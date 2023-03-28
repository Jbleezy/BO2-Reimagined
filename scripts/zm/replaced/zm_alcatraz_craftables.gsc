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

init_craftables()
{
    precachestring( &"ZM_PRISON_KEY_DOOR" );
    level.craftable_piece_count = 10;
    register_clientfields();
    add_zombie_craftable( "alcatraz_shield_zm", &"ZM_PRISON_CRAFT_RIOT", undefined, &"ZOMBIE_BOUGHT_RIOT", undefined, 1 );
    add_zombie_craftable_vox_category( "alcatraz_shield_zm", "build_zs" );
    make_zombie_craftable_open( "alcatraz_shield_zm", "t6_wpn_zmb_shield_dlc2_dmg0_world", vectorscale( ( 0, -1, 0 ), 90.0 ), ( 0, 0, level.riotshield_placement_zoffset ) );
    add_zombie_craftable( "packasplat", &"ZM_PRISON_CRAFT_PACKASPLAT", undefined, undefined, ::onfullycrafted_packasplat, 1 );
    add_zombie_craftable_vox_category( "packasplat", "build_bsm" );
    make_zombie_craftable_open( "packasplat", "p6_anim_zm_al_packasplat", vectorscale( ( 0, -1, 0 ), 90.0 ) );
    level.craftable_piece_swap_allowed = 0;
    add_zombie_craftable( "quest_key1" );
    add_zombie_craftable( "plane", &"ZM_PRISON_CRAFT_PLANE", &"ZM_PRISON_CRAFTING_PLANE", undefined, ::onfullycrafted_plane, 1 );
    add_zombie_craftable( "refuelable_plane", &"ZM_PRISON_REFUEL_PLANE", &"ZM_PRISON_REFUELING_PLANE", undefined, ::onfullycrafted_refueled, 1 );
    in_game_checklist_setup();
}

include_craftables()
{
    level.zombie_include_craftables["open_table"].custom_craftablestub_update_prompt = ::prison_open_craftablestub_update_prompt;
    craftable_name = "packasplat";
    packasplat_case = generate_zombie_craftable_piece( craftable_name, "case", "p6_zm_al_packasplat_suitcase", 48, 36, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_packasplat_case", 1, "build_bsm" );
    packasplat_fuse = generate_zombie_craftable_piece( craftable_name, "fuse", "p6_zm_al_packasplat_engine", 32, 36, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_packasplat_fuse", 1, "build_bsm" );
    packasplat_blood = generate_zombie_craftable_piece( craftable_name, "blood", "p6_zm_al_packasplat_iv", 32, 15, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_packasplat_blood", 1, "build_bsm" );
    packasplat = spawnstruct();
    packasplat.name = craftable_name;
    packasplat add_craftable_piece( packasplat_case );
    packasplat add_craftable_piece( packasplat_fuse );
    packasplat add_craftable_piece( packasplat_blood );
    packasplat.triggerthink = ::packasplatcraftable;
    include_craftable( packasplat );
    craftable_name = "alcatraz_shield_zm";
    riotshield_dolly = generate_zombie_craftable_piece( craftable_name, "dolly", "t6_wpn_zmb_shield_dlc2_dolly", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs" );
    riotshield_door = generate_zombie_craftable_piece( craftable_name, "door", "t6_wpn_zmb_shield_dlc2_door", 48, 15, 25, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs" );
    riotshield_clamp = generate_zombie_craftable_piece( craftable_name, "clamp", "t6_wpn_zmb_shield_dlc2_shackles", 32, 15, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs" );
    riotshield = spawnstruct();
    riotshield.name = craftable_name;
    riotshield add_craftable_piece( riotshield_dolly );
    riotshield add_craftable_piece( riotshield_door );
    riotshield add_craftable_piece( riotshield_clamp );
    riotshield.onbuyweapon = ::onbuyweapon_riotshield;
    riotshield.triggerthink = ::riotshieldcraftable;
    include_craftable( riotshield );
    include_key_craftable( "quest_key1", "p6_zm_al_key" );
    craftable_name = "plane";
    plane_cloth = generate_zombie_craftable_piece( craftable_name, "cloth", "p6_zm_al_clothes_pile_lrg", 48, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_origin", undefined, 1 );
    plane_fueltanks = generate_zombie_craftable_piece( craftable_name, "fueltanks", "veh_t6_dlc_zombie_part_fuel", 32, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_feul_tanks", undefined, 2 );
    plane_engine = generate_zombie_craftable_piece( craftable_name, "engine", "veh_t6_dlc_zombie_part_engine", 32, 62, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_origin", undefined, 3 );
    plane_steering = generate_zombie_craftable_piece( craftable_name, "steering", "veh_t6_dlc_zombie_part_control", 32, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_control_mechanism", undefined, 4 );
    plane_rigging = generate_zombie_craftable_piece( craftable_name, "rigging", "veh_t6_dlc_zombie_part_rigging", 32, 15, 0, undefined, ::onpickup_plane, ::ondrop_plane, ::oncrafted_plane, undefined, "tag_origin", undefined, 5 );

    plane_cloth.is_shared = 1;
    plane_fueltanks.is_shared = 1;
    plane_engine.is_shared = 1;
    plane_steering.is_shared = 1;
    plane_rigging.is_shared = 1;
    plane_cloth.client_field_state = undefined;
    plane_fueltanks.client_field_state = undefined;
    plane_engine.client_field_state = undefined;
    plane_steering.client_field_state = undefined;
    plane_rigging.client_field_state = undefined;

    plane_cloth.pickup_alias = "sidequest_sheets";
    plane_fueltanks.pickup_alias = "sidequest_oxygen";
    plane_engine.pickup_alias = "sidequest_engine";
    plane_steering.pickup_alias = "sidequest_valves";
    plane_rigging.pickup_alias = "sidequest_rigging";
    plane = spawnstruct();
    plane.name = craftable_name;
    plane add_craftable_piece( plane_cloth );
    plane add_craftable_piece( plane_engine );
    plane add_craftable_piece( plane_fueltanks );
    plane add_craftable_piece( plane_steering );
    plane add_craftable_piece( plane_rigging );
    plane.triggerthink = ::planecraftable;
    plane.custom_craftablestub_update_prompt = ::prison_plane_update_prompt;
    include_craftable( plane );
    craftable_name = "refuelable_plane";
    refuelable_plane_gas1 = generate_zombie_craftable_piece( craftable_name, "fuel1", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 6 );
    refuelable_plane_gas2 = generate_zombie_craftable_piece( craftable_name, "fuel2", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 7 );
    refuelable_plane_gas3 = generate_zombie_craftable_piece( craftable_name, "fuel3", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 8 );
    refuelable_plane_gas4 = generate_zombie_craftable_piece( craftable_name, "fuel4", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 9 );
    refuelable_plane_gas5 = generate_zombie_craftable_piece( craftable_name, "fuel5", "accessories_gas_canister_1", 32, 15, 0, undefined, ::onpickup_fuel, ::ondrop_fuel, ::oncrafted_fuel, undefined, undefined, undefined, 10 );

    refuelable_plane_gas1.is_shared = 1;
    refuelable_plane_gas2.is_shared = 1;
    refuelable_plane_gas3.is_shared = 1;
    refuelable_plane_gas4.is_shared = 1;
    refuelable_plane_gas5.is_shared = 1;
    refuelable_plane_gas1.client_field_state = undefined;
    refuelable_plane_gas2.client_field_state = undefined;
    refuelable_plane_gas3.client_field_state = undefined;
    refuelable_plane_gas4.client_field_state = undefined;
    refuelable_plane_gas5.client_field_state = undefined;

    refuelable_plane = spawnstruct();
    refuelable_plane.name = craftable_name;
    refuelable_plane add_craftable_piece( refuelable_plane_gas1 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas2 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas3 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas4 );
    refuelable_plane add_craftable_piece( refuelable_plane_gas5 );
    refuelable_plane.triggerthink = ::planefuelable;
    plane.custom_craftablestub_update_prompt = ::prison_plane_update_prompt;
    include_craftable( refuelable_plane );
}

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