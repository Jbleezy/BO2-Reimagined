#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

lava_damage_depot()
{
	trigs = getentarray( "lava_damage", "targetname" );
	volume = getent( "depot_lava_volume", "targetname" );
	exploder( 2 );

	foreach ( trigger in trigs )
	{
		if ( isDefined( trigger.script_string ) && trigger.script_string == "depot_lava" )
		{
			trig = trigger;
		}
	}

	if ( isDefined( trig ) )
	{
		trig.script_float = 0.05;
	}

	flag_wait( "power_on" );

	while ( !volume maps/mp/zm_transit::depot_lava_seen() )
	{
		wait 0.05;
	}

	if ( isDefined( trig ) )
	{
		trig.script_float = 0.4;
		earthquake( 0.5, 1.5, trig.origin, 1000 );
		level clientnotify( "earth_crack" );
		crust = getent( "depot_black_lava", "targetname" );
		crust delete();
	}

	stop_exploder( 2 );
	exploder( 3 );
}