#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

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