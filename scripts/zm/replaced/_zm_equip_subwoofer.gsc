#include maps\mp\zombies\_zm_equip_subwoofer;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

hit_player(action, doshellshock)
{
	if (action == "burst")
	{
		if (is_true(self.is_zombie))
		{
			if (is_true(doshellshock))
			{
				self dodamage(self.maxhealth, self.origin);
			}
		}
		else
		{
			self playrumbleonentity("subwoofer_heavy");

			if (is_true(doshellshock))
			{
				self shellshock("frag_grenade_mp", 1.5);
			}
		}
	}
	else if (action == "fling")
	{
		if (is_true(self.is_zombie))
		{
			if (is_true(doshellshock))
			{
				self dodamage(self.maxhealth, self.origin);
			}
		}
		else
		{
			self playrumbleonentity("subwoofer_medium");

			if (is_true(doshellshock))
			{
				self shellshock("frag_grenade_mp", 0.5);
			}
		}
	}
	else if (action == "stumble")
	{
		if (is_true(doshellshock))
		{
			self playrumbleonentity("subwoofer_light");
			self shellshock("frag_grenade_mp", 0.13);
		}
	}
}

startsubwooferdecay(weapon)
{
	self endon("death");
	self endon("disconnect");
	self endon("equip_subwoofer_zm_taken");

	// hack to decrease max subwoofer time
	if (self.subwoofer_health > 30)
	{
		self.subwoofer_health = 30;
	}

	fire_time = 2;

	wait fire_time + 0.05; // startup time

	while (isDefined(weapon))
	{
		if (weapon.power_on)
		{
			weapon.subwoofer_kills = 0; // hack to make subwoofer not get destroyed from kills
			self.subwoofer_health -= fire_time;

			if (self.subwoofer_health <= 0)
			{
				self.subwoofer_health = undefined;
				self thread subwoofer_expired(weapon);

				return;
			}
		}

		wait fire_time;
	}
}

subwoofer_network_choke()
{
	// no choke
}