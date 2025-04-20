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