#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_buried_sq;
#include maps\mp\zm_buried_sq_ows;

ows_targets_start()
{
    n_cur_second = 0;
    flag_clear( "sq_ows_target_missed" );
    level thread sndsidequestowsmusic();
    a_sign_spots = getstructarray( "otw_target_spot", "script_noteworthy" );

    level.targets_hit = 0;

    while ( n_cur_second < 40 )
    {
        a_spawn_spots = ows_targets_get_cur_spots( n_cur_second );

        if ( isdefined( a_spawn_spots ) && a_spawn_spots.size > 0 )
            ows_targets_spawn( a_spawn_spots );

        wait 1;
        n_cur_second++;
    }

    players = get_players();
    if ( level.targets_hit < ( 20 * players.size ) )
    {
        flag_set( "sq_ows_target_missed" );
    }

    if ( !flag( "sq_ows_target_missed" ) )
    {
        flag_set( "sq_ows_success" );
        playsoundatposition( "zmb_sq_target_success", ( 0, 0, 0 ) );
    }
    else
        playsoundatposition( "zmb_sq_target_fail", ( 0, 0, 0 ) );

    level notify( "sndEndOWSMusic" );
}

ows_targets_spawn( a_spawn_spots )
{
    i = 0;
    foreach ( s_spot in a_spawn_spots )
    {
        m_target = spawn( "script_model", s_spot.origin );
        m_target.angles = s_spot.angles;
        m_target setmodel( "p6_zm_bu_target" );
        m_target ghost();
        wait_network_frame();
        m_target show();
        playfxontag( level._effect["sq_spawn"], m_target, "tag_origin" );
        m_target playsound( "zmb_sq_target_spawn" );

        if ( isdefined( s_spot.target ) )
            m_target thread ows_target_move( s_spot.target );

        m_target thread ows_target_think();
        m_target thread sndhit();
        m_target thread sndtime();
        i++;
    }
}

ows_target_think()
{
    self setcandamage( 1 );
    self thread ows_target_delete_timer();
    msg = self waittill_any_return( "ows_target_timeout", "damage" );

    if ( msg == "damage" )
    {
        level.targets_hit++;
    }

    if ( isdefined( self.m_linker ) )
    {
        self unlink();
        self.m_linker delete();
    }

    self rotatepitch( -90, 0.15, 0.05, 0.05 );

    self waittill( "rotatedone" );

    self delete();
}

ows_target_delete_timer()
{
    self endon( "death" );
    wait 4;
    self notify( "ows_target_timeout" );
}