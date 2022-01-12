#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm;

#include scripts/zm/replaced/utility;
#include scripts/zm/locs/common;

struct_init()
{
	if ( !is_true( level.ctsm_disable_custom_perk_locations ) )
	{
		scripts/zm/replaced/utility::register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( -3563, -7196, -59 ), ( 0, 0, 0 ) );
        scripts/zm/replaced/utility::register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( -6207, -6544, -46 ), ( 0, 60, 0 ) );
        scripts/zm/replaced/utility::register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( -5470, -7859.5, 0 ), ( 0, 270, 0 ) );
		scripts/zm/replaced/utility::register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( -4170, -7592, -63 ), ( 0, 270, 0 ) );
	}
	coordinates = array( ( -3991, -7317, -63 ), ( -4231, -7395, -60 ), ( -4127, -6757, -54 ), ( -4465, -7346, -58 ),
						 ( -5770, -6600, -55 ), ( -6135, -6671, -56 ), ( -6182, -7120, -60 ), ( -5882, -7174, -61 ) );
	angles = array( ( 0, 161, 0 ), ( 0, 120, 0 ), ( 0, 217, 0 ), ( 0, 173, 0 ), ( 0, -106, 0 ), ( 0, -46, 0 ), ( 0, 51, 0 ), ( 0, 99, 0 ) );
	for ( i = 0; i < coordinates.size; i++ )
	{
		scripts/zm/replaced/utility::register_map_initial_spawnpoint( coordinates[ i ], angles[ i ] );
	}
	gameObjects = getEntArray( "script_model", "classname" );
	foreach ( object in gameObjects )
	{
		if ( object.script_gameobjectname == "zcleansed zturned" )
		{
			object.script_gameobjectname = "zstandard zgrief zcleansed zturned";
		}
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
    disable_zombie_spawn_locations();
	scripts/zm/locs/common::common_init();
}

treasure_chest_init()
{
    chests = getstructarray( "treasure_chest_use", "targetname" );
	level.chests = [];
	level.chests[0] = chests[3];
    maps/mp/zombies/_zm_magicbox::treasure_chest_init( "start_chest" );
}

init_wallbuys()
{
	scripts/zm/replaced/utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", ( -5085, -7807, -5 ), ( 0, 0, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", ( -4576, -7748, 18 ), ( 0, 90, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "mp5k_zm", "mp5", "weapon_upgrade", ( -5489, -7982.7, 62 ), ( 0, 1, 0 ) );
}

init_barriers()
{
	precacheModel( "zm_collision_transit_diner_survival" );
	collision = spawn( "script_model", ( -5000, -6700, 0 ), 1 );
	collision setmodel( "zm_collision_transit_diner_survival" );
	collision disconnectpaths();
}

disable_zombie_spawn_locations()
{
	for ( z = 0; z < level.zone_keys.size; z++ )
	{
		zone = level.zones[ level.zone_keys[ z ] ];

        i = 0;
        while ( i < zone.spawn_locations.size )
        {
            if ( zone.spawn_locations[ i ].targetname == "zone_trans_diner_spawners")
            {
                zone.spawn_locations[ i ].is_enabled = false;
            }
            else if ( zone.spawn_locations[ i ].targetname == "zone_trans_diner2_spawners")
            {
                zone.spawn_locations[ i ].is_enabled = false;
            }
            else if ( zone.spawn_locations[ i ].origin == ( -3825, -6576, -52.7 ) )
            {
                zone.spawn_locations[ i ].is_enabled = false;
            }
            else if ( zone.spawn_locations[ i ].origin == ( -5130, -6512, -35.4 ) )
            {
                zone.spawn_locations[ i ].is_enabled = false;
            }
            else if ( zone.spawn_locations[ i ].origin == ( -6462, -7159, -64 ) )
            {
                zone.spawn_locations[ i ].is_enabled = false;
            }
            else if ( zone.spawn_locations[ i ].origin == ( -6531, -6613, -54.4 ) )
            {
                zone.spawn_locations[ i ].is_enabled = false;
            }

            i++;
		}
	}
}