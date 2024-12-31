#include maps\mp\zombies\_zm_weap_time_bomb;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_ai_basic;

init_time_bomb()
{
	time_bomb_precache();
	level thread time_bomb_post_init();
	flag_init("time_bomb_round_killed");
	flag_init("time_bomb_enemies_restored");
	flag_init("time_bomb_zombie_respawning_done");
	flag_init("time_bomb_restore_active");
	flag_init("time_bomb_restore_done");
	flag_init("time_bomb_global_restore_done");
	flag_init("time_bomb_detonation_enabled");
	flag_init("time_bomb_stores_door_state");
	registerclientfield("world", "time_bomb_saved_round_number", 12000, 8, "int");
	registerclientfield("world", "time_bomb_lua_override", 12000, 1, "int");
	registerclientfield("world", "time_bomb_hud_toggle", 12000, 1, "int");
	registerclientfield("toplayer", "sndTimebombLoop", 12000, 2, "int");
	maps\mp\zombies\_zm_weapons::register_zombie_weapon_callback("time_bomb_zm", ::player_give_time_bomb);
	level.zombiemode_time_bomb_give_func = ::player_give_time_bomb;
	include_weapon("time_bomb_zm", 1);
	maps\mp\zombies\_zm_weapons::add_limited_weapon("time_bomb_zm", 1);
	add_time_bomb_to_mystery_box();
	register_equipment_for_level("time_bomb_zm");
	register_equipment_for_level("time_bomb_detonator_zm");

	if (!isdefined(level.round_wait_func))
	{
		level.round_wait_func = ::time_bomb_round_wait;
	}

	level.zombie_round_change_custom = ::time_bomb_custom_round_change;
	level._effect["time_bomb_set"] = loadfx("weapon/time_bomb/fx_time_bomb_detonate");
	level._effect["time_bomb_ammo_fx"] = loadfx("misc/fx_zombie_powerup_on");
	level._effect["time_bomb_respawns_enemy"] = loadfx("maps/zombie_buried/fx_buried_time_bomb_spawn");
	level._effect["time_bomb_kills_enemy"] = loadfx("maps/zombie_buried/fx_buried_time_bomb_death");
	level._time_bomb = spawnstruct();
	level._time_bomb.enemy_type = [];
	register_time_bomb_enemy("zombie", ::is_zombie_round, ::time_bomb_saves_zombie_data, ::time_bomb_respawns_zombies);
	register_time_bomb_enemy_default("zombie");
	level._time_bomb.last_round_restored = -1;
	flag_set("time_bomb_detonation_enabled");
}

player_give_time_bomb()
{
	assert(isplayer(self), "player_give_time_bomb can only be used on players!");
	self giveweapon("time_bomb_zm");
	self swap_weapon_to_time_bomb();
	self thread show_time_bomb_hints();
	self thread time_bomb_think();
	self thread detonator_think();
	self thread time_bomb_inventory_slot_think();
	self thread destroy_time_bomb_save_if_user_bleeds_out_or_disconnects();
	self thread sndwatchforweapswitch();
}

show_time_bomb_hints()
{
	self endon("death_or_disconnect");
	self endon("player_lost_time_bomb");

	if (!isdefined(self.time_bomb_hints_shown))
	{
		self.time_bomb_hints_shown = 0;
	}

	if (!self.time_bomb_hints_shown)
	{
		self.time_bomb_hints_shown = 1;
		wait 0.5;
		self show_time_bomb_notification(&"ZOMBIE_TIMEBOMB_PICKUP");
		self thread _watch_for_player_switch_to_time_bomb();
		wait 3.5;
		self clean_up_time_bomb_notifications();
	}
}

time_bomb_inventory_slot_think()
{
	self notify("_time_bomb_inventory_think_done");
	self endon("_time_bomb_inventory_think_done");
	self endon("death_or_disconnect");
	self endon("player_lost_time_bomb");
	self.time_bomb_detonator_only = 0;

	while (true)
	{
		self waittill("zmb_max_ammo");

		if (self.time_bomb_detonator_only)
		{
			self.time_bomb_detonator_only = 0;
		}

		self swap_weapon_to_time_bomb();
	}
}

swap_weapon_to_time_bomb()
{
	switch_to_weapon = 0;

	if (self getcurrentweapon() == "time_bomb_detonator_zm")
	{
		switch_to_weapon = 1;
	}

	self takeweapon("time_bomb_detonator_zm");
	self giveweapon("time_bomb_zm");
	self setactionslot(2, "weapon", "time_bomb_zm");

	if (switch_to_weapon)
	{
		self switchtoweapon("time_bomb_zm");
	}
}

time_bomb_think()
{
	self notify("_time_bomb_kill_thread");
	self endon("_time_bomb_kill_thread");
	self endon("death");
	self endon("disconnect");
	self endon("player_lost_time_bomb");

	while (true)
	{
		self waittill("grenade_fire", e_grenade, str_grenade_name);

		if (str_grenade_name == "time_bomb_zm")
		{
			if (isdefined(str_grenade_name) && str_grenade_name == "time_bomb_zm")
			{
				e_grenade thread setup_time_bomb_detonation_model();
				time_bomb_saves_data();
				e_grenade time_bomb_model_init();
				self thread swap_weapon_to_detonator(e_grenade);
				self thread time_bomb_thrown_vo();
			}
		}
	}
}

swap_weapon_to_detonator(e_grenade)
{
	self endon("death_or_disconnect");
	self endon("player_lost_time_bomb");
	b_switch_to_weapon = 0;

	if (isdefined(e_grenade))
	{
		b_switch_to_weapon = 1;
		wait 0.4;
	}

	self takeweapon("time_bomb_zm");
	self giveweapon("time_bomb_detonator_zm");
	self setweaponammoclip("time_bomb_detonator_zm", 0);
	self setweaponammostock("time_bomb_detonator_zm", 0);
	self setactionslot(2, "weapon", "time_bomb_detonator_zm");

	if (b_switch_to_weapon)
	{
		self switchtoweapon("time_bomb_detonator_zm");
	}

	self giveweapon("time_bomb_zm");
}

detonator_think()
{
	self notify("_detonator_think_done");
	self endon("_detonator_think_done");
	self endon("death");
	self endon("disconnect");
	self endon("player_lost_time_bomb");
	debug_time_bomb_print("player picked up detonator");

	while (true)
	{
		self waittill("detonate");

		debug_time_bomb_print("detonate detected! ");

		if (time_bomb_save_exists() && flag("time_bomb_detonation_enabled"))
		{
			level.time_bomb_save_data.player_used = self;
			level.time_bomb_save_data.time_bomb_model thread detonate_time_bomb();
			self notify("player_activates_timebomb");
			self thread time_bomb_detonation_vo();
		}
	}
}

detonate_time_bomb()
{
	if (isdefined(level.time_bomb_save_data.time_bomb_model) && isdefined(level.time_bomb_save_data.time_bomb_model.origin))
	{
		playsoundatposition("zmb_timebomb_3d_timer_end", level.time_bomb_save_data.time_bomb_model.origin);
	}

	if (time_bomb_save_exists())
	{
		time_bomb_detonation();
	}
	else
	{
		delete_time_bomb_model();
	}
}

time_bomb_detonation()
{
	level setclientfield("time_bomb_lua_override", 1);

	playsoundatposition("zmb_timebomb_timechange_2d", (0, 0, 0));
	_time_bomb_show_overlay();
	time_bomb_clears_global_data();
	time_bomb_clears_player_data();

	wait 4;

	_time_bomb_kill_all_active_enemies();
	_time_bomb_revive_all_downed_players();

	delete_time_bomb_model();
	_time_bomb_hide_overlay();
	level thread set_time_bomb_restore_active();
	level setclientfield("time_bomb_lua_override", 0);

	if (isdefined(level._time_bomb.functionality_override) && level._time_bomb.functionality_override)
	{
		return;
	}

	level notify("time_bomb_detonation_complete");
}

_time_bomb_show_overlay()
{
	flag_clear("time_bomb_restore_done");
	a_players = get_players();

	foreach (player in a_players)
	{
		maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zombie_time_bomb_overlay", player);
		player freezecontrols(1);
		player enableinvulnerability();
	}

	a_players = get_players(level.time_bomb_save_data.player_used.team);

	foreach (player in a_players)
	{
		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			player.bleedout_time = getdvarfloat("player_lastStandBleedoutTime");
		}
	}

	level thread kill_overlay_at_match_end();
}

_time_bomb_hide_overlay(n_time_start)
{
	n_time_end = gettime();

	if (isdefined(n_time_start))
	{
		n_time_elapsed = (n_time_end - n_time_start) * 0.001;
		n_delay = 4 - n_time_elapsed;
		n_delay = clamp(n_delay, 0, 4);

		if (n_delay > 0)
		{
			wait(n_delay);
			timebomb_wait_for_hostmigration();
		}
	}

	timebomb_wait_for_hostmigration();
	a_players = get_players();
	flag_set("time_bomb_restore_done");

	foreach (player in a_players)
	{
		player freezecontrols(0);
		player disableInvulnerability();
	}
}

set_time_bomb_restore_active()
{
	flag_set("time_bomb_restore_active");

	wait 0.05;

	flag_clear("time_bomb_restore_active");
}

_time_bomb_kill_all_active_enemies()
{
	for (zombies = time_bomb_get_enemy_array(); zombies.size > 0; zombies = time_bomb_get_enemy_array())
	{
		for (i = 0; i < zombies.size; i++)
		{
			timebomb_wait_for_hostmigration();

			if (isdefined(zombies[i]))
			{
				zombies[i] thread _kill_time_bomb_enemy();
			}
		}
	}
}

_kill_time_bomb_enemy()
{
	self dodamage(self.health + 100, self.origin, level.time_bomb_save_data.player_used, level.time_bomb_save_data.player_used, self.origin);
	self ghost();
	playfx(level._effect["time_bomb_kills_enemy"], self.origin);

	if (isdefined(self) && isdefined(self.anchor))
	{
		self.anchor delete();
	}

	wait_network_frame();

	if (isdefined(self))
	{
		if (isdefined(self.script_mover))
		{
			self.script_mover delete();
		}

		self delete();
	}
}

_time_bomb_revive_all_downed_players()
{
	players = get_players(level.time_bomb_save_data.player_used.team);

	foreach (player in players)
	{
		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			player.revived_by_weapon = "time_bomb_zm";
			player maps\mp\zombies\_zm_laststand::auto_revive(level.time_bomb_save_data.player_used);
		}
	}
}