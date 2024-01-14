#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\gametypes\zgrief::onprecachegametype, scripts\zm\replaced\zgrief::onprecachegametype);
	replaceFunc(clientscripts\mp\gametypes\zgrief::premain, scripts\zm\replaced\zgrief::premain);
}