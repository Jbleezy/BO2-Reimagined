#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

main()
{
	if (getDvar("g_gametype") != "zgrief")
	{
		return;
	}

	replaceFunc(maps\mp\zombies\_zm::getfreespawnpoint, scripts\zm\replaced\_zm::getfreespawnpoint);
	replaceFunc(maps\mp\zombies\_zm_audio_announcer::init_griefvox, scripts\zm\replaced\_zm_audio_announcer::init_griefvox);
	replaceFunc(maps\mp\zombies\_zm_blockers::handle_post_board_repair_rewards, scripts\zm\replaced\_zm_blockers::handle_post_board_repair_rewards);
	replaceFunc(maps\mp\zombies\_zm_game_module::wait_for_team_death_and_round_end, scripts\zm\replaced\_zm_game_module::wait_for_team_death_and_round_end);
	replaceFunc(maps\mp\zombies\_zm_game_module_meat_utility::init_item_meat, scripts\zm\replaced\_zm_game_module_meat_utility::init_item_meat);
	replaceFunc(maps\mp\gametypes_zm\_zm_gametype::onspawnplayer, scripts\zm\replaced\_zm_gametype::onspawnplayer);
	replaceFunc(maps\mp\gametypes_zm\_zm_gametype::onplayerspawned, scripts\zm\replaced\_zm_gametype::onplayerspawned);
	replaceFunc(maps\mp\gametypes_zm\_zm_gametype::menu_onmenuresponse, scripts\zm\replaced\_zm_gametype::menu_onmenuresponse);
	replaceFunc(maps\mp\gametypes_zm\zgrief::postinit_func, scripts\zm\replaced\zgrief::postinit_func);
	replaceFunc(maps\mp\gametypes_zm\zgrief::zgrief_main, scripts\zm\replaced\zgrief::zgrief_main);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_stink, scripts\zm\replaced\zgrief::meat_stink);
	replaceFunc(maps\mp\gametypes_zm\zmeat::create_item_meat_watcher, scripts\zm\replaced\zmeat::create_item_meat_watcher);
}

init()
{
	if (getDvar("g_gametype") != "zgrief")
	{
		return;
	}

	precacheshader("waypoint_target");
	precacheshader("white_waypoint_target");
	precacheshader("white_waypoint_capture");
	precacheshader("white_waypoint_defend");
	precacheshader("white_waypoint_contested");
	precacheshader("white_waypoint_grab");
	precacheshader("white_waypoint_kill");
	precacheshader("white_waypoint_escort");
	precacheshader("chalkmarks_hellcatraz_1");
	precacheshader("chalkmarks_hellcatraz_2");
	precacheshader("chalkmarks_hellcatraz_3");
	precacheshader("chalkmarks_hellcatraz_4");
	precacheshader("chalkmarks_hellcatraz_5");

	level._effect["human_disappears"] = loadfx("maps/zombie/fx_zmb_returned_spawn_puff");

	if (level.item_meat_name == "item_head_zm")
	{
		level.item_meat_status_icon_name = "menu_zm_weapons_item_head";
	}
	else
	{
		level.item_meat_status_icon_name = "menu_zm_weapons_item_meat";
	}

	precacheStatusIcon(level.item_meat_status_icon_name);

	setDvar("ui_scorelimit", 1);

	setteamscore("axis", 0);
	setteamscore("allies", 0);

	set_grief_vars();
	grief_setscoreboardcolumns_gametype();
	grief_gamemode_hud();
	grief_score_hud();
	enemy_powerup_hud();

	if (level.scr_zm_ui_gametype_obj == "zcontainment")
	{
		containment_init();
	}

	if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		meat_init();
	}

	level.dont_allow_meat_interaction = 1;
	level.can_revive_game_module = ::can_revive;
	level._powerup_grab_check = ::powerup_can_player_grab;
	level.meat_bounce_override = scripts\zm\replaced\zgrief::meat_bounce_override;
	level.autoassign = scripts\zm\replaced\_globallogic_ui::menuautoassign;
	level.custom_spectate_permissions = undefined;

	level.get_gamemode_display_name_func = ::get_gamemode_display_name;
	level.is_respawn_gamemode_func = ::is_respawn_gamemode;
	level.round_start_wait_func = ::round_start_wait;
	level.increment_score_func = ::increment_score;
	level.grief_score_hud_set_player_count_func = ::grief_score_hud_set_player_count;
	level.show_grief_hud_msg_func = ::show_grief_hud_msg;
	level.store_player_damage_info_func = ::store_player_damage_info;
	level.player_suicide_func = ::player_suicide;

	level thread grief_intro_msg();
	level thread round_start_wait(5, true);
	level thread remove_round_number();
	level thread unlimited_zombies();
	level thread unlimited_powerups();
	level thread save_teams_on_intermission();
	level thread all_voice_on_intermission();
}

grief_setscoreboardcolumns_gametype()
{
	if (level.scr_zm_ui_gametype_obj == "zcontainment" || level.scr_zm_ui_gametype_obj == "zmeat")
	{
		setscoreboardcolumns("score", "captures", "killsconfirmed", "downs", "revives");
	}
	else if (level.scr_zm_ui_gametype_obj == "zrace")
	{
		setscoreboardcolumns("score", "kills", "killsconfirmed", "downs", "revives");
	}
	else
	{
		setscoreboardcolumns("score", "killsdenied", "killsconfirmed", "downs", "revives");
	}
}

grief_gamemode_hud()
{
	level.grief_gamemode_hud = newHudElem();
	level.grief_gamemode_hud.alignx = "center";
	level.grief_gamemode_hud.aligny = "top";
	level.grief_gamemode_hud.horzalign = "user_center";
	level.grief_gamemode_hud.vertalign = "user_top";
	level.grief_gamemode_hud.y += 2;
	level.grief_gamemode_hud.fontscale = 1.2;
	level.grief_gamemode_hud.hidewheninmenu = 1;
	level.grief_gamemode_hud.foreground = 1;
	level.grief_gamemode_hud.alpha = 0;
	level.grief_gamemode_hud setText(get_gamemode_display_name());

	level thread grief_gamemode_hud_wait_and_show();
	level thread grief_gamemode_hud_destroy_on_intermission();
}

grief_gamemode_hud_wait_and_show()
{
	flag_wait("hud_visible");

	level.grief_gamemode_hud.alpha = 1;
}

grief_gamemode_hud_destroy_on_intermission()
{
	level waittill("intermission");

	level.grief_gamemode_hud destroy();
}

grief_score_hud()
{
	if (level.script == "zm_prison")
	{
		game["icons"]["axis"] = "faction_inmates";
		game["icons"]["allies"] = "faction_guards";
	}

	level.grief_score_hud = [];

	foreach (team1 in level.teams)
	{
		level.grief_score_hud[team1] = spawnStruct();

		foreach (team2 in level.teams)
		{
			level.grief_score_hud[team1].icon[team2] = newTeamHudElem(team1);
			level.grief_score_hud[team1].icon[team2].alignx = "center";
			level.grief_score_hud[team1].icon[team2].aligny = "top";
			level.grief_score_hud[team1].icon[team2].horzalign = "user_center";
			level.grief_score_hud[team1].icon[team2].vertalign = "user_top";
			level.grief_score_hud[team1].icon[team2].y += 16;
			level.grief_score_hud[team1].icon[team2].width = 32;
			level.grief_score_hud[team1].icon[team2].height = 32;
			level.grief_score_hud[team1].icon[team2].hidewheninmenu = 1;
			level.grief_score_hud[team1].icon[team2].foreground = 1;
			level.grief_score_hud[team1].icon[team2].alpha = 0;
			level.grief_score_hud[team1].icon[team2] setShader(game["icons"][team2], level.grief_score_hud[team1].icon[team2].width, level.grief_score_hud[team1].icon[team2].height);

			level.grief_score_hud[team1].score[team2] = newTeamHudElem(team1);
			level.grief_score_hud[team1].score[team2].alignx = "center";
			level.grief_score_hud[team1].score[team2].aligny = "top";
			level.grief_score_hud[team1].score[team2].horzalign = "user_center";
			level.grief_score_hud[team1].score[team2].vertalign = "user_top";
			level.grief_score_hud[team1].score[team2].y += 10;
			level.grief_score_hud[team1].score[team2].fontscale = 3.5;
			level.grief_score_hud[team1].score[team2].color = (0.21, 0, 0);
			level.grief_score_hud[team1].score[team2].hidewheninmenu = 1;
			level.grief_score_hud[team1].score[team2].foreground = 1;
			level.grief_score_hud[team1].score[team2].alpha = 0;
			level.grief_score_hud[team1].score[team2] setValue(0);

			if (team1 == team2)
			{
				level.grief_score_hud[team1].icon[team2].x -= 72.5;
				level.grief_score_hud[team1].score[team2].x -= 27.5;
			}
			else
			{
				level.grief_score_hud[team1].icon[team2].x += 72.5;
				level.grief_score_hud[team1].score[team2].x += 27.5;
			}

			level.grief_score_hud[team1].icon[team2] thread scripts\zm\_zm_reimagined::destroy_on_intermission();
			level.grief_score_hud[team1].score[team2] thread scripts\zm\_zm_reimagined::destroy_on_intermission();

			if (level.scr_zm_ui_gametype_obj == "zsnr" || level.scr_zm_ui_gametype_obj == "zcontainment")
			{
				level.grief_score_hud[team1].player_count[team2] = newTeamHudElem(team1);
				level.grief_score_hud[team1].player_count[team2].alignx = "center";
				level.grief_score_hud[team1].player_count[team2].aligny = "top";
				level.grief_score_hud[team1].player_count[team2].horzalign = "user_center";
				level.grief_score_hud[team1].player_count[team2].vertalign = "user_top";
				level.grief_score_hud[team1].player_count[team2].y += 50;
				level.grief_score_hud[team1].player_count[team2].width = 32;
				level.grief_score_hud[team1].player_count[team2].height = 32;
				level.grief_score_hud[team1].player_count[team2].color = (0.21, 0, 0);
				level.grief_score_hud[team1].player_count[team2].hidewheninmenu = 1;
				level.grief_score_hud[team1].player_count[team2].foreground = 1;
				level.grief_score_hud[team1].player_count[team2].archived = 0;
				level.grief_score_hud[team1].player_count[team2].alpha = 0;

				if (team1 == team2)
				{
					level.grief_score_hud[team1].player_count[team2].x -= 27.5;
				}
				else
				{
					level.grief_score_hud[team1].player_count[team2].x += 27.5;
				}

				level.grief_score_hud[team1].player_count[team2].og_x = level.grief_score_hud[team1].player_count[team2].x;

				level.grief_score_hud[team1].player_count[team2] thread scripts\zm\_zm_reimagined::destroy_on_end_game();
			}
		}

		if (level.scr_zm_ui_gametype_obj == "zcontainment" || level.scr_zm_ui_gametype_obj == "zmeat")
		{
			level.grief_score_hud[team1].obj_icon = newTeamHudElem(team1);
			level.grief_score_hud[team1].obj_icon.alignx = "center";
			level.grief_score_hud[team1].obj_icon.aligny = "top";
			level.grief_score_hud[team1].obj_icon.horzalign = "user_center";
			level.grief_score_hud[team1].obj_icon.vertalign = "user_top";
			level.grief_score_hud[team1].obj_icon.y += 50;
			level.grief_score_hud[team1].obj_icon.width = 20;
			level.grief_score_hud[team1].obj_icon.height = 20;
			level.grief_score_hud[team1].obj_icon.hidewheninmenu = 1;
			level.grief_score_hud[team1].obj_icon.foreground = 1;
			level.grief_score_hud[team1].obj_icon.archived = 0;
			level.grief_score_hud[team1].obj_icon.alpha = 0;
			level.grief_score_hud[team1].obj_icon setShader("waypoint_target", level.grief_score_hud[team1].obj_icon.width, level.grief_score_hud[team1].obj_icon.height);

			level.grief_score_hud[team1].obj_icon.og_x = level.grief_score_hud[team1].obj_icon.x;

			level.grief_score_hud[team1].obj_icon thread scripts\zm\_zm_reimagined::destroy_on_end_game();
		}
	}

	level thread grief_score_hud_wait_and_show();
}

grief_score_hud_wait_and_show()
{
	flag_wait("hud_visible");

	foreach (team1 in level.teams)
	{
		foreach (team2 in level.teams)
		{
			level.grief_score_hud[team1].icon[team2].alpha = 1;
			level.grief_score_hud[team1].score[team2].alpha = 1;
		}
	}
}

grief_score_hud_set_player_count(team, num = get_number_of_valid_players_team(team))
{
	foreach (team1 in level.teams)
	{
		if (num == 0)
		{
			level.grief_score_hud[team1].player_count[team].alpha = 0;
			continue;
		}

		level.grief_score_hud[team1].player_count[team].alpha = 1;

		offset = (4 - num) * (level.grief_score_hud[team1].player_count[team].width / 8);
		level.grief_score_hud[team1].player_count[team].x = level.grief_score_hud[team1].player_count[team].og_x + offset;

		level.grief_score_hud[team1].player_count[team] setShader("chalkmarks_hellcatraz_" + num, level.grief_score_hud[team1].player_count[team].width, level.grief_score_hud[team1].player_count[team].height);
	}
}

grief_score_hud_set_obj_icon(team)
{
	dist = 72.5;

	foreach (team1 in level.teams)
	{
		if (team == "none")
		{
			level.grief_score_hud[team1].obj_icon.alpha = 0;
			continue;
		}

		level.grief_score_hud[team1].obj_icon.alpha = 1;

		if (team == "neutral")
		{
			level.grief_score_hud[team1].obj_icon.x = level.grief_score_hud[team1].obj_icon.og_x;
			level.grief_score_hud[team1].obj_icon.color = (1, 1, 1);
		}
		else if (team == "contested")
		{
			level.grief_score_hud[team1].obj_icon.x = level.grief_score_hud[team1].obj_icon.og_x;
			level.grief_score_hud[team1].obj_icon.color = (1, 1, 0);
		}
		else if (team1 == team)
		{
			level.grief_score_hud[team1].obj_icon.x = level.grief_score_hud[team1].obj_icon.og_x - dist;
			level.grief_score_hud[team1].obj_icon.color = (0, 1, 0);
		}
		else
		{
			level.grief_score_hud[team1].obj_icon.x = level.grief_score_hud[team1].obj_icon.og_x + dist;
			level.grief_score_hud[team1].obj_icon.color = (1, 0, 0);
		}
	}
}

enemy_powerup_hud()
{
	registerclientfield("toplayer", "powerup_instant_kill_enemy", 1, 2, "int");
	registerclientfield("toplayer", "powerup_double_points_enemy", 1, 2, "int");

	powerup = level.zombie_powerups["insta_kill"];

	if (isdefined(powerup))
	{
		powerup.enemy_client_field_name = powerup.client_field_name + "_enemy";
	}

	powerup = level.zombie_powerups["double_points"];

	if (isdefined(powerup))
	{
		powerup.enemy_client_field_name = powerup.client_field_name + "_enemy";
	}
}

set_grief_vars()
{
	if (getDvar("ui_gametype_obj") == "")
	{
		setDvar("ui_gametype_obj", "zgrief zsnr zrace zcontainment zmeat");
	}

	if (getDvar("ui_gametype_obj_cur") != "")
	{
		level.scr_zm_ui_gametype_obj = getDvar("ui_gametype_obj_cur");
	}
	else
	{
		gamemodes = strTok(getDvar("ui_gametype_obj"), " ");
		level.scr_zm_ui_gametype_obj = random(gamemodes);
	}

	if (getDvar("ui_gametype_pro") == "")
	{
		setDvar("ui_gametype_pro", 0);
	}

	level.scr_zm_ui_gametype_pro = getDvarInt("ui_gametype_pro");

	if (getDvar("ui_gametype_team_change") == "")
	{
		if (isDedicated())
		{
			setDvar("ui_gametype_team_change", 0);
		}
		else
		{
			setDvar("ui_gametype_team_change", 1);
		}
	}

	level.allow_teamchange = getDvarInt("ui_gametype_team_change");

	if (getDvarInt("party_minplayers") < 2)
	{
		setDvar("party_minplayers", 2);
	}

	level.pregame_minplayers = getDvarInt("party_minplayers");

	level.snr_round_number = 1;
	setDvar("ui_round_number", level.snr_round_number);

	level.noroundnumber = 1;
	level.hide_revive_message = 1;
	level.custom_end_screen = ::custom_end_screen;
	level.game_module_onplayerconnect = ::grief_onplayerconnect;
	level.game_mode_custom_onplayerdisconnect = ::grief_onplayerdisconnect;
	level._game_module_player_damage_callback = ::game_module_player_damage_callback;
	level._game_module_player_laststand_callback = ::grief_laststand_weapon_save;
	level.onplayerspawned_restore_previous_weapons = ::grief_laststand_weapons_return;
	level.game_mode_spawn_player_logic = scripts\zm\replaced\zgrief::game_mode_spawn_player_logic;

	if (isDefined(level.zombie_weapons["knife_ballistic_zm"]))
	{
		level.zombie_weapons["knife_ballistic_zm"].is_in_box = 1;
	}

	if (isDefined(level.zombie_weapons["ray_gun_zm"]))
	{
		level.zombie_weapons["ray_gun_zm"].is_in_box = 1;
	}

	if (isDefined(level.zombie_weapons["raygun_mark2_zm"]))
	{
		level.zombie_weapons["raygun_mark2_zm"].is_in_box = 1;
	}

	level.grief_score = [];
	level.grief_score["A"] = 0;
	level.grief_score["B"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_insta_kill_time"] = 15;
	level.zombie_vars["allies"]["zombie_powerup_insta_kill_time"] = 15;
	level.zombie_vars["axis"]["zombie_powerup_point_doubler_time"] = 15;
	level.zombie_vars["allies"]["zombie_powerup_point_doubler_time"] = 15;
	level.zombie_vars["axis"]["zombie_powerup_point_halfer_on"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_point_halfer_time"] = 15;
	level.zombie_vars["allies"]["zombie_powerup_point_halfer_on"] = 0;
	level.zombie_vars["allies"]["zombie_powerup_point_halfer_time"] = 15;
	level.zombie_vars["axis"]["zombie_half_damage"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_half_damage_on"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_half_damage_time"] = 15;
	level.zombie_vars["allies"]["zombie_half_damage"] = 0;
	level.zombie_vars["allies"]["zombie_powerup_half_damage_on"] = 0;
	level.zombie_vars["allies"]["zombie_powerup_half_damage_time"] = 15;

	level.zombie_move_speed = 100;
	level.zombie_vars["zombie_health_start"] = 2500;
	level.zombie_vars["zombie_health_increase"] = 0;
	level.zombie_vars["zombie_health_increase_multiplier"] = 0;
	level.zombie_vars["zombie_spawn_delay"] = 0.5;
	level.brutus_health = 25000;
	level.brutus_expl_dmg_req = 15000;
	level.player_starting_points = 10000;

	level.zombie_vars["zombie_powerup_drop_increment"] = level.player_starting_points * 4;

	if (is_respawn_gamemode())
	{
		setDvar("player_lastStandBleedoutTime", 10);
	}
}

grief_onplayerconnect()
{
	self setclientdvar("ui_gametype_obj", level.scr_zm_ui_gametype_obj);
	self setclientdvar("ui_gametype_pro", level.scr_zm_ui_gametype_pro);
	self setclientdvar("ui_round_number", getdvarint("ui_round_number"));

	self thread on_player_spawned();
	self thread on_player_spectate();
	self thread on_player_downed();
	self thread on_player_bleedout();
	self thread on_player_revived();
	self thread head_icon();
	self thread obj_waypoint();
	self thread headstomp_watcher();
	self thread decrease_upgraded_start_weapon_ammo();
	self thread maps\mp\gametypes_zm\zmeat::create_item_meat_watcher();
	self.killsconfirmed = 0;
	self.killsdenied = 0;
	self.captures = 0;

	if (level.scr_zm_ui_gametype_obj != "zsnr")
	{
		self._retain_perks = 1;
	}

	if (level.scr_zm_ui_gametype_obj == "zrace")
	{
		self thread race_check_for_kills();
	}
}

grief_onplayerdisconnect(disconnecting_player)
{
	level endon("end_game");

	if (isDefined(disconnecting_player.head_icon))
	{
		if (isDefined(disconnecting_player.head_icon_origin))
		{
			disconnecting_player.head_icon_origin unlink();
			disconnecting_player.head_icon_origin delete();
		}

		disconnecting_player.head_icon destroy();
	}

	if (!isDefined(disconnecting_player.team) || (disconnecting_player.team != "axis" && disconnecting_player.team != "allies"))
	{
		return;
	}

	if (!flag("initial_blackscreen_passed"))
	{
		return;
	}

	if (isDefined(level.gamemodulewinningteam))
	{
		return;
	}

	if (isDefined(level.update_stats_func))
	{
		[[level.update_stats_func]](disconnecting_player);
	}

	if (level.scr_zm_ui_gametype_obj == "zgrief")
	{
		if (disconnecting_player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			increment_score(getOtherTeam(disconnecting_player.team));
		}
	}

	count = get_players(disconnecting_player.team).size - 1;

	if (count <= 0)
	{
		encounters_team = "A";

		if (getOtherTeam(disconnecting_player.team) == "allies")
		{
			encounters_team = "B";
		}

		scripts\zm\replaced\_zm_game_module::game_won(encounters_team);

		return;
	}

	team_var = "team_" + disconnecting_player.team;

	setDvar(team_var, getDvar(team_var) + disconnecting_player getguid() + " ");

	if (level.scr_zm_ui_gametype_obj == "zsnr")
	{
		level thread update_players_on_disconnect(disconnecting_player);
	}
}

on_player_spawned()
{
	level endon("end_game");
	self endon("disconnect");

	self.grief_initial_spawn = true;

	while (1)
	{
		self waittill("spawned_player");

		self.head_icon.alpha = 1;

		self thread scripts\zm\replaced\_zm::player_spawn_protection();

		if (self.grief_initial_spawn)
		{
			self.grief_initial_spawn = false;

			if (is_respawn_gamemode() && flag("start_zombie_round_logic"))
			{
				self thread wait_and_award_grenades();
			}
		}

		if (level.scr_zm_ui_gametype_obj == "zsnr")
		{
			// round_start_wait resets these
			self freezeControls(1);
			self enableInvulnerability();
		}

		if (level.scr_zm_ui_gametype_obj == "zcontainment")
		{
			self.in_containment_zone = undefined;
		}

		if (is_respawn_gamemode())
		{
			min_points = level.player_starting_points;

			if (min_points > 1500)
			{
				min_points = 1500;
			}

			if (self.score < min_points)
			{
				self.score = min_points;
			}
		}
	}
}

on_player_spectate()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("spawned_spectator");

		self.head_icon.alpha = 0;
	}
}

on_player_downed()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("entering_last_stand");

		self.head_icon.alpha = 0;
		self kill_feed();
		self add_grief_downed_score();

		if (level.scr_zm_ui_gametype_obj == "zrace")
		{
			increment_score(getOtherTeam(self.team), 10, 1, &"ZOMBIE_ZGRIEF_PLAYER_BLED_OUT_SCORE");
		}

		if (level.scr_zm_ui_gametype_obj == "zsnr")
		{
			level thread update_players_on_downed(self);
		}
	}
}

on_player_bleedout()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill_any("bled_out", "player_suicide");

		self.head_icon.alpha = 0;

		if (isDefined(level.zombie_last_stand_ammo_return))
		{
			self [[level.zombie_last_stand_ammo_return]](1);
		}

		if (level.scr_zm_ui_gametype_obj == "zgrief")
		{
			self add_grief_bleedout_score();
			increment_score(getOtherTeam(self.team));
		}

		if (level.scr_zm_ui_gametype_obj == "zsnr")
		{
			self.grief_savedweapon_weapons = undefined;
			self.init_player_offhand_weapons_override = 1;
			self init_player_offhand_weapons();
			self.init_player_offhand_weapons_override = undefined;
			self bleedout_feed();
			self add_grief_bleedout_score();
			level thread update_players_on_bleedout(self);
		}

		if (is_respawn_gamemode())
		{
			if (self.bleedout_time > 0)
			{
				wait self.bleedout_time;
				self.sessionstate = "playing";
			}

			self maps\mp\zombies\_zm::spectator_respawn();
			playfx(level._effect["human_disappears"], self.origin);
			playsoundatposition("evt_appear_3d", self.origin);
			earthquake(0.5, 0.75, self.origin, 100);
			playrumbleonposition("explosion_generic", self.origin);
		}
	}
}

on_player_revived()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("player_revived", reviver);

		self.head_icon.alpha = 1;

		if (isDefined(reviver) && reviver != self)
		{
			self revive_feed(reviver);

			if (level.scr_zm_ui_gametype_obj == "zrace")
			{
				increment_score(reviver.team, 5, 1, &"ZOMBIE_ZGRIEF_ALLY_REVIVED_SCORE");
			}

			if (level.scr_zm_ui_gametype_obj == "zsnr")
			{
				level thread update_players_on_revived(self, reviver);
			}
		}
	}
}

kill_feed()
{
	if (isDefined(self.last_griefed_by))
	{
		self.last_griefed_by.attacker.killsconfirmed++;

		// show weapon icon for melee damage
		if (self.last_griefed_by.meansofdeath == "MOD_MELEE")
		{
			self.last_griefed_by.meansofdeath = "MOD_UNKNOWN";

			// show melee weapon icon on Ballistic Knife w/ Bowie melee or Ballistic Knife w/ Galvaknuckles melee
			if (issubstr(self.last_griefed_by.weapon, "knife_ballistic_bowie"))
			{
				self.last_griefed_by.weapon = "held_bowie_knife_zm";
			}
			else if (issubstr(self.last_griefed_by.weapon, "knife_ballistic_no_melee"))
			{
				self.last_griefed_by.weapon = "held_tazer_knuckles_zm";
			}
		}

		// show weapon icon for impact damage
		if (self.last_griefed_by.meansofdeath == "MOD_IMPACT")
		{
			self.last_griefed_by.meansofdeath = "MOD_UNKNOWN";
		}

		// weapon icon only defined on held melee weapon
		if (is_melee_weapon(self.last_griefed_by.weapon))
		{
			self.last_griefed_by.weapon = get_held_melee_weapon(self.last_griefed_by.weapon);
		}

		// show BO2 MP Ballistic Knife icon (only defined on unupgraded Ballistic Knife)
		if (issubstr(self.last_griefed_by.weapon, "knife_ballistic"))
		{
			self.last_griefed_by.weapon = get_base_weapon_name(self.last_griefed_by.weapon, 1);
		}

		obituary(self, self.last_griefed_by.attacker, self.last_griefed_by.weapon, self.last_griefed_by.meansofdeath);
	}
	else if (isDefined(self.last_meated_by))
	{
		self.last_meated_by.attacker.killsconfirmed++;

		obituary(self, self.last_meated_by.attacker, level.item_meat_name, "MOD_UNKNOWN");
	}
	else if (isDefined(self.last_emped_by))
	{
		self.last_emped_by.attacker.killsconfirmed++;

		obituary(self, self.last_emped_by.attacker, "emp_grenade_zm", "MOD_GRENADE_SPLASH");
	}
	else
	{
		obituary(self, self, "none", "MOD_SUICIDE");
	}
}

bleedout_feed()
{
	obituary(self, self, "none", "MOD_CRUSH");
}

revive_feed(reviver)
{
	weapon = level.revive_tool;

	if (isdefined(self.revived_by_weapon))
	{
		weapon = self.revived_by_weapon;
		self.revived_by_weapon = undefined;
	}

	obituary(self, reviver, weapon, "MOD_UNKNOWN");
}

get_held_melee_weapon(melee_weapon)
{
	if (!issubstr(melee_weapon, "held_"))
	{
		melee_weapon = "held_" + melee_weapon;
	}

	return melee_weapon;
}

add_grief_downed_score()
{
	downed_by = undefined;

	if (isDefined(self.last_griefed_by))
	{
		downed_by = self.last_griefed_by;
	}
	else if (isDefined(self.last_meated_by))
	{
		downed_by = self.last_meated_by;
	}
	else if (isDefined(self.last_emped_by))
	{
		downed_by = self.last_emped_by;
	}

	if (isDefined(downed_by) && is_player_valid(downed_by.attacker))
	{
		score = 500 * maps\mp\zombies\_zm_score::get_points_multiplier(downed_by.attacker);
		downed_by.attacker maps\mp\zombies\_zm_score::add_to_player_score(score);
	}
}

add_grief_bleedout_score()
{
	players = get_players();

	foreach (player in players)
	{
		if (is_player_valid(player) && player.team != self.team)
		{
			score = 1000 * maps\mp\zombies\_zm_score::get_points_multiplier(player);
			player maps\mp\zombies\_zm_score::add_to_player_score(score);
		}
	}
}

head_icon()
{
	flag_wait("hud_visible");

	self.head_icon_origin = spawn("script_model", self.origin);
	self.head_icon_origin setmodel("tag_origin");
	self.head_icon_origin linkto(self);
	self thread head_icon_origin_think();

	self.head_icon = scripts\zm\replaced\_zm_gametype::head_icon_create();
}

head_icon_origin_think()
{
	self endon("disconnect");

	prev_stance = "none";

	while (isDefined(self.head_icon_origin))
	{
		cur_stance = self getStance();

		if (prev_stance != cur_stance)
		{
			prev_stance = cur_stance;

			self.head_icon_origin unlink();

			if (cur_stance == "stand" || !self isOnGround())
			{
				self.head_icon_origin.origin = self.origin + (0, 0, 72);
			}
			else if (cur_stance == "crouch")
			{
				self.head_icon_origin.origin = self.origin + (0, 0, 52);
			}
			else if (cur_stance == "prone")
			{
				self.head_icon_origin.origin = self.origin + (0, 0, 23);
			}

			self.head_icon_origin linkto(self);
		}

		wait 0.05;
	}
}

obj_waypoint()
{
	if (level.scr_zm_ui_gametype_obj == "zcontainment" || level.scr_zm_ui_gametype_obj == "zmeat")
	{
		self.obj_waypoint = newClientHudElem(self);
		self.obj_waypoint.alignx = "center";
		self.obj_waypoint.aligny = "middle";
		self.obj_waypoint.horzalign = "user_center";
		self.obj_waypoint.vertalign = "user_center";
		self.obj_waypoint.alpha = 0;
		self.obj_waypoint.hidewheninmenu = 1;
	}

	if (level.scr_zm_ui_gametype_obj == "zcontainment")
	{
		self.next_obj_waypoint = newClientHudElem(self);
		self.next_obj_waypoint.alignx = "center";
		self.next_obj_waypoint.aligny = "middle";
		self.next_obj_waypoint.horzalign = "user_center";
		self.next_obj_waypoint.vertalign = "user_center";
		self.next_obj_waypoint.color = (0.5, 0.5, 0.5);
		self.next_obj_waypoint.archived = 0;
		self.next_obj_waypoint.alpha = 0;
		self.next_obj_waypoint.hidewheninmenu = 1;
	}

	self thread obj_waypoint_destroy_on_end_game();
}

obj_waypoint_destroy_on_end_game()
{
	self endon("disconnect");

	level waittill("end_game");

	if (isDefined(self.obj_waypoint))
	{
		self.obj_waypoint destroy();
	}

	if (isDefined(self.next_obj_waypoint))
	{
		self.next_obj_waypoint destroy();
	}
}

headstomp_watcher()
{
	level endon("end_game");
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

	while (1)
	{
		if (self.sessionstate != "playing")
		{
			wait 0.05;
			continue;
		}

		players = get_players();

		foreach (player in players)
		{
			player_top_origin = player getCentroid();

			if (player != self && player.team != self.team && is_player_valid(player) && player getStance() == "prone" && player isOnGround() && self.origin[2] > player_top_origin[2])
			{
				if (distance2d(self.origin, player.origin) <= 21 && (self.origin[2] - player_top_origin[2]) <= 15)
				{
					player store_player_damage_info(self, "none", "MOD_FALLING");
					player dodamage(1000, (0, 0, 0));
				}
			}
		}

		wait 0.05;
	}
}

decrease_upgraded_start_weapon_ammo()
{
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

	upgraded_start_weapon = level.zombie_weapons[level.start_weapon].upgrade_name;
	max_ammo = int(weaponmaxammo(upgraded_start_weapon) / 2);

	while (1)
	{
		self waittill("weapon_ammo_change");

		foreach (weapon in self getweaponslistprimaries())
		{
			if (weapon != upgraded_start_weapon)
			{
				continue;
			}

			ammo = self getweaponammostock(weapon);

			if (ammo > max_ammo)
			{
				self setweaponammostock(weapon, max_ammo);
			}
		}
	}
}

round_start_wait(time, initial)
{
	level endon("end_game");

	if (!isDefined(initial))
	{
		initial = false;
	}

	if (initial)
	{
		flag_clear("spawn_zombies");

		flag_wait("start_zombie_round_logic");

		players = get_players();

		foreach (player in players)
		{
			player.hostmigrationcontrolsfrozen = 1; // fixes players being able to move after initial_blackscreen_passed
		}

		level thread freeze_hotjoin_players();

		flag_wait("initial_blackscreen_passed");
	}
	else
	{
		players = get_players();

		foreach (player in players)
		{
			ground_origin = groundpos(player.origin);
			dist = distancesquared(player.origin, ground_origin);

			// distance check because sometimes groundpos goes below walkable surface
			if (dist <= 4096)
			{
				player setOrigin(ground_origin); // players normally spawn slightly above the ground
			}

			player setPlayerAngles(player.spectator_respawn.angles); // fixes angles if player was looking around while spawning in
		}
	}

	if (level.scr_zm_ui_gametype_obj == "zsnr")
	{
		foreach (team in level.teams)
		{
			grief_score_hud_set_player_count(team);
		}
	}

	zombie_spawn_time = time + 10;

	level thread zombie_spawn_wait(zombie_spawn_time);

	text = &"ZOMBIE_MATCH_BEGINS_IN_CAPS";
	text_param = undefined;

	if (level.scr_zm_ui_gametype_obj == "zsnr")
	{
		text = &"ZOMBIE_ROUND_BEGINS_IN_CAPS";
		text_param = level.snr_round_number;
	}

	countdown_hud = scripts\zm\replaced\_zm::countdown_hud(text, text_param, time);

	wait time;

	countdown_hud scripts\zm\replaced\_zm::countdown_hud_destroy();

	players = get_players();

	foreach (player in players)
	{
		if (initial)
		{
			player.hostmigrationcontrolsfrozen = 0;
		}

		player freezeControls(0);
		player disableInvulnerability();
	}

	level notify("restart_round_start");
}

freeze_hotjoin_players()
{
	level endon("restart_round_start");

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			if (!is_true(player.hostmigrationcontrolsfrozen))
			{
				player.hostmigrationcontrolsfrozen = 1;

				player thread wait_and_freeze();
				player enableInvulnerability();
			}
		}

		wait 0.05;
	}
}

wait_and_freeze()
{
	self endon("disconnect");

	wait 0.05;

	self freezeControls(1);
}

zombie_spawn_wait(time)
{
	level endon("end_game");
	level endon("restart_round");

	flag_clear("spawn_zombies");

	wait time;

	flag_set("spawn_zombies");
}

get_number_of_valid_players_team(team, excluded_player)
{
	num_player_valid = 0;
	players = get_players(team);

	foreach (player in players)
	{
		if (isDefined(excluded_player) && player == excluded_player)
		{
			continue;
		}

		if (is_player_valid(player))
		{
			num_player_valid += 1;
		}
	}

	return num_player_valid;
}

update_players_on_downed(excluded_player)
{
	team = excluded_player.team;
	other_team = getOtherTeam(team);
	players = get_players(team);
	other_players = get_players(other_team);
	players_remaining = get_number_of_valid_players_team(team, excluded_player);
	other_players_remaining = get_number_of_valid_players_team(other_team, excluded_player);

	grief_score_hud_set_player_count(team, players_remaining);

	foreach (player in other_players)
	{
		if (players_remaining == 0)
		{
			if (other_players_remaining > 0)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALL_PLAYERS_DOWN");
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_SURVIVE", undefined, 30, 1);
			}
		}
		else
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_BLED_OUT", players_remaining);
		}
	}

	if (other_players_remaining > 0)
	{
		foreach (player in players)
		{
			if (players_remaining == 0)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALL_ALLIES_DOWN", undefined, 30);
			}
			else
			{
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALLY_BLED_OUT", players_remaining, 30);
			}
		}
	}

	if (players_remaining == 1)
	{
		foreach (player in players)
		{
			if (player == excluded_player)
			{
				continue;
			}

			if (is_player_valid(player))
			{
				player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("last_player");
			}
		}
	}

	level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(players_remaining + "_player_left", other_team);
}

update_players_on_bleedout(excluded_player)
{
	team = excluded_player.team;
	other_team = getOtherTeam(team);
	players = get_players(team);
	team_bledout = 0;

	foreach (player in players)
	{
		if (player == excluded_player || player.sessionstate != "playing" || is_true(player.playersuicided))
		{
			team_bledout++;
		}
	}

	level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(team_bledout + "_player_down", other_team);
}

update_players_on_revived(revived_player, reviver)
{
	team = revived_player.team;
	other_team = getOtherTeam(team);
	players = get_players(team);
	other_players = get_players(other_team);
	players_remaining = get_number_of_valid_players_team(team);
	other_players_remaining = get_number_of_valid_players_team(other_team);

	grief_score_hud_set_player_count(team, players_remaining);

	foreach (player in other_players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_REVIVED", players_remaining);
	}

	if (other_players_remaining > 0)
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALLY_REVIVED", players_remaining, 30);
		}
	}
}

update_players_on_disconnect(excluded_player)
{
	if (is_player_valid(excluded_player))
	{
		update_players_on_downed(excluded_player);
	}
}

wait_and_award_grenades()
{
	self endon("disconnect");

	while (is_true(self.is_hotjoining))
	{
		wait 0.05;
	}

	self giveWeapon(self get_player_lethal_grenade());
	self setWeaponAmmoClip(self get_player_lethal_grenade(), 2);
}

grief_intro_msg()
{
	level endon("end_game");

	level waittill("restart_round_start");

	players = get_players();

	if (level.scr_zm_ui_gametype_obj == "zgrief")
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_INTRO");
		}
	}
	else if (level.scr_zm_ui_gametype_obj == "zsnr")
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZSNR_INTRO");
		}
	}
	else if (level.scr_zm_ui_gametype_obj == "zrace")
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZRACE_INTRO");
		}
	}
	else if (level.scr_zm_ui_gametype_obj == "zcontainment")
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZCONTAINMENT_INTRO");
		}
	}
	else if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZMEAT_INTRO");
		}
	}

	wait 5;

	players = get_players();

	if (level.scr_zm_ui_gametype_obj == "zsnr")
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_ROUNDS_TO_WIN", get_gamemode_winning_score());
		}
	}
	else
	{
		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_SCORE_TO_WIN", get_gamemode_winning_score());
		}
	}
}

get_gamemode_display_name(gamemode = level.scr_zm_ui_gametype_obj)
{
	if (level.scr_zm_ui_gametype_pro)
	{
		return istring(toupper("ZMUI_" + gamemode + "_PRO"));
	}
	else
	{
		return istring(toupper("ZMUI_" + gamemode));
	}
}

get_gamemode_winning_score()
{
	if (level.scr_zm_ui_gametype_obj == "zgrief")
	{
		return 10;
	}
	else if (level.scr_zm_ui_gametype_obj == "zsnr")
	{
		return 3;
	}
	else if (level.scr_zm_ui_gametype_obj == "zrace")
	{
		return 500;
	}
	else if (level.scr_zm_ui_gametype_obj == "zcontainment")
	{
		return 250;
	}
	else if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		return 200;
	}
}

is_respawn_gamemode()
{
	if (!isDefined(level.scr_zm_ui_gametype_obj))
	{
		return 0;
	}

	return level.scr_zm_ui_gametype_obj != "zsnr";
}

show_grief_hud_msg(msg, msg_parm, offset, delay)
{
	if (!isDefined(offset))
	{
		self notify("show_grief_hud_msg");
	}
	else
	{
		self notify("show_grief_hud_msg2");
	}

	self endon("disconnect");

	zgrief_hudmsg = newclienthudelem(self);
	zgrief_hudmsg.alignx = "center";
	zgrief_hudmsg.aligny = "middle";
	zgrief_hudmsg.horzalign = "center";
	zgrief_hudmsg.vertalign = "middle";
	zgrief_hudmsg.sort = 1;
	zgrief_hudmsg.y -= 130;

	if (self issplitscreen())
	{
		zgrief_hudmsg.y += 70;
	}

	if (isDefined(offset))
	{
		zgrief_hudmsg.y += offset;
	}

	zgrief_hudmsg.foreground = 1;
	zgrief_hudmsg.fontscale = 5;
	zgrief_hudmsg.alpha = 0;
	zgrief_hudmsg.color = (1, 1, 1);
	zgrief_hudmsg.hidewheninmenu = 1;
	zgrief_hudmsg.font = "default";

	zgrief_hudmsg endon("death");

	zgrief_hudmsg thread show_grief_hud_msg_cleanup(self, offset);

	while (isDefined(level.hostmigrationtimer))
	{
		wait 0.05;
	}

	if (isDefined(delay))
	{
		wait delay;
	}

	if (isDefined(msg_parm))
	{
		zgrief_hudmsg settext(msg, msg_parm);
	}
	else
	{
		zgrief_hudmsg settext(msg);
	}

	zgrief_hudmsg changefontscaleovertime(0.25);
	zgrief_hudmsg fadeovertime(0.25);
	zgrief_hudmsg.alpha = 1;
	zgrief_hudmsg.fontscale = 2;

	wait 3.25;

	zgrief_hudmsg changefontscaleovertime(1);
	zgrief_hudmsg fadeovertime(1);
	zgrief_hudmsg.alpha = 0;
	zgrief_hudmsg.fontscale = 5;

	wait 1;

	if (isDefined(zgrief_hudmsg))
	{
		zgrief_hudmsg destroy();
	}
}

show_grief_hud_msg_cleanup(player, offset)
{
	self endon("death");

	self thread show_grief_hud_msg_cleanup_end_game();

	if (!isDefined(offset))
	{
		self thread show_grief_hud_msg_cleanup_restart_round();
		player waittill("show_grief_hud_msg");
	}
	else
	{
		player waittill("show_grief_hud_msg2");
	}

	if (isDefined(self))
	{
		self destroy();
	}
}

show_grief_hud_msg_cleanup_restart_round()
{
	self endon("death");

	level waittill("restart_round");

	if (isDefined(self))
	{
		self destroy();
	}
}

show_grief_hud_msg_cleanup_end_game()
{
	self endon("death");

	level waittill("end_game");

	if (isDefined(self))
	{
		self destroy();
	}
}

custom_end_screen()
{
	players = get_players();
	i = 0;

	while (i < players.size)
	{
		players[i].game_over_hud = newclienthudelem(players[i]);
		players[i].game_over_hud.alignx = "center";
		players[i].game_over_hud.aligny = "middle";
		players[i].game_over_hud.horzalign = "center";
		players[i].game_over_hud.vertalign = "middle";
		players[i].game_over_hud.y -= 130;
		players[i].game_over_hud.foreground = 1;
		players[i].game_over_hud.fontscale = 3;
		players[i].game_over_hud.alpha = 0;
		players[i].game_over_hud.color = (1, 1, 1);
		players[i].game_over_hud.hidewheninmenu = 1;
		players[i].game_over_hud settext(&"ZOMBIE_GAME_OVER");
		players[i].game_over_hud fadeovertime(1);
		players[i].game_over_hud.alpha = 1;

		if (players[i] issplitscreen())
		{
			players[i].game_over_hud.fontscale = 2;
			players[i].game_over_hud.y += 40;
		}

		players[i].survived_hud = newclienthudelem(players[i]);
		players[i].survived_hud.alignx = "center";
		players[i].survived_hud.aligny = "middle";
		players[i].survived_hud.horzalign = "center";
		players[i].survived_hud.vertalign = "middle";
		players[i].survived_hud.y -= 100;
		players[i].survived_hud.foreground = 1;
		players[i].survived_hud.fontscale = 2;
		players[i].survived_hud.alpha = 0;
		players[i].survived_hud.color = (1, 1, 1);
		players[i].survived_hud.hidewheninmenu = 1;

		if (players[i] issplitscreen())
		{
			players[i].survived_hud.fontscale = 1.5;
			players[i].survived_hud.y += 40;
		}

		winner_text = &"ZOMBIE_GRIEF_WIN";
		loser_text = &"ZOMBIE_GRIEF_LOSE";

		if (isDefined(level.host_ended_game) && level.host_ended_game)
		{
			players[i].survived_hud settext(&"MP_HOST_ENDED_GAME");
		}
		else
		{
			if (isDefined(level.gamemodulewinningteam) && players[i]._encounters_team == level.gamemodulewinningteam)
			{
				players[i].survived_hud settext(winner_text);
			}
			else
			{
				players[i].survived_hud settext(loser_text);
			}
		}

		players[i].survived_hud fadeovertime(1);
		players[i].survived_hud.alpha = 1;
		i++;
	}
}

game_module_player_damage_callback(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	if (isdefined(self.player_damage_callback_score_only))
	{
		self do_game_mode_stun_score_steal(eattacker);

		self store_player_damage_info(eattacker, sweapon, smeansofdeath);

		return 0;
	}

	self.last_damage_from_zombie_or_player = 0;

	if (isDefined(eattacker))
	{
		if (isplayer(eattacker) && eattacker == self)
		{
			return;
		}

		if (isDefined(eattacker.is_zombie) && eattacker.is_zombie || isplayer(eattacker))
		{
			self.last_damage_from_zombie_or_player = 1;
		}
	}

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		return;
	}

	if (isDefined(sweapon) && isSubStr(sweapon, "tower_trap"))
	{
		if (is_true(self._being_pushed))
		{
			return 0;
		}

		if (isDefined(level._effect["butterflies"]))
		{
			self do_game_mode_stun_fx(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
		}

		self thread do_game_mode_shellshock();
		self playsound("zmb_player_hit_ding");

		return 0;
	}

	if (isplayer(eattacker) && isDefined(eattacker._encounters_team) && eattacker._encounters_team != self._encounters_team)
	{
		if (is_true(self.hasriotshield) && isDefined(vdir))
		{
			if (is_true(self.hasriotshieldequipped))
			{
				if (self maps\mp\zombies\_zm::player_shield_facing_attacker(vdir, 0.2) && isDefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
			else if (!isdefined(self.riotshieldentity))
			{
				if (!self maps\mp\zombies\_zm::player_shield_facing_attacker(vdir, -0.2) && isdefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
		}

		if (is_true(self._being_pushed))
		{
			return;
		}

		is_melee = false;

		if (isDefined(eattacker) && isplayer(eattacker) && eattacker != self && eattacker.team != self.team && (smeansofdeath == "MOD_MELEE" || issubstr(sweapon, "knife_ballistic")))
		{
			is_melee = true;
			dir = vdir;
			amount = self get_player_push_amount(idamage);

			if (self isOnGround())
			{
				// don't move vertically if on ground
				dir = (dir[0], dir[1], 0);
			}

			dir = vectorNormalize(dir);
			self setVelocity(amount * dir);
		}

		if (is_true(self._being_shellshocked) && !is_melee)
		{
			return;
		}

		sweapon = get_nonalternate_weapon(sweapon);

		if (!is_true(self._being_shellshocked))
		{
			self do_game_mode_stun_score_steal(eattacker);
		}

		if (isDefined(level._effect["butterflies"]))
		{
			self do_game_mode_stun_fx(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
		}

		self thread do_game_mode_shellshock(is_melee, is_weapon_upgraded(sweapon));
		self playsound("zmb_player_hit_ding");

		self store_player_damage_info(eattacker, sweapon, smeansofdeath);
	}
}

get_player_push_amount(idamage)
{
	amount = 0;

	if (self maps\mp\zombies\_zm_laststand::is_reviving_any())
	{
		if (idamage >= 500)
		{
			if (!self isOnGround())
			{
				amount = 185; // 64 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 297.5; // 32 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 215; // 21.33 units
			}
			else if (self getStance() == "prone")
			{
				amount = 132.5; // 10.66 units
			}
		}
		else
		{
			if (!self isOnGround())
			{
				amount = 142.5; // 48 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 235; // 24 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 172.5; // 16 units
			}
			else if (self getStance() == "prone")
			{
				amount = 112.5; // 8 units
			}
		}
	}
	else
	{
		if (idamage >= 500)
		{
			if (!self isOnGround())
			{
				amount = 350; // 128 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 540; // 64 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 377.5; // 42.66 units
			}
			else if (self getStance() == "prone")
			{
				amount = 215; // 21.33 units
			}
		}
		else
		{
			if (!self isOnGround())
			{
				amount = 265; // 96 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 420; // 48 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 297.5; // 32 units
			}
			else if (self getStance() == "prone")
			{
				amount = 172.5; // 16 units
			}
		}
	}

	return amount;
}

do_game_mode_stun_score_steal(eattacker)
{
	score = 100 * maps\mp\zombies\_zm_score::get_points_multiplier(eattacker);
	self stun_score_steal(eattacker, score);

	eattacker.killsdenied++;
}

do_game_mode_stun_fx(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	pos = vpoint;
	angle = vectorToAngles(eattacker getCentroid() - self getCentroid());

	if (isDefined(sweapon) && (weapontype(sweapon) == "grenade" || weapontype(sweapon) == "projectile"))
	{
		pos_offset = vectorNormalize(vpoint - self getCentroid()) * 8;
		pos_offset = (pos_offset[0], pos_offset[1], 0);
		pos = self getCentroid() + pos_offset;
		angle = vectorToAngles(vpoint - self getCentroid());
	}

	angle = (0, angle[1], 0);
	stun_fx_amount = 3;

	if (!isDefined(self.stun_fx))
	{
		// spawning in model right before playfx causes the fx not to play occasionally
		// stun fx lasts longer than stun time, so alternate between different models
		self.stun_fx = [];
		self.stun_fx_ind = 0;

		for (i = 0; i < stun_fx_amount; i++)
		{
			self.stun_fx[i] = spawn("script_model", pos);
			self.stun_fx[i] setModel("tag_origin");
		}
	}

	self.stun_fx[self.stun_fx_ind] unlink();
	self.stun_fx[self.stun_fx_ind].origin = pos;
	self.stun_fx[self.stun_fx_ind].angles = angle;
	self.stun_fx[self.stun_fx_ind] linkTo(self);

	playFXOnTag(level._effect["butterflies"], self.stun_fx[self.stun_fx_ind], "tag_origin");

	self.stun_fx_ind = (self.stun_fx_ind + 1) % stun_fx_amount;
}

do_game_mode_shellshock(is_melee = 0, is_upgraded = 0)
{
	self notify("do_game_mode_shellshock");
	self endon("do_game_mode_shellshock");
	self endon("disconnect");

	time = 0.5;

	if (is_melee)
	{
		time = 0.75;
	}
	else if (is_upgraded)
	{
		time = 0.75;
	}

	self._being_shellshocked = 1;
	self._being_pushed = is_melee;
	self shellshock("grief_stab_zm", time);

	wait 0.75;

	self._being_shellshocked = 0;
	self._being_pushed = 0;
}

stun_score_steal(attacker, score)
{
	if (is_player_valid(attacker))
	{
		attacker maps\mp\zombies\_zm_score::add_to_player_score(score);
	}

	if (self.score < score)
	{
		self maps\mp\zombies\_zm_score::minus_to_player_score(self.score);
	}
	else
	{
		self maps\mp\zombies\_zm_score::minus_to_player_score(score);
	}
}

store_player_damage_info(attacker, weapon, meansofdeath)
{
	self.last_griefed_by = spawnStruct();
	self.last_griefed_by.attacker = attacker;
	self.last_griefed_by.weapon = weapon;
	self.last_griefed_by.meansofdeath = meansofdeath;

	self thread remove_player_damage_info();
}

remove_player_damage_info()
{
	self notify("new_griefer");
	self endon("new_griefer");
	self endon("disconnect");

	health = self.health;
	time = getTime();
	max_time = 3000;

	while (((getTime() - time) < max_time || self.health < health) && is_player_valid(self))
	{
		wait_network_frame();
	}

	self.last_griefed_by = undefined;
}

grief_laststand_weapon_save(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	self.grief_savedweapon_weapons = self getweaponslist();
	self.grief_savedweapon_weaponsammo_clip = [];
	self.grief_savedweapon_weaponsammo_clip_dualwield = [];
	self.grief_savedweapon_weaponsammo_stock = [];
	self.grief_savedweapon_weaponsammo_clip_alt = [];
	self.grief_savedweapon_weaponsammo_stock_alt = [];
	self.grief_savedweapon_currentweapon = maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(self getcurrentweapon()); // can't switch to alt weapon
	self.grief_savedweapon_melee = self get_player_melee_weapon();
	self.grief_savedweapon_grenades = self get_player_lethal_grenade();
	self.grief_savedweapon_tactical = self get_player_tactical_grenade();
	self.grief_savedweapon_mine = self get_player_placeable_mine();
	self.grief_savedweapon_equipment = self get_player_equipment();
	self.grief_hasriotshield = undefined;

	for (i = 0; i < self.grief_savedweapon_weapons.size; i++)
	{
		self.grief_savedweapon_weaponsammo_clip[i] = self getweaponammoclip(self.grief_savedweapon_weapons[i]);
		self.grief_savedweapon_weaponsammo_clip_dualwield[i] = self getweaponammoclip(weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i]));
		self.grief_savedweapon_weaponsammo_stock[i] = self getweaponammostock(self.grief_savedweapon_weapons[i]);
		self.grief_savedweapon_weaponsammo_clip_alt[i] = self getweaponammoclip(weaponAltWeaponName(self.grief_savedweapon_weapons[i]));
		self.grief_savedweapon_weaponsammo_stock_alt[i] = self getweaponammostock(weaponAltWeaponName(self.grief_savedweapon_weapons[i]));

		if (isDefined(self.grief_savedweapon_weaponsammo_clip[i]))
		{
			clip_missing = weaponClipSize(self.grief_savedweapon_weapons[i]) - self.grief_savedweapon_weaponsammo_clip[i];

			if (clip_missing > self.grief_savedweapon_weaponsammo_stock[i])
			{
				clip_missing = self.grief_savedweapon_weaponsammo_stock[i];
			}

			self.grief_savedweapon_weaponsammo_clip[i] += clip_missing;
			self.grief_savedweapon_weaponsammo_stock[i] -= clip_missing;
		}

		if (isDefined(self.grief_savedweapon_weaponsammo_clip_dualwield[i]) && weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i]) != "none")
		{
			clip_dualwield_missing = weaponClipSize(weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i])) - self.grief_savedweapon_weaponsammo_clip_dualwield[i];

			if (clip_dualwield_missing > self.grief_savedweapon_weaponsammo_stock[i])
			{
				clip_dualwield_missing = self.grief_savedweapon_weaponsammo_stock[i];
			}

			self.grief_savedweapon_weaponsammo_clip_dualwield[i] += clip_dualwield_missing;
			self.grief_savedweapon_weaponsammo_stock[i] -= clip_dualwield_missing;
		}

		if (isDefined(self.grief_savedweapon_weaponsammo_clip_alt[i]) && weaponAltWeaponName(self.grief_savedweapon_weapons[i]) != "none")
		{
			clip_alt_missing = weaponClipSize(weaponAltWeaponName(self.grief_savedweapon_weapons[i])) - self.grief_savedweapon_weaponsammo_clip_alt[i];

			if (clip_alt_missing > self.grief_savedweapon_weaponsammo_stock_alt[i])
			{
				clip_alt_missing = self.grief_savedweapon_weaponsammo_stock_alt[i];
			}

			self.grief_savedweapon_weaponsammo_clip_alt[i] += clip_alt_missing;
			self.grief_savedweapon_weaponsammo_stock_alt[i] -= clip_alt_missing;
		}
	}

	if (isDefined(self.grief_savedweapon_grenades))
	{
		self.grief_savedweapon_grenades_clip = self getweaponammoclip(self.grief_savedweapon_grenades);
	}

	if (isDefined(self.grief_savedweapon_tactical))
	{
		self.grief_savedweapon_tactical_clip = self getweaponammoclip(self.grief_savedweapon_tactical);
	}

	if (isDefined(self.grief_savedweapon_mine))
	{
		self.grief_savedweapon_mine_clip = self getweaponammoclip(self.grief_savedweapon_mine);
	}

	if (isDefined(self.hasriotshield) && self.hasriotshield)
	{
		self.grief_hasriotshield = 1;
	}

	self.grief_savedperks = self.perks_active;
}

grief_laststand_weapons_return()
{
	if (!isDefined(self.grief_savedweapon_weapons))
	{
		return 0;
	}

	if (is_true(self._retain_perks))
	{
		if (isDefined(self.grief_savedperks))
		{
			self.perks_active = [];

			foreach (perk in self.grief_savedperks)
			{
				self maps\mp\zombies\_zm_perks::give_perk(perk);
			}
		}
	}

	primary_weapons_returned = 0;
	i = 0;

	while (i < self.grief_savedweapon_weapons.size)
	{
		if (isdefined(self.grief_savedweapon_grenades) && self.grief_savedweapon_weapons[i] == self.grief_savedweapon_grenades || (isdefined(self.grief_savedweapon_tactical) && self.grief_savedweapon_weapons[i] == self.grief_savedweapon_tactical))
		{
			i++;
			continue;
		}

		if (is_temporary_zombie_weapon(self.grief_savedweapon_weapons[i]))
		{
			i++;
			continue;
		}

		if (level.item_meat_name == self.grief_savedweapon_weapons[i])
		{
			i++;
			continue;
		}

		if (isweaponprimary(self.grief_savedweapon_weapons[i]))
		{
			if (primary_weapons_returned >= get_player_weapon_limit(self))
			{
				i++;
				continue;
			}

			primary_weapons_returned++;
		}

		if (isDefined(self.stored_weapon_info[self.grief_savedweapon_weapons[i]]) && isDefined(self.stored_weapon_info[self.grief_savedweapon_weapons[i]].used_amt))
		{
			used_amt = self.stored_weapon_info[self.grief_savedweapon_weapons[i]].used_amt;

			if (used_amt >= self.grief_savedweapon_weaponsammo_stock[i])
			{
				used_amt = used_amt - self.grief_savedweapon_weaponsammo_stock[i];
				self.grief_savedweapon_weaponsammo_stock[i] = 0;

				dual_wield_name = weapondualwieldweaponname(self.grief_savedweapon_weapons[i]);

				if ("none" != dual_wield_name)
				{
					if (used_amt >= self.grief_savedweapon_weaponsammo_clip_dualwield[i])
					{
						used_amt -= self.grief_savedweapon_weaponsammo_clip_dualwield[i];
						self.grief_savedweapon_weaponsammo_clip_dualwield[i] = 0;

						if (used_amt >= self.grief_savedweapon_weaponsammo_clip[i])
						{
							used_amt -= self.grief_savedweapon_weaponsammo_clip[i];
							self.grief_savedweapon_weaponsammo_clip[i] = 0;
						}
						else
						{
							self.grief_savedweapon_weaponsammo_clip[i] -= used_amt;
						}
					}
					else
					{
						self.grief_savedweapon_weaponsammo_clip_dualwield[i] -= used_amt;
					}
				}
				else
				{
					if (used_amt >= self.grief_savedweapon_weaponsammo_clip[i])
					{
						used_amt -= self.grief_savedweapon_weaponsammo_clip[i];
						self.grief_savedweapon_weaponsammo_clip[i] = 0;
					}
					else
					{
						self.grief_savedweapon_weaponsammo_clip[i] -= used_amt;
					}
				}
			}
			else
			{
				self.grief_savedweapon_weaponsammo_stock[i] -= used_amt;
			}
		}

		self giveweapon(self.grief_savedweapon_weapons[i], 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(self.grief_savedweapon_weapons[i]));

		if (isdefined(self.grief_savedweapon_weaponsammo_clip[i]))
		{
			self setweaponammoclip(self.grief_savedweapon_weapons[i], self.grief_savedweapon_weaponsammo_clip[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_clip_dualwield[i]))
		{
			self setweaponammoclip(weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i]), self.grief_savedweapon_weaponsammo_clip_dualwield[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_stock[i]))
		{
			self setweaponammostock(self.grief_savedweapon_weapons[i], self.grief_savedweapon_weaponsammo_stock[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_clip_alt[i]))
		{
			self setweaponammoclip(weaponAltWeaponName(self.grief_savedweapon_weapons[i]), self.grief_savedweapon_weaponsammo_clip_alt[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_stock_alt[i]))
		{
			self setweaponammostock(weaponAltWeaponName(self.grief_savedweapon_weapons[i]), self.grief_savedweapon_weaponsammo_stock_alt[i]);
		}

		i++;
	}

	if (isDefined(self.grief_savedweapon_melee))
	{
		self set_player_melee_weapon(self.grief_savedweapon_melee);
		self setactionslot(2, "weapon", "held_" + self.grief_savedweapon_melee);
	}

	if (isDefined(self.grief_savedweapon_grenades))
	{
		self giveweapon(self.grief_savedweapon_grenades);
		self set_player_lethal_grenade(self.grief_savedweapon_grenades);

		if (isDefined(self.grief_savedweapon_grenades_clip))
		{
			if (is_respawn_gamemode())
			{
				self.grief_savedweapon_grenades_clip += 2;

				if (self.grief_savedweapon_grenades_clip > weaponClipSize(self.grief_savedweapon_grenades))
				{
					self.grief_savedweapon_grenades_clip = weaponClipSize(self.grief_savedweapon_grenades);
				}
			}

			self setweaponammoclip(self.grief_savedweapon_grenades, self.grief_savedweapon_grenades_clip);
		}
	}

	if (isDefined(self.grief_savedweapon_tactical))
	{
		self giveweapon(self.grief_savedweapon_tactical);
		self set_player_tactical_grenade(self.grief_savedweapon_tactical);

		if (isDefined(self.grief_savedweapon_tactical_clip))
		{
			self setweaponammoclip(self.grief_savedweapon_tactical, self.grief_savedweapon_tactical_clip);
		}
	}

	if (isDefined(self.grief_savedweapon_mine))
	{
		if (is_respawn_gamemode())
		{
			self.grief_savedweapon_mine_clip += 2;

			if (self.grief_savedweapon_mine_clip > weaponClipSize(self.grief_savedweapon_mine))
			{
				self.grief_savedweapon_mine_clip = weaponClipSize(self.grief_savedweapon_mine);
			}
		}

		self giveweapon(self.grief_savedweapon_mine);
		self set_player_placeable_mine(self.grief_savedweapon_mine);
		self setactionslot(4, "weapon", self.grief_savedweapon_mine);
		self setweaponammoclip(self.grief_savedweapon_mine, self.grief_savedweapon_mine_clip);
	}

	if (isDefined(self.current_equipment))
	{
		self maps\mp\zombies\_zm_equipment::equipment_take(self.current_equipment);
	}

	if (isDefined(self.grief_savedweapon_equipment))
	{
		self.do_not_display_equipment_pickup_hint = 1;
		self maps\mp\zombies\_zm_equipment::equipment_give(self.grief_savedweapon_equipment);
		self.do_not_display_equipment_pickup_hint = undefined;
	}

	if (isDefined(self.grief_hasriotshield) && self.grief_hasriotshield)
	{
		if (isDefined(self.player_shield_reset_health))
		{
			self [[self.player_shield_reset_health]]();
		}
	}

	self.grief_savedweapon_weapons = undefined;

	weapon = undefined;
	primaries = self getweaponslistprimaries();

	if (isDefined(self.pre_temp_weapon) && self hasWeapon(self.pre_temp_weapon))
	{
		weapon = self.pre_temp_weapon;
		self.pre_temp_weapon = undefined;
	}
	else if (isDefined(self.pre_meat_weapon) && self hasWeapon(self.pre_meat_weapon))
	{
		weapon = self.pre_meat_weapon;
		self.pre_meat_weapon = undefined;
	}
	else if (isDefined(self.grief_savedweapon_currentweapon) && self hasWeapon(self.grief_savedweapon_currentweapon))
	{
		weapon = self.grief_savedweapon_currentweapon;
		self.grief_savedweapon_currentweapon = undefined;
	}

	if (isDefined(weapon))
	{
		foreach (primary in primaries)
		{
			if (primary == weapon)
			{
				self switchtoweapon(primary);
				return 1;
			}
		}
	}

	if (primaries.size > 0)
	{
		self switchtoweapon(primaries[0]);
		return 1;
	}

	self maps\mp\zombies\_zm_weapons::give_fallback_weapon();
	return 1;
}

red_flashing_overlay_loop()
{
	level endon("restart_round");
	self endon("disconnect");

	while (1)
	{
		self notify("hit_again");
		self player_flag_set("player_has_red_flashing_overlay");

		wait 1;
	}
}

unlimited_zombies()
{
	while (1)
	{
		level.zombie_total = 100;

		wait 1;
	}
}

unlimited_powerups()
{
	while (1)
	{
		level.powerup_drop_count = 0;

		wait 1;
	}
}

player_suicide()
{
	self.bleedout_time += 1;

	self notify("player_suicide");

	self.playersuicided = 1;

	wait_network_frame();

	self maps\mp\zombies\_zm_laststand::bleed_out();
	self.playersuicided = undefined;
}

remove_round_number()
{
	level endon("end_game");

	while (1)
	{
		level waittill("start_of_round");

		setroundsplayed(0);
	}
}

save_teams_on_intermission()
{
	level waittill("intermission");

	axis_guids = "";
	allies_guids = "";

	if (level.allow_teamchange)
	{
		players = get_players("axis");

		foreach (player in players)
		{
			axis_guids += player getguid() + " ";
		}

		players = get_players("allies");

		foreach (player in players)
		{
			allies_guids += player getguid() + " ";
		}
	}
	else
	{
		players = array_randomize(get_players());
		i = 0;

		foreach (player in players)
		{
			if (i % 2 == 0)
			{
				axis_guids += player getguid() + " ";
			}
			else
			{
				allies_guids += player getguid() + " ";
			}

			i++;
		}
	}

	setDvar("team_axis", axis_guids);
	setDvar("team_allies", allies_guids);
}

all_voice_on_intermission()
{
	level waittill("intermission");

	setDvar("sv_voice", 1);
}

race_check_for_kills()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("zom_kill", zombie);

		amount = 1;
		score_msg = undefined;

		if (is_true(zombie.is_brutus))
		{
			amount = 10;
			score_msg = &"ZOMBIE_ZGRIEF_BOSS_KILLED_SCORE";
		}

		increment_score(self.team, amount, 1, score_msg);
	}
}

containment_init()
{
	level.containment_zone_hud = newHudElem();
	level.containment_zone_hud.alignx = "left";
	level.containment_zone_hud.aligny = "top";
	level.containment_zone_hud.horzalign = "user_left";
	level.containment_zone_hud.vertalign = "user_top";
	level.containment_zone_hud.x += 7;
	level.containment_zone_hud.y += 2;
	level.containment_zone_hud.fontscale = 1.4;
	level.containment_zone_hud.alpha = 0;
	level.containment_zone_hud.color = (1, 1, 1);
	level.containment_zone_hud.hidewheninmenu = 1;
	level.containment_zone_hud.foreground = 1;
	level.containment_zone_hud.label = &"ZOMBIE_HUD_CONTAINMENT_ZONE";

	level.containment_time_hud = newHudElem();
	level.containment_time_hud.alignx = "left";
	level.containment_time_hud.aligny = "top";
	level.containment_time_hud.horzalign = "user_left";
	level.containment_time_hud.vertalign = "user_top";
	level.containment_time_hud.x += 7;
	level.containment_time_hud.y += 17;
	level.containment_time_hud.fontscale = 1.4;
	level.containment_time_hud.alpha = 0;
	level.containment_time_hud.color = (1, 1, 1);
	level.containment_time_hud.hidewheninmenu = 1;
	level.containment_time_hud.foreground = 1;
	level.containment_time_hud.label = &"ZOMBIE_HUD_CONTAINMENT_TIME";

	level thread containment_hud_destroy_on_end_game();
	level thread containment_think();
}

containment_hud_destroy_on_end_game()
{
	level waittill("end_game");

	level.containment_zone_hud setText("");
	level.containment_time_hud setText("");

	level waittill("intermission");

	level.containment_zone_hud destroy();
	level.containment_time_hud destroy();
}

containment_think()
{
	level endon("end_game");

	flag_wait("hud_visible");

	ind = 0;
	containment_zones = containment_get_zones();

	level.containment_zone_hud.alpha = 1;

	if (containment_zones.size > 1)
	{
		level.containment_time_hud.alpha = 1;
	}

	level waittill("restart_round_start");

	start_time = getTime();

	while ((getTime() - start_time) <= 10000)
	{
		next_zone_name = containment_zones[ind];
		next_zone = level.zones[next_zone_name];
		players = get_players();

		foreach (player in players)
		{
			player_zone_name = player get_current_zone();

			if (isDefined(player_zone_name) && player_zone_name == next_zone_name)
			{
				player containment_set_obj_waypoint_on_screen(1);
			}
			else
			{
				player containment_set_obj_waypoint_off_screen(next_zone_name, next_zone, 1);
			}

			player containment_set_obj_waypoint_icon("white_waypoint_target", 1);
		}

		wait 0.05;
	}

	while (1)
	{
		zone_name = containment_zones[ind];
		zone_display_name = scripts\zm\_zm_reimagined::get_zone_display_name(zone_name);
		zone = level.zones[zone_name];

		next_ind = ind + 1;

		if (next_ind >= containment_zones.size)
		{
			next_ind = 0;
		}

		next_zone_name = containment_zones[next_ind];
		next_zone = level.zones[next_zone_name];

		zone_name_to_lock = zone_name;

		if (zone_name == "culdesac_yellow_zone")
		{
			zone_name_to_lock = "culdesac_green_zone";
		}
		else if (zone_name == "zone_street_fountain")
		{
			zone_name_to_lock = "zone_street_lighteast";
		}
		else if (zone_name == "zone_mansion_lawn")
		{
			zone_name_to_lock = "zone_mansion";
		}

		players = get_players();

		foreach (player in players)
		{
			player.in_containment_zone = undefined;

			player thread show_grief_hud_msg(&"ZOMBIE_NEW_CONTAINMENT_ZONE");
		}

		level.containment_zone_hud setText(zone_display_name);
		level.containment_time_hud setTimer(60);

		zone_time = 60000;
		next_obj_waypoint_time = 10000;
		obj_time = 1000;
		held_time = [];
		held_time["axis"] = undefined;
		held_time["allies"] = undefined;
		held_prev = "none";
		start_time = getTime();

		while ((getTime() - start_time) <= zone_time || containment_zones.size == 1)
		{
			if (containment_zones.size > 1)
			{
				spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

				foreach (spawn_point in spawn_points)
				{
					if (spawn_point.script_noteworthy == zone_name_to_lock)
					{
						spawn_point.locked = 1;
					}
				}
			}

			zombies = get_round_enemy_array();
			players = get_players();
			in_containment_zone = [];
			in_containment_zone["axis"] = [];
			in_containment_zone["allies"] = [];
			show_next_obj_waypoint = (getTime() - start_time) >= (zone_time - next_obj_waypoint_time);

			foreach (player in players)
			{
				player_zone_name = player get_current_zone();

				if (isDefined(player_zone_name) && player_zone_name == zone_name)
				{
					if (is_player_valid(player))
					{
						if (!isDefined(level.meat_player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
						{
							player.ignoreme = 0;
						}

						in_containment_zone[player.team][in_containment_zone[player.team].size] = player;
					}

					if (!is_true(player.in_containment_zone))
					{
						player.in_containment_zone = 1;

						player thread show_grief_hud_msg(&"ZOMBIE_PLAYER_IN_CONTAINMENT_ZONE");
					}

					player containment_set_obj_waypoint_on_screen();
				}
				else
				{
					if (is_player_valid(player) && !isDefined(level.meat_player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
					{
						close_zombies = get_array_of_closest(player.origin, zombies, undefined, 1, 64);

						player.ignoreme = close_zombies.size == 0;
					}

					if (is_true(player.in_containment_zone))
					{
						player.in_containment_zone = undefined;

						player thread show_grief_hud_msg(&"ZOMBIE_PLAYER_OUT_CONTAINMENT_ZONE");
					}

					player containment_set_obj_waypoint_off_screen(zone_name, zone);
				}

				if (containment_zones.size > 1 && show_next_obj_waypoint)
				{
					player_zone_name = player get_current_zone();

					if (isDefined(player_zone_name) && player_zone_name == next_zone_name)
					{
						player containment_set_obj_waypoint_on_screen(1);
					}
					else
					{
						player containment_set_obj_waypoint_off_screen(next_zone_name, next_zone, 1);
					}

					player containment_set_obj_waypoint_icon("white_waypoint_target", 1);
				}
				else
				{
					player.next_obj_waypoint.alpha = 0;
				}
			}

			team_diff = abs(get_players("axis").size - get_players("allies").size);

			if (team_diff > 0)
			{
				team = "axis";

				if (get_players("allies").size < get_players("axis").size)
				{
					team = "allies";
				}

				if (in_containment_zone[team].size > 0)
				{
					for (i = 0; i < team_diff; i++)
					{
						in_containment_zone[team][in_containment_zone[team].size] = level;
					}
				}
			}

			foreach (team in level.teams)
			{
				grief_score_hud_set_player_count(team, in_containment_zone[team].size);
			}

			if (in_containment_zone["axis"].size == in_containment_zone["allies"].size && in_containment_zone["axis"].size > 0 && in_containment_zone["allies"].size > 0)
			{
				foreach (player in players)
				{
					player.obj_waypoint.color = (1, 1, 0);
					player containment_set_obj_waypoint_icon("white_waypoint_contested");
				}

				grief_score_hud_set_obj_icon("contested");

				if (held_prev != "cont")
				{
					foreach (player in players)
					{
						player thread print_containment_msg(&"ZOMBIE_CONTAINMENT_ZONE_CONTESTED");
					}

					obj_time = 2000;
					held_time["axis"] = getTime();
					held_time["allies"] = getTime();
					held_prev = "cont";
				}

				if ((level.grief_score["A"] + 1) >= get_gamemode_winning_score() || (level.grief_score["B"] + 1) >= get_gamemode_winning_score())
				{
					held_time["axis"] = undefined;
					held_time["allies"] = undefined;
				}
			}
			else if (in_containment_zone["axis"].size > in_containment_zone["allies"].size)
			{
				foreach (player in players)
				{
					if (player.team == "axis")
					{
						player.obj_waypoint.color = (0, 1, 0);
						player containment_set_obj_waypoint_icon("white_waypoint_defend");
					}
					else
					{
						player.obj_waypoint.color = (1, 0, 0);
						player containment_set_obj_waypoint_icon("white_waypoint_capture");
					}
				}

				grief_score_hud_set_obj_icon("axis");

				if (held_prev != "axis")
				{
					foreach (player in players)
					{
						if (player.team == "axis")
						{
							player thread print_containment_msg(&"ZOMBIE_YOUR_TEAM_CONTAINMENT_ZONE");
						}
						else
						{
							player thread print_containment_msg(&"ZOMBIE_OTHER_TEAM_CONTAINMENT_ZONE");
						}
					}

					obj_time = 1000;

					if (!isDefined(held_time["axis"]))
					{
						held_time["axis"] = getTime();
					}

					held_time["allies"] = undefined;
					held_prev = "axis";
				}
			}
			else if (in_containment_zone["allies"].size > in_containment_zone["axis"].size)
			{
				foreach (player in players)
				{
					if (player.team == "axis")
					{
						player.obj_waypoint.color = (1, 0, 0);
						player containment_set_obj_waypoint_icon("white_waypoint_capture");
					}
					else
					{
						player.obj_waypoint.color = (0, 1, 0);
						player containment_set_obj_waypoint_icon("white_waypoint_defend");
					}
				}

				grief_score_hud_set_obj_icon("allies");

				if (held_prev != "allies")
				{
					foreach (player in players)
					{
						if (player.team == "axis")
						{
							player thread print_containment_msg(&"ZOMBIE_OTHER_TEAM_CONTAINMENT_ZONE");
						}
						else
						{
							player thread print_containment_msg(&"ZOMBIE_YOUR_TEAM_CONTAINMENT_ZONE");
						}
					}

					obj_time = 1000;

					if (!isDefined(held_time["allies"]))
					{
						held_time["allies"] = getTime();
					}

					held_time["axis"] = undefined;
					held_prev = "allies";
				}
			}
			else
			{
				foreach (player in players)
				{
					if (is_player_valid(player))
					{
						if (!isDefined(level.meat_player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
						{
							player.ignoreme = 0;
						}
					}

					player.obj_waypoint.color = (1, 1, 1);
					player containment_set_obj_waypoint_icon("white_waypoint_target");
				}

				grief_score_hud_set_obj_icon("neutral");

				if (held_prev != "none")
				{
					foreach (player in players)
					{
						player thread print_containment_msg(&"ZOMBIE_CONTAINMENT_ZONE_UNCONTROLLED");
					}

					held_time["axis"] = undefined;
					held_time["allies"] = undefined;
					held_prev = "none";
				}
			}

			if (isDefined(held_time["axis"]))
			{
				if ((getTime() - held_time["axis"]) >= obj_time)
				{
					held_time["axis"] = getTime();

					foreach (player in in_containment_zone["axis"])
					{
						if (!isPlayer(player))
						{
							continue;
						}

						score = 50 * maps\mp\zombies\_zm_score::get_points_multiplier(player);
						player maps\mp\zombies\_zm_score::add_to_player_score(score);
						player.captures++;
					}

					increment_score("axis", undefined, !isDefined(held_time["allies"]));
				}
			}

			if (isDefined(held_time["allies"]))
			{
				if ((getTime() - held_time["allies"]) >= obj_time)
				{
					held_time["allies"] = getTime();

					foreach (player in in_containment_zone["allies"])
					{
						if (!isPlayer(player))
						{
							continue;
						}

						score = 50 * maps\mp\zombies\_zm_score::get_points_multiplier(player);
						player maps\mp\zombies\_zm_score::add_to_player_score(score);
						player.captures++;
					}

					increment_score("allies", undefined, !isDefined(held_time["axis"]));
				}
			}

			wait 0.05;
		}

		zombies = get_round_enemy_array();

		if (isDefined(zombies))
		{
			for (i = 0; i < zombies.size; i++)
			{
				if (!isDefined(zombies[i] get_current_zone()) || zombies[i] get_current_zone() == zone_name)
				{
					zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
				}
			}
		}

		spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

		foreach (spawn_point in spawn_points)
		{
			if (spawn_point.script_noteworthy == zone_name_to_lock)
			{
				spawn_point.locked = 0;
			}
		}

		ind++;

		if (ind >= containment_zones.size)
		{
			ind = 0;
		}
	}
}

containment_get_zones()
{
	containment_zones = [];

	if (level.script == "zm_transit")
	{
		if (level.scr_zm_map_start_location == "transit")
		{
			containment_zones = array("zone_pri", "zone_pri2", "zone_station_ext", "zone_trans_2b");
		}
		else if (level.scr_zm_map_start_location == "diner")
		{
			containment_zones = array("zone_gas", "zone_roadside_west", "zone_roadside_east", "zone_gar", "zone_din");
		}
		else if (level.scr_zm_map_start_location == "farm")
		{
			containment_zones = array("zone_far_ext", "zone_brn", "zone_farm_house");
		}
		else if (level.scr_zm_map_start_location == "power")
		{
			containment_zones = array("zone_pow", "zone_trans_8", "zone_prr", "zone_pcr", "zone_pow_warehouse");
		}
		else if (level.scr_zm_map_start_location == "town")
		{
			containment_zones = array("zone_tow", "zone_town_north", "zone_town_south", "zone_town_east", "zone_town_west", "zone_bar", "zone_town_barber", "zone_ban");
		}
		else if (level.scr_zm_map_start_location == "tunnel")
		{
			containment_zones = array("zone_amb_tunnel");
		}
		else if (level.scr_zm_map_start_location == "cornfield")
		{
			containment_zones = array("zone_amb_cornfield", "zone_cornfield_prototype");
		}
	}
	else if (level.script == "zm_nuked")
	{
		if (level.scr_zm_map_start_location == "nuked")
		{
			containment_zones = array("culdesac_yellow_zone", "culdesac_green_zone", "openhouse1_f1_zone", "openhouse2_f1_zone", "openhouse1_f2_zone", "openhouse2_f2_zone", "openhouse1_backyard_zone", "openhouse2_backyard_zone");
		}
	}
	else if (level.script == "zm_prison")
	{
		if (level.scr_zm_map_start_location == "cellblock")
		{
			containment_zones = array("zone_cellblock_west", "zone_cellblock_west_gondola", "zone_cellblock_west_barber", "zone_cellblock_east", "zone_start", "zone_library", "zone_cafeteria", "zone_warden_office");
		}
		else if (level.scr_zm_map_start_location == "docks")
		{
			containment_zones = array("zone_dock", "zone_dock_gondola", "zone_studio", "zone_citadel_basement_building");
		}
	}
	else if (level.script == "zm_buried")
	{
		if (level.scr_zm_map_start_location == "street")
		{
			containment_zones = array("zone_street_lightwest", "zone_street_darkwest", "zone_street_darkeast", "zone_stables", "zone_general_store", "zone_gun_store", "zone_underground_bar", "zone_underground_courthouse", "zone_toy_store", "zone_candy_store", "zone_street_fountain", "zone_church_main", "zone_mansion_lawn");
		}
		else if (level.scr_zm_map_start_location == "maze")
		{
			containment_zones = array("zone_maze", "zone_mansion_backyard", "zone_maze_staircase");
		}
	}

	containment_zones = array_randomize(containment_zones);

	return containment_zones;
}

containment_set_obj_waypoint_on_screen(next_obj = false)
{
	hud = self.obj_waypoint;

	if (next_obj)
	{
		hud = self.next_obj_waypoint;
	}

	if (isads(self))
	{
		hud fadeOverTime(0.25);
		hud.alpha = 0.25;
	}
	else
	{
		hud.alpha = 1;
	}

	hud.x = 0;
	hud.y = 140;
	hud.z = 0;

	hud.on_screen = 1;
}

containment_set_obj_waypoint_off_screen(zone_name, zone, next_obj = false)
{
	hud = self.obj_waypoint;

	if (next_obj)
	{
		hud = self.next_obj_waypoint;
	}

	hud.alpha = 1;

	if (level.script == "zm_transit" && zone_name == "zone_far_ext")
	{
		other_zone = level.zones["zone_farm_house"];
		other_zone2 = level.zones["zone_brn"];
		hud.x = (other_zone.volumes[0].origin[0] + other_zone2.volumes[0].origin[0]) / 2;
		hud.y = (other_zone.volumes[0].origin[1] + other_zone2.volumes[0].origin[1]) / 2;
		hud.z = (other_zone.volumes[0].origin[2] + other_zone2.volumes[0].origin[2]) / 2;
	}
	else if (level.script == "zm_transit" && zone_name == "zone_trans_8")
	{
		other_zone = level.zones["zone_pow_warehouse"];
		hud.x = (zone.volumes[0].origin[0] + other_zone.volumes[0].origin[0]) / 2;
		hud.y = (zone.volumes[0].origin[1] + other_zone.volumes[0].origin[1]) / 2;
		hud.z = (zone.volumes[0].origin[2] + other_zone.volumes[0].origin[2]) / 2;

		hud.x += 200;
	}
	else if (level.script == "zm_transit" && zone_name == "zone_town_west")
	{
		other_zone = level.zones["zone_town_barber"];
		other_zone2 = level.zones["zone_ban"];
		hud.x = (other_zone.volumes[0].origin[0] + other_zone2.volumes[0].origin[0]) / 2;
		hud.y = (other_zone.volumes[0].origin[1] + other_zone2.volumes[0].origin[1]) / 2;
		hud.z = (other_zone.volumes[0].origin[2] + other_zone2.volumes[0].origin[2]) / 2;
	}
	else if (level.script == "zm_buried" && zone_name == "zone_street_darkwest")
	{
		other_zone = level.zones["zone_gun_store"];
		other_zone2 = level.zones["zone_general_store"];
		other_zone3 = level.zones["zone_street_darkwest_nook"];
		hud.x = (other_zone.volumes[0].origin[0] + other_zone2.volumes[0].origin[0] + other_zone3.volumes[0].origin[0]) / 3;
		hud.y = (other_zone.volumes[0].origin[1] + other_zone2.volumes[0].origin[1] + other_zone3.volumes[0].origin[1]) / 3;
		hud.z = (other_zone.volumes[0].origin[2] + other_zone2.volumes[0].origin[2] + other_zone3.volumes[0].origin[2]) / 3;
	}
	else if (level.script == "zm_buried" && zone_name == "zone_street_darkeast")
	{
		other_zone = level.zones["zone_underground_bar"];
		other_zone2 = level.zones["zone_general_store"];
		other_zone3 = level.zones["zone_gun_store"];
		other_zone4 = level.zones["zone_toy_store"];
		hud.x = (other_zone.volumes[0].origin[0] + other_zone2.volumes[0].origin[0] + other_zone3.volumes[0].origin[0] + other_zone4.volumes[0].origin[0]) / 4;
		hud.y = (other_zone.volumes[0].origin[1] + other_zone2.volumes[0].origin[1] + other_zone3.volumes[0].origin[1] + other_zone4.volumes[0].origin[1]) / 4;
		hud.z = (other_zone.volumes[0].origin[2] + other_zone2.volumes[0].origin[2] + other_zone3.volumes[0].origin[2] + other_zone4.volumes[0].origin[2]) / 4;
	}
	else
	{
		hud.x = zone.volumes[0].origin[0];
		hud.y = zone.volumes[0].origin[1];
		hud.z = zone.volumes[0].origin[2];
	}

	if (level.script == "zm_nuked" && zone_name == "openhouse1_f1_zone")
	{
		hud.z -= 50;
	}
	else if (level.script == "zm_buried" && zone_name == "zone_maze")
	{
		hud.z += 200;
	}
	else if (level.script == "zm_prison" && zone_name == "zone_dock")
	{
		hud.z -= 100;
	}
	else if (level.script == "zm_prison" && zone_name == "zone_dock_gondola")
	{
		hud.z += 200;
	}
	else if (level.script == "zm_prison" && zone_name == "zone_dock_puzzle")
	{
		hud.z -= 250;
	}
	else if (level.script == "zm_prison" && zone_name == "zone_studio")
	{
		hud.x += 400;
	}

	// the 2 different types of waypoints are not aligned by default
	if (next_obj)
	{
		hud.z -= 12;
	}

	hud.on_screen = 0;
}

containment_set_obj_waypoint_icon(icon, next_obj = false)
{
	hud = self.obj_waypoint;

	if (next_obj)
	{
		hud = self.next_obj_waypoint;
	}

	if (hud.on_screen)
	{
		hud setShader(icon, getDvarInt("waypointIconWidth"), getDvarInt("waypointIconHeight"));
	}
	else
	{
		if (next_obj)
		{
			hud setShader(icon, 9, 9);
			hud setWaypoint(1);
		}
		else
		{
			hud setWaypoint(1, icon);
		}
	}
}

print_containment_msg(hint_string)
{
	self iprintln(hint_string);
}

meat_init()
{
	level._powerup_timeout_custom_time = ::meat_powerup_custom_time;

	level thread meat_powerup_drop_think();
	level thread meat_think();
}

meat_powerup_drop_think()
{
	level endon("end_game");

	level thread meat_powerup_drop_watcher();

	level waittill("restart_round_start");

	wait 10;

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_KILL_ZOMBIE_DROP_MEAT");
	}

	while (1)
	{
		level.zombie_powerup_ape = "meat_stink";
		level.zombie_vars["zombie_drop_item"] = 1;

		level waittill("powerup_dropped", powerup);

		if (powerup.powerup_name != "meat_stink")
		{
			continue;
		}

		players = get_players();

		foreach (player in players)
		{
			if (isdefined(level.meat_player) && level.meat_player == player)
			{
				continue;
			}

			player thread show_grief_hud_msg(&"ZOMBIE_MEAT_DROPPED");
		}

		level.meat_powerup = powerup;

		level waittill("meat_inactive");

		players = get_players();

		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_MEAT_RESET");
		}
	}
}

meat_powerup_drop_watcher()
{
	while (1)
	{
		level waittill("powerup_dropped", powerup);

		if (powerup.powerup_name != "meat_stink")
		{
			continue;
		}

		powerup thread meat_powerup_reset_on_timeout();
	}
}

meat_powerup_reset_on_timeout()
{
	level endon("meat_grabbed");

	self waittill("powerup_timedout");

	level notify("meat_inactive");
}

meat_waypoint_origin_destroy_on_death()
{
	self waittill("death");

	if (isDefined(self.obj_waypoint_origin))
	{
		self.obj_waypoint_origin unlink();
		self.obj_waypoint_origin delete();
	}
}

meat_think()
{
	level endon("end_game");

	held_time = undefined;
	obj_time = 1000;

	while (1)
	{
		players = get_players();

		if (isDefined(level.meat_player))
		{
			if (!isDefined(held_time))
			{
				held_time = getTime();
			}

			grief_score_hud_set_obj_icon(level.meat_player.team);

			foreach (player in players)
			{
				if (player == level.meat_player)
				{
					player.obj_waypoint.alpha = 0;
				}
				else
				{
					player.obj_waypoint.alpha = 1;

					if (player.team == level.meat_player.team)
					{
						player.obj_waypoint.color = (0, 1, 0);
						player.obj_waypoint setWaypoint(1, "white_waypoint_escort");
					}
					else
					{
						player.obj_waypoint.color = (1, 0, 0);
						player.obj_waypoint setWaypoint(1, "white_waypoint_kill");
					}

					player.obj_waypoint setTargetEnt(level.meat_player.head_icon_origin);
				}
			}

			if ((getTime() - held_time) >= obj_time)
			{
				held_time = getTime();

				score = 100 * maps\mp\zombies\_zm_score::get_points_multiplier(level.meat_player);
				level.meat_player maps\mp\zombies\_zm_score::add_to_player_score(score);

				level.meat_player.captures++;
				increment_score(level.meat_player.team);
			}
		}
		else
		{
			held_time = undefined;

			if (isDefined(level.item_meat))
			{
				if (!isDefined(level.item_meat.obj_waypoint_origin))
				{
					level.item_meat.obj_waypoint_origin = spawn("script_model", level.item_meat.origin);
					level.item_meat.obj_waypoint_origin setmodel("tag_origin");

					level.item_meat thread meat_waypoint_origin_destroy_on_death();
				}

				level.item_meat.obj_waypoint_origin.origin = level.item_meat.origin + (0, 0, 32);

				grief_score_hud_set_obj_icon("neutral");

				foreach (player in players)
				{
					player.obj_waypoint.alpha = 1;
					player.obj_waypoint.color = (1, 1, 1);
					player.obj_waypoint setWaypoint(1, "white_waypoint_grab");
					player.obj_waypoint setTargetEnt(level.item_meat.obj_waypoint_origin);
				}
			}
			else if (isDefined(level.meat_powerup))
			{
				if (!isDefined(level.meat_powerup.obj_waypoint_origin))
				{
					level.meat_powerup.obj_waypoint_origin = spawn("script_model", level.meat_powerup.origin + (0, 0, 32));
					level.meat_powerup.obj_waypoint_origin setmodel("tag_origin");

					level.meat_powerup thread meat_waypoint_origin_destroy_on_death();
				}

				grief_score_hud_set_obj_icon("neutral");

				foreach (player in players)
				{
					player.obj_waypoint.alpha = 1;
					player.obj_waypoint.color = (1, 1, 1);
					player.obj_waypoint setWaypoint(1, "white_waypoint_grab");
					player.obj_waypoint setTargetEnt(level.meat_powerup.obj_waypoint_origin);
				}
			}
			else
			{
				grief_score_hud_set_obj_icon("none");

				foreach (player in players)
				{
					player.obj_waypoint.alpha = 0;
				}
			}
		}

		wait 0.05;
	}
}

meat_powerup_custom_time(powerup)
{
	if (powerup.powerup_name == "meat_stink")
	{
		return 5;
	}

	return 15;
}

can_revive(revivee)
{
	if (self hasweapon(get_gamemode_var("item_meat_name")))
	{
		return false;
	}

	return true;
}

powerup_can_player_grab(player)
{
	if (self.powerup_name == "meat_stink")
	{
		if (player hasWeapon(get_gamemode_var("item_meat_name")) || is_true(player.dont_touch_the_meat))
		{
			return false;
		}
	}

	return true;
}

increment_score(team, amount = 1, show_lead_msg = true, score_msg)
{
	level endon("end_game");

	encounters_team = "A";

	if (team == "allies")
	{
		encounters_team = "B";
	}

	level.grief_score[encounters_team] += amount;

	if (level.grief_score[encounters_team] > get_gamemode_winning_score())
	{
		level.grief_score[encounters_team] = get_gamemode_winning_score();
	}

	foreach (hud_team in level.teams)
	{
		level.grief_score_hud[hud_team].score[team] setValue(level.grief_score[encounters_team]);
	}

	setteamscore(team, level.grief_score[encounters_team]);

	if (level.grief_score[encounters_team] >= get_gamemode_winning_score())
	{
		scripts\zm\replaced\_zm_game_module::game_won(encounters_team);
	}

	if (level.scr_zm_ui_gametype_obj == "zgrief")
	{
		score_left = get_gamemode_winning_score() - level.grief_score[encounters_team];

		players = get_players(team);

		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_DEAD", score_left);
		}

		if (level.grief_score[encounters_team] <= 3)
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(level.grief_score[encounters_team] + "_player_down", team);
		}
		else if (score_left <= 3)
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(score_left + "_player_left", team);
		}
	}

	if (level.scr_zm_ui_gametype_obj == "zrace")
	{
		if (isDefined(score_msg))
		{
			players = get_players(team);

			foreach (player in players)
			{
				player thread show_grief_hud_msg(score_msg, amount);
			}
		}
	}

	if (show_lead_msg)
	{
		if (!isDefined(level.prev_leader) || (level.prev_leader != encounters_team && level.grief_score[encounters_team] > level.grief_score[level.prev_leader]))
		{
			level.prev_leader = encounters_team;

			delay = undefined;

			if (level.scr_zm_ui_gametype_obj == "zgrief" || level.scr_zm_ui_gametype_obj == "zrace")
			{
				delay = 1;
			}

			players = get_players();

			foreach (player in players)
			{
				if (player.team == team)
				{
					player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_GAIN_LEAD", undefined, 30, delay);
				}
				else
				{
					player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_LOSE_LEAD", undefined, 30, delay);
				}
			}
		}
	}
}