#include clientscripts\mp\zm_transit;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zm_transit_classic;
#include clientscripts\mp\zm_transit_standard_station;
#include clientscripts\mp\zm_transit_standard_farm;
#include clientscripts\mp\zm_transit_standard_town;
#include clientscripts\mp\zm_transit_grief_station;
#include clientscripts\mp\zm_transit_grief_farm;
#include clientscripts\mp\zm_transit_grief_town;
#include clientscripts\mp\zm_transit_ffotd;
#include clientscripts\mp\zm_transit_bus;
#include clientscripts\mp\zm_transit_automaton;
#include clientscripts\mp\zombies\_zm_equip_turbine;
#include clientscripts\mp\zm_transit_fx;
#include clientscripts\mp\zm_transit_amb;
#include clientscripts\mp\zm_transit_gump;
#include clientscripts\mp\_teamset_cdc;
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_morsecode;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_zm_weap_tazer_knuckles;
#include clientscripts\mp\zombies\_zm_weap_riotshield;
#include clientscripts\mp\zombies\_zm_weap_cymbal_monkey;
#include clientscripts\mp\zombies\_zm_weap_jetgun;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zombies\_zm_equipment;

start_zombie_stuff()
{
	level._uses_crossbow = 1;
	level.raygun2_included = 1;
	include_weapons();
	include_powerups();
	include_equipment_for_level();
	clientscripts\mp\zombies\_zm::init();
	clientscripts\mp\zombies\_zm_weap_tazer_knuckles::init();
	clientscripts\mp\zombies\_zm_weap_riotshield::init();
	level.legacy_cymbal_monkey = 1;
	clientscripts\mp\zombies\_zm_weap_cymbal_monkey::init();
	clientscripts\mp\zombies\_zm_weap_jetgun::init();
	clientscripts\mp\_visionset_mgr::vsmgr_register_overlay_info_style_burn("zm_transit_burn", 1, 15, 2);
	init_level_specific_wall_buy_fx();
}

init_level_specific_wall_buy_fx()
{
	level._effect["an94_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_an94");
	level._effect["pdw57_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_pdw57");
}