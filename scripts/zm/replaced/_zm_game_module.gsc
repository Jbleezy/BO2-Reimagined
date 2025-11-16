#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

wait_for_team_death_and_round_end()
{
	level endon("game_module_ended");
	level endon("end_game");

	if (level.scr_zm_ui_gametype_obj != "zsr")
	{
		return;
	}

	checking_for_round_end = 0;
	checking_for_round_tie = 0;
	level.isresetting_grief = 0;

	while (1)
	{
		cdc_alive = 0;
		cia_alive = 0;
		players = get_players();
		i = 0;

		while (i < players.size)
		{
			if (!isDefined(players[i]._encounters_team))
			{
				i++;
				continue;
			}

			if (players[i]._encounters_team == "A")
			{
				if (is_player_valid(players[i]))
				{
					cia_alive++;
				}

				i++;
				continue;
			}

			if (is_player_valid(players[i]))
			{
				cdc_alive++;
			}

			i++;
		}

		if (players.size == 1)
		{
			if (!checking_for_round_tie)
			{
				if (cia_alive == 0 && cdc_alive == 0)
				{
					level notify("stop_round_end_check");
					level thread check_for_round_end();
					checking_for_round_tie = 1;
					checking_for_round_end = 1;
				}
			}

			if (cia_alive > 0 || cdc_alive > 0)
			{
				level notify("stop_round_end_check");
				checking_for_round_end = 0;
				checking_for_round_tie = 0;
			}

			wait 0.05;
			continue;
		}

		if (!checking_for_round_tie)
		{
			if (cia_alive == 0 && cdc_alive == 0)
			{
				level notify("stop_round_end_check");
				level thread check_for_round_end();
				checking_for_round_tie = 1;
				checking_for_round_end = 1;
			}
		}

		if (!checking_for_round_end)
		{
			if (cia_alive == 0)
			{
				level thread check_for_round_end("B");
				checking_for_round_end = 1;
			}
			else if (cdc_alive == 0)
			{
				level thread check_for_round_end("A");
				checking_for_round_end = 1;
			}
		}

		if (cia_alive > 0 && cdc_alive > 0)
		{
			level notify("stop_round_end_check");
			checking_for_round_end = 0;
			checking_for_round_tie = 0;
		}

		wait 0.05;
	}
}

check_for_round_end(winner)
{
	level endon("stop_round_end_check");
	level endon("end_game");

	if (isDefined(winner))
	{
		wait 5;
	}
	else
	{
		wait 0.5;
	}

	level thread round_end(winner);
}

round_end(winner)
{
	level endon("end_game");

	team = undefined;

	if (isDefined(winner))
	{
		if (winner == "A")
		{
			team = "axis";
		}
		else
		{
			team = "allies";
		}

		if (isDefined(level.increment_score_func))
		{
			[[level.increment_score_func]](team, 1, false);
		}
	}

	players = get_players();

	foreach (player in players)
	{
		if (is_player_valid(player))
		{
			// don't give perk
			player notify("perk_abort_drinking");

			// stop active perks
			if (isDefined(player.perks_active))
			{
				foreach (perk in player.perks_active)
				{
					player notify(perk + "_stop");
				}
			}

			// save weapons
			player [[level._game_module_player_laststand_callback]]();
		}

		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			if (isDefined(level.zombie_last_stand_ammo_return))
			{
				player [[level.zombie_last_stand_ammo_return]](1);
			}
		}
	}

	level.isresetting_grief = 1;
	level notify("end_round_think");
	level.zombie_vars["spectators_respawn"] = 1;
	level notify("keep_griefing");
	level notify("restart_round");

	level.sr_round_number++;
	setDvar("ui_round_number", level.sr_round_number);

	if (isDefined(level.show_grief_hud_msg_func))
	{
		if (isDefined(winner))
		{
			foreach (player in players)
			{
				if (player.team == team)
				{
					player thread [[level.show_grief_hud_msg_func]](&"ZOMBIE_GRIEF_WIN_ROUND");
					player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("grief_won");
				}
				else
				{
					player thread [[level.show_grief_hud_msg_func]](&"ZOMBIE_GRIEF_LOSE_ROUND");
					player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("grief_lost");
				}
			}
		}
		else
		{
			foreach (player in players)
			{
				player thread [[level.show_grief_hud_msg_func]](&"ZOMBIE_GRIEF_RESET");
				player thread [[level.show_grief_hud_msg_func]](&"", undefined, undefined, 30);
				player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("grief_restarted");
			}
		}
	}

	zombie_goto_round(level.sr_round_number);
	level thread maps\mp\zombies\_zm_game_module::reset_grief();
	level thread maps\mp\zombies\_zm::round_think(1);
}

game_won(winner)
{
	level.gamemodulewinningteam = winner;
	level.zombie_vars["spectators_respawn"] = 0;
	players = get_players();

	foreach (player in players)
	{
		player freezecontrols(1);

		if (player._encounters_team == winner)
		{
			player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("grief_won");
			continue;
		}

		player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("grief_lost");
	}

	if (isdefined(level.game_mode_scoring_team_hud_value))
	{
		level.game_mode_scoring_team_hud_value = undefined;

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_scoring_team");
		}
	}

	if (isdefined(level.game_mode_player_count_hud_value))
	{
		level.game_mode_player_count_hud_value = undefined;

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_player_count");
		}
	}

	if (isdefined(level.game_mode_obj_ind))
	{
		objective_setgamemodeflags(level.game_mode_obj_ind, 0);
	}

	if (isdefined(level.game_mode_next_obj_ind))
	{
		objective_setgamemodeflags(level.game_mode_next_obj_ind, 0);
	}

	if (isdefined(level.meat_player))
	{
		objective_setgamemodeflags(level.meat_player.obj_ind, 1);
	}

	level notify("game_module_ended", winner);
	level._game_module_game_end_check = undefined;
	maps\mp\gametypes_zm\_zm_gametype::track_encounters_win_stats(level.gamemodulewinningteam);
	level notify("end_game");
}

zombie_goto_round(target_round)
{
	level endon("end_game");

	if (target_round < 1)
	{
		target_round = 1;
	}

	level.zombie_total = 0;
	zombies = get_round_enemy_array();

	if (isDefined(zombies))
	{
		for (i = 0; i < zombies.size; i++)
		{
			zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		}
	}

	game["axis_spawnpoints_randomized"] = undefined;
	game["allies_spawnpoints_randomized"] = undefined;
	set_game_var("switchedsides", !get_game_var("switchedsides"));

	waittillframeend; // wait for active perks to be stopped

	maps\mp\zombies\_zm_game_module::respawn_players();

	wait 0.05; // let all players fully respawn

	level thread player_respawn_award();

	if (isDefined(level.round_start_wait_func))
	{
		level thread [[level.round_start_wait_func]](5);
	}
}

player_respawn_award()
{
	maps\mp\zombies\_zm::award_grenades_for_survivors();
	players = get_players();

	foreach (player in players)
	{
		if (player.score < level.player_starting_points)
		{
			player maps\mp\zombies\_zm_score::add_to_player_score(level.player_starting_points - player.score);
		}

		if (isDefined(player get_player_placeable_mine()))
		{
			player giveweapon(player get_player_placeable_mine());
			player set_player_placeable_mine(player get_player_placeable_mine());
			player setactionslot(4, "weapon", player get_player_placeable_mine());
			player setweaponammoclip(player get_player_placeable_mine(), 2);
		}
	}
}