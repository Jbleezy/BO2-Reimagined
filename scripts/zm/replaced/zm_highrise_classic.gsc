#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_highrise_classic;

escape_pod()
{
    escape_pod = getent( "elevator_bldg1a_body", "targetname" );
    escape_pod setmovingplatformenabled( 1 );
    escape_pod escapeelevatoruseanimtree();
    escape_pod_trigger = getent( "escape_pod_trigger", "targetname" );
    escape_pod.is_elevator = 1;
    escape_pod._post_host_migration_thread = maps\mp\zm_highrise_elevators::escape_pod_host_migration_respawn_check;

    if ( !isdefined( escape_pod_trigger ) )
        return;

    escape_pod.home_origin = escape_pod.origin;
    escape_pod.link_start = [];
    escape_pod.link_end = [];
    escape_pod_blocker_door = getent( "elevator_bldg1a_body_door_clip", "targetname" );
    number_of_times_used = 0;
    used_at_least_once = 0;
    escape_pod setanim( level.escape_elevator_1_state );
    escape_pod setclientfield( "clientfield_escape_pod_light_fx", 1 );
    escape_pod_trigger thread escape_pod_walk_on_off( escape_pod );

    while ( true )
    {
        escape_pod setanim( level.escape_elevator_idle );
        flag_clear( "escape_pod_needs_reset" );

        if ( isdefined( escape_pod_blocker_door ) )
        {
            escape_pod escape_pod_linknodes( "escape_pod_door_l_node" );
            escape_pod escape_pod_linknodes( "escape_pod_door_r_node" );
            escape_pod_blocker_door unlink();
            escape_pod_blocker_door thread trigger_off();
        }

        if ( is_true( used_at_least_once ) )
            wait 3;

        escape_pod thread escape_pod_state_run();

        while ( true )
        {
            players_in_escape_pod = escape_pod_trigger escape_pod_get_all_alive_players_inside();

            if ( players_in_escape_pod.size == 0 )
            {
                escape_pod.escape_pod_state = 1;
                wait 0.05;
                continue;
            }

            players_in_escape_pod = escape_pod_trigger escape_pod_get_all_alive_players_inside();

            if ( players_in_escape_pod.size > 0 )
			{
				escape_pod.escape_pod_state = 2;

				escape_pod thread escape_pod_tell_fx();
                wait 3;
                players_in_escape_pod = escape_pod_trigger escape_pod_get_all_alive_players_inside();

                if ( players_in_escape_pod.size > 0 )
                    break;
			}

            wait 0.05;
        }

        level notify( "escape_pod_falling_begin" );

        foreach ( player in players_in_escape_pod )
        {
            player.riding_escape_pod = 1;
            player allowjump( 0 );
        }

        if ( isdefined( escape_pod_blocker_door ) )
        {
            escape_pod_blocker_door trigger_on();
            escape_pod_blocker_door linkto( escape_pod );
            escape_pod escape_pod_unlinknodes( "escape_pod_door_l_node" );
            escape_pod escape_pod_unlinknodes( "escape_pod_door_r_node" );
        }

        escape_pod.escape_pod_state = 5;
        escape_pod thread escape_pod_shake();
        wait( getanimlength( level.escape_elevator_5_state ) - 0.05 );
        escape_pod setanim( level.escape_elevator_drop );
        escape_pod setclientfield( "clientfield_escape_pod_light_fx", 0 );
        escape_pod setclientfield( "clientfield_escape_pod_sparks_fx", 1 );
        escape_pod thread escape_pod_move();
        escape_pod thread escape_pod_rotate();

        escape_pod waittill( "reached_destination" );

        number_of_times_used++;
        escape_pod thread impact_animate();

        if ( number_of_times_used == 1 )
        {
            level.escape_elevator_idle = level.escape_elevator_damage_idle_state;
            level.escape_elevator_drop = level.escape_elevator_damage_drop_state;
            level.escape_elevator_impact = level.escape_elevator_damage_impact_state;
        }

        level notify( "escape_pod_falling_complete" );

        if ( isdefined( escape_pod_blocker_door ) )
        {
            escape_pod_blocker_door unlink();
            escape_pod_blocker_door trigger_off();
            escape_pod escape_pod_linknodes( "escape_pod_door_l_node" );
            escape_pod escape_pod_linknodes( "escape_pod_door_r_node" );
        }

        escape_pod setclientfield( "clientfield_escape_pod_sparks_fx", 0 );
        escape_pod setclientfield( "clientfield_escape_pod_impact_fx", 1 );
        escape_pod setclientfield( "clientfield_escape_pod_light_fx", 1 );
        flag_set( "escape_pod_needs_reset" );

        level waittill( "reset_escape_pod" );

        flag_clear( "escape_pod_needs_reset" );
        escape_pod setclientfield( "clientfield_escape_pod_impact_fx", 0 );
        escape_pod thread escape_pod_breaking_rotate();
        wait 6;
        escape_pod playsound( "zmb_elevator_run_start" );
        escape_pod playloopsound( "zmb_elevator_run", 1 );
        level notify( "escape_pod_moving_back_to_start_position" );

        if ( isdefined( escape_pod_blocker_door ) )
        {
            escape_pod_blocker_door trigger_on();
            escape_pod_blocker_door linkto( escape_pod );
            escape_pod escape_pod_unlinknodes( "escape_pod_door_l_node" );
            escape_pod escape_pod_unlinknodes( "escape_pod_door_r_node" );
        }

        escape_pod moveto( escape_pod.home_origin, 3, 0.1, 0.1 );

        escape_pod waittill( "movedone" );

        escape_pod stoploopsound( 1 );
        escape_pod playsound( "zmb_esc_pod_crash" );
        escape_pod playsound( "zmb_elevator_run_stop" );
        escape_pod playsound( "zmb_elevator_ding" );
        escape_pod thread reset_impact_animate();
        used_at_least_once = 1;
    }
}

escape_pod_get_all_alive_players_inside()
{
    players = get_players();
    players_in_escape_pod = [];

    foreach ( player in players )
    {
        if ( player.sessionstate != "spectator" )
        {
            if ( player istouching( self ) )
                players_in_escape_pod[players_in_escape_pod.size] = player;
        }
    }

    return players_in_escape_pod;
}

insta_kill_player( perks_can_respawn_player, kill_if_falling )
{
	self endon( "disconnect" );
	if ( isDefined( perks_can_respawn_player ) && perks_can_respawn_player == 0 )
	{
		if ( self hasperk( "specialty_quickrevive" ) )
		{
			self unsetperk( "specialty_quickrevive" );
		}
		if ( self hasperk( "specialty_finalstand" ) )
		{
			self unsetperk( "specialty_finalstand" );
		}
	}
	self maps\mp\zombies\_zm_buildables::player_return_piece_to_original_spawn();
	if ( isDefined( self.insta_killed ) && self.insta_killed )
	{
		return;
	}
	if ( isDefined( self.ignore_insta_kill ) )
	{
		self.disable_chugabud_corpse = 1;
		return;
	}
	if ( self hasperk( "specialty_finalstand" ) )
	{
		self.ignore_insta_kill = 1;
		self.disable_chugabud_corpse = 1;
		self dodamage( self.health + 1000, ( 0, 0, 1 ) );
		return;
	}
	if ( !isDefined( kill_if_falling ) || kill_if_falling == 0 )
	{
		if ( !self isonground() )
		{
			return;
		}
	}
	if ( is_player_killable( self ) )
	{
		self.insta_killed = 1;
		in_last_stand = 0;
		self notify( "chugabud_effects_cleanup" );
		if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			in_last_stand = 1;
		}
		self thread blood_splat();
		if ( getnumconnectedplayers() == 1 )
		{
			if ( isDefined( self.solo_lives_given ) && self.solo_lives_given < 3 )
			{
				self.waiting_to_revive = 1;
				points = getstruct( "zone_green_start", "script_noteworthy" );
				spawn_points = getstructarray( points.target, "targetname" );
				point = spawn_points[ 0 ];
				if ( in_last_stand == 0 )
				{
					self dodamage( self.health + 1000, ( 0, 0, 1 ) );
				}
				wait 0.5;
				self freezecontrols( 1 );
				wait 0.25;
				self setorigin( point.origin + vectorScale( ( 0, 0, 1 ), 20 ) );
				self.angles = point.angles;
				if ( in_last_stand )
				{
					flag_set( "instant_revive" );
					self.stopflashingbadlytime = getTime() + 1000;
					wait_network_frame();
					flag_clear( "instant_revive" );
				}
				else
				{
					self thread maps\mp\zombies\_zm_laststand::auto_revive( self );
					self.waiting_to_revive = 0;
					self.solo_respawn = 0;
					self.lives--;
				}
				self freezecontrols( 0 );
				self.insta_killed = 0;
			}
			else
			{
				self dodamage( self.health + 1000, ( 0, 0, 1 ) );
			}
		}
		else
		{
			self dodamage( self.health + 1000, ( 0, 0, 1 ) );
			wait_network_frame();
			self.bleedout_time = 0;
		}
		self.insta_killed = 0;
	}
}