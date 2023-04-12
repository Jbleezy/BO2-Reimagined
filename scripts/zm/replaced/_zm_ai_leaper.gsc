#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_highrise_elevators;
#include maps\mp\zombies\_zm_ai_leaper;

leaper_round_tracker()
{
    level.leaper_round_count = 1;
    level.next_leaper_round = level.round_number + randomintrange( 4, 6 );
    old_spawn_func = level.round_spawn_func;
    old_wait_func = level.round_wait_func;

	if (level.next_leaper_round == 5)
	{
		level.prev_leaper_round_amount = 4;
	}
	else
	{
		level.prev_leaper_round_amount = 5;
	}

    while ( true )
    {
        level waittill( "between_round_over" );

        if ( level.round_number == level.next_leaper_round )
        {
            level.music_round_override = 1;
            old_spawn_func = level.round_spawn_func;
            old_wait_func = level.round_wait_func;
            leaper_round_start();
            level.round_spawn_func = ::leaper_round_spawning;
            level.round_wait_func = ::leaper_round_wait;
            level.next_leaper_round = level.round_number + randomintrange( 4, 6 );

			if( !isdefined( level.prev_leaper_round_amount ) )
			{
				level.prev_leaper_round_amount = randomintrange( 4, 6 );
				level.next_leaper_round = level.round_number + level.prev_leaper_round_amount;
			}
			else
			{
				if (level.prev_leaper_round_amount == 4)
				{
					level.next_leaper_round = level.round_number + 5;
				}
				else
				{
					level.next_leaper_round = level.round_number + 4;
				}

				level.prev_leaper_round_amount = undefined;
			}
        }
        else if ( flag( "leaper_round" ) )
        {
            leaper_round_stop();
            level.round_spawn_func = old_spawn_func;
            level.round_wait_func = old_wait_func;
            level.music_round_override = 0;
            level.leaper_round_count += 1;
        }
    }
}