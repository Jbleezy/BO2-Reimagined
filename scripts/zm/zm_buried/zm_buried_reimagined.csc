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
	level.buildable_wallbuy_weapons[0] = "vector_zm";
	level.buildable_wallbuy_weapons[1] = "an94_zm";
	level.buildable_wallbuy_weapons[2] = "pdw57_zm";
	level.buildable_wallbuy_weapons[3] = "svu_zm";
	level.buildable_wallbuy_weapons[4] = "tazer_knuckles_zm";
	level.buildable_wallbuy_weapons[5] = "870mcs_zm";
	level.buildable_wallbuy_weapon_models = [];
	level.buildable_wallbuy_weapon_models["vector_zm"] = undefined;
	level.buildable_wallbuy_weapon_models["an94_zm"] = undefined;
	level.buildable_wallbuy_weapon_models["pdw57_zm"] = undefined;
	level.buildable_wallbuy_weapon_models["svu_zm"] = undefined;
	level.buildable_wallbuy_weapon_models["tazer_knuckles_zm"] = undefined;
	level.buildable_wallbuy_weapon_models["870mcs_zm"] = undefined;
	level.buildable_wallbuy_weapon_angles = [];
	level.buildable_wallbuy_weapon_angles["vector_zm"] = undefined;
	level.buildable_wallbuy_weapon_angles["an94_zm"] = undefined;
	level.buildable_wallbuy_weapon_angles["pdw57_zm"] = undefined;
	level.buildable_wallbuy_weapon_angles["svu_zm"] = undefined;
	level.buildable_wallbuy_weapon_angles["tazer_knuckles_zm"] = undefined;
	level.buildable_wallbuy_weapon_angles["870mcs_zm"] = undefined;
}