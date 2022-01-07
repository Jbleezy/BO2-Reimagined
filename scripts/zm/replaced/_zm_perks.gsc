#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

perk_pause( perk )
{
	// disabled
}

destroy_weapon_in_blackout( player )
{
	self endon( "pap_timeout" );
	self endon( "pap_taken" );
	self endon( "pap_player_disconnected" );

	level waittill( "Pack_A_Punch_off" );

	if ( isDefined( self.worldgun ) )
	{
		if ( isDefined( self.worldgun.worldgundw ) )
		{
			self.worldgun.worldgundw delete();
		}
		self.worldgun delete();
	}
}