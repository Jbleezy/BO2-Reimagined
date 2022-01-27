#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_weap_jetgun;

jetgun_grind_zombie( player )
{
	player endon( "death" );
	player endon( "disconnect" );
	self endon( "death" );
	if ( !isDefined( self.jetgun_grind ) )
	{
		self.jetgun_grind = 1;
		self notify( "grinding" );
		if ( is_mature() )
		{
			if ( isDefined( level._effect[ "zombie_guts_explosion" ] ) )
			{
				playfx( level._effect[ "zombie_guts_explosion" ], self gettagorigin( "J_SpineLower" ) );
			}
		}
		self.nodeathragdoll = 1;
		self.handle_death_notetracks = ::jetgun_handle_death_notetracks;
		self dodamage( self.health + 666, player.origin, player );
	}
}

jetgun_network_choke()
{
	// no choke
}