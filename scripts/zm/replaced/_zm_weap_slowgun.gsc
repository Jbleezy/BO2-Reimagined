#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weap_slowgun;

watch_reset_anim_rate()
{
	self set_anim_rate( 1 );
	self setclientfieldtoplayer( "slowgun_fx", 0 );
	while ( 1 )
	{
		self waittill_any( "spawned_player", "entering_last_stand", "player_revived", "player_suicide" );
		self setclientfieldtoplayer( "slowgun_fx", 0 );
		self set_anim_rate( 1 );
	}
}