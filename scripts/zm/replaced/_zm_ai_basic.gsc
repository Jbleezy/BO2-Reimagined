#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

find_flesh()
{
	self endon("death");
	level endon("intermission");
	self endon("stop_find_flesh");

	if (level.intermission)
	{
		return;
	}

	self.ai_state = "find_flesh";
	self.helitarget = 1;
	self.ignoreme = 0;
	self.nododgemove = 1;
	self.ignore_player = [];
	self maps\mp\zombies\_zm_spawner::zombie_history("find flesh -> start");
	self.goalradius = 32;

	if (isdefined(self.custom_goalradius_override))
	{
		self.goalradius = self.custom_goalradius_override;
	}

	while (true)
	{
		zombie_poi = undefined;

		if (isdefined(level.zombietheaterteleporterseeklogicfunc))
		{
			self [[level.zombietheaterteleporterseeklogicfunc]]();
		}

		if (isdefined(level._poi_override))
		{
			zombie_poi = self [[level._poi_override]]();
		}

		if (!isdefined(zombie_poi))
		{
			zombie_poi = self get_zombie_point_of_interest(self.origin);
		}

		players = get_players();

		if (!isdefined(self.ignore_player) || players.size == 1)
		{
			self.ignore_player = [];
		}
		else if (!isdefined(level._should_skip_ignore_player_logic) || ![[level._should_skip_ignore_player_logic]]())
		{
			i = 0;

			while (i < self.ignore_player.size)
			{
				if (isdefined(self.ignore_player[i]) && isdefined(self.ignore_player[i].ignore_counter) && self.ignore_player[i].ignore_counter > 3)
				{
					self.ignore_player[i].ignore_counter = 0;
					arrayremovevalue(self.ignore_player, self.ignore_player[i]);

					if (!isdefined(self.ignore_player))
					{
						self.ignore_player = [];
					}

					i = 0;
					continue;
				}

				i++;
			}
		}

		player = get_closest_valid_player(self.origin, self.ignore_player);

		if (!isdefined(player) && !isdefined(zombie_poi))
		{
			self maps\mp\zombies\_zm_spawner::zombie_history("find flesh -> can't find player, continue");

			if (isdefined(self.ignore_player))
			{
				if (isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
				{
					wait 1;
					continue;
				}

				self.ignore_player = [];
			}

			wait 1;
			continue;
		}

		if (!isdefined(level.check_for_alternate_poi) || ![[level.check_for_alternate_poi]]())
		{
			self.enemyoverride = zombie_poi;
			self.favoriteenemy = player;
		}

		self thread zombie_pathing();

		if (players.size > 1)
		{
			for (i = 0; i < self.ignore_player.size; i++)
			{
				if (isdefined(self.ignore_player[i]))
				{
					if (!isdefined(self.ignore_player[i].ignore_counter))
					{
						self.ignore_player[i].ignore_counter = 0;
						continue;
					}

					self.ignore_player[i].ignore_counter = self.ignore_player[i].ignore_counter + 1;
				}
			}
		}

		self thread attractors_generated_listener();

		if (isdefined(level._zombie_path_timer_override))
		{
			self.zombie_path_timer = [[level._zombie_path_timer_override]]();
		}
		else
		{
			self.zombie_path_timer = gettime() + randomfloatrange(1, 3) * 1000;
		}

		while (gettime() < self.zombie_path_timer)
		{
			wait 0.1;
		}

		self notify("path_timer_done");
		self maps\mp\zombies\_zm_spawner::zombie_history("find flesh -> bottom of loop");
		debug_print("Zombie is re-acquiring enemy, ending breadcrumb search");
		self notify("zombie_acquire_enemy");
	}
}

inert_wakeup()
{
	self endon("death");
	self endon("stop_zombie_inert");

	wait 0.1;

	self thread maps\mp\zombies\_zm_ai_basic::inert_damage();
	self thread maps\mp\zombies\_zm_ai_basic::inert_bump();

	while (1)
	{
		current_time = getTime();
		players = get_players();

		foreach (player in players)
		{
			dist_sq = distancesquared(self.origin, player.origin);

			if (dist_sq < 4096)
			{
				self maps\mp\zombies\_zm_ai_basic::stop_inert();
				return;
			}

			if (dist_sq < 5760000)
			{
				if ((current_time - player.lastfiretime) <= 100)
				{
					self maps\mp\zombies\_zm_ai_basic::stop_inert();
					return;
				}
			}
		}

		wait 0.1;
	}
}