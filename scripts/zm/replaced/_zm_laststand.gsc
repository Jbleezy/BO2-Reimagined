#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

revive_trigger_think()
{
	self endon("disconnect");
	self endon("zombified");
	self endon("stop_revive_trigger");
	level endon("end_game");
	self endon("death");

	self thread revive_trigger_clean_up_on_end_game();

	while (true)
	{
		wait 0.1;
		self.revivetrigger sethintstring("");
		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			d = 0;
			d = self depthinwater();

			if (players[i] can_revive(self) || d > 20)
			{
				self.revivetrigger setrevivehintstring(&"ZOMBIE_BUTTON_TO_REVIVE_PLAYER", self.team);
				break;
			}
		}

		for (i = 0; i < players.size; i++)
		{
			reviver = players[i];

			if (self == reviver || !reviver is_reviving(self))
			{
				continue;
			}

			gun = reviver getcurrentweapon();
			assert(isdefined(gun));

			if (gun == level.revive_tool)
			{
				continue;
			}

			reviver thread scripts\zm\_zm_reimagined::temp_weapon_disable_fast_weapon_switch(level.revive_tool);

			reviver giveweapon(level.revive_tool);
			reviver switchtoweapon(level.revive_tool);
			reviver setweaponammostock(level.revive_tool, 1);
			revive_success = reviver revive_do_revive(self, gun);
			reviver revive_give_back_weapons(gun);

			if (isplayer(self))
			{
				self allowjump(1);
			}

			self.laststand = undefined;

			if (revive_success)
			{
				if (isplayer(self))
				{
					maps\mp\zombies\_zm_chugabud::player_revived_cleanup_chugabud_corpse();
				}

				self thread revive_success(reviver);
				self cleanup_suicide_hud();
				return;
			}

			break;
		}
	}
}

revive_trigger_clean_up_on_end_game()
{
	self endon("disconnect");
	self.revivetrigger endon("death");

	level waittill("end_game");

	if (isdefined(self.revivetrigger))
	{
		self.no_revive_trigger = 1;
		self notify("stop_revive_trigger");
		self.revivetrigger delete();
	}
}

revive_do_revive(playerbeingrevived, revivergun)
{
	self thread revive_check_for_weapon_change();

	playerbeingrevived_player = undefined;
	obj_ind = undefined;
	beingrevivedprogressbar_y = 0;

	if (isDefined(playerbeingrevived.e_chugabud_player))
	{
		playerbeingrevived_player = playerbeingrevived.e_chugabud_player;
		playerbeingrevived_player.revive_hud.y = -95;
		obj_ind = playerbeingrevived_player.clone_obj_ind;
		beingrevivedprogressbar_y = level.secondaryprogressbary * -1.5;
	}
	else
	{
		playerbeingrevived_player = playerbeingrevived;
		playerbeingrevived_player.revive_hud.y = -160;
		obj_ind = playerbeingrevived_player.obj_ind;
		beingrevivedprogressbar_y = level.primaryprogressbary * -1;
	}

	objective_setplayerusing(obj_ind, self);

	revivetime = 3;

	if (self hasperk("specialty_quickrevive"))
	{
		revivetime /= 1.5;
	}

	if (self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active())
	{
		revivetime *= 0.5;
	}

	timer = 0;
	revived = 0;
	playerbeingrevived.revivetrigger.beingrevived = 1;
	playerbeingrevived.revivetrigger sethintstring("");

	if (playerbeingrevived_player != self)
	{
		playerbeingrevived_player.revive_hud settext(&"ZOMBIE_PLAYER_IS_REVIVING_YOU", self);
		playerbeingrevived_player maps\mp\zombies\_zm_laststand::revive_hud_show_n_fade(revivetime);
	}

	if (isplayer(playerbeingrevived))
	{
		playerbeingrevived startrevive(self);
	}

	if (!isDefined(playerbeingrevived_player.beingrevivedprogressbar) && playerbeingrevived_player != self)
	{
		playerbeingrevived_player.beingrevivedprogressbar = playerbeingrevived_player createprimaryprogressbar();
		playerbeingrevived_player.beingrevivedprogressbar setpoint("CENTER", undefined, level.primaryprogressbarx, beingrevivedprogressbar_y);
		playerbeingrevived_player.beingrevivedprogressbar.bar.color = (0.5, 0.5, 1);
		playerbeingrevived_player.beingrevivedprogressbar.foreground = 1;
		playerbeingrevived_player.beingrevivedprogressbar.bar.foreground = 1;
		playerbeingrevived_player.beingrevivedprogressbar.barframe.foreground = 1;
		playerbeingrevived_player.beingrevivedprogressbar.hidewheninmenu = 1;
		playerbeingrevived_player.beingrevivedprogressbar.bar.hidewheninmenu = 1;
		playerbeingrevived_player.beingrevivedprogressbar.barframe.hidewheninmenu = 1;
		playerbeingrevived_player.beingrevivedprogressbar.sort = 1;
		playerbeingrevived_player.beingrevivedprogressbar.bar.sort = 2;
		playerbeingrevived_player.beingrevivedprogressbar.barframe.sort = 3;
		playerbeingrevived_player.beingrevivedprogressbar thread scripts\zm\_zm_reimagined::hide_on_scoreboard(playerbeingrevived_player);
		playerbeingrevived_player.beingrevivedprogressbar thread scripts\zm\_zm_reimagined::destroy_on_intermission();
	}

	if (!isDefined(self.reviveprogressbar))
	{
		self.reviveprogressbar = self createprimaryprogressbar();
		self.reviveprogressbar.bar.color = (0.5, 0.5, 1);
		self.reviveprogressbar.foreground = 1;
		self.reviveprogressbar.bar.foreground = 1;
		self.reviveprogressbar.barframe.foreground = 1;
		self.reviveprogressbar.hidewheninmenu = 1;
		self.reviveprogressbar.bar.hidewheninmenu = 1;
		self.reviveprogressbar.barframe.hidewheninmenu = 1;
		self.reviveprogressbar.sort = 1;
		self.reviveprogressbar.bar.sort = 2;
		self.reviveprogressbar.barframe.sort = 3;
		self.reviveprogressbar thread scripts\zm\_zm_reimagined::hide_on_scoreboard(self);
		self.reviveprogressbar thread scripts\zm\_zm_reimagined::destroy_on_intermission();
	}

	if (!isDefined(self.revivetexthud))
	{
		self.revivetexthud = newclienthudelem(self);
	}

	self thread laststand_clean_up_on_disconnect(playerbeingrevived_player, revivergun);

	if (!isDefined(self.is_reviving_any))
	{
		self.is_reviving_any = 0;
	}

	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any(playerbeingrevived, revivergun);
	self.reviveprogressbar updatebar(0.01, 1 / revivetime);

	if (isDefined(playerbeingrevived_player.beingrevivedprogressbar))
	{
		playerbeingrevived_player.beingrevivedprogressbar updatebar(0.01, 1 / revivetime);
	}

	self.revivetexthud.alignx = "center";
	self.revivetexthud.aligny = "middle";
	self.revivetexthud.horzalign = "center";
	self.revivetexthud.vertalign = "bottom";
	self.revivetexthud.y = -113;

	if (self issplitscreen())
	{
		self.revivetexthud.y = -347;
	}

	self.revivetexthud.foreground = 1;
	self.revivetexthud.font = "default";
	self.revivetexthud.fontscale = 1.8;
	self.revivetexthud.alpha = 1;
	self.revivetexthud.color = (1, 1, 1);
	self.revivetexthud.hidewheninmenu = 1;

	if (self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active())
	{
		self.revivetexthud.color = (0.5, 0.5, 1);
	}

	self.revivetexthud settext(&"ZOMBIE_REVIVING");
	self.revivetexthud thread scripts\zm\_zm_reimagined::hide_on_scoreboard(self);
	self thread maps\mp\zombies\_zm_laststand::check_for_failed_revive(playerbeingrevived);

	while (self maps\mp\zombies\_zm_laststand::is_reviving(playerbeingrevived))
	{
		wait 0.05;

		timer += 0.05;

		if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			break;
		}
		else if (isDefined(playerbeingrevived.revivetrigger.auto_revive) && playerbeingrevived.revivetrigger.auto_revive == 1)
		{
			break;
		}

		if (timer >= revivetime)
		{
			revived = 1;
			break;
		}
	}

	if (isDefined(playerbeingrevived_player.beingrevivedprogressbar))
	{
		if (!flag("wait_and_revive"))
		{
			playerbeingrevived_player.beingrevivedprogressbar destroyelem();
		}
	}

	if (isDefined(playerbeingrevived_player.revive_hud))
	{
		playerbeingrevived_player.revive_hud.y = -160;

		if (!flag("wait_and_revive"))
		{
			playerbeingrevived_player.revive_hud settext("");
		}
	}

	if (isDefined(self.reviveprogressbar))
	{
		self.reviveprogressbar destroyelem();
	}

	if (isDefined(self.revivetexthud))
	{
		self.revivetexthud destroy();
	}

	if (isDefined(playerbeingrevived.revivetrigger.auto_revive) && playerbeingrevived.revivetrigger.auto_revive == 1)
	{

	}
	else if (!revived)
	{
		if (isplayer(playerbeingrevived))
		{
			playerbeingrevived stoprevive(self);
		}
	}

	playerbeingrevived.revivetrigger sethintstring(&"ZOMBIE_BUTTON_TO_REVIVE_PLAYER");
	playerbeingrevived.revivetrigger.beingrevived = 0;
	self notify("do_revive_ended_normally");
	self.is_reviving_any--;

	if (!revived)
	{
		playerbeingrevived thread maps\mp\zombies\_zm_laststand::checkforbleedout(self);
	}

	objective_clearplayerusing(obj_ind, self);

	return revived;
}

revive_check_for_weapon_change()
{
	self notify("revive_check_for_weapon_change");
	self endon("revive_check_for_weapon_change");
	self endon("do_revive_ended_normally");

	self.revive_weapon_changed = 0;

	self waittill_any("weapon_change", "weapon_change_complete");

	self.revive_weapon_changed = 1;
}

laststand_clean_up_on_disconnect(playerbeingrevived, revivergun)
{
	self endon("do_revive_ended_normally");

	revivetrigger = playerbeingrevived.revivetrigger;

	playerbeingrevived waittill("disconnect");

	if (isDefined(revivetrigger))
	{
		revivetrigger delete();
	}

	self maps\mp\zombies\_zm_laststand::cleanup_suicide_hud();

	if (isDefined(self.reviveprogressbar))
	{
		self.reviveprogressbar destroyelem();
	}

	if (isDefined(self.revivetexthud))
	{
		self.revivetexthud destroy();
	}

	self maps\mp\zombies\_zm_laststand::revive_give_back_weapons(revivergun);
}

laststand_clean_up_reviving_any(playerbeingrevived, revivergun)
{
	self endon("do_revive_ended_normally");

	playerbeingrevived_player = undefined;
	obj_ind = undefined;

	if (isDefined(playerbeingrevived.e_chugabud_player))
	{
		playerbeingrevived_player = playerbeingrevived.e_chugabud_player;
		obj_ind = playerbeingrevived_player.clone_obj_ind;
	}
	else
	{
		playerbeingrevived_player = playerbeingrevived;
		obj_ind = playerbeingrevived_player.obj_ind;
	}

	playerbeingrevived_player waittill_any("disconnect", "zombified", "stop_revive_trigger", "chugabud_effects_cleanup");

	if (isDefined(playerbeingrevived_player.beingrevivedprogressbar))
	{
		playerbeingrevived_player.beingrevivedprogressbar destroyelem();
	}

	if (isDefined(playerbeingrevived_player.revive_hud))
	{
		playerbeingrevived_player.revive_hud settext("");
	}

	self.is_reviving_any--;

	if (self.is_reviving_any < 0)
	{
		self.is_reviving_any = 0;
	}

	if (!self.is_reviving_any)
	{
		if (isDefined(self.reviveprogressbar))
		{
			self.reviveprogressbar destroyelem();
		}

		if (isDefined(self.revivetexthud))
		{
			self.revivetexthud destroy();
		}

		self maps\mp\zombies\_zm_laststand::revive_give_back_weapons(revivergun);
	}

	objective_clearplayerusing(obj_ind, self);
}

revive_give_back_weapons(gun)
{
	revive_tool = level.revive_tool;

	if (is_true(self.afterlife))
	{
		revive_tool = level.afterlife_revive_tool;
	}

	cur_wep = self getCurrentWeapon();

	self takeweapon(revive_tool);

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		return;
	}

	if (cur_wep != revive_tool && is_true(self.revive_weapon_changed))
	{
		return;
	}

	if (self hasWeapon(level.item_meat_name))
	{
		return;
	}

	if (self hasWeapon("screecher_arms_zm"))
	{
		return;
	}

	if (gun != "none" && gun != "equip_gasmask_zm" && gun != "lower_equip_gasmask_zm" && self hasweapon(gun))
	{
		self switchtoweapon(gun);
	}
	else
	{
		primaryweapons = self getweaponslistprimaries();

		if (isDefined(primaryweapons) && primaryweapons.size > 0)
		{
			self switchtoweapon(primaryweapons[0]);
		}
	}
}

revive_hud_think()
{
	self endon("disconnect");

	while (1)
	{
		wait 0.1;

		if (!maps\mp\zombies\_zm_laststand::player_any_player_in_laststand())
		{
			continue;
		}

		players = get_players();
		playertorevive = undefined;
		i = 0;

		while (i < players.size)
		{
			if (!isDefined(players[i].revivetrigger) || !isDefined(players[i].revivetrigger.createtime))
			{
				i++;
				continue;
			}

			if (!isDefined(playertorevive) || playertorevive.revivetrigger.createtime > players[i].revivetrigger.createtime)
			{
				playertorevive = players[i];
			}

			i++;
		}

		if (isDefined(playertorevive))
		{
			i = 0;

			while (i < players.size)
			{
				if (players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
				{
					i++;
					continue;
				}

				if (getDvar("g_gametype") == "vs")
				{
					if (players[i].team != playertorevive.team)
					{
						i++;
						continue;
					}
				}

				if (is_encounter())
				{
					if (players[i].sessionteam != playertorevive.sessionteam)
					{
						i++;
						continue;
					}

					if (is_true(level.hide_revive_message))
					{
						i++;
						continue;
					}
				}

				players[i] thread maps\mp\zombies\_zm_laststand::faderevivemessageover(playertorevive, 3);
				i++;
			}

			playertorevive.revivetrigger.createtime = undefined;
		}
	}
}

auto_revive(reviver, dont_enable_weapons)
{
	if (isdefined(self.revivetrigger))
	{
		self.revivetrigger.auto_revive = 1;

		if (self.revivetrigger.beingrevived == 1)
		{
			while (true)
			{
				if (self.revivetrigger.beingrevived == 0)
				{
					break;
				}

				wait_network_frame();
			}
		}

		self.revivetrigger.auto_trigger = 0;
	}

	self reviveplayer();
	self maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
	setclientsysstate("lsm", "0", self);
	self notify("stop_revive_trigger");

	if (isdefined(self.revivetrigger))
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}

	self cleanup_suicide_hud();

	if (!isdefined(dont_enable_weapons) || dont_enable_weapons == 0)
	{
		self laststand_enable_player_weapons();
	}

	self allowjump(1);
	self.ignoreme = 0;
	self.laststand = undefined;

	valid_reviver = 1;

	if (is_encounter() && reviver == self)
	{
		valid_reviver = 0;
	}

	if (valid_reviver)
	{
		reviver.revives++;
		reviver maps\mp\zombies\_zm_stats::increment_client_stat("revives");
		reviver maps\mp\zombies\_zm_stats::increment_player_stat("revives");
		self recordplayerrevivezombies(reviver);
		maps\mp\_demo::bookmark("zm_player_revived", gettime(), self, reviver);
	}

	self notify("player_revived", reviver);
}

playerlaststand(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	self notify("entering_last_stand");

	if (isdefined(level._game_module_player_laststand_callback))
	{
		self [[level._game_module_player_laststand_callback]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);
	}

	if (self player_is_in_laststand())
	{
		return;
	}

	if (isdefined(self.in_zombify_call) && self.in_zombify_call)
	{
		return;
	}

	self thread player_last_stand_stats(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);

	if (isdefined(level.playerlaststand_func))
	{
		[[level.playerlaststand_func]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);
	}

	self.health = 1;
	self.laststand = 1;
	self.ignoreme = 1;
	self thread maps\mp\gametypes_zm\_gameobjects::onplayerlaststand();
	self thread maps\mp\zombies\_zm_buildables::onplayerlaststand();

	if (!(isdefined(self.no_revive_trigger) && self.no_revive_trigger))
	{
		self revive_trigger_spawn();
	}
	else
	{
		self undolaststand();
	}

	if (isdefined(self.is_zombie) && self.is_zombie)
	{
		self takeallweapons();

		if (isdefined(attacker) && isplayer(attacker) && attacker != self)
		{
			attacker notify("killed_a_zombie_player", einflictor, self, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);
		}
	}
	else
	{
		self laststand_disable_player_weapons();
		self laststand_give_pistol();
	}

	if (isdefined(level.playersuicideallowed) && level.playersuicideallowed && get_players().size > 1)
	{
		if (!isdefined(level.canplayersuicide) || self [[level.canplayersuicide]]())
		{
			self thread suicide_trigger_spawn();
		}
	}

	if (level.laststandgetupallowed)
	{
		self thread laststand_getup();
	}
	else
	{
		bleedout_time = getdvarfloat("player_lastStandBleedoutTime");
		self thread laststand_bleedout(bleedout_time);
	}

	if ("zcleansed" != level.gametype)
	{
		maps\mp\_demo::bookmark("zm_player_downed", gettime(), self);
	}

	self notify("player_downed");
	self thread refire_player_downed();
	self thread cleanup_laststand_on_disconnect();
}

player_last_stand_stats(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if (isdefined(attacker) && isplayer(attacker) && attacker != self)
	{
		if (is_true(self.is_zombie) || is_true(attacker.is_zombie))
		{
			maps\mp\_demo::bookmark("kill", gettime(), self, attacker, 0, einflictor);
		}

		if (is_true(self.is_zombie) || is_true(attacker.is_zombie))
		{
			attacker.returns++;
		}
		else
		{
			attacker.kills++;
		}

		attacker maps\mp\zombies\_zm_stats::increment_client_stat("kills");
		attacker maps\mp\zombies\_zm_stats::increment_player_stat("kills");

		if (isdefined(sweapon))
		{
			dmgweapon = sweapon;

			if (is_alt_weapon(dmgweapon))
			{
				dmgweapon = weaponaltweaponname(dmgweapon);
			}

			attacker addweaponstat(dmgweapon, "kills", 1);
		}

		if (is_headshot(sweapon, shitloc, smeansofdeath))
		{
			attacker.headshots++;
			attacker maps\mp\zombies\_zm_stats::increment_client_stat("headshots");
			attacker addweaponstat(sweapon, "headshots", 1);
			attacker maps\mp\zombies\_zm_stats::increment_player_stat("headshots");
		}
	}

	self increment_downed_stat();

	if (flag("solo_game") && !self.lives && getnumconnectedplayers() < 2)
	{
		self maps\mp\zombies\_zm_stats::increment_client_stat("deaths");
		self maps\mp\zombies\_zm_stats::increment_player_stat("deaths");
		self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
	}
}

laststand_bleedout(delay)
{
	level endon("intermission");
	self endon("player_revived");
	self endon("player_suicide");
	self endon("zombified");
	self endon("disconnect");

	if (isdefined(self.is_zombie) && self.is_zombie || isdefined(self.no_revive_trigger) && self.no_revive_trigger)
	{
		self notify("bled_out");
		wait_network_frame();
		self bleed_out();
		return;
	}

	setclientsysstate("lsm", "1", self);
	self.bleedout_time = delay;

	while (self.bleedout_time > int(delay * 0.5))
	{
		self.bleedout_time = self.bleedout_time - 1;
		wait 1;
	}

	self useservervisionset(1);
	self setvisionsetforplayer("zombie_death", delay * 0.5);

	while (self.bleedout_time > 0)
	{
		self.bleedout_time = self.bleedout_time - 1;
		wait 1;
	}

	while (isdefined(self.revivetrigger) && isdefined(self.revivetrigger.beingrevived) && self.revivetrigger.beingrevived == 1)
	{
		wait 0.1;
	}

	if (is_true(level.intermission))
	{
		return;
	}

	self notify("bled_out");
	wait_network_frame();
	self bleed_out();
}

revive_hud_create()
{
	if (isDefined(self.revive_hud))
	{
		return;
	}

	self.revive_hud = newclienthudelem(self);
	self.revive_hud.alignx = "center";
	self.revive_hud.aligny = "middle";
	self.revive_hud.horzalign = "center";
	self.revive_hud.vertalign = "bottom";
	self.revive_hud.foreground = 1;
	self.revive_hud.font = "default";
	self.revive_hud.fontscale = 1.5;
	self.revive_hud.alpha = 0;
	self.revive_hud.color = (1, 1, 1);
	self.revive_hud.hidewheninmenu = 1;
	self.revive_hud settext("");
	self.revive_hud.y = -160;
}