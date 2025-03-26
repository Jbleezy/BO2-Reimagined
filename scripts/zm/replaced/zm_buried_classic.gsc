#include maps\mp\zm_buried_classic;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_ai_ghost;
#include maps\mp\zombies\_zm_equip_turbine;
#include maps\mp\zombies\_zm_equip_springpad;
#include maps\mp\zombies\_zm_equip_subwoofer;
#include maps\mp\zombies\_zm_equip_headchopper;
#include maps\mp\zm_buried_fountain;
#include maps\mp\zm_buried_buildables;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_buried_power;
#include maps\mp\zm_buried_maze;
#include maps\mp\zm_buried_ee;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_ai_sloth;
#include maps\mp\zombies\_zm_laststand;

insta_kill_player(perks_can_respawn_player, kill_if_falling)
{
	self endon("disconnect");

	if (isdefined(self.is_in_fountain_transport_trigger) && self.is_in_fountain_transport_trigger)
	{
		return;
	}

	if (isdefined(self.insta_killed) && self.insta_killed)
	{
		return;
	}

	if (!is_player_killable(self))
	{
		return;
	}

	self.insta_killed = 1;

	self maps\mp\zombies\_zm_buildables::player_return_piece_to_original_spawn();

	self playlocalsound(level.zmb_laugh_alias);

	self disableinvulnerability();
	self.lives = 0;
	self dodamage(self.health + 1000, self.origin);
	self scripts\zm\_zm_reimagined::player_suicide();

	self.insta_killed = 0;
}