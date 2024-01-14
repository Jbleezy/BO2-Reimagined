#include clientscripts\mp\zm_nuked;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zm_nuked_ffotd;
#include clientscripts\mp\zm_nuked_fx;
#include clientscripts\mp\zm_nuked_amb;
#include clientscripts\mp\zm_nuked_standard;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_sticky_grenade;
#include clientscripts\mp\zombies\_zm_weap_cymbal_monkey;
#include clientscripts\mp\zombies\_zm_weap_tazer_knuckles;

init_gamemodes()
{
	add_map_gamemode("zstandard", undefined, undefined);
	add_map_gamemode("zgrief", undefined, undefined);

	add_map_location_gamemode("zstandard", "nuked", clientscripts\mp\zm_nuked_standard::precache, undefined, clientscripts\mp\zm_nuked_standard::main);
	add_map_location_gamemode("zgrief", "nuked", clientscripts\mp\zm_nuked_standard::precache, undefined, clientscripts\mp\zm_nuked_standard::main);
}