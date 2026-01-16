#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

main()
{
	setDvar("scr_disablePlutoniumFixes", 1);

	replaceFunc(common_scripts\utility::struct_class_init, scripts\zm\replaced\utility::struct_class_init);
	replaceFunc(maps\mp\animscripts\zm_melee::meleecombat, scripts\zm\replaced\zm_melee::meleecombat);
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, scripts\zm\replaced\_zm_utility::wait_network_frame);
	replaceFunc(maps\mp\animscripts\traverse\zm_shared::dotraverse, scripts\zm\replaced\zm_shared::dotraverse);
	replaceFunc(maps\mp\gametypes_zm\_damagefeedback::onplayerconnect, scripts\zm\replaced\_damagefeedback::onplayerconnect);
	replaceFunc(maps\mp\gametypes_zm\_globallogic_player::callback_playerconnect, scripts\zm\replaced\_globallogic_player::callback_playerconnect);
	replaceFunc(maps\mp\gametypes_zm\_hud::fadetoblackforxsec, scripts\zm\replaced\_hud::fadetoblackforxsec);
	replaceFunc(maps\mp\gametypes_zm\_hud_message::onplayerconnect, scripts\zm\replaced\_hud_message::onplayerconnect);
	replaceFunc(maps\mp\gametypes_zm\_zm_gametype::hide_gump_loading_for_hotjoiners, scripts\zm\replaced\_zm_gametype::hide_gump_loading_for_hotjoiners);
	replaceFunc(maps\mp\zombies\_zm::init_client_flags, scripts\zm\replaced\_zm::init_client_flags);
	replaceFunc(maps\mp\zombies\_zm::init_fx, scripts\zm\replaced\_zm::init_fx);
	replaceFunc(maps\mp\zombies\_zm::round_start, scripts\zm\replaced\_zm::round_start);
	replaceFunc(maps\mp\zombies\_zm::round_think, scripts\zm\replaced\_zm::round_think);
	replaceFunc(maps\mp\zombies\_zm::round_spawn_failsafe, scripts\zm\replaced\_zm::round_spawn_failsafe);
	replaceFunc(maps\mp\zombies\_zm::ai_calculate_health, scripts\zm\replaced\_zm::ai_calculate_health);
	replaceFunc(maps\mp\zombies\_zm::onallplayersready, scripts\zm\replaced\_zm::onallplayersready);
	replaceFunc(maps\mp\zombies\_zm::last_stand_pistol_rank_init, scripts\zm\replaced\_zm::last_stand_pistol_rank_init);
	replaceFunc(maps\mp\zombies\_zm::last_stand_best_pistol, scripts\zm\replaced\_zm::last_stand_best_pistol);
	replaceFunc(maps\mp\zombies\_zm::can_track_ammo, scripts\zm\replaced\_zm::can_track_ammo);
	replaceFunc(maps\mp\zombies\_zm::take_additionalprimaryweapon, scripts\zm\replaced\_zm::take_additionalprimaryweapon);
	replaceFunc(maps\mp\zombies\_zm::check_for_valid_spawn_near_team, scripts\zm\replaced\_zm::check_for_valid_spawn_near_team);
	replaceFunc(maps\mp\zombies\_zm::get_valid_spawn_location, scripts\zm\replaced\_zm::get_valid_spawn_location);
	replaceFunc(maps\mp\zombies\_zm::player_spawn_protection, scripts\zm\replaced\_zm::player_spawn_protection);
	replaceFunc(maps\mp\zombies\_zm::actor_damage_override, scripts\zm\replaced\_zm::actor_damage_override);
	replaceFunc(maps\mp\zombies\_zm::callback_playerdamage, scripts\zm\replaced\_zm::callback_playerdamage);
	replaceFunc(maps\mp\zombies\_zm::player_damage_override, scripts\zm\replaced\_zm::player_damage_override);
	replaceFunc(maps\mp\zombies\_zm::callback_playerlaststand, scripts\zm\replaced\_zm::callback_playerlaststand);
	replaceFunc(maps\mp\zombies\_zm::player_laststand, scripts\zm\replaced\_zm::player_laststand);
	replaceFunc(maps\mp\zombies\_zm::last_stand_pistol_swap, scripts\zm\replaced\_zm::last_stand_pistol_swap);
	replaceFunc(maps\mp\zombies\_zm::last_stand_restore_pistol_ammo, scripts\zm\replaced\_zm::last_stand_restore_pistol_ammo);
	replaceFunc(maps\mp\zombies\_zm::wait_and_revive, scripts\zm\replaced\_zm::wait_and_revive);
	replaceFunc(maps\mp\zombies\_zm::player_revive_monitor, scripts\zm\replaced\_zm::player_revive_monitor);
	replaceFunc(maps\mp\zombies\_zm::player_out_of_playable_area_monitor, scripts\zm\replaced\_zm::player_out_of_playable_area_monitor);
	replaceFunc(maps\mp\zombies\_zm::player_too_many_weapons_monitor, scripts\zm\replaced\_zm::player_too_many_weapons_monitor);
	replaceFunc(maps\mp\zombies\_zm::end_game, scripts\zm\replaced\_zm::end_game);
	replaceFunc(maps\mp\zombies\_zm::check_quickrevive_for_hotjoin, scripts\zm\replaced\_zm::check_quickrevive_for_hotjoin);
	replaceFunc(maps\mp\zombies\_zm_audio::zmbvoxadd, scripts\zm\replaced\_zm_audio::zmbvoxadd);
	replaceFunc(maps\mp\zombies\_zm_audio::create_and_play_dialog, scripts\zm\replaced\_zm_audio::create_and_play_dialog);
	replaceFunc(maps\mp\zombies\_zm_audio_announcer::playleaderdialogonplayer, scripts\zm\replaced\_zm_audio_announcer::playleaderdialogonplayer);
	replaceFunc(maps\mp\zombies\_zm_stats::set_global_stat, scripts\zm\replaced\_zm_stats::set_global_stat);
	replaceFunc(maps\mp\zombies\_zm_playerhealth::playerhealthregen, scripts\zm\replaced\_zm_playerhealth::playerhealthregen);
	replaceFunc(maps\mp\zombies\_zm_utility::init_player_offhand_weapons, scripts\zm\replaced\_zm_utility::init_player_offhand_weapons);
	replaceFunc(maps\mp\zombies\_zm_utility::give_start_weapon, scripts\zm\replaced\_zm_utility::give_start_weapon);
	replaceFunc(maps\mp\zombies\_zm_utility::is_headshot, scripts\zm\replaced\_zm_utility::is_headshot);
	replaceFunc(maps\mp\zombies\_zm_utility::shock_onpain, scripts\zm\replaced\_zm_utility::shock_onpain);
	replaceFunc(maps\mp\zombies\_zm_utility::create_zombie_point_of_interest, scripts\zm\replaced\_zm_utility::create_zombie_point_of_interest);
	replaceFunc(maps\mp\zombies\_zm_utility::create_zombie_point_of_interest_attractor_positions, scripts\zm\replaced\_zm_utility::create_zombie_point_of_interest_attractor_positions);
	replaceFunc(maps\mp\zombies\_zm_utility::get_current_zone, scripts\zm\replaced\_zm_utility::get_current_zone);
	replaceFunc(maps\mp\zombies\_zm_utility::is_alt_weapon, scripts\zm\replaced\_zm_utility::is_alt_weapon);
	replaceFunc(maps\mp\zombies\_zm_utility::is_temporary_zombie_weapon, scripts\zm\replaced\_zm_utility::is_temporary_zombie_weapon);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, scripts\zm\replaced\_zm_utility::wait_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::track_players_intersection_tracker, scripts\zm\replaced\_zm_utility::track_players_intersection_tracker);
	replaceFunc(maps\mp\zombies\_zm_utility::place_navcard, scripts\zm\replaced\_zm_utility::place_navcard);
	replaceFunc(maps\mp\zombies\_zm_zonemgr::create_spawner_list, scripts\zm\replaced\_zm_zonemgr::create_spawner_list);
	replaceFunc(maps\mp\zombies\_zm_ffotd::ffotd_melee_miss_func, scripts\zm\replaced\_zm_ffotd::ffotd_melee_miss_func);
	replaceFunc(maps\mp\zombies\_zm_score::add_to_player_score, scripts\zm\replaced\_zm_score::add_to_player_score);
	replaceFunc(maps\mp\zombies\_zm_score::minus_to_player_score, scripts\zm\replaced\_zm_score::minus_to_player_score);
	replaceFunc(maps\mp\zombies\_zm_score::player_add_points_kill_bonus, scripts\zm\replaced\_zm_score::player_add_points_kill_bonus);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_trigger_think, scripts\zm\replaced\_zm_laststand::revive_trigger_think);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_do_revive, scripts\zm\replaced\_zm_laststand::revive_do_revive);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_give_back_weapons, scripts\zm\replaced\_zm_laststand::revive_give_back_weapons);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_hud_think, scripts\zm\replaced\_zm_laststand::revive_hud_think);
	replaceFunc(maps\mp\zombies\_zm_laststand::auto_revive, scripts\zm\replaced\_zm_laststand::auto_revive);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_hud_create, scripts\zm\replaced\_zm_laststand::revive_hud_create);
	replaceFunc(maps\mp\zombies\_zm_blockers::door_buy, scripts\zm\replaced\_zm_blockers::door_buy);
	replaceFunc(maps\mp\zombies\_zm_blockers::door_opened, scripts\zm\replaced\_zm_blockers::door_opened);
	replaceFunc(maps\mp\zombies\_zm_blockers::player_fails_blocker_repair_trigger_preamble, scripts\zm\replaced\_zm_blockers::player_fails_blocker_repair_trigger_preamble);
	replaceFunc(maps\mp\zombies\_zm_weapons::init_weapon_upgrade, scripts\zm\replaced\_zm_weapons::init_weapon_upgrade);
	replaceFunc(maps\mp\zombies\_zm_weapons::add_dynamic_wallbuy, scripts\zm\replaced\_zm_weapons::add_dynamic_wallbuy);
	replaceFunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, scripts\zm\replaced\_zm_weapons::get_pack_a_punch_weapon_options);
	replaceFunc(maps\mp\zombies\_zm_weapons::weapon_give, scripts\zm\replaced\_zm_weapons::weapon_give);
	replaceFunc(maps\mp\zombies\_zm_weapons::ammo_give, scripts\zm\replaced\_zm_weapons::ammo_give);
	replaceFunc(maps\mp\zombies\_zm_weapons::get_upgraded_ammo_cost, scripts\zm\replaced\_zm_weapons::get_upgraded_ammo_cost);
	replaceFunc(maps\mp\zombies\_zm_weapons::makegrenadedudanddestroy, scripts\zm\replaced\_zm_weapons::makegrenadedudanddestroy);
	replaceFunc(maps\mp\zombies\_zm_weapons::weaponobjects_on_player_connect_override_internal, scripts\zm\replaced\_zm_weapons::weaponobjects_on_player_connect_override_internal);
	replaceFunc(maps\mp\zombies\_zm_weapons::setupretrievablehintstrings, scripts\zm\replaced\_zm_weapons::setupretrievablehintstrings);
	replaceFunc(maps\mp\zombies\_zm_weapons::createballisticknifewatcher_zm, scripts\zm\replaced\_zm_weapons::createballisticknifewatcher_zm);
	replaceFunc(maps\mp\zombies\_zm_weapons::weapon_spawn_think, scripts\zm\replaced\_zm_weapons::weapon_spawn_think);
	replaceFunc(maps\mp\zombies\_zm_weapons::weapon_set_first_time_hint, scripts\zm\replaced\_zm_weapons::weapon_set_first_time_hint);
	replaceFunc(maps\mp\zombies\_zm_weapons::get_player_weapondata, scripts\zm\replaced\_zm_weapons::get_player_weapondata);
	replaceFunc(maps\mp\zombies\_zm_weapons::limited_weapon_below_quota, scripts\zm\replaced\_zm_weapons::limited_weapon_below_quota);
	replaceFunc(maps\mp\zombies\_zm_weapons::get_nonalternate_weapon, scripts\zm\replaced\_zm_weapons::get_nonalternate_weapon);
	replaceFunc(maps\mp\zombies\_zm_weapons::switch_from_alt_weapon, scripts\zm\replaced\_zm_weapons::switch_from_alt_weapon);
	replaceFunc(maps\mp\zombies\_zm_weapons::give_fallback_weapon, scripts\zm\replaced\_zm_weapons::give_fallback_weapon);
	replaceFunc(maps\mp\zombies\_zm_magicbox::treasure_chest_init, scripts\zm\replaced\_zm_magicbox::treasure_chest_init);
	replaceFunc(maps\mp\zombies\_zm_magicbox::init_starting_chest_location, scripts\zm\replaced\_zm_magicbox::init_starting_chest_location);
	replaceFunc(maps\mp\zombies\_zm_magicbox::decide_hide_show_hint, scripts\zm\replaced\_zm_magicbox::decide_hide_show_hint);
	replaceFunc(maps\mp\zombies\_zm_magicbox::trigger_visible_to_player, scripts\zm\replaced\_zm_magicbox::trigger_visible_to_player);
	replaceFunc(maps\mp\zombies\_zm_magicbox::can_buy_weapon, scripts\zm\replaced\_zm_magicbox::can_buy_weapon);
	replaceFunc(maps\mp\zombies\_zm_magicbox::weapon_is_dual_wield, scripts\zm\replaced\_zm_magicbox::weapon_is_dual_wield);
	replaceFunc(maps\mp\zombies\_zm_perks::perks_register_clientfield, scripts\zm\replaced\_zm_perks::perks_register_clientfield);
	replaceFunc(maps\mp\zombies\_zm_perks::default_vending_precaching, scripts\zm\replaced\_zm_perks::default_vending_precaching);
	replaceFunc(maps\mp\zombies\_zm_perks::vending_trigger_think, scripts\zm\replaced\_zm_perks::vending_trigger_think);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_give_bottle_end, scripts\zm\replaced\_zm_perks::perk_give_bottle_end);
	replaceFunc(maps\mp\zombies\_zm_perks::vending_weapon_upgrade, scripts\zm\replaced\_zm_perks::vending_weapon_upgrade);
	replaceFunc(maps\mp\zombies\_zm_perks::turnonpapsounds, scripts\zm\replaced\_zm_perks::turnonpapsounds);
	replaceFunc(maps\mp\zombies\_zm_perks::give_perk, scripts\zm\replaced\_zm_perks::give_perk);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_think, scripts\zm\replaced\_zm_perks::perk_think);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg, scripts\zm\replaced\_zm_perks::perk_set_max_health_if_jugg);
	replaceFunc(maps\mp\zombies\_zm_perks::initialize_custom_perk_arrays, scripts\zm\replaced\_zm_perks::initialize_custom_perk_arrays);
	replaceFunc(maps\mp\zombies\_zm_perks::turn_marathon_on, scripts\zm\replaced\_zm_perks::turn_marathon_on);
	replaceFunc(maps\mp\zombies\_zm_perks::turn_tombstone_on, scripts\zm\replaced\_zm_perks::turn_tombstone_on);
	replaceFunc(maps\mp\zombies\_zm_perks::turn_chugabud_on, scripts\zm\replaced\_zm_perks::turn_chugabud_on);
	replaceFunc(maps\mp\zombies\_zm_perks::wait_for_player_to_take, scripts\zm\replaced\_zm_perks::wait_for_player_to_take);
	replaceFunc(maps\mp\zombies\_zm_perks::check_player_has_perk, scripts\zm\replaced\_zm_perks::check_player_has_perk);
	replaceFunc(maps\mp\zombies\_zm_perks::set_perk_clientfield, scripts\zm\replaced\_zm_perks::set_perk_clientfield);
	replaceFunc(maps\mp\zombies\_zm_perks::get_perk_array, scripts\zm\replaced\_zm_perks::get_perk_array);
	replaceFunc(maps\mp\zombies\_zm_perks::do_initial_power_off_callback, scripts\zm\replaced\_zm_perks::do_initial_power_off_callback);
	replaceFunc(maps\mp\zombies\_zm_perks::has_perk_paused, scripts\zm\replaced\_zm_perks::has_perk_paused);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_pause, scripts\zm\replaced\_zm_perks::perk_pause);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_unpause, scripts\zm\replaced\_zm_perks::perk_unpause);
	replaceFunc(maps\mp\zombies\_zm_buildables::buildable_place_think, scripts\zm\replaced\_zm_buildables::buildable_place_think);
	replaceFunc(maps\mp\zombies\_zm_buildables::buildablestub_update_prompt, scripts\zm\replaced\_zm_buildables::buildablestub_update_prompt);
	replaceFunc(maps\mp\zombies\_zm_buildables::player_progress_bar, scripts\zm\replaced\_zm_buildables::player_progress_bar);
	replaceFunc(maps\mp\zombies\_zm_power::standard_powered_items, scripts\zm\replaced\_zm_power::standard_powered_items);
	replaceFunc(maps\mp\zombies\_zm_powerups::powerup_drop, scripts\zm\replaced\_zm_powerups::powerup_drop);
	replaceFunc(maps\mp\zombies\_zm_powerups::powerup_timeout, scripts\zm\replaced\_zm_powerups::powerup_timeout);
	replaceFunc(maps\mp\zombies\_zm_powerups::powerup_move, scripts\zm\replaced\_zm_powerups::powerup_move);
	replaceFunc(maps\mp\zombies\_zm_powerups::get_next_powerup, scripts\zm\replaced\_zm_powerups::get_next_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::powerup_grab, scripts\zm\replaced\_zm_powerups::powerup_grab);
	replaceFunc(maps\mp\zombies\_zm_powerups::full_ammo_powerup, scripts\zm\replaced\_zm_powerups::full_ammo_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::nuke_powerup, scripts\zm\replaced\_zm_powerups::nuke_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::insta_kill_powerup, scripts\zm\replaced\_zm_powerups::insta_kill_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::double_points_powerup, scripts\zm\replaced\_zm_powerups::double_points_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::func_should_drop_fire_sale, scripts\zm\replaced\_zm_powerups::func_should_drop_fire_sale);
	replaceFunc(maps\mp\zombies\_zm_powerups::powerup_hud_monitor, scripts\zm\replaced\_zm_powerups::powerup_hud_monitor);
	replaceFunc(maps\mp\zombies\_zm_pers_upgrades::is_pers_system_disabled, scripts\zm\replaced\_zm_pers_upgrades::is_pers_system_disabled);
	replaceFunc(maps\mp\zombies\_zm_pers_upgrades_system::check_pers_upgrade, scripts\zm\replaced\_zm_pers_upgrades_system::check_pers_upgrade);
	replaceFunc(maps\mp\zombies\_zm_traps::player_elec_damage, scripts\zm\replaced\_zm_traps::player_elec_damage);
	replaceFunc(maps\mp\zombies\_zm_equipment::show_equipment_hint, scripts\zm\replaced\_zm_equipment::show_equipment_hint);
	replaceFunc(maps\mp\zombies\_zm_equipment::placed_equipment_think, scripts\zm\replaced\_zm_equipment::placed_equipment_think);
	replaceFunc(maps\mp\zombies\_zm_equipment::equipment_take, scripts\zm\replaced\_zm_equipment::equipment_take);
	replaceFunc(maps\mp\zombies\_zm_equipment::limited_equipment_in_use, scripts\zm\replaced\_zm_equipment::limited_equipment_in_use);
	replaceFunc(maps\mp\zombies\_zm_clone::spawn_player_clone, scripts\zm\replaced\_zm_clone::spawn_player_clone);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_damage, scripts\zm\replaced\_zm_spawner::zombie_damage);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_gib_on_damage, scripts\zm\replaced\_zm_spawner::zombie_gib_on_damage);
	replaceFunc(maps\mp\zombies\_zm_spawner::head_should_gib, scripts\zm\replaced\_zm_spawner::head_should_gib);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_death_animscript, scripts\zm\replaced\_zm_spawner::zombie_death_animscript);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_can_drop_powerups, scripts\zm\replaced\_zm_spawner::zombie_can_drop_powerups);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area, scripts\zm\replaced\_zm_spawner::zombie_complete_emerging_into_playable_area);
	replaceFunc(maps\mp\zombies\_zm_spawner::get_number_variants, scripts\zm\replaced\_zm_spawner::get_number_variants);
	replaceFunc(maps\mp\zombies\_zm_ai_basic::find_flesh, scripts\zm\replaced\_zm_ai_basic::find_flesh);
	replaceFunc(maps\mp\zombies\_zm_ai_basic::inert_wakeup, scripts\zm\replaced\_zm_ai_basic::inert_wakeup);
	replaceFunc(maps\mp\zombies\_zm_ai_dogs::enable_dog_rounds, scripts\zm\replaced\_zm_ai_dogs::enable_dog_rounds);
	replaceFunc(maps\mp\zombies\_zm_ai_dogs::special_dog_spawn, scripts\zm\replaced\_zm_ai_dogs::special_dog_spawn);
	replaceFunc(maps\mp\zombies\_zm_ai_dogs::waiting_for_next_dog_spawn, scripts\zm\replaced\_zm_ai_dogs::waiting_for_next_dog_spawn);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::init, scripts\zm\replaced\_zm_melee_weapon::init);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::change_melee_weapon, scripts\zm\replaced\_zm_melee_weapon::change_melee_weapon);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::give_melee_weapon, scripts\zm\replaced\_zm_melee_weapon::give_melee_weapon);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::melee_weapon_think, scripts\zm\replaced\_zm_melee_weapon::melee_weapon_think);
	replaceFunc(maps\mp\zombies\_zm_weap_ballistic_knife::init, scripts\zm\replaced\_zm_weap_ballistic_knife::init);
	replaceFunc(maps\mp\zombies\_zm_weap_ballistic_knife::watch_use_trigger, scripts\zm\replaced\_zm_weap_ballistic_knife::watch_use_trigger);
	replaceFunc(maps\mp\zombies\_zm_weap_ballistic_knife::pick_up, scripts\zm\replaced\_zm_weap_ballistic_knife::pick_up);
	replaceFunc(maps\mp\zombies\_zm_weap_claymore::claymore_watch, scripts\zm\replaced\_zm_weap_claymore::claymore_watch);
	replaceFunc(maps\mp\zombies\_zm_weap_cymbal_monkey::init, scripts\zm\replaced\_zm_weap_cymbal_monkey::init);
	replaceFunc(maps\mp\zombies\_zm_weap_cymbal_monkey::player_handle_cymbal_monkey, scripts\zm\replaced\_zm_weap_cymbal_monkey::player_handle_cymbal_monkey);
	replaceFunc(maps\mp\zombies\_zm_perk_divetonuke::divetonuke_precache, scripts\zm\replaced\_zm_perk_divetonuke::divetonuke_precache);
	replaceFunc(maps\mp\zombies\_zm_perk_divetonuke::divetonuke_perk_machine_setup, scripts\zm\replaced\_zm_perk_divetonuke::divetonuke_perk_machine_setup);
	replaceFunc(maps\mp\zombies\_zm_perk_divetonuke::divetonuke_explode, scripts\zm\replaced\_zm_perk_divetonuke::divetonuke_explode);
	replaceFunc(maps\mp\zombies\_zm_perk_electric_cherry::enable_electric_cherry_perk_for_level, scripts\zm\replaced\_zm_perk_electric_cherry::enable_electric_cherry_perk_for_level);
	replaceFunc(maps\mp\zombies\_zm_perk_electric_cherry::electic_cherry_precache, scripts\zm\replaced\_zm_perk_electric_cherry::electic_cherry_precache);
	replaceFunc(maps\mp\zombies\_zm_perk_electric_cherry::electric_cherry_reload_attack, scripts\zm\replaced\_zm_perk_electric_cherry::electric_cherry_reload_attack);
	replaceFunc(maps\mp\zombies\_zm_perk_electric_cherry::electric_cherry_laststand, scripts\zm\replaced\_zm_perk_electric_cherry::electric_cherry_laststand);
	replaceFunc(maps\mp\zombies\_zm_tombstone::tombstone_player_init, scripts\zm\replaced\_zm_tombstone::tombstone_player_init);
	replaceFunc(maps\mp\zombies\_zm_tombstone::tombstone_spawn, scripts\zm\replaced\_zm_tombstone::tombstone_spawn);
	replaceFunc(maps\mp\zombies\_zm_tombstone::tombstone_laststand, scripts\zm\replaced\_zm_tombstone::tombstone_laststand);
	replaceFunc(maps\mp\zombies\_zm_tombstone::is_weapon_available_in_tombstone, scripts\zm\replaced\_zm_tombstone::is_weapon_available_in_tombstone);
	replaceFunc(maps\mp\zombies\_zm_chugabud::chugabud_laststand, scripts\zm\replaced\_zm_chugabud::chugabud_laststand);
	replaceFunc(maps\mp\zombies\_zm_chugabud::is_weapon_available_in_chugabud_corpse, scripts\zm\replaced\_zm_chugabud::is_weapon_available_in_chugabud_corpse);

	perk_changes();
	powerup_changes();
}

init()
{
	precache_menus();
	precache_strings();
	precache_status_icons();

	level.using_solo_revive = 0;
	level.claymores_max_per_player = 20;
	level.navcards = undefined;
	level.powerup_intro_vox = undefined;
	level.hotjoin_player_setup = undefined;
	level.player_too_many_players_check = 0;
	level.pregame_minplayers = getDvarInt("party_minplayers");
	level.player_starting_health = 150;

	if (!isdefined(level.item_meat_name))
	{
		level.item_meat_name = "";
	}

	set_dvars();

	add_objectives();

	setscoreboardcolumns_gametype();

	spawn_mystery_box_blocks_and_collision();

	spawn_intercom_ents();

	hide_unused_chest_zbarriers();

	level thread on_player_connect();

	level thread on_intermission();

	level thread post_init();

	level thread enemy_counter_hud();

	level thread timer_hud();

	level thread swap_marathon_perk();

	level thread disable_story_vo();

	if (isDedicated())
	{
		scripts\zm\server\_zm_reimagined_server::init();
	}
}

precache_menus()
{
	precacheMenu("r_fog");
	precacheMenu("r_dof_enable");
}

precache_strings()
{
	precacheString(&"OBJ_PLAYER_1");
	precacheString(&"OBJ_PLAYER_2");
	precacheString(&"OBJ_PLAYER_3");
	precacheString(&"OBJ_PLAYER_4");
	precacheString(&"OBJ_PLAYER_5");
	precacheString(&"OBJ_PLAYER_6");
	precacheString(&"OBJ_PLAYER_7");
	precacheString(&"OBJ_PLAYER_8");

	precacheString(&"OBJ_PLAYER_CLONE_1");
	precacheString(&"OBJ_PLAYER_CLONE_2");
	precacheString(&"OBJ_PLAYER_CLONE_3");
	precacheString(&"OBJ_PLAYER_CLONE_4");
	precacheString(&"OBJ_PLAYER_CLONE_5");
	precacheString(&"OBJ_PLAYER_CLONE_6");
	precacheString(&"OBJ_PLAYER_CLONE_7");
	precacheString(&"OBJ_PLAYER_CLONE_8");

	precacheString(&"OBJ_GAME_MODE_1");
	precacheString(&"OBJ_GAME_MODE_2");

	precacheString(&"get_dvar");
	precacheString(&"r_fog");
	precacheString(&"r_dof_enable");

	precacheString(&"hud_update_rounds_played");
	precacheString(&"hud_update_weapon_select");
	precacheString(&"hud_update_overheat");
	precacheString(&"hud_update_perk_order");
	precacheString(&"hud_update_other_player_team_change");
	precacheString(&"objective_update_tombstone_powerup");

	precacheString(&"hud_update_enemy_counter");
	precacheString(&"hud_update_total_timer");
	precacheString(&"hud_update_round_timer");
	precacheString(&"hud_update_round_total_timer");
	precacheString(&"hud_update_health_bar");
	precacheString(&"hud_update_zone_name");
	precacheString(&"hud_update_quest_timer");

	precacheString(&"hud_fade_out_zone_name");
	precacheString(&"hud_fade_in_zone_name");
	precacheString(&"hud_fade_out_round_total_timer");
	precacheString(&"hud_fade_in_round_total_timer");
	precacheString(&"hud_fade_out_quest_timer");
	precacheString(&"hud_fade_in_quest_timer");

	foreach (zone_name in level.zone_keys)
	{
		precacheString(istring(toupper(level.script + "_" + zone_name)));
	}

	if (level.script == "zm_highrise")
	{
		elevator_volume_names = array("elevator_1b", "elevator_1c", "elevator_1d", "elevator_3a", "elevator_3b", "elevator_3c", "elevator_3d");

		foreach (volume_name in elevator_volume_names)
		{
			precacheString(istring(toupper(level.script + "_" + volume_name)));
		}
	}
}

precache_status_icons()
{
	precacheStatusIcon("menu_mp_killstreak_select");
	precacheStatusIcon("menu_mp_contract_expired");
	precacheStatusIcon("hud_status_revive");

	if (is_true(level.zombiemode_using_chugabud_perk))
	{
		precacheStatusIcon("specialty_chugabud_zombies");
	}

	if (is_true(level.zombiemode_using_afterlife))
	{
		precacheStatusIcon("hud_status_afterlife");
	}
}

spawn_mystery_box_blocks_and_collision()
{
	chests_to_spawn_ents = [];

	foreach (chest in level.chests)
	{
		if (!isDefined(chest.script_noteworthy))
		{
			continue;
		}

		if (level.script == "zm_transit")
		{
			if (chest.script_noteworthy == "tunnel_chest")
			{
				chests_to_spawn_ents[chests_to_spawn_ents.size] = chest;
			}
			else if (chest.script_noteworthy == "cornfield_chest")
			{
				chests_to_spawn_ents[chests_to_spawn_ents.size] = chest;
			}
		}
		else if (level.script == "zm_highrise")
		{
			if (chest.script_noteworthy == "gb1_chest")
			{
				chests_to_spawn_ents[chests_to_spawn_ents.size] = chest;
			}
			else if (chest.script_noteworthy == "blue_level4_chest")
			{
				chests_to_spawn_ents[chests_to_spawn_ents.size] = chest;
			}
			else if (chest.script_noteworthy == "orange_level3_chest")
			{
				chests_to_spawn_ents[chests_to_spawn_ents.size] = chest;
			}
		}
	}

	if (chests_to_spawn_ents.size == 0)
	{
		return;
	}

	precacheModel("p_glo_cinder_block_big");

	foreach (chest in chests_to_spawn_ents)
	{
		// spawn cinder blocks
		for (i = 0; i < 4; i++)
		{
			block = spawn("script_model", chest.zbarrier.origin);
			block.angles = chest.zbarrier.angles + (0, 90, 0);

			// fix upside down box angles
			if (abs(chest.zbarrier.angles[2]) >= 90)
			{
				block.angles = (0, block.angles[1], block.angles[2] + block.angles[0]);
			}

			block.origin += anglesToRight(chest.zbarrier.angles) * -5;
			block.origin += anglesToForward(chest.zbarrier.angles) * (35 + (i % 4 * -25));
			block.origin += anglesToUp(chest.zbarrier.angles) * -6;

			if (i % 4 == 0)
			{
				block.angles += (0, -45, 0);
			}
			else if (i % 4 == 1)
			{
				block.angles += (0, 22.5, 0);
			}
			else if (i % 4 == 2)
			{
				block.angles += (0, -5, 0);
			}
			else if (i % 4 == 3)
			{
				block.angles += (0, 22.5, 0);
			}

			// fix upside down box angles
			if (abs(chest.zbarrier.angles[2]) >= 90)
			{
				if (i % 4 == 0)
				{
					block.angles += (-8, 0, 4);
				}
				else if (i % 4 == 1)
				{
					block.angles += (5, 0, 1);
				}
				else if (i % 4 == 2)
				{
					block.angles += (-1, 0, 0);
				}
				else if (i % 4 == 3)
				{
					block.angles += (5, 0, 1);
				}
			}

			block setModel("p_glo_cinder_block_big");
		}

		// spawn collision
		for (i = 0; i < 3; i++)
		{
			collision = spawn("script_model", chest.zbarrier.origin, 1);
			collision.angles = chest.zbarrier.angles;

			collision.origin += anglesToForward(chest.zbarrier.angles) * (32 + (i * -32));
			collision.origin += anglesToUp(chest.zbarrier.angles) * 64;

			collision setModel("collision_geo_32x32x128_standard");
			collision disconnectPaths();
		}
	}
}

spawn_intercom_ents()
{
	if (level.script != "zm_transit" && level.script != "zm_highrise")
	{
		return;
	}

	foreach (chest in level.chests)
	{
		ent = spawn("script_origin", chest.origin + (0, 0, 15));
		ent.targetname = "intercom";
	}
}

hide_unused_chest_zbarriers()
{
	chests = getstructarray("treasure_chest_use", "targetname");

	foreach (chest in chests)
	{
		if (!isinarray(level.chests, chest))
		{
			zbarrier = getent(chest.script_noteworthy + "_zbarrier", "script_noteworthy");

			if (isdefined(zbarrier))
			{
				zbarrier hide();
			}
		}
	}
}

on_player_connect()
{
	while (1)
	{
		level waittill("connected", player);

		if (!is_true(level.intermission))
		{
			player.statusicon = "hud_status_dead";
		}

		player set_client_dvars();

		player thread lui_notify_events();

		player thread on_player_spawned();
		player thread on_player_downed();
		player thread on_player_revived();
		player thread on_player_fake_revive();
		player thread on_player_spectate();
		player thread on_player_spectate_change();
		player thread on_player_disconnect();

		player thread player_waypoint();
		player thread grenade_fire_watcher();
		player thread create_equipment_turret_watcher();
		player thread sndmeleewpnsound();
	}
}

on_player_spawned()
{
	level endon("game_ended");
	self endon("disconnect");

	self.initial_spawn = true;

	while (1)
	{
		self waittill("spawned_player");
		waittillframeend;

		if (self.initial_spawn)
		{
			self.initial_spawn = false;

			self.solo_lives_given = 0;
			self.stored_weapon_data = undefined;

			self thread init_player_fx_ent();

			self thread health_bar_hud();
			self thread zone_name_hud();

			self thread bleedout_bar_hud();

			self thread veryhurt_blood_fx();

			self thread ignoreme_after_revived();

			self thread last_held_primary_weapon_tracker();

			self thread held_melee_weapon_world_model_fix();

			self thread give_additional_perks();

			self thread bank_gain_interest_after_rounds();
			self thread weapon_locker_give_ammo_after_rounds();

			self thread alt_weapon_name_hud();

			self thread additionalprimaryweapon_indicator();
			self thread additionalprimaryweapon_stowed_weapon_refill();

			if (maps\mp\zombies\_zm_weapons::is_weapon_included("crossbow_zm"))
			{
				self thread scripts\zm\reimagined\_zm_weap_crossbow::watch_for_monkey_bolt();
			}
		}

		if (!is_player_valid(self))
		{
			continue;
		}

		self.statusicon = "";

		objective_setgamemodeflags(self.obj_ind, 1);

		self useservervisionset(0);

		self set_perks();
		self set_favorite_wall_weapons();
		self disable_lean();
	}
}

on_player_downed()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("entering_last_stand");

		self.statusicon = "hud_status_revive";
		self.health = self.maxhealth;

		objective_setgamemodeflags(self.obj_ind, 2);
	}
}

on_player_revived()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("player_revived", reviver);

		if (isDefined(self.e_chugabud_corpse))
		{
			self.statusicon = "specialty_chugabud_zombies";
		}
		else
		{
			self.statusicon = "";
		}

		objective_setgamemodeflags(self.obj_ind, 1);

		self useservervisionset(0);
	}
}

on_player_fake_revive()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("fake_revive");

		if (is_true(level.zombiemode_using_chugabud_perk))
		{
			self.statusicon = "specialty_chugabud_zombies";
		}
		else if (is_true(level.zombiemode_using_afterlife))
		{
			self.statusicon = "hud_status_afterlife";
			objective_setgamemodeflags(self.obj_ind, 0);
		}
	}
}

on_player_spectate()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("spawned_spectator");

		self.statusicon = "hud_status_dead";

		objective_setgamemodeflags(self.obj_ind, 0);
	}
}

on_player_spectate_change()
{
	level endon("intermission");
	self endon("disconnect");

	while (1)
	{
		self waittill("spectator_cycle");

		self update_perk_order();
	}
}

on_player_disconnect()
{
	self waittill("disconnect");

	objective_state(self.obj_ind, "invisible");
	objective_clearentity(self.obj_ind, self);
	objective_setgamemodeflags(self.obj_ind, 0);
	objective_position(self.obj_ind, (0, 0, 0));
}

on_intermission()
{
	level waittill("intermission");

	players = get_players();

	foreach (player in players)
	{
		player.statusicon = "";
		player useservervisionset(0);
		player setclientuivisibilityflag("hud_visible", 0);

		if (isdefined(player.player_fx_ent))
		{
			player.player_fx_ent delete();
		}

		if (isdefined(player.stun_fx_ents))
		{
			array_delete(player.stun_fx_ents);
		}
	}
}

post_init()
{
	flag_wait("start_zombie_round_logic");

	wait 0.05;

	level.ta_vaultfee = 0;
	level.ta_tellerfee = 0;
	level.weapon_locker_online = 0;
	level.disable_melee_wallbuy_icons = 0;
	level.dont_link_common_wallbuys = 1;
	level.magicbox_timeout = 9;
	level.packapunch_timeout = 12;
	level.perk_purchase_limit = 9;
	level._random_zombie_perk_cost = 2500;
	level.flopper_network_optimized = 0;
	level.equipment_etrap_needs_power = 0;
	level.equipment_turret_needs_power = 0;
	level.equipment_subwoofer_needs_power = 0;
	level.limited_weapons["ray_gun_zm"] = 8;
	level.limited_weapons["raygun_mark2_zm"] = 1;

	if (isDefined(level.zombie_weapons["slipgun_zm"]))
	{
		level.zombie_weapons["slipgun_zm"].upgrade_name = "slipgun_upgraded_zm";
		level.zombie_weapons_upgraded["slipgun_upgraded_zm"] = "slipgun_zm";
	}

	level.zombie_vars["riotshield_hit_points"] = 1500;
	level.zombie_vars["slipgun_reslip_rate"] = 0;
	level.zombie_vars["zombie_perk_divetonuke_min_damage"] = 1000;
	level.zombie_vars["zombie_perk_divetonuke_max_damage"] = 5000;
	level.players_can_damage_riotshields = 1;
	level.speed_change_round = undefined;
	level.playersuicideallowed = undefined;
	level.disable_free_perks_before_power = undefined;
	level.custom_random_perk_weights = undefined;
	level.etrap_damage = maps\mp\zombies\_zm::ai_zombie_health(255);
	level.slipgun_damage = maps\mp\zombies\_zm::ai_zombie_health(255);
	level.should_respawn_func = ::should_respawn;

	disable_carpenter();

	disable_bank_teller();

	zone_changes();

	jetgun_remove_forced_weapon_switch();

	level thread wallbuy_cost_changes();

	level thread buildbuildables();
	level thread buildcraftables();
}

add_objectives()
{
	objective_add(0, "invisible", (0, 0, 0), &"OBJ_PLAYER_1");
	objective_add(1, "invisible", (0, 0, 0), &"OBJ_PLAYER_2");
	objective_add(2, "invisible", (0, 0, 0), &"OBJ_PLAYER_3");
	objective_add(3, "invisible", (0, 0, 0), &"OBJ_PLAYER_4");
	objective_add(4, "invisible", (0, 0, 0), &"OBJ_PLAYER_5");
	objective_add(5, "invisible", (0, 0, 0), &"OBJ_PLAYER_6");
	objective_add(6, "invisible", (0, 0, 0), &"OBJ_PLAYER_7");
	objective_add(7, "invisible", (0, 0, 0), &"OBJ_PLAYER_8");

	objective_add(8, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_1");
	objective_add(9, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_2");
	objective_add(10, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_3");
	objective_add(11, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_4");
	objective_add(12, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_5");
	objective_add(13, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_6");
	objective_add(14, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_7");
	objective_add(15, "invisible", (0, 0, 0), &"OBJ_PLAYER_CLONE_8");

	objective_add(16, "invisible", (0, 0, 0), &"OBJ_GAME_MODE_1");
	objective_add(17, "invisible", (0, 0, 0), &"OBJ_GAME_MODE_2");
}

set_dvars()
{
	setDvar("playerPushAmount", 1);

	setDvar("player_backSpeedScale", 1);
	setDvar("player_strafeSpeedScale", 1);

	setDvar("player_meleeRange", 64);

	setDvar("player_allowActivateWhileSwitchingWeapons", 1);

	setDvar("player_breath_gasp_lerp", 0);

	// can't set to exactly 90 or else looking completely up or down will cause the player to move in the opposite direction
	setDvar("player_view_pitch_up", 89.9999);
	setDvar("player_view_pitch_down", 89.9999);

	setDvar("player_sliding_velocity_cap", 80);
	setDvar("player_sliding_wishspeed", 800);

	setDvar("player_sprintFix", 1);

	setDvar("dtp_post_move_pause", 0);
	setDvar("dtp_startup_delay", 100);
	setDvar("dtp_exhaustion_window", 100);

	setDvar("turret_SentryForceManualTarget", 1);

	setDvar("penetrationCount", 100);

	setDvar("perk_weapRateEnhanced", 0);
	setDvar("perk_weapSpreadAds", 1);
	setDvar("perk_speedMultiplier", 1.1);

	setDvar("riotshield_melee_damage_scale", 1);
	setDvar("riotshield_bullet_damage_scale", 1);
	setDvar("riotshield_explosive_damage_scale", 1);
	setDvar("riotshield_projectile_damage_scale", 1);
	setDvar("riotshield_deployed_health", 1500);

	setDvar("sv_rateBoostingEnabled", 1);
	setDvar("sv_rateBoostingForce", 1);

	setDvar("sv_voiceQuality", 9);

	setDvar("g_fix_entity_leaks", 1);

	setDvar("g_friendlyfireDist", 0);

	setDvar("bg_fallDamageScale", 0);

	setDvar("bg_burstFireInputFix", 1);

	setDvar("bg_forceMinePlant", 1);

	setDvar("bg_ladder_pitchmove", 0);

	setDvar("bg_minigun_prevent_spin_while_not_ready", 1);
	setDvar("bg_minigun_disable_ads_spin", 1);

	setDvar("bg_jetgun_prevent_spin_while_not_ready", 1);
	setDvar("bg_jetgun_disable_z_thrust", 1);
	setDvar("bg_jetgun_fix_spin", 1);

	if (maps\mp\zombies\_zm_weapons::is_weapon_included("metalstorm_mms_zm"))
	{
		setDvar("bg_chargeShotMaxBulletsInQueue", 5);
		setDvar("bg_chargeShotQueueTime", 250);
	}
	else
	{
		setDvar("bg_chargeShotMaxBulletsInQueue", 3);
		setDvar("bg_chargeShotQueueTime", 500);
	}

	setDvar("bg_chargeShotEmptyFire", 1);
	setDvar("bg_chargeShotAllowChargingWithoutRepress", 1);
	setDvar("bg_chargeShotPreventChargingWhileNotReady", 1);
}

set_client_dvars()
{
	self setClientDvars(
	    "player_backSpeedScale", getDvar("player_backSpeedScale"),
	    "player_strafeSpeedScale", getDvar("player_strafeSpeedScale"),
	    "player_meleeRange", getDvar("player_meleeRange"),
	    "player_allowActivateWhileSwitchingWeapons", getDvar("player_allowActivateWhileSwitchingWeapons"),
	    "player_breath_gasp_lerp", getDvar("player_breath_gasp_lerp"),
	    "player_lastStandBleedoutTime", getDvar("player_lastStandBleedoutTime"),
	    "player_view_pitch_up", getDvar("player_view_pitch_up"),
	    "player_view_pitch_down", getDvar("player_view_pitch_down"),
	    "player_sliding_velocity_cap", getDvar("player_sliding_velocity_cap"),
	    "player_sliding_wishspeed", getDvar("player_sliding_wishspeed"),
	    "player_sprintFix", getDvar("player_sprintFix"),
	    "dtp_post_move_pause", getDvar("dtp_post_move_pause"),
	    "dtp_startup_delay", getDvar("dtp_startup_delay"),
	    "dtp_exhaustion_window", getDvar("dtp_exhaustion_window"),
	    "turret_SentryForceManualTarget", getDvar("turret_SentryForceManualTarget"));

	self setClientDvars(
	    "bg_fallDamageScale", getDvar("bg_fallDamageScale"),
	    "bg_burstFireInputFix", getDvar("bg_burstFireInputFix"),
	    "bg_forceMinePlant", getDvar("bg_forceMinePlant"),
	    "bg_ladder_pitchmove", getDvar("bg_ladder_pitchmove"),
	    "bg_minigun_prevent_spin_while_not_ready", getDvar("bg_minigun_prevent_spin_while_not_ready"),
	    "bg_minigun_disable_ads_spin", getDvar("bg_minigun_disable_ads_spin"),
	    "bg_jetgun_prevent_spin_while_not_ready", getDvar("bg_jetgun_prevent_spin_while_not_ready"),
	    "bg_jetgun_disable_z_thrust", getDvar("bg_jetgun_disable_z_thrust"),
	    "bg_jetgun_fix_spin", getDvar("bg_jetgun_fix_spin"),
	    "bg_chargeShotMaxBulletsInQueue", getDvar("bg_chargeShotMaxBulletsInQueue"),
	    "bg_chargeShotQueueTime", getDvar("bg_chargeShotQueueTime"),
	    "bg_chargeShotEmptyFire", getDvar("bg_chargeShotEmptyFire"),
	    "bg_chargeShotAllowChargingWithoutRepress", getDvar("bg_chargeShotAllowChargingWithoutRepress"),
	    "bg_chargeShotPreventChargingWhileNotReady", getDvar("bg_chargeShotPreventChargingWhileNotReady"));

	self setClientDvars(
	    "aim_automelee_enabled", 0,
	    "cg_friendlyNameFadeIn", 0,
	    "cg_friendlyNameFadeOut", 250,
	    "cg_enemyNameFadeIn", 0,
	    "cg_enemyNameFadeOut", 250,
	    "cg_sonarAttachmentHideFriendlies", 0,
	    "cg_sonarAttachmentFadeFriendlies", 0,
	    "cg_sonarAttachmentFadeEnemies", 0,
	    "cg_sonarAttachmentFullscreenThermal", 0,
	    "cg_sonarAttachmentFullscreenSightCheck", 1,
	    "r_lodBiasRigid", -1000,
	    "r_lodBiasSkinned", -1000);

	self setClientDvars(
	    "waypointMaxDrawDist", 0,
	    "waypointOffscreenPadTop", 40,
	    "waypointOffscreenPadBottom", 20,
	    "waypointOffscreenPadLeft", 10,
	    "waypointOffscreenPadRight", 10,
	    "waypointOffscreenPadLUIFix", 1,
	    "waypointDistFade", 100,
	    "waypointTimeFade", 0,
	    "waypointTimeFadeLUIFix", 1,
	    "weaponAltWeaponNames", "",
	    "additionalPrimaryWeaponName", "",
	    "ui_gametype_obj_lobby", getDvar("ui_gametype_obj"),
	    "ui_gametype_pro_lobby", getDvar("ui_gametype_pro"));

	self thread set_client_dvar_loop("r_fog");
	self thread set_client_dvar_loop("r_dof_enable");
}

set_client_dvar_loop(dvar)
{
	self endon("disconnect");

	// this will send menu response back after getting to the waittill
	self luinotifyevent(&"get_dvar", 1, istring(dvar));

	while (1)
	{
		self waittill("menuresponse", menu, value);

		if (menu == tolower(dvar))
		{
			self setClientDvar(dvar, value);
		}
	}
}

set_perks()
{
	self setperk("specialty_unlimitedsprint");
	self setperk("specialty_fastmantle");
	self setperk("specialty_fastladderclimb");
}

set_favorite_wall_weapons()
{
	if (!isdefined(self.favorite_wall_weapons_list))
	{
		return;
	}

	for (i = 0; i < self.favorite_wall_weapons_list.size; i++)
	{
		if (self.favorite_wall_weapons_list[i] == "rottweil72_zm")
		{
			self.favorite_wall_weapons_list[i] = "ballista_zm";
		}
		else if (self.favorite_wall_weapons_list[i] == "m14_zm")
		{
			self.favorite_wall_weapons_list[i] = "saritch_zm";
		}
		else if (self.favorite_wall_weapons_list[i] == "m16_zm")
		{
			self.favorite_wall_weapons_list[i] = "sig556_zm";
		}
	}
}

disable_lean()
{
	self._allow_lean = 0;
	self allowlean(0);
}

lui_notify_events()
{
	self endon("disconnect");

	self waittill_next_snapshot();

	if (isdefined(level.enemy_counter_hud_value))
	{
		self luinotifyevent(&"hud_update_enemy_counter", 1, level.enemy_counter_hud_value);
	}

	if (isdefined(level.total_timer_hud_value))
	{
		self luinotifyevent(&"hud_update_total_timer", 1, level.total_timer_hud_value);
	}

	if (isdefined(level.round_timer_hud_value))
	{
		self luinotifyevent(&"hud_update_round_timer", 1, level.round_timer_hud_value);
	}

	if (isdefined(level.round_total_timer_hud_value))
	{
		self luinotifyevent(&"hud_update_round_total_timer", 1, level.round_total_timer_hud_value);
		self luinotifyevent(&"hud_fade_in_round_total_timer");
	}

	if (isdefined(level.quest_timer_hud_value))
	{
		self luinotifyevent(&"hud_update_quest_timer", 1, level.quest_timer_hud_value);
		self luinotifyevent(&"hud_fade_in_quest_timer");
	}

	if (isdefined(level.game_mode_name_hud_value))
	{
		self luinotifyevent(&"hud_update_game_mode_name", 1, level.game_mode_name_hud_value);
	}

	if (isdefined(level.game_mode_scoring_team_hud_value))
	{
		self luinotifyevent(&"hud_update_scoring_team", 1, level.game_mode_scoring_team_hud_value[self.team]);
	}

	if (isdefined(level.game_mode_player_count_hud_value))
	{
		self luinotifyevent(&"hud_update_player_count", 2, level.game_mode_player_count_hud_value[self.team], level.game_mode_player_count_hud_value[getotherteam(self.team)]);
	}

	if (isdefined(level.containment_zone_hud_value))
	{
		self luinotifyevent(&"hud_update_containment_zone", 1, level.containment_zone_hud_value);
	}

	if (isdefined(level.containment_time_hud_value))
	{
		self luinotifyevent(&"hud_update_containment_time", 1, level.containment_time_hud_value);
	}

	if (level.round_number > 255)
	{
		self luinotifyevent(&"hud_update_rounds_played", 1, level.round_number);
	}
}

enemy_counter_hud()
{
	flag_wait("hud_visible");

	if (getDvar("g_gametype") == "zgrief")
	{
		return;
	}

	level.enemy_counter_hud_value = 0;

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_enemy_counter", 1, level.enemy_counter_hud_value);
	}

	while (1)
	{
		enemies = get_round_enemy_array().size + level.zombie_total;

		if (level flag_exists("spawn_ghosts") && flag("spawn_ghosts") && isdefined(level.get_current_ghost_count_func))
		{
			enemies = [[level.get_current_ghost_count_func]]();
		}
		else if (level flag_exists("sq_tpo_special_round_active") && flag("sq_tpo_special_round_active"))
		{
			enemies = 0;
		}

		if (level.enemy_counter_hud_value == enemies)
		{
			wait 0.05;
			continue;
		}

		level.enemy_counter_hud_value = enemies;

		players = get_players();

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_enemy_counter", 1, level.enemy_counter_hud_value);
		}

		wait 0.05;
	}
}

timer_hud()
{
	level endon("end_game");
	level endon("stop_timers");

	flag_wait("hud_visible");

	level thread round_timer_hud_loop();

	level.total_timer_hud_value = 0;

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_total_timer", 1, level.total_timer_hud_value);
	}

	if (!flag("initial_blackscreen_passed"))
	{
		level waittill("initial_blackscreen_passed");
	}

	if (getDvar("g_gametype") == "zgrief")
	{
		level waittill("restart_round_start");
	}

	while (1)
	{
		wait 1;

		level.total_timer_hud_value++;

		players = get_players();

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_total_timer", 1, level.total_timer_hud_value);
		}
	}
}

round_timer_hud_loop()
{
	level endon("end_game");
	level endon("stop_timers");

	if (isDefined(level.scr_zm_ui_gametype_obj) && level.scr_zm_ui_gametype_obj != "zsr")
	{
		return;
	}

	level.round_timer_hud_value = 0;

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_round_timer", 1, level.round_timer_hud_value);
	}

	if (!flag("initial_blackscreen_passed"))
	{
		level waittill("initial_blackscreen_passed");
	}

	if (getDvar("g_gametype") == "zgrief")
	{
		level waittill("restart_round_start");
	}

	while (1)
	{
		level thread round_timer_hud();

		if (getDvar("g_gametype") == "zgrief")
		{
			level waittill("restart_round_start");
		}
		else
		{
			level waittill("end_of_round");
			level waittill("start_of_round");
		}
	}
}

round_timer_hud()
{
	level endon("end_game");
	level endon("stop_timers");
	level notify("round_timer_hud");
	level endon("round_timer_hud");

	if (getDvar("g_gametype") == "zgrief")
	{
		level endon("restart_round");
	}
	else
	{
		level endon("end_of_round");
	}

	level thread round_total_timer_hud();

	level.round_timer_hud_value = 0;
	level.round_total_timer_hud_value = undefined;

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_round_timer", 1, level.round_timer_hud_value);
		player luinotifyevent(&"hud_fade_out_round_total_timer", 1, 500);
	}

	while (1)
	{
		wait 1;

		level.round_timer_hud_value++;

		players = get_players();

		foreach (player in players)
		{
			player luinotifyevent(&"hud_update_round_timer", 1, level.round_timer_hud_value);
		}
	}
}

round_total_timer_hud()
{
	level endon("end_game");
	level endon("stop_timers");
	level notify("round_total_timer_hud");
	level endon("round_total_timer_hud");

	if (getDvar("g_gametype") == "zgrief")
	{
		return;
	}

	level waittill("end_of_round");

	level.round_total_timer_hud_value = level.total_timer_hud_value;

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_round_total_timer", 1, level.round_total_timer_hud_value);
		player luinotifyevent(&"hud_fade_in_round_total_timer", 1, 500);
	}
}

health_bar_hud()
{
	level endon("intermission");
	self endon("disconnect");

	self waittill_next_snapshot();

	flag_wait("hud_visible");

	prev_health = 0;
	prev_maxhealth = 0;
	prev_shield_health = 0;

	while (1)
	{
		player = self get_current_spectating_player();

		shield_health = 0;

		if (is_true(player.hasriotshield) && isdefined(player.shielddamagetaken) && player.shielddamagetaken < level.zombie_vars["riotshield_hit_points"])
		{
			shield_health = level.zombie_vars["riotshield_hit_points"] - player.shielddamagetaken;
			shield_health = int((shield_health / level.zombie_vars["riotshield_hit_points"]) * 100);
		}

		if (player.health == prev_health && player.maxhealth == prev_maxhealth && shield_health == prev_shield_health)
		{
			wait 0.05;
			continue;
		}

		self luinotifyevent(&"hud_update_health_bar", 3, player.health, player.maxhealth, shield_health);

		prev_health = player.health;
		prev_maxhealth = player.maxhealth;
		prev_shield_health = shield_health;

		wait 0.05;
	}
}

zone_name_hud()
{
	level endon("intermission");
	self endon("disconnect");

	self waittill_next_snapshot();

	flag_wait("hud_visible");

	prev_player = self;
	prev_zone_name = &"";

	while (1)
	{
		player = self get_current_spectating_player();

		zone = player get_current_zone();
		zone_name = player get_zone_display_name(zone);

		if (zone_name == prev_zone_name && player == prev_player)
		{
			wait 0.05;
			continue;
		}

		self thread zone_name_hud_fade(player, zone_name, prev_player, prev_zone_name);

		prev_player = player;
		prev_zone_name = zone_name;

		wait 0.05;
	}
}

zone_name_hud_fade(player, zone_name, prev_player, prev_zone_name)
{
	level endon("intermission");
	self endon("disconnect");
	self notify("zone_name_hud_fade");
	self endon("zone_name_hud_fade");

	if (player != prev_player)
	{
		self luinotifyevent(&"hud_update_zone_name", 1, zone_name);

		if (zone_name == &"")
		{
			self luinotifyevent(&"hud_fade_out_zone_name");
		}
		else
		{
			self luinotifyevent(&"hud_fade_in_zone_name");
		}

		return;
	}

	if (prev_zone_name != &"")
	{
		self luinotifyevent(&"hud_fade_out_zone_name", 1, 250);

		wait 0.25;
	}

	self luinotifyevent(&"hud_update_zone_name", 1, zone_name);

	if (zone_name != &"")
	{
		self luinotifyevent(&"hud_fade_in_zone_name", 1, 250);

		wait 0.25;
	}
}

get_zone_display_name(zone)
{
	if (isdefined(self) && (isplayer(self) || isai(self)))
	{
		if (isdefined(level.elevator_volumes))
		{
			foreach (volume in level.elevator_volumes)
			{
				if (self istouching(volume))
				{
					return istring(toupper(level.script + "_" + volume.targetname));
				}
			}
		}

		if (is_true(self.teleporting))
		{
			return &"";
		}
	}

	if (!isDefined(zone))
	{
		return &"";
	}

	return istring(toupper(level.script + "_" + zone));
}

bleedout_bar_hud()
{
	level endon("pre_end_game");
	level endon("end_game");
	self endon("disconnect");

	flag_wait("hud_visible");

	while (1)
	{
		self waittill("entering_last_stand");

		if (is_true(self.playersuicided))
		{
			continue;
		}

		if (flag("solo_game"))
		{
			continue;
		}

		hud = self createbar((1, 0, 0), level.secondaryprogressbarwidth * 2, level.secondaryprogressbarheight);
		hud setpoint("CENTER", undefined, level.secondaryprogressbarx, -1 * level.secondaryprogressbary);
		hud.foreground = 1;
		hud.bar.foreground = 1;
		hud.barframe.foreground = 1;
		hud.hidewheninmenu = 1;
		hud.bar.hidewheninmenu = 1;
		hud.barframe.hidewheninmenu = 1;
		hud.sort = 1;
		hud.bar.sort = 2;
		hud.barframe.sort = 3;
		hud thread destroy_on_intermission();

		self thread bleedout_bar_hud_updatebar(hud);

		self waittill_any("player_revived", "bled_out", "player_suicide");

		hud destroyelem();
	}
}

// scaleovertime doesn't work past 30 seconds so here is a workaround
bleedout_bar_hud_updatebar(hud)
{
	self endon("player_revived");
	self endon("bled_out");
	self endon("player_suicide");

	bleedout_time = getDvarInt("player_lastStandBleedoutTime");
	interval_time = 30;
	interval_frac = interval_time / bleedout_time;
	num_intervals = int(bleedout_time / interval_time) + 1;

	hud updatebar(1);

	for (i = 0; i < num_intervals; i++)
	{
		time = bleedout_time;

		if (time > interval_time)
		{
			time = interval_time;
		}

		frac = 0.99 - ((i + 1) * interval_frac);

		barwidth = int((hud.width * frac) + 0.5);

		if (barwidth < 1)
		{
			barwidth = 1;
		}

		hud.bar scaleovertime(time, barwidth, hud.height);

		wait time;

		bleedout_time -= time;
	}
}

setscoreboardcolumns_gametype()
{
	if (level.scr_zm_ui_gametype != "zgrief")
	{
		setscoreboardcolumns("score", "kills", "headshots", "downs", "revives");
	}
}

swap_marathon_perk()
{
	vending_triggers = getentarray("zombie_vending", "targetname");

	foreach (trigger in vending_triggers)
	{
		if (trigger.script_noteworthy == "specialty_longersprint")
		{
			trigger.script_noteworthy = "specialty_movefaster";
		}
	}

	if (isDefined(level._random_perk_machine_perk_list))
	{
		for (i = 0; i < level._random_perk_machine_perk_list.size; i++)
		{
			if (level._random_perk_machine_perk_list[i] == "specialty_longersprint")
			{
				level._random_perk_machine_perk_list[i] = "specialty_movefaster";
			}
		}
	}
}

disable_story_vo()
{
	if (getDvarIntDefault("character_dialog", 1))
	{
		return;
	}

	if (flag_exists("story_vo_playing"))
	{
		flag_set("story_vo_playing");
	}
}

init_player_fx_ent()
{
	self endon("disconnect");

	self waittill_next_snapshot(1);

	tag = "j_spinelower";
	self.player_fx_ent = spawn("script_model", self gettagorigin(tag));
	self.player_fx_ent.angles = self gettagangles(tag);
	self.player_fx_ent setmodel("tag_origin");
	self.player_fx_ent linkto(self, tag);
	self thread ent_cleanup_on_disconnect(self.player_fx_ent);
}

ent_cleanup_on_disconnect(ent)
{
	ent endon("death");

	self waittill("disconnect");

	if (isdefined(ent))
	{
		ent delete();
	}
}

veryhurt_blood_fx()
{
	level endon("intermission");
	self endon("disconnect");

	while (1)
	{
		if (is_player_valid(self) && self.health <= 50)
		{
			playfxontag(level._effect["zombie_guts_explosion"], self.player_fx_ent, "tag_origin");

			wait 1;

			continue;
		}

		wait 0.05;
	}
}

ignoreme_after_revived()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("player_revived", reviver);

		self thread player_revive_protection();
	}
}

player_revive_protection()
{
	self endon("disconnect");
	self endon("player_downed");
	self endon("meat_grabbed");
	self endon("meat_stink_player_start");

	self thread player_revive_protection_timeout();

	self.revive_protection = 1;

	for (i = 0; i < 20; i++)
	{
		self.ignoreme = 1;
		wait 0.05;
	}

	if (!isDefined(level.meat_player))
	{
		self.ignoreme = 0;
	}

	self.revive_protection = 0;
	self notify("player_revive_protection_end");
}

player_revive_protection_timeout()
{
	self endon("disconnect");
	self endon("player_revive_protection_end");

	self waittill_any("player_downed", "meat_grabbed", "meat_stink_player_start");

	self.revive_protection = 0;
}

last_held_primary_weapon_tracker()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("weapon_change");

		current_weapon = self getcurrentweapon();

		if (current_weapon != "none" && isweaponprimary(current_weapon))
		{
			self.last_held_primary_weapon = current_weapon;
		}
	}
}

held_melee_weapon_world_model_fix()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("weapon_change");

		current_weapon = self getcurrentweapon();
		melee_weapon = self get_player_melee_weapon();

		if (!isdefined(melee_weapon))
		{
			continue;
		}

		if (getweaponmodel(melee_weapon) == "t6_wpn_none_world")
		{
			continue;
		}

		if (!self hasweapon(melee_weapon) && !self hasweapon("held_" + melee_weapon))
		{
			continue;
		}

		if (current_weapon == "held_" + melee_weapon && self hasweapon(melee_weapon))
		{
			self takeweapon(melee_weapon);

			if (is_held_melee_weapon_offhand_melee(melee_weapon))
			{
				self giveweapon("held_" + melee_weapon + "_offhand");
			}
		}
		else if (current_weapon != "held_" + melee_weapon && !self hasweapon(melee_weapon))
		{
			self giveweapon(melee_weapon);

			if (is_held_melee_weapon_offhand_melee(melee_weapon))
			{
				self takeweapon("held_" + melee_weapon + "_offhand");
			}
		}
	}
}

is_held_melee_weapon_offhand_melee(weaponname)
{
	return weaponname == "tazer_knuckles_zm";
}

disable_bank_teller()
{
	level notify("stop_bank_teller");
	bank_teller_dmg_trig = getent("bank_teller_tazer_trig", "targetname");

	if (IsDefined(bank_teller_dmg_trig))
	{
		bank_teller_transfer_trig = getent(bank_teller_dmg_trig.target, "targetname");
		bank_teller_transfer_trig delete();
		bank_teller_dmg_trig delete();
	}
}

disable_carpenter()
{
	arrayremovevalue(level.zombie_powerup_array, "carpenter");
}

perk_changes()
{
	if (!is_gametype_active("zclassic"))
	{
		return;
	}

	if (getdvar("mapname") == "zm_highrise")
	{
		level.zombiemode_using_marathon_perk = 1;
	}

	if (getdvar("mapname") == "zm_transit" || getdvar("mapname") == "zm_highrise" || getdvar("mapname") == "zm_prison" || getdvar("mapname") == "zm_buried" || getdvar("mapname") == "zm_tomb")
	{
		level.zombiemode_using_divetonuke_perk = 1;
		maps\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();
	}

	if (getdvar("mapname") == "zm_transit" || getdvar("mapname") == "zm_buried" || getdvar("mapname") == "zm_tomb")
	{
		level.zombiemode_using_deadshot_perk = 1;
	}

	if (getdvar("mapname") == "zm_transit" || getdvar("mapname") == "zm_prison")
	{
		level.zombiemode_using_additionalprimaryweapon_perk = 1;
	}

	if (getdvar("mapname") == "zm_buried")
	{
		level.zombiemode_using_tombstone_perk = 1;
	}

	if (getdvar("mapname") == "zm_transit")
	{
		level.zombiemode_using_chugabud_perk = 1;
		level.whos_who_client_setup = 1;
		level.vsmgr_prio_visionset_zm_whos_who = 123;

		registerclientfield("actor", "clientfield_whos_who_clone_glow_shader", 5000, 1, "int");
		registerclientfield("toplayer", "clientfield_whos_who_audio", 5000, 1, "int");
		registerclientfield("toplayer", "clientfield_whos_who_filter", 5000, 1, "int");
	}
}

powerup_changes()
{
	if (getDvar("mapname") == "zm_transit" || getDvar("mapname") == "zm_highrise")
	{
		include_powerup("fire_sale");
	}
}

weapon_changes()
{
	if (level.script == "zm_transit" || level.script == "zm_nuked" || level.script == "zm_highrise" || level.script == "zm_buried" || level.script == "zm_tomb")
	{
		include_weapon("held_knife_zm", 0);
		register_melee_weapon_for_level("held_knife_zm");
	}

	if (level.script == "zm_transit" || level.script == "zm_nuked" || level.script == "zm_highrise" || level.script == "zm_buried")
	{
		include_weapon("held_bowie_knife_zm", 0);
		register_melee_weapon_for_level("held_bowie_knife_zm");

		include_weapon("held_tazer_knuckles_zm", 0);
		register_melee_weapon_for_level("held_tazer_knuckles_zm");

		level.laststandpistol = "fnp45_zm";
		level.default_laststandpistol = "fnp45_zm";
		level.default_solo_laststandpistol = "fnp45_upgraded_zm";
		level.start_weapon = "fnp45_zm";
		include_weapon("fnp45_zm", 0);
		include_weapon("fnp45_upgraded_zm", 0);
		add_limited_weapon("fnp45_zm", 0);
		add_zombie_weapon("fnp45_zm", "fnp45_upgraded_zm", &"WEAPON_FNP45", 500, "", "", undefined, 1);
	}

	if (level.script == "zm_transit")
	{
		include_weapon("an94_zm", 0);
		include_weapon("an94_upgraded_zm", 0);
		add_zombie_weapon("an94_zm", "an94_upgraded_zm", &"ZOMBIE_WEAPON_AN94", 1500, "", "", undefined, 1);

		include_weapon("pdw57_zm", 0);
		include_weapon("pdw57_upgraded_zm", 0);
		add_zombie_weapon("pdw57_zm", "pdw57_upgraded_zm", &"ZOMBIE_WEAPON_PDW57", 1000, "", "", undefined, 1);

		include_weapon("svu_zm", 0);
		include_weapon("svu_upgraded_zm", 0);
		add_zombie_weapon("svu_zm", "svu_upgraded_zm", &"ZOMBIE_WEAPON_SVU", 1000, "", "", undefined, 1);

		include_weapon("metalstorm_mms_zm");
		include_weapon("metalstorm_mms_upgraded_zm", 0);
		add_limited_weapon("metalstorm_mms_zm", 1);
		add_limited_weapon("metalstorm_mms_upgraded_zm", 1);
		add_zombie_weapon("metalstorm_mms_zm", "metalstorm_mms_upgraded_zm", &"WEAPON_METALSTORM", 1000, "", "", undefined, 1);
	}

	if (level.script == "zm_nuked")
	{
		include_weapon("titus6_zm");
		include_weapon("titus6_upgraded_zm", 0);
		add_limited_weapon("titus6_zm", 1);
		add_limited_weapon("titus6_upgraded_zm", 1);
		add_zombie_weapon("titus6_zm", "titus6_upgraded_zm", &"WEAPON_TITUS6_EXPLOSIVE", 1000, "", "", undefined, 1);
		precacheitem("titus6_explosive_dart_zm");
		precacheitem("titus6_explosive_dart_upgraded_zm");
	}

	if (level.script == "zm_prison")
	{
		include_weapon("held_knife_zm_alcatraz", 0);
		register_melee_weapon_for_level("held_knife_zm_alcatraz");

		include_weapon("held_spoon_zm_alcatraz", 0);
		register_melee_weapon_for_level("held_spoon_zm_alcatraz");

		include_weapon("held_spork_zm_alcatraz", 0);
		register_melee_weapon_for_level("held_spork_zm_alcatraz");

		include_weapon("sticky_grenade_zm", 0);
		add_zombie_weapon("sticky_grenade_zm", undefined, &"ZOMBIE_WEAPON_STICKY_GRENADE", 250, "wpck_explo", "", 250);
		register_lethal_grenade_for_level("sticky_grenade_zm");

		maps\mp\zombies\_zm_weapons::register_zombie_weapon_callback("willy_pete_zm", ::player_give_willy_pete);
		register_tactical_grenade_for_level("willy_pete_zm");
		level.zombie_weapons["willy_pete_zm"].is_in_box = 1;
	}

	if (level.script == "zm_tomb")
	{
		include_weapon("held_one_inch_punch_zm", 0);
		register_melee_weapon_for_level("held_one_inch_punch_zm");

		include_weapon("held_one_inch_punch_upgraded_zm", 0);
		register_melee_weapon_for_level("held_one_inch_punch_upgraded_zm");

		include_weapon("held_one_inch_punch_air_zm", 0);
		register_melee_weapon_for_level("held_one_inch_punch_air_zm");

		include_weapon("held_one_inch_punch_fire_zm", 0);
		register_melee_weapon_for_level("held_one_inch_punch_fire_zm");

		include_weapon("held_one_inch_punch_ice_zm", 0);
		register_melee_weapon_for_level("held_one_inch_punch_ice_zm");

		include_weapon("held_one_inch_punch_lightning_zm", 0);
		register_melee_weapon_for_level("held_one_inch_punch_lightning_zm");

		include_weapon("bouncingbetty_zm", 0);
		add_zombie_weapon("bouncingbetty_zm", undefined, &"ZOMBIE_WEAPON_BOUNCINGBETTY", 1000, "wpck_explo", "", undefined, 1);
		register_placeable_mine_for_level("bouncingbetty_zm");
	}

	if (isdefined(level.zombie_weapons["saritch_zm"]))
	{
		level.zombie_weapons["saritch_zm"].is_in_box = 0;
		level.zombie_weapons["saritch_zm"].cost = 500;
		level.zombie_weapons["saritch_zm"].ammo_cost = 250;
		level.vox.speaker["player"].alias["weapon_pickup"]["saritch_zm"] = "";
	}
	else
	{
		include_weapon("saritch_zm", 0);
		include_weapon("saritch_upgraded_zm", 0);
		add_zombie_weapon("saritch_zm", "saritch_upgraded_zm", &"ZOMBIE_WEAPON_SARITCH", 500, "", "", undefined, 1);
	}

	if (!isdefined(level.zombie_weapons["ballista_zm"]))
	{
		include_weapon("ballista_zm", 0);
		include_weapon("ballista_upgraded_zm", 0);
		add_zombie_weapon("ballista_zm", "ballista_upgraded_zm", &"ZMWEAPON_BALLISTA_WALLBUY", 500, "", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["mp5k_zm"]))
	{
		include_weapon("insas_zm", 0);
		include_weapon("insas_upgraded_zm", 0);
		add_zombie_weapon("insas_zm", "insas_upgraded_zm", &"ZOMBIE_WEAPON_INSAS", 1000, "", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["ak74u_zm"]))
	{
		include_weapon("vector_zm", 0);
		include_weapon("vector_upgraded_zm", 0);
		add_zombie_weapon("vector_zm", "vector_upgraded_zm", &"ZOMBIE_WEAPON_VECTOR", 1200, "", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["ak74u_extclip_zm"]))
	{
		level.zombie_weapons["ak74u_extclip_zm"].is_in_box = 0;

		include_weapon("vector_extclip_zm");
		include_weapon("vector_extclip_upgraded_zm", 0);
		add_zombie_weapon("vector_extclip_zm", "vector_extclip_upgraded_zm", &"ZOMBIE_WEAPON_VECTOR", 1200, "wpck_smg", "", undefined, 1);
		add_shared_ammo_weapon("vector_extclip_zm", "vector_zm");
	}

	if (level.script == "zm_buried")
	{
		include_weapon("qcw05_zm");
		include_weapon("qcw05_upgraded_zm", 0);
		add_zombie_weapon("qcw05_zm", "qcw05_upgraded_zm", &"ZOMBIE_WEAPON_QCW05", 1000, "wpck_chicom", "", undefined, 1);
	}

	if (level.script == "zm_nuked" || level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
	{
		include_weapon("mp7_zm");
		include_weapon("mp7_upgraded_zm", 0);
		add_zombie_weapon("mp7_zm", "mp7_upgraded_zm", &"WEAPON_MP7", 1000, "", "", undefined, 1);
	}

	if (level.script == "zm_nuked" || level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried" || level.script == "zm_prison" || level.script == "zm_tomb")
	{
		vox = "";

		if (level.script == "zm_prison" || level.script == "zm_tomb")
		{
			vox = "wpck_smg";
		}

		include_weapon("peacekeeper_zm");
		include_weapon("peacekeeper_upgraded_zm", 0);
		add_zombie_weapon("peacekeeper_zm", "peacekeeper_upgraded_zm", &"WEAPON_PEACEKEEPER", 1000, vox, "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["m16_zm"]))
	{
		include_weapon("sig556_zm", 0);
		include_weapon("sig556_upgraded_zm", 0);
		add_zombie_weapon("sig556_zm", "sig556_upgraded_zm", &"ZOMBIE_WEAPON_SIG556", 1200, "", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["python_zm"]))
	{
		level.zombie_weapons["python_zm"].is_in_box = 0;
	}

	if (level.script == "zm_buried")
	{
		level.zombie_weapons["judge_zm"].is_in_box = 0;
	}
	else if (level.script == "zm_tomb")
	{
		include_weapon("judge_zm");
		include_weapon("judge_upgraded_zm", 0);
		add_zombie_weapon("judge_zm", "judge_upgraded_zm", &"ZOMBIE_WEAPON_JUDGE", 1000, "wpck_pistol", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["galil_zm"]))
	{
		level.zombie_weapons["galil_zm"].is_in_box = 0;
	}

	if (level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried" || level.script == "zm_prison" || level.script == "zm_tomb")
	{
		vox = "";

		if (level.script == "zm_prison")
		{
			vox = "wpck_mg";
		}
		else if (level.script == "zm_tomb")
		{
			vox = "wpck_rifle";
		}

		include_weapon("hk416_zm");
		include_weapon("hk416_upgraded_zm", 0);
		add_zombie_weapon("hk416_zm", "hk416_upgraded_zm", &"ZOMBIE_WEAPON_HK416", 1000, vox, "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["fnfal_zm"]))
	{
		level.zombie_weapons["fnfal_zm"].is_in_box = 0;

		vox = "wpck_fal";

		if (level.script == "zm_prison")
		{
			vox = "wpck_mg";
		}
		else if (level.script == "zm_tomb")
		{
			vox = "wpck_rifle";
		}

		include_weapon("sa58_zm");
		include_weapon("sa58_upgraded_zm", 0);
		add_zombie_weapon("sa58_zm", "sa58_upgraded_zm", &"WEAPON_SA58", 1000, vox, "", undefined, 1);
	}

	if (level.script == "zm_buried")
	{
		include_weapon("xm8_zm");
		include_weapon("xm8_upgraded_zm", 0);
		add_zombie_weapon("xm8_zm", "xm8_upgraded_zm", &"ZOMBIE_WEAPON_XM8", 1000, "wpck_m8a1", "", undefined, 1);
	}

	if (level.script == "zm_buried")
	{
		include_weapon("type95_zm");
		include_weapon("type95_upgraded_zm", 0);
		add_zombie_weapon("type95_zm", "type95_upgraded_zm", &"ZOMBIE_WEAPON_TYPE95", 1000, "wpck_type25", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["rpd_zm"]))
	{
		level.zombie_weapons["rpd_zm"].is_in_box = 0;
	}

	if (level.script == "zm_nuked" || level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried")
	{
		include_weapon("mk48_zm");
		include_weapon("mk48_upgraded_zm", 0);
		add_zombie_weapon("mk48_zm", "mk48_upgraded_zm", &"WEAPON_MK48", 1000, "wpck_rpd", "", undefined, 1);
	}

	if (level.script == "zm_prison")
	{
		include_weapon("qbb95_zm");
		include_weapon("qbb95_upgraded_zm", 0);
		add_zombie_weapon("qbb95_zm", "qbb95_upgraded_zm", &"WEAPON_QBB95", 1000, "wpck_mg", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["barretm82_zm"]))
	{
		level.zombie_weapons["barretm82_zm"].is_in_box = 0;

		vox = "wpck_m82a1";

		if (level.script == "zm_transit" || level.script == "zm_nuked")
		{
			vox = "sniper";
		}
		else if (level.script == "zm_prison")
		{
			vox = "wpck_snipe";
		}

		include_weapon("as50_zm");
		include_weapon("as50_upgraded_zm", 0);
		add_zombie_weapon("as50_zm", "as50_upgraded_zm", &"WEAPON_AS50", 1000, vox, "", undefined, 1);
	}

	if (level.script == "zm_tomb")
	{
		include_weapon("crossbow_zm");
		include_weapon("crossbow_upgraded_zm", 0);
		add_limited_weapon("crossbow_zm", 1);
		add_limited_weapon("crossbow_upgraded_zm", 1);
		add_zombie_weapon("crossbow_zm", "crossbow_upgraded_zm", &"WEAPON_CROSSBOW_EXPLOSIVE", 1000, "wpck_explo", "", undefined, 1);
		precacheitem("crossbow_explosive_bolt_zm");
		precacheitem("crossbow_explosive_bolt_upgraded_zm");
	}

	if (isdefined(level.zombie_weapons["beretta93r_extclip_zm"]))
	{
		level.zombie_weapons["beretta93r_extclip_zm"].is_in_box = 0;
	}

	if (level.script == "zm_tomb")
	{
		level.zombie_weapons["fivesevendw_zm"].cost = 1100;
		level.zombie_weapons["fivesevendw_zm"].ammo_cost = 550;
		add_shared_ammo_weapon("fivesevendw_zm", "fiveseven_zm");
	}

	if (level.script == "zm_tomb")
	{
		include_weapon("mp44_fastads_zm");
		include_weapon("mp44_fastads_upgraded_zm", 0);
		add_zombie_weapon("mp44_fastads_zm", "mp44_fastads_upgraded_zm", &"ZMWEAPON_MP44_WALLBUY", 1400, "wpck_rifle", "", undefined, 1);
		add_shared_ammo_weapon("mp44_fastads_zm", "mp44_zm");
	}

	if (isdefined(level.zombie_weapons["evoskorpion_zm"]))
	{
		level.zombie_weapons["evoskorpion_zm"].cost = 1400;
		level.zombie_weapons["evoskorpion_zm"].ammo_cost = 700;
	}

	if (isdefined(level.zombie_weapons["scar_zm"]))
	{
		level.zombie_weapons["scar_zm"].cost = 1600;
		level.zombie_weapons["scar_zm"].ammo_cost = 800;
	}

	if (isdefined(level.zombie_weapons["mg08_zm"]))
	{
		level.zombie_weapons["mg08_zm"].cost = 2000;
		level.zombie_weapons["mg08_zm"].ammo_cost = 1000;
	}

	if (isdefined(level.zombie_weapons["ksg_zm"]))
	{
		level.zombie_weapons["ksg_zm"].cost = 1800;
		level.zombie_weapons["ksg_zm"].ammo_cost = 900;
	}

	if (level.script == "zm_transit" || level.script == "zm_nuked" || level.script == "zm_highrise" || level.script == "zm_prison")
	{
		level.zombie_lethal_grenade_player_init = "sticky_grenade_zm";
	}
}

player_give_willy_pete()
{
	self endon("disconnect");

	self setclientfieldtoplayer("tomahawk_in_use", 0);

	wait 0.05;

	self giveweapon("willy_pete_zm");
}

wallbuy_cost_changes()
{
	flag_wait("initial_blackscreen_passed");

	if (isDefined(level.zombie_weapons["beretta93r_zm"]))
	{
		cost = 900;
		level.zombie_weapons["beretta93r_zm"].cost = cost;
		level.zombie_weapons["beretta93r_zm"].ammo_cost = int(cost / 2);
	}

	if (isDefined(level.zombie_weapons["870mcs_zm"]))
	{
		cost = 1200;
		level.zombie_weapons["870mcs_zm"].cost = cost;
		level.zombie_weapons["870mcs_zm"].ammo_cost = int(cost / 2);
	}

	if (isDefined(level.zombie_weapons["an94_zm"]))
	{
		cost = 1500;
		level.zombie_weapons["an94_zm"].cost = cost;
		level.zombie_weapons["an94_zm"].ammo_cost = int(cost / 2);
	}

	if (isDefined(level.zombie_weapons["thompson_zm"]))
	{
		level.zombie_weapons["thompson_zm"].ammo_cost = 750;
	}
}

player_waypoint()
{
	self endon("disconnect");

	self.obj_ind = self.entity_num;
	self.clone_obj_ind = self.obj_ind + 8;

	objective_state(self.obj_ind, "active");
	objective_onentity(self.obj_ind, self);
	objective_setgamemodeflags(self.obj_ind, 0);
	objective_position(self.obj_ind, (0, 0, getdvarint("waypointPlayerOffsetStand")));

	self waittill_next_snapshot(1);

	flag_wait("hud_visible");

	self thread player_waypoint_height_offset_think();
}

player_waypoint_height_offset_think()
{
	self endon("disconnect");

	prev_stance = "";

	while (1)
	{
		stance = self getstance();

		if (!self isonground() && !is_true(self.divetoprone))
		{
			stance = "stand";
		}

		if (prev_stance == stance)
		{
			wait 0.05;
			continue;
		}

		prev_stance = stance;
		height_offset = getdvarint("waypointPlayerOffsetStand");

		if (stance == "crouch")
		{
			height_offset = getdvarint("waypointPlayerOffsetCrouch");
		}
		else if (stance == "prone")
		{
			height_offset = getdvarint("waypointPlayerOffsetProne");
		}

		objective_position(self.obj_ind, (0, 0, height_offset));

		wait 0.05;
	}
}

grenade_fire_watcher()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("grenade_fire", grenade, weapname);

		if (is_lethal_grenade(weapname) || is_tactical_grenade(weapname))
		{
			self thread temp_disable_offhand_weapons();
		}

		if (isdefined(level.headchopper_name) && weapname == level.headchopper_name)
		{
			grenade.angles = (0, grenade.angles[1], 0);
		}
	}
}

temp_disable_offhand_weapons()
{
	self endon("disconnect");
	self endon("entering_last_stand");

	self disableOffhandWeapons();

	while (self isThrowingGrenade())
	{
		wait 0.05;
	}

	if (!is_true(self.is_drinking))
	{
		self enableOffhandWeapons();
	}
}

create_equipment_turret_watcher()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("create_equipment_turret", equipment, turret);

		hide_turret = 0;

		if (isdefined(level.turbine_name) && equipment == level.turbine_name)
		{
			self thread turbine_equipment_rotate_model(equipment, turret);
			hide_turret = 1;
		}
		else if (isdefined(level.turret_name) && equipment == level.turret_name)
		{
			hide_turret = 1;
		}
		else if (isdefined(level.electrictrap_name) && equipment == level.electrictrap_name)
		{
			hide_turret = 1;
		}
		else if (isdefined(level.springpad_name) && equipment == level.springpad_name)
		{
			hide_turret = 1;
		}
		else if (isdefined(level.subwoofer_name) && equipment == level.subwoofer_name)
		{
			hide_turret = 1;
		}

		if (hide_turret)
		{
			turret setinvisibletoall();
			turret setvisibletoplayer(self);
		}
	}
}

turbine_equipment_rotate_model(equipment, turret)
{
	// don't hide or ghost, makes linkto not work
	turret setmodel("tag_origin");

	model = spawnturret("auto_turret", turret.origin, equipment + "_turret");
	model.angles = turret.angles + (0, 90, 0);
	model setmodel(level.placeable_equipment[equipment]);
	model linkto(turret);
	model setinvisibletoall();
	model setvisibletoplayer(self);

	self waittill_any("destroy_equipment_turret", "disconnect");

	model delete();
}

sndmeleewpnsound()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("weapon_melee", weapon);

		alias = "zmb_melee_whoosh_npc";

		if (is_true(self.is_player_zombie))
		{
			alias = "zmb_melee_whoosh_zmb_npc";
		}
		else if (issubstr(weapon, "shield_zm"))
		{
			alias = "fly_riotshield_zm_swing";
		}
		else if (issubstr(weapon, "bowie_knife_zm") || issubstr(weapon, "knife_ballistic_bowie"))
		{
			alias = "zmb_bowie_swing";
		}
		else if (issubstr(weapon, "tazer_knuckles_zm") || issubstr(weapon, "knife_ballistic_no_melee"))
		{
			alias = "wpn_tazer_whoosh_npc";
		}
		else if (issubstr(weapon, "spoon_zm_alcatraz"))
		{
			alias = "zmb_spoon_swing";
		}
		else if (issubstr(weapon, "spork_zm_alcatraz"))
		{
			alias = "zmb_spork_swing";
		}
		else if (issubstr(weapon, "one_inch_punch_zm") || issubstr(weapon, "one_inch_punch_upgraded_zm"))
		{
			alias = "wpn_one_inch_punch_npc";
		}
		else if (issubstr(weapon, "one_inch_punch_fire_zm"))
		{
			alias = "wpn_one_inch_punch_fire_npc";
		}
		else if (issubstr(weapon, "one_inch_punch_air_zm"))
		{
			alias = "wpn_one_inch_punch_air_npc";
		}
		else if (issubstr(weapon, "one_inch_punch_ice_zm"))
		{
			alias = "wpn_one_inch_punch_ice_npc";
		}
		else if (issubstr(weapon, "one_inch_punch_lightning_zm"))
		{
			alias = "wpn_one_inch_punch_lightning_npc";
		}
		else if (sndmeleewpn_isstaff(weapon))
		{
			alias = "zmb_melee_staff_upgraded_npc";
		}

		if (maps\mp\zombies\_zm_audio::sndisnetworksafe())
		{
			self play_sound_to_nearby_players(alias);
		}
	}
}

sndmeleewpn_isstaff(weapon)
{
	switch (weapon)
	{
		case "staff_melee_zm":
		case "staff_air_melee_zm":
		case "staff_fire_melee_zm":
		case "staff_water_melee_zm":
		case "staff_lightning_melee_zm":

			isstaff = 1;
			break;

		default:
			isstaff = 0;
	}

	return isstaff;
}

play_sound_to_nearby_players(alias, range = 500)
{
	players = get_players();

	foreach (player in players)
	{
		if (player != self && distancesquared(player.origin, self.origin) <= range * range)
		{
			self playsoundtoplayer(alias, player);
		}
	}
}

buildbuildables()
{
	wait 1; // need a wait or else some buildables dont build

	if (is_classic())
	{
		if (level.script == "zm_transit")
		{
			level.buildables_available = array("turbine", "riotshield_zm", "turret", "electric_trap", "jetgun_zm");

			buildbuildable("turbine");
			buildbuildable("electric_trap");
			buildbuildable("turret");
			buildbuildable("riotshield_zm");
			buildbuildable("jetgun_zm");
			buildbuildable("powerswitch", 1);
			buildbuildable("pap", 1);
			buildbuildable("sq_common", 1);
			buildbuildable("dinerhatch", 1, 0);

			// power switch is not showing up from forced build
			show_powerswitch();
		}
		else if (level.script == "zm_highrise")
		{
			level.buildables_available = array("springpad_zm", "slipgun_zm");

			buildbuildable("slipgun_zm");
			buildbuildable("springpad_zm");
			buildbuildable("sq_common", 1);
		}
		else if (level.script == "zm_buried")
		{
			flag_wait("initial_blackscreen_passed"); // wait for buildables to randomize
			wait 1;

			level.buildables_available = array("subwoofer_zm", "springpad_zm", "headchopper_zm");

			removebuildable("keys_zm");
			removebuildable("booze");
			removebuildable("candy");
			removebuildable("sloth");
			buildbuildable("turbine");
			buildbuildable("subwoofer_zm");
			buildbuildable("springpad_zm");
			buildbuildable("headchopper_zm");
			buildbuildable("sq_common", 1);
			buildbuildable("buried_sq_bt_m_tower", 0, 1, 1, ::onuseplantobject_mtower);
			buildbuildable("buried_sq_bt_r_tower", 0, 1, 1, ::onuseplantobject_rtower);
		}
	}
	else
	{
		if (level.script == "zm_highrise")
		{
			buildbuildable("springpad_zm", 1);
			buildbuildable("slipgun_zm", 1);
		}
		else if (level.script == "zm_buried" && level.scr_zm_map_start_location == "street")
		{
			flag_wait("initial_blackscreen_passed"); // wait for buildables to be built
			wait 1;

			updatebuildables();
			removebuildable("turbine", "buried");
		}
	}
}

buildbuildable(buildable, craft = 0, remove_pieces = 1, solo_pool = 0, onuse)
{
	player = get_players()[0];

	foreach (stub in level.buildable_stubs)
	{
		if (!isDefined(buildable) || stub.equipname == buildable)
		{
			if (isDefined(buildable) || stub.persistent != 3)
			{
				stub.cost = stub get_equipment_cost();
				stub.trigger_func = scripts\zm\replaced\_zm_buildables_pooled::pooled_buildable_place_think;

				if (isDefined(onuse))
				{
					stub.buildablestruct.onuseplantobject = onuse;
				}

				if (craft)
				{
					stub.original_prompt_and_visibility_func = stub.prompt_and_visibility_func;
					stub.prompt_and_visibility_func = scripts\zm\replaced\_zm_buildables_pooled::pooledbuildabletrigger_update_prompt;

					stub maps\mp\zombies\_zm_buildables::buildablestub_finish_build(player);
					stub maps\mp\zombies\_zm_buildables::buildablestub_remove();

					if (isdefined(stub.model))
					{
						stub.model notsolid();
						stub.model show();
					}
				}
				else
				{
					if (level.script == "zm_buried")
					{
						if (solo_pool)
						{
							stub.solo_pool = 1;
							scripts\zm\replaced\_zm_buildables_pooled::add_buildable_to_pool(stub, stub.equipname);
						}
					}
					else
					{
						scripts\zm\replaced\_zm_buildables_pooled::add_buildable_to_pool(stub, level.script);
					}
				}

				if (remove_pieces)
				{
					foreach (piece in stub.buildablezone.pieces)
					{
						piece maps\mp\zombies\_zm_buildables::piece_unspawn();
					}
				}

				return;
			}
		}
	}
}

get_equipment_cost()
{
	if (self.equipname == "turbine")
	{
		return 500;
	}
	else if (self.equipname == "jetgun_zm")
	{
		return 10000;
	}
	else if (self.equipname == "slipgun_zm")
	{
		return 10000;
	}
	else if (self.equipname == "packasplat")
	{
		return 2500;
	}

	return 1000;
}

// adds updated hintstring and functionality
updatebuildables()
{
	foreach (stub in level._unitriggers.trigger_stubs)
	{
		if (IsDefined(stub.equipname) && stub.equipname != "chalk")
		{
			stub.cost = stub get_equipment_cost();
			stub.trigger_func = scripts\zm\replaced\_zm_buildables_pooled::pooled_buildable_place_think;
			stub.prompt_and_visibility_func = scripts\zm\replaced\_zm_buildables_pooled::pooledbuildabletrigger_update_prompt;
		}
	}
}

removebuildable(buildable, poolname)
{
	if (isDefined(poolname))
	{
		foreach (stub in level.buildablepools[poolname].stubs)
		{
			if (IsDefined(stub.equipname) && stub.equipname == buildable)
			{
				stub.model hide();
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
				return;
			}
		}
	}
	else
	{
		foreach (stub in level.buildable_stubs)
		{
			if (!isDefined(buildable) || stub.equipname == buildable)
			{
				if (isDefined(buildable) || stub.persistent != 3)
				{
					stub maps\mp\zombies\_zm_buildables::buildablestub_remove();

					foreach (piece in stub.buildablezone.pieces)
					{
						piece maps\mp\zombies\_zm_buildables::piece_unspawn();
					}

					maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
					return;
				}
			}
		}
	}
}

onuseplantobject_mtower(player)
{
	level setclientfield("sq_gl_b_vt", 1);
	level setclientfield("sq_gl_b_bb", 1);
	level setclientfield("sq_gl_b_a", 1);
	level setclientfield("sq_gl_b_ws", 1);
	level notify("mtower_object_planted");

	self maps\mp\zombies\_zm_buildables::buildablestub_finish_build(player);
	player playsound("zmb_buildable_complete");

	level thread unregister_tower_unitriggers();
}

onuseplantobject_rtower(player)
{
	m_tower = getent("sq_guillotine", "targetname");
	m_tower sq_tower_spawn_attachment("p6_zm_bu_sq_crystal", "j_crystal_01");
	m_tower sq_tower_spawn_attachment("p6_zm_bu_sq_satellite_dish", "j_satellite");
	m_tower sq_tower_spawn_attachment("p6_zm_bu_sq_antenna", "j_antenna");
	m_tower sq_tower_spawn_attachment("p6_zm_bu_sq_wire_spool", "j_spool");
	level notify("rtower_object_planted");

	self maps\mp\zombies\_zm_buildables::buildablestub_finish_build(player);
	player playsound("zmb_buildable_complete");

	level thread unregister_tower_unitriggers();
}

sq_tower_spawn_attachment(str_model, str_tag)
{
	m_part = spawn("script_model", self gettagorigin(str_tag));
	m_part.angles = self gettagangles(str_tag);
	m_part setmodel(str_model);
}

unregister_tower_unitriggers()
{
	foreach (stub in level.buildable_stubs)
	{
		if (isDefined(stub.equipname))
		{
			if (stub.equipname == "buried_sq_bt_m_tower" || stub.equipname == "buried_sq_bt_r_tower")
			{
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
			}
		}
	}
}

// MOTD\Origins style buildables
buildcraftables()
{
	flag_wait("initial_blackscreen_passed");

	if (is_true(level.zombiemode_using_afterlife))
	{
		flag_wait("afterlife_start_over");
	}

	if (is_classic())
	{
		if (level.script == "zm_prison")
		{
			buildcraftable("alcatraz_shield_zm");
			buildcraftable("packasplat");
		}
		else if (level.script == "zm_tomb")
		{
			buildcraftable("tomb_shield_zm");
			buildcraftable("equip_dieseldrone_zm");
			takecraftableparts("gramophone");
		}
	}
}

takecraftableparts(buildable)
{
	player = get_players()[0];

	foreach (stub in level.zombie_include_craftables)
	{
		if (stub.name == buildable)
		{
			foreach (piece in stub.a_piecestubs)
			{
				piecespawn = piece.piecespawn;

				if (isDefined(piecespawn))
				{
					player player_take_piece(piecespawn);
				}
			}

			return;
		}
	}
}

buildcraftable(buildable)
{
	player = get_players()[0];

	foreach (stub in level.a_uts_craftables)
	{
		if (stub.craftablestub.name == buildable)
		{
			foreach (piece in stub.craftablespawn.a_piecespawns)
			{
				piecespawn = get_craftable_piece(stub.craftablestub.name, piece.piecename);

				if (isDefined(piecespawn))
				{
					player player_take_piece(piecespawn);
				}
			}

			return;
		}
	}
}

get_craftable_piece(str_craftable, str_piece)
{
	foreach (uts_craftable in level.a_uts_craftables)
	{
		if (uts_craftable.craftablestub.name == str_craftable)
		{
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
			{
				if (piecespawn.piecename == str_piece)
				{
					return piecespawn;
				}
			}
		}
	}

	return undefined;
}

player_take_piece(piecespawn)
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if (isDefined(piecestub.onpickup))
	{
		piecespawn [[piecestub.onpickup]](self);
	}

	if (isDefined(piecestub.is_shared) && piecestub.is_shared)
	{
		if (isDefined(piecestub.client_field_id))
		{
			level setclientfield(piecestub.client_field_id, 1);
		}
	}
	else
	{
		if (isDefined(piecestub.client_field_state))
		{
			self setclientfieldtoplayer("craftable", piecestub.client_field_state);
		}
	}

	piecespawn piece_unspawn();
	piecespawn notify("pickup");

	if (isDefined(piecestub.is_shared) && piecestub.is_shared)
	{
		piecespawn.in_shared_inventory = 1;
	}

	self adddstat("buildables", piecespawn.craftablename, "pieces_pickedup", 1);
}

piece_unspawn()
{
	if (isDefined(self.model))
	{
		self.model delete();
	}

	self.model = undefined;

	if (isDefined(self.unitrigger))
	{
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.unitrigger);
	}

	self.unitrigger = undefined;
}

remove_buildable_pieces(buildable_name)
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if (IsDefined(buildable.name) && buildable.name == buildable_name)
		{
			pieces = buildable.buildablepieces;

			for (i = 0; i < pieces.size; i++)
			{
				pieces[i] maps\mp\zombies\_zm_buildables::piece_unspawn();
			}

			return;
		}
	}
}

jetgun_remove_forced_weapon_switch()
{
	if (!IsDefined(level.zombie_include_buildables))
	{
		return;
	}

	foreach (buildable in level.zombie_include_buildables)
	{
		if (IsDefined(buildable.name) && buildable.name == "jetgun_zm")
		{
			buildable.onbuyweapon = undefined;
			return;
		}
	}
}

give_additional_perks()
{
	self endon("disconnect");

	while (1)
	{
		self waittill_any("perk_acquired", "perk_lost");

		if (self HasPerk("specialty_fastreload"))
		{
			self SetPerk("specialty_fastads");
			self SetPerk("specialty_fastweaponswitch");
			self Setperk("specialty_fasttoss");
		}
		else
		{
			self UnsetPerk("specialty_fastads");
			self UnsetPerk("specialty_fastweaponswitch");
			self Unsetperk("specialty_fasttoss");
		}

		if (self HasPerk("specialty_deadshot"))
		{
			self SetPerk("specialty_stalker");
			self Setperk("specialty_sprintrecovery");
		}
		else
		{
			self UnsetPerk("specialty_stalker");
			self Unsetperk("specialty_sprintrecovery");
		}
	}
}

bank_gain_interest_after_rounds()
{
	self endon("disconnect");

	while (1)
	{
		level waittill("end_of_round");

		if (isDefined(self.account_value))
		{
			self.account_value *= 1.1;

			if (self.account_value > level.bank_account_max)
			{
				self.account_value = level.bank_account_max;
			}

			self notify("update_account_value");
		}
	}
}

weapon_locker_give_ammo_after_rounds()
{
	self endon("disconnect");

	while (1)
	{
		level waittill("end_of_round");

		if (isDefined(self.stored_weapon_data))
		{
			if (self.stored_weapon_data["name"] != "none")
			{
				self.stored_weapon_data["clip"] = weaponClipSize(self.stored_weapon_data["name"]);
				self.stored_weapon_data["stock"] = weaponMaxAmmo(self.stored_weapon_data["name"]);
			}

			if (self.stored_weapon_data["dw_name"] != "none")
			{
				self.stored_weapon_data["lh_clip"] = weaponClipSize(self.stored_weapon_data["dw_name"]);
			}

			if (self.stored_weapon_data["alt_name"] != "none")
			{
				self.stored_weapon_data["alt_clip"] = weaponClipSize(self.stored_weapon_data["alt_name"]);
				self.stored_weapon_data["alt_stock"] = weaponMaxAmmo(self.stored_weapon_data["alt_name"]);
			}
		}
	}
}

alt_weapon_name_hud()
{
	self endon("disconnect");

	prev_alt_weapon_names = "";

	while (1)
	{
		alt_weapon_names = "";
		primaries = self getweaponslistprimaries();

		foreach (primary in primaries)
		{
			if (weaponaltweaponname(primary) == "none")
			{
				continue;
			}

			weapon_name = getweapondisplayname(primary);
			alt_weapon_name = getweapondisplayname(weaponaltweaponname(primary));

			if (weapon_name == alt_weapon_name)
			{
				continue;
			}

			alt_weapon_names += weapon_name + ":" + alt_weapon_name + ";";
		}

		if (prev_alt_weapon_names != alt_weapon_names)
		{
			prev_alt_weapon_names = alt_weapon_names;
			self setClientDvar("weaponAltWeaponNames", alt_weapon_names);
		}

		wait 0.05;
	}
}

additionalprimaryweapon_indicator()
{
	self endon("disconnect");

	if (!is_true(level.zombiemode_using_additionalprimaryweapon_perk))
	{
		return;
	}

	prev_weapon_name = "";

	while (1)
	{
		weapon_name = "";

		player = self get_current_spectating_player();

		if (player == self)
		{
			self additionalprimaryweapon_update_weapon_slots();
		}

		if (player hasPerk("specialty_additionalprimaryweapon"))
		{
			weapon = player.weapon_to_take_by_losing_specialty_additionalprimaryweapon;

			if (isDefined(weapon))
			{
				weapon_name = getweapondisplayname(weapon);
			}
		}

		if (prev_weapon_name != weapon_name)
		{
			prev_weapon_name = weapon_name;
			self setClientDvar("additionalPrimaryWeaponName", weapon_name);
		}

		wait 0.05;
	}
}

additionalprimaryweapon_update_weapon_slots()
{
	if (!isDefined(self.weapon_slots))
	{
		self.weapon_slots = [];
	}

	primaries_that_can_be_taken = [];
	primaries = self getweaponslistprimaries();

	for (i = 0; i < primaries.size; i++)
	{
		if (maps\mp\zombies\_zm_weapons::is_weapon_included(primaries[i]) || maps\mp\zombies\_zm_weapons::is_weapon_upgraded(primaries[i]))
		{
			primaries_that_can_be_taken[primaries_that_can_be_taken.size] = primaries[i];
		}
	}

	for (i = 0; i < self.weapon_slots.size; i++)
	{
		if (!self hasWeapon(self.weapon_slots[i]))
		{
			self.weapon_slots[i] = "none";
		}
	}

	for (i = 0; i < primaries_that_can_be_taken.size; i++)
	{
		weapon = primaries_that_can_be_taken[i];

		if (!isInArray(self.weapon_slots, weapon))
		{
			added = 0;

			for (j = 0; j < self.weapon_slots.size; j++)
			{
				if (self.weapon_slots[j] == "none")
				{
					added = 1;
					self.weapon_slots[j] = weapon;
					break;
				}
			}

			if (!added)
			{
				self.weapon_slots[self.weapon_slots.size] = weapon;
			}
		}
	}

	num_weapons = 0;

	for (i = 0; i < self.weapon_slots.size; i++)
	{
		if (self.weapon_slots[i] != "none")
		{
			num_weapons++;
		}
	}

	if (num_weapons >= get_player_weapon_limit(self))
	{
		self.weapon_to_take_by_losing_specialty_additionalprimaryweapon = self.weapon_slots[self.weapon_slots.size - 1];
	}
	else
	{
		self.weapon_to_take_by_losing_specialty_additionalprimaryweapon = undefined;
	}
}

additionalprimaryweapon_stowed_weapon_refill()
{
	self endon("disconnect");

	while (1)
	{
		result = self waittill_any_return("weapon_change", "weapon_change_complete", "perk_additionalprimaryweapon_activated", "specialty_additionalprimaryweapon_stop", "spawned_player");

		if (self hasPerk("specialty_additionalprimaryweapon"))
		{
			curr_wep = self getCurrentWeapon();

			if (curr_wep == "none")
			{
				continue;
			}

			primaries = self getWeaponsListPrimaries();

			foreach (primary in primaries)
			{
				if (primary != maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(curr_wep))
				{
					if (result != "weapon_change")
					{
						self thread refill_after_time(primary);
					}
				}
				else
				{
					self notify(primary + "_reload_stop");
				}
			}
		}
	}
}

refill_after_time(primary)
{
	self endon(primary + "_reload_stop");
	self endon("specialty_additionalprimaryweapon_stop");
	self endon("spawned_player");

	reload_time = weaponReloadTime(primary);
	reload_amount = undefined;

	if (primary == "m32_zm" || primary == "python_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "judge_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "870mcs_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "ksg_zm")
	{
		reload_amount = 1;

		if (maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "ksg_zm" && maps\mp\zombies\_zm_weapons::is_weapon_upgraded(primary))
		{
			reload_amount = 2;
		}
	}

	if (!isDefined(reload_amount) && reload_time < 1)
	{
		reload_time = 1;
	}

	if (self hasPerk("specialty_fastreload"))
	{
		reload_time *= getDvarFloat("perk_weapReloadMultiplier");
	}

	wait reload_time;

	ammo_clip = self getWeaponAmmoClip(primary);
	ammo_stock = self getWeaponAmmoStock(primary);
	missing_clip = weaponClipSize(primary) - ammo_clip;
	og_ammo_stock = ammo_stock;

	if (missing_clip > ammo_stock)
	{
		missing_clip = ammo_stock;
	}

	if (isDefined(reload_amount) && missing_clip > reload_amount)
	{
		missing_clip = reload_amount;
	}

	dw_primary = weaponDualWieldWeaponName(primary);
	alt_primary = weaponAltWeaponName(primary);

	ammo_stock -= missing_clip;

	if (dw_primary != "none" && self hasweapon(dw_primary))
	{
		dw_ammo_clip = self getWeaponAmmoClip(dw_primary);
		dw_missing_clip = weaponClipSize(dw_primary) - dw_ammo_clip;

		if (dw_missing_clip > ammo_stock)
		{
			dw_missing_clip = ammo_stock;
		}

		ammo_stock -= dw_missing_clip;
	}

	if (ammo_stock != og_ammo_stock)
	{
		// setWeaponAmmoClip changes dual wield weapon clip ammo of current weapon when called on any dual wield weapon
		curr_primary = self getCurrentWeapon();
		curr_dw_primary = weaponDualWieldWeaponName(curr_primary);
		curr_dw_ammo_clip = 0;

		// save current dual wield weapon clip ammo
		if (dw_primary != "none" && curr_dw_primary != "none")
		{
			curr_dw_ammo_clip = self getWeaponAmmoClip(curr_dw_primary);
		}

		self setWeaponAmmoClip(primary, ammo_clip + missing_clip);

		if (dw_primary != "none")
		{
			self setWeaponAmmoClip(dw_primary, dw_ammo_clip + dw_missing_clip);
		}

		self setWeaponAmmoStock(primary, ammo_stock);

		// restore current dual wield weapon clip ammo
		if (dw_primary != "none" && curr_dw_primary != "none")
		{
			self setWeaponAmmoClip(curr_dw_primary, curr_dw_ammo_clip);
		}
	}

	if (alt_primary != "none" && self hasweapon(alt_primary))
	{
		ammo_clip = self getWeaponAmmoClip(alt_primary);
		ammo_stock = self getWeaponAmmoStock(alt_primary);
		missing_clip = weaponClipSize(alt_primary) - ammo_clip;

		if (missing_clip > ammo_stock)
		{
			missing_clip = ammo_stock;
		}

		self setWeaponAmmoClip(alt_primary, ammo_clip + missing_clip);
		self setWeaponAmmoStock(alt_primary, ammo_stock - missing_clip);
	}

	if (isDefined(reload_amount) && self getWeaponAmmoStock(primary) > 0 && self getWeaponAmmoClip(primary) < weaponClipSize(primary))
	{
		self refill_after_time(primary);
	}
}

show_powerswitch()
{
	getent("powerswitch_p6_zm_buildable_pswitch_hand", "targetname") show();
	getent("powerswitch_p6_zm_buildable_pswitch_body", "targetname") show();
	getent("powerswitch_p6_zm_buildable_pswitch_lever", "targetname") show();
}

zone_changes()
{
	if (level.script == "zm_transit")
	{
		if (level.scr_zm_map_start_location == "farm")
		{
			// Barn to Farm
			flag_set("OnFarm_enter");
		}
	}
	else if (level.script == "zm_highrise")
	{
		// Shopping Mall to Dragon Rooftop
		level.zones["zone_green_level3b"].adjacent_zones["zone_blue_level1c"] structdelete();
		level.zones["zone_green_level3b"].adjacent_zones["zone_blue_level1c"] = undefined;

		// Buddha Room debris
		level.zones["zone_orange_level3a"].adjacent_zones["zone_orange_level3b"].is_connected = 0;
		level.zones["zone_orange_level3b"].adjacent_zones["zone_orange_level3a"].is_connected = 0;
	}
}

player_suicide()
{
	self.playersuicided = 1;
	self notify("player_suicide");

	wait_network_frame();

	self maps\mp\zombies\_zm_laststand::bleed_out();
	self.playersuicided = undefined;
}

temp_weapon_disable_fast_weapon_switch(temp_weapon)
{
	self endon("disconnect");

	if (!self hasperk("specialty_fastweaponswitch"))
	{
		return;
	}

	if (self hasperk("specialty_fastreload"))
	{
		self unsetperk("specialty_fastweaponswitch");
	}

	while (1)
	{
		wait 0.05;

		if (!self isswitchingweapons() || self getcurrentweapon() == temp_weapon || !self hasweapon(temp_weapon))
		{
			break;
		}
	}

	if (self hasperk("specialty_fastreload"))
	{
		self setperk("specialty_fastweaponswitch");
	}
}

should_respawn()
{
	if (is_true(level.intermission))
	{
		return 0;
	}

	if (!flag("initial_blackscreen_passed"))
	{
		return 1;
	}

	if (isDefined(level.is_respawn_gamemode_func) && [[level.is_respawn_gamemode_func]]())
	{
		return 1;
	}

	return 0;
}

is_tazer_weapon(weapon)
{
	return issubstr(weapon, "tazer_knuckles") || issubstr(weapon, "knife_ballistic_no_melee");
}

is_overheat_weapon(weapon)
{
	return weapon == "jetgun_zm" || weapon == "slowgun_zm";
}

is_magicbox_wonder_weapon(weapon)
{
	return weapon == "metalstorm_mms_zm" || weapon == "titus6_zm" || weapon == "slipgun_zm" || weapon == "slowgun_zm" || weapon == "blundergat_zm";
}

get_player_speed()
{
	if (!self isonground())
	{
		return length(self getvelocity() * (1, 1, 0));
	}

	return length(self getvelocity());
}

get_current_spectating_player()
{
	players = get_players();

	foreach (player in players)
	{
		if (self.currentspectatingclient == player getentitynumber())
		{
			return player;
		}
	}

	return self;
}

get_grief_vox_postfix()
{
	if (level.script == "zm_nuked" || level.script == "zm_highrise")
	{
		return "_rich";
	}

	if (level.script == "zm_tomb")
	{
		return "_brutus";
	}

	return "";
}

update_perk_order()
{
	perk_order_str = "";
	player = self get_current_spectating_player();

	if (isdefined(player.perks_disabled))
	{
		foreach (perk in player.perks_disabled)
		{
			perk_order_str += perk + ";";
		}
	}

	if (isdefined(player.perks_active))
	{
		foreach (perk in player.perks_active)
		{
			perk_order_str += perk + ";";
		}
	}

	if (perk_order_str == "")
	{
		return;
	}

	if (player == self)
	{
		players = get_players();

		foreach (other_player in players)
		{
			if (other_player get_current_spectating_player() == self)
			{
				other_player setclientdvar("perk_order", perk_order_str);
				other_player luinotifyevent(&"hud_update_perk_order");
			}
		}
	}
	else
	{
		self setclientdvar("perk_order", perk_order_str);
		self luinotifyevent(&"hud_update_perk_order");
	}
}

clientnotifyloop(notify_str, endon_str)
{
	if (isdefined(endon_str))
	{
		level endon(endon_str);
	}

	while (1)
	{
		clientnotify(notify_str);

		level waittill("connected", player);

		wait 0.05;
	}
}

waittill_next_snapshot(require_playing = 0)
{
	self endon("disconnect");

	while (1)
	{
		num = self getsnapshotackindex();

		while (num == self getsnapshotackindex())
		{
			wait 0.05;
		}

		if (self.sessionstate == "playing" || !require_playing)
		{
			break;
		}

		self waittill("spawned_player");
	}
}

destroy_on_end_game()
{
	self endon("death");

	level waittill("end_game");

	if (isDefined(self.bar))
	{
		self.bar destroy();
	}

	if (isDefined(self.barframe))
	{
		self.barframe destroy();
	}

	self destroy();
}

destroy_on_intermission()
{
	self endon("death");

	level waittill("intermission");

	if (isDefined(self.bar))
	{
		self.bar destroy();
	}

	if (isDefined(self.barframe))
	{
		self.barframe destroy();
	}

	self destroy();
}