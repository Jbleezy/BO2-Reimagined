#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_afterlife;

init_player()
{
	flag_wait( "initial_players_connected" );
	self.lives = 1;
	self setclientfieldtoplayer( "player_lives", self.lives );
	self.afterlife = 0;
	self.afterliferound = level.round_number;
	self.afterlifedeaths = 0;
	self thread afterlife_doors_close();
	self thread afterlife_player_refill_watch();
}

afterlife_add()
{
	if ( self.lives < 1 )
    {
        self.lives++;
        self thread afterlife_add_fx();
    }
	self playsoundtoplayer( "zmb_afterlife_add", self );
	self setclientfieldtoplayer( "player_lives", self.lives );
}

afterlife_start_zombie_logic()
{
	flag_wait( "start_zombie_round_logic" );
	wait 0.5;
	b_everyone_alive = 0;
	while ( isDefined( b_everyone_alive ) && !b_everyone_alive )
	{
		b_everyone_alive = 1;
		a_players = getplayers();
		_a192 = a_players;
		_k192 = getFirstArrayKey( _a192 );
		while ( isDefined( _k192 ) )
		{
			player = _a192[ _k192 ];
			if ( isDefined( player.afterlife ) && player.afterlife )
			{
				b_everyone_alive = 0;
				wait 0.05;
				break;
			}
			else
			{
				_k192 = getNextArrayKey( _a192, _k192 );
			}
		}
	}
	wait 0.5;
	while ( level.intermission )
	{
		wait 0.05;
	}
	flag_set( "afterlife_start_over" );
	wait 2;
	array_func( getplayers(), ::afterlife_add );
}