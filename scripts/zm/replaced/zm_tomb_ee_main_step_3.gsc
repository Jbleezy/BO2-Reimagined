#include maps\mp\zm_tomb_ee_main_step_3;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zombies\_zm_unitrigger;

ready_to_activate( unitrigger_stub )
{
    self endon( "death" );
    self playsoundwithnotify( "vox_maxi_robot_sync_0", "sync_done" );

    self waittill( "sync_done" );

    wait 0.5;
    self playsoundwithnotify( "vox_maxi_robot_await_0", "ready_to_use" );

    self waittill( "ready_to_use" );

    maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( unitrigger_stub, ::activate_fire_link );
}

activate_fire_link()
{
    self endon( "kill_trigger" );

    while ( true )
    {
        self waittill( "trigger", player );

        self playsound( "zmb_squest_robot_button" );

        level thread fire_link_cooldown( self );
        self playsound( "zmb_squest_robot_button_activate" );
        self playloopsound( "zmb_squest_robot_button_timer", 0.5 );
        flag_waitopen( "fire_link_enabled" );
        self stoploopsound( 0.5 );
        self playsound( "zmb_squest_robot_button_deactivate" );
    }
}

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