#include maps\mp\zombies\_zm_weap_blundersplat;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_shared;

init()
{
	if (!maps\mp\zombies\_zm_weapons::is_weapon_included("blundergat_zm"))
		return;
	else
	{
		precacheitem("blundersplat_bullet_zm");
		precacheitem("blundersplat_explosive_dart_zm");
		precacheitem("blundersplat_bullet_upgraded_zm");
		precacheitem("blundersplat_explosive_dart_upgraded_zm");
	}

	level.zombie_spawners = getentarray("zombie_spawner", "script_noteworthy");
	array_thread(level.zombie_spawners, ::add_spawn_function, ::zombie_wait_for_blundersplat_hit);
	level.custom_derive_damage_refs = ::gib_on_blundergat_damage;
	level._effect["dart_light"] = loadfx("weapon/crossbow/fx_trail_crossbow_blink_grn_os");
	onplayerconnect_callback(::blundersplat_on_player_connect);
}

wait_for_blundersplat_fired()
{
	self endon("disconnect");

	self waittill("spawned_player");

	for (;;)
	{
		self waittill("weapon_fired", str_weapon);

		if (str_weapon == "blundersplat_zm")
		{
			self remove_clip_ammo(str_weapon);

			for (i = 0; i < weaponclipsize(str_weapon); i++)
			{
				_titus_locate_target(1, i);
			}
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
			self remove_clip_ammo(str_weapon);

			for (i = 0; i < weaponclipsize(str_weapon); i++)
			{
				_titus_locate_target(0, i);
			}
		}
	}
}

remove_clip_ammo(str_weapon)
{
	self setweaponammoclip(str_weapon, 0);

	if (self getammocount(str_weapon) == 0)
	{
		self thread force_weapon_switch(str_weapon);
	}
}

force_weapon_switch(str_weapon)
{
	self endon("disconnect");

	wait weaponfiretime(str_weapon);

	if (self getcurrentweapon() != str_weapon)
	{
		return;
	}

	primary_weapons = self getweaponslistprimaries();
	str_weapon_ind = 0;

	foreach (primary_weapon_ind, primary_weapon in primary_weapons)
	{
		if (primary_weapon == str_weapon)
		{
			str_weapon_ind = primary_weapon_ind;
			break;
		}
	}

	switch_to_weapon_ind = (str_weapon_ind + 1) % primary_weapons.size;
	self switchtoweapon(primary_weapons[switch_to_weapon_ind]);
}

_titus_locate_target(is_not_upgraded = 1, count)
{
	fire_angles = self getplayerangles();
	fire_origin = self getplayercamerapos();

	if (is_not_upgraded)
	{
		bullet_name = "blundersplat_bullet_zm";
		n_fuse_timer = randomfloatrange(1.0, 2.5);
	}
	else
	{
		bullet_name = "blundersplat_bullet_upgraded_zm";
		n_fuse_timer = randomfloatrange(3.0, 4.0);
	}

	n_spread = 6;

	if (self hasPerk("specialty_deadshot"))
	{
		n_spread *= getdvarfloat("perk_weapSpreadMultiplier");
	}

	if (count == 2)
	{
		fire_angles += (0, n_spread, 0);
	}
	else if (count == 0)
	{
		fire_angles += (0, n_spread / 3, 0);
	}
	else if (count == 1)
	{
		fire_angles -= (0, n_spread / 3, 0);
	}
	else if (count == 3)
	{
		fire_angles -= (0, n_spread, 0);
	}

	vec = anglestoforward(fire_angles);
	trace_end = fire_origin + vec * 20000;
	trace = bullettrace(fire_origin, trace_end, 1, self);
	offsetpos = trace["position"];
	e_dart = magicbullet(bullet_name, fire_origin, offsetpos, self);
	e_dart thread _titus_reset_grenade_fuse(n_fuse_timer, is_not_upgraded);
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
				e_grenade create_zombie_point_of_interest(250, 5, 10000);
			else
				e_grenade create_zombie_point_of_interest(500, 10, 10000);

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