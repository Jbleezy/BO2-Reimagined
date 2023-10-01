#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\_visionset_mgr;
#include maps\mp\zm_buried_sq_bt;
#include maps\mp\zm_buried_sq_mta;
#include maps\mp\zm_buried_sq_gl;
#include maps\mp\zm_buried_sq_ftl;
#include maps\mp\zm_buried_sq_ll;
#include maps\mp\zm_buried_sq_ts;
#include maps\mp\zm_buried_sq_ctw;
#include maps\mp\zm_buried_sq_tpo;
#include maps\mp\zm_buried_sq_ip;
#include maps\mp\zm_buried_sq_ows;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_buried_amb;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zm_buried_sq;

sq_metagame()
{
    level endon( "sq_metagame_player_connected" );

    if ( !is_true( level.buried_sq_maxis_complete ) && !is_true( level.buried_sq_richtofen_complete ) )
        level waittill( "buried_sidequest_achieved" );

    m_endgame_machine = getstruct( "sq_endgame_machine", "targetname" );
    a_stat = [];
    a_stat[0] = "sq_transit_last_completed";
    a_stat[1] = "sq_highrise_last_completed";
    a_stat[2] = "sq_buried_last_completed";
    level.n_metagame_machine_lights_on = 0;
    flag_wait( "start_zombie_round_logic" );
    sq_metagame_clear_lights();
    players = get_players();
    player_count = players.size;

    for ( n_player = 0; n_player < player_count; n_player++ )
    {
        for ( n_stat = 0; n_stat < a_stat.size; n_stat++ )
        {
            if ( flag( "sq_is_max_tower_built" ) )
            {
                m_endgame_machine sq_metagame_machine_set_light( n_player, n_stat, "sq_bulb_orange" );
            }
            else
            {
                m_endgame_machine sq_metagame_machine_set_light( n_player, n_stat, "sq_bulb_blue" );
            }

            level setclientfield( "buried_sq_egm_bulb_" + n_stat, 1 );
        }
    }

    m_endgame_machine.activate_trig = spawn( "trigger_radius", m_endgame_machine.origin, 0, 128, 72 );

    m_endgame_machine.activate_trig waittill( "trigger" );

    m_endgame_machine.activate_trig delete();
    m_endgame_machine.activate_trig = undefined;
    level setclientfield( "buried_sq_egm_animate", 1 );
    m_endgame_machine.endgame_trig = spawn( "trigger_radius_use", m_endgame_machine.origin, 0, 16, 16 );
    m_endgame_machine.endgame_trig setcursorhint( "HINT_NOICON" );
    m_endgame_machine.endgame_trig sethintstring( &"ZM_BURIED_SQ_EGM_BUT" );
    m_endgame_machine.endgame_trig triggerignoreteam();
    m_endgame_machine.endgame_trig usetriggerrequirelookat();

    m_endgame_machine.endgame_trig waittill( "trigger" );

    m_endgame_machine.endgame_trig delete();
    m_endgame_machine.endgame_trig = undefined;
    level thread sq_metagame_clear_tower_pieces();
    playsoundatposition( "zmb_endgame_mach_button", m_endgame_machine.origin );
    players = get_players();

    sq_metagame_clear_lights();

    if ( flag( "sq_is_max_tower_built" ) )
        level notify( "end_game_reward_starts_maxis" );
    else
        level notify( "end_game_reward_starts_richtofen" );
}

make_richtofen_zombie()
{
    self endon( "death" );
    level.sq_richtofen_zombie.spawned = 1;
    self setclientfield( "buried_sq_maxis_ending_update_eyeball_color", 1 );
    self thread richtofen_zombie_watch_death();

    self waittill( "completed_emerging_into_playable_area" );

    self thread richtofen_zombie_vo_watcher();
    self.deathfunction_old = self.deathfunction;
    self.deathfunction = ::richtofen_zombie_deathfunction_override;
}

richtofen_zombie_deathfunction_override()
{
    if ( isdefined( self.attacker ) && isplayer( self.attacker ) )
    {
        if ( !( isdefined( self.turning_into_ghost ) && self.turning_into_ghost ) )
        {
            self force_random_powerup_drop();

            self.attacker maps\mp\zombies\_zm_score::add_to_player_score( 500 );
        }
    }

    return self [[ self.deathfunction_old ]]();
}

sq_give_player_rewards()
{
    level thread scripts\zm\replaced\_zm_sq::sq_complete_time_hud();

    players = get_players();

    foreach ( player in players )
    {
        if ( is_player_valid( player ) )
        {
            player thread scripts\zm\replaced\_zm_sq::sq_give_player_all_perks();
        }
    }
}

mule_kick_allows_4_weapons()
{
    level.additionalprimaryweapon_limit = 4;
}