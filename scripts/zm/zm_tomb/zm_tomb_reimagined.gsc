#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;

main()
{
	replaceFunc(maps\mp\zm_tomb::precache_personality_characters, scripts\zm\replaced\zm_tomb::precache_personality_characters);
	replaceFunc(maps\mp\zm_tomb::give_personality_characters, scripts\zm\replaced\zm_tomb::give_personality_characters);
	replaceFunc(maps\mp\zm_tomb::custom_vending_precaching, scripts\zm\replaced\zm_tomb::custom_vending_precaching);
	replaceFunc(maps\mp\zm_tomb::working_zone_init, scripts\zm\replaced\zm_tomb::working_zone_init);
	replaceFunc(maps\mp\zm_tomb::tomb_can_track_ammo_custom, scripts\zm\replaced\zm_tomb::tomb_can_track_ammo_custom);
	replaceFunc(maps\mp\zm_tomb::tomb_zombie_death_event_callback, scripts\zm\replaced\zm_tomb::tomb_zombie_death_event_callback);
	replaceFunc(maps\mp\zm_tomb::tomb_custom_divetonuke_explode, scripts\zm\replaced\zm_tomb::tomb_custom_divetonuke_explode);
	replaceFunc(maps\mp\zm_tomb::tomb_custom_electric_cherry_reload_attack, scripts\zm\replaced\zm_tomb::tomb_custom_electric_cherry_reload_attack);
	replaceFunc(maps\mp\zm_tomb::tomb_custom_electric_cherry_laststand, scripts\zm\replaced\zm_tomb::tomb_custom_electric_cherry_laststand);
	replaceFunc(maps\mp\zm_tomb::sndmeleewpnsound, scripts\zm\replaced\zm_tomb::sndmeleewpnsound);
	replaceFunc(maps\mp\zm_tomb_gamemodes::init, scripts\zm\replaced\zm_tomb_gamemodes::init);
	replaceFunc(maps\mp\zm_tomb_main_quest::main_quest_init, scripts\zm\replaced\zm_tomb_main_quest::main_quest_init);
	replaceFunc(maps\mp\zm_tomb_main_quest::place_staff_in_charger, scripts\zm\replaced\zm_tomb_main_quest::place_staff_in_charger);
	replaceFunc(maps\mp\zm_tomb_main_quest::watch_for_player_pickup_staff, scripts\zm\replaced\zm_tomb_main_quest::watch_for_player_pickup_staff);
	replaceFunc(maps\mp\zm_tomb_main_quest::staff_upgraded_reload_monitor, scripts\zm\replaced\zm_tomb_main_quest::staff_upgraded_reload_monitor);
	replaceFunc(maps\mp\zm_tomb_main_quest::watch_staff_ammo_reload, scripts\zm\replaced\zm_tomb_main_quest::watch_staff_ammo_reload);
	replaceFunc(maps\mp\zm_tomb_quest_air::air_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_air::air_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_quest_elec::electric_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_elec::electric_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_quest_elec::electric_puzzle_2_init, scripts\zm\replaced\zm_tomb_quest_elec::electric_puzzle_2_init);
	replaceFunc(maps\mp\zm_tomb_quest_fire::fire_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_fire::fire_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_quest_ice::ice_puzzle_1_init, scripts\zm\replaced\zm_tomb_quest_ice::ice_puzzle_1_init);
	replaceFunc(maps\mp\zm_tomb_quest_ice::ice_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_ice::ice_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_ee_main::all_staffs_inserted_in_puzzle_room, scripts\zm\replaced\zm_tomb_ee_main::all_staffs_inserted_in_puzzle_room);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_2::create_robot_head_trigger, scripts\zm\replaced\zm_tomb_ee_main_step_2::create_robot_head_trigger);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_3::ready_to_activate, scripts\zm\replaced\zm_tomb_ee_main_step_3::ready_to_activate);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_4::stage_logic, scripts\zm\replaced\zm_tomb_ee_main_step_4::stage_logic);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_4::mechz_death_ee, scripts\zm\replaced\zm_tomb_ee_main_step_4::mechz_death_ee);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_8::stage_logic, scripts\zm\replaced\zm_tomb_ee_main_step_8::stage_logic);
	replaceFunc(maps\mp\zm_tomb_ee_side::init, scripts\zm\replaced\zm_tomb_ee_side::init);
	replaceFunc(maps\mp\zm_tomb_ee_side::swap_mg, scripts\zm\replaced\zm_tomb_ee_side::swap_mg);
	replaceFunc(maps\mp\zm_tomb_capture_zones::precache_everything, scripts\zm\replaced\zm_tomb_capture_zones::precache_everything);
	replaceFunc(maps\mp\zm_tomb_capture_zones::declare_objectives, scripts\zm\replaced\zm_tomb_capture_zones::declare_objectives);
	replaceFunc(maps\mp\zm_tomb_capture_zones::init_capture_zone, scripts\zm\replaced\zm_tomb_capture_zones::init_capture_zone);
	replaceFunc(maps\mp\zm_tomb_capture_zones::register_elements_powered_by_zone_capture_generators, scripts\zm\replaced\zm_tomb_capture_zones::register_elements_powered_by_zone_capture_generators);
	replaceFunc(maps\mp\zm_tomb_capture_zones::enable_mystery_boxes_in_zone, scripts\zm\replaced\zm_tomb_capture_zones::enable_mystery_boxes_in_zone);
	replaceFunc(maps\mp\zm_tomb_capture_zones::disable_mystery_boxes_in_zone, scripts\zm\replaced\zm_tomb_capture_zones::disable_mystery_boxes_in_zone);
	replaceFunc(maps\mp\zm_tomb_capture_zones::pack_a_punch_init, scripts\zm\replaced\zm_tomb_capture_zones::pack_a_punch_init);
	replaceFunc(maps\mp\zm_tomb_capture_zones::pack_a_punch_enable, scripts\zm\replaced\zm_tomb_capture_zones::pack_a_punch_enable);
	replaceFunc(maps\mp\zm_tomb_capture_zones::setup_perk_machines_not_controlled_by_zone_capture, scripts\zm\replaced\zm_tomb_capture_zones::setup_perk_machines_not_controlled_by_zone_capture);
	replaceFunc(maps\mp\zm_tomb_capture_zones::check_perk_machine_valid, scripts\zm\replaced\zm_tomb_capture_zones::check_perk_machine_valid);
	replaceFunc(maps\mp\zm_tomb_capture_zones::init_recapture_zombie, scripts\zm\replaced\zm_tomb_capture_zones::init_recapture_zombie);
	replaceFunc(maps\mp\zm_tomb_capture_zones::recapture_zombie_death_func, scripts\zm\replaced\zm_tomb_capture_zones::recapture_zombie_death_func);
	replaceFunc(maps\mp\zm_tomb_capture_zones::recapture_round_tracker, scripts\zm\replaced\zm_tomb_capture_zones::recapture_round_tracker);
	replaceFunc(maps\mp\zm_tomb_capture_zones::recapture_zombie_icon_think, scripts\zm\replaced\zm_tomb_capture_zones::recapture_zombie_icon_think);
	replaceFunc(maps\mp\zm_tomb_capture_zones::get_zone_objective_index, scripts\zm\replaced\zm_tomb_capture_zones::get_zone_objective_index);
	replaceFunc(maps\mp\zm_tomb_capture_zones::get_generator_capture_start_cost, scripts\zm\replaced\zm_tomb_capture_zones::get_generator_capture_start_cost);
	replaceFunc(maps\mp\zm_tomb_capture_zones::magic_box_stub_update_prompt, scripts\zm\replaced\zm_tomb_capture_zones::magic_box_stub_update_prompt);
	replaceFunc(maps\mp\zm_tomb_chamber::inits, scripts\zm\replaced\zm_tomb_chamber::inits);
	replaceFunc(maps\mp\zm_tomb_challenges::tomb_challenges_add_stats, scripts\zm\replaced\zm_tomb_challenges::tomb_challenges_add_stats);
	replaceFunc(maps\mp\zm_tomb_challenges::box_footprint_think, scripts\zm\replaced\zm_tomb_challenges::box_footprint_think);
	replaceFunc(maps\mp\zm_tomb_challenges::one_inch_punch_watch_for_death, scripts\zm\replaced\zm_tomb_challenges::one_inch_punch_watch_for_death);
	replaceFunc(maps\mp\zm_tomb_craftables::init_craftables, scripts\zm\replaced\zm_tomb_craftables::init_craftables);
	replaceFunc(maps\mp\zm_tomb_craftables::include_craftables, scripts\zm\replaced\zm_tomb_craftables::include_craftables);
	replaceFunc(maps\mp\zm_tomb_craftables::track_staff_weapon_respawn, scripts\zm\replaced\zm_tomb_craftables::track_staff_weapon_respawn);
	replaceFunc(maps\mp\zm_tomb_craftables::onpickup_crystal, scripts\zm\replaced\zm_tomb_craftables::onpickup_crystal);
	replaceFunc(maps\mp\zm_tomb_craftables::clear_player_crystal, scripts\zm\replaced\zm_tomb_craftables::clear_player_crystal);
	replaceFunc(maps\mp\zm_tomb_craftables::staff_fullycrafted, scripts\zm\replaced\zm_tomb_craftables::staff_fullycrafted);
	replaceFunc(maps\mp\zm_tomb_dig::init_shovel, scripts\zm\replaced\zm_tomb_dig::init_shovel);
	replaceFunc(maps\mp\zm_tomb_dig::waittill_dug, scripts\zm\replaced\zm_tomb_dig::waittill_dug);
	replaceFunc(maps\mp\zm_tomb_dig::increment_player_perk_purchase_limit, scripts\zm\replaced\zm_tomb_dig::increment_player_perk_purchase_limit);
	replaceFunc(maps\mp\zm_tomb_giant_robot::init_giant_robot_glows, scripts\zm\replaced\zm_tomb_giant_robot::init_giant_robot_glows);
	replaceFunc(maps\mp\zm_tomb_giant_robot::giant_robot_initial_spawns, scripts\zm\replaced\zm_tomb_giant_robot::giant_robot_initial_spawns);
	replaceFunc(maps\mp\zm_tomb_giant_robot::robot_cycling, scripts\zm\replaced\zm_tomb_giant_robot::robot_cycling);
	replaceFunc(maps\mp\zm_tomb_giant_robot::activate_kill_trigger, scripts\zm\replaced\zm_tomb_giant_robot::activate_kill_trigger);
	replaceFunc(maps\mp\zm_tomb_giant_robot::giant_robot_close_head_entrance, scripts\zm\replaced\zm_tomb_giant_robot::giant_robot_close_head_entrance);
	replaceFunc(maps\mp\zm_tomb_tank::init, scripts\zm\replaced\zm_tomb_tank::init);
	replaceFunc(maps\mp\zm_tomb_tank::players_on_tank_update, scripts\zm\replaced\zm_tomb_tank::players_on_tank_update);
	replaceFunc(maps\mp\zm_tomb_tank::entity_on_tank, scripts\zm\replaced\zm_tomb_tank::entity_on_tank);
	replaceFunc(maps\mp\zm_tomb_tank::wait_for_tank_cooldown, scripts\zm\replaced\zm_tomb_tank::wait_for_tank_cooldown);
	replaceFunc(maps\mp\zm_tomb_tank::activate_tank_wait_with_no_cost, scripts\zm\replaced\zm_tomb_tank::activate_tank_wait_with_no_cost);
	replaceFunc(maps\mp\zm_tomb_tank::tank_kill_players, scripts\zm\replaced\zm_tomb_tank::tank_kill_players);
	replaceFunc(maps\mp\zm_tomb_teleporter::run_chamber_entrance_teleporter, scripts\zm\replaced\zm_tomb_teleporter::run_chamber_entrance_teleporter);
	replaceFunc(maps\mp\zm_tomb_utility::capture_zombie_spawn_init, scripts\zm\replaced\zm_tomb_utility::capture_zombie_spawn_init);
	replaceFunc(maps\mp\zm_tomb_utility::weather_manager, scripts\zm\replaced\zm_tomb_utility::weather_manager);
	replaceFunc(maps\mp\zm_tomb_utility::update_staff_accessories, scripts\zm\replaced\zm_tomb_utility::update_staff_accessories);
	replaceFunc(maps\mp\zm_tomb_utility::check_solo_status, scripts\zm\replaced\zm_tomb_utility::check_solo_status);
	replaceFunc(maps\mp\zm_tomb_ffotd::update_charger_position, scripts\zm\replaced\zm_tomb_ffotd::update_charger_position);
	replaceFunc(maps\mp\zm_tomb_ffotd::player_spawn_fix, scripts\zm\replaced\zm_tomb_ffotd::player_spawn_fix);
	replaceFunc(maps\mp\zm_tomb_distance_tracking::delete_zombie_noone_looking, scripts\zm\replaced\zm_tomb_distance_tracking::delete_zombie_noone_looking);
	replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_set_starting_health, scripts\zm\replaced\_zm_ai_mechz::mechz_set_starting_health);
	replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_round_tracker, scripts\zm\replaced\_zm_ai_mechz::mechz_round_tracker);
	replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_death, scripts\zm\replaced\_zm_ai_mechz::mechz_death);
	replaceFunc(maps\mp\zombies\_zm_ai_mechz_ft::mechz_watch_for_flamethrower_damage, scripts\zm\replaced\_zm_ai_mechz_ft::mechz_watch_for_flamethrower_damage);
	replaceFunc(maps\mp\zombies\_zm_ai_quadrotor::quadrotor_movementupdate, scripts\zm\replaced\_zm_ai_quadrotor::quadrotor_movementupdate);
	replaceFunc(maps\mp\zombies\_zm_challenges::onplayerspawned, scripts\zm\replaced\_zm_challenges::onplayerspawned);
	replaceFunc(maps\mp\zombies\_zm_challenges::team_stats_init, scripts\zm\replaced\_zm_challenges::team_stats_init);
	replaceFunc(maps\mp\zombies\_zm_challenges::stat_reward_available, scripts\zm\replaced\_zm_challenges::stat_reward_available);
	replaceFunc(maps\mp\zombies\_zm_challenges::player_has_unclaimed_team_reward, scripts\zm\replaced\_zm_challenges::player_has_unclaimed_team_reward);
	replaceFunc(maps\mp\zombies\_zm_challenges::get_reward_stat, scripts\zm\replaced\_zm_challenges::get_reward_stat);
	replaceFunc(maps\mp\zombies\_zm_challenges::spawn_reward, scripts\zm\replaced\_zm_challenges::spawn_reward);
	replaceFunc(maps\mp\zombies\_zm_challenges::update_box_prompt, scripts\zm\replaced\_zm_challenges::update_box_prompt);
	replaceFunc(maps\mp\zombies\_zm_challenges::box_think, scripts\zm\replaced\_zm_challenges::box_think);
	replaceFunc(maps\mp\zombies\_zm_craftables::choose_open_craftable, scripts\zm\replaced\_zm_craftables::choose_open_craftable);
	replaceFunc(maps\mp\zombies\_zm_craftables::craftable_use_hold_think_internal, scripts\zm\replaced\_zm_craftables::craftable_use_hold_think_internal);
	replaceFunc(maps\mp\zombies\_zm_craftables::player_progress_bar, scripts\zm\replaced\_zm_craftables::player_progress_bar);
	replaceFunc(maps\mp\zombies\_zm_craftables::update_open_table_status, scripts\zm\replaced\_zm_craftables::update_open_table_status);
	replaceFunc(maps\mp\zombies\_zm_craftables::onbeginuseuts, scripts\zm\replaced\_zm_craftables::onbeginuseuts);
	replaceFunc(maps\mp\zombies\_zm_magicbox_tomb::custom_magic_box_timer_til_despawn, scripts\zm\replaced\_zm_magicbox_tomb::custom_magic_box_timer_til_despawn);
	replaceFunc(maps\mp\zombies\_zm_perk_random::machines_setup, scripts\zm\replaced\_zm_perk_random::machines_setup);
	replaceFunc(maps\mp\zombies\_zm_perk_random::machine_selector, scripts\zm\replaced\_zm_perk_random::machine_selector);
	replaceFunc(maps\mp\zombies\_zm_perk_random::machine_think, scripts\zm\replaced\_zm_perk_random::machine_think);
	replaceFunc(maps\mp\zombies\_zm_perk_random::start_perk_bottle_cycling, scripts\zm\replaced\_zm_perk_random::start_perk_bottle_cycling);
	replaceFunc(maps\mp\zombies\_zm_perk_random::perk_bottle_motion, scripts\zm\replaced\_zm_perk_random::perk_bottle_motion);
	replaceFunc(maps\mp\zombies\_zm_perk_random::trigger_visible_to_player, scripts\zm\replaced\_zm_perk_random::trigger_visible_to_player);
	replaceFunc(maps\mp\zombies\_zm_perk_random::wunderfizzstub_update_prompt, scripts\zm\replaced\_zm_perk_random::wunderfizzstub_update_prompt);
	replaceFunc(maps\mp\zombies\_zm_powerup_zombie_blood::zombie_blood_powerup, scripts\zm\replaced\_zm_powerup_zombie_blood::zombie_blood_powerup);
	replaceFunc(maps\mp\zombies\_zm_riotshield_tomb::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield_tomb::doriotshielddeploy);
	replaceFunc(maps\mp\zombies\_zm_riotshield_tomb::trackriotshield, scripts\zm\replaced\_zm_riotshield_tomb::trackriotshield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_tomb::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield_tomb::player_damage_shield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_tomb::riotshield_fling_zombie, scripts\zm\replaced\_zm_weap_riotshield_tomb::riotshield_fling_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_tomb::riotshield_knockdown_zombie, scripts\zm\replaced\_zm_weap_riotshield_tomb::riotshield_knockdown_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_one_inch_punch::one_inch_punch_melee_attack, scripts\zm\replaced\_zm_weap_one_inch_punch::one_inch_punch_melee_attack);
	replaceFunc(maps\mp\zombies\_zm_weap_beacon::player_handle_beacon, scripts\zm\replaced\_zm_weap_beacon::player_handle_beacon);
	replaceFunc(maps\mp\zombies\_zm_weap_beacon::artillery_barrage_logic, scripts\zm\replaced\_zm_weap_beacon::artillery_barrage_logic);
	replaceFunc(maps\mp\zombies\_zm_weap_beacon::wait_and_do_weapon_beacon_damage, scripts\zm\replaced\_zm_weap_beacon::wait_and_do_weapon_beacon_damage);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_air::staff_air_position_source, scripts\zm\replaced\_zm_weap_staff_air::staff_air_position_source);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_air::staff_air_zombie_source, scripts\zm\replaced\_zm_weap_staff_air::staff_air_zombie_source);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_air::staff_air_zombie_damage_response, scripts\zm\replaced\_zm_weap_staff_air::staff_air_zombie_damage_response);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::fire_spread_shots, scripts\zm\replaced\_zm_weap_staff_fire::fire_spread_shots);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::fire_additional_shots, scripts\zm\replaced\_zm_weap_staff_fire::fire_additional_shots);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::fire_staff_area_of_effect, scripts\zm\replaced\_zm_weap_staff_fire::fire_staff_area_of_effect);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::flame_damage_fx, scripts\zm\replaced\_zm_weap_staff_fire::flame_damage_fx);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::get_impact_damage, scripts\zm\replaced\_zm_weap_staff_fire::get_impact_damage);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::staff_fire_zombie_damage_response, scripts\zm\replaced\_zm_weap_staff_fire::staff_fire_zombie_damage_response);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::fire_staff_update_grenade_fuse, scripts\zm\replaced\_zm_weap_staff_fire::fire_staff_update_grenade_fuse);
	replaceFunc(maps\mp\zombies\_zm_weap_staff_lightning::staff_lightning_ball_kill_zombies, scripts\zm\replaced\_zm_weap_staff_lightning::staff_lightning_ball_kill_zombies);

	level._effect["fire_ug_impact_exp_sm"] = loadfx("weapon/zmb_staff/fx_zmb_staff_fire_ug_impact_exp_sm");
	level._effect["fire_ug_impact_exp_loop"] = loadfx("weapon/zmb_staff/fx_zmb_staff_fire_ug_impact_exp_loop");

	maps\mp\_explosive_bolt::init();
	scripts\zm\reimagined\_zm_weap_bouncingbetty::init();
	register_clientfields();
}

init()
{
	precachemodel("p6_zm_tm_vending_pipes");

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::tomb_special_weapon_magicbox_check;

	level.mechz_min_round_fq = 4;
	level.mechz_max_round_fq = 6;

	level.zombie_vars["below_world_check"] = -3000;

	if (!is_classic())
	{
		level.zombie_include_weapons["beacon_zm"] = 1;
		level.zombie_weapons["beacon_zm"].is_in_box = 1;

		level.perk_random_vo_func_usemachine = undefined;

		arrayremovevalue(level.zombie_powerup_array, "zombie_blood");
	}

	maps\mp\zombies\_zm::spawn_life_brush((1839, 3574, -228), 512, 256);

	player_respawn_override();
	register_melee_weapons_for_level();
	spawn_custom_wallbuy_chalks();
	spawn_custom_perk_machine_pipes();
	move_additionalprimaryweapon_machine();
	change_stargate_teleport_return_player_angles();
	delete_air_crystal_biplane_ent();
	power_up_all_generators();

	level thread divetonuke_on();
	level thread electric_cherry_on();
	level thread zombie_blood_dig_changes();
	level thread attach_powerups_to_tank();
	level thread updatecraftables();
	level thread random_perk_machine_watch_fire_sale();
	level thread grief_mechz_spawn_after_time();
}

register_clientfields()
{
	if (is_classic())
	{
		return;
	}

	registerclientfield("toplayer", "sndMudSlow", 14000, 1, "int");
	registerclientfield("scriptmover", "element_glow_fx", 14000, 4, "int", undefined, 0);
	registerclientfield("scriptmover", "bryce_cake", 14000, 2, "int", undefined, 0);
	registerclientfield("scriptmover", "switch_spark", 14000, 1, "int", undefined, 0);
}

zombie_init_done()
{
	self.meleedamage = 50;
	self.allowpain = 0;
	self thread maps\mp\zm_tomb_distance_tracking::escaped_zombies_cleanup_init();
	self setphysparams(15, 0, 48);
}

tomb_special_weapon_magicbox_check(weapon)
{
	if (weapon == "beacon_zm")
	{
		if (!is_classic() || is_true(self.beacon_ready))
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}

	if (isDefined(level.zombie_weapons[weapon].shared_ammo_weapon))
	{
		if (self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade(level.zombie_weapons[weapon].shared_ammo_weapon))
		{
			return 0;
		}
	}

	return 1;
}

player_respawn_override()
{
	respawn_points = getstructarray("player_respawn_point", "targetname");

	foreach (respawn_point in respawn_points)
	{
		if (respawn_point.script_noteworthy == "zone_bunker_1")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (2368, 4128, -328))
				{
					respawn.origin = (2268, 4128, -328);
					break;
				}
			}
		}
		else if (respawn_point.script_noteworthy == "zone_bunker_5a")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (-832, 2304, -100))
				{
					respawn.origin = (-819, 2316, -244);
					break;
				}
			}
		}
		else if (respawn_point.script_noteworthy == "zone_village_5")
		{
			respawn_point.script_noteworthy = "zone_village_1";
		}
		else if (respawn_point.script_noteworthy == "zone_village_3")
		{
			respawn_point.script_noteworthy = "zone_village_2";
		}
		else if (respawn_point.script_noteworthy == "zone_chamber")
		{
			respawn_point.script_noteworthy = "zone_chamber_4";
		}
	}
}

register_melee_weapons_for_level()
{
	register_melee_weapon_for_level("one_inch_punch_zm");
	register_melee_weapon_for_level("one_inch_punch_upgraded_zm");
	register_melee_weapon_for_level("one_inch_punch_air_zm");
	register_melee_weapon_for_level("one_inch_punch_fire_zm");
	register_melee_weapon_for_level("one_inch_punch_ice_zm");
	register_melee_weapon_for_level("one_inch_punch_lightning_zm");
}

spawn_custom_wallbuy_chalks()
{
	if (is_classic())
	{
		return;
	}

	foreach (wallbuy in level._spawned_wallbuys)
	{
		if (isdefined(wallbuy.script_noteworthy) && issubstr(wallbuy.script_noteworthy, getdvar("ui_zm_mapstartlocation")))
		{
			wallbuy_target = getstruct(wallbuy.target, "targetname");

			if (isdefined(wallbuy_target.script_string))
			{
				model = spawn("script_model", wallbuy_target.origin);
				model.angles = wallbuy_target.angles;
				model setmodel(wallbuy_target.script_string);
			}
		}
	}
}

spawn_custom_perk_machine_pipes()
{
	if (level.scr_zm_map_start_location == "crazy_place")
	{
		return;
	}

	trigs = getentarray("zombie_vending", "targetname");

	if (!isdefined(trigs))
	{
		return;
	}

	foreach (trig in trigs)
	{
		if (!isdefined(trig.machine))
		{
			continue;
		}

		if (!isdefined(trig.script_noteworthy))
		{
			continue;
		}

		origin_offset = undefined;
		angles_offset = undefined;

		if (trig.script_noteworthy == "specialty_rof")
		{
			origin_offset = (26, 8, 0);
			angles_offset = (0, 180, 0);
		}
		else if (trig.script_noteworthy == "specialty_deadshot")
		{
			origin_offset = (15, 0, 0);
			angles_offset = (0, 180, 0);
		}

		if (!isdefined(origin_offset) || !isdefined(angles_offset))
		{
			continue;
		}

		origin = trig.machine.origin;
		angles = trig.machine.angles;

		model = spawn("script_model", origin + anglestoforward(angles) * origin_offset[0] + anglestoright(angles) * origin_offset[1] + anglestoup(angles) * origin_offset[2]);
		model.angles = angles + angles_offset;
		model setmodel("p6_zm_tm_vending_pipes");
	}
}

move_additionalprimaryweapon_machine()
{
	if (!is_classic())
	{
		return;
	}

	trigs = getentarray("vending_additionalprimaryweapon", "target");

	if (!isdefined(trigs))
	{
		return;
	}

	foreach (trig in trigs)
	{
		if (isdefined(trig.machine))
		{
			for (i = 0; i < 3; i++)
			{
				model = spawn("script_model", trig.machine.origin + anglestoright(trig.clip.angles) * -12 + anglestoup(trig.clip.angles) * (i * 2));
				model.angles = trig.machine.angles;
				model setmodel("p6_zm_tm_wood_plank_rustic_2x12_96");
			}

			for (i = 0; i < 3; i++)
			{
				model = spawn("script_model", trig.machine.origin + anglestoright(trig.clip.angles) * 0 + anglestoup(trig.clip.angles) * (i * 2));
				model.angles = trig.machine.angles;
				model setmodel("p6_zm_tm_wood_plank_rustic_2x12_96");
			}

			for (i = 0; i < 3; i++)
			{
				model = spawn("script_model", trig.machine.origin + anglestoright(trig.clip.angles) * 12 + anglestoup(trig.clip.angles) * (i * 2));
				model.angles = trig.machine.angles;
				model setmodel("p6_zm_tm_wood_plank_rustic_2x12_96");
			}

			trig.machine.origin += anglestoup(trig.clip.angles) * 5;
		}
	}
}

change_stargate_teleport_return_player_angles()
{
	struct = getstructarray("air_teleport_return", "targetname");

	foreach (pos in struct)
	{
		pos.angles = (0, -120, 0);
	}

	struct = getstructarray("elec_teleport_return", "targetname");

	foreach (pos in struct)
	{
		pos.angles = (0, 0, 0);
	}

	struct = getstructarray("fire_teleport_return", "targetname");

	foreach (pos in struct)
	{
		pos.angles = (0, -130, 0);
	}

	struct = getstructarray("ice_teleport_return", "targetname");

	foreach (pos in struct)
	{
		pos.angles = (0, -110, 0);
	}
}

delete_air_crystal_biplane_ent()
{
	ent = getent("air_crystal_biplane", "targetname");
	ent delete();
}

power_up_all_generators()
{
	if (is_classic())
	{
		return;
	}

	flag_wait("start_zombie_round_logic");
	wait_network_frame();

	foreach (zone in level.zone_capture.zones)
	{
		zone maps\mp\zm_tomb_capture_zones::set_player_controlled_area();
		zone.n_current_progress = 100;
		zone maps\mp\zm_tomb_capture_zones::generator_state_power_up();
		level setclientfield(zone.script_noteworthy, zone.n_current_progress / 100);
		wait_network_frame();
	}
}

divetonuke_on()
{
	flag_wait("start_zombie_round_logic");

	level notify("divetonuke_on");
}

electric_cherry_on()
{
	flag_wait("start_zombie_round_logic");

	level notify("electric_cherry_on");
}

zombie_blood_dig_changes()
{
	if (!is_classic())
	{
		return;
	}

	while (1)
	{
		for (i = 0; i < level.a_zombie_blood_entities.size; i++)
		{
			ent = level.a_zombie_blood_entities[i];

			if (IsDefined(ent.e_unique_player))
			{
				if (!isDefined(ent.e_unique_player.initial_zombie_blood_dig))
				{
					ent.e_unique_player.initial_zombie_blood_dig = 0;
				}

				ent.e_unique_player.initial_zombie_blood_dig++;

				if (ent.e_unique_player.initial_zombie_blood_dig <= 2)
				{
					ent setvisibletoplayer(ent.e_unique_player);
				}
				else
				{
					ent thread set_visible_after_rounds(ent.e_unique_player, 3);
				}

				arrayremovevalue(level.a_zombie_blood_entities, ent);
			}
		}

		wait .5;
	}
}

set_visible_after_rounds(player, num)
{
	for (i = 0; i < num; i++)
	{
		level waittill("end_of_round");
	}

	self setvisibletoplayer(player);
}

attach_powerups_to_tank()
{
	if (!isDefined(level.vh_tank))
	{
		return;
	}

	level.vh_tank.radius = 110;
	level.vh_tank.frontdist = 255;
	level.vh_tank.backdist = 110;
	level.vh_tank.frontlocal = (level.vh_tank.frontdist - level.vh_tank.radius / 2.0, 0, 0);
	level.vh_tank.backlocal = (level.vh_tank.backdist * -1 + level.vh_tank.radius / 2.0, 0, 0);

	while (1)
	{
		level waittill("powerup_dropped", powerup);

		level.vh_tank.frontworld = level.vh_tank localtoworldcoords(level.vh_tank.frontlocal);
		level.vh_tank.backworld = level.vh_tank localtoworldcoords(level.vh_tank.backlocal);

		level thread attachpoweruptotank(powerup);
	}
}

attachpoweruptotank(powerup)
{
	if (!isdefined(powerup) || !isdefined(level.vh_tank))
	{
		return;
	}

	powerup endon("powerup_grabbed");
	powerup endon("powerup_timedout");

	distanceoutsideoftank = 50.0;
	pos = powerup.origin;
	posintank = pointonsegmentnearesttopoint(level.vh_tank.frontworld, level.vh_tank.backworld, pos);
	posdist2 = distance2dsquared(pos, posintank);

	if (posdist2 > level.vh_tank.radius * level.vh_tank.radius)
	{
		radiusplus = level.vh_tank.radius + distanceoutsideoftank;

		if (posdist2 > radiusplus * radiusplus)
		{
			return;
		}
	}

	powerup.origin_diff = level.vh_tank worldtolocalcoords(powerup.origin);

	while (isDefined(powerup))
	{
		powerup.origin = level.vh_tank localtoworldcoords(powerup.origin_diff);

		wait 0.05;
	}
}

updatecraftables()
{
	flag_wait("start_zombie_round_logic");

	wait 1;

	foreach (stub in level._unitriggers.trigger_stubs)
	{
		if (IsDefined(stub.equipname) && (stub.equipname == "open_table" || stub.equipname == "tomb_shield_zm" || stub.equipname == "equip_dieseldrone_zm"))
		{
			stub.cost = stub scripts\zm\_zm_reimagined::get_equipment_cost();
			stub.trigger_func = ::craftable_place_think;
			stub.prompt_and_visibility_func = ::craftabletrigger_update_prompt;
		}
	}
}

craftable_place_think()
{
	self endon("kill_trigger");
	player_crafted = undefined;

	while (!(isdefined(self.stub.crafted) && self.stub.crafted))
	{
		self waittill("trigger", player);

		if (isdefined(level.custom_craftable_validation))
		{
			valid = self [[level.custom_craftable_validation]](player);

			if (!valid)
			{
				continue;
			}
		}

		if (player != self.parent_player)
		{
			continue;
		}

		if (isdefined(player.screecher_weapon))
		{
			continue;
		}

		if (!is_player_valid(player))
		{
			player thread ignore_triggers(0.5);
			continue;
		}

		status = player player_can_craft(self.stub.craftablespawn);

		if (!status)
		{
			self.stub.hint_string = "";
			self sethintstring(self.stub.hint_string);

			if (isdefined(self.stub.oncantuse))
			{
				self.stub [[self.stub.oncantuse]](player);
			}
		}
		else
		{
			if (isdefined(self.stub.onbeginuse))
			{
				self.stub [[self.stub.onbeginuse]](player);
			}

			result = self craftable_use_hold_think(player);
			team = player.pers["team"];

			if (isdefined(self.stub.onenduse))
			{
				self.stub [[self.stub.onenduse]](team, player, result);
			}

			if (!result)
			{
				continue;
			}

			if (isdefined(self.stub.onuse))
			{
				self.stub [[self.stub.onuse]](player);
			}

			prompt = player player_craft(self.stub.craftablespawn);
			player_crafted = player;
			self.stub.hint_string = prompt;
			self sethintstring(self.stub.hint_string);
		}
	}

	if (isdefined(self.stub.craftablestub.onfullycrafted))
	{
		b_result = self.stub [[self.stub.craftablestub.onfullycrafted]]();

		if (!b_result)
		{
			return;
		}
	}

	if (isdefined(player_crafted))
	{

	}

	if (self.stub.persistent == 0)
	{
		self.stub craftablestub_remove();
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.stub);
		return;
	}

	if (self.stub.persistent == 3)
	{
		stub_uncraft_craftable(self.stub, 1);
		return;
	}

	if (self.stub.persistent == 2)
	{
		if (isdefined(player_crafted))
		{
			self craftabletrigger_update_prompt(player_crafted);
		}

		if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined))
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			self sethintstring(self.stub.hint_string);
			return;
		}

		if (isdefined(self.stub.str_taken) && self.stub.str_taken)
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			self sethintstring(self.stub.hint_string);
			return;
		}

		if (isdefined(self.stub.model))
		{
			self.stub.model notsolid();
			self.stub.model show();
		}

		while (self.stub.persistent == 2)
		{
			self waittill("trigger", player);

			if (isdefined(player.screecher_weapon))
			{
				continue;
			}

			if (isdefined(level.custom_craftable_validation))
			{
				valid = self [[level.custom_craftable_validation]](player);

				if (!valid)
				{
					continue;
				}
			}

			if (!(isdefined(self.stub.crafted) && self.stub.crafted))
			{
				self.stub.hint_string = "";
				self sethintstring(self.stub.hint_string);
				return;
			}

			if (player != self.parent_player)
			{
				continue;
			}

			if (!is_player_valid(player))
			{
				player thread ignore_triggers(0.5);
				continue;
			}

			self.stub.bought = 1;

			if (isdefined(self.stub.model))
			{
				self.stub.model thread model_fly_away(self);
			}

			player maps\mp\zombies\_zm_weapons::weapon_give(self.stub.weaponname);

			if (isdefined(level.zombie_include_craftables[self.stub.equipname].onbuyweapon))
			{
				self [[level.zombie_include_craftables[self.stub.equipname].onbuyweapon]](player);
			}

			if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined))
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			}
			else
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			}

			self sethintstring(self.stub.hint_string);
			player track_craftables_pickedup(self.stub.craftablespawn);
		}
	}
	else if (!isdefined(player_crafted) || self craftabletrigger_update_prompt(player_crafted))
	{
		if (isdefined(self.stub.model))
		{
			self.stub.model notsolid();
			self.stub.model show();
		}

		while (self.stub.persistent == 1)
		{
			self waittill("trigger", player);

			if (isdefined(player.screecher_weapon))
			{
				continue;
			}

			if (isdefined(level.custom_craftable_validation))
			{
				valid = self [[level.custom_craftable_validation]](player);

				if (!valid)
				{
					continue;
				}
			}

			if (!(isdefined(self.stub.crafted) && self.stub.crafted))
			{
				self.stub.hint_string = "";
				self sethintstring(self.stub.hint_string);
				return;
			}

			if (player != self.parent_player)
			{
				continue;
			}

			if (!is_player_valid(player))
			{
				player thread ignore_triggers(0.5);
				continue;
			}

			if (player.score < self.stub.cost)
			{
				self play_sound_on_ent("no_purchase");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
				continue;
			}

			riotshield_repair = 0;

			if (player has_player_equipment(self.stub.weaponname))
			{
				if (!(self.stub.weaponname == level.riotshield_name && player scripts\zm\replaced\_zm_buildables::has_player_damaged_riotshield_equipped()))
				{
					continue;
				}

				riotshield_repair = 1;
			}

			if (isdefined(level.zombie_craftable_persistent_weapon))
			{
				if (self [[level.zombie_craftable_persistent_weapon]](player))
				{
					continue;
				}
			}

			if (isdefined(level.zombie_custom_equipment_setup))
			{
				if (self [[level.zombie_custom_equipment_setup]](player))
				{
					continue;
				}
			}

			if (!maps\mp\zombies\_zm_equipment::is_limited_equipment(self.stub.weaponname) || !maps\mp\zombies\_zm_equipment::limited_equipment_in_use(self.stub.weaponname))
			{
				player maps\mp\zombies\_zm_score::minus_to_player_score(self.stub.cost);
				self play_sound_on_ent("purchase");

				if (riotshield_repair)
				{
					if (isdefined(player.player_shield_reset_health))
					{
						player [[player.player_shield_reset_health]]();
					}

					self.stub.hint_string = &"ZOMBIE_BOUGHT_RIOT_REPAIR";
					self sethintstring(self.stub.hint_string);
					player track_craftables_pickedup(self.stub.craftablespawn);

					continue;
				}

				player maps\mp\zombies\_zm_equipment::equipment_buy(self.stub.weaponname);
				player giveweapon(self.stub.weaponname);
				player setweaponammoclip(self.stub.weaponname, 1);

				if (isdefined(level.zombie_include_craftables[self.stub.equipname].onbuyweapon))
				{
					self [[level.zombie_include_craftables[self.stub.equipname].onbuyweapon]](player);
				}
				else if (self.stub.weaponname != "keys_zm")
				{
					player setactionslot(1, "weapon", self.stub.weaponname);
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
			}
			else
			{
				self.stub.hint_string = "";
				self sethintstring(self.stub.hint_string);
			}
		}
	}
}

craftabletrigger_update_prompt(player)
{
	can_use = self.stub craftablestub_update_prompt(player);

	if (can_use && is_true(self.stub.crafted) && !isSubStr(self.stub.craftablespawn.craftable_name, "staff"))
	{
		self sethintstring(self.stub.hint_string, self.stub.cost);
	}
	else
	{
		self sethintstring(self.stub.hint_string);
	}

	return can_use;
}

craftablestub_update_prompt(player, unitrigger)
{
	if (!self anystub_update_prompt(player))
	{
		return false;
	}

	if (isdefined(self.is_locked) && self.is_locked)
	{
		return true;
	}

	can_use = 1;

	if (isdefined(self.custom_craftablestub_update_prompt) && !self [[self.custom_craftablestub_update_prompt]](player))
	{
		return false;
	}

	if (!(isdefined(self.crafted) && self.crafted))
	{
		if (!self.craftablespawn craftable_can_use_shared_piece())
		{
			if (!isdefined(player.current_craftable_piece))
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
				return false;
			}
			else if (!self.craftablespawn craftable_has_piece(player.current_craftable_piece))
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
				return false;
			}
		}

		assert(isdefined(level.zombie_craftablestubs[self.equipname].str_to_craft), "Missing craftable hint");
		self.hint_string = level.zombie_craftablestubs[self.equipname].str_to_craft;
	}
	else if (self.persistent == 1)
	{
		if (maps\mp\zombies\_zm_equipment::is_limited_equipment(self.weaponname) && maps\mp\zombies\_zm_equipment::limited_equipment_in_use(self.weaponname))
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
			return false;
		}

		if (player has_player_equipment(self.weaponname))
		{
			if (self.weaponname == level.riotshield_name && player scripts\zm\replaced\_zm_buildables::has_player_damaged_riotshield_equipped())
			{
				self.hint_string = &"ZOMBIE_REPAIR_RIOTSHIELD";
				return true;
			}

			self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
			return false;
		}

		if (self.equipname == "equip_dieseldrone_zm")
		{
			if (level.quadrotor_status.picked_up)
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
				return false;
			}
			else if (flag("quadrotor_cooling_down"))
			{
				self.hint_string = &"ZM_TOMB_MAXISDRONE_COOLDOWN";
				return false;
			}
		}

		self.hint_string = self.trigger_hintstring;
	}
	else if (self.persistent == 2)
	{
		if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.weaponname, undefined))
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			return false;
		}
		else if (isdefined(self.str_taken) && self.str_taken)
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			return false;
		}

		self.hint_string = self.trigger_hintstring;
	}
	else
	{
		self.hint_string = "";
		return false;
	}

	return true;
}

random_perk_machine_watch_fire_sale()
{
	machines = getentarray("random_perk_machine", "targetname");

	foreach (machine in machines)
	{
		machine.is_temp_ball_location = 0;
	}

	while (1)
	{
		level waittill("powerup fire sale");

		level._random_zombie_perk_old_cost = level._random_zombie_perk_cost;
		level._random_zombie_perk_cost = 250;

		foreach (machine in machines)
		{
			if (!machine.is_current_ball_location)
			{
				machine thread show_temp_random_perk_machine();
			}
			else
			{
				machine thread random_perk_machine_fire_sale_fix();
			}
		}

		level waittill("fire_sale_off");

		level._random_zombie_perk_cost = level._random_zombie_perk_old_cost;

		foreach (machine in machines)
		{
			if (machine.is_temp_ball_location)
			{
				machine thread hide_temp_random_perk_machine();
			}
		}
	}
}

random_perk_machine_fire_sale_fix()
{
	level endon("fire_sale_off");

	level waittill("random_perk_moving");
	waittillframeend;

	level.random_perk_start_machine.is_temp_ball_location = 0;

	self thread show_temp_random_perk_machine();
}

show_temp_random_perk_machine()
{
	self.is_temp_ball_location = 1;
	self thread maps\mp\zombies\_zm_perk_random::machine_think();
}

hide_temp_random_perk_machine()
{
	level endon("powerup fire sale");

	if (isdefined(self.machine_user))
	{
		self waittill_either("grab_check", "time_out_check");
		waittillframeend;
	}

	self.is_temp_ball_location = 0;
	self.is_current_ball_location = 0;
	self notify("machine_think");
	self thread maps\mp\zombies\_zm_perk_random::update_animation("shut_down");
	wait 3;
	self setclientfield("turn_on_location_indicator", 0);
	self maps\mp\zombies\_zm_perk_random::conditional_power_indicators();
	self hidepart("j_ball");
}

grief_mechz_spawn_after_time()
{
	if (!is_gametype_active("zgrief"))
	{
		return;
	}

	if (level.scr_zm_map_start_location == "crazy_place")
	{
		return;
	}

	level endon("end_game");

	level waittill("restart_round_start");

	while (1)
	{
		time = randomIntRange(240, 360);

		wait time;

		level.mechz_left_to_spawn = 1;
		level notify("spawn_mechz");

		while (get_mechz_count() <= 0)
		{
			wait 1;
		}

		while (get_mechz_count() > 0)
		{
			wait 1;
		}
	}
}

get_mechz_count()
{
	mechz_count = 0;
	zombies = getaispeciesarray(level.zombie_team, "all");

	foreach (zombie in zombies)
	{
		if (is_true(zombie.is_mechz) && isalive(zombie))
		{
			mechz_count++;
		}
	}

	return mechz_count;
}

spawn_wallbuy_plywood(origin, angles)
{
	model1 = spawn("script_model", origin);
	model1.angles = angles + (-90, 0, 0);
	model1 setmodel("p6_pak_old_plywood_small");

	model2 = spawn("script_model", origin + anglestoforward(angles) * 2 + anglestoup(angles) * -15);
	model2.angles = angles + (0, 90, 0);
	model2 setmodel("p6_zm_tm_wood_post_thin_01_tall");

	model3 = spawn("script_model", origin + anglestoforward(angles) * 1 + anglestoright(angles) * -25 + anglestoup(angles) * -15);
	model3.angles = angles;
	model3 setmodel("p6_zm_tm_wood_post_thin_01_tall");

	model4 = spawn("script_model", origin + anglestoforward(angles) * 1 + anglestoright(angles) * 25 + anglestoup(angles) * -15);
	model4.angles = angles + (0, 180, 0);
	model4 setmodel("p6_zm_tm_wood_post_thin_01_tall");
}