#include maps/mp/_utility;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;

common_init()
{
	level.create_spawner_list_func = ::create_spawner_list;
	level.enemy_location_override_func = ::enemy_location_override;
	flag_wait( "initial_blackscreen_passed" );
	maps/mp/zombies/_zm_game_module::turn_power_on_and_open_doors();
	flag_wait( "start_zombie_round_logic" );
	wait 1;
	level notify( "revive_on" );
	wait_network_frame();
	level notify( "doubletap_on" );
	wait_network_frame();
	level notify( "marathon_on" );
	wait_network_frame();
	level notify( "juggernog_on" );
	wait_network_frame();
	level notify( "sleight_on" );
	wait_network_frame();
	level notify( "tombstone_on" );
	wait_network_frame();
	level notify( "Pack_A_Punch_on" );
}

enemy_location_override( zombie, enemy )
{
	location = enemy.origin;
	if ( is_true( self.reroute ) )
	{
		if ( isDefined( self.reroute_origin ) )
		{
			location = self.reroute_origin;
		}
	}
	return location;
}

create_spawner_list( zkeys )
{
	level.zombie_spawn_locations = [];
	level.inert_locations = [];
	level.enemy_dog_locations = [];
	level.zombie_screecher_locations = [];
	level.zombie_avogadro_locations = [];
	level.quad_locations = [];
	level.zombie_leaper_locations = [];
	level.zombie_astro_locations = [];
	level.zombie_brutus_locations = [];
	level.zombie_mechz_locations = [];
	level.zombie_napalm_locations = [];
	for ( z = 0; z < zkeys.size; z++ )
	{
		zone = level.zones[ zkeys[ z ] ];
		if ( zone.is_enabled && zone.is_active && zone.is_spawning_allowed )
		{
			i = 0;
			while ( i < zone.spawn_locations.size )
			{
				if ( !is_true( zone.spawn_locations[ i ].checked ) )
				{
					if ( zone.spawn_locations[ i ].origin == ( 8394, -2545, -205.16 ) )
					{
						zone.spawn_locations[ i ].is_enabled = false;
					}
					else if ( zone.spawn_locations[ i ].origin == ( 10705, 7347, -576 ) )
					{
						zone.spawn_locations[ i ].is_enabled = false;
					}
					else if ( zone.spawn_locations[ i ].origin == ( 10015, 6931, -571.7 ) )
					{
						zone.spawn_locations[ i ].origin = ( 10249.4, 7691.71, -569.875 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( 9339, 6411, -566.9 ) )
					{
						zone.spawn_locations[ i ].origin = ( 9993.29, 7486.83, -582.875 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( 9914, 8408, -576 ) )
					{
						zone.spawn_locations[ i ].origin = ( 9993.29, 7550, -582.875 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( 9429, 5281, -539.6 ) )
					{
						zone.spawn_locations[ i ].is_enabled = false;
					}
					else if ( zone.spawn_locations[ i ].origin == ( 10015, 6931, -571.7 ) )
					{
						zone.spawn_locations[ i ].is_enabled = false;
					}
					else if ( zone.spawn_locations[ i ].origin == ( 13019.1, 7382.5, -754 ) )
					{
						zone.spawn_locations[ i ].is_enabled = false;
					}
					else if ( zone.spawn_locations[ i ].origin == ( -3825, -6576, -52.7 ) )
					{
						zone.spawn_locations[ i ].origin = ( -4061.03, -6754.44, -58.0897 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -3450, -6559, -51.9 ) )
					{
						zone.spawn_locations[ i ].origin = ( -4060.93, -6968.64, -65.3446 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -4165, -6098, -64 ) )
					{
						zone.spawn_locations[ i ].origin = ( -4239.78, -6902.81, -57.0494 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -5058, -5902, -73.4 ) )
					{
						zone.spawn_locations[ i ].origin = ( -4846.77, -6906.38, 54.8145 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -6462, -7159, -64 ) )
					{
						zone.spawn_locations[ i ].origin = ( -6201.18, -7107.83, -59.7182 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -5130, -6512, -35.4 ) )
					{
						zone.spawn_locations[ i ].origin = ( -5396.36, -6801.88, -60.0821 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -6531, -6613, -54.4 ) )
					{
						zone.spawn_locations[ i ].origin = ( -6116.62, -6586.81, -50.8905 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -5373, -6231, -51.9 ) )
					{
						zone.spawn_locations[ i ].origin = ( -4827.92, -7137.19, -62.9082 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -5752, -6230, -53.4 ) )
					{
						zone.spawn_locations[ i ].origin = ( -5572.47, -6426, -39.1894 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -5540, -6508, -42 ) )
					{
						zone.spawn_locations[ i ].origin = ( -5789.51, -6935.81, -57.875 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -11093 , 393 , 192 ) )
					{
						zone.spawn_locations[ i ].origin = ( -11431.3, -644.496, 192.125 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -10944, -3846, 221.14 ) )
					{
						zone.spawn_locations[ i ].origin = ( -11351.7, -1988.58, 184.125 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -11251, -4397, 200.02 ) )
					{
						zone.spawn_locations[ i ].origin = ( -11431.3, -644.496, 192.125 );
					}
					else if ( zone.spawn_locations[ i ].origin == ( -11334 , -5280, 212.7 ) )
					{
						zone.spawn_locations[ i ].origin = ( -11600.6, -1918.41, 192.125 );
						zone.spawn_locations[ i ].script_noteworthy = "riser_location";
					}
					else if (zone.spawn_locations[ i ].origin == ( -10836, 1195, 209.7 ) )
					{
						zone.spawn_locations[ i ].origin = ( -11241.2, -1118.76, 184.125 );
					}
					else if ( zone.spawn_locations[ i ].targetname == "zone_trans_diner_spawners")
					{
						zone.spawn_locations[ i ].is_enabled = false;
					}
					else
					{
						zone.spawn_locations[ i ].is_enabled = true;
					}
					zone.spawn_locations[ i ].checked = true;
				}
				if ( !is_true( zone.spawn_locations[ i ].is_enabled ) )
				{
					i++;
					continue;
				}
				level.zombie_spawn_locations[ level.zombie_spawn_locations.size ] = zone.spawn_locations[ i ];
				i++;
			}
		}
	}
}