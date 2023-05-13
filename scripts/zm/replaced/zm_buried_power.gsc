#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zm_buried_power;

electric_switch()
{
    trig = getent( "use_elec_switch", "targetname" );
    master_switch = getent( "elec_switch", "targetname" );
    master_switch notsolid();
    trig sethintstring( &"ZOMBIE_ELECTRIC_SWITCH" );
    trig setvisibletoall();

    trig setinvisibletoall();
    master_switch rotateroll( -90, 0.3 );
    master_switch playsound( "zmb_switch_flip" );
    master_switch playsound( "zmb_poweron" );
    level delay_thread( 11.8, ::sndpoweronmusicstinger );

    master_switch waittill( "rotatedone" );

    master_switch playsound( "zmb_turn_on" );
    level notify( "electric_door" );
    clientnotify( "power_on" );
    flag_set( "power_on" );
    level setclientfield( "zombie_power_on", 1 );
}