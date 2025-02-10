#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_nuked::main, scripts\zm\replaced\zm_nuked::main);

	clientscripts\_explosive_dart::main();
}