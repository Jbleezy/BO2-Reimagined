#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

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
	if (isdefined(ent) && isplayer(ent) && is_player_valid(ent) && !ent hasWeapon("item_meat_zm") && !is_true(ent.dont_touch_the_meat))
	{
		level thread meat_stink_player(ent);

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
				continue;

			if (player hasWeapon("item_meat_zm"))
				continue;

			if (is_true(player.dont_touch_the_meat))
				continue;

			distsq = distancesquared(pos, player.origin);

			if (distsq < closest_player_dist)
			{
				closest_player = player;
				closest_player_dist = distsq;
			}
		}

		if (isdefined(closest_player))
		{
			level thread meat_stink_player(closest_player);

			if (isdefined(self.owner))
			{
				maps\mp\_demo::bookmark("zm_player_meat_stink", gettime(), closest_player, self.owner, 0, self);
				self.owner maps\mp\zombies\_zm_stats::increment_client_stat("contaminations_given");
			}

			self delete();

			return;
		}
	}

	playfx(level._effect["meat_impact"], self.origin);

	if (is_true(bounce))
	{
		landed_on = self getgroundent();

		if (!isDefined(landed_on) || isAI(landed_on))
		{
			return;
		}
	}

	if (isDefined(level.object_touching_lava) && self [[level.object_touching_lava]]())
	{
		level notify("meat_inactive");

		self delete();

		return;
	}

	valid_drop = scripts\zm\replaced\_zm_utility::check_point_in_life_brush(pos) || (check_point_in_enabled_zone(pos) && !scripts\zm\replaced\_zm_utility::check_point_in_kill_brush(pos));

	if (valid_drop)
	{
		self hide();

		if (level.scr_zm_ui_gametype_obj == "zmeat")
		{
			level.meat_powerup = maps\mp\zombies\_zm_powerups::specific_powerup_drop("meat_stink", pos);
		}
		else
		{
			level thread meat_stink_on_ground(self.origin);
		}
	}
	else
	{
		level notify("meat_inactive");
	}

	self delete();
}

meat_stink(who)
{
	if (who hasWeapon("item_meat_zm"))
	{
		return;
	}

	if (!is_player_valid(who))
	{
		if (level.scr_zm_ui_gametype_obj == "zmeat")
		{
			valid_drop = scripts\zm\replaced\_zm_utility::check_point_in_life_brush(who.origin) || (check_point_in_enabled_zone(who.origin) && !scripts\zm\replaced\_zm_utility::check_point_in_kill_brush(who.origin));

			if (valid_drop)
			{
				players = get_players();

				foreach (player in players)
				{
					player thread scripts\zm\zgrief\zgrief_reimagined::show_grief_hud_msg("Meat dropped!");
				}

				level.meat_powerup = maps\mp\zombies\_zm_powerups::specific_powerup_drop("meat_stink", who.origin);
			}
			else
			{
				level notify("meat_inactive");
			}
		}

		return;
	}

	who.pre_meat_weapon = who getcurrentweapon();
	level notify("meat_grabbed");
	who notify("meat_grabbed");
	who playsound("zmb_pickup_meat");
	who increment_is_drinking();
	who giveweapon("item_meat_zm");
	who switchtoweapon("item_meat_zm");
	who setweaponammoclip("item_meat_zm", 1);
	who setMoveSpeedScale(0.75);
	who.ignoreme = 0;
	level.meat_player = who;
	level.meat_powerup = undefined;

	who thread meat_damage_over_time();

	if (who attackbuttonpressed())
	{
		who thread meat_disable_weapons();
	}

	if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		who.head_icon.alpha = 0;
	}

	players = get_players();

	foreach (player in players)
	{
		player thread maps\mp\gametypes_zm\zgrief::meat_stink_player_cleanup();

		if (player != who)
		{
			player.ignoreme = 1;
		}

		player thread print_meat_msg(who, "grabbed");

		if (level.scr_zm_ui_gametype_obj == "zmeat")
		{
			if (player == who)
			{
				player thread scripts\zm\zgrief\zgrief_reimagined::show_grief_hud_msg("You have the meat!");
			}
			else if (player.team == who.team)
			{
				player thread scripts\zm\zgrief\zgrief_reimagined::show_grief_hud_msg(&"ZOMBIE_YOUR_TEAM_MEAT");
			}
			else
			{
				player thread scripts\zm\zgrief\zgrief_reimagined::show_grief_hud_msg(&"ZOMBIE_OTHER_TEAM_MEAT");
			}
		}
	}

	who thread meat_stink_ignoreme_think();

	who thread meat_stink_player_create();

	who thread meat_stink_cleanup_on_downed();

	if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		who thread meat_powerup_reset_on_disconnect();
	}
}

meat_disable_weapons()
{
	level endon("meat_thrown");
	self endon("disconnect");
	self endon("player_downed");

	self.meat_weapons_disabled = 1;

	self disableWeapons();

	while (self attackbuttonpressed())
	{
		wait 0.05;
	}

	self enableWeapons();

	self.meat_weapons_disabled = undefined;
}

meat_damage_over_time()
{
	level endon("end_game");
	level endon("meat_thrown");
	self endon("disconnect");
	self endon("player_downed");

	time_zero_speed = 0;

	while (1)
	{
		velocity = self getVelocity() * (1, 1, 0);
		speed = length(velocity);

		if (speed == 0)
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
			radiusDamage(self.origin + (0, 0, 5), 10, 50, 50);
		}

		wait 0.05;
	}
}

meat_stink_ignoreme_think()
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
		zombies = get_round_enemy_array();

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

			player.ignoreme = close_zombies.size == 0;
		}

		wait 0.05;
	}
}

meat_stink_cleanup_on_downed()
{
	level endon("meat_thrown");
	level endon("meat_grabbed");
	self endon("disconnect");
	self endon("bled_out");

	self waittill_any("player_downed", "spawned_player");

	self.lastactiveweapon = self.pre_meat_weapon;

	level.meat_player = undefined;

	self setMoveSpeedScale(1);

	if (is_true(self.meat_weapons_disabled))
	{
		self.meat_weapons_disabled = undefined;
		self enableWeapons();
	}

	players = get_players();

	foreach (player in players)
	{
		player thread maps\mp\gametypes_zm\zgrief::meat_stink_player_cleanup();

		if (is_player_valid(player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
		{
			player.ignoreme = 0;
		}
	}

	if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		valid_drop = scripts\zm\replaced\_zm_utility::check_point_in_life_brush(self.origin) || (check_point_in_enabled_zone(self.origin) && !scripts\zm\replaced\_zm_utility::check_point_in_kill_brush(self.origin));

		if (valid_drop)
		{
			players = get_players();

			foreach (player in players)
			{
				player thread scripts\zm\zgrief\zgrief_reimagined::show_grief_hud_msg("Meat dropped!");
			}

			level.meat_powerup = maps\mp\zombies\_zm_powerups::specific_powerup_drop("meat_stink", self.origin);
		}
		else
		{
			level notify("meat_inactive");
		}
	}
}

meat_powerup_reset_on_disconnect()
{
	level endon("meat_thrown");
	level endon("meat_grabbed");
	self endon("player_downed");
	self endon("bled_out");

	self waittill("disconnect");

	level.meat_player = undefined;

	players = get_players();

	foreach (player in players)
	{
		if (is_player_valid(player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
		{
			player.ignoreme = 0;
		}
	}

	level notify("meat_inactive");
}

meat_stink_on_ground(position_to_play)
{
	level.meat_on_ground = 1;
	attractor_point = spawn("script_model", position_to_play);
	attractor_point setmodel("tag_origin");
	attractor_point playsound("zmb_land_meat");
	wait 0.2;
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

meat_stink_player(who)
{
	level notify("new_meat_stink_player");
	level endon("new_meat_stink_player");

	if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		level thread meat_stink(who);
		return;
	}

	who notify("meat_stink_player_start");
	level.meat_player = who;
	who.ignoreme = 0;
	players = get_players();

	foreach (player in players)
	{
		player thread maps\mp\gametypes_zm\zgrief::meat_stink_player_cleanup();

		if (player != who)
		{
			player.ignoreme = 1;
		}

		player thread print_meat_msg(who, "has");
	}

	who thread meat_stink_ignoreme_think();
	who thread meat_stink_player_create();

	who waittill_any_or_timeout(30, "disconnect", "player_downed", "bled_out", "spawned_player");

	who notify("meat_stink_player_end");
	players = get_players();

	foreach (player in players)
	{
		player thread maps\mp\gametypes_zm\zgrief::meat_stink_player_cleanup();

		if (is_player_valid(player) && !is_true(player.spawn_protection) && !is_true(player.revive_protection))
		{
			player.ignoreme = 0;
		}
	}

	level.meat_player = undefined;
}

meat_stink_player_create()
{
	self maps\mp\zombies\_zm_stats::increment_client_stat("contaminations_received");
	self endon("disconnect");
	self endon("death");
	tagname = "J_SpineLower";
	self.meat_stink_3p = spawn("script_model", self gettagorigin(tagname));
	self.meat_stink_3p setmodel("tag_origin");
	self.meat_stink_3p linkto(self, tagname);
	playfxontag(level._effect["meat_stink_torso"], self.meat_stink_3p, "tag_origin");
	self setclientfieldtoplayer("meat_stink", 1);
}

print_meat_msg(meat_player, verb)
{
	self endon("disconnect");
	meat_player endon("disconnect");

	if (verb == "grabbed" || verb == "has")
	{
		wait 0.05; // must wait to show after any obituaries that happened on the same frame
	}

	color = "";

	if (self.team == meat_player.team)
	{
		color = "^8";
	}
	else
	{
		color = "^9";
	}

	self iprintln(color + meat_player.name + " " + verb + " the meat");
}