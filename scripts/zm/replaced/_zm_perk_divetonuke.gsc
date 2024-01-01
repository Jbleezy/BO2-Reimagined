#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;

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