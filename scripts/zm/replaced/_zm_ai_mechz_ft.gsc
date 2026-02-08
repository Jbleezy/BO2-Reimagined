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

player_flame_damage()
{
	self endon("zombified");
	self endon("death");
	self endon("disconnect");
	n_player_dmg = 30;
	n_burn_time = 1.5;

	if (self.sessionstate != "playing")
	{
		return;
	}

	self thread player_stop_burning();

	if (!isdefined(self.is_burning) && (is_player_valid(self) || is_true(self.is_zombie)))
	{
		self.is_burning = 1;
		maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_transit_burn", self, n_burn_time, level.zm_transit_burn_max_duration);
		self notify("burned");

		if (!is_true(self.is_zombie))
		{
			radiusdamage(self.origin, 10, n_player_dmg, n_player_dmg, undefined, "MOD_BURNED");
		}

		wait 0.5;

		self.is_burning = undefined;
	}
}

explode_on_death()
{
	self endon("stop_flame_damage");
	self waittill("death");

	if (!isdefined(self))
	{
		return;
	}

	tag = "J_SpineLower";

	if (isdefined(self.animname) && self.animname == "zombie_dog")
	{
		tag = "tag_origin";
	}

	if (is_mature())
	{
		if (isdefined(level._effect["zomb_gib"]))
		{
			playfx(level._effect["zomb_gib"], self gettagorigin(tag));
		}
	}
	else if (isdefined(level._effect["spawn_cloud"]))
	{
		playfx(level._effect["spawn_cloud"], self gettagorigin(tag));
	}

	level.use_adjusted_grenade_damage = true;
	self radiusdamage(self.origin, 128, 15, 15, undefined, "MOD_EXPLOSIVE");
	level.use_adjusted_grenade_damage = undefined;

	self ghost();

	if (isdefined(self.isdog) && self.isdog)
	{
		self hide();
	}
	else
	{
		self delay_thread(1, ::self_delete);
	}
}