#include maps\mp\zombies\_zm_perk_random;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_perks;

#using_animtree("zm_perk_random");

machines_setup()
{
	wait 0.5;
	level.perk_bottle_weapon_array = arraycombine(level.machine_assets, level._custom_perks, 0, 1);
	start_machines = getentarray("start_machine", "script_noteworthy");
	assert(isdefined(start_machines.size != 0), "missing start random perk machine");

	if (start_machines.size == 1)
	{
		level.random_perk_start_machine = start_machines[0];
	}
	else
	{
		level.random_perk_start_machine = start_machines[randomint(start_machines.size)];
	}

	machines = getentarray("random_perk_machine", "targetname");

	foreach (machine in machines)
	{
		spawn_location = spawn("script_model", machine.origin);
		spawn_location setmodel("tag_origin");
		spawn_location.angles = machine.angles;
		forward_dir = anglestoright(machine.angles);
		spawn_location.origin = spawn_location.origin + vectorscale((0, 0, 1), 65.0);
		machine.bottle_spawn_location = spawn_location;
		machine useanimtree(#animtree );
		machine thread machine_power_indicators();

		if ((getdvar("g_gametype") == "zgrief" && getdvarintdefault("ui_gametype_pro", 0)) || machine != level.random_perk_start_machine)
		{
			machine update_animation("shut_down");
			machine hidepart("j_ball");
			machine.is_current_ball_location = 0;
		}
		else
		{
			level.wunderfizz_starting_machine = machine;
			level notify("wunderfizz_setup");
			machine thread machine_think();
		}

		wait_network_frame();
	}
}

machine_selector()
{
	while (true)
	{
		level waittill("random_perk_moving");

		machines = getentarray("random_perk_machine", "targetname");

		if (machines.size == 1)
		{
			new_machine = machines[0];
			new_machine thread machine_think();
			continue;
		}

		do
		{
			new_machine = machines[randomint(machines.size)];
		}
		while (new_machine == level.random_perk_start_machine);

		level.random_perk_start_machine = new_machine;
		new_machine thread machine_think();
	}
}

start_perk_bottle_cycling()
{
	self endon("done_cycling");
	array_key = array_randomize(getarraykeys(level._random_perk_machine_perk_list));
	timer = 0;

	while (true)
	{
		model_cycled = 0;

		for (i = 0; i < array_key.size; i++)
		{
			perk = level._random_perk_machine_perk_list[array_key[i]];

			if (!isdefined(self.machine_user) || self.machine_user hasperk(perk))
			{
				continue;
			}

			model_cycled = 1;

			model = get_perk_weapon_model(perk);
			self.bottle_spawn_location setmodel(model);
			wait 0.2;
		}

		if (!model_cycled)
		{
			wait 0.05;
		}
	}
}

perk_bottle_motion()
{
	putouttime = 3;
	putbacktime = 10;
	v_float = anglestoforward(self.angles - (0, 90, 0)) * 10;

	// delete and respawn the bottle model so that it shows at correct origin right away
	model = self.bottle_spawn_location.model;
	self.bottle_spawn_location delete();
	self.bottle_spawn_location = spawn("script_model", self.origin + (0, 0, 53) - v_float);
	self.bottle_spawn_location.angles = self.angles + (0, 0, 10);
	self.bottle_spawn_location setmodel(model);

	self.bottle_spawn_location moveto(self.bottle_spawn_location.origin + v_float, putouttime, putouttime * 0.5);
	self.bottle_spawn_location rotateyaw(720, putouttime, putouttime * 0.5);

	self waittill("done_cycling");

	self.bottle_spawn_location.angles = self.angles;
	self.bottle_spawn_location moveto(self.bottle_spawn_location.origin - v_float, putbacktime, putbacktime * 0.5);
	self.bottle_spawn_location rotateyaw(90, putbacktime, putbacktime * 0.5);
}

trigger_visible_to_player(player)
{
	self setinvisibletoplayer(player);
	visible = 1;

	if (isdefined(self.stub.trigger_target.machine_user))
	{
		if (player != self.stub.trigger_target.machine_user)
		{
			visible = 0;
		}
	}
	else if (!player can_buy_perk())
	{
		visible = 0;
	}

	if (!visible)
	{
		return false;
	}

	self setvisibletoplayer(player);
	return true;
}

can_buy_perk()
{
	if (isdefined(self.is_drinking) && self.is_drinking > 0)
	{
		return false;
	}

	current_weapon = self getcurrentweapon();

	if (is_equipment_that_blocks_purchase(current_weapon))
	{
		return false;
	}

	if (self in_revive_trigger())
	{
		return false;
	}

	if (current_weapon == "none")
	{
		return false;
	}

	return true;
}

wunderfizzstub_update_prompt(player)
{
	self setcursorhint("HINT_NOICON");

	if (!self trigger_visible_to_player(player))
	{
		return false;
	}

	self.hint_parm1 = undefined;

	if (isdefined(self.stub.trigger_target.is_locked) && self.stub.trigger_target.is_locked)
	{
		self.hint_string = &"ZM_TOMB_RPU";
		return false;
	}
	else if (self.stub.trigger_target.is_current_ball_location)
	{
		if (isdefined(self.stub.trigger_target.machine_user))
		{
			if (isdefined(self.stub.trigger_target.grab_perk_hint) && self.stub.trigger_target.grab_perk_hint)
			{
				n_purchase_limit = player get_player_perk_purchase_limit();

				if (player.num_perks >= n_purchase_limit)
				{
					self.hint_string = &"ZM_TOMB_ALL_PERKS";
					return false;
				}
				else
				{
					self.hint_string = &"ZM_TOMB_RPP";
					return true;
				}
			}
			else
			{
				return false;
			}
		}
		else
		{
			n_purchase_limit = player get_player_perk_purchase_limit();

			if (player.num_perks >= n_purchase_limit)
			{
				self.hint_string = &"ZM_TOMB_ALL_PERKS";
				return false;
			}
			else
			{
				self.hint_string = &"ZM_TOMB_RPB";
				self.hint_parm1 = level._random_zombie_perk_cost;
				return true;
			}
		}
	}
	else
	{
		self.hint_string = &"ZM_TOMB_RPE";
		return false;
	}
}