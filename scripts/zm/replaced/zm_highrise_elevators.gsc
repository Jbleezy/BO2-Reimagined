#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\zm_highrise_utility;
#include maps\mp\zm_highrise_distance_tracking;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\zm_highrise_elevators;

faller_location_logic()
{
    wait 1;
    faller_spawn_points = getstructarray( "faller_location", "script_noteworthy" );
    leaper_spawn_points = getstructarray( "leaper_location", "script_noteworthy" );
    spawn_points = arraycombine( faller_spawn_points, leaper_spawn_points, 1, 0 );
    dist_check = 65536;
    elevator_names = getarraykeys( level.elevators );
    elevators = [];

    for ( i = 0; i < elevator_names.size; i++ )
        elevators[i] = getent( "elevator_" + elevator_names[i] + "_body", "targetname" );

    elevator_volumes = [];
    elevator_volumes[elevator_volumes.size] = getent( "elevator_1b", "targetname" );
    elevator_volumes[elevator_volumes.size] = getent( "elevator_1c", "targetname" );
    elevator_volumes[elevator_volumes.size] = getent( "elevator_1d", "targetname" );
    elevator_volumes[elevator_volumes.size] = getent( "elevator_3a", "targetname" );
    elevator_volumes[elevator_volumes.size] = getent( "elevator_3b", "targetname" );
    elevator_volumes[elevator_volumes.size] = getent( "elevator_3c", "targetname" );
    elevator_volumes[elevator_volumes.size] = getent( "elevator_3d", "targetname" );
    level.elevator_volumes = elevator_volumes;

    while ( true )
    {
        foreach ( point in spawn_points )
        {
            should_block = 0;

            foreach ( elevator in elevators )
            {
                if ( distancesquared( elevator getCentroid(), point.origin ) <= dist_check )
                    should_block = 1;
            }

            if ( should_block )
            {
                point.is_enabled = 0;
                point.is_blocked = 1;
                continue;
            }

            if ( isdefined( point.is_blocked ) && point.is_blocked )
                point.is_blocked = 0;

            if ( !isdefined( point.zone_name ) )
                continue;

            zone = level.zones[point.zone_name];

            if ( zone.is_enabled && zone.is_active && zone.is_spawning_allowed )
                point.is_enabled = 1;
        }

        players = get_players();

        foreach ( volume in elevator_volumes )
        {
            should_disable = 0;

            foreach ( player in players )
            {
                if ( is_player_valid( player ) )
                {
                    if ( player istouching( volume ) )
                        should_disable = 1;
                }
            }

            if ( should_disable )
                disable_elevator_spawners( volume, spawn_points );
        }

        wait 0.05;
    }
}