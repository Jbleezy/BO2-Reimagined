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

dryer_zombies_thread()
{
    n_zombie_count_min = 20;
    e_shower_zone = getent( "cellblock_shower", "targetname" );
    flag_wait( "dryer_cycle_active" );

    if ( level.zombie_total < n_zombie_count_min )
        level.zombie_total = n_zombie_count_min;

    while ( flag( "dryer_cycle_active" ) )
    {
        a_zombies_in_shower = [];
        a_zombies_in_shower = get_zombies_touching_volume( "axis", "cellblock_shower", undefined );

        if ( a_zombies_in_shower.size < n_zombie_count_min )
        {
            e_zombie = get_farthest_available_zombie( e_shower_zone );

            if ( isdefined( e_zombie ) && !isinarray( a_zombies_in_shower, e_zombie ) )
            {
                e_zombie notify( "zapped" );
                e_zombie thread dryer_teleports_zombie();
            }
        }

        wait 1;
    }
}

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

plane_boarding_thread()
{
    self endon( "death_or_disconnect" );
    flag_set( "plane_is_away" );
    self thread player_disconnect_watcher();
    self thread player_death_watcher();

    flag_set( "plane_boarded" );
    self setclientfieldtoplayer( "effects_escape_flight", 1 );
    level.brutus_respawn_after_despawn = 0;
    a_nml_teleport_targets = [];

    for ( i = 1; i < 6; i++ )
        a_nml_teleport_targets[i - 1] = getstruct( "nml_telepoint_" + i, "targetname" );

    level.characters_in_nml[level.characters_in_nml.size] = self.character_name;
    self.on_a_plane = 1;
    level.someone_has_visited_nml = 1;
    self.n_passenger_index = level.characters_in_nml.size;
    m_plane_craftable = getent( "plane_craftable", "targetname" );
    m_plane_about_to_crash = getent( "plane_about_to_crash", "targetname" );
    veh_plane_flyable = getent( "plane_flyable", "targetname" );
    t_plane_fly = getent( "plane_fly_trigger", "targetname" );
    t_plane_fly sethintstring( &"ZM_PRISON_PLANE_BOARD" );
    self enableinvulnerability();
    self playerlinktodelta( m_plane_craftable, "tag_player_crouched_" + ( self.n_passenger_index + 1 ) );
    self allowstand( 0 );
    flag_wait( "plane_departed" );
    level notify( "sndStopBrutusLoop" );
    self clientnotify( "sndPS" );
    self playsoundtoplayer( "zmb_plane_takeoff", self );
    level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "plane_takeoff", self );
    self playerlinktodelta( veh_plane_flyable, "tag_player_crouched_" + ( self.n_passenger_index + 1 ) );
    self setclientfieldtoplayer( "effects_escape_flight", 2 );
    flag_wait( "plane_approach_bridge" );
    self thread snddelayedimp();
    self setclientfieldtoplayer( "effects_escape_flight", 3 );
    self unlink();
    self playerlinktoabsolute( veh_plane_flyable, "tag_player_crouched_" + ( self.n_passenger_index + 1 ) );
    flag_wait( "plane_zapped" );
    flag_set( "activate_player_zone_bridge" );
    self playsoundtoplayer( "zmb_plane_fall", self );
    self setclientfieldtoplayer( "effects_escape_flight", 4 );
    self.dontspeak = 1;
    self setclientfieldtoplayer( "isspeaking", 1 );
    self playerlinktodelta( m_plane_about_to_crash, "tag_player_crouched_" + ( self.n_passenger_index + 1 ), 1, 0, 0, 0, 0, 1 );
    self forcegrenadethrow();
    str_current_weapon = self getcurrentweapon();
    self giveweapon( "falling_hands_zm" );
    self switchtoweaponimmediate( "falling_hands_zm" );
    self setweaponammoclip( "falling_hands_zm", 0 );
    players = getplayers();

    foreach ( player in players )
    {
        if ( player != self )
            player setinvisibletoplayer( self );
    }

    flag_wait( "plane_crashed" );
    self setclientfieldtoplayer( "effects_escape_flight", 5 );
    self takeweapon( "falling_hands_zm" );

    if ( isdefined( str_current_weapon ) && str_current_weapon != "none" )
        self switchtoweaponimmediate( str_current_weapon );

    self thread fadetoblackforxsec( 0, 2, 0, 0.5, "black" );
    self thread snddelayedmusic();
    self unlink();
    self allowstand( 1 );
    self setstance( "stand" );
    players = getplayers();

    foreach ( player in players )
    {
        if ( player != self )
            player setvisibletoplayer( self );
    }

    flag_clear( "spawn_zombies" );
    self setorigin( a_nml_teleport_targets[self.n_passenger_index].origin );
    e_poi = getstruct( "plane_crash_poi", "targetname" );
    vec_to_target = e_poi.origin - self.origin;
    vec_to_target = vectortoangles( vec_to_target );
    vec_to_target = ( 0, vec_to_target[1], 0 );
    self setplayerangles( vec_to_target );
    n_shellshock_duration = 5;
    self shellshock( "explosion", n_shellshock_duration );
    self.dontspeak = 0;
    self setclientfieldtoplayer( "isspeaking", 0 );
    self notify( "player_at_bridge" );
    wait( n_shellshock_duration );
    self disableinvulnerability();
    self.on_a_plane = 0;

    if ( level.characters_in_nml.size == 1 )
        self thread vo_bridge_soliloquy();
    else if ( level.characters_in_nml.size == 4 )
        level thread vo_bridge_four_part_convo();

    self playsoundtoplayer( "zmb_ggb_swarm_start", self );
    flag_set( "spawn_zombies" );
    level.brutus_respawn_after_despawn = 1;
    character_name = level.characters_in_nml[randomintrange( 0, level.characters_in_nml.size )];
    players = getplayers();

    foreach ( player in players )
    {
        if ( isdefined( player ) && player.character_name == character_name )
            player thread do_player_general_vox( "quest", "zombie_arrive_gg", undefined, 100 );
    }
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

manage_electric_chairs()
{
    level notify( "manage_electric_chairs" );
    level endon( "manage_electric_chairs" );

    while ( true )
    {
        flag_wait( "plane_approach_bridge" );

        for ( i = 1; i < 5; i++ )
        {
            str_trigger_targetname = "trigger_electric_chair_" + i;
            t_electric_chair = getent( str_trigger_targetname, "targetname" );

            if ( isdefined( level.electric_chair_trigger_thread_custom_func ) )
                t_electric_chair thread [[ level.electric_chair_trigger_thread_custom_func ]]( i );
            else
                t_electric_chair thread electric_chair_trigger_thread( i );

            t_electric_chair setcursorhint( "HINT_NOICON" );
            t_electric_chair sethintstring( &"ZM_PRISON_ELECTRIC_CHAIR_ACTIVATE" );
            t_electric_chair usetriggerrequirelookat();
        }

        if ( level.final_flight_activated )
        {
            level.revive_trigger_should_ignore_sight_checks = maps\mp\zm_prison_sq_final::revive_trigger_should_ignore_sight_checks;

            for ( j = 0; j < level.final_flight_players.size; j++ )
            {
                m_electric_chair = getent( "electric_chair_" + ( j + 1 ), "targetname" );
                corpse = level.final_flight_players[j].e_afterlife_corpse;
                corpse linkto( m_electric_chair, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
                corpse maps\mp\zombies\_zm_clone::clone_animate( "chair" );
                wait 1;
                corpse.revivetrigger unlink();
                corpse.revivetrigger.origin = m_electric_chair.origin + ( 64, 0, 32 );
            }

            for ( j = 1; j < 5; j++ )
            {
                str_trigger_targetname = "trigger_electric_chair_" + j;
                t_electric_chair = getent( str_trigger_targetname, "targetname" );
                t_electric_chair trigger_off();
            }
        }
        else
        {
            for ( i = 1; i < 5; i++ )
            {
                m_electric_chair = getent( "electric_chair_" + i, "targetname" );
                m_electric_chair hide();
                str_trigger_targetname = "trigger_electric_chair_" + i;
                t_electric_chair = getent( str_trigger_targetname, "targetname" );
                t_electric_chair trigger_off();
            }

            flag_wait( "plane_crashed" );
            exploder( 666 );

            for ( i = 1; i < 5; i++ )
            {
                m_electric_chair = getent( "electric_chair_" + i, "targetname" );
                m_electric_chair show();
                m_electric_chair thread snddelayedchairaudio( i );
                str_trigger_targetname = "trigger_electric_chair_" + i;
                t_electric_chair = getent( str_trigger_targetname, "targetname" );
                t_electric_chair trigger_on();
            }

            wait 3;
            electric_chair_vo();
        }

        flag_waitopen( "plane_approach_bridge" );
    }
}