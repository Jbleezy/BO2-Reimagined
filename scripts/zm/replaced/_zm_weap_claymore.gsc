#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

buy_claymores()
{
	self.zombie_cost = 1000;
	self sethintstring(&"ZOMBIE_CLAYMORE_PURCHASE");
	self setcursorhint("HINT_WEAPON", "claymore_zm");
	self endon("kill_trigger");

	if (!isDefined(self.stub))
	{
		return;
	}

	if (isDefined(self.stub) && !isDefined(self.stub.claymores_triggered))
	{
		self.stub.claymores_triggered = 0;
	}

	self.claymores_triggered = self.stub.claymores_triggered;

	while (1)
	{
		self waittill("trigger", who);

		while (who in_revive_trigger())
		{
			continue;
		}

		while (who has_powerup_weapon())
		{
			wait 0.1;
		}

		if (is_player_valid(who))
		{
			if (who.score >= self.zombie_cost)
			{
				if (!who is_player_placeable_mine("claymore_zm") || who getWeaponAmmoStock("claymore_zm") < 2)
				{
					play_sound_at_pos("purchase", self.origin);
					who maps\mp\zombies\_zm_score::minus_to_player_score(self.zombie_cost);

					if (!who is_player_placeable_mine("claymore_zm"))
					{
						who thread show_claymore_hint("claymore_purchased");
					}

					who thread claymore_setup();
					who thread maps\mp\zombies\_zm_audio::create_and_play_dialog("weapon_pickup", "grenade");

					if (isDefined(self.stub))
					{
						self.claymores_triggered = self.stub.claymores_triggered;
					}

					if (self.claymores_triggered == 0)
					{
						model = getent(self.target, "targetname");

						if (isDefined(model))
						{
							model thread maps\mp\zombies\_zm_weapons::weapon_show(who);
						}
						else
						{
							if (isDefined(self.clientfieldname))
							{
								level setclientfield(self.clientfieldname, 1);
							}
						}

						self.claymores_triggered = 1;

						if (isDefined(self.stub))
						{
							self.stub.claymores_triggered = 1;
						}
					}
				}
			}
			else
			{
				who play_sound_on_ent("no_purchase");
				who maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
			}
		}
	}
}

claymore_unitrigger_update_prompt(player)
{
	self sethintstring(&"ZOMBIE_CLAYMORE_PURCHASE");
	self setcursorhint("HINT_WEAPON", "claymore_zm");
	return 1;
}

claymore_watch()
{
	self endon("death");
	self endon("disconnect");
	self notify("claymore_watch");
	self endon("claymore_watch");

	while (true)
	{
		self waittill("grenade_fire", claymore, weapname);

		if (weapname == "claymore_zm")
		{
			claymore.owner = self;
			claymore.team = self.team;
			self notify("zmb_enable_claymore_prompt");

			if (claymore claymore_safe_to_plant())
			{
				if (isdefined(level.claymore_planted))
					self thread [[level.claymore_planted]](claymore);

				claymore thread claymore_detonation();
				claymore thread play_claymore_effects();
				self maps\mp\zombies\_zm_stats::increment_client_stat("claymores_planted");
				self maps\mp\zombies\_zm_stats::increment_player_stat("claymores_planted");
			}
			else
				claymore thread claymore_wait_and_detonate();

			self thread claymore_last_shot_switch(weapname);
		}
	}
}

// empty drop anim doesn't work for weapons that use `offhandSlot\Equipment\` attribute
claymore_last_shot_switch(weapname)
{
	self endon("disconnect");

	fire_time = 0.8;

	if (self hasperk("specialty_rof"))
	{
		fire_time -= 0.2;
	}

	wait fire_time;

	if (!self hasweapon(weapname))
	{
		return;
	}

	if (self getcurrentweapon() != weapname)
	{
		return;
	}

	if (self getammocount(weapname) != 0)
	{
		return;
	}

	self takeweapon(weapname);
	self giveweapon(weapname);
	self setweaponammoclip(weapname, 0);
}

claymore_detonation()
{
	self endon("death");
	self waittill_not_moving();
	detonateradius = 96;
	damagearea = spawn("trigger_radius", self.origin + (0, 0, 0 - detonateradius), 4, detonateradius, detonateradius * 2);
	damagearea setexcludeteamfortrigger(self.team);
	damagearea enablelinkto();
	damagearea linkto(self);

	if (is_true(self.isonbus))
	{
		damagearea setmovingplatformenabled(1);
	}

	self.damagearea = damagearea;
	self thread delete_claymores_on_death(self.owner, damagearea);
	self.owner.claymores[self.owner.claymores.size] = self;

	while (1)
	{
		damagearea waittill("trigger", ent);

		if (isDefined(self.owner) && ent == self.owner)
		{
			continue;
		}

		if (isDefined(ent.pers) && isDefined(ent.pers["team"]) && ent.pers["team"] == self.team)
		{
			continue;
		}

		if (isDefined(ent.pers) && isDefined(ent.pers["team"]) && ent.pers["team"] == getOtherTeam(self.team))
		{
			continue;
		}

		if (isDefined(ent.ignore_claymore) && ent.ignore_claymore)
		{
			continue;
		}

		if (!ent shouldaffectweaponobject(self))
		{
			continue;
		}

		if (ent damageconetrace(self.origin, self) > 0)
		{
			self playsound("wpn_claymore_alert");
			wait 0.4;

			if (isDefined(self.owner))
			{
				self detonate(self.owner);
			}
			else
			{
				self detonate(undefined);
			}

			return;
		}
	}
}