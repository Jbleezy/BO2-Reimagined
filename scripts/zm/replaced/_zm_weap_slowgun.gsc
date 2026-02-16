#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;

slowgun_zombie_damage_response(mod, hit_location, hit_origin, player, amount)
{
	if (!self is_slowgun_damage(self.damagemod, self.damageweapon))
	{
		if (isdefined(self.slowgun_anim_rate) && self.slowgun_anim_rate < 1.0 && mod != level.slowgun_damage_mod)
		{
			extra_damage = get_extra_damage(amount, mod, self.slowgun_anim_rate);

			if (extra_damage > 0)
			{
				if (isalive(self))
				{
					self dodamage(extra_damage, hit_origin, player, player, hit_location, level.slowgun_damage_mod, 0, "slowgun_zm");
				}

				if (!isalive(self))
				{
					return true;
				}
			}
		}

		return false;
	}

	if (gettime() - self.paralyzer_score_time_ms >= 500)
	{
		self.paralyzer_score_time_ms = gettime();

		if (self.paralyzer_damage < 47073)
		{
			player maps\mp\zombies\_zm_score::player_add_points("damage", mod, hit_location, self.isdog, level.zombie_team);
		}
	}

	if (player maps\mp\zombies\_zm_powerups::is_insta_kill_active())
	{
		amount = self.health + 666;
	}

	if (isalive(self))
	{
		self dodamage(amount, hit_origin, player, player, hit_location, mod, 0, "slowgun_zm");
	}

	return true;
}

slowgun_fired(upgraded)
{
	origin = self getweaponmuzzlepoint();
	forward = self getweaponforwarddir();
	targets = self get_targets_in_range(upgraded, origin, forward);

	if (targets.size)
	{
		foreach (target in targets)
		{
			if (isplayer(target))
			{
				if (is_player_valid(target) && self != target)
				{
					target thread player_paralyzed(self, upgraded);
				}
				else if (is_true(target.is_zombie) && target.sessionstate == "playing" && !is_true(target.turned_zombie_spawn_protection) && self.team != target.team)
				{
					target thread player_paralyzed(self, upgraded, 1);
				}

				continue;
			}

			if (isdefined(target.paralyzer_hit_callback))
			{
				target thread [[target.paralyzer_hit_callback]](self, upgraded);
				continue;
			}

			target thread zombie_paralyzed(self, upgraded);
		}
	}

	dot = vectordot(forward, (0, 0, -1));

	if (dot > 0.8)
	{
		self thread player_paralyzed(self, upgraded);
	}
}

player_paralyzed(byplayer, upgraded, player_zombie = 0)
{
	self notify("player_paralyzed");
	self endon("player_paralyzed");
	self endon("death");

	if (isdefined(level.slowgun_allow_player_paralyze))
	{
		if (!self [[level.slowgun_allow_player_paralyze]]())
		{
			return;
		}
	}

	if (self != byplayer)
	{
		sizzle = "player_slowgun_sizzle";

		if (upgraded)
		{
			sizzle = "player_slowgun_sizzle_ug";
		}

		if (isdefined(level._effect[sizzle]))
		{
			playfxontag(level._effect[sizzle], self, "J_SpineLower");
		}
	}

	if (player_zombie)
	{
		self thread zombie_paralyzed(byplayer, upgraded);
	}
	else
	{
		self thread player_slow_for_time(0.25);
	}
}

zombie_paralyzed(player, upgraded)
{
	if (!can_be_paralyzed(self))
	{
		return;
	}

	insta = player maps\mp\zombies\_zm_powerups::is_insta_kill_active();

	if (isai(self))
	{
		if (upgraded)
		{
			self setclientfield("slowgun_fx", 5);
		}
		else
		{
			self setclientfield("slowgun_fx", 1);
		}
	}

	if (self.slowgun_anim_rate <= 0.1 || insta && self.slowgun_anim_rate <= 0.5)
	{
		if (upgraded)
		{
			damage = level.slowgun_damage_ug;
		}
		else
		{
			damage = level.slowgun_damage;
		}

		damage *= randomfloatrange(0.667, 1.5);
		damage *= self.paralyzer_damaged_multiplier;

		if (!isdefined(self.paralyzer_damage))
		{
			self.paralyzer_damage = 0;
		}

		// if ( self.paralyzer_damage > 47073 )
		//	damage *= 47073 / self.paralyzer_damage;

		self.paralyzer_damage += damage;

		if (insta)
		{
			damage = self.health + 666;
		}

		if (isalive(self))
		{
			self dodamage(damage, player.origin, player, player, "none", level.slowgun_damage_mod, 0, "slowgun_zm");
		}

		self.paralyzer_damaged_multiplier *= 1.15;
		self.paralyzer_damaged_multiplier = min(self.paralyzer_damaged_multiplier, 50);
	}
	else
	{
		self.paralyzer_damaged_multiplier = 1;
	}

	self zombie_slow_for_time(0.2);
}

zombie_slow_for_time(time, multiplier)
{
	if (!isdefined(multiplier))
	{
		multiplier = 2.0;
	}

	paralyzer_time_per_frame = 0.1 * (1.0 + multiplier);

	if (self.paralyzer_slowtime <= time)
	{
		self.paralyzer_slowtime = time + paralyzer_time_per_frame;
	}
	else
	{
		self.paralyzer_slowtime = self.paralyzer_slowtime + paralyzer_time_per_frame;
	}

	if (!isdefined(self.slowgun_anim_rate))
	{
		self.slowgun_anim_rate = 1;
	}

	if (!isdefined(self.slowgun_desired_anim_rate))
	{
		self.slowgun_desired_anim_rate = 1;
	}

	if (self.slowgun_desired_anim_rate > 0.3)
	{
		self.slowgun_desired_anim_rate = self.slowgun_desired_anim_rate - 0.2;
	}
	else
	{
		self.slowgun_desired_anim_rate = 0.05;
	}

	if (is_true(self.slowing))
	{
		return;
	}

	self.slowing = 1;
	self.preserve_asd_substates = 1;
	self playloopsound("wpn_paralyzer_slowed_loop", 0.1);

	while (self.paralyzer_slowtime > 0 && isalive(self))
	{
		if (self.paralyzer_slowtime < 0.1)
		{
			self.slowgun_desired_anim_rate = 1;
		}
		else if (self.paralyzer_slowtime < 2 * 0.1)
		{
			self.slowgun_desired_anim_rate = max(self.slowgun_desired_anim_rate, 0.8);
		}
		else if (self.paralyzer_slowtime < 3 * 0.1)
		{
			self.slowgun_desired_anim_rate = max(self.slowgun_desired_anim_rate, 0.6);
		}
		else if (self.paralyzer_slowtime < 4 * 0.1)
		{
			self.slowgun_desired_anim_rate = max(self.slowgun_desired_anim_rate, 0.4);
		}
		else if (self.paralyzer_slowtime < 5 * 0.1)
		{
			self.slowgun_desired_anim_rate = max(self.slowgun_desired_anim_rate, 0.2);
		}

		if (self.slowgun_desired_anim_rate == self.slowgun_anim_rate)
		{
			self.paralyzer_slowtime = self.paralyzer_slowtime - 0.1;
			wait 0.1;
		}
		else if (self.slowgun_desired_anim_rate >= self.slowgun_anim_rate)
		{
			new_rate = self.slowgun_desired_anim_rate;

			if (self.slowgun_desired_anim_rate - self.slowgun_anim_rate > 0.2)
			{
				new_rate = self.slowgun_anim_rate + 0.2;
			}

			self.paralyzer_slowtime = self.paralyzer_slowtime - 0.1;
			zombie_change_rate(0.1, new_rate);
			self.paralyzer_damaged_multiplier = 1;
		}
		else if (self.slowgun_desired_anim_rate <= self.slowgun_anim_rate)
		{
			new_rate = self.slowgun_desired_anim_rate;

			if (self.slowgun_anim_rate - self.slowgun_desired_anim_rate > 0.2)
			{
				new_rate = self.slowgun_anim_rate - 0.2;
			}

			self.paralyzer_slowtime = self.paralyzer_slowtime - 0.25;
			zombie_change_rate(0.25, new_rate);
		}
	}

	if (self.slowgun_anim_rate < 1)
	{
		self zombie_change_rate(0, 1);
	}

	self.preserve_asd_substates = 0;
	self.slowing = 0;
	self.paralyzer_damaged_multiplier = 1;

	if (isai(self))
	{
		self setclientfield("slowgun_fx", 0);
	}

	self stoploopsound(0.1);
}

zombie_change_rate(time, newrate)
{
	if (isplayer(self))
	{
		self.ignore_slowgun_anim_rates = 1;

		self.n_move_scale_modifiers["slowgun"] = newrate;

		self scripts\zm\_zm_reimagined::set_move_speed_scale(self.n_move_scale);
	}

	self set_anim_rate(newrate);

	if (isdefined(self.reset_anim))
	{
		self thread [[self.reset_anim]]();
	}
	else
	{
		self thread reset_anim();
	}

	if (time > 0)
	{
		wait(time);
	}
}

slowgun_zombie_death_response()
{
	if (!self is_slowgun_damage(self.damagemod, self.damageweapon))
	{
		return false;
	}

	level maps\mp\zombies\_zm_spawner::zombie_death_points(self.origin, self.damagemod, self.damagelocation, self.attacker, self);
	self thread explode_into_dust(self.attacker, self.damageweapon == "slowgun_upgraded_zm");

	self slowgun_zombie_death_wait();

	return true;
}

// fixes spawn delay for next zombies
slowgun_zombie_death_wait()
{
	self set_anim_rate(1.0);
	self.ignore_slowgun_anim_rates = 1;

	wait 0.1;
}

player_slow_for_time(time)
{
	if (is_true(self._being_shellshocked))
	{
		return;
	}

	self notify("player_slow_for_time");
	self endon("player_slow_for_time");
	self endon("disconnect");

	if (!is_true(self.slowgun_flying))
	{
		self thread player_fly_rumble();
	}

	if (self isonground())
	{
		self.slowgun_flying_rate = undefined;
	}

	if (!isdefined(self.slowgun_flying_rate))
	{
		self.slowgun_flying_rate = 0.05;
	}
	else
	{
		self.slowgun_flying_rate += 0.01;

		if (self.slowgun_flying_rate > 1.0)
		{
			self.slowgun_flying_rate = 1.0;
		}
	}

	self setclientfieldtoplayer("slowgun_fx", 1);
	self set_anim_rate(self.slowgun_flying_rate);

	wait(time);

	self set_anim_rate(1.0);
	self setclientfieldtoplayer("slowgun_fx", 0);
	self.slowgun_flying = 0;
	self.slowgun_flying_rate = undefined;
}

watch_reset_anim_rate()
{
	self set_anim_rate(1.0);
	self setclientfieldtoplayer("slowgun_fx", 0);

	while (1)
	{
		self waittill_any("spawned_player", "entering_last_stand", "player_revived", "player_suicide");
		self setclientfieldtoplayer("slowgun_fx", 0);
		self set_anim_rate(1.0);

		if (isdefined(self.n_move_scale_modifiers))
		{
			self.n_move_scale_modifiers["slowgun"] = undefined;
		}

		self.paralyzer_hit_callback = ::zombie_paralyzed;
		self.paralyzer_damaged_multiplier = 1;
		self.paralyzer_score_time_ms = gettime();
		self.paralyzer_slowtime = 0;
	}
}