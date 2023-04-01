#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_highrise_sq_atd;
#include maps\mp\zm_highrise_sq_slb;
#include maps\mp\zm_highrise_sq_ssp;
#include maps\mp\zm_highrise_sq_pts;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zm_highrise_sq;

init()
{
    if ( isdefined( level.gamedifficulty ) && level.gamedifficulty == 0 )
    {
        sq_easy_cleanup();
        return;
    }

    flag_init( "sq_disabled" );
    flag_init( "sq_branch_complete" );
    flag_init( "sq_tower_active" );
    flag_init( "sq_player_has_sniper" );
    flag_init( "sq_player_has_ballistic" );
    flag_init( "sq_ric_tower_complete" );
    flag_init( "sq_max_tower_complete" );
    flag_init( "sq_players_out_of_sync" );
    flag_init( "sq_ball_picked_up" );
    register_map_navcard( "navcard_held_zm_highrise", "navcard_held_zm_transit" );
    ss_buttons = getentarray( "sq_ss_button", "targetname" );

    for ( i = 0; i < ss_buttons.size; i++ )
    {
        ss_buttons[i] usetriggerrequirelookat();
        ss_buttons[i] sethintstring( "" );
        ss_buttons[i] setcursorhint( "HINT_NOICON" );
    }

    level thread mahjong_tiles_setup();
    flag_init( "sq_nav_built" );
    declare_sidequest( "sq", ::init_sidequest, ::sidequest_logic, ::complete_sidequest, ::generic_stage_start, ::generic_stage_complete );
    maps\mp\zm_highrise_sq_atd::init();
    maps\mp\zm_highrise_sq_slb::init();
    declare_sidequest( "sq_1", ::init_sidequest_1, ::sidequest_logic_1, ::complete_sidequest, ::generic_stage_start, ::generic_stage_complete );
    maps\mp\zm_highrise_sq_ssp::init_1();
    maps\mp\zm_highrise_sq_pts::init_1();
    declare_sidequest( "sq_2", ::init_sidequest_2, ::sidequest_logic_2, ::complete_sidequest, ::generic_stage_start, ::generic_stage_complete );
    maps\mp\zm_highrise_sq_ssp::init_2();
    maps\mp\zm_highrise_sq_pts::init_2();
    level thread init_navcard();
    level thread init_navcomputer();
    precache_sidequest_assets();
}

sidequest_logic()
{
    level thread watch_nav_computer_built();
    level thread navcomputer_waitfor_navcard();
    flag_wait( "power_on" );
    level thread vo_richtofen_power_on();
    flag_wait( "sq_nav_built" );

    if ( !is_true( level.navcomputer_spawned ) )
        update_sidequest_stats( "sq_highrise_started" );

    stage_start( "sq", "atd" );

    level waittill( "sq_atd_over" );

    stage_start( "sq", "slb" );

    level waittill( "sq_slb_over" );

    if ( !is_true( level.richcompleted ) )
        level thread sidequest_start( "sq_1" );

    if ( !is_true( level.maxcompleted ) )
        level thread sidequest_start( "sq_2" );

    flag_wait( "sq_branch_complete" );
    tower_punch_watcher();

    if ( flag( "sq_ric_tower_complete" ) )
        update_sidequest_stats( "sq_highrise_rich_complete" );
    else if ( flag( "sq_max_tower_complete" ) )
        update_sidequest_stats( "sq_highrise_maxis_complete" );
}