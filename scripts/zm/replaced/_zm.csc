#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

init_wallbuy_fx()
{
	if (!is_false(level._uses_default_wallbuy_fx))
	{
		level._effect["870mcs_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_870mcs");
		level._effect["ak74u_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_ak74u");
		level._effect["beretta93r_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_berreta93r");
		level._effect["bowie_knife_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_bowie");
		level._effect["claymore_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_claymore");
		level._effect["saritch_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m14");
		level._effect["m16_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m16");
		level._effect["insas_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_mp5k");
		level._effect["ballista_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_olympia");
	}

	if (!is_false(level._uses_sticky_grenades))
	{
		if (!is_true(level.disable_fx_zmb_wall_buy_semtex))
			level._effect["sticky_grenade_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_semtex");
	}

	if (!is_false(level._uses_taser_knuckles))
		level._effect["tazer_knuckles_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_taseknuck");

	if (isdefined(level.buildable_wallbuy_weapons))
		level._effect["dynamic_wallbuy_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_question");
}