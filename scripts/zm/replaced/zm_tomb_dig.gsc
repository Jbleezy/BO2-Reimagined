#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

increment_player_perk_purchase_limit()
{
	self maps/mp/zombies/_zm_perks::give_random_perk();
}

dig_disconnect_watch( n_player, v_origin, v_angles )
{
	self waittill( "disconnect" );
	level setclientfield( "shovel_player" + n_player, 0 );
	level setclientfield( "helmet_player" + n_player, 0 );
}