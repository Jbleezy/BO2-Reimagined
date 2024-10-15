#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;

zombie_paralyzed(player, upgraded)
{
	if (!can_be_paralyzed(self))
	{
		return;
	}

	insta = player maps\mp\zombies\_zm_powerups::is_insta_kill_active();

	if (upgraded)
	{
		self setclientfield("slowgun_fx", 5);
	}
	else
	{
		self setclientfield("slowgun_fx", 1);
	}

	if (self.slowgun_anim_rate <= 0.1 || insta && self.slowgun_anim_rate <= 0.5)
	{
		if (upgraded)
		{
			damage = level.slowgun_damage_ug;
		}
		else
		{
			damage = level.slowgun_damage;
		}

		damage *= randomfloatrange(0.667, 1.5);
		damage *= self.paralyzer_damaged_multiplier;

		if (!isdefined(self.paralyzer_damage))
		{
			self.paralyzer_damage = 0;
		}

		// if ( self.paralyzer_damage > 47073 )
		//	damage *= 47073 / self.paralyzer_damage;

		self.paralyzer_damage += damage;

		if (insta)
		{
			damage = self.health + 666;
		}

		if (isalive(self))
		{
			self dodamage(damage, player.origin, player, player, "none", level.slowgun_damage_mod, 0, "slowgun_zm");
		}

		self.paralyzer_damaged_multiplier *= 1.15;
		self.paralyzer_damaged_multiplier = min(self.paralyzer_damaged_multiplier, 50);
	}
	else
	{
		self.paralyzer_damaged_multiplier = 1;
	}

	self zombie_slow_for_time(0.2);
}

slowgun_zombie_death_response()
{
	if (!self is_slowgun_damage(self.damagemod, self.damageweapon))
	{
		return false;
	}

	level maps\mp\zombies\_zm_spawner::zombie_death_points(self.origin, self.damagemod, self.damagelocation, self.attacker, self);
	self thread explode_into_dust(self.attacker, self.damageweapon == "slowgun_upgraded_zm");

	self slowgun_zombie_death_wait();

	return true;
}

// fixes spawn delay for next zombies
slowgun_zombie_death_wait()
{
	self set_anim_rate(1.0);
	self.ignore_slowgun_anim_rates = 1;

	wait 0.1;
}

player_slow_for_time(time)
{
	if (is_true(self._being_shellshocked))
	{
		return;
	}

	self notify("player_slow_for_time");
	self endon("player_slow_for_time");
	self endon("disconnect");

	if (!is_true(self.slowgun_flying))
	{
		self thread player_fly_rumble();
	}

	self setclientfieldtoplayer("slowgun_fx", 1);
	self set_anim_rate(0.1);

	wait(time);

	self set_anim_rate(1.0);
	self setclientfieldtoplayer("slowgun_fx", 0);
	self.slowgun_flying = 0;
}

watch_reset_anim_rate()
{
	self set_anim_rate(1.0);
	self setclientfieldtoplayer("slowgun_fx", 0);

	while (1)
	{
		self waittill_any("spawned_player", "entering_last_stand", "player_revived", "player_suicide");
		self setclientfieldtoplayer("slowgun_fx", 0);
		self set_anim_rate(1.0);
	}
}