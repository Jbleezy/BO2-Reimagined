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
		if (!isdefined(level.meatglow_fx))
		{
			tagname = "tag_weapon";

			if (getdvar("mapname") == "zm_prison" || getdvar("mapname") == "zm_tomb")
			{
				tagname = "tag_fx";
			}

			level.meatglow_fx = playviewmodelfx(localclientnum, level._effect["meat_glow3p"], tagname);
		}
	}
	else
	{
		if (isdefined(level.meatglow_fx))
		{
			deletefx(localclientnum, level.meatglow_fx);
			level.meatglow_fx = undefined;
		}
	}
}