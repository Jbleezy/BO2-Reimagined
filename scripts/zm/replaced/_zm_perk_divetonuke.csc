#include clientscripts\mp\zombies\_zm_perk_divetonuke;
#include clientscripts\mp\zombies\_zm_perks;
#include clientscripts\mp\_visionset_mgr;

divetonuke_client_field_func()
{
	bits = 1;

	if (clientscripts\mp\zombies\_zm_weapons::is_weapon_included("emp_grenade_zm"))
	{
		bits = 2;
	}

	registerclientfield("toplayer", "perk_dive_to_nuke", 9000, bits, "int", undefined, 0, 1);
}