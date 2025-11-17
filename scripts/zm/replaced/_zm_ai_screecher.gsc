#include maps\mp\zombies\_zm_ai_screecher;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_stats;

screecher_spawning_logic()
{
	level endon("intermission");

	if (level.intermission)
	{
		return;
	}

	if (level.screecher_spawners.size < 1)
	{
		return;
	}

	while (true)
	{
		while (!isdefined(level.zombie_screecher_locations) || level.zombie_screecher_locations.size <= 0)
		{
			wait 0.1;
		}

		while (getdvarint("scr_screecher_ignore_player"))
		{
			wait 0.1;
		}

		if (!flag("spawn_zombies"))
		{
			flag_wait("spawn_zombies");
		}

		valid_players_in_screecher_zone = 0;
		valid_players = [];

		while (1)
		{
			players = getplayers();
			valid_players_in_screecher_zone = 0;

			for (p = 0; p < players.size; p++)
			{
				if (is_player_valid(players[p]) && player_in_screecher_zone(players[p]) && !isdefined(players[p].screecher_protection))
				{
					valid_players_in_screecher_zone++;
					valid_players[valid_players.size] = players[p];
				}
			}

			if (valid_players_in_screecher_zone > 0)
			{
				break;
			}

			wait 0.1;
		}

		if (!isdefined(level.zombie_screecher_locations) || level.zombie_screecher_locations.size <= 0)
		{
			continue;
		}

		valid_players = array_randomize(valid_players);
		valid_player = valid_players[0];

		spawn_points = get_array_of_closest(valid_player.origin, level.zombie_screecher_locations);
		spawn_point = undefined;

		if (!isdefined(spawn_points) || spawn_points.size == 0)
		{
			wait 0.1;
			continue;
		}

		if (!isdefined(level.last_spawn))
		{
			level.last_spawn_index = 0;
			level.last_spawn = [];
			level.last_spawn[level.last_spawn_index] = spawn_points[0];
			level.last_spawn_index = 1;
			spawn_point = spawn_points[0];
		}
		else
		{
			foreach (point in spawn_points)
			{
				if (point == level.last_spawn[0])
				{
					continue;
				}

				if (isdefined(level.last_spawn[1]) && point == level.last_spawn[1])
				{
					continue;
				}

				spawn_point = point;
				level.last_spawn[level.last_spawn_index] = spawn_point;
				level.last_spawn_index++;

				if (level.last_spawn_index > 1)
				{
					level.last_spawn_index = 0;
				}

				break;
			}
		}

		if (!isdefined(spawn_point))
		{
			spawn_point = spawn_points[0];
		}

		if (isdefined(level.screecher_spawners))
		{
			spawner = random(level.screecher_spawners);
			ai = spawn_zombie(spawner, spawner.targetname, spawn_point);
		}

		if (isdefined(ai))
		{
			ai.spawn_point = spawn_point;
			level.zombie_screecher_count++;

			valid_player thread screecher_protection(ai);
		}

		wait(level.zombie_vars["zombie_spawn_delay"]);
		wait 0.1;
	}
}

screecher_protection(ai)
{
	self notify("screecher_protection");
	self endon("screecher_protection");
	self endon("disconnect");

	self.screecher_protection = 1;

	while (1)
	{
		stop_protection = 1;

		if (isdefined(self.screecher))
		{
			stop_protection = 0;
		}
		else if (isdefined(ai) && !isdefined(ai.favoriteenemy))
		{
			stop_protection = 0;
		}
		else
		{
			enemies = getaispeciesarray(level.zombie_team, "all");

			foreach (enemy in enemies)
			{
				if (!is_true(enemy.isscreecher))
				{
					continue;
				}

				if (isdefined(enemy.favoriteenemy) && enemy.favoriteenemy == self)
				{
					stop_protection = 0;
				}
			}
		}

		if (stop_protection)
		{
			break;
		}

		wait 0.05;
	}

	wait 5;

	self.screecher_protection = undefined;
}

screecher_attacking()
{
	player = self.favoriteenemy;

	if (!isdefined(player))
	{
		self thread screecher_detach(player);
		return;
	}

	if (screecher_should_runaway(player))
	{
		self thread screecher_detach(player);
		player thread do_player_general_vox("general", "screecher_jumpoff");
		return;
	}

	if (self.attack_time < gettime())
	{
		scratch_score = 5;
		players = get_players();
		self.screecher_score = self.screecher_score + scratch_score;
		killed_player = self screecher_check_score();

		if (player.health > 0 && !(isdefined(killed_player) && killed_player))
		{
			self.attack_delay = self.attack_delay_base + randomint(self.attack_delay_offset);
			self.attack_time = gettime() + self.attack_delay;
			self thread claw_fx(player, self.attack_delay * 0.001);
			self playsound("zmb_vocals_screecher_attack");
			player playsoundtoplayer("zmb_screecher_scratch", player);
			player thread do_player_general_vox("general", "screecher_attack");
			players = get_players();
		}
	}
}

screecher_melee_damage(player)
{
	melee_score = 0;

	if (player hasweapon("tazer_knuckles_zm"))
	{
		melee_score = 30;
	}
	else if (player hasweapon("bowie_knife_zm"))
	{
		melee_score = 15;
	}
	else
	{
		melee_score = 10;
	}

	if (self.screecher_score > 0)
	{
		if (melee_score > self.screecher_score)
		{
			self.screecher_score = 0;
		}
		else
		{
			self.screecher_score -= melee_score;
		}
	}

	if (self.screecher_score <= 0)
	{
		self.player_score += melee_score;
	}

	self playsound("zmb_vocals_screecher_pain");

	if (level.zombie_vars[player.team]["zombie_insta_kill"])
	{
		self.player_score = 30;
	}
	else
	{
		player thread do_player_general_vox("general", "screecher_cut");
	}

	self screecher_check_score();
}

screecher_detach(player)
{
	self endon("death");
	self.state = "detached";

	if (!isdefined(self.linked_ent))
	{
		return;
	}

	if (isdefined(player))
	{
		player clientnotify("scrEnd");

		player allowprone(1);

		player takeweapon("screecher_arms_zm");

		if (!getdvarint("scr_screecher_poison"))
		{
			player stoppoisoning();
		}

		if (!player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(isdefined(player.intermission) && player.intermission))
		{
			player decrement_is_drinking();
		}

		if (isdefined(player.screecher_weapon) && player.screecher_weapon != "none" && is_player_valid(player) && !is_equipment_that_blocks_purchase(player.screecher_weapon))
		{
			player switchtoweapon(player.screecher_weapon);
		}
		else if (!player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			primaryweapons = player getweaponslistprimaries();

			if (isdefined(primaryweapons) && primaryweapons.size > 0)
			{
				player switchtoweapon(primaryweapons[0]);
			}
		}

		player.screecher_weapon = undefined;
	}

	self unlink();
	self setclientfield("render_third_person", 0);

	if (isdefined(self.linked_ent))
	{
		self.linked_ent.screecher = undefined;
		self.linked_ent setmovespeedscale(1);
		self.linked_ent = undefined;
	}

	self.green_light = player.green_light;
	self animcustom(::screecher_jump_down);

	self waittill("jump_down_done");

	maps\mp\_visionset_mgr::vsmgr_deactivate("overlay", "zm_ai_screecher_blur", player);
	self animmode("normal");
	self.ignoreall = 1;
	self setplayercollision(1);

	if (isdefined(level.screecher_should_burrow))
	{
		if (self [[level.screecher_should_burrow]]())
		{
			return;
		}
	}

	self thread screecher_runaway();
}

screecher_cleanup()
{
	self waittill("death", attacker);

	if (isdefined(attacker) && isplayer(attacker))
	{
		if (isdefined(self.damagelocation) && isdefined(self.damagemod))
		{
			level thread maps\mp\zombies\_zm_audio::player_zombie_kill_vox(self.damagelocation, attacker, self.damagemod, self);
		}

		if (isdefined(self.origin) && issubstr(self getanimstatefromasd(), "zm_jump") && randomint(100) < 2)
		{
			trace = groundtrace(self.origin + vectorscale((0, 0, 1), 10.0), self.origin + vectorscale((0, 0, -1), 150.0), 0, undefined, 1);
			power_up_origin = trace["position"];
			level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("free_perk", power_up_origin);
		}
	}

	if (isdefined(self.loopsoundent))
	{
		self.loopsoundent delete();
		self.loopsoundent = undefined;
	}

	player = self.linked_ent;

	if (isdefined(player))
	{
		player playsound("zmb_vocals_screecher_death");
		player setmovespeedscale(1);
		maps\mp\_visionset_mgr::vsmgr_deactivate("overlay", "zm_ai_screecher_blur", player);

		if (isdefined(player.screecher_weapon))
		{
			player clientnotify("scrEnd");

			player allowprone(1);

			player takeweapon("screecher_arms_zm");

			if (!getdvarint("scr_screecher_poison"))
			{
				player stoppoisoning();
			}

			if (!player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(isdefined(player.intermission) && player.intermission))
			{
				player decrement_is_drinking();
			}

			if (player.screecher_weapon != "none" && is_player_valid(player))
			{
				player switchtoweapon(player.screecher_weapon);
			}
			else
			{
				primaryweapons = player getweaponslistprimaries();

				if (isdefined(primaryweapons) && primaryweapons.size > 0)
				{
					player switchtoweapon(primaryweapons[0]);
				}
			}

			player.screecher_weapon = undefined;
		}
	}

	if (isdefined(self.claw_fx))
	{
		self.claw_fx destroy();
	}

	if (isdefined(self.anchor))
	{
		self.anchor delete();
	}

	if (isdefined(level.screecher_cleanup))
	{
		self [[level.screecher_cleanup]]();
	}

	if (level.zombie_screecher_count > 0)
	{
		level.zombie_screecher_count--;
	}
}

screecher_should_runaway(player)
{
	if (is_true(player.ignoreme))
	{
		return 1;
	}

	if (isdefined(level.screecher_should_runaway))
	{
		return self [[level.screecher_should_runaway]](player);
	}

	return 0;
}