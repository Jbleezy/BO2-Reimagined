#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

init(weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn)
{
	precacheitem(weapon_name);
	precacheitem(flourish_weapon_name);
	precacheitem("held_" + weapon_name);

	if (scripts\zm\_zm_reimagined::is_held_melee_weapon_offhand_melee(weapon_name))
	{
		precacheitem("held_" + weapon_name + "_offhand");
	}

	add_melee_weapon(weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn);
	melee_weapon_triggers = getentarray(wallbuy_targetname, "targetname");

	for (i = 0; i < melee_weapon_triggers.size; i++)
	{
		knife_model = getent(melee_weapon_triggers[i].target, "targetname");

		if (isdefined(knife_model))
			knife_model hide();

		melee_weapon_triggers[i] thread melee_weapon_think(weapon_name, cost, flourish_fn, vo_dialog_id, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name);

		if (!(isdefined(level.monolingustic_prompt_format) && level.monolingustic_prompt_format))
		{
			melee_weapon_triggers[i] sethintstring(hint_string, cost);

			cursor_hint = "HINT_WEAPON";
			cursor_hint_weapon = weapon_name;
			melee_weapon_triggers[i] setcursorhint(cursor_hint, cursor_hint_weapon);
		}
		else
		{
			weapon_display = get_weapon_display_name(weapon_name);
			hint_string = &"ZOMBIE_WEAPONCOSTONLY";
			melee_weapon_triggers[i] sethintstring(hint_string, weapon_display, cost);

			cursor_hint = "HINT_WEAPON";
			cursor_hint_weapon = weapon_name;
			melee_weapon_triggers[i] setcursorhint(cursor_hint, cursor_hint_weapon);
		}

		melee_weapon_triggers[i] usetriggerrequirelookat();
	}

	melee_weapon_structs = getstructarray(wallbuy_targetname, "targetname");

	for (i = 0; i < melee_weapon_structs.size; i++)
		prepare_stub(melee_weapon_structs[i].trigger_stub, weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn);

	register_melee_weapon_for_level(weapon_name);

	if (!isdefined(level.ballistic_weapon_name))
		level.ballistic_weapon_name = [];

	level.ballistic_weapon_name[weapon_name] = ballistic_weapon_name;

	if (!isdefined(level.ballistic_upgraded_weapon_name))
		level.ballistic_upgraded_weapon_name = [];

	level.ballistic_upgraded_weapon_name[weapon_name] = ballistic_upgraded_weapon_name;
}

prepare_stub(stub, weapon_name, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, cost, wallbuy_targetname, hint_string, vo_dialog_id, flourish_fn)
{
	if (isdefined(stub))
	{
		if (!(isdefined(level.monolingustic_prompt_format) && level.monolingustic_prompt_format))
		{
			stub.hint_string = hint_string;

			stub.cursor_hint = "HINT_WEAPON";
			stub.cursor_hint_weapon = weapon_name;
		}
		else
		{
			stub.hint_parm1 = get_weapon_display_name(weapon_name);
			stub.hint_parm2 = cost;
			stub.hint_string = &"ZOMBIE_WEAPONCOSTONLY";

			stub.cursor_hint = "HINT_WEAPON";
			stub.cursor_hint_weapon = weapon_name;
		}

		stub.cost = cost;
		stub.weapon_name = weapon_name;
		stub.vo_dialog_id = vo_dialog_id;
		stub.flourish_weapon_name = flourish_weapon_name;
		stub.ballistic_weapon_name = ballistic_weapon_name;
		stub.ballistic_upgraded_weapon_name = ballistic_upgraded_weapon_name;
		stub.trigger_func = ::melee_weapon_think;
		stub.flourish_fn = flourish_fn;
	}
}

change_melee_weapon(weapon_name, current_weapon)
{
	current_melee_weapon = self get_player_melee_weapon();

	if (isDefined(current_melee_weapon) && current_melee_weapon != weapon_name)
	{
		self takeweapon(current_melee_weapon);
		unacquire_weapon_toggle(current_melee_weapon);
	}

	self set_player_melee_weapon(weapon_name);
	had_ballistic = 0;
	had_ballistic_upgraded = 0;
	ballistic_was_primary = 0;
	old_ballistic = undefined;
	ballistic_ammo_clip = 0;
	ballistic_ammo_stock = 0;
	primaryweapons = self getweaponslistprimaries();
	i = 0;

	while (i < primaryweapons.size)
	{
		primary_weapon = primaryweapons[i];

		if (issubstr(primary_weapon, "knife_ballistic_"))
		{
			had_ballistic = 1;

			if (primary_weapon == current_weapon)
			{
				ballistic_was_primary = 1;
			}

			old_ballistic = primary_weapon;
			ballistic_ammo_clip = self getWeaponAmmoClip(primary_weapon);
			ballistic_ammo_stock = self getWeaponAmmoStock(primary_weapon);
			self takeweapon(primary_weapon);
			unacquire_weapon_toggle(primary_weapon);

			if (issubstr(primary_weapon, "upgraded"))
			{
				had_ballistic_upgraded = 1;
			}
		}

		i++;
	}

	if (had_ballistic)
	{
		if (had_ballistic_upgraded)
		{
			new_ballistic = level.ballistic_upgraded_weapon_name[weapon_name];

			if (ballistic_was_primary)
			{
				current_weapon = new_ballistic;
			}

			self giveweapon(new_ballistic, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(new_ballistic));
		}
		else
		{
			new_ballistic = level.ballistic_weapon_name[weapon_name];

			if (ballistic_was_primary)
			{
				current_weapon = new_ballistic;
			}

			self giveweapon(new_ballistic, 0);
		}

		self setweaponammoclip(new_ballistic, ballistic_ammo_clip);
		self setweaponammostock(new_ballistic, ballistic_ammo_stock);
		self seteverhadweaponall(1);
	}

	self giveweapon("held_" + weapon_name);

	if (!self hasweapon("time_bomb_zm") && !self hasweapon("time_bomb_detonator_zm"))
	{
		self setactionslot(2, "weapon", "held_" + weapon_name);
	}

	return current_weapon;
}

give_melee_weapon(vo_dialog_id, flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, flourish_fn, trigger)
{
	if (isdefined(flourish_fn))
		self thread [[flourish_fn]]();

	self thread do_melee_weapon_change(weapon_name);

	self.pre_temp_weapon = self do_melee_weapon_flourish_begin(flourish_weapon_name);
	self maps\mp\zombies\_zm_audio::create_and_play_dialog("weapon_pickup", vo_dialog_id);
	self waittill_any("fake_death", "death", "player_downed", "weapon_change_complete");
	self do_melee_weapon_flourish_end(self.pre_temp_weapon, flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name);

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(self.intermission) && self.intermission)
		return;

	self.pre_temp_weapon = undefined;

	if (!(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching))
	{
		if (isdefined(trigger))
			trigger setinvisibletoplayer(self);

		self trigger_hide_all();
	}
}

do_melee_weapon_change(weapon_name)
{
	self endon("disconnect");
	self endon("death");
	self endon("fake_death");
	self endon("player_downed");

	self waittill_any("weapon_change", "weapon_change_complete");

	self giveweapon(weapon_name);
	self.pre_temp_weapon = change_melee_weapon(weapon_name, self.pre_temp_weapon);
}

do_melee_weapon_flourish_end(gun, flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name)
{
	assert(!is_zombie_perk_bottle(gun));
	assert(gun != level.revive_tool);
	self enable_player_move_states();

	self takeweapon(flourish_weapon_name);

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(self.intermission) && self.intermission)
	{
		self.lastactiveweapon = self.pre_temp_weapon;
		return;
	}

	if (self is_multiple_drinking())
	{
		self decrement_is_drinking();
		return;
	}
	else if (is_melee_weapon(gun))
	{
		self switchtoweapon("held_" + weapon_name);
		self decrement_is_drinking();
		return;
	}
	else if (gun != "none" && !is_placeable_mine(gun) && !is_equipment(gun))
		self switchtoweapon(gun);
	else
	{
		primaryweapons = self getweaponslistprimaries();

		if (isdefined(primaryweapons) && primaryweapons.size > 0)
			self switchtoweapon(primaryweapons[0]);
	}

	self waittill("weapon_change_complete");

	if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(isdefined(self.intermission) && self.intermission))
		self decrement_is_drinking();
}

melee_weapon_think(weapon_name, cost, flourish_fn, vo_dialog_id, flourish_weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name)
{
	self.first_time_triggered = 0;

	if (isdefined(self.stub))
	{
		self endon("kill_trigger");

		if (isdefined(self.stub.first_time_triggered))
			self.first_time_triggered = self.stub.first_time_triggered;

		weapon_name = self.stub.weapon_name;
		cost = self.stub.cost;
		flourish_fn = self.stub.flourish_fn;
		vo_dialog_id = self.stub.vo_dialog_id;
		flourish_weapon_name = self.stub.flourish_weapon_name;
		ballistic_weapon_name = self.stub.ballistic_weapon_name;
		ballistic_upgraded_weapon_name = self.stub.ballistic_upgraded_weapon_name;
		players = getplayers();

		if (!(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching))
		{
			for (i = 0; i < players.size; i++)
			{
				if (!players[i] player_can_see_weapon_prompt(weapon_name))
					self setinvisibletoplayer(players[i]);
			}
		}
	}

	for (;;)
	{
		self waittill("trigger", player);

		if (!is_player_valid(player))
		{
			player thread ignore_triggers(0.5);
			continue;
		}

		if (player in_revive_trigger())
		{
			wait 0.1;
			continue;
		}

		if (player isthrowinggrenade())
		{
			wait 0.1;
			continue;
		}

		if (player.is_drinking > 0)
		{
			wait 0.1;
			continue;
		}

		if (player hasweapon(weapon_name) || player hasweapon("held_" + weapon_name) || player has_powerup_weapon())
		{
			wait 0.1;
			continue;
		}

		if (player isswitchingweapons())
		{
			wait 0.1;
			continue;
		}

		current_weapon = player getcurrentweapon();

		if (is_placeable_mine(current_weapon) || is_equipment(current_weapon) || player has_powerup_weapon())
		{
			wait 0.1;
			continue;
		}

		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(player.intermission) && player.intermission)
		{
			wait 0.1;
			continue;
		}

		player_has_weapon = player hasweapon(weapon_name);

		if (!player_has_weapon)
		{
			cost = self.stub.cost;

			if (player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active())
				cost = int(cost / 2);

			if (player.score >= cost)
			{
				if (self.first_time_triggered == 0)
				{
					model = getent(self.target, "targetname");

					if (isdefined(model))
						model thread melee_weapon_show(player);
					else if (isdefined(self.clientfieldname))
						level setclientfield(self.clientfieldname, 1);

					self.first_time_triggered = 1;

					if (isdefined(self.stub))
						self.stub.first_time_triggered = 1;
				}

				player maps\mp\zombies\_zm_score::minus_to_player_score(cost, 1);
				bbprint("zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", player.name, player.score, level.round_number, cost, weapon_name, self.origin, "weapon");
				player thread give_melee_weapon(vo_dialog_id, flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, flourish_fn, self);
			}
			else
			{
				play_sound_on_ent("no_purchase");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon", undefined, 1);
			}

			continue;
		}

		if (!(isdefined(level._allow_melee_weapon_switching) && level._allow_melee_weapon_switching))
			self setinvisibletoplayer(player);
	}
}