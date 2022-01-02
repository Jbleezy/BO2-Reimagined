#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/zm_transit;
#include scripts/zm/replaced/_zm_weap_emp_bomb;
#include scripts/zm/replaced/_zm_equip_electrictrap;
#include scripts/zm/replaced/_zm_equip_turret;

main()
{
	replaceFunc(maps/mp/zm_transit::lava_damage_depot, scripts/zm/replaced/zm_transit::lava_damage_depot);
	replaceFunc(maps/mp/zombies/_zm_weap_emp_bomb::emp_detonate, scripts/zm/replaced/_zm_weap_emp_bomb::emp_detonate);
	replaceFunc(maps/mp/zombies/_zm_equip_electrictrap::startelectrictrapdeploy, scripts/zm/replaced/_zm_equip_electrictrap::startelectrictrapdeploy);
	replaceFunc(maps/mp/zombies/_zm_equip_turret::startturretdeploy, scripts/zm/replaced/_zm_equip_turret::startturretdeploy);
}

init()
{
	level.grenade_safe_to_bounce = ::grenade_safe_to_bounce;

	path_exploit_fixes();
}

grenade_safe_to_bounce( player, weapname )
{
	if ( !is_offhand_weapon( weapname ) )
	{
		return 1;
	}

	if ( self maps/mp/zm_transit_lava::object_touching_lava() )
	{
		return 0;
	}

	return 1;
}

path_exploit_fixes()
{
	// town bookstore near jug
	zombie_trigger_origin = ( 1045, -1521, 128 );
	zombie_trigger_radius = 96;
	zombie_trigger_height = 64;
	player_trigger_origin = ( 1116, -1547, 128 );
	player_trigger_radius = 72;
	zombie_goto_point = ( 1098, -1521, 128 );
	level thread maps/mp/zombies/_zm_ffotd::path_exploit_fix( zombie_trigger_origin, zombie_trigger_radius, zombie_trigger_height, player_trigger_origin, player_trigger_radius, zombie_goto_point );
}