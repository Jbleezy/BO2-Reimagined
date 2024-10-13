#include maps\mp\zombies\_zm;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

init_client_flags()
{
	level.disable_deadshot_clientfield = undefined;

	if (isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx)
	{
		level._zombie_scriptmover_flag_board_horizontal_fx = 14;
		level._zombie_scriptmover_flag_board_vertical_fx = 13;
	}

	if (isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
	{
		level._zombie_scriptmover_flag_rock_fx = 12;
	}

	level._zombie_player_flag_cloak_weapon = 14;

	if (!(isdefined(level.disable_deadshot_clientfield) && level.disable_deadshot_clientfield))
	{
		registerclientfield("toplayer", "deadshot_perk", 1, 1, "int");
	}

	registerclientfield("actor", "zombie_riser_fx", 1, 1, "int");

	if (!(isdefined(level._no_water_risers) && level._no_water_risers))
	{
		registerclientfield("actor", "zombie_riser_fx_water", 1, 1, "int");
	}

	if (isdefined(level._foliage_risers) && level._foliage_risers)
	{
		registerclientfield("actor", "zombie_riser_fx_foliage", 12000, 1, "int");
	}

	if (isdefined(level.risers_use_low_gravity_fx) && level.risers_use_low_gravity_fx)
	{
		registerclientfield("actor", "zombie_riser_fx_lowg", 1, 1, "int");
	}
}

init_fx()
{
	if (level.script == "zm_buried" || level.script == "zm_prison")
	{
		level._uses_sticky_grenades = 1;
		level.disable_fx_zmb_wall_buy_semtex = 0;
	}

	if (level.script == "zm_prison")
	{
		register_lethal_grenade_for_level("sticky_grenade_zm");
	}

	level.createfx_callback_thread = ::delete_in_createfx;
	level._effect["wood_chunk_destory"] = loadfx("impacts/fx_large_woodhit");
	level._effect["fx_zombie_bar_break"] = loadfx("maps/zombie/fx_zombie_bar_break");
	level._effect["fx_zombie_bar_break_lite"] = loadfx("maps/zombie/fx_zombie_bar_break_lite");

	if (!(isdefined(level.fx_exclude_edge_fog) && level.fx_exclude_edge_fog))
	{
		level._effect["edge_fog"] = loadfx("maps/zombie/fx_fog_zombie_amb");
	}

	level._effect["chest_light"] = loadfx("maps/zombie/fx_zmb_tranzit_marker_glow");

	if (!(isdefined(level.fx_exclude_default_eye_glow) && level.fx_exclude_default_eye_glow))
	{
		level._effect["eye_glow"] = loadfx("misc/fx_zombie_eye_single");
	}

	level._effect["headshot"] = loadfx("impacts/fx_flesh_hit");
	level._effect["headshot_nochunks"] = loadfx("misc/fx_zombie_bloodsplat");
	level._effect["bloodspurt"] = loadfx("misc/fx_zombie_bloodspurt");

	if (!(isdefined(level.fx_exclude_tesla_head_light) && level.fx_exclude_tesla_head_light))
	{
		level._effect["tesla_head_light"] = loadfx("maps/zombie/fx_zombie_tesla_neck_spurt");
	}

	level._effect["zombie_guts_explosion"] = loadfx("maps/zombie/fx_zmb_tranzit_torso_explo");
	level._effect["rise_burst_water"] = loadfx("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["rise_billow_water"] = loadfx("maps/zombie/fx_mp_zombie_body_dirt_billowing");
	level._effect["rise_dust_water"] = loadfx("maps/zombie/fx_mp_zombie_body_dust_falling");
	level._effect["rise_burst"] = loadfx("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["rise_billow"] = loadfx("maps/zombie/fx_mp_zombie_body_dirt_billowing");
	level._effect["rise_dust"] = loadfx("maps/zombie/fx_mp_zombie_body_dust_falling");
	level._effect["fall_burst"] = loadfx("maps/zombie/fx_mp_zombie_hand_dirt_burst");
	level._effect["fall_billow"] = loadfx("maps/zombie/fx_mp_zombie_body_dirt_billowing");
	level._effect["fall_dust"] = loadfx("maps/zombie/fx_mp_zombie_body_dust_falling");
	level._effect["character_fire_death_sm"] = loadfx("env/fire/fx_fire_zombie_md");
	level._effect["character_fire_death_torso"] = loadfx("env/fire/fx_fire_zombie_torso");

	if (!(isdefined(level.fx_exclude_default_explosion) && level.fx_exclude_default_explosion))
	{
		level._effect["def_explosion"] = loadfx("explosions/fx_default_explosion");
	}

	if (!(isdefined(level._uses_default_wallbuy_fx) && !level._uses_default_wallbuy_fx))
	{
		level._effect["870mcs_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_870mcs");
		level._effect["vector_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_ak74u");
		level._effect["beretta93r_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_berreta93r");
		level._effect["bowie_knife_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_bowie");
		level._effect["claymore_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_claymore");
		level._effect["saritch_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m14");
		level._effect["sig556_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m16");
		level._effect["insas_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_mp5k");
		level._effect["ballista_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_olympia");
	}

	if (!(isdefined(level._uses_sticky_grenades) && !level._uses_sticky_grenades))
	{
		if (!(isdefined(level.disable_fx_zmb_wall_buy_semtex) && level.disable_fx_zmb_wall_buy_semtex))
		{
			grenade = "sticky_grenade_zm";

			if (level.script == "zm_buried")
			{
				grenade = "frag_grenade_zm";
			}

			level._effect[grenade + "_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_semtex");
		}
	}

	if (!(isdefined(level._uses_taser_knuckles) && !level._uses_taser_knuckles))
	{
		level._effect["tazer_knuckles_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_taseknuck");
	}

	if (isdefined(level.buildable_wallbuy_weapons))
	{
		level._effect["dynamic_wallbuy_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_question");
	}

	if (!(isdefined(level.disable_fx_upgrade_aquired) && level.disable_fx_upgrade_aquired))
	{
		level._effect["upgrade_aquired"] = loadfx("maps/zombie/fx_zmb_tanzit_upgrade");
	}
}

round_start()
{
	if (isdefined(level.round_prestart_func))
	{
		[[level.round_prestart_func]]();
	}
	else
	{
		n_delay = 2;

		if (isdefined(level.zombie_round_start_delay))
		{
			n_delay = level.zombie_round_start_delay;
		}

		wait(n_delay);
	}

	level.zombie_health = level.zombie_vars["zombie_health_start"];

	if (getdvarint("scr_writeConfigStrings") == 1)
	{
		wait 5;
		exitlevel();
		return;
	}

	if (level.zombie_vars["game_start_delay"] > 0)
	{
		round_pause(level.zombie_vars["game_start_delay"]);
	}

	flag_set("begin_spawning");

	if (!isdefined(level.round_spawn_func))
	{
		level.round_spawn_func = ::round_spawning;
	}

	if (!isdefined(level.round_wait_func))
	{
		level.round_wait_func = ::round_wait;
	}

	if (!isdefined(level.round_think_func))
	{
		level.round_think_func = ::round_think;
	}

	level thread [[level.round_think_func]]();
}

round_spawning()
{
	level endon("intermission");
	level endon("end_of_round");
	level endon("restart_round");

	if (level.intermission)
	{
		return;
	}

	if (level.zombie_spawn_locations.size < 1)
	{
		return;
	}

	ai_calculate_health(level.round_number);
	count = 0;
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		players[i].zombification_time = 0;
	}

	max = level.zombie_vars["zombie_max_ai"];
	multiplier = level.round_number / 5;

	if (multiplier < 1)
	{
		multiplier = 1;
	}

	if (level.round_number >= 10)
	{
		multiplier *= (level.round_number * 0.15);
	}

	player_num = get_players().size;

	max += int((player_num * 0.5) * level.zombie_vars["zombie_ai_per_player"] * multiplier);

	if (!isdefined(level.max_zombie_func))
	{
		level.max_zombie_func = ::default_max_zombie_func;
	}

	if (!(isdefined(level.kill_counter_hud) && level.zombie_total > 0))
	{
		level.zombie_total = [[level.max_zombie_func]](max);
		level notify("zombie_total_set");
	}

	if (isdefined(level.zombie_total_set_func))
	{
		level thread [[level.zombie_total_set_func]]();
	}

	if (level.round_number < 10 || level.speed_change_max > 0)
	{
		level thread zombie_speed_up();
	}

	mixed_spawns = 0;
	old_spawn = undefined;

	while (true)
	{
		while (get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0)
		{
			wait 0.1;
		}

		while (get_current_actor_count() >= level.zombie_actor_limit)
		{
			clear_all_corpses();
			wait 0.1;
		}

		flag_wait("spawn_zombies");

		while (level.zombie_spawn_locations.size <= 0)
		{
			wait 0.1;
		}

		run_custom_ai_spawn_checks();
		spawn_point = level.zombie_spawn_locations[randomint(level.zombie_spawn_locations.size)];

		if (!isdefined(old_spawn))
		{
			old_spawn = spawn_point;
		}
		else if (spawn_point == old_spawn)
		{
			spawn_point = level.zombie_spawn_locations[randomint(level.zombie_spawn_locations.size)];
		}

		old_spawn = spawn_point;

		if (isdefined(level.mixed_rounds_enabled) && level.mixed_rounds_enabled == 1)
		{
			spawn_dog = 0;

			if (level.round_number > 30)
			{
				if (randomint(100) < 3)
				{
					spawn_dog = 1;
				}
			}
			else if (level.round_number > 25 && mixed_spawns < 3)
			{
				if (randomint(100) < 2)
				{
					spawn_dog = 1;
				}
			}
			else if (level.round_number > 20 && mixed_spawns < 2)
			{
				if (randomint(100) < 2)
				{
					spawn_dog = 1;
				}
			}
			else if (level.round_number > 15 && mixed_spawns < 1)
			{
				if (randomint(100) < 1)
				{
					spawn_dog = 1;
				}
			}

			if (spawn_dog)
			{
				keys = getarraykeys(level.zones);

				for (i = 0; i < keys.size; i++)
				{
					if (level.zones[keys[i]].is_occupied)
					{
						akeys = getarraykeys(level.zones[keys[i]].adjacent_zones);

						for (k = 0; k < akeys.size; k++)
						{
							if (level.zones[akeys[k]].is_active && !level.zones[akeys[k]].is_occupied && level.zones[akeys[k]].dog_locations.size > 0)
							{
								maps\mp\zombies\_zm_ai_dogs::special_dog_spawn(undefined, 1);
								level.zombie_total--;
								wait_network_frame();
							}
						}
					}
				}
			}
		}

		if (isdefined(level.zombie_spawners))
		{
			if (isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
			{
				if (isdefined(spawn_point.script_int))
				{
					if (isdefined(level.zombie_spawn[spawn_point.script_int]) && level.zombie_spawn[spawn_point.script_int].size)
					{
						spawner = random(level.zombie_spawn[spawn_point.script_int]);
					}
				}
				else if (isdefined(level.zones[spawn_point.zone_name].script_int) && level.zones[spawn_point.zone_name].script_int)
				{
					spawner = random(level.zombie_spawn[level.zones[spawn_point.zone_name].script_int]);
				}
				else if (isdefined(level.spawner_int) && (isdefined(level.zombie_spawn[level.spawner_int].size) && level.zombie_spawn[level.spawner_int].size))
				{
					spawner = random(level.zombie_spawn[level.spawner_int]);
				}
				else
				{
					spawner = random(level.zombie_spawners);
				}
			}
			else
			{
				spawner = random(level.zombie_spawners);
			}

			ai = spawn_zombie(spawner, spawner.targetname, spawn_point);
		}

		if (isdefined(ai))
		{
			level.zombie_total--;
			ai thread round_spawn_failsafe();
			count++;
		}

		wait(level.zombie_vars["zombie_spawn_delay"]);
		wait_network_frame();
	}
}

round_spawn_failsafe()
{
	self endon("death");
	prevorigin = self.origin;
	prevorigin_time = gettime();

	while (true)
	{
		if (isdefined(self.ignore_round_spawn_failsafe) && self.ignore_round_spawn_failsafe)
		{
			return;
		}

		wait 0.05;

		if (isdefined(self.is_inert) && self.is_inert)
		{
			prevorigin = self.origin;
			prevorigin_time = gettime();
			continue;
		}

		if (isdefined(self.in_the_ground) && self.in_the_ground)
		{
			prevorigin = self.origin;
			prevorigin_time = gettime();
			continue;
		}

		if (isdefined(self.in_the_ceiling) && self.in_the_ceiling)
		{
			prevorigin = self.origin;
			prevorigin_time = gettime();
			continue;
		}

		if (isdefined(self.lastchunk_destroy_time))
		{
			if (gettime() - self.lastchunk_destroy_time < 4000)
			{
				prevorigin = self.origin;
				prevorigin_time = gettime();
				continue;
			}
		}

		if (self.origin[2] < level.zombie_vars["below_world_check"])
		{
			if (isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !flag("dog_round") && !(isdefined(self.isscreecher) && self.isscreecher))
			{
				level.zombie_total++;
				level.zombie_total_subtract++;
			}

			self dodamage(self.health + 100, (0, 0, 0));
			break;
		}

		if (distancesquared(self.origin, prevorigin) < 576)
		{
			if (gettime() - prevorigin_time < 15000)
			{
				continue;
			}

			if (isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !flag("dog_round"))
			{
				if (!self.ignoreall && !(isdefined(self.nuked) && self.nuked) && !(isdefined(self.marked_for_death) && self.marked_for_death) && !(isdefined(self.isscreecher) && self.isscreecher) && !(isdefined(self.is_brutus) && self.is_brutus))
				{
					level.zombie_total++;
					level.zombie_total_subtract++;

					if (self.health < level.zombie_health)
					{
						level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
					}
				}
			}

			level.zombies_timeout_playspace++;

			if (isdefined(self.is_brutus) && self.is_brutus)
			{
				self.suppress_brutus_powerup_drop = 1;
				self.brutus_round_spawn_failsafe = 1;
			}

			self dodamage(self.health + 100, (0, 0, 0));
			break;
		}
		else
		{
			prevorigin = self.origin;
			prevorigin_time = gettime();
		}
	}
}

round_think(restart = 0)
{
	level endon("end_round_think");

	if (!(isdefined(restart) && restart))
	{
		if (isdefined(level.initial_round_wait_func))
		{
			[[level.initial_round_wait_func]]();
		}

		if (!(isdefined(level.host_ended_game) && level.host_ended_game))
		{
			players = get_players();

			foreach (player in players)
			{
				if (!(isdefined(player.hostmigrationcontrolsfrozen) && player.hostmigrationcontrolsfrozen))
				{
					player freezecontrols(0);
				}

				player maps\mp\zombies\_zm_stats::set_global_stat("rounds", level.round_number);
			}
		}
	}

	if (level.round_number > 255)
	{
		players = get_players();

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_rounds_played", 1, level.round_number);
		}
	}
	else
	{
		setroundsplayed(level.round_number);
	}

	for (;;)
	{
		if (!is_gametype_active("zgrief"))
		{
			level.player_starting_points = (level.round_number + 1) * 500;

			if (level.player_starting_points > 10000)
			{
				level.player_starting_points = 10000;
			}
		}

		maxreward = 50 * level.round_number;

		if (maxreward > 500)
		{
			maxreward = 500;
		}

		level.zombie_vars["rebuild_barrier_cap_per_round"] = maxreward;
		level.pro_tips_start_time = gettime();
		level.zombie_last_run_time = gettime();

		if (isdefined(level.zombie_round_change_custom))
		{
			[[level.zombie_round_change_custom]]();
		}
		else
		{
			level thread maps\mp\zombies\_zm_audio::change_zombie_music("round_start");
			round_one_up();
		}

		maps\mp\zombies\_zm_powerups::powerup_round_start();
		players = get_players();
		array_thread(players, maps\mp\zombies\_zm_blockers::rebuild_barrier_reward_reset);

		if (!(isdefined(level.headshots_only) && level.headshots_only) && !restart)
		{
			level thread award_grenades_for_survivors();
		}

		bbprint("zombie_rounds", "round %d player_count %d", level.round_number, players.size);

		level.round_start_time = gettime();

		while (level.zombie_spawn_locations.size <= 0)
		{
			wait 0.1;
		}

		level thread [[level.round_spawn_func]]();
		level notify("start_of_round");
		recordzombieroundstart();
		players = getplayers();

		for (index = 0; index < players.size; index++)
		{
			zonename = players[index] get_current_zone();

			if (isdefined(zonename))
			{
				players[index] recordzombiezone("startingZone", zonename);
			}
		}

		if (isdefined(level.round_start_custom_func))
		{
			[[level.round_start_custom_func]]();
		}

		[[level.round_wait_func]]();
		level.first_round = 0;
		level notify("end_of_round");
		level thread maps\mp\zombies\_zm_audio::change_zombie_music("round_end");
		uploadstats();

		if (isdefined(level.round_end_custom_logic))
		{
			[[level.round_end_custom_logic]]();
		}

		players = get_players();

		if (isdefined(level.no_end_game_check) && level.no_end_game_check)
		{
			level thread last_stand_revive();
			level thread spectators_respawn();
		}
		else if (1 != players.size)
		{
			level thread spectators_respawn();
		}

		players = get_players();
		array_thread(players, maps\mp\zombies\_zm_pers_upgrades_system::round_end);
		timer = level.zombie_vars["zombie_spawn_delay"];

		if (timer > 0.08)
		{
			level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
		}
		else if (timer < 0.08)
		{
			level.zombie_vars["zombie_spawn_delay"] = 0.08;
		}

		if (level.gamedifficulty == 0)
		{
			level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier_easy"];
		}
		else
		{
			level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
		}

		level.round_number++;

		if (level.round_number > 255)
		{
			players = get_players();

			foreach (player in players)
			{
				player luinotifyevent(&"hud_update_rounds_played", 1, level.round_number);
			}
		}
		else
		{
			setroundsplayed(level.round_number);
		}

		matchutctime = getutc();
		players = get_players();

		foreach (player in players)
		{
			if (level.curr_gametype_affects_rank && level.round_number > 3 + level.start_round)
			{
				player maps\mp\zombies\_zm_stats::add_client_stat("weighted_rounds_played", level.round_number);
			}

			player maps\mp\zombies\_zm_stats::set_global_stat("rounds", level.round_number);
			player maps\mp\zombies\_zm_stats::update_playing_utc_time(matchutctime);
		}

		check_quickrevive_for_hotjoin();
		level round_over();
		level notify("between_round_over");
		restart = 0;
	}
}

spectators_respawn()
{
	level endon("between_round_over");

	if (!isdefined(level.zombie_vars["spectators_respawn"]) || !level.zombie_vars["spectators_respawn"])
	{
		return;
	}

	if (!isdefined(level.custom_spawnplayer))
	{
		level.custom_spawnplayer = ::spectator_respawn;
	}

	while (true)
	{
		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			if (players[i].sessionstate == "spectator" && isdefined(players[i].spectator_respawn))
			{
				players[i][[level.spawnplayer]]();
				thread refresh_player_navcard_hud();

				new_score = (level.round_number + 1) * 250;

				if (new_score > 1500)
				{
					new_score = 1500;
				}

				if (players[i].score < new_score)
				{
					players[i].old_score = players[i].score;

					if (isdefined(level.spectator_respawn_custom_score))
					{
						players[i][[level.spectator_respawn_custom_score]]();
					}

					players[i].score = new_score;
				}
			}
		}

		wait 1;
	}
}

ai_calculate_health(round_number)
{
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	max_health = 100000;
	i = 2;

	while (i <= round_number)
	{
		if (level.zombie_health > max_health)
		{
			level.zombie_health = max_health;
			return;
		}

		if (i >= 10)
		{
			old_health = level.zombie_health;
			level.zombie_health = level.zombie_health + int(level.zombie_health * level.zombie_vars["zombie_health_increase_multiplier"]);

			if (level.zombie_health < old_health)
			{
				level.zombie_health = old_health;
				return;
			}

			i++;
			continue;
		}

		level.zombie_health = int(level.zombie_health + level.zombie_vars["zombie_health_increase"]);
		i++;
	}
}

onallplayersready()
{
	timeout = gettime() + 5000;

	while (getnumexpectedplayers() == 0 && gettime() < timeout)
	{
		wait 0.1;
	}

	player_count_actual = 0;

	while (getnumconnectedplayers() < getnumexpectedplayers() || player_count_actual != getnumexpectedplayers())
	{
		players = get_players();
		player_count_actual = 0;

		for (i = 0; i < players.size; i++)
		{
			players[i] freezecontrols(1);

			if (players[i].sessionstate == "playing")
			{
				player_count_actual++;
			}
		}

		wait 0.1;
	}

	setinitialplayersconnected();

	if (1 == getnumconnectedplayers() && getdvarint("scr_zm_enable_bots") == 1)
	{
		level thread add_bots();
		flag_set("initial_players_connected");
	}
	else
	{
		players = get_players();

		if (players.size == 1 && level.scr_zm_ui_gametype != "zgrief")
		{
			flag_set("solo_game");
			level.solo_lives_given = 0;

			foreach (player in players)
			{
				player.lives = 0;
			}

			level maps\mp\zombies\_zm::set_default_laststand_pistol(1);
		}

		flag_set("initial_players_connected");

		while (!aretexturesloaded())
		{
			wait 0.05;
		}

		thread start_zombie_logic_in_x_sec(3.0);
	}

	setDvar("team_axis", "");
	setDvar("team_allies", "");

	fade_out_intro_screen_zm(5.0, 1.5, 1);
}

fade_out_intro_screen_zm(hold_black_time, fade_out_time, destroyed_afterwards)
{
	flag_init("hud_visible");

	if (!isdefined(level.introscreen))
	{
		level.introscreen = newhudelem();
		level.introscreen.x = 0;
		level.introscreen.y = 0;
		level.introscreen.horzalign = "fullscreen";
		level.introscreen.vertalign = "fullscreen";
		level.introscreen.foreground = 0;
		level.introscreen setshader("black", 640, 480);
		level.introscreen.immunetodemogamehudsettings = 1;
		level.introscreen.immunetodemofreecamera = 1;
		wait 0.05;
	}

	level.introscreen.alpha = 1;

	if (isdefined(hold_black_time))
	{
		wait(hold_black_time);
	}
	else
	{
		wait 0.2;
	}

	if (!isdefined(fade_out_time))
	{
		fade_out_time = 1.5;
	}

	level.introscreen fadeovertime(fade_out_time);
	level.introscreen.alpha = 0;
	wait 1.6;

	level.passed_introscreen = 1;

	players = get_players();

	foreach (player in players)
	{
		player setclientuivisibilityflag("hud_visible", 1);
	}

	flag_set("hud_visible");

	if (isDedicated() || (is_gametype_active("zgrief") && getDvarInt("ui_gametype_team_change")))
	{
		flag_init("all_players_ready");

		level thread pregame_think();

		flag_wait("all_players_ready");
	}

	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		if (!(isdefined(level.host_ended_game) && level.host_ended_game))
		{
			if (isdefined(level.player_movement_suppressed))
			{
				players[i] freezecontrols(level.player_movement_suppressed);
				continue;
			}

			if (!(isdefined(players[i].hostmigrationcontrolsfrozen) && players[i].hostmigrationcontrolsfrozen))
			{
				players[i] freezecontrols(0);
			}
		}
	}

	if (destroyed_afterwards == 1)
	{
		level.introscreen destroy();
	}

	flag_set("initial_blackscreen_passed");
}

pregame_think()
{
	if (!isDefined(level.prev_no_end_game_check))
	{
		level.prev_no_end_game_check = is_true(level.no_end_game_check);
	}

	level.no_end_game_check = 1;

	setroundsplayed(0);

	if (!isDefined(level.pregame_hud))
	{
		level.pregame_hud = createServerFontString("objective", 1.5);
		level.pregame_hud setPoint("CENTER", "CENTER", 0, -95);
		level.pregame_hud.color = (1, 1, 1);
	}

	num_players = get_number_of_waiting_players();

	while (num_players < level.pregame_minplayers)
	{
		if (is_gametype_active("zgrief"))
		{
			level thread check_for_team_change();
		}

		players = get_players();

		foreach (player in players)
		{
			if (is_true(player.afterlife))
			{
				player.infinite_mana = 1;
			}

			player freezecontrols(1);
		}

		num_waiting_for = level.pregame_minplayers - num_players;

		players_str = &"ZOMBIE_WAITING_FOR_MORE_PLAYERS_CAPS";

		if (num_waiting_for == 1)
		{
			players_str = &"ZOMBIE_WAITING_FOR_MORE_PLAYER_CAPS";
		}

		level.pregame_hud setText(players_str, num_waiting_for, num_players, level.pregame_minplayers);

		wait 0.05;

		num_players = get_number_of_waiting_players();
	}

	if (!isDefined(level.ready_up_hud))
	{
		level.ready_up_hud = createServerFontString("objective", 1.5);
		level.ready_up_hud setPoint("CENTER", "CENTER", 0, -115);
		level.ready_up_hud.color = (1, 1, 1);
		level.ready_up_hud setText(&"ZOMBIE_READY_UP_HOWTO_CAPS");
	}

	level.ready_up_hud.alpha = 1;

	ready_up_time = 0;
	ready_up_timeout = 0;
	ready_up_start_time = undefined;
	ready_up_start_players = undefined;

	if (isDedicated() && !(is_gametype_active("zgrief") && getDvarInt("ui_gametype_team_change")))
	{
		ready_up_time = 60;
	}

	num_ready = get_number_of_ready_players();
	players = get_players();

	foreach (player in players)
	{
		player.waiting = undefined;
		player playlocalsound("zmb_perks_packa_ready");

		player.playing_loop_sound = 1;
		player playloopsound("zmb_perks_packa_ticktock");
	}

	while (num_ready < players.size || players.size < level.pregame_minplayers)
	{
		ready_up_timeout = 0;

		if (ready_up_time > 0)
		{
			if (num_ready > 0 && !isdefined(ready_up_start_time))
			{
				ready_up_start_time = getTime();
				ready_up_start_players = get_players();

				if (!isDefined(level.ready_up_countdown_hud))
				{
					level.ready_up_countdown_hud = countdown_hud(&"ZOMBIE_PRE_GAME_ENDS_IN_CAPS", undefined, ready_up_time);
				}
			}

			if (isdefined(ready_up_start_time))
			{
				time = getTime() - ready_up_start_time;

				if (time >= ready_up_time * 1000)
				{
					ready_up_timeout = 1;

					foreach (player in ready_up_start_players)
					{
						if (isDefined(player) && !isDefined(player.ready))
						{
							kick(player getEntityNumber());
						}
					}

					wait 0.05;
				}
			}
		}

		players = get_players();

		if (players.size < level.pregame_minplayers)
		{
			foreach (player in players)
			{
				player.ready = undefined;
				player.statusicon = "";
				player playlocalsound("zmb_perks_packa_deny");

				player.playing_loop_sound = undefined;
				player stoploopsound();
			}

			level.ready_up_hud.alpha = 0;

			if (isDefined(level.ready_up_countdown_hud))
			{
				level.ready_up_countdown_hud countdown_hud_destroy();
			}

			level thread pregame_think();

			return;
		}

		if (ready_up_timeout)
		{
			break;
		}

		if (is_gametype_active("zgrief"))
		{
			level thread check_for_team_change();
		}

		foreach (player in players)
		{
			if (!isDefined(player.playing_loop_sound))
			{
				player.playing_loop_sound = 1;
				player playloopsound("zmb_perks_packa_ticktock");
			}

			if (is_true(player.afterlife))
			{
				player.infinite_mana = 1;
			}

			player freezecontrols(1);
		}

		num_waiting_for = players.size - num_ready;

		players_str = &"ZOMBIE_WAITING_FOR_PLAYERS_READY_CAPS";

		if (num_waiting_for == 1)
		{
			players_str = &"ZOMBIE_WAITING_FOR_PLAYER_READY_CAPS";
		}

		level.pregame_hud setText(players_str, num_waiting_for, num_ready, players.size);

		wait 0.05;

		num_ready = get_number_of_ready_players();
		players = get_players();
	}

	if (is_gametype_active("zgrief"))
	{
		level thread check_for_team_change();
	}

	foreach (player in players)
	{
		player.ready = undefined;
		player.statusicon = "";

		player.playing_loop_sound = undefined;
		player stoploopsound();

		if (is_true(player.afterlife))
		{
			player.infinite_mana = 0;
		}
	}

	level.ready_up_hud destroy();
	level.pregame_hud destroy();

	if (isDefined(level.ready_up_countdown_hud))
	{
		level.ready_up_countdown_hud countdown_hud_destroy();
	}

	level.no_end_game_check = level.prev_no_end_game_check;

	flag_set("all_players_ready");
}

get_number_of_waiting_players()
{
	num = 0;
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		if (is_player_valid(players[i]) || is_true(players[i].afterlife))
		{
			players[i].waiting = 1;
		}

		if (is_true(players[i].waiting))
		{
			num++;
		}
	}

	return num;
}

get_number_of_ready_players()
{
	num = 0;
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		if (players[i] jumpbuttonpressed() || players[i] usebuttonpressed() || players[i] is_bot())
		{
			players[i].ready = 1;
		}

		if (is_true(players[i].ready))
		{
			num++;
			players[i].statusicon = "menu_mp_killstreak_select";
		}
		else
		{
			players[i].statusicon = "menu_mp_contract_expired";
		}
	}

	return num;
}

check_for_team_change()
{
	if (level.allow_teamchange)
	{
		return;
	}

	team_change_player = undefined;
	axis_players = get_players("axis");
	allies_players = get_players("allies");

	if (axis_players.size - 1 > allies_players.size)
	{
		team_change_player = random(axis_players);
	}
	else if (allies_players.size - 1 > axis_players.size)
	{
		team_change_player = random(allies_players);
	}

	if (isDefined(team_change_player))
	{
		team_change_player endon("disconnect");

		team_change_player scripts\zm\replaced\_zm_gametype::do_team_change();

		wait 0.05;

		team_change_player freezecontrols(1);
	}
}

countdown_hud(text, text_param, time)
{
	countdown_hud = createServerFontString("objective", 2.2);
	countdown_hud setPoint("CENTER", "CENTER", 0, 0);
	countdown_hud.color = (1, 1, 0);
	countdown_hud maps\mp\gametypes_zm\_hud::fontpulseinit();
	countdown_hud thread countdown_hud_end_game_watcher();

	countdown_hud.countdown_text = createServerFontString("objective", 1.5);
	countdown_hud.countdown_text setPoint("CENTER", "CENTER", 0, -40);
	countdown_hud.countdown_text.color = (1, 1, 1);

	countdown_hud thread countdown_hud_timer(time);

	if (isdefined(text_param))
	{
		countdown_hud.countdown_text setText(text, text_param);
	}
	else
	{
		countdown_hud.countdown_text setText(text);
	}

	countdown_hud.alpha = 1;
	countdown_hud.countdown_text.alpha = 1;

	return countdown_hud;
}

countdown_hud_destroy()
{
	self.countdown_text destroy();
	self destroy();
}

countdown_hud_end_game_watcher()
{
	self endon("death");

	level waittill("end_game");

	self countdown_hud_destroy();
}

countdown_hud_timer(time)
{
	self endon("death");

	while (time > 0)
	{
		self setvalue(time);
		self thread maps\mp\gametypes_zm\_hud::fontpulse(level);
		wait 1;
		time--;
	}
}

last_stand_pistol_rank_init()
{
	level.pistol_values = [];
	level.pistol_values[level.pistol_values.size] = "fnp45_zm";
	level.pistol_values[level.pistol_values.size] = "m1911_zm";
	level.pistol_values[level.pistol_values.size] = "c96_zm";
	level.pistol_values[level.pistol_values.size] = "cz75_zm";
	level.pistol_values[level.pistol_values.size] = "cz75dw_zm";
	level.pistol_values[level.pistol_values.size] = "kard_zm";
	level.pistol_values[level.pistol_values.size] = "fiveseven_zm";
	level.pistol_values[level.pistol_values.size] = "beretta93r_zm";
	level.pistol_values[level.pistol_values.size] = "beretta93r_extclip_zm";
	level.pistol_values[level.pistol_values.size] = "fivesevendw_zm";
	level.pistol_values[level.pistol_values.size] = "rnma_zm";
	level.pistol_values[level.pistol_values.size] = "python_zm";
	level.pistol_values[level.pistol_values.size] = "judge_zm";
	level.pistol_values[level.pistol_values.size] = "cz75_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "cz75dw_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "kard_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "fiveseven_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "beretta93r_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "beretta93r_extclip_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "fivesevendw_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "rnma_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "python_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "judge_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "ray_gun_zm";
	level.pistol_values[level.pistol_values.size] = "ray_gun_upgraded_zm";
	level.pistol_value_solo_replace_below = level.pistol_values.size - 1;
	level.pistol_values[level.pistol_values.size] = "fnp45_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "m1911_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "c96_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "raygun_mark2_zm";
	level.pistol_values[level.pistol_values.size] = "raygun_mark2_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "freezegun_zm";
	level.pistol_values[level.pistol_values.size] = "freezegun_upgraded_zm";
	level.pistol_values[level.pistol_values.size] = "microwavegundw_zm";
	level.pistol_values[level.pistol_values.size] = "microwavegundw_upgraded_zm";
}

last_stand_best_pistol()
{
	pistol_array = [];
	current_weapons = self getweaponslistprimaries();

	for (i = 0; i < current_weapons.size; i++)
	{
		class = weaponclass(current_weapons[i]);

		if (issubstr(current_weapons[i], "knife_ballistic_"))
		{
			class = "knife";
		}

		if (class == "pistol" || class == "pistolspread" || class == "pistol spread")
		{
			if (current_weapons[i] != level.default_laststandpistol && !flag("solo_game") || !flag("solo_game") && current_weapons[i] != level.default_solo_laststandpistol)
			{
				ammo_count = self getammocount(current_weapons[i]);

				dual_wield_name = weapondualwieldweaponname(current_weapons[i]);

				if (dual_wield_name != "none")
				{
					ammo_count += self getweaponammoclip(dual_wield_name);
				}

				if (ammo_count <= 0)
				{
					continue;
				}
			}

			pistol_array_index = pistol_array.size;
			pistol_array[pistol_array_index] = spawnstruct();
			pistol_array[pistol_array_index].gun = current_weapons[i];
			pistol_array[pistol_array_index].value = 0;

			for (j = 0; j < level.pistol_values.size; j++)
			{
				if (level.pistol_values[j] == current_weapons[i])
				{
					pistol_array[pistol_array_index].value = j;
					break;
				}
			}
		}
	}

	self.laststandpistol = last_stand_compare_pistols(pistol_array);
}

can_track_ammo(weap)
{
	if (!isdefined(weap))
	{
		return false;
	}

	switch (weap)
	{
		case "zombie_tazer_flourish":
		case "zombie_sickle_flourish":
		case "zombie_knuckle_crack":
		case "zombie_fists_zm":
		case "zombie_builder_zm":
		case "zombie_bowie_flourish":
		case "time_bomb_zm":
		case "time_bomb_detonator_zm":
		case "tazer_knuckles_zm":
		case "tazer_knuckles_upgraded_zm":
		case "slowgun_zm":
		case "slowgun_upgraded_zm":
		case "screecher_arms_zm":
		case "riotshield_zm":
		case "none":
		case "no_hands_zm":
		case "lower_equip_gasmask_zm":
		case "humangun_zm":
		case "humangun_upgraded_zm":
		case "equip_gasmask_zm":
		case "equip_dieseldrone_zm":
		case "death_throe_zm":
		case "chalk_draw_zm":
		case "alcatraz_shield_zm":
		case "tomb_shield_zm":
			return false;

		default:
			if (is_melee_weapon(weap) || is_zombie_perk_bottle(weap) || is_placeable_mine(weap) || is_equipment(weap) || issubstr(weap, "knife_ballistic_") || getsubstr(weap, 0, 3) == "gl_" || weaponfuellife(weap) > 0 || weap == level.revive_tool)
			{
				return false;
			}
	}

	return true;
}

take_additionalprimaryweapon()
{
	weapon_to_take = undefined;
	self.a_saved_weapon = undefined;

	if (isdefined(self._retain_perks) && self._retain_perks || isdefined(self._retain_perks_array) && (isdefined(self._retain_perks_array["specialty_additionalprimaryweapon"]) && self._retain_perks_array["specialty_additionalprimaryweapon"]))
	{
		return undefined;
	}

	self scripts\zm\_zm_reimagined::additionalprimaryweapon_update_weapon_slots();

	weapon_to_take = self.weapon_to_take_by_losing_specialty_additionalprimaryweapon;

	if (!isDefined(weapon_to_take) || !self hasWeapon(weapon_to_take))
	{
		return undefined;
	}

	self.a_saved_weapon = maps\mp\zombies\_zm_weapons::get_player_weapondata(self, weapon_to_take);

	name = self.a_saved_weapon["name"];
	dw_name = weaponDualWieldWeaponName(name);
	alt_name = weaponAltWeaponName(name);

	clip_missing = weaponClipSize(name) - self.a_saved_weapon["clip"];

	if (clip_missing > self.a_saved_weapon["stock"])
	{
		clip_missing = self.a_saved_weapon["stock"];
	}

	self.a_saved_weapon["clip"] += clip_missing;
	self.a_saved_weapon["stock"] -= clip_missing;

	if (dw_name != "none")
	{
		clip_dualwield_missing = weaponClipSize(dw_name) - self.a_saved_weapon["lh_clip"];

		if (clip_dualwield_missing > self.a_saved_weapon["stock"])
		{
			clip_dualwield_missing = self.a_saved_weapon["stock"];
		}

		self.a_saved_weapon["lh_clip"] += clip_dualwield_missing;
		self.a_saved_weapon["stock"] -= clip_dualwield_missing;
	}

	if (alt_name != "none")
	{
		clip_alt_missing = weaponClipSize(alt_name) - self.a_saved_weapon["alt_clip"];

		if (clip_alt_missing > self.a_saved_weapon["alt_stock"])
		{
			clip_alt_missing = self.a_saved_weapon["alt_stock"];
		}

		self.a_saved_weapon["alt_clip"] += clip_alt_missing;
		self.a_saved_weapon["alt_stock"] -= clip_alt_missing;
	}

	if (weapon_to_take == self getcurrentweapon())
	{
		for (i = 0; i < self.weapon_slots.size; i++)
		{
			if (isdefined(self.weapon_slots[i]) && self.weapon_slots[i] != weapon_to_take)
			{
				self switchtoweapon(self.weapon_slots[i]);
				break;
			}
		}
	}

	self takeweapon(weapon_to_take);

	return weapon_to_take;
}

restore_additionalprimaryweapon()
{
	if (!isDefined(self.a_saved_weapon))
	{
		return;
	}

	pap_triggers = getentarray("specialty_weapupgrade", "script_noteworthy");

	if (!additionalprimaryweapon_canplayerreceiveweapon(self, self.a_saved_weapon["name"], pap_triggers))
	{
		self.a_saved_weapon = undefined;
		return;
	}

	current = get_player_weapon_with_same_base(self.a_saved_weapon["name"]);

	if (isdefined(current))
	{
		curweapondata = get_player_weapondata(self, current);
		self takeweapon(current);
		weapondata = merge_weapons(curweapondata, weapondata);
	}

	name = self.a_saved_weapon["name"];
	dw_name = weapondualwieldweaponname(name);
	alt_name = weaponaltweaponname(name);

	if (!is_weapon_upgraded(name))
	{
		self giveweapon(name);
	}
	else
	{
		self giveweapon(name, 0, self get_pack_a_punch_weapon_options(name));
	}

	if (name != "none")
	{
		self setweaponammoclip(name, self.a_saved_weapon["clip"]);
		self setweaponammostock(name, self.a_saved_weapon["stock"]);

		if (isdefined(self.a_saved_weapon["fuel"]))
		{
			self setweaponammofuel(name, self.a_saved_weapon["fuel"]);
		}

		if (isdefined(self.a_saved_weapon["heat"]) && isdefined(self.a_saved_weapon["overheat"]))
		{
			self setweaponoverheating(self.a_saved_weapon["overheat"], self.a_saved_weapon["heat"], name);
		}
	}

	if (dw_name != "none")
	{
		self setweaponammoclip(dw_name, self.a_saved_weapon["lh_clip"]);
	}

	if (alt_name != "none")
	{
		self setweaponammoclip(alt_name, self.a_saved_weapon["alt_clip"]);
		self setweaponammostock(alt_name, self.a_saved_weapon["alt_stock"]);
	}

	self switchtoweapon(name);

	self.a_saved_weapon = undefined;
}

additionalprimaryweapon_canplayerreceiveweapon(player, weapon, pap_triggers)
{
	if (isDefined(player) && player maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade(weapon))
	{
		return 0;
	}

	if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(weapon, player, pap_triggers))
	{
		return 0;
	}

	if (!player maps\mp\zombies\_zm_weapons::player_can_use_content(weapon))
	{
		return 0;
	}

	if (isDefined(level.custom_magic_box_selection_logic))
	{
		if (!([[level.custom_magic_box_selection_logic]](weapon, player, pap_triggers)))
		{
			return 0;
		}
	}

	if (isDefined(player) && isDefined(level.special_weapon_magicbox_check))
	{
		if (!player [[level.special_weapon_magicbox_check]](weapon))
		{
			return 0;
		}
	}

	if (isSubStr(weapon, "staff"))
	{
		return 0;
	}

	return 1;
}

actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if (is_true(self.is_sloth))
	{
		return 0;
	}

	if (issubstr(weapon, "one_inch_punch") && damage <= 5)
	{
		return 0;
	}

	if (!isDefined(self) || !isDefined(attacker))
	{
		return damage;
	}

	if (scripts\zm\_zm_reimagined::is_tazer_weapon(weapon) || weapon == "jetgun_zm" || weapon == "riotshield_zm")
	{
		self.knuckles_extinguish_flames = 1;
	}
	else if (weapon != "none")
	{
		self.knuckles_extinguish_flames = undefined;
	}

	if (isDefined(attacker.animname) && attacker.animname == "quad_zombie")
	{
		if (isDefined(self.animname) && self.animname == "quad_zombie")
		{
			return 0;
		}
	}

	if (!isplayer(attacker) && isDefined(self.non_attacker_func))
	{
		if (is_true(self.non_attack_func_takes_attacker))
		{
			return self [[self.non_attacker_func]](damage, weapon, attacker);
		}
		else
		{
			return self [[self.non_attacker_func]](damage, weapon);
		}
	}

	if (weapon == "zombie_bullet_crouch_zm")
	{
		damage = self scale_damage(damage, 600);
	}

	if (weapon == "willy_pete_zm")
	{
		self.no_gib = 1;
		self.guts_explosion = 1;
		damage = self scale_damage(damage);
	}

	if (weapon == "tower_trap_zm")
	{
		damage = self scale_damage(damage);
	}

	if (weapon == "tower_trap_upgraded_zm")
	{
		damage = self scale_damage(damage, 200);
	}

	if (weapon == "quadrotorturret_zm")
	{
		damage = self scale_damage(damage, 6000);
	}

	if (weapon == "quadrotorturret_upgraded_zm")
	{
		damage = self scale_damage(damage, 10000);
	}

	if (!isplayer(attacker) && !isplayer(self))
	{
		return damage;
	}

	if (!isDefined(damage) || !isDefined(meansofdeath))
	{
		return damage;
	}

	if (meansofdeath == "")
	{
		return damage;
	}

	old_damage = damage;
	final_damage = damage;

	if (isDefined(self.actor_damage_func))
	{
		final_damage = [[self.actor_damage_func]](inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
	}

	if (attacker.classname == "script_vehicle" && isDefined(attacker.owner))
	{
		attacker = attacker.owner;
	}

	if (is_true(self.in_water))
	{
		if (int(final_damage) >= self.health)
		{
			self.water_damage = 1;
		}
	}

	attacker thread maps\mp\gametypes_zm\_weapons::checkhit(weapon);

	if (weapon == "blundergat_zm")
	{
		final_damage = self scale_damage(final_damage, 500);
	}

	if (weapon == "blundergat_upgraded_zm")
	{
		final_damage = self scale_damage(final_damage, 1000);
	}

	if (weapon == "blundersplat_explosive_dart_zm")
	{
		final_damage = self scale_damage(final_damage, 4000);
	}

	if (weapon == "blundersplat_explosive_dart_upgraded_zm")
	{
		final_damage = self scale_damage(final_damage, 8000);
	}

	if (issubstr(weapon, "metalstorm") && final_damage > 0)
	{
		if (issubstr(weapon, "upgraded"))
		{
			// do same damage through penetration
			if (isdefined(attacker.chargeshotlevel))
			{
				final_damage = 2000 * attacker.chargeshotlevel;

				if (is_headshot(weapon, shitloc, meansofdeath))
				{
					final_damage = int(final_damage * 1.5);
				}
			}

			final_damage = self scale_damage(final_damage, 10000);
		}
		else
		{
			// do same damage through penetration
			if (isdefined(attacker.chargeshotlevel))
			{
				final_damage = 1000 * attacker.chargeshotlevel;

				if (is_headshot(weapon, shitloc, meansofdeath))
				{
					final_damage = int(final_damage * 1.5);
				}
			}

			final_damage = self scale_damage(final_damage, 5000);
		}
	}

	if (weapon == "titus6_explosive_dart_zm")
	{
		final_damage = self scale_damage(final_damage, 3000);
	}

	if (weapon == "titus6_explosive_dart_upgraded_zm")
	{
		final_damage = self scale_damage(final_damage, 6000);
	}

	if (weapon == "mk_titus6_zm")
	{
		final_damage = self scale_damage(final_damage, 1000);
	}

	if (weapon == "mk_titus6_upgraded_zm")
	{
		final_damage = self scale_damage(final_damage, 2000);
	}

	if (weapon == "staff_revive_zm")
	{
		final_damage = self scale_damage(final_damage);
	}

	if (attacker HasPerk("specialty_rof"))
	{
		if (meansofdeath == "MOD_PISTOL_BULLET" || meansofdeath == "MOD_RIFLE_BULLET")
		{
			if (!issubstr(weapon, "metalstorm"))
			{
				final_damage *= 1.5;
			}
		}
	}

	if (attacker HasPerk("specialty_deadshot"))
	{
		if (is_headshot(weapon, shitloc, meansofdeath))
		{
			if (meansofdeath == "MOD_PISTOL_BULLET" || meansofdeath == "MOD_RIFLE_BULLET")
			{
				if (!isSubStr(weaponClass(weapon), "spread") || maps\mp\zombies\_zm_weapons::get_base_weapon_name(weapon, 1) == "ksg_zm")
				{
					if (!issubstr(weapon, "metalstorm"))
					{
						final_damage *= 2;
					}
				}
			}
		}
	}

	if (attacker maps\mp\zombies\_zm_pers_upgrades_functions::pers_mulit_kill_headshot_active() && is_headshot(weapon, shitloc, meansofdeath))
	{
		final_damage *= 2;
	}

	if (is_true(level.zombie_vars[attacker.team]["zombie_half_damage"]) && !is_true(self.marked_for_death))
	{
		final_damage /= 2;
	}

	if (is_true(level.headshots_only) && isDefined(attacker) && isplayer(attacker))
	{
		if (meansofdeath == "MOD_MELEE" && shitloc == "head" || meansofdeath == "MOD_MELEE" && shitloc == "helmet")
		{
			return int(final_damage);
		}

		if (is_explosive_damage(meansofdeath))
		{
			return int(final_damage);
		}
		else if (!is_headshot(weapon, shitloc, meansofdeath))
		{
			return 0;
		}
	}

	return int(final_damage);
}

scale_damage(damage, damage_to_kill)
{
	if (is_true(self.is_avogadro) || is_true(self.is_brutus) || is_true(self.is_mechz))
	{
		return damage;
	}

	if (!isdefined(damage_to_kill))
	{
		return level.zombie_health;
	}

	scalar = damage / damage_to_kill;
	scaled_damage = int(scalar * level.zombie_health) + 1;

	if (scaled_damage > damage)
	{
		return scaled_damage;
	}

	return damage;
}

getfreespawnpoint(spawnpoints, player)
{
	if (!isDefined(spawnpoints))
	{
		return undefined;
	}

	spawnpoints = array_randomize(spawnpoints);

	if (!isDefined(game["spawns_randomized"]))
	{
		game["spawns_randomized"] = 1;
		random_chance = randomint(100);

		if (random_chance > 50)
		{
			set_game_var("side_selection", 1);
		}
		else
		{
			set_game_var("side_selection", 2);
		}
	}

	side_selection = get_game_var("side_selection");

	if (get_game_var("switchedsides"))
	{
		if (side_selection == 2)
		{
			side_selection = 1;
		}
		else
		{
			if (side_selection == 1)
			{
				side_selection = 2;
			}
		}
	}

	if (isdefined(player) && isdefined(player.team))
	{
		i = 0;

		while (isdefined(spawnpoints) && i < spawnpoints.size)
		{
			if (side_selection == 1)
			{
				if (player.team != "allies" && isdefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1)
				{
					arrayremovevalue(spawnpoints, spawnpoints[i]);
					i = 0;
				}
				else if (player.team == "allies" && isdefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2)
				{
					arrayremovevalue(spawnpoints, spawnpoints[i]);
					i = 0;
				}
				else
				{
					i++;
				}
			}
			else
			{
				if (player.team == "allies" && isdefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1)
				{
					arrayremovevalue(spawnpoints, spawnpoints[i]);
					i = 0;
				}
				else if (player.team != "allies" && isdefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2)
				{
					arrayremovevalue(spawnpoints, spawnpoints[i]);
					i = 0;
				}
				else
				{
					i++;
				}
			}
		}
	}

	if (!isdefined(self.playernum))
	{
		num = 0;
		players = get_players(self.team);

		for (num = 0; num < 4; num++)
		{
			valid_num = true;

			foreach (player in players)
			{
				if (player != self && isdefined(player.playernum) && player.playernum == num)
				{
					valid_num = false;
					break;
				}
			}

			if (valid_num)
			{
				break;
			}
		}

		self.playernum = num;
	}

	for (j = 0; j < spawnpoints.size; j++)
	{
		if (!isdefined(game[self.team + "_spawnpoints_randomized"]))
		{
			game[self.team + "_spawnpoints_randomized"] = 1;

			for (m = 0; m < spawnpoints.size; m++)
			{
				spawnpoints[m].en_num = m;
			}
		}

		if (spawnpoints[j].en_num == self.playernum)
		{
			return spawnpoints[j];
		}
	}

	return spawnpoints[0];
}

check_for_valid_spawn_near_team(revivee, return_struct)
{
	if (isDefined(level.check_for_valid_spawn_near_team_callback))
	{
		spawn_location = [[level.check_for_valid_spawn_near_team_callback]](revivee, return_struct);
		return spawn_location;
	}

	players = array_randomize(get_players());
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();
	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;

	if (spawn_points.size == 0)
	{
		return undefined;
	}

	for (i = 0; i < players.size; i++)
	{
		if (maps\mp\zombies\_zm_utility::is_player_valid(players[i], undefined, 1) && players[i] != self)
		{
			for (j = 0; j < spawn_points.size; j++)
			{
				if (isdefined(spawn_points[j].script_int))
				{
					ideal_distance = spawn_points[j].script_int;
				}
				else
				{
					ideal_distance = 1000;
				}

				if (spawn_points[j].locked == 0)
				{
					plyr_dist = distancesquared(players[i].origin, spawn_points[j].origin);

					if (plyr_dist < ideal_distance * ideal_distance)
					{
						if (plyr_dist < closest_distance)
						{
							closest_distance = plyr_dist;
							closest_group = j;
						}
					}
					else
					{
						if (plyr_dist < backup_distance)
						{
							backup_group = j;
							backup_distance = plyr_dist;
						}
					}
				}
			}
		}

		if (!isdefined(closest_group))
		{
			closest_group = backup_group;
		}

		if (isdefined(closest_group))
		{
			spawn_location = get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct);

			if (isdefined(spawn_location))
			{
				return spawn_location;
			}
		}
	}

	if (!is_true(self.player_initialized))
	{
		return undefined;
	}

	for (j = 0; j < spawn_points.size; j++)
	{
		if (isdefined(spawn_points[j].script_int))
		{
			ideal_distance = spawn_points[j].script_int;
		}
		else
		{
			ideal_distance = 1000;
		}

		if (spawn_points[j].locked == 0)
		{
			plyr_dist = distancesquared(self.origin, spawn_points[j].origin);

			if (plyr_dist < ideal_distance * ideal_distance)
			{
				if (plyr_dist < closest_distance)
				{
					closest_distance = plyr_dist;
					closest_group = j;
				}
			}
			else
			{
				if (plyr_dist < backup_distance)
				{
					backup_group = j;
					backup_distance = plyr_dist;
				}
			}
		}
	}

	if (!isdefined(closest_group))
	{
		closest_group = backup_group;
	}

	if (isdefined(closest_group))
	{
		spawn_location = get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct);

		if (isdefined(spawn_location))
		{
			return spawn_location;
		}
	}

	return undefined;
}

get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct)
{
	spawn_array = getstructarray(spawn_points[closest_group].target, "targetname");
	spawn_array = array_randomize(spawn_array);
	k = 0;

	while (k < spawn_array.size)
	{
		if (positionwouldtelefrag(spawn_array[k].origin))
		{
			k++;
			continue;
		}

		if (is_true(return_struct))
		{
			return spawn_array[k];
		}

		return spawn_array[k].origin;
	}

	if (is_true(return_struct))
	{
		return spawn_array[0];
	}

	return spawn_array[0].origin;
}

player_spawn_protection()
{
	self endon("disconnect");
	self endon("player_downed");
	self endon("meat_grabbed");
	self endon("meat_stink_player_start");

	self thread player_spawn_protection_timeout();

	self.spawn_protection = 1;

	for (x = 0; x < 60; x++)
	{
		self.ignoreme = 1;
		wait 0.05;
	}

	if (!isDefined(level.meat_player))
	{
		self.ignoreme = 0;
	}

	self.spawn_protection = 0;
	self notify("player_spawn_protection_end");
}

player_spawn_protection_timeout()
{
	self endon("disconnect");
	self endon("player_spawn_protection_end");

	self waittill_any("player_downed", "meat_grabbed", "meat_stink_player_start");

	self.spawn_protection = 0;
}

callback_playerdamage(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if (isDefined(eattacker) && isplayer(eattacker) && eattacker.sessionteam == self.sessionteam && !eattacker hasperk("specialty_noname") && isDefined(self.is_zombie) && !self.is_zombie)
	{
		self maps\mp\zombies\_zm::process_friendly_fire_callbacks(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex);

		if (self != eattacker)
		{
			return;
		}
		else if (smeansofdeath != "MOD_GRENADE_SPLASH" && smeansofdeath != "MOD_GRENADE" && smeansofdeath != "MOD_EXPLOSIVE" && smeansofdeath != "MOD_PROJECTILE" && smeansofdeath != "MOD_PROJECTILE_SPLASH" && smeansofdeath != "MOD_BURNED" && smeansofdeath != "MOD_SUICIDE")
		{
			return;
		}
	}

	if (is_true(level.pers_upgrade_insta_kill))
	{
		self maps\mp\zombies\_zm_pers_upgrades_functions::pers_insta_kill_melee_swipe(smeansofdeath, eattacker);
	}

	if (isDefined(self.overrideplayerdamage))
	{
		idamage = self [[self.overrideplayerdamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
	}
	else if (isDefined(level.overrideplayerdamage))
	{
		idamage = self [[level.overrideplayerdamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
	}

	if (is_true(self.magic_bullet_shield))
	{
		maxhealth = self.maxhealth;
		self.health += idamage;
		self.maxhealth = maxhealth;
	}

	if (isDefined(self.divetoprone) && self.divetoprone == 1)
	{
		if (smeansofdeath == "MOD_GRENADE_SPLASH")
		{
			dist = distance2d(vpoint, self.origin);

			if (dist > 32)
			{
				dot_product = vectordot(anglesToForward(self.angles), vdir);

				if (dot_product > 0)
				{
					idamage = int(idamage * 0.5);
				}
			}
		}
	}

	if (isDefined(level.prevent_player_damage))
	{
		if (self [[level.prevent_player_damage]](einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime))
		{
			return;
		}
	}

	idflags |= level.idflags_no_knockback;

	if (idamage > 0 && shitloc == "riotshield")
	{
		shitloc = "torso_upper";
	}

	self maps\mp\zombies\_zm::finishplayerdamagewrapper(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex);
}

player_damage_override(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	if (isDefined(level._game_module_player_damage_callback))
	{
		new_damage = self [[level._game_module_player_damage_callback]](einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);

		if (isDefined(new_damage))
		{
			idamage = new_damage;
		}
	}

	idamage = self maps\mp\zombies\_zm::check_player_damage_callbacks(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);

	if (is_true(self.use_adjusted_grenade_damage))
	{
		if (self hasperk("specialty_flakjacket"))
		{
			return 0;
		}

		if (self.health > idamage)
		{
			return idamage;
		}
	}

	if (!idamage)
	{
		return 0;
	}

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		return 0;
	}

	if (isDefined(einflictor))
	{
		if (is_true(einflictor.water_damage))
		{
			return 0;
		}
	}

	if (isDefined(eattacker) && is_true(eattacker.is_zombie) || isplayer(eattacker))
	{
		if (is_true(self.hasriotshield) && isDefined(vdir))
		{
			if (is_true(self.hasriotshieldequipped))
			{
				if (self maps\mp\zombies\_zm::player_shield_facing_attacker(vdir, 0.2) && isDefined(self.player_shield_apply_damage))
				{
					self [[self.player_shield_apply_damage]](100, 0);
					return 0;
				}
			}
			else if (!isDefined(self.riotshieldentity))
			{
				if (!self maps\mp\zombies\_zm::player_shield_facing_attacker(vdir, -0.2) && isDefined(self.player_shield_apply_damage))
				{
					self [[self.player_shield_apply_damage]](100, 0);
					return 0;
				}
			}
		}
	}

	if (isDefined(eattacker))
	{
		if (isDefined(self.ignoreattacker) && self.ignoreattacker == eattacker)
		{
			return 0;
		}

		if (is_true(self.is_zombie) && is_true(eattacker.is_zombie))
		{
			return 0;
		}

		if (is_true(eattacker.is_zombie))
		{
			self.ignoreattacker = eattacker;
			self thread maps\mp\zombies\_zm::remove_ignore_attacker();

			if (isDefined(eattacker.custom_damage_func))
			{
				idamage = eattacker [[eattacker.custom_damage_func]](self);
			}
			else if (isDefined(eattacker.meleedamage))
			{
				idamage = eattacker.meleedamage;
			}
			else
			{
				idamage = 50;
			}
		}
	}

	if (is_placeable_mine(sweapon) || sweapon == "freezegun_zm" || sweapon == "freezegun_upgraded_zm")
	{
		return 0;
	}

	// fix turrets damaging players
	if (sweapon == "zombie_bullet_crouch_zm")
	{
		return 0;
	}

	if (isDefined(self.player_damage_override))
	{
		self thread [[self.player_damage_override]](einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
	}

	if (smeansofdeath == "MOD_FALLING")
	{
		if (self hasperk("specialty_flakjacket"))
		{
			if (is_true(self.divetoprone))
			{
				if (isDefined(level.zombiemode_divetonuke_perk_func))
				{
					[[level.zombiemode_divetonuke_perk_func]](self, self.origin);
				}
			}

			return 0;
		}

		if (is_true(level.pers_upgrade_flopper))
		{
			if (self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_flopper_damage_check(smeansofdeath, idamage))
			{
				return 0;
			}
		}
	}

	if (smeansofdeath == "MOD_EXPLOSIVE")
	{
		if (sweapon != level.item_meat_name)
		{
			if (self hasperk("specialty_flakjacket"))
			{
				return 0;
			}
		}
	}

	if (smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH")
	{
		if (self hasperk("specialty_flakjacket"))
		{
			return 0;
		}

		if (is_true(level.pers_upgrade_flopper))
		{
			if (is_true(self.pers_upgrades_awarded["flopper"]))
			{
				return 0;
			}
		}

		if (sweapon == "slip_bolt_zm" || sweapon == "slip_bolt_upgraded_zm")
		{
			return 0;
		}

		if (sweapon == "willy_pete_zm")
		{
			return 0;
		}

		idamage = 75;

		if (sweapon == "titus6_explosive_dart_zm" || sweapon == "titus6_explosive_dart_upgraded_zm")
		{
			idamage = 15;
		}
	}

	finaldamage = idamage;

	if (isDefined(eattacker))
	{
		eattacker notify("hit_player");

		if (smeansofdeath != "MOD_FALLING")
		{
			self thread maps\mp\zombies\_zm::playswipesound(smeansofdeath, eattacker);

			if (is_true(eattacker.is_zombie) || isplayer(eattacker))
			{
				self playrumbleonentity("damage_heavy");
			}

			if (randomintrange(0, 1) == 0)
			{
				self thread maps\mp\zombies\_zm_audio::playerexert("hitmed");
			}
			else
			{
				self thread maps\mp\zombies\_zm_audio::playerexert("hitlrg");
			}
		}
	}

	if (idamage < self.health)
	{
		if (isDefined(eattacker) && isai(eattacker))
		{
			if (isDefined(level.custom_kill_damaged_vo))
			{
				eattacker thread [[level.custom_kill_damaged_vo]](self);
			}
			else
			{
				eattacker.sound_damage_player = self;
			}

			if (!is_true(eattacker.has_legs))
			{
				self maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "crawl_hit");
			}
			else if (isDefined(eattacker.animname) && eattacker.animname == "monkey_zombie")
			{
				self maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "monkey_hit");
			}
		}

		return finaldamage;
	}

	if (isDefined(eattacker))
	{
		if (isDefined(eattacker.animname) && eattacker.animname == "zombie_dog")
		{
			self maps\mp\zombies\_zm_stats::increment_client_stat("killed_by_zdog");
			self maps\mp\zombies\_zm_stats::increment_player_stat("killed_by_zdog");
		}
		else if (isDefined(eattacker.is_avogadro) && eattacker.is_avogadro)
		{
			self maps\mp\zombies\_zm_stats::increment_client_stat("killed_by_avogadro", 0);
			self maps\mp\zombies\_zm_stats::increment_player_stat("killed_by_avogadro");
		}
	}

	self thread maps\mp\zombies\_zm::clear_path_timers();

	if (level.intermission)
	{
		level waittill("forever");
	}

	if (level.scr_zm_ui_gametype == "zcleansed" && idamage > 0)
	{
		if ((!is_true(self.laststand) && !self maps\mp\zombies\_zm_laststand::player_is_in_laststand()) || !isDefined(self.last_player_attacker))
		{
			if (isDefined(eattacker) && isplayer(eattacker) && eattacker.team != self.team)
			{
				if (isDefined(eattacker.maxhealth) && is_true(eattacker.is_zombie))
				{
					eattacker.health = eattacker.maxhealth;
				}

				if (isDefined(level.player_kills_player))
				{
					self thread [[level.player_kills_player]](einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
				}
			}
		}
	}

	if (self hasperk("specialty_finalstand"))
	{
		if (isDefined(level.chugabud_laststand_func))
		{
			self thread [[level.chugabud_laststand_func]]();
			return 0;
		}
	}

	players = get_players();
	count = 0;

	for (i = 0; i < players.size; i++)
	{
		if (players[i] == self || players[i].is_zombie || players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() || players[i].sessionstate == "spectator")
		{
			count++;
		}
	}

	if (count < players.size || isDefined(level._game_module_game_end_check) && ![[level._game_module_game_end_check]]())
	{
		if (isDefined(self.solo_lives_given) && self.solo_lives_given < 3 && is_true(level.force_solo_quick_revive) && self hasperk("specialty_quickrevive"))
		{
			self thread maps\mp\zombies\_zm::wait_and_revive();
		}

		return finaldamage;
	}

	solo_death = self is_solo_death(players);
	non_solo_death = self is_non_solo_death(players, count);

	if ((solo_death || non_solo_death) && !is_true(level.no_end_game_check))
	{
		level notify("stop_suicide_trigger");
		self thread scripts\zm\replaced\_zm_laststand::playerlaststand(einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);

		if (!isDefined(vdir))
		{
			vdir = (1, 0, 0);
		}

		self fakedamagefrom(vdir);

		if (isDefined(level.custom_player_fake_death))
		{
			self thread [[level.custom_player_fake_death]](vdir, smeansofdeath);
		}
		else
		{
			self thread maps\mp\zombies\_zm::player_fake_death();
		}
	}

	if (count == players.size && !is_true(level.no_end_game_check))
	{
		if (players.size == 1 && flag("solo_game"))
		{
			if (solo_death)
			{
				self.lives = 0;
				level notify("pre_end_game");
				wait_network_frame();

				if (flag("dog_round"))
				{
					maps\mp\zombies\_zm::increment_dog_round_stat("lost");
				}

				level notify("end_game");
			}
			else
			{
				return finaldamage;
			}
		}
		else
		{
			level notify("pre_end_game");
			wait_network_frame();

			if (flag("dog_round"))
			{
				maps\mp\zombies\_zm::increment_dog_round_stat("lost");
			}

			level notify("end_game");
		}

		return 0;
	}
	else
	{
		surface = "flesh";
		return finaldamage;
	}
}

is_solo_death(players)
{
	if (players.size == 1 && flag("solo_game"))
	{
		if (self.solo_lives_given >= 3)
		{
			return 1;
		}

		if (isDefined(self.e_chugabud_corpse))
		{
			return 0;
		}

		active_perks = 0;

		if (isDefined(self.perks_active))
		{
			active_perks = self.perks_active.size;
		}

		disabled_perks = 0;

		if (isDefined(self.disabled_perks))
		{
			disabled_perks = self.disabled_perks.size;
		}

		if (active_perks <= disabled_perks)
		{
			return 1;
		}
	}

	return 0;
}

is_non_solo_death(players, count)
{
	if (count > 1 || players.size == 1 && !flag("solo_game"))
	{
		return 1;
	}

	return 0;
}

callback_playerlaststand(einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	self endon("disconnect");
	[[scripts\zm\replaced\_zm_laststand::playerlaststand]](einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);
}

player_laststand(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	b_alt_visionset = 0;
	self allowjump(0);
	currweapon = self getcurrentweapon();
	statweapon = currweapon;

	if (is_alt_weapon(statweapon))
	{
		statweapon = weaponaltweaponname(statweapon);
	}

	self addweaponstat(statweapon, "deathsDuringUse", 1);

	if (is_true(self.hasperkspecialtytombstone))
	{
		self.laststand_perks = scripts\zm\replaced\_zm_tombstone::tombstone_save_perks(self);
	}

	if (isDefined(self.pers_upgrades_awarded["perk_lose"]) && self.pers_upgrades_awarded["perk_lose"])
	{
		self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}

	players = get_players();

	if (players.size == 1 && flag("solo_game"))
	{
		if (self.solo_lives_given < 3)
		{
			active_perks = 0;

			if (isDefined(self.perks_active))
			{
				active_perks = self.perks_active.size;
			}

			disabled_perks = 0;

			if (isDefined(self.disabled_perks))
			{
				disabled_perks = self.disabled_perks.size;
			}

			if (active_perks > disabled_perks || isDefined(self.e_chugabud_corpse))
			{
				self thread maps\mp\zombies\_zm::wait_and_revive();
			}
		}
	}

	if (self hasperk("specialty_additionalprimaryweapon"))
	{
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon = maps\mp\zombies\_zm::take_additionalprimaryweapon();
	}

	if (is_true(self.hasperkspecialtytombstone))
	{
		self [[level.tombstone_laststand_func]]();
		self thread [[level.tombstone_spawn_func]]();

		if (!is_true(self._retain_perks))
		{
			self.hasperkspecialtytombstone = undefined;
			self notify("specialty_scavenger_stop");
		}
	}

	self clear_is_drinking();
	self thread maps\mp\zombies\_zm::remove_deadshot_bottle();
	self thread maps\mp\zombies\_zm::remote_revive_watch();
	self maps\mp\zombies\_zm_score::player_downed_penalty();
	self disableoffhandweapons();
	self thread maps\mp\zombies\_zm::last_stand_grenade_save_and_return();

	if (smeansofdeath != "MOD_SUICIDE" && smeansofdeath != "MOD_FALLING")
	{
		if (!is_true(self.intermission))
		{
			self maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "revive_down");
		}
		else
		{
			if (isDefined(level.custom_player_death_vo_func) && !self [[level.custom_player_death_vo_func]]())
			{
				self maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "exert_death");
			}
		}
	}

	bbprint("zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "downed", self.origin);

	if (isDefined(level._zombie_minigun_powerup_last_stand_func))
	{
		self thread [[level._zombie_minigun_powerup_last_stand_func]]();
	}

	if (isDefined(level._zombie_tesla_powerup_last_stand_func))
	{
		self thread [[level._zombie_tesla_powerup_last_stand_func]]();
	}

	if (self hasperk("specialty_grenadepulldeath"))
	{
		b_alt_visionset = 1;

		if (isDefined(level.custom_laststand_func))
		{
			self thread [[level.custom_laststand_func]]();
		}
	}

	if (is_true(self.intermission))
	{
		bbprint("zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "died", self.origin);
		wait 0.5;
		self stopsounds();
		level waittill("forever");
	}

	if (!b_alt_visionset)
	{
		visionsetlaststand("zombie_last_stand", 1);
	}
}

last_stand_pistol_swap()
{
	if (self has_powerup_weapon())
	{
		self.lastactiveweapon = "none";
	}

	if (!self hasweapon(self.laststandpistol))
	{
		if (!is_weapon_upgraded(self.laststandpistol))
		{
			self giveweapon(self.laststandpistol);
		}
		else
		{
			self giveweapon(self.laststandpistol, 0, self get_pack_a_punch_weapon_options(self.laststandpistol));
		}
	}

	amt = 0;
	ammoclip = weaponclipsize(self.laststandpistol);
	doubleclip = ammoclip * 2;
	dual_wield_wep = weapondualwieldweaponname(self.laststandpistol);

	if (dual_wield_wep != "none")
	{
		ammoclip += weaponclipsize(dual_wield_wep);
		doubleclip = ammoclip;
	}

	if (is_true(self._special_solo_pistol_swap) || self.laststandpistol == level.default_solo_laststandpistol && !self.hadpistol)
	{
		self._special_solo_pistol_swap = 0;
		self.hadpistol = 0;
		amt = ammoclip;
	}
	else if (flag("solo_game") && self.laststandpistol == level.default_solo_laststandpistol)
	{
		amt = ammoclip;
	}
	else if (self.laststandpistol == level.default_laststandpistol)
	{
		amt = ammoclip + doubleclip;
	}
	else if (self.laststandpistol == "ray_gun_zm" || self.laststandpistol == "ray_gun_upgraded_zm" || self.laststandpistol == "raygun_mark2_zm" || self.laststandpistol == "raygun_mark2_upgraded_zm" || self.laststandpistol == level.default_solo_laststandpistol)
	{
		amt = ammoclip;

		if (self.hadpistol && amt > self.stored_weapon_info[self.laststandpistol].total_amt)
		{
			amt = self.stored_weapon_info[self.laststandpistol].total_amt;
		}

		self.stored_weapon_info[self.laststandpistol].given_amt = amt;
	}
	else
	{
		amt = ammoclip + doubleclip;

		if (self.hadpistol && amt > self.stored_weapon_info[self.laststandpistol].total_amt)
		{
			amt = self.stored_weapon_info[self.laststandpistol].total_amt;
		}

		self.stored_weapon_info[self.laststandpistol].given_amt = amt;
	}

	clip_amt_init = 0;
	left_clip_amt_init = 0;

	if (self.hadpistol)
	{
		clip_amt_init = self.stored_weapon_info[self.laststandpistol].clip_amt;

		if (dual_wield_wep != "none")
		{
			left_clip_amt_init = self.stored_weapon_info[self.laststandpistol].left_clip_amt;
		}

		amt -= clip_amt_init + left_clip_amt_init;
	}

	clip_amt_add = weaponclipsize(self.laststandpistol) - clip_amt_init;

	if (clip_amt_add > amt)
	{
		clip_amt_add = amt;
	}

	self setweaponammoclip(self.laststandpistol, clip_amt_init + clip_amt_add);

	amt -= clip_amt_add;

	if (dual_wield_wep != "none")
	{
		left_clip_amt_add = weaponclipsize(dual_wield_wep) - left_clip_amt_init;

		if (left_clip_amt_add > amt)
		{
			left_clip_amt_add = amt;
		}

		self scripts\zm\_zm_reimagined::set_weapon_ammo_clip_left(self.laststandpistol, left_clip_amt_init + left_clip_amt_add);

		amt -= left_clip_amt_add;
	}

	stock_amt = doubleclip;

	if (stock_amt > amt)
	{
		stock_amt = amt;
	}

	self setweaponammostock(self.laststandpistol, stock_amt);

	self switchtoweapon(self.laststandpistol);
}

last_stand_restore_pistol_ammo(only_store_info = false)
{
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;

	if (!isDefined(self.stored_weapon_info))
	{
		return;
	}

	weapon_inventory = self getweaponslist(1);
	weapon_to_restore = getarraykeys(self.stored_weapon_info);
	i = 0;

	while (i < weapon_inventory.size)
	{
		weapon = weapon_inventory[i];

		if (weapon != self.laststandpistol)
		{
			i++;
			continue;
		}

		for (j = 0; j < weapon_to_restore.size; j++)
		{
			check_weapon = weapon_to_restore[j];

			if (weapon == check_weapon)
			{
				dual_wield_name = weapondualwieldweaponname(weapon);

				if (self.stored_weapon_info[weapon].given_amt == 0)
				{
					self setweaponammoclip(weapon, self.stored_weapon_info[weapon].clip_amt);

					if ("none" != dual_wield_name)
					{
						self scripts\zm\_zm_reimagined::set_weapon_ammo_clip_left(weapon, self.stored_weapon_info[weapon].left_clip_amt);
					}

					self setweaponammostock(weapon, self.stored_weapon_info[weapon].stock_amt);

					break;
				}

				last_clip = self getweaponammoclip(weapon);
				last_left_clip = 0;

				if ("none" != dual_wield_name)
				{
					last_left_clip = self getweaponammoclip(dual_wield_name);
				}

				last_stock = self getweaponammostock(weapon);
				last_total = last_clip + last_left_clip + last_stock;

				self.stored_weapon_info[weapon].used_amt = self.stored_weapon_info[weapon].given_amt - last_total;

				if (only_store_info)
				{
					break;
				}

				used_amt = self.stored_weapon_info[weapon].used_amt;

				if (used_amt >= self.stored_weapon_info[weapon].stock_amt)
				{
					used_amt -= self.stored_weapon_info[weapon].stock_amt;
					self.stored_weapon_info[weapon].stock_amt = 0;

					if ("none" != dual_wield_name)
					{
						if (used_amt >= self.stored_weapon_info[weapon].left_clip_amt)
						{
							used_amt -= self.stored_weapon_info[weapon].left_clip_amt;
							self.stored_weapon_info[weapon].left_clip_amt = 0;

							if (used_amt >= self.stored_weapon_info[weapon].clip_amt)
							{
								used_amt -= self.stored_weapon_info[weapon].clip_amt;
								self.stored_weapon_info[weapon].clip_amt = 0;
							}
							else
							{
								self.stored_weapon_info[weapon].clip_amt -= used_amt;
							}
						}
						else
						{
							self.stored_weapon_info[weapon].left_clip_amt -= used_amt;
						}
					}
					else
					{
						if (used_amt >= self.stored_weapon_info[weapon].clip_amt)
						{
							used_amt -= self.stored_weapon_info[weapon].clip_amt;
							self.stored_weapon_info[weapon].clip_amt = 0;
						}
						else
						{
							self.stored_weapon_info[weapon].clip_amt -= used_amt;
						}
					}
				}
				else
				{
					self.stored_weapon_info[weapon].stock_amt -= used_amt;
				}

				self setweaponammoclip(weapon, self.stored_weapon_info[weapon].clip_amt);

				if ("none" != dual_wield_name)
				{
					self scripts\zm\_zm_reimagined::set_weapon_ammo_clip_left(weapon, self.stored_weapon_info[weapon].left_clip_amt);
				}

				self setweaponammostock(weapon, self.stored_weapon_info[weapon].stock_amt);

				break;
			}
		}

		i++;
	}
}

wait_and_revive()
{
	flag_set("wait_and_revive");

	if (isDefined(self.waiting_to_revive) && self.waiting_to_revive == 1)
	{
		return;
	}

	if (is_true(self.pers_upgrades_awarded["perk_lose"]))
	{
		self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}

	self.waiting_to_revive = 1;

	if (isDefined(level.exit_level_func))
	{
		self thread [[level.exit_level_func]]();
	}
	else if (get_players().size == 1)
	{
		self thread maps\mp\zombies\_zm::default_exit_level();
	}

	solo_revive_time = 10;
	self.revive_hud.y = -160;
	self.revive_hud settext(&"ZOMBIE_REVIVING");
	self maps\mp\zombies\_zm_laststand::revive_hud_show_n_fade(solo_revive_time);

	if (!isDefined(self.beingrevivedprogressbar))
	{
		self.beingrevivedprogressbar = self createprimaryprogressbar();
		self.beingrevivedprogressbar setpoint("CENTER", undefined, level.primaryprogressbarx, -1 * level.primaryprogressbary);
		self.beingrevivedprogressbar.bar.color = (0.5, 0.5, 1);
		self.beingrevivedprogressbar.hidewheninmenu = 1;
		self.beingrevivedprogressbar.bar.hidewheninmenu = 1;
		self.beingrevivedprogressbar.barframe.hidewheninmenu = 1;
		self.beingrevivedprogressbar.sort = 1;
		self.beingrevivedprogressbar.bar.sort = 2;
		self.beingrevivedprogressbar.barframe.sort = 3;
		self.beingrevivedprogressbar.barframe destroy();
	}

	self.beingrevivedprogressbar updatebar(0.01, 1 / solo_revive_time);
	flag_wait_or_timeout("instant_revive", solo_revive_time);
	self.revive_hud settext("");

	if (isDefined(self.beingrevivedprogressbar))
	{
		self.beingrevivedprogressbar destroyelem();
	}

	flag_clear("wait_and_revive");
	self maps\mp\zombies\_zm_laststand::auto_revive(self);
	self.solo_lives_given++;

	self.waiting_to_revive = 0;

	if (is_true(self.pers_upgrades_awarded["perk_lose"]))
	{
		self thread maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_perk_lose_restore();
	}
}

player_revive_monitor()
{
	self endon("disconnect");
	self notify("stop_player_revive_monitor");
	self endon("stop_player_revive_monitor");

	while (1)
	{
		self waittill("player_revived", reviver);
		self playsoundtoplayer("zmb_character_revived", self);

		if (isDefined(level.isresetting_grief) && level.isresetting_grief)
		{
			continue;
		}

		bbprint("zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "revived", self.origin);

		if (isDefined(reviver))
		{
			self maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "revive_up");

			if (reviver != self)
			{
				points = self.score_lost_when_downed;
				reviver maps\mp\zombies\_zm_score::player_add_points("reviver", points);
			}

			self.score_lost_when_downed = 0;
		}
	}
}

player_out_of_playable_area_monitor()
{
	self notify("stop_player_out_of_playable_area_monitor");
	self endon("stop_player_out_of_playable_area_monitor");
	self endon("disconnect");
	level endon("end_game");

	while (!isdefined(self.characterindex))
	{
		wait 0.05;
	}

	wait(0.15 * self.characterindex);

	while (true)
	{
		if (self.sessionstate == "spectator")
		{
			wait(get_player_out_of_playable_area_monitor_wait_time());
			continue;
		}

		if (is_true(level.hostmigration_occured))
		{
			wait(get_player_out_of_playable_area_monitor_wait_time());
			continue;
		}

		if (get_players().size == 1 && flag("solo_game") && (isdefined(self.waiting_to_revive) && self.waiting_to_revive))
		{
			wait(get_player_out_of_playable_area_monitor_wait_time());
			continue;
		}

		if (!self in_life_brush() && (self in_kill_brush() || !self in_enabled_playable_area()))
		{
			if (!isdefined(level.player_out_of_playable_area_monitor_callback) || self [[level.player_out_of_playable_area_monitor_callback]]())
			{
				self maps\mp\zombies\_zm_stats::increment_map_cheat_stat("cheat_out_of_playable");
				self maps\mp\zombies\_zm_stats::increment_client_stat("cheat_out_of_playable", 0);
				self maps\mp\zombies\_zm_stats::increment_client_stat("cheat_total", 0);
				self playlocalsound(level.zmb_laugh_alias);
				wait 0.5;

				self.lives = 0;
				self dodamage(self.health + 1000, self.origin);

				if (isDefined(level.player_suicide_func))
				{
					wait 0.05;
					self thread [[level.player_suicide_func]]();
				}
				else
				{
					self.bleedout_time = 0;
				}
			}
		}

		wait(get_player_out_of_playable_area_monitor_wait_time());
	}
}

get_player_out_of_playable_area_monitor_wait_time()
{
	return 1;
}

player_too_many_weapons_monitor()
{
	self notify("stop_player_too_many_weapons_monitor");
	self endon("stop_player_too_many_weapons_monitor");
	self endon("disconnect");
	level endon("end_game");
	scalar = self.characterindex;

	if (!isdefined(scalar))
	{
		scalar = self getentitynumber();
	}

	wait(0.15 * scalar);

	while (true)
	{
		if (self has_powerup_weapon() || self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || self.sessionstate == "spectator")
		{
			wait(get_player_too_many_weapons_monitor_wait_time());
			continue;
		}

		weapon_limit = get_player_weapon_limit(self);
		primaryweapons = self getweaponslistprimaries();

		if (primaryweapons.size > weapon_limit)
		{
			self maps\mp\zombies\_zm_weapons::take_fallback_weapon();
			primaryweapons = self getweaponslistprimaries();
		}

		primary_weapons_to_take = [];

		for (i = 0; i < primaryweapons.size; i++)
		{
			if (maps\mp\zombies\_zm_weapons::is_weapon_included(primaryweapons[i]) || maps\mp\zombies\_zm_weapons::is_weapon_upgraded(primaryweapons[i]))
			{
				primary_weapons_to_take[primary_weapons_to_take.size] = primaryweapons[i];
			}
		}

		if (primary_weapons_to_take.size > weapon_limit)
		{
			if (!isdefined(level.player_too_many_weapons_monitor_callback) || self [[level.player_too_many_weapons_monitor_callback]](primary_weapons_to_take))
			{
				self maps\mp\zombies\_zm_stats::increment_map_cheat_stat("cheat_too_many_weapons");
				self maps\mp\zombies\_zm_stats::increment_client_stat("cheat_too_many_weapons", 0);
				self maps\mp\zombies\_zm_stats::increment_client_stat("cheat_total", 0);
				self takeweapon(primary_weapons_to_take[primary_weapons_to_take.size - 1]);
			}
		}

		wait(get_player_too_many_weapons_monitor_wait_time());
	}
}

get_player_too_many_weapons_monitor_wait_time()
{
	return 1;
}

end_game()
{
	level waittill("end_game");
	maps\mp\zombies\_zm::check_end_game_intermission_delay();

	if (level.script != "zm_nuked")
	{
		clientnotify("zesn");

		if (isDefined(level.sndgameovermusicoverride))
		{
			level thread maps\mp\zombies\_zm_audio::change_zombie_music(level.sndgameovermusicoverride);
		}
		else
		{
			level thread maps\mp\zombies\_zm_audio::change_zombie_music("game_over");
		}
	}

	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		setclientsysstate("lsm", "0", players[i]);
	}

	for (i = 0; i < players.size; i++)
	{
		players[i] enableInvulnerability();

		if (players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			players[i] recordplayerdeathzombies();
			players[i] maps\mp\zombies\_zm_stats::increment_player_stat("deaths");
			players[i] maps\mp\zombies\_zm_stats::increment_client_stat("deaths");
			players[i] maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
		}

		if (isdefined(players[i].revivetexthud))
		{
			players[i].revivetexthud destroy();
		}
	}

	stopallrumbles();
	level.intermission = 1;
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
	level.zombie_vars["zombie_powerup_point_doubler_time"] = 0;
	wait 0.1;
	game_over = [];
	survived = [];
	players = get_players();

	if (!isDefined(level._supress_survived_screen))
	{
		for (i = 0; i < players.size; i++)
		{
			if (isDefined(level.custom_game_over_hud_elem))
			{
				game_over[i] = [[level.custom_game_over_hud_elem]](players[i]);
			}
			else
			{
				game_over[i] = newclienthudelem(players[i]);
				game_over[i].alignx = "center";
				game_over[i].aligny = "middle";
				game_over[i].horzalign = "center";
				game_over[i].vertalign = "middle";
				game_over[i].y -= 130;
				game_over[i].foreground = 1;
				game_over[i].fontscale = 3;
				game_over[i].alpha = 0;
				game_over[i].color = (1, 1, 1);
				game_over[i].hidewheninmenu = 1;
				game_over[i] settext(&"ZOMBIE_GAME_OVER");
				game_over[i] fadeovertime(1);
				game_over[i].alpha = 1;
			}

			survived[i] = newclienthudelem(players[i]);
			survived[i].alignx = "center";
			survived[i].aligny = "middle";
			survived[i].horzalign = "center";
			survived[i].vertalign = "middle";
			survived[i].y -= 100;
			survived[i].foreground = 1;
			survived[i].fontscale = 2;
			survived[i].alpha = 0;
			survived[i].color = (1, 1, 1);
			survived[i].hidewheninmenu = 1;

			if (level.round_number < 2)
			{
				if (level.script == "zombie_moon")
				{
					if (!isDefined(level.left_nomans_land))
					{
						nomanslandtime = level.nml_best_time;
						player_survival_time = int(nomanslandtime / 1000);
						player_survival_time_in_mins = maps\mp\zombies\_zm::to_mins(player_survival_time);
						survived[i] settext(&"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins);
					}
					else if (level.left_nomans_land == 2)
					{
						survived[i] settext(&"ZOMBIE_SURVIVED_ROUND");
					}
				}
				else
				{
					survived[i] settext(&"ZOMBIE_SURVIVED_ROUND");
				}
			}
			else
			{
				survived[i] settext(&"ZOMBIE_SURVIVED_ROUNDS", level.round_number);
			}

			survived[i] fadeovertime(1);
			survived[i].alpha = 1;
		}
	}

	if (isDefined(level.custom_end_screen))
	{
		level [[level.custom_end_screen]]();
	}

	for (i = 0; i < players.size; i++)
	{
		players[i] setclientammocounterhide(1);
		players[i] setclientminiscoreboardhide(1);
	}

	uploadstats();
	maps\mp\zombies\_zm_stats::update_players_stats_at_match_end(players);
	maps\mp\zombies\_zm_stats::update_global_counters_on_match_end();
	wait 1;
	wait 3.95;
	players = get_players();

	foreach (player in players)
	{
		if (isdefined(player.sessionstate) && player.sessionstate == "spectator")
		{
			player.sessionstate = "playing";
		}
	}

	wait 0.05;
	players = get_players();

	if (!isDefined(level._supress_survived_screen))
	{
		for (i = 0; i < players.size; i++)
		{
			survived[i] destroy();
			game_over[i] destroy();
		}
	}

	for (i = 0; i < players.size; i++)
	{
		if (isDefined(players[i].survived_hud))
		{
			players[i].survived_hud destroy();
		}

		if (isDefined(players[i].game_over_hud))
		{
			players[i].game_over_hud destroy();
		}
	}

	maps\mp\zombies\_zm::intermission();
	wait level.zombie_vars["zombie_intermission_time"];
	level notify("stop_intermission");
	array_thread(get_players(), maps\mp\zombies\_zm::player_exit_level);
	bbprint("zombie_epilogs", "rounds %d", level.round_number);
	wait 1.5;
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		players[i] cameraactivate(0);
	}

	exitlevel(0);
	wait 666;
}

check_quickrevive_for_hotjoin(disconnecting_player)
{
	if (level.scr_zm_ui_gametype == "zgrief")
	{
		return;
	}

	solo_mode = 0;
	subtract_num = 0;

	if (isdefined(disconnecting_player))
	{
		subtract_num = 1;
	}

	players = get_players();

	if (players.size - subtract_num == 1)
	{
		solo_mode = 1;
		flag_set("solo_game");
	}
	else
	{
		flag_clear("solo_game");
	}

	set_default_laststand_pistol(solo_mode);
}