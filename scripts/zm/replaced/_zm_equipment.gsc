#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

show_equipment_hint(equipment)
{
	if (is_true(self.do_not_display_equipment_pickup_hint))
	{
		return;
	}

	self notify("kill_previous_show_equipment_hint_thread");
	self endon("kill_previous_show_equipment_hint_thread");
	self endon("death");
	self endon("disconnect");

	wait 0.5;

	text = maps\mp\zombies\_zm_equipment::get_equipment_howto_hint(equipment);
	self maps\mp\zombies\_zm_equipment::show_equipment_hint_text(text);
}

placed_equipment_think(model, equipname, origin, angles, tradius, toffset)
{
	pickupmodel = spawn("script_model", origin);

	if (isDefined(angles))
	{
		pickupmodel.angles = angles;
	}

	pickupmodel setmodel(model);

	if (isDefined(level.equipment_safe_to_drop))
	{
		if (!(self [[level.equipment_safe_to_drop]](pickupmodel)))
		{
			self thread placed_equipment_destroy(model, equipname, origin, angles, tradius, toffset, pickupmodel);
			return undefined;
		}
	}

	watchername = getsubstr(equipname, 0, equipname.size - 3);

	if (isDefined(level.retrievehints[watchername]))
	{
		hint = level.retrievehints[watchername].hint;
	}
	else
	{
		hint = &"MP_GENERIC_PICKUP";
	}

	icon = maps\mp\zombies\_zm_equipment::get_equipment_icon(equipname);

	if (!isDefined(tradius))
	{
		tradius = 32;
	}

	torigin = origin;

	if (isDefined(toffset))
	{
		tforward = anglesToForward(angles);
		torigin += toffset * tforward;
	}

	tup = anglesToUp(angles);
	eq_unitrigger_offset = 12 * tup;
	pickupmodel.stub = maps\mp\zombies\_zm_equipment::generate_equipment_unitrigger("trigger_radius_use", torigin + eq_unitrigger_offset, angles, 0, tradius, 64, hint, equipname, maps\mp\zombies\_zm_equipment::placed_equipment_unitrigger_think, pickupmodel.canmove);
	pickupmodel.stub.model = pickupmodel;
	pickupmodel.stub.equipname = equipname;
	pickupmodel.equipname = equipname;
	pickupmodel thread item_watch_damage();

	if (maps\mp\zombies\_zm_equipment::is_limited_equipment(equipname))
	{
		if (!isDefined(level.dropped_equipment))
		{
			level.dropped_equipment = [];
		}

		if (isDefined(level.dropped_equipment[equipname]) && isDefined(level.dropped_equipment[equipname].model))
		{
			level.dropped_equipment[equipname].model maps\mp\zombies\_zm_equipment::dropped_equipment_destroy(1);
		}

		level.dropped_equipment[equipname] = pickupmodel.stub;
	}

	maps\mp\zombies\_zm_equipment::destructible_equipment_list_add(pickupmodel);
	return pickupmodel;
}

placed_equipment_destroy(model, equipname, origin, angles, tradius, toffset, pickupmodel)
{
	if (equipname == "equip_turbine_zm")
	{
		pickupmodel.angles += (0, 90, 0);
	}

	maps\mp\zombies\_zm_equipment::equipment_disappear_fx(pickupmodel.origin, undefined, pickupmodel.angles);
	pickupmodel delete();
	self maps\mp\zombies\_zm_equipment::equipment_take(equipname);
}

item_watch_damage()
{
	self endon("death");
	self setcandamage(1);

	while (1)
	{
		self.health = 1000000;
		self waittill("damage", amount);
		self item_damage(amount);
	}
}

item_damage(damage)
{
	if (isdefined(self.isriotshield) && self.isriotshield)
	{
		if (isdefined(level.riotshield_damage_callback) && isdefined(self.owner))
		{
			self.owner [[level.riotshield_damage_callback]](damage, 0);
		}
		else if (isdefined(level.deployed_riotshield_damage_callback))
		{
			self [[level.deployed_riotshield_damage_callback]](damage);
		}
	}
	else if (isdefined(self.owner))
	{
		self.owner player_damage_equipment(self.equipname, damage, self.origin, self.stub);
	}
	else
	{
		if (!isdefined(self.damage))
		{
			self.damage = 0;
		}

		self.damage += damage;

		if (self.damage >= 1500)
		{
			self thread maps\mp\zombies\_zm_equipment::dropped_equipment_destroy(1);
		}
	}
}

player_damage_equipment(equipment, damage, origin, stub)
{
	if (!isdefined(self.equipment_damage))
	{
		self.equipment_damage = [];
	}

	if (!isdefined(self.equipment_damage[equipment]))
	{
		self.equipment_damage[equipment] = 0;
	}

	self.equipment_damage[equipment] += damage;

	if (self.equipment_damage[equipment] >= 1500)
	{
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);

		if (isdefined(level.placeable_equipment_destroy_fn[equipment]))
		{
			self [[level.placeable_equipment_destroy_fn[equipment]]]();
		}
		else
		{
			equipment_disappear_fx(origin);
		}

		self equipment_release(equipment);
	}
}

equipment_take(equipment)
{
	if (!isdefined(equipment))
	{
		equipment = self get_player_equipment();
	}

	if (!isdefined(equipment))
	{
		return;
	}

	if (!self has_player_equipment(equipment))
	{
		return;
	}

	current = 0;
	current_weapon = 0;

	if (isdefined(self get_player_equipment()) && equipment == self get_player_equipment())
	{
		current = 1;
	}

	if (equipment == self getcurrentweapon())
	{
		current_weapon = 1;
	}

	if (isdefined(self.current_equipment_active[equipment]) && self.current_equipment_active[equipment])
	{
		self.current_equipment_active[equipment] = 0;
		self notify(equipment + "_deactivate");
	}

	self notify(equipment + "_taken");
	self takeweapon(equipment);

	if (!is_limited_equipment(equipment) || is_limited_equipment(equipment) && !limited_equipment_in_use(equipment))
	{
		self set_equipment_invisibility_to_player(equipment, 0);
	}

	if (current)
	{
		self set_player_equipment(undefined);
		self setactionslot(1, "");
	}
	else
	{
		arrayremovevalue(self.deployed_equipment, equipment);
	}

	if (current_weapon)
	{
		if (isdefined(self.last_held_primary_weapon) && self hasweapon(self.last_held_primary_weapon))
		{
			self switchtoweapon(self.last_held_primary_weapon);
		}
		else
		{
			primaryweapons = self getweaponslistprimaries();

			if (isdefined(primaryweapons) && primaryweapons.size > 0)
			{
				self switchtoweapon(primaryweapons[0]);
			}
		}
	}
}

limited_equipment_in_use(equipment)
{
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		current_equipment = players[i] get_player_equipment();

		if (isdefined(current_equipment) && current_equipment == equipment)
		{
			return true;
		}

		if (isdefined(players[i].loadout))
		{
			if (isdefined(players[i].loadout.equipment) && players[i].loadout.equipment == equipment)
			{
				return true;
			}

		}

		if (isdefined(players[i].tombstone_savedweapon_weapons))
		{
			if (isdefined(players[i].tombstone_savedweapon_equipment) && players[i].tombstone_savedweapon_equipment == equipment)
			{
				return true;
			}
		}
	}

	if (isdefined(level.dropped_equipment) && isdefined(level.dropped_equipment[equipment]))
	{
		return true;
	}

	return false;
}