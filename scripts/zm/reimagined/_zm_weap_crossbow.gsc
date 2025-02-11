#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

watch_for_monkey_bolt()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("missile_fire", projectile, weaponname);

		if (weaponname == "crossbow_zm" || weaponname == "crossbow_upgraded_zm")
		{
			projectile thread crossbow_monkey_bolt(weaponname == "crossbow_upgraded_zm");
		}
	}
}

crossbow_monkey_bolt(is_upgraded)
{
	self waittill("stationary", endpos, normal, angles, attacker, prey, bone);

	monkey_bolt_grenade = undefined;
	grenades = getentarray("grenade", "classname");

	foreach (grenade in grenades)
	{
		if (isdefined(grenade.model) && grenade.model == "t5_weapon_crossbow_bolt" && !isdefined(grenade.monkey_bolt_started))
		{
			monkey_bolt_grenade = grenade;
			break;
		}
	}

	if (!isdefined(monkey_bolt_grenade))
	{
		return;
	}

	monkey_bolt_grenade.monkey_bolt_started = 1;

	if (!is_upgraded)
	{
		return;
	}

	self delete();

	valid_poi = check_point_in_enabled_zone(monkey_bolt_grenade.origin, undefined, undefined);

	if (!valid_poi)
	{
		return;
	}

	monkey_bolt_grenade create_zombie_point_of_interest(1536, 96, 10000);
	monkey_bolt_grenade thread create_zombie_point_of_interest_attractor_positions(4, 45);

	if (isdefined(prey) && isalive(prey))
	{
		if (isai(prey))
		{
			if (is_true(prey.is_mechz) || !is_true(prey.completed_emerging_into_playable_area) || !is_true(prey.has_legs))
			{
				monkey_bolt_grenade.attract_to_origin = 1;
			}
			else
			{
				prey thread crossbow_monkey_bolt_zombie_stun_anim(monkey_bolt_grenade);
			}
		}
		else if (isplayer(prey))
		{
			monkey_bolt_grenade.attract_to_origin = 1;
		}
	}
}

crossbow_monkey_bolt_zombie_stun_anim(grenade)
{
	self notify("crossbow_monkey_bolt_zombie_stun_anim");
	self endon("crossbow_monkey_bolt_zombie_stun_anim");
	self endon("death");
	grenade endon("death");

	self thread crossbow_monkey_bolt_zombie_stun_anim_stop_on_grenade_death(grenade);

	while (1)
	{
		ground_ent = self getgroundent();

		if (isdefined(ground_ent) && !is_true(ground_ent.classname == "worldspawn"))
		{
			self linkto(ground_ent);
		}

		self animscripted(self.origin, self.angles, "zm_electric_stun");
		self maps\mp\animscripts\zm_shared::donotetracks("stunned");
	}
}

crossbow_monkey_bolt_zombie_stun_anim_stop_on_grenade_death(grenade)
{
	self endon("crossbow_monkey_bolt_zombie_stun_anim");
	self endon("death");

	grenade waittill("death");

	self stopanimscripted();
}