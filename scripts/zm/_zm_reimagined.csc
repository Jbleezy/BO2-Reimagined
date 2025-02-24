#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\_explosive_bolt::fx_think, scripts\zm\replaced\_explosive_bolt::fx_think);
	replaceFunc(clientscripts\mp\_sticky_grenade::start_light_fx, scripts\zm\replaced\_sticky_grenade::start_light_fx);
	replaceFunc(clientscripts\mp\zombies\_zm::init_client_flag_callback_funcs, scripts\zm\replaced\_zm::init_client_flag_callback_funcs);
	replaceFunc(clientscripts\mp\zombies\_zm::init_wallbuy_fx, scripts\zm\replaced\_zm::init_wallbuy_fx);
	replaceFunc(clientscripts\mp\zombies\_zm::entityspawned, scripts\zm\replaced\_zm::entityspawned);
	replaceFunc(clientscripts\mp\zombies\_zm_audio::sndmeleeswipe, scripts\zm\replaced\_zm_audio::sndmeleeswipe);
	replaceFunc(clientscripts\mp\zombies\_zm_gump::watch_spectation_player, scripts\zm\replaced\_zm_gump::watch_spectation_player);
	replaceFunc(clientscripts\mp\zombies\_zm_gump::demo_monitor, scripts\zm\replaced\_zm_gump::demo_monitor);
	replaceFunc(clientscripts\mp\zombies\_zm_weapons::init, scripts\zm\replaced\_zm_weapons::init);
	replaceFunc(clientscripts\mp\zombies\_zm_perks::perks_register_clientfield, scripts\zm\replaced\_zm_perks::perks_register_clientfield);

	perk_changes();
	powerup_changes();
}

perk_changes()
{
	if (!is_gametype_active("zclassic"))
	{
		return;
	}

	if (getdvar("mapname") == "zm_highrise")
	{
		level.zombiemode_using_marathon_perk = 1;
	}

	if (getdvar("mapname") == "zm_transit" || getdvar("mapname") == "zm_highrise" || getdvar("mapname") == "zm_prison" || getdvar("mapname") == "zm_buried" || getdvar("mapname") == "zm_tomb")
	{
		level.zombiemode_using_divetonuke_perk = 1;
		clientscripts\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();

		level thread toggle_vending_divetonuke_power_on_think();
		level thread toggle_vending_divetonuke_power_off_think();
	}

	if (getdvar("mapname") == "zm_transit" || getdvar("mapname") == "zm_buried" || getdvar("mapname") == "zm_tomb")
	{
		level.zombiemode_using_deadshot_perk = 1;

		level thread toggle_vending_deadshot_power_on_think();
		level thread toggle_vending_deadshot_power_off_think();
	}

	if (getdvar("mapname") == "zm_transit" || getdvar("mapname") == "zm_prison")
	{
		level.zombiemode_using_additionalprimaryweapon_perk = 1;
	}

	if (getdvar("mapname") == "zm_buried")
	{
		level.zombiemode_using_tombstone_perk = 1;
	}

	if (getdvar("mapname") == "zm_transit")
	{
		level.zombiemode_using_chugabud_perk = 1;
		clientscripts\mp\zombies\_zm_perks::register_perk_init_thread("specialty_finalstand", ::init_chugabud);

		registerclientfield("actor", "clientfield_whos_who_clone_glow_shader", 5000, 1, "int", clientscripts\mp\zombies\_zm_perks::chugabud_whos_who_shader, 0);
		registerclientfield("toplayer", "clientfield_whos_who_audio", 5000, 1, "int", clientscripts\mp\zm_highrise_amb::whoswhoaudio, 0);
		registerclientfield("toplayer", "clientfield_whos_who_filter", 5000, 1, "int", clientscripts\mp\zm_highrise_amb::whoswhofilter, 0);
	}
}

init_chugabud()
{
	clientscripts\mp\_visionset_mgr::vsmgr_register_visionset_info("zm_whos_who", 5000, 1, "zm_whos_who", "zm_whos_who");
	level thread clientscripts\mp\zombies\_zm_perks::chugabud_setup_afterlife_filters();
}

powerup_changes()
{
	if (getDvar("mapname") == "zm_transit" || getDvar("mapname") == "zm_highrise")
	{
		include_powerup("fire_sale");
	}
}

toggle_vending_divetonuke_power_on_think()
{
	while (1)
	{
		level waittill("toggle_vending_divetonuke_power_on");

		ents = getentarray(0);

		foreach (ent in ents)
		{
			if (isdefined(ent.model) && ent.model == "p6_zm_al_vending_nuke_on")
			{
				ent mapshaderconstant(0, 1, "ScriptVector0");
				ent setshaderconstant(0, 1, 0, 0.5, 0, 0);
			}
		}
	}
}

toggle_vending_divetonuke_power_off_think()
{
	while (1)
	{
		level waittill("toggle_vending_divetonuke_power_off");

		ents = getentarray(0);

		foreach (ent in ents)
		{
			if (isdefined(ent.model) && ent.model == "p6_zm_al_vending_nuke_on")
			{
				ent mapshaderconstant(0, 1, "ScriptVector0");
				ent setshaderconstant(0, 1, 0, 0, 0, 0);
			}
		}
	}
}

toggle_vending_deadshot_power_on_think()
{
	while (1)
	{
		level waittill("toggle_vending_deadshot_power_on");

		ents = getentarray(0);

		foreach (ent in ents)
		{
			if (isdefined(ent.model) && ent.model == "p6_zm_al_vending_ads_on")
			{
				ent mapshaderconstant(0, 1, "ScriptVector0");
				ent setshaderconstant(0, 1, 0, 0.5, 0, 0);
			}
		}
	}
}

toggle_vending_deadshot_power_off_think()
{
	while (1)
	{
		level waittill("toggle_vending_deadshot_power_off");

		ents = getentarray(0);

		foreach (ent in ents)
		{
			if (isdefined(ent.model) && ent.model == "p6_zm_al_vending_ads_on")
			{
				ent mapshaderconstant(0, 1, "ScriptVector0");
				ent setshaderconstant(0, 1, 0, 0, 0, 0);
			}
		}
	}
}