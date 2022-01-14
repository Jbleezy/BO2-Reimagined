#include maps/mp/zm_transit_grief_town;
#include maps/mp/zm_transit_grief_farm;
#include maps/mp/zm_transit_grief_station;
#include maps/mp/zm_transit_standard_town;
#include maps/mp/zm_transit_standard_farm;
#include maps/mp/zm_transit_standard_station;
#include maps/mp/zm_transit_classic;
#include maps/mp/zm_transit;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/zm_transit_utility;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/_utility;
#include common_scripts/utility;

#include scripts/zm/locs/zm_transit_diner;
#include scripts/zm/locs/zm_transit_power;

init()
{
	add_map_gamemode( "zclassic", maps/mp/zm_transit::zclassic_preinit, undefined, undefined );
	add_map_gamemode( "zgrief", maps/mp/zm_transit::zgrief_preinit, undefined, undefined );
	add_map_gamemode( "zstandard", maps/mp/zm_transit::zstandard_preinit, undefined, undefined );

	add_map_location_gamemode( "zclassic", "transit", maps/mp/zm_transit_classic::precache, maps/mp/zm_transit_classic::main );

	add_map_location_gamemode( "zstandard", "transit", maps/mp/zm_transit_standard_station::precache, maps/mp/zm_transit_standard_station::main );
	add_map_location_gamemode( "zstandard", "farm", maps/mp/zm_transit_standard_farm::precache, maps/mp/zm_transit_standard_farm::main );
	add_map_location_gamemode( "zstandard", "town", maps/mp/zm_transit_standard_town::precache, maps/mp/zm_transit_standard_town::main );
    add_map_location_gamemode( "zstandard", "diner", scripts/zm/locs/zm_transit_diner::precache, scripts/zm/locs/zm_transit_diner::main );
	add_map_location_gamemode( "zstandard", "power", scripts/zm/locs/zm_transit_power::precache, scripts/zm/locs/zm_transit_power::main );

	add_map_location_gamemode( "zgrief", "transit", maps/mp/zm_transit_grief_station::precache, maps/mp/zm_transit_grief_station::main );
	add_map_location_gamemode( "zgrief", "farm", maps/mp/zm_transit_grief_farm::precache, maps/mp/zm_transit_grief_farm::main );
	add_map_location_gamemode( "zgrief", "town", maps/mp/zm_transit_grief_town::precache, maps/mp/zm_transit_grief_town::main );
    add_map_location_gamemode( "zgrief", "diner", scripts/zm/locs/zm_transit_diner::precache, scripts/zm/locs/zm_transit_diner::main );
	add_map_location_gamemode( "zgrief", "power", scripts/zm/locs/zm_transit_power::precache, scripts/zm/locs/zm_transit_power::main );

    scripts/zm/replaced/utility::add_struct_location_gamemode_func( "zstandard", "diner", scripts/zm/locs/zm_transit_diner::struct_init );
    scripts/zm/replaced/utility::add_struct_location_gamemode_func( "zgrief", "diner", scripts/zm/locs/zm_transit_diner::struct_init );
	scripts/zm/replaced/utility::add_struct_location_gamemode_func( "zstandard", "power", scripts/zm/locs/zm_transit_power::struct_init );
    scripts/zm/replaced/utility::add_struct_location_gamemode_func( "zgrief", "power", scripts/zm/locs/zm_transit_power::struct_init );
}