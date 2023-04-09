#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_ai_ghost_ffotd;
#include maps\mp\zombies\_zm_ai_ghost;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_ai_basic;

should_last_ghost_drop_powerup()
{
    if ( flag( "time_bomb_restore_active" ) )
        return false;

    if ( !isdefined( level.ghost_round_last_ghost_origin ) )
        return false;

	if ( !is_true( level.ghost_round_no_damage ) )
		return false;

    return true;
}