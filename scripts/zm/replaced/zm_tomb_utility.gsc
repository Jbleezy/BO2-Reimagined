#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zm_tomb_craftables;
#include maps\mp\zm_tomb_utility;

update_staff_accessories( n_element_index )
{
    cur_weapon = self get_player_melee_weapon();

    if ( !issubstr( cur_weapon, "one_inch_punch" ) )
    {
        weapon_to_keep = "knife_zm";
        self.use_staff_melee = 0;

        if ( n_element_index != 0 )
        {
            staff_info = maps\mp\zm_tomb_craftables::get_staff_info_from_element_index( n_element_index );

            if ( staff_info.charger.is_charged )
                staff_info = staff_info.upgrade;

            if ( isdefined( staff_info.melee ) )
            {
                weapon_to_keep = staff_info.melee;
                self.use_staff_melee = 1;
            }
        }

        melee_changed = 0;

        if ( cur_weapon != weapon_to_keep )
        {
            self takeweapon( cur_weapon );
            self giveweapon( weapon_to_keep );
            self set_player_melee_weapon( weapon_to_keep );
            melee_changed = 1;
        }
    }
    else if ( issubstr( cur_weapon, "one_inch_punch" ) && is_true( self.b_punch_upgraded ) )
    {
        self.str_punch_element = get_punch_element_from_index(n_element_index);
        weapon_to_keep = "one_inch_punch_" + self.str_punch_element + "_zm";

        if ( cur_weapon != weapon_to_keep )
        {
            self takeweapon( cur_weapon );
            self giveweapon( weapon_to_keep );
            self set_player_melee_weapon( weapon_to_keep );
        }
    }

    has_revive = self hasweapon( "staff_revive_zm" );
    has_upgraded_staff = 0;
    a_weapons = self getweaponslistprimaries();
    staff_info = maps\mp\zm_tomb_craftables::get_staff_info_from_element_index( n_element_index );

    foreach ( str_weapon in a_weapons )
    {
        if ( is_weapon_upgraded_staff( str_weapon ) )
            has_upgraded_staff = 1;
    }

    if ( has_revive && !has_upgraded_staff )
    {
        self setactionslot( 3, "altmode" );
        self takeweapon( "staff_revive_zm" );
    }
    else if ( !has_revive && has_upgraded_staff )
    {
        self setactionslot( 3, "weapon", "staff_revive_zm" );
        self giveweapon( "staff_revive_zm" );

        if ( isdefined( staff_info ) && isdefined( staff_info.upgrade.revive_ammo_stock ) )
        {
            if ( staff_info.upgrade.revive_ammo_clip < 1 && staff_info.upgrade.revive_ammo_stock >= 1 )
            {
                staff_info.upgrade.revive_ammo_clip += 1;
                staff_info.upgrade.revive_ammo_stock -= 1;
            }

            self setweaponammostock( "staff_revive_zm", staff_info.upgrade.revive_ammo_stock );
            self setweaponammoclip( "staff_revive_zm", staff_info.upgrade.revive_ammo_clip );
        }
        else
        {
            self setweaponammostock( "staff_revive_zm", 3 );
            self setweaponammoclip( "staff_revive_zm", 1 );
        }
    }
}

get_punch_element_from_index(ind)
{
    if ( ind == 1 )
    {
        return "fire";
    }
    else if ( ind == 2 )
    {
        return "air";
    }
    else if ( ind == 3 )
    {
        return "lightning";
    }
    else if ( ind == 4 )
    {
        return "ice";
    }

    return "upgraded";
}

check_solo_status()
{
    level.is_forever_solo_game = 0;
}