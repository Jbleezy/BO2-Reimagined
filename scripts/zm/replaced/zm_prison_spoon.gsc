#include maps\mp\zm_prison_spoon;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_audio;

give_player_spoon_upon_receipt(m_tomahawk, m_player_spoon)
{
	while (isdefined(m_tomahawk))
		wait 0.05;

	m_player_spoon delete();

	if (!self hasweapon("spoon_zm_alcatraz") && !self hasweapon("spork_zm_alcatraz") && !(isdefined(self.spoon_in_tub) && self.spoon_in_tub))
	{
		current_weapon = self getcurrentweapon();

		self giveweapon("spoon_zm_alcatraz");
		self set_player_melee_weapon("spoon_zm_alcatraz");
		self giveweapon("held_spoon_zm_alcatraz");
		self setactionslot(2, "weapon", "held_spoon_zm_alcatraz");

		if (is_melee_weapon(current_weapon))
		{
			self switchtoweapon("held_spoon_zm_alcatraz");
		}

		level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent("spoon", self);
		weapons = self getweaponslist();

		for (i = 0; i < weapons.size; i++)
		{
			if (issubstr(weapons[i], "knife"))
				self takeweapon(weapons[i]);
		}
	}

	weapons = self getweaponslist();
	wait 1.0;
	self thread do_player_general_vox("quest", "pick_up_easter_egg");
}

dip_the_spoon()
{
	self endon("disconnect");
	wait_for_bucket_activated(self);

	current_weapon = self getcurrentweapon();

	self takeweapon("spoon_zm_alcatraz");
	self takeweapon("held_spoon_zm_alcatraz");
	self giveweapon("knife_zm_alcatraz");
	self set_player_melee_weapon("knife_zm_alcatraz");
	self giveweapon("held_knife_zm_alcatraz");
	self setactionslot(2, "weapon", "held_knife_zm_alcatraz");

	if (is_melee_weapon(current_weapon))
	{
		self switchtoweapon("held_knife_zm_alcatraz");
	}

	self.spoon_in_tub = 1;
	self setclientfieldtoplayer("spoon_visual_state", 1);
	wait 5;
	level.b_spoon_in_tub = 1;
	flag_wait("charged_spoon");
	wait 1.0;
	level.t_bathtub playsound("zmb_easteregg_laugh");
	self thread thrust_the_spork();
}

thrust_the_spork()
{
	self endon("disconnect");
	wait_for_bucket_activated(self);
	self setclientfieldtoplayer("spoon_visual_state", 2);
	wait 5;
	wait_for_bucket_activated(self);

	current_weapon = self getcurrentweapon();

	self takeweapon("knife_zm_alcatraz");
	self takeweapon("held_knife_zm_alcatraz");
	self giveweapon("spork_zm_alcatraz");
	self set_player_melee_weapon("spork_zm_alcatraz");
	self giveweapon("held_spork_zm_alcatraz");
	self setactionslot(2, "weapon", "held_spork_zm_alcatraz");

	if (is_melee_weapon(current_weapon))
	{
		self switchtoweapon("held_spork_zm_alcatraz");
	}

	level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent("spork", self);
	self.spoon_in_tub = undefined;
	self setclientfieldtoplayer("spoon_visual_state", 3);
	wait 1.0;
	self thread do_player_general_vox("quest", "pick_up_easter_egg");
}