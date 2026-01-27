#include maps\mp\zombies\_zm_turned;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\_visionset_mgr;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\gametypes_zm\_spawnlogic;

init()
{
	precacheitem("zombiemelee_zm");
	precacheitem("zombiemelee_dw");

	precachemodel("c_zom_player_zombie_fb");
	precachemodel("c_zom_zombie_viewhands");

	precachemodel("c_zom_zombie_buried_sgirl_player_fb");
	precachemodel("c_zom_buried_zombie_sgirl_viewhands");

	precachemodel("c_zom_tomb_german_player_fb");

	if (!isdefined(level.vsmgr_prio_visionset_zombie_turned))
	{
		level.vsmgr_prio_visionset_zombie_turned = 123;
	}

	maps\mp\_visionset_mgr::vsmgr_register_info("visionset", "zm_turned", 3000, level.vsmgr_prio_visionset_zombie_turned, 1, 1);
	registerclientfield("toplayer", "turned_ir", 3000, 1, "int");
	registerclientfield("allplayers", "player_has_eyes", 3000, 1, "int");
	registerclientfield("allplayers", "player_eyes_special", 5000, 1, "int");
	level._effect["player_eye_glow"] = loadfx("maps/zombie/fx_zombie_eye_returned_blue");
	level._effect["player_eye_glow_orng"] = loadfx("maps/zombie/fx_zombie_eye_returned_orng");
	setdvar("aim_target_player_enabled", 1);
	thread setup_zombie_exerts();
}

turn_to_zombie()
{
	self notify("clear_red_flashing_overlay");
	self notify("zombified");

	maps\mp\_visionset_mgr::vsmgr_activate("visionset", "zm_turned", self);
	self setclientfield("player_has_eyes", 1);
	self setclientfieldtoplayer("turned_ir", 1);
	self maps\mp\zombies\_zm_audio::setexertvoice(1);

	self setperk("specialty_noname");
	self setperk("specialty_unlimitedsprint");
	self setperk("specialty_fallheight");

	self turned_disable_player_weapons();
	self turned_give_melee_weapon();
	self increment_is_drinking();

	self.is_zombie = 1;
	self.animname = "zombie";
	self.maxhealth = level.zombie_vars["zombie_health_start"];
	self.health = self.maxhealth;
	self.meleedamage = 50;
	self.laststand = undefined;
	self.shock_onpain = 0;
	self.score = 0;
	self.ignoreme = 1;

	self allowstand(1);
	self allowprone(0);
	self allowcrouch(0);
	self allowads(0);
	self setburn(0);
	self stopshellshock();
	self detachall();

	if (level.script == "zm_prison" || level.script == "zm_tomb")
	{
		self setmodel("c_zom_tomb_german_player_fb");
		self.voice = "american";
		self.skeleton = "base";
		self setviewmodel("c_zom_zombie_viewhands");
	}
	else if (level.script == "zm_buried")
	{
		self setmodel("c_zom_zombie_buried_sgirl_player_fb");
		self.voice = "american";
		self.skeleton = "base";
		self setviewmodel("c_zom_buried_zombie_sgirl_viewhands");
	}
	else
	{
		self setmodel("c_zom_player_zombie_fb");
		self.voice = "american";
		self.skeleton = "base";
		self setviewmodel("c_zom_zombie_viewhands");
	}

	self thread turned_player_buttons();
}

turned_disable_player_weapons()
{
	self takeallweapons();
	self disableweaponcycling();
	self disableoffhandweapons();
}

turned_give_melee_weapon()
{
	self giveweapon("zombiemelee_zm");
	self givemaxammo("zombiemelee_zm");
	self switchtoweapon("zombiemelee_zm");
}