#include maps\mp\zombies\_zm_perk_vulture;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_ai_basic;

_is_player_in_zombie_stink( a_points )
{
    b_is_in_stink = 0;

    for ( i = 0; i < a_points.size; i++ )
    {
        if ( distancesquared( a_points[i].origin, self.origin ) < 4900 && self getStance() != "stand" )
            b_is_in_stink = 1;
    }

    return b_is_in_stink;
}