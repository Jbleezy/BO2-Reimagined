#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zm_tomb_ee_lights;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_tomb_amb;
#include maps\mp\zm_tomb_ee_side;

swap_mg( e_player )
{
    str_current_weapon = e_player getcurrentweapon();
    str_reward_weapon = maps\mp\zombies\_zm_weapons::get_upgrade_weapon( "mg08_zm" );

    if ( is_player_valid( e_player ) && !e_player.is_drinking && !is_melee_weapon( str_current_weapon ) && !is_placeable_mine( str_current_weapon ) && !is_equipment( str_current_weapon ) && level.revive_tool != str_current_weapon && "none" != str_current_weapon && !e_player hacker_active() )
    {
        if ( e_player hasweapon( str_reward_weapon ) )
            e_player givemaxammo( str_reward_weapon );
        else
        {
            a_weapons = e_player getweaponslistprimaries();

            if ( isdefined( a_weapons ) && a_weapons.size >= get_player_weapon_limit( e_player ) )
                e_player takeweapon( str_current_weapon );

            e_player giveweapon( str_reward_weapon, 0, e_player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( str_reward_weapon ) );
            e_player givestartammo( str_reward_weapon );
            e_player switchtoweapon( str_reward_weapon );
        }

        return true;
    }
    else
        return false;
}