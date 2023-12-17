#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;

init_player_offhand_weapons()
{
	if (!is_true(self.init_player_offhand_weapons_override))
	{
		if (is_gametype_active("zgrief") && is_true(self.player_initialized))
		{
			return;
		}
	}

	init_player_lethal_grenade();
	init_player_tactical_grenade();
	init_player_placeable_mine();
	init_player_melee_weapon();
	init_player_equipment();
}

is_headshot(sweapon, shitloc, smeansofdeath)
{
	if (smeansofdeath == "MOD_MELEE" || smeansofdeath == "MOD_BAYONET" || smeansofdeath == "MOD_IMPACT" || smeansofdeath == "MOD_UNKNOWN" || smeansofdeath == "MOD_IMPACT")
	{
		return 0;
	}

	if (shitloc == "head" || shitloc == "helmet" || sHitLoc == "neck")
	{
		return 1;
	}

	return 0;
}

shock_onpain()
{
	self endon("death");
	self endon("disconnect");
	self notify("stop_shock_onpain");
	self endon("stop_shock_onpain");

	if (getdvar("blurpain") == "")
		setdvar("blurpain", "on");

	while (true)
	{
		oldhealth = self.health;

		self waittill("damage", damage, attacker, direction_vec, point, mod);

		if (isdefined(level.shock_onpain) && !level.shock_onpain)
			continue;

		if (isdefined(self.shock_onpain) && !self.shock_onpain)
			continue;

		if (self.health < 1)
			continue;

		if (mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GRENADE" || mod == "MOD_EXPLOSIVE")
		{
			if (is_true(self.is_burning))
			{
				self shock_onexplosion(damage, "lava", "lava_small");
			}
			else if (mod == "MOD_EXPLOSIVE")
			{
				self shock_onexplosion(damage);
			}
			else
			{
				self shellshock("pain", 0.5);
			}
		}
		else if (getdvar("blurpain") == "on")
		{
			self shellshock("pain", 0.5);
		}
	}
}

create_zombie_point_of_interest_attractor_positions(num_attract_dists, diff_per_dist, attractor_width)
{
	self endon("death");
	forward = (0, 1, 0);

	if (!isDefined(self.num_poi_attracts) || isDefined(self.script_noteworthy) && self.script_noteworthy != "zombie_poi")
	{
		return;
	}

	if (!isDefined(num_attract_dists))
	{
		num_attract_dists = 4;
	}

	if (!isDefined(diff_per_dist))
	{
		diff_per_dist = 45;
	}

	if (!isDefined(attractor_width))
	{
		attractor_width = 45;
	}

	self.attract_to_origin = 0;
	self.num_attract_dists = num_attract_dists;
	self.last_index = [];

	for (i = 0; i < num_attract_dists; i++)
	{
		self.last_index[i] = -1;
	}

	self.attract_dists = [];

	for (i = 0; i < self.num_attract_dists; i++)
	{
		self.attract_dists[i] = diff_per_dist * (i + 1);
	}

	max_positions = [];

	for (i = 0; i < self.num_attract_dists; i++)
	{
		max_positions[i] = int((6.28 * self.attract_dists[i]) / attractor_width);
	}

	num_attracts_per_dist = self.num_poi_attracts / self.num_attract_dists;
	self.max_attractor_dist = self.attract_dists[self.attract_dists.size - 1] * 1.1;
	diff = 0;
	actual_num_positions = [];
	i = 0;

	while (i < self.num_attract_dists)
	{
		if (num_attracts_per_dist > (max_positions[i] + diff))
		{
			actual_num_positions[i] = max_positions[i];
			diff += num_attracts_per_dist - max_positions[i];
			i++;
			continue;
		}

		actual_num_positions[i] = num_attracts_per_dist + diff;
		diff = 0;
		i++;
	}

	self.attractor_positions = [];
	failed = 0;
	angle_offset = 0;
	prev_last_index = -1;

	for (j = 0; j < 4; j++)
	{
		if ((actual_num_positions[j] + failed) < max_positions[j])
		{
			actual_num_positions[j] += failed;
			failed = 0;
		}
		else if (actual_num_positions[j] < max_positions[j])
		{
			actual_num_positions[j] = max_positions[j];
			failed = max_positions[j] - actual_num_positions[j];
		}

		failed += self generated_radius_attract_positions(forward, angle_offset, actual_num_positions[j], self.attract_dists[j]);
		angle_offset += 15;
		self.last_index[j] = int((actual_num_positions[j] - failed) + prev_last_index);
		prev_last_index = self.last_index[j];

		self notify("attractor_positions_generated");
		level notify("attractor_positions_generated");
	}
}

check_point_in_life_brush(origin)
{
	life_brushes = getentarray("life_brush", "script_noteworthy");

	if (!isdefined(life_brushes))
		return false;

	check_model = spawn("script_model", origin + vectorscale((0, 0, 1), 40.0));
	valid_point = 0;

	for (i = 0; i < life_brushes.size; i++)
	{
		if (check_model istouching(life_brushes[i]))
		{
			valid_point = 1;
			break;
		}
	}

	check_model delete();
	return valid_point;
}

check_point_in_kill_brush(origin)
{
	kill_brushes = getentarray("kill_brush", "script_noteworthy");

	if (!isdefined(kill_brushes))
		return false;

	check_model = spawn("script_model", origin + vectorscale((0, 0, 1), 40.0));
	valid_point = 0;

	for (i = 0; i < kill_brushes.size; i++)
	{
		if (check_model istouching(kill_brushes[i]))
		{
			valid_point = 1;
			break;
		}
	}

	check_model delete();
	return valid_point;
}

get_current_zone(return_zone)
{
	flag_wait("zones_initialized");

	if (isDefined(self.prev_zone))
	{
		for (i = 0; i < self.prev_zone.volumes.size; i++)
		{
			if (self istouching(self.prev_zone.volumes[i]))
			{
				if (isdefined(return_zone) && return_zone)
				{
					return self.prev_zone;
				}

				return self.prev_zone_name;
			}
		}
	}

	for (z = 0; z < level.zone_keys.size; z++)
	{
		zone_name = level.zone_keys[z];
		zone = level.zones[zone_name];

		for (i = 0; i < zone.volumes.size; i++)
		{
			if (self istouching(zone.volumes[i]))
			{
				self.prev_zone = zone;
				self.prev_zone_name = zone_name;

				if (isdefined(return_zone) && return_zone)
				{
					return zone;
				}

				return zone_name;
			}
		}
	}

	self.prev_zone = undefined;
	self.prev_zone_name = undefined;

	return undefined;
}

is_temporary_zombie_weapon(str_weapon)
{
	if (isdefined(level.machine_assets["packapunch"]) && isdefined(level.machine_assets["packapunch"].weapon) && str_weapon == level.machine_assets["packapunch"].weapon)
	{
		return 1;
	}

	return is_zombie_perk_bottle(str_weapon) || str_weapon == level.revive_tool || str_weapon == "zombie_builder_zm" || str_weapon == "chalk_draw_zm" || str_weapon == "no_hands_zm" || issubstr(str_weapon, "_flourish");
}

wait_network_frame()
{
	wait 0.1;
}

track_players_intersection_tracker()
{
	// BO2 has built in push mechanic
}