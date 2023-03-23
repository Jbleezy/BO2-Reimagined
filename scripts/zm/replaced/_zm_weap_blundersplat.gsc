#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_weap_blundersplat;

_titus_target_animate_and_die( n_fuse_timer, inflictor )
{
    self endon( "death" );
    self endon( "titus_target_timeout" );
    self thread _titus_target_timeout( n_fuse_timer );
    self thread _titus_check_for_target_death( inflictor );
    self thread _blundersplat_target_acid_stun_anim();
    wait( n_fuse_timer );
    self notify( "killed_by_a_blundersplat", inflictor );
    self dodamage( self.health + 1000, self.origin, inflictor );
}