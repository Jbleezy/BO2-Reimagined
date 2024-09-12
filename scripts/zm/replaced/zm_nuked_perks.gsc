#include maps\mp\zm_nuked_perks;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_game_module;

init_nuked_perks()
{
	level.perk_arrival_vehicle = getent("perk_arrival_vehicle", "targetname");
	level.perk_arrival_vehicle setmodel("tag_origin");

	level.grief_perk_arrival_vehicles = getentarray("grief_perk_arrival_vehicle", "targetname");
	level.grief_perk_arrival_vehicles_ind = 0;

	foreach (grief_perk_arrival_vehicle in level.grief_perk_arrival_vehicles)
	{
		grief_perk_arrival_vehicle setmodel("tag_origin");
	}

	flag_init("perk_vehicle_bringing_in_perk");
	structs = getstructarray("zm_perk_machine", "targetname");

	for (i = 0; i < structs.size; i++)
	{
		structs[i] structdelete();
	}

	level.nuked_perks = [];
	level.nuked_perks[0] = spawnstruct();
	level.nuked_perks[0].model = "zombie_vending_revive";
	level.nuked_perks[0].script_noteworthy = "specialty_quickrevive";
	level.nuked_perks[0].turn_on_notify = "revive_on";
	level.nuked_perks[1] = spawnstruct();
	level.nuked_perks[1].model = "zombie_vending_sleight";
	level.nuked_perks[1].script_noteworthy = "specialty_fastreload";
	level.nuked_perks[1].turn_on_notify = "sleight_on";
	level.nuked_perks[2] = spawnstruct();
	level.nuked_perks[2].model = "zombie_vending_doubletap2";
	level.nuked_perks[2].script_noteworthy = "specialty_rof";
	level.nuked_perks[2].turn_on_notify = "doubletap_on";
	level.nuked_perks[3] = spawnstruct();
	level.nuked_perks[3].model = "zombie_vending_jugg";
	level.nuked_perks[3].script_noteworthy = "specialty_armorvest";
	level.nuked_perks[3].turn_on_notify = "juggernog_on";
	level.nuked_perks[4] = spawnstruct();
	level.nuked_perks[4].model = "p6_anim_zm_buildable_pap";
	level.nuked_perks[4].script_noteworthy = "specialty_weapupgrade";
	level.nuked_perks[4].turn_on_notify = "Pack_A_Punch_on";

	level.override_perk_targetname = "zm_perk_machine_override";
	random_perk_structs = [];
	perk_structs = getstructarray("zm_random_machine", "script_noteworthy");

	for (i = 0; i < perk_structs.size; i++)
	{
		random_perk_structs[i] = getstruct(perk_structs[i].target, "targetname");
		random_perk_structs[i].script_int = perk_structs[i].script_int;
	}

	level.random_perk_structs = array_randomize(random_perk_structs);

	for (i = 0; i < 5; i++)
	{
		level.random_perk_structs[i].targetname = "zm_perk_machine_override";
		level.random_perk_structs[i].model = level.nuked_perks[i].model;
		level.random_perk_structs[i].blocker_model = getent(level.random_perk_structs[i].target, "targetname");
		level.random_perk_structs[i].script_noteworthy = level.nuked_perks[i].script_noteworthy;
		level.random_perk_structs[i].turn_on_notify = level.nuked_perks[i].turn_on_notify;

		if (!isdefined(level.struct_class_names["targetname"]["zm_perk_machine_override"]))
		{
			level.struct_class_names["targetname"]["zm_perk_machine_override"] = [];
		}

		level.struct_class_names["targetname"]["zm_perk_machine_override"][level.struct_class_names["targetname"]["zm_perk_machine_override"].size] = level.random_perk_structs[i];
	}
}

perks_from_the_sky()
{
	level thread turn_perks_on();
	top_height = 8000;
	machines = [];
	machine_triggers = [];
	machines[0] = getent("vending_revive", "targetname");

	if (!isdefined(machines[0]))
	{
		return;
	}

	machine_triggers[0] = getent("vending_revive", "target");
	move_perk(machines[0], top_height, 5.0, 0.001);
	machine_triggers[0] trigger_off();
	machines[1] = getent("vending_doubletap", "targetname");
	machine_triggers[1] = getent("vending_doubletap", "target");
	move_perk(machines[1], top_height, 5.0, 0.001);
	machine_triggers[1] trigger_off();
	machines[2] = getent("vending_sleight", "targetname");
	machine_triggers[2] = getent("vending_sleight", "target");
	move_perk(machines[2], top_height, 5.0, 0.001);
	machine_triggers[2] trigger_off();
	machines[3] = getent("vending_jugg", "targetname");
	machine_triggers[3] = getent("vending_jugg", "target");
	move_perk(machines[3], top_height, 5.0, 0.001);
	machine_triggers[3] trigger_off();
	machine_triggers[4] = getent("specialty_weapupgrade", "script_noteworthy");
	machines[4] = getent(machine_triggers[4].target, "targetname");
	move_perk(machines[4], top_height, 5.0, 0.001);
	machine_triggers[4] trigger_off();
	flag_wait("initial_blackscreen_passed");

	if (level.scr_zm_ui_gametype == "zgrief")
	{
		grief_bring_random_perks(machines, machine_triggers);
	}
	else
	{
		bring_random_perks(machines, machine_triggers);
	}
}

bring_random_perks(machines, machine_triggers)
{
	wait(randomintrange(10, 20));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(5, 6);
	wait(randomintrange(30, 60));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(10, 11);
	wait(randomintrange(30, 60));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(15, 16);
	wait(randomintrange(60, 120));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(20, 21);
	wait(randomintrange(60, 120));
	bring_random_perk(machines, machine_triggers);
}

grief_bring_random_perks(machines, machine_triggers)
{
	level waittill("restart_round_start");

	wait(randomintrange(10, 20));
	grief_bring_random_perk(machines, machine_triggers);
	grief_bring_random_perk(machines, machine_triggers);
	grief_bring_random_perk(machines, machine_triggers);
	grief_bring_random_perk(machines, machine_triggers);
	grief_bring_random_perk(machines, machine_triggers);
}

grief_bring_random_perk(machines, machine_triggers)
{
	count = machines.size;

	if (count <= 0)
	{
		return;
	}

	index = randomintrange(0, count);
	level thread grief_bring_perk(machines[index], machine_triggers[index]);
	arrayremoveindex(machines, index);
	arrayremoveindex(machine_triggers, index);
}

grief_bring_perk(machine, trigger)
{
	if (is_true(level.scr_zm_ui_gametype_pro) && trigger.script_noteworthy == "specialty_weapupgrade")
	{
		return;
	}

	initial_perk = level.grief_perk_arrival_vehicles_ind == 0;
	perk_arrival_vehicle = level.grief_perk_arrival_vehicles[level.grief_perk_arrival_vehicles_ind];
	level.grief_perk_arrival_vehicles_ind++;

	if (initial_perk)
	{
		playsoundatposition("zmb_perks_incoming_quad_front", (0, 0, 0));
		playsoundatposition("zmb_perks_incoming_alarm", (-2198, 486, 327));
	}

	is_doubletap = 0;
	is_sleight = 0;
	is_revive = 0;
	is_jugger = 0;
	machine setclientfield("clientfield_perk_intro_fx", 1);
	machine.fx = spawn("script_model", machine.origin);
	machine.fx playloopsound("zmb_perks_incoming_loop", 6);
	machine.fx thread perk_incoming_sound();
	machine.fx.angles = machine.angles;
	machine.fx setmodel("tag_origin");
	machine.fx linkto(machine);
	machine linkto(perk_arrival_vehicle, "tag_origin", (0, 0, 0), (0, 0, 0));
	start_node = getvehiclenode("perk_arrival_path_" + machine.script_int, "targetname");

	perk_arrival_vehicle perk_follow_path(start_node);
	machine unlink();
	offset = (0, 0, 0);

	if (issubstr(machine.targetname, "doubletap"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 20);
		is_doubletap = 1;
	}
	else if (issubstr(machine.targetname, "sleight"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 5);
		is_sleight = 1;
	}
	else if (issubstr(machine.targetname, "revive"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 10);
		trigger.blocker_model hide();
		is_revive = 1;
	}
	else if (issubstr(machine.targetname, "jugger"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 10);
		is_jugger = 1;
	}

	if (!is_revive)
	{
		trigger.blocker_model delete();
	}

	machine.original_pos = machine.original_pos + (offset[0], offset[1], 0);
	machine.origin = machine.original_pos;
	machine.angles = machine.original_angles;

	if (is_revive)
	{
		level.quick_revive_final_pos = machine.origin;
		level.quick_revive_final_angles = machine.angles;
	}

	machine.fx stoploopsound(0.5);
	machine setclientfield("clientfield_perk_intro_fx", 0);
	playsoundatposition("zmb_perks_incoming_land", machine.origin);
	trigger trigger_on();
	machine thread bring_perk_landing_damage();
	machine.fx unlink();
	machine.fx delete();
	machine notify(machine.turn_on_notify);
	level notify(machine.turn_on_notify);
	machine vibrate(vectorscale((0, -1, 0), 100.0), 0.3, 0.4, 3);
	machine playsound("zmb_perks_power_on");
	machine maps\mp\zombies\_zm_perks::perk_fx(undefined, 1);

	if (is_revive)
	{
		level.revive_machine_spawned = 1;
		machine thread maps\mp\zombies\_zm_perks::perk_fx("revive_light");
	}
	else if (is_jugger)
	{
		machine thread maps\mp\zombies\_zm_perks::perk_fx("jugger_light");
	}
	else if (is_doubletap)
	{
		machine thread maps\mp\zombies\_zm_perks::perk_fx("doubletap_light");
	}
	else if (is_sleight)
	{
		machine thread maps\mp\zombies\_zm_perks::perk_fx("sleight_light");
	}
}