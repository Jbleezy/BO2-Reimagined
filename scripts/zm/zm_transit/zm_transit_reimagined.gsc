#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc(character\c_transit_player_farmgirl::precache, character\c_highrise_player_farmgirl::precache);
	replaceFunc(character\c_transit_player_oldman::precache, character\c_highrise_player_oldman::precache);
	replaceFunc(character\c_transit_player_engineer::precache, character\c_highrise_player_engineer::precache);
	replaceFunc(character\c_transit_player_reporter::precache, character\c_highrise_player_reporter::precache);
	replaceFunc(character\c_transit_player_farmgirl::main, character\c_highrise_player_farmgirl::main);
	replaceFunc(character\c_transit_player_oldman::main, character\c_highrise_player_oldman::main);
	replaceFunc(character\c_transit_player_engineer::main, character\c_highrise_player_engineer::main);
	replaceFunc(character\c_transit_player_reporter::main, character\c_highrise_player_reporter::main);
	replaceFunc(maps\mp\zm_transit_sq::navcomputer_waitfor_navcard, scripts\zm\reimagined\_zm_sq::navcomputer_waitfor_navcard);
	replaceFunc(maps\mp\zm_transit_sq::maxis_sidequest_a, scripts\zm\replaced\zm_transit_sq::maxis_sidequest_a);
	replaceFunc(maps\mp\zm_transit_sq::maxis_sidequest_b, scripts\zm\replaced\zm_transit_sq::maxis_sidequest_b);
	replaceFunc(maps\mp\zm_transit_sq::maxis_sidequest_c, scripts\zm\replaced\zm_transit_sq::maxis_sidequest_c);
	replaceFunc(maps\mp\zm_transit_sq::maxis_sidequest_complete, scripts\zm\replaced\zm_transit_sq::maxis_sidequest_complete);
	replaceFunc(maps\mp\zm_transit_sq::richtofen_sidequest_c, scripts\zm\replaced\zm_transit_sq::richtofen_sidequest_c);
	replaceFunc(maps\mp\zm_transit_sq::richtofen_sidequest_complete, scripts\zm\replaced\zm_transit_sq::richtofen_sidequest_complete);
	replaceFunc(maps\mp\zm_transit_sq::droppowerup, scripts\zm\replaced\zm_transit_sq::droppowerup);
	replaceFunc(maps\mp\zm_transit::transit_zone_init, scripts\zm\replaced\zm_transit::transit_zone_init);
	replaceFunc(maps\mp\zm_transit::include_weapons, scripts\zm\replaced\zm_transit::include_weapons);
	replaceFunc(maps\mp\zm_transit::lava_damage_depot, scripts\zm\replaced\zm_transit::lava_damage_depot);
	replaceFunc(maps\mp\zm_transit::safety_light_power_off, scripts\zm\replaced\zm_transit::safety_light_power_off);
	replaceFunc(maps\mp\zm_transit::grenade_safe_to_bounce, scripts\zm\replaced\zm_transit::grenade_safe_to_bounce);
	replaceFunc(maps\mp\zm_transit::can_revive, scripts\zm\replaced\zm_transit::can_revive);
	replaceFunc(maps\mp\zm_transit::sndplaymusicegg, scripts\zm\replaced\zm_transit::sndplaymusicegg);
	replaceFunc(maps\mp\zm_transit_gamemodes::init, scripts\zm\replaced\zm_transit_gamemodes::init);
	replaceFunc(maps\mp\zm_transit_classic::spawn_inert_zombies, scripts\zm\replaced\zm_transit_classic::spawn_inert_zombies);
	replaceFunc(maps\mp\zm_transit_utility::solo_tombstone_removal, scripts\zm\replaced\zm_transit_utility::solo_tombstone_removal);
	replaceFunc(maps\mp\zm_transit_ai_screecher::init, scripts\zm\replaced\zm_transit_ai_screecher::init);
	replaceFunc(maps\mp\zm_transit_ai_screecher::player_wait_land, scripts\zm\replaced\zm_transit_ai_screecher::player_wait_land);
	replaceFunc(maps\mp\zm_transit_automaton::automatonsetup, scripts\zm\replaced\zm_transit_automaton::automatonsetup);
	replaceFunc(maps\mp\zm_transit_buildables::onuseplantobject_turbine, scripts\zm\replaced\zm_transit_buildables::onuseplantobject_turbine);
	replaceFunc(maps\mp\zm_transit_bus::bussetup, scripts\zm\replaced\zm_transit_bus::bussetup);
	replaceFunc(maps\mp\zm_transit_bus::busfxanims_end, scripts\zm\replaced\zm_transit_bus::busfxanims_end);
	replaceFunc(maps\mp\zm_transit_bus::busscheduleadd, scripts\zm\replaced\zm_transit_bus::busscheduleadd);
	replaceFunc(maps\mp\zm_transit_bus::busplowkillzombieuntildeath, scripts\zm\replaced\zm_transit_bus::busplowkillzombieuntildeath);
	replaceFunc(maps\mp\zm_transit_distance_tracking::delete_zombie_noone_looking, scripts\zm\replaced\zm_transit_distance_tracking::delete_zombie_noone_looking);
	replaceFunc(maps\mp\zm_transit_lava::player_lava_damage, scripts\zm\replaced\zm_transit_lava::player_lava_damage);
	replaceFunc(maps\mp\zm_transit_lava::zombie_exploding_death, scripts\zm\replaced\zm_transit_lava::zombie_exploding_death);
	replaceFunc(maps\mp\zombies\_zm_ai_avogadro::check_range_attack, scripts\zm\replaced\_zm_ai_avogadro::check_range_attack);
	replaceFunc(maps\mp\zombies\_zm_ai_avogadro::check_bolt_impact, scripts\zm\replaced\_zm_ai_avogadro::check_bolt_impact);
	replaceFunc(maps\mp\zombies\_zm_ai_avogadro::avogadro_exit, scripts\zm\replaced\_zm_ai_avogadro::avogadro_exit);
	replaceFunc(maps\mp\zombies\_zm_ai_avogadro::avogadro_damage_func, scripts\zm\replaced\_zm_ai_avogadro::avogadro_damage_func);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_spawning_logic, scripts\zm\replaced\_zm_ai_screecher::screecher_spawning_logic);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_attacking, scripts\zm\replaced\_zm_ai_screecher::screecher_attacking);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_melee_damage, scripts\zm\replaced\_zm_ai_screecher::screecher_melee_damage);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_detach, scripts\zm\replaced\_zm_ai_screecher::screecher_detach);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_cleanup, scripts\zm\replaced\_zm_ai_screecher::screecher_cleanup);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_should_runaway, scripts\zm\replaced\_zm_ai_screecher::screecher_should_runaway);
	replaceFunc(maps\mp\zombies\_zm_riotshield::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield::doriotshielddeploy);
	replaceFunc(maps\mp\zombies\_zm_riotshield::trackriotshield, scripts\zm\replaced\_zm_riotshield::trackriotshield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield::player_damage_shield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::riotshield_fling_zombie, scripts\zm\replaced\_zm_weap_riotshield::riotshield_fling_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::riotshield_knockdown_zombie, scripts\zm\replaced\_zm_weap_riotshield::riotshield_knockdown_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::init, scripts\zm\replaced\_zm_weap_jetgun::init);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::watch_overheat, scripts\zm\replaced\_zm_weap_jetgun::watch_overheat);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::jetgun_firing, scripts\zm\replaced\_zm_weap_jetgun::jetgun_firing);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::is_jetgun_firing, scripts\zm\replaced\_zm_weap_jetgun::is_jetgun_firing);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::jetgun_get_enemies_in_range, scripts\zm\replaced\_zm_weap_jetgun::jetgun_get_enemies_in_range);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::zombie_enter_drag_state, scripts\zm\replaced\_zm_weap_jetgun::zombie_enter_drag_state);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::zombie_drag_think, scripts\zm\replaced\_zm_weap_jetgun::zombie_drag_think);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::jetgun_grind_zombie, scripts\zm\replaced\_zm_weap_jetgun::jetgun_grind_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::handle_overheated_jetgun, scripts\zm\replaced\_zm_weap_jetgun::handle_overheated_jetgun);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::jetgun_network_choke, scripts\zm\replaced\_zm_weap_jetgun::jetgun_network_choke);
	replaceFunc(maps\mp\zombies\_zm_weap_emp_bomb::init, scripts\zm\replaced\_zm_weap_emp_bomb::init);
	replaceFunc(maps\mp\zombies\_zm_weap_emp_bomb::emp_detonate, scripts\zm\replaced\_zm_weap_emp_bomb::emp_detonate);
	replaceFunc(maps\mp\zombies\_zm_equip_electrictrap::startelectrictrapdeploy, scripts\zm\replaced\_zm_equip_electrictrap::startelectrictrapdeploy);
	replaceFunc(maps\mp\zombies\_zm_equip_electrictrap::cleanupoldtrap, scripts\zm\replaced\_zm_equip_electrictrap::cleanupoldtrap);
	replaceFunc(maps\mp\zombies\_zm_equip_electrictrap::electrictrapkill, scripts\zm\replaced\_zm_equip_electrictrap::electrictrapkill);
	replaceFunc(maps\mp\zombies\_zm_equip_electrictrap::etrap_choke, scripts\zm\replaced\_zm_equip_electrictrap::etrap_choke);
	replaceFunc(maps\mp\zombies\_zm_equip_turret::startturretdeploy, scripts\zm\replaced\_zm_equip_turret::startturretdeploy);
	replaceFunc(maps\mp\zombies\_zm_banking::onplayerconnect_bank_deposit_box, scripts\zm\replaced\_zm_banking::onplayerconnect_bank_deposit_box);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_box, scripts\zm\replaced\_zm_banking::bank_deposit_box);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_unitrigger, scripts\zm\replaced\_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger, scripts\zm\replaced\_zm_banking::bank_withdraw_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_weapon_locker::triggerweaponslockerisvalidweaponpromptupdate, scripts\zm\replaced\_zm_weapon_locker::triggerweaponslockerisvalidweaponpromptupdate);
	replaceFunc(maps\mp\zombies\_zm_weapon_locker::wl_set_stored_weapondata, scripts\zm\replaced\_zm_weapon_locker::wl_set_stored_weapondata);

	grief_include_weapons();
	electric_door_changes();
}

init()
{
	level.explode_overheated_jetgun = 0;
	level.unbuild_overheated_jetgun = 0;
	level.take_overheated_jetgun = 1;
	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::transit_special_weapon_magicbox_check;
	level.object_touching_lava_func = maps\mp\zm_transit_lava::object_touching_lava;
	level._chugabud_reject_node_override_func = ::transit_chugabud_reject_node_func;

	player_initial_spawn_override();
	player_respawn_override();
	zombie_spawn_location_changes();
	buildable_table_models();
	cornfield_add_collision();
	cornfield_spawn_path_nodes();
	path_exploit_fixes();

	level thread power_local_electric_doors_globally();
	level thread power_station_exposure_change();
	level thread attach_powerups_to_bus();
	level thread bus_hatch_open();
}

grief_include_weapons()
{
	if (getDvar("g_gametype") != "zgrief")
	{
		return;
	}

	include_weapon("ray_gun_zm");
	include_weapon("ray_gun_upgraded_zm", 0);
	include_weapon("tazer_knuckles_zm", 0);
	include_weapon("knife_ballistic_no_melee_zm", 0);
	include_weapon("knife_ballistic_no_melee_upgraded_zm", 0);
	include_weapon("knife_ballistic_zm");
	include_weapon("knife_ballistic_upgraded_zm", 0);
	include_weapon("knife_ballistic_bowie_zm", 0);
	include_weapon("knife_ballistic_bowie_upgraded_zm", 0);
	level._uses_retrievable_ballisitic_knives = 1;
	maps\mp\zombies\_zm_weapons::add_limited_weapon("knife_ballistic_zm", 1);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("ray_gun_zm", 4);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("ray_gun_upgraded_zm", 4);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("knife_ballistic_upgraded_zm", 0);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("knife_ballistic_no_melee_zm", 0);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("knife_ballistic_no_melee_upgraded_zm", 0);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("knife_ballistic_bowie_zm", 0);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("knife_ballistic_bowie_upgraded_zm", 0);
	include_weapon("raygun_mark2_zm");
	include_weapon("raygun_mark2_upgraded_zm", 0);
	maps\mp\zombies\_zm_weapons::add_weapon_to_content("raygun_mark2_zm", "dlc3");
	maps\mp\zombies\_zm_weapons::add_limited_weapon("raygun_mark2_zm", 1);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("raygun_mark2_upgraded_zm", 1);
}

zombie_init_done()
{
	self.meleedamage = 50;
	self.allowpain = 0;
	self setphysparams(15, 0, 48);
}

transit_special_weapon_magicbox_check(weapon)
{
	return 1;
}

electric_door_changes()
{
	if (is_classic())
	{
		return;
	}

	zombie_doors = getentarray("zombie_door", "targetname");

	for (i = 0; i < zombie_doors.size; i++)
	{
		if (isDefined(zombie_doors[i].script_noteworthy) && (zombie_doors[i].script_noteworthy == "local_electric_door" || zombie_doors[i].script_noteworthy == "electric_door"))
		{
			if (zombie_doors[i].target == "lab_secret_hatch")
			{
				continue;
			}

			zombie_doors[i].script_noteworthy = "default";
			zombie_doors[i].zombie_cost = 750;

			// link Bus Depot and Farm electric doors together
			new_target = undefined;

			if (zombie_doors[i].target == "pf1766_auto2353")
			{
				new_target = "pf1766_auto2352";

			}
			else if (zombie_doors[i].target == "pf1766_auto2358")
			{
				new_target = "pf1766_auto2357";
			}

			if (isDefined(new_target))
			{
				targets = getentarray(zombie_doors[i].target, "targetname");
				zombie_doors[i].target = new_target;

				foreach (target in targets)
				{
					target.targetname = zombie_doors[i].target;
				}
			}
		}
	}
}

power_local_electric_doors_globally()
{
	if (!is_classic())
	{
		return;
	}

	for (;;)
	{
		flag_wait("power_on");

		local_power = [];
		zombie_doors = getentarray("zombie_door", "targetname");

		for (i = 0; i < zombie_doors.size; i++)
		{
			if (isDefined(zombie_doors[i].script_noteworthy) && zombie_doors[i].script_noteworthy == "local_electric_door")
			{
				local_power[local_power.size] = maps\mp\zombies\_zm_power::add_local_power(zombie_doors[i].origin, 16);
			}
		}

		flag_waitopen("power_on");

		for (i = 0; i < local_power.size; i++)
		{
			maps\mp\zombies\_zm_power::end_local_power(local_power[i]);
		}
	}
}

transit_chugabud_reject_node_func(corpse_origin, node)
{
	if (self maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_amb_cornfield"))
	{
		a_player_volumes = getentarray("player_volume", "script_noteworthy");

		origins = [];
		origins[origins.size] = node.origin + anglestoforward(node.angles) * 128;
		origins[origins.size] = node.origin + anglestoforward(node.angles) * -128;
		origins[origins.size] = node.origin + anglestoright(node.angles) * 128;
		origins[origins.size] = node.origin + anglestoright(node.angles) * -128;

		foreach (origin in origins)
		{
			if (!maps\mp\zombies\_zm_utility::check_point_in_enabled_zone(origin, 1, a_player_volumes))
			{
				return 1;
			}
		}

		return 0;
	}

	return !findpath(corpse_origin, node.origin);
}

player_initial_spawn_override()
{
	initial_spawns = getstructarray("initial_spawn", "script_noteworthy");
	remove_initial_spawns = [];

	if (level.scr_zm_map_start_location == "transit")
	{
		foreach (initial_spawn in initial_spawns)
		{
			if (initial_spawn.origin == (-6538, 5200, -28) || initial_spawn.origin == (-6713, 5079, -28) || initial_spawn.origin == (-6929, 5444, -28.92) || initial_spawn.origin == (-7144, 5264, -28))
			{
				remove_initial_spawns[remove_initial_spawns.size] = initial_spawn;
			}
		}
	}
	else if (level.scr_zm_map_start_location == "farm")
	{
		foreach (initial_spawn in initial_spawns)
		{
			if (initial_spawn.origin == (7211, -5800, -17.93) || initial_spawn.origin == (7152, -5663, -18.53))
			{
				remove_initial_spawns[remove_initial_spawns.size] = initial_spawn;
			}
			else if (initial_spawn.origin == (8379, -5693, 73.71))
			{
				initial_spawn.origin = (7785, -5922, 53);
				initial_spawn.angles = (0, 80, 0);
				initial_spawn.script_int = 2;
			}
		}
	}
	else if (level.scr_zm_map_start_location == "town")
	{
		foreach (initial_spawn in initial_spawns)
		{
			if (initial_spawn.origin == (1585.5, -754.8, -32.04) || initial_spawn.origin == (1238.5, -303, -31.76))
			{
				remove_initial_spawns[remove_initial_spawns.size] = initial_spawn;
			}
			else if (initial_spawn.origin == (1544, -188, -34))
			{
				initial_spawn.angles = (0, 245, 0);
			}
			else if (initial_spawn.origin == (1430.5, -159, -34))
			{
				initial_spawn.angles = (0, 270, 0);
			}
		}
	}

	foreach (initial_spawn in remove_initial_spawns)
	{
		arrayremovevalue(initial_spawns, initial_spawn);
	}
}

player_respawn_override()
{
	respawn_points = getstructarray("player_respawn_point", "targetname");

	if (level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype != "zclassic")
	{
		foreach (respawn_point in respawn_points)
		{
			if (respawn_point.script_noteworthy == "zone_station_ext")
			{
				respawn_array = getstructarray(respawn_point.target, "targetname");

				respawn_array[0].origin = (-6173, 4753, -34);
				respawn_array[0].angles = (0, -90, 0);

				respawn_array[1].origin = (-6449, 4753, -35);
				respawn_array[1].angles = (0, -90, 0);

				respawn_array[2].origin = (-7050, 4753, -35);
				respawn_array[2].angles = (0, -90, 0);

				respawn_array[3].origin = (-7263, 4753, -35);
				respawn_array[3].angles = (0, -90, 0);

				respawn_array[4].origin = (-7423, 4753, -35);
				respawn_array[4].angles = (0, -90, 0);

				respawn_array[5].origin = (-6160, 4300, -29);
				respawn_array[5].angles = (0, 90, 0);

				respawn_array[6].origin = (-6680, 4300, -35);
				respawn_array[6].angles = (0, 90, 0);

				respawn_array[7].origin = (-7050, 4404, -35);
				respawn_array[7].angles = (0, 90, 0);

				respawn_array[8].origin = (-7263, 4404, -35);
				respawn_array[8].angles = (0, 90, 0);

				respawn_array[9].origin = (-7423, 4404, -35);
				respawn_array[9].angles = (0, 90, 0);
			}
		}
	}
	else if (level.scr_zm_map_start_location == "town")
	{
		// North Town respawns
		origin = (1468.5, 703.5, -39.5);
		zone = "zone_town_north";
		dist = 5000;

		scripts\zm\replaced\utility::register_map_spawn_group(origin, zone, dist);

		respawn_array = [];

		for (i = 0; i < 8; i++)
		{
			respawn_array[i] = spawnStruct();
		}

		respawn_array[0].origin = (1581, 666, -39.5);
		respawn_array[0].angles = (0, 270, 0);

		respawn_array[1].origin = (1506, 666, -39.5);
		respawn_array[1].angles = (0, 270, 0);

		respawn_array[2].origin = (1431, 666, -39.5);
		respawn_array[2].angles = (0, 270, 0);

		respawn_array[3].origin = (1356, 666, -39.5);
		respawn_array[3].angles = (0, 270, 0);

		respawn_array[4].origin = (1581, 741, -39.5);
		respawn_array[4].angles = (0, 270, 0);

		respawn_array[5].origin = (1506, 741, -39.5);
		respawn_array[5].angles = (0, 270, 0);

		respawn_array[6].origin = (1431, 741, -39.5);
		respawn_array[6].angles = (0, 270, 0);

		respawn_array[7].origin = (1356, 741, -39.5);
		respawn_array[7].angles = (0, 270, 0);

		foreach (respawn_struct in respawn_array)
		{
			scripts\zm\replaced\utility::register_map_spawn(respawn_struct.origin, respawn_struct.angles, zone);
		}

		// South Town respawns
		origin = (1424.5, -1426.5, -39.5);
		zone = "zone_town_south";
		dist = 5000;

		scripts\zm\replaced\utility::register_map_spawn_group(origin, zone, dist);

		respawn_array = [];

		for (i = 0; i < 8; i++)
		{
			respawn_array[i] = spawnStruct();
		}

		respawn_array[0].origin = (1312, -1389, -39.5);
		respawn_array[0].angles = (0, 90, 0);

		respawn_array[1].origin = (1387, -1389, -39.5);
		respawn_array[1].angles = (0, 90, 0);

		respawn_array[2].origin = (1462, -1389, -39.5);
		respawn_array[2].angles = (0, 90, 0);

		respawn_array[3].origin = (1537, -1389, -39.5);
		respawn_array[3].angles = (0, 90, 0);

		respawn_array[4].origin = (1312, -1464, -39.5);
		respawn_array[4].angles = (0, 90, 0);

		respawn_array[5].origin = (1387, -1464, -39.5);
		respawn_array[5].angles = (0, 90, 0);

		respawn_array[6].origin = (1462, -1464, -39.5);
		respawn_array[6].angles = (0, 90, 0);

		respawn_array[7].origin = (1537, -1464, -39.5);
		respawn_array[7].angles = (0, 90, 0);

		foreach (respawn_struct in respawn_array)
		{
			scripts\zm\replaced\utility::register_map_spawn(respawn_struct.origin, respawn_struct.angles, zone);
		}

		// East Town respawns
		origin = (2308.5, -461.5, -34);
		zone = "zone_town_east";
		dist = 5000;

		scripts\zm\replaced\utility::register_map_spawn_group(origin, zone, dist);

		respawn_array = [];

		for (i = 0; i < 8; i++)
		{
			respawn_array[i] = spawnStruct();
		}

		respawn_array[0].origin = (2276, -559, -34);
		respawn_array[0].angles = (0, 180, 0);

		respawn_array[1].origin = (2276, -494, -34);
		respawn_array[1].angles = (0, 180, 0);

		respawn_array[2].origin = (2276, -429, -34);
		respawn_array[2].angles = (0, 180, 0);

		respawn_array[3].origin = (2276, -364, -34);
		respawn_array[3].angles = (0, 180, 0);

		respawn_array[4].origin = (2341, -559, -34);
		respawn_array[4].angles = (0, 180, 0);

		respawn_array[5].origin = (2341, -494, -34);
		respawn_array[5].angles = (0, 180, 0);

		respawn_array[6].origin = (2341, -429, -34);
		respawn_array[6].angles = (0, 180, 0);

		respawn_array[7].origin = (2341, -364, -34);
		respawn_array[7].angles = (0, 180, 0);

		foreach (respawn_struct in respawn_array)
		{
			scripts\zm\replaced\utility::register_map_spawn(respawn_struct.origin, respawn_struct.angles, zone);
		}

		// West Town respawns
		origin = (568.5, -446.5, -34);
		zone = "zone_town_west";
		dist = 5000;

		scripts\zm\replaced\utility::register_map_spawn_group(origin, zone, dist);

		respawn_array = [];

		for (i = 0; i < 8; i++)
		{
			respawn_array[i] = spawnStruct();
		}

		respawn_array[0].origin = (601, -349, -34);
		respawn_array[0].angles = (0, 0, 0);

		respawn_array[1].origin = (601, -414, -34);
		respawn_array[1].angles = (0, 0, 0);

		respawn_array[2].origin = (601, -479, -34);
		respawn_array[2].angles = (0, 0, 0);

		respawn_array[3].origin = (601, -544, -34);
		respawn_array[3].angles = (0, 0, 0);

		respawn_array[4].origin = (536, -349, -34);
		respawn_array[4].angles = (0, 0, 0);

		respawn_array[5].origin = (536, -414, -34);
		respawn_array[5].angles = (0, 0, 0);

		respawn_array[6].origin = (536, -479, -34);
		respawn_array[6].angles = (0, 0, 0);

		respawn_array[7].origin = (536, -544, -34);
		respawn_array[7].angles = (0, 0, 0);

		foreach (respawn_struct in respawn_array)
		{
			scripts\zm\replaced\utility::register_map_spawn(respawn_struct.origin, respawn_struct.angles, zone);
		}
	}
}

zombie_spawn_location_changes()
{
	foreach (zone in level.zones)
	{
		foreach (spawn_location in zone.spawn_locations)
		{
			if (spawn_location.origin == (9963, 8025, -554.9))
			{
				spawn_location.origin += (0, 0, -32);
			}
			else if (spawn_location.origin == (-2202, -6881, -86.6))
			{
				spawn_location.origin += (0, 0, -32);
			}
			else if (spawn_location.origin == (-666, -4962, -66))
			{
				spawn_location.origin += (0, 0, -16);
			}
		}
	}
}

buildable_table_models()
{
	// power switch
	model = spawn("script_model", (12177.3, 8504.51, -731.375));
	model.angles = (0, 88, 90);
	model setmodel("p6_zm_core_panel_02");
	model = spawn("script_model", (12162.3, 8504.51, -731.375));
	model.angles = (0, 92, 90);
	model setmodel("p6_zm_core_panel_02");
	model = spawn("script_model", (12162.3, 8520.51, -731.375));
	model.angles = (0, 92, 90);
	model setmodel("p6_zm_core_panel_02");
	model = spawn("script_model", (12177.3, 8520.51, -731.375));
	model.angles = (0, 88, 90);
	model setmodel("p6_zm_core_panel_02");

	// pack-a-punch
	model = spawn("script_model", (2266.47, -212.901, -303.875));
	model.angles = (0, 0, 0);
	model setmodel("p_rus_crate_metal_1");
	model = spawn("script_model", (2266.47, -212.901, -273.875));
	model.angles = (0, 0, 0);
	model setmodel("p_rus_crate_metal_1");
	model = spawn("script_model", (2266.47, -212.901, -243.875));
	model.angles = (0, 0, 0);
	model setmodel("p_rus_crate_metal_1");
	model = spawn("script_model", (2219.03, -212.725, -243.875));
	model.angles = (0, 0, 0);
	model setmodel("p_rus_crate_metal_2");
	model = spawn("script_model", (2219.03, -212.725, -303.875));
	model.angles = (0, 0, 0);
	model setmodel("p_rus_crate_metal_2");
	model = spawn("script_model", (2219.03, -212.725, -273.875));
	model.angles = (0, 0, 0);
	model setmodel("p_rus_crate_metal_2");
}

cornfield_add_collision()
{
	model = spawn("script_model", (10536, -595, -145));
	model.angles = (0, -35, 0);
	model setmodel("collision_clip_wall_128x128x10");
}

cornfield_spawn_path_nodes()
{
	new_origins = array((7040, -256, -196), (7040, -384, -196), (7040, -512, -196), (7040, -640, -196), (7040, -768, -196), (7168, -256, -196), (7168, -384, -196), (7168, -512, -196), (7168, -640, -196), (7168, -768, -196));

	foreach (origin in new_origins)
	{
		spawn_path_node(origin, (0, 0, 0));
	}
}

path_exploit_fixes()
{
	// town bookstore near jug
	zombie_trigger_origin = (1045, -1521, 128);
	zombie_trigger_radius = 96;
	zombie_trigger_height = 64;
	player_trigger_origin = (1116, -1547, 128);
	player_trigger_radius = 72;
	zombie_goto_point = (1098, -1521, 128);
	level thread maps\mp\zombies\_zm_ffotd::path_exploit_fix(zombie_trigger_origin, zombie_trigger_radius, zombie_trigger_height, player_trigger_origin, player_trigger_radius, zombie_goto_point);
}

power_station_exposure_change()
{
	flag_wait("start_zombie_round_logic");

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			if (!isDefined(player.power_station_exposure_changed))
			{
				player.power_station_exposure_changed = 0;
			}

			spectating_player = player scripts\zm\_zm_reimagined::get_current_spectating_player();

			if (!player.power_station_exposure_changed)
			{
				if (spectating_player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_prr") || spectating_player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_pcr"))
				{
					player.power_station_exposure_changed = 1;

					if (spectating_player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_prr"))
					{
						player thread change_exposure_over_time(3.5, 4, 0.5);
					}
					else
					{
						player thread change_exposure_over_time(3, 4, 0.5);
					}
				}
			}
			else
			{
				if (!(spectating_player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_prr") || spectating_player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_pcr")))
				{
					player.power_station_exposure_changed = 0;

					if (spectating_player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_pow_warehouse"))
					{
						player thread change_exposure_over_time(4, 3, 0.5, 1);
					}
					else
					{
						player thread change_exposure_over_time(4, 3, 0, 1);
					}
				}
			}
		}

		wait 0.05;
	}
}

change_exposure_over_time(start_val, end_val, time, end_tweak = 0)
{
	self notify("change_exposure_over_time");
	self endon("change_exposure_over_time");

	if (!isdefined(self.r_exposureValue))
	{
		self.r_exposureValue = start_val;
		self setClientDvar("r_exposureTweak", 1);
	}

	intervals = time * 20;
	rate = abs(end_val - start_val) / intervals;
	i = 0;

	while (i < intervals)
	{
		if (end_val > start_val)
		{
			self.r_exposureValue += rate;

			if (self.r_exposureValue > end_val)
			{
				self.r_exposureValue = end_val;
			}
		}
		else
		{
			self.r_exposureValue -= rate;

			if (self.r_exposureValue < end_val)
			{
				self.r_exposureValue = end_val;
			}
		}

		self setClientDvar("r_exposureValue", self.r_exposureValue);

		if (self.r_exposureValue == end_val)
		{
			break;
		}

		i++;
		wait 0.05;
	}

	if (end_tweak)
	{
		self.r_exposureValue = undefined;
		self setClientDvar("r_exposureTweak", 0);
	}
}

attach_powerups_to_bus()
{
	if (!isDefined(level.the_bus))
	{
		return;
	}

	while (1)
	{
		level waittill("powerup_dropped", powerup);

		level thread attachpoweruptobus(powerup);
	}
}

attachpoweruptobus(powerup)
{
	if (!isdefined(powerup) || !isdefined(level.the_bus))
	{
		return;
	}

	powerup endon("powerup_grabbed");
	powerup endon("powerup_timedout");

	distanceoutsideofbus = 50.0;
	pos = powerup.origin;
	posinbus = pointonsegmentnearesttopoint(level.the_bus.frontworld, level.the_bus.backworld, pos);
	posdist2 = distance2dsquared(pos, posinbus);

	if (posdist2 > level.the_bus.radius * level.the_bus.radius)
	{
		radiusplus = level.the_bus.radius + distanceoutsideofbus;

		if (posdist2 > radiusplus * radiusplus)
		{
			return;
		}
	}

	powerup.origin_diff = level.the_bus worldtolocalcoords(powerup.origin);

	while (isDefined(powerup))
	{
		powerup.origin = level.the_bus localtoworldcoords(powerup.origin_diff);

		if (isdefined(powerup.waypoint))
		{
			powerup.waypoint.x = powerup.origin[0];
			powerup.waypoint.y = powerup.origin[1];
			powerup.waypoint.z = powerup.origin[2] + 40;
		}

		wait 0.05;
	}
}

bus_hatch_open()
{
	flag_wait("initial_blackscreen_passed");

	level.bus_roof_open = 1;
	level.the_bus notify("hatch_ripped_open");
}