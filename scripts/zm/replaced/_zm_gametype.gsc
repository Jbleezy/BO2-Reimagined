#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

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
		location = level.scr_zm_map_start_location;

		if ((location == "default" || location == "") && isDefined(level.default_start_location))
		{
			location = level.default_start_location;
		}

		match_string = level.scr_zm_ui_gametype + "_" + location;
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
			self thread do_team_change();
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

do_team_change()
{
	teamplayers = get_players(self.pers["team"]).size;
	otherteamplayers = get_players(getotherteam(self.pers["team"])).size;

	if (teamplayers <= otherteamplayers)
	{
		self iprintln(&"MP_CANTJOINTEAM");
		return;
	}

	self.playernum = undefined;

	set_team(getotherteam(self.pers["team"]));

	if (!flag("initial_blackscreen_passed"))
	{
		self [[level.spawnplayer]]();
	}
}

set_team(team)
{
	if (team == "axis")
	{
		self.team = "axis";
		self.sessionteam = "axis";
		self.pers["team"] = "axis";
		self._encounters_team = "A";
		self.characterindex = 0;
	}
	else
	{
		self.team = "allies";
		self.sessionteam = "allies";
		self.pers["team"] = "allies";
		self._encounters_team = "B";
		self.characterindex = 1;
	}

	players = get_players();

	foreach (player in players)
	{
		if (player != self)
		{
			player luinotifyevent(&"hud_update_other_player_team_change");
		}
	}

	self [[level.givecustomcharacters]]();

	self.kills = 0;
	self.headshots = 0;
	self.downs = 0;
	self.revives = 0;
	self.killsconfirmed = 0;
	self.killsdenied = 0;
	self.captures = 0;

	if (level.scr_zm_ui_gametype_obj == "zsr" && flag("initial_blackscreen_passed") && !isdefined(level.gamemodulewinningteam))
	{
		if (isDefined(level.grief_score_hud_set_player_count_func))
		{
			allies_count = scripts\zm\zgrief\zgrief_reimagined::get_number_of_valid_players_team("allies");
			axis_count = scripts\zm\zgrief\zgrief_reimagined::get_number_of_valid_players_team("axis");

			[[level.grief_score_hud_set_player_count_func]]("allies", allies_count, "axis", axis_count);
		}
	}
}