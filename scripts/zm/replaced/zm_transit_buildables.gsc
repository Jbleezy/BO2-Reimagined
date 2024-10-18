#include maps\mp\zm_transit_buildables;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;

onuseplantobject_turbine(player)
{
	check_for_buildable_turbine_vox(level.turbine_buildable, 1);
}