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
	level.random_perk_moves = 0;
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

		if (machine != level.random_perk_start_machine || (getdvar("g_gametype") == "zgrief" && getdvarintdefault("ui_gametype_pro", 0)))
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

machine_think()
{
	self notify("machine_think");
	self endon("machine_think");
	self thread machine_sounds();
	self show();
	self.num_time_used = 0;
	self.num_til_moved = randomintrange(4, 7);
	self.is_current_ball_location = 1;
	self setclientfield("turn_on_location_indicator", 1);
	self showpart("j_ball");
	self thread update_animation("start");
	machines = getentarray("random_perk_machine", "targetname");

	thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);

	wait getanimlength(%o_zombie_dlc4_vending_diesel_turn_on);

	thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, ::wunderfizz_unitrigger_think);

	while (isdefined(self.is_locked) && self.is_locked)
	{
		wait 1;
	}

	self conditional_power_indicators();

	while (true)
	{
		self waittill("trigger", player);
		flag_clear("machine_can_reset");
		self notify("pmmove");

		if (player.score < level._random_zombie_perk_cost)
		{
			self playsound("evt_perk_deny");
			player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 0);
			continue;
		}

		if (machines.size > 1 && self.num_time_used >= self.num_til_moved)
		{
			level.random_perk_moves++;
			self notify("pmmove");
			self thread update_animation("shut_down");
			level notify("random_perk_moving");
			self setclientfield("turn_on_location_indicator", 0);
			self.is_current_ball_location = 0;
			self conditional_power_indicators();
			self hidepart("j_ball");
			break;
		}

		self.machine_user = player;

		if (!is_true(level.zombie_vars["zombie_powerup_fire_sale_on"]))
		{
			self.num_time_used++;
		}

		player maps\mp\zombies\_zm_stats::increment_client_stat("use_perk_random");
		player maps\mp\zombies\_zm_stats::increment_player_stat("use_perk_random");
		player maps\mp\zombies\_zm_score::minus_to_player_score(level._random_zombie_perk_cost);
		self thread update_animation("in_use");

		if (isdefined(level.perk_random_vo_func_usemachine) && isdefined(player))
		{
			player thread [[level.perk_random_vo_func_usemachine]]();
		}

		while (true)
		{
			thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
			random_perk = get_weighted_random_perk(player);
			self setclientfield("perk_bottle_cycle_state", 1);
			self notify("pmstrt");
			wait 1.0;
			self thread start_perk_bottle_cycling();
			self thread perk_bottle_motion();
			model = get_perk_weapon_model(random_perk);
			wait 3.0;
			self notify("done_cycling");

			if (machines.size > 1 && self.num_time_used >= self.num_til_moved)
			{
				level.random_perk_moves++;
				self.bottle_spawn_location setmodel("t6_wpn_zmb_perk_bottle_bear_world");
				self notify("pmmove");
				self thread update_animation("shut_down");
				player maps\mp\zombies\_zm_score::add_to_player_score(level._random_zombie_perk_cost);
				wait 3;
				self.bottle_spawn_location setmodel("tag_origin");
				level notify("random_perk_moving");
				self setclientfield("perk_bottle_cycle_state", 0);
				self setclientfield("turn_on_location_indicator", 0);
				self.is_current_ball_location = 0;
				self conditional_power_indicators();
				self hidepart("j_ball");
				self.machine_user = undefined;
				thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, ::wunderfizz_unitrigger_think);
				break;
			}
			else
			{
				self.bottle_spawn_location setmodel(model);
			}

			self.grab_perk_hint = 1;
			thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, ::wunderfizz_unitrigger_think);
			self thread grab_check(player, random_perk);
			self thread time_out_check();
			self waittill_either("grab_check", "time_out_check");
			self.grab_perk_hint = 0;
			thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
			self notify("pmstop");

			if (player.num_perks >= player get_player_perk_purchase_limit())
			{
				player maps\mp\zombies\_zm_score::add_to_player_score(level._random_zombie_perk_cost);
			}

			self setclientfield("perk_bottle_cycle_state", 0);
			self.machine_user = undefined;
			self.bottle_spawn_location setmodel("tag_origin");
			self thread update_animation("idle");

			wait 0.5;

			thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, ::wunderfizz_unitrigger_think);

			break;
		}
	}
}

grab_check(player, random_perk)
{
	self endon("time_out_check");
	perk_is_bought = 0;

	while (!perk_is_bought)
	{
		self waittill("trigger", e_triggerer);

		if (e_triggerer == player)
		{
			if (player isthrowinggrenade())
			{
				wait 0.1;
				continue;
			}

			if (player isswitchingweapons())
			{
				wait 0.1;
				continue;
			}

			if (isdefined(player.is_drinking) && player.is_drinking > 0)
			{
				wait 0.1;
				continue;
			}

			if (player.num_perks < player get_player_perk_purchase_limit())
			{
				perk_is_bought = 1;
			}
			else
			{
				self playsound("evt_perk_deny");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "sigh");
				self notify("time_out_or_perk_grab");
				return;
			}
		}
	}

	player maps\mp\zombies\_zm_stats::increment_client_stat("grabbed_from_perk_random");
	player maps\mp\zombies\_zm_stats::increment_player_stat("grabbed_from_perk_random");
	player thread monitor_when_player_acquires_perk();
	self notify("grab_check");
	self notify("time_out_or_perk_grab");
	gun = player maps\mp\zombies\_zm_perks::perk_give_bottle_begin(random_perk);

	while (1)
	{
		evt = player waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");

		if (evt == "weapon_change_complete")
		{
			if (player getcurrentweapon() == gun)
			{
				continue;
			}

			player thread maps\mp\zombies\_zm_perks::wait_give_perk(random_perk, 1);
		}

		break;
	}

	player maps\mp\zombies\_zm_perks::perk_give_bottle_end(gun, random_perk);

	if (!(isdefined(player.has_drunk_wunderfizz) && player.has_drunk_wunderfizz))
	{
		player do_player_general_vox("wunderfizz", "perk_wonder", undefined, 100);
		player.has_drunk_wunderfizz = 1;
	}
}

time_out_check()
{
	self endon("grab_check");
	wait 6.0;
	self notify("time_out_check");
	flag_set("machine_can_reset");
}

machine_sounds()
{
	self endon("machine_think");

	while (true)
	{
		self waittill("pmstrt");
		rndprk_ent = spawn("script_origin", self.origin);
		rndprk_ent stopsounds();
		rndprk_ent playsound("zmb_rand_perk_start");
		rndprk_ent playloopsound("zmb_rand_perk_loop", 0.5);
		state_switch = self waittill_any_return("pmstop", "pmmove");
		rndprk_ent stoploopsound(1);

		if (state_switch == "pmstop")
		{
			rndprk_ent playsound("zmb_rand_perk_stop");
		}
		else
		{
			rndprk_ent playsound("zmb_rand_perk_leave");
		}

		rndprk_ent delete();
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
	putbacktime = 6;
	v_float = anglestoforward(self.angles - (0, 90, 0)) * 10;

	// delete and respawn the bottle model so that it shows at correct origin right away
	model = self.bottle_spawn_location.model;
	self.bottle_spawn_location delete();
	self.bottle_spawn_location = spawn("script_model", self.origin + (0, 0, 53) - v_float);
	self.bottle_spawn_location.angles = self.angles;
	self.bottle_spawn_location setmodel(model);

	self.bottle_spawn_location moveto(self.bottle_spawn_location.origin + v_float, putouttime, putouttime * 0.5);
	self.bottle_spawn_location rotateyaw(720, putouttime, putouttime * 0.5);

	self waittill("done_cycling");

	self.bottle_spawn_location.angles = self.angles;

	if (self.bottle_spawn_location.model == "t6_wpn_zmb_perk_bottle_bear_world")
	{
		wait 1;

		self.bottle_spawn_location rotateyaw(1500, 2, 2);

		wait 1.5;

		self.bottle_spawn_location moveto(self.bottle_spawn_location.origin + v_float * 1.0, 0.25, 0.25);
		self.bottle_spawn_location waittill("movedone");
		self.bottle_spawn_location moveto(self.bottle_spawn_location.origin + v_float * -5.0, 0.25, 0.25);
		self.bottle_spawn_location waittill("movedone");
	}
	else
	{
		self.bottle_spawn_location moveto(self.bottle_spawn_location.origin - v_float * 0.25, putbacktime, putbacktime * 0.5);
	}
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