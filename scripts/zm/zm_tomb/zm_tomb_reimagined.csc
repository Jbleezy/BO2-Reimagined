#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zombies\_zm_ai_mechz::mechzfootstepcbfunc, scripts\zm\replaced\_zm_ai_mechz::mechzfootstepcbfunc);
}