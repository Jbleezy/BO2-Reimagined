#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_ai_avogadro;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zm_transit_bus;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weap_riotshield;

check_range_attack()
{
    enemy = self.favoriteenemy;

    if ( isdefined( enemy ) )
    {
        vec_enemy = enemy.origin - self.origin;
        dist_sq = lengthsquared( vec_enemy );

        if ( dist_sq > 4096 && dist_sq < 360000 )
        {
            vec_facing = anglestoforward( self.angles );
            norm_facing = vectornormalize( vec_facing );
            norm_enemy = vectornormalize( vec_enemy );
            dot = vectordot( norm_facing, norm_enemy );

            if ( dot > 0.99 )
            {
                enemy_eye_pos = enemy geteye();
                eye_pos = self geteye();
                passed = bullettracepassed( eye_pos, enemy_eye_pos, 0, undefined );

                if ( passed )
                    return true;
            }
        }
    }

    return false;
}