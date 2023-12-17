#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

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
		primary_weapon = primaryweapons[ i ];

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
			self notify("zmb_lost_knife");
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
			new_ballistic = level.ballistic_upgraded_weapon_name[ weapon_name ];

			if (ballistic_was_primary)
			{
				current_weapon = new_ballistic;
			}

			self giveweapon(new_ballistic, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(new_ballistic));
		}
		else
		{
			new_ballistic = level.ballistic_weapon_name[ weapon_name ];

			if (ballistic_was_primary)
			{
				current_weapon = new_ballistic;
			}

			self giveweapon(new_ballistic, 0);
		}

		self giveMaxAmmo(new_ballistic);
		self seteverhadweaponall(1);
	}

	return current_weapon;
}

give_melee_weapon(vo_dialog_id, flourish_weapon_name, weapon_name, ballistic_weapon_name, ballistic_upgraded_weapon_name, flourish_fn, trigger)
{
	if (isdefined(flourish_fn))
		self thread [[ flourish_fn ]]();

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
		self switchtoweapon(weapon_name);
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