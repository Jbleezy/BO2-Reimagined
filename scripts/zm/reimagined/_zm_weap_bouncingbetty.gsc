#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_weaponobjects;

init()
{
	if (!isdefined(level.betties_max_per_player))
	{
		level.betties_max_per_player = 20;
	}

	trigs = getentarray("betty_purchase", "targetname");

	for (i = 0; i < trigs.size; i++)
	{
		model = getent(trigs[i].target, "targetname");

		if (isdefined(model))
		{
			model hide();
		}
	}

	array_thread(trigs, ::buy_betties);
	level thread give_betties_after_rounds();
	level.betties_on_damage = ::satchel_damage;
	level.pickup_betties = ::pickup_betties;
	level.pickup_betties_trigger_listener = ::pickup_betties_trigger_listener;
	level._effect["betty_light"] = loadfx("weapon/bouncing_betty/fx_betty_light_green");
	level._effect["betty_launch"] = loadfx("weapon/bouncing_betty/fx_betty_launch_dust");
	level._effect["betty_explosion"] = loadfx("weapon/bouncing_betty/fx_betty_explosion");
}

buy_betties()
{
	self.zombie_cost = 1000;
	self sethintstring(&"ZOMBIE_WEAPON_BOUNCINGBETTY", self.zombie_cost);
	self setcursorhint("HINT_WEAPON", "bouncingbetty_zm");
	self endon("kill_trigger");

	if (!isdefined(self.stub))
	{
		return;
	}

	if (isdefined(self.stub) && !isdefined(self.stub.betties_triggered))
	{
		self.stub.betties_triggered = 0;
	}

	self.betties_triggered = self.stub.betties_triggered;

	while (true)
	{
		self waittill("trigger", who);

		if (who in_revive_trigger())
		{
			continue;
		}

		if (who has_powerup_weapon())
		{
			wait 0.1;
			continue;
		}

		if (is_player_valid(who))
		{
			if (who.score >= self.zombie_cost)
			{
				if (!who is_player_placeable_mine("bouncingbetty_zm") || who getWeaponAmmoStock("bouncingbetty_zm") < 2)
				{
					play_sound_at_pos("purchase", self.origin);
					who maps\mp\zombies\_zm_score::minus_to_player_score(self.zombie_cost);

					if (!who is_player_placeable_mine("bouncingbetty_zm"))
					{
						who thread show_betty_hint("betty_purchased");
					}

					who thread betty_setup();
					who thread maps\mp\zombies\_zm_audio::create_and_play_dialog("weapon_pickup", "grenade");

					if (isdefined(self.stub))
					{
						self.betties_triggered = self.stub.betties_triggered;
					}

					if (self.betties_triggered == 0)
					{
						model = getent(self.target, "targetname");

						if (isdefined(model))
						{
							model thread maps\mp\zombies\_zm_weapons::weapon_show(who);
						}
						else if (isdefined(self.clientfieldname))
						{
							level setclientfield(self.clientfieldname, 1);
						}

						self.betties_triggered = 1;

						if (isdefined(self.stub))
						{
							self.stub.betties_triggered = 1;
						}
					}

					trigs = getentarray("betty_purchase", "targetname");

					for (i = 0; i < trigs.size; i++)
					{
						trigs[i] setinvisibletoplayer(who);
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

betty_unitrigger_update_prompt(player)
{
	self sethintstring(&"ZOMBIE_WEAPON_BOUNCINGBETTY", 1000);
	self setcursorhint("HINT_WEAPON", "bouncingbetty_zm");
	return true;
}

betty_safe_to_plant()
{
	if (self.owner.betties.size >= level.betties_max_per_player)
	{
		return 0;
	}

	if (isdefined(level.betty_safe_to_plant))
	{
		return self [[level.betty_safe_to_plant]]();
	}

	return 1;
}

betty_wait_and_detonate()
{
	wait 0.1;
	self bouncingbettydetonate();
}

betty_watch()
{
	self endon("death");
	self notify("betty_watch");
	self endon("betty_watch");

	while (true)
	{
		self waittill("grenade_fire", betty, weapname);

		if (weapname == "bouncingbetty_zm")
		{
			betty.angles = (0, betty.angles[1], 0);
			betty.owner = self;
			betty.team = self.team;
			self notify("zmb_enable_betty_prompt");

			if (betty betty_safe_to_plant())
			{
				if (isdefined(level.betty_planted))
				{
					self thread [[level.betty_planted]](betty);
				}

				betty thread betty_detonation();
				betty thread play_betty_effects();
				self maps\mp\zombies\_zm_stats::increment_client_stat("claymores_planted");
				self maps\mp\zombies\_zm_stats::increment_player_stat("claymores_planted");
			}
			else
			{
				betty thread betty_wait_and_detonate();
			}

			self thread betty_last_shot_give_back_weapon(weapname);
		}
	}
}

// weapon is taken after last shot when using `plantable\0\` attribute
betty_last_shot_give_back_weapon(weapname)
{
	self endon("disconnect");

	ammo = self getammocount(weapname);

	if (ammo != 0)
	{
		return;
	}

	self waittill("weapon_change");

	if (!self is_player_placeable_mine(weapname))
	{
		return;
	}

	ammo = self getammocount(weapname);
	self takeweapon(weapname);
	self giveweapon(weapname);
	self setweaponammoclip(weapname, ammo);
}

betty_setup()
{
	if (!isdefined(self.betties))
	{
		self.betties = [];
	}

	self thread betty_watch();
	self giveweapon("bouncingbetty_zm");
	self set_player_placeable_mine("bouncingbetty_zm");
	self setactionslot(4, "weapon", "bouncingbetty_zm");
	self setweaponammostock("bouncingbetty_zm", 2);
}

adjust_trigger_origin(origin)
{
	origin = origin + vectorscale((0, 0, 1), 20.0);
	return origin;
}

on_spawn_retrieve_trigger(watcher, player)
{
	self maps\mp\gametypes_zm\_weaponobjects::onspawnretrievableweaponobject(watcher, player);

	if (isdefined(self.pickuptrigger))
	{
		self.pickuptrigger sethintlowpriority(0);
	}
}

pickup_betties()
{
	player = self.owner;

	if (!player hasweapon("bouncingbetty_zm"))
	{
		player thread betty_watch();
		player giveweapon("bouncingbetty_zm");
		player set_player_placeable_mine("bouncingbetty_zm");
		player setactionslot(4, "weapon", "bouncingbetty_zm");
		player setweaponammoclip("bouncingbetty_zm", 0);
		player notify("zmb_enable_betty_prompt");
	}
	else
	{
		clip_ammo = player getweaponammoclip(self.name);
		clip_max_ammo = weaponclipsize(self.name);

		if (clip_ammo >= clip_max_ammo)
		{
			self destroy_ent();
			player notify("zmb_disable_betty_prompt");
			return;
		}
	}

	self pick_up();
	clip_ammo = player getweaponammoclip(self.name);
	clip_max_ammo = weaponclipsize(self.name);

	if (clip_ammo >= clip_max_ammo)
	{
		player notify("zmb_disable_betty_prompt");
	}

	player maps\mp\zombies\_zm_stats::increment_client_stat("claymores_pickedup");
	player maps\mp\zombies\_zm_stats::increment_player_stat("claymores_pickedup");
}

pickup_betties_trigger_listener(trigger, player)
{
	self thread pickup_betties_trigger_listener_enable(trigger, player);
	self thread pickup_betties_trigger_listener_disable(trigger, player);
}

pickup_betties_trigger_listener_enable(trigger, player)
{
	self endon("delete");
	self endon("death");

	while (true)
	{
		player waittill_any("zmb_enable_betty_prompt", "spawned_player");

		if (!isdefined(trigger))
		{
			return;
		}

		trigger trigger_on();
		trigger linkto(self);
	}
}

pickup_betties_trigger_listener_disable(trigger, player)
{
	self endon("delete");
	self endon("death");

	while (true)
	{
		player waittill("zmb_disable_betty_prompt");

		if (!isdefined(trigger))
		{
			return;
		}

		trigger unlink();
		trigger trigger_off();
	}
}

betty_detonation()
{
	self endon("death");

	self waittill_not_moving();

	wait 0.1;

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
	self thread delete_betties_on_death(self.owner, damagearea);
	self.owner.betties[self.owner.betties.size] = self;

	while (true)
	{
		damagearea waittill("trigger", ent);

		if (isdefined(self.owner) && ent == self.owner)
		{
			continue;
		}

		if (isdefined(ent.pers) && isdefined(ent.pers["team"]) && ent.pers["team"] == self.team)
		{
			continue;
		}

		if (isDefined(ent.pers) && isDefined(ent.pers["team"]) && ent.pers["team"] == getOtherTeam(self.team))
		{
			continue;
		}

		if (isdefined(ent.ignore_betty) && ent.ignore_betty)
		{
			continue;
		}

		if (ent damageconetrace(self.origin, self) > 0)
		{
			self playsound("wpn_claymore_alert");
			wait 0.1;
			self bouncingbettydetonate();
			return;
		}
	}
}

bouncingbettydetonate()
{
	self spawnminemover();
	self.minemover thread bouncingbettyjumpandexplode();
	self delete();
}

spawnminemover()
{
	minemover = spawn("script_model", self.origin);
	minemover.angles = self.angles;
	minemover setmodel(self.model);
	minemover.owner = self.owner;
	self.minemover = minemover;
}

bouncingbettyjumpandexplode()
{
	bettyjumpheight = 65;
	bettyjumptime = 0.65;
	bettyrotatevelocity = (0, 750, 32);

	explodepos = self.origin + (0, 0, bettyjumpheight);
	self moveto(explodepos, bettyjumptime, bettyjumptime, 0);
	playfx(level._effect["betty_launch"], self.origin);
	self rotatevelocity(bettyrotatevelocity, bettyjumptime, 0, bettyjumptime);
	self playsound("fly_betty_jump");

	wait(bettyjumptime);

	self thread mineexplode();
}

mineexplode()
{
	bettydamageradius = 256;
	bettydamagemax = 200;
	bettydamagemin = 50;

	if (!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}

	self playsound("fly_betty_explo");
	wait 0.05;

	if (!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}

	self hide();
	self radiusdamage(self.origin, bettydamageradius, bettydamagemax, bettydamagemin, self.owner, "MOD_EXPLOSIVE", "bouncingbetty_zm");
	playfx(level._effect["betty_explosion"], self.origin);
	wait 0.2;

	if (!isdefined(self) || !isdefined(self.owner))
	{
		return;
	}

	if (isdefined(self.trigger))
	{
		self.trigger delete();
	}

	self delete();
}

delete_betties_on_death(player, ent)
{
	self waittill("death");

	if (isdefined(player))
	{
		arrayremovevalue(player.betties, self);
	}

	wait 0.05;

	if (isdefined(ent))
	{
		ent delete();
	}
}

satchel_damage()
{
	self endon("death");
	self setcandamage(1);
	self.health = 100000;
	self.maxhealth = self.health;
	attacker = undefined;

	while (true)
	{
		self waittill("damage", amount, attacker);

		if (!isdefined(self))
		{
			return;
		}

		self.health = self.maxhealth;

		if (!isplayer(attacker))
		{
			continue;
		}

		if (isdefined(self.owner) && attacker == self.owner)
		{
			continue;
		}

		if (isdefined(attacker.pers) && isdefined(attacker.pers["team"]) && attacker.pers["team"] != level.zombie_team)
		{
			continue;
		}

		break;
	}

	if (level.satchelexplodethisframe)
	{
		wait(0.1 + randomfloat(0.4));
	}
	else
	{
		wait 0.05;
	}

	if (!isdefined(self))
	{
		return;
	}

	level.satchelexplodethisframe = 1;
	thread reset_satchel_explode_this_frame();
	self detonate(attacker);
}

reset_satchel_explode_this_frame()
{
	wait 0.05;
	level.satchelexplodethisframe = 0;
}

play_betty_effects()
{
	self endon("death");
	self waittill_not_moving();
	playfxontag(level._effect["betty_light"], self, "tag_origin");
}

give_betties_after_rounds()
{
	while (true)
	{
		level waittill("between_round_over");

		if (!level flag_exists("teleporter_used") || !flag("teleporter_used"))
		{
			players = get_players();

			for (i = 0; i < players.size; i++)
			{
				if (players[i] is_player_placeable_mine("bouncingbetty_zm"))
				{
					players[i] giveweapon("bouncingbetty_zm");
					players[i] set_player_placeable_mine("bouncingbetty_zm");
					players[i] setactionslot(4, "weapon", "bouncingbetty_zm");
					players[i] setweaponammoclip("bouncingbetty_zm", 2);
				}
			}
		}
	}
}

show_betty_hint(string)
{
	self endon("death");
	self endon("disconnect");

	text = &"ZOMBIE_BOUNCINGBETTY_HOWTO";

	show_equipment_hint_text(text);
}