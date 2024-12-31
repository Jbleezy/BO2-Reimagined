#include maps\mp\zm_buried_ffotd;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_buried;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm;

main_end()
{
	if (is_gametype_active("zgrief"))
	{
		level thread zgrief_mode_fix();
	}

	level.zombie_init_done = ::ffotd_zombie_init_done;
	level thread bar_spawner_fix();
	level thread maze_blocker_fix();
	level thread door_clip_fix();
	level thread player_respawn_fix();

	if (!is_gametype_active("zclassic"))
	{
		maps\mp\zombies\_zm_weap_time_bomb::init_time_bomb();
	}
}

jail_traversal_fix()
{
	self endon("death");
	window_pos = (-837, 496, 8);
	fix_dist = 64;

	while (true)
	{
		dist = distancesquared(self.origin, window_pos);

		if (dist < fix_dist)
		{
			node = self getnegotiationstartnode();

			if (isdefined(node))
			{
				if (node.animscript == "zm_jump_down_48" && node.type == "Begin")
				{
					self setphysparams(25, 0, 60);
					wait 1;

					if (is_true(self.has_legs))
					{
						self setphysparams(15, 0, 60);
					}
					else
					{
						self setphysparams(15, 0, 24);
					}
				}
			}
		}

		wait 0.25;
	}
}

time_bomb_takeaway()
{
	// remove
}

spawned_life_triggers()
{
	// remove
}