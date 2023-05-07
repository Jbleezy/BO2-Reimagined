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

avogadro_exit( from )
{
    powerup_origin = spawn( "script_origin", self.origin );
    if ( self.state == "attacking_bus" || self.state == "stay_attached" )
    {
        powerup_origin linkto( level.the_bus );
    }

    self.state = "exiting";
    self notify( "stop_find_flesh" );
    self notify( "zombie_acquire_enemy" );
    self setfreecameralockonallowed( 0 );
    self.audio_loop_ent stoploopsound( 0.5 );
    self notify( "stop_health" );

    if ( isdefined( self.health_fx ) )
    {
        self.health_fx unlink();
        self.health_fx delete();
    }

    if ( isdefined( from ) )
    {
        if ( from == "bus" )
        {
            self playsound( "zmb_avogadro_death_short" );
            playfx( level._effect["avogadro_ascend_aerial"], self.origin );
            self animscripted( self.origin, self.angles, "zm_bus_win" );
            maps\mp\animscripts\zm_shared::donotetracks( "bus_win_anim" );
        }
        else if ( from == "chamber" )
        {
            self playsound( "zmb_avogadro_death_short" );
            playfx( level._effect["avogadro_ascend"], self.origin );
            self animscripted( self.origin, self.angles, "zm_chamber_out" );
            wait 0.4;
            self ghost();
            stop_exploder( 500 );
        }
        else
        {
            self playsound( "zmb_avogadro_death" );
            playfx( level._effect["avogadro_ascend"], self.origin );
            self animscripted( self.origin, self.angles, "zm_exit" );
            maps\mp\animscripts\zm_shared::donotetracks( "exit_anim" );
        }
    }
    else
    {
        self playsound( "zmb_avogadro_death" );
        playfx( level._effect["avogadro_ascend"], self.origin );
        self animscripted( self.origin, self.angles, "zm_exit" );
        maps\mp\animscripts\zm_shared::donotetracks( "exit_anim" );
    }

    if ( !isdefined( from ) || from != "chamber" )
        level thread do_avogadro_flee_vo( self );

    self ghost();
    self.hit_by_melee = 0;
    self.anchor.origin = self.origin;
    self.anchor.angles = self.angles;
    self linkto( self.anchor );

    if ( isdefined( from ) && from == "exit_idle" )
        self.return_round = level.round_number + 1;
    else
        self.return_round = level.round_number + randomintrange( 2, 5 );

    level.next_avogadro_round = self.return_round;
    self.state = "cloud";
    self thread cloud_update_fx();

	if ( !isdefined( from ) )
	{
		if ( level.powerup_drop_count >= level.zombie_vars["zombie_powerup_drop_max_per_round"] )
			level.powerup_drop_count = level.zombie_vars["zombie_powerup_drop_max_per_round"] - 1;

		level.zombie_vars["zombie_drop_item"] = 1;
		level thread maps\mp\zombies\_zm_powerups::powerup_drop( powerup_origin.origin );
	}

    powerup_origin delete();
}