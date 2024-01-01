#include maps\mp\zombies\_zm_spawner;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

zombie_damage(mod, hit_location, hit_origin, player, amount, team)
{
	if (is_magic_bullet_shield_enabled(self))
	{
		return;
	}

	player.use_weapon_type = mod;

	if (isDefined(self.marked_for_death))
	{
		return;
	}

	if (!isDefined(player))
	{
		return;
	}

	if (isDefined(hit_origin))
	{
		self.damagehit_origin = hit_origin;
	}
	else
	{
		self.damagehit_origin = player getweaponmuzzlepoint();
	}

	if (self maps\mp\zombies\_zm_spawner::check_zombie_damage_callbacks(mod, hit_location, hit_origin, player, amount))
	{
		return;
	}
	else if (self maps\mp\zombies\_zm_spawner::zombie_flame_damage(mod, player))
	{
		if (self maps\mp\zombies\_zm_spawner::zombie_give_flame_damage_points())
		{
			player maps\mp\zombies\_zm_score::player_add_points("damage", mod, hit_location, self.isdog, team);
		}
	}
	else if (maps\mp\zombies\_zm_spawner::player_using_hi_score_weapon(player))
	{
		damage_type = "damage";
	}
	else
	{
		damage_type = "damage_light";
	}

	if (!is_true(self.no_damage_points))
	{
		player maps\mp\zombies\_zm_score::player_add_points(damage_type, mod, hit_location, self.isdog, team, self.damageweapon);
	}

	if (isDefined(self.zombie_damage_fx_func))
	{
		self [[self.zombie_damage_fx_func]](mod, hit_location, hit_origin, player);
	}

	if (is_placeable_mine(self.damageweapon))
	{
		damage = level.round_number * 100;

		if (level.scr_zm_ui_gametype == "zgrief")
		{
			damage = 2000;
		}

		max_damage = 9000;

		if (damage > max_damage)
		{
			damage = max_damage;
		}

		if (isDefined(self.zombie_damage_claymore_func))
		{
			self [[self.zombie_damage_claymore_func]](mod, hit_location, hit_origin, player);
		}
		else if (isDefined(player) && isalive(player))
		{
			self dodamage(damage, self.origin, player, self, hit_location, mod, 0, self.damageweapon);
		}
		else
		{
			self dodamage(damage, self.origin, undefined, self, hit_location, mod, 0, self.damageweapon);
		}
	}
	else if (mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH")
	{
		damage = level.round_number * 25;

		if (level.scr_zm_ui_gametype == "zgrief")
		{
			damage = 500;
		}

		max_damage = 1500;

		if (damage > max_damage)
		{
			damage = max_damage;
		}

		if (isDefined(player) && isalive(player))
		{
			player.grenade_multiattack_count++;
			player.grenade_multiattack_ent = self;
			self dodamage(damage, self.origin, player, self, hit_location, "MOD_GRENADE_SPLASH", 0, self.damageweapon);
		}
		else
		{
			self dodamage(damage, self.origin, undefined, self, hit_location, "MOD_GRENADE_SPLASH", 0, self.damageweapon);
		}
	}
	else if (mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE")
	{
		damage = level.round_number * 50;

		if (level.scr_zm_ui_gametype == "zgrief")
		{
			damage = 1000;
		}

		max_damage = 3000;

		if (damage > max_damage)
		{
			damage = max_damage;
		}

		if (isDefined(player) && isalive(player))
		{
			self dodamage(damage, self.origin, player, self, hit_location, "MOD_PROJECTILE_SPLASH", 0, self.damageweapon);
		}
		else
		{
			self dodamage(damage, self.origin, undefined, self, hit_location, "MOD_PROJECTILE_SPLASH", 0, self.damageweapon);
		}
	}

	if (isDefined(self.a.gib_ref) && self.a.gib_ref == "no_legs" && isalive(self))
	{
		if (isDefined(player))
		{
			rand = randomintrange(0, 100);

			if (rand < 10)
			{
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "crawl_spawn");
			}
		}
	}
	else if (isDefined(self.a.gib_ref))
	{
		if (self.a.gib_ref == "right_arm" || self.a.gib_ref == "left_arm")
		{
			if (self.has_legs && isalive(self))
			{
				if (isDefined(player))
				{
					rand = randomintrange(0, 100);

					if (rand < 7)
					{
						player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "shoot_arm");
					}
				}
			}
		}
	}

	self thread maps\mp\zombies\_zm_powerups::check_for_instakill(player, mod, hit_location);
}

zombie_gib_on_damage()
{
	while (true)
	{
		self waittill("damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weaponname);

		if (!isdefined(self))
			return;

		if (!self zombie_should_gib(amount, attacker, type))
			continue;

		if (self head_should_gib(attacker, type, point) && type != "MOD_BURNED")
		{
			self zombie_head_gib(attacker, type);
			continue;
		}

		if (!self.gibbed)
		{
			if (self maps\mp\animscripts\zm_utility::damagelocationisany("head", "helmet", "neck"))
				continue;

			refs = [];

			switch (self.damagelocation)
			{
				case "torso_upper":
				case "torso_lower":
					refs[refs.size] = "guts";
					refs[refs.size] = "right_arm";
					break;

				case "right_hand":
				case "right_arm_upper":
				case "right_arm_lower":
					refs[refs.size] = "right_arm";
					break;

				case "left_hand":
				case "left_arm_upper":
				case "left_arm_lower":
					refs[refs.size] = "left_arm";
					break;

				case "right_leg_upper":
				case "right_leg_lower":
				case "right_foot":
					if (self.health <= 0)
					{
						refs[refs.size] = "right_leg";
						refs[refs.size] = "right_leg";
						refs[refs.size] = "right_leg";
						refs[refs.size] = "no_legs";
					}

					break;

				case "left_leg_upper":
				case "left_leg_lower":
				case "left_foot":
					if (self.health <= 0)
					{
						refs[refs.size] = "left_leg";
						refs[refs.size] = "left_leg";
						refs[refs.size] = "left_leg";
						refs[refs.size] = "no_legs";
					}

					break;

				default:
					if (self.damagelocation == "none")
					{
						if (type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH")
						{
							refs = self derive_damage_refs(point);
							break;
						}
					}
					else
					{
						refs[refs.size] = "guts";
						refs[refs.size] = "right_arm";
						refs[refs.size] = "left_arm";
						refs[refs.size] = "right_leg";
						refs[refs.size] = "left_leg";
						refs[refs.size] = "no_legs";
						break;
					}
			}

			if (isdefined(level.custom_derive_damage_refs))
				refs = self [[level.custom_derive_damage_refs]](refs, point, weaponname);

			if (refs.size)
			{
				self.a.gib_ref = maps\mp\animscripts\zm_death::get_random(refs);

				if ((self.a.gib_ref == "no_legs" || self.a.gib_ref == "right_leg" || self.a.gib_ref == "left_leg") && self.health > 0)
				{
					self.has_legs = 0;
					self allowedstances("crouch");
					self setphysparams(15, 0, 24);
					self allowpitchangle(1);
					self setpitchorient();
					health = self.health;
					health *= 0.1;
					self thread maps\mp\animscripts\zm_run::needsdelayedupdate();

					if (level.scr_zm_ui_gametype == "zgrief")
					{
						self thread bleedout_watcher();
					}

					if (isdefined(self.crawl_anim_override))
						self [[self.crawl_anim_override]]();
				}
			}

			if (self.health > 0)
			{
				self thread maps\mp\animscripts\zm_death::do_gib();

				if (isdefined(level.gib_on_damage))
					self thread [[level.gib_on_damage]]();
			}
		}
	}
}

zombie_should_gib(amount, attacker, type)
{
	if (!is_mature())
		return false;

	if (!isdefined(type))
		return false;

	if (isdefined(self.is_on_fire) && self.is_on_fire)
		return false;

	if (isdefined(self.no_gib) && self.no_gib == 1)
		return false;

	switch (type)
	{
		case "MOD_UNKNOWN":
		case "MOD_TRIGGER_HURT":
		case "MOD_TELEFRAG":
		case "MOD_SUICIDE":
		case "MOD_FALLING":
		case "MOD_CRUSH":
		case "MOD_BURNED":
			return false;

		case "MOD_MELEE":
			return false;
	}

	if (type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET")
	{
		if (!isdefined(attacker) || !isplayer(attacker))
			return false;

		weapon = attacker getcurrentweapon();

		if (weapon == "none" || weapon == level.start_weapon)
			return false;

		if (weaponisgasweapon(self.weapon))
			return false;
	}
	else if (type == "MOD_PROJECTILE")
	{
		if (isdefined(attacker) && isplayer(attacker))
		{
			weapon = attacker getcurrentweapon();

			if (weapon == "slipgun_zm" || weapon == "slipgun_upgraded_zm")
				return false;
		}
	}

	prev_health = amount + self.health;

	if (prev_health <= 0)
		prev_health = 1;

	damage_percent = amount / prev_health * 100;

	if (damage_percent < 25)
		return false;

	return true;
}

bleedout_watcher()
{
	self endon("death");

	self thread melee_watcher();

	self.bleedout_time = getTime();
	health = self.health;

	while (1)
	{
		if (health > self.health)
		{
			health = self.health;
			self.bleedout_time = getTime();
		}

		if (getTime() - self.bleedout_time > 30000)
		{
			level.zombie_total++;
			self.no_powerups = 1;
			self dodamage(self.health + 100, self.origin);
			return;
		}

		wait 0.05;
	}
}

melee_watcher()
{
	self endon("death");

	while (1)
	{
		self waittill("melee_anim");

		self.bleedout_time = getTime();
	}
}

head_should_gib(attacker, type, point)
{
	if (!is_mature())
	{
		return 0;
	}

	if (self.head_gibbed)
	{
		return 0;
	}

	if (!isDefined(attacker) || !isplayer(attacker))
	{
		return 0;
	}

	weapon = attacker getcurrentweapon();

	if (type != "MOD_RIFLE_BULLET" && type != "MOD_PISTOL_BULLET")
	{
		if (type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH")
		{
			if ((distance(point, self gettagorigin("j_head")) > 55) || (self.health > 0))
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		else if (type == "MOD_PROJECTILE")
		{
			if ((distance(point, self gettagorigin("j_head")) > 10) || (self.health > 0))
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		else if (weaponclass(weapon) != "spread")
		{
			return 0;
		}
	}

	if (!self maps\mp\animscripts\zm_utility::damagelocationisany("head", "helmet", "neck"))
	{
		return 0;
	}

	if (weapon == "none" || weapon == level.start_weapon || weaponisgasweapon(self.weapon))
	{
		return 0;
	}

	self zombie_hat_gib(attacker, type);

	if (self.health > 0)
	{
		return 0;
	}

	return 1;
}

zombie_death_animscript()
{
	team = undefined;
	recalc_zombie_array();

	if (isdefined(self._race_team))
		team = self._race_team;

	self reset_attack_spot();

	if (self check_zombie_death_animscript_callbacks())
		return false;

	if (isdefined(level.zombie_death_animscript_override))
		self [[level.zombie_death_animscript_override]]();

	if (self.has_legs && isdefined(self.a.gib_ref) && self.a.gib_ref == "no_legs")
		self.deathanim = "zm_death";

	self.grenadeammo = 0;

	if (isdefined(self.nuked))
	{
		if (zombie_can_drop_powerups(self))
		{
			if (isdefined(self.in_the_ground) && self.in_the_ground == 1)
			{
				trace = bullettrace(self.origin + vectorscale((0, 0, 1), 100.0), self.origin + vectorscale((0, 0, -1), 100.0), 0, undefined);
				origin = trace["position"];
				level thread zombie_delay_powerup_drop(origin);
			}
			else
			{
				trace = groundtrace(self.origin + vectorscale((0, 0, 1), 5.0), self.origin + vectorscale((0, 0, -1), 300.0), 0, undefined);
				origin = trace["position"];
				level thread zombie_delay_powerup_drop(self.origin);
			}
		}
	}
	else
		level zombie_death_points(self.origin, self.damagemod, self.damagelocation, self.attacker, self, team);

	if (isdefined(self.attacker) && isai(self.attacker))
		self.attacker notify("killed", self);

	if ("rottweil72_upgraded_zm" == self.damageweapon && "MOD_RIFLE_BULLET" == self.damagemod)
		self thread dragons_breath_flame_death_fx();

	if (issubstr(self.damageweapon, "tazer_knuckles_zm") && "MOD_MELEE" == self.damagemod)
	{
		self.is_on_fire = 0;
		self notify("stop_flame_damage");
	}

	if (self.damagemod == "MOD_BURNED")
		self thread maps\mp\animscripts\zm_death::flame_death_fx();

	if (self.damagemod == "MOD_GRENADE" || self.damagemod == "MOD_GRENADE_SPLASH")
		level notify("zombie_grenade_death", self.origin);

	return false;
}

zombie_can_drop_powerups(zombie)
{
	if (!flag("zombie_drop_powerups"))
		return false;

	if (isdefined(zombie.no_powerups) && zombie.no_powerups)
		return false;

	return true;
}

zombie_complete_emerging_into_playable_area()
{
	if (self.animname == "zombie" && is_true(self.has_legs))
	{
		self setphysparams(15, 0, 60);
	}

	self.completed_emerging_into_playable_area = 1;
	self notify("completed_emerging_into_playable_area");
	self.no_powerups = 0;
	self thread zombie_free_cam_allowed();
}