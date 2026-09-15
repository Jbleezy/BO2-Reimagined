#include clientscripts\mp\zm_tomb;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_filter;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zm_tomb_ffotd;
#include clientscripts\mp\zm_tomb_teleporter;
#include clientscripts\mp\zombies\_zm_weap_one_inch_punch;
#include clientscripts\mp\zombies\_zm_perk_electric_cherry;
#include clientscripts\mp\zombies\_zm_perk_divetonuke;
#include clientscripts\mp\zm_tomb_quest_fire;
#include clientscripts\mp\zm_tomb_tank;
#include clientscripts\mp\zm_tomb_giant_robot;
#include clientscripts\mp\zm_tomb_capture_zones;
#include clientscripts\mp\zombies\_zm_ai_mechz;
#include clientscripts\mp\zombies\_zm_perk_random;
#include clientscripts\mp\zombies\_zm_challenges;
#include clientscripts\mp\zm_tomb_dig;
#include clientscripts\mp\zm_tomb_fx;
#include clientscripts\mp\zm_tomb_ee;
#include clientscripts\mp\zm_tomb_amb;
#include clientscripts\mp\zm_tomb_ambient_scripts;
#include clientscripts\mp\zm_tomb_classic;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\_sticky_grenade;
#include clientscripts\mp\zombies\_zm_weap_beacon;
#include clientscripts\mp\zombies\_zm_weap_riotshield_tomb;
#include clientscripts\mp\zombies\_zm_weap_staff_air;
#include clientscripts\mp\zombies\_zm_weap_staff_fire;
#include clientscripts\mp\zombies\_zm_weap_staff_lightning;
#include clientscripts\mp\zombies\_zm_weap_staff_water;
#include clientscripts\mp\zombies\_zm_weap_cymbal_monkey;
#include clientscripts\mp\zombies\_zm_magicbox_tomb;
#include clientscripts\mp\zombies\_zm_powerup_zombie_blood;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\zombies\_zm_equipment;
#include clientscripts\mp\zombies\_zm_ai_quadrotor;
#include clientscripts\mp\_fx;

init_gamemodes()
{
	add_map_gamemode("zclassic", undefined, undefined);
	add_map_gamemode("zstandard", undefined, undefined);
	add_map_gamemode("zgrief", undefined, undefined);

	add_map_location_gamemode("zclassic", "tomb", clientscripts\mp\zm_tomb_classic::precache, clientscripts\mp\zm_tomb_classic::premain, clientscripts\mp\zm_tomb_classic::main);

	add_map_location_gamemode("zstandard", "trenches", undefined, undefined, undefined);
	add_map_location_gamemode("zstandard", "excavation_site", undefined, undefined, undefined);
	add_map_location_gamemode("zstandard", "church", undefined, undefined, undefined);
	add_map_location_gamemode("zstandard", "crazy_place", undefined, undefined, undefined);

	add_map_location_gamemode("zgrief", "trenches", undefined, undefined, undefined);
	add_map_location_gamemode("zgrief", "excavation_site", undefined, undefined, undefined);
	add_map_location_gamemode("zgrief", "church", undefined, undefined, undefined);
	add_map_location_gamemode("zgrief", "crazy_place", undefined, undefined, undefined);
}

entityspawned_tomb(localclientnum)
{
	if (!isdefined(self.type))
	{
		return;
	}

	if (self.type == "player")
	{
		self thread playerspawned(localclientnum);
	}

	if (self.type == "vehicle")
	{
		if (self.vehicletype == "heli_quadrotor_zm")
		{
			self thread clientscripts\mp\zombies\_zm_ai_quadrotor::spawned(localclientnum);
		}
	}

	if (self.type == "missile")
	{
		switch (self.weapon)
		{
			case "crossbow_explosive_bolt_zm":
			case "crossbow_explosive_bolt_upgraded_zm":
				self thread clientscripts\mp\_explosive_bolt::spawned(localclientnum);
				break;
		}
	}
}

sndweatherupdate(player)
{
	level notify("sndWeatherUpdating");
	level endon("sndWeatherUpdating");

	serverwait(0, 0.5);
	level notify("sndWeatherUpdate");
	player thread sndupdateroomweather();
}

sndupdateroomweather()
{
	serverwait(0, 0.1);
	name = level.activeambientpackage;

	if (isdefined(level.sndambweathernames) && isinarray(level.sndambweathernames, name))
	{
		playsound(0, "amb_thunder_flash_2d", (0, 0, 0));
		stoploopsound(0, level.ambientrooms[name].ent, level.ambientrooms[name].fadeout);
		serverwait(0, 0.5);
		level.ambientrooms[name].id = playloopsound(0, level.ambientrooms[name].ent, level.ambientrooms[name].tone, level.ambientrooms[name].fadein);
	}
}

_rain_thread(n_level, localclientnum)
{
	level notify("_rain_thread" + localclientnum);
	level notify("_rain_begin" + localclientnum);
	level endon("_snow_begin" + localclientnum);
	level endon("_rain_thread" + localclientnum);
	self endon("disconnect");
	self endon("entityshutdown");

	n_wait = 0.35 / n_level;

	if (n_wait < 0.15)
	{
		n_wait = 0.15;
	}

	while (true)
	{
		if (!isdefined(self))
		{
			return;
		}

		playfx(localclientnum, level._effect["player_rain"], self.origin);
		serverwait(localclientnum, n_wait);
	}
}

_snow_thread(n_level, localclientnum)
{
	level notify("_snow_thread" + localclientnum);
	level notify("_snow_begin" + localclientnum);
	level endon("_rain_begin" + localclientnum);
	level endon("_snow_thread" + localclientnum);
	self endon("disconnect");
	self endon("entityshutdown");

	n_wait = 0.5 / n_level;
	self.b_lightning = 0;

	while (true)
	{
		if (!isdefined(self))
		{
			return;
		}

		playfx(localclientnum, level._effect["player_snow"], self.origin);
		wait(n_wait);
	}
}

player_continuous_rumble(localclientnum, rumble_level, shake_camera)
{
	if (!isdefined(shake_camera))
	{
		shake_camera = 1;
	}

	self notify("stop_rumble_and_shake");
	self endon("disconnect");
	self endon("stop_rumble_and_shake");

	while (true)
	{
		if (isdefined(self) && self islocalplayer() && isdefined(self))
		{
			if (rumble_level == 1)
			{
				if (shake_camera)
				{
					self earthquake(0.2, 1.0, self.origin, 100);
				}

				self playrumbleonentity(localclientnum, "reload_small");
				serverwait(localclientnum, 0.05);
			}
			else
			{
				if (shake_camera)
				{
					self earthquake(0.3, 1.0, self.origin, 100);
				}

				self playrumbleonentity(localclientnum, "damage_light");
			}
		}

		serverwait(localclientnum, 0.1);
	}
}

player_staff_charge_rumble(localclientnum, str_rumble)
{
	self endon("stop_charge_rumble");
	self endon("disconnect");

	delta_time = 0.1;
	n_max_time = 10.0;

	while (true)
	{
		self playrumbleonentity(localclientnum, str_rumble);
		serverwait(localclientnum, 0.1);
	}
}

staff_charger_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	v_origin = self gettagorigin("tag_crystal");

	if (!isdefined(level.charger_origins))
	{
		level.charger_origins = [];
	}

	if (newval != 0)
	{
		level.charger_origins[newval] = v_origin;
	}
	else
	{
		keys = getarraykeys(level.charger_origins);

		foreach (i in keys)
		{
			if (!isdefined(level.charger_origins[i]))
			{
				continue;
			}

			if (distancesquared(level.charger_origins[i], v_origin) < 100)
			{
				level.charger_origins[i] = undefined;
			}
		}
	}
}

zombie_soul_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	v_origin = self gettagorigin("J_SpineUpper");
	v_dest = undefined;
	closest_dist_sq = -1.0;

	if (!isdefined(level.charger_origins))
	{
		level.charger_origins = [];
	}

	foreach (v_charger in level.charger_origins)
	{
		dist_sq = distancesquared(self.origin, v_charger);

		if (!isdefined(v_dest))
		{
			closest_dist_sq = dist_sq;
			v_dest = v_charger;
			continue;
		}

		if (dist_sq < closest_dist_sq)
		{
			closest_dist_sq = dist_sq;
			v_dest = v_charger;
		}
	}

	if (!isdefined(v_dest) || !isdefined(v_origin))
	{
		return;
	}

	if (isdefined(self))
	{
		v_origin = self gettagorigin("J_SpineUpper");
	}

	e_fx = spawn(localclientnum, v_origin, "script_model");
	e_fx setmodel("tag_origin");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_leave");
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(v_dest + vectorscale((0, 0, 1), 5.0), 0.5);
	e_fx waittill("movedone");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_impact");
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	serverwait(localclientnum, 0.3);
	e_fx delete();
}

foot_print_box_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	a_structs = getstructarray("foot_box_pos", "targetname");
	s_box = get_array_of_closest(self.origin, a_structs)[0];
	e_fx = spawn(localclientnum, self gettagorigin("J_SpineUpper"), "script_model");
	e_fx setmodel("tag_origin");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_leave");
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(s_box.origin, 1);
	e_fx waittill("movedone");
	playsound(localclientnum, "zmb_squest_charge_soul_impact", e_fx.origin);
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	serverwait(localclientnum, 0.3);
	e_fx delete();
}

loop_cooldown_fx(localclientnum)
{
	level endon("stop_cooldown_fx");

	while (true)
	{
		playfx(localclientnum, level._effect["perk_machine_steam"], self.origin);
		serverwait(localclientnum, 0.1);
	}
}