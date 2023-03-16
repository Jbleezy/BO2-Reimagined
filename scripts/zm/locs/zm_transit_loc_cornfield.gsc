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
    scripts\zm\replaced\utility::register_perk_struct( "", "", ( 0, 0, 0 ), ( 0, 0, 0 ) ); // need this for pap to work
    scripts\zm\replaced\utility::register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 10460, -564, -220 ), ( 0, -35, 0 ) );

    ind = 0;
    respawnpoints = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();
    for(i = 0; i < respawnpoints.size; i++)
    {
        if(respawnpoints[i].script_noteworthy == "zone_amb_cornfield")
        {
            ind = i;
            break;
        }
    }

	level.struct_class_names["script_noteworthy"]["initial_spawn"] = [];

    respawn_array = getstructarray(respawnpoints[ind].target, "targetname");
    foreach(respawn in respawn_array)
    {
		origin = respawn.origin + (anglesToRight(respawn.angles) * 32);
		angles = respawn.angles;
		script_int = 1;

        scripts\zm\replaced\utility::register_map_initial_spawnpoint( origin, angles, script_int );

		origin = respawn.origin + (anglesToRight(respawn.angles) * -32);
		angles = respawn.angles;
		script_int = 2;

        scripts\zm\replaced\utility::register_map_initial_spawnpoint( origin, angles, script_int );
    }

    structs = getstructarray( "game_mode_object", "targetname" );
	foreach ( struct in structs )
	{
		if ( isDefined( struct.script_noteworthy ) && struct.script_noteworthy == "cornfield" )
		{
			struct.script_string = "zstandard zgrief";
		}
	}

    intermission_cam = spawnStruct();
    intermission_cam.origin = (10266, 470, -90);
    intermission_cam.angles = (0, -90, 0);
    intermission_cam.targetname = "intermission";
    intermission_cam.script_string = "cornfield";
    intermission_cam.speed = 30;
    intermission_cam.target = "intermission_cornfield_end";
    scripts\zm\replaced\utility::add_struct(intermission_cam);

    intermission_cam_end = spawnStruct();
    intermission_cam_end.origin = (10216, -1224, -199);
    intermission_cam_end.angles = (0, -90, 0);
    intermission_cam_end.targetname = "intermission_cornfield_end";
    scripts\zm\replaced\utility::add_struct(intermission_cam_end);
}

precache()
{
    start_chest_zbarrier = getEnt( "start_chest_zbarrier", "script_noteworthy" );
	start_chest_zbarrier.origin = ( 13487, 33, -182 );
	start_chest_zbarrier.angles = ( 0, 90, 0 );
	start_chest = spawnStruct();
	start_chest.origin = start_chest_zbarrier.origin;
	start_chest.angles = start_chest_zbarrier.angles;
	start_chest.script_noteworthy = "start_chest";
	start_chest.zombie_cost = 950;
	collision = spawn( "script_model", start_chest_zbarrier.origin, 1 );
	collision.angles = start_chest_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
    collision disconnectpaths();
	collision = spawn( "script_model", start_chest_zbarrier.origin - ( 0, 32, 0 ), 1 );
	collision.angles = start_chest_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
    collision disconnectpaths();
	collision = spawn( "script_model", start_chest_zbarrier.origin + ( 0, 32, 0 ), 1 );
	collision.angles = start_chest_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
    collision disconnectpaths();

	start_chest2_zbarrier = getEnt( "depot_chest_zbarrier", "script_noteworthy" );
	start_chest2_zbarrier.origin = ( 7458, -464, -197 );
	start_chest2_zbarrier.angles = ( 0, -90, 0 );
	start_chest2 = spawnStruct();
	start_chest2.origin = start_chest2_zbarrier.origin;
	start_chest2.angles = start_chest2_zbarrier.angles;
	start_chest2.script_noteworthy = "depot_chest";
	start_chest2.zombie_cost = 950;
	collision = spawn( "script_model", start_chest2_zbarrier.origin, 1 );
	collision.angles = start_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
    collision disconnectpaths();
	collision = spawn( "script_model", start_chest2_zbarrier.origin - ( 0, 32, 0 ), 1 );
	collision.angles = start_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
    collision disconnectpaths();
	collision = spawn( "script_model", start_chest2_zbarrier.origin + ( 0, 32, 0 ), 1 );
	collision.angles = start_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
    collision disconnectpaths();

	level.chests = [];
	level.chests[0] = start_chest;
	level.chests[1] = start_chest2;
}

main()
{
	init_wallbuys();
	init_barriers();
    setup_standard_objects("cornfield");
    maps\mp\zombies\_zm_magicbox::treasure_chest_init( random( array( "start_chest", "depot_chest" ) ) );
    thread disable_zombie_spawn_locations();
	scripts\zm\locs\loc_common::init();
}

init_wallbuys()
{
	scripts\zm\replaced\utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", ( 13663, -1166, -134 ), ( 0, -90, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", ( 13554, -539, -133 ), ( 0, -90, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "beretta93r_zm", "beretta93r", "weapon_upgrade", ( 13793, -1644, -105 ), ( 0, 0, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "mp5k_zm", "mp5", "weapon_upgrade", ( 13554, -769, -133 ), ( 0, -90, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "ak74u_zm", "ak74u", "weapon_upgrade", ( 13978, -1550, -134 ), ( 0, 90, 0 ) );
	scripts\zm\replaced\utility::wallbuy( "m16_zm", "m16", "weapon_upgrade", ( 14092, -351, -133 ), ( 0, 90, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "870mcs_zm", "870mcs", "weapon_upgrade", ( 13554, -1387, -134 ), ( 0, -90, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "sticky_grenade_zm", "sticky_grenade", "weapon_upgrade", ( 13603, -1079, -134 ), ( 0, 0, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "claymore_zm", "claymore", "claymore_purchase", ( 13603, -1282, -134 ), ( 0, -180, 0 ) );
}

init_barriers()
{
    model = spawn( "script_model", (10176.5, -14.8391, -221.988), 1);
    model.angles = (0, 35, 0);
    model setmodel("collision_clip_wall_256x256x10");
    model disconnectpaths();

    model = spawn( "script_model", (10002.6, -95.4607, -212.275), 1);
    model.angles = (0, 0, 0);
    model setmodel("collision_clip_wall_128x128x10");
    model disconnectpaths();

    model = spawn( "script_model", (10173.4, -1761.36, -217.812), 1);
    model.angles = (0, -60, 0);
    model setmodel("collision_clip_wall_128x128x10");
    model disconnectpaths();

    model = spawn( "script_model", (10147.5, -1657.67, -217.208), 1);
    model.angles = (0, 88, 0);
    model setmodel("collision_clip_wall_256x256x10");
    model disconnectpaths();

    model = spawn( "script_model", (10082.7, -1528.05, -217.288), 1);
    model.angles = (0, -180, 0);
    model setmodel("collision_clip_wall_128x128x10");
    model disconnectpaths();

    model = spawn( "script_model", (10159.6, -1104.45, -214.861), 1);
    model.angles = (0, -30, 0);
    model setmodel("collision_clip_64x64x256");
    model disconnectpaths();

    model = spawn( "script_model", (10157.4, -1222.83, -217.875), 1);
    model.angles = (0, 10, 0);
    model setmodel("collision_clip_64x64x256");
    model disconnectpaths();

    model = spawn( "script_model", (10216.6, -1134.53, -217.261), 1);
    model.angles = (0, -30, 0);
    model setmodel("collision_clip_64x64x256");
    model disconnectpaths();

    model = spawn( "script_model", (10147.4, -1152.83, -217.875), 1);
    model.angles = (0, 10, 0);
    model setmodel("collision_clip_64x64x256");
    model disconnectpaths();

    model = spawn( "script_model", (10099.6, -1064.45, -214.861), 1);
    model.angles = (0, -30, 0);
    model setmodel("collision_clip_64x64x256");
    model disconnectpaths();

    model = spawn( "script_model", (10016.8, -1490.24, -217.875), 1);
    model.angles = (0, -30, 0);
    model setmodel("collision_clip_128x128x128");
    model disconnectpaths();

    model = spawn( "script_model", (10443.9, -353.378, -217.748), 1);
    model.angles = (0, -35, 0);
    model setmodel("collision_clip_128x128x128");
    model disconnectpaths();

    model = spawn( "script_model", (10393.5, -421.323, -220.142), 1);
    model.angles = (0, -25, 0);
    model setmodel("collision_clip_128x128x128");
    model disconnectpaths();

    model = spawn( "script_model", (10334.9, -544.594, -217.922), 1);
    model.angles = (0, -25, 0);
    model setmodel("collision_clip_128x128x128");
    model disconnectpaths();
}

disable_zombie_spawn_locations()
{
	for ( z = 0; z < level.zone_keys.size; z++ )
	{
        zone_name = level.zone_keys[z];
        if(zone_name == "zone_amb_cornfield")
        {
            zone = level.zones[ zone_name ];

            i = 0;
            while ( i < zone.spawn_locations.size )
            {
                if (zone.spawn_locations[i].origin == (8394, -2545, -205.16))
                {
                    zone.spawn_locations[i].is_enabled = false;
                }

                i++;
            }
        }
	}
}