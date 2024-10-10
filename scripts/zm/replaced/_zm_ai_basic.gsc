#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

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