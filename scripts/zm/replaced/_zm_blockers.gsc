#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_score;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_blockers;

door_buy()
{
    self waittill( "trigger", who, force );

    if ( isdefined( level.custom_door_buy_check ) )
    {
        if ( !who [[ level.custom_door_buy_check ]]( self ) )
            return false;
    }

    if ( getdvarint( "zombie_unlock_all" ) > 0 || isdefined( force ) && force )
        return true;

    if ( !who usebuttonpressed() )
        return false;

    if ( who in_revive_trigger() )
        return false;

    if ( is_player_valid( who ) )
    {
        players = get_players();
        cost = self.zombie_cost;

        if ( who maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active() )
            cost = who maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_double_points_cost( cost );

        if ( self._door_open == 1 )
            self.purchaser = undefined;
        else if ( who.score >= cost )
        {
            who maps\mp\zombies\_zm_score::minus_to_player_score( cost, 1 );
            maps\mp\_demo::bookmark( "zm_player_door", gettime(), who );
            who maps\mp\zombies\_zm_stats::increment_client_stat( "doors_purchased" );
            who maps\mp\zombies\_zm_stats::increment_player_stat( "doors_purchased" );
            self.purchaser = who;
        }
        else
        {
            play_sound_at_pos( "no_purchase", self.origin );

            if ( isdefined( level.custom_generic_deny_vo_func ) )
                who thread [[ level.custom_generic_deny_vo_func ]]( 1 );
            else
                who maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "door_deny" );

            return false;
        }
    }

    if ( isdefined( level._door_open_rumble_func ) )
        who thread [[ level._door_open_rumble_func ]]();

    return true;
}

door_opened( cost, quick_close )
{
    if ( isdefined( self.door_is_moving ) && self.door_is_moving )
        return;

	play_sound_at_pos( "purchase", self.origin );

    self.has_been_opened = 1;
    all_trigs = getentarray( self.target, "target" );
    self.door_is_moving = 1;

    foreach ( trig in all_trigs )
    {
        trig.door_is_moving = 1;
        trig trigger_off();
        trig.has_been_opened = 1;

        if ( !isdefined( trig._door_open ) || trig._door_open == 0 )
        {
            trig._door_open = 1;
            trig notify( "door_opened" );
            level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "door_open" );
        }
        else
            trig._door_open = 0;

        if ( isdefined( trig.script_flag ) && trig._door_open == 1 )
        {
            tokens = strtok( trig.script_flag, "," );

            for ( i = 0; i < tokens.size; i++ )
                flag_set( tokens[i] );
        }
        else if ( isdefined( trig.script_flag ) && trig._door_open == 0 )
        {
            tokens = strtok( trig.script_flag, "," );

            for ( i = 0; i < tokens.size; i++ )
                flag_clear( tokens[i] );
        }

        if ( isdefined( quick_close ) && quick_close )
        {
            trig set_hint_string( trig, "" );
            continue;
        }

        if ( trig._door_open == 1 && flag( "door_can_close" ) )
        {
            trig set_hint_string( trig, "default_buy_door_close" );
            continue;
        }

        if ( trig._door_open == 0 )
            trig set_hint_string( trig, "default_buy_door", cost );
    }

    level notify( "door_opened" );

    if ( isdefined( self.doors ) )
    {
        is_script_model_door = 0;
        have_moving_clip_for_door = 0;
        use_blocker_clip_for_pathing = 0;

        foreach ( door in self.doors )
        {
            if ( is_true( door.ignore_use_blocker_clip_for_pathing_check ) )
                continue;

            if ( door.classname == "script_model" )
            {
                is_script_model_door = 1;
                continue;
            }

            if ( door.classname == "script_brushmodel" && ( !isdefined( door.script_noteworthy ) || door.script_noteworthy != "clip" ) && ( !isdefined( door.script_string ) || door.script_string != "clip" ) )
                have_moving_clip_for_door = 1;
        }

        use_blocker_clip_for_pathing = is_script_model_door && !have_moving_clip_for_door;

        for ( i = 0; i < self.doors.size; i++ )
		{
			self.doors[i] thread door_activate( self.doors[i].script_transition_time, self._door_open, quick_close, use_blocker_clip_for_pathing );
		}
    }

    level.active_zone_names = maps\mp\zombies\_zm_zonemgr::get_active_zone_names();
    wait 1;
    self.door_is_moving = 0;

    foreach ( trig in all_trigs )
        trig.door_is_moving = 0;

    if ( isdefined( quick_close ) && quick_close )
    {
        for ( i = 0; i < all_trigs.size; i++ )
            all_trigs[i] trigger_on();

        return;
    }

    if ( flag( "door_can_close" ) )
    {
        wait 2.0;

        for ( i = 0; i < all_trigs.size; i++ )
            all_trigs[i] trigger_on();
    }
}

handle_post_board_repair_rewards( cost, zbarrier )
{
	self maps\mp\zombies\_zm_stats::increment_client_stat( "boards" );
	self maps\mp\zombies\_zm_stats::increment_player_stat( "boards" );
	if ( isDefined( self.pers[ "boards" ] ) && ( self.pers[ "boards" ] % 10 ) == 0 )
	{
		self thread do_player_general_vox( "general", "reboard", 90 );
	}
	self maps\mp\zombies\_zm_pers_upgrades_functions::pers_boards_updated( zbarrier );
	self.rebuild_barrier_reward += cost;

	self maps\mp\zombies\_zm_score::player_add_points( "rebuild_board", cost );
	self play_sound_on_ent( "purchase" );

	if ( isDefined( self.board_repair ) )
	{
		self.board_repair += 1;
	}
}

player_fails_blocker_repair_trigger_preamble( player, players, trigger, hold_required )
{
    if ( !isdefined( trigger ) )
        return true;

    if ( !is_player_valid( player ) )
        return true;

    if ( players.size == 1 && isdefined( players[0].intermission ) && players[0].intermission == 1 )
        return true;

    if ( hold_required && !player usebuttonpressed() )
        return true;

    if ( !hold_required && !player use_button_held() )
        return true;

    if ( player in_revive_trigger() )
        return true;

	if ( player issprinting() || player isthrowinggrenade() )
        return true;

    return false;
}