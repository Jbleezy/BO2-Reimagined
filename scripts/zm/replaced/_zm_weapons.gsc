#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

lethal_grenade_update_prompt( player )
{
	weapon = self.stub.zombie_weapon_upgrade;
	hint = level.zombie_weapons[weapon].hint;
	self.stub.hint_string = hint;
	self sethintstring( self.stub.hint_string, cost );
	self.stub.cursor_hint = "HINT_WEAPON";
	self.stub.cursor_hint_weapon = weapon;
	self setcursorhint( self.stub.cursor_hint, self.stub.cursor_hint_weapon );
	return 1;
}

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