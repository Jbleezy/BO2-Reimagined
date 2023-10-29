#include maps\mp\zm_highrise_sq_pts;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_highrise_sq;
#include maps\mp\zombies\_zm_unitrigger;

init_1()
{
    flag_init( "pts_1_springpads_placed" );
    declare_sidequest_stage( "sq_1", "pts_1", ::init_stage_1, ::stage_logic_1, ::exit_stage_1 );
}

init_2()
{
    flag_init( "pts_2_springpads_placed" );
    flag_init( "pts_2_generator_1_started" );
    flag_init( "pts_2_generator_2_started" );
    declare_sidequest_stage( "sq_2", "pts_2", ::init_stage_2, ::stage_logic_2, ::exit_stage_2 );
}

stage_logic_1()
{
    watch_player_springpads( 0 );
    flag_set( "pts_1_springpads_placed" );
    maps\mp\zm_highrise_sq::light_dragon_fireworks( "r", 1 );
    wait_for_zombies_launched();
    maps\mp\zm_highrise_sq::light_dragon_fireworks( "r", 2 );
    stage_completed( "sq_1", "pts_1" );
}

stage_logic_2()
{
    watch_player_springpads( 1 );
    level thread wait_for_balls_launched();
    flag_wait( "pts_2_generator_1_started" );
    maps\mp\zm_highrise_sq::light_dragon_fireworks( "m", 2 );
    flag_wait( "pts_2_generator_2_started" );
    maps\mp\zm_highrise_sq::light_dragon_fireworks( "m", 2 );
    level thread maxis_balls_placed();
    stage_completed( "sq_2", "pts_2" );
}

watch_player_springpads( is_generator )
{
    level thread springpad_count_watcher( is_generator );
    a_players = get_players();

    foreach ( player in a_players )
        player thread pts_watch_springpad_use( is_generator );
}

springpad_count_watcher( is_generator )
{
    level endon( "sq_pts_springad_count4" );
    str_which_spots = "pts_ghoul";

    if ( is_generator )
        str_which_spots = "pts_lion";

    a_spots = getstructarray( str_which_spots, "targetname" );

    while ( true )
    {
        level waittill( "sq_pts_springpad_in_place" );

        n_count = 0;

        foreach ( s_spot in a_spots )
        {
            if ( isdefined( s_spot.springpad ) )
                n_count++;
        }

        level notify( "sq_pts_springad_count" + n_count );
    }
}

pts_watch_springpad_use( is_generator )
{
    self endon( "death" );
    self endon( "disconnect" );

    while ( !flag( "sq_branch_complete" ) )
    {
        self waittill( "equipment_placed", weapon, weapname );

        if ( weapname == level.springpad_name )
            self thread is_springpad_in_place( weapon, is_generator );
    }
}

is_springpad_in_place( m_springpad, is_generator )
{
    m_springpad endon( "death" );

    m_springpad waittill( "armed" );

    a_lion_spots = getstructarray( "pts_lion", "targetname" );
    a_ghoul_spots = getstructarray( "pts_ghoul", "targetname" );
    a_spots = arraycombine( a_lion_spots, a_ghoul_spots, 0, 0 );

    foreach ( s_spot in a_spots )
    {
        n_dist = distance2dsquared( m_springpad.origin, s_spot.origin );

        if ( n_dist < 1024 )
        {
            v_spot_forward = vectornormalize( anglestoforward( s_spot.angles ) );
            v_pad_forward = vectornormalize( anglestoforward( m_springpad.angles ) );
            n_dot = vectordot( v_spot_forward, v_pad_forward );

            if ( n_dot > 0.98 )
            {
                level notify( "sq_pts_springpad_in_place" );
                s_spot.springpad = m_springpad;
                self thread pts_springpad_removed_watcher( m_springpad, s_spot );

                if ( is_generator )
                {
                    wait 0.1;
                    if ( pts_should_springpad_create_trigs( s_spot ) )
                    {
                        thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.buildablespringpad.stub );
                    }
                }
                else
                {
                    m_springpad.fling_scaler = 2;
                    m_springpad thread watch_zombie_flings();
                }

                if ( isdefined( s_spot.script_float ) )
                {
                    s_target = getstruct( "sq_zombie_launch_target", "targetname" );
                    v_override_dir = vectornormalize( s_target.origin - m_springpad.origin );
                    v_override_dir = vectorscale( v_override_dir, 1024 );
                    m_springpad.direction_vec_override = v_override_dir;
                    m_springpad.fling_scaler = s_spot.script_float;
                }

                break;
            }
        }
    }
}

wait_for_zombies_launched()
{
    level thread richtofen_zombies_launched();
    t_tower = getent( "pts_tower_trig", "targetname" );
    s_tower_top = getstruct( "sq_zombie_launch_target", "targetname" );

    while ( level.n_launched_zombies < 15 )
        wait 0.5;
}

watch_zombie_flings()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "equip_springpad_zm_taken" );
    self endon( "equip_springpad_zm_pickup" );

    while ( level.n_launched_zombies < 15 )
    {
        self waittill( "fling", zombies_only );

        if ( zombies_only )
        {
            level.n_launched_zombies++;

            if ( level.n_launched_zombies == 1 || level.n_launched_zombies == 5 || level.n_launched_zombies == 10 )
                level notify( "pts1_say_next_line" );
        }

        wait 0.1;
    }
}

wait_for_balls_launched()
{
    level.current_generator = 1;
    a_lion_spots = getstructarray( "pts_lion", "targetname" );

    foreach ( s_lion_spot in a_lion_spots )
    {
        s_lion_spot.a_place_ball_trigs = [];
    }

    a_players = getplayers();

    foreach ( player in a_players )
    {
        player.a_place_ball_trigs = [];

        if ( isdefined( player.zm_sq_has_ball ) )
            player thread player_set_down_ball_watcher();
    }

    while ( true )
    {
        level waittill( "zm_ball_picked_up", player );

        player thread player_set_down_ball_watcher();
    }
}

player_set_down_ball_watcher()
{
    self waittill_any( "zm_sq_ball_putdown", "zm_sq_ball_used" );
    pts_putdown_trigs_remove_for_player( self );
}

pts_should_player_create_trigs( player )
{
    a_lion_spots = getstructarray( "pts_lion", "targetname" );

    foreach ( s_lion_spot in a_lion_spots )
    {
        if ( isdefined( s_lion_spot.springpad ) && !isdefined( s_lion_spot.which_ball ) )
        {
            pts_putdown_trigs_create_for_spot( s_lion_spot, player );
            return true;
        }
    }

    return false;
}

pts_should_springpad_create_trigs( s_lion_spot )
{
    if ( isdefined( s_lion_spot.springpad ) && !isdefined( s_lion_spot.which_ball ) )
    {
        a_players = getplayers();

        foreach ( player in a_players )
        {
            if ( isdefined( player.zm_sq_has_ball ) && player.zm_sq_has_ball )
            {
                pts_putdown_trigs_create_for_spot( s_lion_spot, player );
                return true;
            }
        }
    }

    return false;
}

pts_putdown_trigs_create_for_spot( s_lion_spot, player )
{
    t_place_ball = sq_pts_create_use_trigger( s_lion_spot.origin, 16, 70, &"ZM_HIGHRISE_SQ_PUTDOWN_BALL" );
    player clientclaimtrigger( t_place_ball );
    t_place_ball.owner = player;
    player thread place_ball_think( t_place_ball, s_lion_spot );

    if ( !isdefined( s_lion_spot.pts_putdown_trigs ) )
        s_lion_spot.pts_putdown_trigs = [];

    s_lion_spot.pts_putdown_trigs[player.characterindex] = t_place_ball;
    level thread pts_putdown_trigs_springpad_delete_watcher( player, s_lion_spot );
}

sq_pts_create_use_trigger( v_origin, radius, height, str_hint_string )
{
    t_pickup = spawn( "trigger_radius_use", v_origin, 0, radius, height );
    t_pickup setcursorhint( "HINT_NOICON" );
    t_pickup sethintstring( str_hint_string );
    t_pickup.targetname = "ball_place_trig";
    t_pickup triggerignoreteam();
    return t_pickup;
}

pts_putdown_trigs_springpad_delete_watcher( player, s_lion_spot )
{
    player pts_springpad_waittill_removed( s_lion_spot.springpad );
    pts_putdown_trigs_remove_for_spot( s_lion_spot );
}

place_ball_think( t_place_ball, s_lion_spot )
{
    t_place_ball endon( "delete" );


    while (1)
    {
        t_place_ball waittill( "trigger" );

        if (!is_true( self.zm_sq_has_ball ) )
        {
            continue;
        }

        pts_putdown_trigs_remove_for_spot( s_lion_spot );
        self.zm_sq_has_ball = undefined;
        s_lion_spot.which_ball = self.which_ball;
        self notify( "zm_sq_ball_used" );
        s_lion_spot.zm_pts_animating = 1;
        flag_set( "pts_2_generator_" + level.current_generator + "_started" );
        s_lion_spot.which_generator = level.current_generator;
        level.current_generator++;

        s_lion_spot.springpad thread pts_springpad_fling( s_lion_spot.script_noteworthy );
        thread maps\mp\zombies\_zm_unitrigger::register_unitrigger( self.buildablespringpad.stub );
        self.t_putdown_ball delete();
    }
}

#using_animtree("fxanim_props");

pts_springpad_fling( str_spot_name )
{
    str_anim1 = undefined;
    n_anim_length1 = undefined;
    str_anim2 = undefined;
    n_anim_length2 = undefined;

    switch ( str_spot_name )
    {
        case "lion_pair_1":
            str_anim1 = "dc";
            str_anim2 = "cd";
            break;
        case "lion_pair_2":
            str_anim1 = "ab";
            str_anim2 = "ba";
            break;
        case "lion_pair_3":
            str_anim1 = "cd";
            str_anim2 = "dc";
            break;
        case "lion_pair_4":
            str_anim1 = "ba";
            str_anim2 = "ab";
            break;
    }

    m_anim = spawn( "script_model", ( 2090, 675, 3542 ) );
    m_anim.angles = ( 0, 0, 0 );
    m_anim setmodel( "fxanim_zom_highrise_trample_gen_mod" );
    m_anim useanimtree( #animtree );
    m_anim.targetname = "trample_gen_" + str_spot_name;
    pts_springpad_anim_ball( m_anim, str_anim1, str_anim2 );
}

pts_springpad_anim_ball( m_anim, str_anim1, str_anim2 )
{
    m_anim endon( "delete" );
    self endon( "delete" );
    n_anim_length1 = getanimlength( level.scr_anim["fxanim_props"]["trample_gen_" + str_anim1] );
    n_anim_length2 = getanimlength( level.scr_anim["fxanim_props"]["trample_gen_" + str_anim2] );

    self notify( "fling", 1 );

    if ( isdefined( m_anim ) )
        m_anim setanim( level.scr_anim["fxanim_props"]["trample_gen_" + str_anim1] );

    wait( n_anim_length1 );
}