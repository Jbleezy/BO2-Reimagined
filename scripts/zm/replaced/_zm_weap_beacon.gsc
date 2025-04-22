#include maps\mp\zombies\_zm_weap_beacon;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_audio;

#using_animtree("zombie_beacon");

player_handle_beacon()
{
	self notify("starting_beacon_watch");
	self endon("disconnect");
	self endon("starting_beacon_watch");
	attract_dist_diff = level.beacon_attract_dist_diff;

	if (!isdefined(attract_dist_diff))
	{
		attract_dist_diff = 45;
	}

	num_attractors = level.num_beacon_attractors;

	if (!isdefined(num_attractors))
	{
		num_attractors = 96;
	}

	max_attract_dist = level.beacon_attract_dist;

	if (!isdefined(max_attract_dist))
	{
		max_attract_dist = 1536;
	}

	while (true)
	{
		grenade = get_thrown_beacon();
		self thread player_throw_beacon(grenade, num_attractors, max_attract_dist, attract_dist_diff);
	}
}

player_throw_beacon(grenade, num_attractors, max_attract_dist, attract_dist_diff)
{
	self endon("disconnect");
	self endon("starting_beacon_watch");

	if (isdefined(grenade))
	{
		grenade endon("death");

		if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			if (isdefined(grenade.damagearea))
			{
				grenade.damagearea delete();
			}

			grenade delete();
			return;
		}

		grenade.angles = (0, grenade.angles[1], 0);
		grenade hide();
		model = spawn("script_model", grenade.origin);
		model.angles = grenade.angles;
		model endon("weapon_beacon_timeout");
		model setmodel("t6_wpn_zmb_homing_beacon_world");
		model useanimtree(#animtree);
		model linkto(grenade);
		model thread beacon_cleanup(grenade);
		model.owner = self;
		clone = undefined;

		if (isdefined(level.beacon_dual_view) && level.beacon_dual_view)
		{
			model setvisibletoallexceptteam(level.zombie_team);
			clone = maps\mp\zombies\_zm_clone::spawn_player_clone(self, vectorscale((0, 0, -1), 999.0), level.beacon_clone_weapon, undefined);
			model.simulacrum = clone;
			clone maps\mp\zombies\_zm_clone::clone_animate("idle");
			clone thread clone_player_angles(self);
			clone notsolid();
			clone ghost();
		}

		grenade thread watch_for_dud(model, clone);
		info = spawnstruct();
		info.sound_attractors = [];
		grenade thread monitor_zombie_groans(info);

		grenade waittill("stationary");

		if (isdefined(level.grenade_planted))
		{
			self thread [[level.grenade_planted]](grenade, model);
		}

		if (isdefined(grenade))
		{
			if (isdefined(model))
			{
				model thread weapon_beacon_anims();

				if (!(isdefined(grenade.backlinked) && grenade.backlinked))
				{
					model unlink();
					model.origin = grenade.origin;
					model.angles = grenade.angles;
				}
			}

			if (isdefined(clone))
			{
				clone forceteleport(grenade.origin, grenade.angles);
				clone thread hide_owner(self);
				grenade thread proximity_detonate(self);
				clone show();
				clone setinvisibletoall();
				clone setvisibletoteam(level.zombie_team);
			}

			grenade resetmissiledetonationtime();
			model setclientfield("play_beacon_fx", 1);
			valid_poi = check_point_in_enabled_zone(grenade.origin, undefined, undefined);

			if (isdefined(level.check_valid_poi))
			{
				valid_poi = grenade [[level.check_valid_poi]](valid_poi);
			}

			if (valid_poi)
			{
				grenade create_zombie_point_of_interest(max_attract_dist, num_attractors, 10000);
				grenade.attract_to_origin = 1;
				grenade thread create_zombie_point_of_interest_attractor_positions(4, attract_dist_diff);
				grenade thread wait_for_attractor_positions_complete();
				grenade thread do_beacon_sound(model, info);
				model thread wait_and_explode(grenade);
				model.time_thrown = gettime();

				while (isdefined(level.weapon_beacon_busy) && level.weapon_beacon_busy)
				{
					wait 0.1;
					continue;
				}

				if (flag("three_robot_round") && flag("fire_link_enabled"))
				{
					model thread start_artillery_launch_ee(grenade);
				}
				else
				{
					model thread start_artillery_launch_normal(grenade);
				}

				level.beacons[level.beacons.size] = grenade;
			}
			else
			{
				grenade.script_noteworthy = undefined;
				self thread grenade_stolen_by_sam(grenade, model, clone);
			}
		}
		else
		{
			grenade.script_noteworthy = undefined;
			self thread grenade_stolen_by_sam(grenade, model, clone);
		}
	}
}

grenade_stolen_by_sam(ent_grenade, ent_model, ent_actor)
{
	if (!isdefined(ent_model))
	{
		return;
	}

	direction = ent_model.origin;
	direction = (direction[1], direction[0], 0);

	if (direction[1] < 0 || direction[0] > 0 && direction[1] > 0)
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if (direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}

	self playlocalsound(level.zmb_laugh_alias);

	playfxontag(level._effect["grenade_samantha_steal"], ent_model, "tag_origin");
	ent_model movez(60, 1.0, 0.25, 0.25);
	ent_model vibrate(direction, 1.5, 2.5, 1.0);

	ent_model waittill("movedone");

	if (isdefined(self.damagearea))
	{
		self.damagearea delete();
	}

	ent_model delete();

	if (isdefined(ent_actor))
	{
		ent_actor delete();
	}

	if (isdefined(ent_grenade))
	{
		if (isdefined(ent_grenade.damagearea))
		{
			ent_grenade.damagearea delete();
		}

		ent_grenade delete();
	}
}

artillery_barrage_logic(grenade, b_ee)
{
	if (!isdefined(b_ee))
	{
		b_ee = 0;
	}

	if (isdefined(b_ee) && b_ee)
	{
		a_v_land_offsets = self build_weap_beacon_landing_offsets_ee();
		a_v_start_offsets = self build_weap_beacon_start_offsets_ee();
		n_num_missiles = 15;
		n_clientfield = 2;
	}
	else
	{
		a_v_land_offsets = self build_weap_beacon_landing_offsets();
		a_v_start_offsets = self build_weap_beacon_start_offsets();
		n_num_missiles = 5;
		n_clientfield = 1;
	}

	self.a_v_land_spots = [];
	self.a_v_start_spots = [];

	for (i = 0; i < n_num_missiles; i++)
	{
		self.a_v_start_spots[i] = self.origin + a_v_start_offsets[i];
		self.a_v_land_spots[i] = self.origin + a_v_land_offsets[i];
		v_start_trace = self.a_v_start_spots[i] - vectorscale((0, 0, 1), 5000.0);
		trace = bullettrace(v_start_trace, self.a_v_land_spots[i], 0, undefined);
		self.a_v_land_spots[i] = trace["position"];
		wait 0.05;
	}

	for (i = 0; i < n_num_missiles; i++)
	{
		self setclientfield("play_artillery_barrage", n_clientfield);
		self thread wait_and_do_weapon_beacon_damage(i);
		wait_network_frame();
		self setclientfield("play_artillery_barrage", 0);

		if (i == 0)
		{
			wait 1.0;
			continue;
		}

		wait 0.25;
	}

	level thread allow_beacons_to_be_targeted_by_giant_robot();
	wait 3.0;
	grenade notify("robot_artillery_barrage", self.origin);
}

wait_and_do_weapon_beacon_damage(index)
{
	wait 3.0;
	v_damage_origin = self.a_v_land_spots[index];
	level.n_weap_beacon_zombie_thrown_count = 0;
	a_zombies_to_kill = [];
	a_zombies = getaispeciesarray(level.zombie_team, "all");
	a_zombies = arraycombine(a_zombies, get_players(getotherteam(self.owner.team)), 0, 0);

	foreach (zombie in a_zombies)
	{
		n_distance = distance(zombie.origin, v_damage_origin);

		if (n_distance <= 200)
		{
			a_zombies_to_kill[a_zombies_to_kill.size] = zombie;
		}
	}

	if (index == 0)
	{
		radiusdamage(self.origin + vectorscale((0, 0, 1), 12.0), 10, 1, 1, self.owner, "MOD_GRENADE_SPLASH", "beacon_zm");
		self ghost();
		self stopanimscripted(0);
	}

	level thread weap_beacon_zombie_death(self, a_zombies_to_kill);
	self thread weap_beacon_rumble();
}

weap_beacon_zombie_death(model, a_zombies_to_kill)
{
	for (i = 0; i < a_zombies_to_kill.size; i++)
	{
		zombie = a_zombies_to_kill[i];

		if (!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}

		zombie dodamage(zombie.health, zombie.origin, model.owner, model.owner, "none", "MOD_GRENADE_SPLASH", 0, "beacon_zm");

		if (isplayer(zombie))
		{
			continue;
		}

		zombie thread set_beacon_damage();
		zombie thread weapon_beacon_launch_ragdoll();
	}
}