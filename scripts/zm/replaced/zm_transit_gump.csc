#include clientscripts\mp\zm_transit_gump;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_gump;

init_transit_gump()
{
	level.uses_gumps = 1;

	waitforclient(0);
	waitforallclients();
	wait 0.05;

	players = getlocalplayers();
	startcolor = (0, 0, 0);

	for (i = 0; i < players.size; i++)
	{
		sethidegumpalpha(i, startcolor);
	}

	if (getdvar("ui_gametype") == "zclassic")
	{
		slots = players.size - 1;
		thread clientscripts\mp\zombies\_zm_gump::load_gump_for_player(0, "zm_transit_gump_prealloc_0");

		level waittill("gump_loaded");

		thread clientscripts\mp\zombies\_zm_gump::load_gump_for_player(1, "zm_transit_gump_tunnel");
		level waittill("gump_loaded");

		for (i = 0; i < slots; i++)
		{
			transit_gump_preallocate(i);
		}

		gump_trigs = getentarray(0, "gump_triggers", "targetname");

		foreach (index, gump_trig in gump_trigs)
		{
			if (isdefined(gump_trig.script_string) && gump_trig.script_string == "zm_transit_gump_tunnel")
			{
				arrayremoveindex(gump_trigs, index);
				break;
			}
		}

		if (isdefined(gump_trigs))
		{
			array_thread(gump_trigs, clientscripts\mp\zombies\_zm_gump::gump_watch_trigger, 0);
		}

		thread clientscripts\mp\zombies\_zm_gump::watch_spectation(gump_trigs);
	}
	else
	{
		start_location = getdvar("ui_zm_mapstartlocation");

		if (start_location == "transit")
		{
			start_location = "busstation";
		}

		if (start_location == "power")
		{
			start_location = "powerstation";
		}

		single_gump_name = "zm_transit_gump_" + start_location;
		clientscripts\mp\zombies\_zm_gump::load_gump_for_player(0, single_gump_name);
	}
}