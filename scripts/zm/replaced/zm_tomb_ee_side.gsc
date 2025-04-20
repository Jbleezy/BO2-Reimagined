#include maps\mp\zm_tomb_ee_side;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zm_tomb_ee_lights;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_tomb_amb;

init()
{
	precacheshader("zm_tm_wth_dog");
	precachemodel("p6_zm_tm_tablet");
	precachemodel("p6_zm_tm_tablet_muddy");
	precachemodel("p6_zm_tm_radio_01");
	precachemodel("p6_zm_tm_radio_01_panel2_blood");
	registerclientfield("world", "wagon_1_fire", 14000, 1, "int");
	registerclientfield("world", "wagon_2_fire", 14000, 1, "int");
	registerclientfield("world", "wagon_3_fire", 14000, 1, "int");
	registerclientfield("actor", "ee_zombie_tablet_fx", 14000, 1, "int");
	registerclientfield("toplayer", "ee_beacon_reward", 14000, 1, "int");

	if (!is_classic())
	{
		registerclientfield("world", "light_show", 14000, 2, "int");

		t_bunker = getent("trigger_oneinchpunch_bunker_table", "targetname");
		t_bunker delete();

		t_birdbath = getent("trigger_oneinchpunch_church_birdbath", "targetname");
		t_birdbath delete();

		return;
	}

	onplayerconnect_callback(::onplayerconnect_ee_jump_scare);
	onplayerconnect_callback(::onplayerconnect_ee_oneinchpunch);
	sq_one_inch_punch();
	a_triggers = getentarray("audio_bump_trigger", "targetname");

	foreach (trigger in a_triggers)
	{
		if (isdefined(trigger.script_sound) && trigger.script_sound == "zmb_perks_bump_bottle")
		{
			trigger thread check_for_change();
		}
	}

	level thread wagon_fire_challenge();
	level thread wall_hole_poster();
	level thread quadrotor_medallions();
	level thread maps\mp\zm_tomb_ee_lights::main();
	level thread radio_ee_song();
}

swap_mg(e_player)
{
	str_current_weapon = e_player getcurrentweapon();
	str_reward_weapon = maps\mp\zombies\_zm_weapons::get_upgrade_weapon("mg08_zm");

	if (is_player_valid(e_player) && !e_player.is_drinking && !is_melee_weapon(str_current_weapon) && !is_placeable_mine(str_current_weapon) && !is_equipment(str_current_weapon) && level.revive_tool != str_current_weapon && "none" != str_current_weapon && !e_player hacker_active())
	{
		if (e_player hasweapon(str_reward_weapon))
		{
			e_player givemaxammo(str_reward_weapon);
		}
		else
		{
			a_weapons = e_player getweaponslistprimaries();

			if (isdefined(a_weapons) && a_weapons.size >= get_player_weapon_limit(e_player))
			{
				e_player takeweapon(str_current_weapon);
			}

			e_player giveweapon(str_reward_weapon, 0, e_player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(str_reward_weapon));
			e_player givestartammo(str_reward_weapon);
			e_player switchtoweapon(str_reward_weapon);
		}

		return true;
	}
	else
	{
		return false;
	}
}