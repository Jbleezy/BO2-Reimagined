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

setup_capture_zones()
{
	spawner_capture_zombie = getent("capture_zombie_spawner", "targetname");
	spawner_capture_zombie add_spawn_function(scripts\zm\replaced\zm_tomb_utility::capture_zombie_spawn_init);
	a_s_generator = getstructarray("s_generator", "targetname");
	registerclientfield("world", "packapunch_anim", 14000, 3, "int");
	registerclientfield("actor", "zone_capture_zombie", 14000, 1, "int");
	registerclientfield("scriptmover", "zone_capture_emergence_hole", 14000, 1, "int");
	registerclientfield("world", "zc_change_progress_bar_color", 14000, 1, "int");
	registerclientfield("world", "zone_capture_hud_all_generators_captured", 14000, 1, "int");
	registerclientfield("world", "zone_capture_perk_machine_smoke_fx_always_on", 14000, 1, "int");
	registerclientfield("world", "pap_monolith_ring_shake", 14000, 1, "int");

	foreach (struct in a_s_generator)
	{
		registerclientfield("world", struct.script_noteworthy, 14000, 7, "float");
		registerclientfield("world", "state_" + struct.script_noteworthy, 14000, 3, "int");
		registerclientfield("world", "zone_capture_hud_generator_" + struct.script_int, 14000, 2, "int");
		registerclientfield("world", "zone_capture_monolith_crystal_" + struct.script_int, 14000, 1, "int");
		registerclientfield("world", "zone_capture_perk_machine_smoke_fx_" + struct.script_int, 14000, 1, "int");
	}

	flag_wait("start_zombie_round_logic");
	level.magic_box_zbarrier_state_func = ::set_magic_box_zbarrier_state;
	level.custom_perk_validation = ::check_perk_machine_valid;
	level thread track_max_player_zombie_points();

	foreach (s_generator in a_s_generator)
	{
		s_generator thread init_capture_zone();
	}

	register_elements_powered_by_zone_capture_generators();
	setup_perk_machines_not_controlled_by_zone_capture();
	pack_a_punch_init();
	level thread recapture_round_tracker();
	level.zone_capture.recapture_zombies = [];
	level.zone_capture.last_zone_captured = undefined;
	level.zone_capture.spawn_func_capture_zombie = ::init_capture_zombie;
	level.zone_capture.spawn_func_recapture_zombie = ::init_recapture_zombie;

	maps\mp\zombies\_zm_spawner::register_zombie_death_event_callback(::recapture_zombie_death_func);
	level.custom_derive_damage_refs = ::zone_capture_gib_think;
	setup_inaccessible_zombie_attack_points();
	level thread quick_revive_game_type_watcher();
	level thread quick_revive_solo_leave_watcher();
	level thread all_zones_captured_vo();
	flag_set("capture_zones_init_done");
	level setclientfield("zone_capture_perk_machine_smoke_fx_always_on", 1);
	maps\mp\zm_tomb_capture_zones_ffotd::capture_zone_init_end();
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
				if (!flag("recapture_event_in_progress") || !self ent_flag("current_recapture_target_zone"))
				{
					objective_setplayerusing(self.n_objective_index, player);
				}

				continue;
			}

			if (is_player_valid(player))
			{
				objective_clearplayerusing(self.n_objective_index, player);
			}
		}

		self.n_last_progress = self.n_current_progress;
		self.n_current_progress += self get_progress_rate(a_players_in_capture_zone.size, a_players.size);

		if (self.n_last_progress != self.n_current_progress)
		{
			self.n_current_progress = clamp(self.n_current_progress, 0, 100);
			objective_setprogress(self.n_objective_index, self.n_current_progress / 100);
			self zone_capture_sound_state_think();
			level setclientfield(self.script_noteworthy, self.n_current_progress / 100);
			self generator_set_state();

			if (!flag("recapture_event_in_progress") || !self ent_flag("attacked_by_recapture_zombies"))
			{
				b_set_color_to_white = a_players_in_capture_zone.size > 0;

				if (!flag("recapture_event_in_progress") && self ent_flag("current_recapture_target_zone"))
				{
					b_set_color_to_white = 1;
				}

				level setclientfield("zc_change_progress_bar_color", b_set_color_to_white);
			}

			update_objective_on_momentum_change();

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

handle_generator_capture()
{
	level setclientfield("zc_change_progress_bar_color", 0);
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
				self refund_generator_cost_if_player_captured_it(player);
			}

			player notify("completed_zone_capture");
			player maps\mp\zombies\_zm_score::player_add_points("bonus_points_powerup", 200);

			if (b_challenge_exists)
			{
				player maps\mp\zombies\_zm_challenges::increment_stat("zc_zone_captures");
			}

			player maps\mp\zombies\_zm_stats::increment_client_stat("tomb_generator_captured", 0);
			player maps\mp\zombies\_zm_stats::increment_player_stat("tomb_generator_captured");
		}
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
	s_recapture_target_zone = undefined;
	capture_event_handle_ai_limit();
	recapture_round_audio_starts();

	while (!flag("recapture_zombies_cleared") && get_captured_zone_count() > 0)
	{
		s_recapture_target_zone = get_recapture_zone(s_recapture_target_zone);
		level.zone_capture.recapture_target = s_recapture_target_zone.script_noteworthy;
		s_recapture_target_zone maps\mp\zm_tomb_capture_zones_ffotd::recapture_event_start();

		if (level.b_is_first_generator_attack)
		{
			s_recapture_target_zone thread monitor_recapture_zombies();
		}

		set_recapture_zombie_attack_target(s_recapture_target_zone);
		s_recapture_target_zone thread generator_under_attack_warnings();
		s_recapture_target_zone ent_flag_set("current_recapture_target_zone");
		s_recapture_target_zone thread hide_zone_objective_while_recapture_group_runs_to_next_generator(level.b_is_first_generator_attack);
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

	// if ( s_recapture_target_zone.n_current_progress == 0 || s_recapture_target_zone.n_current_progress == 100 )
	//	s_recapture_target_zone handle_generator_capture();

	capture_event_handle_ai_limit();
	kill_all_recapture_zombies();
	recapture_round_audio_ends();
	flag_clear("recapture_event_in_progress");
	flag_clear("generator_under_attack");
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

setup_perk_machines_not_controlled_by_zone_capture()
{
	level.zone_capture.perk_machines_always_on = array("specialty_additionalprimaryweapon", "specialty_flakjacket", "specialty_grenadepulldeath");
}