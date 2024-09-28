#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;

divetonuke_precache()
{
	precacheitem("zombie_perk_bottle_nuke");
	precacheshader("specialty_divetonuke_zombies");
	precachemodel("p6_zm_al_vending_nuke_on");
	precachestring(&"ZOMBIE_PERK_DIVETONUKE");

	if (getdvar("mapname") == "zm_prison")
	{
		level._effect["divetonuke_light"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_perk_smk");
	}
	else
	{
		level._effect["divetonuke_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
	}

	level.machine_assets["divetonuke"] = spawnstruct();
	level.machine_assets["divetonuke"].weapon = "zombie_perk_bottle_nuke";
	level.machine_assets["divetonuke"].off_model = "p6_zm_al_vending_nuke_on";
	level.machine_assets["divetonuke"].on_model = "p6_zm_al_vending_nuke_on";
	level.machine_assets["divetonuke"].power_on_callback = ::vending_divetonuke_power_on;
	level.machine_assets["divetonuke"].power_off_callback = ::vending_divetonuke_power_off;
}

vending_divetonuke_power_on()
{
	if (level.script == "zm_prison")
	{
		self setclientfield("toggle_perk_machine_power", 2);
	}
	else
	{
		level thread scripts\zm\_zm_reimagined::clientnotifyloop("toggle_vending_divetonuke_power_on", "divetonuke_off");
	}
}

vending_divetonuke_power_off()
{
	if (level.script == "zm_prison")
	{
		self setclientfield("toggle_perk_machine_power", 1);
	}
	else
	{
		level thread scripts\zm\_zm_reimagined::clientnotifyloop("toggle_vending_divetonuke_power_off", "divetonuke_on");
	}
}

divetonuke_register_clientfield()
{
	bits = 1;

	if (isdefined(level.zombie_include_weapons) && isdefined(level.zombie_include_weapons["emp_grenade_zm"]))
	{
		bits = 2;
	}

	registerclientfield("toplayer", "perk_dive_to_nuke", 9000, bits, "int");
}

divetonuke_perk_machine_setup(use_trigger, perk_machine, bump_trigger, collision)
{
	use_trigger.script_sound = "mus_perks_phdflopper_jingle";
	use_trigger.script_string = "divetonuke_perk";
	use_trigger.script_label = "mus_perks_phdflopper_sting";
	use_trigger.target = "vending_divetonuke";
	perk_machine.script_string = "divetonuke_perk";
	perk_machine.targetname = "vending_divetonuke";

	if (isdefined(bump_trigger))
	{
		bump_trigger.script_string = "divetonuke_perk";
	}
}

divetonuke_explode(attacker, origin)
{
	radius = level.zombie_vars["zombie_perk_divetonuke_radius"];
	min_damage = level.zombie_vars["zombie_perk_divetonuke_min_damage"];
	max_damage = level.zombie_vars["zombie_perk_divetonuke_max_damage"];

	radiusdamage(origin, radius, max_damage, min_damage, attacker, "MOD_GRENADE_SPLASH", "zombie_perk_bottle_nuke");

	playfx(level._effect["divetonuke_groundhit"], origin);
	attacker playsound("zmb_phdflop_explo");
	maps\mp\_visionset_mgr::vsmgr_activate("visionset", "zm_perk_divetonuke", attacker);
	wait 1;
	maps\mp\_visionset_mgr::vsmgr_deactivate("visionset", "zm_perk_divetonuke", attacker);
}