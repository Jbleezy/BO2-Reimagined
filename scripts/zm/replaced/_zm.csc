#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

init_client_flag_callback_funcs()
{
	level.disable_deadshot_clientfield = undefined;

	level._client_flag_callbacks = [];
	level._client_flag_callbacks["vehicle"] = [];
	level._client_flag_callbacks["player"] = [];
	level._client_flag_callbacks["actor"] = [];
	level._client_flag_callbacks["scriptmover"] = [];

	if (isdefined(level.use_clientside_board_fx) && level.use_clientside_board_fx)
	{
		register_clientflag_callback("scriptmover", level._zombie_scriptmover_flag_board_vertical_fx, ::handle_vertical_board_clientside_fx);
		register_clientflag_callback("scriptmover", level._zombie_scriptmover_flag_board_horizontal_fx, ::handle_horizontal_board_clientside_fx);
	}

	if (isdefined(level.use_clientside_rock_tearin_fx) && level.use_clientside_rock_tearin_fx)
	{
		register_clientflag_callback("scriptmover", level._zombie_scriptmover_flag_rock_fx, ::handle_rock_clientside_fx);
	}

	register_clientflag_callback("scriptmover", level._zombie_scriptmover_flag_box_random, clientscripts\mp\zombies\_zm_weapons::weapon_box_callback);

	if (!is_true(level.disable_deadshot_clientfield))
	{
		registerclientfield("toplayer", "deadshot_perk", 1, 1, "int", ::player_deadshot_perk_handler, 0, 1);
	}

	if (!is_true(level._no_navcards))
	{
		if (level.scr_zm_ui_gametype == "zclassic" && !level.createfx_enabled)
		{
			registerclientfield("allplayers", "navcard_held", 1, 4, "int", undefined, 0, 1);
			level thread set_clientfield_navcard_code_callback("navcard_held");
		}
	}

	if (!is_true(level._no_water_risers))
	{
		registerclientfield("actor", "zombie_riser_fx_water", 1, 1, "int", ::handle_zombie_risers_water, 1);
	}

	if (is_true(level._foliage_risers))
	{
		registerclientfield("actor", "zombie_riser_fx_foliage", 12000, 1, "int", ::handle_zombie_risers_foliage, 1);
	}

	registerclientfield("actor", "zombie_riser_fx", 1, 1, "int", ::handle_zombie_risers, 1);

	if (is_true(level.risers_use_low_gravity_fx))
	{
		registerclientfield("actor", "zombie_riser_fx_lowg", 1, 1, "int", ::handle_zombie_risers_lowg, 1);
	}
}

init_wallbuy_fx()
{
	if (getDvar("mapname") == "zm_buried" || getDvar("mapname") == "zm_prison")
	{
		level._uses_sticky_grenades = 1;
		level.disable_fx_zmb_wall_buy_semtex = 0;
	}

	if (!is_false(level._uses_default_wallbuy_fx))
	{
		level._effect["870mcs_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_870mcs");
		level._effect["vector_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_ak74u");
		level._effect["beretta93r_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_berreta93r");
		level._effect["bowie_knife_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_bowie");
		level._effect["claymore_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_claymore");
		level._effect["saritch_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m14");
		level._effect["sig556_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_m16");
		level._effect["insas_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_mp5k");
		level._effect["ballista_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_olympia");
	}

	if (!is_false(level._uses_sticky_grenades))
	{
		if (!is_true(level.disable_fx_zmb_wall_buy_semtex))
		{
			grenade = "sticky_grenade_zm";

			if (getDvar("mapname") == "zm_buried")
			{
				grenade = "frag_grenade_zm";
			}

			level._effect[grenade + "_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_semtex");
		}
	}

	if (!is_false(level._uses_taser_knuckles))
	{
		level._effect["tazer_knuckles_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_taseknuck");
	}

	if (isdefined(level.buildable_wallbuy_weapons))
	{
		level._effect["dynamic_wallbuy_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_question");
	}
}

entityspawned(localclientnum)
{
	if (!isdefined(self.type))
	{
		return;
	}

	if (self.type == "player")
	{
		self thread playerspawned(localclientnum);
	}

	if (self.type == "missile")
	{
		switch (self.weapon)
		{
			case "sticky_grenade_zm":
				self thread clientscripts\mp\_sticky_grenade::spawned(localclientnum);
				break;

			case "titus6_explosive_dart_zm":
			case "titus6_explosive_dart_upgraded_zm":
				self thread clientscripts\_explosive_dart::spawned(localclientnum);
				break;
		}
	}
}