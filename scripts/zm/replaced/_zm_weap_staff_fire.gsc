#include maps\mp\zombies\_zm_weap_staff_fire;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zm_tomb_craftables;
#include maps\mp\zm_tomb_utility;

fire_spread_shots(str_weapon)
{
	v_fwd = self getweaponforwarddir();
	fire_angles = vectortoangles(v_fwd);
	fire_origin = self getweaponmuzzlepoint();
	v_left_angles = (fire_angles[0], fire_angles[1] - 15, fire_angles[2]);
	v_left = anglestoforward(v_left_angles);

	e_proj = magicbullet(str_weapon, fire_origin, fire_origin + v_left * 100.0, self);
	e_proj.additional_shot = 1;

	v_right_angles = (fire_angles[0], fire_angles[1] + 15, fire_angles[2]);
	v_right = anglestoforward(v_right_angles);

	e_proj = magicbullet(str_weapon, fire_origin, fire_origin + v_right * 100.0, self);
	e_proj.additional_shot = 1;
}

fire_additional_shots(str_weapon)
{
	v_fwd = self getweaponforwarddir();
	fire_angles = vectortoangles(v_fwd);
	fire_origin = self getweaponmuzzlepoint();
	v_left_angles = (fire_angles[0], fire_angles[1] - 15, fire_angles[2]);
	v_left = anglestoforward(v_left_angles);

	e_proj = magicbullet(str_weapon, fire_origin, fire_origin + v_left * 100.0, self);
	e_proj.additional_shot = 1;
	e_proj thread fire_staff_area_of_effect(self, str_weapon);

	v_right_angles = (fire_angles[0], fire_angles[1] + 15, fire_angles[2]);
	v_right = anglestoforward(v_right_angles);

	e_proj = magicbullet(str_weapon, fire_origin, fire_origin + v_right * 100.0, self);
	e_proj.additional_shot = 1;
	e_proj thread fire_staff_area_of_effect(self, str_weapon);
}

fire_staff_area_of_effect(e_attacker, str_weapon)
{
	self waittill("death");

	v_pos = self.origin;

	fx_looper = playloopedfx(level._effect["fire_ug_impact_exp_loop"], 5, v_pos);

	ent = spawn("script_origin", v_pos);
	ent playloopsound("wpn_firestaff_grenade_loop", 1);

	n_alive_time = 5.0;
	aoe_radius = 80;

	if (str_weapon == "staff_fire_upgraded3_zm")
	{
		n_alive_time = 7.5;
	}

	n_step_size = 0.2;

	while (n_alive_time > 0.0)
	{
		if (n_alive_time - n_step_size <= 0.0)
		{
			aoe_radius = aoe_radius * 2;
		}

		a_targets = getaiarray("axis");
		a_targets = get_array_of_closest(v_pos, a_targets, undefined, undefined, aoe_radius);
		wait(n_step_size);
		n_alive_time = n_alive_time - n_step_size;

		foreach (e_target in a_targets)
		{
			if (isdefined(e_target) && isalive(e_target))
			{
				if (!is_true(e_target.is_on_fire))
				{
					e_target thread flame_damage_fx(str_weapon, e_attacker);
				}
			}
		}
	}

	playfx(level._effect["fire_ug_impact_exp_sm"], v_pos);
	fx_looper delete();

	ent playsound("wpn_firestaff_proj_impact");
	ent delete();
}

flame_damage_fx(damageweapon, e_attacker, pct_damage = 1.0)
{
	was_on_fire = is_true(self.is_on_fire);
	n_initial_dmg = get_impact_damage(damageweapon) * pct_damage;
	is_upgraded = damageweapon == "staff_fire_upgraded2_zm" || damageweapon == "staff_fire_upgraded3_zm";

	if (is_upgraded)
	{
		self do_damage_network_safe(e_attacker, self.health, damageweapon, "MOD_BURNED");

		if (cointoss())
		{
			self thread zombie_gib_all();
		}
		else
		{
			self thread zombie_gib_guts();
		}

		return;
	}

	self endon("death");

	if (!was_on_fire)
	{
		self.is_on_fire = 1;
		self thread zombie_set_and_restore_flame_state();
		wait 0.5;
		self thread flame_damage_over_time(e_attacker, damageweapon, pct_damage);
	}

	if (n_initial_dmg > 0)
	{
		self do_damage_network_safe(e_attacker, n_initial_dmg, damageweapon, "MOD_BURNED");
	}
}

get_impact_damage(damageweapon)
{
	switch (damageweapon)
	{
		case "staff_fire_zm":
			return 2050;

		case "staff_fire_upgraded_zm":
		case "staff_fire_upgraded2_zm":
		case "staff_fire_upgraded3_zm":
			return 3300;

		case "one_inch_punch_fire_zm":
			return 0;

		default:
			return 0;
	}
}

staff_fire_zombie_damage_response(mod, hit_location, hit_origin, player, amount)
{
	if (self is_staff_fire_damage() && mod != "MOD_MELEE")
	{
		if (mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH")
		{
			player maps\mp\zombies\_zm_score::player_add_points("damage");
		}

		self thread staff_fire_zombie_hit_response_internal(mod, self.damageweapon, player, amount);

		return true;
	}

	return false;
}

fire_staff_update_grenade_fuse()
{
	// removed
}