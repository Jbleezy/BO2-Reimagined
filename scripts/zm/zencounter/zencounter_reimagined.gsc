#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

main()
{
	replaceFunc(maps\mp\gametypes_zm\zgrief::onprecachegametype, scripts\zm\replaced\zgrief::onprecachegametype);
	replaceFunc(maps\mp\gametypes_zm\zgrief::postinit_func, scripts\zm\replaced\zgrief::postinit_func);
	replaceFunc(maps\mp\gametypes_zm\zgrief::zgrief_main, scripts\zm\replaced\zgrief::zgrief_main);
	replaceFunc(maps\mp\gametypes_zm\zgrief::game_mode_spawn_player_logic, scripts\zm\replaced\zgrief::game_mode_spawn_player_logic);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_bounce_override, scripts\zm\replaced\zgrief::meat_bounce_override);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_stink, scripts\zm\replaced\zgrief::meat_stink);
	replaceFunc(maps\mp\gametypes_zm\zmeat::main, maps\mp\gametypes_zm\zgrief::main);
	replaceFunc(maps\mp\gametypes_zm\zmeat::create_item_meat_watcher, scripts\zm\replaced\zmeat::create_item_meat_watcher);
	replaceFunc(maps\mp\zombies\_zm_game_module_meat_utility::init_item_meat, scripts\zm\replaced\_zm_game_module_meat_utility::init_item_meat);

	if (getdvar("mapname") == "zm_nuked" || getdvar("mapname") == "zm_highrise" || getdvar("mapname") == "zm_tomb")
	{
		registerclientfield("toplayer", "meat_stink", 1, 1, "int");
	}

	registerclientfield("toplayer", "meat_glow", 1, 1, "int");

	if (getdvar("mapname") == "zm_prison" || getdvar("mapname") == "zm_tomb")
	{
		level._effect["butterflies"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_skull_elec");
	}
	else
	{
		level._effect["butterflies"] = loadfx("maps/zombie/fx_zmb_impact_noharm");
	}

	level._effect["zombie_disappears"] = loadfx("maps/zombie/fx_zmb_returned_spawn_puff");
}

init()
{
	set_grief_vars();

	precacheStatusIcon(level.item_meat_status_icon_name);

	precacheString(&"hud_update_game_mode_name");
	precacheString(&"hud_update_scoring_team");
	precacheString(&"hud_update_player_count");
	precacheString(&"hud_update_containment_zone");
	precacheString(&"hud_update_containment_time");
	precacheString(istring(toupper("ZMUI_" + level.scr_zm_ui_gametype)));
	precacheString(istring(toupper("ZMUI_" + level.scr_zm_ui_gametype + "_PRO")));

	precacheshellshock("grief_stun_zm");

	enemy_powerup_hud();
	obj_waypoint();

	if (level.scr_zm_ui_gametype == "zcontainment")
	{
		containment_init();
	}

	if (level.scr_zm_ui_gametype == "zmeat")
	{
		meat_init();
	}

	if (level.scr_zm_ui_gametype == "zturned")
	{
		turned_init();
	}

	add_custom_limited_weapon_check(::is_weapon_available_in_grief_saved_weapons);

	level.dont_allow_meat_interaction = 1;
	level.can_revive_game_module = ::can_revive;
	level._powerup_grab_check = ::powerup_can_player_grab;
	level._zombiemode_powerup_grab = ::powerup_grab;
	level.custom_spectate_permissions = undefined;

	level.get_gamemode_display_name_func = ::get_gamemode_display_name;
	level.is_respawn_gamemode_func = ::is_respawn_gamemode;
	level.round_start_wait_func = ::round_start_wait;
	level.increment_score_func = ::increment_score;
	level.grief_score_hud_set_player_count_func = ::grief_score_hud_set_player_count;
	level.show_grief_hud_msg_func = ::show_grief_hud_msg;
	level.store_player_damage_info_func = ::store_player_damage_info;

	level thread grief_gamemode_name_hud();
	level thread grief_intro_msg();
	level thread round_start_wait(5, true);
	level thread unlimited_zombies();
	level thread unlimited_powerups();
	level thread save_teams_on_intermission();

	if (is_true(level.scr_zm_ui_gametype_pro))
	{
		level thread remove_held_melee_weapons();
	}
}

grief_gamemode_name_hud()
{
	flag_wait("hud_visible");

	level.game_mode_name_hud_value = get_gamemode_display_name();

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_game_mode_name", 1, level.game_mode_name_hud_value);
	}
}

grief_score_hud_set_player_count(team, count, team2, count2)
{
	if (!isdefined(level.game_mode_player_count_hud_value))
	{
		level.game_mode_player_count_hud_value = [];
		level.game_mode_player_count_hud_value["allies"] = -1;
		level.game_mode_player_count_hud_value["axis"] = -1;
	}

	if (!isdefined(team2))
	{
		if (level.game_mode_player_count_hud_value[team] == count)
		{
			return;
		}
	}
	else
	{
		if (level.game_mode_player_count_hud_value[team] == count && level.game_mode_player_count_hud_value[team2] == count2)
		{
			return;
		}
	}

	level.game_mode_player_count_hud_value[team] = count;

	if (isdefined(team2))
	{
		level.game_mode_player_count_hud_value[team2] = count2;
	}

	players = get_players("allies");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_player_count", 2, level.game_mode_player_count_hud_value["allies"], level.game_mode_player_count_hud_value["axis"]);
	}

	players = get_players("axis");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_player_count", 2, level.game_mode_player_count_hud_value["axis"], level.game_mode_player_count_hud_value["allies"]);
	}
}

grief_score_hud_set_scoring_team(team)
{
	if (!isdefined(level.game_mode_scoring_team_hud_value))
	{
		level.game_mode_scoring_team_hud_value = [];
		level.game_mode_scoring_team_hud_value["allies"] = -1;
		level.game_mode_scoring_team_hud_value["axis"] = -1;
	}

	value = [];
	value["allies"] = 0;
	value["axis"] = 0;

	if (team == "neutral")
	{
		value["allies"] = 0;
		value["axis"] = 0;
	}
	else if (team == "allies")
	{
		value["allies"] = 1;
		value["axis"] = 2;
	}
	else if (team == "axis")
	{
		value["allies"] = 2;
		value["axis"] = 1;
	}
	else if (team == "contested")
	{
		value["allies"] = 3;
		value["axis"] = 3;
	}
	else if (team == "none")
	{
		value["allies"] = 4;
		value["axis"] = 4;
	}

	if (level.game_mode_scoring_team_hud_value["allies"] == value["allies"] && level.game_mode_scoring_team_hud_value["axis"] == value["axis"])
	{
		return;
	}

	level.game_mode_scoring_team_hud_value["allies"] = value["allies"];
	level.game_mode_scoring_team_hud_value["axis"] = value["axis"];

	players = get_players("allies");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_scoring_team", 1, level.game_mode_scoring_team_hud_value["allies"]);
	}

	players = get_players("axis");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_scoring_team", 1, level.game_mode_scoring_team_hud_value["axis"]);
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

obj_waypoint()
{
	if (level.scr_zm_ui_gametype == "zcontainment" || level.scr_zm_ui_gametype == "zmeat")
	{
		level.game_mode_obj_ind = 16;

		objective_state(level.game_mode_obj_ind, "active");
		objective_setgamemodeflags(level.game_mode_obj_ind, 0);
	}
}

set_grief_vars()
{
	setDvar("ui_scorelimit", 1);
	setteamscore("axis", 0);
	setteamscore("allies", 0);

	level.highest_score = 0;
	setroundsplayed(level.highest_score);

	level.noroundnumber = 1;
	level.hide_revive_message = 1;
	level.custom_end_screen = ::custom_end_screen;
	level.game_module_onplayerconnect = ::grief_onplayerconnect;
	level.game_mode_custom_onplayerdisconnect = ::grief_onplayerdisconnect;
	level._game_module_player_damage_callback = ::game_module_player_damage_callback;
	level._game_module_player_laststand_callback = ::grief_laststand_weapon_save;
	level.onplayerspawned_restore_previous_weapons = ::grief_laststand_weapons_return;

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

	level.player_starting_points = 10000;
	level.zombie_vars["zombie_powerup_drop_increment"] = level.player_starting_points * 4;

	level.zombie_move_speed = 100;
	level.zombie_vars["zombie_health_start"] = 2500;
	level.zombie_vars["zombie_health_increase"] = 0;
	level.zombie_vars["zombie_health_increase_multiplier"] = 0;
	level.zombie_vars["zombie_spawn_delay"] = 0.5;

	level.brutus_health = 20000;
	level.brutus_expl_dmg_req = 18000;
	level.mechz_health = 22500;

	if (level.item_meat_name == "item_head_zm")
	{
		level.item_meat_status_icon_name = "menu_zm_weapons_item_head";
	}
	else
	{
		level.item_meat_status_icon_name = "menu_zm_weapons_item_meat";
	}

	if (is_respawn_gamemode())
	{
		setDvar("player_lastStandBleedoutTime", 10);
	}
}

grief_onplayerconnect()
{
	self thread on_player_spawned();
	self thread on_player_downed();
	self thread on_player_revived();
	self thread on_player_bled_out();
	self thread on_player_zom_kill();

	self thread stun_fx();
	self thread headstomp_watcher();
	self thread decrease_upgraded_start_weapon_ammo();
	self thread maps\mp\gametypes_zm\zmeat::create_item_meat_watcher();

	self.killsconfirmed = 0;
	self.killsdenied = 0;
	self.captures = 0;

	if (is_respawn_gamemode())
	{
		self._retain_perks = 1;
	}
}

grief_onplayerdisconnect(disconnecting_player)
{
	level endon("end_game");

	if (isDefined(disconnecting_player.stun_fx_ents))
	{
		array_thread(disconnecting_player.stun_fx_ents, ::self_delete);
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

	if (level.scr_zm_ui_gametype == "zsr")
	{
		level thread update_players_on_disconnect(disconnecting_player);
	}

	if (level.scr_zm_ui_gametype == "zgrief")
	{
		if (disconnecting_player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			increment_score(getOtherTeam(disconnecting_player.team));
		}
	}

	if (level.scr_zm_ui_gametype == "zturned")
	{
		if (disconnecting_player.team != level.zombie_team)
		{
			increment_score(disconnecting_player.team, -1, 0, &"ZOMBIE_SURVIVOR_TURNED");
		}
	}

	count = get_players(disconnecting_player.team).size - 1;

	if (count <= 0)
	{
		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (disconnecting_player.team == level.zombie_team)
			{
				level thread the_disease_powerup_drop(disconnecting_player.origin);
			}
		}
		else
		{
			encounters_team = "A";

			if (getOtherTeam(disconnecting_player.team) == "allies")
			{
				encounters_team = "B";
			}

			scripts\zm\replaced\_zm_game_module::game_won(encounters_team);
		}
	}

	if (level.teamcount > 1)
	{
		team_var = "team_" + disconnecting_player.team;

		setDvar(team_var, getDvar(team_var) + disconnecting_player getguid() + " ");
	}
}

on_player_spawned()
{
	level endon("end_game");
	self endon("disconnect");

	self.grief_initial_spawn = true;
	self.turned_initial_spawn = true;

	while (1)
	{
		self waittill("spawned_player");
		waittillframeend;

		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (self.turned_initial_spawn)
			{
				self.turned_initial_spawn = false;

				if (self.team == level.zombie_team)
				{
					increment_score(getotherteam(self.team), 0, 0, &"ZOMBIE_SURVIVOR_TURNED");
				}
			}

			if (self.team == level.zombie_team)
			{
				self turned_zombie_spawn();
				continue;
			}
		}

		self thread scripts\zm\replaced\_zm::player_spawn_protection();

		if (self.grief_initial_spawn)
		{
			self.grief_initial_spawn = false;

			if (is_respawn_gamemode() && flag("start_zombie_round_logic"))
			{
				self giveWeapon(self get_player_lethal_grenade());
				self setWeaponAmmoClip(self get_player_lethal_grenade(), 2);
			}
		}

		if (level.scr_zm_ui_gametype == "zsr")
		{
			// round_start_wait resets these
			self freezeControls(1);
			self enableInvulnerability();
		}

		if (level.scr_zm_ui_gametype == "zcontainment")
		{
			self.in_containment_zone = undefined;
		}

		if (is_respawn_gamemode())
		{
			self thread player_spawn();
		}
	}
}

on_player_downed()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("entering_last_stand");

		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (self.team == level.zombie_team)
			{
				self thread turned_zombie_spectate_and_respawn();
				increment_score(self.team, -1, 0);
				continue;
			}

			if (self.team != level.zombie_team)
			{
				increment_score(self.team, -1, 0, &"ZOMBIE_SURVIVOR_DOWN");
			}
		}

		self kill_feed();
		self add_grief_downed_score();

		if (level.scr_zm_ui_gametype == "zrace")
		{
			increment_score(getOtherTeam(self.team), 10, 1, &"ZOMBIE_ZGRIEF_PLAYER_BLED_OUT_SCORE");
		}

		if (level.scr_zm_ui_gametype == "zsr")
		{
			level thread update_players_on_downed(self);
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

		if (isDefined(reviver) && reviver != self)
		{
			self revive_feed(reviver);

			if (level.scr_zm_ui_gametype == "zrace")
			{
				increment_score(reviver.team, 5, 1, &"ZOMBIE_ZGRIEF_ALLY_REVIVED_SCORE");
			}

			if (level.scr_zm_ui_gametype == "zsr")
			{
				level thread update_players_on_revived(self, reviver);
			}

			if (level.scr_zm_ui_gametype == "zturned")
			{
				if (self.team != level.zombie_team)
				{
					increment_score(self.team, 1, 0, &"ZOMBIE_SURVIVOR_REVIVED");
				}
			}
		}
	}
}

on_player_bled_out()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill_any("bled_out", "player_suicide");
		waittillframeend;

		if (isDefined(level.zombie_last_stand_ammo_return))
		{
			self [[level.zombie_last_stand_ammo_return]](1);
		}

		if (!is_respawn_gamemode() || is_true(self.playersuicided))
		{
			self thread bleedout_feed();
		}

		if (level.scr_zm_ui_gametype == "zgrief")
		{
			increment_score(getOtherTeam(self.team));
		}

		if (level.scr_zm_ui_gametype == "zsr")
		{
			self.init_player_offhand_weapons_override = 1;
			self init_player_offhand_weapons();
			self.init_player_offhand_weapons_override = undefined;
			self add_grief_bleedout_score();
			level thread update_players_on_bleedout(self);
		}

		if (level.scr_zm_ui_gametype == "zrace")
		{
			increment_score(getOtherTeam(self.team), 5, 1, &"ZOMBIE_ZGRIEF_PLAYER_DEAD_SCORE");
		}

		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (self.team != level.zombie_team)
			{
				self thread turned_zombie_init();
			}
		}

		if (is_respawn_gamemode())
		{
			if (is_true(self.playersuicided))
			{
				self thread player_spectate_and_respawn();
			}
			else
			{
				self maps\mp\zombies\_zm::spectator_respawn();
			}
		}
	}
}

on_player_zom_kill()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("zom_kill", zombie);

		if (level.scr_zm_ui_gametype == "zrace")
		{
			amount = 1;
			score_msg = undefined;

			if (is_true(zombie.is_brutus) || is_true(zombie.is_mechz))
			{
				amount = 10;
				score_msg = &"ZOMBIE_ZGRIEF_BOSS_KILLED_SCORE";
			}

			increment_score(self.team, amount, 1, score_msg);
		}
		else if (level.scr_zm_ui_gametype == "zturned")
		{
			amount = -1;

			if (is_true(zombie.is_brutus) || is_true(zombie.is_mechz))
			{
				amount = -10;
			}

			increment_score(level.zombie_team, amount, 0);
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

		obituary(self, self.last_emped_by.attacker, "emp_grenade_zm", "MOD_UNKNOWN");
	}
	else
	{
		obituary(self, self, "none", "MOD_CRUSH");
	}
}

bleedout_feed()
{
	if (is_true(self.playersuicided))
	{
		wait 0.05;
	}

	obituary(self, self, "none", "MOD_SUICIDE");
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

player_spawn()
{
	if (self.score < level.player_starting_points)
	{
		self.score = level.player_starting_points;
	}

	if (flag("initial_blackscreen_passed"))
	{
		playfx(level._effect["zombie_disappears"], self.origin);
		playsoundatposition("evt_appear_3d", self.origin);
		earthquake(0.5, 0.75, self.origin, 100);
		playrumbleonposition("explosion_generic", self.origin);
	}
}

player_spectate_and_respawn()
{
	self endon("disconnect");

	time = self.bleedout_time;

	if (!isdefined(time))
	{
		time = 0;
	}

	time += 1;

	wait time;

	self.sessionstate = "playing";

	self maps\mp\zombies\_zm::spectator_respawn();
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

stun_fx()
{
	self endon("disconnect");

	self scripts\zm\_zm_reimagined::waittill_next_snapshot(1);

	self.stun_fx_ents = [];
	self.stun_fx_ind = 0;

	for (i = 0; i < 3; i++)
	{
		self.stun_fx_ents[i] = spawn("script_model", self.origin);
		self.stun_fx_ents[i] setmodel("tag_origin");
		self.stun_fx_ents[i] linkto(self);
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
			if (player != self && player.team != self.team && is_player_valid(player) && player getStance() == "prone" && player isOnGround() && self.origin[2] > player.origin[2])
			{
				if (distance2d(self.origin, player.origin) <= 21 && (self.origin[2] - player.origin[2]) <= 30)
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

	if (level.scr_zm_ui_gametype == "zsr")
	{
		grief_score_hud_set_player_count("allies", 0, "axis", 0);
		grief_score_hud_set_player_count("allies", get_number_of_valid_players_team("allies"), "axis", get_number_of_valid_players_team("axis"));
	}

	zombie_spawn_time = time + 10;

	level thread zombie_spawn_wait(zombie_spawn_time);

	text = &"MP_MATCH_STARTING_IN";
	text_param = undefined;

	if (level.scr_zm_ui_gametype == "zsr")
	{
		text = &"ZOMBIE_ROUND_STARTING_IN";
		text_param = level.scr_zm_ui_round_number;
	}

	countdown_hud = scripts\zm\_zm_reimagined::countdown_hud(text, text_param, time);

	wait time;

	countdown_hud scripts\zm\_zm_reimagined::countdown_hud_destroy();

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

	foreach (player in players)
	{
		if (other_players_remaining > 0)
		{
			if (players_remaining == 0)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALL_ALLIES_DOWN");
			}
			else
			{
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALLY_BLED_OUT", players_remaining, other_players_remaining);
			}
		}
	}

	foreach (player in other_players)
	{
		if (other_players_remaining > 0)
		{
			if (players_remaining == 0)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALL_PLAYERS_DOWN");
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_SURVIVE", undefined, undefined, 30, 1);
			}
			else
			{
				player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_BLED_OUT", other_players_remaining, players_remaining);
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

	foreach (player in players)
	{
		if (other_players_remaining > 0)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALLY_REVIVED", players_remaining, other_players_remaining);
		}
	}

	foreach (player in other_players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_REVIVED", other_players_remaining, players_remaining);
	}
}

update_players_on_disconnect(excluded_player)
{
	if (is_player_valid(excluded_player))
	{
		update_players_on_downed(excluded_player);
	}
}

grief_intro_msg()
{
	level endon("end_game");

	flag_init("grief_intro_msg_complete");

	level waittill("restart_round_start");

	intro_str = istring(toupper("ZOMBIE_" + level.scr_zm_ui_gametype + "_INTRO"));

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(intro_str);
	}

	wait 5;

	to_win_str = &"ZOMBIE_GRIEF_SCORE_TO_WIN";

	if (level.scr_zm_ui_gametype == "zsr")
	{
		to_win_str = &"ZOMBIE_GRIEF_ROUNDS_TO_WIN";
	}
	else if (level.scr_zm_ui_gametype == "zturned")
	{
		to_win_str = &"ZOMBIE_GRIEF_REDUCE_ENEMY_SCORE_TO_WIN";
	}

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(to_win_str, get_gamemode_winning_score());
	}

	wait 5;

	flag_set("grief_intro_msg_complete");
}

get_gamemode_display_name(gamemode = level.scr_zm_ui_gametype)
{
	if (is_true(level.scr_zm_ui_gametype_pro))
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
	if (level.scr_zm_ui_gametype == "zgrief")
	{
		return 10;
	}
	else if (level.scr_zm_ui_gametype == "zrace")
	{
		return 500;
	}
	else if (level.scr_zm_ui_gametype == "zcontainment")
	{
		return 250;
	}
	else if (level.scr_zm_ui_gametype == "zmeat")
	{
		return 200;
	}
	else if (level.scr_zm_ui_gametype == "zsr")
	{
		return 3;
	}
	else if (level.scr_zm_ui_gametype == "zturned")
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

is_respawn_gamemode()
{
	return is_encounter() && level.scr_zm_ui_gametype != "zsr" && level.scr_zm_ui_gametype != "zturned";
}

show_grief_hud_msg(msg, msg_parm1, msg_parm2, offset, delay)
{
	level endon("end_game");
	level endon("restart_round");
	self endon("disconnect");

	while (isDefined(level.hostmigrationtimer))
	{
		wait 0.05;
	}

	if (isDefined(delay))
	{
		wait delay;
	}

	if (!flag("grief_intro_msg_complete"))
	{
		if (isDefined(offset))
		{
			self notify("show_grief_hud_msg2_grief_intro_msg_complete");
			self endon("show_grief_hud_msg2_grief_intro_msg_complete");

			flag_wait("grief_intro_msg_complete");
		}
	}

	if (!isDefined(offset))
	{
		self notify("show_grief_hud_msg");
	}
	else
	{
		self notify("show_grief_hud_msg2");
	}

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

	if (isDefined(msg_parm2))
	{
		zgrief_hudmsg settext(msg, msg_parm1, msg_parm2);
	}
	else if (isDefined(msg_parm1))
	{
		zgrief_hudmsg settext(msg, msg_parm1);
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
	self thread show_grief_hud_msg_cleanup_restart_round();

	if (!isDefined(offset))
	{
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

		return;
	}

	if (issubstr(sweapon, "one_inch_punch") && idamage <= 5)
	{
		return;
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

	if (isplayer(eattacker) && isDefined(eattacker._encounters_team) && eattacker._encounters_team != self._encounters_team)
	{
		if (is_true(eattacker.is_zombie) || is_true(self.is_zombie))
		{
			self store_player_damage_info(eattacker, sweapon, smeansofdeath);
			return;
		}

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

		sweapon = get_nonalternate_weapon(sweapon);

		if (!is_true(self._being_shellshocked) || is_melee)
		{
			self store_player_damage_info(eattacker, sweapon, smeansofdeath);
		}

		if (is_true(self._being_shellshocked))
		{
			return;
		}

		self do_game_mode_stun_score_steal(eattacker);

		if (isDefined(level._effect["butterflies"]))
		{
			self do_game_mode_stun_fx(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
		}

		self thread do_game_mode_shellshock(is_melee, is_weapon_upgraded(sweapon));
		self playsound("zmb_player_hit_ding");
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

	if (level.scr_zm_ui_gametype == "zrace")
	{
		increment_score(eattacker.team);
	}
}

do_game_mode_stun_fx(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	pos = vpoint;
	angle = vectortoangles(vpoint - self getcentroid());
	is_perk_damage = isdefined(sweapon) && issubstr(sweapon, "zombie_perk_bottle");

	if (smeansofdeath == "MOD_GRENADE_SPLASH" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || is_perk_damage)
	{
		pos = self getcentroid() + vectornormalize((vpoint - self getcentroid()) * (1, 1, 0)) * 8;
	}

	angle = (0, angle[1], 0);

	stun_fx_ent = self.stun_fx_ents[self.stun_fx_ind];
	stun_fx_ent unlink();
	stun_fx_ent.origin = pos;
	stun_fx_ent.angles = angle;
	stun_fx_ent linkto(self);

	playfxontag(level._effect["butterflies"], stun_fx_ent, "tag_origin");

	self.stun_fx_ind = (self.stun_fx_ind + 1) % self.stun_fx_ents.size;
}

do_game_mode_shellshock(is_melee = 0, is_upgraded = 0)
{
	self notify("do_game_mode_shellshock");
	self endon("do_game_mode_shellshock");
	self endon("disconnect");

	name = "grief_stun_zm";

	if (is_upgraded || is_melee)
	{
		name = "grief_stab_zm";
	}

	self._being_shellshocked = 1;
	self shellshock(name, 0.75);

	wait 0.75;

	self._being_shellshocked = 0;
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
	self.grief_savedweapon_weapons = self getweaponslistprimaries();
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
	self.grief_hastimebomb = self hasweapon("time_bomb_zm") || self hasweapon("time_bomb_detonator_zm");
	self.grief_hasriotshield = undefined;
	self.grief_savedperks = [];

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

	if (is_true(self.grief_hastimebomb))
	{
		self.grief_savedweapon_timebomb_clip = 1;

		if (self hasweapon("time_bomb_detonator_zm"))
		{
			self.grief_savedweapon_timebomb_clip = 0;
		}
	}

	if (isDefined(self.hasriotshield) && self.hasriotshield)
	{
		self.grief_hasriotshield = 1;
	}

	if (isdefined(self.perks_active))
	{
		self.grief_savedperks = arraycombine(self.grief_savedperks, self.perks_active, 0, 0);
	}

	if (isdefined(self.perks_disabled))
	{
		self.grief_savedperks = arraycombine(self.grief_savedperks, self.perks_disabled, 0, 0);
	}
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

	primary_weapons_given = 0;
	i = 0;

	while (i < self.grief_savedweapon_weapons.size)
	{
		if (primary_weapons_given >= get_player_weapon_limit(self))
		{
			break;
		}

		primary_weapons_given++;

		if (isDefined(self.stored_weapon_info) && isDefined(self.stored_weapon_info[self.grief_savedweapon_weapons[i]]) && isDefined(self.stored_weapon_info[self.grief_savedweapon_weapons[i]].used_amt))
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
		self giveweapon(self.grief_savedweapon_melee);
		self set_player_melee_weapon(self.grief_savedweapon_melee);
		self giveweapon("held_" + self.grief_savedweapon_melee);
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

	if (is_true(self.grief_hastimebomb))
	{
		if (self.grief_savedweapon_timebomb_clip == 1)
		{
			self giveweapon("time_bomb_zm");
			self setactionslot(2, "weapon", "time_bomb_zm");
		}
		else
		{
			self giveweapon("time_bomb_detonator_zm");
			self setweaponammoclip("time_bomb_detonator_zm", 0);
			self setweaponammostock("time_bomb_detonator_zm", 0);
			self setactionslot(2, "weapon", "time_bomb_detonator_zm");
			self giveweapon("time_bomb_zm");
		}
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

		if (!self.is_drinking)
		{
			self.pre_temp_weapon = undefined;
		}
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

save_teams_on_intermission()
{
	if (!isDedicated())
	{
		return;
	}

	level waittill("intermission");

	axis_guids = "";
	allies_guids = "";

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

	setDvar("team_axis", axis_guids);
	setDvar("team_allies", allies_guids);
}

containment_init()
{
	level thread containment_think();
}

containment_think()
{
	level endon("end_game");

	flag_wait("hud_visible");

	ind = 0;
	containment_zones = containment_get_zones();

	if (containment_zones.size > 1)
	{
		players = get_players();

		level.containment_zone_hud_value = &"";
		level.containment_time_hud_value = -1;

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_containment_zone", 1, level.containment_zone_hud_value);
			player luinotifyevent(&"hud_update_containment_time", 1, level.containment_time_hud_value);
		}
	}

	flag_wait("initial_blackscreen_passed");

	grief_score_hud_set_scoring_team("none");

	level waittill("restart_round_start");

	next_zone_name = containment_zones[ind];
	next_zone = level.zones[next_zone_name];
	next_zone_origin = containment_get_zone_waypoint_origin(next_zone_name, next_zone);

	wait 10;

	while (1)
	{
		zone_name = next_zone_name;
		zone_display_name = scripts\zm\_zm_reimagined::get_zone_display_name(zone_name);
		zone = next_zone;
		zone_origin = next_zone_origin;

		ind++;

		if (ind >= containment_zones.size)
		{
			ind = 0;
		}

		next_zone_name = containment_zones[ind];
		next_zone = level.zones[next_zone_name];
		next_zone_origin = containment_get_zone_waypoint_origin(next_zone_name, next_zone);

		objective_position(level.game_mode_obj_ind, zone_origin);
		objective_team(level.game_mode_obj_ind, "neutral");
		objective_setgamemodeflags(level.game_mode_obj_ind, 1);

		zone_name_to_lock = containment_get_zone_name_to_lock(zone_name);

		players = get_players();

		foreach (player in players)
		{
			player.in_containment_zone = undefined;

			player thread show_grief_hud_msg(&"ZOMBIE_NEW_CONTAINMENT_ZONE");
		}

		if (containment_zones.size > 1)
		{
			level.containment_zone_hud_value = zone_display_name;

			foreach (player in players)
			{
				player luinotifyevent(&"hud_update_containment_zone", 1, level.containment_zone_hud_value);
			}

			level thread containment_time_hud_countdown(60);
		}

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

			zombies = getaispeciesarray(level.zombie_team, "all");
			players = get_players();
			in_containment_zone = [];
			in_containment_zone["axis"] = [];
			in_containment_zone["allies"] = [];
			show_next_obj_waypoint = (getTime() - start_time) >= (zone_time - next_obj_waypoint_time);

			foreach (player in players)
			{
				player_zone_name = player containment_get_current_zone();

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
					}

					objective_setplayerusing(level.game_mode_obj_ind, player);
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
					}

					objective_clearplayerusing(level.game_mode_obj_ind, player);
				}

			}

			grief_score_hud_set_player_count("allies", in_containment_zone["allies"].size, "axis", in_containment_zone["axis"].size);

			if (in_containment_zone["axis"].size == in_containment_zone["allies"].size && in_containment_zone["axis"].size > 0 && in_containment_zone["allies"].size > 0)
			{
				objective_team(level.game_mode_obj_ind, "team3");

				grief_score_hud_set_scoring_team("contested");

				if (held_prev != "cont")
				{
					obj_time = 2000;
					held_time["axis"] = getTime();
					held_time["allies"] = getTime();
					held_prev = "cont";
				}
			}
			else if (in_containment_zone["axis"].size > in_containment_zone["allies"].size)
			{
				objective_team(level.game_mode_obj_ind, "axis");

				grief_score_hud_set_scoring_team("axis");

				if (held_prev != "axis")
				{
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
				objective_team(level.game_mode_obj_ind, "allies");

				grief_score_hud_set_scoring_team("allies");

				if (held_prev != "allies")
				{
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
				}

				objective_team(level.game_mode_obj_ind, "neutral");

				grief_score_hud_set_scoring_team("neutral");

				if (held_prev != "none")
				{
					held_time["axis"] = undefined;
					held_time["allies"] = undefined;
					held_prev = "none";
				}
			}

			contested_on_tied_final_score = isDefined(held_time["axis"]) && isDefined(held_time["allies"]) && (level.grief_score["A"] + 1) >= get_gamemode_winning_score() && (level.grief_score["B"] + 1) >= get_gamemode_winning_score();

			if (!contested_on_tied_final_score)
			{
				low_score_team = "axis";
				high_score_team = "allies";

				if (level.grief_score["B"] < level.grief_score["A"])
				{
					low_score_team = "allies";
					high_score_team = "axis";
				}

				if (isDefined(held_time[low_score_team]) && (getTime() - held_time[low_score_team]) >= obj_time)
				{
					held_time[low_score_team] = getTime();

					foreach (player in in_containment_zone[low_score_team])
					{
						if (!isPlayer(player))
						{
							continue;
						}

						score = 50 * maps\mp\zombies\_zm_score::get_points_multiplier(player);
						player maps\mp\zombies\_zm_score::add_to_player_score(score);
						player.captures++;
					}

					increment_score(low_score_team, undefined, !isDefined(held_time[high_score_team]));
				}

				if (isDefined(held_time[high_score_team]) && (getTime() - held_time[high_score_team]) >= obj_time)
				{
					held_time[high_score_team] = getTime();

					foreach (player in in_containment_zone[high_score_team])
					{
						if (!isPlayer(player))
						{
							continue;
						}

						score = 50 * maps\mp\zombies\_zm_score::get_points_multiplier(player);
						player maps\mp\zombies\_zm_score::add_to_player_score(score);
						player.captures++;
					}

					increment_score(high_score_team, undefined, !isDefined(held_time[low_score_team]));
				}
			}

			wait 0.05;
		}

		zombies = get_round_enemy_array();

		for (i = 0; i < zombies.size; i++)
		{
			if (!isDefined(zombies[i] containment_get_current_zone()) || zombies[i] containment_get_current_zone() == zone_name)
			{
				zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
			}
		}

		spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

		if (maps\mp\zombies\_zm_zonemgr::zone_is_enabled(zone_name_to_lock))
		{
			foreach (spawn_point in spawn_points)
			{
				if (spawn_point.script_noteworthy == zone_name_to_lock)
				{
					spawn_point.locked = 0;
				}
			}
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
	else if (level.script == "zm_highrise")
	{
		if (level.scr_zm_map_start_location == "shopping_mall")
		{
			containment_zones = array("zone_green_start", "zone_green_level1", "zone_green_level2a", "zone_green_level2b", "zone_green_level3a", "zone_green_level3b", "zone_green_level3c");
		}
		else if (level.scr_zm_map_start_location == "dragon_rooftop")
		{
			containment_zones = array("zone_blue_level1a", "zone_blue_level1b", "zone_blue_level1c", "zone_blue_level2a", "zone_blue_level2b", "zone_blue_level2c");
		}
		else if (level.scr_zm_map_start_location == "sweatshop")
		{
			containment_zones = array("zone_blue_level4a", "zone_blue_level4b", "zone_blue_level4c", "zone_blue_level5");
		}
	}
	else if (level.script == "zm_prison")
	{
		if (level.scr_zm_map_start_location == "cellblock")
		{
			containment_zones = array("zone_start", "zone_library", "zone_cellblock_west", "zone_cellblock_west_gondola", "zone_cellblock_west_barber", "zone_cellblock_east", "zone_cafeteria", "zone_warden_office");
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
	else if (level.script == "zm_tomb")
	{
		if (level.scr_zm_map_start_location == "trenches")
		{
			containment_zones = array("zone_start_b", "zone_bunker_3a", "zone_bunker_4a", "zone_bunker_5a");
		}
		else if (level.scr_zm_map_start_location == "excavation_site")
		{
			containment_zones = array("zone_nml_farm", "zone_nml_11", "zone_nml_18");
		}
		else if (level.scr_zm_map_start_location == "church")
		{
			containment_zones = array("zone_village_1", "zone_village_2", "zone_village_3a");
		}
		else if (level.scr_zm_map_start_location == "crazy_place")
		{
			containment_zones = array("zone_chamber_0", "zone_chamber_2", "zone_chamber_4", "zone_chamber_6", "zone_chamber_8");
		}
	}

	containment_zones = array_randomize(containment_zones);

	return containment_zones;
}

containment_get_zone_waypoint_origin(zone_name, zone)
{
	if (level.script == "zm_transit")
	{
		if (zone_name == "zone_pri")
		{
			return (-6852, 5305, -56);
		}
		else if (zone_name == "zone_pri2")
		{
			return (-7316, 5247, -56);
		}
		else if (zone_name == "zone_station_ext")
		{
			return (-6979, 4769, -64);
		}
		else if (zone_name == "zone_trans_2b")
		{
			return (-7896, 4769, -59);
		}
		else if (zone_name == "zone_gas")
		{
			return (-5178, -7136, -59);
		}
		else if (zone_name == "zone_roadside_west")
		{
			return (-5913, -6934, -58);
		}
		else if (zone_name == "zone_roadside_east")
		{
			return (-4352, -7109, -64);
		}
		else if (zone_name == "zone_gar")
		{
			return (-4690, -7748, -53);
		}
		else if (zone_name == "zone_din")
		{
			return (-6030, -7662, 5);
		}
		else if (zone_name == "zone_far_ext")
		{
			return (7931, -5730, 11);
		}
		else if (zone_name == "zone_brn")
		{
			return (8213, -5201, 48);
		}
		else if (zone_name == "zone_farm_house")
		{
			return (8126, -6625, 117);
		}
		else if (zone_name == "zone_pow")
		{
			return (10274, 7823, -570);
		}
		else if (zone_name == "zone_trans_8")
		{
			return (10274, 8562, -587);
		}
		else if (zone_name == "zone_prr")
		{
			return (11842, 7581, -756);
		}
		else if (zone_name == "zone_pcr")
		{
			return (12210, 8339, -751);
		}
		else if (zone_name == "zone_pow_warehouse")
		{
			return (11039, 8587, -416);
		}
		else if (zone_name == "zone_tow")
		{
			return (1533, -384, -68);
		}
		else if (zone_name == "zone_town_north")
		{
			return (1504, 693, -62);
		}
		else if (zone_name == "zone_town_south")
		{
			return (1554, -1239, -51);
		}
		else if (zone_name == "zone_town_east")
		{
			return (2090, -481, -62);
		}
		else if (zone_name == "zone_town_west")
		{
			return (771, -508, -62);
		}
		else if (zone_name == "zone_bar")
		{
			return (2043, 268, -56);
		}
		else if (zone_name == "zone_town_barber")
		{
			return (891, -1236, 120);
		}
		else if (zone_name == "zone_ban")
		{
			return (832, 266, -40);
		}
		else if (zone_name == "zone_amb_tunnel")
		{
			return (-11249, -2010, 184);
		}
		else if (zone_name == "zone_amb_cornfield")
		{
			return (12186, -600, -153);
		}
		else if (zone_name == "zone_cornfield_prototype")
		{
			return (13421, -638, -201);
		}
	}
	else if (level.script == "zm_nuked")
	{
		if (zone_name == "culdesac_yellow_zone")
		{
			return (392, 78, -48);
		}
		else if (zone_name == "culdesac_green_zone")
		{
			return (-311, 344, -44);
		}
		else if (zone_name == "openhouse1_f1_zone")
		{
			return (-806, 431, -56);
		}
		else if (zone_name == "openhouse2_f1_zone")
		{
			return (880, 264, -57);
		}
		else if (zone_name == "openhouse1_f2_zone")
		{
			return (-880, 473, 80);
		}
		else if (zone_name == "openhouse2_f2_zone")
		{
			return (953, 319, 79);
		}
		else if (zone_name == "openhouse1_backyard_zone")
		{
			return (-1491, 670, -60);
		}
		else if (zone_name == "openhouse2_backyard_zone")
		{
			return (1536, 581, -59);
		}
	}
	else if (level.script == "zm_highrise")
	{
		if (zone_name == "zone_green_start")
		{
			return (1518, 1373, 3392);
		}
		else if (zone_name == "zone_green_level1")
		{
			return (1709, 1843, 3409);
		}
		else if (zone_name == "zone_green_level2a")
		{
			return (1981, 1468, 3216);
		}
		else if (zone_name == "zone_green_level2b")
		{
			return (1579, 1888, 3216);
		}
		else if (zone_name == "zone_green_level3a")
		{
			return (1934, 2266, 3040);
		}
		else if (zone_name == "zone_green_level3b")
		{
			return (2062, 1350, 3040);
		}
		else if (zone_name == "zone_green_level3c")
		{
			return (1686, 1302, 3047);
		}
		else if (zone_name == "zone_blue_level1a")
		{
			return (1985, 139, 2880);
		}
		else if (zone_name == "zone_blue_level1b")
		{
			return (2923, 97, 2880);
		}
		else if (zone_name == "zone_blue_level1c")
		{
			return (2156, 591, 3136);
		}
		else if (zone_name == "zone_blue_level2a")
		{
			return (2370, -411, 2704);
		}
		else if (zone_name == "zone_blue_level2b")
		{
			return (1683, -18, 2704);
		}
		else if (zone_name == "zone_blue_level2c")
		{
			return (2830, -4, 2704);
		}
		else if (zone_name == "zone_blue_level4a")
		{
			return (2141, 325, 1296);
		}
		else if (zone_name == "zone_blue_level4b")
		{
			return (1917, -255, 1296);
		}
		else if (zone_name == "zone_blue_level4c")
		{
			return (2691, 5, 1296);
		}
		else if (zone_name == "zone_blue_level5")
		{
			return (2329, -431, 1120);
		}
	}
	else if (level.script == "zm_prison")
	{
		if (zone_name == "zone_start")
		{
			return (1306, 10595, 1336);
		}
		else if (zone_name == "zone_library")
		{
			return (591, 10504, 1344);
		}
		else if (zone_name == "zone_cellblock_west")
		{
			return (888, 9674, 1443);
		}
		else if (zone_name == "zone_cellblock_west_gondola")
		{
			return (888, 9674, 1545);
		}
		else if (zone_name == "zone_cellblock_west_barber")
		{
			return (888, 9147, 1336);
		}
		else if (zone_name == "zone_cellblock_east")
		{
			return (1920, 9674, 1336);
		}
		else if (zone_name == "zone_cafeteria")
		{
			return (2633, 9647, 1336);
		}
		else if (zone_name == "zone_warden_office")
		{
			return (-921, 9312, 1336);
		}
		else if (zone_name == "zone_dock")
		{
			return (-639, 5746, -48);
		}
		else if (zone_name == "zone_dock_gondola")
		{
			return (420, 6122, 264);
		}
		else if (zone_name == "zone_studio")
		{
			return (-205, 6590, 64);
		}
		else if (zone_name == "zone_citadel_basement_building")
		{
			return (-102, 7088, 64);
		}
	}
	else if (level.script == "zm_buried")
	{
		if (zone_name == "zone_street_lightwest")
		{
			return (-667, 315, -26);
		}
		else if (zone_name == "zone_street_darkwest")
		{
			return (-598, -812, -31);
		}
		else if (zone_name == "zone_street_darkeast")
		{
			return (196, -930, -20);
		}
		else if (zone_name == "zone_stables")
		{
			return (-929, -262, -23);
		}
		else if (zone_name == "zone_general_store")
		{
			return (-19, -296, 8);
		}
		else if (zone_name == "zone_gun_store")
		{
			return (-598, -1151, 8);
		}
		else if (zone_name == "zone_underground_bar")
		{
			return (733, -1465, 55);
		}
		else if (zone_name == "zone_underground_courthouse")
		{
			return (216, 1007, 8);
		}
		else if (zone_name == "zone_toy_store")
		{
			return (720, -553, 8);
		}
		else if (zone_name == "zone_candy_store")
		{
			return (625, -139, 8);
		}
		else if (zone_name == "zone_street_fountain")
		{
			return (983, 626, -14);
		}
		else if (zone_name == "zone_church_main")
		{
			return (1464, 1740, 24);
		}
		else if (zone_name == "zone_mansion_lawn")
		{
			return (1847, 559, 0);
		}
		else if (zone_name == "zone_maze")
		{
			return (5002, 577, 4);
		}
		else if (zone_name == "zone_mansion_backyard")
		{
			return (3980, 577, 4);
		}
		else if (zone_name == "zone_maze_staircase")
		{
			return (6438, 577, 108);
		}
	}
	else if (level.script == "zm_tomb")
	{
		if (zone_name == "zone_start_b")
		{
			return (2169, 4784, -291);
		}
		else if (zone_name == "zone_bunker_3a")
		{
			return (526, 2340, -107);
		}
		else if (zone_name == "zone_bunker_4a")
		{
			return (-352, 3448, -283);
		}
		else if (zone_name == "zone_bunker_5a")
		{
			return (-493, 2902, -256);
		}
		else if (zone_name == "zone_nml_farm")
		{
			return (-2626, 176, 254);
		}
		else if (zone_name == "zone_nml_11")
		{
			return (2368, 240, 132);
		}
		else if (zone_name == "zone_nml_18")
		{
			return (-156, -9, 320);
		}
		else if (zone_name == "zone_village_1")
		{
			return (515, -2642, 35);
		}
		else if (zone_name == "zone_village_2")
		{
			return (515, -2642, 369);
		}
		else if (zone_name == "zone_village_3a")
		{
			return (960, -3712, 311);
		}
		else if (zone_name == "zone_chamber_0")
		{
			return (9627, -7008, -346);
		}
		else if (zone_name == "zone_chamber_2")
		{
			return (11229, -7052, -346);
		}
		else if (zone_name == "zone_chamber_4")
		{
			return (10340, -7906, -412);
		}
		else if (zone_name == "zone_chamber_6")
		{
			return (9459, -8557, -398);
		}
		else if (zone_name == "zone_chamber_8")
		{
			return (11254, -8662, -408);
		}
	}

	return (0, 0, 0);
}

containment_get_zone_name_to_lock(zone_name)
{
	if (level.script == "zm_nuked")
	{
		if (zone_name == "culdesac_yellow_zone")
		{
			return "culdesac_green_zone";
		}
	}
	else if (level.script == "zm_buried")
	{
		if (zone_name == "zone_street_fountain")
		{
			return "zone_street_lighteast";
		}
		else if (zone_name == "zone_mansion_lawn")
		{
			return "zone_mansion";
		}
	}
	else if (level.script == "zm_tomb")
	{
		if (zone_name == "zone_start_b")
		{
			return "zone_start";
		}
		else if (zone_name == "zone_chamber_0" || zone_name == "zone_chamber_2" || zone_name == "zone_chamber_6" || zone_name == "zone_chamber_8")
		{
			return "zone_chamber_4";
		}
		else if (zone_name == "zone_chamber_4")
		{
			return "";
		}
	}

	return zone_name;
}

containment_get_current_zone()
{
	if (isdefined(level.elevator_volumes))
	{
		foreach (volume in level.elevator_volumes)
		{
			if (self istouching(volume))
			{
				return "";
			}
		}
	}

	return self get_current_zone();
}

containment_time_hud_countdown(time)
{
	level notify("containment_time_hud_countdown");
	level endon("containment_time_hud_countdown");
	level endon("end_game");

	level.containment_time_hud_value = time;

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_containment_time", 1, level.containment_time_hud_value);
		}

		if (level.containment_time_hud_value <= 0)
		{
			return;
		}

		wait 1;

		level.containment_time_hud_value--;
	}
}

meat_init()
{
	level thread meat_think();
}

meat_think()
{
	level endon("end_game");

	flag_wait("initial_blackscreen_passed");

	grief_score_hud_set_scoring_team("none");

	level waittill("restart_round_start");

	wait 10;

	level thread meat_powerup_drop_think();
	level thread meat_powerup_timeout_think();

	prev_meat_player = undefined;
	held_time = undefined;
	obj_time = 1000;

	while (1)
	{
		if (isDefined(level.meat_player))
		{
			if (!isDefined(held_time))
			{
				held_time = getTime();
			}

			if (isDefined(prev_meat_player) && level.meat_player != prev_meat_player)
			{
				held_time = getTime();
			}

			prev_meat_player = level.meat_player;

			grief_score_hud_set_scoring_team(level.meat_player.team);

			objective_setgamemodeflags(level.meat_player.obj_ind, 3);
			objective_setgamemodeflags(level.game_mode_obj_ind, 0);

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
			prev_meat_player = undefined;

			if (isDefined(level.item_meat))
			{
				grief_score_hud_set_scoring_team("neutral");

				objective_onentity(level.game_mode_obj_ind, level.item_meat);
				objective_setgamemodeflags(level.game_mode_obj_ind, 1);
			}
			else if (isDefined(level.meat_powerup))
			{
				grief_score_hud_set_scoring_team("neutral");

				objective_onentity(level.game_mode_obj_ind, level.meat_powerup);
				objective_setgamemodeflags(level.game_mode_obj_ind, 1);
			}
			else
			{
				grief_score_hud_set_scoring_team("none");

				objective_setgamemodeflags(level.game_mode_obj_ind, 0);
			}
		}

		wait 0.05;
		waittillframeend;
	}
}

meat_powerup_drop_think()
{
	level endon("end_game");

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_KILL_ZOMBIE_TO_DROP_MEAT");
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

meat_powerup_timeout_think()
{
	level endon("end_game");

	while (1)
	{
		level waittill("powerup_dropped", powerup);

		if (powerup.powerup_name != "meat_stink")
		{
			continue;
		}

		powerup thread meat_powerup_timeout();
		powerup thread meat_powerup_reset_on_timeout();
	}
}

meat_powerup_timeout()
{
	self notify("powerup_reset");

	self endon("powerup_grabbed");
	self endon("death");
	self endon("powerup_reset");
	self show();

	wait 7.5;

	for (i = 0; i < 30; i++)
	{
		if (i % 2)
		{
			self ghost();
		}
		else
		{
			self show();
		}

		if (i < 8)
		{
			wait 0.5;
			continue;
		}

		if (i < 18)
		{
			wait 0.25;
			continue;
		}

		wait 0.1;
	}

	self notify("powerup_timedout");
	self maps\mp\zombies\_zm_powerups::powerup_delete();
}

meat_powerup_reset_on_timeout()
{
	self endon("powerup_grabbed");

	self waittill("powerup_timedout");

	if (is_true(self.claimed))
	{
		return;
	}

	level notify("meat_inactive");
}

turned_init()
{
	maps\mp\zombies\_zm_turned::init();

	level.is_zombie_level = undefined;
	level.decrement_score = 1;
	level.force_team_characters = 1;
	level.should_use_cia = 0;

	if (randomint(100) >= 50)
	{
		level.should_use_cia = 1;
	}

	maps\mp\zombies\_zm_powerups::include_zombie_powerup("the_disease");
	maps\mp\zombies\_zm_powerups::add_zombie_powerup("the_disease", "p6_zm_tm_blood_power_up", &"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_never_drop, 0, 1, 0);

	level thread turned_think();
}

turned_think()
{
	flag_wait("initial_blackscreen_passed");

	allies_players = get_players("allies");

	increment_score("allies", allies_players.size, 0);
	increment_score("axis", allies_players.size * 50, 0);

	level waittill("restart_round_start");

	players = get_players();
	player = random(players);
	origin = player.origin;

	wait 10;

	level thread the_disease_powerup_drop(origin);
}

the_disease_powerup(player)
{
	player notify("player_suicide");
}

the_disease_powerup_drop(origin)
{
	waittillframeend; // wait for disconnecting player to disconnect when dropping from disconnecting player

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_RUN_FROM_DISEASE");
	}

	level._powerup_timeout_override = ::the_disease_powerup_infinite_time;
	powerup = maps\mp\zombies\_zm_powerups::specific_powerup_drop("the_disease", origin);
	level._powerup_timeout_override = undefined;

	powerup thread the_disease_powerup_do_chase();
}

the_disease_powerup_do_chase()
{
	level endon("end_game");
	self endon("powerup_timedout");
	self endon("powerup_grabbed");

	while (1)
	{
		wait 0.05;

		players = get_players("allies");
		closest_player = getclosest(self.origin, players);

		if (!isdefined(closest_player))
		{
			continue;
		}

		closest_player_origin = closest_player.origin + (0, 0, 40);

		direction = vectornormalize(closest_player_origin - self.origin);

		self.origin += direction * 15;
	}
}

the_disease_powerup_infinite_time()
{

}

turned_zombie_init()
{
	team = self.team;
	amount = -1;

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		amount = 0;
		self thread maps\mp\zombies\_zm_laststand::auto_revive(self);
	}

	self scripts\zm\_zm_reimagined::set_team(level.zombie_team);

	self maps\mp\zombies\_zm_turned::turn_to_zombie();

	increment_score(team, amount, 0, &"ZOMBIE_SURVIVOR_TURNED");
}

turned_zombie_spawn()
{
	self maps\mp\zombies\_zm_turned::turn_to_zombie();

	playfx(level._effect["zombie_disappears"], self.origin);
	playsoundatposition("evt_appear_3d", self.origin);
	earthquake(0.5, 0.75, self.origin, 100);
	playrumbleonposition("explosion_generic", self.origin);
}

turned_zombie_spectate_and_respawn()
{
	playfx(level._effect["zombie_disappears"], self.origin);
	playsoundatposition("evt_disappear_3d", self.origin);

	self maps\mp\zombies\_zm::spawnspectator();

	wait 10;

	self.sessionstate = "playing";

	self maps\mp\zombies\_zm::spectator_respawn();
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
	if (is_true(player.is_zombie))
	{
		return false;
	}

	if (self.powerup_name == "meat_stink")
	{
		if (player hasWeapon(get_gamemode_var("item_meat_name")) || is_true(player.dont_touch_the_meat))
		{
			return false;
		}
	}

	return true;
}

powerup_grab(powerup, player)
{
	switch (powerup.powerup_name)
	{
		case "meat_stink":
			level thread maps\mp\gametypes_zm\zgrief::meat_stink(player);
			break;

		case "the_disease":
			level thread the_disease_powerup(player);
			break;
	}
}

increment_score(team, amount = 1, show_lead_msg = true, score_msg)
{
	level endon("end_game");

	other_team = getotherteam(team);
	players = get_players();
	team_players = get_players(team);
	other_team_players = get_players(other_team);
	encounters_team = "A";
	other_encounters_team = "B";

	if (team == "allies")
	{
		encounters_team = "B";
		other_encounters_team = "A";
	}

	level.grief_score[encounters_team] += amount;

	if (is_true(level.decrement_score))
	{
		if (level.grief_score[encounters_team] < get_gamemode_winning_score())
		{
			level.grief_score[encounters_team] = get_gamemode_winning_score();
		}

		setteamscore(team, level.grief_score[encounters_team]);

		if ((level.highest_score > level.grief_score[encounters_team] && level.highest_score < 255) || level.highest_score == 0)
		{
			level.highest_score = level.grief_score[encounters_team];

			if (level.highest_score > 255)
			{
				level.highest_score = 255;
			}

			setroundsplayed(level.highest_score);
		}

		if (level.grief_score[encounters_team] <= get_gamemode_winning_score())
		{
			scripts\zm\replaced\_zm_game_module::game_won(other_encounters_team);
		}
	}
	else
	{
		if (level.grief_score[encounters_team] > get_gamemode_winning_score())
		{
			level.grief_score[encounters_team] = get_gamemode_winning_score();
		}

		setteamscore(team, level.grief_score[encounters_team]);

		if ((level.highest_score < level.grief_score[encounters_team] && level.highest_score < 255) || level.highest_score == 0)
		{
			level.highest_score = level.grief_score[encounters_team];

			if (level.highest_score > 255)
			{
				level.highest_score = 255;
			}

			setroundsplayed(level.highest_score);
		}

		if (level.grief_score[encounters_team] >= get_gamemode_winning_score())
		{
			scripts\zm\replaced\_zm_game_module::game_won(encounters_team);
		}
	}

	if (level.scr_zm_ui_gametype == "zgrief")
	{
		score = level.grief_score[encounters_team];
		other_score = level.grief_score[other_encounters_team];
		score_remaining = get_gamemode_winning_score() - score;

		foreach (player in team_players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_DEAD", score, other_score);
		}

		foreach (player in other_team_players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALLY_DEAD", other_score, score);
		}

		if (level.grief_score[encounters_team] <= 3)
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(level.grief_score[encounters_team] + "_player_down", team);
		}
		else if (score_remaining <= 3)
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(score_remaining + "_player_left", team);
		}
	}

	if (level.scr_zm_ui_gametype == "zrace")
	{
		if (isdefined(score_msg))
		{
			foreach (player in team_players)
			{
				player thread show_grief_hud_msg(score_msg, amount);
			}
		}
	}

	if (level.scr_zm_ui_gametype == "zturned")
	{
		if (isdefined(score_msg))
		{
			score = level.grief_score[encounters_team];
			other_score = other_team_players.size;

			foreach (player in team_players)
			{
				player thread show_grief_hud_msg(score_msg, score, other_score);
			}

			foreach (player in other_team_players)
			{
				player thread show_grief_hud_msg(score_msg, other_score, score);
			}

			if (score_msg == &"ZOMBIE_SURVIVOR_TURNED")
			{
				if (other_score <= 3)
				{
					level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(other_score + "_player_down");
				}
			}
			else
			{
				if (score <= 1)
				{
					foreach (player in players)
					{
						if (player.team != level.zombie_team && is_player_valid(player))
						{
							player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("last_player");
						}
						else
						{
							player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer(score + "_player_left");
						}
					}
				}
				else if (score <= 3)
				{
					level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(score + "_player_left");
				}
			}
		}
	}

	if (show_lead_msg)
	{
		if (!isdefined(level.prev_leader) || (level.prev_leader != encounters_team && level.grief_score[encounters_team] > level.grief_score[level.prev_leader]))
		{
			level.prev_leader = encounters_team;

			delay = undefined;

			if (level.scr_zm_ui_gametype == "zgrief" || level.scr_zm_ui_gametype == "zrace")
			{
				delay = 1;
			}

			foreach (player in team_players)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_GAIN_LEAD", undefined, undefined, 30, delay);
			}

			foreach (player in other_team_players)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_LOSE_LEAD", undefined, undefined, 30, delay);
			}
		}
	}
}

is_weapon_available_in_grief_saved_weapons(weapon, ignore_player)
{
	count = 0;
	upgradedweapon = weapon;

	if (isdefined(level.zombie_weapons[weapon]) && isdefined(level.zombie_weapons[weapon].upgrade_name))
	{
		upgradedweapon = level.zombie_weapons[weapon].upgrade_name;
	}

	players = getplayers();

	if (isdefined(players))
	{
		for (player_index = 0; player_index < players.size; player_index++)
		{
			player = players[player_index];

			if (isdefined(ignore_player) && player == ignore_player)
			{
				continue;
			}

			if (isdefined(player.grief_savedweapon_weapons))
			{
				for (i = 0; i < player.grief_savedweapon_weapons.size; i++)
				{
					grief_weapon = player.grief_savedweapon_weapons[i];

					if (isdefined(grief_weapon) && (grief_weapon == weapon || grief_weapon == upgradedweapon))
					{
						count++;
					}
				}
			}
		}
	}

	return count;
}

remove_held_melee_weapons()
{
	level endon("intermission");

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			melee_weapon = player get_player_melee_weapon();

			if (!isdefined(melee_weapon))
			{
				continue;
			}

			held_melee_weapon = "held_" + melee_weapon;

			if (player hasweapon(held_melee_weapon))
			{
				player takeweapon(held_melee_weapon);
			}
		}

		wait 0.05;
		waittillframeend;
	}
}