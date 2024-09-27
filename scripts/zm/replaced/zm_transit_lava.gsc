#include maps\mp\zm_transit_lava;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\animscripts\zm_death;

player_lava_damage(trig)
{
	self endon("zombified");
	self endon("death");
	self endon("disconnect");
	max_dmg = 15;
	min_dmg = 5;
	burn_time = 1;

	if (isdefined(self.is_zombie) && self.is_zombie)
	{
		return;
	}

	self thread player_stop_burning();

	if (isdefined(trig.script_float))
	{
		max_dmg *= trig.script_float;
		min_dmg *= trig.script_float;
		burn_time *= trig.script_float;

		if (burn_time >= 1.5)
		{
			burn_time = 1.5;
		}
	}

	if (max_dmg < 15)
	{
		max_dmg = 5;
	}

	if (!isdefined(self.is_burning) && is_player_valid(self))
	{
		self.is_burning = 1;
		maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_transit_burn", self, burn_time, level.zm_transit_burn_max_duration);
		self notify("burned");

		if (isdefined(trig.script_float) && trig.script_float >= 0.1)
		{
			self thread player_burning_fx();
		}

		radiusdamage(self.origin, 10, max_dmg, min_dmg);

		wait 0.5;

		self.is_burning = undefined;
	}
}

zombie_exploding_death(zombie_dmg, trap)
{
	self endon("stop_flame_damage");

	if (isdefined(self.isdog) && self.isdog && isdefined(self.a.nodeath))
	{
		return;
	}

	while (isdefined(self) && self.health >= zombie_dmg && (isdefined(self.is_on_fire) && self.is_on_fire))
	{
		wait 0.5;
	}

	if (!isdefined(self) || !(isdefined(self.is_on_fire) && self.is_on_fire) || isdefined(self.damageweapon) && (scripts\zm\_zm_reimagined::is_tazer_weapon(self.damageweapon) || self.damageweapon == "jetgun_zm") || isdefined(self.knuckles_extinguish_flames) && self.knuckles_extinguish_flames)
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

	self radiusdamage(self.origin, 128, 15, 15, undefined, "MOD_GRENADE_SPLASH");
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