#include maps\mp\zm_buried_gamemodes;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_buried;
#include maps\mp\zm_buried_classic;
#include maps\mp\zm_buried_turned_street;
#include maps\mp\zm_buried_grief_street;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_unitrigger;

init()
{
	add_map_gamemode("zclassic", maps\mp\zm_buried::zclassic_preinit, undefined, undefined);
	add_map_gamemode("zstandard", ::zstandard_preinit, undefined, undefined);
	add_map_gamemode("zgrief", maps\mp\zm_buried::zgrief_preinit, undefined, undefined);
	add_map_gamemode("zcleansed", maps\mp\zm_buried::zcleansed_preinit, undefined, undefined);

	add_map_location_gamemode("zclassic", "processing", maps\mp\zm_buried_classic::precache, maps\mp\zm_buried_classic::main);

	add_map_location_gamemode("zstandard", "street", maps\mp\zm_buried_grief_street::precache, maps\mp\zm_buried_grief_street::main);
	add_map_location_gamemode("zstandard", "maze", scripts\zm\locs\zm_buried_loc_maze::precache, scripts\zm\locs\zm_buried_loc_maze::main);

	add_map_location_gamemode("zgrief", "street", maps\mp\zm_buried_grief_street::precache, maps\mp\zm_buried_grief_street::main);
	add_map_location_gamemode("zgrief", "maze", scripts\zm\locs\zm_buried_loc_maze::precache, scripts\zm\locs\zm_buried_loc_maze::main);

	add_map_location_gamemode("zcleansed", "street", maps\mp\zm_buried_turned_street::precache, maps\mp\zm_buried_turned_street::main);

	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "maze", scripts\zm\locs\zm_buried_loc_maze::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "maze", scripts\zm\locs\zm_buried_loc_maze::struct_init);
}

zstandard_preinit()
{
	survival_init();
}

survival_init()
{
	level.force_team_characters = 1;
	level.should_use_cia = 0;

	if (randomint(100) >= 50)
	{
		level.should_use_cia = 1;
	}

	level.precachecustomcharacters = ::precache_team_characters;
	level.givecustomcharacters = ::give_team_characters;
	zm_buried_common_init();
	flag_wait("start_zombie_round_logic");
	trig_removal = getentarray("zombie_door", "targetname");

	foreach (trig in trig_removal)
	{
		if (isdefined(trig.script_parameters) && trig.script_parameters == "grief_remove")
		{
			trig delete();
		}
	}
}

buildbuildable(buildable)
{
	player = get_players()[0];

	foreach (stub in level.buildable_stubs)
	{
		if (!isdefined(buildable) || stub.equipname == buildable)
		{
			if (isdefined(buildable) || stub.persistent != 3)
			{
				stub maps\mp\zombies\_zm_buildables::buildablestub_finish_build(player);
				stub maps\mp\zombies\_zm_buildables::buildablestub_remove();

				foreach (piece in stub.buildablezone.pieces)
				{
					piece maps\mp\zombies\_zm_buildables::piece_unspawn();
				}

				stub.model notsolid();
				stub.model show();

				stub.buildablezone scripts\zm\replaced\_zm_buildables::buildable_adjust_model_origin();

				return;
			}
		}
	}
}

builddynamicwallbuy(location, weaponname)
{
	gametype = level.scr_zm_ui_gametype;

	if (is_encounter())
	{
		gametype = "zgrief";
	}

	match_string = gametype + "_" + level.scr_zm_map_start_location;

	foreach (stub in level.chalk_builds)
	{
		wallbuy = getstruct(stub.target, "targetname");

		if (isdefined(wallbuy.script_location) && wallbuy.script_location == location)
		{
			if (!isdefined(wallbuy.script_noteworthy) || issubstr(wallbuy.script_noteworthy, match_string))
			{
				maps\mp\zombies\_zm_weapons::add_dynamic_wallbuy(weaponname, wallbuy.targetname, 1);
				thread wait_and_remove(stub, stub.buildablezone.pieces[0]);
			}
		}
	}
}