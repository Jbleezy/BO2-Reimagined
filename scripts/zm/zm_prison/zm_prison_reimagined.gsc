#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_utility;

main()
{
	replaceFunc(maps\mp\zm_alcatraz_craftables::init_craftables, scripts\zm\replaced\zm_alcatraz_craftables::init_craftables);
	replaceFunc(maps\mp\zm_alcatraz_craftables::include_craftables, scripts\zm\replaced\zm_alcatraz_craftables::include_craftables);
	replaceFunc(maps\mp\zm_alcatraz_gamemodes::init, scripts\zm\replaced\zm_alcatraz_gamemodes::init);
	replaceFunc(maps\mp\zm_alcatraz_grief_cellblock::zgrief_init, scripts\zm\replaced\zm_alcatraz_grief_cellblock::zgrief_init);
	replaceFunc(maps\mp\zm_alcatraz_grief_cellblock::main, scripts\zm\replaced\zm_alcatraz_grief_cellblock::main);
	replaceFunc(maps\mp\zm_alcatraz_grief_cellblock::magicbox_face_spawn, scripts\zm\replaced\zm_alcatraz_grief_cellblock::magicbox_face_spawn);
	replaceFunc(maps\mp\zm_alcatraz_utility::blundergat_upgrade_station, scripts\zm\replaced\zm_alcatraz_utility::blundergat_upgrade_station);
	replaceFunc(maps\mp\zm_alcatraz_utility::alcatraz_audio_get_mod_type_override, scripts\zm\replaced\zm_alcatraz_utility::alcatraz_audio_get_mod_type_override);
	replaceFunc(maps\mp\zm_alcatraz_utility::check_solo_status, scripts\zm\replaced\zm_alcatraz_utility::check_solo_status);
	replaceFunc(maps\mp\zm_alcatraz_utility::drop_all_barriers, scripts\zm\replaced\zm_alcatraz_utility::drop_all_barriers);
	replaceFunc(maps\mp\zm_alcatraz_sq::dryer_zombies_thread, scripts\zm\replaced\zm_alcatraz_sq::dryer_zombies_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::track_quest_status_thread, scripts\zm\replaced\zm_alcatraz_sq::track_quest_status_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::plane_boarding_thread, scripts\zm\replaced\zm_alcatraz_sq::plane_boarding_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::plane_flight_thread, scripts\zm\replaced\zm_alcatraz_sq::plane_flight_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::manage_electric_chairs, scripts\zm\replaced\zm_alcatraz_sq::manage_electric_chairs);
	replaceFunc(maps\mp\zm_alcatraz_traps::init_fan_trap_trigs, scripts\zm\replaced\zm_alcatraz_traps::init_fan_trap_trigs);
	replaceFunc(maps\mp\zm_alcatraz_traps::init_acid_trap_trigs, scripts\zm\replaced\zm_alcatraz_traps::init_acid_trap_trigs);
	replaceFunc(maps\mp\zm_alcatraz_traps::zombie_acid_damage, scripts\zm\replaced\zm_alcatraz_traps::zombie_acid_damage);
	replaceFunc(maps\mp\zm_alcatraz_traps::player_acid_damage, scripts\zm\replaced\zm_alcatraz_traps::player_acid_damage);
	replaceFunc(maps\mp\zm_alcatraz_traps::tower_trap_trigger_think, scripts\zm\replaced\zm_alcatraz_traps::tower_trap_trigger_think);
	replaceFunc(maps\mp\zm_alcatraz_travel::move_gondola, scripts\zm\replaced\zm_alcatraz_travel::move_gondola);
	replaceFunc(maps\mp\zm_alcatraz_weap_quest::grief_soul_catcher_state_manager, scripts\zm\replaced\zm_alcatraz_weap_quest::grief_soul_catcher_state_manager);
	replaceFunc(maps\mp\zm_alcatraz_weap_quest::hellhole_projectile_watch, scripts\zm\replaced\zm_alcatraz_weap_quest::hellhole_projectile_watch);
	replaceFunc(maps\mp\zm_alcatraz_distance_tracking::delete_zombie_noone_looking, scripts\zm\replaced\zm_alcatraz_distance_tracking::delete_zombie_noone_looking);
	replaceFunc(maps\mp\zm_prison::working_zone_init, scripts\zm\replaced\zm_prison::working_zone_init);
	replaceFunc(maps\mp\zm_prison::custom_vending_precaching, scripts\zm\replaced\zm_prison::custom_vending_precaching);
	replaceFunc(maps\mp\zm_prison::delete_perk_machine_clip, scripts\zm\replaced\zm_prison::delete_perk_machine_clip);
	replaceFunc(maps\mp\zm_prison_spoon::init, scripts\zm\replaced\zm_prison_spoon::init);
	replaceFunc(maps\mp\zm_prison_spoon::give_player_spoon_upon_receipt, scripts\zm\replaced\zm_prison_spoon::give_player_spoon_upon_receipt);
	replaceFunc(maps\mp\zm_prison_spoon::dip_the_spoon, scripts\zm\replaced\zm_prison_spoon::dip_the_spoon);
	replaceFunc(maps\mp\zm_prison_spoon::extra_death_func_to_check_for_splat_death, scripts\zm\replaced\zm_prison_spoon::extra_death_func_to_check_for_splat_death);
	replaceFunc(maps\mp\zm_prison_sq_bg::give_sq_bg_reward, scripts\zm\replaced\zm_prison_sq_bg::give_sq_bg_reward);
	replaceFunc(maps\mp\zm_prison_sq_final::stage_one, scripts\zm\replaced\zm_prison_sq_final::stage_one);
	replaceFunc(maps\mp\zm_prison_sq_final::final_flight_trigger, scripts\zm\replaced\zm_prison_sq_final::final_flight_trigger);
	replaceFunc(maps\mp\zm_prison_sq_wth::sq_is_weapon_sniper, scripts\zm\replaced\zm_prison_sq_wth::sq_is_weapon_sniper);
	replaceFunc(maps\mp\zombies\_zm_afterlife::init_player, scripts\zm\replaced\_zm_afterlife::init_player);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_add, scripts\zm\replaced\_zm_afterlife::afterlife_add);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_laststand, scripts\zm\replaced\_zm_afterlife::afterlife_laststand);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_revive_trigger_think, scripts\zm\replaced\_zm_afterlife::afterlife_revive_trigger_think);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_revive_do_revive, scripts\zm\replaced\_zm_afterlife::afterlife_revive_do_revive);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_corpse_cleanup, scripts\zm\replaced\_zm_afterlife::afterlife_corpse_cleanup);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_player_damage_callback, scripts\zm\replaced\_zm_afterlife::afterlife_player_damage_callback);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_save_loadout, scripts\zm\replaced\_zm_afterlife::afterlife_save_loadout);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_give_loadout, scripts\zm\replaced\_zm_afterlife::afterlife_give_loadout);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_trigger_think, scripts\zm\replaced\_zm_afterlife::afterlife_trigger_think);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_can_revive, scripts\zm\replaced\_zm_afterlife::afterlife_can_revive);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_doors_open, scripts\zm\replaced\_zm_afterlife::afterlife_doors_open);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_doors_close, scripts\zm\replaced\_zm_afterlife::afterlife_doors_close);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::init, scripts\zm\replaced\_zm_ai_brutus::init);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_round_tracker, scripts\zm\replaced\_zm_ai_brutus::brutus_round_tracker);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::get_brutus_spawn_pos_val, scripts\zm\replaced\_zm_ai_brutus::get_brutus_spawn_pos_val);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_spawn, scripts\zm\replaced\_zm_ai_brutus::brutus_spawn);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_health_increases, scripts\zm\replaced\_zm_ai_brutus::brutus_health_increases);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_cleanup_at_end_of_grief_round, scripts\zm\replaced\_zm_ai_brutus::brutus_cleanup_at_end_of_grief_round);
	replaceFunc(maps\mp\zombies\_zm_craftables::choose_open_craftable, scripts\zm\replaced\_zm_craftables::choose_open_craftable);
	replaceFunc(maps\mp\zombies\_zm_craftables::craftable_use_hold_think_internal, scripts\zm\replaced\_zm_craftables::craftable_use_hold_think_internal);
	replaceFunc(maps\mp\zombies\_zm_craftables::player_progress_bar, scripts\zm\replaced\_zm_craftables::player_progress_bar);
	replaceFunc(maps\mp\zombies\_zm_craftables::update_open_table_status, scripts\zm\replaced\_zm_craftables::update_open_table_status);
	replaceFunc(maps\mp\zombies\_zm_craftables::onbeginuseuts, scripts\zm\replaced\_zm_craftables::onbeginuseuts);
	replaceFunc(maps\mp\zombies\_zm_riotshield_prison::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield_prison::doriotshielddeploy);
	replaceFunc(maps\mp\zombies\_zm_riotshield_prison::trackriotshield, scripts\zm\replaced\_zm_riotshield_prison::trackriotshield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield_prison::player_damage_shield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::riotshield_fling_zombie, scripts\zm\replaced\_zm_weap_riotshield_prison::riotshield_fling_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::riotshield_knockdown_zombie, scripts\zm\replaced\_zm_weap_riotshield_prison::riotshield_knockdown_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::init, scripts\zm\replaced\_zm_weap_blundersplat::init);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::wait_for_blundersplat_fired, scripts\zm\replaced\_zm_weap_blundersplat::wait_for_blundersplat_fired);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::wait_for_blundersplat_upgraded_fired, scripts\zm\replaced\_zm_weap_blundersplat::wait_for_blundersplat_upgraded_fired);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::_titus_target_animate_and_die, scripts\zm\replaced\_zm_weap_blundersplat::_titus_target_animate_and_die);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::calculate_tomahawk_damage, scripts\zm\replaced\_zm_weap_tomahawk::calculate_tomahawk_damage);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::get_grenade_charge_power, scripts\zm\replaced\_zm_weap_tomahawk::get_grenade_charge_power);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_attack_zombies, scripts\zm\replaced\_zm_weap_tomahawk::tomahawk_attack_zombies);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_return_player, scripts\zm\replaced\_zm_weap_tomahawk::tomahawk_return_player);

	if (!is_gametype_active("zclassic") && !is_gametype_active("zgrief"))
	{
		level.zombiemode_using_divetonuke_perk = 1;
		maps\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();

		level.zombiemode_using_additionalprimaryweapon_perk = 1;

		precacheModel("p6_zm_al_shock_box_on");
	}

	if (!is_gametype_active("zclassic"))
	{
		level.zombiemode_using_electric_cherry_perk = 1;
		maps\mp\zombies\_zm_perk_electric_cherry::enable_electric_cherry_perk_for_level();

		level thread turn_on_electric_cherry();
	}

	door_changes();
}

init()
{
	precacheModel("collision_geo_32x32x128_standard");
	precacheModel("collision_player_sphere_32");

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::check_for_special_weapon_limit_exist;
	level.custom_door_buy_check = ::door_buy_afterlife_check;

	level.zombie_vars["below_world_check"] = -15000;

	maps\mp\zombies\_zm::spawn_life_brush((94, 6063, 240), 256, 256);

	alcatraz_add_player_dialogue("player", "perk", "specialty_flakjacket", "perk_generic", undefined, 100);
	alcatraz_add_player_dialogue("player", "perk", "specialty_additionalprimaryweapon", "perk_generic", undefined, 100);

	player_initial_spawn_override();
	player_respawn_override();
	docks_gates_remain_open();

	level thread maps\mp\_sticky_grenade::init();

	level thread updatecraftables();
	level thread docks_teleporter();
	level thread grief_brutus_spawn_after_time();
}

door_changes()
{
	num = 0;
	targets = getentarray("cellblock_start_door", "targetname");
	zombie_doors = getentarray("zombie_door", "targetname");

	for (i = 0; i < zombie_doors.size; i++)
	{
		if (isdefined(zombie_doors[i].target) && zombie_doors[i].target == "cellblock_start_door")
		{
			zombie_doors[i].zombie_cost = 750;
			zombie_doors[i].target += num;
			targets[num].targetname += num;
			targets[num + 2].targetname += num;
			num++;
		}
	}
}

turn_on_electric_cherry()
{
	flag_wait("initial_blackscreen_passed");

	wait 1;

	level notify("electric_cherry_on");
}

zombie_init_done()
{
	self.meleedamage = 50;
	self.allowpain = 0;
	self setphysparams(15, 0, 48);
}

check_for_special_weapon_limit_exist(weapon)
{
	if (weapon != "blundergat_zm" && weapon != "minigun_alcatraz_zm")
	{
		return 1;
	}

	players = get_players();
	count = 0;

	if (weapon == "blundergat_zm")
	{
		if (self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade("blundersplat_zm"))
		{
			return 0;
		}

		if (self afterlife_weapon_limit_check("blundergat_zm"))
		{
			return 0;
		}

		limit = level.limited_weapons["blundergat_zm"];
	}
	else
	{
		if (self afterlife_weapon_limit_check("minigun_alcatraz_zm"))
		{
			return 0;
		}

		limit = level.limited_weapons["minigun_alcatraz_zm"];
	}

	i = 0;

	while (i < players.size)
	{
		if (weapon == "blundergat_zm")
		{
			if (players[i] maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade("blundersplat_zm") || isDefined(players[i].is_pack_splatting) && players[i].is_pack_splatting)
			{
				count++;
				i++;
				continue;
			}
		}
		else
		{
			if (players[i] afterlife_weapon_limit_check(weapon))
			{
				count++;
			}
		}

		i++;
	}

	if (count >= limit)
	{
		return 0;
	}

	return 1;
}

door_buy_afterlife_check(door)
{
	if (isDefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](self);
	}

	return true;
}

player_initial_spawn_override()
{
	initial_spawns = getstructarray("initial_spawn", "script_noteworthy");
	remove_initial_spawns = [];

	if (level.scr_zm_map_start_location == "cellblock")
	{
		foreach (initial_spawn in initial_spawns)
		{
			if (initial_spawn.origin == (704, 9672, 1470) || initial_spawn.origin == (1008, 9684, 1470))
			{
				remove_initial_spawns[remove_initial_spawns.size] = initial_spawn;
			}
			else if (initial_spawn.origin == (704, 9712, 1471) || initial_spawn.origin == (1008, 9720, 1470))
			{
				initial_spawn.origin += (0, -16, 0);
			}
			else if (initial_spawn.origin == (704, 9632, 1470) || initial_spawn.origin == (1008, 9640, 1470))
			{
				initial_spawn.origin += (0, 16, 0);
			}

			// prevents spawning up top in 3rd Floor zone due to not being enough height clearance
			initial_spawn.origin += (0, 0, -16);
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

	foreach (respawn_point in respawn_points)
	{
		if (respawn_point.script_noteworthy == "zone_cafeteria")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");
			remove_respawn_array = [];

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (2536, 9704, 1360))
				{
					// respawn is in acid trap
					remove_respawn_array[remove_respawn_array.size] = respawn;
				}
			}

			foreach (respawn in remove_respawn_array)
			{
				arrayremovevalue(respawn_array, respawn);
			}
		}
	}
}

updatecraftables()
{
	flag_wait("start_zombie_round_logic");

	wait 1;

	foreach (stub in level._unitriggers.trigger_stubs)
	{
		if (IsDefined(stub.equipname) && (stub.equipname == "open_table" || stub.equipname == "alcatraz_shield_zm" || stub.equipname == "packasplat"))
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

	if (can_use && is_true(self.stub.crafted) && !is_true(self.stub.is_locked))
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

docks_gates_remain_open()
{
	if (flag_exists("docks_gates_remain_open"))
	{
		flag_set("docks_gates_remain_open");
	}
}

docks_teleporter()
{
	flag_wait("initial_blackscreen_passed");

	teleporter = getstruct("docks_teleporter", "targetname");
	teleporter_end = getstruct(teleporter.target, "targetname");

	trig = spawn("trigger_radius", teleporter.origin, 0, teleporter.radius, teleporter.height);

	while (1)
	{
		trig waittill("trigger", player);

		height_diff = player.origin[2] - groundpos(player.origin)[2];

		playsoundatposition("zmb_afterlife_zombie_warp_out", player.origin);
		player setorigin(teleporter_end.origin + (0, 0, height_diff));
	}
}

grief_brutus_spawn_after_time()
{
	if (!is_encounter())
	{
		return;
	}

	level endon("end_game");

	level waittill("restart_round_start");

	while (1)
	{
		time = randomIntRange(240, 360);

		wait time;

		maps\mp\zombies\_zm_ai_brutus::attempt_brutus_spawn(1);

		while (level.brutus_count <= 0)
		{
			wait 1;
		}

		while (level.brutus_count > 0)
		{
			wait 1;
		}
	}
}