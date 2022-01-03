#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	level.custom_magic_box_timer_til_despawn = ::custom_magic_box_timer_til_despawn;
}

custom_magic_box_timer_til_despawn( magic_box )
{
	self endon( "kill_weapon_movement" );
	v_float = anglesToForward( magic_box.angles - vectorScale( ( 0, 1, 0 ), 90 ) ) * 40;
	self moveto( self.origin - ( v_float * 0.25 ), level.magicbox_timeout, level.magicbox_timeout * 0.5 );
	wait level.magicbox_timeout;
	if ( isDefined( self ) )
	{
		self delete();
	}
}