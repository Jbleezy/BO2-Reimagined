#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_clone;

#using_animtree("zombie_cymbal_monkey");

init()
{
	if (!cymbal_monkey_exists())
	{
		return;
	}

	level.cymbal_monkey_model = "t6_wpn_zmb_monkey_bomb_world";

	level._effect["monkey_glow"] = loadfx("maps/zombie/fx_zombie_monkey_light");
	level._effect["grenade_samantha_steal"] = loadfx("maps/zombie/fx_zmb_blackhole_trap_end");
	level.cymbal_monkeys = [];
	scriptmodelsuseanimtree(#animtree);
}

player_handle_cymbal_monkey()
{
	self notify("starting_monkey_watch");
	self endon("disconnect");
	self endon("starting_monkey_watch");
	attract_dist_diff = level.monkey_attract_dist_diff;

	if (!isdefined(attract_dist_diff))
	{
		attract_dist_diff = 45;
	}

	num_attractors = level.num_monkey_attractors;

	if (!isdefined(num_attractors))
	{
		num_attractors = 96;
	}

	max_attract_dist = level.monkey_attract_dist;

	if (!isdefined(max_attract_dist))
	{
		max_attract_dist = 1536;
	}

	while (true)
	{
		grenade = get_thrown_monkey();
		self thread player_throw_cymbal_monkey(grenade, num_attractors, max_attract_dist, attract_dist_diff);
	}
}

player_throw_cymbal_monkey(grenade, num_attractors, max_attract_dist, attract_dist_diff)
{
	self endon("disconnect");
	self endon("starting_monkey_watch");

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
		model setmodel(level.cymbal_monkey_model);
		model useanimtree(#animtree);
		model linkto(grenade);
		model thread monkey_cleanup(grenade);
		clone = undefined;

		if (isdefined(level.cymbal_monkey_dual_view) && level.cymbal_monkey_dual_view)
		{
			model setvisibletoallexceptteam(level.zombie_team);
			clone = maps\mp\zombies\_zm_clone::spawn_player_clone(self, vectorscale((0, 0, -1), 999.0), level.cymbal_monkey_clone_weapon, undefined);
			model.simulacrum = clone;
			clone maps\mp\zombies\_zm_clone::clone_animate("idle");
			clone thread clone_player_angles(self);
			clone notsolid();
			clone ghost();
		}

		grenade thread watch_for_dud(model, clone);
		grenade thread watch_for_emp(model, clone);
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
				model setanim(%o_monkey_bomb);

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
			playfxontag(level._effect["monkey_glow"], model, "origin_animate_jnt");
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
				grenade thread do_monkey_sound(model, info);
				level.cymbal_monkeys[level.cymbal_monkeys.size] = grenade;
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