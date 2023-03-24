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
#include maps\mp\zombies\_zm_weap_slipgun;

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