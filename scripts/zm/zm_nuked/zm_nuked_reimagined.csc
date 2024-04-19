#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_nuked::main, scripts\zm\replaced\zm_nuked::main);

	scripts\zm\reimagined\_explosive_dart::main();
}