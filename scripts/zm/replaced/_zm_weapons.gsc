#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init_weapon_upgrade()
{
	scripts\zm\_zm_reimagined::weapon_changes();

	init_spawnable_weapon_upgrade();
}

init_spawnable_weapon_upgrade()
{
	spawn_list = [];
	spawnable_weapon_spawns = getstructarray("weapon_upgrade", "targetname");
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("bowie_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("sickle_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("tazer_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("buildable_wallbuy", "targetname"), 1, 0);

	if (!is_true(level.headshots_only))
	{
		spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("claymore_purchase", "targetname"), 1, 0);
	}

	match_string = "";
	location = level.scr_zm_map_start_location;

	if ((location == "default" || location == "") && isdefined(level.default_start_location))
	{
		location = level.default_start_location;
	}

	match_string = level.scr_zm_ui_gametype;

	if ("" != location)
	{
		match_string = match_string + "_" + location;
	}

	match_string_plus_space = " " + match_string;

	for (i = 0; i < spawnable_weapon_spawns.size; i++)
	{
		spawnable_weapon = spawnable_weapon_spawns[i];

		if (isdefined(spawnable_weapon.zombie_weapon_upgrade) && spawnable_weapon.zombie_weapon_upgrade == "sticky_grenade_zm" && is_true(level.headshots_only))
		{
			continue;
		}

		if (!isdefined(spawnable_weapon.script_noteworthy) || spawnable_weapon.script_noteworthy == "")
		{
			spawn_list[spawn_list.size] = spawnable_weapon;
			continue;
		}

		matches = strtok(spawnable_weapon.script_noteworthy, ",");

		for (j = 0; j < matches.size; j++)
		{
			if (matches[j] == match_string || matches[j] == match_string_plus_space)
			{
				spawn_list[spawn_list.size] = spawnable_weapon;
			}
		}
	}

	tempmodel = spawn("script_model", (0, 0, 0));

	for (i = 0; i < spawn_list.size; i++)
	{
		clientfieldname = undefined;
		target_struct = getstruct(spawn_list[i].target, "targetname");

		if (!(isdefined(spawn_list[i].script_string) && spawn_list[i].script_string == "disable_clientfield"))
		{
			clientfieldname = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;
			numbits = 2;

			if (isdefined(level._wallbuy_override_num_bits))
			{
				numbits = level._wallbuy_override_num_bits;
			}

			registerclientfield("world", clientfieldname, 1, numbits, "int");

			if (spawn_list[i].targetname == "buildable_wallbuy")
			{
				bits = 4;

				if (isdefined(level.buildable_wallbuy_weapons))
				{
					bits = getminbitcountfornum(level.buildable_wallbuy_weapons.size + 1);
				}

				registerclientfield("world", clientfieldname + "_idx", 12000, bits, "int");
				spawn_list[i].clientfieldname = clientfieldname;
				continue;
			}
		}

		precachemodel(target_struct.model);
		unitrigger_stub = spawnstruct();
		unitrigger_stub.origin = spawn_list[i].origin;
		unitrigger_stub.angles = spawn_list[i].angles;
		tempmodel.origin = spawn_list[i].origin;
		tempmodel.angles = spawn_list[i].angles;
		mins = undefined;
		maxs = undefined;
		absmins = undefined;
		absmaxs = undefined;
		tempmodel setmodel(target_struct.model);
		tempmodel useweaponhidetags(spawn_list[i].zombie_weapon_upgrade);
		mins = tempmodel getmins();
		maxs = tempmodel getmaxs();
		absmins = tempmodel getabsmins();
		absmaxs = tempmodel getabsmaxs();
		bounds = absmaxs - absmins;
		unitrigger_stub.script_length = 64;
		unitrigger_stub.script_width = bounds[1];
		unitrigger_stub.script_height = bounds[2];
		unitrigger_stub.origin -= anglestoright(unitrigger_stub.angles) * (bounds[0] * 0.1);
		unitrigger_stub.target = spawn_list[i].target;
		unitrigger_stub.targetname = spawn_list[i].targetname;
		unitrigger_stub.cursor_hint = "HINT_NOICON";

		if (spawn_list[i].targetname == "weapon_upgrade")
		{
			unitrigger_stub.cost = get_weapon_cost(spawn_list[i].zombie_weapon_upgrade);

			if (!(isdefined(level.monolingustic_prompt_format) && level.monolingustic_prompt_format))
			{
				unitrigger_stub.hint_string = get_weapon_hint(spawn_list[i].zombie_weapon_upgrade);
				unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
			}
			else
			{
				unitrigger_stub.hint_parm1 = get_weapon_display_name(spawn_list[i].zombie_weapon_upgrade);

				if (!isdefined(unitrigger_stub.hint_parm1) || unitrigger_stub.hint_parm1 == "" || unitrigger_stub.hint_parm1 == "none")
				{
					unitrigger_stub.hint_parm1 = "missing weapon name " + spawn_list[i].zombie_weapon_upgrade;
				}

				unitrigger_stub.hint_parm2 = unitrigger_stub.cost;
				unitrigger_stub.hint_string = &"ZOMBIE_WEAPONCOSTONLY";
			}
		}

		unitrigger_stub.weapon_upgrade = spawn_list[i].zombie_weapon_upgrade;
		unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		unitrigger_stub.require_look_at = 1;

		if (isdefined(spawn_list[i].require_look_from) && spawn_list[i].require_look_from)
		{
			unitrigger_stub.require_look_from = 1;
		}

		unitrigger_stub.zombie_weapon_upgrade = spawn_list[i].zombie_weapon_upgrade;
		unitrigger_stub.clientfieldname = clientfieldname;
		maps\mp\zombies\_zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);

		if (is_melee_weapon(unitrigger_stub.zombie_weapon_upgrade))
		{
			if (unitrigger_stub.zombie_weapon_upgrade == "tazer_knuckles_zm")
			{
				unitrigger_stub.origin += (anglesToForward(unitrigger_stub.angles) * -7) + (anglesToRight(unitrigger_stub.angles) * -2);
			}

			maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, ::weapon_spawn_think);
		}
		else if (unitrigger_stub.zombie_weapon_upgrade == "claymore_zm")
		{
			unitrigger_stub.prompt_and_visibility_func = scripts\zm\replaced\_zm_weap_claymore::claymore_unitrigger_update_prompt;
			maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, scripts\zm\replaced\_zm_weap_claymore::buy_claymores);
		}
		else if (unitrigger_stub.zombie_weapon_upgrade == "bouncingbetty_zm")
		{
			unitrigger_stub.prompt_and_visibility_func = scripts\zm\reimagined\_zm_weap_bouncingbetty::betty_unitrigger_update_prompt;
			maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, scripts\zm\reimagined\_zm_weap_bouncingbetty::buy_betties);
		}
		else
		{
			if (is_lethal_grenade(unitrigger_stub.zombie_weapon_upgrade))
			{
				unitrigger_stub.prompt_and_visibility_func = ::lethal_grenade_update_prompt;
			}
			else
			{
				unitrigger_stub.prompt_and_visibility_func = ::wall_weapon_update_prompt;
			}

			maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, ::weapon_spawn_think);
		}

		spawn_list[i].trigger_stub = unitrigger_stub;
	}

	level._spawned_wallbuys = spawn_list;
	tempmodel delete();
}

add_dynamic_wallbuy(weapon, wallbuy, pristine)
{
	spawned_wallbuy = undefined;

	for (i = 0; i < level._spawned_wallbuys.size; i++)
	{
		if (level._spawned_wallbuys[i].target == wallbuy)
		{
			spawned_wallbuy = level._spawned_wallbuys[i];
			break;
		}
	}

	if (!isdefined(spawned_wallbuy))
	{
		return;
	}

	if (isdefined(spawned_wallbuy.trigger_stub))
	{
		return;
	}

	target_struct = getstruct(wallbuy, "targetname");
	wallmodel = spawn_weapon_model(weapon, undefined, target_struct.origin, target_struct.angles);
	clientfieldname = spawned_wallbuy.clientfieldname;
	model = getweaponmodel(weapon);
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = target_struct.origin;
	unitrigger_stub.angles = target_struct.angles;
	wallmodel.origin = target_struct.origin;
	wallmodel.angles = target_struct.angles;
	mins = undefined;
	maxs = undefined;
	absmins = undefined;
	absmaxs = undefined;
	wallmodel setmodel(model);
	wallmodel useweaponhidetags(weapon);
	mins = wallmodel getmins();
	maxs = wallmodel getmaxs();
	absmins = wallmodel getabsmins();
	absmaxs = wallmodel getabsmaxs();
	bounds = absmaxs - absmins;
	unitrigger_stub.script_length = 64;
	unitrigger_stub.script_width = bounds[1];
	unitrigger_stub.script_height = bounds[2];
	unitrigger_stub.origin -= anglestoright(unitrigger_stub.angles) * (bounds[0] * 0.1);
	unitrigger_stub.target = spawned_wallbuy.target;
	unitrigger_stub.targetname = "weapon_upgrade";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.first_time_triggered = !pristine;

	if (!is_melee_weapon(weapon))
	{
		if (pristine || weapon == "claymore_zm" || weapon == "bouncingbetty_zm")
		{
			unitrigger_stub.hint_string = get_weapon_hint(weapon);
		}
		else
		{
			unitrigger_stub.hint_string = get_weapon_hint_ammo();
		}

		unitrigger_stub.cost = get_weapon_cost(weapon);
		unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
	}

	unitrigger_stub.weapon_upgrade = weapon;
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = 1;
	unitrigger_stub.zombie_weapon_upgrade = weapon;
	unitrigger_stub.clientfieldname = clientfieldname;
	unitrigger_force_per_player_triggers(unitrigger_stub, 1);

	if (is_melee_weapon(weapon))
	{
		if (weapon == "tazer_knuckles_zm")
		{
			unitrigger_stub.origin += (anglesToForward(unitrigger_stub.angles) * -7) + (anglesToRight(unitrigger_stub.angles) * -2);
		}

		maps\mp\zombies\_zm_melee_weapon::add_stub(unitrigger_stub, weapon);
		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, maps\mp\zombies\_zm_melee_weapon::melee_weapon_think);
	}
	else if (weapon == "claymore_zm")
	{
		unitrigger_stub.prompt_and_visibility_func = maps\mp\zombies\_zm_weap_claymore::claymore_unitrigger_update_prompt;
		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, maps\mp\zombies\_zm_weap_claymore::buy_claymores);
	}
	else if (weapon == "bouncingbetty_zm")
	{
		unitrigger_stub.prompt_and_visibility_func = scripts\zm\reimagined\_zm_weap_bouncingbetty::betty_unitrigger_update_prompt;
		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, scripts\zm\reimagined\_zm_weap_bouncingbetty::buy_betties);
	}
	else
	{
		if (is_lethal_grenade(unitrigger_stub.zombie_weapon_upgrade))
		{
			unitrigger_stub.prompt_and_visibility_func = ::lethal_grenade_update_prompt;
		}
		else
		{
			unitrigger_stub.prompt_and_visibility_func = ::wall_weapon_update_prompt;
		}

		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(unitrigger_stub, ::weapon_spawn_think);
	}

	spawned_wallbuy.trigger_stub = unitrigger_stub;
	weaponidx = undefined;

	if (isdefined(level.buildable_wallbuy_weapons))
	{
		for (i = 0; i < level.buildable_wallbuy_weapons.size; i++)
		{
			if (weapon == level.buildable_wallbuy_weapons[i])
			{
				weaponidx = i;
				break;
			}
		}
	}

	if (isdefined(weaponidx))
	{
		level setclientfield(clientfieldname + "_idx", weaponidx + 1);
		wallmodel delete();

		if (!pristine)
		{
			level setclientfield(clientfieldname, 1);
		}
	}
	else
	{
		level setclientfield(clientfieldname, 1);
		wallmodel show();
	}
}

lethal_grenade_update_prompt(player)
{
	weapon = self.stub.zombie_weapon_upgrade;

	cost = get_weapon_cost(weapon);
	self.stub.hint_string = get_weapon_hint(weapon);
	self sethintstring(self.stub.hint_string, cost);

	self.stub.cursor_hint = "HINT_WEAPON";
	self.stub.cursor_hint_weapon = weapon;
	self setcursorhint(self.stub.cursor_hint, self.stub.cursor_hint_weapon);

	return 1;
}

get_pack_a_punch_weapon_options(weapon)
{
	if (!isdefined(self.pack_a_punch_weapon_options))
	{
		self.pack_a_punch_weapon_options = [];
	}

	if (!is_weapon_upgraded(weapon))
	{
		return self calcweaponoptions(0, 0, 0, 0, 0);
	}

	if (isdefined(self.pack_a_punch_weapon_options[weapon]))
	{
		return self.pack_a_punch_weapon_options[weapon];
	}

	smiley_face_reticle_index = 1;
	base = get_base_name(weapon);
	camo_index = 39;

	if ("zm_prison" == level.script)
	{
		camo_index = 40;
	}
	else if ("zm_tomb" == level.script)
	{
		camo_index = 45;
	}

	lens_index = 0;
	reticle_index = 0;
	reticle_color_index = 0;

	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions(camo_index, lens_index, reticle_index, reticle_color_index);
	return self.pack_a_punch_weapon_options[weapon];
}

weapon_give(weapon, is_upgrade, magic_box, nosound)
{
	primaryweapons = self getweaponslistprimaries();
	current_weapon = self getcurrentweapon();
	current_weapon = self maps\mp\zombies\_zm_weapons::switch_from_alt_weapon(current_weapon);

	if (!isDefined(is_upgrade))
	{
		is_upgrade = 0;
	}

	weapon_limit = get_player_weapon_limit(self);

	if (is_equipment(weapon))
	{
		self maps\mp\zombies\_zm_equipment::equipment_give(weapon);
	}

	if (weapon == "riotshield_zm")
	{
		if (isDefined(self.player_shield_reset_health))
		{
			self [[self.player_shield_reset_health]]();
		}
	}

	if (self hasweapon(weapon))
	{
		if (issubstr(weapon, "knife_ballistic_"))
		{
			self notify("zmb_lost_knife");
		}

		self givestartammo(weapon);

		if (!is_offhand_weapon(weapon))
		{
			self switchtoweapon(weapon);
		}

		return;
	}

	if (is_melee_weapon(weapon))
	{
		current_weapon = maps\mp\zombies\_zm_melee_weapon::change_melee_weapon(weapon, current_weapon);
	}
	else if (is_lethal_grenade(weapon))
	{
		old_lethal = self get_player_lethal_grenade();

		if (isDefined(old_lethal) && old_lethal != "")
		{
			self takeweapon(old_lethal);
			unacquire_weapon_toggle(old_lethal);
		}

		self set_player_lethal_grenade(weapon);
	}
	else if (is_tactical_grenade(weapon))
	{
		old_tactical = self get_player_tactical_grenade();

		if (isDefined(old_tactical) && old_tactical != "")
		{
			self takeweapon(old_tactical);
			unacquire_weapon_toggle(old_tactical);
		}

		self set_player_tactical_grenade(weapon);
	}
	else if (is_placeable_mine(weapon))
	{
		old_mine = self get_player_placeable_mine();

		if (isDefined(old_mine))
		{
			self takeweapon(old_mine);
			unacquire_weapon_toggle(old_mine);
		}

		self set_player_placeable_mine(weapon);
	}

	if (!is_offhand_weapon(weapon))
	{
		self maps\mp\zombies\_zm_weapons::take_fallback_weapon();
	}

	if (primaryweapons.size >= weapon_limit)
	{
		if (is_melee_weapon(current_weapon) || is_placeable_mine(current_weapon) || is_equipment(current_weapon))
		{
			current_weapon = undefined;
		}

		if (isDefined(current_weapon))
		{
			if (!is_offhand_weapon(weapon))
			{
				if (current_weapon == "tesla_gun_zm")
				{
					level.player_drops_tesla_gun = 1;
				}

				if (issubstr(current_weapon, "knife_ballistic_"))
				{
					self notify("zmb_lost_knife");
				}

				self takeweapon(current_weapon);
				unacquire_weapon_toggle(current_weapon);
			}
		}
	}

	if (isDefined(level.zombiemode_offhand_weapon_give_override))
	{
		if (self [[level.zombiemode_offhand_weapon_give_override]](weapon))
		{
			return;
		}
	}

	if (weapon == "cymbal_monkey_zm")
	{
		self maps\mp\zombies\_zm_weap_cymbal_monkey::player_give_cymbal_monkey();
		self play_weapon_vo(weapon, magic_box);
		return;
	}
	else if (issubstr(weapon, "knife_ballistic_"))
	{
		weapon = self maps\mp\zombies\_zm_melee_weapon::give_ballistic_knife(weapon, issubstr(weapon, "upgraded"));
	}
	else if (weapon == "claymore_zm")
	{
		self thread maps\mp\zombies\_zm_weap_claymore::claymore_setup();
		self play_weapon_vo(weapon, magic_box);
		return;
	}
	else if (weapon == "bouncingbetty_zm")
	{
		self thread scripts\zm\reimagined\_zm_weap_bouncingbetty::betty_setup();
		self play_weapon_vo(weapon, magic_box);
		return;
	}

	if (isDefined(level.zombie_weapons_callbacks) && isDefined(level.zombie_weapons_callbacks[weapon]))
	{
		self thread [[level.zombie_weapons_callbacks[weapon]]]();
		play_weapon_vo(weapon, magic_box);
		return;
	}

	if (!is_true(nosound))
	{
		self play_sound_on_ent("purchase");
	}

	if (is_true(magic_box) && is_limited_weapon(weapon) && level.limited_weapons[weapon] == 1)
	{
		playsoundatposition("mus_raygun_stinger", (0, 0, 0));
	}

	if (!is_weapon_upgraded(weapon))
	{
		self giveweapon(weapon);
	}
	else
	{
		self giveweapon(weapon, 0, self get_pack_a_punch_weapon_options(weapon));
	}

	acquire_weapon_toggle(weapon, self);
	self givestartammo(weapon);

	if (!is_offhand_weapon(weapon))
	{
		if (!is_melee_weapon(weapon))
		{
			self switchtoweapon(weapon);
		}
		else
		{
			self switchtoweapon(current_weapon);
		}
	}

	self play_weapon_vo(weapon, magic_box);

	self notify("weapon_ammo_change");
}

ammo_give(weapon)
{
	give_ammo = 0;

	if (!is_offhand_weapon(weapon))
	{
		weapon = get_weapon_with_attachments(weapon);

		if (isdefined(weapon))
		{
			stockmax = weaponstartammo(weapon);
			clipmax = weaponclipsize(weapon);
			ammocount = self getammocount(weapon);

			give_ammo = ammocount < (stockmax + clipmax);

			if (!give_ammo)
			{
				alt_weap = weaponaltweaponname(weapon);

				if ("none" != alt_weap)
				{
					stockmax = weaponstartammo(alt_weap);
					clipmax = weaponclipsize(alt_weap);
					ammocount = self getammocount(alt_weap);

					give_ammo = ammocount < (stockmax + clipmax);
				}
			}
		}
	}
	else if (self has_weapon_or_upgrade(weapon))
	{
		if (self getammocount(weapon) < weaponmaxammo(weapon))
		{
			give_ammo = 1;
		}
	}

	if (give_ammo)
	{
		self play_sound_on_ent("purchase");
		self givemaxammo(weapon);
		self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
		alt_weap = weaponaltweaponname(weapon);

		if ("none" != alt_weap)
		{
			self givemaxammo(alt_weap);
			self setWeaponAmmoClip(alt_weap, weaponClipSize(alt_weap));
		}

		self notify("weapon_ammo_change");

		return true;
	}

	if (!give_ammo)
	{
		return false;
	}
}

weapon_spawn_think()
{
	cost = maps\mp\zombies\_zm_weapons::get_weapon_cost(self.zombie_weapon_upgrade);
	ammo_cost = maps\mp\zombies\_zm_weapons::get_ammo_cost(self.zombie_weapon_upgrade);
	shared_ammo_weapon = undefined;
	second_endon = undefined;

	is_grenade = 0;

	if (weapontype(self.zombie_weapon_upgrade) == "grenade")
	{
		is_grenade = 1;
	}

	if (isDefined(self.stub))
	{
		second_endon = "kill_trigger";
		self.first_time_triggered = self.stub.first_time_triggered;
	}

	if (isDefined(self.stub) && is_true(self.stub.trigger_per_player))
	{
		self thread maps\mp\zombies\_zm_magicbox::decide_hide_show_hint("stop_hint_logic", second_endon, self.parent_player);
	}
	else
	{
		self thread maps\mp\zombies\_zm_magicbox::decide_hide_show_hint("stop_hint_logic", second_endon);
	}

	if (is_grenade)
	{
		self.first_time_triggered = 0;
		hint = maps\mp\zombies\_zm_weapons::get_weapon_hint(self.zombie_weapon_upgrade);
		self sethintstring(hint, cost);
	}
	else if (!isDefined(self.first_time_triggered))
	{
		self.first_time_triggered = 0;

		if (isDefined(self.stub))
		{
			self.stub.first_time_triggered = 0;
		}
	}
	else if (self.first_time_triggered)
	{
		if (is_true(level.use_legacy_weapon_prompt_format))
		{
			self maps\mp\zombies\_zm_weapons::weapon_set_first_time_hint(cost, maps\mp\zombies\_zm_weapons::get_ammo_cost(self.zombie_weapon_upgrade));
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

		if (!is_grenade && !player maps\mp\zombies\_zm_magicbox::can_buy_weapon())
		{
			wait 0.1;
			continue;
		}

		if (isDefined(self.stub) && is_true(self.stub.require_look_from))
		{
			toplayer = player get_eye() - self.origin;
			forward = -1 * anglesToRight(self.angles);
			dot = vectordot(toplayer, forward);

			if (dot < 0)
			{
				continue;
			}
		}

		if (player has_powerup_weapon())
		{
			wait 0.1;
			continue;
		}

		player_has_weapon = player maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade(self.zombie_weapon_upgrade);

		if (!player_has_weapon && is_true(level.weapons_using_ammo_sharing))
		{
			shared_ammo_weapon = player maps\mp\zombies\_zm_weapons::get_shared_ammo_weapon(self.zombie_weapon_upgrade);

			if (isDefined(shared_ammo_weapon))
			{
				player_has_weapon = 1;
			}
		}

		if (is_true(level.pers_upgrade_nube))
		{
			player_has_weapon = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_should_we_give_raygun(player_has_weapon, player, self.zombie_weapon_upgrade);
		}

		cost = maps\mp\zombies\_zm_weapons::get_weapon_cost(self.zombie_weapon_upgrade);

		if (player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			cost = int(cost / 2);
		}

		if (!player_has_weapon)
		{
			if (player.score >= cost)
			{
				if (self.first_time_triggered == 0)
				{
					self maps\mp\zombies\_zm_weapons::show_all_weapon_buys(player, cost, ammo_cost, is_grenade);
				}

				player maps\mp\zombies\_zm_score::minus_to_player_score(cost, 1);
				bbprint("zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", player.name, player.score, level.round_number, cost, self.zombie_weapon_upgrade, self.origin, "weapon");
				level notify("weapon_bought", player, self.zombie_weapon_upgrade);

				if (self.zombie_weapon_upgrade == "riotshield_zm")
				{
					player maps\mp\zombies\_zm_equipment::equipment_give("riotshield_zm");

					if (isDefined(player.player_shield_reset_health))
					{
						player [[player.player_shield_reset_health]]();
					}
				}
				else if (self.zombie_weapon_upgrade == "jetgun_zm")
				{
					player maps\mp\zombies\_zm_equipment::equipment_give("jetgun_zm");
				}
				else if (is_lethal_grenade(self.zombie_weapon_upgrade))
				{
					player takeweapon(player get_player_lethal_grenade());
					player set_player_lethal_grenade(self.zombie_weapon_upgrade);
				}

				str_weapon = self.zombie_weapon_upgrade;

				if (is_true(level.pers_upgrade_nube))
				{
					str_weapon = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_weapon_upgrade_check(player, str_weapon);
				}

				player maps\mp\zombies\_zm_weapons::weapon_give(str_weapon);
				player maps\mp\zombies\_zm_stats::increment_client_stat("wallbuy_weapons_purchased");
				player maps\mp\zombies\_zm_stats::increment_player_stat("wallbuy_weapons_purchased");
			}
			else
			{
				play_sound_on_ent("no_purchase");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
			}
		}
		else
		{
			str_weapon = self.zombie_weapon_upgrade;

			if (isDefined(shared_ammo_weapon))
			{
				str_weapon = shared_ammo_weapon;
			}

			if (is_true(level.pers_upgrade_nube))
			{
				str_weapon = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_weapon_ammo_check(player, str_weapon);
			}

			if (is_true(self.hacked))
			{
				if (!player maps\mp\zombies\_zm_weapons::has_upgrade(str_weapon))
				{
					ammo_cost = maps\mp\zombies\_zm_weapons::get_upgraded_ammo_cost(str_weapon);
				}
				else
				{
					ammo_cost = maps\mp\zombies\_zm_weapons::get_ammo_cost(str_weapon);
				}
			}
			else if (player maps\mp\zombies\_zm_weapons::has_upgrade(str_weapon))
			{
				ammo_cost = maps\mp\zombies\_zm_weapons::get_upgraded_ammo_cost(str_weapon);
			}
			else
			{
				ammo_cost = maps\mp\zombies\_zm_weapons::get_ammo_cost(str_weapon);
			}

			if (is_true(player.pers_upgrades_awarded["nube"]))
			{
				ammo_cost = maps\mp\zombies\_zm_pers_upgrades_functions::pers_nube_override_ammo_cost(player, self.zombie_weapon_upgrade, ammo_cost);
			}

			if (player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active())
			{
				ammo_cost = int(ammo_cost / 2);
			}

			if (str_weapon == "riotshield_zm")
			{
				play_sound_on_ent("no_purchase");
			}
			else if (player.score >= ammo_cost)
			{
				if (self.first_time_triggered == 0)
				{
					self maps\mp\zombies\_zm_weapons::show_all_weapon_buys(player, cost, ammo_cost, is_grenade);
				}

				if (player maps\mp\zombies\_zm_weapons::has_upgrade(str_weapon))
				{
					player maps\mp\zombies\_zm_stats::increment_client_stat("upgraded_ammo_purchased");
					player maps\mp\zombies\_zm_stats::increment_player_stat("upgraded_ammo_purchased");
				}
				else
				{
					player maps\mp\zombies\_zm_stats::increment_client_stat("ammo_purchased");
					player maps\mp\zombies\_zm_stats::increment_player_stat("ammo_purchased");
				}

				if (str_weapon == "riotshield_zm")
				{
					if (isDefined(player.player_shield_reset_health))
					{
						ammo_given = player [[player.player_shield_reset_health]]();
					}
					else
					{
						ammo_given = 0;
					}
				}
				else if (player maps\mp\zombies\_zm_weapons::has_upgrade(str_weapon))
				{
					ammo_given = player maps\mp\zombies\_zm_weapons::ammo_give(level.zombie_weapons[str_weapon].upgrade_name);
				}
				else
				{
					ammo_given = player maps\mp\zombies\_zm_weapons::ammo_give(str_weapon);
				}

				if (ammo_given)
				{
					player maps\mp\zombies\_zm_score::minus_to_player_score(ammo_cost, 1);
					bbprint("zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", player.name, player.score, level.round_number, ammo_cost, str_weapon, self.origin, "ammo");
				}
			}
			else
			{
				play_sound_on_ent("no_purchase");

				if (isDefined(level.custom_generic_deny_vo_func))
				{
					player [[level.custom_generic_deny_vo_func]]();
				}
				else
				{
					player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
				}
			}
		}

		if (isDefined(self.stub) && isDefined(self.stub.prompt_and_visibility_func))
		{
			self [[self.stub.prompt_and_visibility_func]](player);
		}
	}
}

get_upgraded_ammo_cost(weapon_name)
{
	if (isDefined(level.zombie_weapons[weapon_name].upgraded_ammo_cost))
	{
		return level.zombie_weapons[weapon_name].upgraded_ammo_cost;
	}

	return 2500;
}

weapon_set_first_time_hint(cost, ammo_cost)
{
	// remove
}

makegrenadedudanddestroy()
{
	self endon("death");

	self notify("grenade_dud");
	self makegrenadedud();

	if (isDefined(self))
	{
		self delete();
	}
}

weaponobjects_on_player_connect_override_internal()
{
	self maps\mp\gametypes_zm\_weaponobjects::createbasewatchers();
	self createclaymorewatcher_zm();
	self createbettywatcher_zm();

	for (i = 0; i < level.retrievable_knife_init_names.size; i++)
	{
		self createballisticknifewatcher_zm(level.retrievable_knife_init_names[i], level.retrievable_knife_init_names[i] + "_zm");
	}

	self maps\mp\gametypes_zm\_weaponobjects::setupretrievablewatcher();

	if (!isdefined(self.weaponobjectwatcherarray))
	{
		self.weaponobjectwatcherarray = [];
	}

	self thread maps\mp\gametypes_zm\_weaponobjects::watchweaponobjectspawn();
	self thread maps\mp\gametypes_zm\_weaponobjects::watchweaponprojectileobjectspawn();
	self thread maps\mp\gametypes_zm\_weaponobjects::deleteweaponobjectson();
	self.concussionendtime = 0;
	self.hasdonecombat = 0;
	self.lastfiretime = 0;
	self thread watchweaponusagezm();
	self thread maps\mp\gametypes_zm\_weapons::watchgrenadeusage();
	self thread maps\mp\gametypes_zm\_weapons::watchmissileusage();
	self thread watchweaponchangezm();
	self thread maps\mp\gametypes_zm\_weapons::watchturretuse();
	self thread trackweaponzm();
	self notify("weapon_watchers_created");
}

createbettywatcher_zm()
{
	watcher = self maps\mp\gametypes_zm\_weaponobjects::createuseweaponobjectwatcher("bouncingbetty", "bouncingbetty_zm", self.team);
	watcher.onspawnretrievetriggers = scripts\zm\reimagined\_zm_weap_bouncingbetty::on_spawn_retrieve_trigger;
	watcher.adjusttriggerorigin = scripts\zm\reimagined\_zm_weap_bouncingbetty::adjust_trigger_origin;
	watcher.pickup = level.pickup_betties;
	watcher.pickup_trigger_listener = level.pickup_betties_trigger_listener;
	watcher.skip_weapon_object_damage = 1;
	watcher.headicon = 0;
	watcher.watchforfire = 1;
	watcher.detonate = ::bettydetonate;
	watcher.ondamage = level.betties_on_damage;
}

bettydetonate(attacker, weaponname)
{
	from_emp = isempweapon(weaponname);

	if (from_emp)
	{
		self delete();
		return;
	}

	if (isdefined(attacker))
	{
		self detonate(attacker);
	}
	else if (isdefined(self.owner) && isplayer(self.owner))
	{
		self detonate(self.owner);
	}
	else
	{
		self detonate();
	}
}

setupretrievablehintstrings()
{
	maps\mp\gametypes_zm\_weaponobjects::createretrievablehint("claymore", &"ZOMBIE_CLAYMORE_PICKUP");
	maps\mp\gametypes_zm\_weaponobjects::createretrievablehint("bouncingbetty", &"ZOMBIE_BOUNCINGBETTY_PICKUP");
}

createballisticknifewatcher_zm(name, weapon)
{
	watcher = self maps\mp\gametypes_zm\_weaponobjects::createuseweaponobjectwatcher(name, weapon, self.team);
	watcher.onspawn = scripts\zm\replaced\_zm_weap_ballistic_knife::on_spawn;
	watcher.onspawnretrievetriggers = maps\mp\zombies\_zm_weap_ballistic_knife::on_spawn_retrieve_trigger;
	watcher.storedifferentobject = 1;
	watcher.headicon = 0;
}

get_player_weapondata(player, weapon)
{
	weapondata = [];

	if (!isdefined(weapon))
	{
		weapondata["name"] = get_nonalternate_weapon(player getcurrentweapon());
	}
	else
	{
		weapondata["name"] = weapon;
	}

	weapondata["dw_name"] = weapondualwieldweaponname(weapondata["name"]);
	weapondata["alt_name"] = weaponaltweaponname(weapondata["name"]);

	if (weapondata["name"] != "none")
	{
		weapondata["clip"] = player getweaponammoclip(weapondata["name"]);
		weapondata["stock"] = player getweaponammostock(weapondata["name"]);
		weapondata["fuel"] = player getweaponammofuel(weapondata["name"]);
		weapondata["heat"] = player isweaponoverheating(1, weapondata["name"]);
		weapondata["overheat"] = player isweaponoverheating(0, weapondata["name"]);
	}
	else
	{
		weapondata["clip"] = 0;
		weapondata["stock"] = 0;
		weapondata["fuel"] = 0;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}

	if (weapondata["dw_name"] != "none")
	{
		weapondata["lh_clip"] = player getweaponammoclip(weapondata["dw_name"]);
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}

	if (weapondata["alt_name"] != "none")
	{
		weapondata["alt_clip"] = player getweaponammoclip(weapondata["alt_name"]);
		weapondata["alt_stock"] = player getweaponammostock(weapondata["alt_name"]);
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}

	return weapondata;
}

get_nonalternate_weapon(altweapon)
{
	if (is_alt_weapon(altweapon))
	{
		alt = weaponaltweaponname(altweapon);

		if (alt == "none")
		{
			primaryweapons = self getweaponslistprimaries();
			alt = primaryweapons[0];

			foreach (weapon in primaryweapons)
			{
				if (weaponaltweaponname(weapon) == altweapon)
				{
					alt = weapon;
					break;
				}
			}
		}

		return alt;
	}

	if (issubstr(altweapon, "metalstorm"))
	{
		alt = "metalstorm_mms_zm";

		if (issubstr(altweapon, "upgraded"))
		{
			alt = "metalstorm_mms_upgraded_zm";
		}

		return alt;
	}

	if (issubstr(altweapon, "titus6"))
	{
		alt = "titus6_zm";

		if (issubstr(altweapon, "upgraded"))
		{
			alt = "titus6_upgraded_zm";
		}

		return alt;
	}

	return altweapon;
}

switch_from_alt_weapon(current_weapon)
{
	return get_nonalternate_weapon(current_weapon);
}

give_fallback_weapon()
{
	self switchtoweapon("held_" + self get_player_melee_weapon());
}