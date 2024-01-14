#include clientscripts\mp\gametypes\zgrief;

onprecachegametype()
{
	if (getdvar("mapname") == "zm_prison")
	{
		setteamreviveicon("allies", "waypoint_revive_guards");
		setteamreviveicon("axis", "waypoint_revive_inmates");
	}
	else
	{
		setteamreviveicon("allies", "waypoint_revive_cdc_zm");
		setteamreviveicon("axis", "waypoint_revive_cia_zm");
	}

	level._effect["meat_stink_camera"] = loadfx("maps/zombie/fx_zmb_meat_stink_camera");
	level._effect["meat_stink_torso"] = loadfx("maps/zombie/fx_zmb_meat_stink_torso");

	registerclientfield("toplayer", "meat_stink", 1, 1, "int", ::meat_stink_cb, 0, 1);
}

premain()
{
	// removed
}