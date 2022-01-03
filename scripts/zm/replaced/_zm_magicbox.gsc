#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

treasure_chest_timeout()
{
	self endon( "user_grabbed_weapon" );
	self.zbarrier endon( "box_hacked_respin" );
	self.zbarrier endon( "box_hacked_rerespin" );
	wait level.magicbox_timeout;
	self notify( "trigger", level );
}

timer_til_despawn( v_float )
{
	self endon( "kill_weapon_movement" );
	self moveto( self.origin - ( v_float * 0.85 ), level.magicbox_timeout, level.magicbox_timeout * 0.5 );
	wait level.magicbox_timeout;
	if ( isDefined( self ) )
	{
		self delete();
	}
}