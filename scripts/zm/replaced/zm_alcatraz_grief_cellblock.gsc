#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\gametypes_zm\zmeat;
#include maps\mp\zm_alcatraz_traps;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

zgrief_init()
{
	encounter_init();
}

encounter_init()
{
	level.precachecustomcharacters = ::precache_team_characters;
	level.givecustomcharacters = ::give_team_characters;
	level.gamemode_post_spawn_logic = ::give_player_shiv;
}

main()
{
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects("cellblock");
	grief_treasure_chest_init();
	precacheshader("zm_al_wth_zombie");
	array_thread(level.zombie_spawners, ::add_spawn_function, ::remove_zombie_hats_for_grief);
	maps\mp\zombies\_zm_ai_brutus::precache();
	maps\mp\zombies\_zm_ai_brutus::init();
	level.enemy_location_override_func = ::enemy_location_override;
	level._effect["butterflies"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_skull_elec");
	a_t_door_triggers = getentarray("zombie_door", "targetname");
	triggers = a_t_door_triggers;
	i = 0;

	while (i < triggers.size)
	{
		if (isDefined(triggers[i].script_flag))
		{
			if (triggers[i].script_flag == "activate_cellblock_citadel" || triggers[i].script_flag == "activate_shower_room" || triggers[i].script_flag == "activate_cellblock_infirmary" || triggers[i].script_flag == "activate_infirmary")
			{
				triggers[i] delete();
				i++;
				continue;
			}

			if (triggers[i].script_flag == "activate_cafeteria" || triggers[i].script_flag == "activate_cellblock_east" || triggers[i].script_flag == "activate_cellblock_west" || triggers[i].script_flag == "activate_cellblock_barber" || triggers[i].script_flag == "activate_cellblock_gondola" || triggers[i].script_flag == "activate_cellblock_east_west" || triggers[i].script_flag == "activate_warden_office")
			{
				i++;
				continue;
			}

			if (isDefined(triggers[i].target))
			{
				str_target = triggers[i].target;
				a_door_and_clip = getentarray(str_target, "targetname");

				foreach (ent in a_door_and_clip)
				{
					ent delete();
				}
			}

			triggers[i] delete();
		}

		i++;
	}

	a_t_doors = getentarray("zombie_door", "targetname");

	foreach (t_door in a_t_doors)
	{
		if (isDefined(t_door.script_flag))
		{
			if (t_door.script_flag == "activate_cellblock_east_west" || t_door.script_flag == "activate_cellblock_barber")
			{
				t_door maps\mp\zombies\_zm_blockers::door_opened(self.zombie_cost);
			}
		}
	}

	zbarriers = getzbarrierarray();
	a_str_zones = [];
	a_str_zones[0] = "zone_start";
	a_str_zones[1] = "zone_library";
	a_str_zones[2] = "zone_cafeteria";
	a_str_zones[3] = "zone_cafeteria_end";
	a_str_zones[4] = "zone_warden_office";
	a_str_zones[5] = "zone_cellblock_east";
	a_str_zones[6] = "zone_cellblock_west_warden";
	a_str_zones[7] = "zone_cellblock_west_barber";
	a_str_zones[8] = "zone_cellblock_west";
	a_str_zones[9] = "zone_cellblock_west_gondola";

	foreach (barrier in zbarriers)
	{
		if (isDefined(barrier.script_noteworthy) && barrier.script_noteworthy == "cafe_chest_zbarrier" || isDefined(barrier.script_noteworthy) && barrier.script_noteworthy == "start_chest_zbarrier")
		{

		}
		else
		{
			str_model = barrier.model;
			b_delete_barrier = 1;

			if (isdefined(barrier.script_string))
			{
				for (i = 0; i < a_str_zones.size; i++)
				{
					if (str_model == a_str_zones[i])
					{
						b_delete_barrier = 0;
						break;
					}
				}
			}
			else if (b_delete_barrier == 1)
			{
				barrier delete();
			}
		}
	}

	t_temp = getent("tower_trap_activate_trigger", "targetname");
	t_temp delete();
	t_temp = getent("tower_trap_range_trigger", "targetname");
	t_temp delete();
	e_model = getent("trap_control_docks", "targetname");
	e_model delete();
	e_brush = getent("tower_shockbox_door", "targetname");
	e_brush delete();
	a_t_travel_triggers = getentarray("travel_trigger", "script_noteworthy");

	foreach (trigger in a_t_travel_triggers)
	{
		trigger delete();
	}

	a_e_gondola_lights = getentarray("gondola_state_light", "targetname");

	foreach (light in a_e_gondola_lights)
	{
		light delete();
	}

	a_e_gondola_landing_gates = getentarray("gondola_landing_gates", "targetname");

	foreach (model in a_e_gondola_landing_gates)
	{
		model delete();
	}

	a_e_gondola_landing_doors = getentarray("gondola_landing_doors", "targetname");

	foreach (model in a_e_gondola_landing_doors)
	{
		model delete();
	}

	a_e_gondola_gates = getentarray("gondola_gates", "targetname");

	foreach (model in a_e_gondola_gates)
	{
		model delete();
	}

	a_e_gondola_doors = getentarray("gondola_doors", "targetname");

	foreach (model in a_e_gondola_doors)
	{
		model delete();
	}

	m_gondola = getent("zipline_gondola", "targetname");
	m_gondola delete();
	t_ride_trigger = getent("gondola_ride_trigger", "targetname");
	t_ride_trigger delete();
	a_classic_clips = getentarray("classic_clips", "targetname");

	foreach (clip in a_classic_clips)
	{
		clip connectpaths();
		clip delete();
	}

	a_afterlife_props = getentarray("afterlife_show", "targetname");

	foreach (m_prop in a_afterlife_props)
	{
		m_prop delete();
	}

	spork_portal = getent("afterlife_show_spork", "targetname");
	spork_portal delete();
	a_audio = getentarray("at_headphones", "script_noteworthy");

	foreach (model in a_audio)
	{
		model delete();
	}

	m_spoon_pickup = getent("pickup_spoon", "targetname");
	m_spoon_pickup delete();
	t_sq_bg = getent("sq_bg_reward_pickup", "targetname");
	t_sq_bg delete();
	t_crafting_table = getentarray("open_craftable_trigger", "targetname");

	foreach (trigger in t_crafting_table)
	{
		trigger delete();
	}

	t_warden_fence = getent("warden_fence_damage", "targetname");
	t_warden_fence delete();
	level setclientfield("warden_fence_down", 1);
	m_plane_about_to_crash = getent("plane_about_to_crash", "targetname");
	m_plane_about_to_crash delete();
	m_plane_craftable = getent("plane_craftable", "targetname");
	m_plane_craftable delete();

	for (i = 1; i <= 5; i++)
	{
		m_key_lock = getent("masterkey_lock_" + i, "targetname");
		m_key_lock delete();
	}

	m_shower_door = getent("shower_key_door", "targetname");
	m_shower_door delete();
	m_nixie_door = getent("nixie_door_left", "targetname");
	m_nixie_door delete();
	m_nixie_door = getent("nixie_door_right", "targetname");
	m_nixie_door delete();
	m_nixie_brush = getent("nixie_tube_weaponclip", "targetname");
	m_nixie_brush delete();

	for (i = 1; i <= 3; i++)
	{
		m_nixie_tube = getent("nixie_tube_" + i, "targetname");
		m_nixie_tube delete();
	}

	t_elevator_door = getent("nixie_elevator_door", "targetname");
	t_elevator_door delete();
	e_elevator_clip = getent("elevator_door_playerclip", "targetname");
	e_elevator_clip delete();
	e_elevator_bottom_gate = getent("elevator_bottom_gate_l", "targetname");
	e_elevator_bottom_gate delete();
	e_elevator_bottom_gate = getent("elevator_bottom_gate_r", "targetname");
	e_elevator_bottom_gate delete();
	m_docks_puzzle = getent("cable_puzzle_gate_01", "targetname");
	m_docks_puzzle delete();
	m_docks_puzzle = getent("cable_puzzle_gate_02", "targetname");
	m_docks_puzzle delete();
	m_infirmary_case = getent("infirmary_case_door_left", "targetname");
	m_infirmary_case delete();
	m_infirmary_case = getent("infirmary_case_door_right", "targetname");
	m_infirmary_case delete();
	fake_plane_part = getent("fake_veh_t6_dlc_zombie_part_control", "targetname");
	fake_plane_part delete();

	for (i = 1; i <= 3; i++)
	{
		m_generator = getent("generator_panel_" + i, "targetname");
		m_generator delete();
	}

	a_m_generator_core = getentarray("generator_core", "targetname");

	foreach (generator in a_m_generator_core)
	{
		generator delete();
	}

	e_playerclip = getent("electric_chair_playerclip", "targetname");
	e_playerclip delete();

	for (i = 1; i <= 4; i++)
	{
		t_use = getent("trigger_electric_chair_" + i, "targetname");
		t_use delete();
		m_chair = getent("electric_chair_" + i, "targetname");
		m_chair delete();
	}

	a_afterlife_interact = getentarray("afterlife_interact", "targetname");

	foreach (model in a_afterlife_interact)
	{
		model turn_afterlife_interact_on();
		wait 0.1;
	}

	east_hurt_trigger = getent("pulley_hurt_trigger_east", "targetname");
	east_hurt_trigger delete();

	west_hurt_trigger = getent("pulley_hurt_trigger_west", "targetname");
	west_hurt_trigger delete();

	flag_wait("initial_blackscreen_passed");
	maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
	flag_wait("start_zombie_round_logic");
	level thread maps\mp\zm_alcatraz_traps::init_fan_trap_trigs();
	level thread maps\mp\zm_alcatraz_traps::init_acid_trap_trigs();
	wait 1;
	level notify("sleight_on");
	wait_network_frame();
	level notify("doubletap_on");
	wait_network_frame();
	level notify("juggernog_on");
	wait_network_frame();
	level notify("electric_cherry_on");
	wait_network_frame();
	level notify("deadshot_on");
	wait_network_frame();
	level notify("divetonuke_on");
	wait_network_frame();
	level notify("additionalprimaryweapon_on");
	wait_network_frame();
	level notify("Pack_A_Punch_on");
	wait_network_frame();
}