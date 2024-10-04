#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perks;

tombstone_player_init()
{
	self set_player_tombstone_index();

	level.tombstones[self.tombstone_index] = spawnstruct();
}