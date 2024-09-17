#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_ai_basic;

electric_cherry_reload_attack()
{
	self endon("death");
	self endon("disconnect");
	self endon("stop_electric_cherry_reload_attack");
	self.wait_on_reload = [];
	self.consecutive_electric_cherry_attacks = 0;

	while (true)
	{
		self waittill("reload_start");
		str_current_weapon = self getcurrentweapon();

		if (isinarray(self.wait_on_reload, str_current_weapon))
		{
			continue;
		}

		self.wait_on_reload[self.wait_on_reload.size] = str_current_weapon;
		self.consecutive_electric_cherry_attacks++;
		n_clip_current = self getweaponammoclip(str_current_weapon);
		n_clip_max = weaponclipsize(str_current_weapon);
		n_fraction = n_clip_current / n_clip_max;
		perk_radius = linear_map(n_fraction, 1.0, 0.0, 32, 128);
		perk_dmg = linear_map(n_fraction, 1.0, 0.0, 1, 1045);
		self thread check_for_reload_complete(str_current_weapon);

		if (isdefined(self))
		{
			switch (self.consecutive_electric_cherry_attacks)
			{
				case 0:
				case 1:
					n_zombie_limit = undefined;
					break;

				case 2:
					n_zombie_limit = 8;
					break;

				case 3:
					n_zombie_limit = 4;
					break;

				case 4:
					n_zombie_limit = 2;
					break;

				default:
					n_zombie_limit = 0;
			}

			self thread electric_cherry_cooldown_timer(str_current_weapon);

			if (isdefined(n_zombie_limit) && n_zombie_limit == 0)
			{
				continue;
			}

			self thread electric_cherry_reload_fx(n_fraction);
			self notify("electric_cherry_start");
			self playsound("zmb_cherry_explode");
			a_zombies = get_round_enemy_array();
			a_zombies = arraycombine(a_zombies, get_players(getotherteam(self.team)), 1, 0);
			a_zombies = get_array_of_closest(self.origin, a_zombies, undefined, undefined, perk_radius);
			n_zombies_hit = 0;

			for (i = 0; i < a_zombies.size; i++)
			{
				if (isalive(self))
				{
					if (isdefined(n_zombie_limit))
					{
						if (n_zombies_hit < n_zombie_limit)
						{
							n_zombies_hit++;
						}
						else
						{
							break;
						}
					}

					if (isai(a_zombies[i]))
					{
						if (a_zombies[i].health <= perk_dmg)
						{
							a_zombies[i] thread electric_cherry_death_fx();

							if (isdefined(self.cherry_kills))
							{
								self.cherry_kills++;
							}

							self maps\mp\zombies\_zm_score::add_to_player_score(40);
						}
						else
						{
							if (!isdefined(a_zombies[i].is_brutus))
							{
								a_zombies[i] thread electric_cherry_stun();
							}

							a_zombies[i] thread electric_cherry_shock_fx();
						}
					}

					wait 0.1;
					a_zombies[i] dodamage(perk_dmg, self.origin, self, self, "none", "MOD_UNKNOWN", 0, "zombie_perk_bottle_cherry");
				}
			}

			self notify("electric_cherry_end");
		}
	}
}

electric_cherry_laststand()
{
	visionsetlaststand("zombie_last_stand", 1);

	if (isdefined(self))
	{
		playfx(level._effect["electric_cherry_explode"], self.origin);
		self playsound("zmb_cherry_explode");
		self notify("electric_cherry_start");
		wait 0.05;
		a_zombies = get_round_enemy_array();
		a_zombies = arraycombine(a_zombies, get_players(getotherteam(self.team)), 1, 0);
		a_zombies = get_array_of_closest(self.origin, a_zombies, undefined, undefined, 500);

		for (i = 0; i < a_zombies.size; i++)
		{
			if (isalive(self))
			{
				if (isai(a_zombies[i]))
				{
					a_zombies[i] thread electric_cherry_death_fx();

					if (isdefined(self.cherry_kills))
					{
						self.cherry_kills++;
					}

					self maps\mp\zombies\_zm_score::add_to_player_score(40);
				}

				wait 0.1;
				a_zombies[i] dodamage(a_zombies[i].health + 1000, self.origin, self, self, "none", "MOD_UNKNOWN", 0, "zombie_perk_bottle_cherry");
			}
		}

		self notify("electric_cherry_end");
	}
}