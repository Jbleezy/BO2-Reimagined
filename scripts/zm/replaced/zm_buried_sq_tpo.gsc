#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\_visionset_mgr;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm;
#include maps\mp\zm_buried_sq;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zm_buried_sq_tpo;

init()
{
    declare_sidequest_stage( "sq", "tpo", ::init_stage, ::stage_logic, ::exit_stage );
    flag_init( "sq_tpo_time_bomb_in_valid_location" );
    flag_init( "sq_tpo_players_in_position_for_time_warp" );
    flag_init( "sq_tpo_special_round_active" );
    flag_init( "sq_tpo_found_item" );
    flag_init( "sq_tpo_generator_powered" );
    flag_init( "sq_wisp_saved_with_time_bomb" );
    flag_init( "sq_tpo_stage_started" );
    maps\mp\zombies\_zm_weap_time_bomb::time_bomb_add_custom_func_global_save( ::time_bomb_saves_wisp_state );
    maps\mp\zombies\_zm_weap_time_bomb::time_bomb_add_custom_func_global_restore( ::time_bomb_restores_wisp_state );

    level._effect["sq_tpo_time_bomb_fx"] = loadfx( "maps/zombie_buried/fx_buried_ghost_drain" );
    level.sq_tpo = spawnstruct();
    level thread setup_buildable_switch();
}

stage_logic()
{
    flag_set( "sq_tpo_stage_started" );

    if ( flag( "sq_is_ric_tower_built" ) )
        stage_logic_richtofen();
    else
        stage_logic_maxis();

    stage_completed( "sq", level._cur_stage_name );
}

stage_logic_maxis()
{
    flag_clear( "sq_wisp_success" );
    flag_clear( "sq_wisp_failed" );

    while ( !flag( "sq_wisp_success" ) )
    {
        stage_start( "sq", "ts" );

        level waittill( "sq_ts_over" );

        stage_start( "sq", "ctw" );

        level waittill( "sq_ctw_over" );
    }

    level._cur_stage_name = "tpo";
}

stage_logic_richtofen()
{
    level endon( "sq_tpo_generator_powered" );

    e_time_bomb_volume = getent( "sq_tpo_timebomb_volume", "targetname" );

    do
    {
        flag_clear( "sq_tpo_time_bomb_in_valid_location" );

        b_time_bomb_in_valid_location = 0;
        while (1)
        {
            if ( isdefined( level.time_bomb_save_data ) && isdefined( level.time_bomb_save_data.time_bomb_model ) )
            {
                b_time_bomb_in_valid_location = level.time_bomb_save_data.time_bomb_model istouching( e_time_bomb_volume );
                level.time_bomb_save_data.time_bomb_model.sq_location_valid = b_time_bomb_in_valid_location;
            }

            if ( b_time_bomb_in_valid_location )
            {
                break;
            }

            level waittill( "new_time_bomb_set" );
        }

        playfxontag( level._effect["sq_tpo_time_bomb_fx"], level.time_bomb_save_data.time_bomb_model, "tag_origin" );
        flag_set( "sq_tpo_time_bomb_in_valid_location" );
        flag_set( "sq_tpo_players_in_position_for_time_warp" );
        wait_for_time_bomb_to_be_detonated_or_thrown_again();
        level notify( "sq_tpo_stop_checking_time_bomb_volume" );

        if ( flag( "time_bomb_restore_active" ) )
        {
            if ( flag( "sq_tpo_players_in_position_for_time_warp" ) )
            {
                special_round_start();
                level notify( "sq_tpo_special_round_started" );
                start_item_hunt_with_timeout( 60 );
                special_round_end();
                level notify( "sq_tpo_special_round_ended" );
            }
        }

        wait_network_frame();
    }
    while ( !flag( "sq_tpo_generator_powered" ) );
}

special_round_start()
{
    flag_set( "sq_tpo_special_round_active" );
    level.sq_tpo.times_searched = 0;
    flag_clear( "time_bomb_detonation_enabled" );
    level thread sndsidequestnoirmusic();
    make_super_zombies( 1 );
    a_players = get_players();

    foreach ( player in a_players )
        vsmgr_activate( "visionset", "cheat_bw", player );

    level setclientfield( "sq_tpo_special_round_active", 1 );
}

special_round_end()
{
    level setclientfield( "sq_tpo_special_round_active", 0 );
    level notify( "sndEndNoirMusic" );
    make_super_zombies( 0 );
    level._time_bomb.functionality_override = 0;
    flag_set( "time_bomb_detonation_enabled" );
    scripts\zm\replaced\_zm_weap_time_bomb::time_bomb_detonation();

    a_players = get_players();
    foreach ( player in a_players )
    {
        vsmgr_deactivate( "visionset", "cheat_bw", player );
        player notify( "search_done" );
    }

    clean_up_special_round();
    flag_clear( "sq_tpo_special_round_active" );
}