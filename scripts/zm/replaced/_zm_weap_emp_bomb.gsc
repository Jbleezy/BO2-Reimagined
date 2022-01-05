#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

emp_detonate(grenade)
{
	grenade_owner = undefined;

	if ( isDefined( grenade.owner ) )
	{
		grenade_owner = grenade.owner;
	}

	grenade waittill( "explode", grenade_origin );

	emp_radius = level.zombie_vars[ "emp_perk_off_range" ];
	emp_time = level.zombie_vars[ "emp_perk_off_time" ];
	origin = grenade_origin;

	if ( !isDefined( origin ) )
	{
		return;
	}

	level notify( "emp_detonate", origin, emp_radius );
	self thread maps/mp/zombies/_zm_weap_emp_bomb::emp_detonate_zombies( grenade_origin, grenade_owner );

	if ( isDefined( level.custom_emp_detonate ) )
	{
		thread [[ level.custom_emp_detonate ]]( grenade_origin );
	}

	if ( isDefined( grenade_owner ) )
	{
		grenade_owner thread maps/mp/zombies/_zm_weap_emp_bomb::destroyequipment( origin, emp_radius );
	}

	emp_players( origin, emp_radius, grenade_owner );
	disabled_list = maps/mp/zombies/_zm_power::change_power_in_radius( -1, origin, emp_radius );

	wait emp_time;

	maps/mp/zombies/_zm_power::revert_power_to_list( 1, origin, emp_radius, disabled_list );
}

emp_players(origin, radius, owner)
{
	rsquared = radius * radius;
	players = get_players();
	foreach(player in players)
	{
		if (player maps/mp/zombies/_zm_laststand::player_is_in_laststand() && distancesquared(origin, player.origin) < rsquared)
		{
			player.bleedout_time = 0;
		}
	}
}