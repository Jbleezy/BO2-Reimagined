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

survival_init()
{
	level.force_team_characters = 1;
	level.should_use_cia = 0;

	if (randomint(100) >= 50)
	{
		level.should_use_cia = 1;
	}

	level.precachecustomcharacters = ::precache_team_characters;
	level.givecustomcharacters = ::give_team_characters;
	level.dog_spawn_func = ::dog_spawn_transit_logic;
	level thread maps\mp\zombies\_zm_banking::delete_bank_teller();
	flag_wait("start_zombie_round_logic");
	level.custom_intermission = ::transit_standard_intermission;

	if (isdefined(level.scr_zm_map_start_location) && level.scr_zm_map_start_location == "transit")
	{
		level thread lava_damage_depot();
	}
}

transit_zone_init()
{
	flag_init("always_on");
	flag_init("init_classic_adjacencies");
	flag_set("always_on");

	if (is_classic())
	{
		flag_set("init_classic_adjacencies");
		add_adjacent_zone("zone_trans_2", "zone_trans_2b", "init_classic_adjacencies");
		add_adjacent_zone("zone_station_ext", "zone_trans_2b", "init_classic_adjacencies", 1);
		add_adjacent_zone("zone_town_west2", "zone_town_west", "init_classic_adjacencies");
		add_adjacent_zone("zone_town_south", "zone_town_church", "init_classic_adjacencies");
		add_adjacent_zone("zone_trans_pow_ext1", "zone_trans_7", "init_classic_adjacencies");
		add_adjacent_zone("zone_far", "zone_far_ext", "OnFarm_enter");
	}
	else
	{
		playable_area = getentarray("player_volume", "script_noteworthy");

		foreach (area in playable_area)
		{
			add_adjacent_zone("zone_station_ext", "zone_trans_2b", "always_on");

			if (isdefined(area.script_parameters) && area.script_parameters == "classic_only")
			{
				area delete();
			}
		}
	}

	add_adjacent_zone("zone_pri2", "zone_station_ext", "OnPriDoorYar", 1);
	add_adjacent_zone("zone_pri2", "zone_pri", "OnPriDoorYar3", 1);

	if (getdvar("ui_zm_mapstartlocation") == "transit")
	{
		level thread disconnect_door_zones("zone_pri2", "zone_station_ext", "OnPriDoorYar");
		level thread disconnect_door_zones("zone_pri2", "zone_pri", "OnPriDoorYar3");
	}

	add_adjacent_zone("zone_station_ext", "zone_pri", "OnPriDoorYar2");
	add_adjacent_zone("zone_roadside_west", "zone_din", "OnGasDoorDin");
	add_adjacent_zone("zone_roadside_west", "zone_gas", "always_on");
	add_adjacent_zone("zone_roadside_east", "zone_gas", "always_on");
	add_adjacent_zone("zone_roadside_east", "zone_gar", "OnGasDoorGar");
	add_adjacent_zone("zone_trans_diner", "zone_roadside_west", "always_on", 1);
	add_adjacent_zone("zone_trans_diner", "zone_gas", "always_on", 1);
	add_adjacent_zone("zone_trans_diner2", "zone_roadside_east", "always_on", 1);
	add_adjacent_zone("zone_gas", "zone_din", "OnGasDoorDin");
	add_adjacent_zone("zone_gas", "zone_gar", "OnGasDoorGar");
	add_adjacent_zone("zone_diner_roof", "zone_din", "OnGasDoorDin", 1);
	add_adjacent_zone("zone_tow", "zone_bar", "always_on", 1);
	add_adjacent_zone("zone_bar", "zone_tow", "OnTowDoorBar", 1);
	add_adjacent_zone("zone_tow", "zone_ban", "OnTowDoorBan");
	add_adjacent_zone("zone_ban", "zone_ban_vault", "OnTowBanVault");
	add_adjacent_zone("zone_tow", "zone_town_north", "always_on");
	add_adjacent_zone("zone_town_north", "zone_ban", "OnTowDoorBan");
	add_adjacent_zone("zone_tow", "zone_town_west", "always_on");
	add_adjacent_zone("zone_tow", "zone_town_south", "always_on");
	add_adjacent_zone("zone_town_south", "zone_town_barber", "always_on", 1);
	add_adjacent_zone("zone_tow", "zone_town_east", "always_on");
	add_adjacent_zone("zone_town_east", "zone_bar", "OnTowDoorBar");
	add_adjacent_zone("zone_tow", "zone_town_barber", "always_on", 1);
	add_adjacent_zone("zone_town_barber", "zone_tow", "OnTowDoorBarber", 1);
	add_adjacent_zone("zone_town_barber", "zone_town_west", "OnTowDoorBarber");
	add_adjacent_zone("zone_far_ext", "zone_brn", "OnFarm_enter");
	add_adjacent_zone("zone_far_ext", "zone_farm_house", "open_farmhouse");
	add_adjacent_zone("zone_prr", "zone_pow", "OnPowDoorRR", 1);
	add_adjacent_zone("zone_pcr", "zone_prr", "OnPowDoorRR");
	add_adjacent_zone("zone_pcr", "zone_pow_warehouse", "OnPowDoorWH");
	add_adjacent_zone("zone_pow", "zone_pow_warehouse", "always_on");
	add_adjacent_zone("zone_tbu", "zone_tow", "vault_opened", 1);
	add_adjacent_zone("zone_trans_8", "zone_pow", "always_on", 1);
	add_adjacent_zone("zone_trans_8", "zone_pow_warehouse", "always_on", 1);

	zone_init("zone_amb_tunnel");
	enable_zone("zone_amb_tunnel");

	zone_init("zone_amb_cornfield");
	enable_zone("zone_amb_cornfield");

	zone_init("zone_cornfield_prototype");
	enable_zone("zone_cornfield_prototype");
}

include_weapons()
{
	gametype = getdvar("ui_gametype");
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
	{
		include_weapon("screecher_arms_zm", 0);
	}

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

	add_limited_weapon("m1911_zm", 0);

	init_level_specific_wall_buy_fx();
}

init_level_specific_wall_buy_fx()
{
	level._effect["an94_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_an94");
	level._effect["pdw57_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_pdw57");
	level._effect["svu_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_svuas");
}

include_powerups()
{
	include_powerup("nuke");
	include_powerup("insta_kill");
	include_powerup("double_points");
	include_powerup("full_ammo");
	include_powerup("insta_kill_ug");
	include_powerup("carpenter");
	include_powerup("teller_withdrawl");
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

safety_light_power_off(origin, radius)
{
	self.target.power_on = 0;
	self.target notify("power_off");

	if (isdefined(self.target.clientfieldname))
	{
		level setclientfield(self.target.clientfieldname, 0);
	}

	level notify("safety_light_power_off", self);

	self stop_portal();
}

stop_portal()
{
	self.target notify("portal_stopped");
	self.target.burrow_active = 0;

	if (isdefined(self.target.hole))
	{
		playsoundatposition("zmb_screecher_portal_end", self.target.hole.origin);
		self.target.hole delete();
	}

	if (isdefined(self.target.hole_fx))
	{
		self.target.hole_fx delete();
	}

	if (isinarray(level.portals, self.target))
	{
		arrayremovevalue(level.portals, self.target);
	}
}

grenade_safe_to_bounce(player, weapname)
{
	if (!is_offhand_weapon(weapname))
	{
		return 1;
	}

	if (self maps\mp\zm_transit_lava::object_touching_lava())
	{
		return 0;
	}

	return 1;
}

can_revive(player_down)
{
	if (self hasWeapon("screecher_arms_zm"))
	{
		return false;
	}

	return true;
}

insta_kill_player()
{
	self endon("disconnect");

	if (isdefined(self.insta_killed) && self.insta_killed)
	{
		return;
	}

	if (get_players().size == 1 && flag("solo_game") && (isdefined(self.waiting_to_revive) && self.waiting_to_revive))
	{
		return;
	}

	if (!is_player_killable(self))
	{
		return;
	}

	self.insta_killed = 1;

	self maps\mp\zombies\_zm_buildables::player_return_piece_to_original_spawn();

	self playlocalsound(level.zmb_laugh_alias);

	self disableinvulnerability();
	self.lives = 0;
	self dodamage(self.health + 1000, self.origin);
	self scripts\zm\_zm_reimagined::player_suicide();

	self.insta_killed = 0;
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