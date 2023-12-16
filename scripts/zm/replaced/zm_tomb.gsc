#include maps\mp\zm_tomb;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_gamemodes;
#include maps\mp\zm_tomb_fx;
#include maps\mp\zm_tomb_ffotd;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zm_tomb_quest_fire;
#include maps\mp\zm_tomb_capture_zones;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zm_tomb_giant_robot;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_tomb_amb;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\zombies\_zm_ai_quadrotor;
#include maps\mp\zombies\_load;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_weap_one_inch_punch;
#include maps\mp\zombies\_zm_weap_staff_fire;
#include maps\mp\zombies\_zm_weap_staff_water;
#include maps\mp\zombies\_zm_weap_staff_lightning;
#include maps\mp\zombies\_zm_weap_staff_air;
#include maps\mp\zm_tomb_achievement;
#include maps\mp\zm_tomb_distance_tracking;
#include maps\mp\zombies\_zm_magicbox_tomb;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zombies\_zm_perk_random;
#include maps\mp\_sticky_grenade;
#include maps\mp\zombies\_zm_weap_beacon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_riotshield_tomb;
#include maps\mp\zombies\_zm_weap_staff_revive;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zm_tomb_ambient_scripts;
#include maps\mp\zm_tomb_dig;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zm_tomb_ee_side;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_audio;
#include character\c_usa_dempsey_dlc4;
#include character\c_rus_nikolai_dlc4;
#include character\c_ger_richtofen_dlc4;
#include character\c_jap_takeo_dlc4;
#include maps\mp\zombies\_zm_powerup_zombie_blood;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zombies\_zm_laststand;

sndmeleewpn_isstaff( weapon )
{
	switch ( weapon )
	{
	case "staff_water_melee_zm":
	case "staff_melee_zm":
	case "staff_lightning_melee_zm":
	case "staff_fire_melee_zm":
	case "staff_air_melee_zm":
		isstaff = 1;
		break;
	default:
		isstaff = 0;
	}

	return isstaff;
}

tomb_can_track_ammo_custom( weap )
{
	if ( !isdefined( weap ) )
		return false;

	switch ( weap )
	{
	case "zombie_tazer_flourish":
	case "zombie_sickle_flourish":
	case "zombie_one_inch_punch_upgrade_flourish":
	case "zombie_one_inch_punch_flourish":
	case "zombie_knuckle_crack":
	case "zombie_fists_zm":
	case "zombie_builder_zm":
	case "zombie_bowie_flourish":
	case "time_bomb_zm":
	case "time_bomb_detonator_zm":
	case "tazer_knuckles_zm":
	case "tazer_knuckles_upgraded_zm":
	case "staff_revive_zm":
	case "slowgun_zm":
	case "slowgun_upgraded_zm":
	case "screecher_arms_zm":
	case "riotshield_zm":
	case "one_inch_punch_zm":
	case "one_inch_punch_upgraded_zm":
	case "one_inch_punch_lightning_zm":
	case "one_inch_punch_ice_zm":
	case "one_inch_punch_fire_zm":
	case "one_inch_punch_air_zm":
	case "none":
	case "no_hands_zm":
	case "lower_equip_gasmask_zm":
	case "humangun_zm":
	case "humangun_upgraded_zm":
	case "falling_hands_tomb_zm":
	case "equip_gasmask_zm":
	case "equip_dieseldrone_zm":
	case "death_throe_zm":
	case "chalk_draw_zm":
	case "alcatraz_shield_zm":
	case "tomb_shield_zm":
		return false;
	default:
		if ( is_melee_weapon( weap ) || is_zombie_perk_bottle( weap ) || is_placeable_mine( weap ) || is_equipment( weap ) || issubstr( weap, "knife_ballistic_" ) || getsubstr( weap, 0, 3 ) == "gl_" || weaponfuellife( weap ) > 0 || weap == level.revive_tool )
			return false;
	}

	return true;
}