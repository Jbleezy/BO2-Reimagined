#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\replaced\utility;
#include scripts\zm\replaced\_zm;
#include scripts\zm\replaced\_zm_playerhealth;
#include scripts\zm\replaced\_zm_utility;
#include scripts\zm\replaced\_zm_score;
#include scripts\zm\replaced\_zm_laststand;
#include scripts\zm\replaced\_zm_weapons;
#include scripts\zm\replaced\_zm_magicbox;
#include scripts\zm\replaced\_zm_perks;
#include scripts\zm\replaced\_zm_power;
#include scripts\zm\replaced\_zm_powerups;
#include scripts\zm\replaced\_zm_pers_upgrades;
#include scripts\zm\replaced\_zm_traps;
#include scripts\zm\replaced\_zm_equipment;
#include scripts\zm\replaced\_zm_spawner;
#include scripts\zm\replaced\_zm_ai_basic;
#include scripts\zm\replaced\_zm_melee_weapon;
#include scripts\zm\replaced\_zm_weap_ballistic_knife;
#include scripts\zm\replaced\_zm_weap_claymore;

main()
{
	replaceFunc(common_scripts\utility::struct_class_init, scripts\zm\replaced\utility::struct_class_init);
	replaceFunc(maps\mp\zombies\_zm::check_quickrevive_for_hotjoin, scripts\zm\replaced\_zm::check_quickrevive_for_hotjoin);
	replaceFunc(maps\mp\zombies\_zm::ai_calculate_health, scripts\zm\replaced\_zm::ai_calculate_health);
	replaceFunc(maps\mp\zombies\_zm::last_stand_pistol_rank_init, scripts\zm\replaced\_zm::last_stand_pistol_rank_init);
	replaceFunc(maps\mp\zombies\_zm::check_for_valid_spawn_near_team, scripts\zm\replaced\_zm::check_for_valid_spawn_near_team);
	replaceFunc(maps\mp\zombies\_zm::get_valid_spawn_location, scripts\zm\replaced\_zm::get_valid_spawn_location);
	replaceFunc(maps\mp\zombies\_zm::actor_damage_override, scripts\zm\replaced\_zm::actor_damage_override);
	replaceFunc(maps\mp\zombies\_zm::player_spawn_protection, scripts\zm\replaced\_zm::player_spawn_protection);
	replaceFunc(maps\mp\zombies\_zm::wait_and_revive, scripts\zm\replaced\_zm::wait_and_revive);
	replaceFunc(maps\mp\zombies\_zm::player_revive_monitor, scripts\zm\replaced\_zm::player_revive_monitor);
	replaceFunc(maps\mp\zombies\_zm::end_game, scripts\zm\replaced\_zm::end_game);
	replaceFunc(maps\mp\zombies\_zm_playerhealth::playerhealthregen, scripts\zm\replaced\_zm_playerhealth::playerhealthregen);
	replaceFunc(maps\mp\zombies\_zm_utility::track_players_intersection_tracker, scripts\zm\replaced\_zm_utility::track_players_intersection_tracker);
	replaceFunc(maps\mp\zombies\_zm_utility::is_headshot, scripts\zm\replaced\_zm_utility::is_headshot);
	replaceFunc(maps\mp\zombies\_zm_utility::create_zombie_point_of_interest_attractor_positions, scripts\zm\replaced\_zm_utility::create_zombie_point_of_interest_attractor_positions);
	replaceFunc(maps\mp\zombies\_zm_score::add_to_player_score, scripts\zm\replaced\_zm_score::add_to_player_score);
	replaceFunc(maps\mp\zombies\_zm_score::minus_to_player_score, scripts\zm\replaced\_zm_score::minus_to_player_score);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_do_revive, scripts\zm\replaced\_zm_laststand::revive_do_revive);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_give_back_weapons, scripts\zm\replaced\_zm_laststand::revive_give_back_weapons);
	replaceFunc(maps\mp\zombies\_zm_laststand::revive_hud_think, scripts\zm\replaced\_zm_laststand::revive_hud_think);
	replaceFunc(maps\mp\zombies\_zm_weapons::weapon_give, scripts\zm\replaced\_zm_weapons::weapon_give);
	replaceFunc(maps\mp\zombies\_zm_weapons::get_upgraded_ammo_cost, scripts\zm\replaced\_zm_weapons::get_upgraded_ammo_cost);
	replaceFunc(maps\mp\zombies\_zm_weapons::makegrenadedudanddestroy, scripts\zm\replaced\_zm_weapons::makegrenadedudanddestroy);
	replaceFunc(maps\mp\zombies\_zm_weapons::createballisticknifewatcher_zm, scripts\zm\replaced\_zm_weapons::createballisticknifewatcher_zm);
	replaceFunc(maps\mp\zombies\_zm_magicbox::treasure_chest_init, scripts\zm\replaced\_zm_magicbox::treasure_chest_init);
	replaceFunc(maps\mp\zombies\_zm_magicbox::treasure_chest_move, scripts\zm\replaced\_zm_magicbox::treasure_chest_move);
	replaceFunc(maps\mp\zombies\_zm_magicbox::treasure_chest_timeout, scripts\zm\replaced\_zm_magicbox::treasure_chest_timeout);
	replaceFunc(maps\mp\zombies\_zm_magicbox::timer_til_despawn, scripts\zm\replaced\_zm_magicbox::timer_til_despawn);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_pause, scripts\zm\replaced\_zm_perks::perk_pause);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_unpause, scripts\zm\replaced\_zm_perks::perk_unpause);
	replaceFunc(maps\mp\zombies\_zm_perks::destroy_weapon_in_blackout, scripts\zm\replaced\_zm_perks::destroy_weapon_in_blackout);
	replaceFunc(maps\mp\zombies\_zm_perks::give_perk, scripts\zm\replaced\_zm_perks::give_perk);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_think, scripts\zm\replaced\_zm_perks::perk_think);
	replaceFunc(maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg, scripts\zm\replaced\_zm_perks::perk_set_max_health_if_jugg);
	replaceFunc(maps\mp\zombies\_zm_perks::initialize_custom_perk_arrays, scripts\zm\replaced\_zm_perks::initialize_custom_perk_arrays);
	replaceFunc(maps\mp\zombies\_zm_power::standard_powered_items, scripts\zm\replaced\_zm_power::standard_powered_items);
	replaceFunc(maps\mp\zombies\_zm_powerups::full_ammo_powerup, scripts\zm\replaced\_zm_powerups::full_ammo_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::nuke_powerup, scripts\zm\replaced\_zm_powerups::nuke_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::insta_kill_powerup, scripts\zm\replaced\_zm_powerups::insta_kill_powerup);
	replaceFunc(maps\mp\zombies\_zm_powerups::double_points_powerup, scripts\zm\replaced\_zm_powerups::double_points_powerup);
	replaceFunc(maps\mp\zombies\_zm_pers_upgrades::is_pers_system_disabled, scripts\zm\replaced\_zm_pers_upgrades::is_pers_system_disabled);
	replaceFunc(maps\mp\zombies\_zm_traps::player_elec_damage, scripts\zm\replaced\_zm_traps::player_elec_damage);
	replaceFunc(maps\mp\zombies\_zm_equipment::show_equipment_hint, scripts\zm\replaced\_zm_equipment::show_equipment_hint);
	replaceFunc(maps\mp\zombies\_zm_equipment::placed_equipment_think, scripts\zm\replaced\_zm_equipment::placed_equipment_think);
	replaceFunc(maps\mp\zombies\_zm_spawner::head_should_gib, scripts\zm\replaced\_zm_spawner::head_should_gib);
	replaceFunc(maps\mp\zombies\_zm_ai_basic::inert_wakeup, scripts\zm\replaced\_zm_ai_basic::inert_wakeup);
	replaceFunc(maps\mp\zombies\_zm_melee_weapon::change_melee_weapon, scripts\zm\replaced\_zm_melee_weapon::change_melee_weapon);
	replaceFunc(maps\mp\zombies\_zm_weap_ballistic_knife::watch_use_trigger, scripts\zm\replaced\_zm_weap_ballistic_knife::watch_use_trigger);
	replaceFunc(maps\mp\zombies\_zm_weap_claymore::claymore_detonation, scripts\zm\replaced\_zm_weap_claymore::claymore_detonation);
}

init()
{
	level.using_solo_revive = 0;
	level.claymores_max_per_player = 20;

	if(getDvar("g_gametype") == "zgrief" && is_true(level.scr_zm_ui_gametype_pro))
	{
		level.player_starting_health = 100;
	}
	else
	{
		level.player_starting_health = 150;
	}

	setscoreboardcolumns_gametype();
	set_lethal_grenade_init();
	set_dvars();

	level thread initial_print();

	level thread onplayerconnect();
	level thread post_all_players_spawned();

	level thread enemy_counter_hud();
	level thread timer_hud();

	level thread swap_staminup_perk();
}

initial_print()
{
	flag_wait("initial_players_connected");

	iprintln("Reimagined Loaded");
}

onplayerconnect()
{
	while(true)
	{
		level waittill("connecting", player);

		if(isDefined(level.map_on_player_connect))
		{
			player thread [[level.map_on_player_connect]]();
		}

		player thread onplayerspawned();
		player thread onplayerdowned();

		player thread weapon_inspect_watcher();
	}
}

onplayerspawned()
{
	level endon( "game_ended" );
	self endon( "disconnect" );

	self.initial_spawn = true;

	for(;;)
	{
		self waittill( "spawned_player" );

		if (self.initial_spawn)
		{
			self.initial_spawn = false;

			self.solo_lives_given = 0;
			self.stored_weapon_data = undefined;
			self.screecher_seen_hint = 1;

			self thread health_bar_hud();
			self thread bleedout_bar_hud();
			self thread zone_hud();

			self thread veryhurt_blood_fx();

			self thread ignoreme_after_revived();

			self thread fall_velocity_check();

			self thread melee_weapon_switch_watcher();

			self thread give_additional_perks();

			self thread weapon_locker_give_ammo_after_rounds();

			self thread buildable_piece_remove_on_last_stand();

			self thread war_machine_explode_on_impact();

			self thread jetgun_heatval_changes();

			self thread additionalprimaryweapon_save_weapons();
			self thread additionalprimaryweapon_restore_weapons();
			self thread additionalprimaryweapon_indicator();
			self thread additionalprimaryweapon_stowed_weapon_refill();

			self thread whos_who_spawn_changes();

			self thread electric_cherry_unlimited();

			self thread vulture_disable_stink_while_standing();

			//self.score = 100000;
			//maps\mp\zombies\_zm_perks::give_perk( "specialty_armorvest", 0 );
			//self GiveWeapon("dsr50_zm");
			//self GiveMaxAmmo("dsr50_zm");
		}

		self set_client_dvars();
		self set_perks();
	}
}

onplayerdowned()
{
	level endon( "game_ended" );
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "entering_last_stand" );

		self.health = self.maxhealth;
	}
}

post_all_players_spawned()
{
	flag_wait( "start_zombie_round_logic" );

	wait 0.05;

	maps\mp\zombies\_zm::register_player_damage_callback( ::player_damage_override );

	level.near_miss = 2; // makes screecher not run away first time on solo
	level.ta_vaultfee = 0;
	level.ta_tellerfee = 0;
	level.weapon_locker_online = 0;
	level.magicbox_timeout = 9;
	level.packapunch_timeout = 12;
	level.perk_purchase_limit = 9;
	level._random_zombie_perk_cost = 2500;
	level.equipment_etrap_needs_power = 0;
	level.equipment_turret_needs_power = 0;
	level.equipment_subwoofer_needs_power = 0;
	level.limited_weapons["ray_gun_zm"] = undefined;
	level.limited_weapons["raygun_mark2_zm"] = 1;
	level.zombie_weapons["slipgun_zm"].upgrade_name = "slipgun_upgraded_zm";
	level.zombie_weapons_upgraded["slipgun_upgraded_zm"] = "slipgun_zm";
	level.zombie_vars["emp_stun_range"] = 420;
	level.zombie_vars["slipgun_reslip_rate"] = 0;
	level.zombie_ai_limit_screecher = 1;
	level.explode_overheated_jetgun = 0;
	level.unbuild_overheated_jetgun = 0;
	level.take_overheated_jetgun = 1;
	level.speed_change_round = undefined;
	level.playersuicideallowed = undefined;
	level.disable_free_perks_before_power = undefined;
	level.custom_random_perk_weights = undefined;
	level.global_damage_func = scripts\zm\replaced\_zm_spawner::zombie_damage;
	level.callbackplayerdamage = scripts\zm\replaced\_zm::callback_playerdamage;
	level.overrideplayerdamage = scripts\zm\replaced\_zm::player_damage_override;
	level.playerlaststand_func = scripts\zm\replaced\_zm::player_laststand;
	level.etrap_damage = maps\mp\zombies\_zm::ai_zombie_health( 255 );
	level.slipgun_damage = maps\mp\zombies\_zm::ai_zombie_health( 255 );
	level.tombstone_spawn_func = ::tombstone_spawn;
	level.tombstone_laststand_func = ::tombstone_save;
	level.zombie_last_stand = ::last_stand_pistol_swap;
	level.zombie_last_stand_ammo_return = ::last_stand_restore_pistol_ammo;

	disable_carpenter();

	disable_bank_teller();

	wallbuy_increase_trigger_radius();
	wallbuy_decrease_upgraded_ammo_cost();
	wallbuy_lethal_grenade_changes();
	wallbuy_claymore_changes();
	wallbuy_location_changes();

	zone_changes();

	jetgun_remove_forced_weapon_switch();

	level thread wallbuy_cost_changes();

	level thread buildbuildables();
	level thread buildcraftables();

	level thread wallbuy_dynamic_update();
	level thread wallbuy_dynamic_zgrief_update();

	//level.round_number = 115;
	//level.zombie_move_speed = 105;
	//level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
	//level.zombie_ai_limit = 1;

	//level.local_doors_stay_open = 1;
	//level.power_local_doors_globally = 1;
}

set_dvars()
{
	setDvar( "zm_reimagined_version", "1.0.0" );

	setDvar( "player_backSpeedScale", 1 );

	setDvar( "dtp_post_move_pause", 0 );
	setDvar( "dtp_startup_delay", 100 );
	setDvar( "dtp_exhaustion_window", 100 );

	setDvar( "player_meleeRange", 64 );
	setDvar( "player_breath_gasp_lerp", 0 );

	setDvar( "g_friendlyfireDist", 0 );

	setDvar( "perk_weapRateEnhanced", 0 );

	setDvar( "sv_patch_zm_weapons", 0 );
	setDvar( "sv_fix_zm_weapons", 1 );

	setDvar( "sv_voice", 2 );
	setDvar( "sv_voiceQuality", 9 );

	setDvar( "sv_cheats", 0 );
}

set_client_dvars()
{
	self setClientDvar( "player_lastStandBleedoutTime", getDvarInt( "player_lastStandBleedoutTime" ) );

	self setClientDvar( "dtp_post_move_pause", getDvarInt( "dtp_post_move_pause" ) );
	self setClientDvar( "dtp_startup_delay", getDvarInt( "dtp_startup_delay" ) );
	self setClientDvar( "dtp_exhaustion_window", getDvarInt( "dtp_exhaustion_window" ) );

	self setClientDvar( "aim_automelee_enabled", 0 );

	self setClientDvar( "cg_drawBreathHint", 0 );

	self setClientDvar( "cg_friendlyNameFadeIn", 0 );
	self setClientDvar( "cg_friendlyNameFadeOut", 250 );
	self setClientDvar( "cg_enemyNameFadeIn", 0 );
	self setClientDvar( "cg_enemyNameFadeOut", 250 );

	self setClientDvar( "waypointOffscreenPointerDistance", 30);
	self setClientDvar( "waypointOffscreenPadTop", 32);
	self setClientDvar( "waypointOffscreenPadBottom", 32);
	self setClientDvar( "waypointPlayerOffsetStand", 30);
	self setClientDvar( "waypointPlayerOffsetCrouch", 30);

	self setClientDvar( "r_fog", 0 );

	self setClientDvar( "r_lodBiasRigid", -1000 );
	self setClientDvar( "r_lodBiasSkinned", -1000 );

	self setClientDvar( "cg_ufo_scaler", 1 );
}

set_perks()
{
	if(!(getDvar("g_gametype") == "zgrief" && getDvarIntDefault("ui_gametype_pro", 0)))
	{
		self setperk( "specialty_unlimitedsprint" );
	}

	self setperk( "specialty_fastmantle" );
	self setperk( "specialty_fastladderclimb" );
}

health_bar_hud()
{
	self endon("disconnect");

	flag_wait( "initial_blackscreen_passed" );

	if(getDvar("g_gametype") == "zgrief" && is_true(level.scr_zm_ui_gametype_pro))
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

	health_bar = self createbar((1, 1, 1), level.primaryprogressbarwidth - 10, level.primaryprogressbarheight);
	health_bar.alignx = "left";
	health_bar.bar.alignx = "left";
	health_bar.barframe.alignx = "left";
	health_bar.aligny = "middle";
	health_bar.bar.aligny = "middle";
	health_bar.barframe.aligny = "middle";
	health_bar.horzalign = "user_left";
	health_bar.bar.horzalign = "user_left";
	health_bar.barframe.horzalign = "user_left";
	health_bar.vertalign = "user_bottom";
	health_bar.bar.vertalign = "user_bottom";
	health_bar.barframe.vertalign = "user_bottom";
	health_bar.x += x;
	health_bar.bar.x += x + ((health_bar.width + 4) / 2);
	health_bar.barframe.x += x;
	health_bar.y += y;
	health_bar.bar.y += y;
	health_bar.barframe.y += y;
	health_bar.hidewheninmenu = 1;
	health_bar.bar.hidewheninmenu = 1;
	health_bar.barframe.hidewheninmenu = 1;
	health_bar.foreground = 1;
	health_bar.bar.foreground = 1;
	health_bar.barframe.foreground = 1;

	health_bar_text = createfontstring("objective", 1.2);
	health_bar_text.alignx = "left";
	health_bar_text.aligny = "middle";
	health_bar_text.horzalign = "user_left";
	health_bar_text.vertalign = "user_bottom";
	health_bar_text.x += x + health_bar.width + 7;
	health_bar_text.y += y;
	health_bar_text.hidewheninmenu = 1;
	health_bar_text.foreground = 1;

	health_bar endon("death");

	health_bar thread destroy_on_intermission();
	health_bar_text thread destroy_on_intermission();

	while (1)
	{
		if(isDefined(self.e_afterlife_corpse))
		{
			health_bar hideelem();
			health_bar_text hideelem();

			while(isDefined(self.e_afterlife_corpse))
			{
				wait 0.05;
			}

			health_bar showelem();
			health_bar_text showelem();
		}

		health_bar updatebar(self.health / self.maxhealth);
		health_bar_text setvalue(self.health);

		wait 0.05;
	}
}

enemy_counter_hud()
{
	if ( getDvar( "g_gametype" ) == "zgrief" )
	{
		return;
	}

	enemy_counter_hud = newHudElem();
	enemy_counter_hud.alignx = "left";
	enemy_counter_hud.aligny = "top";
	enemy_counter_hud.horzalign = "user_left";
	enemy_counter_hud.vertalign = "user_top";
	enemy_counter_hud.x += 5;
	if (level.script == "zm_tomb")
	{
		enemy_counter_hud.y += 49;
	}
	else
	{
		enemy_counter_hud.y += 2;
	}
	enemy_counter_hud.fontscale = 1.4;
	enemy_counter_hud.alpha = 0;
	enemy_counter_hud.color = ( 1, 1, 1 );
	enemy_counter_hud.hidewheninmenu = 1;
	enemy_counter_hud.foreground = 1;
	enemy_counter_hud.label = &"Enemies Remaining: ";

	enemy_counter_hud endon("death");

	enemy_counter_hud thread destroy_on_intermission();

	flag_wait( "initial_blackscreen_passed" );

	enemy_counter_hud.alpha = 1;
	while (1)
	{
		enemies = get_round_enemy_array().size + level.zombie_total;

		if (enemies == 0)
		{
			enemy_counter_hud setText("");
		}
		else
		{
			enemy_counter_hud setValue(enemies);
		}

		wait 0.05;
	}
}

timer_hud()
{
	level thread round_timer_hud();

	timer_hud = newHudElem();
	timer_hud.alignx = "right";
	timer_hud.aligny = "top";
	timer_hud.horzalign = "user_right";
	timer_hud.vertalign = "user_top";
	timer_hud.x -= 5;
	timer_hud.y += 12;
	timer_hud.fontscale = 1.4;
	timer_hud.alpha = 0;
	timer_hud.color = ( 1, 1, 1 );
	timer_hud.hidewheninmenu = 1;
	timer_hud.foreground = 1;
	timer_hud.label = &"Total: ";

	timer_hud endon("death");

	timer_hud thread destroy_on_intermission();

	level thread set_time_frozen_on_end_game(timer_hud);

	flag_wait( "initial_blackscreen_passed" );

	timer_hud.alpha = 1;

	if ( getDvar( "g_gametype" ) == "zgrief" )
	{
		set_time_frozen(timer_hud, 0);
	}

	timer_hud setTimerUp(0);
	timer_hud.start_time = int(getTime() / 1000);
}

round_timer_hud()
{
	if(isDefined(level.scr_zm_ui_gametype_obj) && level.scr_zm_ui_gametype_obj != "zsnr")
	{
		return;
	}

	round_timer_hud = newHudElem();
	round_timer_hud.alignx = "right";
	round_timer_hud.aligny = "top";
	round_timer_hud.horzalign = "user_right";
	round_timer_hud.vertalign = "user_top";
	round_timer_hud.x -= 5;
	round_timer_hud.y += 27;
	round_timer_hud.fontscale = 1.4;
	round_timer_hud.alpha = 0;
	round_timer_hud.color = ( 1, 1, 1 );
	round_timer_hud.hidewheninmenu = 1;
	round_timer_hud.foreground = 1;
	round_timer_hud.label = &"Round: ";

	round_timer_hud endon("death");

	round_timer_hud thread destroy_on_intermission();

	level thread set_time_frozen_on_end_game(round_timer_hud);

	flag_wait( "initial_blackscreen_passed" );

	round_timer_hud.alpha = 1;

	if ( getDvar( "g_gametype" ) == "zgrief" )
	{
		set_time_frozen(round_timer_hud, 0);
	}

	while (1)
	{
		round_timer_hud setTimerUp(0);
		round_timer_hud.start_time = int(getTime() / 1000);
		round_timer_hud.end_time = undefined;

		if ( getDvar( "g_gametype" ) == "zgrief" )
		{
			level waittill( "restart_round" );
		}
		else
		{
			level waittill( "end_of_round" );
		}

		round_timer_hud.end_time = int(getTime() / 1000);
		time = round_timer_hud.end_time - round_timer_hud.start_time;

		set_time_frozen(round_timer_hud, time);
	}
}

set_time_frozen_on_end_game(hud)
{
	level endon("intermission");

	level waittill("end_game");

	if(!isDefined(hud.end_time))
	{
		hud.end_time = int(getTime() / 1000);
	}

	time = hud.end_time - hud.start_time;

	set_time_frozen(hud, time);
}

set_time_frozen(hud, time)
{
	if ( getDvar( "g_gametype" ) == "zgrief" )
	{
		level endon( "restart_round_start" );
	}
	else
	{
		level endon( "start_of_round" );
	}

	if(time != 0)
	{
		time -= .1; // need to set it below the number or it shows the next number
	}

	while (1)
	{
		if(time == 0)
		{
			hud setTimerUp(time);
		}
		else
		{
			hud setTimer(time);
		}

		wait 0.5;
	}
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

	zone_hud = newClientHudElem(self);
	zone_hud.alignx = "left";
	zone_hud.aligny = "middle";
	zone_hud.horzalign = "user_left";
	zone_hud.vertalign = "user_bottom";
	zone_hud.x += x;
	zone_hud.y += y;
	zone_hud.fontscale = 1.4;
	zone_hud.alpha = 0;
	zone_hud.color = ( 1, 1, 1 );
	zone_hud.hidewheninmenu = 1;
	zone_hud.foreground = 1;

	zone_hud endon("death");

	zone_hud thread destroy_on_intermission();

	flag_wait( "initial_blackscreen_passed" );

	zone = self get_current_zone();
	prev_zone_name = get_zone_display_name(zone);
	zone_hud settext(prev_zone_name);
	zone_hud.alpha = 1;

	while (1)
	{
		zone = self get_current_zone();
		zone_name = get_zone_display_name(zone);

		if(prev_zone_name != zone_name)
		{
			prev_zone_name = zone_name;

			zone_hud fadeovertime(0.25);
			zone_hud.alpha = 0;
			wait 0.25;

			zone_hud settext(zone_name);

			zone_hud fadeovertime(0.25);
			zone_hud.alpha = 1;
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

	name = zone;

	if (level.script == "zm_transit" || level.script == "zm_transit_dr")
	{
		if (zone == "zone_pri")
		{
			name = "Bus Depot";
		}
		else if (zone == "zone_pri2")
		{
			name = "Bus Depot Hallway";
		}
		else if (zone == "zone_station_ext")
		{
			name = "Outside Bus Depot";
		}
		else if (zone == "zone_trans_2b")
		{
			name = "Fog After Bus Depot";
		}
		else if (zone == "zone_trans_2")
		{
			name = "Tunnel Entrance";
		}
		else if (zone == "zone_amb_tunnel")
		{
			name = "Tunnel";
		}
		else if (zone == "zone_trans_3")
		{
			name = "Tunnel Exit";
		}
		else if (zone == "zone_roadside_west")
		{
			name = "Outside Diner";
		}
		else if (zone == "zone_gas")
		{
			name = "Gas Station";
		}
		else if (zone == "zone_roadside_east")
		{
			name = "Outside Garage";
		}
		else if (zone == "zone_trans_diner")
		{
			name = "Fog Outside Diner";
		}
		else if (zone == "zone_trans_diner2")
		{
			name = "Fog Outside Garage";
		}
		else if (zone == "zone_gar")
		{
			name = "Garage";
		}
		else if (zone == "zone_din")
		{
			name = "Diner";
		}
		else if (zone == "zone_diner_roof")
		{
			name = "Diner Roof";
		}
		else if (zone == "zone_trans_4")
		{
			name = "Fog After Diner";
		}
		else if (zone == "zone_amb_forest")
		{
			name = "Forest";
		}
		else if (zone == "zone_trans_10")
		{
			name = "Outside Church";
		}
		else if (zone == "zone_town_church")
		{
			name = "Outside Church To Town";
		}
		else if (zone == "zone_trans_5")
		{
			name = "Fog Before Farm";
		}
		else if (zone == "zone_far")
		{
			name = "Outside Farm";
		}
		else if (zone == "zone_far_ext")
		{
			name = "Farm";
		}
		else if (zone == "zone_brn")
		{
			name = "Barn";
		}
		else if (zone == "zone_farm_house")
		{
			name = "Farmhouse";
		}
		else if (zone == "zone_trans_6")
		{
			name = "Fog After Farm";
		}
		else if (zone == "zone_amb_cornfield")
		{
			name = "Cornfield";
		}
		else if (zone == "zone_cornfield_prototype")
		{
			name = "Prototype";
		}
		else if (zone == "zone_trans_7")
		{
			name = "Upper Fog Before Power Station";
		}
		else if (zone == "zone_trans_pow_ext1")
		{
			name = "Fog Before Power Station";
		}
		else if (zone == "zone_pow")
		{
			name = "Outside Power Station";
		}
		else if (zone == "zone_prr")
		{
			name = "Power Station";
		}
		else if (zone == "zone_pcr")
		{
			name = "Power Station Control Room";
		}
		else if (zone == "zone_pow_warehouse")
		{
			name = "Warehouse";
		}
		else if (zone == "zone_trans_8")
		{
			name = "Fog After Power Station";
		}
		else if (zone == "zone_amb_power2town")
		{
			name = "Cabin";
		}
		else if (zone == "zone_trans_9")
		{
			name = "Fog Before Town";
		}
		else if (zone == "zone_town_north")
		{
			name = "North Town";
		}
		else if (zone == "zone_tow")
		{
			name = "Center Town";
		}
		else if (zone == "zone_town_east")
		{
			name = "East Town";
		}
		else if (zone == "zone_town_west")
		{
			name = "West Town";
		}
		else if (zone == "zone_town_south")
		{
			name = "South Town";
		}
		else if (zone == "zone_bar")
		{
			name = "Bar";
		}
		else if (zone == "zone_town_barber")
		{
			name = "Bookstore";
		}
		else if (zone == "zone_ban")
		{
			name = "Bank";
		}
		else if (zone == "zone_ban_vault")
		{
			name = "Bank Vault";
		}
		else if (zone == "zone_tbu")
		{
			name = "Below Bank";
		}
		else if (zone == "zone_trans_11")
		{
			name = "Fog After Town";
		}
		else if (zone == "zone_amb_bridge")
		{
			name = "Bridge";
		}
		else if (zone == "zone_trans_1")
		{
			name = "Fog Before Bus Depot";
		}
	}
	else if (level.script == "zm_nuked")
	{
		if (zone == "culdesac_yellow_zone")
		{
			name = "Yellow House Cul-de-sac";
		}
		else if (zone == "culdesac_green_zone")
		{
			name = "Green House Cul-de-sac";
		}
		else if (zone == "truck_zone")
		{
			name = "Truck";
		}
		else if (zone == "openhouse1_f1_zone")
		{
			name = "Green House Downstairs";
		}
		else if (zone == "openhouse1_f2_zone")
		{
			name = "Green House Upstairs";
		}
		else if (zone == "openhouse1_backyard_zone")
		{
			name = "Green House Backyard";
		}
		else if (zone == "openhouse2_f1_zone")
		{
			name = "Yellow House Downstairs";
		}
		else if (zone == "openhouse2_f2_zone")
		{
			name = "Yellow House Upstairs";
		}
		else if (zone == "openhouse2_backyard_zone")
		{
			name = "Yellow House Backyard";
		}
		else if (zone == "ammo_door_zone")
		{
			name = "Yellow House Backyard Door";
		}
	}
	else if (level.script == "zm_highrise")
	{
		if (zone == "zone_green_start")
		{
			name = "Green Highrise Level 3b";
		}
		else if (zone == "zone_green_escape_pod")
		{
			name = "Escape Pod";
		}
		else if (zone == "zone_green_escape_pod_ground")
		{
			name = "Escape Pod Shaft";
		}
		else if (zone == "zone_green_level1")
		{
			name = "Green Highrise Level 3a";
		}
		else if (zone == "zone_green_level2a")
		{
			name = "Green Highrise Level 2a";
		}
		else if (zone == "zone_green_level2b")
		{
			name = "Green Highrise Level 2b";
		}
		else if (zone == "zone_green_level3a")
		{
			name = "Green Highrise Restaurant";
		}
		else if (zone == "zone_green_level3b")
		{
			name = "Green Highrise Level 1a";
		}
		else if (zone == "zone_green_level3c")
		{
			name = "Green Highrise Level 1b";
		}
		else if (zone == "zone_green_level3d")
		{
			name = "Green Highrise Behind Restaurant";
		}
		else if (zone == "zone_orange_level1")
		{
			name = "Upper Orange Highrise Level 2";
		}
		else if (zone == "zone_orange_level2")
		{
			name = "Upper Orange Highrise Level 1";
		}
		else if (zone == "zone_orange_elevator_shaft_top")
		{
			name = "Elevator Shaft Level 3";
		}
		else if (zone == "zone_orange_elevator_shaft_middle_1")
		{
			name = "Elevator Shaft Level 2";
		}
		else if (zone == "zone_orange_elevator_shaft_middle_2")
		{
			name = "Elevator Shaft Level 1";
		}
		else if (zone == "zone_orange_elevator_shaft_bottom")
		{
			name = "Elevator Shaft Bottom";
		}
		else if (zone == "zone_orange_level3a")
		{
			name = "Lower Orange Highrise Level 1a";
		}
		else if (zone == "zone_orange_level3b")
		{
			name = "Lower Orange Highrise Level 1b";
		}
		else if (zone == "zone_blue_level5")
		{
			name = "Lower Blue Highrise Level 1";
		}
		else if (zone == "zone_blue_level4a")
		{
			name = "Lower Blue Highrise Level 2a";
		}
		else if (zone == "zone_blue_level4b")
		{
			name = "Lower Blue Highrise Level 2b";
		}
		else if (zone == "zone_blue_level4c")
		{
			name = "Lower Blue Highrise Level 2c";
		}
		else if (zone == "zone_blue_level2a")
		{
			name = "Upper Blue Highrise Level 1a";
		}
		else if (zone == "zone_blue_level2b")
		{
			name = "Upper Blue Highrise Level 1b";
		}
		else if (zone == "zone_blue_level2c")
		{
			name = "Upper Blue Highrise Level 1c";
		}
		else if (zone == "zone_blue_level2d")
		{
			name = "Upper Blue Highrise Level 1d";
		}
		else if (zone == "zone_blue_level1a")
		{
			name = "Upper Blue Highrise Level 2a";
		}
		else if (zone == "zone_blue_level1b")
		{
			name = "Upper Blue Highrise Level 2b";
		}
		else if (zone == "zone_blue_level1c")
		{
			name = "Upper Blue Highrise Level 2c";
		}
	}
	else if (level.script == "zm_prison")
	{
		if (zone == "zone_start")
		{
			name = "D-Block";
		}
		else if (zone == "zone_library")
		{
			name = "Library";
		}
		else if (zone == "zone_cellblock_west")
		{
			name = "Cell Block 2nd Floor";
		}
		else if (zone == "zone_cellblock_west_gondola")
		{
			name = "Cell Block 3rd Floor";
		}
		else if (zone == "zone_cellblock_west_gondola_dock")
		{
			name = "Cell Block Gondola";
		}
		else if (zone == "zone_cellblock_west_barber")
		{
			name = "Michigan Avenue";
		}
		else if (zone == "zone_cellblock_east")
		{
			name = "Times Square";
		}
		else if (zone == "zone_cafeteria")
		{
			name = "Cafeteria";
		}
		else if (zone == "zone_cafeteria_end")
		{
			name = "Cafeteria End";
		}
		else if (zone == "zone_infirmary")
		{
			name = "Infirmary 1";
		}
		else if (zone == "zone_infirmary_roof")
		{
			name = "Infirmary 2";
		}
		else if (zone == "zone_roof_infirmary")
		{
			name = "Roof 1";
		}
		else if (zone == "zone_roof")
		{
			name = "Roof 2";
		}
		else if (zone == "zone_cellblock_west_warden")
		{
			name = "Sally Port";
		}
		else if (zone == "zone_warden_office")
		{
			name = "Warden's Office";
		}
		else if (zone == "cellblock_shower")
		{
			name = "Showers";
		}
		else if (zone == "zone_citadel_shower")
		{
			name = "Citadel To Showers";
		}
		else if (zone == "zone_citadel")
		{
			name = "Citadel";
		}
		else if (zone == "zone_citadel_warden")
		{
			name = "Citadel To Warden's Office";
		}
		else if (zone == "zone_citadel_stairs")
		{
			name = "Citadel Tunnels";
		}
		else if (zone == "zone_citadel_basement")
		{
			name = "Citadel Basement";
		}
		else if (zone == "zone_citadel_basement_building")
		{
			name = "China Alley";
		}
		else if (zone == "zone_studio")
		{
			name = "Building 64";
		}
		else if (zone == "zone_dock")
		{
			name = "Docks";
		}
		else if (zone == "zone_dock_puzzle")
		{
			name = "Docks Gates";
		}
		else if (zone == "zone_dock_gondola")
		{
			name = "Upper Docks";
		}
		else if (zone == "zone_golden_gate_bridge")
		{
			name = "Golden Gate Bridge";
		}
		else if (zone == "zone_gondola_ride")
		{
			name = "Gondola";
		}
	}
	else if (level.script == "zm_buried")
	{
		if (zone == "zone_start")
		{
			name = "Processing";
		}
		else if (zone == "zone_start_lower")
		{
			name = "Lower Processing";
		}
		else if (zone == "zone_tunnels_center")
		{
			name = "Center Tunnels";
		}
		else if (zone == "zone_tunnels_north")
		{
			name = "Courthouse Tunnels 2";
		}
		else if (zone == "zone_tunnels_north2")
		{
			name = "Courthouse Tunnels 1";
		}
		else if (zone == "zone_tunnels_south")
		{
			name = "Saloon Tunnels 3";
		}
		else if (zone == "zone_tunnels_south2")
		{
			name = "Saloon Tunnels 2";
		}
		else if (zone == "zone_tunnels_south3")
		{
			name = "Saloon Tunnels 1";
		}
		else if (zone == "zone_street_lightwest")
		{
			name = "Outside General Store & Bank";
		}
		else if (zone == "zone_street_lightwest_alley")
		{
			name = "Outside General Store & Bank Alley";
		}
		else if (zone == "zone_morgue_upstairs")
		{
			name = "Morgue";
		}
		else if (zone == "zone_underground_jail")
		{
			name = "Jail Downstairs";
		}
		else if (zone == "zone_underground_jail2")
		{
			name = "Jail Upstairs";
		}
		else if (zone == "zone_general_store")
		{
			name = "General Store";
		}
		else if (zone == "zone_stables")
		{
			name = "Stables";
		}
		else if (zone == "zone_street_darkwest")
		{
			name = "Outside Gunsmith";
		}
		else if (zone == "zone_street_darkwest_nook")
		{
			name = "Outside Gunsmith Nook";
		}
		else if (zone == "zone_gun_store")
		{
			name = "Gunsmith";
		}
		else if (zone == "zone_bank")
		{
			name = "Bank";
		}
		else if (zone == "zone_tunnel_gun2stables")
		{
			name = "Stables To Gunsmith Tunnel 2";
		}
		else if (zone == "zone_tunnel_gun2stables2")
		{
			name = "Stables To Gunsmith Tunnel";
		}
		else if (zone == "zone_street_darkeast")
		{
			name = "Outside Saloon & Toy Store";
		}
		else if (zone == "zone_street_darkeast_nook")
		{
			name = "Outside Saloon & Toy Store Nook";
		}
		else if (zone == "zone_underground_bar")
		{
			name = "Saloon";
		}
		else if (zone == "zone_tunnel_gun2saloon")
		{
			name = "Saloon To Gunsmith Tunnel";
		}
		else if (zone == "zone_toy_store")
		{
			name = "Toy Store Downstairs";
		}
		else if (zone == "zone_toy_store_floor2")
		{
			name = "Toy Store Upstairs";
		}
		else if (zone == "zone_toy_store_tunnel")
		{
			name = "Toy Store Tunnel";
		}
		else if (zone == "zone_candy_store")
		{
			name = "Candy Store Downstairs";
		}
		else if (zone == "zone_candy_store_floor2")
		{
			name = "Candy Store Upstairs";
		}
		else if (zone == "zone_street_lighteast")
		{
			name = "Outside Courthouse & Candy Store";
		}
		else if (zone == "zone_underground_courthouse")
		{
			name = "Courthouse Downstairs";
		}
		else if (zone == "zone_underground_courthouse2")
		{
			name = "Courthouse Upstairs";
		}
		else if (zone == "zone_street_fountain")
		{
			name = "Fountain";
		}
		else if (zone == "zone_church_graveyard")
		{
			name = "Graveyard";
		}
		else if (zone == "zone_church_main")
		{
			name = "Church Downstairs";
		}
		else if (zone == "zone_church_upstairs")
		{
			name = "Church Upstairs";
		}
		else if (zone == "zone_mansion_lawn")
		{
			name = "Mansion Lawn";
		}
		else if (zone == "zone_mansion")
		{
			name = "Mansion";
		}
		else if (zone == "zone_mansion_backyard")
		{
			name = "Mansion Backyard";
		}
		else if (zone == "zone_maze")
		{
			name = "Maze";
		}
		else if (zone == "zone_maze_staircase")
		{
			name = "Maze Staircase";
		}
	}
	else if (level.script == "zm_tomb")
	{
		if (isDefined(self.teleporting) && self.teleporting)
		{
			return "";
		}

		if (zone == "zone_start")
		{
			name = "Lower Laboratory";
		}
		else if (zone == "zone_start_a")
		{
			name = "Upper Laboratory";
		}
		else if (zone == "zone_start_b")
		{
			name = "Generator 1";
		}
		else if (zone == "zone_bunker_1a")
		{
			name = "Generator 3 Bunker 1";
		}
		else if (zone == "zone_fire_stairs")
		{
			name = "Fire Tunnel";
		}
		else if (zone == "zone_bunker_1")
		{
			name = "Generator 3 Bunker 2";
		}
		else if (zone == "zone_bunker_3a")
		{
			name = "Generator 3";
		}
		else if (zone == "zone_bunker_3b")
		{
			name = "Generator 3 Bunker 3";
		}
		else if (zone == "zone_bunker_2a")
		{
			name = "Generator 2 Bunker 1";
		}
		else if (zone == "zone_bunker_2")
		{
			name = "Generator 2 Bunker 2";
		}
		else if (zone == "zone_bunker_4a")
		{
			name = "Generator 2";
		}
		else if (zone == "zone_bunker_4b")
		{
			name = "Generator 2 Bunker 3";
		}
		else if (zone == "zone_bunker_4c")
		{
			name = "Tank Station";
		}
		else if (zone == "zone_bunker_4d")
		{
			name = "Above Tank Station";
		}
		else if (zone == "zone_bunker_tank_c")
		{
			name = "Generator 2 Tank Route 1";
		}
		else if (zone == "zone_bunker_tank_c1")
		{
			name = "Generator 2 Tank Route 2";
		}
		else if (zone == "zone_bunker_4e")
		{
			name = "Generator 2 Tank Route 3";
		}
		else if (zone == "zone_bunker_tank_d")
		{
			name = "Generator 2 Tank Route 4";
		}
		else if (zone == "zone_bunker_tank_d1")
		{
			name = "Generator 2 Tank Route 5";
		}
		else if (zone == "zone_bunker_4f")
		{
			name = "zone_bunker_4f";
		}
		else if (zone == "zone_bunker_5a")
		{
			name = "Workshop Downstairs";
		}
		else if (zone == "zone_bunker_5b")
		{
			name = "Workshop Upstairs";
		}
		else if (zone == "zone_nml_2a")
		{
			name = "No Man's Land Walkway";
		}
		else if (zone == "zone_nml_2")
		{
			name = "No Man's Land Entrance";
		}
		else if (zone == "zone_bunker_tank_e")
		{
			name = "Generator 5 Tank Route 1";
		}
		else if (zone == "zone_bunker_tank_e1")
		{
			name = "Generator 5 Tank Route 2";
		}
		else if (zone == "zone_bunker_tank_e2")
		{
			name = "zone_bunker_tank_e2";
		}
		else if (zone == "zone_bunker_tank_f")
		{
			name = "Generator 5 Tank Route 3";
		}
		else if (zone == "zone_nml_1")
		{
			name = "Generator 5 Tank Route 4";
		}
		else if (zone == "zone_nml_4")
		{
			name = "Generator 5 Tank Route 5";
		}
		else if (zone == "zone_nml_0")
		{
			name = "Generator 5 Left Footstep";
		}
		else if (zone == "zone_nml_5")
		{
			name = "Generator 5 Right Footstep Walkway";
		}
		else if (zone == "zone_nml_farm")
		{
			name = "Generator 5";
		}
		else if (zone == "zone_nml_celllar")
		{
			name = "Generator 5 Cellar";
		}
		else if (zone == "zone_bolt_stairs")
		{
			name = "Lightning Tunnel";
		}
		else if (zone == "zone_nml_3")
		{
			name = "No Man's Land 1st Right Footstep";
		}
		else if (zone == "zone_nml_2b")
		{
			name = "No Man's Land Stairs";
		}
		else if (zone == "zone_nml_6")
		{
			name = "No Man's Land Left Footstep";
		}
		else if (zone == "zone_nml_8")
		{
			name = "No Man's Land 2nd Right Footstep";
		}
		else if (zone == "zone_nml_10a")
		{
			name = "Generator 4 Tank Route 1";
		}
		else if (zone == "zone_nml_10")
		{
			name = "Generator 4 Tank Route 2";
		}
		else if (zone == "zone_nml_7")
		{
			name = "Generator 4 Tank Route 3";
		}
		else if (zone == "zone_bunker_tank_a")
		{
			name = "Generator 4 Tank Route 4";
		}
		else if (zone == "zone_bunker_tank_a1")
		{
			name = "Generator 4 Tank Route 5";
		}
		else if (zone == "zone_bunker_tank_a2")
		{
			name = "zone_bunker_tank_a2";
		}
		else if (zone == "zone_bunker_tank_b")
		{
			name = "Generator 4 Tank Route 6";
		}
		else if (zone == "zone_nml_9")
		{
			name = "Generator 4 Left Footstep";
		}
		else if (zone == "zone_air_stairs")
		{
			name = "Wind Tunnel";
		}
		else if (zone == "zone_nml_11")
		{
			name = "Generator 4";
		}
		else if (zone == "zone_nml_12")
		{
			name = "Generator 4 Right Footstep";
		}
		else if (zone == "zone_nml_16")
		{
			name = "Excavation Site Front Path";
		}
		else if (zone == "zone_nml_17")
		{
			name = "Excavation Site Back Path";
		}
		else if (zone == "zone_nml_18")
		{
			name = "Excavation Site Level 3";
		}
		else if (zone == "zone_nml_19")
		{
			name = "Excavation Site Level 2";
		}
		else if (zone == "ug_bottom_zone")
		{
			name = "Excavation Site Level 1";
		}
		else if (zone == "zone_nml_13")
		{
			name = "Generator 5 To Generator 6 Path";
		}
		else if (zone == "zone_nml_14")
		{
			name = "Generator 4 To Generator 6 Path";
		}
		else if (zone == "zone_nml_15")
		{
			name = "Generator 6 Entrance";
		}
		else if (zone == "zone_village_0")
		{
			name = "Generator 6 Left Footstep";
		}
		else if (zone == "zone_village_5")
		{
			name = "Generator 6 Tank Route 1";
		}
		else if (zone == "zone_village_5a")
		{
			name = "Generator 6 Tank Route 2";
		}
		else if (zone == "zone_village_5b")
		{
			name = "Generator 6 Tank Route 3";
		}
		else if (zone == "zone_village_1")
		{
			name = "Generator 6 Tank Route 4";
		}
		else if (zone == "zone_village_4b")
		{
			name = "Generator 6 Tank Route 5";
		}
		else if (zone == "zone_village_4a")
		{
			name = "Generator 6 Tank Route 6";
		}
		else if (zone == "zone_village_4")
		{
			name = "Generator 6 Tank Route 7";
		}
		else if (zone == "zone_village_2")
		{
			name = "Church";
		}
		else if (zone == "zone_village_3")
		{
			name = "Generator 6 Right Footstep";
		}
		else if (zone == "zone_village_3a")
		{
			name = "Generator 6";
		}
		else if (zone == "zone_ice_stairs")
		{
			name = "Ice Tunnel";
		}
		else if (zone == "zone_bunker_6")
		{
			name = "Above Generator 3 Bunker";
		}
		else if (zone == "zone_nml_20")
		{
			name = "Above No Man's Land";
		}
		else if (zone == "zone_village_6")
		{
			name = "Behind Church";
		}
		else if (zone == "zone_chamber_0")
		{
			name = "The Crazy Place Lightning Chamber";
		}
		else if (zone == "zone_chamber_1")
		{
			name = "The Crazy Place Lightning & Ice";
		}
		else if (zone == "zone_chamber_2")
		{
			name = "The Crazy Place Ice Chamber";
		}
		else if (zone == "zone_chamber_3")
		{
			name = "The Crazy Place Fire & Lightning";
		}
		else if (zone == "zone_chamber_4")
		{
			name = "The Crazy Place Center";
		}
		else if (zone == "zone_chamber_5")
		{
			name = "The Crazy Place Ice & Wind";
		}
		else if (zone == "zone_chamber_6")
		{
			name = "The Crazy Place Fire Chamber";
		}
		else if (zone == "zone_chamber_7")
		{
			name = "The Crazy Place Wind & Fire";
		}
		else if (zone == "zone_chamber_8")
		{
			name = "The Crazy Place Wind Chamber";
		}
		else if (zone == "zone_robot_head")
		{
			name = "Robot's Head";
		}
	}

	return name;
}

bleedout_bar_hud()
{
	self endon("disconnect");

	flag_wait( "initial_blackscreen_passed" );

	if(flag("solo_game"))
	{
		return;
	}

	bleedout_bar = self createbar((1, 0, 0), level.secondaryprogressbarwidth * 2, level.secondaryprogressbarheight);
	bleedout_bar setpoint("CENTER", undefined, level.secondaryprogressbarx, -1 * level.secondaryprogressbary);
	bleedout_bar.hidewheninmenu = 1;
	bleedout_bar.bar.hidewheninmenu = 1;
	bleedout_bar.barframe.hidewheninmenu = 1;
	bleedout_bar hideelem();

	while (1)
	{
		self waittill("entering_last_stand");

		// don't show for last player downed
		if(!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			continue;
		}

		self thread bleedout_bar_hud_updatebar(bleedout_bar);

		bleedout_bar showelem();

		self waittill_any("player_revived", "bled_out", "player_suicide");

		bleedout_bar hideelem();
	}
}

// scaleovertime doesn't work past 30 seconds so here is a workaround
bleedout_bar_hud_updatebar(bleedout_bar)
{
	self endon("player_revived");
	self endon("bled_out");
	self endon("player_suicide");

	bleedout_time = getDvarInt("player_lastStandBleedoutTime");
	interval_time = 30;
	interval_frac = interval_time / bleedout_time;
	num_intervals = int(bleedout_time / interval_time) + 1;

	bleedout_bar updatebar(1);

	for(i = 0; i < num_intervals; i++)
	{
		time = bleedout_time;
		if(time > interval_time)
		{
			time = interval_time;
		}

		frac = 0.99 - ((i + 1) * interval_frac);

		barwidth = int((bleedout_bar.width * frac) + 0.5);
		if(barwidth < 1)
		{
			barwidth = 1;
		}

		bleedout_bar.bar scaleovertime(time, barwidth, bleedout_bar.height);

		wait time;

		bleedout_time -= time;
	}
}

last_stand_pistol_swap()
{
	if ( self has_powerup_weapon() )
	{
		self.lastactiveweapon = "none";
	}
	if ( !self hasweapon( self.laststandpistol ) )
	{
		self giveweapon( self.laststandpistol );
	}

	ammoclip = weaponclipsize( self.laststandpistol );
	doubleclip = ammoclip * 2;
	if(weapondualwieldweaponname(self.laststandpistol) != "none")
	{
		ammoclip += weaponclipsize(weapondualwieldweaponname(self.laststandpistol));
		doubleclip = ammoclip;
	}

	if ( is_true( self._special_solo_pistol_swap ) ||  self.laststandpistol == level.default_solo_laststandpistol && !self.hadpistol )
	{
		self._special_solo_pistol_swap = 0;
		self.hadpistol = 0;
		self setweaponammostock( self.laststandpistol, doubleclip );
	}
	else if ( flag( "solo_game" ) && self.laststandpistol == level.default_solo_laststandpistol )
	{
		self setweaponammostock(self.laststandpistol, doubleclip);
	}
	else if ( self.laststandpistol == level.default_laststandpistol )
	{
		self setweaponammostock( self.laststandpistol, doubleclip );
	}
	else if ( self.laststandpistol == "ray_gun_zm" || self.laststandpistol == "ray_gun_upgraded_zm" || self.laststandpistol == "raygun_mark2_zm" || self.laststandpistol == "raygun_mark2_upgraded_zm" || self.laststandpistol == "m1911_upgraded_zm" )
	{
		amt = ammoclip;
		if(amt > self.stored_weapon_info[self.laststandpistol].total_amt)
		{
			amt = self.stored_weapon_info[self.laststandpistol].total_amt;
		}

		amt -= (self.stored_weapon_info[self.laststandpistol].clip_amt + self.stored_weapon_info[self.laststandpistol].left_clip_amt);

		self setWeaponAmmoStock(self.laststandpistol, amt);
		self.stored_weapon_info[self.laststandpistol].given_amt = amt;
	}
	else
	{
		amt = ammoclip + doubleclip;
		if(amt > self.stored_weapon_info[self.laststandpistol].total_amt)
		{
			amt = self.stored_weapon_info[self.laststandpistol].total_amt;
		}

		amt -= (self.stored_weapon_info[self.laststandpistol].clip_amt + self.stored_weapon_info[self.laststandpistol].left_clip_amt);

		self setweaponammostock( self.laststandpistol, amt );
		self.stored_weapon_info[ self.laststandpistol ].given_amt = amt;
	}

	self switchtoweapon( self.laststandpistol );
}

last_stand_restore_pistol_ammo()
{
	self.weapon_taken_by_losing_specialty_additionalprimaryweapon = undefined;
	if ( !isDefined( self.stored_weapon_info ) )
	{
		return;
	}
	weapon_inventory = self getweaponslist( 1 );
	weapon_to_restore = getarraykeys( self.stored_weapon_info );
	i = 0;
	while ( i < weapon_inventory.size )
	{
		weapon = weapon_inventory[ i ];
		if(weapon != self.laststandpistol)
		{
			i++;
			continue;
		}
		for ( j = 0; j < weapon_to_restore.size; j++ )
		{
			check_weapon = weapon_to_restore[ j ];
			if ( weapon == check_weapon )
			{
				dual_wield_name = weapondualwieldweaponname( weapon_to_restore[ j ] );
				if ( weapon != level.default_laststandpistol )
				{
					last_clip = self getweaponammoclip( weapon );
					last_left_clip = 0;
					if( "none" != dual_wield_name )
					{
						last_left_clip = self getweaponammoclip( dual_wield_name );
					}
					last_stock = self getweaponammostock( weapon );
					last_total = last_clip + last_left_clip + last_stock;
					used_amt = self.stored_weapon_info[ weapon ].given_amt - last_total;
					if ( used_amt >= self.stored_weapon_info[ weapon ].stock_amt )
					{
						used_amt = used_amt - self.stored_weapon_info[weapon].stock_amt;
						self.stored_weapon_info[ weapon ].stock_amt = 0;
						self.stored_weapon_info[ weapon ].clip_amt = self.stored_weapon_info[ weapon ].clip_amt - used_amt;
						if ( self.stored_weapon_info[ weapon ].clip_amt < 0 )
						{
							self.stored_weapon_info[ weapon ].clip_amt = 0;
						}
					}
					else
					{
						new_stock_amt = self.stored_weapon_info[ weapon ].stock_amt - used_amt;
						if ( new_stock_amt < self.stored_weapon_info[ weapon ].stock_amt )
						{
							self.stored_weapon_info[ weapon ].stock_amt = new_stock_amt;
						}
					}
				}
				self setweaponammostock( weapon_to_restore[ j ], self.stored_weapon_info[weapon_to_restore[ j ] ].stock_amt );
				break;
			}
		}
		i++;
	}
}

setscoreboardcolumns_gametype()
{
	if(getDvar("g_gametype") == "zgrief")
	{
		setscoreboardcolumns("score", "kills", "killsconfirmed", "downs", "revives");
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
	self endon( "disconnect" );

	if(level.scr_zm_ui_gametype == "zgrief" && is_true(level.scr_zm_ui_gametype_pro))
	{
		return;
	}

	while(1)
	{
		health_ratio = self.health / self.maxhealth;

		if(health_ratio <= 0.2)
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

	while(1)
	{
		self waittill("player_revived", reviver);

		self thread player_revive_protection();
	}
}

player_revive_protection()
{
	self endon("disconnect");

	self.revive_protection = 1;

	for(i = 0; i < 20; i++)
	{
		self.ignoreme = 1;
		wait 0.05;
	}

	self.ignoreme = 0;
	self.revive_protection = 0;
}

fall_velocity_check()
{
	self endon("disconnect");

	while (1)
	{
		was_on_ground = 1;
		self.fall_velocity = 0;

		while (!self isOnGround())
		{
			was_on_ground = 0;
			vel = self getVelocity();
			self.fall_velocity = vel[2];
			wait 0.05;
		}

		if (!was_on_ground)
		{
			// fall damage does not register when player's max health is less than 100 and has PHD Flopper
			if(self.maxhealth < 100 && self hasPerk("specialty_flakjacket"))
			{
				if(is_true(self.divetoprone) && self.fall_velocity <= -300)
				{
					if(isDefined(level.zombiemode_divetonuke_perk_func))
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

melee_weapon_switch_watcher()
{
	self endon("disconnect");

	self thread melee_weapon_disable_weapon_trading();

	prev_wep = undefined;
	while(1)
	{
		melee_wep = self get_player_melee_weapon();
		curr_wep = self getCurrentWeapon();

		if(curr_wep != "none" && !is_offhand_weapon(curr_wep))
		{
			prev_wep = curr_wep;
		}

		if(self actionSlotTwoButtonPressed() && !self hasWeapon("time_bomb_zm") && !self hasWeapon("time_bomb_detonator_zm") && !self hasWeapon("equip_dieseldrone_zm"))
		{
			if(curr_wep != melee_wep)
			{
				self switchToWeapon(melee_wep);
			}
			else
			{
				self maps\mp\zombies\_zm_weapons::switch_back_primary_weapon(prev_wep);
			}
		}

		wait 0.05;
	}
}

melee_weapon_disable_weapon_trading()
{
	self endon("disconnect");

	while(1)
	{
		melee_wep = self get_player_melee_weapon();
		curr_wep = self getCurrentWeapon();

		if(curr_wep == melee_wep && self getWeaponsListPrimaries().size >= 1)
		{
			self.is_drinking = 1;

			while(curr_wep == melee_wep && self getWeaponsListPrimaries().size >= 1)
			{
				melee_wep = self get_player_melee_weapon();
				curr_wep = self getCurrentWeapon();

				wait 0.05;
			}

			self.is_drinking = 0;
		}

		wait 0.05;
	}
}

player_damage_override( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	if(smeansofdeath == "MOD_FALLING" && !self hasPerk("specialty_flakjacket"))
	{
		// remove fall damage being based off max health
		ratio = self.maxhealth / 100;
		idamage = int(idamage / ratio);

		// increase fall damage beyond 110
		max_damage = 110;
		if(idamage >= max_damage)
		{
			velocity = abs(self.fall_velocity);
			min_velocity = getDvarInt("bg_fallDamageMinHeight") * 3.25;
			max_velocity = getDvarInt("bg_fallDamageMaxHeight") * 2.5;
			if(self.divetoprone)
			{
				min_velocity = getDvarInt("dtp_fall_damage_min_height") * 4.5;
				max_velocity = getDvarInt("dtp_fall_damage_max_height") * 2.75;
			}

			idamage = int(((velocity - min_velocity) / (max_velocity - min_velocity)) * max_damage);

			if(idamage < max_damage)
			{
				idamage = max_damage;
			}
		}
	}

	// fix turrets damaging players
	if(sweapon == "zombie_bullet_crouch_zm" && smeansofdeath == "MOD_RIFLE_BULLET")
	{
		idamage = 0;
	}

	return idamage;
}

disable_bank_teller()
{
	level notify( "stop_bank_teller" );
	bank_teller_dmg_trig = getent( "bank_teller_tazer_trig", "targetname" );
	if(IsDefined(bank_teller_dmg_trig))
	{
		bank_teller_transfer_trig = getent( bank_teller_dmg_trig.target, "targetname" );
		bank_teller_dmg_trig delete();
		bank_teller_transfer_trig delete();
	}
}

disable_carpenter()
{
	arrayremovevalue(level.zombie_powerup_array, "carpenter");
}

wallbuy_location_changes()
{
	if(!is_classic())
	{
		if(level.scr_zm_map_start_location == "farm")
		{
			if(level.scr_zm_ui_gametype == "zstandard")
			{
				remove_wallbuy("tazer_knuckles_zm");
			}

			add_wallbuy("claymore_zm");
		}

		if(level.scr_zm_map_start_location == "street")
		{
			if(level.scr_zm_ui_gametype == "zgrief")
			{
				add_wallbuy("beretta93r_zm");
				add_wallbuy("m16_zm");
				add_wallbuy("claymore_zm");
				add_wallbuy("bowie_knife_zm");
			}
		}

		if(level.scr_zm_ui_gametype == "zgrief" && is_true(level.scr_zm_ui_gametype_pro))
		{
			remove_wallbuy("claymore_zm");
		}
	}
}

remove_wallbuy( name )
{
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(IsDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade) && level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade == name)
		{
			maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( level._unitriggers.trigger_stubs[i] );
		}
	}
}

add_wallbuy( name )
{
	struct = undefined;
	spawnable_weapon_spawns = getstructarray( "weapon_upgrade", "targetname" );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "bowie_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "sickle_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "tazer_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "buildable_wallbuy", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "claymore_purchase", "targetname" ), 1, 0 );
	for(i = 0; i < spawnable_weapon_spawns.size; i++)
	{
		if(IsDefined(spawnable_weapon_spawns[i].zombie_weapon_upgrade) && spawnable_weapon_spawns[i].zombie_weapon_upgrade == name)
		{
			struct = spawnable_weapon_spawns[i];
			break;
		}
	}

	if(!IsDefined(struct))
	{
		return;
	}

	scripts\zm\replaced\utility::wallbuy( name, struct.target, struct.targetname, struct.origin, struct.angles );
}

wallbuy_cost_changes()
{
	flag_wait( "initial_blackscreen_passed" );

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

wallbuy_increase_trigger_radius()
{
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(IsDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade))
		{
			level._unitriggers.trigger_stubs[i].script_length = 64;
		}
	}
}

wallbuy_decrease_upgraded_ammo_cost()
{
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(isDefined(level._unitriggers.trigger_stubs[i].trigger_func) && level._unitriggers.trigger_stubs[i].trigger_func == maps\mp\zombies\_zm_weapons::weapon_spawn_think)
		{
			level._unitriggers.trigger_stubs[i].trigger_func = ::weapon_spawn_think;
		}
	}
}

wallbuy_lethal_grenade_changes()
{
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(IsDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade) && is_lethal_grenade(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade))
		{
			level._unitriggers.trigger_stubs[i].prompt_and_visibility_func = scripts\zm\replaced\_zm_weapons::lethal_grenade_update_prompt;
		}
	}
}

wallbuy_claymore_changes()
{
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(isDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade) && level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade == "claymore_zm")
		{
			level._unitriggers.trigger_stubs[i].prompt_and_visibility_func = scripts\zm\replaced\_zm_weap_claymore::claymore_unitrigger_update_prompt;
			level._unitriggers.trigger_stubs[i].trigger_func = scripts\zm\replaced\_zm_weap_claymore::buy_claymores;
		}
	}
}

weapon_spawn_think()
{
	cost = maps\mp\zombies\_zm_weapons::get_weapon_cost( self.zombie_weapon_upgrade );
	ammo_cost = maps\mp\zombies\_zm_weapons::get_ammo_cost( self.zombie_weapon_upgrade );
	shared_ammo_weapon = undefined;
	second_endon = undefined;

	is_grenade = 0;
	if(weapontype( self.zombie_weapon_upgrade ) == "grenade")
	{
		is_grenade = 1;
	}

	if ( isDefined( self.stub ) )
	{
		second_endon = "kill_trigger";
		self.first_time_triggered = self.stub.first_time_triggered;
	}

	if ( isDefined( self.stub ) && is_true( self.stub.trigger_per_player ) )
	{
		self thread maps\mp\zombies\_zm_magicbox::decide_hide_show_hint( "stop_hint_logic", second_endon, self.parent_player );
	}
	else
	{
		self thread maps\mp\zombies\_zm_magicbox::decide_hide_show_hint( "stop_hint_logic", second_endon );
	}

	if ( is_grenade )
	{
		self.first_time_triggered = 0;
		hint = maps\mp\zombies\_zm_weapons::get_weapon_hint( self.zombie_weapon_upgrade );
		self sethintstring( hint, cost );
	}
	else if ( !isDefined( self.first_time_triggered ) )
	{
		self.first_time_triggered = 0;
		if ( isDefined( self.stub ) )
		{
			self.stub.first_time_triggered = 0;
		}
	}
	else if ( self.first_time_triggered )
	{
		if ( is_true( level.use_legacy_weapon_prompt_format ) )
		{
			self maps\mp\zombies\_zm_weapons::weapon_set_first_time_hint( cost, maps\mp\zombies\_zm_weapons::get_ammo_cost( self.zombie_weapon_upgrade ) );
		}
	}

	for ( ;; )
	{
		self waittill( "trigger", player );

		if ( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if ( !player maps\mp\zombies\_zm_magicbox::can_buy_weapon() )
		{
			wait 0.1;
			continue;
		}

		if ( isDefined( self.stub ) && is_true( self.stub.require_look_from ) )
		{
			toplayer = player get_eye() - self.origin;
			forward = -1 * anglesToRight( self.angles );
			dot = vectordot( toplayer, forward );
			if ( dot < 0 )
			{
				continue;
			}
		}

		if ( player has_powerup_weapon() )
		{
			wait 0.1;
			continue;
		}

		player_has_weapon = player maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( self.zombie_weapon_upgrade );
		if ( !player_has_weapon && is_true( level.weapons_using_ammo_sharing ) )
		{
			shared_ammo_weapon = player maps\mp\zombies\_zm_weapons::get_shared_ammo_weapon( self.zombie_weapon_upgrade );
			if ( isDefined( shared_ammo_weapon ) )
			{
				player_has_weapon = 1;
			}
		}

		if ( is_true( level.pers_upgrade_nube ) )
		{
			player_has_weapon = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_should_we_give_raygun( player_has_weapon, player, self.zombie_weapon_upgrade );
		}

		cost = maps\mp\zombies\_zm_weapons::get_weapon_cost( self.zombie_weapon_upgrade );
		if ( player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active() )
		{
			cost = int( cost / 2 );
		}

		if ( !player_has_weapon )
		{
			if ( player.score >= cost )
			{
				if ( self.first_time_triggered == 0 )
				{
					self maps\mp\zombies\_zm_weapons::show_all_weapon_buys( player, cost, ammo_cost, is_grenade );
				}

				player maps\mp\zombies\_zm_score::minus_to_player_score( cost, 1 );
				bbprint( "zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", player.name, player.score, level.round_number, cost, self.zombie_weapon_upgrade, self.origin, "weapon" );
				level notify( "weapon_bought", player, self.zombie_weapon_upgrade );

				if ( self.zombie_weapon_upgrade == "riotshield_zm" )
				{
					player maps\mp\zombies\_zm_equipment::equipment_give( "riotshield_zm" );
					if ( isDefined( player.player_shield_reset_health ) )
					{
						player [[ player.player_shield_reset_health ]]();
					}
				}
				else if ( self.zombie_weapon_upgrade == "jetgun_zm" )
				{
					player maps\mp\zombies\_zm_equipment::equipment_give( "jetgun_zm" );
				}
				else if ( is_lethal_grenade( self.zombie_weapon_upgrade ) )
				{
					player takeweapon( player get_player_lethal_grenade() );
					player set_player_lethal_grenade( self.zombie_weapon_upgrade );
				}

				str_weapon = self.zombie_weapon_upgrade;

				if ( is_true( level.pers_upgrade_nube ) )
				{
					str_weapon = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_weapon_upgrade_check( player, str_weapon );
				}

				player maps\mp\zombies\_zm_weapons::weapon_give( str_weapon );
				player maps\mp\zombies\_zm_stats::increment_client_stat( "wallbuy_weapons_purchased" );
				player maps\mp\zombies\_zm_stats::increment_player_stat( "wallbuy_weapons_purchased" );
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money_weapon" );
			}
		}
		else
		{
			str_weapon = self.zombie_weapon_upgrade;

			if ( isDefined( shared_ammo_weapon ) )
			{
				str_weapon = shared_ammo_weapon;
			}

			if ( is_true( level.pers_upgrade_nube ) )
			{
				str_weapon = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_weapon_ammo_check( player, str_weapon );
			}

			if ( is_true( self.hacked ) )
			{
				if ( !player maps\mp\zombies\_zm_weapons::has_upgrade( str_weapon ) )
				{
					ammo_cost = maps\mp\zombies\_zm_weapons::get_upgraded_ammo_cost( str_weapon );
				}
				else
				{
					ammo_cost = maps\mp\zombies\_zm_weapons::get_ammo_cost( str_weapon );
				}
			}
			else if ( player maps\mp\zombies\_zm_weapons::has_upgrade( str_weapon ) )
			{
				ammo_cost = maps\mp\zombies\_zm_weapons::get_upgraded_ammo_cost( str_weapon );
			}
			else
			{
				ammo_cost = maps\mp\zombies\_zm_weapons::get_ammo_cost( str_weapon );
			}

			if ( is_true( player.pers_upgrades_awarded[ "nube" ] ) )
			{
				ammo_cost = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_override_ammo_cost( player, self.zombie_weapon_upgrade, ammo_cost );
			}

			if ( player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active() )
			{
				ammo_cost = int( ammo_cost / 2 );
			}

			if ( str_weapon == "riotshield_zm" )
			{
				play_sound_on_ent( "no_purchase" );
			}
			else if ( player.score >= ammo_cost )
			{
				if ( self.first_time_triggered == 0 )
				{
					self maps\mp\zombies\_zm_weapons::show_all_weapon_buys( player, cost, ammo_cost, is_grenade );
				}

				if ( player maps\mp\zombies\_zm_weapons::has_upgrade( str_weapon ) )
				{
					player maps\mp\zombies\_zm_stats::increment_client_stat( "upgraded_ammo_purchased" );
					player maps\mp\zombies\_zm_stats::increment_player_stat( "upgraded_ammo_purchased" );
				}
				else
				{
					player maps\mp\zombies\_zm_stats::increment_client_stat( "ammo_purchased" );
					player maps\mp\zombies\_zm_stats::increment_player_stat( "ammo_purchased" );
				}

				if ( str_weapon == "riotshield_zm" )
				{
					if ( isDefined( player.player_shield_reset_health ) )
					{
						ammo_given = player [[ player.player_shield_reset_health ]]();
					}
					else
					{
						ammo_given = 0;
					}
				}
				else if ( player maps\mp\zombies\_zm_weapons::has_upgrade( str_weapon ) )
				{
					ammo_given = player maps\mp\zombies\_zm_weapons::ammo_give( level.zombie_weapons[ str_weapon ].upgrade_name );
				}
				else
				{
					ammo_given = player maps\mp\zombies\_zm_weapons::ammo_give( str_weapon );
				}

				if ( ammo_given )
				{
					player maps\mp\zombies\_zm_score::minus_to_player_score( ammo_cost, 1 );
					bbprint( "zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", player.name, player.score, level.round_number, ammo_cost, str_weapon, self.origin, "ammo" );
				}
			}
			else
			{
				play_sound_on_ent( "no_purchase" );

				if ( isDefined( level.custom_generic_deny_vo_func ) )
				{
					player [[ level.custom_generic_deny_vo_func ]]();
				}
				else
				{
					player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money_weapon" );
				}
			}
		}

		if ( isDefined( self.stub ) && isDefined( self.stub.prompt_and_visibility_func ) )
		{
			self [[ self.stub.prompt_and_visibility_func ]]( player );
		}
	}
}

wallbuy_dynamic_update()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	while (!isDefined(level.built_wallbuys))
	{
		wait 0.5;
	}

	prev_built_wallbuys = 0;

	while (1)
	{
		if (level.built_wallbuys > prev_built_wallbuys)
		{
			prev_built_wallbuys = level.built_wallbuys;
			wallbuy_increase_trigger_radius();
			wallbuy_decrease_upgraded_ammo_cost();
		}

		if (level.built_wallbuys == -100)
		{
			wallbuy_increase_trigger_radius();
			wallbuy_decrease_upgraded_ammo_cost();
			return;
		}

		wait 0.5;
	}
}

wallbuy_dynamic_zgrief_update()
{
	if(!(level.scr_zm_ui_gametype == "zgrief" && level.scr_zm_map_start_location == "street"))
	{
		return;
	}

	level waittill("dynamicwallbuysbuilt");

	wallbuy_increase_trigger_radius();
	wallbuy_decrease_upgraded_ammo_cost();
}

weapon_inspect_watcher()
{
	level endon( "end_game" );
	self endon( "disconnect" );

	while(1)
	{
		wait 0.05;

		if(self isSwitchingWeapons())
		{
			continue;
		}

		curr_wep = self getCurrentWeapon();

		is_primary = 0;
		foreach(wep in self getWeaponsListPrimaries())
		{
			if(wep == curr_wep)
			{
				is_primary = 1;
				break;
			}
		}

		if(!is_primary)
		{
			continue;
		}

		if(self actionSlotThreeButtonPressed() && self getWeaponAmmoClip(curr_wep) != 0)
		{
			self initialWeaponRaise(curr_wep);
		}
	}
}

buildbuildables()
{
	// need a wait or else some buildables dont build
	wait 1;

	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "transit")
		{
			buildbuildable( "turbine" );
			buildbuildable( "electric_trap" );
			buildbuildable( "turret" );
			buildbuildable( "riotshield_zm" );
			buildbuildable( "jetgun_zm" );
			buildbuildable( "powerswitch", 1 );
			buildbuildable( "pap", 1 );
			buildbuildable( "sq_common", 1 );

			// power switch is not showing up from forced build
			show_powerswitch();
		}
		else if(level.scr_zm_map_start_location == "rooftop")
		{
			buildbuildable( "slipgun_zm" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "sq_common", 1 );
		}
		else if(level.scr_zm_map_start_location == "processing")
		{
			flag_wait( "initial_blackscreen_passed" ); // wait for buildables to randomize
			wait 1;

			level.buildables_available = array("subwoofer_zm", "springpad_zm", "headchopper_zm");

			removebuildable( "keys_zm" );
			buildbuildable( "turbine" );
			buildbuildable( "subwoofer_zm" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "headchopper_zm" );
			buildbuildable( "sq_common", 1 );
		}
	}
	else
	{
		if(level.scr_zm_map_start_location == "street")
		{
			flag_wait( "initial_blackscreen_passed" ); // wait for buildables to be built
			wait 1;

			updatebuildables();
			removebuildable( "turbine", 1 );
		}
	}
}

buildbuildable( buildable, craft )
{
	if (!isDefined(craft))
	{
		craft = 0;
	}

	player = get_players()[ 0 ];
	foreach (stub in level.buildable_stubs)
	{
		if ( !isDefined( buildable ) || stub.equipname == buildable )
		{
			if ( isDefined( buildable ) || stub.persistent != 3 )
			{
				stub.cost = stub get_equipment_cost();
				stub.trigger_func = ::buildable_place_think;
				stub.prompt_and_visibility_func = ::buildabletrigger_update_prompt;

				if (craft)
				{
					stub maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
					stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
					stub.model notsolid();
					stub.model show();
				}
				else
				{
					level.zombie_buildables[stub.equipname].hint = "Hold ^3[{+activate}]^7 to craft " + stub get_equipment_display_name();
				}

				i = 0;
				foreach (piece in stub.buildablezone.pieces)
				{
					piece maps\mp\zombies\_zm_buildables::piece_unspawn();
					if (!craft && i > 0)
					{
						stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_set_piece_built(piece);
					}
					i++;
				}

				return;
			}
		}
	}
}

get_equipment_display_name()
{
	if (self.equipname == "turbine")
	{
		return "Turbine";
	}
	else if (self.equipname == "turret")
	{
		return "Turret";
	}
	else if (self.equipname == "electric_trap")
	{
		return "Electric Trap";
	}
	else if (self.equipname == "riotshield_zm" || self.equipname == "alcatraz_shield_zm" || self.equipname ==  "tomb_shield_zm")
	{
		return "Zombie Shield";
	}
	else if (self.equipname == "jetgun_zm")
	{
		return "Jet Gun";
	}
	else if (self.equipname == "slipgun_zm")
	{
		return "Sliquifier";
	}
	else if (self.equipname == "subwoofer_zm")
	{
		return "Subsurface Resonator";
	}
	else if (self.equipname == "springpad_zm")
	{
		return "Trample Steam";
	}
	else if (self.equipname == "headchopper_zm")
	{
		return "Head Chopper";
	}
}

get_equipment_cost()
{
	if (self.equipname == "turbine" && level.script == "zm_transit")
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

buildable_place_think()
{
	self endon( "kill_trigger" );
	player_built = undefined;
	while ( isDefined( self.stub.built ) && !self.stub.built )
	{
		self waittill( "trigger", player );

		if (isDefined(level._zm_buildables_pooled_swap_buildable_fields))
		{
			slot = self.stub.buildablestruct.buildable_slot;
			bind_to = self.stub.buildable_pool pooledbuildable_stub_for_piece( player player_get_buildable_piece( slot ) );

			if (bind_to != self.stub)
			{
				[[level._zm_buildables_pooled_swap_buildable_fields]]( self.stub, bind_to );
			}
		}

		if ( player != self.parent_player )
		{
			continue;
		}
		if ( isDefined( player.screecher_weapon ) )
		{
			continue;
		}
		if ( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
		}
		status = player maps\mp\zombies\_zm_buildables::player_can_build( self.stub.buildablezone );
		if ( !status )
		{
			self.stub.hint_string = "";
			self sethintstring( self.stub.hint_string );
			if ( isDefined( self.stub.oncantuse ) )
			{
				self.stub [[ self.stub.oncantuse ]]( player );
			}
			continue;
		}
		else
		{
			if ( isDefined( self.stub.onbeginuse ) )
			{
				self.stub [[ self.stub.onbeginuse ]]( player );
			}
			result = self maps\mp\zombies\_zm_buildables::buildable_use_hold_think( player );
			team = player.pers[ "team" ];
			if ( isDefined( self.stub.onenduse ) )
			{
				self.stub [[ self.stub.onenduse ]]( team, player, result );
			}
			if ( !result )
			{
				continue;
			}
			if ( isDefined( self.stub.onuse ) )
			{
				self.stub [[ self.stub.onuse ]]( player );
			}
			prompt = player maps\mp\zombies\_zm_buildables::player_build( self.stub.buildablezone );
			player_built = player;
			self.stub.hint_string = prompt;
			self sethintstring( self.stub.hint_string );
		}
	}
	if ( isDefined( player_built ) )
	{
	}
	if ( self.stub.persistent == 0 )
	{
		self.stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.stub );
		return;
	}
	if ( self.stub.persistent == 3 )
	{
		maps\mp\zombies\_zm_buildables::stub_unbuild_buildable( self.stub, 1 );
		return;
	}
	if ( self.stub.persistent == 2 )
	{
		if ( isDefined( player_built ) )
		{
			self buildabletrigger_update_prompt( player_built );
		}
		if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.stub.weaponname, undefined ) )
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			self sethintstring( self.stub.hint_string );
			return;
		}
		if ( isDefined( self.stub.bought ) && self.stub.bought )
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			self sethintstring( self.stub.hint_string );
			return;
		}
		if ( isDefined( self.stub.model ) )
		{
			self.stub.model notsolid();
			self.stub.model show();
		}
		while ( self.stub.persistent == 2 )
		{
			self waittill( "trigger", player );
			if ( isDefined( player.screecher_weapon ) )
			{
				continue;
			}
			if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.stub.weaponname, undefined ) )
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				self sethintstring( self.stub.hint_string );
				return;
			}
			if ( isDefined( self.stub.built ) && !self.stub.built )
			{
				self.stub.hint_string = "";
				self sethintstring( self.stub.hint_string );
				return;
			}
			if ( player != self.parent_player )
			{
				continue;
			}
			if ( !is_player_valid( player ) )
			{
				player thread ignore_triggers( 0.5 );
			}

			if (player.score < self.stub.cost)
			{
				self play_sound_on_ent( "no_purchase" );
				continue;
			}

			player maps\mp\zombies\_zm_score::minus_to_player_score( self.stub.cost );
			self play_sound_on_ent( "purchase" );

			self.stub.bought = 1;
			if ( isDefined( self.stub.model ) )
			{
				self.stub.model thread maps\mp\zombies\_zm_buildables::model_fly_away();
			}
			player maps\mp\zombies\_zm_weapons::weapon_give( self.stub.weaponname );
			if ( isDefined( level.zombie_include_buildables[ self.stub.equipname ].onbuyweapon ) )
			{
				self [[ level.zombie_include_buildables[ self.stub.equipname ].onbuyweapon ]]( player );
			}
			if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.stub.weaponname, undefined ) )
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			}
			else
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			}
			self sethintstring( self.stub.hint_string );
			player maps\mp\zombies\_zm_buildables::track_buildables_pickedup( self.stub.weaponname );
		}
	}
	else while ( !isDefined( player_built ) || self buildabletrigger_update_prompt( player_built ) )
	{
		if ( isDefined( self.stub.model ) )
		{
			self.stub.model notsolid();
			self.stub.model show();
		}
		while ( self.stub.persistent == 1 )
		{
			self waittill( "trigger", player );
			if ( isDefined( player.screecher_weapon ) )
			{
				continue;
			}
			if ( isDefined( self.stub.built ) && !self.stub.built )
			{
				self.stub.hint_string = "";
				self sethintstring( self.stub.hint_string );
				return;
			}
			if ( player != self.parent_player )
			{
				continue;
			}
			if ( !is_player_valid( player ) )
			{
				player thread ignore_triggers( 0.5 );
			}
			if ( player has_player_equipment( self.stub.weaponname ) )
			{
				continue;
			}
			if (player.score < self.stub.cost)
			{
				self play_sound_on_ent( "no_purchase" );
				continue;
			}
			if ( !maps\mp\zombies\_zm_equipment::is_limited_equipment( self.stub.weaponname ) || !maps\mp\zombies\_zm_equipment::limited_equipment_in_use( self.stub.weaponname ) )
			{
				player maps\mp\zombies\_zm_score::minus_to_player_score( self.stub.cost );
				self play_sound_on_ent( "purchase" );

				player maps\mp\zombies\_zm_equipment::equipment_buy( self.stub.weaponname );
				player giveweapon( self.stub.weaponname );
				player setweaponammoclip( self.stub.weaponname, 1 );
				if ( isDefined( level.zombie_include_buildables[ self.stub.equipname ].onbuyweapon ) )
				{
					self [[ level.zombie_include_buildables[ self.stub.equipname ].onbuyweapon ]]( player );
				}
				if ( self.stub.weaponname != "keys_zm" )
				{
					player setactionslot( 1, "weapon", self.stub.weaponname );
				}
				if ( isDefined( level.zombie_buildables[ self.stub.equipname ].bought ) )
				{
					self.stub.hint_string = level.zombie_buildables[ self.stub.equipname ].bought;
				}
				else
				{
					self.stub.hint_string = "";
				}
				self sethintstring( self.stub.hint_string );
				player maps\mp\zombies\_zm_buildables::track_buildables_pickedup( self.stub.weaponname );
				continue;
			}
			else
			{
				self.stub.hint_string = "";
				self sethintstring( self.stub.hint_string );
			}
		}
	}
}

buildabletrigger_update_prompt( player )
{
	can_use = 0;
	if (isDefined(level.buildablepools))
	{
		can_use = self.stub pooledbuildablestub_update_prompt( player, self );
	}
	else
	{
		can_use = self.stub buildablestub_update_prompt( player, self );
	}

	if (can_use && is_true(self.stub.built))
	{
		self sethintstring( self.stub.hint_string, " [Cost: " + self.stub.cost + "]" );
	}
	else
	{
		self sethintstring( self.stub.hint_string );
	}

	if ( isDefined( self.stub.cursor_hint ) )
	{
		if ( self.stub.cursor_hint == "HINT_WEAPON" && isDefined( self.stub.cursor_hint_weapon ) )
		{
			self setcursorhint( self.stub.cursor_hint, self.stub.cursor_hint_weapon );
		}
		else
		{
			self setcursorhint( self.stub.cursor_hint );
		}
	}
	return can_use;
}

buildablestub_update_prompt( player, trigger )
{
	if ( !self maps\mp\zombies\_zm_buildables::anystub_update_prompt( player ) )
	{
		return 0;
	}

	if ( isDefined( self.buildablestub_reject_func ) )
	{
		rval = self [[ self.buildablestub_reject_func ]]( player );
		if ( rval )
		{
			return 0;
		}
	}

	if ( isDefined( self.custom_buildablestub_update_prompt ) && !( self [[ self.custom_buildablestub_update_prompt ]]( player ) ) )
	{
		return 0;
	}

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if ( isDefined( self.built ) && !self.built )
	{
		slot = self.buildablestruct.buildable_slot;
		piece = self.buildablezone.pieces[0];
		player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

		if ( !isDefined( player maps\mp\zombies\_zm_buildables::player_get_buildable_piece( slot ) ) )
		{
			if ( isDefined( level.zombie_buildables[ self.equipname ].hint_more ) )
			{
				self.hint_string = level.zombie_buildables[ self.equipname ].hint_more;
			}
			else
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			}
			return 0;
		}
		else
		{
			if ( !self.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( player maps\mp\zombies\_zm_buildables::player_get_buildable_piece( slot ) ) )
			{
				if ( isDefined( level.zombie_buildables[ self.equipname ].hint_wrong ) )
				{
					self.hint_string = level.zombie_buildables[ self.equipname ].hint_wrong;
				}
				else
				{
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
				}
				return 0;
			}
			else
			{
				if ( isDefined( level.zombie_buildables[ self.equipname ].hint ) )
				{
					self.hint_string = level.zombie_buildables[ self.equipname ].hint;
				}
				else
				{
					self.hint_string = "Missing buildable hint";
				}
			}
		}
	}
	else
	{
		if ( self.persistent == 1 )
		{
			if ( maps\mp\zombies\_zm_equipment::is_limited_equipment( self.weaponname ) && maps\mp\zombies\_zm_equipment::limited_equipment_in_use( self.weaponname ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
				return 0;
			}

			if ( player has_player_equipment( self.weaponname ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
				return 0;
			}

			self.hint_string = self.trigger_hintstring;
		}
		else if ( self.persistent == 2 )
		{
			if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.weaponname, undefined ) )
			{
				self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				return 0;
			}
			else
			{
				if ( isDefined( self.bought ) && self.bought )
				{
					self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
					return 0;
				}
			}
			self.hint_string = self.trigger_hintstring;
		}
		else
		{
			self.hint_string = "";
			return 0;
		}
	}
	return 1;
}

pooledbuildablestub_update_prompt( player, trigger )
{
	if ( !self maps\mp\zombies\_zm_buildables::anystub_update_prompt( player ) )
	{
		return 0;
	}

	if ( isDefined( self.custom_buildablestub_update_prompt ) && !( self [[ self.custom_buildablestub_update_prompt ]]( player ) ) )
	{
		return 0;
	}

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if ( isDefined( self.built ) && !self.built )
	{
		trigger thread buildablestub_build_succeed();

		if (level.buildables_available.size > 1)
		{
			self thread choose_open_buildable(player);
		}

		slot = self.buildablestruct.buildable_slot;

		if (self.buildables_available_index >= level.buildables_available.size)
		{
			self.buildables_available_index = 0;
		}

		foreach (stub in level.buildable_stubs)
		{
			if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
			{
				piece = stub.buildablezone.pieces[0];
				break;
			}
		}

		player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

		piece = player maps\mp\zombies\_zm_buildables::player_get_buildable_piece(slot);

		if ( !isDefined( piece ) )
		{
			if ( isDefined( level.zombie_buildables[ self.equipname ].hint_more ) )
			{
				self.hint_string = level.zombie_buildables[ self.equipname ].hint_more;
			}
			else
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			}

			if ( isDefined( level.custom_buildable_need_part_vo ) )
			{
				player thread [[ level.custom_buildable_need_part_vo ]]();
			}
			return 0;
		}
		else
		{
			if ( isDefined( self.bound_to_buildable ) && !self.bound_to_buildable.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( piece ) )
			{
				if ( isDefined( level.zombie_buildables[ self.bound_to_buildable.equipname ].hint_wrong ) )
				{
					self.hint_string = level.zombie_buildables[ self.bound_to_buildable.equipname ].hint_wrong;
				}
				else
				{
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
				}

				if ( isDefined( level.custom_buildable_wrong_part_vo ) )
				{
					player thread [[ level.custom_buildable_wrong_part_vo ]]();
				}
				return 0;
			}
			else
			{
				if ( !isDefined( self.bound_to_buildable ) && !self.buildable_pool pooledbuildable_has_piece( piece ) )
				{
					if ( isDefined( level.zombie_buildables[ self.equipname ].hint_wrong ) )
					{
						self.hint_string = level.zombie_buildables[ self.equipname ].hint_wrong;
					}
					else
					{
						self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
					}
					return 0;
				}
				else
				{
					if ( isDefined( self.bound_to_buildable ) )
					{
						if ( isDefined( level.zombie_buildables[ piece.buildablename ].hint ) )
						{
							self.hint_string = level.zombie_buildables[ piece.buildablename ].hint;
						}
						else
						{
							self.hint_string = "Missing buildable hint";
						}
					}

					if ( isDefined( level.zombie_buildables[ piece.buildablename ].hint ) )
					{
						self.hint_string = level.zombie_buildables[ piece.buildablename ].hint;
					}
					else
					{
						self.hint_string = "Missing buildable hint";
					}
				}
			}
		}
	}
	else
	{
		return trigger [[ self.original_prompt_and_visibility_func ]]( player );
	}
	return 1;
}

pooledbuildable_has_piece( piece )
{
	return isDefined( self pooledbuildable_stub_for_piece( piece ) );
}

pooledbuildable_stub_for_piece( piece )
{
	foreach (stub in self.stubs)
	{
		if ( !isDefined( stub.bound_to_buildable ) )
		{
			if ( stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( piece ) )
			{
				return stub;
			}
		}
	}

	return undefined;
}

choose_open_buildable( player )
{
	self endon( "kill_choose_open_buildable" );

	n_playernum = player getentitynumber();
	b_got_input = 1;
	hinttexthudelem = newclienthudelem( player );
	hinttexthudelem.alignx = "center";
	hinttexthudelem.aligny = "middle";
	hinttexthudelem.horzalign = "center";
	hinttexthudelem.vertalign = "bottom";
	hinttexthudelem.y = -100;
	hinttexthudelem.foreground = 1;
	hinttexthudelem.font = "default";
	hinttexthudelem.fontscale = 1;
	hinttexthudelem.alpha = 1;
	hinttexthudelem.color = ( 1, 1, 1 );
	hinttexthudelem settext( "Press [{+actionslot 1}] or [{+actionslot 2}] to change item" );

	if (!isDefined(self.buildables_available_index))
	{
		self.buildables_available_index = 0;
	}

	while ( isDefined( self.playertrigger[ n_playernum ] ) && !self.built )
	{
		if (!player isTouching(self.playertrigger[n_playernum]))
		{
			hinttexthudelem.alpha = 0;
			wait 0.05;
			continue;
		}

		hinttexthudelem.alpha = 1;

		if ( player actionslotonebuttonpressed() )
		{
			self.buildables_available_index++;
			b_got_input = 1;
		}
		else if ( player actionslottwobuttonpressed() )
		{

			self.buildables_available_index--;
			b_got_input = 1;
		}

		if ( self.buildables_available_index >= level.buildables_available.size )
		{
			self.buildables_available_index = 0;
		}
		else if ( self.buildables_available_index < 0 )
		{
			self.buildables_available_index = level.buildables_available.size - 1;
		}

		if ( b_got_input )
		{
			piece = undefined;
			foreach (stub in level.buildable_stubs)
			{
				if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
				{
					piece = stub.buildablezone.pieces[0];
					break;
				}
			}
			slot = self.buildablestruct.buildable_slot;
			player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

			self.equipname = level.buildables_available[self.buildables_available_index];
			self.hint_string = level.zombie_buildables[self.equipname].hint;
			self.playertrigger[n_playernum] sethintstring(self.hint_string);
			b_got_input = 0;
		}

		if ( player is_player_looking_at( self.playertrigger[n_playernum].origin, 0.76 ) )
		{
			hinttexthudelem.alpha = 1;
		}
		else
		{
			hinttexthudelem.alpha = 0;
		}

		wait 0.05;
	}

	hinttexthudelem destroy();
}

buildablestub_build_succeed()
{
	self notify("buildablestub_build_succeed");
	self endon("buildablestub_build_succeed");

	self waittill( "build_succeed" );

	self.stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
	arrayremovevalue(level.buildables_available, self.stub.buildablezone.buildable_name);
	if (level.buildables_available.size == 0)
	{
		foreach (stub in level.buildable_stubs)
		{
			switch(stub.equipname)
			{
				case "turbine":
				case "subwoofer_zm":
				case "springpad_zm":
				case "headchopper_zm":
					maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
					break;
			}
		}
	}
}

// adds updated hintstring and functionality
updatebuildables()
{
	foreach (stub in level._unitriggers.trigger_stubs)
	{
		if(IsDefined(stub.equipname))
		{
			stub.cost = stub get_equipment_cost();
			stub.trigger_func = ::buildable_place_think;
			stub.prompt_and_visibility_func = ::buildabletrigger_update_prompt;
		}
	}
}

removebuildable( buildable, after_built )
{
	if (!isDefined(after_built))
	{
		after_built = 0;
	}

	if (after_built)
	{
		foreach (stub in level._unitriggers.trigger_stubs)
		{
			if(IsDefined(stub.equipname) && stub.equipname == buildable)
			{
				stub.model hide();
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( stub );
				return;
			}
		}
	}
	else
	{
		foreach (stub in level.buildable_stubs)
		{
			if ( !isDefined( buildable ) || stub.equipname == buildable )
			{
				if ( isDefined( buildable ) || stub.persistent != 3 )
				{
					stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
					foreach (piece in stub.buildablezone.pieces)
					{
						piece maps\mp\zombies\_zm_buildables::piece_unspawn();
					}
					maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( stub );
					return;
				}
			}
		}
	}
}

buildable_piece_remove_on_last_stand()
{
	self endon( "disconnect" );

	self thread buildable_get_last_piece();

	while (1)
	{
		self waittill("entering_last_stand");

		if (isDefined(self.last_piece))
		{
			self.last_piece maps\mp\zombies\_zm_buildables::piece_unspawn();
		}
	}
}

buildable_get_last_piece()
{
	self endon( "disconnect" );

	while (1)
	{
		if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			self.last_piece = maps\mp\zombies\_zm_buildables::player_get_buildable_piece(0);
		}

		wait 0.05;
	}
}

// MOTD\Origins style buildables
buildcraftables()
{
	// need a wait or else some buildables dont build
	wait 1;

	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "prison")
		{
			buildcraftable( "alcatraz_shield_zm" );
			buildcraftable( "packasplat" );
			changecraftableoption( 0 );
		}
		else if(level.scr_zm_map_start_location == "tomb")
		{
			buildcraftable( "tomb_shield_zm" );
			buildcraftable( "equip_dieseldrone_zm" );
			takecraftableparts( "gramophone" );
		}
	}
}

changecraftableoption( index )
{
	foreach (craftable in level.a_uts_craftables)
	{
		if (craftable.equipname == "open_table")
		{
			craftable thread setcraftableoption( index );
		}
	}
}

setcraftableoption( index )
{
	self endon("death");

	while (self.a_uts_open_craftables_available.size <= 0)
	{
		wait 0.05;
	}

	if (self.a_uts_open_craftables_available.size > 1)
	{
		self.n_open_craftable_choice = index;
		self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
		self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
		foreach (trig in self.playertrigger)
		{
			trig sethintstring( self.hint_string );
		}
	}
}

takecraftableparts( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.zombie_include_craftables)
	{
		if ( stub.name == buildable )
		{
			foreach (piece in stub.a_piecestubs)
			{
				piecespawn = piece.piecespawn;
				if ( isDefined( piecespawn ) )
				{
					player player_take_piece( piecespawn );
				}
			}

			return;
		}
	}
}

buildcraftable( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.a_uts_craftables)
	{
		if ( stub.craftablestub.name == buildable )
		{
			foreach (piece in stub.craftablespawn.a_piecespawns)
			{
				piecespawn = get_craftable_piece( stub.craftablestub.name, piece.piecename );
				if ( isDefined( piecespawn ) )
				{
					player player_take_piece( piecespawn );
				}
			}

			return;
		}
	}
}

get_craftable_piece( str_craftable, str_piece )
{
	foreach (uts_craftable in level.a_uts_craftables)
	{
		if ( uts_craftable.craftablestub.name == str_craftable )
		{
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
			{
				if ( piecespawn.piecename == str_piece )
				{
					return piecespawn;
				}
			}
		}
	}
	return undefined;
}

player_take_piece( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
	{
		piecespawn [[ piecestub.onpickup ]]( self );
	}

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
	{
		if ( isDefined( piecestub.client_field_id ) )
		{
			level setclientfield( piecestub.client_field_id, 1 );
		}
	}
	else
	{
		if ( isDefined( piecestub.client_field_state ) )
		{
			self setclientfieldtoplayer( "craftable", piecestub.client_field_state );
		}
	}

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
	{
		piecespawn.in_shared_inventory = 1;
	}

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

piece_unspawn()
{
	if ( isDefined( self.model ) )
	{
		self.model delete();
	}
	self.model = undefined;
	if ( isDefined( self.unitrigger ) )
	{
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger );
	}
	self.unitrigger = undefined;
}

remove_buildable_pieces( buildable_name )
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == buildable_name)
		{
			pieces = buildable.buildablepieces;
			for(i = 0; i < pieces.size; i++)
			{
				pieces[i] maps\mp\zombies\_zm_buildables::piece_unspawn();
			}
			return;
		}
	}
}

war_machine_explode_on_impact()
{
	self endon("disconnect");

	while(1)
	{
		self waittill("grenade_launcher_fire", grenade, weapname);

		if(weapname == "m32_zm")
		{
			grenade thread grenade_explode_on_impact();
		}
	}
}

grenade_explode_on_impact()
{
	self endon("death");

	self waittill("grenade_bounce", pos);

	self.origin = pos; // need this or position is slightly off

	self resetmissiledetonationtime(0);
}

jetgun_heatval_changes()
{
	self endon("disconnect");

	if(!maps\mp\zombies\_zm_weapons::is_weapon_included("jetgun_zm"))
	{
		return;
	}

	prev_heatval = 0;
	cooldown_amount = 0.1;
	overheat_amount = 0.85;

	while(1)
	{
		if(!IsDefined(self.jetgun_heatval))
		{
			prev_heatval = 0;
			wait 0.05;
			continue;
		}

		curr_heatval = self.jetgun_heatval;
		diff_heatval = curr_heatval - prev_heatval;

		if(self getCurrentWeapon() != "jetgun_zm")
		{
			self.jetgun_heatval -= cooldown_amount;
		}
		else if(self getCurrentWeapon() == "jetgun_zm" && self attackButtonPressed() && self isMeleeing())
		{
			self.jetgun_heatval += overheat_amount;
		}
		else if(diff_heatval < 0)
		{
			self.jetgun_heatval -= abs(diff_heatval);
		}

		if(self.jetgun_heatval < 0)
		{
			self.jetgun_heatval = 0;
		}
		else if(self.jetgun_heatval > 99.9)
		{
			self.jetgun_heatval = 99.9;
		}

		if(self.jetgun_heatval != curr_heatval)
		{
			self setweaponoverheating(self.jetgun_overheating, self.jetgun_heatval);
		}

		prev_heatval = self.jetgun_heatval;

		wait 0.05;
	}
}

jetgun_remove_forced_weapon_switch()
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == "jetgun_zm")
		{
			buildable.onbuyweapon = undefined;
			return;
		}
	}
}

give_additional_perks()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill_any("perk_acquired", "perk_lost");

		if (self HasPerk("specialty_fastreload"))
		{
			self SetPerk("specialty_fastads");
			self SetPerk("specialty_fastweaponswitch");
			self Setperk( "specialty_fasttoss" );
		}
		else
		{
			self UnsetPerk("specialty_fastads");
			self UnsetPerk("specialty_fastweaponswitch");
			self Unsetperk( "specialty_fasttoss" );
		}

		if (self HasPerk("specialty_deadshot"))
		{
			self SetPerk("specialty_stalker");
			self Setperk( "specialty_sprintrecovery" );
		}
		else
		{
			self UnsetPerk("specialty_stalker");
			self Unsetperk( "specialty_sprintrecovery" );
		}
	}
}

weapon_locker_give_ammo_after_rounds()
{
	self endon("disconnect");

	while(1)
	{
		level waittill("end_of_round");

		if(isDefined(self.stored_weapon_data))
		{
			if(self.stored_weapon_data["name"] != "none")
			{
				self.stored_weapon_data["clip"] = weaponClipSize(self.stored_weapon_data["name"]);
				self.stored_weapon_data["stock"] = weaponMaxAmmo(self.stored_weapon_data["name"]);
			}

			if(self.stored_weapon_data["dw_name"] != "none")
			{
				self.stored_weapon_data["lh_clip"] = weaponClipSize(self.stored_weapon_data["dw_name"]);
			}

			if(self.stored_weapon_data["alt_name"] != "none")
			{
				self.stored_weapon_data["alt_clip"] = weaponClipSize(self.stored_weapon_data["alt_name"]);
				self.stored_weapon_data["alt_stock"] = weaponMaxAmmo(self.stored_weapon_data["alt_name"]);
			}
		}
	}
}

tombstone_spawn()
{
	dc = spawn( "script_model", self.origin + vectorScale( ( 0, 0, 1 ), 40 ) );
	dc.angles = self.angles;
	dc setmodel( "tag_origin" );
	dc_icon = spawn( "script_model", self.origin + vectorScale( ( 0, 0, 1 ), 40 ) );
	dc_icon.angles = self.angles;
	dc_icon setmodel( "ch_tombstone1" );
	dc_icon linkto( dc );
	dc.icon = dc_icon;
	dc.script_noteworthy = "player_tombstone_model";
	dc.player = self;

	self thread maps\mp\zombies\_zm_tombstone::tombstone_clear();
	dc thread tombstone_wobble();
	dc thread tombstone_emp();

	result = self waittill_any_return( "player_revived", "spawned_player", "disconnect" );

	if (result == "disconnect")
	{
		dc tombstone_delete();
		return;
	}

	dc thread tombstone_waypoint();
	dc thread tombstone_timeout();
	dc thread tombstone_grab();
}

tombstone_wobble()
{
	self endon( "tombstone_grabbed" );
	self endon( "tombstone_timedout" );

	if ( isDefined( self ) )
	{
		playfxontag( level._effect[ "powerup_on_solo" ], self, "tag_origin" );
		self playsound( "zmb_tombstone_spawn" );
		self playloopsound( "zmb_tombstone_looper" );
	}

	while ( isDefined( self ) )
	{
		self rotateyaw( 360, 3 );
		wait 2.9;
	}
}

tombstone_emp()
{
	self endon( "tombstone_timedout" );
	self endon( "tombstone_grabbed" );

	if ( !should_watch_for_emp() )
	{
		return;
	}

	while ( 1 )
	{
		level waittill( "emp_detonate", origin, radius );
		if ( distancesquared( origin, self.origin ) < ( radius * radius ) )
		{
			playfx( level._effect[ "powerup_off" ], self.origin );
			self thread tombstone_delete();
		}
	}
}

tombstone_waypoint()
{
	height_offset = 40;
	hud_elem = newClientHudElem(self.player);
	hud_elem.x = self.origin[0];
	hud_elem.y = self.origin[1];
	hud_elem.z = self.origin[2] + height_offset;
	hud_elem.alpha = 1;
	hud_elem.color = (0.5, 0.5, 0.5);
	hud_elem.hidewheninmenu = 1;
	hud_elem.fadewhentargeted = 1;
	hud_elem setWaypoint(1, "specialty_tombstone_zombies");

	self waittill_any("tombstone_grabbed", "tombstone_timedout");

	hud_elem destroy();
}

tombstone_timeout()
{
	self endon( "tombstone_grabbed" );

	self thread maps\mp\zombies\_zm_tombstone::playtombstonetimeraudio();

	self.player waittill("player_downed");

	self tombstone_delete();
}

tombstone_grab()
{
	self endon( "tombstone_timedout" );

	while ( isDefined( self ) )
	{
		players = get_players();
		i = 0;
		while ( i < players.size )
		{
			if ( players[ i ].is_zombie )
			{
				i++;
				continue;
			}
			else
			{
				if ( isDefined( self.player ) && players[ i ] == self.player )
				{
					dist = distance( players[ i ].origin, self.origin );
					if ( dist < 64 )
					{
						playfx( level._effect[ "powerup_grabbed_solo" ], self.origin );
						playfx( level._effect[ "powerup_grabbed_wave_solo" ], self.origin );
						players[ i ] tombstone_give();
						wait 0.1;
						playsoundatposition( "zmb_tombstone_grab", self.origin );
						self stoploopsound();
						self.icon unlink();
						self.icon delete();
						self delete();
						self notify( "tombstone_grabbed" );
						players[ i ] clientnotify( "dc0" );
						players[ i ] notify( "dance_on_my_grave" );
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
	self notify( "tombstone_timedout" );
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
	if(is_alt_weapon(self.tombstone_savedweapon_currentweapon))
	{
		self.tombstone_savedweapon_currentweapon = maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(self.tombstone_savedweapon_currentweapon);
	}

	for ( i = 0; i < self.tombstone_savedweapon_weapons.size; i++ )
	{
		self.tombstone_savedweapon_weaponsammo_clip[ i ] = self getweaponammoclip( self.tombstone_savedweapon_weapons[ i ] );
		self.tombstone_savedweapon_weaponsammo_clip_dualwield[ i ] = self getweaponammoclip(weaponDualWieldWeaponName( self.tombstone_savedweapon_weapons[ i ] ) );
		self.tombstone_savedweapon_weaponsammo_stock[ i ] = self getweaponammostock( self.tombstone_savedweapon_weapons[ i ] );
		self.tombstone_savedweapon_weaponsammo_clip_alt[i] = self getweaponammoclip(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]));
		self.tombstone_savedweapon_weaponsammo_stock_alt[i] = self getweaponammostock(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]));
	}

	if ( isDefined( self.tombstone_savedweapon_grenades ) )
	{
		self.tombstone_savedweapon_grenades_clip = self getweaponammoclip( self.tombstone_savedweapon_grenades );
	}

	if ( isDefined( self.tombstone_savedweapon_tactical ) )
	{
		self.tombstone_savedweapon_tactical_clip = self getweaponammoclip( self.tombstone_savedweapon_tactical );
	}

	if ( isDefined( self.tombstone_savedweapon_mine ) )
	{
		self.tombstone_savedweapon_mine_clip = self getweaponammoclip( self.tombstone_savedweapon_mine );
	}

	if ( isDefined( self.hasriotshield ) && self.hasriotshield )
	{
		self.tombstone_hasriotshield = 1;
	}
}

tombstone_save_perks( ent )
{
	perk_array = [];
	if ( ent hasperk( "specialty_armorvest" ) )
	{
		perk_array[ perk_array.size ] = "specialty_armorvest";
	}
	if ( ent hasperk( "specialty_deadshot" ) )
	{
		perk_array[ perk_array.size ] = "specialty_deadshot";
	}
	if ( ent hasperk( "specialty_fastreload" ) )
	{
		perk_array[ perk_array.size ] = "specialty_fastreload";
	}
	if ( ent hasperk( "specialty_flakjacket" ) )
	{
		perk_array[ perk_array.size ] = "specialty_flakjacket";
	}
	if ( ent hasperk( "specialty_movefaster" ) )
	{
		perk_array[ perk_array.size ] = "specialty_movefaster";
	}
	if ( ent hasperk( "specialty_quickrevive" ) )
	{
		perk_array[ perk_array.size ] = "specialty_quickrevive";
	}
	if ( ent hasperk( "specialty_rof" ) )
	{
		perk_array[ perk_array.size ] = "specialty_rof";
	}
	return perk_array;
}

tombstone_give()
{
	if ( !isDefined( self.tombstone_savedweapon_weapons ) )
	{
		return ;
	}

	primary_weapons = self getWeaponsListPrimaries();
	foreach(weapon in primary_weapons)
	{
		self takeWeapon(weapon);
	}

	self takeWeapon(self get_player_melee_weapon());
	self takeWeapon(self get_player_lethal_grenade());
	self takeWeapon(self get_player_tactical_grenade());
	self takeWeapon(self get_player_placeable_mine());

	primary_weapons_returned = 0;
	i = 0;
	while ( i < self.tombstone_savedweapon_weapons.size )
	{
		if ( isdefined( self.tombstone_savedweapon_grenades ) && self.tombstone_savedweapon_weapons[ i ] == self.tombstone_savedweapon_grenades || ( isdefined( self.tombstone_savedweapon_tactical ) && self.tombstone_savedweapon_weapons[ i ] == self.tombstone_savedweapon_tactical ) )
		{
			i++;
			continue;
		}

		if ( isweaponprimary( self.tombstone_savedweapon_weapons[ i ] ) )
		{
			if ( primary_weapons_returned >= 2 )
			{
				i++;
				continue;
			}

			primary_weapons_returned++;
		}

		if ( "item_meat_zm" == self.tombstone_savedweapon_weapons[ i ] )
		{
			i++;
			continue;
		}

		self giveweapon( self.tombstone_savedweapon_weapons[ i ], 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( self.tombstone_savedweapon_weapons[ i ] ) );

		if ( isdefined( self.tombstone_savedweapon_weaponsammo_clip[ i ] ) )
		{
			self setweaponammoclip( self.tombstone_savedweapon_weapons[ i ], self.tombstone_savedweapon_weaponsammo_clip[ i ] );
		}

		if ( isdefined( self.tombstone_savedweapon_weaponsammo_clip_dualwield[ i ] ) )
		{
			self setweaponammoclip( weaponDualWieldWeaponName( self.tombstone_savedweapon_weapons[ i ] ), self.tombstone_savedweapon_weaponsammo_clip_dualwield[ i ] );
		}

		if ( isdefined( self.tombstone_savedweapon_weaponsammo_stock[ i ] ) )
		{
			self setweaponammostock( self.tombstone_savedweapon_weapons[ i ], self.tombstone_savedweapon_weaponsammo_stock[ i ] );
		}

		if ( isdefined( self.tombstone_savedweapon_weaponsammo_clip_alt[ i ] ) )
		{
			self setweaponammoclip( weaponAltWeaponName( self.tombstone_savedweapon_weapons[ i ] ), self.tombstone_savedweapon_weaponsammo_clip_alt[ i ] );
		}

		if ( isdefined( self.tombstone_savedweapon_weaponsammo_stock_alt[ i ] ) )
		{
			self setweaponammostock( weaponAltWeaponName( self.tombstone_savedweapon_weapons[ i ] ), self.tombstone_savedweapon_weaponsammo_stock_alt[ i ] );
		}

		i++;
	}

	if ( isDefined( self.tombstone_savedweapon_melee ) )
	{
		self set_player_melee_weapon( self.tombstone_savedweapon_melee );
	}

	if ( isDefined( self.tombstone_savedweapon_grenades ) )
	{
		self giveweapon( self.tombstone_savedweapon_grenades );
		self set_player_lethal_grenade( self.tombstone_savedweapon_grenades );

		if ( isDefined( self.tombstone_savedweapon_grenades_clip ) )
		{
			self setweaponammoclip( self.tombstone_savedweapon_grenades, self.tombstone_savedweapon_grenades_clip );
		}
	}

	if ( isDefined( self.tombstone_savedweapon_tactical ) )
	{
		self giveweapon( self.tombstone_savedweapon_tactical );
		self set_player_tactical_grenade( self.tombstone_savedweapon_tactical );

		if ( isDefined( self.tombstone_savedweapon_tactical_clip ) )
		{
			self setweaponammoclip( self.tombstone_savedweapon_tactical, self.tombstone_savedweapon_tactical_clip );
		}
	}

	if ( isDefined( self.tombstone_savedweapon_mine ) )
	{
		self giveweapon( self.tombstone_savedweapon_mine );
		self set_player_placeable_mine( self.tombstone_savedweapon_mine );
		self setactionslot( 4, "weapon", self.tombstone_savedweapon_mine );
		self setweaponammoclip( self.tombstone_savedweapon_mine, self.tombstone_savedweapon_mine_clip );
	}

	if ( isDefined( self.current_equipment ) )
	{
		self maps\mp\zombies\_zm_equipment::equipment_take( self.current_equipment );
	}

	if ( isDefined( self.tombstone_savedweapon_equipment ) )
	{
		self.do_not_display_equipment_pickup_hint = 1;
		self maps\mp\zombies\_zm_equipment::equipment_give( self.tombstone_savedweapon_equipment );
		self.do_not_display_equipment_pickup_hint = undefined;
	}

	if ( isDefined( self.tombstone_hasriotshield ) && self.tombstone_hasriotshield )
	{
		if ( isDefined( self.player_shield_reset_health ) )
		{
			self [[ self.player_shield_reset_health ]]();
		}
	}

	current_wep = self getCurrentWeapon();
	if(!isSubStr(current_wep, "perk_bottle") && !isSubStr(current_wep, "knuckle_crack") && !isSubStr(current_wep, "flourish") && !isSubStr(current_wep, "item_meat"))
	{
		switched = 0;
		primaries = self getweaponslistprimaries();
		foreach ( weapon in primaries )
		{
			if ( isDefined( self.tombstone_savedweapon_currentweapon ) && self.tombstone_savedweapon_currentweapon == weapon )
			{
				switched = 1;
				self switchtoweapon( weapon );
			}
		}

		if(!switched)
		{
			if ( primaries.size > 0 )
			{
				self switchtoweapon( primaries[ 0 ] );
			}
		}
	}

	if ( isDefined( self.tombstone_perks ) && self.tombstone_perks.size > 0 )
	{
		i = 0;
		while ( i < self.tombstone_perks.size )
		{
			if ( self hasperk( self.tombstone_perks[ i ] ) )
			{
				i++;
				continue;
			}

			self maps\mp\zombies\_zm_perks::give_perk( self.tombstone_perks[ i ] );
			i++;
		}
	}
}

additionalprimaryweapon_save_weapons()
{
	self endon("disconnect");

	while (1)
	{
		if (!self hasPerk("specialty_additionalprimaryweapon"))
		{
			self waittill("perk_acquired");
			wait 0.05;
		}

		if (self hasPerk("specialty_additionalprimaryweapon"))
		{
			primaries = self getweaponslistprimaries();
			if (primaries.size >= 3)
			{
				weapon = primaries[primaries.size - 1];
				self.a_saved_weapon = maps\mp\zombies\_zm_weapons::get_player_weapondata(self, weapon);
			}
			else
			{
				self.a_saved_weapon = undefined;
			}
		}

		wait 0.05;
	}
}

additionalprimaryweapon_restore_weapons()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("perk_acquired");

		if (isDefined(self.a_saved_weapon) && self hasPerk("specialty_additionalprimaryweapon"))
		{
			pap_triggers = getentarray( "specialty_weapupgrade", "script_noteworthy" );

			give_wep = 1;
			if ( isDefined( self ) && self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( self.a_saved_weapon["name"] ) )
			{
				give_wep = 0;
			}
			else if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.a_saved_weapon["name"], self, pap_triggers ) )
			{
				give_wep = 0;
			}
			else if ( !self maps\mp\zombies\_zm_weapons::player_can_use_content( self.a_saved_weapon["name"] ) )
			{
				give_wep = 0;
			}
			else if ( isDefined( level.custom_magic_box_selection_logic ) )
			{
				if ( !( [[ level.custom_magic_box_selection_logic ]]( self.a_saved_weapon["name"], self, pap_triggers ) ) )
				{
					give_wep = 0;
				}
			}
			else if ( isDefined( self ) && isDefined( level.special_weapon_magicbox_check ) )
			{
				give_wep = self [[ level.special_weapon_magicbox_check ]]( self.a_saved_weapon["name"] );
			}

			if (give_wep)
			{
				current_wep = self getCurrentWeapon();
				self maps\mp\zombies\_zm_weapons::weapondata_give(self.a_saved_weapon);
				self switchToWeapon(current_wep);
			}

			self.a_saved_weapon = undefined;
		}
	}
}

additionalprimaryweapon_indicator()
{
	self endon("disconnect");

	if(!is_true(level.zombiemode_using_additionalprimaryweapon_perk))
	{
		return;
	}

	additionalprimaryweapon_indicator_hud = newClientHudElem(self);
	additionalprimaryweapon_indicator_hud.alignx = "right";
	additionalprimaryweapon_indicator_hud.aligny = "bottom";
	additionalprimaryweapon_indicator_hud.horzalign = "user_right";
	additionalprimaryweapon_indicator_hud.vertalign = "user_bottom";
	if (level.script == "zm_highrise")
	{
		additionalprimaryweapon_indicator_hud.x -= 100;
		additionalprimaryweapon_indicator_hud.y -= 80;
	}
	else if (level.script == "zm_tomb")
	{
		additionalprimaryweapon_indicator_hud.x -= 75;
		additionalprimaryweapon_indicator_hud.y -= 60;
	}
	else
	{
		additionalprimaryweapon_indicator_hud.x -= 75;
		additionalprimaryweapon_indicator_hud.y -= 80;
	}
	additionalprimaryweapon_indicator_hud.alpha = 0;
	additionalprimaryweapon_indicator_hud.color = ( 1, 1, 1 );
	additionalprimaryweapon_indicator_hud.hidewheninmenu = 1;
	additionalprimaryweapon_indicator_hud setShader("specialty_additionalprimaryweapon_zombies", 24, 24);

	while (1)
	{
		self waittill_any("weapon_change", "specialty_additionalprimaryweapon_stop", "spawned_player");

		if (self hasPerk("specialty_additionalprimaryweapon") && isDefined(self.a_saved_weapon) && self getCurrentWeapon() == self.a_saved_weapon["name"])
		{
			additionalprimaryweapon_indicator_hud fadeOverTime(0.5);
			additionalprimaryweapon_indicator_hud.alpha = 1;
		}
		else
		{
			additionalprimaryweapon_indicator_hud fadeOverTime(0.5);
			additionalprimaryweapon_indicator_hud.alpha = 0;
		}
	}
}

additionalprimaryweapon_stowed_weapon_refill()
{
	self endon("disconnect");

	while (1)
	{
		string = self waittill_any_return("weapon_change", "weapon_change_complete", "specialty_additionalprimaryweapon_stop", "spawned_player");

		if(self hasPerk("specialty_additionalprimaryweapon"))
		{
			curr_wep = self getCurrentWeapon();
			if(curr_wep == "none")
			{
				continue;
			}

			primaries = self getWeaponsListPrimaries();
			foreach(primary in primaries)
			{
				if(primary != maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(curr_wep))
				{
					if(string != "weapon_change")
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

	if(primary == "m32_zm" || primary == "python_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "judge_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "870mcs_zm" || maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "ksg_zm")
	{
		reload_amount = 1;

		if(maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary, 1) == "ksg_zm" && maps\mp\zombies\_zm_weapons::is_weapon_upgraded(primary))
		{
			reload_amount = 2;
		}
	}

	if(!isDefined(reload_amount) && reload_time < 1)
	{
		reload_time = 1;
	}

	if(self hasPerk("specialty_fastreload"))
	{
		reload_time *= getDvarFloat("perk_weapReloadMultiplier");
	}

	wait reload_time;

	ammo_clip = self getWeaponAmmoClip(primary);
	ammo_stock = self getWeaponAmmoStock(primary);
	missing_clip = weaponClipSize(primary) - ammo_clip;

	if(missing_clip > ammo_stock)
	{
		missing_clip = ammo_stock;
	}

	if(isDefined(reload_amount) && missing_clip > reload_amount)
	{
		missing_clip = reload_amount;
	}

	self setWeaponAmmoClip(primary, ammo_clip + missing_clip);
	self setWeaponAmmoStock(primary, ammo_stock - missing_clip);

	dw_primary = weaponDualWieldWeaponName(primary);
	if(dw_primary != "none")
	{
		ammo_clip = self getWeaponAmmoClip(dw_primary);
		ammo_stock = self getWeaponAmmoStock(dw_primary);
		missing_clip = weaponClipSize(dw_primary) - ammo_clip;

		if(missing_clip > ammo_stock)
		{
			missing_clip = ammo_stock;
		}

		self setWeaponAmmoClip(dw_primary, ammo_clip + missing_clip);
		self setWeaponAmmoStock(dw_primary, ammo_stock - missing_clip);
	}

	alt_primary = weaponAltWeaponName(primary);
	if(alt_primary != "none")
	{
		ammo_clip = self getWeaponAmmoClip(alt_primary);
		ammo_stock = self getWeaponAmmoStock(alt_primary);
		missing_clip = weaponClipSize(alt_primary) - ammo_clip;

		if(missing_clip > ammo_stock)
		{
			missing_clip = ammo_stock;
		}

		self setWeaponAmmoClip(alt_primary, ammo_clip + missing_clip);
		self setWeaponAmmoStock(alt_primary, ammo_stock - missing_clip);
	}

	if(isDefined(reload_amount) && self getWeaponAmmoStock(primary) > 0 && self getWeaponAmmoClip(primary) < weaponClipSize(primary))
	{
		self refill_after_time(primary);
	}
}

whos_who_spawn_changes()
{
	self endon( "disconnect" );

	while (1)
	{
		self waittill("fake_revive");

		self.pers_upgrades_awarded["revive"] = 1;

		self takeweapon("frag_grenade_zm");
		self takeweapon("claymore_zm");
		self giveweapon("sticky_grenade_zm");
		self setweaponammoclip("sticky_grenade_zm", 2);

		foreach (perk in self.loadout.perks)
		{
			self maps\mp\zombies\_zm_perks::give_perk(perk);
		}

		self waittill("chugabud_effects_cleanup");

		self.pers_upgrades_awarded["revive"] = 0;
	}
}

electric_cherry_unlimited()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self.consecutive_electric_cherry_attacks = 0;

		wait 0.5;
	}
}

show_powerswitch()
{
	getent( "powerswitch_p6_zm_buildable_pswitch_hand", "targetname" ) show();
	getent( "powerswitch_p6_zm_buildable_pswitch_body", "targetname" ) show();
	getent( "powerswitch_p6_zm_buildable_pswitch_lever", "targetname" ) show();
}

zone_changes()
{
	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "rooftop")
		{
			// AN94 to Debris
			level.zones[ "zone_orange_level3a" ].adjacent_zones[ "zone_orange_level3b" ].is_connected = 0;

			// Trample Steam to Skyscraper
			level.zones[ "zone_green_level3b" ].adjacent_zones[ "zone_blue_level1c" ] structdelete();
			level.zones[ "zone_green_level3b" ].adjacent_zones[ "zone_blue_level1c" ] = undefined;
		}
	}
	else
	{
		if(level.scr_zm_map_start_location == "farm")
		{
			// Barn to Farm
			flag_set("OnFarm_enter");
		}
	}
}

vulture_disable_stink_while_standing()
{
	self endon( "disconnect" );

	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	while(!isDefined(self.perk_vulture))
	{
		wait 0.05;
	}

	while(1)
	{
		if (!self.perk_vulture.active)
		{
			wait 0.05;
			continue;
		}

		self.perk_vulture.is_in_zombie_stink = 1;
		self.perk_vulture.stink_time_entered = undefined;

		b_player_in_zombie_stink = 0;
		a_close_points = arraysort( level.perk_vulture.zombie_stink_array, self.origin, 1, 300 );
		if ( a_close_points.size > 0 )
		{
			if(isDefined(level._is_player_in_zombie_stink))
			{
				b_player_in_zombie_stink = self [[level._is_player_in_zombie_stink]]( a_close_points );
			}
		}

		if (b_player_in_zombie_stink)
		{
			vel = self GetVelocity();
			magnitude = sqrt((vel[0] * vel[0]) + (vel[1] * vel[1]) + (vel[2] * vel[2]));
			if (magnitude < 125)
			{
				self.perk_vulture.is_in_zombie_stink = 0;

				wait 0.25;

				while (self.vulture_stink_value > 0)
				{
					wait 0.05;
				}
			}
		}

		wait 0.05;
	}
}

destroy_on_intermission()
{
	self endon("death");

	level waittill("intermission");

	if(isDefined(self.elemtype) && self.elemtype == "bar")
	{
		self.bar destroy();
		self.barframe destroy();
	}

	self destroy();
}