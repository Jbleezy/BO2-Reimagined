#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weapons;

change_melee_weapon( weapon_name, current_weapon )
{
	current_melee_weapon = self get_player_melee_weapon();
	if ( isDefined( current_melee_weapon ) && current_melee_weapon != weapon_name )
	{
		self takeweapon( current_melee_weapon );
		unacquire_weapon_toggle( current_melee_weapon );
	}
	self set_player_melee_weapon( weapon_name );
	had_ballistic = 0;
	had_ballistic_upgraded = 0;
	ballistic_was_primary = 0;
    old_ballistic = undefined;
    ballistic_ammo_clip = 0;
    ballistic_ammo_stock = 0;
	primaryweapons = self getweaponslistprimaries();
	i = 0;
	while ( i < primaryweapons.size )
	{
		primary_weapon = primaryweapons[ i ];
		if ( issubstr( primary_weapon, "knife_ballistic_" ) )
		{
			had_ballistic = 1;
			if ( primary_weapon == current_weapon )
			{
				ballistic_was_primary = 1;
			}
            old_ballistic = primary_weapon;
			ballistic_ammo_clip = self getWeaponAmmoClip( primary_weapon );
            ballistic_ammo_stock = self getWeaponAmmoStock( primary_weapon );
            self notify( "zmb_lost_knife" );
			self takeweapon( primary_weapon );
			unacquire_weapon_toggle( primary_weapon );
			if ( issubstr( primary_weapon, "upgraded" ) )
			{
				had_ballistic_upgraded = 1;
			}
		}
		i++;
	}
	if ( had_ballistic )
	{
		if ( had_ballistic_upgraded )
		{
			new_ballistic = level.ballistic_upgraded_weapon_name[ weapon_name ];
			if ( ballistic_was_primary )
			{
				current_weapon = new_ballistic;
			}
			self giveweapon( new_ballistic, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( new_ballistic ) );
		}
		else
		{
			new_ballistic = level.ballistic_weapon_name[ weapon_name ];
			if ( ballistic_was_primary )
			{
				current_weapon = new_ballistic;
			}
			self giveweapon( new_ballistic, 0 );
		}
        self giveMaxAmmo( new_ballistic );
	}
	return current_weapon;
}