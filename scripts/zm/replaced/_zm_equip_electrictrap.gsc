#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

startelectrictrapdeploy( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_electrictrap_zm_taken" );

	self thread maps/mp/zombies/_zm_equip_electrictrap::watchforcleanup();
	electricradius = 45;
	self.weapon = weapon;

	if ( !isDefined( self.electrictrap_health ) )
	{
		self.electrictrap_health = 30;
	}

	if ( isDefined( weapon ) )
	{
		wait 0.5;

		self trap_power_on( weapon );
		self thread maps/mp/zombies/_zm_equip_electrictrap::electrictrapthink( weapon, electricradius );
		self thread electrictrapdecay( weapon );
		self thread maps/mp/zombies/_zm_buildables::delete_on_disconnect( weapon );

		weapon waittill( "death" );

		if ( isDefined( level.electrap_sound_ent ) )
		{
			level.electrap_sound_ent playsound( "wpn_zmb_electrap_stop" );
			level.electrap_sound_ent delete();
			level.electrap_sound_ent = undefined;
		}

		self notify( "etrap_cleanup" );
	}
}

trap_power_on( weapon )
{
	weapon.power_on = 1;
	weapon.power_on_time = getTime() - 2000; // ::electrictrapthink doesn't start until after 2 seconds
	weapon notify( "stop_attracting_zombies" );

	if ( !isDefined( level.electrap_sound_ent ) )
	{
		level.electrap_sound_ent = spawn( "script_origin", weapon.origin );
	}

	level.electrap_sound_ent playsound( "wpn_zmb_electrap_start" );
	level.electrap_sound_ent playloopsound( "wpn_zmb_electrap_loop", 2 );
	weapon thread maps/mp/zombies/_zm_equip_electrictrap::trapfx();
}

electrictrapdecay( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_electrictrap_zm_taken" );

	while ( isDefined( weapon ) )
	{
		if ( weapon.power_on )
		{
			self.electrictrap_health--;

			if ( self.electrictrap_health <= 0 )
			{
				maps/mp/zombies/_zm_equipment::equipment_disappear_fx( weapon.origin, undefined, weapon.angles );
				self maps/mp/zombies/_zm_equip_electrictrap::cleanupoldtrap();
				self.electrictrap_health = undefined;
				self thread maps/mp/zombies/_zm_equipment::equipment_release( level.electrictrap_name );

				return;
			}
		}

		wait 1;
	}
}

cleanupoldtrap()
{
	if ( isDefined( self.buildableelectrictrap ) )
	{
		if ( isDefined( self.buildableelectrictrap.stub ) )
		{
			thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.buildableelectrictrap.stub );
			self.buildableelectrictrap.stub = undefined;
		}
		self.buildableelectrictrap delete();
		self.electrictrap_health = undefined;
	}
	if ( isDefined( level.electrap_sound_ent ) )
	{
		level.electrap_sound_ent delete();
		level.electrap_sound_ent = undefined;
	}
}

etrap_choke()
{
	// no choke
}