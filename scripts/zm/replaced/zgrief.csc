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
}