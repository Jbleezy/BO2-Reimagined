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

	if (getdvar("mapname") == "zm_prison")
	{
		level._effect["electriccherry"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_perk_smk");
	}
	else
	{
		level._effect["electriccherry"] = loadfx("misc/fx_zombie_cola_on");
	}

	level._effect["electric_cherry_explode"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_down");
	level._effect["electric_cherry_reload_small"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_sm");
	level._effect["electric_cherry_reload_medium"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_player");
	level._effect["electric_cherry_reload_large"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_electric_cherry_lg");
	level._effect["tesla_shock"] = loadfx("maps/zombie/fx_zombie_tesla_shock");
	level._effect["tesla_shock_secondary"] = loadfx("maps/zombie/fx_zombie_tesla_shock_secondary");
	level.machine_assets["electriccherry"] = spawnstruct();
	level.machine_assets["electriccherry"].power_on_callback = ::vending_electriccherry_power_on;
	level.machine_assets["electriccherry"].power_off_callback = ::vending_electriccherry_power_off;
}

vending_electriccherry_power_on()
{
	if (level.script == "zm_prison")
	{
		self setclientfield("toggle_perk_machine_power", 2);
	}
	else
	{
		level thread scripts\zm\_zm_reimagined::clientnotifyloop("toggle_vending_electriccherry_power_on", "electric_cherry_off");
	}
}

vending_electriccherry_power_off()
{
	if (level.script == "zm_prison")
	{
		self setclientfield("toggle_perk_machine_power", 1);
	}
	else
	{
		level thread scripts\zm\_zm_reimagined::clientnotifyloop("toggle_vending_electriccherry_power_off", "electric_cherry_on");
	}
}

electric_cherry_perk_machine_think()
{
	init_electric_cherry();

	while (true)
	{
		machine = getentarray("vendingelectric_cherry", "targetname");
		machine_triggers = getentarray("vending_electriccherry", "target");

		for (i = 0; i < machine.size; i++)
		{
			machine[i] setmodel("p6_zm_vending_electric_cherry_off");
		}

		level thread do_initial_power_off_callback(machine, "electriccherry");
		array_thread(machine_triggers, maps\mp\zombies\_zm_perks::set_power_on, 0);
		level waittill("electric_cherry_on");

		for (i = 0; i < machine.size; i++)
		{
			machine[i] setmodel("p6_zm_vending_electric_cherry_on");
			machine[i] vibrate(vectorscale((0, -1, 0), 100.0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx("electriccherry");
			machine[i] thread play_loop_on_machine();
		}

		level notify("specialty_grenadepulldeath_power_on");
		array_thread(machine_triggers, maps\mp\zombies\_zm_perks::set_power_on, 1);

		if (isdefined(level.machine_assets["electriccherry"].power_on_callback))
		{
			array_thread(machine, level.machine_assets["electriccherry"].power_on_callback);
		}

		level waittill("electric_cherry_off");

		if (isdefined(level.machine_assets["electriccherry"].power_off_callback))
		{
			array_thread(machine, level.machine_assets["electriccherry"].power_off_callback);
		}

		array_thread(machine, maps\mp\zombies\_zm_perks::turn_perk_off);
	}
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
			n_zombie_limit = undefined;

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

					if (isplayer(a_zombies[i]) && is_true(a_zombies[i].is_zombie) && a_zombies[i].sessionstate == "playing")
					{
						if (a_zombies[i].health <= perk_dmg)
						{
							if (is_player_valid(self))
							{
								self maps\mp\zombies\_zm_score::add_to_player_score(40);
							}
						}
						else
						{
							a_zombies[i] thread electric_cherry_stun_player_zombie();
							a_zombies[i] thread electric_cherry_shock_fx_player_zombie();
						}
					}

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
				}

				if (isalive(a_zombies[i]))
				{
					a_zombies[i] dodamage(a_zombies[i].health + 1000, self.origin, self, self, "none", "MOD_UNKNOWN", 0, "zombie_perk_bottle_cherry");
				}
			}
		}

		self notify("electric_cherry_end");
	}
}

electric_cherry_stun_player_zombie()
{
	self notify("stun_zombie");
	self endon("stun_zombie");
	self endon("disconnect");
	self endon("spawned_spectator");
	self endon("humanify");
	level endon("end_game");

	self.is_stunned = 1;

	self thread electric_cherry_stun_player_zombie_think();

	self shellshock("zombie_stun_zm", 2);
	self disableweapons();

	if (self is_jumping())
	{
		self setvelocity((0, 0, 0));

		while (self is_jumping())
		{
			wait 0.05;
		}
	}

	self freezecontrols(1);
}

electric_cherry_stun_player_zombie_think()
{
	self endon("stun_zombie");
	self endon("disconnect");
	level endon("end_game");

	result = self waittill_any_timeout(2, "spawned_spectator", "humanify");

	if (result == "timeout")
	{
		self enableweapons();
		self freezecontrols(0);
		self stopshellshock();
	}

	self.is_stunned = undefined;

	self notify("stun_zombie");
}

electric_cherry_shock_fx_player_zombie()
{
	tag = "J_SpineUpper";
	fx = "tesla_shock_secondary";

	player_fx_ent = spawn("script_model", self gettagorigin(tag));
	player_fx_ent.angles = self gettagangles(tag);
	player_fx_ent setmodel("tag_origin");
	player_fx_ent linkto(self, tag);

	self playsound("zmb_elec_jib_zombie");
	playfxontag(level._effect[fx], player_fx_ent, "tag_origin");

	self waittill_any("stun_zombie", "disconnect");

	player_fx_ent delete();
}