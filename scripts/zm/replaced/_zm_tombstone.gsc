#include maps\mp\zombies\_zm_tombstone;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_perks;

tombstone_player_init()
{
	self set_player_tombstone_index();

	level.tombstones[self.tombstone_index] = spawnstruct();
}

tombstone_spawn(ent)
{
	self notify("tombstone_handle_multiple_instances");

	origin = self.origin;
	angles = self.angles;

	if (isdefined(ent))
	{
		origin = ent.origin;
		angles = ent.angles;
	}

	powerup = spawn("script_model", origin + vectorScale((0, 0, 1), 40));
	powerup.angles = angles;
	powerup setmodel("tag_origin");
	icon = spawn("script_model", origin + vectorScale((0, 0, 1), 40));
	icon.angles = angles;
	icon setmodel("ch_tombstone1");
	icon linkto(powerup);
	powerup.icon = icon;
	powerup.script_noteworthy = "player_tombstone_model";
	powerup.player = self;
	level.active_powerups[level.active_powerups.size] = powerup;
	level notify("powerup_dropped", powerup);

	self thread maps\mp\zombies\_zm_tombstone::tombstone_clear();
	powerup thread tombstone_wobble();
	powerup thread tombstone_emp();
	powerup thread tombstone_move();
	powerup thread tombstone_handle_multiple_instances();

	result = "";

	if (!is_player_valid(self))
	{
		result = self waittill_any_return("player_revived", "spawned_player", "disconnect");
	}

	if (result == "disconnect")
	{
		powerup thread tombstone_delete();
		return;
	}

	powerup thread tombstone_waypoint();
	powerup thread tombstone_timeout();
	powerup thread tombstone_grab();
}

tombstone_wobble()
{
	self endon("tombstone_grabbed");
	self endon("tombstone_timedout");

	if (isDefined(self))
	{
		playfxontag(level._effect["powerup_on_solo"], self, "tag_origin");
		self playsound("zmb_tombstone_spawn");
		self playloopsound("zmb_tombstone_looper");
	}

	while (isDefined(self))
	{
		self rotateyaw(360, 3);
		wait 2.9;
	}
}

tombstone_emp()
{
	self endon("tombstone_grabbed");
	self endon("tombstone_timedout");

	if (!should_watch_for_emp())
	{
		return;
	}

	while (1)
	{
		level waittill("emp_detonate", origin, radius);

		if (distancesquared(origin, self.origin) < (radius * radius))
		{
			playfx(level._effect["powerup_off"], self.origin);
			self thread tombstone_delete();
		}
	}
}

tombstone_move()
{
	self endon("tombstone_grabbed");
	self endon("tombstone_timedout");

	while (true)
	{
		self waittill("move_powerup", moveto, distance);
		drag_vector = moveto - self.origin;
		range_squared = lengthsquared(drag_vector);

		if (range_squared > distance * distance)
		{
			drag_vector = vectornormalize(drag_vector);
			drag_vector = distance * drag_vector;
			moveto = self.origin + drag_vector;
		}

		self.origin = moveto;

		if (isdefined(self.origin_diff) && isdefined(level.the_bus))
		{
			self.origin_diff = level.the_bus worldtolocalcoords(moveto);
		}

		self.waypoint.x = self.origin[0];
		self.waypoint.y = self.origin[1];
		self.waypoint.z = self.origin[2] + 40;
	}
}

tombstone_waypoint()
{
	hud = newClientHudElem(self.player);
	hud.x = self.origin[0];
	hud.y = self.origin[1];
	hud.z = self.origin[2] + 40;
	hud.alpha = 1;
	hud.color = (1, 1, 1);
	hud.hidewheninmenu = 1;
	hud.hidewheninscope = 1;
	hud.fadewhentargeted = 1;
	hud setShader("specialty_tombstone_zombies", 8, 8);
	hud setWaypoint(1);
	self.waypoint = hud;

	self waittill_any("tombstone_grabbed", "tombstone_timedout");

	hud destroy();
}

tombstone_timeout()
{
	self endon("tombstone_grabbed");
	self endon("tombstone_timedout");

	self thread maps\mp\zombies\_zm_tombstone::playtombstonetimeraudio();

	self.player waittill_any("player_downed", "disconnect");

	self thread tombstone_delete();
}

tombstone_handle_multiple_instances()
{
	self endon("tombstone_grabbed");
	self endon("tombstone_timedout");

	self.player waittill("tombstone_handle_multiple_instances");

	self thread tombstone_delete();
}

tombstone_grab()
{
	self endon("tombstone_timedout");

	while (isDefined(self))
	{
		if (!isDefined(self.player))
		{
			wait 0.05;
			continue;
		}

		if (!is_player_valid(self.player))
		{
			wait 0.05;
			continue;
		}

		dist = distance(self.player.origin, self.origin);

		if (dist < 64)
		{
			playfx(level._effect["powerup_grabbed_solo"], self.origin);
			playfx(level._effect["powerup_grabbed_wave_solo"], self.origin);
			self.player tombstone_give();
			wait 0.1;
			playsoundatposition("zmb_tombstone_grab", self.origin);
			self stoploopsound();
			arrayremovevalue(level.active_powerups, self, 0);
			self.icon unlink();
			self.icon delete();
			self delete();
			self notify("tombstone_grabbed");
			self.player clientnotify("dc0");
			self.player notify("dance_on_my_grave");
		}

		wait 0.05;
	}
}

tombstone_delete()
{
	self notify("tombstone_timedout");
	self.player.tombstone_savedweapon_weapons = undefined;
	arrayremovevalue(level.active_powerups, self, 0);
	self.icon unlink();
	self.icon delete();
	self delete();
}

tombstone_laststand()
{
	self.tombstone_savedweapon_weapons = self getweaponslistprimaries();
	self.tombstone_savedweapon_weaponsammo_clip = [];
	self.tombstone_savedweapon_weaponsammo_clip_dualwield = [];
	self.tombstone_savedweapon_weaponsammo_stock = [];
	self.tombstone_savedweapon_weaponsammo_clip_alt = [];
	self.tombstone_savedweapon_weaponsammo_stock_alt = [];
	self.tombstone_savedweapon_currentweapon = self getcurrentweapon();
	self.tombstone_savedweapon_melee = self get_player_melee_weapon();
	self.tombstone_savedweapon_grenades = self get_player_lethal_grenade();
	self.tombstone_savedweapon_tactical = self get_player_tactical_grenade();
	self.tombstone_savedweapon_mine = self get_player_placeable_mine();
	self.tombstone_savedweapon_equipment = self get_player_equipment();
	self.tombstone_hasriotshield = undefined;
	self.tombstone_perks = tombstone_save_perks(self);

	// can't switch to alt weapon
	if (is_alt_weapon(self.tombstone_savedweapon_currentweapon))
	{
		self.tombstone_savedweapon_currentweapon = maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(self.tombstone_savedweapon_currentweapon);
	}

	for (i = 0; i < self.tombstone_savedweapon_weapons.size; i++)
	{
		self.tombstone_savedweapon_weaponsammo_clip[i] = self getweaponammoclip(self.tombstone_savedweapon_weapons[i]);
		self.tombstone_savedweapon_weaponsammo_clip_dualwield[i] = self getweaponammoclip(weaponDualWieldWeaponName(self.tombstone_savedweapon_weapons[i]));
		self.tombstone_savedweapon_weaponsammo_stock[i] = self getweaponammostock(self.tombstone_savedweapon_weapons[i]);
		self.tombstone_savedweapon_weaponsammo_clip_alt[i] = self getweaponammoclip(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]));
		self.tombstone_savedweapon_weaponsammo_stock_alt[i] = self getweaponammostock(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]));

		wep = self.tombstone_savedweapon_weapons[i];
		dualwield_wep = weaponDualWieldWeaponName(wep);
		alt_wep = weaponAltWeaponName(wep);

		clip_missing = weaponClipSize(wep) - self.tombstone_savedweapon_weaponsammo_clip[i];

		if (clip_missing > self.tombstone_savedweapon_weaponsammo_stock[i])
		{
			clip_missing = self.tombstone_savedweapon_weaponsammo_stock[i];
		}

		self.tombstone_savedweapon_weaponsammo_clip[i] += clip_missing;
		self.tombstone_savedweapon_weaponsammo_stock[i] -= clip_missing;

		if (dualwield_wep != "none")
		{
			clip_dualwield_missing = weaponClipSize(dualwield_wep) - self.tombstone_savedweapon_weaponsammo_clip_dualwield[i];

			if (clip_dualwield_missing > self.tombstone_savedweapon_weaponsammo_stock[i])
			{
				clip_dualwield_missing = self.tombstone_savedweapon_weaponsammo_stock[i];
			}

			self.tombstone_savedweapon_weaponsammo_clip_dualwield[i] += clip_dualwield_missing;
			self.tombstone_savedweapon_weaponsammo_stock[i] -= clip_dualwield_missing;
		}

		if (alt_wep != "none")
		{
			clip_alt_missing = weaponClipSize(alt_wep) - self.tombstone_savedweapon_weaponsammo_clip_alt[i];

			if (clip_alt_missing > self.tombstone_savedweapon_weaponsammo_stock_alt[i])
			{
				clip_alt_missing = self.tombstone_savedweapon_weaponsammo_stock_alt[i];
			}

			self.tombstone_savedweapon_weaponsammo_clip_alt[i] += clip_alt_missing;
			self.tombstone_savedweapon_weaponsammo_stock_alt[i] -= clip_alt_missing;
		}
	}

	if (isDefined(self.tombstone_savedweapon_grenades))
	{
		self.tombstone_savedweapon_grenades_clip = self getweaponammoclip(self.tombstone_savedweapon_grenades);
	}

	if (isDefined(self.tombstone_savedweapon_tactical))
	{
		self.tombstone_savedweapon_tactical_clip = self getweaponammoclip(self.tombstone_savedweapon_tactical);
	}

	if (isDefined(self.tombstone_savedweapon_mine))
	{
		self.tombstone_savedweapon_mine_clip = self getweaponammoclip(self.tombstone_savedweapon_mine);
	}

	if (isDefined(self.hasriotshield) && self.hasriotshield)
	{
		self.tombstone_hasriotshield = 1;
	}
}

tombstone_save_perks(ent)
{
	perk_array = [];
	perks = ent.perks_active;

	if (!isdefined(perks))
	{
		return perk_array;
	}

	foreach (perk in perks)
	{
		if (perk == "specialty_scavenger")
		{
			continue;
		}

		if (perk == "specialty_finalstand")
		{
			continue;
		}

		perk_array[perk_array.size] = perk;
	}

	return perk_array;
}

tombstone_give()
{
	if (!isDefined(self.tombstone_savedweapon_weapons))
	{
		return;
	}

	primary_weapons = self getWeaponsListPrimaries();

	foreach (weapon in primary_weapons)
	{
		self takeWeapon(weapon);
	}

	if (isDefined(self get_player_melee_weapon()))
	{
		self takeWeapon(self get_player_melee_weapon());
	}

	if (isDefined(self get_player_lethal_grenade()))
	{
		self takeWeapon(self get_player_lethal_grenade());
	}

	if (isDefined(self get_player_tactical_grenade()))
	{
		self takeWeapon(self get_player_tactical_grenade());
	}

	if (isDefined(self get_player_placeable_mine()))
	{
		self takeWeapon(self get_player_placeable_mine());
	}

	primary_weapons_given = 0;
	i = 0;

	while (i < self.tombstone_savedweapon_weapons.size)
	{
		if (primary_weapons_given >= get_player_weapon_limit(self))
		{
			break;
		}

		primary_weapons_given++;

		self giveweapon(self.tombstone_savedweapon_weapons[i], 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(self.tombstone_savedweapon_weapons[i]));

		if (isdefined(self.tombstone_savedweapon_weaponsammo_clip[i]))
		{
			self setweaponammoclip(self.tombstone_savedweapon_weapons[i], self.tombstone_savedweapon_weaponsammo_clip[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_clip_dualwield[i]))
		{
			self setweaponammoclip(weaponDualWieldWeaponName(self.tombstone_savedweapon_weapons[i]), self.tombstone_savedweapon_weaponsammo_clip_dualwield[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_stock[i]))
		{
			self setweaponammostock(self.tombstone_savedweapon_weapons[i], self.tombstone_savedweapon_weaponsammo_stock[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_clip_alt[i]))
		{
			self setweaponammoclip(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]), self.tombstone_savedweapon_weaponsammo_clip_alt[i]);
		}

		if (isdefined(self.tombstone_savedweapon_weaponsammo_stock_alt[i]))
		{
			self setweaponammostock(weaponAltWeaponName(self.tombstone_savedweapon_weapons[i]), self.tombstone_savedweapon_weaponsammo_stock_alt[i]);
		}

		i++;
	}

	if (isDefined(self.tombstone_savedweapon_melee))
	{
		self giveweapon(self.tombstone_savedweapon_melee);
		self set_player_melee_weapon(self.tombstone_savedweapon_melee);
		self giveweapon("held_" + self.tombstone_savedweapon_melee);
		self setactionslot(2, "weapon", "held_" + self.tombstone_savedweapon_melee);
	}

	if (isDefined(self.tombstone_savedweapon_grenades))
	{
		self giveweapon(self.tombstone_savedweapon_grenades);
		self set_player_lethal_grenade(self.tombstone_savedweapon_grenades);

		if (isDefined(self.tombstone_savedweapon_grenades_clip))
		{
			self setweaponammoclip(self.tombstone_savedweapon_grenades, self.tombstone_savedweapon_grenades_clip);
		}
	}

	if (isDefined(self.tombstone_savedweapon_tactical))
	{
		self giveweapon(self.tombstone_savedweapon_tactical);
		self set_player_tactical_grenade(self.tombstone_savedweapon_tactical);

		if (isDefined(self.tombstone_savedweapon_tactical_clip))
		{
			self setweaponammoclip(self.tombstone_savedweapon_tactical, self.tombstone_savedweapon_tactical_clip);
		}
	}

	if (isDefined(self.tombstone_savedweapon_mine))
	{
		self giveweapon(self.tombstone_savedweapon_mine);
		self set_player_placeable_mine(self.tombstone_savedweapon_mine);
		self setactionslot(4, "weapon", self.tombstone_savedweapon_mine);
		self setweaponammoclip(self.tombstone_savedweapon_mine, self.tombstone_savedweapon_mine_clip);
	}

	if (isDefined(self.current_equipment))
	{
		self maps\mp\zombies\_zm_equipment::equipment_take(self.current_equipment);
	}

	if (isDefined(self.tombstone_savedweapon_equipment))
	{
		self.do_not_display_equipment_pickup_hint = 1;
		self maps\mp\zombies\_zm_equipment::equipment_give(self.tombstone_savedweapon_equipment);
		self.do_not_display_equipment_pickup_hint = undefined;
	}

	if (isDefined(self.tombstone_hasriotshield) && self.tombstone_hasriotshield)
	{
		if (isDefined(self.player_shield_reset_health))
		{
			self [[self.player_shield_reset_health]]();
		}
	}

	current_wep = self getCurrentWeapon();

	if (!isSubStr(current_wep, "perk_bottle") && !isSubStr(current_wep, "knuckle_crack") && !isSubStr(current_wep, "flourish") && !isSubStr(current_wep, level.item_meat_name))
	{
		switched = 0;
		primaries = self getweaponslistprimaries();

		foreach (weapon in primaries)
		{
			if (isDefined(self.tombstone_savedweapon_currentweapon) && self.tombstone_savedweapon_currentweapon == weapon)
			{
				switched = 1;
				self switchtoweapon(weapon);
			}
		}

		if (!switched)
		{
			if (primaries.size > 0)
			{
				self switchtoweapon(primaries[0]);
			}
		}
	}

	if (isDefined(self.tombstone_perks) && self.tombstone_perks.size > 0)
	{
		for (i = 0; i < self.tombstone_perks.size; i++)
		{
			if (self hasperk(self.tombstone_perks[i]) || self maps\mp\zombies\_zm_perks::has_perk_paused(self.tombstone_perks[i]))
			{
				continue;
			}

			self maps\mp\zombies\_zm_perks::give_perk(self.tombstone_perks[i]);
		}

		self scripts\zm\_zm_reimagined::update_perk_order();
	}

	self.tombstone_savedweapon_weapons = undefined;
}

is_weapon_available_in_tombstone(weapon, ignore_player)
{
	count = 0;
	upgradedweapon = weapon;

	if (isdefined(level.zombie_weapons[weapon]) && isdefined(level.zombie_weapons[weapon].upgrade_name))
	{
		upgradedweapon = level.zombie_weapons[weapon].upgrade_name;
	}

	players = getplayers();

	if (isdefined(players))
	{
		for (player_index = 0; player_index < players.size; player_index++)
		{
			player = players[player_index];

			if (isdefined(ignore_player) && player == ignore_player)
			{
				continue;
			}

			if (isdefined(player.tombstone_savedweapon_weapons))
			{
				for (i = 0; i < player.tombstone_savedweapon_weapons.size; i++)
				{
					tombstone_weapon = player.tombstone_savedweapon_weapons[i];

					if (isdefined(tombstone_weapon) && (tombstone_weapon == weapon || tombstone_weapon == upgradedweapon))
					{
						count++;
					}
				}
			}
		}
	}

	return count;
}