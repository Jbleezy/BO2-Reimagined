#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_buried::start_zombie_stuff, scripts\zm\replaced\zm_buried::start_zombie_stuff);
}

init()
{
	prepare_chalk_weapon_list();
}

prepare_chalk_weapon_list()
{
	level.buildable_wallbuy_weapons = [];

	if (getdvar("ui_zm_mapstartlocation") == "maze")
	{
		level.buildable_wallbuy_weapons[0] = "saritch_zm";
		level.buildable_wallbuy_weapons[1] = "ballista_zm";
		level.buildable_wallbuy_weapons[2] = "beretta93r_zm";
		level.buildable_wallbuy_weapons[3] = "pdw57_zm";
		level.buildable_wallbuy_weapons[4] = "an94_zm";
		level.buildable_wallbuy_weapons[5] = "lsat_zm";
	}
	else
	{
		level.buildable_wallbuy_weapons[0] = "vector_zm";
		level.buildable_wallbuy_weapons[1] = "an94_zm";
		level.buildable_wallbuy_weapons[2] = "pdw57_zm";
		level.buildable_wallbuy_weapons[3] = "svu_zm";
		level.buildable_wallbuy_weapons[4] = "tazer_knuckles_zm";
		level.buildable_wallbuy_weapons[5] = "870mcs_zm";
	}

	level.buildable_wallbuy_weapon_models = [];
	level.buildable_wallbuy_weapon_angles = [];

	foreach (buildable_wallbuy_weapon in level.buildable_wallbuy_weapons)
	{
		level.buildable_wallbuy_weapon_models[buildable_wallbuy_weapon] = undefined;
		level.buildable_wallbuy_weapon_angles[buildable_wallbuy_weapon] = undefined;
	}
}