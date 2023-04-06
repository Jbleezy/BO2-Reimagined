#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_sq_nixie;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_alcatraz_sq;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm;
#include maps\mp\zm_prison_sq_final;

stage_one()
{
    if ( isdefined( level.gamedifficulty ) && level.gamedifficulty == 0 )
    {
        sq_final_easy_cleanup();
        return;
    }

    precachemodel( "p6_zm_al_audio_headset_icon" );
    flag_wait( "quest_completed_thrice" );
    flag_wait( "spoon_obtained" );
    flag_wait( "warden_blundergat_obtained" );

    for ( i = 1; i < 4; i++ )
    {
        m_nixie_tube = getent( "nixie_tube_" + i, "targetname" );
        m_nixie_tube thread nixie_tube_scramble_protected_effects( i );
    }

    level waittill_multiple( "nixie_tube_trigger_1", "nixie_tube_trigger_2", "nixie_tube_trigger_3" );
    nixie_tube_off();

    m_nixie_tube = getent( "nixie_tube_1", "targetname" );
    m_nixie_tube playsoundwithnotify( "vox_brutus_nixie_right_0", "scary_voice" );

    m_nixie_tube waittill( "scary_voice" );

    wait 3;
    level thread stage_two();
}

stage_two()
{
    audio_logs = [];
    audio_logs[0] = [];
    audio_logs[0][0] = "vox_guar_tour_vo_1_0";
    audio_logs[0][1] = "vox_guar_tour_vo_2_0";
    audio_logs[0][2] = "vox_guar_tour_vo_3_0";
    audio_logs[2] = [];
    audio_logs[2][0] = "vox_guar_tour_vo_4_0";
    audio_logs[3] = [];
    audio_logs[3][0] = "vox_guar_tour_vo_5_0";
    audio_logs[3][1] = "vox_guar_tour_vo_6_0";
    audio_logs[4] = [];
    audio_logs[4][0] = "vox_guar_tour_vo_7_0";
    audio_logs[5] = [];
    audio_logs[5][0] = "vox_guar_tour_vo_8_0";
    audio_logs[6] = [];
    audio_logs[6][0] = "vox_guar_tour_vo_9_0";
    audio_logs[6][1] = "vox_guar_tour_vo_10_0";
    play_sq_audio_log( 0, audio_logs[0], 0 );

    for ( i = 2; i <= 6; i++ )
        play_sq_audio_log( i, audio_logs[i], 1 );

    level.m_headphones delete();
    t_plane_fly_afterlife = getent( "plane_fly_afterlife_trigger", "script_noteworthy" );
    t_plane_fly_afterlife playsound( "zmb_easteregg_laugh" );
    t_plane_fly_afterlife trigger_on();
}

final_flight_trigger()
{
    t_plane_fly = getent( "plane_fly_trigger", "targetname" );
    self setcursorhint( "HINT_NOICON" );
    self sethintstring( "" );

    while ( isdefined( self ) )
    {
        self waittill( "trigger", e_triggerer );

        if ( isplayer( e_triggerer ) )
        {
            if ( isdefined( level.custom_plane_validation ) )
            {
                valid = self [[ level.custom_plane_validation ]]( e_triggerer );

                if ( !valid )
                    continue;
            }

            players = getplayers();

            b_everyone_is_ready = 1;

            foreach ( player in players )
            {
                if ( !isdefined( player ) || player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
                    b_everyone_is_ready = 0;
            }

            if ( !b_everyone_is_ready )
                continue;

            if ( flag( "plane_is_away" ) )
                continue;

            flag_set( "plane_is_away" );
            t_plane_fly trigger_off();

            foreach ( player in players )
            {
                if ( isdefined( player ) )
                {
                    player thread final_flight_player_thread();
                }
            }

            return;
        }
    }
}