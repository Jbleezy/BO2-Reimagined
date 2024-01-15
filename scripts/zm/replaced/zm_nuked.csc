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

main()
{
	level thread clientscripts\mp\zm_nuked_ffotd::main_start();
	level.default_start_location = "nuked";
	level.default_game_mode = "zstandard";
	level._no_water_risers = 1;
	level.zombiemode_using_doubletap_perk = 1;
	level.zombiemode_using_juggernaut_perk = 1;
	level.zombiemode_using_revive_perk = 1;
	level.zombiemode_using_sleightofhand_perk = 1;
	level.zombiemode_using_perk_intro_fx = 1;
	level.riser_fx_on_client = 1;
	start_zombie_stuff();
	init_gamemodes();
	thread clientscripts\mp\zm_nuked_fx::main();
	thread clientscripts\mp\zm_nuked_amb::main();
	setsaveddvar("sm_sunsamplesizenear", 0.25);
	zombe_gametype_premain();
	level thread clientscripts\mp\zm_nuked_ffotd::main_end();
	waitforclient(0);
	level thread init_fog_vol_to_visionset();
	level thread intermission_settings();
}

init_gamemodes()
{
	add_map_gamemode("zstandard", undefined, undefined);
	add_map_gamemode("zgrief", undefined, undefined);

	add_map_location_gamemode("zstandard", "nuked", clientscripts\mp\zm_nuked_standard::precache, undefined, clientscripts\mp\zm_nuked_standard::main);
	add_map_location_gamemode("zgrief", "nuked", clientscripts\mp\zm_nuked_standard::precache, undefined, clientscripts\mp\zm_nuked_standard::main);
}