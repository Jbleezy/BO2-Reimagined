#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zm_prison_sq_final;
#include maps\mp\zm_alcatraz_sq_vo;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_alcatraz_sq_nixie;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zm_alcatraz_sq;

track_quest_status_thread()
{
    while ( true )
    {
        while ( level.characters_in_nml.size == 0 )
            wait 1;

        while ( level.characters_in_nml.size > 0 )
            wait 1;

        if ( flag( "plane_trip_to_nml_successful" ) )
        {
            bestow_quest_rewards();
            flag_clear( "plane_trip_to_nml_successful" );
        }

        level notify( "bridge_empty" );

        if ( level.n_quest_iteration_count == 2 )
            vo_play_four_part_conversation( level.four_part_convos["alcatraz_return_alt" + randomintrange( 0, 2 )] );

        prep_for_new_quest();
        t_plane_fly = getent( "plane_fly_trigger", "targetname" );
		t_plane_fly sethintstring( &"ZM_PRISON_PLANE_BEGIN_TAKEOFF" );
        t_plane_fly trigger_on();
    }
}

prep_for_new_quest()
{
    for ( i = 1; i < 4; i++ )
    {
        str_trigger_targetname = "trigger_electric_chair_" + i;
        t_electric_chair = getent( str_trigger_targetname, "targetname" );
        t_electric_chair sethintstring( &"ZM_PRISON_ELECTRIC_CHAIR_ACTIVATE" );
        t_electric_chair trigger_on();
    }

    for ( i = 1; i < 5; i++ )
    {
        m_electric_chair = getent( "electric_chair_" + i, "targetname" );
        m_electric_chair notify( "bridge_empty" );
    }

    m_plane_craftable = getent( "plane_craftable", "targetname" );
    m_plane_craftable show();
    playfxontag( level._effect["fx_alcatraz_plane_apear"], m_plane_craftable, "tag_origin" );
    veh_plane_flyable = getent( "plane_flyable", "targetname" );
    veh_plane_flyable attachpath( getvehiclenode( "zombie_plane_underground", "targetname" ) );
    vo_play_four_part_conversation( level.four_part_convos["alcatraz_return_quest_reset"] );
    flag_clear( "plane_is_away" );
}

plane_flight_thread()
{
    while ( true )
    {
        m_plane_about_to_crash = getent( "plane_about_to_crash", "targetname" );
        m_plane_craftable = getent( "plane_craftable", "targetname" );
        t_plane_fly = getent( "plane_fly_trigger", "targetname" );
        veh_plane_flyable = getent( "plane_flyable", "targetname" );
        m_plane_about_to_crash ghost();
        flag_wait( "plane_boarded" );
        level clientnotify( "sndPB" );

        if ( !( isdefined( level.music_override ) && level.music_override ) )
            t_plane_fly playloopsound( "mus_event_plane_countdown_loop", 0.25 );

        for ( i = 10; i > 0; i-- )
        {
            veh_plane_flyable playsound( "zmb_plane_countdown_tick" );
            wait 1;
        }

        t_plane_fly stoploopsound( 2 );
        exploder( 10000 );
        veh_plane_flyable attachpath( getvehiclenode( "zombie_plane_flight_path", "targetname" ) );
        veh_plane_flyable startpath();
        flag_set( "plane_departed" );
        t_plane_fly trigger_off();
        m_plane_craftable ghost();
        veh_plane_flyable setvisibletoall();
        level setclientfield( "fog_stage", 1 );
        playfxontag( level._effect["fx_alcatraz_plane_trail"], veh_plane_flyable, "tag_origin" );
        wait 2;
        playfxontag( level._effect["fx_alcatraz_plane_trail_fast"], veh_plane_flyable, "tag_origin" );
        wait 3;
        exploder( 10001 );
        wait 4;
        playfxontag( level._effect["fx_alcatraz_flight_lightning"], veh_plane_flyable, "tag_origin" );
        level setclientfield( "scripted_lightning_flash", 1 );
        wait 1;
        flag_set( "plane_approach_bridge" );
        stop_exploder( 10001 );
        level setclientfield( "fog_stage", 2 );
        veh_plane_flyable attachpath( getvehiclenode( "zombie_plane_bridge_approach", "targetname" ) );
        veh_plane_flyable startpath();
        wait 6;
        playfxontag( level._effect["fx_alcatraz_flight_lightning"], veh_plane_flyable, "tag_origin" );
        level setclientfield( "scripted_lightning_flash", 1 );

        veh_plane_flyable waittill( "reached_end_node" );

        flag_set( "plane_zapped" );
        level setclientfield( "fog_stage", 3 );
        veh_plane_flyable setinvisibletoall();
        n_crash_duration = 2.25;
        nd_plane_about_to_crash_1 = getstruct( "plane_about_to_crash_point_1", "targetname" );
        m_plane_about_to_crash.origin = nd_plane_about_to_crash_1.origin;
        nd_plane_about_to_crash_2 = getstruct( "plane_about_to_crash_point_2", "targetname" );
        m_plane_about_to_crash moveto( nd_plane_about_to_crash_2.origin, n_crash_duration );
        m_plane_about_to_crash thread spin_while_falling();
        stop_exploder( 10000 );

        m_plane_about_to_crash waittill( "movedone" );

        flag_set( "plane_crashed" );
        wait 2;
        level setclientfield( "scripted_lightning_flash", 1 );
        m_plane_about_to_crash.origin += vectorscale( ( 0, 0, -1 ), 2048.0 );
        wait 4;
        veh_plane_flyable setvisibletoall();
        veh_plane_flyable play_fx( "fx_alcatraz_plane_fire_trail", veh_plane_flyable.origin, veh_plane_flyable.angles, "reached_end_node", 1, "tag_origin", undefined );
        veh_plane_flyable attachpath( getvehiclenode( "zombie_plane_bridge_flyby", "targetname" ) );
        veh_plane_flyable startpath();
        veh_plane_flyable thread sndpc();

        veh_plane_flyable waittill( "reached_end_node" );

        veh_plane_flyable setinvisibletoall();
        wait 20;

        if ( !level.final_flight_activated )
        {
            if ( isdefined( level.brutus_on_the_bridge_custom_func ) )
                level thread [[ level.brutus_on_the_bridge_custom_func ]]();
            else
                level thread brutus_on_the_bridge();
        }

        flag_clear( "plane_boarded" );
        flag_clear( "plane_departed" );
        flag_clear( "plane_approach_bridge" );
        flag_clear( "plane_zapped" );
        flag_clear( "plane_crashed" );
    }
}