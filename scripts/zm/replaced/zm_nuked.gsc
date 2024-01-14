#include maps\mp\zm_nuked;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_nuked_gamemodes;
#include maps\mp\zm_nuked_ffotd;
#include maps\mp\zm_nuked_fx;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_load;
#include maps\mp\teams\_teamset_cdc;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zm_nuked_perks;
#include maps\mp\_sticky_grenade;
#include maps\mp\zombies\_zm_weap_tazer_knuckles;
#include maps\mp\zombies\_zm_weap_bowie;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\animscripts\zm_run;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\_compass;

give_team_characters()
{
	if (isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_suit_viewhands"))
		return;

	self detachall();
	self set_player_is_female(0);

	if (isdefined(level.should_use_cia))
	{
		if (level.should_use_cia)
		{
			self setmodel("c_zom_player_cia_fb");
			self setviewmodel("c_zom_suit_viewhands");
			self.characterindex = 0;
		}
		else
		{
			self setmodel("c_zom_player_cdc_fb");
			self setviewmodel("c_zom_hazmat_viewhands_light");
			self.characterindex = 1;
		}
	}
	else
	{
		if (!isdefined(self.characterindex))
		{
			self.characterindex = 1;

			if (self.team == "axis")
				self.characterindex = 0;
		}

		switch (self.characterindex)
		{
			case 0:
			case 2:
				self setmodel("c_zom_player_cia_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_suit_viewhands");
				self.characterindex = 0;
				break;

			case 1:
			case 3:
				self setmodel("c_zom_player_cdc_fb");
				self.voice = "american";
				self.skeleton = "base";
				self setviewmodel("c_zom_hazmat_viewhands_light");
				self.characterindex = 1;
				break;
		}
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}