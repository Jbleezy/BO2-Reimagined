#include maps\mp\zombies\_zm_ffotd;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_stats;

ffotd_melee_miss_func()
{
	if (isdefined(self.enemy))
	{
		if (isplayer(self.enemy) && is_placeable_mine(self.enemy getcurrentweapon()))
		{
			dist_sq = distancesquared(self.enemy.origin, self.origin);
			melee_dist_sq = self.meleeattackdist * self.meleeattackdist;

			if (dist_sq < melee_dist_sq)
			{
				self.enemy dodamage(self.meleedamage, self.origin, self, self, "none", "MOD_MELEE");
				return;
			}
		}
	}

	if (isdefined(level.original_melee_miss_func))
	{
		self [[level.original_melee_miss_func]]();
	}
}