#include maps\mp\zombies\_zm_ai_avogadro;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zm_transit_bus;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weap_riotshield;

check_range_attack()
{
	enemy = self.favoriteenemy;

	if (isdefined(enemy))
	{
		vec_enemy = enemy.origin - self.origin;
		dist_sq = lengthsquared(vec_enemy);

		if (dist_sq > 4096 && dist_sq < 360000)
		{
			vec_facing = anglestoforward(self.angles);
			norm_facing = vectornormalize(vec_facing);
			norm_enemy = vectornormalize(vec_enemy);
			dot = vectordot(norm_facing, norm_enemy);

			if (dot > 0.99)
			{
				enemy_eye_pos = enemy geteye();
				eye_pos = self geteye();
				passed = bullettracepassed(eye_pos, enemy_eye_pos, 0, undefined);

				if (passed)
					return true;
			}
		}
	}

	return false;
}

avogadro_exit(from)
{
	powerup_origin = spawn("script_origin", self.origin);

	if (self.state == "attacking_bus" || self.state == "stay_attached")
	{
		powerup_origin linkto(level.the_bus);
	}

	self.state = "exiting";
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self setfreecameralockonallowed(0);
	self.audio_loop_ent stoploopsound(0.5);
	self notify("stop_health");

	if (isdefined(self.health_fx))
	{
		self.health_fx unlink();
		self.health_fx delete();
	}

	if (isdefined(from))
	{
		if (from == "bus")
		{
			self playsound("zmb_avogadro_death_short");
			playfx(level._effect["avogadro_ascend_aerial"], self.origin);
			self animscripted(self.origin, self.angles, "zm_bus_win");
			maps\mp\animscripts\zm_shared::donotetracks("bus_win_anim");
		}
		else if (from == "chamber")
		{
			self playsound("zmb_avogadro_death_short");
			playfx(level._effect["avogadro_ascend"], self.origin);
			self animscripted(self.origin, self.angles, "zm_chamber_out");
			wait 0.4;
			self ghost();
			stop_exploder(500);
		}
		else
		{
			self playsound("zmb_avogadro_death");
			playfx(level._effect["avogadro_ascend"], self.origin);
			self animscripted(self.origin, self.angles, "zm_exit");
			maps\mp\animscripts\zm_shared::donotetracks("exit_anim");
		}
	}
	else
	{
		self playsound("zmb_avogadro_death");
		playfx(level._effect["avogadro_ascend"], self.origin);
		self animscripted(self.origin, self.angles, "zm_exit");
		maps\mp\animscripts\zm_shared::donotetracks("exit_anim");
	}

	if (!isdefined(from) || from != "chamber")
		level thread do_avogadro_flee_vo(self);

	self ghost();
	self.hit_by_melee = 0;
	self.anchor.origin = self.origin;
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	if (isdefined(from) && from == "exit_idle")
		self.return_round = level.round_number;
	else
		self.return_round = level.round_number + randomintrange(2, 5);

	level.next_avogadro_round = self.return_round;
	self.state = "cloud";
	self thread cloud_update_fx();

	if (!isdefined(from))
	{
		if (level.powerup_drop_count >= level.zombie_vars["zombie_powerup_drop_max_per_round"])
			level.powerup_drop_count = level.zombie_vars["zombie_powerup_drop_max_per_round"] - 1;

		level.zombie_vars["zombie_drop_item"] = 1;
		level thread maps\mp\zombies\_zm_powerups::powerup_drop(powerup_origin.origin);
	}

	powerup_origin delete();
}

cloud_update_fx()
{
	self endon("cloud_fx_end");
	level endon("end_game");
	region = [];
	region[0] = "bus";
	region[1] = "diner";
	region[2] = "farm";
	region[3] = "cornfield";
	region[4] = "power";
	region[5] = "town";

	if (!isdefined(self.sndent))
	{
		self.sndent = spawn("script_origin", (0, 0, 0));
		self.sndent playloopsound("zmb_avogadro_thunder_overhead");
	}

	cloud_time = gettime();

	for (vo_counter = 0; 1; vo_counter++)
	{
		if (gettime() >= cloud_time)
		{
			if (isdefined(self.current_region))
			{
				exploder_num = level.transit_region[self.current_region].exploder;
				stop_exploder(exploder_num);
			}

			rand_region = array_randomize(region);
			region_str = rand_region[0];

			if (!isdefined(self.current_region))
				region_str = region[4];

			self.current_region = region_str;
			exploder_num = level.transit_region[region_str].exploder;
			exploder(exploder_num);
			self.sndent moveto(level.transit_region[region_str].sndorigin, 3);
			cloud_time = gettime() + 30000;
		}

		if (vo_counter > 50)
		{
			player = self get_player_in_region();

			if (isdefined(player))
			{
				if (isdefined(self._in_cloud) && self._in_cloud)
					player thread do_player_general_vox("general", "avogadro_above", 90, 10);
				else
					player thread do_player_general_vox("general", "avogadro_arrive", 60, 40);
			}
			else
				level thread avogadro_storm_vox();

			vo_counter = 0;
		}

		wait 0.1;
	}
}

avogadro_damage_func(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if (self.state == "exiting" || self.state == "phasing")
	{
		return false;
	}

	if (smeansofdeath == "MOD_MELEE")
	{
		if (isplayer(einflictor))
		{
			if (self.shield)
			{
				einflictor.avogadro_melee_time = gettime();
				maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_ai_avogadro_electrified", einflictor, 0.25, 1);
				einflictor shellshock("electrocution", 0.25);
				einflictor notify("avogadro_damage_taken");
			}

			if (sweapon == "riotshield_zm")
			{
				shield_damage = level.zombie_vars["riotshield_fling_damage_shield"];
				einflictor maps\mp\zombies\_zm_weap_riotshield::player_damage_shield(shield_damage, 0);
			}
		}

		if (!self.shield)
		{
			self.shield = 1;
			self notify("melee_pain");

			if (issubstr(sweapon, "tazer_knuckles_zm"))
			{
				self.hit_by_melee += 2;
			}
			else
			{
				self.hit_by_melee++;
			}

			self thread avogadro_pain(einflictor);

			if (isplayer(einflictor))
			{
				einflictor thread do_player_general_vox("general", "avogadro_wound", 30, 35);
				level notify("avogadro_stabbed", self);
			}
		}
	}
	else
	{
		self update_damage_absorbed(idamage);
	}

	return false;
}