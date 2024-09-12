#include maps\mp\zm_buried_distance_tracking;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_ai_basic;

delete_zombie_noone_looking(how_close, how_high)
{
	self endon("death");

	if (self can_be_deleted_from_buried_special_zones())
	{
		self.inview = 0;
		self.player_close = 0;
	}
	else
	{
		if (!isdefined(how_close))
		{
			how_close = 1000;
		}

		if (!isdefined(how_high))
		{
			how_high = 500;
		}

		if (!(isdefined(self.has_legs) && self.has_legs))
		{
			how_close *= 1.5;
		}

		distance_squared_check = how_close * how_close;
		height_squared_check = how_high * how_high;
		too_far_dist = distance_squared_check * 3;

		if (isdefined(level.zombie_tracking_too_far_dist))
		{
			too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
		}

		self.inview = 0;
		self.player_close = 0;
		players = get_players();

		foreach (player in players)
		{
			if (player.sessionstate == "spectator")
			{
				continue;
			}

			if (isdefined(player.laststand) && player.laststand && (isdefined(self.favoriteenemy) && self.favoriteenemy == player))
			{
				if (!self can_zombie_see_any_player())
				{
					self.favoriteenemy = undefined;
					self.zombie_path_bad = 1;
					self thread escaped_zombies_cleanup();
				}
			}

			if (isdefined(level.only_track_targeted_players))
			{
				if (!isdefined(self.favoriteenemy) || self.favoriteenemy != player)
				{
					continue;
				}
			}

			can_be_seen = self player_can_see_me(player);
			distance_squared = distancesquared(self.origin, player.origin);

			if (can_be_seen && distance_squared < too_far_dist)
			{
				self.inview++;
			}

			if (distance_squared < distance_squared_check && abs(self.origin[2] - player.origin[2]) < how_high)
			{
				self.player_close++;
			}
		}
	}

	wait 0.1;

	if (self.inview == 0 && self.player_close == 0)
	{
		if (!isdefined(self.animname) || isdefined(self.animname) && self.animname != "zombie")
		{
			return;
		}

		if (isdefined(self.electrified) && self.electrified == 1)
		{
			return;
		}

		if (!(isdefined(self.exclude_distance_cleanup_adding_to_total) && self.exclude_distance_cleanup_adding_to_total) && !(isdefined(self.isscreecher) && self.isscreecher))
		{
			level.zombie_total++;

			if (self.health < level.zombie_health)
			{
				level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
			}
		}

		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self notify("zombie_delete");

		if (isdefined(self.anchor))
		{
			self.anchor delete();
		}

		self delete();
		recalc_zombie_array();
	}
}