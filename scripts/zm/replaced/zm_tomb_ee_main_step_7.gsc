#include maps\mp\zm_tomb_ee_main_step_7;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zm_tomb_chamber;

ee_zombie_killed_override(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
{
	if (isdefined(attacker) && isplayer(attacker) && !issubstr(sweapon, "staff") && maps\mp\zm_tomb_chamber::is_point_in_chamber(self.origin))
	{
		level thread zombie_soul_to_portal(self);
	}
}

zombie_soul_to_portal(ai_zombie)
{
	ai_zombie setclientfield("ee_zombie_soul_portal", 1);

	wait 1;

	if (flag("ee_souls_absorbed"))
	{
		return;
	}

	level.n_ee_portal_souls++;

	if (level.n_ee_portal_souls == 1)
	{
		level thread ee_samantha_say("vox_sam_generic_encourage_3");
	}
	else if (level.n_ee_portal_souls == floor(33.3333))
	{
		level thread ee_samantha_say("vox_sam_generic_encourage_4");
	}
	else if (level.n_ee_portal_souls == floor(66.6667))
	{
		level thread ee_samantha_say("vox_sam_generic_encourage_5");
	}
	else if (level.n_ee_portal_souls == 100)
	{
		level thread ee_samantha_say("vox_sam_generic_encourage_0");
		flag_set("ee_souls_absorbed");
	}
}