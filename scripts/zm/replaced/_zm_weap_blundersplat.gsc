#include maps\mp\zombies\_zm_weap_blundersplat;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_shared;

wait_for_blundersplat_fired()
{
	self endon("disconnect");

	self waittill("spawned_player");

	for (;;)
	{
		self waittill("weapon_fired", str_weapon);

		if (str_weapon == "blundersplat_zm")
		{
			_titus_locate_target(1, 0);
			wait_network_frame();
			_titus_locate_target(1, 1);
			wait_network_frame();
			_titus_locate_target(1, 2);
			wait_network_frame();
		}
	}
}

wait_for_blundersplat_upgraded_fired()
{
	self endon("disconnect");

	self waittill("spawned_player");

	for (;;)
	{
		self waittill("weapon_fired", str_weapon);

		if (str_weapon == "blundersplat_upgraded_zm")
		{
			_titus_locate_target(0, 0);
			wait_network_frame();
			_titus_locate_target(0, 1);
			wait_network_frame();
			_titus_locate_target(0, 2);
			wait_network_frame();
		}
	}
}

_titus_locate_target(is_not_upgraded = 1, count)
{
	fire_angles = self getplayerangles();
	fire_origin = self getplayercamerapos();

	if (is_not_upgraded)
		n_fuse_timer = randomfloatrange(1.0, 2.5);
	else
		n_fuse_timer = randomfloatrange(3.0, 4.0);

	n_spread = 5;

	if (isads(self))
	{
		n_spread *= 0.5;
	}
	else if (self hasPerk("specialty_deadshot"))
	{
		n_spread *= getdvarfloat("perk_weapSpreadMultiplier");
	}

	if (count == 1)
	{
		fire_angles += (0, n_spread, 0);
	}
	else if (count == 2)
	{
		fire_angles -= (0, n_spread, 0);
	}

	vec = anglestoforward(fire_angles);
	trace_end = fire_origin + vec * 20000;
	trace = bullettrace(fire_origin, trace_end, 1, self);
	offsetpos = trace["position"];
	e_dart = magicbullet("blundersplat_bullet_zm", fire_origin, offsetpos, self);
	e_dart thread _titus_reset_grenade_fuse(n_fuse_timer);
}

_titus_reset_grenade_fuse(n_fuse_timer = randomfloatrange(1, 1.5), is_not_upgraded = 1)
{
	self waittill("death");

	a_grenades = getentarray("grenade", "classname");

	foreach (e_grenade in a_grenades)
	{
		if (isdefined(e_grenade.model) && e_grenade.model == "t6_wpn_zmb_projectile_blundergat" && !isdefined(e_grenade.fuse_reset))
		{
			e_grenade.fuse_reset = 1;
			e_grenade.fuse_time = n_fuse_timer;
			e_grenade resetmissiledetonationtime(n_fuse_timer);

			if (is_not_upgraded)
				e_grenade create_zombie_point_of_interest(250, 15, 10000);
			else
				e_grenade create_zombie_point_of_interest(500, 30, 10000);

			return;
		}
	}
}

_titus_target_animate_and_die(n_fuse_timer, inflictor)
{
	self endon("death");
	self endon("titus_target_timeout");
	self thread _titus_target_timeout(n_fuse_timer);
	self thread _titus_check_for_target_death(inflictor);
	self thread _blundersplat_target_acid_stun_anim();
	wait(n_fuse_timer);
	self notify("killed_by_a_blundersplat", inflictor);
	self dodamage(self.health + 1000, self.origin, inflictor);
}