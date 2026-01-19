#include maps\mp\zombies\_zm_game_module_meat_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_game_module_utility;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\gametypes_zm\zmeat;
#include maps\mp\zombies\_zm_powerups;

init_item_meat(gametype)
{
	if (getdvar("mapname") == "zm_prison" || getdvar("mapname") == "zm_tomb")
	{
		set_gamemode_var_once("item_meat_name", "item_head_zm");
		set_gamemode_var_once("item_meat_model", "t6_wpn_zmb_severedhead_world");
	}
	else
	{
		set_gamemode_var_once("item_meat_name", "item_meat_zm");
		set_gamemode_var_once("item_meat_model", "t6_wpn_zmb_meat_world");
	}

	level._effect["meat_impact"] = loadfx("maps/zombie/fx_zmb_meat_impact");
	level._effect["spawn_cloud"] = loadfx("maps/zombie/fx_zmb_race_zombie_spawn_cloud");
	level._effect["meat_stink_camera"] = loadfx("maps/zombie/fx_zmb_meat_stink_camera");
	level._effect["meat_stink_torso"] = loadfx("maps/zombie/fx_zmb_meat_stink_torso");
	level._effect["meat_glow3p"] = loadfx("maps/zombie/fx_zmb_meat_glow_3p");
	include_powerup("meat_stink");
	maps\mp\zombies\_zm_powerups::add_zombie_powerup("meat_stink", get_gamemode_var("item_meat_model"), &"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_drop_meat, 1, 0, 0);

	precacheitem(get_gamemode_var("item_meat_name"));
	set_gamemode_var_once("start_item_meat_name", get_gamemode_var("item_meat_name"));
	level.meat_weaponidx = getweaponindexfromname(get_gamemode_var("item_meat_name"));
	level.meat_pickupsound = getweaponpickupsound(level.meat_weaponidx);
	level.meat_pickupsoundplayer = getweaponpickupsoundplayer(level.meat_weaponidx);
	level.item_meat_name = get_gamemode_var("item_meat_name");
}

func_should_drop_meat()
{
	if (level.scr_zm_ui_gametype == "zmeat")
	{
		return 0;
	}

	foreach (powerup in level.active_powerups)
	{
		if (powerup.powerup_name == "meat_stink")
		{
			return 0;
		}
	}

	players = get_players();

	foreach (player in players)
	{
		if (player hasWeapon(level.item_meat_name))
		{
			return 0;
		}
	}

	if (isDefined(level.item_meat) || is_true(level.meat_on_ground) || isDefined(level.meat_player))
	{
		return 0;
	}

	return 1;
}