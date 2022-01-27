#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
    level.special_weapon_magicbox_check = ::nuked_special_weapon_magicbox_check;
}

nuked_special_weapon_magicbox_check(weapon)
{
	return 1;
}