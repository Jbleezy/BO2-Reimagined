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

precache_personality_characters()
{
	if (!is_classic())
	{
		precache_team_characters();
		return;
	}

	character\c_usa_dempsey_dlc4::precache();
	character\c_rus_nikolai_dlc4::precache();
	character\c_ger_richtofen_dlc4::precache();
	character\c_jap_takeo_dlc4::precache();
	precachemodel("c_zom_richtofen_viewhands");
	precachemodel("c_zom_nikolai_viewhands");
	precachemodel("c_zom_takeo_viewhands");
	precachemodel("c_zom_dempsey_viewhands");
}

precache_team_characters()
{
	precachemodel("c_zom_player_grief_guard_fb");
	precachemodel("c_zom_oleary_shortsleeve_viewhands");
	precachemodel("c_zom_player_grief_inmate_fb");
	precachemodel("c_zom_grief_guard_viewhands");
}

give_personality_characters()
{
	if (!is_classic())
	{
		give_team_characters();
		return;
	}

	if (isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_arlington_coat_viewhands"))
	{
		return;
	}

	self detachall();

	if (!isdefined(self.characterindex))
	{
		self.characterindex = assign_lowest_unused_character_index();
	}

	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = 0;

	switch (self.characterindex)
	{
		case 0:
			self character\c_usa_dempsey_dlc4::main();
			self setviewmodel("c_zom_dempsey_viewhands");
			level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self set_player_is_female(0);
			self.character_name = "Dempsey";
			break;

		case 1:
			self character\c_rus_nikolai_dlc4::main();
			self setviewmodel("c_zom_nikolai_viewhands");
			level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self set_player_is_female(0);
			self.character_name = "Nikolai";
			break;

		case 2:
			self character\c_ger_richtofen_dlc4::main();
			self setviewmodel("c_zom_richtofen_viewhands");
			level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self set_player_is_female(0);
			self.character_name = "Richtofen";
			break;

		case 3:
			self character\c_jap_takeo_dlc4::main();
			self setviewmodel("c_zom_takeo_viewhands");
			level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self set_player_is_female(0);
			self.character_name = "Takeo";
			break;
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
	self thread set_exert_id();
}

give_team_characters()
{
	self detachall();
	self set_player_is_female(0);

	if (isdefined(level.should_use_cia))
	{
		if (level.should_use_cia)
		{
			self setmodel("c_zom_player_grief_inmate_fb");
			self setviewmodel("c_zom_oleary_shortsleeve_viewhands");
			self.characterindex = 0;
		}
		else
		{
			self setmodel("c_zom_player_grief_guard_fb");
			self setviewmodel("c_zom_grief_guard_viewhands");
			self.characterindex = 1;
		}
	}
	else
	{
		if (!isdefined(self.characterindex))
		{
			self.characterindex = 1;

			if (self.team == "axis")
			{
				self.characterindex = 0;
			}
		}

		switch (self.characterindex)
		{
			case 0:
			case 2:
				self setmodel("c_zom_player_grief_inmate_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_oleary_shortsleeve_viewhands");
				self.characterindex = 0;
				break;

			case 1:
			case 3:
				self setmodel("c_zom_player_grief_guard_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_grief_guard_viewhands");
				self.characterindex = 1;
				break;
		}
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}

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
		precachemodel("p6_zm_al_vending_ads_on");
		precachestring(&"ZOMBIE_PERK_DEADSHOT");
		level._effect["deadshot_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].on_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].power_on_callback = scripts\zm\replaced\_zm_perks::vending_deadshot_power_on;
		level.machine_assets["deadshot"].power_off_callback = scripts\zm\replaced\_zm_perks::vending_deadshot_power_off;
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
}

working_zone_init()
{
	flag_init("always_on");
	flag_set("always_on");
	add_adjacent_zone("zone_robot_head", "zone_robot_head", "always_on");
	add_adjacent_zone("zone_start", "zone_start_a", "always_on");
	add_adjacent_zone("zone_start", "zone_start_b", "always_on");
	add_adjacent_zone("zone_start_a", "zone_start_b", "always_on");
	add_adjacent_zone("zone_start_a", "zone_bunker_1a", "activate_zone_bunker_1");
	add_adjacent_zone("zone_bunker_1a", "zone_bunker_1", "activate_zone_bunker_1");
	add_adjacent_zone("zone_bunker_1a", "zone_bunker_1", "activate_zone_bunker_3a");
	add_adjacent_zone("zone_bunker_1", "zone_bunker_3a", "activate_zone_bunker_3a");
	add_adjacent_zone("zone_bunker_1", "zone_bunker_6", "activate_zone_bunker_1");
	add_adjacent_zone("zone_bunker_1", "zone_bunker_6", "activate_zone_bunker_3a");
	add_adjacent_zone("zone_bunker_3a", "zone_bunker_3b", "activate_zone_bunker_3a");
	add_adjacent_zone("zone_bunker_3a", "zone_bunker_3b", "activate_zone_bunker_3b");
	add_adjacent_zone("zone_bunker_3b", "zone_bunker_5a", "activate_zone_bunker_3b");
	add_adjacent_zone("zone_start_b", "zone_bunker_2a", "activate_zone_bunker_2");
	add_adjacent_zone("zone_bunker_2a", "zone_bunker_2", "activate_zone_bunker_2");
	add_adjacent_zone("zone_bunker_2a", "zone_bunker_2", "activate_zone_bunker_4a");
	add_adjacent_zone("zone_bunker_2", "zone_bunker_4a", "activate_zone_bunker_4a");
	add_adjacent_zone("zone_bunker_4a", "zone_bunker_4b", "activate_zone_bunker_4a");
	add_adjacent_zone("zone_bunker_4a", "zone_bunker_4c", "activate_zone_bunker_4a");
	add_adjacent_zone("zone_bunker_4b", "zone_bunker_4f", "activate_zone_bunker_4a");
	add_adjacent_zone("zone_bunker_4c", "zone_bunker_4d", "activate_zone_bunker_4a");
	add_adjacent_zone("zone_bunker_4a", "zone_bunker_4b", "activate_zone_bunker_4b");
	add_adjacent_zone("zone_bunker_4a", "zone_bunker_4c", "activate_zone_bunker_4b");
	add_adjacent_zone("zone_bunker_4b", "zone_bunker_4f", "activate_zone_bunker_4b");
	add_adjacent_zone("zone_bunker_4c", "zone_bunker_4d", "activate_zone_bunker_4b");
	add_adjacent_zone("zone_bunker_4b", "zone_bunker_5a", "activate_zone_bunker_4b");
	add_adjacent_zone("zone_nml_0", "zone_nml_1", "activate_zone_nml");
	add_adjacent_zone("zone_nml_0", "zone_nml_farm", "activate_zone_farm");
	add_adjacent_zone("zone_nml_1", "zone_nml_2", "activate_zone_nml");
	add_adjacent_zone("zone_nml_1", "zone_nml_4", "activate_zone_nml");
	add_adjacent_zone("zone_nml_1", "zone_nml_20", "activate_zone_nml");
	add_adjacent_zone("zone_nml_2", "zone_nml_2b", "activate_zone_nml");
	add_adjacent_zone("zone_nml_2", "zone_nml_3", "activate_zone_nml");
	add_adjacent_zone("zone_nml_3", "zone_nml_4", "activate_zone_nml");
	add_adjacent_zone("zone_nml_3", "zone_nml_13", "activate_zone_nml");
	add_adjacent_zone("zone_nml_4", "zone_nml_5", "activate_zone_nml");
	add_adjacent_zone("zone_nml_4", "zone_village_5", "activate_zone_nml");
	add_adjacent_zone("zone_nml_5", "zone_nml_farm", "activate_zone_farm");
	add_adjacent_zone("zone_nml_6", "zone_nml_2b", "activate_zone_nml");
	add_adjacent_zone("zone_nml_6", "zone_nml_7", "activate_zone_nml");
	add_adjacent_zone("zone_nml_6", "zone_nml_7a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_6", "zone_nml_8", "activate_zone_nml");
	add_adjacent_zone("zone_nml_7", "zone_nml_7a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_7", "zone_nml_9", "activate_zone_nml");
	add_adjacent_zone("zone_nml_7", "zone_nml_10", "activate_zone_nml");
	add_adjacent_zone("zone_nml_8", "zone_nml_10a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_8", "zone_nml_14", "activate_zone_nml");
	add_adjacent_zone("zone_nml_8", "zone_nml_16", "activate_zone_nml");
	add_adjacent_zone("zone_nml_9", "zone_nml_7a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_9", "zone_nml_9a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_9", "zone_nml_11", "activate_zone_nml");
	add_adjacent_zone("zone_nml_10", "zone_nml_10a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_10", "zone_nml_11", "activate_zone_nml");
	add_adjacent_zone("zone_nml_10a", "zone_nml_12", "activate_zone_nml");
	add_adjacent_zone("zone_nml_10a", "zone_village_4", "activate_zone_nml");
	add_adjacent_zone("zone_nml_11", "zone_nml_9a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_11", "zone_nml_11a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_11", "zone_nml_12", "activate_zone_nml");
	add_adjacent_zone("zone_nml_12", "zone_nml_11a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_12", "zone_nml_12a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_13", "zone_nml_15", "activate_zone_nml");
	add_adjacent_zone("zone_nml_14", "zone_nml_15", "activate_zone_nml");
	add_adjacent_zone("zone_nml_15", "zone_nml_17", "activate_zone_nml");
	add_adjacent_zone("zone_nml_15a", "zone_nml_14", "activate_zone_nml");
	add_adjacent_zone("zone_nml_15a", "zone_nml_15", "activate_zone_nml");
	add_adjacent_zone("zone_nml_16", "zone_nml_2b", "activate_zone_nml");
	add_adjacent_zone("zone_nml_16", "zone_nml_16a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_16", "zone_nml_18", "activate_zone_ruins");
	add_adjacent_zone("zone_nml_17", "zone_nml_17a", "activate_zone_nml");
	add_adjacent_zone("zone_nml_17", "zone_nml_18", "activate_zone_ruins");
	add_adjacent_zone("zone_nml_farm", "zone_nml_farm_1", "activate_zone_farm");
	add_adjacent_zone("zone_village_1", "zone_village_1a", "activate_zone_village_0");
	add_adjacent_zone("zone_village_1", "zone_village_2", "activate_zone_village_1");
	add_adjacent_zone("zone_village_1", "zone_village_4b", "activate_zone_village_0");
	add_adjacent_zone("zone_village_1", "zone_village_5b", "activate_zone_village_0");
	add_adjacent_zone("zone_village_2", "zone_village_3", "activate_zone_village_1");
	add_adjacent_zone("zone_village_3", "zone_village_3a", "activate_zone_village_1");
	add_adjacent_zone("zone_village_3a", "zone_village_3b", "activate_zone_village_1");
	add_adjacent_zone("zone_village_6", "zone_village_5b", "activate_zone_village_0");
	add_adjacent_zone("zone_village_6", "zone_village_6a", "activate_zone_village_0");
	add_adjacent_zone("zone_chamber_0", "zone_chamber_1", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_0", "zone_chamber_3", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_0", "zone_chamber_4", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_1", "zone_chamber_2", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_1", "zone_chamber_3", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_1", "zone_chamber_4", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_1", "zone_chamber_5", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_2", "zone_chamber_4", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_2", "zone_chamber_5", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_3", "zone_chamber_4", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_3", "zone_chamber_6", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_3", "zone_chamber_7", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_4", "zone_chamber_5", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_4", "zone_chamber_6", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_4", "zone_chamber_7", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_4", "zone_chamber_8", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_5", "zone_chamber_7", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_5", "zone_chamber_8", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_6", "zone_chamber_7", "activate_zone_chamber");
	add_adjacent_zone("zone_chamber_7", "zone_chamber_8", "activate_zone_chamber");

	if (is_classic())
	{
		add_adjacent_zone("zone_bunker_4c", "zone_bunker_4e", "activate_zone_bunker_4a");
		add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_c1", "activate_zone_bunker_4a");
		add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_d", "activate_zone_bunker_4a");
		add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_bunker_4a");
		add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_bunker_4a");
		add_adjacent_zone("zone_bunker_4c", "zone_bunker_4e", "activate_zone_bunker_4b");
		add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_c1", "activate_zone_bunker_4b");
		add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_d", "activate_zone_bunker_4b");
		add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_bunker_4b");
		add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_bunker_4b");
		add_adjacent_zone("zone_bunker_5a", "zone_bunker_5b", "activate_zone_bunker_3b");
		add_adjacent_zone("zone_bunker_5a", "zone_bunker_5b", "activate_zone_bunker_4b");
		add_adjacent_zone("zone_bunker_5b", "zone_nml_2a", "activate_zone_nml");
		add_adjacent_zone("zone_nml_2", "zone_nml_2a", "activate_zone_nml");
		add_adjacent_zone("zone_nml_18", "zone_nml_19", "activate_zone_ruins");
		add_adjacent_zone("zone_nml_19", "ug_bottom_zone", "activate_zone_crypt");
		add_adjacent_zone("zone_bunker_tank_a", "zone_nml_7", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_a", "zone_nml_7a", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_a", "zone_bunker_tank_a1", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_a1", "zone_bunker_tank_a2", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_a1", "zone_bunker_tank_b", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_b", "zone_bunker_tank_c", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_b", "zone_bunker_6", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_d1", "zone_bunker_tank_e", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_e", "zone_bunker_tank_e1", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_e1", "zone_bunker_tank_e2", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_e1", "zone_bunker_tank_f", "activate_zone_nml");
		add_adjacent_zone("zone_bunker_tank_f", "zone_nml_1", "activate_zone_nml");
		add_adjacent_zone("zone_village_0", "zone_nml_15", "activate_zone_village_0");
		add_adjacent_zone("zone_village_0", "zone_village_4b", "activate_zone_village_0");
		add_adjacent_zone("zone_village_4", "zone_village_4a", "activate_zone_village_0");
		add_adjacent_zone("zone_village_4a", "zone_village_4b", "activate_zone_village_0");
		add_adjacent_zone("zone_village_5", "zone_village_5a", "activate_zone_village_0");
		add_adjacent_zone("zone_village_5a", "zone_village_5b", "activate_zone_village_0");
		add_adjacent_zone("zone_bunker_1a", "zone_fire_stairs", "activate_zone_bunker_1");
		add_adjacent_zone("zone_fire_stairs", "zone_fire_stairs_1", "activate_zone_bunker_1");
		add_adjacent_zone("zone_bunker_1a", "zone_fire_stairs", "activate_zone_bunker_3a");
		add_adjacent_zone("zone_fire_stairs", "zone_fire_stairs_1", "activate_zone_bunker_3a");
		add_adjacent_zone("zone_bunker_1a", "zone_fire_stairs", "activate_zone_bunker_1_tank");
		add_adjacent_zone("zone_fire_stairs", "zone_fire_stairs_1", "activate_zone_bunker_1_tank");
		add_adjacent_zone("zone_nml_9", "zone_air_stairs", "activate_zone_nml");
		add_adjacent_zone("zone_air_stairs", "zone_air_stairs_1", "activate_zone_nml");
		add_adjacent_zone("zone_nml_farm", "zone_nml_celllar", "activate_zone_farm");
		add_adjacent_zone("zone_nml_celllar", "zone_bolt_stairs", "activate_zone_farm");
		add_adjacent_zone("zone_bolt_stairs", "zone_bolt_stairs_1", "activate_zone_farm");
		add_adjacent_zone("zone_village_3", "zone_ice_stairs", "activate_zone_village_1");
		add_adjacent_zone("zone_ice_stairs", "zone_ice_stairs_1", "activate_zone_village_1");
		add_adjacent_zone("zone_bunker_1", "zone_bunker_1a", "activate_zone_bunker_1_tank");
		add_adjacent_zone("zone_bunker_2", "zone_bunker_2a", "activate_zone_bunker_2_tank");
		add_adjacent_zone("zone_bunker_4a", "zone_bunker_4b", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_4a", "zone_bunker_4c", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_4c", "zone_bunker_4d", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_4c", "zone_bunker_4e", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_c1", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_4e", "zone_bunker_tank_d", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_tank_c", "zone_bunker_tank_c1", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_tank_d", "zone_bunker_tank_d1", "activate_zone_bunker_4_tank");
		add_adjacent_zone("zone_bunker_tank_b", "zone_bunker_6", "activate_zone_bunker_6_tank");
		add_adjacent_zone("zone_bunker_1", "zone_bunker_6", "activate_zone_bunker_6_tank");

		level thread activate_zone_trig("trig_zone_bunker_1", "activate_zone_bunker_1_tank");
		level thread activate_zone_trig("trig_zone_bunker_2", "activate_zone_bunker_2_tank");
		level thread activate_zone_trig("trig_zone_bunker_4", "activate_zone_bunker_4_tank");
		level thread activate_zone_trig("trig_zone_bunker_6", "activate_zone_bunker_6_tank", "activate_zone_bunker_1_tank");
	}
	else
	{
		zone_init("zone_bunker_4e");
		zone_init("zone_bunker_5b");
		zone_init("zone_bunker_tank_a");
		zone_init("zone_bunker_tank_a1");
		zone_init("zone_bunker_tank_b");
		zone_init("zone_bunker_tank_c");
		zone_init("zone_bunker_tank_d");
		zone_init("zone_bunker_tank_d1");
		zone_init("zone_bunker_tank_e");
		zone_init("zone_bunker_tank_e1");
		zone_init("zone_bunker_tank_e2");
		zone_init("zone_bunker_tank_f");
		zone_init("zone_nml_2a");
		zone_init("zone_nml_19");
		zone_init("ug_bottom_zone");
		zone_init("zone_village_0");
		zone_init("zone_village_4a");
		zone_init("zone_village_5a");
		zone_init("zone_fire_stairs");
		zone_init("zone_fire_stairs_1");
		zone_init("zone_air_stairs");
		zone_init("zone_air_stairs_1");
		zone_init("zone_nml_celllar");
		zone_init("zone_bolt_stairs");
		zone_init("zone_bolt_stairs_1");
		zone_init("zone_ice_stairs");
		zone_init("zone_ice_stairs_1");
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
		case "crossbow_zm":
		case "crossbow_upgraded_zm":
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

tomb_zombie_death_event_callback()
{
	if (!is_classic())
	{
		return;
	}

	if (isdefined(self) && isdefined(self.damagelocation) && isdefined(self.damagemod) && isdefined(self.damageweapon) && isdefined(self.attacker) && isplayer(self.attacker))
	{
		if (is_headshot(self.damageweapon, self.damagelocation, self.damagemod) && maps\mp\zombies\_zm_challenges::challenge_exists("zc_headshots") && !(!isdefined(self.script_noteworthy) && !isdefined("capture_zombie") || isdefined(self.script_noteworthy) && isdefined("capture_zombie") && self.script_noteworthy == "capture_zombie"))
		{
			self.attacker maps\mp\zombies\_zm_challenges::increment_stat("zc_headshots");
		}
	}
}

tomb_custom_divetonuke_explode(attacker, origin)
{
	maps\mp\zombies\_zm_perk_divetonuke::divetonuke_explode(attacker, origin);
}

tomb_custom_electric_cherry_reload_attack()
{
	maps\mp\zombies\_zm_perk_electric_cherry::electric_cherry_reload_attack();
}

tomb_custom_electric_cherry_laststand()
{
	maps\mp\zombies\_zm_perk_electric_cherry::electric_cherry_laststand();
}

sndmeleewpnsound()
{
	// added to all maps in _zm_reimagined
}