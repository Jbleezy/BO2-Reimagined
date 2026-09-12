#include maps\mp\zm_tomb_quest_crypt;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_audio;

run_crypt_gem_pos()
{
	str_weapon = undefined;
	str_crafted = undefined;
	complete_flag = undefined;
	str_orb_path = undefined;
	str_glow_fx = undefined;
	n_element = self.script_int;

	switch (self.targetname)
	{
		case "crypt_gem_air":
			str_weapon = "staff_air_zm";
			str_crafted = "elemental_staff_air_crafted";
			complete_flag = "staff_air_zm_upgrade_unlocked";
			str_orb_path = "air_orb_exit_path";
			str_final_pos = "air_orb_plinth_final";
			break;

		case "crypt_gem_ice":
			str_weapon = "staff_water_zm";
			str_crafted = "elemental_staff_water_crafted";
			complete_flag = "staff_water_zm_upgrade_unlocked";
			str_orb_path = "ice_orb_exit_path";
			str_final_pos = "ice_orb_plinth_final";
			break;

		case "crypt_gem_fire":
			str_weapon = "staff_fire_zm";
			str_crafted = "elemental_staff_fire_crafted";
			complete_flag = "staff_fire_zm_upgrade_unlocked";
			str_orb_path = "fire_orb_exit_path";
			str_final_pos = "fire_orb_plinth_final";
			break;

		case "crypt_gem_elec":
			str_weapon = "staff_lightning_zm";
			str_crafted = "elemental_staff_lightning_crafted";
			complete_flag = "staff_lightning_zm_upgrade_unlocked";
			str_orb_path = "lightning_orb_exit_path";
			str_final_pos = "lightning_orb_plinth_final";
			break;

		default:
			return;
	}

	flag_wait("start_zombie_round_logic");

	if (is_classic())
	{
		level waittill(str_crafted, player);
	}

	s_start = getstruct(str_orb_path, "targetname");
	s_final = getstruct(str_final_pos, "targetname");
	e_new_gem = spawn("script_model", s_final.origin);
	e_new_gem setmodel(s_start.model);
	e_new_gem.script_int = n_element;
	e_new_gem setclientfield("element_glow_fx", n_element);

	if (is_classic())
	{
		e_new_gem playsound("zmb_squest_crystal_arrive");
		e_new_gem playloopsound("zmb_squest_crystal_charge_loop", 0.1);
	}
	else
	{
		e_new_gem_sound = spawn("script_model", s_final.origin + vectorscale((0, 0, -1), 500.0));
		e_new_gem_sound setmodel("tag_origin");
		e_new_gem_sound playloopsound("zmb_squest_crystal_charge_loop", 0.1);
	}

	if (is_classic())
	{
		flag_set(complete_flag);
	}
}