#include maps\mp\zm_tomb_craftables;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_ai_quadrotor;
#include maps\mp\zombies\_zm_equipment;

init_craftables()
{
	precachemodel("p6_zm_tm_quadrotor_stand");
	flag_init("quadrotor_cooling_down");
	level.craftable_piece_count = 4;
	flag_init("any_crystal_picked_up");
	flag_init("staff_air_zm_enabled");
	flag_init("staff_fire_zm_enabled");
	flag_init("staff_lightning_zm_enabled");
	flag_init("staff_water_zm_enabled");
	register_clientfields();
	add_zombie_craftable("equip_dieseldrone_zm", &"ZM_TOMB_CRQ", &"ZM_TOMB_CRQ", &"ZM_TOMB_TQ", ::onfullycrafted_quadrotor, 1);
	add_zombie_craftable_vox_category("equip_dieseldrone_zm", "build_dd");
	make_zombie_craftable_open("equip_dieseldrone_zm", "veh_t6_dlc_zm_quadrotor", (0, 0, 0), (0, -4, 10));
	add_zombie_craftable("tomb_shield_zm", &"ZM_TOMB_CRRI", undefined, &"ZOMBIE_BOUGHT_RIOT", undefined, 1);
	add_zombie_craftable_vox_category("tomb_shield_zm", "build_zs");
	make_zombie_craftable_open("tomb_shield_zm", "t6_wpn_zmb_shield_dlc4_dmg0_world", vectorscale((0, -1, 0), 90.0), (0, 0, level.riotshield_placement_zoffset));
	add_zombie_craftable("elemental_staff_fire", &"ZM_TOMB_CRF", &"ZM_TOMB_INS", &"ZM_TOMB_BOF", ::staff_fire_fullycrafted, 1);
	add_zombie_craftable_vox_category("elemental_staff_fire", "fire_staff");
	add_zombie_craftable("elemental_staff_air", &"ZM_TOMB_CRA", &"ZM_TOMB_INS", &"ZM_TOMB_BOA", ::staff_air_fullycrafted, 1);
	add_zombie_craftable_vox_category("elemental_staff_air", "air_staff");
	add_zombie_craftable("elemental_staff_lightning", &"ZM_TOMB_CRL", &"ZM_TOMB_INS", &"ZM_TOMB_BOL", ::staff_lightning_fullycrafted, 1);
	add_zombie_craftable_vox_category("elemental_staff_lightning", "light_staff");
	add_zombie_craftable("elemental_staff_water", &"ZM_TOMB_CRW", &"ZM_TOMB_INS", &"ZM_TOMB_BOW", ::staff_water_fullycrafted, 1);
	add_zombie_craftable_vox_category("elemental_staff_water", "ice_staff");
	add_zombie_craftable("gramophone", &"ZM_TOMB_CRAFT_GRAMOPHONE", &"ZM_TOMB_CRAFT_GRAMOPHONE", &"ZM_TOMB_BOUGHT_GRAMOPHONE", undefined, 0);
	add_zombie_craftable_vox_category("gramophone", "gramophone");
	level.zombie_craftable_persistent_weapon = ::tomb_check_crafted_weapon_persistence;
	level.custom_craftable_validation = ::tomb_custom_craftable_validation;
	level.zombie_custom_equipment_setup = ::setup_quadrotor_purchase;
	level thread hide_staff_model();
	level.quadrotor_status = spawnstruct();
	level.quadrotor_status.crafted = 0;
	level.quadrotor_status.picked_up = 0;
	level.num_staffpieces_picked_up = [];
	level.n_staffs_crafted = 0;
}

register_clientfields()
{
	bits = 1;
	registerclientfield("world", "piece_quadrotor_zm_body", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_quadrotor_zm_brain", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_quadrotor_zm_engine", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_riotshield_dolly", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_riotshield_door", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_riotshield_clamp", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_gem_air", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_ustaff_air", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_mstaff_air", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_lstaff_air", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_gem_fire", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_ustaff_fire", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_mstaff_fire", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_lstaff_fire", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_gem_lightning", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_ustaff_lightning", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_mstaff_lightning", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_lstaff_lightning", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_gem_water", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_ustaff_water", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_mstaff_water", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_staff_zm_lstaff_water", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_record_zm_player", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_record_zm_vinyl_master", 14000, 3, "int", undefined, 0);
	registerclientfield("world", "piece_record_zm_vinyl_air", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_record_zm_vinyl_water", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_record_zm_vinyl_fire", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "piece_record_zm_vinyl_lightning", 14000, bits, "int", undefined, 0);
	registerclientfield("scriptmover", "element_glow_fx", 14000, 4, "int", undefined, 0);
	registerclientfield("scriptmover", "bryce_cake", 14000, 2, "int", undefined, 0);
	registerclientfield("scriptmover", "switch_spark", 14000, 1, "int", undefined, 0);
	bits = getminbitcountfornum(5);
	registerclientfield("world", "gem_player1", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "gem_player2", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "gem_player3", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "gem_player4", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "staff_player1", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "staff_player2", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "staff_player3", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "staff_player4", 14000, bits, "int", undefined, 0);
	bits = getminbitcountfornum(5);
	registerclientfield("world", "quest_state1", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "quest_state2", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "quest_state3", 14000, bits, "int", undefined, 0);
	registerclientfield("world", "quest_state4", 14000, bits, "int", undefined, 0);
	registerclientfield("toplayer", "sndMudSlow", 14000, 1, "int");
}

include_craftables()
{
	level thread run_craftables_devgui();
	craftable_name = "equip_dieseldrone_zm";
	quadrotor_body = generate_zombie_craftable_piece(craftable_name, "body", "veh_t6_dlc_zm_quad_piece_body", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_body", 1, "build_dd");
	quadrotor_brain = generate_zombie_craftable_piece(craftable_name, "brain", "veh_t6_dlc_zm_quad_piece_brain", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_brain", 1, "build_dd_brain");
	quadrotor_engine = generate_zombie_craftable_piece(craftable_name, "engine", "veh_t6_dlc_zm_quad_piece_engine", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_engine", 1, "build_dd");
	quadrotor = spawnstruct();
	quadrotor.name = craftable_name;
	quadrotor add_craftable_piece(quadrotor_body);
	quadrotor add_craftable_piece(quadrotor_brain);
	quadrotor add_craftable_piece(quadrotor_engine);
	quadrotor.triggerthink = ::quadrotorcraftable;
	include_zombie_craftable(quadrotor);
	level thread add_craftable_cheat(quadrotor);
	craftable_name = "tomb_shield_zm";
	riotshield_top = generate_zombie_craftable_piece(craftable_name, "top", "t6_wpn_zmb_shield_dlc4_top", 48, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs");
	riotshield_door = generate_zombie_craftable_piece(craftable_name, "door", "t6_wpn_zmb_shield_dlc4_door", 48, 15, 25, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs");
	riotshield_bracket = generate_zombie_craftable_piece(craftable_name, "bracket", "t6_wpn_zmb_shield_dlc4_bracket", 48, 15, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs");
	riotshield = spawnstruct();
	riotshield.name = craftable_name;
	riotshield add_craftable_piece(riotshield_top);
	riotshield add_craftable_piece(riotshield_door);
	riotshield add_craftable_piece(riotshield_bracket);
	riotshield.onbuyweapon = ::onbuyweapon_riotshield;
	riotshield.triggerthink = ::riotshieldcraftable;
	include_craftable(riotshield);
	level thread add_craftable_cheat(riotshield);
	craftable_name = "elemental_staff_air";
	staff_air_gem = generate_zombie_craftable_piece(craftable_name, "gem", "t6_wpn_zmb_staff_crystal_air_part", 48, 64, 0, undefined, ::onpickup_aircrystal, ::ondrop_aircrystal, undefined, undefined, undefined, undefined, 2, 0, "crystal", 1);
	staff_air_upper_staff = generate_zombie_craftable_piece(craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_air_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_air", 1, "staff_part");
	staff_air_middle_staff = generate_zombie_craftable_piece(craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_air_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_air", 1, "staff_part");
	staff_air_lower_staff = generate_zombie_craftable_piece(craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_air", 1, "staff_part");
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece(staff_air_gem);
	staff add_craftable_piece(staff_air_upper_staff);
	staff add_craftable_piece(staff_air_middle_staff);
	staff add_craftable_piece(staff_air_lower_staff);
	staff.triggerthink = ::staffcraftable_air;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(array(staff_air_upper_staff, staff_air_middle_staff, staff_air_lower_staff));
	craftable_name = "elemental_staff_fire";
	staff_fire_gem = generate_zombie_craftable_piece(craftable_name, "gem", "t6_wpn_zmb_staff_crystal_fire_part", 48, 64, 0, undefined, ::onpickup_firecrystal, ::ondrop_firecrystal, undefined, undefined, undefined, undefined, 1, 0, "crystal", 1);
	staff_fire_upper_staff = generate_zombie_craftable_piece(craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_fire_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_fire", 1, "staff_part");
	staff_fire_middle_staff = generate_zombie_craftable_piece(craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_fire_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_fire", 1, "staff_part");
	staff_fire_lower_staff = generate_zombie_craftable_piece(craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 64, 128, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_fire", 1, "staff_part");
	level thread maps\mp\zm_tomb_main_quest::staff_mechz_drop_pieces(staff_fire_lower_staff);
	level thread maps\mp\zm_tomb_main_quest::staff_biplane_drop_pieces(array(staff_fire_middle_staff));
	level thread maps\mp\zm_tomb_main_quest::staff_unlock_with_zone_capture(staff_fire_upper_staff);
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece(staff_fire_gem);
	staff add_craftable_piece(staff_fire_upper_staff);
	staff add_craftable_piece(staff_fire_middle_staff);
	staff add_craftable_piece(staff_fire_lower_staff);
	staff.triggerthink = ::staffcraftable_fire;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(array(staff_fire_upper_staff, staff_fire_middle_staff, staff_fire_lower_staff));
	craftable_name = "elemental_staff_lightning";
	staff_lightning_gem = generate_zombie_craftable_piece(craftable_name, "gem", "t6_wpn_zmb_staff_crystal_bolt_part", 48, 64, 0, undefined, ::onpickup_lightningcrystal, ::ondrop_lightningcrystal, undefined, undefined, undefined, undefined, 3, 0, "crystal", 1);
	staff_lightning_upper_staff = generate_zombie_craftable_piece(craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_lightning_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_lightning", 1, "staff_part");
	staff_lightning_middle_staff = generate_zombie_craftable_piece(craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_bolt_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_lightning", 1, "staff_part");
	staff_lightning_lower_staff = generate_zombie_craftable_piece(craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_lightning", 1, "staff_part");
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece(staff_lightning_gem);
	staff add_craftable_piece(staff_lightning_upper_staff);
	staff add_craftable_piece(staff_lightning_middle_staff);
	staff add_craftable_piece(staff_lightning_lower_staff);
	staff.triggerthink = ::staffcraftable_lightning;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(array(staff_lightning_upper_staff, staff_lightning_middle_staff, staff_lightning_lower_staff));
	craftable_name = "elemental_staff_water";
	staff_water_gem = generate_zombie_craftable_piece(craftable_name, "gem", "t6_wpn_zmb_staff_crystal_water_part", 48, 64, 0, undefined, ::onpickup_watercrystal, ::ondrop_watercrystal, undefined, undefined, undefined, undefined, 4, 0, "crystal", 1);
	staff_water_upper_staff = generate_zombie_craftable_piece(craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_water_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_water", 1, "staff_part");
	staff_water_middle_staff = generate_zombie_craftable_piece(craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_water_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_water", 1, "staff_part");
	staff_water_lower_staff = generate_zombie_craftable_piece(craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_water", 1, "staff_part");
	a_ice_staff_parts = array(staff_water_lower_staff, staff_water_middle_staff, staff_water_upper_staff);
	level thread maps\mp\zm_tomb_main_quest::staff_ice_dig_pieces(a_ice_staff_parts);
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece(staff_water_gem);
	staff add_craftable_piece(staff_water_upper_staff);
	staff add_craftable_piece(staff_water_middle_staff);
	staff add_craftable_piece(staff_water_lower_staff);
	staff.triggerthink = ::staffcraftable_water;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(array(staff_water_upper_staff, staff_water_middle_staff, staff_water_lower_staff));
	craftable_name = "gramophone";
	vinyl_pickup_player = vinyl_add_pickup(craftable_name, "vinyl_player", "p6_zm_tm_gramophone", "piece_record_zm_player", undefined, "gramophone");
	vinyl_pickup_master = vinyl_add_pickup(craftable_name, "vinyl_master", "p6_zm_tm_record_master", "piece_record_zm_vinyl_master", undefined, "record");
	vinyl_pickup_air = vinyl_add_pickup(craftable_name, "vinyl_air", "p6_zm_tm_record_wind", "piece_record_zm_vinyl_air", "quest_state2", "record");
	vinyl_pickup_ice = vinyl_add_pickup(craftable_name, "vinyl_ice", "p6_zm_tm_record_ice", "piece_record_zm_vinyl_water", "quest_state4", "record");
	vinyl_pickup_fire = vinyl_add_pickup(craftable_name, "vinyl_fire", "p6_zm_tm_record_fire", "piece_record_zm_vinyl_fire", "quest_state1", "record");
	vinyl_pickup_elec = vinyl_add_pickup(craftable_name, "vinyl_elec", "p6_zm_tm_record_lightning", "piece_record_zm_vinyl_lightning", "quest_state3", "record");
	vinyl_pickup_player.sam_line = "gramophone_found";
	vinyl_pickup_master.sam_line = "master_found";
	vinyl_pickup_air.sam_line = "first_record_found";
	vinyl_pickup_ice.sam_line = "first_record_found";
	vinyl_pickup_fire.sam_line = "first_record_found";
	vinyl_pickup_elec.sam_line = "first_record_found";
	level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_line("vox_sam_1st_record_found_0", "first_record_found");
	level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_line("vox_sam_gramophone_found_0", "gramophone_found");
	level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_line("vox_sam_master_found_0", "master_found");
	gramophone = spawnstruct();
	gramophone.name = craftable_name;
	gramophone add_craftable_piece(vinyl_pickup_player);
	gramophone add_craftable_piece(vinyl_pickup_master);
	gramophone add_craftable_piece(vinyl_pickup_air);
	gramophone add_craftable_piece(vinyl_pickup_ice);
	gramophone add_craftable_piece(vinyl_pickup_fire);
	gramophone add_craftable_piece(vinyl_pickup_elec);
	gramophone.triggerthink = ::gramophonecraftable;
	include_zombie_craftable(gramophone);
	level thread add_craftable_cheat(gramophone);
	staff_fire_gem thread watch_part_pickup("quest_state1", 2);
	staff_air_gem thread watch_part_pickup("quest_state2", 2);
	staff_lightning_gem thread watch_part_pickup("quest_state3", 2);
	staff_water_gem thread watch_part_pickup("quest_state4", 2);
	staff_fire_gem thread staff_crystal_wait_for_teleport(1);
	staff_air_gem thread staff_crystal_wait_for_teleport(2);
	staff_lightning_gem thread staff_crystal_wait_for_teleport(3);
	staff_water_gem thread staff_crystal_wait_for_teleport(4);
	level thread maps\mp\zm_tomb_vo::staff_craft_vo();
	level thread maps\mp\zm_tomb_vo::samantha_discourage_think();
	level thread maps\mp\zm_tomb_vo::samantha_encourage_think();
	level thread craftable_add_glow_fx();
}

onfullycrafted_quadrotor(player)
{
	if (is_true(level.quadrotor_status.crafted))
	{
		return 1;
	}

	level.quadrotor_status.crafted = 1;
	pickup_trig = level.quadrotor_status.pickup_trig;
	level.quadrotor_status.str_zone = maps\mp\zombies\_zm_zonemgr::get_zone_from_position(pickup_trig.origin, 1);
	level.quadrotor_status.pickup_indicator = spawn("script_model", pickup_trig.model.origin + vectorscale((0, 0, -1), 10.0));
	level.quadrotor_status.pickup_indicator.angles = pickup_trig.model.angles;
	level.quadrotor_status.pickup_indicator setmodel("p6_zm_tm_quadrotor_stand");
	pickup_trig.model.origin += (0, 0, 6.5);
	pickup_trig.model.angles += (0, -90, 0);

	level notify("quest_progressed", player, 1);
	return 1;
}

quadrotor_control_thread()
{
	self endon("bled_out");
	self endon("disconnect");

	while (1)
	{
		if (self actionslottwobuttonpressed() && self hasweapon("equip_dieseldrone_zm"))
		{
			prev_wep = self getCurrentWeapon();

			self increment_is_drinking();
			self disable_player_move_states(1);

			self switchtoweapon("equip_dieseldrone_zm");

			self waittill("weapon_change_complete");

			self playsound("veh_qrdrone_takeoff");

			if (self hasweapon(prev_wep) && prev_wep != "equip_dieseldrone_zm")
			{
				self switchtoweapon(prev_wep);
			}
			else
			{
				self switchtoweapon(self getweaponslistprimaries()[0]);
			}

			self waittill("weapon_change");

			if (self hasweapon("equip_dieseldrone_zm"))
			{
				self takeweapon("equip_dieseldrone_zm");

				melee = self scripts\zm\replaced\zm_tomb_utility::get_melee_weapon_from_held();
				self setactionslot(2, "weapon", "held_" + melee);
			}

			self decrement_is_drinking();
			self enable_player_move_states();

			str_vehicle = "heli_quadrotor_zm";

			if (flag("ee_maxis_drone_retrieved"))
			{
				str_vehicle = "heli_quadrotor_upgraded_zm";
			}

			qr = spawnvehicle("veh_t6_dlc_zm_quadrotor", "quadrotor_ai", str_vehicle, self.origin + vectorScale((0, 0, 1), 96), self.angles);
			level thread maps\mp\zm_tomb_craftables::quadrotor_death_watcher(qr);
			qr thread quadrotor_instance_watcher(self);
			return;
		}

		wait 0.05;
	}
}

setup_quadrotor_purchase(player)
{
	if (self.stub.weaponname == "equip_dieseldrone_zm")
	{
		if (players_has_weapon("equip_dieseldrone_zm"))
		{
			return true;
		}

		quadrotor = getentarray("quadrotor_ai", "targetname");

		if (quadrotor.size >= 1)
		{
			return true;
		}

		player maps\mp\zombies\_zm_score::minus_to_player_score(self.stub.cost);
		self play_sound_on_ent("purchase");

		quadrotor_set_unavailable();
		player giveweapon("equip_dieseldrone_zm");
		player setweaponammoclip("equip_dieseldrone_zm", 1);
		player playsoundtoplayer("zmb_buildable_pickup_complete", player);

		if (isdefined(self.stub.craftablestub.use_actionslot))
		{
			player setactionslot(self.stub.craftablestub.use_actionslot, "weapon", "equip_dieseldrone_zm");
		}
		else
		{
			player setactionslot(2, "weapon", "equip_dieseldrone_zm");
		}

		player notify("equip_dieseldrone_zm_given");
		level thread quadrotor_watcher(player);
		player thread maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "build_dd_plc");

		self.stub.hint_string = &"ZM_TOMB_BOUGHT_QUADROTOR";
		self sethintstring(self.stub.hint_string);

		player thread show_equipment_hint(self.stub.weaponname);

		return true;
	}

	return false;
}

quadrotor_watcher(player)
{
	quadrotor_set_unavailable();
	player thread quadrotor_return_condition_watcher();
	player thread quadrotor_control_thread();

	level waittill("drone_available");

	level.maxis_quadrotor = undefined;

	if (flag("ee_quadrotor_disabled"))
	{
		flag_waitopen("ee_quadrotor_disabled");
	}

	quadrotor_set_available();
}

quadrotor_set_unavailable()
{
	level.quadrotor_status.picked_up = 1;
	level.quadrotor_status.pickup_trig.model ghost();
}

quadrotor_set_available()
{
	playfx(level._effect["tesla_elec_kill"], level.quadrotor_status.pickup_trig.model.origin);
	level.quadrotor_status.pickup_trig.model playsound("zmb_qrdrone_leave");
	level.quadrotor_status.picked_up = 0;
	level.quadrotor_status.pickup_trig.model show();
	flag_set("quadrotor_cooling_down");
	str_zone = level.quadrotor_status.str_zone;

	switch (str_zone)
	{
		case "zone_nml_9":
			setclientfield("cooldown_steam", 1);
			break;

		case "zone_bunker_5a":
			setclientfield("cooldown_steam", 2);
			break;

		case "zone_village_1":
			setclientfield("cooldown_steam", 3);
			break;
	}

	vox_line = "vox_maxi_drone_cool_down_3";
	thread maxissay(vox_line, level.quadrotor_status.pickup_trig.model);
	wait 30;
	flag_clear("quadrotor_cooling_down");
	setclientfield("cooldown_steam", 0);
	level.quadrotor_status.pickup_trig trigger_on();
	vox_line = "vox_maxi_drone_cool_down_4";
	maxissay(vox_line, level.quadrotor_status.pickup_trig.model);
}

quadrotor_timer()
{
	self endon("death");
	level endon("drone_available");
	wait 50;
	vox_line = "vox_maxi_drone_cool_down_" + randomintrange(0, 2);
	self thread maps\mp\zm_tomb_vo::maxissay(vox_line, self);
	wait 10;
	vox_line = "vox_maxi_drone_cool_down_2";
	self thread maps\mp\zm_tomb_vo::maxissay(vox_line, self);
	level notify("drone_should_return");
}

quadrotor_instance_watcher(player_owner)
{
	self endon("death");
	self.player_owner = player_owner;
	self.health = 200;
	level.maxis_quadrotor = self;
	self makevehicleunusable();
	self thread maps\mp\zombies\_zm_ai_quadrotor::quadrotor_think();
	self thread follow_ent(player_owner);
	self thread quadrotor_timer();

	level waittill("drone_should_return");

	self quadrotor_fly_back_to_table();
}

tomb_check_crafted_weapon_persistence(player)
{
	if (self.stub.equipname == "equip_dieseldrone_zm")
	{
		if (level.quadrotor_status.picked_up)
		{
			return true;
		}
		else if (level.quadrotor_status.crafted)
		{
			return false;
		}
	}
	else if (self.stub.weaponname == "staff_air_zm" || self.stub.weaponname == "staff_fire_zm" || self.stub.weaponname == "staff_lightning_zm" || self.stub.weaponname == "staff_water_zm")
	{
		if (self is_unclaimed_staff_weapon(self.stub.weaponname))
		{
			s_elemental_staff = get_staff_info_from_weapon_name(self.stub.weaponname, 0);
			player maps\mp\zombies\_zm_weapons::weapon_give(s_elemental_staff.weapname, 0, 0);

			if (isdefined(s_elemental_staff.prev_ammo_stock) && isdefined(s_elemental_staff.prev_ammo_clip))
			{
				clip_size = weaponclipsize(s_elemental_staff.weapname);

				if (s_elemental_staff.prev_ammo_clip < clip_size)
				{
					clip_add = clip_size - s_elemental_staff.prev_ammo_clip;

					if (clip_add > s_elemental_staff.prev_ammo_stock)
					{
						clip_add = s_elemental_staff.prev_ammo_stock;
					}

					s_elemental_staff.prev_ammo_clip += clip_add;
					s_elemental_staff.prev_ammo_stock -= clip_add;
				}

				player setweaponammostock(s_elemental_staff.weapname, s_elemental_staff.prev_ammo_stock);
				player setweaponammoclip(s_elemental_staff.weapname, s_elemental_staff.prev_ammo_clip);
			}

			if (isdefined(level.zombie_craftablestubs[self.stub.equipname].str_taken))
			{
				self.stub.hint_string = level.zombie_craftablestubs[self.stub.equipname].str_taken;
			}
			else
			{
				self.stub.hint_string = "";
			}

			self sethintstring(self.stub.hint_string);
			player track_craftables_pickedup(self.stub.craftablespawn);
			model = getent("craftable_" + self.stub.weaponname, "targetname");
			model ghost();
			self.stub thread track_crafted_staff_trigger();
			self.stub thread track_staff_weapon_respawn(player);
			set_player_staff(self.stub.weaponname, player);
		}
		else
		{
			self.stub.hint_string = "";
			self sethintstring(self.stub.hint_string);
		}

		return true;
	}

	return false;
}

tomb_custom_craftable_validation(player)
{
	if (self.stub.equipname == "equip_dieseldrone_zm")
	{
		level.quadrotor_status.pickup_trig = self.stub;

		if (level.quadrotor_status.crafted)
		{
			return !level.quadrotor_status.picked_up && !flag("quadrotor_cooling_down");
		}
	}

	if (!issubstr(self.stub.weaponname, "staff"))
	{
		return 1;
	}

	if (!(isdefined(level.craftables_crafted[self.stub.equipname]) && level.craftables_crafted[self.stub.equipname]))
	{
		return 1;
	}

	if (!player scripts\zm\replaced\zm_tomb_main_quest::can_pickup_staff())
	{
		self thread swap_staff_hint_craftable();
		return 0;
	}

	e_upgraded_staff = maps\mp\zm_tomb_craftables::get_staff_info_from_weapon_name(self.stub.weaponname);

	if (is_true(e_upgraded_staff.ee_in_use))
	{
		return 0;
	}

	s_elemental_staff = get_staff_info_from_weapon_name(self.stub.weaponname, 0);
	weapons = player getweaponslistprimaries();

	foreach (weapon in weapons)
	{
		if (issubstr(weapon, "staff") && weapon != s_elemental_staff.weapname)
		{
			player takeweapon(weapon);
		}
	}

	return 1;
}

swap_staff_hint_craftable()
{
	self notify("swap_staff_hint_craftable");
	self endon("swap_staff_hint_craftable");
	self endon("death");

	self sethintstring(&"ZM_TOMB_OSO");

	wait 3;

	self sethintstring(self.stub.hint_string);
}

track_staff_weapon_respawn(player)
{
	self notify("kill_track_staff_weapon_respawn");
	self endon("kill_track_staff_weapon_respawn");
	player endon("disconnect");

	self thread track_staff_weapon_respawn_player_disconnect_monitor(player);

	s_elemental_staff = get_staff_info_from_weapon_name(self.weaponname, 1);
	s_upgraded_staff = s_elemental_staff.upgrade;

	if (!isdefined(self.base_weaponname))
	{
		self.base_weaponname = s_elemental_staff.weapname;
	}

	flag_clear(self.base_weaponname + "_enabled");

	for (has_weapon = 0; isalive(player); has_weapon = 0)
	{
		if (isdefined(s_elemental_staff.charger.is_inserted) && s_elemental_staff.charger.is_inserted || isdefined(s_upgraded_staff.charger.is_inserted) && s_upgraded_staff.charger.is_inserted || isdefined(s_upgraded_staff.ee_in_use) && s_upgraded_staff.ee_in_use)
		{
			has_weapon = 1;
		}
		else
		{
			weapons = player getweaponslistprimaries();

			foreach (weapon in weapons)
			{
				n_melee_element = 0;

				if (weapon == self.base_weaponname)
				{
					s_elemental_staff.prev_ammo_stock = player getweaponammostock(weapon);
					s_elemental_staff.prev_ammo_clip = player getweaponammoclip(weapon);
					has_weapon = 1;
				}
				else if (weapon == s_upgraded_staff.weapname)
				{
					s_upgraded_staff.prev_ammo_stock = player getweaponammostock(weapon);
					s_upgraded_staff.prev_ammo_clip = player getweaponammoclip(weapon);
					has_weapon = 1;
					n_melee_element = s_upgraded_staff.enum;
				}

				if (player hasweapon("staff_revive_zm"))
				{
					s_upgraded_staff.revive_ammo_stock = player getweaponammostock("staff_revive_zm");
					s_upgraded_staff.revive_ammo_clip = player getweaponammoclip("staff_revive_zm");
				}

				if (has_weapon)
				{
					cur_weapon = player getcurrentweapon();
					cur_melee_weapon = player get_player_melee_weapon();

					if (!issubstr(cur_melee_weapon, "one_inch_punch") && n_melee_element != 0)
					{
						if (cur_weapon != weapon && (isdefined(player.use_staff_melee) && player.use_staff_melee))
						{
							player update_staff_accessories(0);
							continue;
						}

						if (cur_weapon == weapon && !(isdefined(player.use_staff_melee) && player.use_staff_melee))
						{
							player update_staff_accessories(n_melee_element);
						}
					}
				}
			}
		}

		if (!has_weapon)
		{
			break;
		}

		wait 0.5;
	}

	b_staff_in_use = 0;
	a_players = getplayers();

	foreach (check_player in a_players)
	{
		if (check_player.sessionstate == "playing")
		{
			weapons = check_player getweaponslistprimaries();

			foreach (weapon in weapons)
			{
				if (weapon == self.base_weaponname || weapon == s_upgraded_staff.weapname)
				{
					b_staff_in_use = 1;
				}
			}
		}
	}

	if (!b_staff_in_use)
	{
		model = getent("craftable_" + self.base_weaponname, "targetname");
		model show();
		flag_set(self.base_weaponname + "_enabled");
	}

	clear_player_staff(self.base_weaponname, player);
}

track_staff_weapon_respawn_player_disconnect_monitor(player)
{
	self notify("track_staff_weapon_respawn_player_disconnect_monitor");
	self endon("track_staff_weapon_respawn_player_disconnect_monitor");

	player waittill("disconnect");

	model = getent("craftable_" + self.base_weaponname, "targetname");
	model show();
	flag_set(self.base_weaponname + "_enabled");
}

onpickup_crystal(player, elementname, elementenum)
{
	onpickup_common(player);
	level setclientfield("piece_staff_zm_gem_" + elementname, 1);
	n_player = player getentitynumber() + 1;
	level setclientfield("gem_player" + n_player, elementenum);

	if (flag("any_crystal_picked_up"))
	{
		self.piecestub.vox_id = undefined;
	}

	flag_set("any_crystal_picked_up");
}

clear_player_crystal(n_element)
{
	if (n_element == self.crystal_id)
	{
		n_player = self getentitynumber() + 1;
		level setclientfield("gem_player" + n_player, 0);
		self.crystal_id = 0;
	}
}

staff_fullycrafted(modelname, elementenum)
{
	player = get_closest_player(self.origin);
	staff_model = getent(modelname, "targetname");
	staff_info = get_staff_info_from_element_index(elementenum);
	staff_model useweaponmodel(staff_info.weapname);
	staff_model showallparts();
	level notify("quest_progressed", player, 0);

	if (!isdefined(staff_model.inused))
	{
		staff_model show();
		staff_model.inused = 1;
		level.n_staffs_crafted++;

		if (level.n_staffs_crafted == 4)
		{
			flag_set("ee_all_staffs_crafted");
		}
	}

	player clear_player_crystal(elementenum);

	str_fieldname = "quest_state" + elementenum;
	level setclientfield(str_fieldname, 3);
	return true;
}

onpickup_common(player)
{
	player playsound("zmb_buildable_pickup");
	self.piece_owner = player;
	self thread piece_pickup_conversation(player);
}