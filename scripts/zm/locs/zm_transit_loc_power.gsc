#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_zonemgr;

#include scripts/zm/replaced/utility;
#include scripts/zm/locs/loc_common;

struct_init()
{
    replaceFunc(maps/mp/zombies/_zm_zonemgr::manage_zones, ::manage_zones);

    scripts/zm/replaced/utility::register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 10746, 7282, -557 ), ( 0, -132, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( 10946, 8308.77, -408 ), ( 0, 270, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( 11568, 7723, -755 ), ( 0, -1, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( 11402, 8159, -487 ), ( 0, 180, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 11156, 8120, -575 ), ( 0, -4, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 12625, 7434, -755 ), ( 0, 162, 0 ) );

    ind = 0;
    respawnpoints = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
    for(i = 0; i < respawnpoints.size; i++)
    {
        if(respawnpoints[i].script_noteworthy == "zone_pow")
        {
            ind = i;
            break;
        }
    }

    respawn_array = getstructarray(respawnpoints[ind].target, "targetname");
    foreach(respawn in respawn_array)
    {
        scripts/zm/replaced/utility::register_map_initial_spawnpoint( respawn.origin, respawn.angles, respawn.script_int );
    }
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
	generatebuildabletarps();
    disable_zombie_spawn_locations();
    level thread maps/mp/zm_transit::falling_death_init();
	scripts/zm/locs/loc_common::init();
}

treasure_chest_init()
{
    chests = getstructarray( "treasure_chest_use", "targetname" );
	level.chests = [];
	level.chests[0] = chests[2];
    maps/mp/zombies/_zm_magicbox::treasure_chest_init( "pow_chest" );
}

init_wallbuys()
{
	scripts/zm/replaced/utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", ( 10559, 8226, -504 ), ( 0, 90, 0) );
    scripts/zm/replaced/utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", ( 11769, 7662, -701 ), ( 0, 170, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "m16_zm", "m16", "weapon_upgrade", ( 10859, 8146, -353 ), ( 0, 0, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "mp5k_zm", "mp5", "weapon_upgrade", ( 11452, 8692, -521 ), ( 0, 90, 0 ) );
}

init_barriers()
{
	scripts/zm/replaced/utility::barrier( "veh_t6_civ_60s_coupe_dead", ( 9965, 8133, -556 ), ( 15, 5, 0 ) );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_256x256x10", ( 9955, 8105, -575 ), ( 0, 0, 0 ) );
	scripts/zm/replaced/utility::barrier( "veh_t6_civ_bus_zombie", ( 10056, 8350, -584 ), ( 0, 340, 0 ), 1 );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_256x256x10", ( 10267, 8194, -556 ), ( 0, 340, 0 ) );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_512x512x10", ( 10409, 8220, -181 ), ( 0, 250, 0 ) );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_128x128x10", ( 10409, 8220, -556 ), ( 0, 250, 0 ) );
	scripts/zm/replaced/utility::barrier( "veh_t6_civ_microbus_dead", ( 10281, 7257, -575 ), ( 0, 13, 0 ) );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_256x256x10", ( 10268, 7294, -569 ), ( 0, 13, 0 ) );
	scripts/zm/replaced/utility::barrier( "veh_t6_civ_60s_coupe_dead", ( 10100, 7238, -575 ), ( 0, 52, 0 ) );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_128x128x10", ( 10170, 7292, -505 ), ( 0, 140, 0 ) );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_256x256x10", ( 10030, 7216, -569 ), ( 0, 49, 0 ) );
	scripts/zm/replaced/utility::barrier( "collision_player_wall_256x256x10", ( 10563, 8630, -344 ), ( 0, 270, 0 ) );
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

generatebuildabletarps()
{
	// power switch
    tarp = spawn( "script_model", ( 12169, 8498, -752 ) );
    tarp.angles = ( 0, 180, 0 );
	tarp setModel( "p6_zm_buildable_bench_tarp" );

	// trap
	tarp = spawn( "script_model", ( 11325, 8170, -488 ) );
    tarp.angles = ( 0, 0, 0 );
	tarp setModel( "p6_zm_buildable_bench_tarp" );
}

disable_zombie_spawn_locations()
{
    level.zones["zone_trans_8"].is_spawning_allowed = 0;
}

transit_power_zone_init()
{
    flag_init( "always_on" );
	flag_set( "always_on" );

    add_adjacent_zone("zone_pow", "zone_trans_8", "always_on");
    add_adjacent_zone( "zone_pow", "zone_pow_warehouse", "always_on" );
    add_adjacent_zone( "zone_trans_8", "zone_pow_warehouse", "always_on" );
    add_adjacent_zone( "zone_prr", "zone_pow", "OnPowDoorRR", 1 );
    add_adjacent_zone( "zone_pcr", "zone_prr", "OnPowDoorRR" );
	add_adjacent_zone( "zone_pcr", "zone_pow_warehouse", "OnPowDoorWH" );
}

manage_zones( initial_zone )
{
    level.zone_manager_init_func = ::transit_power_zone_init;
    initial_zone = [];
    initial_zone[0] = "zone_pow";
    initial_zone[1] = "zone_trans_8";

	deactivate_initial_barrier_goals();
	zone_choke = 0;
	spawn_points = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
	for ( i = 0; i < spawn_points.size; i++ )
	{
		spawn_points[ i ].locked = 1;
	}
	if ( isDefined( level.zone_manager_init_func ) )
	{
		[[ level.zone_manager_init_func ]]();
	}

	if ( isarray( initial_zone ) )
	{
		for ( i = 0; i < initial_zone.size; i++ )
		{
			zone_init( initial_zone[ i ] );
			enable_zone( initial_zone[ i ] );
		}
	}
	else
	{
		zone_init( initial_zone );
		enable_zone( initial_zone );
	}
	setup_zone_flag_waits();
	zkeys = getarraykeys( level.zones );
	level.zone_keys = zkeys;
	level.newzones = [];
	for ( z = 0; z < zkeys.size; z++ )
	{
		level.newzones[ zkeys[ z ] ] = spawnstruct();
	}
	oldzone = undefined;
	flag_set( "zones_initialized" );
	flag_wait( "begin_spawning" );
	while ( getDvarInt( "noclip" ) == 0 || getDvarInt( "notarget" ) != 0 )
	{
		for( z = 0; z < zkeys.size; z++ )
		{
			level.newzones[ zkeys[ z ] ].is_active = 0;
			level.newzones[ zkeys[ z ] ].is_occupied = 0;
		}
		a_zone_is_active = 0;
		a_zone_is_spawning_allowed = 0;
		level.zone_scanning_active = 1;
		z = 0;
		while ( z < zkeys.size )
		{
			zone = level.zones[ zkeys[ z ] ];
			newzone = level.newzones[ zkeys[ z ] ];
			if( !zone.is_enabled )
			{
				z++;
				continue;
			}
			if ( isdefined(level.zone_occupied_func ) )
			{
				newzone.is_occupied = [[ level.zone_occupied_func ]]( zkeys[ z ] );
			}
			else
			{
				newzone.is_occupied = player_in_zone( zkeys[ z ] );
			}
			if ( newzone.is_occupied )
			{
				newzone.is_active = 1;
				a_zone_is_active = 1;
				if ( zone.is_spawning_allowed )
				{
					a_zone_is_spawning_allowed = 1;
				}
				if ( !isdefined(oldzone) || oldzone != newzone )
				{
					level notify( "newzoneActive", zkeys[ z ] );
					oldzone = newzone;
				}
				azkeys = getarraykeys( zone.adjacent_zones );
				for ( az = 0; az < zone.adjacent_zones.size; az++ )
				{
					if ( zone.adjacent_zones[ azkeys[ az ] ].is_connected && level.zones[ azkeys[ az ] ].is_enabled )
					{
						level.newzones[ azkeys[ az ] ].is_active = 1;
						if ( level.zones[ azkeys[ az ] ].is_spawning_allowed )
						{
							a_zone_is_spawning_allowed = 1;
						}
					}
				}
			}
			zone_choke++;
			if ( zone_choke >= 3 )
			{
				zone_choke = 0;
				wait 0.05;
			}
			z++;
		}
		level.zone_scanning_active = 0;
		for ( z = 0; z < zkeys.size; z++ )
		{
			level.zones[ zkeys[ z ] ].is_active = level.newzones[ zkeys[ z ] ].is_active;
			level.zones[ zkeys[ z ] ].is_occupied = level.newzones[ zkeys[ z ] ].is_occupied;
		}
		if ( !a_zone_is_active || !a_zone_is_spawning_allowed )
		{
			if ( isarray( initial_zone ) )
			{
				level.zones[ initial_zone[ 0 ] ].is_active = 1;
				level.zones[ initial_zone[ 0 ] ].is_occupied = 1;
				level.zones[ initial_zone[ 0 ] ].is_spawning_allowed = 1;
			}
			else
			{
				level.zones[ initial_zone ].is_active = 1;
				level.zones[ initial_zone ].is_occupied = 1;
				level.zones[ initial_zone ].is_spawning_allowed = 1;
			}
		}
		[[ level.create_spawner_list_func ]]( zkeys );
		level.active_zone_names = maps/mp/zombies/_zm_zonemgr::get_active_zone_names();
		wait 1;
	}
}