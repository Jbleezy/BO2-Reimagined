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
#include scripts\zm\locs\loc_common;

struct_init()
{
	og_perk_structs = [];
	structs = getstructarray( "zm_perk_machine", "targetname" );

	level.struct_class_names[ "targetname" ][ "zm_perk_machine" ] = [];

	foreach (struct in structs)
	{
		if (isdefined(struct.script_string) && isSubStr(struct.script_string, "zclassic"))
		{
			if (struct.script_noteworthy == "specialty_longersprint" || struct.script_noteworthy == "specialty_weapupgrade")
			{
				scripts\zm\replaced\utility::register_perk_struct( struct.script_noteworthy, struct.model, struct.origin, struct.angles );
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

		scripts\zm\replaced\utility::register_perk_struct( struct.script_noteworthy, struct.model, struct.origin, struct.angles );
	}

	scripts\zm\replaced\utility::register_perk_struct( "specialty_additionalprimaryweapon", "zombie_vending_three_gun", (3414, 853, 52), (0, 90, 0) );

	initial_spawns = [];
	player_respawn_points = [];

	foreach (initial_spawn in level.struct_class_names["script_noteworthy"]["initial_spawn"])
	{
		if (isDefined(initial_spawn.script_string) && isSubStr(initial_spawn.script_string, "zgrief_maze"))
		{
			initial_spawn.script_string = "zgrief_street";

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
			spawn_array = getstructarray( player_respawn_point.target, "targetname" );
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

	level.struct_class_names[ "script_noteworthy" ][ "initial_spawn" ] = initial_spawns;
	level.struct_class_names[ "targetname" ][ "player_respawn_point" ] = player_respawn_points;

	level.struct_class_names[ "targetname" ][ "intermission" ] = [];

	intermission_cam = spawnStruct();
	intermission_cam.origin = (3694, 569, 253);
	intermission_cam.angles = (30, 0, 0);
	intermission_cam.targetname = "intermission";
	intermission_cam.script_string = "street";
	intermission_cam.speed = 30;
	intermission_cam.target = "intermission_street_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam);

	intermission_cam_end = spawnStruct();
	intermission_cam_end.origin = (5856, 569, 253);
	intermission_cam_end.angles = (30, 0, 0);
	intermission_cam_end.targetname = "intermission_street_end";
	scripts\zm\replaced\utility::add_struct(intermission_cam_end);
}

precache()
{
	precachemodel( "zm_collision_buried_street_grief" );
	precachemodel( "p6_zm_bu_buildable_bench_tarp" );
	level.chalk_buildable_pieces_hide = 1;
	griefbuildables = array( "chalk", "turbine", "springpad_zm", "subwoofer_zm" );
	maps\mp\zm_buried_buildables::include_buildables( griefbuildables );
	maps\mp\zm_buried_buildables::init_buildables( griefbuildables );
	maps\mp\zombies\_zm_equip_turbine::init();
	maps\mp\zombies\_zm_equip_turbine::init_animtree();
	maps\mp\zombies\_zm_equip_springpad::init( &"ZM_BURIED_EQ_SP_PHS", &"ZM_BURIED_EQ_SP_HTS" );
	maps\mp\zombies\_zm_equip_subwoofer::init( &"ZM_BURIED_EQ_SW_PHS", &"ZM_BURIED_EQ_SW_HTS" );
	maps\mp\zm_buried_fountain::init_fountain();

	setdvar( "disableLookAtEntityLogic", 1 );

	start_chest_zbarrier = getEnt( "start_chest_zbarrier", "script_noteworthy" );
	start_chest_zbarrier.origin = (4127.04, 1271.74, 17);
	start_chest_zbarrier.angles = (0, 270, 0);
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

	start_chest2_zbarrier = getEnt( "tunnels_chest1_zbarrier", "script_noteworthy" );
	start_chest2_zbarrier.origin = (5605.74, 276.96, 17);
	start_chest2_zbarrier.angles = (0, 180, 0);
	start_chest2 = spawnStruct();
	start_chest2.origin = start_chest2_zbarrier.origin;
	start_chest2.angles = start_chest2_zbarrier.angles;
	start_chest2.script_noteworthy = "tunnels_chest1";
	start_chest2.zombie_cost = 950;
	collision = spawn( "script_model", start_chest2_zbarrier.origin, 1 );
	collision.angles = start_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", start_chest2_zbarrier.origin - ( 32, 0, 0 ), 1 );
	collision.angles = start_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();
	collision = spawn( "script_model", start_chest2_zbarrier.origin + ( 32, 0, 0 ), 1 );
	collision.angles = start_chest2_zbarrier.angles;
	collision setmodel( "collision_clip_32x32x128" );
	collision disconnectpaths();

	level.chests = [];
	level.chests[0] = start_chest;
	level.chests[1] = start_chest2;
}

main()
{
	level.buildables_built["pap"] = 1;
	level.equipment_team_pick_up = 1;
	level thread maps\mp\zombies\_zm_buildables::think_buildables();
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects( "street" );
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( random( array( "start_chest", "tunnels_chest1" ) ) );
	deleteslothbarricades();
	powerswitchstate( 1 );

	flag_set("mansion_door1");
	level.zones["zone_mansion"].is_enabled = 0;
	maps\mp\zombies\_zm::spawn_kill_brush( (4919, 575, -511), 128, 300 );
	init_wallbuys();
	init_barriers();
	disable_mansion();
	scripts\zm\locs\loc_common::init();
}

init_wallbuys()
{
	og_weapon_structs = [];
	structs = getstructarray( "weapon_upgrade", "targetname" );
	foreach (struct in structs)
	{
		if (isDefined(struct.script_noteworthy) && isSubStr(struct.script_noteworthy, "maze"))
		{
			og_weapon_structs[og_weapon_structs.size] = struct;
		}
	}

	og_weapon_structs[0].origin += anglesToRight(og_weapon_structs[0].angles) * 28;
	og_weapon_structs[1].origin += anglesToRight(og_weapon_structs[1].angles) * 50;
	og_weapon_structs[2].origin += anglesToRight(og_weapon_structs[2].angles) * -18;
	og_weapon_structs[3].origin += anglesToRight(og_weapon_structs[3].angles) * 46;
	og_weapon_structs[4].origin += anglesToRight(og_weapon_structs[4].angles) * 33;
	og_weapon_structs[5].origin += anglesToRight(og_weapon_structs[5].angles) * 36;

	og_weapon_structs = array_randomize(og_weapon_structs);

	scripts\zm\replaced\utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", og_weapon_structs[0].origin, og_weapon_structs[0].angles );
	scripts\zm\replaced\utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", og_weapon_structs[1].origin, og_weapon_structs[1].angles );
	scripts\zm\replaced\utility::wallbuy( "beretta93r_zm", "beretta93r", "weapon_upgrade", og_weapon_structs[2].origin, og_weapon_structs[2].angles );
	scripts\zm\replaced\utility::wallbuy( "pdw57_zm", "pdw57", "weapon_upgrade", og_weapon_structs[3].origin, og_weapon_structs[3].angles );
	scripts\zm\replaced\utility::wallbuy( "an94_zm", "an94", "weapon_upgrade", og_weapon_structs[4].origin, og_weapon_structs[4].angles );
	scripts\zm\replaced\utility::wallbuy( "lsat_zm", "lsat", "weapon_upgrade", og_weapon_structs[5].origin, og_weapon_structs[5].angles );
}

init_barriers()
{
	scripts\zm\replaced\utility::barrier( "collision_geo_64x64x128_standard", (3398, 898, 116), (0, 0, 0) );
	scripts\zm\replaced\utility::barrier( "collision_geo_64x64x128_standard", (3398, 898, 244), (0, 0, 0) );
	scripts\zm\replaced\utility::barrier( "collision_geo_64x64x128_standard", (3398, 898, 372), (0, 0, 0) );

	structs = getstructarray( "zm_perk_machine", "targetname" );
	foreach (struct in structs)
	{
		scripts\zm\replaced\utility::barrier( "collision_geo_64x64x128_standard", struct.origin + (anglesToRight(struct.angles) * -9) + (0, 0, 320), struct.angles );
	}
}

disable_mansion()
{
	// left
	model = spawn( "script_model", (3368.72, 561.516, 234.577));
	model.angles = (179, 90, 38);
	model setmodel("p6_zm_bu_conservatory_tree_roots_a_close");
	model = spawn( "script_model", (3396.1, 556.795, 246.125));
	model.angles = (0, 90, 0);
	model setmodel("collision_clip_wall_128x128x10");

	// right
	model = spawn( "script_model", (3447.32, 1058.31, 30.6045));
	model.angles = (0, 270, 240);
	model setmodel("p6_zm_bu_conservatory_tree_roots_a");
	model = spawn( "script_model", (3417.32, 1058.31, 200.605));
	model.angles = (-170, 270, 220);
	model setmodel("p6_zm_bu_conservatory_tree_roots_a");
	model = spawn( "script_model", (3332.03, 1123.32, 51.4592));
	model.angles = (-15, 0, 0);
	model setmodel("collision_clip_256x256x256");
}