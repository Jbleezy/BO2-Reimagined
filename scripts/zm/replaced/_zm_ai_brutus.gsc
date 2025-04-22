#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;

init()
{
	level.brutus_spawners = getentarray("brutus_zombie_spawner", "script_noteworthy");

	if (level.brutus_spawners.size == 0)
	{
		return;
	}

	array_thread(level.brutus_spawners, ::add_spawn_function, ::brutus_prespawn);

	for (i = 0; i < level.brutus_spawners.size; i++)
	{
		level.brutus_spawners[i].is_enabled = 1;
		level.brutus_spawners[i].script_forcespawn = 1;
	}

	level.brutus_spawn_positions = getstructarray("brutus_location", "script_noteworthy");
	level thread setup_interaction_matrix();
	level.sndbrutusistalking = 0;
	level.brutus_health = 500;
	level.brutus_health_increase = 1000;
	level.brutus_round_count = 0;
	level.brutus_last_spawn_round = 0;
	level.brutus_count = 0;
	level.brutus_max_count = 1;
	level.brutus_damage_percent = 0.1;
	level.brutus_helmet_shots = 5;
	level.brutus_team_points_for_death = 500;
	level.brutus_player_points_for_death = 250;
	level.brutus_points_for_helmet = 250;
	level.brutus_alarm_chance = 100;
	level.brutus_min_alarm_chance = 100;
	level.brutus_alarm_chance_increment = 10;
	level.brutus_max_alarm_chance = 200;
	level.brutus_min_round_fq = 4;
	level.brutus_max_round_fq = 7;
	level.brutus_reset_dist_sq = 262144;
	level.brutus_aggro_dist_sq = 16384;
	level.brutus_aggro_earlyout = 12;
	level.brutus_blocker_pieces_req = 1;
	level.brutus_zombie_per_round = 1;
	level.brutus_players_in_zone_spawn_point_cap = 120;
	level.brutus_teargas_duration = 7;
	level.player_teargas_duration = 2;
	level.brutus_teargas_radius = 64;
	level.num_pulls_since_brutus_spawn = 0;
	level.brutus_min_pulls_between_box_spawns = 4;
	level.brutus_explosive_damage_for_helmet_pop = 1500;
	level.brutus_explosive_damage_increase = 600;
	level.brutus_failed_paths_to_teleport = 15;
	level.brutus_do_prologue = 1;
	level.brutus_min_spawn_delay = 10.0;
	level.brutus_max_spawn_delay = 60.0;
	level.brutus_respawn_after_despawn = 1;
	level.brutus_in_grief = 0;

	if (getdvar("ui_gametype") == "zstandard" || getdvar("ui_gametype") == "zgrief")
	{
		level.brutus_in_grief = 1;
	}

	level.brutus_shotgun_damage_mod = 1.5;
	level.brutus_custom_goalradius = 48;
	registerclientfield("actor", "helmet_off", 9000, 1, "int");
	registerclientfield("actor", "brutus_lock_down", 9000, 1, "int");
	level thread brutus_spawning_logic();

	if (!level.brutus_in_grief)
	{
		level thread maps\mp\zombies\_zm_ai_brutus::get_brutus_interest_points();

		level.custom_perk_validation = maps\mp\zombies\_zm_ai_brutus::check_perk_machine_valid;
		level.custom_craftable_validation = ::check_craftable_table_valid;
		level.custom_plane_validation = maps\mp\zombies\_zm_ai_brutus::check_plane_valid;
	}
}

setup_interaction_matrix()
{
	level.interaction_types = [];

	level.interaction_types["magic_box"] = spawnstruct();
	level.interaction_types["magic_box"].priority = 0;
	level.interaction_types["magic_box"].animstate = "zm_lock_magicbox";
	level.interaction_types["magic_box"].notify_name = "box_lock_anim";
	level.interaction_types["magic_box"].action_notetrack = "locked";
	level.interaction_types["magic_box"].end_notetrack = "lock_done";
	level.interaction_types["magic_box"].validity_func = ::is_magic_box_valid;
	level.interaction_types["magic_box"].get_func = ::get_magic_boxes;
	level.interaction_types["magic_box"].value_func = ::get_dist_score;
	level.interaction_types["magic_box"].interact_func = ::magic_box_lock;
	level.interaction_types["magic_box"].spawn_bias = 1000;
	level.interaction_types["magic_box"].num_times_to_scale = 1;
	level.interaction_types["magic_box"].unlock_cost = 2000;

	level.interaction_types["perk_machine"] = spawnstruct();
	level.interaction_types["perk_machine"].priority = 1;
	level.interaction_types["perk_machine"].animstate = "zm_lock_perk_machine";
	level.interaction_types["perk_machine"].notify_name = "perk_lock_anim";
	level.interaction_types["perk_machine"].action_notetrack = "locked";
	level.interaction_types["perk_machine"].validity_func = ::is_perk_machine_valid;
	level.interaction_types["perk_machine"].get_func = ::get_perk_machines;
	level.interaction_types["perk_machine"].value_func = ::get_dist_score;
	level.interaction_types["perk_machine"].interact_func = ::perk_machine_lock;
	level.interaction_types["perk_machine"].spawn_bias = 800;
	level.interaction_types["perk_machine"].num_times_to_scale = 3;
	level.interaction_types["perk_machine"].unlock_cost = 2000;

	if (!is_gametype_active("zgrief"))
	{
		level.interaction_types["blocker"] = spawnstruct();
		level.interaction_types["blocker"].priority = 5;
		level.interaction_types["blocker"].animstate = "zm_smash_blocker";
		level.interaction_types["blocker"].notify_name = "board_smash_anim";
		level.interaction_types["blocker"].action_notetrack = "fire";
		level.interaction_types["blocker"].validity_func = ::is_blocker_valid;
		level.interaction_types["blocker"].get_func = ::get_blockers;
		level.interaction_types["blocker"].value_func = ::get_dist_score;
		level.interaction_types["blocker"].interact_func = ::blocker_smash;
		level.interaction_types["blocker"].spawn_bias = 50;

		level.interaction_types["trap"] = spawnstruct();
		level.interaction_types["trap"].priority = 3;
		level.interaction_types["trap"].animstate = "zm_smash_trap";
		level.interaction_types["trap"].notify_name = "trap_smash_anim";
		level.interaction_types["trap"].action_notetrack = "fire";
		level.interaction_types["trap"].validity_func = ::is_trap_valid;
		level.interaction_types["trap"].get_func = ::get_traps;
		level.interaction_types["trap"].value_func = ::get_dist_score;
		level.interaction_types["trap"].interact_func = ::trap_smash;
		level.interaction_types["trap"].spawn_bias = 400;
		level.interaction_types["trap"].interaction_z_offset = -15;

		level.interaction_types["craftable_table"] = spawnstruct();
		level.interaction_types["craftable_table"].priority = 2;
		level.interaction_types["craftable_table"].animstate = "zm_smash_craftable_table";
		level.interaction_types["craftable_table"].notify_name = "table_smash_anim";
		level.interaction_types["craftable_table"].action_notetrack = "fire";
		level.interaction_types["craftable_table"].validity_func = ::is_craftable_table_valid;
		level.interaction_types["craftable_table"].get_func = ::get_craftable_tables;
		level.interaction_types["craftable_table"].value_func = ::get_dist_score;
		level.interaction_types["craftable_table"].interact_func = ::craftable_table_lock;
		level.interaction_types["craftable_table"].spawn_bias = 600;
		level.interaction_types["craftable_table"].num_times_to_scale = 1;
		level.interaction_types["craftable_table"].unlock_cost = 2000;
		level.interaction_types["craftable_table"].interaction_z_offset = -15;
		level.interaction_types["craftable_table"].interaction_yaw_offset = 270;
		level.interaction_types["craftable_table"].fx_z_offset = -44;
		level.interaction_types["craftable_table"].fx_yaw_offset = 270;

		level.interaction_types["plane_ramp"] = spawnstruct();
		level.interaction_types["plane_ramp"].priority = 4;
		level.interaction_types["plane_ramp"].animstate = "zm_lock_plane_ramp";
		level.interaction_types["plane_ramp"].notify_name = "plane_lock_anim";
		level.interaction_types["plane_ramp"].action_notetrack = "locked";
		level.interaction_types["plane_ramp"].end_notetrack = "lock_done";
		level.interaction_types["plane_ramp"].validity_func = ::is_plane_ramp_valid;
		level.interaction_types["plane_ramp"].get_func = ::get_plane_ramps;
		level.interaction_types["plane_ramp"].value_func = ::get_dist_score;
		level.interaction_types["plane_ramp"].interact_func = ::plane_ramp_lock;
		level.interaction_types["plane_ramp"].spawn_bias = 500;
		level.interaction_types["plane_ramp"].num_times_to_scale = 3;
		level.interaction_types["plane_ramp"].unlock_cost = 2000;
		level.interaction_types["plane_ramp"].interaction_z_offset = -60;
		level.interaction_types["plane_ramp"].fx_z_offset = -60;
		level.interaction_types["plane_ramp"].fx_x_offset = 70;
		level.interaction_types["plane_ramp"].fx_yaw_offset = 90;
	}

	level.interaction_priority = [];
	interaction_types = getarraykeys(level.interaction_types);

	for (i = 0; i < interaction_types.size; i++)
	{
		int_type = interaction_types[i];
		interaction = level.interaction_types[int_type];
		assert(!isdefined(level.interaction_priority[interaction.priority]));
		level.interaction_priority[interaction.priority] = int_type;
	}
}

check_craftable_table_valid(player)
{
	if (!isdefined(self.stub) && (isdefined(self.is_locked) && self.is_locked))
	{
		if (player.score >= self.locked_cost)
		{
			player minus_to_player_score(self.locked_cost);
			self.is_locked = 0;
			self.locked_cost = undefined;
			self.lock_fx delete();
		}

		return false;
	}
	else if (isdefined(self.stub) && (isdefined(self.stub.is_locked) && self.stub.is_locked))
	{
		if (player.score >= self.stub.locked_cost)
		{
			player minus_to_player_score(self.stub.locked_cost);
			self.stub.is_locked = 0;
			self.stub.locked_cost = undefined;
			self.stub.lock_fx delete();
			self scripts\zm\zm_prison\zm_prison_reimagined::craftabletrigger_update_prompt(player);
		}

		return false;
	}

	return true;
}

brutus_spawning_logic()
{
	level thread enable_brutus_rounds();

	if (isdefined(level.chests))
	{
		for (i = 0; i < level.chests.size; i++)
		{
			level.chests[i] thread wait_on_box_alarm();
		}
	}

	while (true)
	{
		level waittill("spawn_brutus", num);

		for (i = 0; i < num; i++)
		{
			ai = spawn_zombie(level.brutus_spawners[0]);
			ai thread brutus_spawn();
		}

		if (isdefined(ai))
		{
			ai playsound("zmb_ai_brutus_spawn_2d");
		}
	}
}

brutus_round_tracker()
{
	level.next_brutus_round = level.round_number + randomintrange(level.brutus_min_round_fq, level.brutus_max_round_fq);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;

	if (is_classic())
	{
		flag_wait_any("activate_cellblock_east", "activate_cellblock_west");
	}

	while (true)
	{
		level waittill("between_round_over");

		players = get_players();

		if (level.round_number < 9)
		{
			continue;
		}
		else if (level.next_brutus_round <= level.round_number)
		{
			if (maps\mp\zm_alcatraz_utility::is_team_on_golden_gate_bridge())
			{
				level.next_brutus_round = level.round_number + 1;
				continue;
			}

			wait(randomfloatrange(level.brutus_min_spawn_delay, level.brutus_max_spawn_delay));

			if (attempt_brutus_spawn(level.brutus_zombie_per_round))
			{
				level.music_round_override = 1;
				level thread maps\mp\zombies\_zm_audio::change_zombie_music("brutus_round_start");
				level thread sndforcewait();
				level.next_brutus_round = level.round_number + randomintrange(level.brutus_min_round_fq, level.brutus_max_round_fq);
			}
		}
	}
}

craftable_table_lock()
{
	self endon("death");
	table_struct = self.priority_item;

	if (!isdefined(table_struct))
	{
		return;
	}

	craftable_table = table_struct get_trigger_for_craftable();
	int_struct = level.interaction_types["craftable_table"];
	craftable_table.lock_fx = spawn("script_model", table_struct.origin);
	craftable_table.lock_fx.angles = table_struct.angles;
	craftable_table.lock_fx = offset_fx_struct(int_struct, craftable_table.lock_fx);
	craftable_table.lock_fx setmodel("tag_origin");
	playfxontag(level._effect["brutus_lockdown_lg"], craftable_table.lock_fx, "tag_origin");
	craftable_table.lock_fx playsound("zmb_ai_brutus_clang");
	craftable_table.is_locked = 1;
	craftable_table.locked_cost = get_scaling_lock_cost("craftable_table", craftable_table);
	craftable_table.hint_string = get_lock_hint_string(craftable_table.locked_cost);

	if (!isdefined(craftable_table.equipname))
	{
		craftable_table sethintstring(craftable_table.hint_string);
	}

	if (isdefined(craftable_table.targetname) && craftable_table.targetname == "blundergat_upgrade")
	{
		level.lockdown_track["craft_kit"] = 1;

		t_upgrade = getent("blundergat_upgrade", "targetname");
		t_upgrade.is_locked = 1;
		t_upgrade sethintstring(craftable_table.hint_string);
	}

	if (isdefined(craftable_table.weaponname) && craftable_table.weaponname == "alcatraz_shield_zm")
	{
		level.lockdown_track["craft_shield"] = 1;
	}

	level notify("brutus_locked_object");
	self.priority_item = undefined;
}

brutus_find_flesh()
{
	self endon("death");
	level endon("intermission");

	if (level.intermission)
	{
		return;
	}

	self.ai_state = "idle";
	self.helitarget = 1;
	self.ignoreme = 0;
	self.nododgemove = 1;
	self.ignore_player = [];
	self thread brutus_watch_for_gondola();
	self thread brutus_stuck_watcher();
	self thread brutus_goal_watcher();
	self thread watch_for_player_dist();

	while (true)
	{
		if (self.not_interruptable)
		{
			wait 0.05;
			continue;
		}

		player = brutus_get_closest_valid_player();
		brutus_zone = get_zone_from_position(self.origin);

		if (!isdefined(brutus_zone))
		{
			brutus_zone = self.prev_zone;

			if (!isdefined(brutus_zone))
			{
				wait 1;
				continue;
			}
		}

		player_zone = undefined;
		self.prev_zone = brutus_zone;

		if (level.brutus_in_grief)
		{
			brutus_start_basic_find_flesh();
		}
		else if (!isdefined(player))
		{
			self.priority_item = self get_priority_item_for_brutus(brutus_zone, 1);
		}
		else
		{
			player_zone = player get_player_zone();

			if (isdefined(player_zone))
			{
				self.priority_item = self get_priority_item_for_brutus(player_zone);
			}
			else
			{
				self.priority_item = self get_priority_item_for_brutus(brutus_zone, 1);
			}
		}

		if (isdefined(player) && distancesquared(self.origin, player.origin) < level.brutus_aggro_dist_sq && isdefined(player_zone) && should_brutus_aggro(player_zone, brutus_zone))
		{
			self.favorite_enemy = player;
			self.goal_pos = player.origin;
			brutus_start_basic_find_flesh();
		}
		else if (isdefined(self.priority_item))
		{
			brutus_stop_basic_find_flesh();
			self.goalradius = 12;
			self.custom_goalradius_override = 12;
			self.goal_pos = self get_interact_offset(self.priority_item, self.ai_state);
			self setgoalpos(self.goal_pos);
		}
		else if (isdefined(player))
		{
			self.favorite_enemy = player;
			self.goal_pos = self.favorite_enemy.origin;
			brutus_start_basic_find_flesh();
		}
		else
		{
			self.goal_pos = self.origin;
			self.ai_state = "idle";
			self setanimstatefromasd("zm_idle");
			self setgoalpos(self.goal_pos);
		}

		wait 1;
	}
}

get_brutus_spawn_pos_val(brutus_pos)
{
	score = 0;
	zone_name = brutus_pos.zone_name;

	if (!maps\mp\zombies\_zm_zonemgr::zone_is_enabled(zone_name))
	{
		return 0;
	}

	a_players_in_zone = get_players_in_zone(zone_name, 1);

	if (a_players_in_zone.size == 0)
	{
		return 0;
	}
	else
	{
		n_score_addition = 1;

		for (i = 0; i < a_players_in_zone.size; i++)
		{
			if (findpath(brutus_pos.origin, a_players_in_zone[i].origin, self, 0, 0))
			{
				n_dist = distance2d(brutus_pos.origin, a_players_in_zone[i].origin);
				n_score_addition += linear_map(n_dist, 2000, 0, 0, level.brutus_players_in_zone_spawn_point_cap);
			}
		}

		if (n_score_addition > level.brutus_players_in_zone_spawn_point_cap)
		{
			n_score_addition = level.brutus_players_in_zone_spawn_point_cap;
		}

		score += n_score_addition;
	}

	if (!level.brutus_in_grief)
	{
		interaction_types = getarraykeys(level.interaction_types);
		interact_array = level.interaction_types;

		for (i = 0; i < interaction_types.size; i++)
		{
			int_type = interaction_types[i];
			interaction = interact_array[int_type];
			interact_points = [[interaction.get_func]](zone_name);

			for (j = 0; j < interact_points.size; j++)
			{
				if (interact_points[j][[interaction.validity_func]]())
				{
					score += interaction.spawn_bias;
				}
			}
		}
	}

	return score;
}

brutus_spawn(starting_health, has_helmet, helmet_hits, explosive_dmg_taken, zone_name)
{
	level.num_pulls_since_brutus_spawn = 0;
	self set_zombie_run_cycle("run");

	if (!isDefined(has_helmet))
	{
		self.has_helmet = 1;
	}
	else
	{
		self.has_helmet = has_helmet;
	}

	if (!isDefined(helmet_hits))
	{
		self.helmet_hits = 0;
	}
	else
	{
		self.helmet_hits = helmet_hits;
	}

	if (!isDefined(explosive_dmg_taken))
	{
		self.explosive_dmg_taken = 0;
	}
	else
	{
		self.explosive_dmg_taken = explosive_dmg_taken;
	}

	if (!isDefined(starting_health))
	{
		self brutus_health_increases();
		self.maxhealth = level.brutus_health;
		self.health = level.brutus_health;
	}
	else
	{
		self.maxhealth = starting_health;
		self.health = starting_health;
	}

	self.explosive_dmg_req = level.brutus_expl_dmg_req;
	self.no_damage_points = 1;
	self endon("death");
	level endon("intermission");
	self.animname = "brutus_zombie";
	self.audio_type = "brutus";
	self.has_legs = 1;
	self.ignore_all_poi = 1;
	self.is_brutus = 1;
	self.ignore_enemy_count = 1;
	self.instakill_func = ::brutus_instakill_override;
	self.nuke_damage_func = ::brutus_nuke_override;
	self.melee_anim_func = ::melee_anim_func;
	self.meleedamage = 100;
	self.custom_item_dmg = 1000;
	self.brutus_lockdown_state = 0;
	recalc_zombie_array();
	self setphysparams(20, 0, 60);
	self.zombie_init_done = 1;
	self notify("zombie_init_done");
	self.allowpain = 0;
	self animmode("normal");
	self orientmode("face enemy");
	self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();
	self setfreecameralockonallowed(0);
	level thread maps\mp\zombies\_zm_spawner::zombie_death_event(self);
	self thread maps\mp\zombies\_zm_spawner::enemy_death_detection();

	if (isDefined(zone_name) && zone_name == "zone_golden_gate_bridge")
	{
		wait randomfloat(1.5);
		spawn_pos = get_random_brutus_spawn_pos(zone_name);
	}
	else
	{
		spawn_pos = get_best_brutus_spawn_pos(zone_name);
	}

	if (!isDefined(spawn_pos))
	{
		self delete();
		return;
	}

	if (!isDefined(spawn_pos.angles))
	{
		spawn_pos.angles = (0, 0, 0);
	}

	if (isDefined(level.brutus_do_prologue) && level.brutus_do_prologue)
	{
		self brutus_spawn_prologue(spawn_pos);
	}

	if (!self.has_helmet)
	{
		self detach("c_zom_cellbreaker_helmet");
	}

	level.brutus_count++;
	self maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area();
	self thread snddelayedmusic();
	self thread brutus_death();
	self thread brutus_check_zone();
	self thread brutus_watch_enemy();
	self forceteleport(spawn_pos.origin, spawn_pos.angles);
	self.cant_melee = 1;
	self.not_interruptable = 1;
	self.actor_damage_func = ::brutus_damage_override;
	self.non_attacker_func = ::brutus_non_attacker_damage_override;
	self thread brutus_lockdown_client_effects(0.5);
	playfx(level._effect["brutus_spawn"], self.origin);
	playsoundatposition("zmb_ai_brutus_spawn", self.origin);
	self animscripted(spawn_pos.origin, spawn_pos.angles, "zm_spawn");
	self thread maps\mp\animscripts\zm_shared::donotetracks("spawn_anim");
	self waittillmatch("spawn_anim");
	self.not_interruptable = 0;
	self.cant_melee = 0;
	self thread brutus_chest_flashlight();
	self thread brutus_find_flesh();
	self thread maps\mp\zombies\_zm_spawner::delayed_zombie_eye_glow();
	level notify("brutus_spawned", self, "spawn_complete");
	logline1 = "INFO: _zm_ai_brutus.gsc brutus_spawn() completed its operation " + "\n";
	logprint(logline1);
}

brutus_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, poffsettime, boneindex)
{
	if (isDefined(attacker) && isalive(attacker) && isplayer(attacker) && level.zombie_vars[attacker.team]["zombie_insta_kill"] || isDefined(attacker.personal_instakill) && attacker.personal_instakill)
	{
		n_brutus_damage_percent = 1;
		n_brutus_headshot_modifier = 2;
	}
	else
	{
		n_brutus_damage_percent = level.brutus_damage_percent;
		n_brutus_headshot_modifier = 1;
	}

	if (isDefined(weapon) && is_weapon_shotgun(weapon))
	{
		n_brutus_damage_percent *= level.brutus_shotgun_damage_mod;
		n_brutus_headshot_modifier *= level.brutus_shotgun_damage_mod;
	}

	if (isDefined(weapon) && weapon == "bouncing_tomahawk_zm" && isDefined(inflictor))
	{
		self playsound("wpn_tomahawk_imp_zombie");

		if (self.has_helmet)
		{
			if (damage == 1)
			{
				return 0;
			}

			if (isDefined(inflictor.n_cookedtime) && inflictor.n_cookedtime >= 2000)
			{
				self.helmet_hits = level.brutus_helmet_shots;
			}
			else if (isDefined(inflictor.n_grenade_charge_power) && inflictor.n_grenade_charge_power >= 2)
			{
				self.helmet_hits = level.brutus_helmet_shots;
			}
			else
			{
				self.helmet_hits++;
			}

			if (self.helmet_hits >= level.brutus_helmet_shots)
			{
				self thread brutus_remove_helmet(vdir);

				if (level.brutus_in_grief && getdvar("ui_gametype") == "zgrief")
				{
					player_points = level.brutus_points_for_helmet;
				}
				else
				{
					multiplier = maps\mp\zombies\_zm_score::get_points_multiplier(self);
					player_points = multiplier * round_up_score(level.brutus_points_for_helmet, 5);
				}

				if (isDefined(attacker) && isplayer(attacker))
				{
					attacker add_to_player_score(player_points);
					attacker.pers["score"] = attacker.score;
					level notify("brutus_helmet_removed", attacker);
				}
			}

			return damage * n_brutus_damage_percent;
		}
		else
		{
			return damage;
		}
	}

	if ((meansofdeath == "MOD_MELEE" || meansofdeath == "MOD_IMPACT") && isDefined(meansofdeath))
	{
		if (weapon == "alcatraz_shield_zm")
		{
			shield_damage = level.zombie_vars["riotshield_fling_damage_shield"];
			inflictor maps\mp\zombies\_zm_weap_riotshield_prison::player_damage_shield(shield_damage, 0);
			return 0;
		}
	}

	if (isDefined(level.zombiemode_using_afterlife) && level.zombiemode_using_afterlife && weapon == "lightning_hands_zm")
	{
		self thread brutus_afterlife_teleport();
		return 0;
	}

	if (weapon == "willy_pete_zm")
	{
		return 0;
	}

	if (is_explosive_damage(meansofdeath) && weapon != "raygun_mark2_zm" && weapon != "raygun_mark2_upgraded_zm")
	{
		self.explosive_dmg_taken += damage;

		if (!self.has_helmet)
		{
			scaler = n_brutus_headshot_modifier;
		}
		else
		{
			scaler = level.brutus_damage_percent;
		}

		if (self.explosive_dmg_taken >= self.explosive_dmg_req && isDefined(self.has_helmet) && self.has_helmet)
		{
			self thread brutus_remove_helmet(vectorScale((0, 1, 0), 10));

			if (level.brutus_in_grief && getdvar("ui_gametype") == "zgrief")
			{
				player_points = level.brutus_points_for_helmet;
			}
			else
			{
				multiplier = maps\mp\zombies\_zm_score::get_points_multiplier(self);
				player_points = multiplier * round_up_score(level.brutus_points_for_helmet, 5);
			}

			attacker add_to_player_score(player_points);
			attacker.pers["score"] = inflictor.score;
		}

		return damage * scaler;
	}
	else if (shitloc != "head" && shitloc != "helmet")
	{
		return damage * n_brutus_damage_percent;
	}
	else
	{
		return int(self scale_helmet_damage(attacker, damage, n_brutus_headshot_modifier, n_brutus_damage_percent, vdir));
	}
}

brutus_health_increases()
{
	if (level.scr_zm_ui_gametype == "zgrief")
	{
		return;
	}

	if (level.round_number > level.brutus_last_spawn_round)
	{
		players = getplayers();
		n_player_modifier = 1;

		if (players.size > 1)
		{
			n_player_modifier = players.size * 0.75;
		}

		level.brutus_round_count++;
		level.brutus_health = int(level.brutus_health_increase * n_player_modifier * level.brutus_round_count);
		level.brutus_expl_dmg_req = int(level.brutus_explosive_damage_increase * n_player_modifier * level.brutus_round_count);

		if (level.brutus_health >= (5000 * n_player_modifier))
		{
			level.brutus_health = int(5000 * n_player_modifier);
		}

		if (level.brutus_expl_dmg_req >= (4500 * n_player_modifier))
		{
			level.brutus_expl_dmg_req = int(4500 * n_player_modifier);
		}

		level.brutus_last_spawn_round = level.round_number;
	}
}

brutus_cleanup_at_end_of_grief_round()
{
	// stays on map
}