#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_buried::init_gamemodes, scripts\zm\replaced\zm_buried::init_gamemodes);
	replaceFunc(clientscripts\mp\zm_buried::start_zombie_stuff, scripts\zm\replaced\zm_buried::start_zombie_stuff);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::init_vulture, scripts\zm\replaced\_zm_perk_vulture::init_vulture);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::vulture_vision_enable, scripts\zm\replaced\_zm_perk_vulture::vulture_vision_enable);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::vulture_vision_update_wallbuy_list, scripts\zm\replaced\_zm_perk_vulture::vulture_vision_update_wallbuy_list);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::vulture_vision_mystery_box, scripts\zm\replaced\_zm_perk_vulture::vulture_vision_mystery_box);
}

init()
{
	prepare_chalk_weapon_list();
}

prepare_chalk_weapon_list()
{
	level.buildable_wallbuy_weapons = [];
	level.buildable_wallbuy_weapon_models = [];
	level.buildable_wallbuy_weapon_angles = [];
	level.buildable_wallbuy_weapon_offsets = [];

	if (getdvar("ui_zm_mapstartlocation") == "maze")
	{
		level.buildable_wallbuy_weapons[0] = "saritch_zm";
		level.buildable_wallbuy_weapons[1] = "ballista_zm";
		level.buildable_wallbuy_weapons[2] = "beretta93r_zm";
		level.buildable_wallbuy_weapons[3] = "pdw57_zm";
		level.buildable_wallbuy_weapons[4] = "an94_zm";
		level.buildable_wallbuy_weapons[5] = "lsat_zm";
	}
	else if (getdvar("ui_zm_mapstartlocation") == "street")
	{
		level.buildable_wallbuy_weapons[0] = "vector_zm";
		level.buildable_wallbuy_weapons[1] = "an94_zm";
		level.buildable_wallbuy_weapons[2] = "pdw57_zm";
		level.buildable_wallbuy_weapons[3] = "svu_zm";
		level.buildable_wallbuy_weapons[4] = "ballista_zm";
		level.buildable_wallbuy_weapons[5] = "870mcs_zm";
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

	level.buildable_wallbuy_weapon_offsets["vector_zm"] = (2, 0, 0);
	level.buildable_wallbuy_weapon_offsets["an94_zm"] = (4, 0, 0);
	level.buildable_wallbuy_weapon_offsets["pdw57_zm"] = (10, 0, 0);
	level.buildable_wallbuy_weapon_offsets["svu_zm"] = (8, 0, 0);
	level.buildable_wallbuy_weapon_offsets["tazer_knuckles_zm"] = (0, 0, 0);
	level.buildable_wallbuy_weapon_offsets["870mcs_zm"] = (3, 0, 0);
	level.buildable_wallbuy_weapon_offsets["saritch_zm"] = (3, 0, 0);
	level.buildable_wallbuy_weapon_offsets["ballista_zm"] = (0, 0, 0);
	level.buildable_wallbuy_weapon_offsets["beretta93r_zm"] = (8, 0, 0);
	level.buildable_wallbuy_weapon_offsets["lsat_zm"] = (8, 0, 0);

	foreach (buildable_wallbuy_weapon in level.buildable_wallbuy_weapons)
	{
		level.buildable_wallbuy_weapon_models[buildable_wallbuy_weapon] = undefined;
		level.buildable_wallbuy_weapon_angles[buildable_wallbuy_weapon] = undefined;
	}
}