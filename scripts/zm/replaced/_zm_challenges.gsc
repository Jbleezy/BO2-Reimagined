#include maps\mp\zombies\_zm_challenges;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_score;

init()
{
    level._challenges = spawnstruct();
    stats_init();
    level.a_m_challenge_boards = [];
    level.a_uts_challenge_boxes = [];
    a_m_challenge_boxes = getentarray( "challenge_box", "targetname" );
    array_thread( a_m_challenge_boxes, ::box_init );
    onplayerconnect_callback( ::onplayerconnect );
    n_bits = getminbitcountfornum( 14 );
    registerclientfield( "toplayer", "challenge_complete_1", 14000, 1, "int" );
    registerclientfield( "toplayer", "challenge_complete_2", 14000, 1, "int" );
    registerclientfield( "toplayer", "challenge_complete_3", 14000, 1, "int" );
    registerclientfield( "toplayer", "challenge_complete_4", 14000, 1, "int" );
}

#using_animtree("fxanim_props_dlc4");

box_init()
{
    self useanimtree( #animtree );
    s_unitrigger_stub = spawnstruct();
    s_unitrigger_stub.origin = self.origin + ( 0, 0, 0 );
    s_unitrigger_stub.angles = self.angles;
    s_unitrigger_stub.radius = 64;
    s_unitrigger_stub.script_length = 64;
    s_unitrigger_stub.script_width = 64;
    s_unitrigger_stub.script_height = 64;
    s_unitrigger_stub.cursor_hint = "HINT_NOICON";
    s_unitrigger_stub.hint_string = &"";
    s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
    s_unitrigger_stub.prompt_and_visibility_func = ::box_prompt_and_visiblity;
    s_unitrigger_stub ent_flag_init( "waiting_for_grab" );
    s_unitrigger_stub ent_flag_init( "reward_timeout" );
    s_unitrigger_stub.b_busy = 0;
    s_unitrigger_stub.m_box = self;
    s_unitrigger_stub.b_disable_trigger = 0;

    if ( isdefined( self.script_string ) )
        s_unitrigger_stub.str_location = self.script_string;

    if ( isdefined( s_unitrigger_stub.m_box.target ) )
    {
        s_unitrigger_stub.m_board = getent( s_unitrigger_stub.m_box.target, "targetname" );
        s_unitrigger_stub board_init( s_unitrigger_stub.m_board );
    }

    unitrigger_force_per_player_triggers( s_unitrigger_stub, 1 );
    level.a_uts_challenge_boxes[level.a_uts_challenge_boxes.size] = s_unitrigger_stub;
    maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( s_unitrigger_stub, ::box_think );
}

box_think()
{
    self endon( "kill_trigger" );
    s_team = level._challenges.s_team;

    while ( true )
    {
        self waittill( "trigger", player );

        if ( !is_player_valid( player ) )
            continue;

        if ( self.stub.b_busy )
        {
            current_weapon = player getcurrentweapon();

            if ( isdefined( player.intermission ) && player.intermission || is_melee_weapon( current_weapon ) || is_placeable_mine( current_weapon ) || is_equipment_that_blocks_purchase( current_weapon ) || current_weapon == "none" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || player isthrowinggrenade() || player in_revive_trigger() || player isswitchingweapons() || player.is_drinking > 0 )
            {
                wait 0.1;
                continue;
            }

            if ( self.stub ent_flag( "waiting_for_grab" ) )
            {
                if ( !isdefined( self.stub.player_using ) )
                    self.stub.player_using = player;

                if ( player == self.stub.player_using )
                    self.stub ent_flag_clear( "waiting_for_grab" );
            }

            wait 0.05;
            continue;
        }

        if ( self.b_can_open )
        {
            self.stub.hint_string = &"";
            self sethintstring( self.stub.hint_string );
            level thread open_box( player, self.stub );
        }
    }
}