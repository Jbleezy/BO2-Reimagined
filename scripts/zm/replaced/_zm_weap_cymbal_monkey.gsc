#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;

player_handle_cymbal_monkey()
{
    self notify( "starting_monkey_watch" );
    self endon( "disconnect" );
    self endon( "starting_monkey_watch" );
    attract_dist_diff = level.monkey_attract_dist_diff;

    if ( !isdefined( attract_dist_diff ) )
        attract_dist_diff = 45;

    num_attractors = level.num_monkey_attractors;

    if ( !isdefined( num_attractors ) )
        num_attractors = 96;

    max_attract_dist = level.monkey_attract_dist;

    if ( !isdefined( max_attract_dist ) )
        max_attract_dist = 1536;

    while ( true )
    {
        grenade = get_thrown_monkey();
        self thread player_throw_cymbal_monkey( grenade, num_attractors, max_attract_dist, attract_dist_diff );
    }
}