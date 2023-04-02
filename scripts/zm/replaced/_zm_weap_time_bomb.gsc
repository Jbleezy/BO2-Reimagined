#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_time_bomb;

init_time_bomb()
{
    time_bomb_precache();
    level thread time_bomb_post_init();
    flag_init( "time_bomb_round_killed" );
    flag_init( "time_bomb_enemies_restored" );
    flag_init( "time_bomb_zombie_respawning_done" );
    flag_init( "time_bomb_restore_active" );
    flag_init( "time_bomb_restore_done" );
    flag_init( "time_bomb_global_restore_done" );
    flag_init( "time_bomb_detonation_enabled" );
    flag_init( "time_bomb_stores_door_state" );
    registerclientfield( "world", "time_bomb_saved_round_number", 12000, 8, "int" );
    registerclientfield( "world", "time_bomb_lua_override", 12000, 1, "int" );
    registerclientfield( "world", "time_bomb_hud_toggle", 12000, 1, "int" );
    registerclientfield( "toplayer", "sndTimebombLoop", 12000, 2, "int" );
    maps\mp\zombies\_zm_weapons::register_zombie_weapon_callback( "time_bomb_zm", ::player_give_time_bomb );
    level.zombiemode_time_bomb_give_func = ::player_give_time_bomb;
    include_weapon( "time_bomb_zm", 1 );
    maps\mp\zombies\_zm_weapons::add_limited_weapon( "time_bomb_zm", 1 );
    add_time_bomb_to_mystery_box();
    register_equipment_for_level( "time_bomb_zm" );
    register_equipment_for_level( "time_bomb_detonator_zm" );

    if ( !isdefined( level.round_wait_func ) )
        level.round_wait_func = ::time_bomb_round_wait;

    level.zombie_round_change_custom = ::time_bomb_custom_round_change;
    level._effect["time_bomb_set"] = loadfx( "weapon/time_bomb/fx_time_bomb_detonate" );
    level._effect["time_bomb_ammo_fx"] = loadfx( "misc/fx_zombie_powerup_on" );
    level._effect["time_bomb_respawns_enemy"] = loadfx( "maps/zombie_buried/fx_buried_time_bomb_spawn" );
    level._effect["time_bomb_kills_enemy"] = loadfx( "maps/zombie_buried/fx_buried_time_bomb_death" );
    level._time_bomb = spawnstruct();
    level._time_bomb.enemy_type = [];
    register_time_bomb_enemy( "zombie", ::is_zombie_round, ::time_bomb_saves_zombie_data, ::time_bomb_respawns_zombies );
    register_time_bomb_enemy_default( "zombie" );
    level._time_bomb.last_round_restored = -1;
    flag_set( "time_bomb_detonation_enabled" );
}

player_give_time_bomb()
{
    assert( isplayer( self ), "player_give_time_bomb can only be used on players!" );
    self giveweapon( "time_bomb_zm" );
    self swap_weapon_to_time_bomb();
    self thread show_time_bomb_hints();
    self thread time_bomb_think();
    self thread detonator_think();
    self thread time_bomb_inventory_slot_think();
    self thread destroy_time_bomb_save_if_user_bleeds_out_or_disconnects();
    self thread sndwatchforweapswitch();
}