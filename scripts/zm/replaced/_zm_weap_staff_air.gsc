#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_weap_staff_air;

whirlwind_kill_zombies( n_level, str_weapon )
{
    self endon( "death" );
    n_range = get_air_blast_range( n_level );
    self.n_charge_level = n_level;

    while ( true )
    {
        a_zombies = staff_air_zombie_range( self.origin, n_range );
        a_zombies = get_array_of_closest( self.origin, a_zombies );

        for ( i = 0; i < a_zombies.size; i++ )
        {
            if ( !isdefined( a_zombies[i] ) )
                continue;

            if ( a_zombies[i].ai_state != "find_flesh" )
                continue;

            if ( is_true( self._whirlwind_attract_anim ) )
                continue;

            v_offset = ( 10, 10, 32 );

            if ( !bullet_trace_throttled( self.origin + v_offset, a_zombies[i].origin + v_offset, undefined ) )
                continue;

            if ( !isdefined( a_zombies[i] ) || !isalive( a_zombies[i] ) )
                continue;

            v_offset = ( -10, -10, 64 );

            if ( !bullet_trace_throttled( self.origin + v_offset, a_zombies[i].origin + v_offset, undefined ) )
                continue;

            if ( !isdefined( a_zombies[i] ) || !isalive( a_zombies[i] ) )
                continue;

            if ( is_true( a_zombies[i].is_mechz ) )
            {
                a_zombies[i] do_damage_network_safe( self.player_owner, 3300, str_weapon, "MOD_IMPACT" );
            }
            else
            {
                a_zombies[i] thread whirlwind_drag_zombie( self, str_weapon );
            }

            wait 0.5;
        }

        wait_network_frame();
    }
}