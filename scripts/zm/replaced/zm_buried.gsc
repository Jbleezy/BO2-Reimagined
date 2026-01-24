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