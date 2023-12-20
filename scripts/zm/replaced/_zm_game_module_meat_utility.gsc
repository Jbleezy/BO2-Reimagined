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
	if (level.script == "zm_prison")
	{
		set_gamemode_var_once("item_meat_name", "item_head_zm");
		set_gamemode_var_once("item_meat_model", "t6_wpn_zmb_severedhead_world");
	}
	else
	{
		set_gamemode_var_once("item_meat_name", "item_meat_zm");
		set_gamemode_var_once("item_meat_model", "t6_wpn_zmb_meat_world");
	}

	precacheitem(get_gamemode_var("item_meat_name"));
	set_gamemode_var_once("start_item_meat_name", get_gamemode_var("item_meat_name"));
	level.meat_weaponidx = getweaponindexfromname(get_gamemode_var("item_meat_name"));
	level.meat_pickupsound = getweaponpickupsound(level.meat_weaponidx);
	level.meat_pickupsoundplayer = getweaponpickupsoundplayer(level.meat_weaponidx);
	level.item_meat_name = get_gamemode_var("item_meat_name");
}