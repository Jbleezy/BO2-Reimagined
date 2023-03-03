#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_tomb_ee_main_step_3;

fire_link_cooldown( t_button )
{
    level notify( "fire_link_cooldown" );
    level endon( "fire_link_cooldown" );
    flag_set( "fire_link_enabled" );

    if ( isdefined( t_button ) )
    {
        t_button playsound( "vox_maxi_robot_activated_0" );
    }
}