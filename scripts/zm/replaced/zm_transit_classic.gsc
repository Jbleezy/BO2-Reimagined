#include maps\mp\zm_transit_classic;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_ai_screecher;
#include maps\mp\zombies\_zm_ai_avogadro;
#include maps\mp\zm_transit_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zombies\_zm_equip_turbine;
#include maps\mp\zombies\_zm_equip_turret;
#include maps\mp\zombies\_zm_equip_electrictrap;
#include maps\mp\zm_transit_bus;
#include maps\mp\zm_transit_ai_screecher;
#include maps\mp\zombies\_zm_banking;
#include maps\mp\zm_transit_power;
#include maps\mp\zm_transit_ambush;
#include maps\mp\zm_transit;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_audio;

spawn_inert_zombies()
{
	if (!isdefined(self.angles))
	{
		self.angles = (0, 0, 0);
	}

	flag_wait("initial_players_connected");

	wait 0.1;

	if (isdefined(level.zombie_spawners))
	{
		spawner = random(level.zombie_spawners);
		ai = spawn_zombie(spawner);
	}

	if (isdefined(ai))
	{
		ai forceteleport(self.origin, self.angles);
		ai.start_inert = 1;
	}
}