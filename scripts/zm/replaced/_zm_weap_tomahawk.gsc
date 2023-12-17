#include maps\mp\zombies\_zm_weap_tomahawk;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;

calculate_tomahawk_damage(n_target_zombie, n_tomahawk_power, tomahawk)
{
	if (self.current_tomahawk_weapon == "upgraded_tomahawk_zm")
	{
		return n_target_zombie.health + 1;
	}
	else
	{
		return 2000;
	}
}

get_grenade_charge_power(player)
{
	player endon("disconnect");

	if (self.n_cookedtime >= 1000 && self.n_cookedtime < 2000)
	{
		return 3;
	}
	else if (self.n_cookedtime >= 2000 && self.n_cookedtime < 3000)
	{
		return 6;
	}
	else if (self.n_cookedtime >= 3000)
	{
		if (player.current_tomahawk_weapon != "upgraded_tomahawk_zm")
		{
			return 6;
		}
		else
		{
			return 9;
		}
	}

	return 1;
}

tomahawk_attack_zombies(m_tomahawk, a_zombies)
{
	self endon("disconnect");

	if (!isdefined(a_zombies))
	{
		self thread tomahawk_return_player(m_tomahawk, 0);
		return;
	}

	n_attack_limit = m_tomahawk.n_grenade_charge_power - 1;

	if (a_zombies.size <= n_attack_limit)
		n_attack_limit = a_zombies.size;

	for (i = 0; i < n_attack_limit; i++)
	{
		if (isdefined(a_zombies[i]) && isalive(a_zombies[i]))
		{
			tag = "J_Head";

			if (a_zombies[i].isdog)
				tag = "J_Spine1";

			if (isdefined(a_zombies[i].hit_by_tomahawk) && !a_zombies[i].hit_by_tomahawk)
			{
				v_target = a_zombies[i] gettagorigin(tag);
				m_tomahawk moveto(v_target, 0.3);

				m_tomahawk waittill("movedone");

				if (isdefined(a_zombies[i]) && isalive(a_zombies[i]))
				{
					if (self.current_tactical_grenade == "upgraded_tomahawk_zm")
						playfxontag(level._effect["tomahawk_impact_ug"], a_zombies[i], tag);
					else
						playfxontag(level._effect["tomahawk_impact"], a_zombies[i], tag);

					playfxontag(level._effect["tomahawk_fire_dot"], a_zombies[i], "j_spineupper");
					a_zombies[i] setclientfield("play_tomahawk_hit_sound", 1);
					n_tomahawk_damage = calculate_tomahawk_damage(a_zombies[i], m_tomahawk.n_grenade_charge_power, m_tomahawk);
					a_zombies[i] dodamage(n_tomahawk_damage, m_tomahawk.origin, self, m_tomahawk, "none", "MOD_GRENADE", 0, "bouncing_tomahawk_zm");
					a_zombies[i].hit_by_tomahawk = 1;
					self maps\mp\zombies\_zm_score::add_to_player_score(10);
				}
			}
		}

		wait 0.2;
	}

	self thread tomahawk_return_player(m_tomahawk, n_attack_limit);
}

tomahawk_return_player(m_tomahawk, num_zombie_hit = 5)
{
	self endon("disconnect");
	n_dist = distance2dsquared(m_tomahawk.origin, self.origin);
	n_attack_limit = m_tomahawk.n_grenade_charge_power - 1;

	while (n_dist > 4096)
	{
		m_tomahawk moveto(self geteye(), 0.25);

		if (num_zombie_hit < n_attack_limit)
		{
			self tomahawk_check_for_zombie(m_tomahawk);
			num_zombie_hit++;
		}

		wait 0.1;
		n_dist = distance2dsquared(m_tomahawk.origin, self geteye());
	}

	if (isdefined(m_tomahawk.a_has_powerup))
	{
		foreach (powerup in m_tomahawk.a_has_powerup)
		{
			if (isdefined(powerup))
				powerup.origin = self.origin;
		}
	}

	m_tomahawk delete();
	self playsoundtoplayer("wpn_tomahawk_catch_plr", self);
	self playsound("wpn_tomahawk_catch_npc");
	wait 5;
	self playsoundtoplayer("wpn_tomahawk_cooldown_done", self);
	self givemaxammo(self.current_tomahawk_weapon);
	a_zombies = getaispeciesarray("axis", "all");

	foreach (ai_zombie in a_zombies)
		ai_zombie.hit_by_tomahawk = 0;

	self setclientfieldtoplayer("tomahawk_in_use", 3);
}