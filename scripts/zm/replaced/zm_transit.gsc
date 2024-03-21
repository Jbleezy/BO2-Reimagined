#include maps\mp\zm_transit;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zm_transit_gamemodes;
#include maps\mp\zombies\_zm_banking;
#include maps\mp\zm_transit_ffotd;
#include maps\mp\zm_transit_bus;
#include maps\mp\zm_transit_automaton;
#include maps\mp\zombies\_zm_equip_turbine;
#include maps\mp\zm_transit_fx;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\teams\_teamset_cdc;
#include maps\mp\_sticky_grenade;
#include maps\mp\zombies\_load;
#include maps\mp\zm_transit_ai_screecher;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zm_transit_lava;
#include maps\mp\zm_transit_power;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_riotshield;
#include maps\mp\zombies\_zm_weap_jetgun;
#include maps\mp\zombies\_zm_weap_emp_bomb;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weap_tazer_knuckles;
#include maps\mp\zombies\_zm_weap_bowie;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\_visionset_mgr;
#include maps\mp\zm_transit_achievement;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zm_transit_openings;
#include character\c_transit_player_farmgirl;
#include character\c_transit_player_oldman;
#include character\c_transit_player_engineer;
#include character\c_transit_player_reporter;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_power;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zm_transit_cling;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zm_transit_sq;
#include maps\mp\zm_transit_distance_tracking;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_tombstone;

include_weapons()
{
	gametype = getdvar(#"ui_gametype");
	include_weapon("knife_zm", 0);
	include_weapon("frag_grenade_zm", 0);
	include_weapon("claymore_zm", 0);
	include_weapon("sticky_grenade_zm", 0);
	include_weapon("m1911_zm", 0);
	include_weapon("m1911_upgraded_zm", 0);
	include_weapon("python_zm");
	include_weapon("python_upgraded_zm", 0);
	include_weapon("judge_zm");
	include_weapon("judge_upgraded_zm", 0);
	include_weapon("kard_zm");
	include_weapon("kard_upgraded_zm", 0);
	include_weapon("fiveseven_zm");
	include_weapon("fiveseven_upgraded_zm", 0);
	include_weapon("beretta93r_zm", 0);
	include_weapon("beretta93r_upgraded_zm", 0);
	include_weapon("fivesevendw_zm");
	include_weapon("fivesevendw_upgraded_zm", 0);
	include_weapon("ak74u_zm", 0);
	include_weapon("ak74u_upgraded_zm", 0);
	include_weapon("mp5k_zm", 0);
	include_weapon("mp5k_upgraded_zm", 0);
	include_weapon("qcw05_zm");
	include_weapon("qcw05_upgraded_zm", 0);
	include_weapon("870mcs_zm", 0);
	include_weapon("870mcs_upgraded_zm", 0);
	include_weapon("rottweil72_zm", 0);
	include_weapon("rottweil72_upgraded_zm", 0);
	include_weapon("saiga12_zm");
	include_weapon("saiga12_upgraded_zm", 0);
	include_weapon("srm1216_zm");
	include_weapon("srm1216_upgraded_zm", 0);
	include_weapon("m14_zm", 0);
	include_weapon("m14_upgraded_zm", 0);
	include_weapon("saritch_zm");
	include_weapon("saritch_upgraded_zm", 0);
	include_weapon("m16_zm", 0);
	include_weapon("m16_gl_upgraded_zm", 0);
	include_weapon("xm8_zm");
	include_weapon("xm8_upgraded_zm", 0);
	include_weapon("type95_zm");
	include_weapon("type95_upgraded_zm", 0);
	include_weapon("tar21_zm");
	include_weapon("tar21_upgraded_zm", 0);
	include_weapon("galil_zm");
	include_weapon("galil_upgraded_zm", 0);
	include_weapon("fnfal_zm");
	include_weapon("fnfal_upgraded_zm", 0);
	include_weapon("dsr50_zm");
	include_weapon("dsr50_upgraded_zm", 0);
	include_weapon("barretm82_zm");
	include_weapon("barretm82_upgraded_zm", 0);
	include_weapon("rpd_zm");
	include_weapon("rpd_upgraded_zm", 0);
	include_weapon("hamr_zm");
	include_weapon("hamr_upgraded_zm", 0);
	include_weapon("usrpg_zm");
	include_weapon("usrpg_upgraded_zm", 0);
	include_weapon("m32_zm");
	include_weapon("m32_upgraded_zm", 0);
	include_weapon("cymbal_monkey_zm");
	include_weapon("emp_grenade_zm", 1, undefined, ::less_than_normal);

	if (is_classic())
		include_weapon("screecher_arms_zm", 0);

	if (gametype != "zgrief")
	{
		include_weapon("ray_gun_zm");
		include_weapon("ray_gun_upgraded_zm", 0);
		include_weapon("jetgun_zm", 0, undefined, ::less_than_normal);
		include_weapon("riotshield_zm", 0);
		include_weapon("tazer_knuckles_zm", 0);
		include_weapon("knife_ballistic_no_melee_zm", 0);
		include_weapon("knife_ballistic_no_melee_upgraded_zm", 0);
		include_weapon("knife_ballistic_zm");
		include_weapon("knife_ballistic_upgraded_zm", 0);
		include_weapon("knife_ballistic_bowie_zm", 0);
		include_weapon("knife_ballistic_bowie_upgraded_zm", 0);
		level._uses_retrievable_ballisitic_knives = 1;
		add_limited_weapon("knife_ballistic_zm", 1);
		add_limited_weapon("jetgun_zm", 1);
		add_limited_weapon("ray_gun_zm", 4);
		add_limited_weapon("ray_gun_upgraded_zm", 4);
		add_limited_weapon("knife_ballistic_upgraded_zm", 0);
		add_limited_weapon("knife_ballistic_no_melee_zm", 0);
		add_limited_weapon("knife_ballistic_no_melee_upgraded_zm", 0);
		add_limited_weapon("knife_ballistic_bowie_zm", 0);
		add_limited_weapon("knife_ballistic_bowie_upgraded_zm", 0);

		if (isdefined(level.raygun2_included) && level.raygun2_included)
		{
			include_weapon("raygun_mark2_zm");
			include_weapon("raygun_mark2_upgraded_zm", 0);
			add_weapon_to_content("raygun_mark2_zm", "dlc3");
			add_limited_weapon("raygun_mark2_zm", 1);
			add_limited_weapon("raygun_mark2_upgraded_zm", 1);
		}
	}

	add_limited_weapon("m1911_zm", 0);

	init_level_specific_wall_buy_fx();
}

init_level_specific_wall_buy_fx()
{
	level._effect["an94_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_an94");
}

lava_damage_depot()
{
	trigs = getentarray("lava_damage", "targetname");
	volume = getent("depot_lava_volume", "targetname");
	exploder(2);

	foreach (trigger in trigs)
	{
		if (isDefined(trigger.script_string) && trigger.script_string == "depot_lava")
		{
			trig = trigger;
		}
	}

	if (isDefined(trig))
	{
		trig.script_float = 0.05;
	}

	flag_wait("power_on");

	while (!volume maps\mp\zm_transit::depot_lava_seen())
	{
		wait 0.05;
	}

	if (isDefined(trig))
	{
		trig.script_float = 0.4;
		earthquake(0.5, 1.5, trig.origin, 1000);
		level clientnotify("earth_crack");
		crust = getent("depot_black_lava", "targetname");
		crust delete();
	}

	stop_exploder(2);
	exploder(3);
}

sndplaymusicegg(player, ent)
{
	song = sndplaymusicegg_get_song_for_origin(ent);
	time = sndplaymusicegg_get_time_for_song(song);

	level.music_override = 1;
	wait 1;
	ent playsound(song);
	level thread sndplaymusicegg_wait(time);
	level waittill_either("end_game", "sndSongDone");
	ent stopsounds();
	wait 0.05;
	ent delete();
	level.music_override = 0;
}

sndplaymusicegg_wait(time)
{
	level endon("end_game");
	wait time;
	level notify("sndSongDone");
}

sndplaymusicegg_get_song_for_origin(ent)
{
	if (ent.origin == (1864, -7, -19))
	{
		return "mus_zmb_secret_song";
	}
	else if (ent.origin == (7914, -6557, 269))
	{
		return "mus_zmb_secret_song_a7x_carry_on";
	}
	else if (ent.origin == (-7562, 4570, -19))
	{
		return "mus_zmb_secret_song_skrillex_try_it_out";
	}

	return "";
}

sndplaymusicegg_get_time_for_song(song)
{
	if (song == "mus_zmb_secret_song")
	{
		return 256;
	}
	else if (song == "mus_zmb_secret_song_a7x_carry_on")
	{
		return 254;
	}
	else if (song == "mus_zmb_secret_song_skrillex_try_it_out")
	{
		return 231;
	}

	return 0;
}