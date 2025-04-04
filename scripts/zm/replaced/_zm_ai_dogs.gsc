#include maps\mp\zombies\_zm_ai_dogs;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_net;

enable_dog_rounds()
{
	level.dog_rounds_enabled = 1;

	if (!isdefined(level.dog_round_track_override))
	{
		level.dog_round_track_override = ::dog_round_tracker;
	}

	level thread [[level.dog_round_track_override]]();
}

dog_round_tracker()
{
	level.dog_round_count = 1;
	level.next_dog_round = level.round_number + randomintrange(4, 6);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;

	if (level.next_dog_round == 5)
	{
		level.prev_dog_round_amount = 4;
	}
	else
	{
		level.prev_dog_round_amount = 5;
	}

	while (true)
	{
		level waittill("between_round_over");

		if (level.round_number == level.next_dog_round)
		{
			level.music_round_override = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			dog_round_start();
			level.round_spawn_func = ::dog_round_spawning;

			if (!isdefined(level.prev_dog_round_amount))
			{
				level.prev_dog_round_amount = randomintrange(4, 6);
				level.next_dog_round = level.round_number + level.prev_dog_round_amount;
			}
			else
			{
				if (level.prev_dog_round_amount == 4)
				{
					level.next_dog_round = level.round_number + 5;
				}
				else
				{
					level.next_dog_round = level.round_number + 4;
				}

				level.prev_dog_round_amount = undefined;
			}
		}
		else if (flag("dog_round"))
		{
			dog_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.music_round_override = 0;
			level.dog_round_count += 1;
		}
	}
}

special_dog_spawn(spawners, num_to_spawn)
{
	dogs = getaispeciesarray("all", "zombie_dog");

	if (isdefined(dogs) && dogs.size >= 8)
	{
		return false;
	}

	if (!isdefined(num_to_spawn))
	{
		num_to_spawn = 1;
	}

	spawn_point = undefined;
	count = 0;

	while (count < num_to_spawn)
	{
		players = get_players();
		favorite_enemy = get_favorite_enemy();

		if (isdefined(spawners))
		{
			spawn_point = spawners[randomint(spawners.size)];
			ai = spawn_zombie(spawn_point);

			if (isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx(ai);
				count++;
				flag_set("dog_clips");
			}
		}
		else if (isdefined(level.dog_spawn_func))
		{
			spawn_loc = [[level.dog_spawn_func]](level.dog_spawners, favorite_enemy);
			ai = spawn_zombie(level.dog_spawners[0]);

			if (isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_loc thread dog_spawn_fx(ai, spawn_loc);
				count++;
				flag_set("dog_clips");
			}
		}
		else
		{
			spawn_point = dog_spawn_factory_logic(level.enemy_dog_spawns, favorite_enemy);
			ai = spawn_zombie(level.dog_spawners[0]);

			if (isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx(ai, spawn_point);
				count++;
				flag_set("dog_clips");
			}
		}

		waiting_for_next_dog_spawn(count, num_to_spawn);
	}

	return true;
}

waiting_for_next_dog_spawn(count, max)
{
	if (is_true(level.mixed_rounds_enabled))
	{
		wait 0.5;
		return;
	}

	default_wait = 1.5;

	if (level.dog_round_count == 1)
	{
		default_wait = 3;
	}
	else if (level.dog_round_count == 2)
	{
		default_wait = 2.5;
	}
	else if (level.dog_round_count == 3)
	{
		default_wait = 2;
	}
	else
	{
		default_wait = 1.5;
	}

	default_wait = default_wait - count / max;
	wait(default_wait);
}