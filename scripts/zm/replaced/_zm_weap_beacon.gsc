#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_weap_beacon;

wait_and_do_weapon_beacon_damage( index )
{
    wait 3.0;
    v_damage_origin = self.a_v_land_spots[index];
    level.n_weap_beacon_zombie_thrown_count = 0;
    a_zombies_to_kill = [];
    a_zombies = getaispeciesarray( "axis", "all" );

    foreach ( zombie in a_zombies )
    {
        n_distance = distance( zombie.origin, v_damage_origin );

        if ( n_distance <= 200 )
        {
            a_zombies_to_kill[a_zombies_to_kill.size] = zombie;
        }
    }

    if ( index == 0 )
    {
        radiusdamage( self.origin + vectorscale( ( 0, 0, 1 ), 12.0 ), 10, 1, 1, self.owner, "MOD_GRENADE_SPLASH", "beacon_zm" );
        self ghost();
        self stopanimscripted( 0 );
    }

    level thread weap_beacon_zombie_death( self, a_zombies_to_kill );
    self thread weap_beacon_rumble();
}

weap_beacon_zombie_death( model, a_zombies_to_kill )
{
    for ( i = 0; i < a_zombies_to_kill.size; i++ )
    {
        zombie = a_zombies_to_kill[i];

        if ( !isdefined( zombie ) || !isalive( zombie ) )
            continue;

        zombie thread set_beacon_damage();
        zombie dodamage( zombie.health, zombie.origin, model.owner, model.owner, "none", "MOD_GRENADE_SPLASH", 0, "beacon_zm" );
        zombie thread weapon_beacon_launch_ragdoll();
    }
}