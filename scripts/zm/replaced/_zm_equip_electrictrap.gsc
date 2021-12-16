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
	if ( !isDefined( self.electrictrap_health ) )
	{
		self.electrictrap_health = 60;
	}
	if ( isDefined( weapon ) )
	{
		weapon trap_power_on();
		if ( !weapon.power_on )
		{
			self iprintlnbold( &"ZOMBIE_NEED_LOCAL_POWER" );
		}
		self thread maps/mp/zombies/_zm_equip_electrictrap::electrictrapthink( weapon, electricradius );
		self thread maps/mp/zombies/_zm_equip_electrictrap::electrictrapdecay( weapon );
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

trap_power_on()
{
	self.power_on = 1;
	self.power_on_time = getTime() - 2000; // activates the trap right away
	self notify( "stop_attracting_zombies" );
	if ( !isDefined( level.electrap_sound_ent ) )
	{
		level.electrap_sound_ent = spawn( "script_origin", self.origin );
	}
	level.electrap_sound_ent playsound( "wpn_zmb_electrap_start" );
	level.electrap_sound_ent playloopsound( "wpn_zmb_electrap_loop", 2 );
	self thread maps/mp/zombies/_zm_equip_electrictrap::trapfx();
}

electrictrapthink( weapon, electricradius )
{
	weapon endon( "death" );
	radiussquared = electricradius * electricradius;
	while ( isDefined( weapon ) )
	{
		if ( weapon.power_on )
		{
			zombies = getaiarray( level.zombie_team );
			_a354 = zombies;
			_k354 = getFirstArrayKey( _a354 );
			while ( isDefined( _k354 ) )
			{
				zombie = _a354[ _k354 ];
				if ( isDefined( zombie ) && isalive( zombie ) )
				{
					if ( isDefined( zombie.ignore_electric_trap ) && zombie.ignore_electric_trap )
					{
						break;
					}
					else
					{
						if ( distancesquared( weapon.origin, zombie.origin ) < radiussquared )
						{
							weapon maps/mp/zombies/_zm_equip_electrictrap::zap_zombie( zombie );
							wait 0.15;
						}
						maps/mp/zombies/_zm_equip_electrictrap::etrap_choke();
					}
				}
				_k354 = getNextArrayKey( _a354, _k354 );
			}
			players = get_players();
			_a373 = players;
			_k373 = getFirstArrayKey( _a373 );
			while ( isDefined( _k373 ) )
			{
				player = _a373[ _k373 ];
				if ( is_player_valid( player ) && distancesquared( weapon.origin, player.origin ) < radiussquared )
				{
					player thread maps/mp/zombies/_zm_traps::player_elec_damage();
					maps/mp/zombies/_zm_equip_electrictrap::etrap_choke();
				}
				maps/mp/zombies/_zm_equip_electrictrap::etrap_choke();
				_k373 = getNextArrayKey( _a373, _k373 );
			}
		}
		wait 0.1;
	}
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