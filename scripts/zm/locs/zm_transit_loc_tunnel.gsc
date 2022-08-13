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

    scripts/zm/replaced/utility::register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( -11541, -2630, 194 ), ( 0, -180, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( -10780, -2565, 224 ), ( 0, 270, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( -11373, -1674, 192 ), ( 0, -89, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( -11170, -590, 196 ), ( 0, -10, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_longersprint", "zombie_vending_marathon", ( -11681, -734, 228 ),  ( 0, -19, 0 ) );
    scripts/zm/replaced/utility::register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( -11301, -2096, 184 ), ( 0, 115, 0 ) );

    ind = 0;
    respawnpoints = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
    for(i = 0; i < respawnpoints.size; i++)
    {
        if(respawnpoints[i].script_noteworthy == "zone_amb_tunnel")
        {
            ind = i;
            break;
        }
    }

    respawn_array = getstructarray(respawnpoints[ind].target, "targetname");
    foreach(respawn in respawn_array)
    {
        // if(respawn.script_int == 2)
        // {
        //     respawn.angles += (0, 180, 0);
        // }

        scripts/zm/replaced/utility::register_map_initial_spawnpoint( respawn.origin, respawn.angles, respawn.script_int );
    }
}

precache()
{

}

main()
{
	init_wallbuys();
	init_barriers();
    thread disable_zombie_spawn_locations();
	scripts/zm/locs/loc_common::init();
}

init_wallbuys()
{
	scripts/zm/replaced/utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", ( -11166, -2844, 247 ), ( 0, -86, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", ( -10787, -1430, 247 ), ( 0, 88, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "mp5k_zm", "mp5", "weapon_upgrade", ( -10656, -752, 247 ), ( 0, 83, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "m16_zm", "m16", "weapon_upgrade", ( -11839, -1695.1, 287 ), ( 0, 270, 0 ) );
    scripts/zm/replaced/utility::wallbuy( "sticky_grenade_zm", "sticky_grenade", "weapon_upgrade", ( -11839, -2406, 283 ), ( 0, -93, 0 ) );
}

init_barriers()
{
    origin = ( -11270, -500, 255 );
	angles = ( 0, 195, 0 );
    scripts/zm/replaced/utility::barrier( "collision_player_wall_512x512x10", origin + (anglesToRight(angles) * -25) + (anglesToForward(angles) * 150), angles );
    scripts/zm/replaced/utility::barrier( "veh_t6_civ_60s_coupe_dead", origin + (anglesToUp(angles) * -63) + (anglesToForward(angles) * 125) + (anglesToRight(angles) * 25), angles );
    scripts/zm/replaced/utility::barrier( "veh_t6_civ_smallwagon_dead", origin + (anglesToUp(angles) * -63) + (anglesToForward(angles) * -30) + (anglesToRight(angles) * 50), angles + (0, -90, 0) );

    origin = ( -10750, -3275, 255 );
	angles = ( 0, 195, 0 );
    scripts/zm/replaced/utility::barrier( "collision_player_wall_512x512x10", origin + (anglesToRight(angles) * 55), angles );
	scripts/zm/replaced/utility::barrier( "veh_t6_civ_movingtrk_cab_dead", origin, angles );
}

disable_zombie_spawn_locations()
{
    wait 10;
    player = get_players()[0];
    player notify( "stop_player_out_of_playable_area_monitor" );

	for ( z = 0; z < level.zone_keys.size; z++ )
	{
		zone = level.zones[ level.zone_keys[ z ] ];
        if(zone == "zone_amb_tunnel")
        {
            i = 0;
            while ( i < zone.spawn_locations.size )
            {
                if ( zone.spawn_locations[ i ].origin == ( -11447, -3424, 254.2 ) )
                {
                    zone.spawn_locations[ i ].is_enabled = false;
                }
                else if ( zone.spawn_locations[ i ].origin == ( -11093, 393, 192 ) )
                {
                    zone.spawn_locations[ i ].is_enabled = false;
                }
                else if ( zone.spawn_locations[ i ].origin == ( -10944, -3846, 221.14 ) )
                {
                    zone.spawn_locations[ i ].is_enabled = false;
                }
                else if ( zone.spawn_locations[ i ].origin == ( -10836, 1195, 209.7 ) )
                {
                    zone.spawn_locations[ i ].is_enabled = false;
                }
                else if ( zone.spawn_locations[ i ].origin == ( -11251, -4397, 200.02 ) )
                {
                    zone.spawn_locations[ i ].is_enabled = false;
                }
                else if ( zone.spawn_locations[ i ].origin == ( -11334, -5280, 212.7 ) )
                {
                    zone.spawn_locations[ i ].is_enabled = false;
                }
                else if ( zone.spawn_locations[ i ].origin == ( -11347, -3134, 283.9 ) )
                {
                    zone.spawn_locations[ i ].is_enabled = false;
                }

                i++;
            }
        }
	}
}

manage_zones( initial_zone )
{
    initial_zone = [];
    initial_zone[0] = "zone_amb_tunnel";

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