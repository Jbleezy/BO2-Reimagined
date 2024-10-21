#include maps\mp\zombies\_zm_chugabud;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

chugabud_laststand()
{
	self endon("player_suicide");
	self endon("disconnect");
	self endon("chugabud_bleedout");

	if (isdefined(self.e_chugabud_corpse))
	{
		self notify("chugabud_handle_multiple_instances");
		return;
	}

	spawn_tombstone = 0;

	if (isdefined(level.tombstone_laststand_func) && is_true(self.hasperkspecialtytombstone))
	{
		spawn_tombstone = 1;
		self [[level.tombstone_laststand_func]]();
	}

	self maps\mp\zombies\_zm_laststand::increment_downed_stat();
	self.ignore_insta_kill = 1;
	self.health = self.maxhealth;
	self chugabud_save_loadout();
	self chugabud_fake_death();
	wait 3;

	if (isdefined(self.insta_killed) && self.insta_killed || isdefined(self.disable_chugabud_corpse))
	{
		create_corpse = 0;
	}
	else
	{
		create_corpse = 1;
	}

	if (create_corpse == 1)
	{
		if (isdefined(level._chugabug_reject_corpse_override_func))
		{
			reject_corpse = self [[level._chugabug_reject_corpse_override_func]](self.origin);

			if (reject_corpse)
			{
				create_corpse = 0;
			}
		}
	}

	if (create_corpse == 1)
	{
		self thread activate_chugabud_effects_and_audio();
		corpse = self chugabud_spawn_corpse();
		self.e_chugabud_corpse = corpse;
		corpse.e_chugabud_player = self;
		corpse.spawn_tombstone = spawn_tombstone;
		corpse thread chugabud_corpse_revive_icon(self);
		corpse thread chugabud_corpse_cleanup_on_spectator(self);
		corpse thread chugabud_corpse_cleanup_on_end_game(self);
		corpse thread chugabud_corpse_cleanup_on_disconnect(self);

		if (isdefined(level.whos_who_client_setup))
		{
			corpse setclientfield("clientfield_whos_who_clone_glow_shader", 1);
		}
	}

	self thread chugabud_fake_revive();
	wait 0.1;
	self.ignore_insta_kill = undefined;
	self.disable_chugabud_corpse = undefined;

	if (create_corpse == 0)
	{
		if (is_player_valid(self))
		{
			self.statusicon = "";
		}

		self notify("chugabud_effects_cleanup");
		return;
	}

	bleedout_time = 30;
	self thread chugabud_bleed_timeout(bleedout_time, corpse);
	self thread chugabud_handle_multiple_instances(corpse);

	corpse waittill("player_revived", e_reviver);

	if (isdefined(e_reviver) && e_reviver == self)
	{
		self notify("whos_who_self_revive");
	}

	self perk_abort_drinking(0.1);
	self maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
	self setorigin(corpse.origin);
	self setplayerangles(corpse.angles);

	if (self player_is_in_laststand())
	{
		self thread chugabud_laststand_cleanup(corpse, "player_revived");
		self enableweaponcycling();
		self enableoffhandweapons();
		self auto_revive(self, 1);
		return;
	}

	self chugabud_laststand_cleanup(corpse, undefined);
}

chugabud_save_loadout()
{
	primaries = self getweaponslistprimaries();
	currentweapon = self getcurrentweapon();
	self.loadout = spawnstruct();
	self.loadout.player = self;
	self.loadout.weapons = [];
	self.loadout.score = self.score;
	self.loadout.current_weapon = -1;

	foreach (index, weapon in primaries)
	{
		self.loadout.weapons[index] = maps\mp\zombies\_zm_weapons::get_player_weapondata(self, weapon);

		if (weapon == currentweapon || self.loadout.weapons[index]["alt_name"] == currentweapon)
		{
			self.loadout.current_weapon = index;
		}
	}

	self.loadout.equipment = self get_player_equipment();

	if (isdefined(self.loadout.equipment))
	{
		self equipment_take(self.loadout.equipment);
	}

	self.loadout.melee_weapon = self get_player_melee_weapon();

	if (self hasweapon("claymore_zm"))
	{
		self.loadout.hasclaymore = 1;
		self.loadout.claymoreclip = self getweaponammoclip("claymore_zm");
	}

	self.loadout.perks = chugabud_save_perks(self);
	self chugabud_save_grenades();

	if (maps\mp\zombies\_zm_weap_cymbal_monkey::cymbal_monkey_exists())
	{
		self.loadout.zombie_cymbal_monkey_count = self getweaponammoclip("cymbal_monkey_zm");
	}
}

chugabud_save_perks(ent)
{
	perk_array = ent get_perk_array(1);

	foreach (perk in perk_array)
	{
		if (perk == "specialty_additionalprimaryweapon")
		{
			ent maps\mp\zombies\_zm::take_additionalprimaryweapon();
		}

		ent unsetperk(perk);
	}

	return perk_array;
}

chugabud_fake_death()
{
	level notify("fake_death");
	self notify("fake_death");
	self takeallweapons();
	self allowstand(0);
	self allowcrouch(0);
	self allowprone(1);
	self setstance("prone");
	self.ignoreme = 1;
	self enableinvulnerability();

	if (self is_jumping())
	{
		while (self is_jumping())
		{
			wait 0.05;
		}
	}

	self freezecontrols(1);
}

chugabud_fake_revive()
{
	level notify("fake_revive");
	self notify("fake_revive");
	playsoundatposition("evt_ww_disappear", self.origin);
	playfx(level._effect["chugabud_revive_fx"], self.origin);
	spawnpoint = chugabud_get_spawnpoint();

	if (isdefined(level._chugabud_post_respawn_override_func))
	{
		self [[level._chugabud_post_respawn_override_func]](spawnpoint.origin);
	}

	if (isdefined(level.chugabud_force_corpse_position))
	{
		if (isdefined(self.e_chugabud_corpse))
		{
			self.e_chugabud_corpse forceteleport(level.chugabud_force_corpse_position);
		}

		level.chugabud_force_corpse_position = undefined;
	}

	if (isdefined(level.chugabud_force_player_position))
	{
		spawnpoint.origin = level.chugabud_force_player_position;
		level.chugabud_force_player_position = undefined;
	}

	self allowstand(1);
	self allowcrouch(1);
	self allowprone(1);
	self setstance("stand");
	self chugabud_give_loadout();
	self seteverhadweaponall(1);
	self.score = self.loadout.score;
	self.pers["score"] = self.loadout.score;

	self setorigin(spawnpoint.origin);
	self setplayerangles(spawnpoint.angles);
	playsoundatposition("evt_ww_appear", spawnpoint.origin);
	playfx(level._effect["chugabud_revive_fx"], spawnpoint.origin);

	wait 0.5;

	self freezecontrols(0);

	wait 0.5;

	self.ignoreme = 0;

	wait 1;

	self disableinvulnerability();
}

chugabud_give_loadout()
{
	self takeallweapons();
	loadout = self.loadout;
	primaries = self getweaponslistprimaries();

	if (loadout.weapons.size > 1 || primaries.size > 1)
	{
		foreach (weapon in primaries)
		{
			self takeweapon(weapon);
		}
	}

	primary_weapons_given = 0;

	for (i = 0; i < loadout.weapons.size; i++)
	{
		if (!isdefined(loadout.weapons[i]))
		{
			continue;
		}

		if (loadout.weapons[i]["name"] == "none")
		{
			continue;
		}

		self maps\mp\zombies\_zm_weapons::weapondata_give(loadout.weapons[i]);

		primary_weapons_given++;

		if (primary_weapons_given >= get_player_weapon_limit(self))
		{
			break;
		}
	}

	if (loadout.current_weapon >= 0 && isdefined(loadout.weapons[loadout.current_weapon]["name"]))
	{
		self switchtoweapon(loadout.weapons[loadout.current_weapon]["name"]);
	}

	self.do_not_display_equipment_pickup_hint = 1;
	self maps\mp\zombies\_zm_equipment::equipment_give(self.loadout.equipment);
	self.do_not_display_equipment_pickup_hint = undefined;
	self chugabud_restore_melee_weapon();
	self chugabud_restore_claymore();
	self.score = loadout.score;
	self.pers["score"] = loadout.score;

	self chugabud_restore_grenades();

	if (maps\mp\zombies\_zm_weap_cymbal_monkey::cymbal_monkey_exists())
	{
		if (loadout.zombie_cymbal_monkey_count)
		{
			self maps\mp\zombies\_zm_weap_cymbal_monkey::player_give_cymbal_monkey();
			self setweaponammoclip("cymbal_monkey_zm", loadout.zombie_cymbal_monkey_count);
		}
	}

	self.loadout.weapons = undefined;
}

chugabud_restore_melee_weapon()
{
	self giveweapon(self.loadout.melee_weapon);
	self set_player_melee_weapon(self.loadout.melee_weapon);
	self giveweapon("held_" + self.loadout.melee_weapon);
	self setactionslot(2, "weapon", "held_" + self.loadout.melee_weapon);
}

chugabud_give_perks()
{
	loadout = self.loadout;

	if (isdefined(loadout.perks) && loadout.perks.size > 0)
	{
		dvar_str = "";

		for (i = 0; i < loadout.perks.size; i++)
		{
			if (self hasperk(loadout.perks[i]))
			{
				continue;
			}

			if (loadout.perks[i] == "specialty_quickrevive" && flag("solo_game"))
			{
				level.solo_game_free_player_quickrevive = 1;
			}

			if (loadout.perks[i] == "specialty_finalstand")
			{
				continue;
			}

			dvar_str += loadout.perks[i] + ";";
			maps\mp\zombies\_zm_perks::give_perk(loadout.perks[i]);
		}

		self setclientdvar("perk_order", dvar_str);
		self luinotifyevent(&"hud_update_perk_order");
	}

	self.loadout.perks = undefined;
}

chugabud_spawn_corpse()
{
	corpse = maps\mp\zombies\_zm_clone::spawn_player_clone(self, self.origin, undefined, self.whos_who_shader);
	corpse.angles = self.angles;
	corpse maps\mp\zombies\_zm_clone::clone_give_weapon(level.start_weapon);
	corpse maps\mp\zombies\_zm_clone::clone_animate("laststand");
	corpse thread maps\mp\zombies\_zm_laststand::revive_trigger_spawn();
	return corpse;
}

chugabud_bleed_timeout_hud_create(delay)
{
	hud = self createbar((0.25, 0.25, 1), level.secondaryprogressbarwidth * 2, level.secondaryprogressbarheight);
	hud setpoint("CENTER", undefined, level.secondaryprogressbarx, -1.75 * level.secondaryprogressbary);
	hud.hidewheninmenu = 1;
	hud.bar.hidewheninmenu = 1;
	hud.barframe.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.bar.foreground = 1;
	hud.barframe.foreground = 1;
	hud.sort = 1;
	hud.bar.sort = 2;
	hud.barframe.sort = 3;
	hud thread scripts\zm\_zm_reimagined::destroy_on_intermission();

	hud updatebar(1);
	hud.bar scaleovertime(delay, 1, hud.height);

	return hud;
}

chugabud_corpse_revive_icon(player)
{
	self endon("death");
	height_offset = 30;
	index = player.clientid;
	self.revive_waypoint_origin = spawn("script_model", self.origin + (0, 0, height_offset));
	self.revive_waypoint_origin setmodel("tag_origin");
	self.revive_waypoint_origin linkto(self);

	hud_elem = newhudelem();
	self.revive_hud_elem = hud_elem;
	hud_elem.alpha = 1;
	hud_elem.hidewheninmenu = 1;
	hud_elem.immunetodemogamehudsettings = 1;
	hud_elem setwaypoint(1, "specialty_chugabud_zombies");
	hud_elem settargetent(self.revive_waypoint_origin);
}

chugabud_corpse_cleanup(corpse, was_revived, was_disconnect = 0)
{
	self notify("chugabud_effects_cleanup");

	if (was_revived)
	{
		playsoundatposition("evt_ww_appear", corpse.origin);
		playfx(level._effect["chugabud_revive_fx"], corpse.origin);
	}
	else
	{
		playsoundatposition("evt_ww_disappear", corpse.origin);
		playfx(level._effect["chugabud_bleedout_fx"], corpse.origin);
		self notify("chugabud_bleedout");

		if (isdefined(level.tombstone_spawn_func) && is_true(corpse.spawn_tombstone) && !was_disconnect)
		{
			self thread [[level.tombstone_spawn_func]](corpse);
		}
	}

	if (isdefined(corpse.revivetrigger))
	{
		corpse notify("stop_revive_trigger");
		corpse.revivetrigger delete();
		corpse.revivetrigger = undefined;
	}

	if (isdefined(corpse.revive_hud_elem))
	{
		corpse.revive_hud_elem destroy();
		corpse.revive_hud_elem = undefined;
	}

	if (isdefined(corpse.revive_waypoint_origin))
	{
		corpse.revive_waypoint_origin delete();
		corpse.revive_waypoint_origin = undefined;
	}

	if (isdefined(self.chugabud_bleed_timeout_hud))
	{
		self.chugabud_bleed_timeout_hud destroyelem();
		self.chugabud_bleed_timeout_hud = undefined;
	}

	self.loadout = undefined;

	wait 0.1;

	if (is_player_valid(self))
	{
		self.statusicon = "";
	}

	corpse delete();
	self.e_chugabud_corpse = undefined;
}

chugabud_handle_multiple_instances(corpse)
{
	corpse endon("death");

	self waittill("chugabud_handle_multiple_instances");

	self thread chugabud_laststand_wait(corpse);
	self chugabud_corpse_cleanup(corpse, 0);
}

chugabud_laststand_wait(corpse)
{
	corpse waittill("death");

	self chugabud_laststand();
}

chugabud_corpse_cleanup_on_end_game(player)
{
	self endon("death");

	level waittill("end_game");

	player chugabud_corpse_cleanup(self, 0);
}

chugabud_corpse_cleanup_on_disconnect(player)
{
	self endon("death");

	player waittill("disconnect");

	player chugabud_corpse_cleanup(self, 0, 1);
}

chugabud_laststand_cleanup(corpse, str_notify)
{
	if (isdefined(str_notify))
	{
		self waittill(str_notify);
	}

	self setstance("stand");
	self thread chugabud_leave_freeze();
	self thread chugabud_revive_invincible();
	self chugabud_give_perks();
	self chugabud_corpse_cleanup(corpse, 1);
}

chugabud_leave_freeze()
{
	self endon("disconnect");
	level endon("end_game");

	self freezecontrols(1);

	wait 0.5;

	if (!is_true(self.hostmigrationcontrolsfrozen))
	{
		self freezecontrols(0);
	}
}

chugabud_revive_invincible()
{
	self endon("disconnect");
	level endon("end_game");

	self.health = self.maxhealth;
	self enableinvulnerability();

	wait 2;

	self disableinvulnerability();
}

chugabud_bleed_timeout(delay, corpse)
{
	self endon("player_suicide");
	self endon("disconnect");
	corpse endon("death");

	self.chugabud_bleed_timeout_hud = self chugabud_bleed_timeout_hud_create(delay);

	wait delay;

	if (isDefined(corpse.revivetrigger))
	{
		while (corpse.revivetrigger.beingrevived)
		{
			wait 0.01;
		}
	}

	self chugabud_corpse_cleanup(corpse, 0);
}

is_weapon_available_in_chugabud_corpse(weapon, player_to_check)
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

			if (isdefined(player_to_check) && player != player_to_check)
			{
				continue;
			}

			if (isdefined(player.loadout) && isdefined(player.loadout.weapons))
			{
				for (i = 0; i < player.loadout.weapons.size; i++)
				{
					chugabud_weapon = player.loadout.weapons[i]["name"];

					if (isdefined(chugabud_weapon) && (chugabud_weapon == weapon || chugabud_weapon == upgradedweapon))
					{
						count++;
					}
				}
			}
		}
	}

	return count;
}