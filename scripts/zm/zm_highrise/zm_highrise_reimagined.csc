#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_highrise::init_gamemodes, scripts\zm\replaced\zm_highrise::init_gamemodes);
}

init()
{
	hide_static_models();
}

hide_static_models()
{
	divetonuke_model_index = findstaticmodelindex((1726, 1269, 1984));

	if (isdefined(divetonuke_model_index))
	{
		hidestaticmodel(divetonuke_model_index);
	}
}