#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_callbacksetup;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_gameobjects;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_globallogic_defaults;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_spawner;

rungametypeprecache(gamemode)
{
	if (is_encounter())
	{
		gamemode = "zgrief";
	}

	if (!isdefined(level.gamemode_map_location_main) || !isdefined(level.gamemode_map_location_main[gamemode]))
	{
		return;
	}

	if (isdefined(level.gamemode_map_precache))
	{
		if (isdefined(level.gamemode_map_precache[gamemode]))
		{
			[[level.gamemode_map_precache[gamemode]]]();
		}
	}

	if (isdefined(level.gamemode_map_location_precache))
	{
		if (isdefined(level.gamemode_map_location_precache[gamemode]))
		{
			loc = getdvar("ui_zm_mapstartlocation");

			if (loc == "" && isdefined(level.default_start_location))
			{
				loc = level.default_start_location;
			}

			if (isdefined(level.gamemode_map_location_precache[gamemode][loc]))
			{
				[[level.gamemode_map_location_precache[gamemode][loc]]]();
			}
		}
	}

	if (isdefined(level.precachecustomcharacters))
	{
		self [[level.precachecustomcharacters]]();
	}
}

rungametypemain(gamemode, mode_main_func, use_round_logic)
{
	if (is_encounter())
	{
		gamemode = "zgrief";
	}

	if (!isdefined(level.gamemode_map_location_main) || !isdefined(level.gamemode_map_location_main[gamemode]))
	{
		return;
	}

	level thread game_objects_allowed(get_gamemode_var("mode"), get_gamemode_var("location"));

	if (isdefined(level.gamemode_map_main))
	{
		if (isdefined(level.gamemode_map_main[gamemode]))
		{
			level thread [[level.gamemode_map_main[gamemode]]]();
		}
	}

	if (isdefined(level.gamemode_map_location_main))
	{
		if (isdefined(level.gamemode_map_location_main[gamemode]))
		{
			loc = getdvar("ui_zm_mapstartlocation");

			if (loc == "" && isdefined(level.default_start_location))
			{
				loc = level.default_start_location;
			}

			if (isdefined(level.gamemode_map_location_main[gamemode][loc]))
			{
				level thread [[level.gamemode_map_location_main[gamemode][loc]]]();
			}
		}
	}

	if (isdefined(mode_main_func))
	{
		if (isdefined(use_round_logic) && use_round_logic)
		{
			level thread round_logic(mode_main_func);
		}
		else
		{
			level thread non_round_logic(mode_main_func);
		}
	}

	level thread game_end_func();
}

game_objects_allowed(mode, location)
{
	if (is_encounter())
	{
		mode = "zgrief";
	}

	allowed[0] = mode;
	entities = getentarray();

	foreach (entity in entities)
	{
		if (isdefined(entity.script_gameobjectname))
		{
			isallowed = maps\mp\gametypes_zm\_gameobjects::entity_is_allowed(entity, allowed);
			isvalidlocation = maps\mp\gametypes_zm\_gameobjects::location_is_allowed(entity, location);

			if (!isallowed || !isvalidlocation && !is_classic())
			{
				if (isdefined(entity.spawnflags) && entity.spawnflags == 1)
				{
					if (isdefined(entity.classname) && entity.classname != "trigger_multiple")
					{
						entity connectpaths();
					}
				}

				entity delete();
				continue;
			}

			if (isdefined(entity.script_vector))
			{
				entity moveto(entity.origin + entity.script_vector, 0.05);
				entity waittill("movedone");

				if (isdefined(entity.spawnflags) && entity.spawnflags == 1)
				{
					entity disconnectpaths();
				}

				continue;
			}

			if (isdefined(entity.spawnflags) && entity.spawnflags == 1)
			{
				if (isdefined(entity.classname) && entity.classname != "trigger_multiple")
				{
					entity connectpaths();
				}
			}
		}
	}
}

post_init_gametype()
{
	gametype = level.scr_zm_ui_gametype;

	if (is_encounter())
	{
		gametype = "zgrief";
	}

	if (isdefined(level.gamemode_map_postinit))
	{
		if (isdefined(level.gamemode_map_postinit[gametype]))
		{
			[[level.gamemode_map_postinit[gametype]]]();
		}
	}
}

onspawnplayer(predictedspawn)
{
	if (!isDefined(predictedspawn))
	{
		predictedspawn = 0;
	}

	pixbeginevent("ZSURVIVAL:onSpawnPlayer");
	self.usingobj = undefined;
	self.is_zombie = 0;

	if (isDefined(level.custom_spawnplayer) && is_true(self.player_initialized))
	{
		self [[level.custom_spawnplayer]]();
		return;
	}

	if (isDefined(level.customspawnlogic))
	{
		self [[level.customspawnlogic]](predictedspawn);

		if (predictedspawn)
		{
			return;
		}
	}
	else
	{
		if (!is_encounter() && flag("begin_spawning"))
		{
			spawnpoint = maps\mp\zombies\_zm::check_for_valid_spawn_near_team(self, 1);
		}

		if (!isdefined(spawnpoint))
		{
			gametype = level.scr_zm_ui_gametype;
			location = level.scr_zm_map_start_location;

			if (is_encounter())
			{
				gametype = "zgrief";
			}

			if ((location == "default" || location == "") && isDefined(level.default_start_location))
			{
				location = level.default_start_location;
			}

			match_string = gametype + "_" + location;
			spawnpoints = [];
			structs = getstructarray("initial_spawn", "script_noteworthy");

			if (isdefined(structs))
			{
				for (i = 0; i < structs.size; i++)
				{
					if (isdefined(structs[i].script_string))
					{
						tokens = strtok(structs[i].script_string, " ");

						foreach (token in tokens)
						{
							if (token == match_string)
							{
								spawnpoints[spawnpoints.size] = structs[i];
							}
						}
					}
				}
			}
		}

		if (!isDefined(spawnpoints) || spawnpoints.size == 0)
		{
			spawnpoints = getstructarray("initial_spawn_points", "targetname");
		}

		spawnpoint = maps\mp\zombies\_zm::getfreespawnpoint(spawnpoints, self);

		if (predictedspawn)
		{
			self predictspawnpoint(spawnpoint.origin, spawnpoint.angles);
			return;
		}
		else
		{
			self spawn(spawnpoint.origin, spawnpoint.angles, "zsurvival");
		}
	}

	self.entity_num = self getentitynumber();
	self thread maps\mp\zombies\_zm::onplayerspawned();
	self thread maps\mp\zombies\_zm::player_revive_monitor();
	self freezecontrols(1);
	self.spectator_respawn = spawnpoint;
	self.score = self maps\mp\gametypes_zm\_globallogic_score::getpersstat("score");
	self.pers["participation"] = 0;

	self.score_total = self.score;
	self.old_score = self.score;
	self.player_initialized = 0;
	self.zombification_time = 0;
	self.enabletext = 1;
	self thread maps\mp\zombies\_zm_blockers::rebuild_barrier_reward_reset();

	if (!is_true(level.host_ended_game))
	{
		self freeze_player_controls(0);
		self enableweapons();
	}

	if (isDefined(level.game_mode_spawn_player_logic))
	{
		spawn_in_spectate = [[level.game_mode_spawn_player_logic]]();

		if (spawn_in_spectate)
		{
			self delay_thread(0.05, maps\mp\zombies\_zm::spawnspectator);
		}
	}

	pixendevent();
}

get_player_spawns_for_gametype()
{
	match_string = "";
	gametype = level.scr_zm_ui_gametype;
	location = level.scr_zm_map_start_location;

	if (is_encounter())
	{
		gametype = "zgrief";
	}

	if ((location == "default" || location == "") && isdefined(level.default_start_location))
	{
		location = level.default_start_location;
	}

	match_string = gametype + "_" + location;
	player_spawns = [];
	structs = getstructarray("player_respawn_point", "targetname");

	foreach (struct in structs)
	{
		if (isdefined(struct.script_string))
		{
			tokens = strtok(struct.script_string, " ");

			foreach (token in tokens)
			{
				if (token == match_string)
				{
					player_spawns[player_spawns.size] = struct;
				}
			}

			continue;
		}

		player_spawns[player_spawns.size] = struct;
	}

	return player_spawns;
}

onplayerspawned()
{
	level endon("end_game");
	self endon("disconnect");

	for (;;)
	{
		self waittill_either("spawned_player", "fake_spawned_player");

		if (isDefined(level.match_is_ending) && level.match_is_ending)
		{
			return;
		}

		if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			self thread maps\mp\zombies\_zm_laststand::auto_revive(self);
		}

		if (isDefined(level.custom_player_fake_death_cleanup))
		{
			self [[level.custom_player_fake_death_cleanup]]();
		}

		self setstance("stand");
		self.zmbdialogqueue = [];
		self.zmbdialogactive = 0;
		self.zmbdialoggroups = [];
		self.zmbdialoggroup = "";

		if (is_encounter())
		{
			if (self.team == "axis")
			{
				self.characterindex = 0;
				self._encounters_team = "A";
				self._team_name = &"ZOMBIE_RACE_TEAM_1";
			}
			else
			{
				self.characterindex = 1;
				self._encounters_team = "B";
				self._team_name = &"ZOMBIE_RACE_TEAM_2";
			}
		}

		self takeallweapons();

		if (isDefined(level.givecustomcharacters))
		{
			self [[level.givecustomcharacters]]();
		}

		weapons_restored = 0;

		if (isDefined(level.onplayerspawned_restore_previous_weapons))
		{
			weapons_restored = self [[level.onplayerspawned_restore_previous_weapons]]();
		}

		if (!is_true(weapons_restored))
		{
			self giveweapon("knife_zm");
			self give_start_weapon(1);
		}

		weapons_restored = 0;

		if (isDefined(level._team_loadout))
		{
			self giveweapon(level._team_loadout);
			self switchtoweapon(level._team_loadout);
		}

		if (isDefined(level.gamemode_post_spawn_logic))
		{
			self [[level.gamemode_post_spawn_logic]]();
		}
	}
}

menu_onmenuresponse()
{
	self endon("disconnect");

	for (;;)
	{
		self waittill("menuresponse", menu, response);

		if (response == "back")
		{
			self closemenu();
			self closeingamemenu();

			if (level.console)
			{
				if (menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"])
				{
					if (self.pers["team"] == "allies")
					{
						self openmenu(game["menu_class"]);
					}

					if (self.pers["team"] == "axis")
					{
						self openmenu(game["menu_class"]);
					}
				}
			}

			continue;
		}

		if (menu == game["menu_team"])
		{
			self closemenu();
			self closeingamemenu();
			self thread scripts\zm\_zm_reimagined::do_team_change();
			continue;
		}

		if (response == "changeclass_marines")
		{
			self closemenu();
			self closeingamemenu();
			self openmenu(game["menu_changeclass_allies"]);
			continue;
		}

		if (response == "changeclass_opfor")
		{
			self closemenu();
			self closeingamemenu();
			self openmenu(game["menu_changeclass_axis"]);
			continue;
		}

		if (response == "changeclass_wager")
		{
			self closemenu();
			self closeingamemenu();
			self openmenu(game["menu_changeclass_wager"]);
			continue;
		}

		if (response == "changeclass_custom")
		{
			self closemenu();
			self closeingamemenu();
			self openmenu(game["menu_changeclass_custom"]);
			continue;
		}

		if (response == "changeclass_barebones")
		{
			self closemenu();
			self closeingamemenu();
			self openmenu(game["menu_changeclass_barebones"]);
			continue;
		}

		if (response == "changeclass_marines_splitscreen")
		{
			self openmenu("changeclass_marines_splitscreen");
		}

		if (response == "changeclass_opfor_splitscreen")
		{
			self openmenu("changeclass_opfor_splitscreen");
		}

		if (response == "endgame")
		{
			if (self issplitscreen())
			{
				level.skipvote = 1;

				if (!(isdefined(level.gameended) && level.gameended))
				{
					self maps\mp\zombies\_zm_laststand::add_weighted_down();
					self maps\mp\zombies\_zm_stats::increment_client_stat("deaths");
					self maps\mp\zombies\_zm_stats::increment_player_stat("deaths");
					self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
					level.host_ended_game = 1;
					maps\mp\zombies\_zm_game_module::freeze_players(1);
					level notify("end_game");
				}
			}

			continue;
		}

		if (response == "restart_level_zm")
		{
			self maps\mp\zombies\_zm_laststand::add_weighted_down();
			self maps\mp\zombies\_zm_stats::increment_client_stat("deaths");
			self maps\mp\zombies\_zm_stats::increment_player_stat("deaths");
			self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
			missionfailed();
		}

		if (response == "killserverpc")
		{
			level thread maps\mp\gametypes_zm\_globallogic::killserverpc();
			continue;
		}

		if (response == "endround")
		{
			if (!(isdefined(level.gameended) && level.gameended))
			{
				self maps\mp\gametypes_zm\_globallogic::gamehistoryplayerquit();
				self maps\mp\zombies\_zm_laststand::add_weighted_down();
				self closemenu();
				self closeingamemenu();
				level.host_ended_game = 1;
				maps\mp\zombies\_zm_game_module::freeze_players(1);
				level notify("end_game");
			}

			continue;
		}

		if (menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_changeclass_wager"] || menu == game["menu_changeclass_custom"] || menu == game["menu_changeclass_barebones"])
		{
			self closemenu();
			self closeingamemenu();

			if (level.rankedmatch && issubstr(response, "custom"))
			{

			}

			self.selectedclass = 1;
			self [[level.class]](response);
		}
	}
}

hide_gump_loading_for_hotjoiners()
{
	self endon("disconnect");

	self.is_hotjoin = 1;

	if (isDefined(level.should_respawn_func) && [[level.should_respawn_func]]())
	{
		return;
	}

	self maps\mp\zombies\_zm::spawnspectator();

	if (is_true(level.intermission) || is_true(level.host_ended_game))
	{
		setclientsysstate("levelNotify", "zi", self);
		self setclientthirdperson(0);
		self resetfov();
		self.health = 100;
		self.sessionstate = "intermission";
	}
}