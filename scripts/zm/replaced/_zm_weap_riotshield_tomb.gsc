#include maps\mp\zombies\_zm_weap_riotshield_tomb;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_riotshield_tomb;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_audio;

player_damage_shield(idamage, bheld)
{
	damagemax = level.zombie_vars["riotshield_hit_points"];

	if (!isdefined(self.shielddamagetaken))
	{
		self.shielddamagetaken = 0;
	}

	self.shielddamagetaken += idamage;

	if (self.shielddamagetaken >= damagemax)
	{
		if (bheld || !isdefined(self.shield_ent))
		{
			self playrumbleonentity("damage_heavy");
			earthquake(1.0, 0.75, self.origin, 100);
			self playsound("wpn_riotshield_zm_destroy");
			self thread player_take_riotshield();
		}
		else
		{
			shield_origin = self.shield_ent.origin;
			playsoundatposition("fly_riotshield_zm_impact_zombies", shield_origin);

			if (is_true(self.shield_ent.destroy_begun))
			{
				return;
			}

			self.shield_ent.destroy_begun = 1;
			self thread player_wait_and_take_riotshield();
		}
	}
	else
	{
		if (bheld || !isdefined(self.shield_ent))
		{
			self playrumbleonentity("damage_light");
			earthquake(0.5, 0.5, self.origin, 100);
			self playsound("fly_riotshield_zm_impact_zombies");
		}
		else
		{
			shield_origin = self.shield_ent.origin;
			playsoundatposition("fly_riotshield_zm_impact_zombies", shield_origin);
		}

		self player_set_shield_health(self.shielddamagetaken, damagemax);
	}
}

player_wait_and_take_riotshield()
{
	shield_origin = self.shield_ent.origin;
	level thread maps\mp\zombies\_zm_equipment::equipment_disappear_fx(shield_origin, level._riotshield_dissapear_fx);
	wait 1;
	playsoundatposition("wpn_riotshield_zm_destroy", shield_origin);
	self thread player_take_riotshield();
}

riotshield_fling_zombie(player, fling_vec, index)
{
	if (!isdefined(self) || !isalive(self))
	{
		return;
	}

	if (isdefined(self.ignore_riotshield) && self.ignore_riotshield)
	{
		return;
	}

	if (isdefined(self.riotshield_fling_func))
	{
		self [[self.riotshield_fling_func]](player);
		return;
	}

	damage = 2500;
	self dodamage(damage, player.origin, player, player, 0, "MOD_MELEE", 0, level.riotshield_name);

	if (self.health < 1)
	{
		self.riotshield_death = 1;
		player maps\mp\zombies\_zm_score::player_add_points("death", "MOD_MELEE");
		self startragdoll();
		self launchragdoll(fling_vec);
	}
	else
	{
		player maps\mp\zombies\_zm_score::player_add_points("damage_light");
	}
}

zombie_knockdown(player, gib)
{
	if (isdefined(level.override_riotshield_damage_func))
	{
		self [[level.override_riotshield_damage_func]](player, gib);
	}
	else
	{
		if (gib)
		{
			self.a.gib_ref = random(level.riotshield_gib_refs);
			self thread maps\mp\animscripts\zm_death::do_gib();
		}
	}
}

riotshield_knockdown_zombie(player, gib)
{
	self endon("death");
	playsoundatposition("vox_riotshield_forcehit", self.origin);
	playsoundatposition("wpn_riotshield_proj_impact", self.origin);

	if (!isdefined(self) || !isalive(self))
	{
		return;
	}

	if (isdefined(self.riotshield_knockdown_func))
	{
		self [[self.riotshield_knockdown_func]](player, gib);
	}
	else
	{
		self zombie_knockdown(player, gib);
	}

	self dodamage(level.zombie_vars["riotshield_knockdown_damage"], player.origin, player, player, 0, "MOD_MELEE", 0, level.riotshield_name);
	self playsound("fly_riotshield_forcehit");

	if (self.health < 1)
	{
		player maps\mp\zombies\_zm_score::player_add_points("death", "MOD_MELEE");
	}
	else
	{
		player maps\mp\zombies\_zm_score::player_add_points("damage_light");
	}
}