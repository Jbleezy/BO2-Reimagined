#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_tomb_utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zm_tomb_teleporter;

#using_animtree("fxanim_props_dlc4");

teleporter_init()
{
    registerclientfield( "scriptmover", "teleporter_fx", 14000, 1, "int" );
    precacheshellshock( "lava" );
    level.teleport = [];
    level.n_active_links = 0;
    level.n_countdown = 0;
    level.n_teleport_delay = 0;
    level.teleport_cost = 0;
    level.n_teleport_cooldown = 0;
    level.is_cooldown = 0;
    level.n_active_timer = -1;
    level.n_teleport_time = 0;
    level.a_teleport_models = [];
    a_entrance_models = getentarray( "teleport_model", "targetname" );

    foreach ( e_model in a_entrance_models )
    {
        e_model useanimtree( #animtree );
        level.a_teleport_models[e_model.script_int] = e_model;
    }

    array_thread( a_entrance_models, ::teleporter_samantha_chamber_line );
    a_portal_frames = getentarray( "portal_exit_frame", "script_noteworthy" );
    level.a_portal_exit_frames = [];

    foreach ( e_frame in a_portal_frames )
    {
        e_frame useanimtree( #animtree );
        e_frame ghost();
        level.a_portal_exit_frames[e_frame.script_int] = e_frame;
    }

    level.a_teleport_exits = [];
    a_exits = getstructarray( "portal_exit", "script_noteworthy" );

    foreach ( s_portal in a_exits )
        level.a_teleport_exits[s_portal.script_int] = s_portal;

    level.a_teleport_exit_triggers = [];
    a_trigs = getstructarray( "chamber_exit_trigger", "script_noteworthy" );

    foreach ( s_trig in a_trigs )
        level.a_teleport_exit_triggers[s_trig.script_int] = s_trig;

    a_s_teleporters = getstructarray( "trigger_teleport_pad", "targetname" );
    array_thread( a_s_teleporters, ::run_chamber_entrance_teleporter );
    spawn_stargate_fx_origins();
    root = %root;
    i = %fxanim_zom_tomb_portal_open_anim;
    i = %fxanim_zom_tomb_portal_collapse_anim;
}

run_chamber_entrance_teleporter()
{
    self endon( "death" );
    fx_glow = get_teleport_fx_from_enum( self.script_int );
    e_model = level.a_teleport_models[self.script_int];
    self.origin = e_model gettagorigin( "fx_portal_jnt" );
    self.angles = e_model gettagangles( "fx_portal_jnt" );
    self.angles = ( self.angles[0], self.angles[1] + 180, self.angles[2] );
    self.trigger_stub = tomb_spawn_trigger_radius( self.origin - vectorscale( ( 0, 0, 1 ), 30.0 ), 50.0 );
    flag_init( "enable_teleporter_" + self.script_int );
    str_building_flag = "teleporter_building_" + self.script_int;
    flag_init( str_building_flag );
    collapse_time = getanimlength( %fxanim_zom_tomb_portal_collapse_anim );
    open_time = getanimlength( %fxanim_zom_tomb_portal_open_anim );
    flag_wait( "start_zombie_round_logic" );
    e_model setanim( %fxanim_zom_tomb_portal_collapse_anim, 1.0, 0.1, 1 );
    wait( collapse_time );

    flag_wait( "enable_teleporter_" + self.script_int );
    flag_set( str_building_flag );

    e_model thread whirlwind_rumble_nearby_players( str_building_flag );
    e_model setanim( %fxanim_zom_tomb_portal_open_anim, 1.0, 0.1, 1 );
    e_model playloopsound( "zmb_teleporter_loop_pre", 1 );

    if ( !( isdefined( self.exit_enabled ) && self.exit_enabled ) )
    {
        self.exit_enabled = 1;
        level thread run_chamber_exit( self.script_int );
    }

    wait( open_time );
    e_model setanim( %fxanim_zom_tomb_portal_open_1frame_anim, 1.0, 0.1, 1 );
    wait_network_frame();
    e_fx = spawn( "script_model", self.origin );
    e_fx.angles = self.angles;
    e_fx setmodel( "tag_origin" );
    e_fx setclientfield( "element_glow_fx", self.script_int + 4 );
    rumble_nearby_players( e_fx.origin, 1000, 2 );
    e_model playloopsound( "zmb_teleporter_loop_post", 1 );

    self thread stargate_teleport_think();
    flag_clear( str_building_flag );

    level notify( "player_teleported", undefined, self.script_int );
}

run_chamber_exit( n_enum )
{
    s_portal = level.a_teleport_exits[n_enum];
    s_activate_pos = level.a_teleport_exit_triggers[n_enum];
    e_portal_frame = level.a_portal_exit_frames[n_enum];
    e_portal_frame show();
    str_building_flag = e_portal_frame.targetname + "_building";
    flag_init( str_building_flag );
    s_activate_pos.trigger_stub = tomb_spawn_trigger_radius( s_activate_pos.origin, 50.0, 1 );
    s_activate_pos.trigger_stub set_unitrigger_hint_string( &"ZM_TOMB_TELE" );
    s_portal.target = s_activate_pos.target;
    s_portal.origin = e_portal_frame gettagorigin( "fx_portal_jnt" );
    s_portal.angles = e_portal_frame gettagangles( "fx_portal_jnt" );
    s_portal.angles = ( s_portal.angles[0], s_portal.angles[1] + 180, s_portal.angles[2] );
    str_fx = get_teleport_fx_from_enum( n_enum );
    collapse_time = getanimlength( %fxanim_zom_tomb_portal_collapse_anim );
    open_time = getanimlength( %fxanim_zom_tomb_portal_open_anim );
    flag_wait( "start_zombie_round_logic" );

    s_activate_pos.trigger_stub set_unitrigger_hint_string( "" );
    s_activate_pos.trigger_stub trigger_off();

    e_portal_frame playloopsound( "zmb_teleporter_loop_pre", 1 );
    e_portal_frame setanim( %fxanim_zom_tomb_portal_open_anim, 1.0, 0.1, 1 );
    flag_set( str_building_flag );
    e_portal_frame thread whirlwind_rumble_nearby_players( str_building_flag );
    wait( open_time );
    e_portal_frame setanim( %fxanim_zom_tomb_portal_open_1frame_anim, 1.0, 0.1, 1 );
    wait_network_frame();
    flag_clear( str_building_flag );
    e_fx = spawn( "script_model", s_portal.origin );
    e_fx.angles = s_portal.angles;
    e_fx setmodel( "tag_origin" );
    e_fx setclientfield( "element_glow_fx", n_enum + 4 );
    rumble_nearby_players( e_fx.origin, 1000, 2 );
    e_portal_frame playloopsound( "zmb_teleporter_loop_post", 1 );
    s_portal thread teleporter_radius_think();
}

teleporter_radius_think( radius = 120.0 )
{
    self endon( "teleporter_radius_stop" );
    radius_sq = radius * radius;

    while ( true )
    {
        a_players = getplayers();

        foreach ( e_player in a_players )
        {
            dist_sq = distancesquared( e_player.origin, self.origin );

            if ( !is_true(e_player.divetoprone) && dist_sq < radius_sq && !( isdefined( e_player.teleporting ) && e_player.teleporting ) )
            {
                if ( e_player getstance() == "prone" )
                {
                    e_player setstance( "crouch" );
                }

                playfx( level._effect["teleport_3p"], self.origin, ( 1, 0, 0 ), ( 0, 0, 1 ) );
                playsoundatposition( "zmb_teleporter_tele_3d", self.origin );
                level thread stargate_teleport_player( self.target, e_player );
            }
        }

        wait_network_frame();
    }
}

stargate_teleport_think()
{
    self endon( "death" );
    level endon( "disable_teleporter_" + self.script_int );
    e_potal = level.a_teleport_models[self.script_int];

    while ( true )
    {
        self.trigger_stub waittill( "trigger", e_player );

        if ( !is_true(e_player.divetoprone) && !( isdefined( e_player.teleporting ) && e_player.teleporting ) )
        {
            if ( e_player getstance() == "prone" )
            {
                e_player setstance( "crouch" );
            }

            playfx( level._effect["teleport_3p"], self.origin, ( 1, 0, 0 ), ( 0, 0, 1 ) );
            playsoundatposition( "zmb_teleporter_tele_3d", self.origin );
            level notify( "player_teleported", e_player, self.script_int );
            level thread stargate_teleport_player( self.target, e_player );
        }
    }
}