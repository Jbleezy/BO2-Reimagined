#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_powerup_zombie_blood;
#include maps\mp\zm_tomb_dig;

init_shovel()
{
    precachemodel( "p6_zm_tm_dig_mound" );
    precachemodel( "p6_zm_tm_dig_mound_blood" );
    precachemodel( "p6_zm_tm_shovel" );
    precachemodel( "zombie_pickup_perk_bottle" );
    precachemodel( "t6_wpn_claymore_world" );
    maps\mp\zombies\_zm_audio_announcer::createvox( "blood_money", "powerup_blood_money" );
    onplayerconnect_callback( ::init_shovel_player );

    level.get_player_perk_purchase_limit = ::get_player_perk_purchase_limit;
    level.bonus_points_powerup_override = ::bonus_points_powerup_override;
    level thread dig_powerups_tracking();
    level thread dig_spots_init();
    registerclientfield( "world", "shovel_player1", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "shovel_player2", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "shovel_player3", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "shovel_player4", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player1", 14000, 1, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player2", 14000, 1, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player3", 14000, 1, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player4", 14000, 1, "int", undefined, 0 );
}

init_shovel_player()
{
    self.dig_vars["has_shovel"] = 1;
    self.dig_vars["has_upgraded_shovel"] = 0;
    self.dig_vars["has_helmet"] = 0;
    self.dig_vars["n_spots_dug"] = 0;
    self.dig_vars["n_losing_streak"] = 0;

	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 1 );

	self thread dig_disconnect_watch( n_player );
}

dig_disconnect_watch( n_player )
{
	self waittill( "disconnect" );
	level setclientfield( "shovel_player" + n_player, 0 );
	level setclientfield( "helmet_player" + n_player, 0 );
}

waittill_dug( s_dig_spot )
{
    while ( true )
    {
        self waittill( "trigger", player );

        if ( isdefined( player.dig_vars["has_shovel"] ) && player.dig_vars["has_shovel"] )
        {
            player playsound( "evt_dig" );
            s_dig_spot.dug = 1;
            level.n_dig_spots_cur--;
            playfx( level._effect["digging"], self.origin );
            player setclientfieldtoplayer( "player_rumble_and_shake", 1 );
            player maps\mp\zombies\_zm_stats::increment_client_stat( "tomb_dig", 0 );
            player maps\mp\zombies\_zm_stats::increment_player_stat( "tomb_dig" );
            s_staff_piece = s_dig_spot maps\mp\zm_tomb_main_quest::dig_spot_get_staff_piece( player );

            if ( isdefined( s_staff_piece ) )
            {
                s_staff_piece maps\mp\zm_tomb_main_quest::show_ice_staff_piece( self.origin );
                player dig_reward_dialog( "dig_staff_part" );
            }
            else
            {
                n_good_chance = 50;

                if ( player.dig_vars["n_spots_dug"] == 0 || player.dig_vars["n_losing_streak"] == 3 )
                {
                    player.dig_vars["n_losing_streak"] = 0;
                    n_good_chance = 100;
                }

                if ( player.dig_vars["has_upgraded_shovel"] )
                {
                    if ( !player.dig_vars["has_helmet"] )
                    {
                        player.dig_vars["n_spots_dug"]++;

                        if ( player.dig_vars["n_spots_dug"] >= 40 )
                        {
                            player.dig_vars["has_helmet"] = 1;
                            n_player = player getentitynumber() + 1;
                            level setclientfield( "helmet_player" + n_player, 1 );
                            player playsoundtoplayer( "zmb_squest_golden_anything", player );
                            player maps\mp\zombies\_zm_stats::increment_client_stat( "tomb_golden_hard_hat", 0 );
                            player maps\mp\zombies\_zm_stats::increment_player_stat( "tomb_golden_hard_hat" );
                            return;
                        }
                    }

                    n_good_chance = 70;
                }

                n_prize_roll = randomint( 100 );

                if ( n_prize_roll > n_good_chance )
                {
                    if ( cointoss() )
                    {
                        player dig_reward_dialog( "dig_grenade" );
                        self thread dig_up_grenade( player );
                    }
                    else
                    {
                        player dig_reward_dialog( "dig_zombie" );
                        self thread dig_up_zombie( player, s_dig_spot );
                    }

                    player.dig_vars["n_losing_streak"]++;
                }
                else if ( cointoss() )
                    self thread dig_up_powerup( player );
                else
                {
                    player dig_reward_dialog( "dig_gun" );
                    self thread dig_up_weapon( player );
                }
            }

            if ( !player.dig_vars["has_upgraded_shovel"] )
            {
                player.dig_vars["n_spots_dug"]++;

                if ( player.dig_vars["n_spots_dug"] >= 20 )
                {
                    player.dig_vars["has_upgraded_shovel"] = 1;
                    player thread ee_zombie_blood_dig();
                    n_player = player getentitynumber() + 1;
                    level setclientfield( "shovel_player" + n_player, 2 );
                    player playsoundtoplayer( "zmb_squest_golden_anything", player );
                    player maps\mp\zombies\_zm_stats::increment_client_stat( "tomb_golden_shovel", 0 );
                    player maps\mp\zombies\_zm_stats::increment_player_stat( "tomb_golden_shovel" );
                }
            }

            return;
        }
    }
}

increment_player_perk_purchase_limit()
{
	self maps\mp\zombies\_zm_perks::give_random_perk();
}