#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_weap_staff_lightning;

staff_lightning_ball_damage_over_time( e_source, e_target, e_attacker )
{
    e_attacker endon( "disconnect" );
    e_target setclientfield( "lightning_impact_fx", 1 );
    e_target thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "electrocute", e_target.animname );
    n_range_sq = e_source.n_range * e_source.n_range;
    e_target.is_being_zapped = 1;
    e_target setclientfield( "lightning_arc_fx", 1 );
    wait 0.5;

    if ( isdefined( e_source ) )
    {
        if ( !isdefined( e_source.n_damage_per_sec ) )
            e_source.n_damage_per_sec = get_lightning_ball_damage_per_sec( e_attacker.chargeshotlevel );

        n_damage_per_pulse = e_source.n_damage_per_sec * 1.0;
    }

    while ( isdefined( e_source ) && isalive( e_target ) )
    {
        e_target thread stun_zombie();
        wait 1.0;

        if ( !isdefined( e_source ) || !isalive( e_target ) )
            break;

        n_dist_sq = distancesquared( e_source.origin, e_target.origin );

        if ( n_dist_sq > n_range_sq )
            break;

        if ( isalive( e_target ) && isdefined( e_source ) )
        {
            e_target thread zombie_shock_eyes();
            e_target thread staff_lightning_kill_zombie( e_attacker, e_source.str_weapon );
            break;
        }
    }

    if ( isdefined( e_target ) )
    {
        e_target.is_being_zapped = 0;
        e_target setclientfield( "lightning_arc_fx", 0 );
    }
}

get_lightning_ball_damage_per_sec( n_charge )
{
    return 2500;
}