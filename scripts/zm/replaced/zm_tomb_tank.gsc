#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zm_tomb_amb;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_staff_fire;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zm_tomb_tank;

players_on_tank_update()
{
    flag_wait( "start_zombie_round_logic" );
    self thread tank_disconnect_paths();

    while ( true )
    {
        a_players = getplayers();

        foreach ( e_player in a_players )
        {
            if ( is_player_valid( e_player ) )
            {
                if ( isdefined( e_player.b_already_on_tank ) && !e_player.b_already_on_tank && e_player entity_on_tank() )
                {
                    e_player.b_already_on_tank = 1;
                    self.n_players_on++;

                    if ( self ent_flag( "tank_cooldown" ) )
                        level notify( "vo_tank_cooling", e_player );

                    e_player thread tank_rumble_update();
                    e_player thread tank_rides_around_map_achievement_watcher();
                    continue;
                }

                if ( isdefined( e_player.b_already_on_tank ) && e_player.b_already_on_tank && !e_player entity_on_tank() )
                {
                    e_player.b_already_on_tank = 0;
                    self.n_players_on--;
                    level notify( "vo_tank_leave", e_player );
                    e_player notify( "player_jumped_off_tank" );
                    e_player setclientfieldtoplayer( "player_rumble_and_shake", 0 );
                }
            }
        }

        wait 0.05;
    }
}

wait_for_tank_cooldown()
{
    self thread snd_fuel();

    self.n_cooldown_timer = 30;

    wait( self.n_cooldown_timer );
    level notify( "stp_cd" );
    self playsound( "zmb_tank_ready" );
    self playloopsound( "zmb_tank_idle" );
}