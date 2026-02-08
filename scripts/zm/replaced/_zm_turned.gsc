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
	self notify("fake_death");

	self setclientfieldtoplayer("turned_ir", 1);
	maps\mp\_visionset_mgr::vsmgr_activate("visionset", "zm_turned", self);
	self maps\mp\zombies\_zm_audio::setexertvoice(1);

	self setperk("specialty_noname");
	self setperk("specialty_unlimitedsprint");
	self setperk("specialty_fallheight");
	self setperk("specialty_fasttoss");

	self turned_disable_player_weapons();
	self turned_give_melee_weapon();
	self turned_give_tactical_insertion();

	self.is_zombie = 1;
	self.animname = "zombie";
	self.maxhealth = level.zombie_vars["zombie_health_start"];
	self.health = self.maxhealth;
	self.premaxhealth = self.maxhealth;
	self.meleedamage = 50;
	self.laststand = undefined;
	self.shock_onpain = 0;
	self.score = 0;
	self.ignoreme = 1;
	self.is_drinking = 1;

	self.a = spawnstruct();
	self.has_legs = 1;
	self.no_gib = 1;
	self.delayeddeath = 0;
	self.deathpoints_already_given = 0;

	if (!isdefined(self.n_move_scale))
	{
		self.n_move_scale = 1;
	}

	self.n_move_scale_modifiers = [];

	self allowstand(1);
	self allowcrouch(0);
	self allowprone(1);
	self allowjump(1);
	self allowads(0);
	self setstance("stand");
	self setmovespeedscale(self.n_move_scale);
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

	self thread delay_turning_on_eyes();
	self thread turned_player_buttons();
	self thread turned_melee_watcher();
	self thread turned_grenade_watcher();
	self thread turned_jump_watcher();

	self thread maps\mp\zombies\_zm_spawner::enemy_death_detection();
}

turned_disable_player_weapons()
{
	self takeallweapons();
	self disableweaponcycling();
}

turned_give_melee_weapon()
{
	self giveweapon("zombiemelee_zm");
	self givemaxammo("zombiemelee_zm");
	self switchtoweapon("zombiemelee_zm");
}

turned_give_tactical_insertion()
{
	if (!isdefined(self.tacticalinsertion))
	{
		self giveweapon("tactical_insertion_zm");
		self set_player_tactical_grenade("tactical_insertion_zm");
	}
}

delay_turning_on_eyes()
{
	self endon("disconnect");

	wait 0.05;

	if (level.script == "zm_nuked" || level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
	{
		self setclientfield("player_eyes_special", 1);
	}

	self setclientfield("player_has_eyes", 1);
}

turned_player_buttons()
{
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	while (isdefined(self.is_zombie) && self.is_zombie)
	{
		if (self attackbuttonpressed() || self adsbuttonpressed() || self meleebuttonpressed())
		{
			if (cointoss())
			{
				self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals("attack", undefined);
			}

			while (self attackbuttonpressed() || self adsbuttonpressed() || self meleebuttonpressed())
			{
				wait 0.05;
			}
		}

		if (self usebuttonpressed() || self isthrowinggrenade())
		{
			self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals("taunt", undefined);

			while (self usebuttonpressed() || self isthrowinggrenade())
			{
				wait 0.05;
			}
		}

		if (self issprinting())
		{
			while (self issprinting())
			{
				self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals("sprint", undefined);
				wait 0.05;
			}
		}

		wait 0.05;
	}
}

turned_melee_watcher()
{
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	while (isdefined(self.is_zombie) && self.is_zombie)
	{
		self waittill("weapon_melee", weapon);

		self thread turned_melee_disable_movement();
	}
}

turned_melee_disable_movement()
{
	self notify("turned_melee_disable_movement");
	self endon("turned_melee_disable_movement");
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	if (self is_jumping() && !isdefined(self.n_move_scale_modifiers["turned_melee"]))
	{
		self setvelocity((0, 0, 0));
	}

	if (self getstance() == "stand")
	{
		self allowstand(1);
		self allowprone(0);
	}
	else if (self getstance() == "prone")
	{
		self allowstand(0);
		self allowprone(1);
	}

	self allowjump(0);

	self.n_move_scale_modifiers["turned_melee"] = 0;

	self scripts\zm\_zm_reimagined::set_move_speed_scale(self.n_move_scale);

	wait 0.5;

	self allowstand(1);
	self allowprone(1);

	if (!self isthrowinggrenade())
	{
		self allowjump(1);
	}

	self.n_move_scale_modifiers["turned_melee"] = undefined;

	self scripts\zm\_zm_reimagined::set_move_speed_scale(self.n_move_scale);
}

turned_grenade_watcher()
{
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	while (isdefined(self.is_zombie) && self.is_zombie)
	{
		while (self isthrowinggrenade())
		{
			wait 0.05;
		}

		while (!self isthrowinggrenade())
		{
			wait 0.05;
		}

		self thread turned_grenade_disable_movement();
	}
}

turned_grenade_disable_movement()
{
	self notify("turned_grenade_disable_movement");
	self endon("turned_grenade_disable_movement");
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	if (self is_jumping() && !isdefined(self.n_move_scale_modifiers["turned_grenade"]))
	{
		self setvelocity((0, 0, 0));
	}

	self allowjump(0);

	self.n_move_scale_modifiers["turned_grenade"] = 0;

	self scripts\zm\_zm_reimagined::set_move_speed_scale(self.n_move_scale);

	while (self isthrowinggrenade())
	{
		wait 0.05;
	}

	self allowjump(1);

	self.n_move_scale_modifiers["turned_grenade"] = undefined;

	self scripts\zm\_zm_reimagined::set_move_speed_scale(self.n_move_scale);
}

turned_jump_watcher()
{
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	while (isdefined(self.is_zombie) && self.is_zombie)
	{
		disable_movement = 1;

		while (!self jumpbuttonpressed() || !self is_jumping())
		{
			wait 0.05;
		}

		while (self is_jumping())
		{
			if (self ismantling() || self isonladder())
			{
				disable_movement = 0;
			}

			wait 0.05;
		}

		if (disable_movement)
		{
			self thread turned_jump_disable_movement();
		}
	}
}

turned_jump_disable_movement()
{
	self notify("turned_jump_disable_movement");
	self endon("turned_jump_disable_movement");
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	self.n_move_scale_modifiers["turned_jump"] = 0.5;

	self scripts\zm\_zm_reimagined::set_move_speed_scale(self.n_move_scale);

	wait 0.5;

	self.n_move_scale_modifiers["turned_jump"] = undefined;

	self scripts\zm\_zm_reimagined::set_move_speed_scale(self.n_move_scale);
}