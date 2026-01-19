#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	scripts\zm\replaced\utility::register_perk_struct("", "", (0, 0, 0), (0, 0, 0)); // need this for pap to work
	scripts\zm\replaced\utility::register_perk_struct("specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", (10460, -564, -220), (0, -35, 0));

	structs = getstructarray("player_respawn_point", "targetname");
	respawn_point = undefined;
	zone = "zone_cornfield_prototype";

	foreach (struct in structs)
	{
		if (isdefined(struct.script_noteworthy) && struct.script_noteworthy == zone)
		{
			respawn_point = struct;
			break;
		}
	}

	respawn_point2 = undefined;
	zone = "zone_amb_cornfield";
	target = "cornfield_nml_player_spawns";

	foreach (struct in structs)
	{
		if (isdefined(struct.script_noteworthy) && struct.script_noteworthy == zone)
		{
			if (isdefined(struct.target) && struct.target == target)
			{
				respawn_point2 = struct;
				break;
			}
		}
	}

	level.struct_class_names["targetname"]["player_respawn_point"] = [];
	level.struct_class_names["script_noteworthy"]["initial_spawn"] = [];

	if (isdefined(respawn_point))
	{
		scripts\zm\replaced\utility::register_map_spawn_group(respawn_point.origin, zone, respawn_point.script_int);

		respawn_array = getstructarray(respawn_point.target, "targetname");

		foreach (respawn in respawn_array)
		{
			scripts\zm\replaced\utility::register_map_spawn(respawn.origin + (150, -150, 0), respawn.angles + (0, 180, 0), zone, respawn.script_int);
		}
	}

	if (isdefined(respawn_point2))
	{
		scripts\zm\replaced\utility::register_map_spawn_group(respawn_point2.origin, zone, respawn_point2.script_int);

		scripts\zm\replaced\utility::register_map_spawn((11986, -1858, -132), (0, 80, 0), zone);
		scripts\zm\replaced\utility::register_map_spawn((12158, -61, -141), (0, -85, 0), zone);
		scripts\zm\replaced\utility::register_map_spawn((11366, 20, -193), (0, -5, 0), zone);
		scripts\zm\replaced\utility::register_map_spawn((11199, -1768, -156), (0, -5, 0), zone);
		scripts\zm\replaced\utility::register_map_spawn((10448, 90, -189), (0, -5, 0), zone);
		scripts\zm\replaced\utility::register_map_spawn((10255, -1698, -186), (0, -5, 0), zone);
		scripts\zm\replaced\utility::register_map_spawn((10046, -591, -192), (0, 0, 0), zone);
		scripts\zm\replaced\utility::register_map_spawn((10036, -967, -186), (0, 0, 0), zone);
	}

	structs = getstructarray("game_mode_object", "targetname");

	foreach (struct in structs)
	{
		if (isDefined(struct.script_noteworthy) && struct.script_noteworthy == "cornfield")
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

}

main()
{
	treasure_chest_init();
	init_barriers();
	disable_zombie_spawn_locations();
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects("cornfield");
	scripts\zm\locs\loc_common::increase_pap_collision();
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest = getstruct("cornfield_chest", "script_noteworthy");
	level.chests = [];
	level.chests[0] = chest;
	maps\mp\zombies\_zm_magicbox::treasure_chest_init("cornfield_chest");
}

init_barriers()
{
	collision = spawn("script_model", (10500, -850, 0), 1);
	collision setmodel("zm_collision_transit_cornfield_survival");
	collision disconnectpaths();

	// cornfield left
	origin = (9720, -1090, -212);
	angles = (0, 90, 0);
	scripts\zm\locs\loc_common::barrier("collision_wall_256x256x10_standard", origin + (anglesToRight(angles) * 24) + (anglesToUp(angles) * 128), angles, 1);
	scripts\zm\locs\loc_common::barrier("veh_t6_civ_smallwagon_dead", origin, angles);

	// cornfield right
	origin = (9900, -232, -217);
	angles = (0, -90, 0);
	scripts\zm\locs\loc_common::barrier("collision_wall_256x256x10_standard", origin + (anglesToRight(angles) * -48) + (anglesToUp(angles) * 128), angles, 1);
	scripts\zm\locs\loc_common::barrier("veh_t6_civ_microbus_dead", origin, angles);

	// cornfield right corner
	origin = (9982, -142, -217);
	angles = (0, 35, 0);
	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", origin + (anglesToUp(angles) * 64), angles, 1);
	scripts\zm\locs\loc_common::barrier("veh_t6_civ_smallwagon_dead", origin + (anglesToForward(angles) * 15) + (anglesToRight(angles) * -50), angles + (0, 165, 0));
}

disable_zombie_spawn_locations()
{
	for (z = 0; z < level.zone_keys.size; z++)
	{
		if (level.zone_keys[z] != "zone_amb_cornfield")
		{
			continue;
		}

		zone = level.zones[level.zone_keys[z]];

		i = 0;

		while (i < zone.spawn_locations.size)
		{
			if (zone.spawn_locations[i].origin[0] <= 9700)
			{
				zone.spawn_locations[i].is_enabled = false;
			}

			i++;
		}
	}
}