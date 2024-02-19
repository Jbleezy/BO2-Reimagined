#include clientscripts\mp\zombies\_zm_perk_vulture;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zombies\_zm_perks;
#include clientscripts\mp\_visionset_mgr;
#include clientscripts\mp\_filter;

vulture_vision_enable(localclientnumber)
{
	if (isdefined(level.perk_vulture.vulture_vision_fx_list[localclientnumber]))
		vulture_vision_disable(localclientnumber);

	level.perk_vulture.vulture_vision_fx_list[localclientnumber] = spawnstruct();
	s_temp = level.perk_vulture.vulture_vision_fx_list[localclientnumber];
	s_temp.player_ent = self;
	s_temp.fx_list = [];
	s_temp.fx_list_wallbuy = [];
	s_temp.fx_list_special = [];

	foreach (powerup in level.perk_vulture.vulture_vision.powerups)
		powerup _powerup_drop_fx_enable(localclientnumber);

	foreach (zombie in level.perk_vulture.vulture_vision.actors_eye_glow)
		zombie _zombie_eye_glow_enable(localclientnumber);

	self.perk_vulture = s_temp;
	level.perk_vulture.fx_array[localclientnumber] = s_temp;
}

vulture_vision_update_wallbuy_list(localclientnumber, b_first_run)
{
	// removed
}

vulture_vision_mystery_box(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	// removed
}