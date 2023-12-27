#include maps\mp\zombies\_zm_buildables_pooled;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

add_buildable_to_pool(stub, poolname)
{
	if (!isdefined(level.buildablepools))
		level.buildablepools = [];

	if (!isdefined(level.buildablepools[poolname]))
	{
		level.buildablepools[poolname] = spawnstruct();
		level.buildablepools[poolname].stubs = [];
	}

	level.buildablepools[poolname].stubs[level.buildablepools[poolname].stubs.size] = stub;

	if (!isdefined(level.buildablepools[poolname].buildable_slot))
		level.buildablepools[poolname].buildable_slot = stub.buildablestruct.buildable_slot;
	else
		assert(level.buildablepools[poolname].buildable_slot == stub.buildablestruct.buildable_slot);

	stub.buildable_pool = level.buildablepools[poolname];
	stub.original_prompt_and_visibility_func = stub.prompt_and_visibility_func;
	stub.original_trigger_func = stub.trigger_func;
	stub.prompt_and_visibility_func = ::pooledbuildabletrigger_update_prompt;
	reregister_unitrigger(stub, ::pooled_buildable_place_think);
}

reregister_unitrigger(unitrigger_stub, new_trigger_func)
{
	static = 0;

	if (isdefined(unitrigger_stub.in_zone))
		static = 1;

	unregister_unitrigger(unitrigger_stub);
	unitrigger_stub.trigger_func = new_trigger_func;

	if (static)
		register_static_unitrigger(unitrigger_stub, new_trigger_func, 0);
	else
		register_unitrigger(unitrigger_stub, new_trigger_func);
}

randomize_pooled_buildables(poolname)
{
	level waittill("buildables_setup");

	if (isdefined(level.buildablepools[poolname]))
	{
		count = level.buildablepools[poolname].stubs.size;

		if (count > 1)
		{
			for (i = 0; i < count; i++)
			{
				rand = randomint(count);

				if (rand != i)
				{
					swap_buildable_fields(level.buildablepools[poolname].stubs[i], level.buildablepools[poolname].stubs[rand]);
				}
			}
		}
	}
}

pooledbuildabletrigger_update_prompt(player)
{
	can_use = self.stub pooledbuildablestub_update_prompt(player, self);

	if (can_use && is_true(self.stub.built))
	{
		self sethintstring(self.stub.hint_string, self.stub.cost);
	}
	else
	{
		self sethintstring(self.stub.hint_string);
	}

	self setcursorhint("HINT_NOICON");

	return can_use;
}

pooledbuildablestub_update_prompt(player, trigger)
{
	if (!self anystub_update_prompt(player))
		return 0;

	can_use = 1;

	if (isdefined(self.custom_buildablestub_update_prompt) && !self [[self.custom_buildablestub_update_prompt]](player))
		return 0;

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	piece = undefined;

	if (!(isdefined(self.built) && self.built))
	{
		if (!is_true(self.solo_pool))
		{
			if (level.buildables_available.size > 1)
			{
				if (!is_true(self.open_buildable_checking_input))
				{
					self thread choose_open_buildable(player);
				}
				else
				{
					equipname = level.buildables_available[self.buildables_available_index];
					self.hint_string = level.zombie_buildables[equipname].hint;
				}
			}
			else
			{
				self notify("kill_choose_open_buildable");
				self.open_buildable_checking_input = 0;

				if (isdefined(self.openbuildablehudelem))
				{
					self.openbuildablehudelem destroy();
					self.openbuildablehudelem = undefined;
				}

				self.buildables_available_index = 0;
				equipname = level.buildables_available[self.buildables_available_index];
				self.hint_string = level.zombie_buildables[equipname].hint;
			}

			return 1;
		}

		if (isdefined(level.zombie_buildables[self.equipname].hint))
			self.hint_string = level.zombie_buildables[self.equipname].hint;
		else
			self.hint_string = "Missing buildable hint";
	}
	else
		return trigger [[self.original_prompt_and_visibility_func]](player);

	return 1;
}

find_bench(bench_name)
{
	return getent(bench_name, "targetname");
}

swap_buildable_fields(stub1, stub2)
{
	temp = stub2.buildablezone;
	stub2.buildablezone = stub1.buildablezone;
	stub2.buildablezone.stub = stub2;
	stub1.buildablezone = temp;
	stub1.buildablezone.stub = stub1;
	temp = stub2.buildablestruct;
	stub2.buildablestruct = stub1.buildablestruct;
	stub1.buildablestruct = temp;
	temp = stub2.equipname;
	stub2.equipname = stub1.equipname;
	stub1.equipname = temp;
	temp = stub2.hint_string;
	stub2.hint_string = stub1.hint_string;
	stub1.hint_string = temp;
	temp = stub2.trigger_hintstring;
	stub2.trigger_hintstring = stub1.trigger_hintstring;
	stub1.trigger_hintstring = temp;
	temp = stub2.persistent;
	stub2.persistent = stub1.persistent;
	stub1.persistent = temp;
	temp = stub2.onbeginuse;
	stub2.onbeginuse = stub1.onbeginuse;
	stub1.onbeginuse = temp;
	temp = stub2.oncantuse;
	stub2.oncantuse = stub1.oncantuse;
	stub1.oncantuse = temp;
	temp = stub2.onenduse;
	stub2.onenduse = stub1.onenduse;
	stub1.onenduse = temp;
	temp = stub2.target;
	stub2.target = stub1.target;
	stub1.target = temp;
	temp = stub2.targetname;
	stub2.targetname = stub1.targetname;
	stub1.targetname = temp;
	temp = stub2.weaponname;
	stub2.weaponname = stub1.weaponname;
	stub1.weaponname = temp;
	temp = stub2.cost;
	stub2.cost = stub1.cost;
	stub1.cost = temp;
	temp = stub2.original_prompt_and_visibility_func;
	stub2.original_prompt_and_visibility_func = stub1.original_prompt_and_visibility_func;
	stub1.original_prompt_and_visibility_func = temp;
	bench1 = undefined;
	bench2 = undefined;
	transfer_pos_as_is = 1;

	if (isdefined(stub1.model.target) && isdefined(stub2.model.target))
	{
		bench1 = find_bench(stub1.model.target);
		bench2 = find_bench(stub2.model.target);

		if (isdefined(bench1) && isdefined(bench2))
		{
			transfer_pos_as_is = 0;
			temp = [];
			temp[0] = bench1 worldtolocalcoords(stub1.model.origin);
			temp[1] = stub1.model.angles - bench1.angles;
			temp[2] = bench2 worldtolocalcoords(stub2.model.origin);
			temp[3] = stub2.model.angles - bench2.angles;
			stub1.model.origin = bench2 localtoworldcoords(temp[0]);
			stub1.model.angles = bench2.angles + temp[1];
			stub2.model.origin = bench1 localtoworldcoords(temp[2]);
			stub2.model.angles = bench1.angles + temp[3];
		}

		temp = stub2.model.target;
		stub2.model.target = stub1.model.target;
		stub1.model.target = temp;
	}

	temp = stub2.model;
	stub2.model = stub1.model;
	stub1.model = temp;

	if (transfer_pos_as_is)
	{
		temp = [];
		temp[0] = stub2.model.origin;
		temp[1] = stub2.model.angles;
		stub2.model.origin = stub1.model.origin;
		stub2.model.angles = stub1.model.angles;
		stub1.model.origin = temp[0];
		stub1.model.angles = temp[1];

		swap_buildable_fields_model_offset(stub1, stub2);
	}
}

swap_buildable_fields_model_offset(stub1, stub2)
{
	origin_offset = (0, 0, 0);
	angle_offset = (0, 0, 0);

	if (stub1.weaponname == "equip_turbine_zm")
	{
		if (stub2.weaponname == "riotshield_zm")
		{
			origin_offset = (6, -6, -27);
			angle_offset = (0, -180, 0);
		}
		else if (stub2.weaponname == "equip_turret_zm")
		{
			origin_offset = (-7, -5, 0);
			angle_offset = (0, -90, 0);
		}
		else if (stub2.weaponname == "equip_electrictrap_zm")
		{
			origin_offset = (-2, 8, 0);
			angle_offset = (0, 90, 0);
		}
		else if (stub2.weaponname == "jetgun_zm")
		{
			origin_offset = (-3, -4, -24);
			angle_offset = (0, -90, 0);
		}
	}
	else if (stub1.weaponname == "riotshield_zm")
	{
		if (stub2.weaponname == "equip_turbine_zm")
		{
			origin_offset = (-6, 6, 27);
			angle_offset = (0, 180, 0);
		}
		else if (stub2.weaponname == "equip_turret_zm")
		{
			origin_offset = (-1, 1, 27);
			angle_offset = (0, 90, 0);
		}
		else if (stub2.weaponname == "equip_electrictrap_zm")
		{
			origin_offset = (2, -4, 27);
			angle_offset = (0, -90, 0);
		}
		else if (stub2.weaponname == "jetgun_zm")
		{
			origin_offset = (-2, 5, 3);
			angle_offset = (0, 90, 0);
		}
	}
	else if (stub1.weaponname == "equip_turret_zm")
	{
		if (stub2.weaponname == "equip_turbine_zm")
		{
			origin_offset = (7, 5, 0);
			angle_offset = (0, 90, 0);
		}
		else if (stub2.weaponname == "riotshield_zm")
		{
			origin_offset = (1, -1, -27);
			angle_offset = (0, -90, 0);
		}
		else if (stub2.weaponname == "equip_electrictrap_zm")
		{
			origin_offset = (2, -2, 0);
			angle_offset = (0, -180, 0);
		}
		else if (stub2.weaponname == "jetgun_zm")
		{
			origin_offset = (4, 0, -24);
			angle_offset = (0, 0, 0);
		}
	}
	else if (stub1.weaponname == "equip_electrictrap_zm")
	{
		if (stub2.weaponname == "equip_turbine_zm")
		{
			origin_offset = (2, -8, 0);
			angle_offset = (0, -90, 0);
		}
		else if (stub2.weaponname == "riotshield_zm")
		{
			origin_offset = (-2, 4, -27);
			angle_offset = (0, 90, 0);
		}
		else if (stub2.weaponname == "equip_turret_zm")
		{
			origin_offset = (-2, 2, 0);
			angle_offset = (0, 180, 0);
		}
		else if (stub2.weaponname == "jetgun_zm")
		{
			origin_offset = (-6, 3, -24);
			angle_offset = (0, 180, 0);
		}
	}
	else if (stub1.weaponname == "jetgun_zm")
	{
		if (stub2.weaponname == "equip_turbine_zm")
		{
			origin_offset = (3, 4, 24);
			angle_offset = (0, 90, 0);
		}
		else if (stub2.weaponname == "riotshield_zm")
		{
			origin_offset = (2, -5, -3);
			angle_offset = (0, -90, 0);
		}
		else if (stub2.weaponname == "equip_turret_zm")
		{
			origin_offset = (-4, 0, 24);
			angle_offset = (0, 0, 0);
		}
		else if (stub2.weaponname == "equip_electrictrap_zm")
		{
			origin_offset = (6, -3, 24);
			angle_offset = (0, -180, 0);
		}
	}
	else if (stub1.weaponname == "equip_springpad_zm")
	{
		if (stub2.weaponname == "slipgun_zm")
		{
			origin_offset = (-14, 2, -2);
			angle_offset = (64.2, 90, 0);
		}
	}
	else if (stub1.weaponname == "slipgun_zm")
	{
		if (stub2.weaponname == "equip_springpad_zm")
		{
			origin_offset = (14, -2, 2);
			angle_offset = (-64.2, -90, 0);
		}
	}

	stub1.model.angles += angle_offset;
	stub2.model.angles -= angle_offset;

	model1_angle = (0, stub1.model.angles[1], 0);
	model2_angle = (0, stub2.model.angles[1], 0);

	if (angle_offset[1] < 0)
	{
		model1_angle -= (0, angle_offset[1], 0);
	}
	else
	{
		model2_angle += (0, angle_offset[1], 0);
	}

	stub1.model.origin += (anglesToForward(model1_angle) * origin_offset[0]) + (anglesToRight(model1_angle) * origin_offset[1]) + (anglesToUp(model1_angle) * origin_offset[2]);
	stub2.model.origin -= (anglesToForward(model2_angle) * origin_offset[0]) + (anglesToRight(model2_angle) * origin_offset[1]) + (anglesToUp(model2_angle) * origin_offset[2]);
}

pooled_buildable_place_think()
{
	self endon("kill_trigger");

	if (isdefined(self.stub.built) && self.stub.built)
		return scripts\zm\replaced\_zm_buildables::buildable_place_think();

	while (!(isdefined(self.stub.built) && self.stub.built))
	{
		self waittill("trigger", player);

		if (player != self.parent_player)
			continue;

		if (isdefined(player.screecher_weapon))
			continue;

		if (!is_player_valid(player))
		{
			player thread ignore_triggers(0.5);
			continue;
		}

		bind_to = self.stub.buildable_pool pooledbuildable_stub_for_equipname(level.buildables_available[self.stub.buildables_available_index]);

		if (!isdefined(bind_to) || isdefined(self.stub.bound_to_buildable) && self.stub.bound_to_buildable != bind_to || isdefined(bind_to.bound_to_buildable) && self.stub != bind_to.bound_to_buildable)
		{
			self.stub.hint_string = "";
			self sethintstring(self.stub.hint_string);

			if (isdefined(self.stub.oncantuse))
				self.stub [[self.stub.oncantuse]](player);

			continue;
		}

		status = player scripts\zm\replaced\_zm_buildables::player_can_build(bind_to.buildablezone);

		if (!status)
		{
			self.stub.hint_string = "";
			self sethintstring(self.stub.hint_string);

			if (isdefined(bind_to.oncantuse))
				bind_to [[bind_to.oncantuse]](player);
		}
		else
		{
			if (isdefined(bind_to.onbeginuse))
				self.stub [[bind_to.onbeginuse]](player);

			result = self scripts\zm\replaced\_zm_buildables::buildable_use_hold_think(player, bind_to);
			team = player.pers["team"];

			if (result)
			{
				if (isdefined(self.stub.bound_to_buildable) && self.stub.bound_to_buildable != bind_to)
					result = 0;

				if (isdefined(bind_to.bound_to_buildable) && self.stub != bind_to.bound_to_buildable)
					result = 0;
			}

			if (isdefined(bind_to.onenduse))
				self.stub [[bind_to.onenduse]](team, player, result);

			if (!result)
				continue;

			if (bind_to != self.stub)
			{
				swap_buildable_fields(self.stub, bind_to);
			}

			if (isdefined(self.stub.onuse))
				self.stub [[self.stub.onuse]](player);

			prompt = player scripts\zm\replaced\_zm_buildables::player_build(self.stub.buildablezone);
			self.stub.hint_string = self.stub.trigger_hintstring;
		}
	}

	self.stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
	arrayremovevalue(level.buildables_available, self.stub.equipname);

	if (level.buildables_available.size == 0)
	{
		foreach (stub in level.buildable_stubs)
		{
			if (isDefined(stub.buildable_pool) && stub.buildable_pool == self.stub.buildable_pool)
			{
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
			}
		}
	}

	self thread pooled_buildable_place_update_all();
}

pooled_buildable_place_update_all()
{
	players = get_players();

	foreach (player in players)
	{
		num = player getentitynumber();

		if (isDefined(self.stub.playertrigger[num]))
		{
			self.stub.playertrigger[num] notify("kill_trigger");
			self.stub.playertrigger[num] pooledbuildabletrigger_update_prompt(player);
			self.stub.playertrigger[num] pooled_buildable_place_think();
		}
	}
}

pooledbuildable_stub_for_equipname(equipname)
{
	foreach (stub in self.stubs)
	{
		if (isdefined(stub.bound_to_buildable))
			continue;

		if (stub.equipname == equipname)
			return stub;
	}

	return undefined;
}

choose_open_buildable(player)
{
	self endon("kill_choose_open_buildable");

	num = player getentitynumber();
	got_input = 1;
	hud = newclienthudelem(player);
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.horzalign = "center";
	hud.vertalign = "bottom";
	hud.y = -100;
	hud.foreground = 1;
	hud.hidewheninmenu = 1;
	hud.font = "default";
	hud.fontscale = 1;
	hud.alpha = 1;
	hud.color = (1, 1, 1);
	hud settext(&"ZM_CRAFTABLES_CHANGE_BUILD");
	self.open_buildable_checking_input = 1;
	self.openbuildablehudelem = hud;

	if (!isDefined(self.buildables_available_index))
	{
		self.buildables_available_index = 0;
	}

	while (isDefined(self.playertrigger[num]) && !self.built)
	{
		if (!player isTouching(self.playertrigger[num]) || !player is_player_looking_at(self.playertrigger[num].origin, 0.76) || !is_player_valid(player) || player isSprinting() || player isThrowingGrenade())
		{
			hud.alpha = 0;
			wait 0.05;
			continue;
		}

		hud.alpha = 1;

		if (player actionslotonebuttonpressed())
		{
			self.buildables_available_index++;
			got_input = 1;
		}
		else if (player actionslottwobuttonpressed())
		{
			self.buildables_available_index--;
			got_input = 1;
		}

		if (self.buildables_available_index >= level.buildables_available.size)
		{
			self.buildables_available_index = 0;
		}
		else if (self.buildables_available_index < 0)
		{
			self.buildables_available_index = level.buildables_available.size - 1;
		}

		if (got_input)
		{
			equipname = level.buildables_available[self.buildables_available_index];
			self.hint_string = level.zombie_buildables[equipname].hint;

			foreach (trig in self.playertrigger)
			{
				trig sethintstring(self.hint_string);
			}

			got_input = 0;
		}

		wait 0.05;
	}

	self.open_buildable_checking_input = 0;
	self.openbuildablehudelem destroy();
	self.openbuildablehudelem = undefined;
}