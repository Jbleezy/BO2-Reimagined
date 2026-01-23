#include maps\mp\zm_alcatraz_gamemodes;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zm_prison;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\zm_alcatraz_classic;

init()
{
	level.custom_vending_precaching = maps\mp\zm_prison::custom_vending_precaching;

	add_map_gamemode("zclassic", maps\mp\zm_prison::zclassic_preinit, undefined, undefined);
	add_map_gamemode("zstandard", ::zstandard_preinit, undefined, undefined);
	add_map_gamemode("zgrief", maps\mp\zm_alcatraz_grief_cellblock::zgrief_preinit, undefined, undefined);

	add_map_location_gamemode("zclassic", "prison", maps\mp\zm_alcatraz_classic::precache, maps\mp\zm_alcatraz_classic::main);

	add_map_location_gamemode("zstandard", "cellblock", maps\mp\zm_alcatraz_grief_cellblock::precache, maps\mp\zm_alcatraz_grief_cellblock::main);
	add_map_location_gamemode("zstandard", "docks", scripts\zm\locs\zm_prison_loc_docks::precache, scripts\zm\locs\zm_prison_loc_docks::main);

	add_map_location_gamemode("zgrief", "cellblock", maps\mp\zm_alcatraz_grief_cellblock::precache, maps\mp\zm_alcatraz_grief_cellblock::main);
	add_map_location_gamemode("zgrief", "docks", scripts\zm\locs\zm_prison_loc_docks::precache, scripts\zm\locs\zm_prison_loc_docks::main);

	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zstandard", "docks", scripts\zm\locs\zm_prison_loc_docks::struct_init);
	scripts\zm\replaced\utility::add_struct_location_gamemode_func("zgrief", "docks", scripts\zm\locs\zm_prison_loc_docks::struct_init);
}

zstandard_preinit()
{
	level.force_team_characters = 1;
	level.should_use_cia = 0;

	if (randomint(100) >= 50)
	{
		level.should_use_cia = 1;
	}

	level.givecustomloadout = maps\mp\zm_prison::givecustomloadout;
	level.precachecustomcharacters = ::precache_team_characters;
	level.givecustomcharacters = ::give_team_characters;
	level.gamemode_post_spawn_logic = ::give_player_shiv;

	flag_wait("start_zombie_round_logic");
}

give_team_characters()
{
	self detachall();
	self set_player_is_female(0);

	if (isdefined(level.should_use_cia))
	{
		if (level.should_use_cia)
		{
			self setmodel("c_zom_player_grief_inmate_fb");
			self setviewmodel("c_zom_oleary_shortsleeve_viewhands");
			self.characterindex = 0;
		}
		else
		{
			self setmodel("c_zom_player_grief_guard_fb");
			self setviewmodel("c_zom_grief_guard_viewhands");
			self.characterindex = 1;
		}
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}