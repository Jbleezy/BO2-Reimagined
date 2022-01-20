#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

player_elec_damage()
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( !isDefined( self.is_burning ) && is_player_valid( self ) )
	{
        self.is_burning = 1;
        shocktime = 1.25;

		if ( is_true( level.trap_electric_visionset_registered ) )
		{
			maps/mp/_visionset_mgr::vsmgr_activate( "overlay", "zm_trap_electric", self, shocktime, shocktime );
		}
		else
		{
			self setelectrified( shocktime );
		}

		self shellshock( "electrocution", shocktime );
		self playsound( "zmb_zombie_arc" );
        radiusdamage( self.origin + (0, 0, 5), 10, 25, 25 );

        wait 0.1;

        self.is_burning = undefined;
	}
}