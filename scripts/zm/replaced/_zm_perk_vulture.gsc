#include maps\mp\zombies\_zm_perk_vulture;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_ai_basic;

give_vulture_perk()
{
	vulture_debug_text("player " + self getentitynumber() + " has vulture perk!");

	if (!isdefined(self.perk_vulture))
	{
		self.perk_vulture = spawnstruct();
	}

	self.perk_vulture.active = 1;
	self vulture_vision_toggle(1);
	self vulture_clientfield_toplayer_set("vulture_perk_active");
	self thread _vulture_perk_think();
	self thread vulture_perk_ir_think();
}

take_vulture_perk()
{
	if (isdefined(self.perk_vulture) && (isdefined(self.perk_vulture.active) && self.perk_vulture.active))
	{
		vulture_debug_text("player " + self getentitynumber() + " has lost vulture perk!");
		self.perk_vulture.active = 0;

		if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			self.ignoreme = 0;
		}

		self vulture_vision_toggle(0);
		self vulture_clientfield_toplayer_clear("vulture_perk_active");
		self set_vulture_overlay(0);
		self.vulture_stink_value = 0;
		self setclientfieldtoplayer("vulture_perk_disease_meter", 0);
		self notify("vulture_perk_lost");
	}
}

vulture_perk_ir_think()
{
	self endon("disconnect");
	self endon("vulture_perk_lost");

	prev_val = 1;

	while (1)
	{
		val = self vulture_perk_ir_is_valid();

		if (prev_val != val)
		{
			prev_val = val;

			if (val)
			{
				self clientnotify("vulture_perk_ir_enable");
			}
			else
			{
				self clientnotify("vulture_perk_ir_disable");
			}
		}

		wait 0.1;
	}
}

vulture_perk_ir_is_valid()
{
	// activating vulture stink filter deactivates vulture ir filter
	if (isdefined(self.vulture_stink_value) && self.vulture_stink_value > 0)
	{
		return 0;
	}

	return 1;
}

_vulture_perk_think()
{
	self endon("death");
	self endon("disconnect");
	self endon("vulture_perk_lost");

	prev_speed = 0;

	while (true)
	{
		b_player_in_zombie_stink = 0;
		speed = self scripts\zm\_zm_reimagined::get_player_speed();
		slowing_down = (prev_speed - speed) >= 10;

		if (!isdefined(level.perk_vulture.zombie_stink_array))
		{
			level.perk_vulture.zombie_stink_array = [];
		}

		if (level.perk_vulture.zombie_stink_array.size > 0)
		{
			a_close_points = arraysort(level.perk_vulture.zombie_stink_array, self.origin, 1, 300);

			if (a_close_points.size > 0)
			{
				b_player_in_zombie_stink = self _is_player_in_zombie_stink(a_close_points, speed, slowing_down);
			}
		}

		prev_speed = speed;

		self _handle_zombie_stink(b_player_in_zombie_stink);
		wait(randomfloatrange(0.25, 0.5));
	}
}

_is_player_in_zombie_stink(a_points, speed, slowing_down)
{
	if (speed != 0 && !slowing_down)
	{
		return 0;
	}

	b_is_in_stink = 0;

	for (i = 0; i < a_points.size; i++)
	{
		if (distancesquared(a_points[i].origin, self.origin) < 4900)
		{
			b_is_in_stink = 1;
		}
	}

	return b_is_in_stink;
}