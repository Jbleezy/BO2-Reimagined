#include clientscripts\mp\zm_prison;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_filter;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zm_prison_ffotd;
#include clientscripts\mp\zombies\_zm_perk_electric_cherry;
#include clientscripts\mp\zombies\_zm_perk_divetonuke;
#include clientscripts\mp\zm_alcatraz_classic;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zm_prison_fx;
#include clientscripts\mp\zm_alcatraz_amb;
#include clientscripts\mp\zombies\_zm_ai_brutus;
#include clientscripts\mp\zm_alcatraz_grief_cellblock;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_zm_craftables;
#include clientscripts\mp\zombies\_zm_magicbox_prison;
#include clientscripts\mp\zombies\_zm_weap_riotshield_prison;
#include clientscripts\mp\zombies\_zm_weap_blundersplat;
#include clientscripts\mp\zombies\_zm_weap_tomahawk;
#include clientscripts\mp\zm_prison_spoon;
#include clientscripts\mp\zm_prison_weap_quest;
#include clientscripts\mp\zombies\_zm_equipment;

init_gamemodes()
{
	add_map_gamemode("zclassic", undefined, undefined);
	add_map_gamemode("zstandard", undefined, undefined);
	add_map_gamemode("zgrief", undefined, undefined);
	add_map_location_gamemode("zclassic", "prison", clientscripts\mp\zm_alcatraz_classic::precache, clientscripts\mp\zm_alcatraz_classic::premain, clientscripts\mp\zm_alcatraz_classic::main);
	add_map_location_gamemode("zstandard", "cellblock", clientscripts\mp\zm_alcatraz_grief_cellblock::precache, undefined, clientscripts\mp\zm_alcatraz_grief_cellblock::main);
	add_map_location_gamemode("zgrief", "cellblock", clientscripts\mp\zm_alcatraz_grief_cellblock::precache, undefined, clientscripts\mp\zm_alcatraz_grief_cellblock::main);
}

entityspawned_alcatraz(localclientnum)
{
	if (!isdefined(self.type))
	{
		return;
	}

	if (self.type == "player")
		self thread playerspawned(localclientnum);

	if (self.type == "missile")
	{
		switch (self.weapon)
		{
			case "sticky_grenade_zm":
				self thread clientscripts\mp\_sticky_grenade::spawned(localclientnum);
				break;

			case "blundersplat_explosive_dart_zm":
			case "blundersplat_explosive_dart_upgraded_zm":
				self thread clientscripts\mp\zombies\_zm_weap_blundersplat::spawned(localclientnum);
				break;
		}
	}
}