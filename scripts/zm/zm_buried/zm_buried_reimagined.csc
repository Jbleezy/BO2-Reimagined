#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_buried::init_gamemodes, scripts\zm\replaced\zm_buried::init_gamemodes);
	replaceFunc(clientscripts\mp\zm_buried::start_zombie_stuff, scripts\zm\replaced\zm_buried::start_zombie_stuff);
	replaceFunc(clientscripts\mp\zm_buried_buildables::prepare_chalk_weapon_list, scripts\zm\replaced\zm_buried_buildables::prepare_chalk_weapon_list);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::vulture_vision_enable, scripts\zm\replaced\_zm_perk_vulture::vulture_vision_enable);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::vulture_vision_disable, scripts\zm\replaced\_zm_perk_vulture::vulture_vision_disable);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::vulture_vision_update_wallbuy_list, scripts\zm\replaced\_zm_perk_vulture::vulture_vision_update_wallbuy_list);
	replaceFunc(clientscripts\mp\zombies\_zm_perk_vulture::vulture_vision_mystery_box, scripts\zm\replaced\_zm_perk_vulture::vulture_vision_mystery_box);

	setsoundcontext("grass", "no_grass");
}