#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zombies\_zm::init_wallbuy_fx, scripts\zm\replaced\_zm::init_wallbuy_fx);
	replaceFunc(clientscripts\mp\zombies\_zm_weapons::wallbuy_player_connect, scripts\zm\replaced\_zm_weapons::wallbuy_player_connect);
	replaceFunc(clientscripts\mp\zombies\_zm_weapons::wallbuy_callback_idx, scripts\zm\replaced\_zm_weapons::wallbuy_callback_idx);
}