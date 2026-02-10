#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_damagefeedback;

init()
{
	level.tacticalinsertionweapon = "tactical_insertion_zm";
	precachemodel("t6_wpn_tac_insert_world");
	level._effect["tacticalInsertionFriendly"] = loadfx("misc/fx_equip_tac_insert_light_grn");
	level._effect["tacticalInsertionEnemy"] = loadfx("misc/fx_equip_tac_insert_light_red");
	level._effect["tacticalInsertionFizzle"] = loadfx("misc/fx_equip_tac_insert_exp");
}

waitanddelete(time)
{
	self endon("death");
	wait 0.05;
	self delete();
}

watch(player)
{
	if (isdefined(player.tacticalinsertion))
	{
		player.tacticalinsertion destroy_tactical_insertion();
	}

	player thread spawntacticalinsertion();
	self waitanddelete(0.05);
}

watchusetrigger(trigger, callback, playersoundonuse, npcsoundonuse)
{
	self endon("delete");

	while (true)
	{
		trigger waittill("trigger", player);

		if (!isalive(player))
		{
			continue;
		}

		if (!player isonground())
		{
			continue;
		}

		if (isdefined(trigger.triggerteam) && player.team != trigger.triggerteam)
		{
			continue;
		}

		if (isdefined(trigger.triggerteamignore) && player.team == trigger.triggerteamignore)
		{
			continue;
		}

		if (isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}

		if (player usebuttonpressed() && !player.throwinggrenade && !player meleebuttonpressed())
		{
			if (isdefined(playersoundonuse))
			{
				player playlocalsound(playersoundonuse);
			}

			if (isdefined(npcsoundonuse))
			{
				player playsound(npcsoundonuse);
			}

			self thread [[callback]](player);
		}
	}
}

watchdisconnect()
{
	self.tacticalinsertion endon("delete");
	self waittill("disconnect");
	self.tacticalinsertion thread destroy_tactical_insertion();
}

destroy_tactical_insertion(attacker)
{
	self.owner.tacticalinsertion = undefined;
	self notify("delete");
	self.owner notify("tactical_insertion_destroyed");
	self.friendlytrigger delete();

	self delete();
}

pickup(attacker)
{
	player = self.owner;
	self destroy_tactical_insertion();
	player giveweapon(level.tacticalinsertionweapon);
	player setweaponammoclip(level.tacticalinsertionweapon, 1);
}

spawntacticalinsertion()
{
	self endon("disconnect");
	self.tacticalinsertion = spawn("script_model", self.origin + (0, 0, 1));
	self.tacticalinsertion setmodel("t6_wpn_tac_insert_world");
	self.tacticalinsertion.origin = self.origin + (0, 0, 1);
	self.tacticalinsertion.angles = self.angles;
	self.tacticalinsertion.team = self.team;
	self.tacticalinsertion setteam(self.team);
	self.tacticalinsertion.owner = self;
	self.tacticalinsertion setowner(self);
	self.tacticalinsertion setweapon(level.tacticalinsertionweapon);
	self.tacticalinsertion setinvisibletoall();
	self.tacticalinsertion setvisibletoplayer(self);
	self.tacticalinsertion thread play_tactical_insertion_effects();
	self.tacticalinsertion endon("delete");
	triggerheight = 64;
	triggerradius = 128;
	self.tacticalinsertion.friendlytrigger = spawn("trigger_radius_use", self.tacticalinsertion.origin + vectorscale((0, 0, 1), 3.0));
	self.tacticalinsertion.friendlytrigger setcursorhint("HINT_NOICON", self.tacticalinsertion);
	self.tacticalinsertion.friendlytrigger sethintstring(&"MP_TACTICAL_INSERTION_PICKUP");

	if (level.teambased)
	{
		self.tacticalinsertion.friendlytrigger setteamfortrigger(self.team);
		self.tacticalinsertion.friendlytrigger.triggerteam = self.team;
	}

	self clientclaimtrigger(self.tacticalinsertion.friendlytrigger);
	self.tacticalinsertion.friendlytrigger.claimedby = self;

	self.tacticalinsertion setclientflag(2);
	self thread watchdisconnect();
	watcher = maps\mp\gametypes_zm\_weaponobjects::getweaponobjectwatcherbyweapon(level.tacticalinsertionweapon);
	self.tacticalinsertion thread watchusetrigger(self.tacticalinsertion.friendlytrigger, ::pickup, watcher.pickupsoundplayer, watcher.pickupsound);

	if (!self.tacticalinsertion tactical_insertion_safe_to_plant())
	{
		self.tacticalinsertion tactical_insertion_wait_and_fizzle();
	}
}

play_tactical_insertion_effects()
{
	self endon("death");
	wait 0.05;
	playfxontag(level._effect["tacticalInsertionEnemy"], self, "tag_flash");
}

tactical_insertion_safe_to_plant()
{
	if (isdefined(level.claymore_safe_to_plant))
	{
		return self [[level.claymore_safe_to_plant]]();
	}

	return 1;
}

tactical_insertion_wait_and_fizzle()
{
	wait 0.1;
	self thread fizzle(self.owner, 1);
}

fizzle(attacker, pickup)
{
	if (isdefined(self.fizzle) && self.fizzle)
	{
		return;
	}

	self.fizzle = 1;
	self thread fizzle_fx();

	if (pickup)
	{
		self playsoundtoplayer("dst_tac_insert_break", self.owner);
		self pickup(attacker);
	}
	else
	{
		self.owner playlocalsound("dst_tac_insert_break");
		self destroy_tactical_insertion(attacker);
	}
}

fizzle_fx()
{
	temp_ent = spawn("script_model", self.origin);
	temp_ent setmodel("tag_origin");
	temp_ent setinvisibletoall();
	temp_ent setvisibletoplayer(self.owner);

	playfxontag(level._effect["tacticalInsertionFizzle"], temp_ent, "tag_origin");

	wait 1;

	temp_ent delete();
}

cancel_button_think()
{
	self endon("disconnect");
	level endon("end_game");

	if (!isdefined(self.tacticalinsertion))
	{
		return;
	}

	text = cancel_text_create();
	self thread cancel_button_press();
	event = self waittill_any_return("tactical_insertion_canceled", "tactical_insertion_destroyed", "spawned_player");

	if (event == "tactical_insertion_canceled")
	{
		self.tacticalinsertion thread fizzle(self.owner, 0);
	}

	if (isdefined(text))
	{
		text destroy();
	}
}

canceltacinsertbutton()
{
	if (level.console)
	{
		return self changeseatbuttonpressed();
	}
	else
	{
		return self jumpbuttonpressed();
	}
}

cancel_button_press()
{
	self endon("disconnect");
	self endon("end_killcam");
	self endon("abort_killcam");

	while (true)
	{
		wait 0.05;

		if (self canceltacinsertbutton())
		{
			break;
		}
	}

	self notify("tactical_insertion_canceled");
}

cancel_text_create()
{
	text = newclienthudelem(self);
	text.archived = 0;
	text.y = -100;
	text.alignx = "center";
	text.aligny = "middle";
	text.horzalign = "center";
	text.vertalign = "bottom";
	text.sort = 10;
	text.font = "small";
	text.foreground = 1;
	text.hidewheninmenu = 1;
	text thread scripts\zm\_zm_reimagined::hide_on_scoreboard(self);
	text thread scripts\zm\_zm_reimagined::destroy_on_intermission();

	if (self issplitscreen())
	{
		text.y = -80;
		text.fontscale = 1.2;
	}
	else
	{
		text.fontscale = 1.6;
	}

	text settext(&"PLATFORM_PRESS_TO_CANCEL_TACTICAL_INSERTION");
	text.alpha = 1;
	return text;
}