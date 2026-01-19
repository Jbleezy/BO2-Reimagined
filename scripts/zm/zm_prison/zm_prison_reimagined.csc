#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_prison::init_gamemodes, scripts\zm\replaced\zm_prison::init_gamemodes);
	replaceFunc(clientscripts\mp\zm_prison::entityspawned_alcatraz, scripts\zm\replaced\zm_prison::entityspawned_alcatraz);
	replaceFunc(clientscripts\mp\zm_prison::flicker_in_and_out, scripts\zm\replaced\zm_prison::flicker_in_and_out);
	replaceFunc(clientscripts\mp\zombies\_zm_ai_brutus::brutusfootstepcbfunc, scripts\zm\replaced\_zm_ai_brutus::brutusfootstepcbfunc);

	level thread clientscripts\mp\_sticky_grenade::main();

	if (!is_gametype_active("zclassic") && !is_gametype_active("zgrief"))
	{
		level.zombiemode_using_divetonuke_perk = 1;
		clientscripts\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();

		level.zombiemode_using_additionalprimaryweapon_perk = 1;
	}

	if (!is_gametype_active("zclassic"))
	{
		clientscripts\mp\zombies\_zm_perk_electric_cherry::enable_electric_cherry_perk_for_level();
	}
}

init()
{
	hide_static_models();
	docks_teleporter_fx();
}

hide_static_models()
{
	divetonuke_model_index = findstaticmodelindex((-599, 4832, -63));

	if (isdefined(divetonuke_model_index))
	{
		hidestaticmodel(divetonuke_model_index);
	}

	additionalprimaryweapon_model_index = findstaticmodelindex((-552, 4846, -69));

	if (isdefined(additionalprimaryweapon_model_index))
	{
		hidestaticmodel(additionalprimaryweapon_model_index);
	}
}

docks_teleporter_fx()
{
	teleporter = getstruct("docks_teleporter", "targetname");

	playfx(0, level._effect["hell_portal"], teleporter.origin, anglestoforward(teleporter.angles));
}