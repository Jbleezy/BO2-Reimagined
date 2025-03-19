#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_ai_basic;

enable_electric_cherry_perk_for_level()
{
	maps\mp\zombies\_zm_perks::register_perk_basic_info("specialty_grenadepulldeath", "electric_cherry", 2000, &"ZOMBIE_PERK_CHERRY", "zombie_perk_bottle_cherry");
	maps\mp\zombies\_zm_perks::register_perk_precache_func("specialty_grenadepulldeath", ::electic_cherry_precache);
	maps\mp\zombies\_zm_perks::register_perk_clientfields("specialty_grenadepulldeath", ::electric_cherry_register_clientfield, ::electric_cherry_set_clientfield);
	maps\mp\zombies\_zm_perks::register_perk_threads("specialty_grenadepulldeath", ::electric_cherry_reload_attack, ::electric_cherry_perk_lost);
	maps\mp\zombies\_zm_perks::register_perk_machine("specialty_grenadepulldeath", ::electric_cherry_perk_machine_setup, ::electric_cherry_perk_machine_think);
	maps\mp\zombies\_zm_perks::register_perk_host_migration_func("specialty_grenadepulldeath", ::electric_cherry_host_migration_func);
}

electic_cherry_precache()
{
	precacheitem("zombie_perk_bottle_cherry");
	precacheshader("specialty_fastreload_zombies");
	precachemodel("p6_zm_vending_electric_cherry_off");
	precachemodel("p6_zm_vending_electric_cherry_on");
	precachestring(&"ZOMBIE_PERK_CHERRY");
	level._effect["electriccherry"] = loadfx("misc/fx_zombie_cola_on");
	level._effect["electric_cherry_explode"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_down");
	level._effect["electric_cherry_reload_small"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_sm");
	level._effect["electric_cherry_reload_medium"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_player");
	level._effect["electric_cherry_reload_large"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_lg");
	level._effect["tesla_shock"] = loadfx("maps/zombie/fx_zombie_tesla_shock");
	level._effect["tesla_shock_secondary"] = loadfx("maps/zombie/fx_zombie_tesla_shock_secondary");
}

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
			a_zombies = getaispeciesarray(level.zombie_team, "all");
			a_zombies = arraycombine(a_zombies, get_players(getotherteam(self.team)), 1, 0);
			a_zombies = get_array_of_closest(self.origin, a_zombies, undefined, undefined, perk_radius);
			n_zombies_hit = 0;

			for (i = 0; i < a_zombies.size; i++)
			{
				if (isalive(self) && isalive(a_zombies[i]))
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

							if (is_player_valid(self))
							{
								self maps\mp\zombies\_zm_score::add_to_player_score(40);
							}
						}
						else
						{
							if (!isdefined(a_zombies[i].is_brutus) && !isdefined(a_zombies[i].is_mechz))
							{
								a_zombies[i] thread electric_cherry_stun();
							}

							a_zombies[i] thread electric_cherry_shock_fx();
						}
					}

					wait 0.1;

					if (isalive(a_zombies[i]))
					{
						a_zombies[i] dodamage(perk_dmg, self.origin, self, self, "none", "MOD_UNKNOWN", 0, "zombie_perk_bottle_cherry");
					}
				}
			}

			self notify("electric_cherry_end");
		}
	}
}

electric_cherry_laststand()
{
	if (!is_player_valid(self) && !is_true(self.afterlife))
	{
		self useservervisionset(1);
		self setvisionsetforplayer("zombie_last_stand", 1);
	}

	if (isdefined(self))
	{
		playfxontag(level._effect["electric_cherry_explode"], self, "tag_origin");
		self playsound("zmb_cherry_explode");
		self notify("electric_cherry_start");
		wait 0.05;
		a_zombies = getaispeciesarray(level.zombie_team, "all");
		a_zombies = arraycombine(a_zombies, get_players(getotherteam(self.team)), 1, 0);
		a_zombies = get_array_of_closest(self.origin, a_zombies, undefined, undefined, 256);

		for (i = 0; i < a_zombies.size; i++)
		{
			if (isalive(self) && isalive(a_zombies[i]))
			{
				if (isai(a_zombies[i]))
				{
					a_zombies[i] thread electric_cherry_death_fx();

					if (isdefined(self.cherry_kills))
					{
						self.cherry_kills++;
					}

					if (is_player_valid(self))
					{
						self maps\mp\zombies\_zm_score::add_to_player_score(40);
					}
				}

				wait 0.1;

				if (isalive(a_zombies[i]))
				{
					a_zombies[i] dodamage(a_zombies[i].health + 1000, self.origin, self, self, "none", "MOD_UNKNOWN", 0, "zombie_perk_bottle_cherry");
				}
			}
		}

		self notify("electric_cherry_end");
	}
}