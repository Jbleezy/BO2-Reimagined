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

custom_vending_precaching()
{
	if (level._custom_perks.size > 0)
	{
		a_keys = getarraykeys(level._custom_perks);

		for (i = 0; i < a_keys.size; i++)
		{
			if (isdefined(level._custom_perks[a_keys[i]].precache_func))
			{
				level [[level._custom_perks[a_keys[i]].precache_func]]();
			}
		}
	}

	if (isdefined(level.zombiemode_using_pack_a_punch) && level.zombiemode_using_pack_a_punch)
	{
		precacheitem("zombie_knuckle_crack");
		precachemodel("p6_anim_zm_buildable_pap");
		precachemodel("p6_anim_zm_buildable_pap_on");
		precachestring(&"ZOMBIE_PERK_PACKAPUNCH");
		precachestring(&"ZOMBIE_PERK_PACKAPUNCH_ATT");
		level._effect["packapunch_fx"] = loadfx("maps/zombie/fx_zombie_packapunch");
		level.machine_assets["packapunch"] = spawnstruct();
		level.machine_assets["packapunch"].weapon = "zombie_knuckle_crack";
	}

	if (isdefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk)
	{
		precacheitem("zombie_perk_bottle_additionalprimaryweapon");
		precacheshader("specialty_additionalprimaryweapon_zombies");
		precachemodel("p6_zm_tm_vending_three_gun");
		precachestring(&"ZOMBIE_PERK_ADDITIONALWEAPONPERK");
		level._effect["additionalprimaryweapon_light"] = loadfx("misc/fx_zombie_cola_arsenal_on");
		level.machine_assets["additionalprimaryweapon"] = spawnstruct();
		level.machine_assets["additionalprimaryweapon"].weapon = "zombie_perk_bottle_additionalprimaryweapon";
		level.machine_assets["additionalprimaryweapon"].off_model = "p6_zm_tm_vending_three_gun";
		level.machine_assets["additionalprimaryweapon"].on_model = "p6_zm_tm_vending_three_gun";
		level.machine_assets["additionalprimaryweapon"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["additionalprimaryweapon"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk)
	{
		precacheitem("zombie_perk_bottle_deadshot");
		precacheshader("specialty_ads_zombies");
		precachemodel("zombie_vending_ads");
		precachemodel("zombie_vending_ads_on");
		precachestring(&"ZOMBIE_PERK_DEADSHOT");
		level._effect["deadshot_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "zombie_vending_ads";
		level.machine_assets["deadshot"].on_model = "zombie_vending_ads_on";
		level.machine_assets["deadshot"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["deadshot"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk)
	{
		precacheitem("zombie_perk_bottle_doubletap");
		precacheshader("specialty_doubletap_zombies");
		precachemodel("zombie_vending_doubletap2");
		precachemodel("zombie_vending_doubletap2_on");
		precachestring(&"ZOMBIE_PERK_DOUBLETAP");
		level._effect["doubletap_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
		level.machine_assets["doubletap"] = spawnstruct();
		level.machine_assets["doubletap"].weapon = "zombie_perk_bottle_doubletap";
		level.machine_assets["doubletap"].off_model = "zombie_vending_doubletap2";
		level.machine_assets["doubletap"].on_model = "zombie_vending_doubletap2_on";
		level.machine_assets["doubletap"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["doubletap"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk)
	{
		precacheitem("zombie_perk_bottle_jugg");
		precacheshader("specialty_juggernaut_zombies");
		precachemodel("zombie_vending_jugg");
		precachemodel("zombie_vending_jugg_on");
		precachestring(&"ZOMBIE_PERK_JUGGERNAUT");
		level._effect["jugger_light"] = loadfx("misc/fx_zombie_cola_jugg_on");
		level.machine_assets["juggernog"] = spawnstruct();
		level.machine_assets["juggernog"].weapon = "zombie_perk_bottle_jugg";
		level.machine_assets["juggernog"].off_model = "zombie_vending_jugg";
		level.machine_assets["juggernog"].on_model = "zombie_vending_jugg_on";
		level.machine_assets["juggernog"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["juggernog"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk)
	{
		precacheitem("zombie_perk_bottle_marathon");
		precacheshader("specialty_marathon_zombies");
		precachemodel("zombie_vending_marathon");
		precachemodel("zombie_vending_marathon_on");
		precachestring(&"ZOMBIE_PERK_MARATHON");
		level._effect["marathon_light"] = loadfx("maps/zombie/fx_zmb_cola_staminup_on");
		level.machine_assets["marathon"] = spawnstruct();
		level.machine_assets["marathon"].weapon = "zombie_perk_bottle_marathon";
		level.machine_assets["marathon"].off_model = "zombie_vending_marathon";
		level.machine_assets["marathon"].on_model = "zombie_vending_marathon_on";
		level.machine_assets["marathon"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["marathon"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk)
	{
		precacheitem("zombie_perk_bottle_revive");
		precacheshader("specialty_quickrevive_zombies");
		precachemodel("p6_zm_tm_vending_revive");
		precachemodel("p6_zm_tm_vending_revive_on");
		precachestring(&"ZOMBIE_PERK_QUICKREVIVE");
		level._effect["revive_light"] = loadfx("misc/fx_zombie_cola_revive_on");
		level._effect["revive_light_flicker"] = loadfx("maps/zombie/fx_zmb_cola_revive_flicker");
		level.machine_assets["revive"] = spawnstruct();
		level.machine_assets["revive"].weapon = "zombie_perk_bottle_revive";
		level.machine_assets["revive"].off_model = "p6_zm_tm_vending_revive";
		level.machine_assets["revive"].on_model = "p6_zm_tm_vending_revive_on";
		level.machine_assets["revive"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["revive"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk)
	{
		precacheitem("zombie_perk_bottle_sleight");
		precacheshader("specialty_fastreload_zombies");
		precachemodel("zombie_vending_sleight");
		precachemodel("zombie_vending_sleight_on");
		precachestring(&"ZOMBIE_PERK_FASTRELOAD");
		level._effect["sleight_light"] = loadfx("misc/fx_zombie_cola_on");
		level.machine_assets["speedcola"] = spawnstruct();
		level.machine_assets["speedcola"].weapon = "zombie_perk_bottle_sleight";
		level.machine_assets["speedcola"].off_model = "zombie_vending_sleight";
		level.machine_assets["speedcola"].on_model = "zombie_vending_sleight_on";
		level.machine_assets["speedcola"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["speedcola"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
	{
		precacheitem("zombie_perk_bottle_tombstone");
		precacheshader("specialty_tombstone_zombies");
		precachemodel("zombie_vending_tombstone");
		precachemodel("zombie_vending_tombstone_on");
		precachemodel("ch_tombstone1");
		precachestring(&"ZOMBIE_PERK_TOMBSTONE");
		level._effect["tombstone_light"] = loadfx("misc/fx_zombie_cola_on");
		level.machine_assets["tombstone"] = spawnstruct();
		level.machine_assets["tombstone"].weapon = "zombie_perk_bottle_tombstone";
		level.machine_assets["tombstone"].off_model = "zombie_vending_tombstone";
		level.machine_assets["tombstone"].on_model = "zombie_vending_tombstone_on";
		level.machine_assets["tombstone"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["tombstone"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk)
	{
		precacheitem("zombie_perk_bottle_whoswho");
		precacheshader("specialty_quickrevive_zombies");
		precachemodel("p6_zm_vending_chugabud");
		precachemodel("p6_zm_vending_chugabud_on");
		precachemodel("ch_tombstone1");
		precachestring(&"ZOMBIE_PERK_TOMBSTONE");
		level._effect["tombstone_light"] = loadfx("misc/fx_zombie_cola_on");
		level.machine_assets["whoswho"] = spawnstruct();
		level.machine_assets["whoswho"].weapon = "zombie_perk_bottle_whoswho";
		level.machine_assets["whoswho"].off_model = "p6_zm_vending_chugabud";
		level.machine_assets["whoswho"].on_model = "p6_zm_vending_chugabud_on";
		level.machine_assets["whoswho"].power_on_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_on;
		level.machine_assets["whoswho"].power_off_callback = maps\mp\zm_tomb_capture_zones::custom_vending_power_off;
	}
}

tomb_can_track_ammo_custom(weap)
{
	if (!isdefined(weap))
	{
		return false;
	}

	switch (weap)
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
			if (is_melee_weapon(weap) || is_zombie_perk_bottle(weap) || is_placeable_mine(weap) || is_equipment(weap) || issubstr(weap, "knife_ballistic_") || getsubstr(weap, 0, 3) == "gl_" || weaponfuellife(weap) > 0 || weap == level.revive_tool)
			{
				return false;
			}
	}

	return true;
}

sndmeleewpnsound()
{
	// removed - added to all maps in _zm_reimagined
}