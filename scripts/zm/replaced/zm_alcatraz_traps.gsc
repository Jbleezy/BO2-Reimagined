#include maps\mp\zm_alcatraz_traps;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_ai_brutus;

init_fan_trap_trigs()
{
    trap_trigs = getentarray( "fan_trap_use_trigger", "targetname" );
    array_thread( trap_trigs, ::fan_trap_think );
    init_fan_fxanim( "wardens_office" );
}

fan_trap_think()
{
    triggers = getentarray( self.targetname, "targetname" );
    self.cost = 1000;
    self.in_use = 0;
    self.is_available = 1;
    self.has_been_used = 0;
    self.zombie_dmg_trig = getent( self.target, "targetname" );
    self.zombie_dmg_trig.script_string = self.script_string;
    self.zombie_dmg_trig.in_use = 0;
    self.rumble_trig = getent( "fan_trap_rumble", "targetname" );
    light_name = self get_trap_light_name();
    zapper_light_red( light_name );
    self sethintstring( &"ZM_PRISON_FAN_TRAP_UNAVAILABLE" );
    flag_wait( "activate_warden_office" );
    zapper_light_green( light_name );
    self hint_string( &"ZM_PRISON_FAN_TRAP", self.cost );

    while ( true )
    {
        self waittill( "trigger", who );

        if ( who in_revive_trigger() )
            continue;

        if ( !isdefined( self.is_available ) )
            continue;

        if ( is_player_valid( who ) )
        {
            if ( who.score >= self.cost )
            {
                if ( !self.zombie_dmg_trig.in_use )
                {
                    if ( !self.has_been_used )
                    {
                        self.has_been_used = 1;
                        level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "trap" );
                        who do_player_general_vox( "general", "discover_trap" );
                    }
                    else
                        who do_player_general_vox( "general", "start_trap" );

                    array_thread( triggers, ::hint_string, &"ZOMBIE_TRAP_ACTIVE" );
                    self.zombie_dmg_trig.in_use = 1;
                    self.zombie_dmg_trig.active = 1;
                    self playsound( "zmb_trap_activate" );
                    self thread fan_trap_move_switch( self );

                    self waittill( "switch_activated" );

                    who minus_to_player_score( self.cost );
                    level.trapped_track["fan"] = 1;
                    level notify( "trap_activated" );
                    who maps\mp\zombies\_zm_stats::increment_client_stat( "prison_fan_trap_used", 0 );
                    self.zombie_dmg_trig setvisibletoall();
                    self thread activate_fan_trap();

                    self.zombie_dmg_trig waittill( "trap_finished_" + self.script_string );

                    clientnotify( self.script_string + "off" );
                    self.zombie_dmg_trig notify( "fan_trap_finished" );
                    self.zombie_dmg_trig.active = 0;
                    self.zombie_dmg_trig setinvisibletoall();
                    array_thread( triggers, ::hint_string, &"ZOMBIE_TRAP_COOLDOWN" );
                    wait 25;
                    self playsound( "zmb_trap_available" );
                    self notify( "available" );
                    self.zombie_dmg_trig.in_use = 0;
                    array_thread( triggers, ::hint_string, &"ZM_PRISON_FAN_TRAP", self.cost );
                }
            }
        }
    }
}

init_acid_trap_trigs()
{
    trap_trigs = getentarray( "acid_trap_trigger", "targetname" );
    array_thread( trap_trigs, ::acid_trap_think );
    level thread acid_trap_host_migration_listener();
}

acid_trap_think()
{
    triggers = getentarray( self.targetname, "targetname" );
    self.is_available = 1;
    self.has_been_used = 0;
    self.cost = 1000;
    self.in_use = 0;
    self.zombie_dmg_trig = getent( self.target, "targetname" );
    self.zombie_dmg_trig.in_use = 0;
    light_name = self get_trap_light_name();
    zapper_light_red( light_name );
    self sethintstring( &"ZM_PRISON_ACID_TRAP_UNAVAILABLE" );
    flag_wait_any( "activate_cafeteria", "activate_infirmary" );
    zapper_light_green( light_name );
    self hint_string( &"ZM_PRISON_ACID_TRAP", self.cost );

    while ( true )
    {
        self waittill( "trigger", who );

        if ( who in_revive_trigger() )
            continue;

        if ( !isdefined( self.is_available ) )
            continue;

        if ( is_player_valid( who ) )
        {
            if ( who.score >= self.cost )
            {
                if ( !self.zombie_dmg_trig.in_use )
                {
                    if ( !self.has_been_used )
                    {
                        self.has_been_used = 1;
                        level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "trap" );
                        who do_player_general_vox( "general", "discover_trap" );
                    }
                    else
                        who do_player_general_vox( "general", "start_trap" );

                    array_thread( triggers, ::hint_string, &"ZOMBIE_TRAP_ACTIVE" );
                    self.zombie_dmg_trig.in_use = 1;
                    self.zombie_dmg_trig.active = 1;
                    self playsound( "zmb_trap_activate" );
                    self thread acid_trap_move_switch( self );

                    self waittill( "switch_activated" );

                    who minus_to_player_score( self.cost );
                    level.trapped_track["acid"] = 1;
                    level notify( "trap_activated" );
                    who maps\mp\zombies\_zm_stats::increment_client_stat( "prison_acid_trap_used", 0 );
                    self thread activate_acid_trap();

                    self.zombie_dmg_trig waittill( "acid_trap_fx_done" );

                    clientnotify( self.script_string + "off" );

                    if ( isdefined( self.fx_org ) )
                        self.fx_org delete();

                    if ( isdefined( self.zapper_fx_org ) )
                        self.zapper_fx_org delete();

                    if ( isdefined( self.zapper_fx_switch_org ) )
                        self.zapper_fx_switch_org delete();

                    self.zombie_dmg_trig notify( "acid_trap_finished" );
                    self.zombie_dmg_trig.active = 0;
                    array_thread( triggers, ::hint_string, &"ZOMBIE_TRAP_COOLDOWN" );
                    wait 25;
                    self playsound( "zmb_trap_available" );
                    self notify( "available" );
                    self.zombie_dmg_trig.in_use = 0;
                    array_thread( triggers, ::hint_string, &"ZM_PRISON_ACID_TRAP", self.cost );
                }
            }
        }
    }
}

zombie_acid_damage()
{
    self endon( "death" );
    self setclientfield( "acid_trap_death_fx", 1 );

    if ( !isdefined( self.is_brutus ) )
    {
        self.a.gib_ref = random( array( "right_arm", "left_arm", "head", "right_leg", "left_leg", "no_legs" ) );
        self thread maps\mp\animscripts\zm_death::do_gib();
    }

    self dodamage( self.health + 1000, self.origin );
}

player_acid_damage( t_damage )
{
    self endon( "death" );
    self endon( "disconnect" );
    t_damage endon( "acid_trap_finished" );

    if ( !isdefined( self.is_in_acid ) && !self player_is_in_laststand() )
    {
        self.is_in_acid = 1;
        self thread player_acid_damage_cooldown();

        self dodamage( self.maxhealth / 2, self.origin, t_damage, t_damage, "none", "MOD_UNKNOWN", 0, "none" );
        wait 1.5;
    }
}

player_acid_damage_cooldown()
{
    self endon( "disconnect" );
    wait 1.5;

    if ( isdefined( self ) )
        self.is_in_acid = undefined;
}

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

    if (is_gametype_active("zclassic"))
    {
        self thread tower_upgrade_trigger_think();
    }

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

                    self hint_string( &"ZOMBIE_TRAP_ACTIVE" );
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
                    self.sndtowerent playsound( "zmb_trap_tower_start" );
                    self.sndtowerent playloopsound( "zmb_trap_tower_loop", 1 );
                    self thread activate_tower_trap();
                    self thread tower_trap_timer();

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

tower_upgrade_trigger_think()
{
    while (1)
    {
        level thread open_tower_trap_upgrade_panel();

        level waittill( self.upgrade_trigger.script_string );

        self.upgrade_trigger.in_use = 1;
        self.upgrade_trigger.is_available = 0;

        level.trapped_track["tower_upgrade"] = 1;
        level notify( "tower_trap_upgraded" );
        level notify( "close_tower_trap_upgrade_panel" );
        self upgrade_tower_trap_weapon();

        level waittill( "end_of_round" );

        self tower_trap_weapon();
        self.upgrade_trigger notify( "afterlife_interact_reset" );
        self.upgrade_trigger notify( "available" );
        self.upgrade_trigger.in_use = 0;
        self.upgrade_trigger.is_available = 1;
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
            {
                zombies_sorted[zombies_sorted.size] = zombie;
            }
        }

        if ( zombies_sorted.size <= 0 )
        {
            wait 0.05;
            continue;
        }

        self tower_trap_fires( zombies_sorted );
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
    {
        return;
    }

    self endon( "tower_trap_off" );
    e_org = getstruct( self.range_trigger.target, "targetname" );

    while ( 1 )
    {
        if ( a_zombies.size <= 0 )
        {
            wait 0.05;
            return;
        }

        n_index = randomintrange( 0, a_zombies.size );
        e_target = a_zombies[n_index];

        if ( !isalive( e_target ) )
        {
            arrayremovevalue( a_zombies, e_target, 0 );
            continue;
        }

        if ( isplayer( e_target ) && e_target maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        {
            arrayremovevalue( a_zombies, e_target, 0 );
            continue;
        }

        v_zombietarget = e_target gettagorigin( self.tag_to_target );

        if ( sighttracepassed( e_org.origin, v_zombietarget, 1, undefined ) )
        {
            magicbullet( self.weapon_name, e_org.origin, v_zombietarget );

            wait( self.trap_reload_time );

            return;
        }
        else
        {
            arrayremovevalue( a_zombies, e_target, 0 );
            continue;
        }
    }
}