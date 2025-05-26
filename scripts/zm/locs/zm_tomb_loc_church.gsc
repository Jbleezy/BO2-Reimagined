#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	zone = "zone_village_1";
	scripts\zm\replaced\utility::register_map_spawn((710, -2538, 37), (0, 285, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((565, -2577, 37), (0, 285, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((420, -2616, 37), (0, 285, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((275, -2654, 37), (0, 285, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((736, -2635, 37), (0, 105, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((591, -2673, 37), (0, 105, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((446, -2712, 37), (0, 105, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((301, -2751, 37), (0, 105, 0), zone, 2);

	level.struct_class_names["targetname"]["intermission"] = [];

	intermission_cam = spawnStruct();
	intermission_cam.origin = (1332, -3279, 650);
	intermission_cam.angles = (30, 150, 0);
	intermission_cam.targetname = "intermission";
	intermission_cam.script_string = "church";
	intermission_cam.speed = 30;
	intermission_cam.target = "intermission_church_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam);

	intermission_cam_end = spawnStruct();
	intermission_cam_end.origin = (573, -3263, 650);
	intermission_cam_end.angles = (30, 60, 0);
	intermission_cam_end.targetname = "intermission_church_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam_end);
}

precache()
{

}

main()
{
	treasure_chest_init();
	random_perk_machine_init();
	init_barriers();
	generatebuildabletarps();
	enable_zones();
	disable_zones();
	disable_zombie_spawn_locations();
	disable_player_spawn_locations();
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest_names = array("village_church_chest");
	level.chests = [];

	foreach (chest_name in chest_names)
	{
		chest = getstruct(chest_name, "script_noteworthy");
		level.chests[level.chests.size] = chest;
	}

	start_chest_names = array("village_church_chest");
	maps\mp\zombies\_zm_magicbox::treasure_chest_init(random(start_chest_names));
}

random_perk_machine_init()
{
	machine_names = array("church");
	machines = getentarray("random_perk_machine", "targetname");

	foreach (machine in machines)
	{
		if (!isinarray(machine_names, machine.script_string))
		{
			machine delete();
		}
	}

	start_machine_names = array("church");
	machines = getentarray("random_perk_machine", "targetname");

	foreach (machine in machines)
	{
		if (isinarray(start_machine_names, machine.script_string))
		{
			machine.script_noteworthy = "start_machine";
		}
		else
		{
			machine.script_noteworthy = undefined;
		}
	}
}

init_barriers()
{
	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (-595, -2085, 441), (0, 45, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_128", (-607, -2062, 191), (0, 45, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_01", (-684, -2133, 183), (0, 135, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_01", (-541, -1990, 190), (0, 135, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (1371, -1856, 441), (0, -45, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_128", (1391, -1834, 209), (0, -45, 15));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_01", (1324, -1760, 213), (-15, 45, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_01", (1463, -1899, 207), (-15, 45, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (763, -1956, 281), (0, 90, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_128", (743, -1956, 230), (0, 90, 5));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (1241, -2951, 306), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barricade_wall_02", (1241, -2941, 237), (-30, -90, 0));
}

generatebuildabletarps()
{
	tarp = spawn("script_model", (127, -2987, 48));
	tarp.angles = (0, -75, 0);
	tarp setModel("p6_zm_buildable_bench_tarp");
}

enable_zones()
{
	flag_set("activate_zone_village_0");
}

disable_zones()
{
	valid_zones = array("zone_village_1", "zone_village_1a", "zone_village_2", "zone_village_3", "zone_village_3a", "zone_village_3b", "zone_village_4b", "zone_village_5b", "zone_village_6", "zone_village_6a");
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	foreach (index, zone in level.zones)
	{
		if (!isinarray(valid_zones, index))
		{
			level.zones[index].is_enabled = 0;
			level.zones[index].is_spawning_allowed = 0;

			foreach (spawn_point in spawn_points)
			{
				if (spawn_point.script_noteworthy == index)
				{
					spawn_point.locked = 1;
					break;
				}
			}
		}
	}
}

disable_zombie_spawn_locations()
{
	foreach (index, zone in level.zones)
	{
		if (index == "zone_village_5b")
		{
			foreach (spawn_location in zone.spawn_locations)
			{
				if (spawn_location.origin == (-576, -2048, 192))
				{
					spawn_location.is_enabled = false;
				}
				else if (spawn_location.origin == (-672, -2112, 184))
				{
					spawn_location.is_enabled = false;
				}
			}
		}
	}
}

disable_player_spawn_locations()
{
	respawn_points = getstructarray("player_respawn_point", "targetname");

	foreach (respawn_point in respawn_points)
	{
		if (respawn_point.script_noteworthy == "zone_village_5")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (-640, -1920, 216))
				{
					arrayremovevalue(respawn_array, respawn);
					break;
				}
			}
		}
		else if (respawn_point.script_noteworthy == "zone_village_3")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (1248, -2752, 152))
				{
					arrayremovevalue(respawn_array, respawn);
					break;
				}
			}
		}
	}
}