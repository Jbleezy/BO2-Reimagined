#include maps\mp\zm_tomb_ffotd;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_zonemgr;
#include codescripts\struct;

update_charger_position()
{
	if (isdefined(level.a_elemental_staffs))
	{
		foreach (e_staff in level.a_elemental_staffs)
		{
			e_staff moveto(e_staff.charger.origin, 0.05);
		}
	}

	if (isdefined(level.a_elemental_staffs_upgraded))
	{
		foreach (e_staff in level.a_elemental_staffs_upgraded)
		{
			e_staff moveto(e_staff.charger.origin, 0.05);
		}
	}
}

player_spawn_fix()
{
	// fixed in zm_tomb::working_zone_init
}