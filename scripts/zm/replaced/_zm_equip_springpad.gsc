#include maps\mp\zombies\_zm_equip_springpad;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_buildables;

springpadthink( weapon, electricradius, armed )
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "equip_springpad_zm_taken" );
    weapon endon( "death" );
    radiussquared = electricradius * electricradius;
    trigger = spawn( "trigger_box", weapon getcentroid(), 1, 48, 48, 32 );
    trigger.origin += anglestoforward( flat_angle( weapon.angles ) ) * -15;
    trigger.angles = weapon.angles;
    trigger enablelinkto();
    trigger linkto( weapon );
    weapon.trigger = trigger;
    weapon thread springpadthinkcleanup( trigger );
    direction_forward = anglestoforward( flat_angle( weapon.angles ) + vectorscale( ( -1, 0, 0 ), 60.0 ) );
    direction_vector = vectorscale( direction_forward, 1024 );
    direction_origin = weapon.origin + direction_vector;
    home_angles = weapon.angles;
    weapon.is_armed = 0;
    self thread springpad_fx( weapon );
    self thread springpad_animate( weapon, armed );

    weapon waittill( "armed" );

    weapon.is_armed = 1;
    weapon.fling_targets = [];
    self thread targeting_thread( weapon, trigger );

    while ( isdefined( weapon ) )
    {
        wait_for_targets( weapon );

        if ( isdefined( weapon.fling_targets ) && weapon.fling_targets.size > 0 )
        {
            weapon notify( "fling", weapon.zombies_only );
            weapon.is_armed = 0;
            weapon.zombies_only = 1;

            weapon.springpad_kills++;

            foreach ( ent in weapon.fling_targets )
            {
                if ( isplayer( ent ) )
                {
                    ent thread player_fling( weapon.origin + vectorscale( ( 0, 0, 1 ), 30.0 ), weapon.angles, direction_vector, weapon );
                    continue;
                }

                if ( isdefined( ent ) && isdefined( ent.custom_springpad_fling ) )
                {
                    if ( !isdefined( self.num_zombies_flung ) )
                        self.num_zombies_flung = 0;

                    self.num_zombies_flung++;
                    self notify( "zombie_flung" );
                    ent thread [[ ent.custom_springpad_fling ]]( weapon, self );
                    continue;
                }

                if ( isdefined( ent ) )
                {
                    if ( !isdefined( self.num_zombies_flung ) )
                        self.num_zombies_flung = 0;

                    self.num_zombies_flung++;
                    self notify( "zombie_flung" );

                    if ( !isdefined( weapon.fling_scaler ) )
                        weapon.fling_scaler = 1;

                    if ( isdefined( weapon.direction_vec_override ) )
                        direction_vector = weapon.direction_vec_override;

                    ent dodamage( ent.health + 666, ent.origin );
                    ent startragdoll();
                    ent launchragdoll( direction_vector / 4 * weapon.fling_scaler );
                }
            }

            weapon.fling_targets = [];

            weapon waittill( "armed" );

            weapon.is_armed = 1;

            if ( weapon.springpad_kills >= 15 )
            {
                self thread springpad_expired( weapon );
                return;
            }
        }
        else
            wait 0.1;
    }
}

player_fling( origin, angles, velocity, weapon )
{
    torigin = ( self.origin[0], self.origin[1], origin[2] );
    aorigin = ( origin + torigin ) * 0.5;
    trace = physicstrace( origin, torigin, vectorscale( ( -1, -1, 0 ), 15.0 ), ( 15, 15, 30 ), self );

    self setorigin( aorigin );
    wait_network_frame();
    self setvelocity( velocity );
}

wait_for_targets( weapon )
{
    weapon endon( "hi_priority_target" );

    while ( isdefined( weapon ) )
    {
        if ( isdefined( weapon.fling_targets ) && weapon.fling_targets.size > 0 )
        {
            return;
        }

        wait 0.05;
    }
}

#using_animtree("zombie_springpad");

springpad_animate( weapon, armed )
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "equip_springpad_zm_taken" );
    weapon endon( "death" );
    weapon useanimtree( #animtree );
    f_animlength = getanimlength( %o_zombie_buildable_tramplesteam_reset_zombie );
    r_animlength = getanimlength( %o_zombie_buildable_tramplesteam_reset );
    l_animlength = getanimlength( %o_zombie_buildable_tramplesteam_launch );
    weapon thread springpad_audio();
    prearmed = 0;

    if ( isdefined( armed ) && armed )
        prearmed = 1;

    fast_reset = 0;

    while ( isdefined( weapon ) )
    {
        if ( !prearmed )
        {
            if ( fast_reset )
            {
                weapon setanim( %o_zombie_buildable_tramplesteam_reset_zombie );
                weapon thread playspringpadresetaudio( f_animlength );
                wait( f_animlength );
            }
            else
            {
                weapon setanim( %o_zombie_buildable_tramplesteam_reset );
                weapon thread playspringpadresetaudio( r_animlength );
                wait( r_animlength );
            }
        }
        else
            wait 0.05;

        prearmed = 0;
        weapon notify( "armed" );
        fast_reset = 1;

        if ( isdefined( weapon ) )
        {
            weapon setanim( %o_zombie_buildable_tramplesteam_compressed_idle );

            weapon waittill( "fling", fast );
        }

        if ( isdefined( weapon ) )
        {
            weapon setanim( %o_zombie_buildable_tramplesteam_launch );
            wait( l_animlength );
        }
    }
}