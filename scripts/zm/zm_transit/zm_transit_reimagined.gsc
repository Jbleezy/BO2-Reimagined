#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/zm_transit;
#include scripts/zm/replaced/_zm_equip_electrictrap;
#include scripts/zm/replaced/_zm_equip_turret;

main()
{
	replaceFunc(maps/mp/zm_transit::lava_damage_depot, scripts/zm/replaced/zm_transit::lava_damage_depot);
	replaceFunc(maps/mp/zombies/_zm_equip_electrictrap::startelectrictrapdeploy, scripts/zm/replaced/_zm_equip_electrictrap::startelectrictrapdeploy);
	replaceFunc(maps/mp/zombies/_zm_equip_turret::startturretdeploy, scripts/zm/replaced/_zm_equip_turret::startturretdeploy);
}