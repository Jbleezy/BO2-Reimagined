#include clientscripts\mp\zm_tomb;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_filter;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zm_tomb_ffotd;
#include clientscripts\mp\zm_tomb_teleporter;
#include clientscripts\mp\zombies\_zm_weap_one_inch_punch;
#include clientscripts\mp\zombies\_zm_perk_electric_cherry;
#include clientscripts\mp\zombies\_zm_perk_divetonuke;
#include clientscripts\mp\zm_tomb_quest_fire;
#include clientscripts\mp\zm_tomb_tank;
#include clientscripts\mp\zm_tomb_giant_robot;
#include clientscripts\mp\zm_tomb_capture_zones;
#include clientscripts\mp\zombies\_zm_ai_mechz;
#include clientscripts\mp\zombies\_zm_perk_random;
#include clientscripts\mp\zombies\_zm_challenges;
#include clientscripts\mp\zm_tomb_dig;
#include clientscripts\mp\zm_tomb_fx;
#include clientscripts\mp\zm_tomb_ee;
#include clientscripts\mp\zm_tomb_amb;
#include clientscripts\mp\zm_tomb_ambient_scripts;
#include clientscripts\mp\zm_tomb_classic;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_sticky_grenade;
#include clientscripts\mp\zombies\_zm_weap_beacon;
#include clientscripts\mp\zombies\_zm_weap_riotshield_tomb;
#include clientscripts\mp\zombies\_zm_weap_staff_air;
#include clientscripts\mp\zombies\_zm_weap_staff_fire;
#include clientscripts\mp\zombies\_zm_weap_staff_lightning;
#include clientscripts\mp\zombies\_zm_weap_staff_water;
#include clientscripts\mp\zombies\_zm_weap_cymbal_monkey;
#include clientscripts\mp\zombies\_zm_magicbox_tomb;
#include clientscripts\mp\zombies\_zm_powerup_zombie_blood;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zombies\_zm_equipment;
#include clientscripts\mp\zombies\_zm_ai_quadrotor;
#include clientscripts\mp\_fx;

init_gamemodes()
{
	add_map_gamemode("zclassic", undefined, undefined);
	add_map_gamemode("zstandard", undefined, undefined);
	add_map_gamemode("zgrief", undefined, undefined);

	add_map_location_gamemode("zclassic", "tomb", clientscripts\mp\zm_tomb_classic::precache, clientscripts\mp\zm_tomb_classic::premain, clientscripts\mp\zm_tomb_classic::main);

	add_map_location_gamemode("zstandard", "trenches", undefined, undefined, undefined);

	add_map_location_gamemode("zgrief", "trenches", undefined, undefined, undefined);
}

entityspawned_tomb(localclientnum)
{
	if (!isdefined(self.type))
	{
		return;
	}

	if (self.type == "player")
	{
		self thread playerspawned(localclientnum);
	}

	if (self.type == "vehicle")
	{
		if (self.vehicletype == "heli_quadrotor_zm")
		{
			self thread clientscripts\mp\zombies\_zm_ai_quadrotor::spawned(localclientnum);
		}
	}

	if (self.type == "missile")
	{
		switch (self.weapon)
		{
			case "crossbow_explosive_bolt_zm":
			case "crossbow_explosive_bolt_upgraded_zm":
				self thread clientscripts\mp\_explosive_bolt::spawned(localclientnum);
				break;
		}
	}
}