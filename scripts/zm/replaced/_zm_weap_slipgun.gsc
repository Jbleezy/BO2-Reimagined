#include maps\mp\zombies\_zm_weap_slipgun;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_audio;

init()
{
    if ( !maps\mp\zombies\_zm_weapons::is_weapon_included( "slipgun_zm" ) )
        return;

    precachemodel( "t5_weapon_crossbow_bolt" );
    precacheitem( "slip_bolt_zm" );
    precacheitem( "slip_bolt_upgraded_zm" );

    if ( is_true( level.slipgun_as_equipment ) )
    {
        maps\mp\zombies\_zm_equipment::register_equipment( "slipgun_zm", &"ZM_HIGHRISE_EQUIP_SLIPGUN_PICKUP_HINT_STRING", &"ZM_HIGHRISE_EQUIP_SLIPGUN_HOWTO", "jetgun_zm_icon", "slipgun", ::slipgun_activation_watcher_thread, ::transferslipgun, ::dropslipgun, ::pickupslipgun );
        maps\mp\zombies\_zm_equipment::enemies_ignore_equipment( "slipgun_zm" );
        maps\mp\gametypes_zm\_weaponobjects::createretrievablehint( "slipgun", &"ZM_HIGHRISE_EQUIP_SLIPGUN_PICKUP_HINT_STRING" );
    }

    set_zombie_var_once( "slipgun_reslip_max_spots", 8 );
    set_zombie_var_once( "slipgun_reslip_rate", 6 );
    set_zombie_var_once( "slipgun_max_kill_chain_depth", 16 );
    set_zombie_var_once( "slipgun_max_kill_round", 100 );
    set_zombie_var_once( "slipgun_chain_radius", 120 );
    set_zombie_var_once( "slipgun_chain_wait_min", 0.75, 1 );
    set_zombie_var_once( "slipgun_chain_wait_max", 1.5, 1 );
    level.slippery_spot_count = 0;
    level.sliquifier_distance_checks = 0;
    maps\mp\zombies\_zm_spawner::register_zombie_damage_callback( ::slipgun_zombie_damage_response );
    maps\mp\zombies\_zm_spawner::register_zombie_death_animscript_callback( ::slipgun_zombie_death_response );
    level._effect["slipgun_explode"] = loadfx( "weapon/liquifier/fx_liquifier_goo_explo" );
    level._effect["slipgun_splatter"] = loadfx( "maps/zombie/fx_zmb_goo_splat" );
    level._effect["slipgun_simmer"] = loadfx( "weapon/liquifier/fx_liquifier_goo_sizzle" );
    level._effect["slipgun_viewmodel_eject"] = loadfx( "weapon/liquifier/fx_liquifier_clip_eject" );
    level._effect["slipgun_viewmodel_reload"] = loadfx( "weapon/liquifier/fx_liquifier_reload_steam" );
    onplayerconnect_callback( ::slipgun_player_connect );
    thread wait_init_damage();
}

slipgun_zombie_death_response()
{
    if ( !isDefined( self.goo_chain_depth ) )
        return false;

    level maps\mp\zombies\_zm_spawner::zombie_death_points( self.origin, self.damagemod, self.damagelocation, self.attacker, self );
    self explode_into_goo( self.attacker, 0 );
    return true;
}

slipgun_zombie_1st_hit_response( upgraded, player )
{
    self notify( "stop_find_flesh" );
    self notify( "zombie_acquire_enemy" );
    self orientmode( "face default" );
    self.ignoreall = 1;
    self.gibbed = 1;

    if ( isalive( self ) )
    {
        if ( !isdefined( self.goo_chain_depth ) )
            self.goo_chain_depth = 0;

        self.goo_upgraded = upgraded;

        if ( self.health > 0 )
        {
            if ( player maps\mp\zombies\_zm_powerups::is_insta_kill_active() )
                self.health = 1;

            self dodamage( level.slipgun_damage, self.origin, player, player, "none", level.slipgun_damage_mod, 0, "slip_goo_zm" );
        }
    }
}

explode_into_goo( player, chain_depth )
{
    if ( isdefined( self.marked_for_insta_upgraded_death ) )
        return;

    tag = "J_SpineLower";

    if ( is_true( self.isdog ) )
        tag = "tag_origin";

    self.guts_explosion = 1;
    self playsound( "wpn_slipgun_zombie_explode" );

    if ( isdefined( level._effect["slipgun_explode"] ) )
        playfx( level._effect["slipgun_explode"], self gettagorigin( tag ) );

    if ( !is_true( self.isdog ) )
        wait 0.1;

    self ghost();

    if ( !isdefined( self.goo_chain_depth ) )
        self.goo_chain_depth = chain_depth;

    chain_radius = level.zombie_vars["slipgun_chain_radius"];
    if ( is_true( self.goo_upgraded ) )
    {
        chain_radius *= 1.5;
    }

    level thread explode_to_near_zombies( player, self.origin, chain_radius, self.goo_chain_depth, self.goo_upgraded );
}

explode_to_near_zombies( player, origin, radius, chain_depth, goo_upgraded )
{
    if ( level.zombie_vars["slipgun_max_kill_chain_depth"] > 0 && chain_depth > level.zombie_vars["slipgun_max_kill_chain_depth"] )
        return;

    enemies = get_round_enemy_array();
    enemies = get_array_of_closest( origin, enemies );

    minchainwait = level.zombie_vars["slipgun_chain_wait_min"];
    maxchainwait = level.zombie_vars["slipgun_chain_wait_max"];

    rsquared = radius * radius;
    tag = "J_Head";
    marked_zombies = [];

    if ( isdefined( enemies ) && enemies.size )
    {
        index = 0;

        for ( enemy = enemies[index]; distancesquared( enemy.origin, origin ) < rsquared; enemy = enemies[index] )
        {
            if ( isalive( enemy ) && !is_true( enemy.guts_explosion ) && !is_true( enemy.nuked ) && !isdefined( enemy.slipgun_sizzle ) )
            {
                trace = bullettrace( origin + vectorscale( ( 0, 0, 1 ), 50.0 ), enemy.origin + vectorscale( ( 0, 0, 1 ), 50.0 ), 0, undefined, 1 );

                if ( isdefined( trace["fraction"] ) && trace["fraction"] == 1 )
                {
                    enemy.slipgun_sizzle = playfxontag( level._effect["slipgun_simmer"], enemy, tag );
                    marked_zombies[marked_zombies.size] = enemy;
                }
            }

            index++;

            if ( index >= enemies.size )
                break;
        }
    }

    if ( isdefined( marked_zombies ) && marked_zombies.size )
    {
        foreach ( enemy in marked_zombies )
        {
            if ( isalive( enemy ) && !is_true( enemy.guts_explosion ) && !is_true( enemy.nuked ) )
            {
                wait( randomfloatrange( minchainwait, maxchainwait ) );

                if ( isalive( enemy ) && !is_true( enemy.guts_explosion ) && !is_true( enemy.nuked ) )
                {
                    if ( !isdefined( enemy.goo_chain_depth ) )
                        enemy.goo_chain_depth = chain_depth;

                    enemy.goo_upgraded = goo_upgraded;

                    if ( enemy.health > 0 )
                    {
                        if ( player maps\mp\zombies\_zm_powerups::is_insta_kill_active() )
                            enemy.health = 1;

                        enemy dodamage( level.slipgun_damage, origin, player, player, "none", level.slipgun_damage_mod, 0, "slip_goo_zm" );
                    }

                    if ( level.slippery_spot_count < level.zombie_vars["slipgun_reslip_max_spots"] )
                    {
                        if ( ( !isdefined( enemy.slick_count ) || enemy.slick_count == 0 ) && enemy.health <= 0 )
                        {
                            if ( level.zombie_vars["slipgun_reslip_rate"] > 0 && randomint( level.zombie_vars["slipgun_reslip_rate"] ) == 0 )
                            {
                                startpos = origin;
                                duration = 24;
                                thread add_slippery_spot( enemy.origin, duration, startpos );
                            }
                        }
                    }
                }
            }
        }
    }
}