#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_prison::init_gamemodes, scripts\zm\replaced\zm_prison::init_gamemodes);
	replaceFunc(clientscripts\mp\zm_prison::entityspawned_alcatraz, scripts\zm\replaced\zm_prison::entityspawned_alcatraz);
	replaceFunc(clientscripts\mp\zm_prison::flicker_in_and_out, scripts\zm\replaced\zm_prison::flicker_in_and_out);
	replaceFunc(clientscripts\mp\zombies\_zm_ai_brutus::brutusfootstepcbfunc, scripts\zm\replaced\_zm_ai_brutus::brutusfootstepcbfunc);

	level thread clientscripts\mp\_sticky_grenade::main();

	if (is_gametype_active("zstandard"))
	{
		level.zombiemode_using_additionalprimaryweapon_perk = 1;
	}

	if (!is_gametype_active("zclassic"))
	{
		clientscripts\mp\zombies\_zm_perk_electric_cherry::enable_electric_cherry_perk_for_level();
	}
}