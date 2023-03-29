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

increment_player_perk_purchase_limit()
{
	self maps\mp\zombies\_zm_perks::give_random_perk();
}