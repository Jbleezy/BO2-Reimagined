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
	self endon("disconnect");
	self endon("stop_one_inch_punch_attack");

	if (!(isdefined(self.one_inch_punch_flag_has_been_init) && self.one_inch_punch_flag_has_been_init))
		self ent_flag_init("melee_punch_cooldown");

	self.one_inch_punch_flag_has_been_init = 1;

	punch_weapon = "one_inch_punch_zm";
	flourish_weapon = "zombie_one_inch_punch_flourish";

	if (isdefined(self.b_punch_upgraded) && self.b_punch_upgraded)
	{
		punch_weapon = "one_inch_punch_" + self.str_punch_element + "_zm";
		flourish_weapon = "zombie_one_inch_punch_upgrade_flourish";
	}

	current_melee_weapon = self get_player_melee_weapon();
	str_weapon = self getcurrentweapon();
	self increment_is_drinking();
	self disable_player_move_states(1);
	self giveweapon(flourish_weapon);
	self switchtoweapon(flourish_weapon);

	result = self waittill_any_return("player_downed", "weapon_change");

	self takeweapon(current_melee_weapon);
	self takeweapon("held_" + current_melee_weapon);
	self giveweapon(punch_weapon);
	self set_player_melee_weapon(punch_weapon);
	self giveweapon("held_" + punch_weapon);

	if (!self hasweapon("equip_dieseldrone_zm"))
	{
		self setactionslot(2, "weapon", "held_" + punch_weapon);
	}

	if (result != "player_downed")
	{
		result = self waittill_any_return("player_downed", "weapon_change_complete");
	}

	if (result != "player_downed")
	{
		if (is_melee_weapon(str_weapon))
		{
			self switchtoweapon("held_" + punch_weapon);
		}
		else
		{
			self switchtoweapon(str_weapon);
		}
	}

	self takeweapon(flourish_weapon);
	self decrement_is_drinking();
	self enable_player_move_states();

	if (!isdefined(self.b_punch_upgraded) || !self.b_punch_upgraded)
	{
		self thread maps\mp\zombies\_zm_audio::create_and_play_dialog("perk", "one_inch");
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

		range_mod = 1.5;
		self setclientfield("oneinchpunch_impact", 1);
		wait_network_frame();
		self setclientfield("oneinchpunch_impact", 0);
		v_punch_effect_fwd = anglestoforward(self getplayerangles());
		v_punch_yaw = get2dyaw((0, 0, 0), v_punch_effect_fwd);

		range_dist = getDvarInt("player_meleeRange") * range_mod;
		a_zombies = getaispeciesarray(level.zombie_team, "all");
		a_zombies = get_array_of_closest(self.origin, a_zombies, undefined, undefined, range_dist);

		foreach (zombie in a_zombies)
		{
			if (self is_player_facing(zombie, v_punch_yaw))
			{
				self thread zombie_punch_damage(zombie, 1);
				continue;
			}
		}

		while (self ismeleeing())
			wait 0.05;

		wait 0.05;
	}
}

zombie_punch_damage(ai_zombie, n_mod)
{
	self endon("disconnect");
	ai_zombie.punch_handle_pain_notetracks = ::handle_punch_pain_notetracks;

	if (isdefined(n_mod))
	{
		if (isdefined(self.b_punch_upgraded) && self.b_punch_upgraded)
			n_base_damage = 11275;
		else
			n_base_damage = 2250;

		n_damage = int(n_base_damage * n_mod);

		if (self maps\mp\zombies\_zm_powerups::is_insta_kill_active())
		{
			if (n_damage < ai_zombie.health)
			{
				n_damage = ai_zombie.health;
			}
		}

		if (!(isdefined(ai_zombie.is_mechz) && ai_zombie.is_mechz))
		{
			if (n_damage >= ai_zombie.health)
			{
				self thread zombie_punch_death(ai_zombie);
				self do_player_general_vox("kill", "one_inch_punch");

				if (isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element))
				{
					switch (self.str_punch_element)
					{
						case "fire":
							ai_zombie thread maps\mp\zombies\_zm_weap_staff_fire::flame_damage_fx(self.current_melee_weapon, self, n_mod);
							break;

						case "ice":
							ai_zombie thread maps\mp\zombies\_zm_weap_staff_water::ice_affect_zombie(self.current_melee_weapon, self, 0, n_mod);
							break;

						case "lightning":
							if (isdefined(ai_zombie.is_mechz) && ai_zombie.is_mechz)
								return;

							if (isdefined(ai_zombie.is_electrocuted) && ai_zombie.is_electrocuted)
								return;

							tag = "J_SpineUpper";
							network_safe_play_fx_on_tag("lightning_impact", 2, level._effect["lightning_impact"], ai_zombie, tag);
							ai_zombie thread maps\mp\zombies\_zm_audio::do_zombies_playvocals("electrocute", ai_zombie.animname);
							break;
					}
				}
			}
			else
			{
				if (isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element))
				{
					switch (self.str_punch_element)
					{
						case "fire":
							ai_zombie thread maps\mp\zombies\_zm_weap_staff_fire::flame_damage_fx(self.current_melee_weapon, self, n_mod);
							break;

						case "ice":
							ai_zombie thread maps\mp\zombies\_zm_weap_staff_water::ice_affect_zombie(self.current_melee_weapon, self, 0, n_mod);
							break;

						case "lightning":
							ai_zombie thread maps\mp\zombies\_zm_weap_staff_lightning::stun_zombie();
							break;

						case "air":
							ai_zombie thread air_knockdown_zombie(self);
							break;
					}
				}
			}
		}

		ai_zombie dodamage(n_damage, ai_zombie.origin, self, self, 0, "MOD_MELEE", 0, self.current_melee_weapon);
	}
}

air_knockdown_zombie(player)
{
	self endon("death");
	player endon("disconnect");

	waittillframeend;

	self.v_punched_from = player.origin;
	self animcustom(maps\mp\zombies\_zm_weap_one_inch_punch::knockdown_zombie_animate);
}

is_player_facing(zombie, v_punch_yaw)
{
	v_player_to_zombie_yaw = get2dyaw(self.origin, zombie.origin);
	yaw_diff = v_player_to_zombie_yaw - v_punch_yaw;

	if (yaw_diff < 0)
		yaw_diff = yaw_diff * -1;

	yaw_amount = 35;

	if (yaw_diff < yaw_amount || yaw_diff > (360 - yaw_amount))
		return true;
	else
		return false;
}