#include maps\mp\zm_transit_lava;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\animscripts\zm_death;

player_lava_damage( trig )
{
    self endon( "zombified" );
    self endon( "death" );
    self endon( "disconnect" );
    max_dmg = 15;
    min_dmg = 5;
    burn_time = 1;

    if ( isdefined( self.is_zombie ) && self.is_zombie )
        return;

    self thread player_stop_burning();

    if ( isdefined( trig.script_float ) )
    {
        max_dmg *= trig.script_float;
        min_dmg *= trig.script_float;
        burn_time *= trig.script_float;

        if ( burn_time >= 1.5 )
            burn_time = 1.5;
    }

	if (max_dmg < 15)
	{
		max_dmg = 5;
	}

    if ( !isdefined( self.is_burning ) && is_player_valid( self ) )
    {
        self.is_burning = 1;
        maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_transit_burn", self, burn_time, level.zm_transit_burn_max_duration );
        self notify( "burned" );

        if ( isdefined( trig.script_float ) && trig.script_float >= 0.1 )
            self thread player_burning_fx();

		radiusdamage( self.origin, 10, max_dmg, min_dmg );

		wait 0.5;

        self.is_burning = undefined;
    }
}