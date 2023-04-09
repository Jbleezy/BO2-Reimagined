#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_highrise_elevators;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_highrise_buildables;

init_buildables()
{
    level.buildable_piece_count = 13;
    add_zombie_buildable( "springpad_zm", &"ZM_HIGHRISE_BUILD_SPRINGPAD", &"ZM_HIGHRISE_BUILDING_SPRINGPAD", &"ZM_HIGHRISE_BOUGHT_SPRINGPAD" );
    add_zombie_buildable( "slipgun_zm", &"ZM_HIGHRISE_BUILD_SLIPGUN", &"ZM_HIGHRISE_BUILDING_SLIPGUN", &"ZM_HIGHRISE_BOUGHT_SLIPGUN" );
    add_zombie_buildable( "sq_common", &"ZOMBIE_BUILD_SQ_COMMON", &"ZOMBIE_BUILDING_SQ_COMMON" );
}

include_buildables()
{
    springpad_door = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_door", 32, 64, 0, "zom_hud_trample_steam_screen", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_02", undefined, 1 );
    springpad_flag = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_bellows", 48, 15, 0, "zom_hud_trample_steam_bellow", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_04", undefined, 2 );
    springpad_motor = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_compressor", 48, 15, 0, "zom_hud_trample_steam_compressor", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_01", undefined, 3 );
    springpad_whistle = generate_zombie_buildable_piece( "springpad_zm", "p6_zm_buildable_tramplesteam_flag", 48, 15, 0, "zom_hud_trample_steam_whistle", ::onpickup_common, ::ondrop_common, undefined, "Tag_part_03", undefined, 4 );
    springpad = spawnstruct();
    springpad.name = "springpad_zm";
    springpad add_buildable_piece( springpad_door );
    springpad add_buildable_piece( springpad_flag );
    springpad add_buildable_piece( springpad_motor );
    springpad add_buildable_piece( springpad_whistle );
    springpad.triggerthink = ::springpadbuildable;
    include_buildable( springpad );
    slipgun_canister = generate_zombie_buildable_piece( "slipgun_zm", "t6_zmb_buildable_slipgun_extinguisher", 32, 64, 0, "zom_hud_icon_buildable_slip_ext", ::onpickup_common, ::ondrop_common, undefined, "TAG_CO2", undefined, 5 );
    slipgun_cooker = generate_zombie_buildable_piece( "slipgun_zm", "t6_zmb_buildable_slipgun_cooker", 48, 15, 0, "zom_hud_icon_buildable_slip_cooker", ::onpickup_common, ::ondrop_common, undefined, "TAG_COOKER", undefined, 6 );
    slipgun_foot = generate_zombie_buildable_piece( "slipgun_zm", "t6_zmb_buildable_slipgun_foot", 48, 15, 0, "zom_hud_icon_buildable_slip_foot", ::onpickup_common, ::ondrop_common, undefined, "TAG_FOOT", undefined, 7 );
    slipgun_throttle = generate_zombie_buildable_piece( "slipgun_zm", "t6_zmb_buildable_slipgun_throttle", 48, 15, 0, "zom_hud_icon_buildable_slip_handle", ::onpickup_common, ::ondrop_common, undefined, "TAG_THROTTLE", undefined, 8 );
    slipgun = spawnstruct();
    slipgun.name = "slipgun_zm";
    slipgun add_buildable_piece( slipgun_canister );
    slipgun add_buildable_piece( slipgun_cooker );
    slipgun add_buildable_piece( slipgun_foot );
    slipgun add_buildable_piece( slipgun_throttle );
    slipgun.onbuyweapon = ::onbuyweapon_slipgun;
    slipgun.triggerthink = ::slipgunbuildable;
    slipgun.onuseplantobject = ::onuseplantobject_slipgun;
    include_buildable( slipgun );

    if ( !isdefined( level.gamedifficulty ) || level.gamedifficulty != 0 )
    {
        sq_common_electricbox = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_electric_box", 32, 64, 0, "zm_hud_icon_sq_powerbox", ::onpickup_common, ::ondrop_common, undefined, "tag_part_02", undefined, 10 );
        sq_common_meteor = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_meteor", 32, 64, 0, "zm_hud_icon_sq_meteor", ::onpickup_common, ::ondrop_common, undefined, "tag_part_04", undefined, 11 );
        sq_common_scaffolding = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_scaffolding", 64, 96, 0, "zm_hud_icon_sq_scafold", ::onpickup_common, ::ondrop_common, undefined, "tag_part_01", undefined, 12 );
        sq_common_transceiver = generate_zombie_buildable_piece( "sq_common", "p6_zm_buildable_sq_transceiver", 64, 96, 0, "zm_hud_icon_sq_tranceiver", ::onpickup_common, ::ondrop_common, undefined, "tag_part_03", undefined, 13 );
        sqcommon = spawnstruct();
        sqcommon.name = "sq_common";
        sqcommon add_buildable_piece( sq_common_electricbox );
        sqcommon add_buildable_piece( sq_common_meteor );
        sqcommon add_buildable_piece( sq_common_scaffolding );
        sqcommon add_buildable_piece( sq_common_transceiver );
        sqcommon.triggerthink = ::sqcommonbuildable;
        include_buildable( sqcommon );
        maps\mp\zombies\_zm_buildables::hide_buildable_table_model( "sq_common_buildable_trigger" );
    }
}