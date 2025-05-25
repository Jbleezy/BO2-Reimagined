#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	zone = "zone_nml_2";
	scripts\zm\replaced\utility::register_map_spawn((1373, 879, 97), (0, 285, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1638, 284, 138), (0, 315, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1975, -43, 125), (0, 135, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((2090, -398, 120), (0, 110, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-988, 820, 106), (0, 265, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-985, 521, 104), (0, 235, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-1286, 108, 102), (0, 55, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-1473, -474, 104), (0, 80, 0), zone, 2);
}

precache()
{

}

main()
{
	treasure_chest_init();
	random_perk_machine_init();
	init_barriers();
	init_wallbuy_plywood();
	generatebuildabletarps();
	disable_doors();
	enable_zones();
	disable_zones();
	disable_zombie_spawn_locations();
	disable_player_spawn_locations();
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest_names = array("nml_open_chest", "nml_farm_chest");
	level.chests = [];

	foreach (chest_name in chest_names)
	{
		chest = getstruct(chest_name, "script_noteworthy");
		level.chests[level.chests.size] = chest;
	}

	start_chest_names = array("nml_open_chest", "nml_farm_chest");
	maps\mp\zombies\_zm_magicbox::treasure_chest_init(random(start_chest_names));
}

random_perk_machine_init()
{
	machine_names = array("nml", "farmhouse");
	machines = getentarray("random_perk_machine", "targetname");

	foreach (machine in machines)
	{
		if (!isinarray(machine_names, machine.script_string))
		{
			machine delete();
		}
	}

	start_machine_names = array("nml", "farmhouse");
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
	scripts\zm\locs\loc_common::barrier("collision_wall_256x256x10_standard", (-771, 1373, 199), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_128", (-771, 1388, 51), (0, 0, -15));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (-1206, 1187, 358), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_256", (-1271, 1202, 102), (0, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_02", (-1391, 1212, 109), (0, 90, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_02", (-1031, 1212, 104), (0, 90, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (1331, 1181, 329), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_256", (1266, 1200, 71), (0, 0, -5));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_01", (1171, 1210, 85), (5, 90, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_crate_01", (1481, 1210, 77), (5, 90, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (-2432, 587, 270), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_gate", (-2432, 587, 221), (0, 0, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (1997, 802, 181), (0, 90, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barbedwire_gate", (1997, 802, 117), (0, 90, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (91, -141, 388), (0, 135, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_wood_wall_64x96_lft", (88, -144, 333), (90, 135, 0));
}

init_wallbuy_plywood()
{
	scripts\zm\zm_tomb\zm_tomb_reimagined::spawn_wallbuy_plywood((-2432, 591, 265), (0, -90, 0));
	scripts\zm\zm_tomb\zm_tomb_reimagined::spawn_wallbuy_plywood((1993, 802, 169), (0, 0, 0));
}

generatebuildabletarps()
{
	tarp = spawn("script_model", (2307, 704, -20));
	tarp.angles = (0, 0, 0);
	tarp setModel("p6_zm_buildable_bench_tarp");
}

disable_doors()
{
	debris_trigs = getentarray("zombie_debris", "targetname");

	foreach (debris_trig in debris_trigs)
	{
		if (debris_trig.script_flag == "activate_zone_village_0")
		{
			debris_trig delete();
		}
	}
}

enable_zones()
{
	flag_set("activate_zone_nml");
}

disable_zones()
{
	valid_zones = array("zone_nml_0", "zone_nml_1", "zone_nml_2", "zone_nml_2b", "zone_nml_3", "zone_nml_4", "zone_nml_5", "zone_nml_6", "zone_nml_7", "zone_nml_8", "zone_nml_9", "zone_nml_10", "zone_nml_10a", "zone_nml_11", "zone_nml_12", "zone_nml_13", "zone_nml_14", "zone_nml_15", "zone_nml_16", "zone_nml_17", "zone_nml_18", "zone_nml_20", "zone_nml_farm");
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
		if (index == "zone_nml_1")
		{
			foreach (spawn_location in zone.spawn_locations)
			{
				if (spawn_location.origin == (-960, 1408, 121.75))
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
		if (respawn_point.script_noteworthy == "zone_nml_2")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (-768, 2048, -96))
				{
					arrayremovevalue(respawn_array, respawn);
					break;
				}
			}
		}
		else if (respawn_point.script_noteworthy == "zone_nml_18")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (320, 0, 147.65))
				{
					arrayremovevalue(respawn_array, respawn);
					break;
				}
			}

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (-128, 256, 51.65))
				{
					arrayremovevalue(respawn_array, respawn);
					break;
				}
			}
		}
		else if (respawn_point.script_noteworthy == "zone_nml_farm")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (-2752, 64, 64))
				{
					arrayremovevalue(respawn_array, respawn);
					break;
				}
			}
		}
	}
}