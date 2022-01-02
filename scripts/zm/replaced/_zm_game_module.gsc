#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

wait_for_team_death_and_round_end()
{
	level endon( "game_module_ended" );
	level endon( "end_game" );

	checking_for_round_end = 0;
	checking_for_round_tie = 0;
	level.isresetting_grief = 0;
	while ( 1 )
	{
		cdc_total = 0;
		cia_total = 0;
		cdc_alive = 0;
		cia_alive = 0;
		players = get_players();
		i = 0;
		while ( i < players.size )
		{
			if ( !isDefined( players[ i ]._encounters_team ) )
			{
				i++;
				continue;
			}
			if ( players[ i ]._encounters_team == "A" )
			{
				cia_total++;
				if ( is_player_valid( players[ i ] ) )
				{
					cia_alive++;
				}
				i++;
				continue;
			}
			cdc_total++;
			if ( is_player_valid( players[ i ] ) )
			{
				cdc_alive++;
			}
			i++;
		}

		if ( cia_total == 0 )
		{
			level notify( "stop_round_end_check" );
			level thread round_end( "B", true );
			checking_for_round_end = 1;
		}
		else if ( cdc_total == 0 )
		{
			level notify( "stop_round_end_check" );
			level thread round_end( "A", true );
			checking_for_round_end = 1;
		}

		if ( !checking_for_round_tie )
		{
			if(cia_alive == 0 && cdc_alive == 0)
			{
				level notify( "stop_round_end_check" );
				level thread check_for_round_end();
				checking_for_round_tie = 1;
				checking_for_round_end = 1;
			}
		}

		if ( !checking_for_round_end )
		{
			if ( cia_alive == 0 )
			{
				level thread check_for_round_end( "B" );
				checking_for_round_end = 1;
			}
			else if ( cdc_alive == 0 )
			{
				level thread check_for_round_end( "A" );
				checking_for_round_end = 1;
			}
		}

		if ( cia_alive > 0 && cdc_alive > 0 )
		{
			level notify( "stop_round_end_check" );
			checking_for_round_end = 0;
			checking_for_round_tie = 0;
		}

		wait 0.05;
	}
}

check_for_round_end(winner)
{
	level endon( "stop_round_end_check" );

	if(isDefined(winner))
	{
		wait 5;
	}
	else
	{
		wait 0.5;
	}

	level thread round_end(winner);
}

round_end(winner, force_win)
{
	if(!isDefined(force_win))
	{
		force_win = false;
	}

	team = undefined;
	if(isDefined(winner))
	{
		if(winner == "A")
		{
			team = "axis";
		}
		else
		{
			team = "allies";
		}
	}

	if(isDefined(winner))
	{
		level.grief_score[winner]++;
		level.grief_hud.score[team] setValue(level.grief_score[winner]);
		setteamscore(team, level.grief_score[winner]);

		if(level.grief_score[winner] == level.grief_winning_score || force_win)
		{
			level.gamemodulewinningteam = winner;
			level.zombie_vars[ "spectators_respawn" ] = 0;
			players = get_players();
			i = 0;
			while ( i < players.size )
			{
				players[ i ] freezecontrols( 1 );
				if ( players[ i ]._encounters_team == winner )
				{
					players[ i ] thread maps/mp/zombies/_zm_audio_announcer::leaderdialogonplayer( "grief_won" );
					i++;
					continue;
				}
				players[ i ] thread maps/mp/zombies/_zm_audio_announcer::leaderdialogonplayer( "grief_lost" );
				i++;
			}
			level notify( "game_module_ended", winner );
			level._game_module_game_end_check = undefined;
			maps/mp/gametypes_zm/_zm_gametype::track_encounters_win_stats( level.gamemodulewinningteam );
			level notify( "end_game" );
			return;
		}
	}

	players = get_players();
	foreach(player in players)
	{
		// don't give score back from down
		player.pers["score"] = player.score;

		if(is_player_valid(player))
		{
			// don't give perk
			player notify("perk_abort_drinking");
			// save weapons
			player [[level._game_module_player_laststand_callback]]();
		}
	}

	level.isresetting_grief = 1;
	level notify( "end_round_think" );
	level.zombie_vars[ "spectators_respawn" ] = 1;
	level notify( "keep_griefing" );
	level notify( "restart_round" );

	level.round_number++;
	setroundsplayed(level.round_number);

	level thread maps/mp/zombies/_zm_audio_announcer::leaderdialog( "grief_restarted" );
	if(isDefined(winner))
	{
		foreach(player in players)
		{
			if(player.team == team)
			{
				player thread scripts/zm/main/_zm_reimagined_zgrief::show_grief_hud_msg( "You won the round" );
			}
			else
			{
				player thread scripts/zm/main/_zm_reimagined_zgrief::show_grief_hud_msg( "You lost the round" );
			}
		}
	}
	else
	{
		foreach(player in players)
		{
			player thread scripts/zm/main/_zm_reimagined_zgrief::show_grief_hud_msg( &"ZOMBIE_GRIEF_RESET" );
		}
	}

	zombie_goto_round( level.round_number );
	level thread maps/mp/zombies/_zm_game_module::reset_grief();
	level thread maps/mp/zombies/_zm::round_think( 1 );
}

zombie_goto_round(target_round)
{
	level endon( "end_game" );

	if ( target_round < 1 )
	{
		target_round = 1;
	}

	level.zombie_total = 0;
	zombies = get_round_enemy_array();
	if ( isDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			zombies[ i ] dodamage( zombies[ i ].health + 666, zombies[ i ].origin );
		}
	}

	game["axis_spawnpoints_randomized"] = undefined;
	game["allies_spawnpoints_randomized"] = undefined;
	set_game_var("switchedsides", !get_game_var("switchedsides"));

	maps/mp/zombies/_zm_game_module::respawn_players();

	level thread player_respawn_award();

	level thread scripts/zm/main/_zm_reimagined_zgrief::round_start_wait(5);
}

player_respawn_award()
{
	wait 0.05; // let all players fully respawn

	maps/mp/zombies/_zm::award_grenades_for_survivors();
	players = get_players();
	foreach(player in players)
	{
		if(player.score < level.player_starting_points)
		{
			player maps/mp/zombies/_zm_score::add_to_player_score(level.player_starting_points - player.score);
		}

		if(isDefined(player get_player_placeable_mine()))
		{
			player giveweapon(player get_player_placeable_mine());
			player set_player_placeable_mine(player get_player_placeable_mine());
			player setactionslot(4, "weapon", player get_player_placeable_mine());
			player setweaponammoclip(player get_player_placeable_mine(), 2);
		}
	}
}