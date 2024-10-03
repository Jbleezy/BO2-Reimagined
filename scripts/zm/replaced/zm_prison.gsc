#include maps\mp\zm_prison;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_gamemodes;
#include maps\mp\zm_prison_fx;
#include maps\mp\zm_prison_ffotd;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_alcatraz_amb;
#include maps\mp\zombies\_load;
#include maps\mp\zm_prison_achievement;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\zm_alcatraz_distance_tracking;
#include maps\mp\zm_alcatraz_traps;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\zombies\_zm_magicbox_prison;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_riotshield_prison;
#include maps\mp\zombies\_zm_weap_blundersplat;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\_visionset_mgr;
#include character\c_zom_arlington;
#include character\c_zom_deluca;
#include character\c_zom_handsome;
#include character\c_zom_oleary;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;

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
		level.machine_assets["packapunch"].off_model = "p6_zm_al_vending_pap_on";
		level.machine_assets["packapunch"].on_model = "p6_zm_al_vending_pap_on";
		level.machine_assets["packapunch"].power_on_callback = maps\mp\zm_prison::custom_vending_power_on;
		level.machine_assets["packapunch"].power_off_callback = maps\mp\zm_prison::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk)
	{
		precacheitem("zombie_perk_bottle_additionalprimaryweapon");
		precacheshader("specialty_additionalprimaryweapon_zombies");
		precachemodel("p6_zm_al_vending_three_gun_on");
		precachestring(&"ZOMBIE_PERK_ADDITIONALWEAPONPERK");
		level._effect["additionalprimaryweapon_light"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_perk_smk");
		level.machine_assets["additionalprimaryweapon"] = spawnstruct();
		level.machine_assets["additionalprimaryweapon"].weapon = "zombie_perk_bottle_additionalprimaryweapon";
		level.machine_assets["additionalprimaryweapon"].off_model = "p6_zm_al_vending_three_gun_on";
		level.machine_assets["additionalprimaryweapon"].on_model = "p6_zm_al_vending_three_gun_on";
		level.machine_assets["additionalprimaryweapon"].power_on_callback = maps\mp\zm_prison::custom_vending_power_on;
		level.machine_assets["additionalprimaryweapon"].power_off_callback = maps\mp\zm_prison::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk)
	{
		precacheitem("zombie_perk_bottle_deadshot");
		precacheshader("specialty_ads_zombies");
		precachemodel("p6_zm_al_vending_ads_on");
		precachestring(&"ZOMBIE_PERK_DEADSHOT");
		level._effect["deadshot_light"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_perk_smk");
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].on_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].power_on_callback = maps\mp\zm_prison::custom_vending_power_on;
		level.machine_assets["deadshot"].power_off_callback = maps\mp\zm_prison::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk)
	{
		precacheitem("zombie_perk_bottle_doubletap");
		precacheshader("specialty_doubletap_zombies");
		precachemodel("p6_zm_al_vending_doubletap2_on");
		precachestring(&"ZOMBIE_PERK_DOUBLETAP");
		level._effect["doubletap_light"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_perk_smk");
		level.machine_assets["doubletap"] = spawnstruct();
		level.machine_assets["doubletap"].weapon = "zombie_perk_bottle_doubletap";
		level.machine_assets["doubletap"].off_model = "p6_zm_al_vending_doubletap2_on";
		level.machine_assets["doubletap"].on_model = "p6_zm_al_vending_doubletap2_on";
		level.machine_assets["doubletap"].power_on_callback = maps\mp\zm_prison::custom_vending_power_on;
		level.machine_assets["doubletap"].power_off_callback = maps\mp\zm_prison::custom_vending_power_off;
	}

	if (isdefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk)
	{
		precacheitem("zombie_perk_bottle_jugg");
		precacheshader("specialty_juggernaut_zombies");
		precachemodel("p6_zm_al_vending_jugg_on");
		precachestring(&"ZOMBIE_PERK_JUGGERNAUT");
		level._effect["jugger_light"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_perk_smk");
		level.machine_assets["juggernog"] = spawnstruct();
		level.machine_assets["juggernog"].weapon = "zombie_perk_bottle_jugg";
		level.machine_assets["juggernog"].off_model = "p6_zm_al_vending_jugg_on";
		level.machine_assets["juggernog"].on_model = "p6_zm_al_vending_jugg_on";
		level.machine_assets["juggernog"].power_on_callback = maps\mp\zm_prison::custom_vending_power_on;
		level.machine_assets["juggernog"].power_off_callback = maps\mp\zm_prison::custom_vending_power_off;
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
	}

	if (isdefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk)
	{
		precacheitem("zombie_perk_bottle_revive");
		precacheshader("specialty_quickrevive_zombies");
		precachemodel("zombie_vending_revive");
		precachemodel("zombie_vending_revive_on");
		precachestring(&"ZOMBIE_PERK_QUICKREVIVE");
		level._effect["revive_light"] = loadfx("misc/fx_zombie_cola_revive_on");
		level._effect["revive_light_flicker"] = loadfx("maps/zombie/fx_zmb_cola_revive_flicker");
		level.machine_assets["revive"] = spawnstruct();
		level.machine_assets["revive"].weapon = "zombie_perk_bottle_revive";
		level.machine_assets["revive"].off_model = "zombie_vending_revive";
		level.machine_assets["revive"].on_model = "zombie_vending_revive_on";
	}

	if (isdefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk)
	{
		precacheitem("zombie_perk_bottle_sleight");
		precacheshader("specialty_fastreload_zombies");
		precachemodel("p6_zm_al_vending_sleight_on");
		precachestring(&"ZOMBIE_PERK_FASTRELOAD");
		level._effect["sleight_light"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_perk_smk");
		level.machine_assets["speedcola"] = spawnstruct();
		level.machine_assets["speedcola"].weapon = "zombie_perk_bottle_sleight";
		level.machine_assets["speedcola"].off_model = "p6_zm_al_vending_sleight_on";
		level.machine_assets["speedcola"].on_model = "p6_zm_al_vending_sleight_on";
		level.machine_assets["speedcola"].power_on_callback = maps\mp\zm_prison::custom_vending_power_on;
		level.machine_assets["speedcola"].power_off_callback = maps\mp\zm_prison::custom_vending_power_off;
	}
}

delete_perk_machine_clip()
{
	perk_machines = getentarray("zombie_vending", "targetname");

	foreach (perk_machine in perk_machines)
	{
		if (isdefined(perk_machine.clip))
		{
			perk_machine.clip delete();
		}

		if (isdefined(perk_machine.target) && (perk_machine.target == "vending_divetonuke" || perk_machine.target == "vending_additionalprimaryweapon"))
		{
			spawn_custom_perk_collision(perk_machine);
		}
	}
}

spawn_custom_perk_collision(perk_machine)
{
	collision = spawn("script_model", perk_machine.origin + (0, 0, 64), 1);
	collision.angles = perk_machine.angles;

	collision setmodel("collision_clip_32x32x128");
	collision disconnectpaths();
}