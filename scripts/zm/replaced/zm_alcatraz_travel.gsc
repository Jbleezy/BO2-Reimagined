#include maps\mp\zm_alcatraz_travel;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\_zombiemode_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;

move_gondola( b_suppress_doors_close = 0 )
{
	level clientnotify( "sndGS" );
	level thread gondola_lights_red();
	e_gondola = level.e_gondola;
	t_ride = level.e_gondola.t_ride;
	e_gondola.is_moving = 1;

	if ( e_gondola.location == "roof" )
	{
		s_moveloc = getstruct( "gondola_struct_docks", "targetname" );
		e_gondola.destination = "docks";
		level thread gondola_outofbounds_trigger_stop();
	}
	else if ( e_gondola.location == "docks" )
	{
		s_moveloc = getstruct( "gondola_struct_roof", "targetname" );
		e_gondola.destination = "roof";
		level thread gondola_outofbounds_trigger_enabled();
	}

	if ( flag( "gondola_initialized" ) )
	{
		flag_set( "gondola_roof_to_dock" );
		flag_set( "gondola_dock_to_roof" );
		flag_set( "gondola_ride_zone_enabled" );
	}

	flag_clear( "gondola_at_" + e_gondola.location );

	a_t_move = getentarray( "gondola_move_trigger", "targetname" );

	foreach ( trigger in a_t_move )
		trigger sethintstring( "" );

	a_t_call = getentarray( "gondola_call_trigger", "targetname" );

	foreach ( trigger in a_t_call )
		trigger sethintstring( &"ZM_PRISON_GONDOLA_ACTIVE" );

	if ( !( isdefined( b_suppress_doors_close ) && b_suppress_doors_close ) )
		e_gondola gondola_doors_move( e_gondola.location, -1 );

	level notify( "gondola_moving" );

	check_when_gondola_moves_if_groundent_is_undefined( e_gondola );
	a_players = getplayers();

	foreach ( player in a_players )
	{
		if ( player is_player_on_gondola() )
		{
			player setclientfieldtoplayer( "rumble_gondola", 1 );
			player thread check_for_death_on_gondola( e_gondola );
			player.is_on_gondola = 1;
			level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "gondola", player );
		}

		if ( isdefined( player.e_afterlife_corpse ) && player.e_afterlife_corpse istouching( t_ride ) )
			player.e_afterlife_corpse thread link_corpses_to_gondola( e_gondola );
	}

	e_gondola thread create_gondola_poi();
	level thread gondola_moving_vo();
	e_gondola thread gondola_physics_explosion( 10 );
	e_gondola moveto( s_moveloc.origin, 10, 1, 1 );
	flag_set( "gondola_in_motion" );
	e_gondola thread gondola_chain_fx_anim();
	e_gondola playsound( "zmb_gondola_start" );
	e_gondola playloopsound( "zmb_gondola_loop", 1 );

	e_gondola waittill( "movedone" );

	flag_clear( "gondola_in_motion" );
	e_gondola stoploopsound( 0.5 );
	e_gondola thread sndcooldown();
	e_gondola playsound( "zmb_gondola_stop" );
	player_escaped_gondola_failsafe();
	a_players = getplayers();

	foreach ( player in a_players )
	{
		if ( isdefined( player.is_on_gondola ) && player.is_on_gondola )
		{
			player setclientfieldtoplayer( "rumble_gondola", 0 );
			player.is_on_gondola = 0;
		}
	}

	e_gondola gondola_doors_move( e_gondola.destination, 1 );
	e_gondola.is_moving = 0;
	e_gondola thread tear_down_gondola_poi();
	wait 1.0;
	level clientnotify( "sndGE" );

	if ( e_gondola.location == "roof" )
	{
		e_gondola.location = "docks";
		str_zone = "zone_dock_gondola";
	}
	else if ( e_gondola.location == "docks" )
	{
		e_gondola.location = "roof";
		str_zone = "zone_cellblock_west_gondola_dock";
	}

	level notify( "gondola_arrived", str_zone );
	gondola_cooldown();
	flag_set( "gondola_at_" + e_gondola.location );
}