#include maps\mp\zombies\_zm_perks;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

precache()
{
	precachemodel( "zm_collision_transit_busdepot_survival" );
}

station_treasure_chest_init()
{
	chest1 = getstruct( "depot_chest", "script_noteworthy" );
	level.chests = [];
	level.chests[ level.chests.size ] = chest1;
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( "depot_chest" );
}

main()
{
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects( "station" );
	station_treasure_chest_init();
	level.enemy_location_override_func = ::enemy_location_override;
	//collision = spawn( "script_model", ( -6896, 4744, 0 ), 1 );
	//collision setmodel( "zm_collision_transit_busdepot_survival" );
	//collision disconnectpaths();
	remove_lava_collision();
	flag_wait( "initial_blackscreen_passed" );
	level thread maps\mp\zombies\_zm_perks::perk_machine_removal( "specialty_quickrevive", "p_glo_tools_chest_tall" );
	flag_set( "power_on" );
	level setclientfield( "zombie_power_on", 1 );
	level thread open_electric_doors_on_door_opened();

	// electric doors showing hintstring
	zombie_doors = getentarray( "zombie_door", "targetname" );

	foreach ( door in zombie_doors )
	{
		if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
		{
			door trigger_off();
		}
	}
}

enemy_location_override( zombie, enemy )
{
	location = enemy.origin;

	if ( is_true( self.reroute ) )
	{
		if ( isDefined( self.reroute_origin ) )
		{
			location = self.reroute_origin;
		}
	}

	return location;
}

remove_lava_collision()
{
	ents = getEntArray( "script_model", "classname");

	foreach (ent in ents)
	{
		if (IsDefined(ent.model))
		{
			if (ent.model == "zm_collision_transit_busdepot_survival")
			{
				ent delete();
			}
			else if (ent.model == "veh_t6_civ_smallwagon_dead" && ent.origin[0] == -6663.96 && ent.origin[1] == 4816.34)
			{
				ent delete();
			}
			else if (ent.model == "veh_t6_civ_microbus_dead" && ent.origin[0] == -6807.05 && ent.origin[1] == 4765.23)
			{
				ent delete();
			}
			else if (ent.model == "veh_t6_civ_movingtrk_cab_dead" && ent.origin[0] == -6652.9 && ent.origin[1] == 4767.7)
			{
				ent delete();
			}
			else if (ent.model == "p6_zm_rocks_small_cluster_01")
			{
				ent delete();
			}
		}
	}

	// spawn in new map edge collisions
	// the lava collision and the map edge collisions are all the same entity
	collision1 = spawn( "script_model", ( -5898, 4653, 0 ) );
	collision1.angles = (0, 55, 0);
	collision1 setmodel( "collision_wall_512x512x10_standard" );
	collision2 = spawn( "script_model", ( -8062, 4700, 0 ) );
	collision2.angles = (0, 70, 0);
	collision2 setmodel( "collision_wall_512x512x10_standard" );
	collision3 = spawn( "script_model", ( -7881, 5200, 0 ) );
	collision3.angles = (0, 70, 0);
	collision3 setmodel( "collision_wall_512x512x10_standard" );
}

open_electric_doors_on_door_opened()
{
	level.local_doors_stay_open = 1;
	door = undefined;
	zombie_doors = getentarray( "zombie_door", "targetname" );

	foreach ( door in zombie_doors )
	{
		if(door.target == "busstop_doors")
		{
			break;
		}
	}

	door waittill( "door_opened" );

	zombie_doors = getentarray( "zombie_door", "targetname" );

	foreach ( door in zombie_doors )
	{
		if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
		{
			door notify( "local_power_on" );
		}
	}
}