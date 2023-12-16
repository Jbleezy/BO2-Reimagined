#include maps\mp\zm_buried_ffotd;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_buried;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm;

jail_traversal_fix()
{
	self endon( "death" );
	window_pos = ( -837, 496, 8 );
	fix_dist = 64;

	while ( true )
	{
		dist = distancesquared( self.origin, window_pos );

		if ( dist < fix_dist )
		{
			node = self getnegotiationstartnode();

			if ( isdefined( node ) )
			{
				if ( node.animscript == "zm_jump_down_48" && node.type == "Begin" )
				{
					self setphysparams( 25, 0, 60 );
					wait 1;

					if ( is_true( self.has_legs ) )
						self setphysparams( 15, 0, 60 );
					else
						self setphysparams( 15, 0, 24 );
				}
			}
		}

		wait 0.25;
	}
}

time_bomb_takeaway()
{
	// remove
}

spawned_life_triggers()
{
	// remove
}