#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

check_quickrevive_for_hotjoin(disconnecting_player)
{
	// always use coop quick revive
}

onallplayersready()
{
	while ( getPlayers().size < getDvarInt( "zombies_minplayers" ) )
	{
		wait 0.1;
	}
	game[ "state" ] = "playing";
	wait_for_all_players_to_connect( level.crash_delay );
	setinitialplayersconnected();
	flag_set( "initial_players_connected" );
	while ( !aretexturesloaded() )
	{
		wait 0.05;
	}
	thread maps/mp/zombies/_zm::start_zombie_logic_in_x_sec( 3 );
	maps/mp/zombies/_zm::fade_out_intro_screen_zm( 5, 1.5, 1 );
}

wait_for_all_players_to_connect( max_wait )
{
	timeout = int( max_wait * 10 );
	cur_time = 0;
	player_count_actual = 0;
	while ( getnumconnectedplayers() < getnumexpectedplayers() || player_count_actual != getnumexpectedplayers() )
	{
		players = getPlayers();
		player_count_actual = 0;
		for ( i = 0; i < players.size; i++ )
		{
			players[ i ] freezecontrols( 1 );
			if ( players[ i ].sessionstate == "playing" )
			{
				player_count_actual++;
			}
		}
		wait 0.1;
		cur_time++;
		if ( cur_time >= timeout )
		{
			return;
		}
	}
}