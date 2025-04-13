#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	zone = "zone_blue_level1a";
	scripts\zm\replaced\utility::register_map_spawn((2032, 410, 2880), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1980, 316, 2880), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1922, 210, 2880), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((1870, 90, 2880), (0, 330, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((2142, 346, 2880), (0, 150, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((2086, 256, 2880), (0, 150, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((2028, 146, 2880), (0, 150, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((1962, 40, 2880), (0, 150, 0), zone, 2);
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
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest = getstruct("ob6_chest", "script_noteworthy");
	level.chests = [];
	level.chests[0] = chest;
	maps\mp\zombies\_zm_magicbox::treasure_chest_init("ob6_chest");
}

init_barriers()
{
	scripts\zm\locs\loc_common::barrier("collision_wall_256x256x10_standard", (2062, 1055, 3187), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_03", (2000, 1108, 3110), (90, 180, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_03", (2065, 1108, 3110), (90, 180, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_03", (2130, 1108, 3110), (90, 180, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_03", (2195, 1108, 3110), (90, 180, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (2722, 1039, 2946), (348, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2571, 1060, 2760), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2618, 1060, 2770), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2665, 1060, 2780), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2712, 1060, 2790), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2759, 1060, 2800), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2806, 1060, 2810), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2853, 1060, 2820), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2529, 1060, 2956), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2576, 1060, 2966), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2623, 1060, 2976), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2670, 1060, 2986), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2717, 1060, 2996), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2764, 1060, 3006), (348, 0, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_pillar_01", (2811, 1060, 3016), (348, 0, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (3127, 939, 3200), (348, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("collision_wall_512x512x10_standard", (3367, 939, 3250), (348, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (3035, 1008, 2935), (12, 180, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (3250, 1009, 2981), (12, 180, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_hr_concrete_slabs_lrg_02", (3465, 1008, 3026), (12, 180, 0));
}

disable_zones()
{
	valid_zones = array("zone_blue_level1a", "zone_blue_level1b", "zone_blue_level1c", "zone_blue_level2a", "zone_blue_level2b", "zone_blue_level2c", "zone_blue_level2d");
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