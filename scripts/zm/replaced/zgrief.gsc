#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

game_mode_spawn_player_logic()
{
	if(isDefined(level.scr_zm_ui_gametype_obj) && level.scr_zm_ui_gametype_obj != "zgrief")
	{
		return 0;
	}

	if ( flag( "start_zombie_round_logic" ) && !isDefined( self.is_hotjoin ) )
	{
		self.is_hotjoin = 1;
		return 1;
	}

	return 0;
}

meat_stink_on_ground(position_to_play)
{
	level.meat_on_ground = 1;
	attractor_point = spawn( "script_model", position_to_play );
	attractor_point setmodel( "tag_origin" );
	attractor_point playsound( "zmb_land_meat" );
	wait 0.2;
	playfxontag( level._effect[ "meat_stink_torso" ], attractor_point, "tag_origin" );
	attractor_point playloopsound( "zmb_meat_flies" );
	attractor_point create_zombie_point_of_interest( 1536, 32, 10000 );
	attractor_point.attract_to_origin = 1;
	attractor_point thread create_zombie_point_of_interest_attractor_positions( 4, 45 );
	attractor_point thread maps/mp/zombies/_zm_weap_cymbal_monkey::wait_for_attractor_positions_complete();
	attractor_point delay_thread( 10, ::self_delete );
	wait 10;
	level.meat_on_ground = undefined;
}

meat_stink_player( who )
{
	level notify( "new_meat_stink_player" );
	level endon( "new_meat_stink_player" );
	who.ignoreme = 0;
	players = get_players();
	foreach ( player in players )
	{
		player thread maps/mp/gametypes_zm/zgrief::meat_stink_player_cleanup();
		if ( player != who )
		{
			player.ignoreme = 1;
		}

		if(player.team == who.team)
		{
			player iprintln("^8" + who.name + " has the meat");
		}
		else
		{
			player iprintln("^9" + who.name + " has the meat");
		}
	}
	who thread maps/mp/gametypes_zm/zgrief::meat_stink_player_create();
	who waittill_any_or_timeout( 30, "disconnect", "player_downed", "bled_out" );
	players = get_players();
	foreach ( player in players )
	{
		player thread maps/mp/gametypes_zm/zgrief::meat_stink_player_cleanup();
		player.ignoreme = 0;
	}
}