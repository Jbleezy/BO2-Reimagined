#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	zone = "zone_blue_level4a";
	scripts\zm\replaced\utility::register_map_spawn((2039, 576, 1300), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1988, 485, 1300), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1930, 379, 1300), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1888, 294, 1300), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((2235, 457, 1300), (0, 150, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((2188, 369, 1300), (0, 150, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((2130, 261, 1300), (0, 150, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((2084, 177, 1300), (0, 150, 0), zone, 2);

	level.struct_class_names["targetname"]["intermission"] = [];

	intermission_cam = spawnStruct();
	intermission_cam.origin = (3182, 719, 1450);
	intermission_cam.angles = (15, 240, 0);
	intermission_cam.targetname = "intermission";
	intermission_cam.script_string = "blue_rooftop";
	intermission_cam.speed = 30;
	intermission_cam.target = "intermission_blue_rooftop_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam);

	intermission_cam_end = spawnStruct();
	intermission_cam_end.origin = (2619, 1045, 1450);
	intermission_cam_end.angles = (15, 240, 0);
	intermission_cam_end.targetname = "intermission_blue_rooftop_end";
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
	activate_electric_switch();
	level thread swap_buildable_tables();
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest = getstruct("blue_level4_chest", "script_noteworthy");
	level.chests = [];
	level.chests[0] = chest;
	maps\mp\zombies\_zm_magicbox::treasure_chest_init("blue_level4_chest");
}

init_barriers()
{
	scripts\zm\locs\loc_common::barrier("collision_geo_256x256x256_standard", (1956, 1098, 1538), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (1956, 1102, 1456), (0, 180, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (3024, 1055, 1522), (348, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("collision_wall_256x256x10_standard", (2977, 1029, 1384), (0, 85, 0));
	scripts\zm\locs\loc_common::barrier("collision_wall_256x256x10_standard", (3002, 1029, 1384), (0, 85, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (2888, 1085, 1231), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (2935, 1085, 1241), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (2982, 1085, 1251), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3029, 1085, 1261), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3076, 1085, 1271), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3123, 1085, 1281), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3170, 1085, 1291), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (2851, 1085, 1403), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (2898, 1085, 1413), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (2945, 1085, 1423), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (2992, 1085, 1433), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3039, 1085, 1443), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3086, 1085, 1453), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3133, 1085, 1463), (348, 0, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (3400, 974, 1602), (348, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3264, 1021, 1311), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3311, 1021, 1321), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3358, 1021, 1331), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3405, 1021, 1341), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3452, 1021, 1351), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3499, 1021, 1361), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3546, 1021, 1371), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3227, 1021, 1483), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3274, 1021, 1493), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3321, 1021, 1503), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3368, 1021, 1513), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3415, 1021, 1523), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3462, 1021, 1533), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_bldg2_rest_pillar01", (3509, 1021, 1543), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (3312, 997, 1490), (348, 0, 270));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (3311, 997, 1495), (348, 0, 270));
}

disable_zones()
{
	valid_zones = array("zone_blue_level4a", "zone_blue_level4b", "zone_blue_level4c", "zone_blue_level5");
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

activate_electric_switch()
{
	trig = getent("use_elec_switch", "targetname");
	master_switch = getent("elec_switch", "targetname");
	trig setinvisibletoall();
	master_switch rotateroll(-90, 0.3);
}

swap_buildable_tables()
{
	flag_wait("start_zombie_round_logic");
	wait 0.5;

	scripts\zm\replaced\_zm_buildables_pooled::swap_buildable_fields(level.buildable_stubs[0], level.buildable_stubs[1]);
}