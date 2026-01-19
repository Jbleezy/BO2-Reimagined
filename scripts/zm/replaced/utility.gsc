#include common_scripts\utility;
#include maps\mp\zombies\_load;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;

struct_class_init()
{
	level.struct_class_names = [];
	level.struct_class_names["target"] = [];
	level.struct_class_names["targetname"] = [];
	level.struct_class_names["script_noteworthy"] = [];
	level.struct_class_names["script_linkname"] = [];
	level.struct_class_names["script_unitrigger_type"] = [];

	foreach (s_struct in level.struct)
	{
		if (isDefined(s_struct.targetname))
		{
			if (!isDefined(level.struct_class_names["targetname"][s_struct.targetname]))
			{
				level.struct_class_names["targetname"][s_struct.targetname] = [];
			}

			size = level.struct_class_names["targetname"][s_struct.targetname].size;
			level.struct_class_names["targetname"][s_struct.targetname][size] = s_struct;
		}

		if (isDefined(s_struct.target))
		{
			if (!isDefined(level.struct_class_names["target"][s_struct.target]))
			{
				level.struct_class_names["target"][s_struct.target] = [];
			}

			size = level.struct_class_names["target"][s_struct.target].size;
			level.struct_class_names["target"][s_struct.target][size] = s_struct;
		}

		if (isDefined(s_struct.script_noteworthy))
		{
			if (!isDefined(level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy]))
			{
				level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy] = [];
			}

			size = level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy].size;
			level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy][size] = s_struct;
		}

		if (isDefined(s_struct.script_linkname))
		{
			level.struct_class_names["script_linkname"][s_struct.script_linkname][0] = s_struct;
		}

		if (isDefined(s_struct.script_unitrigger_type))
		{
			if (!isDefined(level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type]))
			{
				level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type] = [];
			}

			size = level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type].size;
			level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type][size] = s_struct;
		}
	}

	gametype = getDvar("g_gametype");
	location = getDvar("ui_zm_mapstartlocation");

	if (is_encounter())
	{
		gametype = "zgrief";
	}

	if (array_validate(level.add_struct_gamemode_location_funcs))
	{
		if (array_validate(level.add_struct_gamemode_location_funcs[gametype]))
		{
			if (array_validate(level.add_struct_gamemode_location_funcs[gametype][location]))
			{
				for (i = 0; i < level.add_struct_gamemode_location_funcs[gametype][location].size; i++)
				{
					[[level.add_struct_gamemode_location_funcs[gametype][location][i]]]();
				}
			}
		}
	}
}

add_struct(s_struct)
{
	if (isDefined(s_struct.targetname))
	{
		if (!isDefined(level.struct_class_names["targetname"][s_struct.targetname]))
		{
			level.struct_class_names["targetname"][s_struct.targetname] = [];
		}

		size = level.struct_class_names["targetname"][s_struct.targetname].size;
		level.struct_class_names["targetname"][s_struct.targetname][size] = s_struct;
	}

	if (isDefined(s_struct.script_noteworthy))
	{
		if (!isDefined(level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy]))
		{
			level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy] = [];
		}

		size = level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy].size;
		level.struct_class_names["script_noteworthy"][s_struct.script_noteworthy][size] = s_struct;
	}

	if (isDefined(s_struct.target))
	{
		if (!isDefined(level.struct_class_names["target"][s_struct.target]))
		{
			level.struct_class_names["target"][s_struct.target] = [];
		}

		size = level.struct_class_names["target"][s_struct.target].size;
		level.struct_class_names["target"][s_struct.target][size] = s_struct;
	}

	if (isDefined(s_struct.script_linkname))
	{
		level.struct_class_names["script_linkname"][s_struct.script_linkname][0] = s_struct;
	}

	if (isDefined(s_struct.script_unitrigger_type))
	{
		if (!isDefined(level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type]))
		{
			level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type] = [];
		}

		size = level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type].size;
		level.struct_class_names["script_unitrigger_type"][s_struct.script_unitrigger_type][size] = s_struct;
	}
}

register_perk_struct(name, model, origin, angles)
{
	perk_struct = spawnStruct();
	perk_struct.targetname = "zm_perk_machine";
	perk_struct.origin = origin;
	perk_struct.angles = angles;
	perk_struct.script_noteworthy = name;
	perk_struct.model = model;

	if (name == "specialty_weapupgrade")
	{
		flag_struct = spawnStruct();
		flag_struct.targetname = "weapupgrade_flag_targ";
		flag_struct.origin = origin + (anglesToForward(angles) * 29) + (anglesToRight(angles) * -13.5) + (anglesToUp(angles) * 49.5);
		flag_struct.angles = angles + (0, 180, 180);
		flag_struct.model = "zombie_sign_please_wait";
		perk_struct.target = flag_struct.targetname;

		add_struct(flag_struct);
	}

	add_struct(perk_struct);
}

register_map_spawn_group(origin, zone, dist)
{
	gametype = getDvar("g_gametype");
	location = getDvar("ui_zm_mapstartlocation");

	if (is_encounter())
	{
		gametype = "zgrief";
	}

	spawn_group_struct = spawnStruct();
	spawn_group_struct.targetname = "player_respawn_point";
	spawn_group_struct.origin = origin;
	spawn_group_struct.locked = !zone_is_enabled(zone);
	spawn_group_struct.script_int = dist;
	spawn_group_struct.script_noteworthy = zone;
	spawn_group_struct.script_string = gametype + "_" + location;
	spawn_group_struct.target = zone + "_player_spawns";

	add_struct(spawn_group_struct);
}

register_map_spawn(origin, angles, zone, team_num)
{
	gametype = getDvar("g_gametype");
	location = getDvar("ui_zm_mapstartlocation");

	if (is_encounter())
	{
		gametype = "zgrief";
	}

	spawn_struct = spawnStruct();
	spawn_struct.targetname = zone + "_player_spawns";
	spawn_struct.origin = origin;
	spawn_struct.angles = angles;
	spawn_struct.script_string = gametype + "_" + location;

	if (isDefined(team_num))
	{
		spawn_struct.script_noteworthy = "initial_spawn";
		spawn_struct.script_int = team_num;
	}

	add_struct(spawn_struct);
}

add_struct_location_gamemode_func(gametype, location, func)
{
	if (!isDefined(level.add_struct_gamemode_location_funcs))
	{
		level.add_struct_gamemode_location_funcs = [];
	}

	if (!isDefined(level.add_struct_gamemode_location_funcs[gametype]))
	{
		level.add_struct_gamemode_location_funcs[gametype] = [];
	}

	if (!isDefined(level.add_struct_gamemode_location_funcs[gametype][location]))
	{
		level.add_struct_gamemode_location_funcs[gametype][location] = [];
	}

	level.add_struct_gamemode_location_funcs[gametype][location][level.add_struct_gamemode_location_funcs[gametype][location].size] = func;
}