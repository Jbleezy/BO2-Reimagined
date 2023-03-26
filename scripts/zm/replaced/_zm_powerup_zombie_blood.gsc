#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_powerup_zombie_blood;

zombie_blood_powerup( m_powerup, e_player )
{
    e_player notify( "zombie_blood" );
    e_player endon( "zombie_blood" );
    e_player endon( "disconnect" );
    e_player thread powerup_vo( "zombie_blood" );
    e_player._show_solo_hud = 1;
    e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
    e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 1;
    level notify( "player_zombie_blood", e_player );
    maps\mp\_visionset_mgr::vsmgr_activate( "visionset", "zm_powerup_zombie_blood_visionset", e_player );
    maps\mp\_visionset_mgr::vsmgr_activate( "overlay", "zm_powerup_zombie_blood_overlay", e_player );
    e_player setclientfield( "player_zombie_blood_fx", 1 );
    __new = [];

    foreach ( __key, __value in level.a_zombie_blood_entities )
    {
        if ( isdefined( __value ) )
        {
            if ( isstring( __key ) )
            {
                __new[__key] = __value;
                continue;
            }

            __new[__new.size] = __value;
        }
    }

    level.a_zombie_blood_entities = __new;

    foreach ( e_zombie_blood in level.a_zombie_blood_entities )
    {
        if ( isdefined( e_zombie_blood.e_unique_player ) )
        {
            if ( e_zombie_blood.e_unique_player == e_player )
                e_zombie_blood setvisibletoplayer( e_player );

            continue;
        }

        e_zombie_blood setvisibletoplayer( e_player );
    }

    if ( !isdefined( e_player.m_fx ) )
    {
        v_origin = e_player gettagorigin( "J_Eyeball_LE" );
        v_angles = e_player gettagangles( "J_Eyeball_LE" );
        m_fx = spawn( "script_model", v_origin );
        m_fx setmodel( "tag_origin" );
        m_fx.angles = v_angles;
        m_fx linkto( e_player, "J_Eyeball_LE", ( 0, 0, 0 ), ( 0, 0, 0 ) );
        m_fx thread fx_disconnect_watch( e_player );
        playfxontag( level._effect["zombie_blood"], m_fx, "tag_origin" );
        e_player.m_fx = m_fx;
        e_player.m_fx playloopsound( "zmb_zombieblood_3rd_loop", 1 );

        if ( isdefined( level.str_zombie_blood_model ) )
        {
            e_player.hero_model = e_player.model;
            e_player setmodel( level.str_zombie_blood_model );
        }
    }

    e_player thread watch_zombie_blood_early_exit();

    while ( e_player.zombie_vars["zombie_powerup_zombie_blood_time"] >= 0 )
    {
        wait 0.05;
        e_player.zombie_vars["zombie_powerup_zombie_blood_time"] -= 0.05;
    }

    e_player notify( "zombie_blood_over" );

    if ( isdefined( e_player.characterindex ) )
        e_player playsound( "vox_plr_" + e_player.characterindex + "_exert_grunt_" + randomintrange( 0, 3 ) );

    e_player.m_fx delete();
    maps\mp\_visionset_mgr::vsmgr_deactivate( "visionset", "zm_powerup_zombie_blood_visionset", e_player );
    maps\mp\_visionset_mgr::vsmgr_deactivate( "overlay", "zm_powerup_zombie_blood_overlay", e_player );
    e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 0;
    e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
    e_player._show_solo_hud = 0;
    e_player setclientfield( "player_zombie_blood_fx", 0 );

	e_player.early_exit = undefined;

    __new = [];

    foreach ( __key, __value in level.a_zombie_blood_entities )
    {
        if ( isdefined( __value ) )
        {
            if ( isstring( __key ) )
            {
                __new[__key] = __value;
                continue;
            }

            __new[__new.size] = __value;
        }
    }

    level.a_zombie_blood_entities = __new;

    foreach ( e_zombie_blood in level.a_zombie_blood_entities )
        e_zombie_blood setinvisibletoplayer( e_player );

    if ( isdefined( e_player.hero_model ) )
    {
        e_player setmodel( e_player.hero_model );
        e_player.hero_model = undefined;
    }
}