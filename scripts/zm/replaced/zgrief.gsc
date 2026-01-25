#include maps\mp\gametypes_zm\zgrief;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\zmeat;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_game_module_meat_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;

onprecachegametype()
{
	level.playersuicideallowed = 1;
	level.canplayersuicide = ::canplayersuicide;
	level.suicide_weapon = "death_self_zm";
	precacheitem("death_self_zm");
	precacheshellshock("grief_stab_zm");
	precacheshader("faction_cdc");
	precacheshader("faction_cia");
	precacheshader("waypoint_revive_cdc_zm");
	precacheshader("waypoint_revive_cia_zm");
	level thread maps\mp\zombies\_zm_game_module_meat_utility::init_item_meat("zgrief");
	level thread maps\mp\gametypes_zm\_zm_gametype::init();
	maps\mp\gametypes_zm\_zm_gametype::rungametypeprecache("zgrief");
}

postinit_func()
{
	level.min_humans = 1;
	level.zombie_ai_limit = 24;
	level.prevent_player_damage = ::player_prevent_damage;
	level.lock_player_on_team_score = 1;
	level.meat_bounce_override = ::meat_bounce_override;
	level._zombie_spawning = 0;
	level._get_game_module_players = undefined;
	level.powerup_drop_count = 0;
	level.is_zombie_level = 1;

	setmatchtalkflag("DeadChatWithDead", 1);
	setmatchtalkflag("DeadChatWithTeam", 1);
	setmatchtalkflag("DeadHearTeamLiving", 1);
	setmatchtalkflag("DeadHearAllLiving", 1);
	setmatchtalkflag("EveryoneHearsEveryone", 1);
}

zgrief_main()
{
	level thread maps\mp\zombies\_zm::round_start();
	level thread maps\mp\gametypes_zm\_zm_gametype::kill_all_zombies();
	flag_wait("initial_blackscreen_passed");
	level thread maps\mp\zombies\_zm_game_module::wait_for_team_death_and_round_end();
	players = get_players();

	foreach (player in players)
	{
		player.is_hotjoin = 0;
	}

	wait 1;

	postfix = scripts\zm\_zm_reimagined::get_grief_vox_postfix();

	playsoundatposition("vox_zmba_grief_intro" + postfix + "_0", (0, 0, 0));
}

game_mode_spawn_player_logic()
{
	if (isDefined(level.should_respawn_func) && [[level.should_respawn_func]]())
	{
		return 0;
	}

	if (flag("start_zombie_round_logic") && !isDefined(self.is_hotjoin))
	{
		self.is_hotjoin = 1;
		return 1;
	}

	return 0;
}

meat_bounce_override(pos, normal, ent, bounce)
{
	if (isdefined(ent) && isplayer(ent) && is_player_valid(ent) && !ent hasWeapon(level.item_meat_name) && !is_true(ent.dont_touch_the_meat))
	{
		level thread meat_stink_player(ent, self.owner);

		if (isdefined(self.owner))
		{
			maps\mp\_demo::bookmark("zm_player_meat_stink", gettime(), ent, self.owner, 0, self);
			self.owner maps\mp\zombies\_zm_stats::increment_client_stat("contaminations_given");
		}

		self delete();

		return;
	}
	else
	{
		players = getplayers();
		closest_player = undefined;
		closest_player_dist = 10000.0;

		foreach (player in players)
		{
			if (!is_player_valid(player))
			{
				continue;
			}

			if (player hasWeapon(level.item_meat_name))
			{
				continue;
			}

			if (is_true(player.dont_touch_the_meat))
			{
				continue;
			}

			distsq = distancesquared(pos, player.origin);

			if (distsq < closest_player_dist)
			{
				closest_player = player;
				closest_player_dist = distsq;
			}
		}

		if (isdefined(closest_player))
		{
			level thread meat_stink_player(closest_player, self.owner);

			if (isdefined(self.owner))
			{
				maps\mp\_demo::bookmark("zm_player_meat_stink", gettime(), closest_player, self.owner, 0, self);
				self.owner maps\mp\zombies\_zm_stats::increment_client_stat("contaminations_given");
			}

			self delete();

			return;
		}
	}

	if (is_true(bounce))
	{
		ground_ent = self getgroundent();

		if (isDefined(ground_ent) && isAI(ground_ent))
		{
			return;
		}

		if (!isDefined(ground_ent))
		{
			self.bounce_count++;

			if (self.bounce_count < 4)
			{
				return;
			}
		}
	}

	if (isDefined(level.object_touching_lava_func) && self [[level.object_touching_lava_func]]())
	{
		level notify("meat_inactive");

		self delete();

		return;
	}

	meat_drop(pos, self);
}

meat_drop(pos, prev_meat_ent)
{
	valid_drop = scripts\zm\replaced\_zm_utility::check_point_in_life_brush(pos) || (check_point_in_enabled_zone(pos) && !scripts\zm\replaced\_zm_utility::check_point_in_kill_brush(pos));

	if (valid_drop)
	{
		if (check_point_in_insta_kill_trigger(pos) || check_point_in_insta_kill_trigger(pos + (0, 0, 70)))
		{
			valid_drop = 0;
		}
	}

	if (valid_drop)
	{
		meat_origin = pos;

		if (isdefined(prev_meat_ent))
		{
			meat_origin = prev_meat_ent.origin;
			prev_meat_ent hide();
		}

		level thread meat_stink_on_ground(meat_origin);
	}
	else
	{
		level notify("meat_inactive");
	}

	if (isdefined(prev_meat_ent))
	{
		prev_meat_ent delete();
	}
}

check_point_in_insta_kill_trigger(pos)
{
	is_touching = 0;
	check_org = spawn("script_origin", pos);

	if (isdefined(level.insta_kill_triggers))
	{
		foreach (trigger in level.insta_kill_triggers)
		{
			if (check_org istouching(trigger))
			{
				is_touching = 1;
				break;
			}
		}
	}

	trigger = getent("transit_falling_death", "targetname");

	if (isdefined(trigger))
	{
		if (check_org istouching(trigger))
		{
			is_touching = 1;
		}
	}

	check_org delete();
	return is_touching;
}

meat_stink(who, owner)
{
	if (who hasWeapon(level.item_meat_name))
	{
		return;
	}

	if (!is_player_valid(who))
	{
		if (isDefined(owner))
		{
			players = get_players();

			foreach (player in players)
			{
				player thread print_meat_msg(owner, "dropped");
			}
		}

		if (level.scr_zm_ui_gametype == "zmeat")
		{
			meat_drop(who.origin);
		}

		return;
	}

	if (who isusingoffhand())
	{
		who forceoffhandend();
	}

	if (!isdefined(who.pre_temp_weapon))
	{
		pre_temp_weapon = who getcurrentweapon();

		if (pre_temp_weapon != "none")
		{
			who.pre_temp_weapon = pre_temp_weapon;
		}
	}

	level notify("meat_grabbed");
	who notify("meat_grabbed");
	who playsound("zmb_pickup_meat");
	who increment_is_drinking();
	who giveweapon(level.item_meat_name);
	who switchtoweapon(level.item_meat_name);
	who setweaponammoclip(level.item_meat_name, 1);
	who.ignoreme = 0;
	level.meat_player = who;
	level.meat_powerup = undefined;
	who.statusicon = level.item_meat_status_icon_name;

	who thread meat_disable_fire();

	who thread meat_damage_over_time();

	if (level.scr_zm_ui_gametype == "zmeat")
	{
		objective_setgamemodeflags(who.obj_ind, 3);
	}

	players = get_players();

	foreach (player in players)
	{
		if (player != who)
		{
			player.ignoreme = 1;
		}

		player thread print_meat_msg(who, "grabbed");
	}

	level notify("attractor_positions_generated");

	who thread meat_stink_ignoreme_think(0);

	who thread meat_glow_player_create();

	who thread meat_stink_cleanup_on_downed();
	who thread meat_stink_cleanup_on_disconnect();
	who thread meat_stink_cleanup_on_intermission();
}

meat_disable_fire()
{
	level endon("meat_thrown");
	self endon("disconnect");
	self endon("player_downed");

	if (!self attackbuttonpressed())
	{
		return;
	}

	self setweaponammoclip(level.item_meat_name, 0);

	while (self attackbuttonpressed())
	{
		wait 0.05;
	}

	self setweaponammoclip(level.item_meat_name, 1);
}

meat_damage_over_time()
{
	level endon("end_game");
	level endon("meat_thrown");
	level endon("meat_grabbed");
	self endon("disconnect");
	self endon("player_downed");
	self endon("bled_out");
	self endon("spawned_player");
	self endon("meat_stink_player_end");

	time_zero_speed = 0;
	prev_speed = 0;

	while (1)
	{
		speed = self scripts\zm\_zm_reimagined::get_player_speed();
		slowing_down = (speed - prev_speed) <= -10;

		if (speed == 0 || slowing_down)
		{
			time_zero_speed++;
		}
		else
		{
			if (time_zero_speed > 0)
			{
				time_zero_speed--;
			}
		}

		if (time_zero_speed >= 20)
		{
			time_zero_speed = 0;
			radiusDamage(self.origin + (0, 0, 5), 10, 50, 50, undefined, "MOD_EXPLOSIVE");
		}

		prev_speed = speed;

		wait 0.05;
	}
}

meat_stink_ignoreme_think(check_meat_player_dist)
{
	level endon("meat_thrown");
	level endon("meat_grabbed");
	self endon("disconnect");
	self endon("player_downed");
	self endon("bled_out");
	self endon("spawned_player");
	self endon("meat_stink_player_end");

	while (1)
	{
		zombies = getaispeciesarray(level.zombie_team, "all");

		players = get_players();

		foreach (player in players)
		{
			if (player == self)
			{
				continue;
			}

			if (!is_player_valid(player))
			{
				continue;
			}

			if (is_true(player.spawn_protection) || is_true(player.revive_protection))
			{
				continue;
			}

			close_zombies = get_array_of_closest(player.origin, zombies, undefined, 1, 64);
			close_meat_player = 1;

			if (check_meat_player_dist)
			{
				meat_player_dist = distanceSquared(player.origin, self.origin);
				max_dist = 768 * 768;
				close_meat_player = meat_player_dist <= max_dist;
			}

			player.ignoreme = close_zombies.size == 0 && close_meat_player;
		}

		wait 0.05;
	}
}

meat_stink_cleanup_on_downed()
{
	level endon("meat_thrown");
	level endon("meat_grabbed");
	self endon("disconnect");

	self waittill_any("player_downed", "bled_out", "spawned_player");

	self.lastactiveweapon = self.pre_temp_weapon;

	self thread meat_glow_player_cleanup();

	level.meat_player = undefined;

	players = get_players();

	foreach (player in players)
	{
		if (is_player_valid(player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
		{
			player.ignoreme = 0;
		}

		player thread print_meat_msg(self, "dropped", 1);
	}

	level notify("attractor_positions_generated");

	if (level.scr_zm_ui_gametype == "zmeat")
	{
		meat_drop(self.origin);
	}
}

meat_stink_cleanup_on_disconnect()
{
	level endon("meat_thrown");
	level endon("meat_grabbed");
	self endon("player_downed");
	self endon("bled_out");
	self endon("spawned_player");

	self waittill("disconnect");

	self thread meat_glow_player_cleanup();

	level.meat_player = undefined;

	players = get_players();

	foreach (player in players)
	{
		if (is_player_valid(player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
		{
			player.ignoreme = 0;
		}
	}

	level notify("attractor_positions_generated");
	level notify("meat_inactive");
}

meat_stink_cleanup_on_intermission()
{
	level endon("meat_thrown");
	level endon("meat_grabbed");
	self endon("player_downed");
	self endon("bled_out");
	self endon("spawned_player");
	self endon("disconnect");

	level waittill("intermission");

	self thread meat_glow_player_cleanup();
}

meat_stink_on_ground(position_to_play)
{
	if (level.scr_zm_ui_gametype == "zmeat")
	{
		level.meat_powerup = maps\mp\zombies\_zm_powerups::specific_powerup_drop("meat_stink", position_to_play);
		return;
	}

	level.meat_on_ground = 1;
	attractor_point = spawn("script_model", position_to_play);
	attractor_point setmodel("tag_origin");
	attractor_point playsound("zmb_land_meat");
	playfxontag(level._effect["meat_stink_torso"], attractor_point, "tag_origin");
	attractor_point playloopsound("zmb_meat_flies");
	attractor_point create_zombie_point_of_interest(768, 48, 10000);
	attractor_point.attract_to_origin = 1;
	attractor_point thread create_zombie_point_of_interest_attractor_positions(4, 45);
	attractor_point thread maps\mp\zombies\_zm_weap_cymbal_monkey::wait_for_attractor_positions_complete();
	attractor_point delay_thread(10, ::self_delete);
	wait 10;
	level.meat_on_ground = undefined;
}

meat_stink_player(who, owner)
{
	level notify("new_meat_stink_player");
	level endon("new_meat_stink_player");

	if (level.scr_zm_ui_gametype == "zmeat")
	{
		level thread meat_stink(who, owner);
		return;
	}

	who.statusicon = level.item_meat_status_icon_name;

	if (who.team != owner.team)
	{
		who.last_meated_by = spawnStruct();
		who.last_meated_by.attacker = owner;

		who.player_damage_callback_score_only = 1;
		who [[level._game_module_player_damage_callback]](owner, owner, 0, 0, "MOD_UNKNOWN", level.item_meat_name);
		who.player_damage_callback_score_only = undefined;
	}
	else
	{
		who.last_meated_by = undefined;
	}

	who notify("meat_stink_player_start");
	level.meat_player = who;
	who.ignoreme = 0;
	players = get_players();

	foreach (player in players)
	{
		if (player != who)
		{
			player.ignoreme = 1;
		}

		player thread print_meat_msg(who, "has");
	}

	level notify("attractor_positions_generated");

	who maps\mp\zombies\_zm_stats::increment_client_stat("contaminations_received");

	who thread meat_stink_ignoreme_think(1);
	who thread meat_stink_player_create();

	who waittill_any_or_timeout(15, "disconnect", "player_downed", "bled_out", "spawned_player");

	if (is_player_valid(who))
	{
		who.statusicon = "";
	}

	who thread meat_stink_player_cleanup();

	who notify("meat_stink_player_end");
	players = get_players();

	foreach (player in players)
	{
		if (is_player_valid(player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
		{
			player.ignoreme = 0;
		}
	}

	level notify("attractor_positions_generated");

	level.meat_player = undefined;

	who thread wait_and_reset_last_meated_by();
}

wait_and_reset_last_meated_by()
{
	self endon("disconnect");

	wait 0.05;

	self.last_meated_by = undefined;
}

meat_stink_player_create()
{
	self endon("disconnect");
	self endon("death");

	tagname = "J_SpineLower";
	self.meat_stink_3p = spawn("script_model", self gettagorigin(tagname));
	self.meat_stink_3p setmodel("tag_origin");
	self.meat_stink_3p linkto(self, tagname);
	playfxontag(level._effect["meat_stink_torso"], self.meat_stink_3p, "tag_origin");

	self setclientfieldtoplayer("meat_stink", 1);
}

meat_stink_player_cleanup()
{
	if (isdefined(self.meat_stink_3p))
	{
		self.meat_stink_3p unlink();
		self.meat_stink_3p delete();
	}

	self setclientfieldtoplayer("meat_stink", 0);
}

meat_glow_player_create()
{
	self endon("disconnect");
	self endon("death");

	tagname = "tag_weapon_right";
	self.meat_glow_3p = spawn("script_model", self gettagorigin(tagname));
	self.meat_glow_3p setmodel("tag_origin");
	self.meat_glow_3p linkto(self, tagname);
	playfxontag(level._effect["meat_glow3p"], self.meat_glow_3p, "tag_origin");

	self setclientfieldtoplayer("meat_glow", 1);
}

meat_glow_player_cleanup()
{
	if (isdefined(self.meat_glow_3p))
	{
		self.meat_glow_3p unlink();
		self.meat_glow_3p delete();
	}

	self setclientfieldtoplayer("meat_glow", 0);
}

print_meat_msg(meat_player, verb, show_after_obituaries = 0)
{
	self endon("disconnect");
	meat_player endon("disconnect");

	while (is_true(self.printing_meat_msg))
	{
		wait 0.05;
	}

	self.printing_meat_msg = 1;

	if (show_after_obituaries)
	{
		if (is_true(self.playersuicided))
		{
			wait 0.05;
		}

		wait 0.05;
	}

	meat = "_MEAT";

	if (self.team != meat_player.team)
	{
		meat = "_MEAT_ENEMY";
	}

	hint_string = istring(toupper("ZOMBIE_" + verb + meat));

	self iprintln(hint_string, meat_player.name);

	self.printing_meat_msg = undefined;
}