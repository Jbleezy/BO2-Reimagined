#include maps\mp\zombies\_zm_weap_staff_revive;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_laststand;

watch_staff_revive_fired()
{
	self endon( "disconnect" );

	while ( true )
	{
		self waittill( "missile_fire", e_projectile, str_weapon );

		if ( !( str_weapon == "staff_revive_zm" ) )
			continue;

		self thread staff_revive_impact_wait();

		self thread staff_revive_reload( str_weapon );
	}
}

staff_revive_impact_wait()
{
	self waittill( "projectile_impact", e_ent, v_explode_point, n_radius, str_name, n_impact );

	self thread staff_revive_impact( v_explode_point );
}

staff_revive_reload( str_weapon )
{
	self endon( "disconnect" );

	wait 0.4;

	ammo_clip = self getWeaponAmmoClip(str_weapon);
	ammo_stock = self getWeaponAmmoStock(str_weapon);

	if (ammo_clip < 1 && ammo_stock >= 1)
	{
		self setWeaponAmmoClip(str_weapon, ammo_clip + 1);
		self setWeaponAmmoStock(str_weapon, ammo_stock - 1);
		return;
	}

	while (1)
	{
		self waittill( "weapon_change" );

		if (self getCurrentWeapon() == str_weapon)
		{
			ammo_clip = self getWeaponAmmoClip(str_weapon);
			ammo_stock = self getWeaponAmmoStock(str_weapon);

			if (ammo_clip < 1 && ammo_stock >= 1)
			{
				self setWeaponAmmoClip(str_weapon, ammo_clip + 1);
				self setWeaponAmmoStock(str_weapon, ammo_stock - 1);
			}

			return;
		}
	}
}