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

staff_lightning_position_source(v_detonate, v_angles, str_weapon)
{
	self endon("disconnect");
	level notify("lightning_ball_created");

	if (!isdefined(v_angles))
	{
		v_angles = (0, 0, 0);
	}

	e_ball_fx = spawn("script_model", v_detonate + anglestoforward(v_angles) * 100.0);
	e_ball_fx.angles = v_angles;
	e_ball_fx.str_weapon = str_weapon;
	e_ball_fx setmodel("tag_origin");
	e_ball_fx.n_range = get_lightning_blast_range(self.chargeshotlevel);
	e_ball_fx.n_damage_per_sec = get_lightning_ball_damage_per_sec(self.chargeshotlevel);
	e_ball_fx setclientfield("lightning_miss_fx", 1);
	n_shot_range = staff_lightning_get_shot_range(self.chargeshotlevel);
	v_end = e_ball_fx.origin + anglestoforward(v_angles) * n_shot_range;
	trace = bullettrace(e_ball_fx.origin, v_end, 0, undefined);

	if (trace["fraction"] != 1)
	{
		v_end = trace["position"];
	}

	n_max_movetime_s = self.chargeshotlevel * 3.0;
	staff_lightning_ball_speed = n_shot_range / n_max_movetime_s;
	n_dist = distance(e_ball_fx.origin, v_end);
	n_movetime_s = n_dist / staff_lightning_ball_speed;
	n_leftover_time = n_max_movetime_s - n_movetime_s;

	if (n_leftover_time < 0)
	{
		n_leftover_time = 0;
	}

	e_ball_fx thread staff_lightning_ball_kill_zombies(self);
	e_ball_fx moveto(v_end, n_movetime_s);
	finished_playing = e_ball_fx lightning_ball_wait(n_leftover_time);
	e_ball_fx notify("stop_killing");
	e_ball_fx notify("stop_debug_position");

	playfx(level._effect["elec_ug_impact"], e_ball_fx.origin);

	if (isdefined(e_ball_fx))
	{
		e_ball_fx delete();
	}
}

staff_lightning_get_shot_range(n_charge)
{
	switch (n_charge)
	{
		case 3:
			return 1350;

		default:
			return 900;
	}
}

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
	str_weapon = e_source.str_weapon;
	n_range_sq = e_source.n_range * e_source.n_range;
	e_target.is_being_zapped = 1;
	e_target setclientfield("lightning_arc_fx", 1);
	level thread staff_lightning_arc_fx_cleanup(e_source, e_target, e_attacker);
	wait 0.5;

	if (isdefined(e_source))
	{
		if (!isdefined(e_source.n_damage_per_sec))
		{
			e_source.n_damage_per_sec = get_lightning_ball_damage_per_sec(e_attacker.chargeshotlevel);
		}

		n_damage_per_pulse = e_source.n_damage_per_sec * 1.0;
	}

	e_target thread stun_zombie();

	wait 1.0;

	if (isalive(e_target))
	{
		e_target thread zombie_shock_eyes();
		e_target thread staff_lightning_kill_zombie(e_attacker, str_weapon);
	}

	if (isdefined(e_target) && is_true(e_target.is_being_zapped))
	{
		e_target.is_being_zapped = 0;
		e_target setclientfield("lightning_arc_fx", 0);
	}
}

staff_lightning_arc_fx_cleanup(e_source, e_target, e_attacker)
{
	e_attacker endon("disconnect");
	e_target endon("death");

	e_source waittill("stop_killing");

	if (isdefined(e_target) && is_true(e_target.is_being_zapped))
	{
		e_target.is_being_zapped = 0;
		e_target setclientfield("lightning_arc_fx", 0);
	}
}

staff_lightning_kill_zombie(player, str_weapon)
{
	player endon("disconnect");

	if (!isalive(self))
	{
		return;
	}

	if (is_true(self.has_legs))
	{
		if (!self hasanimstatefromasd("zm_death_tesla"))
		{
			return;
		}

		self.deathanim = "zm_death_tesla";
	}
	else
	{
		if (!self hasanimstatefromasd("zm_death_tesla_crawl"))
		{
			return;
		}

		self.deathanim = "zm_death_tesla_crawl";
	}

	if (is_true(self.is_traversing))
	{
		self.deathanim = undefined;
	}

	self do_damage_network_safe(player, self.health, str_weapon, "MOD_RIFLE_BULLET");
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