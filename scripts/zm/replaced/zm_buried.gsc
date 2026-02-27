#include maps\mp\zm_buried;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_banking;
#include maps\mp\zm_buried_sq;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zm_buried_distance_tracking;
#include maps\mp\zm_buried_fx;
#include maps\mp\zm_buried_ffotd;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_buried_amb;
#include maps\mp\zombies\_zm_ai_ghost;
#include maps\mp\zombies\_zm_ai_sloth;
#include maps\mp\zombies\_load;
#include maps\mp\teams\_teamset_cdc;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zm_buried_jail;
#include maps\mp\zombies\_zm_weap_bowie;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\zombies\_zm_weap_tazer_knuckles;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zm_buried_achievement;
#include maps\mp\zm_buried_maze;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_buried_classic;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_buildables;
#include character\c_transit_player_farmgirl;
#include character\c_transit_player_oldman;
#include character\c_transit_player_engineer;
#include character\c_buried_player_reporter_dam;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_equip_headchopper;

init_level_specific_wall_buy_fx()
{
	level._effect["an94_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_an94");
	level._effect["pdw57_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_pdw57");
	level._effect["svu_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_svuas");
	level._effect["lsat_zm_fx"] = loadfx("maps/zombie/fx_zmb_wall_buy_lsat");
	level._effect["tazer_knuckles_zm_fx"] = loadfx("maps/zombie/fx_zmb_buried_buy_taseknuck");
	level._effect["tazer_knuckles_zm_chalk_fx"] = loadfx("maps/zombie/fx_zmb_buried_dyn_taseknuck");
	level._effect["870mcs_zm_chalk_fx"] = loadfx("maps/zombie/fx_zmb_wall_dyn_870mcs");
	level._effect["vector_zm_chalk_fx"] = loadfx("maps/zombie/fx_zmb_wall_dyn_ak74u");
	level._effect["an94_zm_chalk_fx"] = loadfx("maps/zombie/fx_zmb_wall_dyn_an94");
	level._effect["pdw57_zm_chalk_fx"] = loadfx("maps/zombie/fx_zmb_wall_dyn_pdw57");
	level._effect["svu_zm_chalk_fx"] = loadfx("maps/zombie/fx_zmb_wall_dyn_svuas");
}

buried_zone_init()
{
	flag_init("always_on");
	flag_set("always_on");
	add_adjacent_zone("zone_tunnels_center", "zone_tunnels_north", "always_on");
	add_adjacent_zone("zone_tunnels_north", "zone_tunnels_north2", "tunnels2courthouse");
	add_adjacent_zone("zone_tunnels_south", "zone_tunnels_south2", "tunnel2saloon");
	add_adjacent_zone("zone_tunnels_south3", "zone_tunnels_south2", "always_on");
	add_adjacent_zone("zone_tunnels_center", "zone_tunnels_south", "always_on");
	add_adjacent_zone("zone_street_lightwest", "zone_general_store", "general_store_door1");
	add_adjacent_zone("zone_street_lighteast", "zone_general_store", "always_on");
	add_adjacent_zone("zone_street_darkwest", "zone_general_store", "general_store_door2");
	add_adjacent_zone("zone_street_lightwest", "zone_morgue_upstairs", "always_on");
	add_adjacent_zone("zone_street_fountain", "zone_mansion_lawn", "mansion_lawn_door1");
	add_adjacent_zone("zone_street_darkwest", "zone_gun_store", "gun_store_door1");
	add_adjacent_zone("zone_stables", "zone_street_lightwest", "always_on", 1);
	add_adjacent_zone("zone_street_darkwest", "zone_street_darkwest_nook", "darkwest_nook_door1");
	add_adjacent_zone("zone_street_darkwest", "zone_general_store", "general_store_door3");
	add_adjacent_zone("zone_street_darkwest_nook", "zone_stables", "stables_door2");
	add_adjacent_zone("zone_street_darkeast", "zone_underground_bar", "bar_door1");
	add_adjacent_zone("zone_street_darkeast", "zone_street_darkeast_nook", "always_on");
	add_adjacent_zone("zone_underground_courthouse2", "zone_underground_courthouse", "always_on");
	add_adjacent_zone("zone_street_lighteast", "zone_underground_courthouse", "courthouse_door1");
	add_adjacent_zone("zone_street_lightwest", "zone_underground_jail", "jail_door1");
	add_adjacent_zone("zone_street_lightwest", "zone_street_lightwest_alley", "jail_jugg");
	add_adjacent_zone("zone_underground_jail", "zone_underground_jail2", "always_on");
	add_adjacent_zone("zone_underground_jail2", "zone_street_lightwest", "always_on");
	add_adjacent_zone("zone_street_lighteast", "zone_candy_store", "candy_store_door1");
	add_adjacent_zone("zone_candy_store", "zone_candy_store_floor2", "always_on");
	add_adjacent_zone("zone_toy_store_floor2", "zone_candy_store_floor2", "always_on");
	add_adjacent_zone("zone_toy_store", "zone_candy_store", "always_on");
	add_adjacent_zone("zone_toy_store", "zone_toy_store_floor2", "always_on");
	add_adjacent_zone("zone_street_darkeast", "zone_toy_store_floor2", "always_on");
	add_adjacent_zone("zone_street_darkeast", "zone_toy_store", "candy_store_door2");
	add_adjacent_zone("zone_street_lighteast", "zone_candy_store_floor2", "candy2lighteast", 1);
	add_adjacent_zone("zone_street_darkeast", "zone_candy_store_floor2", "always_on", 1);
	add_adjacent_zone("zone_toy_store_tunnel", "zone_toy_store_floor2", "always_on", 1);
	add_adjacent_zone("zone_street_lighteast", "zone_street_fountain", "always_on");
	add_adjacent_zone("zone_street_fountain", "zone_church_graveyard", "always_on");
	add_adjacent_zone("zone_church_graveyard", "zone_church_main", "church_door1");
	add_adjacent_zone("zone_church_main", "zone_church_upstairs", "church_door1");
	add_adjacent_zone("zone_gun_store", "zone_tunnel_gun2stables", "gunshop2tunnel");
	add_adjacent_zone("zone_tunnel_gun2saloon", "zone_underground_bar", "always_on");
	add_adjacent_zone("zone_maze", "zone_mansion_backyard", "mansion_door1", 1);
	add_adjacent_zone("zone_maze", "zone_maze_staircase", "mansion_door1", 1);
	add_adjacent_zone("zone_stables", "zone_tunnel_gun2stables2", "always_on");
	add_adjacent_zone("zone_tunnel_gun2stables2", "zone_tunnel_gun2stables", "always_on");
}

give_team_characters()
{
	self detachall();
	self set_player_is_female(0);

	if (isdefined(level.should_use_cia))
	{
		if (level.should_use_cia)
		{
			self setmodel("c_zom_player_cia_dlc1_fb");
			self setviewmodel("c_zom_suit_viewhands");
			self.characterindex = 0;
		}
		else
		{
			self setmodel("c_zom_player_cdc_dlc1_fb");
			self setviewmodel("c_zom_hazmat_viewhands");
			self.characterindex = 1;
		}
	}
	else
	{
		if (!isdefined(self.characterindex))
		{
			self.characterindex = 1;

			if (self.team == "axis")
			{
				self.characterindex = 0;
			}
		}

		switch (self.characterindex)
		{
			case 0:
			case 2:
				self setmodel("c_zom_player_cia_dlc1_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_suit_viewhands");
				self.characterindex = 0;
				break;

			case 1:
			case 3:
				self setmodel("c_zom_player_cdc_dlc1_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_hazmat_viewhands");
				self.characterindex = 1;
				break;
		}
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}