#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	if (is_gametype_active("zstandard"))
	{
		level.zombiemode_using_additionalprimaryweapon_perk = 1;
		level.zombiemode_using_divetonuke_perk = 1;
		clientscripts\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();
	}
}