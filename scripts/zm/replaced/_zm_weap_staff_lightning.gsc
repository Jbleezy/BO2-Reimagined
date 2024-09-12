#include maps\mp\zombies\_zm_weap_staff_lightning;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\shared;

staff_lightning_ball_kill_zombies(e_attacker)
{
	self endon("death");
	self endon("stop_killing");

	while (true)
	{
		a_zombies = staff_lightning_get_valid_targets(e_attacker, self.origin);

		if (isdefined(a_zombies))
		{
			foreach (zombie in a_zombies)
			{
				if (staff_lightning_is_target_valid(zombie))
				{
					e_attacker thread staff_lightning_arc_fx(self, zombie);
					wait 0.2;
				}
			}
		}

		wait 0.05;
	}
}

staff_lightning_get_valid_targets(player, v_source)
{
	player endon("disconnect");
	a_enemies = [];
	a_zombies = getaiarray(level.zombie_team);
	a_zombies = get_array_of_closest(v_source, a_zombies, undefined, undefined, self.n_range);

	if (isdefined(a_zombies))
	{
		foreach (ai_zombie in a_zombies)
		{
			if (staff_lightning_is_target_valid(ai_zombie))
			{
				a_enemies[a_enemies.size] = ai_zombie;
			}
		}
	}

	return a_enemies;
}

staff_lightning_is_target_valid(ai_zombie)
{
	if (!isdefined(ai_zombie))
	{
		return false;
	}

	if (is_true(ai_zombie.is_being_zapped))
	{
		return false;
	}

	return true;
}

staff_lightning_arc_fx(e_source, ai_zombie)
{
	self endon("disconnect");

	if (!isdefined(ai_zombie))
	{
		return;
	}

	if (!bullet_trace_throttled(e_source.origin, ai_zombie.origin + vectorscale((0, 0, 1), 20.0), ai_zombie))
	{
		return;
	}

	if (isdefined(e_source) && isdefined(ai_zombie) && isalive(ai_zombie))
	{
		if (is_true(ai_zombie.is_mechz))
		{
			level thread staff_lightning_ball_damage_over_time_mechz(e_source, ai_zombie, self);
		}
		else
		{
			level thread staff_lightning_ball_damage_over_time(e_source, ai_zombie, self);
		}
	}
}

staff_lightning_ball_damage_over_time(e_source, e_target, e_attacker)
{
	e_attacker endon("disconnect");
	e_target setclientfield("lightning_impact_fx", 1);
	e_target thread maps\mp\zombies\_zm_audio::do_zombies_playvocals("electrocute", e_target.animname);
	n_range_sq = e_source.n_range * e_source.n_range;
	e_target.is_being_zapped = 1;
	e_target setclientfield("lightning_arc_fx", 1);
	wait 0.5;

	if (isdefined(e_source))
	{
		if (!isdefined(e_source.n_damage_per_sec))
		{
			e_source.n_damage_per_sec = get_lightning_ball_damage_per_sec(e_attacker.chargeshotlevel);
		}

		n_damage_per_pulse = e_source.n_damage_per_sec * 1.0;
	}

	while (isdefined(e_source) && isalive(e_target))
	{
		e_target thread stun_zombie();
		wait 1.0;

		if (!isdefined(e_source) || !isalive(e_target))
		{
			break;
		}

		n_dist_sq = distancesquared(e_source.origin, e_target.origin);

		if (n_dist_sq > n_range_sq)
		{
			break;
		}

		if (isalive(e_target) && isdefined(e_source))
		{
			e_target thread zombie_shock_eyes();
			e_target thread staff_lightning_kill_zombie(e_attacker, e_source.str_weapon);
			break;
		}
	}

	if (isdefined(e_target))
	{
		e_target.is_being_zapped = 0;
		e_target setclientfield("lightning_arc_fx", 0);
	}
}

staff_lightning_ball_damage_over_time_mechz(e_source, e_target, e_attacker)
{
	e_attacker endon("disconnect");
	n_range_sq = e_source.n_range * e_source.n_range;
	e_target.is_being_zapped = 1;
	wait 0.5;

	if (isdefined(e_source))
	{
		if (!isdefined(e_source.n_damage_per_sec))
		{
			e_source.n_damage_per_sec = get_lightning_ball_damage_per_sec(e_attacker.chargeshotlevel);
		}

		n_damage_per_pulse = e_source.n_damage_per_sec * 1.0;
	}

	while (isdefined(e_source) && isalive(e_target))
	{
		wait 1.0;

		if (!isdefined(e_source) || !isalive(e_target))
		{
			break;
		}

		n_dist_sq = distancesquared(e_source.origin, e_target.origin);

		if (n_dist_sq > n_range_sq)
		{
			break;
		}

		if (isalive(e_target) && isdefined(e_source))
		{
			e_target do_damage_network_safe(e_attacker, e_source.n_damage_per_sec, e_source.str_weapon, "MOD_RIFLE_BULLET");
			break;
		}
	}

	if (isdefined(e_target))
	{
		e_target.is_being_zapped = 0;
	}
}

get_lightning_ball_damage_per_sec(n_charge)
{
	return 2500;
}