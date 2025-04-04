#include maps\mp\zm_highrise_elevators;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\zm_highrise_utility;
#include maps\mp\zm_highrise_distance_tracking;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_ai_leaper;

init_elevator_perks()
{
	level.elevator_perks = [];
	level.elevator_perks_building = [];
	level.elevator_perks_building["green"] = [];
	level.elevator_perks_building["blue"] = [];

	level.elevator_perks_building["green"][0] = spawnstruct();
	level.elevator_perks_building["green"][0].model = "zombie_vending_revive";
	level.elevator_perks_building["green"][0].script_noteworthy = "specialty_quickrevive";
	level.elevator_perks_building["green"][0].turn_on_notify = "revive_on";
	level.elevator_perks_building["green"][1] = spawnstruct();
	level.elevator_perks_building["green"][1].model = "p6_zm_vending_chugabud";
	level.elevator_perks_building["green"][1].script_noteworthy = "specialty_finalstand";
	level.elevator_perks_building["green"][1].turn_on_notify = "chugabud_on";
	level.elevator_perks_building["green"][2] = spawnstruct();
	level.elevator_perks_building["green"][2].model = "zombie_vending_sleight";
	level.elevator_perks_building["green"][2].script_noteworthy = "specialty_fastreload";
	level.elevator_perks_building["green"][2].turn_on_notify = "sleight_on";
	level.elevator_perks_building["blue"][0] = spawnstruct();
	level.elevator_perks_building["blue"][0].model = "zombie_vending_three_gun";
	level.elevator_perks_building["blue"][0].script_noteworthy = "specialty_additionalprimaryweapon";
	level.elevator_perks_building["blue"][0].turn_on_notify = "specialty_additionalprimaryweapon_power_on";
	level.elevator_perks_building["blue"][1] = spawnstruct();
	level.elevator_perks_building["blue"][1].model = "zombie_vending_jugg";
	level.elevator_perks_building["blue"][1].script_noteworthy = "specialty_armorvest";
	level.elevator_perks_building["blue"][1].turn_on_notify = "juggernog_on";
	level.elevator_perks_building["blue"][2] = spawnstruct();
	level.elevator_perks_building["blue"][2].model = "zombie_vending_doubletap2";
	level.elevator_perks_building["blue"][2].script_noteworthy = "specialty_rof";
	level.elevator_perks_building["blue"][2].turn_on_notify = "doubletap_on";
	level.elevator_perks_building["blue"][3] = spawnstruct();
	level.elevator_perks_building["blue"][3].model = "p6_anim_zm_buildable_pap";
	level.elevator_perks_building["blue"][3].script_noteworthy = "specialty_weapupgrade";
	level.elevator_perks_building["blue"][3].turn_on_notify = "Pack_A_Punch_on";

	if (!is_gametype_active("zclassic") && getdvar("ui_zm_mapstartlocation") == "green_rooftop")
	{
		temp = level.elevator_perks_building["green"][1];
		level.elevator_perks_building["green"][1] = level.elevator_perks_building["blue"][1];
		level.elevator_perks_building["blue"][1] = temp;
	}

	players_expected = getnumexpectedplayers();
	level.override_perk_targetname = "zm_perk_machine_override";
	level.elevator_perks_building["green"] = array_randomize(level.elevator_perks_building["green"]);
	level.elevator_perks_building["blue"] = array_randomize(level.elevator_perks_building["blue"]);
	level.elevator_perks = arraycombine(level.elevator_perks_building["green"], level.elevator_perks_building["blue"], 0, 0);
	random_perk_structs = [];
	perk_structs = getstructarray("zm_random_machine", "script_noteworthy");

	for (i = 0; i < perk_structs.size; i++)
	{
		random_perk_structs[i] = getstruct(perk_structs[i].target, "targetname");
		random_perk_structs[i].script_parameters = perk_structs[i].script_parameters;
		random_perk_structs[i].script_linkent = getent("elevator_" + perk_structs[i].script_parameters + "_body", "targetname");
	}

	green_structs = [];
	blue_structs = [];

	foreach (perk_struct in random_perk_structs)
	{
		if (isdefined(perk_struct.script_parameters))
		{
			if (issubstr(perk_struct.script_parameters, "bldg1"))
			{
				green_structs[green_structs.size] = perk_struct;
				continue;
			}

			blue_structs[blue_structs.size] = perk_struct;
		}
	}

	green_structs = array_randomize(green_structs);
	blue_structs = array_randomize(blue_structs);
	level.random_perk_structs = green_structs;
	level.random_perk_structs = arraycombine(level.random_perk_structs, blue_structs, 0, 0);

	if (!is_gametype_active("zclassic") && getdvar("ui_zm_mapstartlocation") == "blue_highrise")
	{
		specialty_additionalprimaryweapon_elevator_perks_index = 0;
		bldg3d_random_perk_structs_index = 0;

		for (i = 0; i < level.elevator_perks.size; i++)
		{
			if (level.elevator_perks[i].script_noteworthy == "specialty_additionalprimaryweapon")
			{
				specialty_additionalprimaryweapon_elevator_perks_index = i;
				break;
			}
		}

		for (i = 0; i < level.random_perk_structs.size; i++)
		{
			if (level.random_perk_structs[i].script_parameters == "bldg3d")
			{
				bldg3d_random_perk_structs_index = i;
				break;
			}
		}

		if (specialty_additionalprimaryweapon_elevator_perks_index != bldg3d_random_perk_structs_index)
		{
			level.random_perk_structs = array_swap(level.random_perk_structs, specialty_additionalprimaryweapon_elevator_perks_index, bldg3d_random_perk_structs_index);
		}
	}

	for (i = 0; i < level.elevator_perks.size; i++)
	{
		if (!isdefined(level.random_perk_structs[i]))
		{
			continue;
		}

		level.random_perk_structs[i].targetname = "zm_perk_machine_override";
		level.random_perk_structs[i].model = level.elevator_perks[i].model;
		level.random_perk_structs[i].script_noteworthy = level.elevator_perks[i].script_noteworthy;
		level.random_perk_structs[i].turn_on_notify = level.elevator_perks[i].turn_on_notify;

		if (!isdefined(level.struct_class_names["targetname"]["zm_perk_machine_override"]))
		{
			level.struct_class_names["targetname"]["zm_perk_machine_override"] = [];
		}

		level.struct_class_names["targetname"]["zm_perk_machine_override"][level.struct_class_names["targetname"]["zm_perk_machine_override"].size] = level.random_perk_structs[i];
	}

	static_perk_structs = getstructarray("zm_perk_machine", "targetname");

	foreach (static_perk_struct in static_perk_structs)
	{
		if (static_perk_struct.script_noteworthy == "specialty_longersprint" || static_perk_struct.script_noteworthy == "specialty_flakjacket")
		{
			level.struct_class_names["targetname"]["zm_perk_machine_override"][level.struct_class_names["targetname"]["zm_perk_machine_override"].size] = static_perk_struct;
		}
	}
}

elevator_think(elevator)
{
	current_floor = elevator.body.current_location;
	delaybeforeleaving = 5;
	skipinitialwait = 0;
	speed = 100;
	minwait = 5;
	maxwait = 20;
	flag_wait("perks_ready");

	if (isdefined(elevator.body.force_starting_floor))
	{
		elevator.body.current_level = "" + elevator.body.force_starting_floor;
		elevator.body.origin = elevator.floors[elevator.body.current_level].origin;

		if (isdefined(elevator.body.force_starting_origin_offset))
		{
			elevator.body.origin += (0, 0, elevator.body.force_starting_origin_offset);
		}
	}

	elevator.body.can_move = 1;
	elevator elevator_set_moving(0);
	elevator elevator_enable_paths(elevator.body.current_level);

	flag_wait("power_on");

	elevator.body perkelevatordoor(1);
	next = undefined;

	while (true)
	{
		start_location = 0;

		if (isdefined(elevator.body.force_starting_floor))
		{
			skipinitialwait = 1;
		}

		elevator.body.departing = 1;

		if (!is_true(elevator.body.lock_doors))
		{
			elevator.body setanim(level.perk_elevators_anims[elevator.body.perk_type][1]);
		}

		predict_floor(elevator, next, speed);

		if (!is_true(skipinitialwait))
		{
			elevator_initial_wait(elevator, minwait, maxwait, delaybeforeleaving);

			if (!is_true(elevator.body.lock_doors))
			{
				elevator.body setanim(level.perk_elevators_anims[elevator.body.perk_type][1]);
			}
		}

		if (isdefined(elevator.body.force_starting_floor))
		{
			skipinitialwait = 1;
		}

		next = elevator_next_floor(elevator, next, 0);

		if (isdefined(elevator.floors["" + (next + 1)]))
		{
			elevator.body.next_level = "" + (next + 1);
		}
		else
		{
			start_location = 1;
			elevator.body.next_level = "0";
		}

		floor_stop = elevator.floors[elevator.body.next_level];
		floor_goal = undefined;
		cur_level_start_pos = elevator.floors[elevator.body.next_level].starting_position;
		start_level_start_pos = elevator.floors[elevator.body.starting_floor].starting_position;

		if (elevator.body.next_level == elevator.body.starting_floor || isdefined(cur_level_start_pos) && isdefined(start_level_start_pos) && cur_level_start_pos == start_level_start_pos)
		{
			floor_goal = cur_level_start_pos;
		}
		else
		{
			floor_goal = floor_stop.origin;
		}

		dist = distance(elevator.body.origin, floor_goal);
		time = dist / speed;

		if (dist > 0)
		{
			if (elevator.body.origin[2] > floor_goal[2])
			{
				elevator.dir = "_d";
			}
			else
			{
				elevator.dir = "_u";
			}

			clientnotify(elevator.name + elevator.dir);
		}

		if (is_true(start_location))
		{
			elevator.body thread squashed_death_alarm();

			if (!skipinitialwait)
			{
				elevator.body.start_location_wait = 1;

				elevator.body notify("startwait");
				event = elevator.body waittill_any_timeout(3, "forcego");

				elevator.body.start_location_wait = 0;

				if (event == "forcego")
				{
					next = elevator_next_floor(elevator, next, 0);

					if (isdefined(elevator.floors["" + (next + 1)]))
					{
						elevator.body.next_level = "" + (next + 1);
					}
					else
					{
						start_location = 1;
						elevator.body.next_level = "0";
					}

					floor_stop = elevator.floors[elevator.body.next_level];
					floor_goal = undefined;
					cur_level_start_pos = elevator.floors[elevator.body.next_level].starting_position;
					start_level_start_pos = elevator.floors[elevator.body.starting_floor].starting_position;

					if (elevator.body.next_level == elevator.body.starting_floor || isdefined(cur_level_start_pos) && isdefined(start_level_start_pos) && cur_level_start_pos == start_level_start_pos)
					{
						floor_goal = cur_level_start_pos;
					}
					else
					{
						floor_goal = floor_stop.origin;
					}

					dist = distance(elevator.body.origin, floor_goal);
					time = dist / speed;

					if (dist > 0)
					{
						if (elevator.body.origin[2] > floor_goal[2])
						{
							elevator.dir = "_d";
						}
						else
						{
							elevator.dir = "_u";
						}

						clientnotify(elevator.name + elevator.dir);
					}
				}
			}
		}

		skipinitialwait = 0;
		elevator.body.current_level = elevator.body.next_level;
		elevator notify("floor_changed");
		elevator elevator_disable_paths(elevator.body.current_level);
		elevator.body.departing = 0;
		elevator elevator_set_moving(1);

		if (dist > 0)
		{
			elevator.body moveto(floor_goal, time, time * 0.25, time * 0.25);

			if (isdefined(elevator.body.trig))
			{
				elevator.body thread elev_clean_up_corpses();
			}

			elevator.body thread elevator_move_sound();
			elevator.body waittill_any("movedone", "forcego");
		}

		elevator elevator_set_moving(0);
		elevator elevator_enable_paths(elevator.body.current_level);
	}
}

predict_floor(elevator, next, speed)
{
	next = elevator_next_floor(elevator, next, 1);

	if (isdefined(elevator.floors["" + (next + 1)]))
	{
		elevator.body.next_level = "" + (next + 1);
	}
	else
	{
		start_location = 1;
		elevator.body.next_level = "0";
	}

	floor_stop = elevator.floors[elevator.body.next_level];
	floor_goal = undefined;
	cur_level_start_pos = elevator.floors[elevator.body.next_level].starting_position;
	start_level_start_pos = elevator.floors[elevator.body.starting_floor].starting_position;

	if (elevator.body.next_level == elevator.body.starting_floor || isdefined(cur_level_start_pos) && isdefined(start_level_start_pos) && cur_level_start_pos == start_level_start_pos)
	{
		floor_goal = cur_level_start_pos;
	}
	else
	{
		floor_goal = floor_stop.origin;
	}

	dist = distance(elevator.body.origin, floor_goal);
	time = dist / speed;

	if (dist > 0)
	{
		if (elevator.body.origin[2] > floor_goal[2])
		{
			elevator.dir = "_d";
		}
		else
		{
			elevator.dir = "_u";
		}

		clientnotify(elevator.name + elevator.dir);
	}
}

elevator_next_floor(elevator, last, justchecking)
{
	if (isdefined(elevator.body.force_starting_floor))
	{
		floor = elevator.body.force_starting_floor;

		if (!justchecking)
		{
			elevator.body.force_starting_floor = undefined;
		}

		return floor;
	}

	if (!isdefined(last))
	{
		return 0;
	}

	min_floor = 0;
	max_floor = elevator.floors.size - 1;

	if (!is_gametype_active("zclassic"))
	{
		if (getdvar("ui_zm_mapstartlocation") == "blue_rooftop")
		{
			if (elevator.name == "3" || elevator.name == "3b")
			{
				min_floor = 4;
			}
			else if (elevator.name == "3c")
			{
				min_floor = 3;
			}
		}
		else if (getdvar("ui_zm_mapstartlocation") == "blue_highrise")
		{
			if (elevator.name == "3" || elevator.name == "3b")
			{
				min_floor = 1;
				max_floor = 3;
			}
			else if (elevator.name == "3c")
			{
				max_floor = 2;
			}
		}
	}

	if (last + 1 <= max_floor)
	{
		return last + 1;
	}

	return min_floor;
}

elevator_initial_wait(elevator, minwait, maxwait, delaybeforeleaving)
{
	elevator.body endon("forcego");
	elevator.body waittill_any_or_timeout(randomintrange(minwait, maxwait), "depart_early");

	if (!is_true(elevator.body.lock_doors) && !is_true(elevator.body.elevator_stop))
	{
		elevator.body setanim(level.perk_elevators_anims[elevator.body.perk_type][0]);
	}

	if (!is_true(elevator.body.departing_early))
	{
		wait(delaybeforeleaving);
	}

	if (elevator.body.perk_type == "specialty_weapupgrade")
	{
		while (flag("pack_machine_in_use"))
		{
			wait 0.5;
		}

		wait(randomintrange(1, 3));
	}

	while (isdefined(level.elevators_stop) && level.elevators_stop || isdefined(elevator.body.elevator_stop) && elevator.body.elevator_stop)
	{
		wait 0.05;
	}
}

elevator_move_sound()
{
	self playsound("zmb_elevator_ding");

	wait 0.4;

	if (!is_true(self.is_moving))
	{
		return;
	}

	self playsound("zmb_elevator_ding");
	self playsound("zmb_elevator_run_start");
	self playloopsound("zmb_elevator_run", 0.5);

	self waittill("movedone");

	self stoploopsound(0.5);
	self playsound("zmb_elevator_run_stop");
	self playsound("zmb_elevator_ding");
}

elevator_roof_watcher()
{
	level endon("end_game");

	while (true)
	{
		self.trig waittill("trigger", who);

		if (isdefined(who) && isplayer(who))
		{
			while (isdefined(who) && who istouching(self.trig))
			{
				if (self.is_moving)
				{
					self waittill_any("movedone", "forcego");
				}

				if (self.current_level == "0")
				{
					break; // don't make climber at top level
				}

				zombies = getaiarray(level.zombie_team);

				if (isdefined(zombies) && zombies.size > 0)
				{
					foreach (zombie in zombies)
					{
						climber = zombie zombie_for_elevator_unseen();

						if (isdefined(climber))
						{
							continue;
						}
					}

					if (isdefined(climber))
					{
						zombie zombie_climb_elevator(self);
						wait(randomint(30));
					}
				}

				wait 0.5;
			}
		}

		wait 0.5;
	}
}

faller_location_logic()
{
	wait 1;
	faller_spawn_points = getstructarray("faller_location", "script_noteworthy");
	leaper_spawn_points = getstructarray("leaper_location", "script_noteworthy");
	spawn_points = arraycombine(faller_spawn_points, leaper_spawn_points, 1, 0);
	dist_check = 16384;
	elevator_names = getarraykeys(level.elevators);
	elevators = [];

	for (i = 0; i < elevator_names.size; i++)
	{
		elevators[i] = getent("elevator_" + elevator_names[i] + "_body", "targetname");
	}

	elevator_volumes = [];
	elevator_volumes[elevator_volumes.size] = getent("elevator_1b", "targetname");
	elevator_volumes[elevator_volumes.size] = getent("elevator_1c", "targetname");
	elevator_volumes[elevator_volumes.size] = getent("elevator_1d", "targetname");
	elevator_volumes[elevator_volumes.size] = getent("elevator_3a", "targetname");
	elevator_volumes[elevator_volumes.size] = getent("elevator_3b", "targetname");
	elevator_volumes[elevator_volumes.size] = getent("elevator_3c", "targetname");
	elevator_volumes[elevator_volumes.size] = getent("elevator_3d", "targetname");
	level.elevator_volumes = elevator_volumes;

	while (true)
	{
		foreach (point in spawn_points)
		{
			should_block = 0;

			foreach (elevator in elevators)
			{
				if (distancesquared(elevator getCentroid(), point.origin) <= dist_check)
				{
					should_block = 1;
				}
			}

			if (should_block)
			{
				point.is_enabled = 0;
				point.is_blocked = 1;
				continue;
			}

			if (isdefined(point.is_blocked) && point.is_blocked)
			{
				point.is_blocked = 0;
			}

			if (!isdefined(point.zone_name))
			{
				continue;
			}

			zone = level.zones[point.zone_name];

			if (zone.is_enabled && zone.is_active && zone.is_spawning_allowed)
			{
				point.is_enabled = 1;
			}
		}

		players = get_players();

		foreach (volume in elevator_volumes)
		{
			should_disable = 0;

			foreach (player in players)
			{
				if (is_player_valid(player))
				{
					if (player istouching(volume))
					{
						should_disable = 1;
					}
				}
			}

			if (should_disable)
			{
				disable_elevator_spawners(volume, spawn_points);
			}
		}

		wait 0.05;
	}
}

watch_for_elevator_during_faller_spawn()
{
	self endon("death");
	self endon("risen");
	self endon("spawn_anim");

	flag_wait("power_on");

	elevator_bodies = [];

	foreach (elevator in level.elevators)
	{
		elevator_bodies[elevator_bodies.size] = elevator.body;
	}

	elevator_body = get_closest_2d(self.zombie_faller_location.origin, elevator_bodies);

	while (true)
	{
		should_gib = 0;

		if (is_true(elevator_body.is_moving))
		{
			if (self istouching(elevator_body))
			{
				should_gib = 1;
			}
		}
		else
		{
			if (isdefined(self.zombie_faller_location) && is_true(self.zombie_faller_location.is_blocked))
			{
				should_gib = 1;
			}
		}

		if (should_gib)
		{
			playfx(level._effect["zomb_gib"], self.origin);

			if (isdefined(self.is_leaper) && self.is_leaper)
			{
				self maps\mp\zombies\_zm_ai_leaper::leaper_cleanup();
				self dodamage(self.health + 100, self.origin);
			}
			else
			{
				self delete();
			}

			break;
		}

		wait 0.05;
	}
}