#include maps\mp\zombies\_zm_equip_subwoofer;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

startsubwooferdecay( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_subwoofer_zm_taken" );

	// hack to decrease max subwoofer time
	if( self.subwoofer_health > 30 )
	{
		self.subwoofer_health = 30;
	}

	fire_time = 2;

	wait fire_time + 0.05; // startup time

	while ( isDefined( weapon ) )
	{
		if ( weapon.power_on )
		{
			weapon.subwoofer_kills = 0; // hack to make subwoofer not get destroyed from kills
			self.subwoofer_health -= fire_time;

			if ( self.subwoofer_health <= 0 )
			{
				self.subwoofer_health = undefined;
				self thread subwoofer_expired( weapon );

				return;
			}
		}

		wait fire_time;
	}
}

subwoofer_network_choke()
{
	// no choke
}