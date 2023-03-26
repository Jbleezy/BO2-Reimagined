#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_alcatraz_sq_vo;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\zm_alcatraz_craftables;

include_key_craftable( craftable_name, model_name )
{
    part_key = generate_zombie_craftable_piece( craftable_name, undefined, model_name, 32, 15, 0, undefined, ::onpickup_key, undefined, undefined, undefined, undefined, undefined, undefined, 1 );
    part = spawnstruct();
    part.name = craftable_name;
    part add_craftable_piece( part_key );
    part.triggerthink = maps\mp\zombies\_zm_craftables::setup_craftable_pieces;
    include_craftable( part );
}

onpickup_key( player )
{
    flag_set( "key_found" );

    if ( level.is_master_key_west )
        level clientnotify( "fxanim_west_pulley_up_start" );
    else
        level clientnotify( "fxanim_east_pulley_up_start" );

    a_m_checklist = getentarray( "plane_checklist", "targetname" );

    foreach ( m_checklist in a_m_checklist )
    {
        m_checklist showpart( "j_check_key" );
        m_checklist showpart( "j_strike_key" );
    }

    a_door_structs = getstructarray( "quest_trigger", "script_noteworthy" );

    foreach ( struct in a_door_structs )
    {
        if ( isdefined( struct.unitrigger_stub ) )
            struct.unitrigger_stub maps\mp\zombies\_zm_unitrigger::run_visibility_function_for_all_triggers();
    }

    player playsound( "evt_key_pickup" );
    player thread do_player_general_vox( "quest", "sidequest_key_response", undefined, 100 );
    //level setclientfield( "piece_key_warden", 1 );
}