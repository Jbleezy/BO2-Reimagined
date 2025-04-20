#include maps\mp\zombies\_zm_ai_mechz_ft;
#include maps\mp\zombies\_zm_zonemgr;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zombies\_zm_ai_mechz_dev;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\_visionset_mgr;

mechz_watch_for_flamethrower_damage()
{
	self endon("death");

	while (true)
	{
		self waittillmatch("flamethrower_anim", "start_ft");
		self.firing = 1;
		self thread mechz_stop_firing_watcher();

		while (isdefined(self.firing) && self.firing)
		{
			do_tank_sweep_auto_damage = isdefined(self.doing_tank_sweep) && self.doing_tank_sweep && !level.vh_tank ent_flag("tank_moving");
			players = getplayers();

			for (i = 0; i < players.size; i++)
			{
				if (!(isdefined(players[i].is_burning) && players[i].is_burning))
				{
					if (do_tank_sweep_auto_damage && players[i] entity_on_tank() || players[i] istouching(self.flamethrower_trigger))
					{
						players[i] thread player_flame_damage();
					}
				}
			}

			zombies = getaispeciesarray(level.zombie_team, "all");

			for (i = 0; i < zombies.size; i++)
			{
				if (isdefined(zombies[i].is_mechz) && zombies[i].is_mechz)
				{
					continue;
				}

				if (isdefined(zombies[i].on_fire) && zombies[i].on_fire)
				{
					continue;
				}

				if (do_tank_sweep_auto_damage && zombies[i] entity_on_tank() || zombies[i] istouching(self.flamethrower_trigger))
				{
					zombies[i].on_fire = 1;
					zombies[i] promote_to_explosive();
				}
			}

			wait 0.1;
		}
	}
}