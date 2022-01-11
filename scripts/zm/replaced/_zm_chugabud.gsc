#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_chugabud;

chugabud_bleed_timeout( delay, corpse )
{
	self endon( "player_suicide" );
	self endon( "disconnect" );
	corpse endon( "death" );

	wait delay;

	if ( isDefined( corpse.revivetrigger ) )
	{
		while ( corpse.revivetrigger.beingrevived )
		{
			wait 0.01;
		}
	}

    if ( flag( "solo_game" ) && self.solo_lives_given < 3 )
	{
        self.solo_lives_given++;
        corpse notify( "player_revived" );
        return;
    }

	self chugabud_corpse_cleanup( corpse, 0 );
}