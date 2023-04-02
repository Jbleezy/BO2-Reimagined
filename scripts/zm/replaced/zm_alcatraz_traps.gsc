#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\zm_alcatraz_traps;

tower_trap_trigger_think()
{
    self.range_trigger = getent( self.target, "targetname" );
    self.upgrade_trigger = getent( self.script_string, "script_noteworthy" );
    self.cost = 1000;
    light_name = self get_trap_light_name();
    zapper_light_green( light_name );
    self.is_available = 1;
    self.in_use = 0;
    self.has_been_used = 0;
    self.sndtowerent = spawn( "script_origin", ( -21, 5584, 356 ) );
    self tower_trap_weapon();
    self.upgrade_trigger.cost = 1000;
    self.upgrade_trigger.in_use = 0;
    self.upgrade_trigger.is_available = 1;

    while ( true )
    {
        self hint_string( &"ZM_PRISON_TOWER_TRAP", self.cost );

        self waittill( "trigger", who );

        if ( who in_revive_trigger() )
            continue;

        if ( !isdefined( self.is_available ) )
            continue;

        if ( is_player_valid( who ) )
        {
            if ( who.score >= self.cost )
            {
                if ( !self.in_use )
                {
                    if ( !self.has_been_used )
                    {
                        self.has_been_used = 1;
                        who do_player_general_vox( "general", "discover_trap" );
                    }
                    else
                        who do_player_general_vox( "general", "start_trap" );

                    self.in_use = 1;
                    self.active = 1;
                    play_sound_at_pos( "purchase", who.origin );
                    self thread tower_trap_move_switch( self );
                    self playsound( "zmb_trap_activate" );

                    self waittill( "switch_activated" );

                    who minus_to_player_score( self.cost );
                    level.trapped_track["tower"] = 1;
                    level notify( "trap_activated" );
                    who maps\mp\zombies\_zm_stats::increment_client_stat( "prison_sniper_tower_used", 0 );
                    self hint_string( &"ZOMBIE_TRAP_ACTIVE" );
                    self.sndtowerent playsound( "zmb_trap_tower_start" );
                    self.sndtowerent playloopsound( "zmb_trap_tower_loop", 1 );
                    self thread activate_tower_trap();
                    self thread tower_trap_timer();

                    if (is_true(self.upgrade_trigger.is_available) && is_gametype_active("zclassic"))
                    {
                        self thread tower_upgrade_trigger_think();
                        level thread open_tower_trap_upgrade_panel();
                        level thread tower_trap_upgrade_panel_closes_early();
                    }

                    self waittill( "tower_trap_off" );

                    self.sndtowerent stoploopsound( 1 );
                    self.sndtowerent playsound( "zmb_trap_tower_end" );
                    self.active = 0;
                    self sethintstring( &"ZOMBIE_TRAP_COOLDOWN" );
                    zapper_light_red( light_name );
                    wait 25;
                    self playsound( "zmb_trap_available" );
                    self notify( "available" );
                    self.in_use = 0;
                }
            }
        }
    }
}

tower_trap_weapon()
{
    self.weapon_name = "tower_trap_zm";
    self.tag_to_target = "J_Head";
    self.trap_reload_time = 0.75;
}

activate_tower_trap()
{
    self endon( "tower_trap_off" );

    while ( true )
    {
        zombies = getaiarray( level.zombie_team );

        if (is_gametype_active("zgrief"))
        {
            zombies = arraycombine(zombies, get_players(), 1, 0);
        }

        zombies_sorted = [];

        foreach ( zombie in zombies )
        {
            if ( zombie istouching( self.range_trigger ) )
                zombies_sorted[zombies_sorted.size] = zombie;
        }

        if ( zombies_sorted.size <= 0 )
        {
            wait_network_frame();
            continue;
        }
        else
        {
            wait_network_frame();
            self tower_trap_fires( zombies_sorted );
        }
    }
}

tower_trap_fires( a_zombies )
{
    if ( isdefined( level.custom_tower_trap_fires_func ) )
    {
        self thread [[ level.custom_tower_trap_fires_func ]]( a_zombies );
        return;
    }

    if ( a_zombies.size <= 0 )
        return;

    self endon( "tower_trap_off" );
    e_org = getstruct( self.range_trigger.target, "targetname" );
    n_index = randomintrange( 0, a_zombies.size );

    while ( 1 )
    {
        e_target = a_zombies[n_index];

        if ( !isalive( e_target ) )
        {
            arrayremovevalue( a_zombies, e_target, 0 );

            if ( a_zombies.size <= 0 )
                return;

            n_index = randomintrange( 0, a_zombies.size );

            continue;
        }

        if ( isplayer( e_target ) && e_target maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        {
            arrayremovevalue( a_zombies, e_target, 0 );

            if ( a_zombies.size <= 0 )
                return;

            n_index = randomintrange( 0, a_zombies.size );

            continue;
        }

        v_zombietarget = e_target gettagorigin( self.tag_to_target );

        if ( sighttracepassed( e_org.origin, v_zombietarget, 1, undefined ) )
        {
            magicbullet( self.weapon_name, e_org.origin, v_zombietarget );
            wait( self.trap_reload_time );
        }
        else
        {
            arrayremovevalue( a_zombies, e_target, 0 );

            if ( a_zombies.size <= 0 )
                return;

            n_index = randomintrange( 0, a_zombies.size );

            continue;
        }
    }
}

tower_upgrade_trigger_think()
{
    self endon( "tower_trap_off" );

    level waittill( self.upgrade_trigger.script_string );

    self.upgrade_trigger.in_use = 1;
    self.upgrade_trigger.is_available = 0;

    level.trapped_track["tower_upgrade"] = 1;
    level notify( "tower_trap_upgraded" );
    level notify( "close_tower_trap_upgrade_panel" );
    self upgrade_tower_trap_weapon();
    self notify( "tower_trap_reset_timer" );
    self thread tower_trap_timer();

    self thread tower_upgrade_reset_after_round();
}

tower_upgrade_reset_after_round()
{
    level waittill( "end_of_round" );

    self tower_trap_weapon();
    self.upgrade_trigger notify( "afterlife_interact_reset" );
    self.upgrade_trigger notify( "available" );
    self.upgrade_trigger.in_use = 0;
    self.upgrade_trigger.is_available = 1;
}