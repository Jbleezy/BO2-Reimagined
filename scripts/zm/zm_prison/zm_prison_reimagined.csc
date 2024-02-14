#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_prison::entityspawned_alcatraz, scripts\zm\replaced\zm_prison::entityspawned_alcatraz);
	replaceFunc(clientscripts\mp\zombies\_zm_ai_brutus::brutusfootstepcbfunc, scripts\zm\replaced\_zm_ai_brutus::brutusfootstepcbfunc);

	level thread clientscripts\mp\_sticky_grenade::main();

	if (is_gametype_active("zstandard"))
	{
		level.zombiemode_using_additionalprimaryweapon_perk = 1;
		level.zombiemode_using_divetonuke_perk = 1;
		clientscripts\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();
	}
}