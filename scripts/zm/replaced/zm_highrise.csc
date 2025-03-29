#include clientscripts\mp\zm_highrise;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_filter;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zm_highrise_ffotd;
#include clientscripts\mp\zm_highrise_classic;
#include clientscripts\mp\zm_highrise_fx;
#include clientscripts\mp\zm_highrise_amb;
#include clientscripts\mp\zombies\_zm_perks;
#include clientscripts\mp\zm_highrise_sq;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_sticky_grenade;
#include clientscripts\mp\zombies\_zm_weap_cymbal_monkey;
#include clientscripts\mp\zombies\_zm_weap_slipgun;
#include clientscripts\mp\zombies\_zm_weap_tazer_knuckles;
#include clientscripts\mp\zombies\_zm_equip_springpad;
#include clientscripts\mp\_fx;

init_gamemodes()
{
	add_map_gamemode("zclassic", undefined, undefined);
	add_map_gamemode("zstandard", undefined, undefined);
	add_map_gamemode("zgrief", undefined, undefined);

	add_map_location_gamemode("zclassic", "rooftop", clientscripts\mp\zm_highrise_classic::precache, clientscripts\mp\zm_highrise_classic::premain, clientscripts\mp\zm_highrise_classic::main);
}