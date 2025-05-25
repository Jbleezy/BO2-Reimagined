#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	zone = "zone_bunker_5a";
	scripts\zm\replaced\utility::register_map_spawn((-472, 2852, -256), (0, 270, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-844, 2924, -256), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-906, 2548, -256), (0, 90, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-543, 2498, -256), (0, 180, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-472, 2548, -256), (0, 90, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-543, 2924, -256), (0, 180, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-906, 2852, -256), (0, 270, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-844, 2498, -256), (0, 0, 0), zone, 2);

	level.struct_class_names["targetname"]["intermission"] = [];

	intermission_cam = spawnStruct();
	intermission_cam.origin = (-59, 2854, 42);
	intermission_cam.angles = (15, 45, 0);
	intermission_cam.targetname = "intermission";
	intermission_cam.script_string = "trenches";
	intermission_cam.speed = 30;
	intermission_cam.target = "intermission_trenches_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam);

	intermission_cam_end = spawnStruct();
	intermission_cam_end.origin = (-30, 3412, 24);
	intermission_cam_end.angles = (15, 315, 0);
	intermission_cam_end.targetname = "intermission_trenches_end";
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
	open_doors();
	disable_zones();
	scripts\zm\locs\loc_common::increase_pap_collision();
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest_names = array("bunker_start_chest", "bunker_cp_chest", "bunker_tank_chest");
	level.chests = [];

	foreach (chest_name in chest_names)
	{
		chest = getstruct(chest_name, "script_noteworthy");
		level.chests[level.chests.size] = chest;
	}

	start_chest_names = array("bunker_cp_chest", "bunker_tank_chest");
	maps\mp\zombies\_zm_magicbox::treasure_chest_init(random(start_chest_names));
}

random_perk_machine_init()
{
	machine_names = array("starting_bunker", "trenches_left", "trenches_right");
	machines = getentarray("random_perk_machine", "targetname");

	foreach (machine in machines)
	{
		if (!isinarray(machine_names, machine.script_string))
		{
			machine delete();
		}
	}

	start_machine_names = array("trenches_left", "trenches_right");
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
	if (getdvar("g_gametype") == "zgrief" && getdvarintdefault("ui_gametype_pro", 0))
	{
		scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (-686, 2653, -120), (0, 90, 0), 1);
		scripts\zm\locs\loc_common::barrier("p6_zm_tm_barricade_wall_02", (-686, 2653, -184), (0, 0, 0));
	}

	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barricade_wall_02", (-749, 2820, -112), (0, -90, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (80, 4509, -288), (0, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barricade_wall_01", (75, 4514, -352), (0, 270, 0));

	scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", (2305, 4128, -280), (0, 90, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_tm_barricade_wall_01", (2310, 4138, -344), (0, 180, 0));
}

generatebuildabletarps()
{
	tarp = spawn("script_model", (-893, 2312, -256));
	tarp.angles = (0, 0, 0);
	tarp setModel("p6_zm_buildable_bench_tarp");
}

open_doors()
{
	doors = getentarray("zombie_door", "targetname");

	foreach (door in doors)
	{
		if (isdefined(door.script_flag))
		{
			if (door.script_flag == "activate_zone_bunker_3b" || door.script_flag == "activate_zone_bunker_4b")
			{
				door maps\mp\zombies\_zm_blockers::door_opened(self.zombie_cost);
			}
		}
	}
}

disable_zones()
{
	valid_zones = array("zone_start", "zone_start_a", "zone_start_b", "zone_bunker_1", "zone_bunker_1a", "zone_bunker_2", "zone_bunker_2a", "zone_bunker_3a", "zone_bunker_3b", "zone_bunker_4a", "zone_bunker_4b", "zone_bunker_4c", "zone_bunker_4d", "zone_bunker_5a", "zone_bunker_6");
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