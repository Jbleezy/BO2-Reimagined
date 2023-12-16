#include maps\mp\zm_tomb_ee_main;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_quest_air;
#include maps\mp\zm_tomb_quest_fire;
#include maps\mp\zm_tomb_quest_ice;
#include maps\mp\zm_tomb_quest_elec;
#include maps\mp\zm_tomb_quest_crypt;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zm_tomb_craftables;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zm_tomb_ee_main_step_7;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_amb;
#include maps\mp\zombies\_zm_audio;

all_staffs_inserted_in_puzzle_room()
{
	n_staffs_inserted = 0;

	foreach ( staff in level.a_elemental_staffs )
	{
		if ( staff.upgrade.charger.is_inserted && staff.upgrade.charger.full )
			n_staffs_inserted++;
	}

	if ( n_staffs_inserted == 4 )
		return true;
	else
		return false;
}