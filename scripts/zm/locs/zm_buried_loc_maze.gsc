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
				struct.origin += anglesToRight(struct.angles) * 32;
				struct.origin += anglesToForward(struct.angles) * -12;
			}
			else if (struct.script_noteworthy == "specialty_fastreload")
			{
				struct.origin += anglesToRight(struct.angles) * 24;
				struct.origin += anglesToForward(struct.angles) * -16;
			}
			else if (struct.script_noteworthy == "specialty_rof")
			{
				struct.origin += anglesToRight(struct.angles) * 20;
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
			temp_origin = og_perk_structs[i].origin;
			temp_angles = og_perk_structs[i].angles;
			og_perk_structs[i].origin = og_perk_structs[rand].origin;
			og_perk_structs[i].angles = og_perk_structs[rand].angles;
			og_perk_structs[rand].origin = temp_origin;
			og_perk_structs[rand].angles = temp_angles;
		}
	}

	foreach (struct in og_perk_structs)
	{
		scripts\zm\replaced\utility::register_perk_struct( struct.script_noteworthy, struct.model, struct.origin, struct.angles );
	}

	scripts\zm\replaced\utility::register_perk_struct( "specialty_additionalprimaryweapon", "zombie_vending_three_gun", (3414, 853, 52), (0, 90, 0) );

	for(i = 0; i < level.struct_class_names["targetname"]["player_respawn_point"].size; i++)
    {
        if(level.struct_class_names["targetname"]["player_respawn_point"][i].script_noteworthy != "zone_mansion_backyard" && level.struct_class_names["targetname"]["player_respawn_point"][i].script_noteworthy != "zone_maze" && level.struct_class_names["targetname"]["player_respawn_point"][i].script_noteworthy != "zone_maze_staircase")
        {
			level.struct_class_names["targetname"]["player_respawn_point"][i].script_string = "none";
        }
		else
		{
			level.struct_class_names["targetname"]["player_respawn_point"][i].script_string = "zgrief_street";
		}
    }

    initialpoints = getstructarray( "initial_spawn", "script_noteworthy" );
	level.struct_class_names[ "script_noteworthy" ][ "initial_spawn" ] = [];
	foreach (point in initialpoints)
	{
		if(isDefined(point.script_string) && isSubStr(point.script_string, "zgrief_maze"))
		{
			scripts\zm\replaced\utility::register_map_initial_spawnpoint( point.origin, point.angles, point.script_int );
		}
	}
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
	maps\mp\zombies\_zm::spawn_kill_brush( (6751, 568, -785), 256, 400 );
	init_wallbuys();
	disable_player_spawn_locations();
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
			struct.origin += anglesToRight(struct.angles) * 32;
			og_weapon_structs[og_weapon_structs.size] = struct;
		}
	}

	og_weapon_structs = array_randomize(og_weapon_structs);

	scripts\zm\replaced\utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", og_weapon_structs[0].origin, og_weapon_structs[0].angles );
	scripts\zm\replaced\utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", og_weapon_structs[1].origin, og_weapon_structs[1].angles );
	scripts\zm\replaced\utility::wallbuy( "beretta93r_zm", "beretta93r", "weapon_upgrade", og_weapon_structs[2].origin, og_weapon_structs[2].angles );
	scripts\zm\replaced\utility::wallbuy( "mp5k_zm", "mp5", "weapon_upgrade", og_weapon_structs[3].origin, og_weapon_structs[3].angles );
	scripts\zm\replaced\utility::wallbuy( "pdw57_zm", "pdw57", "weapon_upgrade", og_weapon_structs[4].origin, og_weapon_structs[4].angles );
	scripts\zm\replaced\utility::wallbuy( "m16_zm", "m16", "weapon_upgrade", og_weapon_structs[5].origin, og_weapon_structs[5].angles );
}

disable_player_spawn_locations()
{
    spawn_points = getstructarray( "player_respawn_point", "targetname" );
    foreach(spawn_point in spawn_points)
    {
        if(spawn_point.script_noteworthy != "zone_mansion_backyard" && spawn_point.script_noteworthy != "zone_maze" && spawn_point.script_noteworthy != "zone_maze_staircase")
        {
            spawn_point.script_noteworthy = "none";
        }
    }
}

disable_mansion()
{
	model = spawn( "script_model", (3386.42, 548.859, 239.727));
	model.angles = (0, -90, 0);
	model setmodel("p6_zm_bu_sloth_blocker_medium");
	model = spawn( "script_model", (3396.1, 556.795, 246.125));
	model.angles = (0, 90, 0);
	model setmodel("collision_clip_wall_128x128x10");

	model = spawn( "script_model", (3490.37, 1045.68, 56.6861));
	model.angles = (0, -96, 8);
	model setmodel("p6_zm_bu_sloth_blocker_medium");
	model = spawn( "script_model", (3364.03, 1123.32, 51.4592));
	model.angles = (0, 0, 0);
	model setmodel("collision_clip_256x256x256");
}