#include maps\mp\zm_tomb_distance_tracking;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zm_tomb_chamber;

escaped_zombies_cleanup_init()
{
	self endon("death");
	self.zombie_path_bad = 0;

	while (true)
	{
		if (!self.zombie_path_bad)
		{
			self waittill("bad_path");
		}

		found_player = undefined;
		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			if (is_player_valid(players[i]) && self maymovetopoint(players[i].origin, 1))
			{
				self.favoriteenemy = players[i];
				found_player = 1;
				continue;
			}
		}

		n_delete_distance = 1500;
		n_delete_height = 1000;

		if (!isdefined(found_player) && (is_true(self.completed_emerging_into_playable_area) || is_true(self.in_the_ground)))
		{
			self thread delete_zombie_noone_looking(n_delete_distance, n_delete_height);
		}

		wait 0.1;
	}
}

delete_zombie_noone_looking(how_close, how_high)
{
	self endon("death");

	if (!isdefined(how_close))
	{
		how_close = 1500;
	}

	if (!isdefined(how_high))
	{
		how_high = 600;
	}

	distance_squared_check = how_close * how_close;
	too_far_dist = distance_squared_check * 3;

	if (isdefined(level.zombie_tracking_too_far_dist))
	{
		too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;
	}

	self.inview = 0;
	self.player_close = 0;
	n_distance_squared = 0;
	n_height_difference = 0;
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		if (players[i].sessionstate == "spectator")
		{
			continue;
		}

		if (isdefined(level.only_track_targeted_players))
		{
			if (!isdefined(self.favoriteenemy) || self.favoriteenemy != players[i])
			{
				continue;
			}
		}

		can_be_seen = self player_can_see_me(players[i]);

		if (can_be_seen && distancesquared(self.origin, players[i].origin) < too_far_dist)
		{
			self.inview++;
		}

		n_modifier = 1.0;

		if (isdefined(players[i].b_in_tunnels) && players[i].b_in_tunnels)
		{
			n_modifier = 2.25;
		}

		n_distance_squared = distancesquared(self.origin, players[i].origin);
		n_height_difference = abs(self.origin[2] - players[i].origin[2]);

		if (n_distance_squared < distance_squared_check * n_modifier && n_height_difference < how_high)
		{
			self.player_close++;
		}
	}

	if (self.inview == 0 && self.player_close == 0)
	{
		if (!isdefined(self.animname) || self.animname != "zombie" && self.animname != "mechz_zombie")
		{
			return;
		}

		if (isdefined(self.electrified) && self.electrified == 1)
		{
			return;
		}

		if (isdefined(self.in_the_ground) && self.in_the_ground == 1)
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

		if (isdefined(self.is_mechz) && self.is_mechz)
		{
			self notify("mechz_cleanup");
			level.mechz_left_to_spawn++;
			wait_network_frame();
			level notify("spawn_mechz");
		}

		self delete();
		recalc_zombie_array();
	}
}