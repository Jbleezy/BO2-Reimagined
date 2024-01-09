#include maps\mp\zm_alcatraz_weap_quest;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#using_animtree("fxanim_props");

grief_soul_catcher_state_manager()
{
	wait 1;

	if (is_true(level.scr_zm_ui_gametype_pro))
	{
		for (i = 0; i < level.soul_catchers.size; i++)
		{
			level.soul_catchers[i].is_charged = 1;
		}

		return;
	}

	while (true)
	{
		level setclientfield(self.script_parameters, 0);

		self waittill("first_zombie_killed_in_zone");

		if (isdefined(level.soul_catcher_clip[self.script_noteworthy]))
			level.soul_catcher_clip[self.script_noteworthy] setvisibletoall();

		level setclientfield(self.script_parameters, 1);
		anim_length = getanimlength(%o_zombie_dreamcatcher_intro);
		wait(anim_length);

		while (!self.is_charged)
		{
			level setclientfield(self.script_parameters, 2);
			self waittill_either("fully_charged", "finished_eating");
		}

		level setclientfield(self.script_parameters, 6);
		anim_length = getanimlength(%o_zombie_dreamcatcher_outtro);
		wait(anim_length);

		if (isdefined(level.soul_catcher_clip[self.script_noteworthy]))
			level.soul_catcher_clip[self.script_noteworthy] delete();

		self.souls_received = 0;
		level thread wolf_spit_out_powerup();
		wait 20;
		self thread soul_catcher_check();
	}
}

wolf_spit_out_powerup()
{
	if (!(isdefined(level.enable_magic) && level.enable_magic))
		return;

	power_origin_structs = getstructarray("wolf_puke_powerup_origin", "targetname");
	power_origin_struct = undefined;

	foreach (struct in power_origin_structs)
	{
		if (isdefined(struct.script_string) && struct.script_string == level.scr_zm_map_start_location)
		{
			power_origin_struct = struct;
			break;
		}
	}

	if (!isdefined(power_origin_struct))
	{
		return;
	}

	powerup_array = array_randomize(level.zombie_powerup_array);
	wolf_powerup = undefined;

	foreach (powerup in powerup_array)
	{
		if (powerup == "meat_stink" && level.scr_zm_ui_gametype_obj != "zmeat")
		{
			continue;
		}

		wolf_powerup = powerup;
		break;
	}

	spawn_infinite_powerup_drop(power_origin_struct.origin, wolf_powerup);
	power_ups = get_array_of_closest(power_origin_struct.origin, level.active_powerups, undefined, undefined, 100);

	if (isdefined(power_ups[0]))
		power_ups[0] movez(120, 4);
}