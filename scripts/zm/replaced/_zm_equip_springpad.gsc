#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_equip_springpad;
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

			weapon.springpad_kills++;

            if ( weapon.springpad_kills >= 15 )
                self thread springpad_expired( weapon );

            weapon.fling_targets = [];

            weapon waittill( "armed" );

            weapon.is_armed = 1;
        }
        else
            wait 0.1;
    }
}