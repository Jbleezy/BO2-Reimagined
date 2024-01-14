#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_nuked::init_gamemodes, scripts\zm\replaced\zm_nuked::init_gamemodes);
}