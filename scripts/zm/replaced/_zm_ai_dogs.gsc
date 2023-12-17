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

	if ( !isdefined( level.dog_round_track_override ) )
		level.dog_round_track_override = ::dog_round_tracker;

	level thread [[ level.dog_round_track_override ]]();
}

dog_round_tracker()
{
	level.dog_round_count = 1;
	level.next_dog_round = level.round_number + randomintrange( 4, 6 );
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

	while ( true )
	{
		level waittill( "between_round_over" );

		if ( level.round_number == level.next_dog_round )
		{
			level.music_round_override = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			dog_round_start();
			level.round_spawn_func = ::dog_round_spawning;

			if ( !isdefined( level.prev_dog_round_amount ) )
			{
				level.prev_dog_round_amount = randomintrange( 4, 6 );
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
		else if ( flag( "dog_round" ) )
		{
			dog_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.music_round_override = 0;
			level.dog_round_count += 1;
		}
	}
}