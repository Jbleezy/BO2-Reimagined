#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

get_upgraded_ammo_cost( weapon_name )
{
	if ( isDefined( level.zombie_weapons[ weapon_name ].upgraded_ammo_cost ) )
	{
		return level.zombie_weapons[ weapon_name ].upgraded_ammo_cost;
	}

	return 2500;
}

makegrenadedudanddestroy()
{
	self endon( "death" );

	self notify( "grenade_dud" );
	self makegrenadedud();

	if ( isDefined( self ) )
	{
		self delete();
	}
}

createballisticknifewatcher_zm( name, weapon )
{
	watcher = self maps/mp/gametypes_zm/_weaponobjects::createuseweaponobjectwatcher( name, weapon, self.team );
	watcher.onspawn = scripts/zm/replaced/_zm_weap_ballistic_knife::on_spawn;
	watcher.onspawnretrievetriggers = maps/mp/zombies/_zm_weap_ballistic_knife::on_spawn_retrieve_trigger;
	watcher.storedifferentobject = 1;
	watcher.headicon = 0;
}