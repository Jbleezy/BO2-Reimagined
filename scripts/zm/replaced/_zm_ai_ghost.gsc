#include maps\mp\zombies\_zm_ai_ghost;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_ai_ghost_ffotd;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_ai_basic;

ghost_zone_spawning_think()
{
	level endon("intermission");

	if (isdefined(level.intermission) && level.intermission)
		return;

	if (!isdefined(level.female_ghost_spawner))
	{
		return;
	}

	while (true)
	{
		if (level.zombie_ghost_count >= level.zombie_ai_limit_ghost)
		{
			wait 0.1;
			continue;
		}

		valid_player_count = 0;
		valid_players = [];

		while (valid_player_count < 1)
		{
			players = getplayers();
			valid_player_count = 0;

			foreach (player in players)
			{
				if (is_player_valid(player) && !is_player_fully_claimed(player))
				{
					if (isdefined(player.is_in_ghost_zone) && player.is_in_ghost_zone)
					{
						valid_player_count++;
						valid_players[valid_players.size] = player;
					}
				}
			}

			wait 0.1;
		}

		valid_players = array_randomize(valid_players);
		spawn_point = get_best_spawn_point(valid_players[0]);

		if (!isdefined(spawn_point))
		{
			wait 0.1;
			continue;
		}

		ghost_ai = undefined;

		if (isdefined(level.female_ghost_spawner))
			ghost_ai = spawn_zombie(level.female_ghost_spawner, level.female_ghost_spawner.targetname, spawn_point);
		else
		{
			return;
		}

		if (isdefined(ghost_ai))
		{
			ghost_ai setclientfield("ghost_fx", 3);
			ghost_ai.spawn_point = spawn_point;
			ghost_ai.is_ghost = 1;
			ghost_ai.is_spawned_in_ghost_zone = 1;
			ghost_ai.find_target = 1;
			level.zombie_ghost_count++;
		}
		else
		{
			return;
		}

		wait 0.1;
	}
}

should_last_ghost_drop_powerup()
{
	if (flag("time_bomb_restore_active"))
		return false;

	if (!isdefined(level.ghost_round_last_ghost_origin))
		return false;

	if (!is_true(level.ghost_round_no_damage))
		return false;

	return true;
}