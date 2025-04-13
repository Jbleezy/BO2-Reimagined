#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	zone = "zone_green_level1";
	scripts\zm\replaced\utility::register_map_spawn((1600, 2006, 3415), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1600, 1906, 3415), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1600, 1806, 3415), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1600, 1706, 3415), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1750, 2006, 3415), (0, 180, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((1750, 1906, 3415), (0, 180, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((1750, 1806, 3415), (0, 180, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((1750, 1706, 3415), (0, 180, 0), zone, 2);

	level.struct_class_names["targetname"]["intermission"] = [];

	intermission_cam = spawnStruct();
	intermission_cam.origin = (2077, 937, 3150);
	intermission_cam.angles = (0, 90, 0);
	intermission_cam.targetname = "intermission";
	intermission_cam.script_string = "shopping_mall";
	intermission_cam.speed = 20;
	intermission_cam.target = "intermission_shopping_mall_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam);

	intermission_cam_end = spawnStruct();
	intermission_cam_end.origin = (2077, 937, 3550);
	intermission_cam_end.angles = (0, 90, 0);
	intermission_cam_end.targetname = "intermission_shopping_mall_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam_end);
}

precache()
{
	level thread maps\mp\zm_highrise_classic::precache();
}

main()
{
	level thread maps\mp\zm_highrise_classic::main();

	treasure_chest_init();
	init_barriers();
	disable_zones();
	level thread drop_escape_pod();
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest = getstruct("gb1_chest", "script_noteworthy");
	level.chests = [];
	level.chests[0] = chest;
	maps\mp\zombies\_zm_magicbox::treasure_chest_init("gb1_chest");
}

init_barriers()
{
	scripts\zm\locs\loc_common::barrier("collision_geo_128x128x128_standard", (2160, 845, 3198), (0, 15, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_02", (2158, 840, 3154), (90, 15, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_02", (2158, 839, 3179), (90, 15, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (2490, 749, 2961), (0, 150, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (2568, 701, 2711), (0, 150, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (2382, 808, 2711), (0, 150, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_03", (2510, 705, 3017), (0, 330, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (2444, 1597, 2891), (0, 90, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_01", (2444, 1617, 2966), (0, 90, 90));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_04", (2454, 1517, 2761), (120, 180, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_03", (2464, 1612, 2611), (0, 90, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (1436, 2716, 3080), (0, 90, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (1451, 2706, 3080), (0, 270, 0));
}

disable_zones()
{
	valid_zones = array("zone_green_start", "zone_green_level1", "zone_green_level2a", "zone_green_level2b", "zone_green_level3a", "zone_green_level3b", "zone_green_level3c");
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

drop_escape_pod()
{
	flag_wait("escape_pod_needs_reset");

	level notify("reset_escape_pod");
}