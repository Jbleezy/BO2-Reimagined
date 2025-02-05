#include maps\mp\zombies\_zm_buildables;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_demo;

buildable_place_think()
{
	self endon("kill_trigger");
	player_built = undefined;

	while (isDefined(self.stub.built) && !self.stub.built)
	{
		self waittill("trigger", player);

		bind_to = self.stub.buildable_pool scripts\zm\replaced\_zm_buildables_pooled::pooledbuildable_stub_for_equipname(self.stub);

		if (player != self.parent_player)
		{
			continue;
		}

		if (isDefined(player.screecher_weapon))
		{
			continue;
		}

		if (!is_player_valid(player))
		{
			player thread ignore_triggers(0.5);
		}

		status = player player_can_build(self.stub.buildablezone);

		if (!status)
		{
			self.stub.hint_string = "";
			self sethintstring(self.stub.hint_string);

			if (isDefined(self.stub.oncantuse))
			{
				self.stub [[self.stub.oncantuse]](player);
			}

			continue;
		}
		else
		{
			if (isDefined(self.stub.onbeginuse))
			{
				self.stub [[self.stub.onbeginuse]](player);
			}

			result = self buildable_use_hold_think(player);
			team = player.pers["team"];

			if (isDefined(self.stub.onenduse))
			{
				self.stub [[self.stub.onenduse]](team, player, result);
			}

			if (!result)
			{
				continue;
			}

			if (bind_to != self.stub)
			{
				scripts\zm\replaced\_zm_buildables_pooled::swap_buildable_fields(self.stub, bind_to);
			}

			if (isDefined(self.stub.onuse))
			{
				self.stub [[self.stub.onuse]](player);
			}

			prompt = player maps\mp\zombies\_zm_buildables::player_build(self.stub.buildablezone);
			player_built = player;
			self.stub.hint_string = prompt;
			self sethintstring(self.stub.hint_string);
		}
	}

	if (self.stub.persistent == 4)
	{
		self [[self.stub.custom_completion_callback]](player_built);
		return;
	}

	if (self.stub.persistent == 0)
	{
		self.stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.stub);
		return;
	}

	if (self.stub.persistent == 3)
	{
		maps\mp\zombies\_zm_buildables::stub_unbuild_buildable(self.stub, 1);
		return;
	}

	if (self.stub.persistent == 2)
	{
		if (isDefined(player_built))
		{
			self scripts\zm\replaced\_zm_buildables_pooled::pooledbuildabletrigger_update_prompt(player_built);
		}

		if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined))
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			self sethintstring(self.stub.hint_string);
			return;
		}

		if (isDefined(self.stub.bought) && self.stub.bought)
		{
			self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			self sethintstring(self.stub.hint_string);
			return;
		}

		if (isDefined(self.stub.model))
		{
			self.stub.model notsolid();
			self.stub.model show();
		}

		while (self.stub.persistent == 2)
		{
			self waittill("trigger", player);

			current_weapon = player getCurrentWeapon();

			if (isDefined(player.screecher_weapon) || is_melee_weapon(current_weapon) || is_placeable_mine(current_weapon))
			{
				continue;
			}

			if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined))
			{
				self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				self sethintstring(self.stub.hint_string);
				return;
			}

			if (isDefined(self.stub.built) && !self.stub.built)
			{
				self.stub.hint_string = "";
				self sethintstring(self.stub.hint_string);
				return;
			}

			if (player != self.parent_player)
			{
				continue;
			}

			if (!is_player_valid(player))
			{
				player thread ignore_triggers(0.5);
			}

			if (player.score < self.stub.cost)
			{
				self play_sound_on_ent("no_purchase");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
				continue;
			}

			player maps\mp\zombies\_zm_score::minus_to_player_score(self.stub.cost);
			self play_sound_on_ent("purchase");

			self.stub.bought = 1;

			if (isDefined(self.stub.model))
			{
				self.stub.model thread model_fly_away(self.stub.weaponname);
			}

			player maps\mp\zombies\_zm_weapons::weapon_give(self.stub.weaponname);

			if (isDefined(level.zombie_include_buildables[self.stub.equipname].onbuyweapon))
			{
				self [[level.zombie_include_buildables[self.stub.equipname].onbuyweapon]](player);
			}

			if (isDefined(level.zombie_buildables[self.stub.equipname].bought))
			{
				self.stub.hint_string = level.zombie_buildables[self.stub.equipname].bought;
			}
			else
			{
				if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.stub.weaponname, undefined))
				{
					self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				}
				else
				{
					self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
				}
			}

			self sethintstring(self.stub.hint_string);
			player maps\mp\zombies\_zm_buildables::track_buildables_pickedup(self.stub.weaponname);
		}
	}
	else
	{
		if (!isDefined(player_built) || self scripts\zm\replaced\_zm_buildables_pooled::pooledbuildabletrigger_update_prompt(player_built))
		{
			if (isDefined(self.stub.model))
			{
				self.stub.model notsolid();
				self.stub.model show();
			}

			if (!isDefined(self.stub.stand_model) && maps\mp\zombies\_zm_equipment::is_limited_equipment(self.stub.weaponname))
			{
				self.stub.stand_model = spawn("script_model", self.stub.model.origin);
				self.stub.stand_model.angles = self.stub.model.angles;

				if (self.stub.weaponname == "jetgun_zm")
				{
					self.stub.stand_model setModel("p6_zm_buildable_sq_electric_box");
					self.stub.stand_model.origin += (0, 0, -23);
					self.stub.stand_model.angles += (0, 90, 90);
				}
			}

			while (self.stub.persistent == 1)
			{
				self waittill("trigger", player);

				if (isDefined(player.screecher_weapon))
				{
					continue;
				}

				if (isDefined(self.stub.built) && !self.stub.built)
				{
					self.stub.hint_string = "";
					self sethintstring(self.stub.hint_string);
					return;
				}

				if (player != self.parent_player)
				{
					continue;
				}

				if (!is_player_valid(player))
				{
					player thread ignore_triggers(0.5);
				}

				riotshield_repair = 0;

				if (player has_player_equipment(self.stub.weaponname))
				{
					if (!(self.stub.weaponname == level.riotshield_name && player has_player_damaged_riotshield_equipped()))
					{
						continue;
					}

					riotshield_repair = 1;
				}

				if (player.score < self.stub.cost)
				{
					self play_sound_on_ent("no_purchase");
					player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
					continue;
				}

				if (!maps\mp\zombies\_zm_equipment::is_limited_equipment(self.stub.weaponname) || !maps\mp\zombies\_zm_equipment::limited_equipment_in_use(self.stub.weaponname))
				{
					player maps\mp\zombies\_zm_score::minus_to_player_score(self.stub.cost);
					self play_sound_on_ent("purchase");

					if (riotshield_repair)
					{
						if (isdefined(player.player_shield_reset_health))
						{
							player [[player.player_shield_reset_health]]();
						}

						self.stub.hint_string = &"ZOMBIE_BOUGHT_RIOT_REPAIR";
						self sethintstring(self.stub.hint_string);
						player maps\mp\zombies\_zm_buildables::track_buildables_pickedup(self.stub.weaponname);

						continue;
					}

					player maps\mp\zombies\_zm_equipment::equipment_buy(self.stub.weaponname);
					player giveweapon(self.stub.weaponname);
					player setweaponammoclip(self.stub.weaponname, 1);

					if (maps\mp\zombies\_zm_equipment::is_limited_equipment(self.stub.weaponname))
					{
						if (isDefined(self.stub.model))
						{
							self.stub.model thread model_go_away(self.stub.weaponname);
						}
					}

					if (isDefined(level.zombie_include_buildables[self.stub.equipname].onbuyweapon))
					{
						self [[level.zombie_include_buildables[self.stub.equipname].onbuyweapon]](player);
					}

					if (self.stub.weaponname != "keys_zm")
					{
						player setactionslot(1, "weapon", self.stub.weaponname);
					}

					if (isDefined(level.zombie_buildables[self.stub.equipname].bought))
					{
						self.stub.hint_string = level.zombie_buildables[self.stub.equipname].bought;
					}
					else
					{
						self.stub.hint_string = "";
					}

					self sethintstring(self.stub.hint_string);
					player maps\mp\zombies\_zm_buildables::track_buildables_pickedup(self.stub.weaponname);
					continue;
				}
				else
				{
					self.stub.hint_string = "";
					self sethintstring(self.stub.hint_string);
				}
			}
		}
	}
}

player_can_build(buildable, continuing)
{
	if (!isdefined(buildable))
	{
		return false;
	}

	if (isdefined(continuing) && continuing)
	{
		if (buildable buildable_is_piece_built(buildable.pieces[0]))
		{
			return false;
		}
	}
	else if (buildable buildable_is_piece_built_or_building(buildable.pieces[0]))
	{
		return false;
	}

	if (isdefined(buildable.stub) && isdefined(buildable.stub.custom_buildablestub_update_prompt) && isdefined(buildable.stub.playertrigger[0]) && isdefined(buildable.stub.playertrigger[0].stub) && !buildable.stub.playertrigger[0].stub [[buildable.stub.custom_buildablestub_update_prompt]](self, 1, buildable.stub.playertrigger[0]))
	{
		return false;
	}

	return true;
}

buildable_use_hold_think(player, bind_stub = self.stub)
{
	self thread buildable_play_build_fx(player);
	self thread buildable_use_hold_think_internal(player, bind_stub);
	retval = self waittill_any_return("build_succeed", "build_failed");

	if (retval == "build_succeed")
	{
		return true;
	}

	return false;
}

buildable_use_hold_think_internal(player, bind_stub = self.stub)
{
	wait 0.01;

	if (!isdefined(self))
	{
		self notify("build_failed");

		if (isdefined(player.buildableaudio))
		{
			player.buildableaudio delete();
			player.buildableaudio = undefined;
		}

		return;
	}

	if (!isdefined(self.usetime))
	{
		self.usetime = int(3000);
	}

	self.build_time = self.usetime;
	self.build_start_time = gettime();
	build_time = self.build_time;
	build_start_time = self.build_start_time;
	player disable_player_move_states(1);
	player increment_is_drinking();
	orgweapon = player getcurrentweapon();
	build_weapon = "zombie_builder_zm";

	if (isdefined(bind_stub.build_weapon))
	{
		build_weapon = bind_stub.build_weapon;
	}

	player giveweapon(build_weapon);
	player switchtoweapon(build_weapon);
	bind_stub.buildablezone buildable_set_piece_building(bind_stub.buildablezone.pieces[0]);
	player thread player_progress_bar(build_start_time, build_time, bind_stub.building_prompt);

	if (isdefined(level.buildable_build_custom_func))
	{
		player thread [[level.buildable_build_custom_func]](self.stub);
	}

	while (isdefined(self) && player player_continue_building(bind_stub.buildablezone, self.stub) && gettime() - self.build_start_time < self.build_time)
	{
		wait 0.05;
	}

	player notify("buildable_progress_end");

	if (player hasWeapon(orgweapon))
	{
		player switchToWeapon(orgweapon);
	}
	else
	{
		player maps\mp\zombies\_zm_weapons::switch_back_primary_weapon(orgweapon);
	}

	player takeweapon("zombie_builder_zm");

	if (isdefined(player.is_drinking) && player.is_drinking)
	{
		player decrement_is_drinking();
	}

	player enable_player_move_states();

	if (isdefined(self) && player player_continue_building(bind_stub.buildablezone, self.stub) && gettime() - self.build_start_time >= self.build_time)
	{
		buildable_clear_piece_building(bind_stub.buildablezone.pieces[0]);
		self notify("build_succeed");
	}
	else
	{
		if (isdefined(player.buildableaudio))
		{
			player.buildableaudio delete();
			player.buildableaudio = undefined;
		}

		buildable_clear_piece_building(bind_stub.buildablezone.pieces[0]);
		self notify("build_failed");
	}
}

player_continue_building(buildablezone, build_stub = buildablezone.stub)
{
	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || self in_revive_trigger())
	{
		return false;
	}

	if (self isthrowinggrenade())
	{
		return false;
	}

	if (!self player_can_build(buildablezone, 1))
	{
		return false;
	}

	if (isdefined(self.screecher))
	{
		return false;
	}

	if (!self usebuttonpressed())
	{
		return false;
	}

	if (!buildablezone buildable_is_piece_building(buildablezone.pieces[0]))
	{
		return false;
	}

	trigger = build_stub maps\mp\zombies\_zm_unitrigger::unitrigger_trigger(self);

	if (build_stub.script_unitrigger_type == "unitrigger_radius_use")
	{
		torigin = build_stub unitrigger_origin();
		porigin = self geteye();
		radius_sq = 2.25 * build_stub.test_radius_sq;

		if (distance2dsquared(torigin, porigin) > radius_sq)
		{
			return false;
		}
	}
	else if (!isdefined(trigger) || !trigger istouching(self))
	{
		return false;
	}

	if (isdefined(build_stub.require_look_at) && build_stub.require_look_at && !self is_player_looking_at(trigger.origin, 0.4))
	{
		return false;
	}

	return true;
}

player_build(buildable, pieces)
{
	foreach (piece in buildable.pieces)
	{
		buildable buildable_set_piece_built(piece);
	}

	if (isdefined(buildable.stub.model))
	{
		for (i = 0; i < buildable.pieces.size; i++)
		{
			if (isdefined(buildable.pieces[i].part_name))
			{
				buildable.stub.model notsolid();

				if (!(isdefined(buildable.pieces[i].built) && buildable.pieces[i].built))
				{
					buildable.stub.model hidepart(buildable.pieces[i].part_name);
					continue;
				}

				buildable.stub.model show();
				buildable.stub.model showpart(buildable.pieces[i].part_name);
			}
		}
	}

	if (isplayer(self))
	{
		self track_buildable_pieces_built(buildable);
	}

	if (buildable buildable_all_built())
	{
		self player_finish_buildable(buildable);
		buildable.stub buildablestub_finish_build(self);

		if (isplayer(self))
		{
			self track_buildables_built(buildable);
		}

		if (isdefined(level.buildable_built_custom_func))
		{
			self thread [[level.buildable_built_custom_func]](buildable);
		}

		alias = sndbuildablecompletealias(buildable.buildable_name);
		self playsound(alias);
	}
	else
	{
		self playsound("zmb_buildable_piece_add");
		assert(isdefined(level.zombie_buildables[buildable.buildable_name].building), "Missing builing hint");

		if (isdefined(level.zombie_buildables[buildable.buildable_name].building))
		{
			return level.zombie_buildables[buildable.buildable_name].building;
		}
	}

	return "";
}

player_progress_bar(start_time, build_time, building_prompt)
{
	self.usebar = self createprimaryprogressbar();
	self.usebartext = self createprimaryprogressbartext();
	self.usebar.foreground = 1;
	self.usebar.bar.foreground = 1;
	self.usebar.barframe.foreground = 1;
	self.usebartext.foreground = 1;

	if (isdefined(building_prompt))
	{
		self.usebartext settext(building_prompt);
	}
	else
	{
		self.usebartext settext(&"ZOMBIE_BUILDING");
	}

	if (isdefined(self) && isdefined(start_time) && isdefined(build_time))
	{
		self player_progress_bar_update(start_time, build_time);
	}

	self.usebartext destroyelem();
	self.usebar destroyelem();
}

player_progress_bar_update(start_time, build_time)
{
	self endon("entering_last_stand");
	self endon("death");
	self endon("disconnect");
	self endon("buildable_progress_end");

	self.usebar updatebar(0.01, 1000 / build_time);

	while (isdefined(self) && gettime() - start_time < build_time)
	{
		wait 0.05;
	}
}

model_go_away(weaponname)
{
	self hide();

	while (maps\mp\zombies\_zm_equipment::limited_equipment_in_use(weaponname))
	{
		wait 0.05;
	}

	self show();
}

model_fly_away(weaponname)
{
	origin = self.origin;
	self moveto(self.origin + vectorscale((0, 0, 1), 40.0), 3);
	direction = self.origin;
	direction = (direction[1], direction[0], 0);

	if (direction[1] < 0 || direction[0] > 0 && direction[1] > 0)
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if (direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}

	self vibrate(direction, 10, 0.5, 3);

	self waittill("movedone");

	self.origin = origin;
	self.angles = (0, self.angles[1], 0);
	self hide();
	playfx(level._effect["poltergeist"], self.origin);

	self thread model_fly_away_think(weaponname);
}

model_fly_away_think(weaponname)
{
	joker_model = spawn("script_model", self.origin - (0, 0, 14));
	joker_model.angles = self.angles + (0, 90, 0);
	joker_model setModel(level.chest_joker_model);

	while (1)
	{
		while (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(weaponname, undefined))
		{
			wait 0.05;
		}

		joker_model rotateto(joker_model.angles + (90, 0, 0), 0.5);
		joker_model waittill("rotatedone");

		while (maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(weaponname, undefined))
		{
			wait 0.05;
		}

		joker_model rotateto(joker_model.angles - (90, 0, 0), 0.5);
		joker_model waittill("rotatedone");
	}
}

buildablestub_update_prompt(player)
{
	if (!self anystub_update_prompt(player))
	{
		return false;
	}

	can_use = 1;

	if (isdefined(self.buildablestub_reject_func))
	{
		rval = self [[self.buildablestub_reject_func]](player);

		if (rval)
		{
			return false;
		}
	}

	if (isdefined(self.custom_buildablestub_update_prompt) && !self [[self.custom_buildablestub_update_prompt]](player))
	{
		return false;
	}

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;

	if (!(isdefined(self.built) && self.built))
	{
		slot = self.buildablestruct.buildable_slot;

		if (!isdefined(player player_get_buildable_piece(slot)))
		{
			if (isdefined(level.zombie_buildables[self.equipname].hint_more))
			{
				self.hint_string = level.zombie_buildables[self.equipname].hint_more;
			}
			else
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			}

			return false;
		}
		else if (!self.buildablezone buildable_has_piece(player player_get_buildable_piece(slot)))
		{
			if (isdefined(level.zombie_buildables[self.equipname].hint_wrong))
			{
				self.hint_string = level.zombie_buildables[self.equipname].hint_wrong;
			}
			else
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
			}

			return false;
		}
		else
		{
			assert(isdefined(level.zombie_buildables[self.equipname].hint), "Missing buildable hint");

			if (isdefined(level.zombie_buildables[self.equipname].hint))
			{
				self.hint_string = level.zombie_buildables[self.equipname].hint;
			}
			else
			{
				self.hint_string = "Missing buildable hint";
			}
		}
	}
	else if (self.persistent == 1)
	{
		if (maps\mp\zombies\_zm_equipment::is_limited_equipment(self.weaponname) && maps\mp\zombies\_zm_equipment::limited_equipment_in_use(self.weaponname))
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
			return false;
		}

		if (player has_player_equipment(self.weaponname))
		{
			if (isdefined(level.riotshield_name) && self.weaponname == level.riotshield_name && player has_player_damaged_riotshield_equipped())
			{
				self.hint_string = &"ZOMBIE_REPAIR_RIOTSHIELD";
				return true;
			}

			self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
			return false;
		}

		if (getdvarint("tu12_zombies_allow_hint_weapon_from_script"))
		{
			self.cursor_hint = "HINT_WEAPON";
			self.cursor_hint_weapon = self.weaponname;
		}

		self.hint_string = self.trigger_hintstring;
	}
	else if (self.persistent == 2)
	{
		if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.weaponname, undefined))
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
			return false;
		}
		else if (isdefined(self.bought) && self.bought)
		{
			self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
			return false;
		}

		self.hint_string = self.trigger_hintstring;
	}
	else
	{
		self.hint_string = "";
		return false;
	}

	return true;
}

has_player_damaged_riotshield_equipped()
{
	return is_true(self.hasriotshield) && isdefined(self.shielddamagetaken) && self.shielddamagetaken > 0;
}