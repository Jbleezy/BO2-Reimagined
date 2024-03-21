#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_transit::start_zombie_stuff, scripts\zm\replaced\zm_transit::start_zombie_stuff);
}