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
	{
		vulture_vision_disable(localclientnumber);
	}

	level.perk_vulture.vulture_vision_fx_list[localclientnumber] = spawnstruct();
	s_temp = level.perk_vulture.vulture_vision_fx_list[localclientnumber];
	s_temp.player_ent = self;
	s_temp.fx_list = [];
	s_temp.fx_list_wallbuy = [];
	s_temp.fx_list_special = [];

	foreach (powerup in level.perk_vulture.vulture_vision.powerups)
	{
		powerup _powerup_drop_fx_enable(localclientnumber);
	}

	foreach (zombie in level.perk_vulture.vulture_vision.actors_eye_glow)
	{
		zombie _zombie_eye_glow_enable(localclientnumber);
	}

	self.perk_vulture = s_temp;
	level.perk_vulture.fx_array[localclientnumber] = s_temp;

	self thread vulture_perk_ir_think(localclientnumber);
}

vulture_vision_disable(localclientnumber)
{
	b_removed_fx = 0;

	if (isdefined(level.perk_vulture.vulture_vision_fx_list[localclientnumber]))
	{
		if (isdefined(level.perk_vulture.vulture_vision_fx_list[localclientnumber].fx_list))
		{
			foreach (n_fx_id in level.perk_vulture.vulture_vision_fx_list[localclientnumber].fx_list)
			{
				deletefx(localclientnumber, n_fx_id, 1);
			}
		}

		if (isdefined(level.perk_vulture.vulture_vision_fx_list[localclientnumber].fx_list_wallbuy))
		{
			foreach (n_fx_id in level.perk_vulture.vulture_vision_fx_list[localclientnumber].fx_list_wallbuy)
			{
				deletefx(localclientnumber, n_fx_id, 1);
			}
		}

		if (isdefined(level.perk_vulture.vulture_vision_fx_list[localclientnumber].fx_list_special))
		{
			foreach (n_fx_id in level.perk_vulture.vulture_vision_fx_list[localclientnumber].fx_list_special)
			{
				deletefx(localclientnumber, n_fx_id, 1);
			}

			level.perk_vulture.vulture_vision_fx_list[localclientnumber] = undefined;
		}
	}

	foreach (powerup in level.perk_vulture.vulture_vision.powerups)
	{
		powerup _powerup_drop_fx_disable(localclientnumber);
	}

	foreach (zombie in level.perk_vulture.vulture_vision.actors_eye_glow)
	{
		zombie _zombie_eye_glow_disable(localclientnumber);
	}

	setlutscriptindex(localclientnumber, 0);
	disable_filter_zm_turned(self, 0, 0);
	self setsonarattachmentenabled(0);

	level notify("vulture_perk_ir_stop");
}

vulture_perk_ir_think(localclientnumber)
{
	level endon("vulture_perk_ir_stop");

	while (1)
	{
		setlutscriptindex(localclientnumber, 2);
		enable_filter_zm_turned(self, 0, 0);
		self setsonarattachmentenabled(1);

		level waittill("vulture_perk_ir_reset");
	}
}

vulture_vision_update_wallbuy_list(localclientnumber, b_first_run)
{
	// removed
}

vulture_vision_mystery_box(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	// removed
}