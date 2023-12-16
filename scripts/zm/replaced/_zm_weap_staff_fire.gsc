#include maps\mp\zombies\_zm_weap_staff_fire;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zm_tomb_craftables;
#include maps\mp\zm_tomb_utility;

flame_damage_fx( damageweapon, e_attacker, pct_damage = 1.0 )
{
	was_on_fire = is_true( self.is_on_fire );
	n_initial_dmg = get_impact_damage( damageweapon ) * pct_damage;
	is_upgraded = damageweapon == "staff_fire_upgraded_zm" || damageweapon == "staff_fire_upgraded2_zm" || damageweapon == "staff_fire_upgraded3_zm";

	if ( is_upgraded )
	{
		self do_damage_network_safe( e_attacker, self.health, damageweapon, "MOD_BURNED" );

		if ( cointoss() )
			self thread zombie_gib_all();
		else
			self thread zombie_gib_guts();

		return;
	}

	self endon( "death" );

	if ( !is_upgraded && !was_on_fire )
	{
		self.is_on_fire = 1;
		self thread zombie_set_and_restore_flame_state();
		wait 0.5;
		self thread flame_damage_over_time( e_attacker, damageweapon, pct_damage );
	}

	if ( n_initial_dmg > 0 )
		self do_damage_network_safe( e_attacker, n_initial_dmg, damageweapon, "MOD_BURNED" );
}

get_impact_damage( damageweapon )
{
	switch ( damageweapon )
	{
		case "staff_fire_zm":
			return 2050;
		case "staff_fire_upgraded_zm":
		case "staff_fire_upgraded2_zm":
		case "staff_fire_upgraded3_zm":
			return 3300;
		case "one_inch_punch_fire_zm":
			return 0;
		default:
			return 0;
	}
}