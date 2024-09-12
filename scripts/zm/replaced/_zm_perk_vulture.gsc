#include maps\mp\zombies\_zm_perk_vulture;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_ai_basic;

init_vulture()
{
	setdvarint("zombies_perk_vulture_pickup_time", 12);
	setdvarint("zombies_perk_vulture_pickup_time_stink", 16);
	setdvarint("zombies_perk_vulture_drop_chance", 65);
	setdvarint("zombies_perk_vulture_ammo_chance", 33);
	setdvarint("zombies_perk_vulture_points_chance", 33);
	setdvarint("zombies_perk_vulture_stink_chance", 33);
	setdvarint("zombies_perk_vulture_drops_max", 20);
	setdvarint("zombies_perk_vulture_network_drops_max", 5);
	setdvarint("zombies_perk_vulture_network_time_frame", 250);
	setdvarint("zombies_perk_vulture_spawn_stink_zombie_cooldown", 12);
	setdvarint("zombies_perk_vulture_max_stink_zombies", 4);
	level.perk_vulture = spawnstruct();
	level.perk_vulture.zombie_stink_array = [];
	level.perk_vulture.drop_time_last = 0;
	level.perk_vulture.drop_slots_for_network = 0;
	level.perk_vulture.last_stink_zombie_spawned = 0;
	level.perk_vulture.use_exit_behavior = 0;
	level.perk_vulture.clientfields = spawnstruct();
	level.perk_vulture.clientfields.scriptmovers = [];
	level.perk_vulture.clientfields.scriptmovers["vulture_stink_fx"] = 0;
	level.perk_vulture.clientfields.scriptmovers["vulture_drop_fx"] = 1;
	level.perk_vulture.clientfields.scriptmovers["vulture_drop_pickup"] = 2;
	level.perk_vulture.clientfields.scriptmovers["vulture_powerup_drop"] = 3;
	level.perk_vulture.clientfields.actors = [];
	level.perk_vulture.clientfields.actors["vulture_stink_trail_fx"] = 0;
	level.perk_vulture.clientfields.actors["vulture_eye_glow"] = 1;
	level.perk_vulture.clientfields.toplayer = [];
	level.perk_vulture.clientfields.toplayer["vulture_perk_active"] = 0;
	registerclientfield("toplayer", "vulture_perk_toplayer", 12000, 1, "int");
	registerclientfield("actor", "vulture_perk_actor", 12000, 2, "int");
	registerclientfield("scriptmover", "vulture_perk_scriptmover", 12000, 4, "int");
	registerclientfield("zbarrier", "vulture_perk_zbarrier", 12000, 1, "int");
	registerclientfield("toplayer", "sndVultureStink", 12000, 1, "int");
	registerclientfield("world", "vulture_perk_disable_solo_quick_revive_glow", 12000, 1, "int");
	registerclientfield("toplayer", "vulture_perk_disease_meter", 12000, 5, "float");
	registerclientfield("toplayer", "vulture_perk_ir", 3000, 1, "int");
	maps\mp\_visionset_mgr::vsmgr_register_info("overlay", "vulture_stink_overlay", 12000, 120, 31, 1);
	maps\mp\zombies\_zm_spawner::add_cusom_zombie_spawn_logic(::vulture_zombie_spawn_func);
	register_zombie_death_event_callback(::zombies_drop_stink_on_death);
	level thread vulture_perk_watch_mystery_box();
	level thread vulture_perk_watch_fire_sale();
	level thread vulture_perk_watch_powerup_drops();
	level thread vulture_handle_solo_quick_revive();
	assert(!isdefined(level.exit_level_func), "vulture perk is attempting to use level.exit_level_func, but one already exists for this level!");
	level.exit_level_func = ::vulture_zombies_find_exit_point;
	level.perk_vulture.invalid_bonus_ammo_weapons = array("time_bomb_zm", "time_bomb_detonator_zm");

	if (!isdefined(level.perk_vulture.func_zombies_find_valid_exit_locations))
	{
		level.perk_vulture.func_zombies_find_valid_exit_locations = ::get_valid_exit_points_for_zombie;
	}

	setup_splitscreen_optimizations();
	initialize_bonus_entity_pool();
	initialize_stink_entity_pool();
}

give_vulture_perk()
{
	vulture_debug_text("player " + self getentitynumber() + " has vulture perk!");

	if (!isdefined(self.perk_vulture))
	{
		self.perk_vulture = spawnstruct();
	}

	self.perk_vulture.active = 1;
	self vulture_vision_toggle(1);
	self vulture_clientfield_toplayer_set("vulture_perk_active");
	self thread vulture_perk_ir_think();
	self thread _vulture_perk_think();
}

take_vulture_perk()
{
	if (isdefined(self.perk_vulture) && (isdefined(self.perk_vulture.active) && self.perk_vulture.active))
	{
		vulture_debug_text("player " + self getentitynumber() + " has lost vulture perk!");
		self.perk_vulture.active = 0;

		if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			self.ignoreme = 0;
		}

		self vulture_vision_toggle(0);
		self vulture_clientfield_toplayer_clear("vulture_perk_active");
		self set_vulture_overlay(0);
		self.vulture_stink_value = 0;
		self setclientfieldtoplayer("vulture_perk_disease_meter", 0);
		self setclientfieldtoplayer("vulture_perk_ir", 0);
		self notify("vulture_perk_lost");
	}
}

vulture_perk_ir_think()
{
	self endon("disconnect");
	self endon("vulture_perk_lost");

	prev_val = 0;

	while (1)
	{
		if (prev_val == 0)
		{
			if (self vulture_perk_ir_is_valid())
			{
				self setclientfieldtoplayer("vulture_perk_ir", 1);
				prev_val = 1;
			}
		}
		else
		{
			if (!self vulture_perk_ir_is_valid())
			{
				self setclientfieldtoplayer("vulture_perk_ir", 0);
				prev_val = 0;
			}
		}

		wait 0.1;
	}
}

vulture_perk_ir_is_valid()
{
	// activating vulture stink filter deactivates vulture ir filter
	if (isdefined(self.vulture_stink_value) && self.vulture_stink_value > 0)
	{
		return 0;
	}

	return 1;
}

_is_player_in_zombie_stink(a_points)
{
	velocity = self getVelocity() * (1, 1, 0);
	speed = length(velocity);

	if (self getStance() == "stand" && speed != 0)
	{
		return 0;
	}

	b_is_in_stink = 0;

	for (i = 0; i < a_points.size; i++)
	{
		if (distancesquared(a_points[i].origin, self.origin) < 4900)
		{
			b_is_in_stink = 1;
		}
	}

	return b_is_in_stink;
}