#include maps\mp\zm_tomb_gamemodes;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zm_tomb;
#include maps\mp\zm_tomb_classic;

init()
{
	add_map_gamemode("zclassic", maps\mp\zm_tomb::zstandard_preinit, undefined, undefined);
	add_map_gamemode("zstandard", ::zstandard_preinit, undefined, undefined);
	add_map_gamemode("zgrief", ::zstandard_preinit, undefined, undefined);

	add_map_location_gamemode("zclassic", "tomb", maps\mp\zm_tomb_classic::precache, maps\mp\zm_tomb_classic::main);

	add_map_location_gamemode("zstandard", "trenches", scripts\zm\locs\zm_tomb_loc_trenches::precache, scripts\zm\locs\zm_tomb_loc_trenches::main);
	add_map_location_gamemode("zstandard", "excavation_site", scripts\zm\locs\zm_tomb_loc_excavation_site::precache, scripts\zm\locs\zm_tomb_loc_excavation_site::main);

	add_map_location_gamemode("zgrief", "trenches", scripts\zm\locs\zm_tomb_loc_trenches::precache, scripts\zm\locs\zm_tomb_loc_trenches::main);
	add_map_location_gamemode("zgrief", "excavation_site", scripts\zm\locs\zm_tomb_loc_excavation_site::precache, scripts\zm\locs\zm_tomb_loc_excavation_site::main);

	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "trenches", scripts\zm\locs\zm_tomb_loc_trenches::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "trenches", scripts\zm\locs\zm_tomb_loc_trenches::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "excavation_site", scripts\zm\locs\zm_tomb_loc_excavation_site::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "excavation_site", scripts\zm\locs\zm_tomb_loc_excavation_site::struct_init);
}

zstandard_preinit()
{
	survival_init();
}

survival_init()
{
	level.force_team_characters = 1;

	if (is_gametype_active("zstandard"))
	{
		level.should_use_cia = 0;

		if (randomint(100) > 50)
		{
			level.should_use_cia = 1;
		}
	}
}