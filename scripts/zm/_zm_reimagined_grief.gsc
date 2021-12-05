#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

init()
{
    if ( getDvar( "g_gametype" ) != "zgrief" )
    {
		return;
    }

	if ( getDvarInt( "zombies_minplayers" ) < 2 || getDvarInt( "zombies_minplayers" ) == "" )
	{
		setDvar( "zombies_minplayers", 2 );
	}

	level.zombie_vars["zombie_health_start"] = 2000;
	level.zombie_vars["zombie_spawn_delay"] = 0.5;
	level.round_number = 0;
	level.zombie_move_speed = 100;
	level.player_starting_points = 10000;

	level thread on_player_connect();
	level thread unlimited_zombies();
}

on_player_connect()
{
    while ( 1 )
    {
    	level waittill( "connected", player );
       	player set_team();
		player [[ level.givecustomcharacters ]]();
    }
}

set_team()
{
	teamplayersallies = countplayers( "allies");
	teamplayersaxis = countplayers( "axis");
	if ( teamplayersallies > teamplayersaxis && !level.isresetting_grief )
	{
		self.team = "axis";
		self.sessionteam = "axis";
	 	self.pers[ "team" ] = "axis";
		self._encounters_team = "A";
	}
	else
	{
		self.team = "allies";
		self.sessionteam = "allies";
		self.pers[ "team" ] = "allies";
		self._encounters_team = "B";
	}
}

unlimited_zombies()
{
	while(1)
	{
		level.zombie_total = 100;

		wait 1;
	}
}