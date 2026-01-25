#include clientscripts\mp\zm_buried;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zm_buried_ffotd;
#include clientscripts\mp\zm_buried_sq;
#include clientscripts\mp\zombies\_zm_perk_divetonuke;
#include clientscripts\mp\zombies\_zm_perk_vulture;
#include clientscripts\mp\zm_buried_fx;
#include clientscripts\mp\zm_buried_buildables;
#include clientscripts\mp\zm_buried_classic;
#include clientscripts\mp\zm_buried_maze;
#include clientscripts\mp\zm_buried_amb;
#include clientscripts\mp\zombies\_zm_turned;
#include clientscripts\mp\zm_buried_turned_street;
#include clientscripts\mp\zm_buried_grief_street;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_zm_weap_time_bomb;
#include clientscripts\mp\zombies\_zm_weap_cymbal_monkey;
#include clientscripts\mp\zombies\_zm_weap_tazer_knuckles;
#include clientscripts\mp\zombies\_zm_weap_slowgun;
#include clientscripts\mp\zombies\_zm_ai_ghost;
#include clientscripts\mp\zombies\_zm_equip_turbine;
#include clientscripts\mp\zombies\_zm_equip_springpad;
#include clientscripts\mp\zombies\_zm_equip_subwoofer;
#include clientscripts\mp\zombies\_zm_equip_headchopper;

init_gamemodes()
{
	add_map_gamemode("zclassic", undefined, undefined);
	add_map_gamemode("zstandard", undefined, undefined);
	add_map_gamemode("zgrief", undefined, undefined);
	add_map_gamemode("zcleansed", clientscripts\mp\zombies\_zm_turned::precache, clientscripts\mp\zombies\_zm_turned::main);
	add_map_location_gamemode("zclassic", "processing", clientscripts\mp\zm_buried_classic::precache, clientscripts\mp\zm_buried_classic::premain, clientscripts\mp\zm_buried_classic::main);
	add_map_location_gamemode("zstandard", "street", clientscripts\mp\zm_buried_grief_street::precache, clientscripts\mp\zm_buried_grief_street::premain, clientscripts\mp\zm_buried_grief_street::main);
	add_map_location_gamemode("zgrief", "street", clientscripts\mp\zm_buried_grief_street::precache, clientscripts\mp\zm_buried_grief_street::premain, clientscripts\mp\zm_buried_grief_street::main);
	add_map_location_gamemode("zcleansed", "street", clientscripts\mp\zm_buried_turned_street::precache, clientscripts\mp\zm_buried_turned_street::premain, clientscripts\mp\zm_buried_turned_street::main);
}

start_zombie_stuff()
{
	include_weapons();
	include_powerups();
	include_equipment_for_level();
	clientscripts\mp\zombies\_zm::init();
	init_level_specific_wall_buy_fx();
	registerclientfield("world", "buried_sq_maxis_eye_glow_override", 12000, 1, "int", ::buried_sq_maxis_eye_glow_override, 1);
	registerclientfield("allplayers", "buried_sq_richtofen_player_eyes_stuhlinger", 12000, 1, "int", ::buried_sq_richtofen_player_eyes_stuhlinger, 0);
	registerclientfield("allplayers", "phd_flopper_effects", 12000, 1, "int", ::buried_phd_flopper_effects, 0);

	clientscripts\mp\zombies\_zm_weap_time_bomb::init_time_bomb();

	clientscripts\mp\zombies\_zm_weap_cymbal_monkey::init();
	clientscripts\mp\zombies\_zm_weap_tazer_knuckles::init();
	clientscripts\mp\zombies\_zm_weap_slowgun::init();

	if (getdvar("createfx") != "")
	{
		return;
	}

	if (level.scr_zm_ui_gametype == "zclassic")
	{
		clientscripts\mp\zombies\_zm_ai_ghost::init_animtree();
		clientscripts\mp\zombies\_zm_equip_turbine::init();
		clientscripts\mp\zombies\_zm_equip_turbine::init_animtree();
		clientscripts\mp\zombies\_zm_equip_springpad::init_animtree();
		clientscripts\mp\zombies\_zm_equip_subwoofer::init();
		clientscripts\mp\zombies\_zm_equip_subwoofer::init_animtree();
		clientscripts\mp\zombies\_zm_equip_headchopper::init_animtree();
	}
	else if (level.scr_zm_map_start_location == "street")
	{
		clientscripts\mp\zombies\_zm_equip_turbine::init();
		clientscripts\mp\zombies\_zm_equip_turbine::init_animtree();
		clientscripts\mp\zombies\_zm_equip_springpad::init_animtree();
		clientscripts\mp\zombies\_zm_equip_subwoofer::init();
		clientscripts\mp\zombies\_zm_equip_subwoofer::init_animtree();
		clientscripts\mp\zombies\_zm_equip_headchopper::init_animtree();
	}
}