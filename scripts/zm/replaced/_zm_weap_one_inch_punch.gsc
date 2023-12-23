#include maps\mp\zombies\_zm_weap_one_inch_punch;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_weap_staff_fire;
#include maps\mp\zombies\_zm_weap_staff_water;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_weap_staff_lightning;
#include maps\mp\animscripts\zm_shared;

one_inch_punch_melee_attack()
{
	self endon( "disconnect" );
	self endon( "stop_one_inch_punch_attack" );

	if ( !( isdefined( self.one_inch_punch_flag_has_been_init ) && self.one_inch_punch_flag_has_been_init ) )
		self ent_flag_init( "melee_punch_cooldown" );

	self.one_inch_punch_flag_has_been_init = 1;
	current_melee_weapon = self get_player_melee_weapon();
	self takeweapon( current_melee_weapon );

	if ( isdefined( self.b_punch_upgraded ) && self.b_punch_upgraded )
	{
		str_weapon = self getcurrentweapon();
		self disable_player_move_states( 1 );
		self giveweapon( "zombie_one_inch_punch_upgrade_flourish" );
		self switchtoweapon( "zombie_one_inch_punch_upgrade_flourish" );
		self waittill_any( "player_downed", "weapon_change_complete" );
		self switchtoweapon( str_weapon );
		self enable_player_move_states();
		self takeweapon( "zombie_one_inch_punch_upgrade_flourish" );

		if ( self.str_punch_element == "air" )
		{
			self giveweapon( "one_inch_punch_air_zm" );
			self set_player_melee_weapon( "one_inch_punch_air_zm" );
			self giveweapon( "held_one_inch_punch_air_zm" );
			self setactionslot( 2, "weapon", "one_inch_punch_air_zm" );
		}
		else if ( self.str_punch_element == "fire" )
		{
			self giveweapon( "one_inch_punch_fire_zm" );
			self set_player_melee_weapon( "one_inch_punch_fire_zm" );
			self giveweapon( "held_one_inch_punch_fire_zm" );
			self setactionslot( 2, "weapon", "held_one_inch_punch_fire_zm" );
		}
		else if ( self.str_punch_element == "ice" )
		{
			self giveweapon( "one_inch_punch_ice_zm" );
			self set_player_melee_weapon( "one_inch_punch_ice_zm" );
			self giveweapon( "held_one_inch_punch_ice_zm" );
			self setactionslot( 2, "weapon", "held_one_inch_punch_ice_zm" );
		}
		else if ( self.str_punch_element == "lightning" )
		{
			self giveweapon( "one_inch_punch_lightning_zm" );
			self set_player_melee_weapon( "one_inch_punch_lightning_zm" );
			self giveweapon( "held_inch_punch_lightning_zm" );
			self setactionslot( 2, "weapon", "held_inch_punch_lightning_zm" );
		}
		else
		{
			self giveweapon( "one_inch_punch_upgraded_zm" );
			self set_player_melee_weapon( "one_inch_punch_upgraded_zm" );
			self giveweapon( "held_one_inch_punch_upgraded_zm" );
			self setactionslot( 2, "weapon", "held_one_inch_punch_upgraded_zm" );
		}
	}
	else
	{
		str_weapon = self getcurrentweapon();
		self disable_player_move_states( 1 );
		self giveweapon( "zombie_one_inch_punch_flourish" );
		self switchtoweapon( "zombie_one_inch_punch_flourish" );
		self waittill_any( "player_downed", "weapon_change_complete" );
		self switchtoweapon( str_weapon );
		self enable_player_move_states();
		self takeweapon( "zombie_one_inch_punch_flourish" );
		self giveweapon( "one_inch_punch_zm" );
		self set_player_melee_weapon( "one_inch_punch_zm" );
		self giveweapon( "held_one_inch_punch_zm" );
		self setactionslot( 2, "weapon", "held_one_inch_punch_zm" );
		self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "perk", "one_inch" );
	}

	self thread monitor_melee_swipe();
}

monitor_melee_swipe()
{
	self endon("disconnect");
	self notify("stop_monitor_melee_swipe");
	self endon("stop_monitor_melee_swipe");
	self endon("bled_out");
	self endon("gr_head_forced_bleed_out");

	while (true)
	{
		while (!self ismeleeing())
			wait 0.05;

		if (self getcurrentweapon() == level.riotshield_name)
		{
			wait 0.1;
			continue;
		}

		range_mod = 1;
		self setclientfield("oneinchpunch_impact", 1);
		wait_network_frame();
		self setclientfield("oneinchpunch_impact", 0);
		v_punch_effect_fwd = anglestoforward(self getplayerangles());
		v_punch_yaw = get2dyaw((0, 0, 0), v_punch_effect_fwd);

		if (isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element) && self.str_punch_element == "air")
			range_mod *= 2;

		a_zombies = getaispeciesarray(level.zombie_team, "all");
		a_zombies = get_array_of_closest(self.origin, a_zombies, undefined, undefined, 100);

		foreach (zombie in a_zombies)
		{
			if (self is_player_facing(zombie, v_punch_yaw) && distancesquared(self.origin, zombie.origin) <= 4096 * range_mod)
			{
				self thread zombie_punch_damage(zombie, 1);
				continue;
			}

			if (self is_player_facing(zombie, v_punch_yaw))
				self thread zombie_punch_damage(zombie, 0.5);
		}

		while (self ismeleeing())
			wait 0.05;

		wait 0.05;
	}
}