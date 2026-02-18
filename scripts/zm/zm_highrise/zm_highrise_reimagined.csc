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
	teleporters_fx();
}

hide_static_models()
{
	divetonuke_model_index = findstaticmodelindex((1726, 1269, 1984));

	if (isdefined(divetonuke_model_index))
	{
		hidestaticmodel(divetonuke_model_index);
	}
}

teleporters_fx()
{
	teleporters_fx = [];

	teleporter_fx = spawnstruct();
	teleporter_fx.origin = (2847, 226, 2754);
	teleporter_fx.angles = (90, 150, 0);
	teleporters_fx[teleporters_fx.size] = teleporter_fx;

	teleporter_fx = spawnstruct();
	teleporter_fx.origin = (3218, 543, 1170);
	teleporter_fx.angles = (90, 240, 0);
	teleporters_fx[teleporters_fx.size] = teleporter_fx;

	teleporter_fx = spawnstruct();
	teleporter_fx.origin = (2720, 831, 1170);
	teleporter_fx.angles = (90, 240, 0);
	teleporters_fx[teleporters_fx.size] = teleporter_fx;

	foreach (teleporter_fx in teleporters_fx)
	{
		playfx(0, level._effect["screecher_vortex"], teleporter_fx.origin, anglestoforward(teleporter_fx.angles));
	}
}