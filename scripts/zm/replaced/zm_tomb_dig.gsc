#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

dig_disconnect_watch( n_player, v_origin, v_angles )
{
	self waittill( "disconnect" );
	level setclientfield( "shovel_player" + n_player, 0 );
	level setclientfield( "helmet_player" + n_player, 0 );
}