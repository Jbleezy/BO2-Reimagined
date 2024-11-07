#include maps\mp\zombies\_zm_weap_staff_air;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\animscripts\shared;

staff_air_position_source(v_detonate, str_weapon)
{
	self endon("disconnect");

	if (!isdefined(v_detonate))
	{
		return;
	}

	if (flag("whirlwind_active"))
	{
		level notify("whirlwind_stopped");

		while (flag("whirlwind_active"))
		{
			wait_network_frame();
		}

		wait 0.3;
	}

	charge_level = 2;

	if (str_weapon == "staff_air_upgraded3_zm")
	{
		charge_level = 3;
	}

	flag_set("whirlwind_active");
	n_time = charge_level * 3.5;
	e_whirlwind = spawn("script_model", v_detonate + vectorscale((0, 0, 1), 100.0));
	e_whirlwind setmodel("tag_origin");
	e_whirlwind.angles = vectorscale((-1, 0, 0), 90.0);
	e_whirlwind thread puzzle_debug_position("X", vectorscale((1, 1, 0), 255.0));
	e_whirlwind moveto(groundpos_ignore_water_new(e_whirlwind.origin), 0.05);
	e_whirlwind waittill("movedone");
	e_whirlwind setclientfield("whirlwind_play_fx", 1);
	e_whirlwind thread whirlwind_rumble_nearby_players("whirlwind_active");
	e_whirlwind thread whirlwind_timeout(n_time);
	wait 0.5;
	e_whirlwind.player_owner = self;
	e_whirlwind thread whirlwind_seek_zombies(charge_level, str_weapon);
}

whirlwind_seek_zombies(n_level, str_weapon)
{
	level endon("whirlwind_stopped");
	self endon("death");
	self.b_found_zombies = 0;
	n_range = get_air_blast_range(n_level);

	while (true)
	{
		a_zombies = staff_air_zombie_range(self.origin, n_range);

		if (a_zombies.size)
		{
			self.b_found_zombies = 1;
			self thread whirlwind_kill_zombies(n_level, str_weapon);
			break;
		}

		wait 0.1;
	}
}

whirlwind_kill_zombies(n_level, str_weapon)
{
	level endon("whirlwind_stopped");
	self endon("death");
	n_range = get_air_blast_range(n_level);
	self.n_charge_level = n_level;

	while (true)
	{
		a_zombies = staff_air_zombie_range(self.origin, n_range);
		a_zombies = get_array_of_closest(self.origin, a_zombies);

		for (i = 0; i < a_zombies.size; i++)
		{
			if (!isdefined(a_zombies[i]))
			{
				continue;
			}

			if (a_zombies[i].ai_state != "find_flesh")
			{
				continue;
			}

			if (is_true(a_zombies[i]._whirlwind_attract_anim))
			{
				continue;
			}

			v_offset = (0, 0, 32);

			if (!bullet_trace_throttled(self.origin + v_offset, a_zombies[i].origin + v_offset, undefined))
			{
				continue;
			}

			if (!isdefined(a_zombies[i]) || !isalive(a_zombies[i]))
			{
				continue;
			}

			if (is_true(a_zombies[i].is_mechz))
			{
				a_zombies[i] do_damage_network_safe(self.player_owner, 3300, str_weapon, "MOD_IMPACT");
			}
			else
			{
				a_zombies[i] thread whirlwind_drag_zombie(self, str_weapon);
			}
		}

		wait_network_frame();
	}
}

staff_air_zombie_source(ai_zombie, str_weapon)
{
	self endon("disconnect");
	ai_zombie.staff_hit = 1;
	ai_zombie.is_source = 1;
	v_whirlwind_pos = ai_zombie.origin;
	self thread staff_air_position_source(v_whirlwind_pos, str_weapon);

	if (!isdefined(ai_zombie.is_mechz))
	{
		self thread source_zombie_death(ai_zombie, str_weapon);
	}
}

source_zombie_death(ai_zombie, str_weapon)
{
	self endon("disconnect");

	charge_level = 2;

	if (str_weapon == "staff_air_upgraded3_zm")
	{
		charge_level = 3;
	}

	n_range = get_air_blast_range(charge_level);
	tag = "J_SpineUpper";

	if (ai_zombie.isdog)
	{
		tag = "J_Spine1";
	}

	v_source = ai_zombie gettagorigin(tag);
	ai_zombie thread staff_air_fling_zombie(self);
	a_zombies = staff_air_zombie_range(v_source, n_range);

	if (!isdefined(a_zombies))
	{
		return;
	}

	self thread staff_air_proximity_kill(a_zombies);
}