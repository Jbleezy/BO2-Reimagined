#include maps\mp\zombies\_zm_weap_jetgun;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

watch_overheat()
{
	self endon("death_or_disconnect");
	self endon("weapon_change");

	overheating_count = 0;

	while (true)
	{
		if (self getcurrentweapon() == "jetgun_zm")
		{
			overheating = self isweaponoverheating(0);
			heat = self isweaponoverheating(1);
			self.jetgun_overheating = overheating;
			self.jetgun_heatval = heat;

			if (overheating && heat >= 100 && self attackbuttonpressed() && !self isswitchingweapons())
			{
				if (overheating_count >= 30)
				{
					self notify("jgun_overheat_snd_end");
					self luinotifyevent(&"hud_update_overheat");
					self notify("jetgun_overheated");
				}
				else
				{
					if (overheating_count == 0)
					{
						if (!isdefined(self.jetsound_overheat_ent))
						{
							self.jetsound_overheat_ent = spawn("script_origin", self.origin);
							self.jetsound_overheat_ent linkto(self, "tag_origin");
							self thread sound_overheat_ent_cleanup();
						}

						self.jetsound_overheat_time = gettime();
						self.jetsound_overheat_ent playloopsound("wpn_jetgun_alarm");
						self luinotifyevent(&"hud_update_overheat", 2, 1, 100);
					}

					self setweaponoverheating(0, 99.9);
				}

				overheating_count++;
			}
			else if (overheating_count > 0)
			{
				self notify("jgun_overheat_snd_end");
				self luinotifyevent(&"hud_update_overheat");
				self setweaponoverheating(1, 100);
				overheating_count = 0;
			}

			if (overheating)
			{
				self thread play_overheat_fx();
			}
		}

		wait 0.05;
	}
}

sound_overheat_ent_cleanup()
{
	self waittill_any("jgun_overheat_snd_end", "disconnect");

	jetsound_overheat_ent = self.jetsound_overheat_ent;
	jetsound_overheat_time = self.jetsound_overheat_time;

	if (isdefined(jetsound_overheat_time))
	{
		stop_times = array(350, 750, 1150, 1550);

		while (1)
		{
			time = gettime() - jetsound_overheat_time;

			if (isinarray(stop_times, time) || time > stop_times[stop_times.size - 1])
			{
				break;
			}

			wait 0.05;
		}
	}

	if (isdefined(jetsound_overheat_ent))
	{
		jetsound_overheat_ent stoploopsound();
		jetsound_overheat_ent delete();
	}
}

jetgun_firing()
{
	if (!isdefined(self.jetsound_ent))
	{
		self.jetsound_ent = spawn("script_origin", self.origin);
		self.jetsound_ent linkto(self, "tag_origin");
	}

	jetgun_fired = 0;

	if (self is_jetgun_firing() && jetgun_fired == 0)
	{
		self thread try_pull_powerups();
		self.jetsound_ent playloopsound("wpn_jetgun_effect_plr_loop", 0.8);
		self.jetsound_ent playsound("wpn_jetgun_effect_plr_start");
		self thread sound_ent_cleanup();
	}

	while (self is_jetgun_firing())
	{
		jetgun_fired = 1;
		self thread jetgun_fired();
		view_pos = self gettagorigin("tag_flash");
		view_angles = self gettagangles("tag_flash");

		if (self get_jetgun_engine_direction() < 0)
		{
			playfx(level._effect["jetgun_smoke_cloud"], view_pos - self getplayerviewheight(), anglestoforward(view_angles), anglestoup(view_angles));
		}
		else
		{
			playfx(level._effect["jetgun_smoke_cloud"], view_pos - self getplayerviewheight(), anglestoforward(view_angles) * -1, anglestoup(view_angles));
		}

		wait 0.25;
	}

	if (jetgun_fired == 1)
	{
		self notify("stop_try_pull_powerups");
		self.jetsound_ent stoploopsound(0.5);
		self.jetsound_ent playsound("wpn_jetgun_effect_plr_end");
		self notify("jgun_snd_end");
		jetgun_fired = 0;
	}
}

sound_ent_cleanup()
{
	self notify("sound_ent_cleanup");
	self endon("sound_ent_cleanup");

	self waittill_any("jgun_snd_end", "disconnect");

	jetsound_ent = self.jetsound_ent;

	wait 4;

	if (isdefined(jetsound_ent))
	{
		jetsound_ent delete();
	}
}

is_jetgun_firing()
{
	if (!self attackButtonPressed())
	{
		return 0;
	}

	return abs(self get_jetgun_engine_direction()) > 0.2;
}

jetgun_fired()
{
	if (!self is_jetgun_firing())
	{
		return;
	}

	origin = self getweaponmuzzlepoint();
	physicsjetthrust(origin, self getweaponforwarddir() * -1, level.zombie_vars["jetgun_grind_range"], self get_jetgun_engine_direction(), 0.85);

	if (!isdefined(level.jetgun_knockdown_enemies))
	{
		level.jetgun_knockdown_enemies = [];
		level.jetgun_knockdown_gib = [];
		level.jetgun_drag_enemies = [];
		level.jetgun_fling_enemies = [];
		level.jetgun_grind_enemies = [];
	}

	self jetgun_get_enemies_in_range(self get_jetgun_engine_direction());
	level.jetgun_network_choke_count = 0;

	foreach (index, zombie in level.jetgun_fling_enemies)
	{
		jetgun_network_choke();

		if (isdefined(zombie))
		{
			zombie thread jetgun_fling_zombie(self, index);
		}
	}

	foreach (zombie in level.jetgun_drag_enemies)
	{
		jetgun_network_choke();

		if (isdefined(zombie))
		{
			zombie.jetgun_owner = self;
			zombie thread jetgun_drag_zombie(origin, -1 * self get_jetgun_engine_direction());
		}
	}

	level.jetgun_knockdown_enemies = [];
	level.jetgun_knockdown_gib = [];
	level.jetgun_drag_enemies = [];
	level.jetgun_fling_enemies = [];
	level.jetgun_grind_enemies = [];
}

try_pull_powerups()
{
	self endon("disconnect");
	self endon("stop_try_pull_powerups");

	while (1)
	{
		if (!self is_jetgun_firing())
		{
			wait 0.05;
			continue;
		}

		powerup_move_dist = level.zombie_vars["powerup_move_dist"] * -1 * self get_jetgun_engine_direction();
		powerup_range_squared = level.zombie_vars["powerup_drag_range"] * level.zombie_vars["powerup_drag_range"];
		view_pos = self getweaponmuzzlepoint();
		forward_view_angles = self getweaponforwarddir();
		powerups = maps\mp\zombies\_zm_powerups::get_powerups();

		foreach (powerup in powerups)
		{
			if (distancesquared(view_pos, powerup.origin) > powerup_range_squared)
			{
				continue;
			}

			normal = vectornormalize(powerup.origin - view_pos);
			dot = vectordot(forward_view_angles, normal);

			if (abs(dot) < 0.7)
			{
				continue;
			}

			powerup notify("move_powerup", view_pos, powerup_move_dist);
		}

		wait 0.05;
	}
}

jetgun_get_enemies_in_range(invert)
{
	view_pos = self getweaponmuzzlepoint();
	zombies = get_array_of_closest(view_pos, get_round_enemy_array(), undefined, undefined, level.zombie_vars["jetgun_drag_range"]);

	knockdown_range_squared = level.zombie_vars["jetgun_knockdown_range"] * level.zombie_vars["jetgun_knockdown_range"];
	drag_range_squared = level.zombie_vars["jetgun_drag_range"] * level.zombie_vars["jetgun_drag_range"];
	gib_range_squared = level.zombie_vars["jetgun_gib_range"] * level.zombie_vars["jetgun_gib_range"];
	grind_range_squared = level.zombie_vars["jetgun_grind_range"] * level.zombie_vars["jetgun_grind_range"];
	cylinder_radius_squared = level.zombie_vars["jetgun_cylinder_radius"] * level.zombie_vars["jetgun_cylinder_radius"];
	forward_view_angles = self getweaponforwarddir();
	end_pos = view_pos + vectorscale(forward_view_angles, level.zombie_vars["jetgun_knockdown_range"]);

	for (i = 0; i < zombies.size; i++)
	{
		self jetgun_check_enemies_in_range(zombies[i], view_pos, drag_range_squared, gib_range_squared, grind_range_squared, cylinder_radius_squared, forward_view_angles, end_pos, invert);
	}
}

jetgun_check_enemies_in_range(zombie, view_pos, drag_range_squared, gib_range_squared, grind_range_squared, cylinder_radius_squared, forward_view_angles, end_pos, invert)
{
	if (!isDefined(zombie))
	{
		return;
	}

	if (zombie enemy_killed_by_jetgun())
	{
		return;
	}

	if (isDefined(zombie.is_avogadro) && zombie.is_avogadro)
	{
		return;
	}

	if (isDefined(zombie.isdog) && zombie.isdog)
	{
		return;
	}

	if (isDefined(zombie.isscreecher) && zombie.isscreecher)
	{
		return;
	}

	if (isDefined(self.animname) && self.animname == "quad_zombie")
	{
		return;
	}

	test_origin = zombie getcentroid();
	test_range_squared = distancesquared(view_pos, test_origin);

	if (test_range_squared > drag_range_squared)
	{
		zombie jetgun_debug_print("range", (1, 0, 1));
		return;
	}

	normal = vectornormalize(test_origin - view_pos);
	dot = vectordot(forward_view_angles, normal);

	if (abs(dot) < 0.7)
	{
		zombie jetgun_debug_print("dot", (1, 0, 1));
		return;
	}

	radial_origin = pointonsegmentnearesttopoint(view_pos, end_pos, test_origin);

	if (distancesquared(test_origin, radial_origin) > cylinder_radius_squared)
	{
		zombie jetgun_debug_print("cylinder", (1, 0, 1));
		return;
	}

	if (zombie damageconetrace(view_pos, self) == 0)
	{
		zombie jetgun_debug_print("cone", (1, 0, 1));
		return;
	}

	if (test_range_squared < grind_range_squared)
	{
		level.jetgun_fling_enemies[level.jetgun_fling_enemies.size] = zombie;
		level.jetgun_grind_enemies[level.jetgun_grind_enemies.size] = dot < 0;
	}
	else if (test_range_squared < drag_range_squared && dot > 0)
	{
		if (!is_true(zombie.completed_emerging_into_playable_area) && !isdefined(zombie.first_node))
		{
			return;
		}

		if (is_true(zombie.barricade_enter))
		{
			return;
		}

		if (is_true(zombie.in_the_ground))
		{
			return;
		}

		if (is_true(self.isonbus) && is_true(level.the_bus.ismoving) && (!isdefined(zombie.ai_state) || zombie.ai_state != "zombieMoveOnBus"))
		{
			return;
		}

		level.jetgun_drag_enemies[level.jetgun_drag_enemies.size] = zombie;
	}
}

zombie_enter_drag_state(vdir, speed)
{
	self.drag_state = 1;
	self.jetgun_drag_state = "unaffected";
	self.was_traversing = isdefined(self.is_traversing) && self.is_traversing;
	self.favoriteenemy = self.jetgun_owner;
	self.ignoreall = 1;
	self notify("stop_zombie_goto_entrance");
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self setplayercollision(0);
	self zombie_keep_in_drag_state(vdir, speed);
	self.zombie_move_speed_pre_jetgun_drag = self.zombie_move_speed;
}

zombie_drag_think()
{
	self endon("death");
	self endon("flinging");
	self endon("grinding");

	while (self zombie_should_stay_in_drag_state())
	{
		if (!is_true(self.completed_emerging_into_playable_area))
		{
			self.goalradius = 128;
			self setgoalpos(self.first_node.origin);
		}
		else if (!is_true(self.isonbus) && is_true(self.jetgun_owner.isonbus) && (is_true(level.the_bus.doorsclosed) || is_true(self.jetgun_owner.isonbusroof)))
		{
			self.goalradius = 2;
			self setgoalpos(self maps\mp\zm_transit_bus::busgetclosestopening());
		}
		else if (!isdefined(self.ai_state) || self.ai_state != "zombieMoveOnBus")
		{
			self.goalradius = 32;
			self setgoalpos(self.jetgun_owner.origin);
		}

		self._distance_to_jetgun_owner = distancesquared(self.origin, self.jetgun_owner.origin);
		jetgun_network_choke();

		if (self.zombie_move_speed == "sprint" || self._distance_to_jetgun_owner < level.jetgun_pulled_in_range)
		{
			self jetgun_drag_set("jetgun_sprint", "jetgun_walk_fast_crawl");
		}
		else if (self._distance_to_jetgun_owner < level.jetgun_pulling_in_range)
		{
			self jetgun_drag_set("jetgun_walk_fast", "jetgun_walk_fast");
		}
		else if (self._distance_to_jetgun_owner < level.jetgun_inner_range)
		{
			self jetgun_drag_set("jetgun_walk", "jetgun_walk_slow_crawl");
		}
		else if (self._distance_to_jetgun_owner < level.jetgun_outer_edge)
		{
			self jetgun_drag_set("jetgun_walk_slow", "jetgun_walk_slow_crawl");
		}

		wait 0.1;
	}

	self thread zombie_exit_drag_state();
}

zombie_exit_drag_state()
{
	self notify("jetgun_end_drag_state");
	self.drag_state = 0;
	self.jetgun_drag_state = "unaffected";
	self.needs_run_update = 1;
	self.ignoreall = 0;
	self setplayercollision(1);

	if (isdefined(self.zombie_move_speed_pre_jetgun_drag))
	{
		self set_zombie_run_cycle(self.zombie_move_speed_pre_jetgun_drag);
		self.zombie_move_speed_pre_jetgun_drag = undefined;
	}
	else
	{
		self set_zombie_run_cycle();
	}

	if (!is_true(self.completed_emerging_into_playable_area))
	{
		assert(isdefined(self.first_node));
		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self thread maps\mp\zombies\_zm_spawner::zombie_goto_entrance(self.first_node);
	}
	else if (!isdefined(self.ai_state) || self.ai_state != "zombieMoveOnBus")
	{
		self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
	}
}

jetgun_grind_zombie(player)
{
	player endon("death");
	player endon("disconnect");
	self endon("death");

	if (!isDefined(self.jetgun_grind))
	{
		self.jetgun_grind = 1;
		self notify("grinding");

		if (is_mature())
		{
			if (isDefined(level._effect["zombie_guts_explosion"]))
			{
				playfx(level._effect["zombie_guts_explosion"], self gettagorigin("J_SpineLower"));
			}
		}

		self.nodeathragdoll = 1;
		self.handle_death_notetracks = ::jetgun_handle_death_notetracks;
		player maps\mp\zombies\_zm_score::add_to_player_score(50 * maps\mp\zombies\_zm_score::get_points_multiplier(player));
		self dodamage(self.health + 666, player.origin, player);
	}
}

handle_overheated_jetgun()
{
	self endon("disconnect");

	while (1)
	{
		self waittill("jetgun_overheated");

		if (self getcurrentweapon() == "jetgun_zm")
		{
			weapon_org = self gettagorigin("tag_weapon");

			if (isDefined(level.explode_overheated_jetgun) && level.explode_overheated_jetgun)
			{
				self thread maps\mp\zombies\_zm_equipment::equipment_release("jetgun_zm");
				pcount = get_players().size;
				pickup_time = 360 / pcount;
				maps\mp\zombies\_zm_buildables::player_explode_buildable("jetgun_zm", weapon_org, 250, 1, pickup_time);
			}
			else if (isDefined(level.unbuild_overheated_jetgun) && level.unbuild_overheated_jetgun)
			{
				self thread maps\mp\zombies\_zm_equipment::equipment_release("jetgun_zm");
				maps\mp\zombies\_zm_buildables::unbuild_buildable("jetgun_zm", 1);
				self dodamage(50, weapon_org, self, self, "none", "MOD_GRENADE_SPLASH");
			}
			else if (isDefined(level.take_overheated_jetgun) && level.take_overheated_jetgun)
			{
				self thread maps\mp\zombies\_zm_equipment::equipment_release("jetgun_zm");
				self dodamage(50, weapon_org, self, self, "none", "MOD_GRENADE_SPLASH");
			}
			else
			{
				continue;
			}

			self.jetgun_overheating = undefined;
			self.jetgun_heatval = undefined;
			self playsound("wpn_jetgun_explo");
		}
	}
}

jetgun_network_choke()
{
	// no choke
}