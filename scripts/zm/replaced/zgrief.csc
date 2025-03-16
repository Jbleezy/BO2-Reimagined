#include clientscripts\mp\gametypes\zgrief;

onprecachegametype()
{
	if (getdvar("mapname") == "zm_prison" || getdvar("mapname") == "zm_tomb")
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
	level._effect["meat_glow3p"] = loadfx("maps/zombie/fx_zmb_meat_glow_3p");
}

premain()
{
	registerclientfield("toplayer", "meat_stink", 1, 1, "int", ::meat_stink_cb, 0, 1);
	registerclientfield("toplayer", "meat_glow", 1, 1, "int", ::meat_glow_cb, 0, 1);
}

meat_stink_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if (newval)
	{
		if (!isdefined(level.meatstink_fx))
		{
			level.meatstink_fx = playfxontag(localclientnum, level._effect["meat_stink_camera"], self, "J_SpineLower");
		}
	}
	else
	{
		if (isdefined(level.meatstink_fx))
		{
			stopfx(localclientnum, level.meatstink_fx);
			level.meatstink_fx = undefined;
		}
	}
}

meat_glow_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if (newval)
	{
		level thread meat_glow_think(localclientnum);
	}
	else
	{
		if (isdefined(level.meatglow_fx))
		{
			deletefx(localclientnum, level.meatglow_fx);
			level.meatglow_fx = undefined;
		}

		level notify("meat_glow_stop");
	}
}

meat_glow_think(localclientnum)
{
	level endon("meat_glow_stop");

	while (!(getcurrentweapon(localclientnum) == "item_meat_zm" || getcurrentweapon(localclientnum) == "item_head_zm"))
	{
		wait 0.05;
	}

	level thread meat_glow_melee_think(localclientnum);
	level thread meat_glow_weapon_change_think(localclientnum);
}

meat_glow_melee_think(localclientnum)
{
	level endon("meat_glow_stop");

	tagname = "tag_weapon";

	if (getcurrentweapon(localclientnum) == "item_head_zm")
	{
		tagname = "j_head";
	}

	while (1)
	{
		if (!isdefined(level.meatglow_fx))
		{
			level.meatglow_fx = playviewmodelfx(localclientnum, level._effect["meat_glow3p"], tagname);
		}

		while (!ismeleeing(localclientnum))
		{
			wait 0.05;
		}

		if (isdefined(level.meatglow_fx))
		{
			deletefx(localclientnum, level.meatglow_fx);
			level.meatglow_fx = undefined;
		}

		while (ismeleeing(localclientnum))
		{
			wait 0.05;
		}
	}
}

meat_glow_weapon_change_think(localclientnum)
{
	level endon("meat_glow_stop");

	while (getcurrentweapon(localclientnum) == "item_meat_zm" || getcurrentweapon(localclientnum) == "item_head_zm")
	{
		wait 0.05;
	}

	if (isdefined(level.meatglow_fx))
	{
		deletefx(localclientnum, level.meatglow_fx);
		level.meatglow_fx = undefined;
	}

	level notify("meat_glow_stop");
}