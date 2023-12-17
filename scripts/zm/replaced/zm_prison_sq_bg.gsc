#include maps\mp\zm_prison_sq_bg;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_weap_tomahawk;

give_sq_bg_reward()
{
	s_reward_origin = getstruct("sq_bg_reward", "targetname");
	t_near = spawn("trigger_radius", s_reward_origin.origin, 0, 196, 64);

	while (true)
	{
		t_near waittill("trigger", ent);

		if (isplayer(ent))
		{
			t_near thread sq_bg_spawn_rumble();
			break;
		}

		wait 0.1;
	}

	str_reward_weapon = "blundergat_zm";
	str_loc = &"ZM_PRISON_SQ_BG";
	m_reward_model = spawn_weapon_model(str_reward_weapon, undefined, s_reward_origin.origin, s_reward_origin.angles + (0, 0, 90));
	m_reward_model moveto(m_reward_model.origin + vectorscale((0, 0, 1), 14.0), 5);
	level setclientfield("sq_bg_reward_portal", 1);
	self sethintstring(str_loc);

	while (true)
	{
		self waittill("trigger", player);

		current_weapon = player getcurrentweapon();

		if (is_player_valid(player) && !(player.is_drinking > 0) && !is_melee_weapon(current_weapon) && !is_placeable_mine(current_weapon) && !is_equipment(current_weapon) && level.revive_tool != current_weapon && "none" != current_weapon && !player hacker_active())
		{
			if (player hasweapon(str_reward_weapon))
			{
				continue;
			}
			else
			{
				self delete();
				level setclientfield("sq_bg_reward_portal", 0);
				wait_network_frame();
				m_reward_model delete();
				player take_old_weapon_and_give_reward(current_weapon, str_reward_weapon);
			}
		}
	}

	t_near delete();
}

take_old_weapon_and_give_reward(current_weapon, reward_weapon, weapon_limit_override = 0)
{
	if (weapon_limit_override == 1)
		self takeweapon(current_weapon);
	else
	{
		primaries = self getweaponslistprimaries();

		if (isdefined(primaries) && primaries.size >= get_player_weapon_limit(self))
			self takeweapon(current_weapon);
	}

	self giveweapon(reward_weapon);
	self givestartammo(reward_weapon);
	self switchtoweapon(reward_weapon);
	flag_set("warden_blundergat_obtained");
	self playsoundtoplayer("vox_brutus_easter_egg_872_0", self);
}