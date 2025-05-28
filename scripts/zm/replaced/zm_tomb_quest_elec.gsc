#include maps\mp\zm_tomb_quest_elec;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zombies\_zm_unitrigger;

electric_puzzle_1_run()
{
	level waittill("elemental_staff_lightning_crafted", player);
	flag_set("staff_lightning_zm_upgrade_unlocked");
}

electric_puzzle_2_init()
{
	level.electric_relays = [];
	level.electric_relays["bunker"] = spawnstruct();
	level.electric_relays["tank_platform"] = spawnstruct();
	level.electric_relays["start"] = spawnstruct();
	level.electric_relays["elec"] = spawnstruct();
	level.electric_relays["ruins"] = spawnstruct();
	level.electric_relays["air"] = spawnstruct();
	level.electric_relays["ice"] = spawnstruct();
	level.electric_relays["village"] = spawnstruct();

	foreach (s_relay in level.electric_relays)
	{
		s_relay.connections = [];
	}

	level.electric_relays["tank_platform"].connections[0] = "ruins";
	level.electric_relays["start"].connections[1] = "tank_platform";
	level.electric_relays["elec"].connections[0] = "ice";
	level.electric_relays["ruins"].connections[2] = "chamber";
	level.electric_relays["air"].connections[2] = "start";
	level.electric_relays["ice"].connections[3] = "village";
	level.electric_relays["village"].connections[2] = "air";
	level.electric_relays["bunker"].position = 2;
	level.electric_relays["tank_platform"].position = 1;
	level.electric_relays["start"].position = 3;
	level.electric_relays["elec"].position = 1;
	level.electric_relays["ruins"].position = 3;
	level.electric_relays["air"].position = 0;
	level.electric_relays["ice"].position = 1;
	level.electric_relays["village"].position = 1;
	a_switches = getentarray("puzzle_relay_switch", "script_noteworthy");

	foreach (e_switch in a_switches)
	{
		level.electric_relays[e_switch.script_string].e_switch = e_switch;
	}
}