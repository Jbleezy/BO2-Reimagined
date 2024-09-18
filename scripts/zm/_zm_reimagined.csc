#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zombies\_zm::init_wallbuy_fx, scripts\zm\replaced\_zm::init_wallbuy_fx);
	replaceFunc(clientscripts\mp\zombies\_zm::entityspawned, scripts\zm\replaced\_zm::entityspawned);
	replaceFunc(clientscripts\mp\zombies\_zm_audio::sndmeleeswipe, scripts\zm\replaced\_zm_audio::sndmeleeswipe);
	replaceFunc(clientscripts\mp\zombies\_zm_weapons::init, scripts\zm\replaced\_zm_weapons::init);

	powerup_changes();
}

init()
{
	level thread toggle_vending_divetonuke_power_on_think();
	level thread toggle_vending_divetonuke_power_off_think();
}

powerup_changes()
{
	if (getDvar("mapname") == "zm_transit" || getDvar("mapname") == "zm_highrise")
	{
		include_powerup("fire_sale");
	}
}

toggle_vending_divetonuke_power_on_think()
{
	while (1)
	{
		level waittill("toggle_vending_divetonuke_power_on");

		ents = getentarray(0);

		foreach (ent in ents)
		{
			if (isdefined(ent.model) && ent.model == "p6_zm_al_vending_nuke_on")
			{
				ent mapshaderconstant(0, 1, "ScriptVector0");
				ent setshaderconstant(0, 1, 0, 0.5, 0, 0);
			}
		}
	}
}

toggle_vending_divetonuke_power_off_think()
{
	while (1)
	{
		level waittill("toggle_vending_divetonuke_power_off");

		ents = getentarray(0);

		foreach (ent in ents)
		{
			if (isdefined(ent.model) && ent.model == "p6_zm_al_vending_nuke_on")
			{
				ent mapshaderconstant(0, 1, "ScriptVector0");
				ent setshaderconstant(0, 1, 0, 0, 0, 0);
			}
		}
	}
}