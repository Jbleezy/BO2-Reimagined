#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_chugabud;

chugabud_fake_death()
{
    level notify( "fake_death" );
    self notify( "fake_death" );
    self takeallweapons();
    self allowstand( 0 );
    self allowcrouch( 0 );
    self allowprone( 1 );
	self setstance( "prone" );
    self.ignoreme = 1;
    self enableinvulnerability();

	if ( self is_jumping() )
    {
        while ( self is_jumping() )
            wait 0.05;
    }

    self freezecontrols( 1 );
}

chugabud_corpse_revive_icon( player )
{
    self endon( "death" );
    height_offset = 30;
    index = player.clientid;
	self.revive_waypoint_origin = spawn( "script_model", self.origin + (0, 0, height_offset) );
	self.revive_waypoint_origin setmodel( "tag_origin" );
	self.revive_waypoint_origin linkto( self );

    hud_elem = newhudelem();
    self.revive_hud_elem = hud_elem;
    hud_elem.alpha = 1;
    hud_elem.archived = 1;
	hud_elem.hidewheninmenu = 1;
    hud_elem.immunetodemogamehudsettings = 1;
    hud_elem setwaypoint( 1, "specialty_chugabud_zombies" );
	hud_elem settargetent( self.revive_waypoint_origin );
}

chugabud_corpse_cleanup( corpse, was_revived )
{
    self notify( "chugabud_effects_cleanup" );

    if ( was_revived )
    {
        playsoundatposition( "evt_ww_appear", corpse.origin );
        playfx( level._effect["chugabud_revive_fx"], corpse.origin );
    }
    else
    {
        playsoundatposition( "evt_ww_disappear", corpse.origin );
        playfx( level._effect["chugabud_bleedout_fx"], corpse.origin );
        self notify( "chugabud_bleedout" );
    }

    if ( isdefined( corpse.revivetrigger ) )
    {
        corpse notify( "stop_revive_trigger" );
        corpse.revivetrigger delete();
        corpse.revivetrigger = undefined;
    }

    if ( isdefined( corpse.revive_hud_elem ) )
    {
        corpse.revive_hud_elem destroy();
        corpse.revive_hud_elem = undefined;
    }

	if ( isdefined( corpse.revive_waypoint_origin ) )
    {
        corpse.revive_waypoint_origin delete();
        corpse.revive_waypoint_origin = undefined;
    }

    self.loadout = undefined;
    wait 0.1;
    corpse delete();
    self.e_chugabud_corpse = undefined;
}

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