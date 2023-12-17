#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

startturretdeploy( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_turret_zm_taken" );
	self thread maps\mp\zombies\_zm_equip_turret::watchforcleanup();

	if ( !isDefined( self.turret_health ) )
	{
		self.turret_health = 30;
	}

	if ( isDefined( weapon ) )
	{
		weapon hide();
		wait 0.1;

		if ( isDefined( weapon.power_on ) && weapon.power_on )
		{
			weapon.turret notify( "stop_burst_fire_unmanned" );
		}

		if ( !isDefined( weapon ) )
		{
			return;
		}

		if ( isDefined( self.turret ) )
		{
			self.turret notify( "stop_burst_fire_unmanned" );
			self.turret notify( "turret_deactivated" );
			self.turret delete();
		}

		turret = spawnturret( "misc_turret", weapon.origin, "zombie_bullet_crouch_zm" );
		turret.turrettype = "sentry";
		turret setturrettype( turret.turrettype );
		turret setmodel( "p6_anim_zm_buildable_turret" );
		turret.origin = weapon.origin;
		turret.angles = weapon.angles;
		turret linkto( weapon );
		turret makeunusable();
		turret.owner = self;
		turret setowner( turret.owner );
		turret maketurretunusable();
		turret setmode( "auto_nonai" );
		turret setdefaultdroppitch( 45 );
		turret setconvergencetime( 0.3 );
		turret setturretteam( self.team );
		turret.team = self.team;
		turret.damage_own_team = 0;
		turret.turret_active = 1;
		turret.script_burst_min = self.turret_health;
		turret.script_burst_max = self.turret_health;
		weapon.turret = turret;
		self.turret = turret;
		weapon turret_power_on();

		if ( weapon.power_on )
		{
			turret thread maps\mp\zombies\_zm_mgturret::burst_fire_unmanned();
		}

		self thread turretdecay( weapon );
		self thread maps\mp\zombies\_zm_buildables::delete_on_disconnect( weapon );
		weapon waittill("death");

		if ( isDefined( self.buildableturret.sound_ent ) )
		{
			self.buildableturret.sound_ent playsound( "wpn_zmb_turret_stop" );
			self.buildableturret.sound_ent delete();
			self.buildableturret.sound_ent = undefined;
		}

		if ( isDefined( turret ) )
		{
			turret notify( "stop_burst_fire_unmanned" );
			turret notify( "turret_deactivated" );
			turret delete();
		}

		self.turret = undefined;
		self notify( "turret_cleanup" );
	}
}

turret_power_on()
{
	self.power_on = 1;
	self.turret thread maps\mp\zombies\_zm_mgturret::burst_fire_unmanned();
	player = self.turret.owner;

	if ( !isDefined( player.buildableturret.sound_ent ) )
	{
		player.buildableturret.sound_ent = spawn( "script_origin", self.turret.origin );
	}

	player.buildableturret.sound_ent playsound( "wpn_zmb_turret_start" );
	player.buildableturret.sound_ent playloopsound( "wpn_zmb_turret_loop", 2 );
}

turretdecay( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_turret_zm_taken" );

	while ( isDefined( weapon ) )
	{
		if ( weapon.power_on )
		{
			self.turret_health--;

			if ( self.turret_health <= 0 )
			{
				maps\mp\zombies\_zm_equipment::equipment_disappear_fx( weapon.origin, undefined, weapon.angles );
				self maps\mp\zombies\_zm_equip_turret::cleanupoldturret();
				self thread maps\mp\zombies\_zm_equipment::equipment_release( level.turret_name );
				return;
			}
		}

		wait 1;
	}
}