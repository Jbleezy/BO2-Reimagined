#include maps\mp\zm_prison_sq_wth;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_zonemgr;

sq_is_weapon_sniper(str_weapon)
{
	a_snipers = array("dsr50", "as50");

	foreach (str_sniper in a_snipers)
	{
		if (issubstr(str_weapon, str_sniper) && !issubstr(str_weapon, "+is"))
		{
			return true;
		}
	}

	return false;
}