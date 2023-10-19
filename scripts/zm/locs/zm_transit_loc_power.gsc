#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_zonemgr;

#include scripts\zm\replaced\utility;
#include scripts\zm\locs\loc_common;

struct_init()
{
    scripts\zm\replaced\utility::register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 10952, 8055, -565 ), ( 0, 270, 0 ) );
    scripts\zm\replaced\utility::register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( 11855, 7308, -758 ), ( 0, 220, 0 ) );
	scripts\zm\replaced\utility::register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( 11571, 7723, -757 ), ( 0, 0, 0 ) );
    scripts\zm\replaced\utility::register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( 11414, 8930, -352 ), ( 0, 0, 0 ) );
    scripts\zm\replaced\utility::register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 10946, 8308.77, -408 ), ( 0, 270, 0 ) );
    scripts\zm\replaced\utility::register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 12333, 8158, -752 ), ( 0, 180, 0 ) );

	zone = "zone_pow";
    scripts\zm\replaced\utility::register_map_spawn( (10160, 8060, -554), (0, 0, 0), zone, 1 );
	scripts\zm\replaced\utility::register_map_spawn( (10160, 7996, -554), (0, 0, 0), zone, 1 );
	scripts\zm\replaced\utility::register_map_spawn( (10160, 7932, -554), (0, 0, 0), zone, 1 );
	scripts\zm\replaced\utility::register_map_spawn( (10160, 7868, -554), (0, 0, 0), zone, 1 );
	scripts\zm\replaced\utility::register_map_spawn( (10160, 7772, -554), (0, 0, 0), zone, 2 );
	scripts\zm\replaced\utility::register_map_spawn( (10160, 7708, -554), (0, 0, 0), zone, 2 );
	scripts\zm\replaced\utility::register_map_spawn( (10160, 7644, -554), (0, 0, 0), zone, 2 );
	scripts\zm\replaced\utility::register_map_spawn( (10160, 7580, -554), (0, 0, 0), zone, 2 );
}

precache()
{

}

main()
{
    treasure_chest_init();
	init_wallbuys();
	init_barriers();
    show_powerswitch();
	activate_core();
	generatebuildabletarps();
    disable_zombie_spawn_locations();
	scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
    chests = getstructarray( "treasure_chest_use", "targetname" );
	level.chests = [];
	level.chests[0] = chests[2];
    maps\mp\zombies\_zm_magicbox::treasure_chest_init( "pow_chest" );
}

init_wallbuys()
{
	scripts\zm\replaced\utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", ( 10559, 8220, -495 ), ( 0, 90, 0) );
	scripts\zm\replaced\utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", ( 10678, 8135, -476 ), ( 0, 180, 0 ) );
	scripts\zm\replaced\utility::wallbuy( "870mcs_zm", "870mcs", "weapon_upgrade", ( 11778, 7664, -697 ), ( 0, 170, 0 ) );
	scripts\zm\replaced\utility::wallbuy( "mp5k_zm", "mp5", "weapon_upgrade", ( 11452, 8692, -521 ), ( 0, 90, 0 ) );
	scripts\zm\replaced\utility::wallbuy( "bowie_knife_zm", "bowie_knife", "bowie_upgrade", ( 10835, 8145, -353 ), ( 0, 0, 0 ) );
}

init_barriers()
{
	// fog before power station
	origin = ( 10215, 7265, -570 );
	angles = ( 0, 0, 0 );
	scripts\zm\replaced\utility::barrier( "collision_player_wall_512x512x10", origin + (anglesToUp(angles) * 256), angles );
	scripts\zm\replaced\utility::barrier( "veh_t6_civ_microbus_dead", origin + (anglesToForward(angles) * 96) + (anglesToRight(angles) * 48), angles );
	scripts\zm\replaced\utility::barrier( "veh_t6_civ_60s_coupe_dead", origin + (anglesToForward(angles) * -112) + (anglesToRight(angles) * 80), angles + (0, 30, 0) );

	// fog after power station
	origin = ( 10215, 8670, -579 );
	angles = ( 0, 7.5, 0 );
	scripts\zm\replaced\utility::barrier( "collision_player_wall_512x512x10", origin + (anglesToForward(angles) * -128) + (anglesToUp(angles) * 256), angles );
	scripts\zm\replaced\utility::barrier( "collision_player_wall_512x512x10", origin + (anglesToForward(angles) * 64) + (anglesToUp(angles) * 256), angles );
	scripts\zm\replaced\utility::barrier( "p6_zm_rocks_large_cluster_01", origin + (anglesToForward(angles) * -176) + (anglesToRight(angles) * -368) + (anglesToUp(angles) * 256), angles + (0, -15, 0) );
}

show_powerswitch()
{
    body = spawn( "script_model", ( 12237.4, 8512, -749.9 ) );
    body.angles = ( 0, 0, 0 );
	body setModel( "p6_zm_buildable_pswitch_body" );

    lever = spawn( "script_model", ( 12237.4, 8503, -703.65 ) );
    lever.angles = ( 0, 0, 0 );
	lever setModel( "p6_zm_buildable_pswitch_lever" );

    hand = spawn( "script_model", ( 12237.7, 8503.1, -684.55 ) );
    hand.angles = ( 0, 270, 0 );
	hand setModel( "p6_zm_buildable_pswitch_hand" );
}

activate_core()
{
	reactor_core_mover = getent( "core_mover", "targetname" );

	maps\mp\zm_transit_power::linkentitiestocoremover( reactor_core_mover );

	reactor_core_mover thread maps\mp\zm_transit_power::coremove( 0.05 );
}

generatebuildabletarps()
{
	// trap
	tarp = spawn( "script_model", ( 11325, 8170, -488 ) );
    tarp.angles = ( 0, 0, 0 );
	tarp setModel( "p6_zm_buildable_bench_tarp" );
}

disable_zombie_spawn_locations()
{
    level.zones["zone_trans_8"].is_spawning_allowed = 0;
}