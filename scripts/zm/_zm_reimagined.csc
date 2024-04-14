#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zombies\_zm::init_wallbuy_fx, scripts\zm\replaced\_zm::init_wallbuy_fx);
	replaceFunc(clientscripts\mp\zombies\_zm_audio::sndmeleeswipe, scripts\zm\replaced\_zm_audio::sndmeleeswipe);
	replaceFunc(clientscripts\mp\zombies\_zm_weapons::init, scripts\zm\replaced\_zm_weapons::init);

	powerup_changes();
}

powerup_changes()
{
	if (getDvar("mapname") == "zm_transit" || getDvar("mapname") == "zm_highrise")
	{
		include_powerup("fire_sale");
	}
}