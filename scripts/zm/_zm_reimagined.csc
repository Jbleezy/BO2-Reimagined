#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zombies\_zm::init_wallbuy_fx, scripts\zm\replaced\_zm::init_wallbuy_fx);
	replaceFunc(clientscripts\mp\zombies\_zm_weapons::init, scripts\zm\replaced\_zm_weapons::init);
}