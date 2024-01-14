#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zm_nuked;
#include maps\mp\zm_nuked_standard;

init()
{
	add_map_gamemode("zstandard", maps\mp\zm_nuked::zstandard_preinit, undefined, undefined);
	add_map_gamemode("zgrief", ::zgrief_preinit, undefined, undefined);

	add_map_location_gamemode("zstandard", "nuked", maps\mp\zm_nuked_standard::precache, maps\mp\zm_nuked_standard::main);
	add_map_location_gamemode("zgrief", "nuked", maps\mp\zm_nuked_standard::precache, maps\mp\zm_nuked_standard::main);
}

zgrief_preinit()
{
	registerclientfield("toplayer", "meat_stink", 1, 1, "int");
}