#include maps\mp\zombies\_zm_weap_slipgun;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_audio;

slipgun_zombie_1st_hit_response(upgraded, player)
{
	if (isplayer(self) && is_true(self.is_zombie))
	{
		if (self.sessionstate == "playing")
		{
			if (!isdefined(self.goo_chain_depth))
			{
				self.goo_chain_depth = 0;
			}

			self.goo_upgraded = upgraded;

			self dodamage(self.health, self.origin, player, player, "none", level.slipgun_damage_mod, 0, "slipgun_zm");
			self explode_into_goo(player, 0);
			return;
		}
	}

	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self orientmode("face default");
	self.ignoreall = 1;
	self.gibbed = 1;

	if (isalive(self))
	{
		if (!isdefined(self.goo_chain_depth))
		{
			self.goo_chain_depth = 0;
		}

		self.goo_upgraded = upgraded;

		if (self.health > 0)
		{
			if (player maps\mp\zombies\_zm_powerups::is_insta_kill_active())
			{
				self.health = 1;
			}

			self dodamage(self.health, self.origin, player, player, "none", level.slipgun_damage_mod, 0, "slipgun_zm");
		}
	}
}

slipgun_zombie_death_response()
{
	if (!isDefined(self.goo_chain_depth))
	{
		return false;
	}

	level maps\mp\zombies\_zm_spawner::zombie_death_points(self.origin, self.damagemod, self.damagelocation, self.attacker, self);
	self explode_into_goo(self.attacker, 0);
	return true;
}

explode_into_goo(player, chain_depth)
{
	if (isdefined(self.marked_for_insta_upgraded_death))
	{
		return;
	}

	tag = "J_SpineLower";

	if (is_true(self.isdog))
	{
		tag = "tag_origin";
	}

	if (isai(self))
	{
		self.guts_explosion = 1;
	}

	self playsound("wpn_slipgun_zombie_explode");

	if (isdefined(level._effect["slipgun_explode"]))
	{
		playfx(level._effect["slipgun_explode"], self gettagorigin(tag));
	}

	if (!is_true(self.isdog))
	{
		wait 0.1;
	}

	self ghost();

	if (!isdefined(self.goo_chain_depth))
	{
		self.goo_chain_depth = chain_depth;
	}

	chain_radius = level.zombie_vars["slipgun_chain_radius"];

	if (is_true(self.goo_upgraded))
	{
		chain_radius *= 1.5;
	}

	level thread explode_to_near_zombies(player, self.origin, chain_radius, self.goo_chain_depth, self.goo_upgraded);
}

explode_to_near_zombies(player, origin, radius, chain_depth, goo_upgraded)
{
	if (level.zombie_vars["slipgun_max_kill_chain_depth"] > 0 && chain_depth > level.zombie_vars["slipgun_max_kill_chain_depth"])
	{
		return;
	}

	enemies = get_round_enemy_array();
	enemy_players = get_players(getotherteam(player.team));

	foreach (enemy_player in enemy_players)
	{
		if (is_true(enemy_player.is_zombie))
		{
			if (enemy_player.sessionstate == "playing")
			{
				enemies[enemies.size] = enemy_player;
			}
		}
	}

	enemies = get_array_of_closest(origin, enemies);

	minchainwait = level.zombie_vars["slipgun_chain_wait_min"];
	maxchainwait = level.zombie_vars["slipgun_chain_wait_max"];

	rsquared = radius * radius;
	tag = "J_Head";
	marked_zombies = [];

	if (isdefined(enemies) && enemies.size)
	{
		index = 0;

		for (enemy = enemies[index]; distancesquared(enemy.origin, origin) < rsquared; enemy = enemies[index])
		{
			if (isalive(enemy) && !is_true(enemy.guts_explosion) && !is_true(enemy.nuked) && !isdefined(enemy.slipgun_sizzle))
			{
				trace = bullettrace(origin + vectorscale((0, 0, 1), 50.0), enemy.origin + vectorscale((0, 0, 1), 50.0), 0, undefined, 1);

				if (isdefined(trace["fraction"]) && trace["fraction"] == 1)
				{
					enemy.slipgun_sizzle = playfxontag(level._effect["slipgun_simmer"], enemy, tag);
					marked_zombies[marked_zombies.size] = enemy;
				}
			}

			index++;

			if (index >= enemies.size)
			{
				break;
			}
		}
	}

	if (isdefined(marked_zombies) && marked_zombies.size)
	{
		foreach (enemy in marked_zombies)
		{
			if (isalive(enemy) && !is_true(enemy.guts_explosion) && !is_true(enemy.nuked))
			{
				wait(randomfloatrange(minchainwait, maxchainwait));

				if (isalive(enemy) && !is_true(enemy.guts_explosion) && !is_true(enemy.nuked))
				{
					if (!isdefined(enemy.goo_chain_depth))
					{
						enemy.goo_chain_depth = chain_depth;
					}

					enemy.goo_upgraded = goo_upgraded;

					if (enemy.health > 0)
					{
						if (player maps\mp\zombies\_zm_powerups::is_insta_kill_active())
						{
							enemy.health = 1;
						}

						enemy dodamage(enemy.health, origin, player, player, "none", level.slipgun_damage_mod, 0, "slipgun_zm");
					}

					if (level.slippery_spot_count < level.zombie_vars["slipgun_reslip_max_spots"])
					{
						if ((!isdefined(enemy.slick_count) || enemy.slick_count == 0) && enemy.health <= 0)
						{
							if (level.zombie_vars["slipgun_reslip_rate"] > 0 && randomint(level.zombie_vars["slipgun_reslip_rate"]) == 0)
							{
								startpos = origin;
								duration = 24;
								thread add_slippery_spot(enemy.origin, duration, startpos);
							}
						}
					}
				}
			}
		}
	}
}