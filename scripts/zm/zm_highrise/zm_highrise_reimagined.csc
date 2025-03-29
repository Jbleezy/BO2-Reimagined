#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_highrise::init_gamemodes, scripts\zm\replaced\zm_highrise::init_gamemodes);
}