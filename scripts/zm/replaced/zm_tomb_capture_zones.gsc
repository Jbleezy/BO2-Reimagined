#include maps\mp\zm_tomb_capture_zones;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_tomb_capture_zones_ffotd;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zombies\_zm_magicbox_tomb;
#include maps\mp\zombies\_zm_powerups;

precache_everything()
{
	precachemodel("p6_zm_tm_zone_capture_hole");
	precachemodel("p6_zm_tm_packapunch");
	precacherumble("generator_active");
	precachestring(&"ZM_TOMB_OBJ_CAPTURE_1");
	precachestring(&"ZM_TOMB_OBJ_CAPTURE_2");
	precachestring(&"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_1");
	precachestring(&"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_2");
	precachestring(&"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_3");
	precachestring(&"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_4");
	precachestring(&"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_5");
	precachestring(&"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_6");
}

declare_objectives()
{
	objective_add(31, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_CAPTURE_1");
	objective_add(30, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_CAPTURE_2");
	objective_add(29, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_1");
	objective_add(28, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_2");
	objective_add(27, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_3");
	objective_add(26, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_4");
	objective_add(25, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_5");
	objective_add(24, "invisible", (0, 0, 0), &"ZM_TOMB_OBJ_RECAPTURE_ZOMBIE_6");
}

init_capture_zone()
{
	assert(isdefined(self.script_noteworthy), "capture zone struct is missing script_noteworthy KVP! This is required for init_capture_zone()");

	if (!isdefined(level.zone_capture))
	{
		level.zone_capture = spawnstruct();
	}

	if (!isdefined(level.zone_capture.zones))
	{
		level.zone_capture.zones = [];
	}

	assert(!isdefined(level.zone_capture.zones[self.script_noteworthy]), "init_capture_zone() attempting to initialize an existing zone with name '" + self.script_noteworthy + "'");
	self.n_current_progress = 0;
	self.n_last_progress = 0;
	self setup_generator_unitrigger();
	self.str_zone = get_zone_from_position(self.origin, 1);
	self.sndent = spawn("script_origin", self.origin);
	assert(isdefined(self.script_int), "script_int KVP is required by init_capture_zone() to identify the objective index, but it's missing on zone '" + self.script_noteworthy + "'");
	self ent_flag_init("attacked_by_recapture_zombies");
	self ent_flag_init("current_recapture_target_zone");
	self ent_flag_init("player_controlled");
	self ent_flag_init("zone_contested");
	self ent_flag_init("zone_initialized");
	level.zone_capture.zones[self.script_noteworthy] = self;
	self set_zombie_controlled_area(1);
	self setup_zombie_attack_points();
	self ent_flag_set("zone_initialized");
	self thread wait_for_capture_trigger();
}

setup_generator_unitrigger()
{
	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = self.origin;
	s_unitrigger_stub.angles = self.angles;
	s_unitrigger_stub.radius = 32;
	s_unitrigger_stub.script_length = 128;
	s_unitrigger_stub.script_width = 128;
	s_unitrigger_stub.script_height = 128;
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.hint_string = &"ZM_TOMB_CAP";
	s_unitrigger_stub.hint_parm1 = [[::get_generator_capture_start_cost]]();
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_unitrigger_stub.require_look_at = 1;
	s_unitrigger_stub.prompt_and_visibility_func = ::generator_trigger_prompt_and_visibility;
	s_unitrigger_stub.generator_struct = self;
	unitrigger_force_per_player_triggers(s_unitrigger_stub, 1);
	maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, ::generator_unitrigger_think);
}

generator_trigger_prompt_and_visibility(e_player)
{
	b_can_see_hint = 1;
	s_zone = self.stub.generator_struct;

	if (s_zone ent_flag("zone_contested") || s_zone ent_flag("player_controlled"))
	{
		b_can_see_hint = 0;
	}

	if (flag("generator_under_attack"))
	{
		self sethintstring(&"ZM_TOMB_ZONE_RECAPTURE_IN_PROGRESS");
	}
	else if (flag("zone_capture_in_progress"))
	{
		self sethintstring(&"ZM_TOMB_ZCIP");
	}
	else
	{
		self sethintstring(&"ZM_TOMB_CAP", get_generator_capture_start_cost());
	}

	self setinvisibletoplayer(e_player, !b_can_see_hint);
	return b_can_see_hint;
}

generator_unitrigger_think()
{
	self endon("kill_trigger");

	while (true)
	{
		self waittill("trigger", e_player);

		if (flag("generator_under_attack"))
		{
			continue;
		}

		if (flag("zone_capture_in_progress"))
		{
			continue;
		}

		if (!is_player_valid(e_player) || e_player is_reviving_any() || e_player != self.parent_player)
		{
			continue;
		}

		if (e_player.score < get_generator_capture_start_cost())
		{
			e_player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_capture");
			continue;
		}

		self setinvisibletoall();
		self.stub.generator_struct notify("start_generator_capture", e_player);
	}
}

register_elements_powered_by_zone_capture_generators()
{
	if (is_classic() || getdvar("ui_zm_mapstartlocation") == "trenches")
	{
		register_random_perk_machine_for_zone("generator_start_bunker", "starting_bunker");
		register_perk_machine_for_zone("generator_start_bunker", "revive", "vending_revive", ::revive_perk_fx_think);
		register_mystery_box_for_zone("generator_start_bunker", "bunker_start_chest");
		register_random_perk_machine_for_zone("generator_tank_trench", "trenches_right");
		register_perk_machine_for_zone("generator_tank_trench", "deadshot", "vending_deadshot");
		register_mystery_box_for_zone("generator_tank_trench", "bunker_tank_chest");
		register_random_perk_machine_for_zone("generator_mid_trench", "trenches_left");
		register_perk_machine_for_zone("generator_mid_trench", "sleight", "vending_sleight");
		register_mystery_box_for_zone("generator_mid_trench", "bunker_cp_chest");
	}

	if (is_classic() || getdvar("ui_zm_mapstartlocation") == "excavation_site")
	{
		register_random_perk_machine_for_zone("generator_nml_right", "nml");
		register_perk_machine_for_zone("generator_nml_right", "juggernog", "vending_jugg");
		register_mystery_box_for_zone("generator_nml_right", "nml_open_chest");
		register_random_perk_machine_for_zone("generator_nml_left", "farmhouse");
		register_perk_machine_for_zone("generator_nml_left", "marathon", "vending_marathon");
		register_mystery_box_for_zone("generator_nml_left", "nml_farm_chest");
	}

	if (is_classic() || getdvar("ui_zm_mapstartlocation") == "church")
	{
		register_random_perk_machine_for_zone("generator_church", "church");
		register_perk_machine_for_zone("generator_church", "doubletap", "vending_doubletap");
		register_mystery_box_for_zone("generator_church", "village_church_chest");
	}
}

enable_mystery_boxes_in_zone()
{
	if (!isdefined(self.mystery_boxes))
	{
		return;
	}

	foreach (mystery_box in self.mystery_boxes)
	{
		mystery_box.is_locked = 0;
		mystery_box.zbarrier set_magic_box_zbarrier_state("player_controlled");
		mystery_box.zbarrier setclientfield("magicbox_runes", 1);
	}
}

disable_mystery_boxes_in_zone()
{
	if (!isdefined(self.mystery_boxes))
	{
		return;
	}

	foreach (mystery_box in self.mystery_boxes)
	{
		mystery_box.is_locked = 1;
		mystery_box.zbarrier set_magic_box_zbarrier_state("zombie_controlled");
		mystery_box.zbarrier setclientfield("magicbox_runes", 0);
	}
}

pack_a_punch_init()
{
	vending_weapon_upgrade_trigger = getentarray("specialty_weapupgrade", "script_noteworthy");
	level.pap_triggers = vending_weapon_upgrade_trigger;
	t_pap = getent("specialty_weapupgrade", "script_noteworthy");

	if (!isdefined(t_pap))
	{
		return;
	}

	t_pap.machine ghost();
	t_pap.machine notsolid();
	t_pap.bump enablelinkto();
	t_pap.bump linkto(t_pap);
	level thread pack_a_punch_think();
}

pack_a_punch_enable()
{
	t_pap = getent("specialty_weapupgrade", "script_noteworthy");
	t_pap trigger_on();
	flag_set("power_on");
	level setclientfield("zone_capture_hud_all_generators_captured", 1);

	if (is_classic() && !flag("generator_lost_to_recapture_zombies"))
	{
		level notify("all_zones_captured_none_lost");
	}
}

setup_perk_machines_not_controlled_by_zone_capture()
{
	level.zone_capture.perk_machines_always_on = array("specialty_additionalprimaryweapon", "specialty_flakjacket", "specialty_grenadepulldeath");
}

check_perk_machine_valid(player)
{
	if (!is_classic())
	{
		return 1;
	}

	if (isdefined(self.script_noteworthy) && isinarray(level.zone_capture.perk_machines_always_on, self.script_noteworthy))
	{
		b_machine_valid = 1;
	}
	else
	{
		assert(isdefined(self.str_zone_name), "str_zone_name field missing on perk machine! This is required by the zone capture system!");
		b_machine_valid = level.zone_capture.zones[self.str_zone_name] ent_flag("player_controlled");
	}

	if (!b_machine_valid)
	{
		player create_and_play_dialog("lockdown", "power_off");
	}

	return b_machine_valid;
}

wait_for_capture_trigger()
{
	while (true)
	{
		self waittill("start_generator_capture", e_player);

		if (!flag("zone_capture_in_progress"))
		{
			flag_set("zone_capture_in_progress");
			self.purchaser = e_player;
			self.generator_cost = get_generator_capture_start_cost();
			e_player minus_to_player_score(self.generator_cost);
			e_player delay_thread(2.5, ::create_and_play_dialog, "zone_capture", "capture_started");
			self maps\mp\zm_tomb_capture_zones_ffotd::capture_event_start();
			self thread monitor_capture_zombies();
			self thread activate_capture_zone();
			self ent_flag_wait("zone_contested");
			capture_event_handle_ai_limit();
			self ent_flag_waitopen("zone_contested");
			self maps\mp\zm_tomb_capture_zones_ffotd::capture_event_end();

			wait 1;

			self.purchaser = undefined;
		}
		else
		{
			flag_wait("zone_capture_in_progress");
			flag_waitopen("zone_capture_in_progress");
		}

		capture_event_handle_ai_limit();

		if (self ent_flag("player_controlled"))
		{
			self ent_flag_waitopen("player_controlled");
		}
	}
}

activate_capture_zone(b_show_emergence_holes = 1)
{
	if (!flag("recapture_event_in_progress"))
	{
		self thread generator_initiated_vo();
	}

	self.a_emergence_hole_structs = getstructarray(self.target, "targetname");
	self show_emergence_holes(b_show_emergence_holes);

	if (flag("recapture_event_in_progress") && self ent_flag("current_recapture_target_zone"))
	{
		flag_wait_any("generator_under_attack", "recapture_zombies_cleared");

		if (flag("recapture_zombies_cleared"))
		{
			return;
		}
	}

	self capture_progress_think();
	self destroy_emergence_holes();
}

capture_progress_think()
{
	self init_capture_progress();
	self clear_zone_objective_index();
	self show_zone_capture_objective(1);
	self get_zone_objective_index();

	while (self ent_flag("zone_contested"))
	{
		a_players = get_players();
		a_players_in_capture_zone = self get_players_in_capture_zone();

		foreach (player in a_players)
		{
			if (isinarray(a_players_in_capture_zone, player))
			{
				objective_setplayerusing(self.n_objective_index, player);

				continue;
			}

			if (is_player_valid(player))
			{
				objective_clearplayerusing(self.n_objective_index, player);
			}
		}

		self.n_last_progress = self.n_current_progress;
		self.n_current_progress += self get_progress_rate(a_players_in_capture_zone.size, a_players.size);

		if (self.n_last_progress != self.n_current_progress || self.n_current_progress == 100)
		{
			self.n_current_progress = clamp(self.n_current_progress, 0, 100);
			objective_setprogress(self.n_objective_index, self.n_current_progress / 100);
			self zone_capture_sound_state_think();
			level setclientfield(self.script_noteworthy, self.n_current_progress / 100);
			self generator_set_state();

			if (self ent_flag("current_recapture_target_zone"))
			{
				level setclientfield("zc_change_progress_bar_color", flag("recapture_event_in_progress"));
			}

			if (self.n_current_progress == 0 || self.n_current_progress == 100 && !self ent_flag("attacked_by_recapture_zombies"))
			{
				self ent_flag_clear("zone_contested");
			}
		}

		show_zone_capture_debug_info();
		wait 0.1;
	}

	self ent_flag_clear("attacked_by_recapture_zombies");
	self handle_generator_capture();
	self clear_all_zombie_attack_points_in_zone();
}

init_capture_progress()
{
	if (!isdefined(level.zone_capture.rate_capture))
	{
		level.zone_capture.rate_capture = get_update_rate(20);
	}

	if (!isdefined(level.zone_capture.rate_capture_solo))
	{
		level.zone_capture.rate_capture_solo = get_update_rate(12);
	}

	if (!isdefined(level.zone_capture.rate_decay))
	{
		level.zone_capture.rate_decay = get_update_rate(40) * -1;
	}

	if (!isdefined(level.zone_capture.rate_recapture))
	{
		level.zone_capture.rate_recapture = get_update_rate(40) * -1;
	}

	if (!isdefined(level.zone_capture.rate_recapture_players))
	{
		level.zone_capture.rate_recapture_players = get_update_rate(10);
	}

	if (!self ent_flag("player_controlled"))
	{
		self.n_current_progress = 0;
		self ent_flag_clear("attacked_by_recapture_zombies");
	}

	self ent_flag_set("zone_contested");
}

get_progress_rate(n_players_in_zone, n_players_total)
{
	if (flag("recapture_event_in_progress") && self ent_flag("current_recapture_target_zone"))
	{
		if (n_players_in_zone > 0)
		{
			n_rate = 0;
		}
		else
		{
			n_rate = level.zone_capture.rate_recapture;
		}
	}
	else if (n_players_in_zone > 0)
	{
		n_rate = level.zone_capture.rate_capture * n_players_in_zone;
	}
	else
	{
		n_rate = level.zone_capture.rate_decay;
	}

	return n_rate;
}

handle_generator_capture()
{
	if (self.n_objective_index == 2)
	{
		level setclientfield("zc_change_progress_bar_color", 1);
	}

	self show_zone_capture_objective(0);

	if (self.n_current_progress == 100)
	{
		self players_capture_zone();
		self kill_all_capture_zombies();
	}
	else if (self.n_current_progress == 0)
	{
		if (self ent_flag("player_controlled"))
		{
			self.sndent stoploopsound(0.25);
			self thread generator_deactivated_vo();
			self.is_playing_audio = 0;

			foreach (player in get_players())
			{
				player maps\mp\zombies\_zm_stats::increment_client_stat("tomb_generator_lost", 0);
				player maps\mp\zombies\_zm_stats::increment_player_stat("tomb_generator_lost");
			}
		}

		self set_zombie_controlled_area();

		if (flag("recapture_event_in_progress") && get_captured_zone_count() > 0)
		{
			if (isdefined(level.s_recapture_target_zone))
			{
				level.s_recapture_target_zone thread hide_zone_objective_while_recapture_group_runs_to_next_generator(0);
			}
		}
		else
		{
			self kill_all_capture_zombies();
		}
	}

	if (get_contested_zone_count() == 0)
	{
		flag_clear("zone_capture_in_progress");
	}
}

players_capture_zone()
{
	self.sndent playsound("zmb_capturezone_success");
	self.sndent stoploopsound(0.25);
	reward_players_in_capture_zone();
	wait_network_frame();

	if (!flag("recapture_event_in_progress") && !self ent_flag("player_controlled"))
	{
		self thread zone_capture_complete_vo();
	}

	self set_player_controlled_area();
	wait_network_frame();
	playfx(level._effect["capture_complete"], self.origin);
	level thread sndplaygeneratormusicstinger();
}

reward_players_in_capture_zone()
{
	b_challenge_exists = maps\mp\zombies\_zm_challenges::challenge_exists("zc_zone_captures");

	if (!self ent_flag("player_controlled"))
	{
		foreach (player in get_players_in_capture_zone())
		{
			if (isdefined(self.purchaser) && self.purchaser == player)
			{
				player add_to_player_score(self.generator_cost * 2);
			}

			player notify("completed_zone_capture");

			if (b_challenge_exists)
			{
				player maps\mp\zombies\_zm_challenges::increment_stat("zc_zone_captures");
			}

			player maps\mp\zombies\_zm_stats::increment_client_stat("tomb_generator_captured", 0);
			player maps\mp\zombies\_zm_stats::increment_player_stat("tomb_generator_captured");
		}
	}
}

all_zones_captured_vo()
{
	if (!is_classic())
	{
		return;
	}

	flag_wait("all_zones_captured");
	flag_waitopen("story_vo_playing");
	set_players_dontspeak(1);
	flag_set("story_vo_playing");
	e_speaker = get_closest_player_to_richtofen();

	if (isdefined(e_speaker))
	{
		e_speaker set_player_dontspeak(0);
		e_speaker create_and_play_dialog("zone_capture", "all_generators_captured");
		e_speaker waittill_any("done_speaking", "disconnect");
	}

	e_richtofen = get_player_named("Richtofen");

	if (isdefined(e_richtofen))
	{
		e_richtofen set_player_dontspeak(0);
		e_richtofen create_and_play_dialog("zone_capture", "all_generators_captured");
	}

	set_players_dontspeak(0);
	flag_clear("story_vo_playing");
}

init_recapture_zombie(zone_struct, s_spawn_point)
{
	self endon("death");
	self.is_recapture_zombie = 1;
	self init_zone_capture_zombie_common(s_spawn_point);
	self.goalradius = 30;
	self.zombie_move_speed = "sprint";
	self.s_attack_generator = zone_struct;
	self.attacking_new_generator = 1;
	self.attacking_point = undefined;
	self thread recapture_zombie_poi_think();

	self.obj_ind = level.current_recapture_zombie_obj_ind;
	level.current_recapture_zombie_obj_ind--;

	self recapture_zombie_icon_show();

	while (true)
	{
		self.is_attacking_zone = 0;

		if (self.zombie_has_point_of_interest)
		{
			v_attack_origin = self.point_of_interest;
		}
		else
		{
			if (self.attacking_new_generator || !isdefined(self.attacking_point))
			{
				if (isdefined(self.attacking_point))
				{
					self.attacking_point unclaim_attacking_point();
				}

				self.attacking_point = self get_unclaimed_attack_point(self.s_attack_generator);
			}

			v_attack_origin = self.attacking_point.origin;
		}

		self setgoalpos(v_attack_origin);
		self waittill_either("goal", "poi_state_changed");

		if (!self.zombie_has_point_of_interest)
		{
			if (distance(self.attacking_point.origin, self.origin) > 50)
			{
				continue;
			}

			self.is_attacking_zone = 1;

			if (!isdefined(level.zone_capture.recapture_target) && !isdefined(self.s_attack_generator.script_noteworthy) || isdefined(level.zone_capture.recapture_target) && isdefined(self.s_attack_generator.script_noteworthy) && level.zone_capture.recapture_target == self.s_attack_generator.script_noteworthy)
			{
				flag_set("generator_under_attack");
				self.s_attack_generator ent_flag_set("attacked_by_recapture_zombies");
				self.attacking_new_generator = 0;
				zone_struct notify("zombies_attacking_generator");
			}
		}
		else if (isdefined(self.attacking_point))
		{
			self.attacking_point unclaim_attacking_point();
		}

		self play_melee_attack_animation();
	}
}

recapture_zombie_death_func()
{
	if (isdefined(self.is_recapture_zombie) && self.is_recapture_zombie)
	{
		level.recapture_zombies_killed++;

		if (isdefined(self.attacker) && isplayer(self.attacker) && level.recapture_zombies_killed == get_recapture_zombies_needed())
		{
			self.attacker thread delay_thread(2, ::create_and_play_dialog, "zone_capture", "recapture_prevented");

			foreach (player in get_players())
			{
				player maps\mp\zombies\_zm_stats::increment_client_stat("tomb_generator_defended", 0);
				player maps\mp\zombies\_zm_stats::increment_player_stat("tomb_generator_defended");
			}
		}

		if (level.recapture_zombies_killed == get_recapture_zombies_needed() && is_true(level.b_is_first_generator_attack))
		{
			self drop_max_ammo_at_death_location();
		}
	}
}

recapture_round_tracker()
{
	if (!is_classic())
	{
		return;
	}

	n_next_recapture_round = 10;

	while (true)
	{
		level waittill_any("between_round_over", "force_recapture_start");

		if (level.round_number >= n_next_recapture_round && !flag("zone_capture_in_progress") && get_captured_zone_count() >= get_player_controlled_zone_count_for_recapture())
		{
			n_next_recapture_round = level.round_number + randomintrange(3, 6);
			level thread recapture_round_start();
		}
	}
}

recapture_round_start()
{
	flag_set("recapture_event_in_progress");
	flag_clear("recapture_zombies_cleared");
	flag_clear("generator_under_attack");
	level.recapture_zombies_killed = 0;
	level.b_is_first_generator_attack = 1;
	level.current_recapture_zombie_obj_ind = 29;
	s_recapture_target_zone = undefined;
	capture_event_handle_ai_limit();
	recapture_round_audio_starts();

	level setclientfield("zc_change_progress_bar_color", 1);

	while (!flag("recapture_zombies_cleared") && get_captured_zone_count() > 0)
	{
		level.s_recapture_target_zone = get_recapture_zone(s_recapture_target_zone);
		s_recapture_target_zone = level.s_recapture_target_zone;
		level.zone_capture.recapture_target = s_recapture_target_zone.script_noteworthy;
		s_recapture_target_zone maps\mp\zm_tomb_capture_zones_ffotd::recapture_event_start();

		if (level.b_is_first_generator_attack)
		{
			s_recapture_target_zone thread monitor_recapture_zombies();
		}

		set_recapture_zombie_attack_target(s_recapture_target_zone);
		s_recapture_target_zone thread generator_under_attack_warnings();
		s_recapture_target_zone ent_flag_set("current_recapture_target_zone");
		s_recapture_target_zone activate_capture_zone(level.b_is_first_generator_attack);
		s_recapture_target_zone ent_flag_clear("attacked_by_recapture_zombies");
		s_recapture_target_zone ent_flag_clear("current_recapture_target_zone");

		if (level.b_is_first_generator_attack && !s_recapture_target_zone ent_flag("player_controlled"))
		{
			delay_thread(3, ::broadcast_vo_category_to_team, "recapture_started");
		}

		level.b_is_first_generator_attack = 0;
		s_recapture_target_zone maps\mp\zm_tomb_capture_zones_ffotd::recapture_event_end();
		wait 0.05;
	}

	capture_event_handle_ai_limit();
	kill_all_recapture_zombies();
	recapture_round_audio_ends();
	flag_clear("recapture_event_in_progress");
	flag_clear("generator_under_attack");
}

hide_zone_objective_while_recapture_group_runs_to_next_generator(b_hide_icon)
{
	self clear_zone_objective_index();
	flag_clear("generator_under_attack");

	if (!b_hide_icon)
	{
		recapture_zombie_group_icon_show();
	}

	do
	{
		wait 1;
	}
	while (!flag("recapture_zombies_cleared") && self get_recapture_attacker_count() == 0);

	if (!flag("recapture_zombies_cleared"))
	{
		self thread generator_compromised_vo();
	}
}

recapture_zombie_group_icon_show()
{
	level endon("recapture_zombies_cleared");

	if (isdefined(level.zone_capture.recapture_zombies) && flag("recapture_event_in_progress"))
	{
		while (!level.zone_capture.recapture_zombies.size)
		{
			wait_network_frame();
			level.zone_capture.recapture_zombies = array_removedead(level.zone_capture.recapture_zombies);
		}

		flag_waitopen("generator_under_attack");

		for (i = 0; i < level.zone_capture.recapture_zombies.size; i++)
		{
			level.zone_capture.recapture_zombies[i] recapture_zombie_icon_show();
		}
	}
}

recapture_zombie_icon_show()
{
	objective_state(self.obj_ind, "active");
	objective_onentity(self.obj_ind, self);
	self thread recapture_zombie_icon_think();
}

recapture_zombie_icon_think()
{
	while (isalive(self) && self.is_attacking_zone)
	{
		self waittill_any_or_timeout(0.05, "goal", "poi_state_changed", "death");
	}

	while (isalive(self) && !self.is_attacking_zone)
	{
		self waittill_any_or_timeout(0.05, "goal", "poi_state_changed", "death");
	}

	self recapture_zombie_icon_hide();
}

recapture_zombie_icon_hide()
{
	objective_state(self.obj_ind, "invisible");
	objective_clearentity(self.obj_ind);
}

get_zone_objective_index()
{
	if (!isdefined(self.n_objective_index))
	{
		if (self ent_flag("current_recapture_target_zone"))
		{
			n_objective = 30;
		}
		else
		{
			n_objective = 31;
		}

		self.n_objective_index = n_objective;
	}

	return self.n_objective_index;
}

get_generator_capture_start_cost()
{
	return 500;
}

magic_box_stub_update_prompt(player)
{
	self setcursorhint("HINT_NOICON");

	if (!self trigger_visible_to_player(player))
	{
		return false;
	}

	self.stub.hint_parm1 = undefined;

	if (isdefined(self.stub.trigger_target.grab_weapon_hint) && self.stub.trigger_target.grab_weapon_hint)
	{
		self.stub.hint_string = &"ZOMBIE_TRADE_WEAPON";
	}
	else if (!level.zone_capture.zones[self.stub.zone] ent_flag("player_controlled"))
	{
		self.stub.hint_string = &"ZM_TOMB_ZC";
		return false;
	}
	else
	{
		self.stub.hint_parm1 = self.stub.trigger_target.zombie_cost;
		self.stub.hint_string = get_hint_string(self, "default_treasure_chest");
	}

	return true;
}