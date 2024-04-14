#include clientscripts\mp\_utility;
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_music;
#include clientscripts\mp\_audio;

sndmeleeswipe(localclientnum, notifystring)
{
	player = undefined;

	while (!isdefined(player))
	{
		player = getnonpredictedlocalplayer(localclientnum);
		wait 0.05;
	}

	player endon("disconnect");

	for (;;)
	{
		player waittill(notifystring);
		currentweapon = getcurrentweapon(localclientnum);

		alias = "zmb_melee_whoosh_plr";

		if (is_true(player.is_player_zombie))
		{
			alias = "zmb_melee_whoosh_zmb_plr";
		}
		else if (issubstr(currentweapon, "shield_zm"))
		{
			alias = "fly_riotshield_zm_swing";
		}
		else if (has_weapon_or_held(localclientnum, "bowie_knife_zm"))
		{
			alias = "zmb_bowie_swing_plr";
		}
		else if (has_weapon_or_held(localclientnum, "tazer_knuckles_zm"))
		{
			alias = "wpn_tazer_whoosh_plr";
		}
		else if (has_weapon_or_held(localclientnum, "spoon_zm_alcatraz"))
		{
			alias = "zmb_spoon_swing_plr";
		}
		else if (has_weapon_or_held(localclientnum, "spork_zm_alcatraz"))
		{
			alias = "zmb_spork_swing_plr";
		}
		else if (has_weapon_or_held(localclientnum, "one_inch_punch_zm"))
		{
			alias = "wpn_one_inch_punch_plr";
		}
		else if (has_weapon_or_held(localclientnum, "one_inch_punch_upgraded_zm"))
		{
			alias = "wpn_one_inch_punch_plr";
		}
		else if (has_weapon_or_held(localclientnum, "one_inch_punch_air_zm"))
		{
			alias = "wpn_one_inch_punch_air_plr";
		}
		else if (has_weapon_or_held(localclientnum, "one_inch_punch_fire_zm"))
		{
			alias = "wpn_one_inch_punch_fire_plr";
		}
		else if (has_weapon_or_held(localclientnum, "one_inch_punch_ice_zm"))
		{
			alias = "wpn_one_inch_punch_ice_plr";
		}
		else if (has_weapon_or_held(localclientnum, "one_inch_punch_lightning_zm"))
		{
			alias = "wpn_one_inch_punch_lightning_plr";
		}
		else if (has_staff_melee(localclientnum))
		{
			alias = "zmb_melee_staff_upgraded_plr";
		}

		playsound(0, alias, player.origin);
	}
}

has_weapon_or_held(localclientnum, weapon)
{
	return hasweapon(localclientnum, weapon) || hasweapon(localclientnum, "held_" + weapon);
}

has_staff_melee(localclientnum)
{
	if (hasweapon(localclientnum, "staff_melee_zm"))
	{
		return 1;
	}
	else if (hasweapon(localclientnum, "staff_air_melee_zm"))
	{
		return 1;
	}
	else if (hasweapon(localclientnum, "staff_fire_melee_zm"))
	{
		return 1;
	}
	else if (hasweapon(localclientnum, "staff_water_melee_zm"))
	{
		return 1;
	}
	else if (hasweapon(localclientnum, "staff_lightning_melee_zm"))
	{
		return 1;
	}

	return 0;
}