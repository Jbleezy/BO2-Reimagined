#include maps\mp\zm_tomb_ee_main_step_8;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zm_tomb_chamber;

init()
{
	declare_sidequest_stage( "little_girl_lost", "step_8", ::init_stage, ::stage_logic, ::exit_stage );
}

stage_logic()
{
	level notify( "tomb_sidequest_complete" );

	s_pos = getstruct( "player_portal_final", "targetname" );

	foreach ( player in get_players() )
	{
		if ( player is_player_in_chamber() )
			player thread fadetoblackforxsec( 0, 0.3, 0.5, 0.5, "white" );
	}

	a_zombies = getaispeciesarray( level.zombie_team, "all" );
	foreach ( zombie in a_zombies )
	{
		if ( is_point_in_chamber( zombie.origin ) && !is_true( zombie.is_mechz ) && is_true( zombie.has_legs ) && is_true( zombie.completed_emerging_into_playable_area ) )
		{
			zombie.v_punched_from = s_pos.origin;
			zombie animcustom( maps\mp\zombies\_zm_weap_one_inch_punch::knockdown_zombie_animate );
		}
	}

	wait 0.5;
	level setclientfield( "ee_sam_portal", 2 );
	level notify( "stop_random_chamber_walls" );
	a_walls = getentarray( "chamber_wall", "script_noteworthy" );

	foreach ( e_wall in a_walls )
	{
		e_wall thread maps\mp\zm_tomb_chamber::move_wall_up();
		e_wall hide();
	}

	players = get_players();
	foreach ( player in players )
	{
		if ( is_player_valid( player ) )
		{
			player thread scripts\zm\replaced\_zm_sq::sq_give_player_all_perks();
		}
	}

	flag_wait( "ee_quadrotor_disabled" );
	wait 1;
	level thread ee_samantha_say( "vox_sam_all_staff_freedom_0" );

	t_portal = tomb_spawn_trigger_radius( s_pos.origin, 100, 1 );
	t_portal.hint_string = &"ZM_TOMB_TELE";
	t_portal thread waittill_player_activates();
	level.ee_ending_beam_fx = spawn( "script_model", s_pos.origin + vectorscale( ( 0, 0, -1 ), 300.0 ) );
	level.ee_ending_beam_fx.angles = vectorscale( ( 0, 1, 0 ), 90.0 );
	level.ee_ending_beam_fx setmodel( "tag_origin" );
	playfxontag( level._effect["ee_beam"], level.ee_ending_beam_fx, "tag_origin" );
	level.ee_ending_beam_fx playsound( "zmb_squest_crystal_sky_pillar_start" );
	level.ee_ending_beam_fx playloopsound( "zmb_squest_crystal_sky_pillar_loop", 3 );
	flag_wait( "ee_samantha_released" );
	t_portal tomb_unitrigger_delete();
	wait_network_frame();
	stage_completed( "little_girl_lost", level._cur_stage_name );
}