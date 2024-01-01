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
	replaceFunc(maps\mp\gametypes_zm\_hud_message::onplayerconnect, scripts\zm\replaced\_hud_message::onplayerconnect);
	replaceFunc(maps\mp\gametypes_zm\_zm_gametype::hide_gump_loading_for_hotjoiners, scripts\zm\replaced\_zm_gametype::hide_gump_loading_for_hotjoiners);
	replaceFunc(maps\mp\zombies\_zm::init_fx, scripts\zm\replaced\_zm::init_fx);
	replaceFunc(maps\mp\zombies\_zm::round_start, scripts\zm\replaced\_zm::round_start);
	replaceFunc(maps\mp\zombies\_zm::ai_calculate_health, scripts\zm\replaced\_zm::ai_calculate_health);
	replaceFunc(maps\mp\zombies\_zm::onallplayersready, scripts\zm\replaced\_zm::onallplayersready);
	replaceFunc(maps\mp\zombies\_zm::last_stand_pistol_rank_init, scripts\zm\replaced\_zm::last_stand_pistol_rank_init);
	replaceFunc(maps\mp\zombies\_zm::last_stand_best_pistol, scripts\zm\replaced\_zm::last_stand_best_pistol);
	replaceFunc(maps\mp\zombies\_zm::can_track_ammo, scripts\zm\replaced\_zm::can_track_ammo);
	replaceFunc(maps\mp\zombies\_zm::take_additionalprimaryweapon, scripts\zm\replaced\_zm::take_additionalprimaryweapon);
	replaceFunc(maps\mp\zombies\_zm::check_for_valid_spawn_near_team, scripts\zm\replaced\_zm::check_for_valid_spawn_near_team);
	replaceFunc(maps\mp\zombies\_zm::get_valid_spawn_location, scripts\zm\replaced\_zm::get_valid_spawn_location);
	replaceFunc(maps\mp\zombies\_zm::actor_damage_override, scripts\zm\replaced\_zm::actor_damage_override);
	replaceFunc(maps\mp\zombies\_zm::player_spawn_protection, scripts\zm\replaced\_zm::player_spawn_protection);
	replaceFunc(maps\mp\zombies\_zm::wait_and_revive, scripts\zm\replaced\_zm::wait_and_revive);
	replaceFunc(maps\mp\zombies\_zm::player_revive_monitor, scripts\zm\replaced\_zm::player_revive_monitor);
	replaceFunc(maps\mp\zombies\_zm::player_out_of_playable_area_monitor, scripts\zm\replaced\_zm::player_out_of_playable_area_monitor);
	replaceFunc(maps\mp\zombies\_zm::end_game, scripts\zm\replaced\_zm::end_game);
	replaceFunc(maps\mp\zombies\_zm::check_quickrevive_for_hotjoin, scripts\zm\replaced\_zm::check_quickrevive_for_hotjoin);
	replaceFunc(maps\mp\zombies\_zm_audio::create_and_play_dialog, scripts\zm\replaced\_zm_audio::create_and_play_dialog);
	replaceFunc(maps\mp\zombies\_zm_audio_announcer::playleaderdialogonplayer, scripts\zm\replaced\_zm_audio_announcer::playleaderdialogonplayer);
	replaceFunc(maps\mp\zombies\_zm_stats::set_global_stat, scripts\zm\replaced\_zm_stats::set_global_stat);
	replaceFunc(maps\mp\zombies\_zm_playerhealth::playerhealthregen, scripts\zm\replaced\_zm_playerhealth::playerhealthregen);
	replaceFunc(maps\mp\zombies\_zm_utility::init_player_offhand_weapons, scripts\zm\replaced\_zm_utility::init_player_offhand_weapons);
	replaceFunc(maps\mp\zombies\_zm_utility::give_start_weapon, scripts\zm\replaced\_zm_utility::give_start_weapon);
	replaceFunc(maps\mp\zombies\_zm_utility::is_headshot, scripts\zm\replaced\_zm_utility::is_headshot);
	replaceFunc(maps\mp\zombies\_zm_utility::shock_onpain, scripts\zm\replaced\_zm_utility::shock_onpain);
	replaceFunc(maps\mp\zombies\_zm_utility::create_zombie_point_of_interest_attractor_positions, scripts\zm\replaced\_zm_utility::create_zombie_point_of_interest_attractor_positions);
	replaceFunc(maps\mp\zombies\_zm_utility::get_current_zone, scripts\zm\replaced\_zm_utility::get_current_zone);
	replaceFunc(maps\mp\zombies\_zm_utility::is_temporary_zombie_weapon, scripts\zm\replaced\_zm_utility::is_temporary_zombie_weapon);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, scripts\zm\replaced\_zm_utility::wait_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::track_players_intersection_tracker, scripts\zm\replaced\_zm_utility::track_players_intersection_tracker);
	replaceFunc(maps\mp\zombies\_zm_score::add_to_player_score, scripts\zm\replaced\_zm_score::add_to_player_score);
	replaceFunc(maps\mp\zombies\_zm_score::minus_to_player_score, scripts\zm\replaced\_zm_score::minus_to_player_score);
	replaceFunc(maps\mp\zombies\_zm_score::player_add_points_kill_bonus, scripts\zm\replaced\_zm_score::player_add_points_kill_bonus);
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
	replaceFunc(maps\mp\zombies\_zm_weapons::weapon_give, scripts\zm\replaced\_zm_weapons::weapon_give);
	replaceFunc(maps\mp\zombies\_zm_weapons::ammo_give, scripts\zm\replaced\_zm_weapons::ammo_give);
	replaceFunc(maps\mp\zombies\_zm_weapons::get_upgraded_ammo_cost, scripts\zm\replaced\_zm_weapons::get_upgraded_ammo_cost);
	replaceFunc(maps\mp\zombies\_zm_weapons::makegrenadedudanddestroy, scripts\zm\replaced\_zm_weapons::makegrenadedudanddestroy);
	replaceFunc(maps\mp\zombies\_zm_weapons::createballisticknifewatcher_zm, scripts\zm\replaced\_zm_weapons::createballisticknifewatcher_zm);
	replaceFunc(maps\mp\zombies\_zm_weapons::weapon_spawn_think, scripts\zm\replaced\_zm_weapons::weapon_spawn_think);
	replaceFunc(maps\mp\zombies\_zm_weapons::weapon_set_first_time_hint, scripts\zm\replaced\_zm_weapons::weapon_set_first_time_hint);
	replaceFunc(maps\mp\zombies\_zm_weapons::give_fallback_weapon, scripts\zm\replaced\_zm_weapons::give_fallback_weapon);
	replaceFunc(maps\mp\zombies\_zm_magicbox::treasure_chest_init, scripts\zm\replaced\_zm_magicbox::treasure_chest_init);
	replaceFunc(maps\mp\zombies\_zm_magicbox::init_starting_chest_location, scripts\zm\replaced\_zm_magicbox::init_starting_chest_location);
	replaceFunc(maps\mp\zombies\_zm_magicbox::decide_hide_show_hint, scripts\zm\replaced\_zm_magicbox::decide_hide_show_hint);
	replaceFunc(maps\mp\zombies\_zm_magicbox::trigger_visible_to_player, scripts\zm\replaced\_zm_magicbox::trigger_visible_to_player);
	replaceFunc(maps\mp\zombies\_zm_magicbox::can_buy_weapon, scripts\zm\replaced\_zm_magicbox::can_buy_weapon);
	replaceFunc(maps\mp\zombies\_zm_magicbox::weapon_is_dual_wield, scripts\zm\replaced\_zm_magicbox::weapon_is_dual_wield);
	replaceFunc(maps\mp\zombies\_zm_perks::init, scripts\zm\replaced\_zm_perks::init);
	replaceFunc(maps\mp\zombies\_zm_perks::vending_trigger_think, scripts\zm\replaced\_zm_perks::vending_trigger_think);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_give_bottle_end, scripts\zm\replaced\_zm_perks::perk_give_bottle_end);
	replaceFunc(maps\mp\zombies\_zm_perks::vending_weapon_upgrade, scripts\zm\replaced\_zm_perks::vending_weapon_upgrade);
	replaceFunc(maps\mp\zombies\_zm_perks::give_perk, scripts\zm\replaced\_zm_perks::give_perk);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_think, scripts\zm\replaced\_zm_perks::perk_think);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg, scripts\zm\replaced\_zm_perks::perk_set_max_health_if_jugg);
	replaceFunc(maps\mp\zombies\_zm_perks::initialize_custom_perk_arrays, scripts\zm\replaced\_zm_perks::initialize_custom_perk_arrays);
	replaceFunc(maps\mp\zombies\_zm_perks::turn_tombstone_on, scripts\zm\replaced\_zm_perks::turn_tombstone_on);
	replaceFunc(maps\mp\zombies\_zm_perks::wait_for_player_to_take, scripts\zm\replaced\_zm_perks::wait_for_player_to_take);
	replaceFunc(maps\mp\zombies\_zm_perks::check_player_has_perk, scripts\zm\replaced\_zm_perks::check_player_has_perk);
	replaceFunc(maps\mp\zombies\_zm_perks::set_perk_clientfield, scripts\zm\replaced\_zm_perks::set_perk_clientfield);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_pause, scripts\zm\replaced\_zm_perks::perk_pause);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_unpause, scripts\zm\replaced\_zm_perks::perk_unpause);
	replaceFunc(maps\mp\zombies\_zm_buildables::player_progress_bar_update, scripts\zm\replaced\_zm_buildables::player_progress_bar_update);
	replaceFunc(maps\mp\zombies\_zm_power::standard_powered_items, scripts\zm\replaced\_zm_power::standard_powered_items);
	replaceFunc(maps\mp\zombies\_zm_powerups::powerup_drop, scripts\zm\replaced\_zm_powerups::powerup_drop);
	replaceFunc(maps\mp\zombies\_zm_powerups::get_next_powerup, scripts\zm\replaced\_zm_powerups::get_next_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::powerup_grab, scripts\zm\replaced\_zm_powerups::powerup_grab);
	replaceFunc(maps\mp\zombies\_zm_powerups::full_ammo_powerup, scripts\zm\replaced\_zm_powerups::full_ammo_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::nuke_powerup, scripts\zm\replaced\_zm_powerups::nuke_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::insta_kill_powerup, scripts\zm\replaced\_zm_powerups::insta_kill_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::double_points_powerup, scripts\zm\replaced\_zm_powerups::double_points_powerup);
	replaceFunc(maps\mp\zombies\_zm_pers_upgrades::is_pers_system_disabled, scripts\zm\replaced\_zm_pers_upgrades::is_pers_system_disabled);
	replaceFunc(maps\mp\zombies\_zm_pers_upgrades_system::check_pers_upgrade, scripts\zm\replaced\_zm_pers_upgrades_system::check_pers_upgrade);
	replaceFunc(maps\mp\zombies\_zm_traps::player_elec_damage, scripts\zm\replaced\_zm_traps::player_elec_damage);
	replaceFunc(maps\mp\zombies\_zm_equipment::show_equipment_hint, scripts\zm\replaced\_zm_equipment::show_equipment_hint);
	replaceFunc(maps\mp\zombies\_zm_equipment::placed_equipment_think, scripts\zm\replaced\_zm_equipment::placed_equipment_think);
	replaceFunc(maps\mp\zombies\_zm_clone::spawn_player_clone, scripts\zm\replaced\_zm_clone::spawn_player_clone);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_gib_on_damage, scripts\zm\replaced\_zm_spawner::zombie_gib_on_damage);
	replaceFunc(maps\mp\zombies\_zm_spawner::head_should_gib, scripts\zm\replaced\_zm_spawner::head_should_gib);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_death_animscript, scripts\zm\replaced\_zm_spawner::zombie_death_animscript);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_can_drop_powerups, scripts\zm\replaced\_zm_spawner::zombie_can_drop_powerups);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area, scripts\zm\replaced\_zm_spawner::zombie_complete_emerging_into_playable_area);
	replaceFunc(maps\mp\zombies\_zm_ai_basic::inert_wakeup, scripts\zm\replaced\_zm_ai_basic::inert_wakeup);
	replaceFunc(maps\mp\zombies\_zm_ai_dogs::enable_dog_rounds, scripts\zm\replaced\_zm_ai_dogs::enable_dog_rounds);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::init, scripts\zm\replaced\_zm_melee_weapon::init);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::change_melee_weapon, scripts\zm\replaced\_zm_melee_weapon::change_melee_weapon);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::give_melee_weapon, scripts\zm\replaced\_zm_melee_weapon::give_melee_weapon);
	replaceFunc(maps\mp\zombies\_zm_weap_ballistic_knife::init, scripts\zm\replaced\_zm_weap_ballistic_knife::init);
	replaceFunc(maps\mp\zombies\_zm_weap_ballistic_knife::watch_use_trigger, scripts\zm\replaced\_zm_weap_ballistic_knife::watch_use_trigger);
	replaceFunc(maps\mp\zombies\_zm_weap_ballistic_knife::pick_up, scripts\zm\replaced\_zm_weap_ballistic_knife::pick_up);
	replaceFunc(maps\mp\zombies\_zm_weap_claymore::claymore_detonation, scripts\zm\replaced\_zm_weap_claymore::claymore_detonation);
	replaceFunc(maps\mp\zombies\_zm_weap_claymore::claymore_setup, scripts\zm\replaced\_zm_weap_claymore::claymore_setup);
	replaceFunc(maps\mp\zombies\_zm_weap_cymbal_monkey::init, scripts\zm\replaced\_zm_weap_cymbal_monkey::init);
	replaceFunc(maps\mp\zombies\_zm_weap_cymbal_monkey::player_handle_cymbal_monkey, scripts\zm\replaced\_zm_weap_cymbal_monkey::player_handle_cymbal_monkey);
}

init()
{
	precacheStatusIcon("menu_mp_killstreak_select");
	precacheStatusIcon("menu_mp_contract_expired");
	precacheStatusIcon("waypoint_revive");

	if (is_true(level.zombiemode_using_chugabud_perk))
	{
		precacheStatusIcon("specialty_chugabud_zombies");
	}

	if (is_true(level.zombiemode_using_afterlife))
	{
		precacheStatusIcon("waypoint_revive_afterlife");
	}

	level.using_solo_revive = 0;
	level.claymores_max_per_player = 20;
	level.navcards = undefined; // removes navcards on HUD
	level.powerup_intro_vox = undefined;
	level.player_too_many_players_check = 0;
	level.player_too_many_weapons_monitor_func = scripts\zm\replaced\_zm::player_too_many_weapons_monitor;
	level.pregame_minplayers = getDvarInt("party_minplayers");
	level.player_starting_health = 150;

	if (!isdefined(level.item_meat_name))
	{
		level.item_meat_name = "";
	}

	setscoreboardcolumns_gametype();

	set_lethal_grenade_init();

	set_dvars();

	weapon_changes();

	wallbuy_location_changes();

	level thread on_player_connect();

	level thread post_all_players_spawned();

	level thread enemy_counter_hud();

	level thread timer_hud();

	level thread swap_staminup_perk();

	level thread remove_status_icons_on_intermission();
}

on_player_connect()
{
	while (true)
	{
		level waittill("connecting", player);

		player thread on_player_spawned();
		player thread on_player_spectate();
		player thread on_player_downed();
		player thread on_player_revived();
		player thread on_player_fake_revive();

		player thread grenade_fire_watcher();
	}
}

on_player_spawned()
{
	level endon("game_ended");
	self endon("disconnect");

	self.initial_spawn = true;

	for (;;)
	{
		self waittill("spawned_player");

		if (self.initial_spawn)
		{
			self.initial_spawn = false;

			self.solo_lives_given = 0;
			self.stored_weapon_data = undefined;
			self.screecher_seen_hint = 1;

			self thread health_bar_hud();
			self thread shield_bar_hud();
			self thread bleedout_bar_hud();
			self thread zone_hud();

			self thread veryhurt_blood_fx();

			self thread ignoreme_after_revived();

			self thread fall_velocity_check();

			self thread give_additional_perks();

			self thread weapon_locker_give_ammo_after_rounds();

			self thread additionalprimaryweapon_indicator();
			self thread additionalprimaryweapon_stowed_weapon_refill();

			self thread electric_cherry_unlimited();
		}

		self.statusicon = "";

		self set_client_dvars();
		self set_perks();
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
	}
}

on_player_downed()
{
	level endon("game_ended");
	self endon("disconnect");

	while (1)
	{
		self waittill("entering_last_stand");

		if (is_gametype_active("zcleansed"))
		{
			continue;
		}

		self.statusicon = "waypoint_revive";
		self.health = self.maxhealth;
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
			self.statusicon = "waypoint_revive_afterlife";
		}
	}
}

post_all_players_spawned()
{
	flag_wait("start_zombie_round_logic");

	wait 0.05;

	level.near_miss = 2; // makes screecher not run away first time on solo
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
	level.explode_overheated_jetgun = 0;
	level.unbuild_overheated_jetgun = 0;
	level.take_overheated_jetgun = 1;
	level.dont_allow_meat_interaction = 1;
	level.players_can_damage_riotshields = 1;
	level.speed_change_round = undefined;
	level.playersuicideallowed = undefined;
	level.disable_free_perks_before_power = undefined;
	level.custom_random_perk_weights = undefined;
	level.zombiemode_divetonuke_perk_func = scripts\zm\replaced\_zm_perk_divetonuke::divetonuke_explode;
	level.global_damage_func = scripts\zm\replaced\_zm_spawner::zombie_damage;
	level.callbackplayerdamage = scripts\zm\replaced\_zm::callback_playerdamage;
	level.overrideplayerdamage = scripts\zm\replaced\_zm::player_damage_override;
	level.playerlaststand_func = scripts\zm\replaced\_zm::player_laststand;
	level.callbackplayerlaststand = scripts\zm\replaced\_zm::callback_playerlaststand;
	level._zombies_round_spawn_failsafe = scripts\zm\replaced\_zm::round_spawn_failsafe;
	level.etrap_damage = maps\mp\zombies\_zm::ai_zombie_health(255);
	level.slipgun_damage = maps\mp\zombies\_zm::ai_zombie_health(255);
	level.should_respawn_func = ::should_respawn;
	level.tombstone_spawn_func = ::tombstone_spawn;
	level.tombstone_laststand_func = ::tombstone_save;
	level.zombie_last_stand = ::last_stand_pistol_swap;
	level.zombie_last_stand_ammo_return = ::last_stand_restore_pistol_ammo;

	disable_carpenter();

	disable_bank_teller();

	zone_changes();

	jetgun_remove_forced_weapon_switch();

	level thread wallbuy_cost_changes();

	level thread buildbuildables();
	level thread buildcraftables();
}

set_dvars()
{
	setDvar("player_backSpeedScale", 1);

	// can't set to exactly 90 or else looking completely up or down will cause the player to move in the opposite direction
	setDvar("player_view_pitch_up", 89.9999);
	setDvar("player_view_pitch_down", 89.9999);

	setDvar("dtp_post_move_pause", 0);
	setDvar("dtp_startup_delay", 100);
	setDvar("dtp_exhaustion_window", 100);

	setDvar("player_meleeRange", 64);
	setDvar("player_breath_gasp_lerp", 0);

	setDvar("g_friendlyfireDist", 0);

	setDvar("perk_weapRateEnhanced", 0);

	setDvar("riotshield_melee_damage_scale", 1);
	setDvar("riotshield_bullet_damage_scale", 1);
	setDvar("riotshield_explosive_damage_scale", 1);
	setDvar("riotshield_projectile_damage_scale", 1);
	setDvar("riotshield_deployed_health", 1500);

	setDvar("r_fog", 0);

	setDvar("sv_patch_zm_weapons", 1);
	setDvar("sv_fix_zm_weapons", 0);

	setDvar("sv_voice", 2);
	setDvar("sv_voiceQuality", 9);

	setDvar("sv_cheats", 0);

	if (getDvar("hud_timer") == "")
	{
		setDvar("hud_timer", 1);
	}

	if (getDvar("hud_enemy_counter") == "")
	{
		setDvar("hud_enemy_counter", 1);
	}

	if (getDvar("hud_health_bar") == "")
	{
		setDvar("hud_health_bar", 1);
	}

	if (getDvar("hud_zone_name") == "")
	{
		setDvar("hud_zone_name", 1);
	}

	if (getDvar("disable_character_dialog") == "")
	{
		setDvar("disable_character_dialog", 0);
	}
}

set_client_dvars()
{
	self setClientDvar("player_lastStandBleedoutTime", getDvarInt("player_lastStandBleedoutTime"));

	self setClientDvar("dtp_post_move_pause", getDvarInt("dtp_post_move_pause"));
	self setClientDvar("dtp_startup_delay", getDvarInt("dtp_startup_delay"));
	self setClientDvar("dtp_exhaustion_window", getDvarInt("dtp_exhaustion_window"));

	self setClientDvar("aim_automelee_enabled", 0);

	self setClientDvar("cg_drawBreathHint", 0);

	self setClientDvar("g_friendlyfireDist", 0);

	self setClientDvar("cg_friendlyNameFadeIn", 0);
	self setClientDvar("cg_friendlyNameFadeOut", 250);
	self setClientDvar("cg_enemyNameFadeIn", 0);
	self setClientDvar("cg_enemyNameFadeOut", 250);

	self setClientDvar("waypointOffscreenPointerDistance", 30);
	self setClientDvar("waypointOffscreenPadTop", 32);
	self setClientDvar("waypointOffscreenPadBottom", 32);
	self setClientDvar("waypointPlayerOffsetStand", 30);
	self setClientDvar("waypointPlayerOffsetCrouch", 30);

	self setClientDvar("r_fog", 0);

	self setClientDvar("r_dof_enable", 0);
	self setClientDvar("r_lodBiasRigid", -1000);
	self setClientDvar("r_lodBiasSkinned", -1000);

	self setClientDvar("cg_ufo_scaler", 1);
}

set_perks()
{
	if (!(getDvar("g_gametype") == "zgrief" && getDvarIntDefault("ui_gametype_pro", 0)))
	{
		self setperk("specialty_unlimitedsprint");
	}

	self setperk("specialty_fastmantle");
	self setperk("specialty_fastladderclimb");
}

health_bar_hud()
{
	self endon("disconnect");

	flag_wait("hud_visible");

	if (!getDvarInt("hud_health_bar"))
	{
		return;
	}

	x = 5;
	y = -104;

	if (level.script == "zm_buried")
	{
		y -= 25;
	}
	else if (level.script == "zm_tomb")
	{
		y -= 60;
	}

	hud = self createbar((1, 1, 1), level.primaryprogressbarwidth - 10, level.primaryprogressbarheight);
	hud.alignx = "left";
	hud.bar.alignx = "left";
	hud.barframe.alignx = "left";
	hud.aligny = "middle";
	hud.bar.aligny = "middle";
	hud.barframe.aligny = "middle";
	hud.horzalign = "user_left";
	hud.bar.horzalign = "user_left";
	hud.barframe.horzalign = "user_left";
	hud.vertalign = "user_bottom";
	hud.bar.vertalign = "user_bottom";
	hud.barframe.vertalign = "user_bottom";
	hud.x += x;
	hud.bar.x += x + ((hud.width + 4) / 2);
	hud.barframe.x += x;
	hud.y += y;
	hud.bar.y += y;
	hud.barframe.y += y;
	hud.hidewheninmenu = 1;
	hud.bar.hidewheninmenu = 1;
	hud.barframe.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.bar.foreground = 1;
	hud.barframe.foreground = 1;
	hud.sort = 1;
	hud.bar.sort = 2;
	hud.barframe.sort = 3;
	hud.barframe destroy();

	hud_text = createfontstring("objective", 1.2);
	hud_text.alignx = "left";
	hud_text.aligny = "middle";
	hud_text.horzalign = "user_left";
	hud_text.vertalign = "user_bottom";
	hud_text.x += x + hud.width + 7;
	hud_text.y += y;
	hud_text.hidewheninmenu = 1;
	hud_text.foreground = 1;

	hud endon("death");

	hud thread destroy_on_intermission();
	hud_text thread destroy_on_intermission();

	while (1)
	{
		if (is_true(self.afterlife))
		{
			hud hideelem();
			hud_text hideelem();

			while (is_true(self.afterlife))
			{
				wait 0.05;
			}

			hud showelem();
			hud_text showelem();
		}

		hud updatebar(self.health / self.maxhealth);
		hud_text setvalue(self.health);

		wait 0.05;
	}
}

shield_bar_hud()
{
	self endon("disconnect");

	flag_wait("hud_visible");

	if (!getDvarInt("hud_health_bar"))
	{
		return;
	}

	x = 5;
	y = -104;

	if (level.script == "zm_buried")
	{
		y -= 25;
	}
	else if (level.script == "zm_tomb")
	{
		y -= 60;
	}

	hud = self createbar((0.5, 0.5, 0.5), level.primaryprogressbarwidth - 10, int(level.primaryprogressbarheight / 2));
	hud.alignx = "left";
	hud.bar.alignx = "left";
	hud.barframe.alignx = "left";
	hud.aligny = "middle";
	hud.bar.aligny = "middle";
	hud.barframe.aligny = "middle";
	hud.horzalign = "user_left";
	hud.bar.horzalign = "user_left";
	hud.barframe.horzalign = "user_left";
	hud.vertalign = "user_bottom";
	hud.bar.vertalign = "user_bottom";
	hud.barframe.vertalign = "user_bottom";
	hud.x += x;
	hud.bar.x += x + ((hud.width + 4) / 2);
	hud.barframe.x += x;
	hud.y += y - 2;
	hud.bar.y += y - 2;
	hud.barframe.y += y - 2;
	hud.hidewheninmenu = 1;
	hud.bar.hidewheninmenu = 1;
	hud.barframe.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.bar.foreground = 1;
	hud.barframe.foreground = 1;
	hud.sort = 2;
	hud.bar.sort = 3;
	hud.barframe.sort = 4;
	hud.alpha = 0;
	hud.barframe destroy();

	hud_text = createfontstring("objective", 1.2);
	hud_text.alignx = "left";
	hud_text.aligny = "middle";
	hud_text.horzalign = "user_left";
	hud_text.vertalign = "user_bottom";
	hud_text.label = &"| ";
	hud_text.x += x + hud.width + 11;
	hud_text.y += y;
	hud_text.hidewheninmenu = 1;
	hud_text.foreground = 1;

	hud_text_x = hud_text.x;

	hud endon("death");

	hud thread destroy_on_intermission();
	hud_text thread destroy_on_intermission();

	while (1)
	{
		if (!is_true(self.hasriotshield) || (isDefined(self.shielddamagetaken) && self.shielddamagetaken >= level.zombie_vars["riotshield_hit_points"]) || is_true(self.afterlife))
		{
			hud.bar.alpha = 0;
			hud_text hideelem();

			while (!is_true(self.hasriotshield) || (isDefined(self.shielddamagetaken) && self.shielddamagetaken >= level.zombie_vars["riotshield_hit_points"]) || is_true(self.afterlife))
			{
				wait 0.05;
			}

			hud.bar.alpha = 1;
			hud_text showelem();
		}

		health = level.zombie_vars["riotshield_hit_points"] - self.shielddamagetaken;

		if (health < 0)
		{
			health = 0;
		}

		health_ratio = health / level.zombie_vars["riotshield_hit_points"];

		offset_x = 0;
		health_str = "" + self.health;

		for (i = 0; i < health_str.size; i++)
		{
			if (health_str[i] == "1")
			{
				offset_x += 4;
			}
			else
			{
				offset_x += 5;
			}
		}

		hud_text.x = hud_text_x + offset_x;

		hud updatebar(health_ratio);
		hud_text setvalue(int(health_ratio * 100));

		wait 0.05;
	}
}

enemy_counter_hud()
{
	if (getDvar("g_gametype") == "zgrief")
	{
		return;
	}

	hud = newHudElem();
	hud.alignx = "left";
	hud.aligny = "top";
	hud.horzalign = "user_left";
	hud.vertalign = "user_top";
	hud.x += 5;
	hud.y += 2;
	hud.fontscale = 1.4;
	hud.alpha = 0;
	hud.color = (1, 1, 1);
	hud.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.label = &"ZOMBIE_HUD_ENEMIES_REMAINING";

	hud endon("death");

	hud thread destroy_on_intermission();

	flag_wait("hud_visible");

	if (!getDvarInt("hud_enemy_counter"))
	{
		return;
	}

	hud.alpha = 1;

	while (1)
	{
		enemies = get_round_enemy_array().size + level.zombie_total;

		if (level flag_exists("spawn_ghosts") && flag("spawn_ghosts"))
		{
			enemies = get_current_ghost_count();
		}
		else if (level flag_exists("sq_tpo_special_round_active") && flag("sq_tpo_special_round_active"))
		{
			enemies = 0;
		}

		if (enemies == 0)
		{
			hud setText("");
		}
		else
		{
			hud setValue(enemies);
		}

		wait 0.05;
	}
}

get_current_ghost_count()
{
	ghost_count = 0;
	ais = getaiarray(level.zombie_team);

	foreach (ai in ais)
	{
		if (isdefined(ai.is_ghost) && ai.is_ghost)
			ghost_count++;
	}

	return ghost_count;
}

timer_hud()
{
	level thread round_timer_hud();

	hud = newHudElem();
	hud.alignx = "right";
	hud.aligny = "top";
	hud.horzalign = "user_right";
	hud.vertalign = "user_top";
	hud.x -= 5;
	hud.y += 12;
	hud.fontscale = 1.4;
	hud.alpha = 0;
	hud.color = (1, 1, 1);
	hud.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.label = &"ZOMBIE_HUD_TOTAL_TIME";

	hud endon("death");

	hud thread destroy_on_intermission();

	hud thread set_time_frozen_on_end_game();

	flag_wait("hud_visible");

	if (!getDvarInt("hud_timer"))
	{
		return;
	}

	hud.alpha = 1;

	if (!flag("initial_blackscreen_passed"))
	{
		hud set_time_frozen(0, "initial_blackscreen_passed");
	}

	if (getDvar("g_gametype") == "zgrief")
	{
		hud set_time_frozen(0);
	}

	hud setTimerUp(0);
	hud.start_time = getTime();
	level.timer_hud_start_time = hud.start_time;
}

round_timer_hud()
{
	flag_wait("hud_visible");

	if (isDefined(level.scr_zm_ui_gametype_obj) && level.scr_zm_ui_gametype_obj != "zsnr")
	{
		return;
	}

	hud = newHudElem();
	hud.alignx = "right";
	hud.aligny = "top";
	hud.horzalign = "user_right";
	hud.vertalign = "user_top";
	hud.x -= 5;
	hud.y += 27;
	hud.fontscale = 1.4;
	hud.alpha = 0;
	hud.color = (1, 1, 1);
	hud.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.label = &"ZOMBIE_HUD_ROUND_TIME";

	hud endon("death");

	hud thread destroy_on_intermission();

	hud thread set_time_frozen_on_end_game();

	if (!getDvarInt("hud_timer"))
	{
		return;
	}

	hud.alpha = 1;

	if (!flag("initial_blackscreen_passed"))
	{
		hud set_time_frozen(0, "initial_blackscreen_passed");
	}

	if (getDvar("g_gametype") == "zgrief")
	{
		hud set_time_frozen(0);
	}

	while (1)
	{
		hud setTimerUp(0);
		hud.start_time = getTime();

		if (getDvar("g_gametype") == "zgrief")
		{
			level waittill("restart_round");
		}
		else
		{
			level waittill("end_of_round");
		}

		level thread round_total_timer_hud();

		time = int((getTime() - hud.start_time) / 1000);

		hud set_time_frozen(time);
	}
}

round_total_timer_hud()
{
	if (getDvar("g_gametype") == "zgrief")
	{
		return;
	}

	hud = newHudElem();
	hud.alignx = "right";
	hud.aligny = "top";
	hud.horzalign = "user_right";
	hud.vertalign = "user_top";
	hud.x -= 5;
	hud.y += 42;
	hud.fontscale = 1.4;
	hud.alpha = 0;
	hud.color = (1, 1, 1);
	hud.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.label = &"ZOMBIE_HUD_ROUND_TOTAL_TIME";

	hud endon("death");

	hud thread destroy_on_intermission();

	fade_time = 0.5;

	hud fadeOverTime(fade_time);
	hud.alpha = 1;

	time = int((getTime() - level.timer_hud_start_time) / 1000);

	hud set_time_frozen(time);

	hud fadeOverTime(fade_time);
	hud.alpha = 0;

	wait fade_time;

	hud destroy();
}

set_time_frozen(time, endon_notify)
{
	if (isDefined(endon_notify))
	{
		level endon(endon_notify);
	}
	else if (getDvar("g_gametype") == "zgrief")
	{
		level endon("restart_round_start");
	}
	else
	{
		level endon("start_of_round");
	}

	self endon("death");

	if (time != 0)
	{
		time -= 0.5; // need to set it below the number or it shows the next number
	}

	while (1)
	{
		if (time == 0)
		{
			self setTimerUp(time);
		}
		else
		{
			self setTimer(time);
		}

		wait 0.5;
	}
}

set_time_frozen_on_end_game()
{
	level endon("intermission");

	level waittill_any("end_game", "freeze_timers");

	time = int((getTime() - self.start_time) / 1000);

	self set_time_frozen(time, "forever");
}

zone_hud()
{
	self endon("disconnect");

	x = 5;
	y = -119;

	if (level.script == "zm_buried")
	{
		y -= 25;
	}
	else if (level.script == "zm_tomb")
	{
		y -= 60;
	}

	hud = newClientHudElem(self);
	hud.alignx = "left";
	hud.aligny = "middle";
	hud.horzalign = "user_left";
	hud.vertalign = "user_bottom";
	hud.x += x;
	hud.y += y;
	hud.fontscale = 1.4;
	hud.alpha = 0;
	hud.color = (1, 1, 1);
	hud.hidewheninmenu = 1;
	hud.foreground = 1;

	hud endon("death");

	hud thread destroy_on_intermission();

	flag_wait("hud_visible");

	if (!getDvarInt("hud_zone_name"))
	{
		return;
	}

	vars = [];

	vars["zone"] = self get_current_zone();
	vars["prev_zone_name"] = get_zone_display_name(vars["zone"]);
	hud settext(vars["prev_zone_name"]);
	hud.alpha = 1;

	while (1)
	{
		vars["zone"] = self get_current_zone();
		vars["zone_name"] = get_zone_display_name(vars["zone"]);

		if (vars["prev_zone_name"] != vars["zone_name"])
		{
			vars["prev_zone_name"] = vars["zone_name"];

			hud fadeovertime(0.25);
			hud.alpha = 0;
			wait 0.25;

			hud settext(vars["zone_name"]);

			hud fadeovertime(0.25);
			hud.alpha = 1;
			wait 0.25;

			continue;
		}

		wait 0.05;
	}
}

get_zone_display_name(zone)
{
	if (!isDefined(zone))
	{
		return "";
	}

	if (level.script == "zm_tomb")
	{
		if (isDefined(self.teleporting) && self.teleporting)
		{
			return "";
		}
	}

	return istring(toupper(level.script + "_" + zone));
}

bleedout_bar_hud()
{
	self endon("disconnect");

	flag_wait("hud_visible");

	while (1)
	{
		self waittill("entering_last_stand");

		if (is_gametype_active("zcleansed"))
		{
			continue;
		}

		// don't show for last player downed
		if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			continue;
		}

		if (flag("solo_game"))
		{
			continue;
		}

		hud = self createbar((1, 0, 0), level.secondaryprogressbarwidth * 2, level.secondaryprogressbarheight);
		hud setpoint("CENTER", undefined, level.secondaryprogressbarx, -1 * level.secondaryprogressbary);
		hud.hidewheninmenu = 1;
		hud.bar.hidewheninmenu = 1;
		hud.barframe.hidewheninmenu = 1;
		hud.sort = 1;
		hud.bar.sort = 2;
		hud.barframe.sort = 3;
		hud.barframe destroy();
		hud thread destroy_on_intermission();

		self thread bleedout_bar_hud_updatebar(hud);

		self waittill_any("player_revived", "bled_out", "player_suicide");

		hud.bar destroy();
		hud destroy();
	}
}

// scaleovertime doesn't work past 30 seconds so here is a workaround
bleedout_bar_hud_updatebar(hud)
{
	self endon("player_revived");
	self endon("bled_out");
	self endon("player_suicide");

	vars = [];

	vars["bleedout_time"] = getDvarInt("player_lastStandBleedoutTime");
	vars["interval_time"] = 30;
	vars["interval_frac"] = vars["interval_time"] / vars["bleedout_time"];
	vars["num_intervals"] = int(vars["bleedout_time"] / vars["interval_time"]) + 1;

	hud updatebar(1);

	for (i = 0; i < vars["num_intervals"]; i++)
	{
		vars["time"] = vars["bleedout_time"];

		if (vars["time"] > vars["interval_time"])
		{
			vars["time"] = vars["interval_time"];
		}

		vars["frac"] = 0.99 - ((i + 1) * vars["interval_frac"]);

		barwidth = int((hud.width * vars["frac"]) + 0.5);

		if (barwidth < 1)
		{
			barwidth = 1;
		}

		hud.bar scaleovertime(vars["time"], barwidth, hud.height);

		wait vars["time"];

		vars["bleedout_time"] -= vars["time"];
	}
}

last_stand_pistol_swap()
{
	if (self has_powerup_weapon())
	{
		self.lastactiveweapon = "none";
	}

	if (!self hasweapon(self.laststandpistol))
	{
		if (!is_weapon_upgraded(self.laststandpistol))
		{
			self giveweapon(self.laststandpistol);
		}
		else
		{
			self giveweapon(self.laststandpistol, 0, self get_pack_a_punch_weapon_options(self.laststandpistol));
		}
	}

	amt = 0;
	ammoclip = weaponclipsize(self.laststandpistol);
	doubleclip = ammoclip * 2;
	dual_wield_wep = weapondualwieldweaponname(self.laststandpistol);

	if (dual_wield_wep != "none")
	{
		ammoclip += weaponclipsize(dual_wield_wep);
		doubleclip = ammoclip;
	}

	if (is_true(self._special_solo_pistol_swap) || self.laststandpistol == level.default_solo_laststandpistol && !self.hadpistol)
	{
		self._special_solo_pistol_swap = 0;
		self.hadpistol = 0;
		amt = ammoclip;
	}
	else if (flag("solo_game") && self.laststandpistol == level.default_solo_laststandpistol)
	{
		amt = ammoclip;
	}
	else if (self.laststandpistol == level.default_laststandpistol)
	{
		amt = ammoclip + doubleclip;
	}
	else if (self.laststandpistol == "ray_gun_zm" || self.laststandpistol == "ray_gun_upgraded_zm" || self.laststandpistol == "raygun_mark2_zm" || self.laststandpistol == "raygun_mark2_upgraded_zm" || self.laststandpistol == level.default_solo_laststandpistol)
	{
		amt = ammoclip;

		if (self.hadpistol && amt > self.stored_weapon_info[self.laststandpistol].total_amt)
		{
			amt = self.stored_weapon_info[self.laststandpistol].total_amt;
		}

		self.stored_weapon_info[self.laststandpistol].given_amt = amt;
	}
	else
	{
		amt = ammoclip + doubleclip;

		if (self.hadpistol && amt > self.stored_weapon_info[self.laststandpistol].total_amt)
		{
			amt = self.stored_weapon_info[self.laststandpistol].total_amt;
		}

		self.stored_weapon_info[self.laststandpistol].given_amt = amt;
	}

	clip_amt_init = 0;
	left_clip_amt_init = 0;

	if (self.hadpistol)
	{
		clip_amt_init = self.stored_weapon_info[self.laststandpistol].clip_amt;

		if (dual_wield_wep != "none")
		{
			left_clip_amt_init = self.stored_weapon_info[self.laststandpistol].left_clip_amt;
		}

		amt -= clip_amt_init + left_clip_amt_init;
	}

	clip_amt_add = weaponclipsize(self.laststandpistol) - clip_amt_init;

	if (clip_amt_add > amt)
	{
		clip_amt_add = amt;
	}

	self setweaponammoclip(self.laststandpistol, clip_amt_init + clip_amt_add);

	amt -= clip_amt_add;

	if (dual_wield_wep != "none")
	{
		left_clip_amt_add = weaponclipsize(dual_wield_wep) - left_clip_amt_init;

		if (left_clip_amt_add > amt)
		{
			left_clip_amt_add = amt;
		}

		self set_weapon_ammo_clip_left(self.laststandpistol, left_clip_amt_init + left_clip_amt_add);

		amt -= left_clip_amt_add;
	}

	stock_amt = doubleclip;

	if (stock_amt > amt)
	{
		stock_amt = amt;
	}

	self setweaponammostock(self.laststandpistol, stock_amt);

	self switchtoweapon(self.laststandpistol);
}

last_stand_restore_pistol_ammo(only_store_info = false)
{
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;

	if (!isDefined(self.stored_weapon_info))
	{
		return;
	}

	weapon_inventory = self getweaponslist(1);
	weapon_to_restore = getarraykeys(self.stored_weapon_info);
	i = 0;

	while (i < weapon_inventory.size)
	{
		weapon = weapon_inventory[i];

		if (weapon != self.laststandpistol)
		{
			i++;
			continue;
		}

		for (j = 0; j < weapon_to_restore.size; j++)
		{
			check_weapon = weapon_to_restore[j];

			if (weapon == check_weapon)
			{
				if (self.stored_weapon_info[weapon].given_amt == 0)
				{
					self setweaponammoclip(weapon, self.stored_weapon_info[weapon].clip_amt);

					if ("none" != dual_wield_name)
						self set_weapon_ammo_clip_left(weapon, self.stored_weapon_info[weapon].left_clip_amt);

					self setweaponammostock(weapon, self.stored_weapon_info[weapon].stock_amt);

					break;
				}

				dual_wield_name = weapondualwieldweaponname(weapon);

				last_clip = self getweaponammoclip(weapon);
				last_left_clip = 0;

				if ("none" != dual_wield_name)
				{
					last_left_clip = self getweaponammoclip(dual_wield_name);
				}

				last_stock = self getweaponammostock(weapon);
				last_total = last_clip + last_left_clip + last_stock;

				self.stored_weapon_info[weapon].used_amt = self.stored_weapon_info[weapon].given_amt - last_total;

				if (only_store_info)
				{
					break;
				}

				used_amt = self.stored_weapon_info[weapon].used_amt;

				if (used_amt >= self.stored_weapon_info[weapon].stock_amt)
				{
					used_amt -= self.stored_weapon_info[weapon].stock_amt;
					self.stored_weapon_info[weapon].stock_amt = 0;

					if ("none" != dual_wield_name)
					{
						if (used_amt >= self.stored_weapon_info[weapon].left_clip_amt)
						{
							used_amt -= self.stored_weapon_info[weapon].left_clip_amt;
							self.stored_weapon_info[weapon].left_clip_amt = 0;

							if (used_amt >= self.stored_weapon_info[weapon].clip_amt)
							{
								used_amt -= self.stored_weapon_info[weapon].clip_amt;
								self.stored_weapon_info[weapon].clip_amt = 0;
							}
							else
							{
								self.stored_weapon_info[weapon].clip_amt -= used_amt;
							}
						}
						else
						{
							self.stored_weapon_info[weapon].left_clip_amt -= used_amt;
						}
					}
					else
					{
						if (used_amt >= self.stored_weapon_info[weapon].clip_amt)
						{
							used_amt -= self.stored_weapon_info[weapon].clip_amt;
							self.stored_weapon_info[weapon].clip_amt = 0;
						}
						else
						{
							self.stored_weapon_info[weapon].clip_amt -= used_amt;
						}
					}
				}
				else
				{
					self.stored_weapon_info[weapon].stock_amt -= used_amt;
				}

				self setweaponammoclip(weapon, self.stored_weapon_info[weapon].clip_amt);

				if ("none" != dual_wield_name)
					self set_weapon_ammo_clip_left(weapon, self.stored_weapon_info[weapon].left_clip_amt);

				self setweaponammostock(weapon, self.stored_weapon_info[weapon].stock_amt);

				break;
			}
		}

		i++;
	}
}

// setweaponammoclip on dual wield left weapons only works when the weapon is given
set_weapon_ammo_clip_left(weapon, amount)
{
	dual_wield_weapon = weaponDualWieldWeaponName(weapon);
	alt_weapon = weaponAltWeaponName(weapon);

	clip_ammo = self getweaponammoclip(weapon);
	stock_ammo = self getweaponammostock(weapon);
	alt_clip_ammo = self getweaponammoclip(alt_weapon);
	alt_stock_ammo = self getweaponammostock(alt_weapon);

	self takeweapon(weapon);
	self giveweapon(weapon, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(weapon));

	self setweaponammoclip(weapon, clip_ammo);
	self setweaponammostock(weapon, stock_ammo);
	self setweaponammoclip(alt_weapon, alt_clip_ammo);
	self setweaponammostock(alt_weapon, alt_stock_ammo);

	self setweaponammoclip(dual_wield_weapon, amount);

	self seteverhadweaponall(1);
}

setscoreboardcolumns_gametype()
{
	if (getDvar("g_gametype") == "zgrief")
	{
		if (getDvar("ui_gametype_obj") == "zcontainment" || getDvar("ui_gametype_obj") == "zmeat")
		{
			setscoreboardcolumns("score", "captures", "killsconfirmed", "downs", "revives");
		}
		else if (getDvar("ui_gametype_obj") == "zgrief" || getDvar("ui_gametype_obj") == "zsnr")
		{
			setscoreboardcolumns("score", "killsdenied", "killsconfirmed", "downs", "revives");
		}
		else
		{
			setscoreboardcolumns("score", "kills", "killsconfirmed", "downs", "revives");
		}
	}
	else
	{
		setscoreboardcolumns("score", "kills", "headshots", "downs", "revives");
	}
}

set_lethal_grenade_init()
{
	if (level.script != "zm_transit" && level.script != "zm_nuked" && level.script != "zm_highrise" && level.script != "zm_tomb")
	{
		return;
	}

	level.zombie_lethal_grenade_player_init = "sticky_grenade_zm";
}

swap_staminup_perk()
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

veryhurt_blood_fx()
{
	self endon("disconnect");

	while (1)
	{
		health_ratio = self.health / self.maxhealth;

		if (health_ratio <= 0.2)
		{
			playFXOnTag(level._effect["zombie_guts_explosion"], self, "J_SpineLower");

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

fall_velocity_check()
{
	self endon("disconnect");

	vars = [];

	while (1)
	{
		vars["was_on_ground"] = 1;
		self.fall_velocity = 0;

		while (!self isOnGround())
		{
			vars["was_on_ground"] = 0;
			vel = self getVelocity();
			self.fall_velocity = vel[2];
			wait 0.05;
		}

		if (!vars["was_on_ground"])
		{
			// fall damage does not register when player's max health is less than 100 and has PHD Flopper
			if (self.maxhealth < 100 && self hasPerk("specialty_flakjacket"))
			{
				if (is_true(self.divetoprone) && self.fall_velocity <= -300)
				{
					if (isDefined(level.zombiemode_divetonuke_perk_func))
					{
						[[level.zombiemode_divetonuke_perk_func]](self, self.origin);
					}
				}
			}

			continue;
		}

		wait 0.05;
	}
}

disable_bank_teller()
{
	level notify("stop_bank_teller");
	bank_teller_dmg_trig = getent("bank_teller_tazer_trig", "targetname");

	if (IsDefined(bank_teller_dmg_trig))
	{
		bank_teller_transfer_trig = getent(bank_teller_dmg_trig.target, "targetname");
		bank_teller_dmg_trig delete();
		bank_teller_transfer_trig delete();
	}
}

disable_carpenter()
{
	arrayremovevalue(level.zombie_powerup_array, "carpenter");
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
		add_zombie_weapon("fnp45_zm", "fnp45_upgraded_zm", &"WEAPON_FNP45", 50, "wpck_pistol", "", undefined, 1);
	}

	if (level.script == "zm_prison")
	{
		include_weapon("held_knife_zm_alcatraz", 0);
		register_melee_weapon_for_level("held_knife_zm_alcatraz");

		include_weapon("held_spoon_zm_alcatraz", 0);
		register_melee_weapon_for_level("held_spoon_zm_alcatraz");

		include_weapon("held_spork_zm_alcatraz", 0);
		register_melee_weapon_for_level("held_spork_zm_alcatraz");

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
	}

	if (isdefined(level.zombie_weapons["saritch_zm"]))
	{
		level.zombie_weapons["saritch_zm"].is_in_box = 0;
		level.zombie_weapons["saritch_zm"].cost = 500;
		level.zombie_weapons["saritch_zm"].ammo_cost = 250;
	}
	else
	{
		include_weapon("saritch_zm", 0);
		include_weapon("saritch_upgraded_zm", 0);
		add_zombie_weapon("saritch_zm", "saritch_upgraded_zm", &"ZOMBIE_WEAPON_SARITCH", 500, "wpck_smr", "", undefined, 1);
	}

	if (!isdefined(level.zombie_weapons["ballista_zm"]))
	{
		include_weapon("ballista_zm", 0);
		include_weapon("ballista_upgraded_zm", 0);
		add_zombie_weapon("ballista_zm", "ballista_upgraded_zm", &"ZMWEAPON_BALLISTA_WALLBUY", 500, "wpck_snipe", "", undefined, 1);
	}

	if (isdefined(level.zombie_weapons["python_zm"]))
	{
		level.zombie_weapons["python_zm"].is_in_box = 0;
	}

	if (level.script == "zm_buried")
	{
		level.zombie_weapons["judge_zm"].is_in_box = 0;
	}

	if (isdefined(level.zombie_weapons["galil_zm"]))
	{
		level.zombie_weapons["galil_zm"].is_in_box = 0;
	}

	if (!isdefined(level.zombie_weapons["hk416_zm"]))
	{
		include_weapon("hk416_zm");
		include_weapon("hk416_upgraded_zm", 0);
		add_zombie_weapon("hk416_zm", "hk416_upgraded_zm", &"ZOMBIE_WEAPON_HK416", 100, "", "", undefined);
	}

	if (!isdefined(level.zombie_weapons["scar_zm"]))
	{
		include_weapon("scar_zm");
		include_weapon("scar_upgraded_zm", 0);
		add_zombie_weapon("scar_zm", "scar_upgraded_zm", &"ZOMBIE_WEAPON_SCAR", 50, "wpck_rifle", "", undefined, 1);
	}
}

player_give_willy_pete()
{
	self endon("disconnect");

	self setclientfieldtoplayer("tomahawk_in_use", 0);

	wait 0.05;

	self giveweapon("willy_pete_zm");
}

wallbuy_location_changes()
{
	if (!is_classic())
	{
		if (level.scr_zm_map_start_location == "farm")
		{
			if (level.scr_zm_ui_gametype == "zstandard")
			{
				level thread remove_wallbuy("tazer_knuckles_zm");
			}

			level thread remove_wallbuy("rottweil72_zm");

			add_wallbuy("870mcs_zm", "zclassic");
			add_wallbuy("claymore_zm");
		}

		if (level.scr_zm_map_start_location == "street")
		{
			if (level.scr_zm_ui_gametype == "zgrief")
			{
				add_wallbuy("beretta93r_zm");
				add_wallbuy("m16_zm");
				add_wallbuy("claymore_zm");
				add_wallbuy("bowie_knife_zm");
			}
		}
	}
}

remove_wallbuy(name)
{
	flag_wait("start_zombie_round_logic");

	wait 0.05;

	for (i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if (IsDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade) && level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade == name)
		{
			maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(level._unitriggers.trigger_stubs[i]);
		}
	}
}

add_wallbuy(name, script_noteworthy)
{
	struct = undefined;
	spawnable_weapon_spawns = getstructarray("weapon_upgrade", "targetname");
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("bowie_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("sickle_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("tazer_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("buildable_wallbuy", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("claymore_purchase", "targetname"), 1, 0);

	for (i = 0; i < spawnable_weapon_spawns.size; i++)
	{
		if (IsDefined(spawnable_weapon_spawns[i].zombie_weapon_upgrade) && spawnable_weapon_spawns[i].zombie_weapon_upgrade == name)
		{
			if (isDefined(script_noteworthy) && isDefined(spawnable_weapon_spawns[i].script_noteworthy) && !isSubStr(spawnable_weapon_spawns[i].script_noteworthy, script_noteworthy))
			{
				continue;
			}

			struct = spawnable_weapon_spawns[i];

			break;
		}
	}

	if (!IsDefined(struct))
	{
		return;
	}

	scripts\zm\replaced\utility::wallbuy(name, struct.target, struct.targetname, struct.origin, struct.angles);
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

buildbuildables()
{
	// need a wait or else some buildables dont build
	wait 1;

	if (is_classic())
	{
		if (level.scr_zm_map_start_location == "transit")
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

			// power switch is not showing up from forced build
			show_powerswitch();
		}
		else if (level.scr_zm_map_start_location == "rooftop")
		{
			level.buildables_available = array("springpad_zm", "slipgun_zm");

			buildbuildable("slipgun_zm");
			buildbuildable("springpad_zm");
			buildbuildable("sq_common", 1);
		}
		else if (level.scr_zm_map_start_location == "processing")
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
			buildbuildable("buried_sq_bt_m_tower", 0, 1, ::onuseplantobject_mtower);
			buildbuildable("buried_sq_bt_r_tower", 0, 1, ::onuseplantobject_rtower);
		}
	}
	else
	{
		if (level.scr_zm_map_start_location == "street")
		{
			flag_wait("initial_blackscreen_passed"); // wait for buildables to be built
			wait 1;

			updatebuildables();
			removebuildable("turbine", "buried");
			removebuildable("headchopper_zm", "buried"); // TODO - remove line when headchopper anims work on Borough
		}
	}
}

buildbuildable(buildable, craft = 0, solo_pool = 0, onuse)
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

				foreach (piece in stub.buildablezone.pieces)
				{
					piece maps\mp\zombies\_zm_buildables::piece_unspawn();
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
		if (IsDefined(stub.equipname))
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
	// need a wait or else some buildables dont build
	wait 1;

	if (is_classic())
	{
		if (level.scr_zm_map_start_location == "prison")
		{
			buildcraftable("alcatraz_shield_zm");
			buildcraftable("packasplat");
		}
		else if (level.scr_zm_map_start_location == "tomb")
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

	for (;;)
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

tombstone_spawn()
{
	vars = [];

	vars["powerup"] = spawn("script_model", self.origin + vectorScale((0, 0, 1), 40));
	vars["powerup"].angles = self.angles;
	vars["powerup"] setmodel("tag_origin");
	vars["icon"] = spawn("script_model", self.origin + vectorScale((0, 0, 1), 40));
	vars["icon"].angles = self.angles;
	vars["icon"] setmodel("ch_tombstone1");
	vars["icon"] linkto(vars["powerup"]);
	vars["powerup"].icon = vars["icon"];
	vars["powerup"].script_noteworthy = "player_tombstone_model";
	vars["powerup"].player = self;

	self thread maps\mp\zombies\_zm_tombstone::tombstone_clear();
	vars["powerup"] thread tombstone_wobble();
	vars["powerup"] thread tombstone_emp();

	result = self waittill_any_return("player_revived", "spawned_player", "disconnect");

	if (result == "disconnect")
	{
		vars["powerup"] tombstone_delete();
		return;
	}

	vars["powerup"] thread tombstone_waypoint();
	vars["powerup"] thread tombstone_timeout();
	vars["powerup"] thread tombstone_grab();
}

tombstone_wobble()
{
	self endon("tombstone_grabbed");
	self endon("tombstone_timedout");

	if (isDefined(self))
	{
		playfxontag(level._effect["powerup_on_solo"], self, "tag_origin");
		self playsound("zmb_tombstone_spawn");
		self playloopsound("zmb_tombstone_looper");
	}

	while (isDefined(self))
	{
		self rotateyaw(360, 3);
		wait 2.9;
	}
}

tombstone_emp()
{
	self endon("tombstone_timedout");
	self endon("tombstone_grabbed");

	if (!should_watch_for_emp())
	{
		return;
	}

	while (1)
	{
		level waittill("emp_detonate", origin, radius);

		if (distancesquared(origin, self.origin) < (radius * radius))
		{
			playfx(level._effect["powerup_off"], self.origin);
			self thread tombstone_delete();
		}
	}
}

tombstone_waypoint()
{
	hud = newClientHudElem(self.player);
	hud.x = self.origin[0];
	hud.y = self.origin[1];
	hud.z = self.origin[2] + 40;
	hud.alpha = 1;
	hud.color = (0.5, 0.5, 0.5);
	hud.hidewheninmenu = 1;
	hud.fadewhentargeted = 1;
	hud setShader("specialty_tombstone_zombies", 8, 8);
	hud setWaypoint(1);

	self waittill_any("tombstone_grabbed", "tombstone_timedout");

	hud destroy();
}

tombstone_timeout()
{
	self endon("tombstone_grabbed");

	self thread maps\mp\zombies\_zm_tombstone::playtombstonetimeraudio();

	self.player waittill("player_downed");

	self tombstone_delete();
}

tombstone_grab()
{
	self endon("tombstone_timedout");

	while (isDefined(self))
	{
		players = get_players();
		i = 0;

		while (i < players.size)
		{
			if (players[i].is_zombie)
			{
				i++;
				continue;
			}
			else
			{
				if (isDefined(self.player) && players[i] == self.player)
				{
					dist = distance(players[i].origin, self.origin);

					if (dist < 64)
					{
						playfx(level._effect["powerup_grabbed_solo"], self.origin);
						playfx(level._effect["powerup_grabbed_wave_solo"], self.origin);
						players[i] tombstone_give();
						wait 0.1;
						playsoundatposition("zmb_tombstone_grab", self.origin);
						self stoploopsound();
						self.icon unlink();
						self.icon delete();
						self delete();
						self notify("tombstone_grabbed");
						players[i] clientnotify("dc0");
						players[i] notify("dance_on_my_grave");
					}
				}
			}

			i++;
		}

		wait_network_frame();
	}
}

tombstone_delete()
{
	self notify("tombstone_timedout");
	self.icon unlink();
	self.icon delete();
	self delete();
}

tombstone_save()
{
	self.tombstone_savedweapon_weapons = self getweaponslist();
	self.tombstone_savedweapon_weaponsammo_clip = [];
	self.tombstone_savedweapon_weaponsammo_clip_dualwield = [];
	self.tombstone_savedweapon_weaponsammo_stock = [];
	self.tombstone_savedweapon_weaponsammo_clip_alt = [];
	self.tombstone_savedweapon_weaponsammo_stock_alt = [];
	self.tombstone_savedweapon_currentweapon = self getcurrentweapon();
	self.tombstone_savedweapon_melee = self get_player_melee_weapon();
	self.tombstone_savedweapon_grenades = self get_player_lethal_grenade();
	self.tombstone_savedweapon_tactical = self get_player_tactical_grenade();
	self.tombstone_savedweapon_mine = self get_player_placeable_mine();
	self.tombstone_savedweapon_equipment = self get_player_equipment();
	self.tombstone_hasriotshield = undefined;
	self.tombstone_perks = tombstone_save_perks(self);

	// can't switch to alt weapon
	if (is_alt_weapon(self.tombstone_savedweapon_currentweapon))
	{
		self.tombstone_savedweapon_currentweapon = maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(self.tombstone_savedweapon_currentweapon);
	}

	for (i = 0; i < self.tombstone_savedweapon_weapons.size; i++)
	{
		self.tombstone_savedweapon_weaponsammo_clip[i] = self getweaponammoclip(self.tombstone_savedweapon_weapons[i]);
		self.tombstone_savedweapon_weaponsammo_clip_dualwield[i] = self getweaponammoclip(weaponDualWieldWeaponName(self.tombstone_savedweapon_weapons[i]));
		self.tombstone_savedweapon_weaponsammo_stock[i] = self getweaponammostock(self.tombstone_savedweapon_weapons[i]);
		self.tombstone_savedweapon_weaponsammo_clip_alt[i] = self getweaponammoclip(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]));
		self.tombstone_savedweapon_weaponsammo_stock_alt[i] = self getweaponammostock(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]));

		wep = self.tombstone_savedweapon_weapons[i];
		dualwield_wep = weaponDualWieldWeaponName(wep);
		alt_wep = weaponAltWeaponName(wep);

		clip_missing = weaponClipSize(wep) - self.tombstone_savedweapon_weaponsammo_clip[i];

		if (clip_missing > self.tombstone_savedweapon_weaponsammo_stock[i])
		{
			clip_missing = self.tombstone_savedweapon_weaponsammo_stock[i];
		}

		self.tombstone_savedweapon_weaponsammo_clip[i] += clip_missing;
		self.tombstone_savedweapon_weaponsammo_stock[i] -= clip_missing;

		if (dualwield_wep != "none")
		{
			clip_dualwield_missing = weaponClipSize(dualwield_wep) - self.tombstone_savedweapon_weaponsammo_clip_dualwield[i];

			if (clip_dualwield_missing > self.tombstone_savedweapon_weaponsammo_stock[i])
			{
				clip_dualwield_missing = self.tombstone_savedweapon_weaponsammo_stock[i];
			}

			self.tombstone_savedweapon_weaponsammo_clip_dualwield[i] += clip_dualwield_missing;
			self.tombstone_savedweapon_weaponsammo_stock[i] -= clip_dualwield_missing;
		}

		if (alt_wep != "none")
		{
			clip_alt_missing = weaponClipSize(alt_wep) - self.tombstone_savedweapon_weaponsammo_clip_alt[i];

			if (clip_alt_missing > self.tombstone_savedweapon_weaponsammo_stock_alt[i])
			{
				clip_alt_missing = self.tombstone_savedweapon_weaponsammo_stock_alt[i];
			}

			self.tombstone_savedweapon_weaponsammo_clip_alt[i] += clip_alt_missing;
			self.tombstone_savedweapon_weaponsammo_stock_alt[i] -= clip_alt_missing;
		}
	}

	if (isDefined(self.tombstone_savedweapon_grenades))
	{
		self.tombstone_savedweapon_grenades_clip = self getweaponammoclip(self.tombstone_savedweapon_grenades);
	}

	if (isDefined(self.tombstone_savedweapon_tactical))
	{
		self.tombstone_savedweapon_tactical_clip = self getweaponammoclip(self.tombstone_savedweapon_tactical);
	}

	if (isDefined(self.tombstone_savedweapon_mine))
	{
		self.tombstone_savedweapon_mine_clip = self getweaponammoclip(self.tombstone_savedweapon_mine);
	}

	if (isDefined(self.hasriotshield) && self.hasriotshield)
	{
		self.tombstone_hasriotshield = 1;
	}
}

tombstone_save_perks(ent)
{
	perk_array = [];

	if (ent hasperk("specialty_armorvest"))
	{
		perk_array[perk_array.size] = "specialty_armorvest";
	}

	if (ent hasperk("specialty_deadshot"))
	{
		perk_array[perk_array.size] = "specialty_deadshot";
	}

	if (ent hasperk("specialty_fastreload"))
	{
		perk_array[perk_array.size] = "specialty_fastreload";
	}

	if (ent hasperk("specialty_flakjacket"))
	{
		perk_array[perk_array.size] = "specialty_flakjacket";
	}

	if (ent hasperk("specialty_movefaster"))
	{
		perk_array[perk_array.size] = "specialty_movefaster";
	}

	if (ent hasperk("specialty_quickrevive"))
	{
		perk_array[perk_array.size] = "specialty_quickrevive";
	}

	if (ent hasperk("specialty_rof"))
	{
		perk_array[perk_array.size] = "specialty_rof";
	}

	return perk_array;
}

tombstone_give()
{
	if (!isDefined(self.tombstone_savedweapon_weapons))
	{
		return;
	}

	primary_weapons = self getWeaponsListPrimaries();

	foreach (weapon in primary_weapons)
	{
		self takeWeapon(weapon);
	}

	self takeWeapon(self get_player_melee_weapon());
	self takeWeapon(self get_player_lethal_grenade());
	self takeWeapon(self get_player_tactical_grenade());
	self takeWeapon(self get_player_placeable_mine());

	primary_weapons_returned = 0;
	i = 0;

	while (i < self.tombstone_savedweapon_weapons.size)
	{
		if (isdefined(self.tombstone_savedweapon_grenades) && self.tombstone_savedweapon_weapons[i] == self.tombstone_savedweapon_grenades || (isdefined(self.tombstone_savedweapon_tactical) && self.tombstone_savedweapon_weapons[i] == self.tombstone_savedweapon_tactical))
		{
			i++;
			continue;
		}

		if (isweaponprimary(self.tombstone_savedweapon_weapons[i]))
		{
			if (primary_weapons_returned >= 2)
			{
				i++;
				continue;
			}

			primary_weapons_returned++;
		}

		if (level.item_meat_name == self.tombstone_savedweapon_weapons[i])
		{
			i++;
			continue;
		}

		self giveweapon(self.tombstone_savedweapon_weapons[i], 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(self.tombstone_savedweapon_weapons[i]));

		if (isdefined(self.tombstone_savedweapon_weaponsammo_clip[i]))
		{
			self setweaponammoclip(self.tombstone_savedweapon_weapons[i], self.tombstone_savedweapon_weaponsammo_clip[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_clip_dualwield[i]))
		{
			self setweaponammoclip(weaponDualWieldWeaponName(self.tombstone_savedweapon_weapons[i]), self.tombstone_savedweapon_weaponsammo_clip_dualwield[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_stock[i]))
		{
			self setweaponammostock(self.tombstone_savedweapon_weapons[i], self.tombstone_savedweapon_weaponsammo_stock[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_clip_alt[i]))
		{
			self setweaponammoclip(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]), self.tombstone_savedweapon_weaponsammo_clip_alt[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_stock_alt[i]))
		{
			self setweaponammostock(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]), self.tombstone_savedweapon_weaponsammo_stock_alt[i]);
		}

		i++;
	}

	if (isDefined(self.tombstone_savedweapon_melee))
	{
		self set_player_melee_weapon(self.tombstone_savedweapon_melee);
		self setactionslot(2, "weapon", "held_" + self.tombstone_savedweapon_melee);
	}

	if (isDefined(self.tombstone_savedweapon_grenades))
	{
		self giveweapon(self.tombstone_savedweapon_grenades);
		self set_player_lethal_grenade(self.tombstone_savedweapon_grenades);

		if (isDefined(self.tombstone_savedweapon_grenades_clip))
		{
			self setweaponammoclip(self.tombstone_savedweapon_grenades, self.tombstone_savedweapon_grenades_clip);
		}
	}

	if (isDefined(self.tombstone_savedweapon_tactical))
	{
		self giveweapon(self.tombstone_savedweapon_tactical);
		self set_player_tactical_grenade(self.tombstone_savedweapon_tactical);

		if (isDefined(self.tombstone_savedweapon_tactical_clip))
		{
			self setweaponammoclip(self.tombstone_savedweapon_tactical, self.tombstone_savedweapon_tactical_clip);
		}
	}

	if (isDefined(self.tombstone_savedweapon_mine))
	{
		self giveweapon(self.tombstone_savedweapon_mine);
		self set_player_placeable_mine(self.tombstone_savedweapon_mine);
		self setactionslot(4, "weapon", self.tombstone_savedweapon_mine);
		self setweaponammoclip(self.tombstone_savedweapon_mine, self.tombstone_savedweapon_mine_clip);
	}

	if (isDefined(self.current_equipment))
	{
		self maps\mp\zombies\_zm_equipment::equipment_take(self.current_equipment);
	}

	if (isDefined(self.tombstone_savedweapon_equipment))
	{
		self.do_not_display_equipment_pickup_hint = 1;
		self maps\mp\zombies\_zm_equipment::equipment_give(self.tombstone_savedweapon_equipment);
		self.do_not_display_equipment_pickup_hint = undefined;
	}

	if (isDefined(self.tombstone_hasriotshield) && self.tombstone_hasriotshield)
	{
		if (isDefined(self.player_shield_reset_health))
		{
			self [[self.player_shield_reset_health]]();
		}
	}

	current_wep = self getCurrentWeapon();

	if (!isSubStr(current_wep, "perk_bottle") && !isSubStr(current_wep, "knuckle_crack") && !isSubStr(current_wep, "flourish") && !isSubStr(current_wep, level.item_meat_name))
	{
		switched = 0;
		primaries = self getweaponslistprimaries();

		foreach (weapon in primaries)
		{
			if (isDefined(self.tombstone_savedweapon_currentweapon) && self.tombstone_savedweapon_currentweapon == weapon)
			{
				switched = 1;
				self switchtoweapon(weapon);
			}
		}

		if (!switched)
		{
			if (primaries.size > 0)
			{
				self switchtoweapon(primaries[0]);
			}
		}
	}

	if (isDefined(self.tombstone_perks) && self.tombstone_perks.size > 0)
	{
		i = 0;

		while (i < self.tombstone_perks.size)
		{
			if (self hasperk(self.tombstone_perks[i]))
			{
				i++;
				continue;
			}

			self maps\mp\zombies\_zm_perks::give_perk(self.tombstone_perks[i]);
			i++;
		}
	}
}

additionalprimaryweapon_indicator()
{
	self endon("disconnect");

	if (!is_true(level.zombiemode_using_additionalprimaryweapon_perk))
	{
		return;
	}

	hud = newClientHudElem(self);
	hud.alignx = "right";
	hud.aligny = "bottom";
	hud.horzalign = "user_right";
	hud.vertalign = "user_bottom";

	if (level.script == "zm_highrise")
	{
		hud.x -= 60;
		hud.y -= 55;
	}
	else
	{
		hud.x -= 60;
		hud.y -= 80;
	}

	hud.alpha = 0;
	hud.color = (1, 1, 1);
	hud.hidewheninmenu = 1;
	hud setShader("specialty_additionalprimaryweapon_zombies", 24, 24);

	hud thread destroy_on_intermission();

	while (1)
	{
		self waittill_any("weapon_change", "specialty_additionalprimaryweapon_stop", "player_downed", "spawned_player");

		if (!is_player_valid(self) || !self hasPerk("specialty_additionalprimaryweapon"))
		{
			hud fadeOverTime(0.5);
			hud.alpha = 0;
			continue;
		}

		primary_weapons_that_can_be_taken = [];
		primaryweapons = self getweaponslistprimaries();

		for (i = 0; i < primaryweapons.size; i++)
		{
			if (maps\mp\zombies\_zm_weapons::is_weapon_included(primaryweapons[i]) || maps\mp\zombies\_zm_weapons::is_weapon_upgraded(primaryweapons[i]))
			{
				primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryweapons[i];
			}
		}

		pwtcbt = primary_weapons_that_can_be_taken.size;

		if (pwtcbt < 3)
		{
			hud fadeOverTime(0.5);
			hud.alpha = 0;
			continue;
		}

		weapon = primary_weapons_that_can_be_taken[pwtcbt - 1];

		if (self getCurrentWeapon() != weapon)
		{
			hud fadeOverTime(0.5);
			hud.alpha = 0;
			continue;
		}

		self thread additionalprimaryweapon_indicator_show_and_hide(hud);
	}
}

additionalprimaryweapon_indicator_show_and_hide(hud)
{
	self endon("disconnect");
	self endon("player_downed");
	self endon("spawned_player");
	self endon("weapon_change");
	self endon("specialty_additionalprimaryweapon_stop");

	hud fadeOverTime(0.5);
	hud.alpha = 1;

	wait 1.5;

	hud fadeOverTime(0.5);
	hud.alpha = 0;
}

additionalprimaryweapon_stowed_weapon_refill()
{
	self endon("disconnect");

	vars = [];

	while (1)
	{
		vars["string"] = self waittill_any_return("weapon_change", "weapon_change_complete", "specialty_additionalprimaryweapon_stop", "spawned_player");

		if (self hasPerk("specialty_additionalprimaryweapon"))
		{
			vars["curr_wep"] = self getCurrentWeapon();

			if (vars["curr_wep"] == "none")
			{
				continue;
			}

			primaries = self getWeaponsListPrimaries();

			foreach (primary in primaries)
			{
				if (primary != maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(vars["curr_wep"]))
				{
					if (vars["string"] != "weapon_change")
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

	vars = [];

	vars["reload_time"] = weaponReloadTime(primary);
	vars["reload_amount"] = undefined;

	if (primary == "m32_zm" || primary == "python_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "judge_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "870mcs_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "ksg_zm")
	{
		vars["reload_amount"] = 1;

		if (maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "ksg_zm" && maps\mp\zombies\_zm_weapons::is_weapon_upgraded(primary))
		{
			vars["reload_amount"] = 2;
		}
	}

	if (!isDefined(vars["reload_amount"]) && vars["reload_time"] < 1)
	{
		vars["reload_time"] = 1;
	}

	if (self hasPerk("specialty_fastreload"))
	{
		vars["reload_time"] *= getDvarFloat("perk_weapReloadMultiplier");
	}

	wait vars["reload_time"];

	vars["ammo_clip"] = self getWeaponAmmoClip(primary);
	vars["ammo_stock"] = self getWeaponAmmoStock(primary);
	vars["missing_clip"] = weaponClipSize(primary) - vars["ammo_clip"];

	if (vars["missing_clip"] > vars["ammo_stock"])
	{
		vars["missing_clip"] = vars["ammo_stock"];
	}

	if (isDefined(vars["reload_amount"]) && vars["missing_clip"] > vars["reload_amount"])
	{
		vars["missing_clip"] = vars["reload_amount"];
	}

	self setWeaponAmmoClip(primary, vars["ammo_clip"] + vars["missing_clip"]);
	self setWeaponAmmoStock(primary, vars["ammo_stock"] - vars["missing_clip"]);

	vars["dw_primary"] = weaponDualWieldWeaponName(primary);

	if (vars["dw_primary"] != "none")
	{
		vars["ammo_clip"] = self getWeaponAmmoClip(vars["dw_primary"]);
		vars["ammo_stock"] = self getWeaponAmmoStock(vars["dw_primary"]);
		vars["missing_clip"] = weaponClipSize(vars["dw_primary"]) - vars["ammo_clip"];

		if (vars["missing_clip"] > vars["ammo_stock"])
		{
			vars["missing_clip"] = vars["ammo_stock"];
		}

		self setWeaponAmmoClip(vars["dw_primary"], vars["ammo_clip"] + vars["missing_clip"]);
		self setWeaponAmmoStock(vars["dw_primary"], vars["ammo_stock"] - vars["missing_clip"]);
	}

	vars["alt_primary"] = weaponAltWeaponName(primary);

	if (vars["alt_primary"] != "none")
	{
		vars["ammo_clip"] = self getWeaponAmmoClip(vars["alt_primary"]);
		vars["ammo_stock"] = self getWeaponAmmoStock(vars["alt_primary"]);
		vars["missing_clip"] = weaponClipSize(vars["alt_primary"]) - vars["ammo_clip"];

		if (vars["missing_clip"] > vars["ammo_stock"])
		{
			vars["missing_clip"] = vars["ammo_stock"];
		}

		self setWeaponAmmoClip(vars["alt_primary"], vars["ammo_clip"] + vars["missing_clip"]);
		self setWeaponAmmoStock(vars["alt_primary"], vars["ammo_stock"] - vars["missing_clip"]);
	}

	if (isDefined(vars["reload_amount"]) && self getWeaponAmmoStock(primary) > 0 && self getWeaponAmmoClip(primary) < weaponClipSize(primary))
	{
		self refill_after_time(primary);
	}
}

electric_cherry_unlimited()
{
	self endon("disconnect");

	for (;;)
	{
		self.consecutive_electric_cherry_attacks = 0;

		wait 0.5;
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
		// Green Highrise to Lower Blue Highrise
		level.zones["zone_green_level3b"].adjacent_zones["zone_blue_level1c"] structdelete();
		level.zones["zone_green_level3b"].adjacent_zones["zone_blue_level1c"] = undefined;

		// Lower Orange Highrise debris
		level.zones["zone_orange_level3a"].adjacent_zones["zone_orange_level3b"].is_connected = 0;
		level.zones["zone_orange_level3b"].adjacent_zones["zone_orange_level3a"].is_connected = 0;
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

remove_status_icons_on_intermission()
{
	level waittill("intermission");

	players = get_players();

	foreach (player in players)
	{
		player.statusicon = "";
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