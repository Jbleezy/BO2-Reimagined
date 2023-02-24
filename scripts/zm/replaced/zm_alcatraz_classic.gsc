#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_alcatraz_classic;

#include scripts\zm\replaced\_zm_afterlife;

give_afterlife()
{
	onplayerconnect_callback( scripts\zm\replaced\_zm_afterlife::init_player );
	flag_wait( "initial_players_connected" );
	wait 0.5;
	n_start_pos = 1;
	a_players = getplayers();
	foreach ( player in a_players )
	{
		if ( isDefined( player.afterlife ) && !player.afterlife )
		{
			player thread fake_kill_player( n_start_pos );
			n_start_pos++;
		}
	}
}