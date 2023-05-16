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

leaper_round_accuracy_tracking()
{
    players = getplayers();
    level.leaper_round_accurate_players = 0;

    for ( i = 0; i < players.size; i++ )
    {
        players[i].total_shots_start_leaper_round = players[i] maps\mp\gametypes_zm\_globallogic_score::getpersstat( "total_shots" );
        players[i].total_hits_start_leaper_round = players[i] maps\mp\gametypes_zm\_globallogic_score::getpersstat( "hits" );
    }

    level waittill( "last_leaper_down" );

    players = getplayers();

    for ( i = 0; i < players.size; i++ )
    {
        total_shots_end_leaper_round = players[i] maps\mp\gametypes_zm\_globallogic_score::getpersstat( "total_shots" ) - players[i].total_shots_start_leaper_round;
        total_hits_end_leaper_round = players[i] maps\mp\gametypes_zm\_globallogic_score::getpersstat( "hits" ) - players[i].total_hits_start_leaper_round;

        if ( total_shots_end_leaper_round == total_hits_end_leaper_round )
            level.leaper_round_accurate_players++;
    }

    if ( level.leaper_round_accurate_players == players.size )
    {
        if ( isdefined( level.last_leaper_origin ) )
        {
            trace = groundtrace( level.last_leaper_origin + vectorscale( ( 0, 0, 1 ), 10.0 ), level.last_leaper_origin + vectorscale( ( 0, 0, -1 ), 150.0 ), 0, undefined, 1 );
            power_up_origin = trace["position"];
            level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( "free_perk", power_up_origin + vectorscale( ( 1, 1, 0 ), 30.0 ) );
        }
    }
}

leaper_death()
{
    self endon( "leaper_cleanup" );

    self waittill( "death" );

    self leaper_stop_trail_fx();
    self playsound( "zmb_vocals_leaper_death" );
    playfx( level._effect["leaper_death"], self.origin );

    if ( get_current_zombie_count() == 0 && level.zombie_total == 0 )
    {
        level.last_leaper_origin = self.origin;
        level notify( "last_leaper_down" );
    }

    if ( isplayer( self.attacker ) )
    {
        self.deathpoints_already_given = 1;

        event = "death";

        if ( issubstr( self.damageweapon, "knife_ballistic_" ) )
            event = "ballistic_knife_death";

        self.attacker thread do_player_general_vox( "general", "leaper_killed", 20, 20 );
        self.attacker maps\mp\zombies\_zm_score::player_add_points( event, self.damagemod, self.damagelocation, 1 );
    }
}