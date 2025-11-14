#include maps\mp\zombies\_zm_weap_emp_bomb;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	if (!emp_bomb_exists())
	{
		return;
	}

	set_zombie_var("emp_stun_range", 512);
	set_zombie_var("emp_stun_time", 12);
	set_zombie_var("emp_perk_off_range", 512);
	set_zombie_var("emp_perk_off_time", 60);
	precacheshellshock("flashbang");

	level thread onplayerconnect();
	level._equipment_emp_destroy_fx = loadfx("weapon/emp/fx_emp_explosion_equip");
}

emp_detonate(grenade)
{
	grenade_owner = undefined;

	if (isDefined(grenade.owner))
	{
		grenade_owner = grenade.owner;
	}

	grenade waittill("explode", origin);

	emp_radius = level.zombie_vars["emp_stun_range"];
	emp_time = level.zombie_vars["emp_perk_off_time"];

	if (!isDefined(origin))
	{
		return;
	}

	level notify("emp_detonate", origin, emp_radius);
	self thread emp_detonate_zombies(origin, emp_radius, grenade_owner);

	if (isDefined(level.custom_emp_detonate))
	{
		thread [[level.custom_emp_detonate]](origin);
	}

	if (isDefined(grenade_owner))
	{
		grenade_owner thread destroyequipment(origin, emp_radius);
	}

	emp_players(origin, emp_radius, grenade_owner);
	disabled_list = maps\mp\zombies\_zm_power::change_power_in_radius(-1, origin, emp_radius);

	wait emp_time;

	maps\mp\zombies\_zm_power::revert_power_to_list(1, origin, emp_radius, disabled_list);
}

emp_detonate_zombies(origin, radius, owner)
{
	zombies = get_array_of_closest(origin, getaispeciesarray(level.zombie_team, "all"), undefined, undefined, radius);

	if (!isdefined(zombies))
	{
		return;
	}

	for (i = 0; i < zombies.size; i++)
	{
		if (!isdefined(zombies[i]) || isdefined(zombies[i].ignore_inert) && zombies[i].ignore_inert)
		{
			continue;
		}

		if (is_true(zombies[i].in_the_ground))
		{
			continue;
		}

		zombies[i].becoming_inert = 1;
	}

	stunned = 0;

	for (i = 0; i < zombies.size; i++)
	{
		if (!isdefined(zombies[i]) || isdefined(zombies[i].ignore_inert) && zombies[i].ignore_inert)
		{
			continue;
		}

		if (is_true(zombies[i].in_the_ground))
		{
			continue;
		}

		stunned++;
		zombies[i] thread stun_zombie();
		wait 0.05;
	}

	if (stunned >= 10 && isdefined(owner))
	{
		owner notify("the_lights_of_their_eyes");
	}
}

destroyequipment(origin, radius)
{
	grenades = getentarray("grenade", "classname");
	rsquared = radius * radius;

	for (i = 0; i < grenades.size; i++)
	{
		item = grenades[i];

		if (distancesquared(origin, item.origin) > rsquared)
		{
			continue;
		}

		if (!isdefined(item.name))
		{
			continue;
		}

		if (!is_offhand_weapon(item.name))
		{
			continue;
		}

		watcher = item.owner getwatcherforweapon(item.name);

		if (!isdefined(watcher))
		{
			continue;
		}

		watcher thread waitanddetonate(item, 0.0, self, "emp_grenade_zm");
	}

	equipment = maps\mp\zombies\_zm_equipment::get_destructible_equipment_list();

	for (i = 0; i < equipment.size; i++)
	{
		item = equipment[i];

		if (!isdefined(item))
		{
			continue;
		}

		if (distancesquared(origin, item.origin) > rsquared)
		{
			continue;
		}

		waitanddamage(item, 1505);
	}
}

waitanddamage(object, damage)
{
	object endon("death");
	object endon("hacked");
	object.stun_fx = 1;

	if (isdefined(level._equipment_emp_destroy_fx))
	{
		playfx(level._equipment_emp_destroy_fx, object.origin + vectorscale((0, 0, 1), 5.0), (0, randomfloat(360), 0));
	}

	delay = 1.1;

	if (delay)
	{
		wait(delay);
	}

	object thread scripts\zm\replaced\_zm_equipment::item_damage(damage);
}

emp_players(origin, radius, owner)
{
	rsquared = radius * radius;
	players = get_players();

	foreach (player in players)
	{
		if (distancesquared(origin, player.origin) < rsquared)
		{
			if (is_player_valid(player) || player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				time = level.zombie_vars["emp_stun_time"];
				player shellshock("flashbang", 1);
				player thread player_perk_pause_and_unpause_all_perks(time, owner);
				player thread player_emp_fx(time);
			}
		}
	}
}

player_emp_fx(time)
{
	self notify("player_emp_fx");
	self endon("player_emp_fx");
	level endon("intermission");
	self endon("disconnect");
	self endon("player_perk_pause_timeout");

	wait_time = 2.5;

	for (i = 0; i < time; i += wait_time)
	{
		playfxontag(level._effect["elec_torso"], self.player_fx_ent, "tag_origin");

		wait wait_time;
	}
}

player_perk_pause_and_unpause_all_perks(time, owner)
{
	self notify("player_perk_pause_and_unpause_all_perks");
	self endon("player_perk_pause_and_unpause_all_perks");
	self endon("disconnect");

	if (!isDefined(self.perks_disabled))
	{
		self.perks_disabled = [];
	}

	if (self.team != owner.team)
	{
		self.last_emped_by = spawnStruct();
		self.last_emped_by.attacker = owner;

		self.player_damage_callback_score_only = 1;
		self [[level._game_module_player_damage_callback]](owner, owner, 0, 0, "MOD_GRENADE_SPLASH", "emp_grenade_zm");
		self.player_damage_callback_score_only = undefined;
	}
	else
	{
		self.last_emped_by = undefined;
	}

	self setclientfieldtoplayer("perks_paused", 1);
	self player_perk_pause_all_perks();
	self thread player_perk_pause_all_perks_acquired(time);

	self waittill_any_or_timeout(time, "spawned_player", "bled_out", "player_suicide");

	self setclientfieldtoplayer("perks_paused", 0);
	self player_perk_unpause_all_perks();

	self.last_emped_by = undefined;
}

player_perk_pause_all_perks_acquired(time)
{
	self endon("player_perk_pause_timeout");
	self endon("player_perk_pause_and_unpause_all_perks");
	self endon("disconnect");

	while (1)
	{
		self waittill("perk_acquired");

		self player_perk_pause_all_perks();
	}
}

player_perk_pause_all_perks()
{
	if (!isdefined(self.perks_active))
	{
		return;
	}

	foreach (perk in self.perks_active)
	{
		self player_perk_pause(perk);
	}

	self.perks_active = [];
}

player_perk_unpause_all_perks()
{
	self notify("player_perk_pause_timeout");

	if (!isdefined(self.perks_disabled))
	{
		return;
	}

	foreach (perk in self.perks_disabled)
	{
		self player_perk_unpause(perk);
	}

	self.perks_disabled = [];
}

player_perk_pause(perk)
{
	if (isinarray(self.perks_disabled, perk))
	{
		return;
	}

	if (!self hasperk(perk))
	{
		return;
	}

	if (perk == "specialty_additionalprimaryweapon" || perk == "specialty_additionalprimaryweapon_upgrade")
	{
		self maps\mp\zombies\_zm::take_additionalprimaryweapon();
	}

	self unsetperk(perk);

	if (perk == "specialty_armorvest" || perk == "specialty_armorvest_upgrade")
	{
		self setmaxhealth(self.premaxhealth);

		if (self.health > self.maxhealth)
		{
			self.health = self.maxhealth;
		}
	}

	if (issubstr(perk, "specialty_scavenger"))
	{
		self.hasperkspecialtytombstone = undefined;
	}

	if (isDefined(level._custom_perks[perk]) && isDefined(level._custom_perks[perk].player_thread_take))
	{
		self thread [[level._custom_perks[perk].player_thread_take]]();
	}

	self.perks_disabled[self.perks_disabled.size] = perk;

	self notify("perk_lost");
}

player_perk_unpause(perk)
{
	if (!isinarray(self.perks_disabled, perk))
	{
		return;
	}

	if (self hasperk(perk))
	{
		return;
	}

	self setperk(perk);

	self maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg(perk, 0, 0);

	if (perk == "specialty_additionalprimaryweapon" || perk == "specialty_additionalprimaryweapon_upgrade")
	{
		self scripts\zm\replaced\_zm::restore_additionalprimaryweapon(0);
	}

	if (issubstr(perk, "specialty_scavenger"))
	{
		self.hasperkspecialtytombstone = 1;
	}

	if (isDefined(level._custom_perks[perk]) && isDefined(level._custom_perks[perk].player_thread_give))
	{
		self thread [[level._custom_perks[perk].player_thread_give]]();
	}

	if (!isDefined(self.perks_active))
	{
		self.perks_active = [];
	}

	self.perks_active[self.perks_active.size] = perk;

	self notify("perk_acquired");
}