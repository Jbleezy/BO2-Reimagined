#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_highrise::init_gamemodes, scripts\zm\replaced\zm_highrise::init_gamemodes);

	level._effect["screecher_vortex"] = loadfx("maps/zombie/fx_zmb_screecher_vortex");
}

init()
{
	hide_static_models();
	dragon_rooftop_teleporter_fx();
}

hide_static_models()
{
	divetonuke_model_index = findstaticmodelindex((1726, 1269, 1984));

	if (isdefined(divetonuke_model_index))
	{
		hidestaticmodel(divetonuke_model_index);
	}
}

dragon_rooftop_teleporter_fx()
{
	teleporter_fx_origin = (2847, 226, 2754);
	teleporter_fx_angles = (90, 150, 0);

	playfx(0, level._effect["screecher_vortex"], teleporter_fx_origin, anglestoforward(teleporter_fx_angles));
}