#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_equip_subwoofer;
#include maps\mp\zombies\_zm_equip_springpad;
#include maps\mp\zombies\_zm_equip_turbine;
#include maps\mp\zombies\_zm_equip_headchopper;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	og_perk_structs = [];
	structs = getstructarray("zm_perk_machine", "targetname");

	level.struct_class_names["targetname"]["zm_perk_machine"] = [];

	foreach (struct in structs)
	{
		if (isdefined(struct.script_string) && isSubStr(struct.script_string, "zclassic"))
		{
			if (struct.script_noteworthy == "specialty_longersprint" || struct.script_noteworthy == "specialty_weapupgrade")
			{
				scripts\zm\replaced\utility::register_perk_struct(struct.script_noteworthy, struct.model, struct.origin, struct.angles);
			}
		}
		else if (isdefined(struct.script_string) && isSubStr(struct.script_string, "maze"))
		{
			if (struct.script_noteworthy == "specialty_armorvest")
			{
				struct.origin += anglesToRight(struct.angles) * 24;
				struct.origin += anglesToForward(struct.angles) * -16;
			}
			else if (struct.script_noteworthy == "specialty_quickrevive")
			{
				struct.origin += anglesToRight(struct.angles) * 36;
				struct.origin += anglesToForward(struct.angles) * -12;
			}
			else if (struct.script_noteworthy == "specialty_fastreload")
			{
				struct.origin += anglesToRight(struct.angles) * 24;
				struct.origin += anglesToForward(struct.angles) * -16;
			}
			else if (struct.script_noteworthy == "specialty_rof")
			{
				struct.origin += anglesToRight(struct.angles) * 32;
				struct.origin += anglesToForward(struct.angles) * -12;
			}

			og_perk_structs[og_perk_structs.size] = struct;
		}
	}

	for (i = 0; i < og_perk_structs.size; i++)
	{
		rand = randomint(og_perk_structs.size);

		if (rand != i)
		{
			temp_script_noteworthy = og_perk_structs[i].script_noteworthy;
			og_perk_structs[i].script_noteworthy = og_perk_structs[rand].script_noteworthy;
			og_perk_structs[rand].script_noteworthy = temp_script_noteworthy;
		}
	}

	foreach (struct in og_perk_structs)
	{
		if (struct.script_noteworthy == "specialty_rof")
		{
			struct.origin += anglesToRight(struct.angles) * -12;
		}

		scripts\zm\replaced\utility::register_perk_struct(struct.script_noteworthy, struct.model, struct.origin, struct.angles);
	}

	scripts\zm\replaced\utility::register_perk_struct("specialty_additionalprimaryweapon", "zombie_vending_three_gun", (3414, 856, 54), (0, 90, 0));

	initial_spawns = [];
	player_respawn_points = [];

	foreach (initial_spawn in level.struct_class_names["script_noteworthy"]["initial_spawn"])
	{
		if (isDefined(initial_spawn.script_string) && isSubStr(initial_spawn.script_string, "zgrief_maze"))
		{
			initial_spawns[initial_spawns.size] = initial_spawn;
		}
	}

	foreach (player_respawn_point in level.struct_class_names["targetname"]["player_respawn_point"])
	{
		if (player_respawn_point.script_noteworthy == "zone_maze")
		{
			if (player_respawn_point.target == "maze_spawn_points")
			{
				player_respawn_point.script_noteworthy = "zone_mansion_backyard";
			}
			else
			{
				level.struct_class_names["targetname"][player_respawn_point.target] = initial_spawns;
			}

			player_respawn_points[player_respawn_points.size] = player_respawn_point;
		}
		else if (player_respawn_point.script_noteworthy == "zone_maze_staircase")
		{
			spawn_array = getstructarray(player_respawn_point.target, "targetname");

			foreach (spawn in spawn_array)
			{
				if (spawn.origin[0] > 5950)
				{
					if (spawn.origin[1] > 550)
					{
						spawn.angles = (0, -90, 0);
					}
					else
					{
						spawn.angles = (0, 90, 0);
					}
				}
			}

			player_respawn_points[player_respawn_points.size] = player_respawn_point;
		}
	}

	level.struct_class_names["script_noteworthy"]["initial_spawn"] = initial_spawns;
	level.struct_class_names["targetname"]["player_respawn_point"] = player_respawn_points;

	level.struct_class_names["targetname"]["intermission"] = [];

	intermission_cam = spawnStruct();
	intermission_cam.origin = (3694, 569, 253);
	intermission_cam.angles = (30, 0, 0);
	intermission_cam.targetname = "intermission";
	intermission_cam.script_string = "maze";
	intermission_cam.speed = 30;
	intermission_cam.target = "intermission_maze_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam);

	intermission_cam_end = spawnStruct();
	intermission_cam_end.origin = (5856, 569, 253);
	intermission_cam_end.angles = (30, 0, 0);
	intermission_cam_end.targetname = "intermission_maze_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam_end);
}

precache()
{

}

main()
{
	level.buildables_built["pap"] = 1;
	level.equipment_team_pick_up = 1;
	level thread maps\mp\zombies\_zm_buildables::think_buildables();
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects("street");
	maze_treasure_chest_init();
	deleteslothbarricades();
	powerswitchstate(1);

	flag_set("mansion_door1");
	level.zones["zone_mansion"].is_enabled = 0;
	maps\mp\zm_buried_fountain::init_fountain();
	maps\mp\zombies\_zm::spawn_kill_brush((4919, 575, -511), 128, 300);
	level thread init_wallbuys();
	init_barriers();
	scripts\zm\locs\loc_common::init();
}

maze_treasure_chest_init()
{
	maze_chest1 = getstruct("maze_chest1", "script_noteworthy");
	maze_chest2 = getstruct("maze_chest2", "script_noteworthy");
	setdvar("disableLookAtEntityLogic", 1);
	level.chests = [];
	level.chests[level.chests.size] = maze_chest1;
	level.chests[level.chests.size] = maze_chest2;
	maps\mp\zombies\_zm_magicbox::treasure_chest_init(random(array("maze_chest1", "maze_chest2")));
}

init_wallbuys()
{
	flag_wait("start_zombie_round_logic");

	wallbuy_structs = [];
	structs = getstructarray("buildable_wallbuy", "targetname");

	foreach (struct in structs)
	{
		if (isDefined(struct.script_noteworthy) && isSubStr(struct.script_noteworthy, "maze"))
		{
			wallbuy_structs[wallbuy_structs.size] = struct;
		}
	}

	random_weapons = array_randomize(level.buildable_wallbuy_weapons);

	for (i = 0; i < wallbuy_structs.size; i++)
	{
		maps\mp\zombies\_zm_weapons::add_dynamic_wallbuy(random_weapons[i], wallbuy_structs[i].target, 1);
	}
}

init_barriers()
{
	// mansion left
	scripts\zm\locs\loc_common::barrier("collision_clip_wall_128x128x10", (3396.1, 556.795, 246.125), (0, 90, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_bu_conservatory_tree_roots_a_close", (3368.72, 561.516, 234.577), (179, 90, 38));

	// mansion right
	scripts\zm\locs\loc_common::barrier("collision_clip_256x256x256", (3332.03, 1123.32, 51.4592), (-15, 0, 0), 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_bu_conservatory_tree_roots_a", (3447.32, 1058.31, 30.6045), (0, 270, 240));
	scripts\zm\locs\loc_common::barrier("p6_zm_bu_conservatory_tree_roots_a", (3417.32, 1058.31, 200.605), (-170, 270, 220));

	trigs = getentarray("zombie_vending", "targetname");

	if (!isdefined(trigs))
	{
		return;
	}

	foreach (trig in trigs)
	{
		if (!isdefined(trig.script_noteworthy))
		{
			continue;
		}

		if (trig.script_noteworthy != "specialty_armorvest" && trig.script_noteworthy != "specialty_quickrevive" && trig.script_noteworthy != "specialty_fastreload" && trig.script_noteworthy != "specialty_rof")
		{
			continue;
		}

		if (isdefined(trig.clip))
		{
			origin = trig.clip.origin;
			angles = trig.clip.angles;

			scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", origin + anglesToRight(angles) * 18 + anglesToUp(angles) * 64, angles, 1);
			scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", origin + anglesToRight(angles) * 18 + anglesToUp(angles) * 192, angles, 1);
			scripts\zm\locs\loc_common::barrier("collision_wall_128x128x10_standard", origin + anglesToRight(angles) * 18 + anglesToUp(angles) * 320, angles, 1);

			trig.clip delete();
		}
	}
}