#include clientscripts\mp\zombies\_zm_powerup_zombie_blood;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_audio;
#include clientscripts\mp\_filter;
#include clientscripts\mp\zombies\_zm_powerups;
#include clientscripts\mp\_visionset_mgr;

init()
{
	onplayerconnect_callback(::init_filter_zombie_blood);
	level.vsmgr_filter_custom_enable["generic_filter_zombie_blood_b"] = ::vsmgr_enable_filter_zombie_blood;
	registerclientfield("allplayers", "player_zombie_blood_fx", 14000, 1, "int", ::toggle_player_zombie_blood_fx, 0, 1);
	level._effect["zombie_blood"] = loadfx("maps/zombie_tomb/fx_tomb_pwr_up_zmb_blood");
	level._effect["zombie_blood_1st"] = loadfx("maps/zombie_tomb/fx_zm_blood_overlay_pclouds");
	level._effect["player_eye_glow_orng"] = loadfx("maps/zombie/fx_zombie_eye_returned_orng");
	clientscripts\mp\zombies\_zm_powerups::add_zombie_powerup("zombie_blood", "powerup_zombie_blood");
	clientscripts\mp\_visionset_mgr::vsmgr_register_visionset_info("zm_powerup_zombie_blood_visionset", 14000, 15, "zm_powerup_zombie_blood", "zm_powerup_zombie_blood");
	clientscripts\mp\_visionset_mgr::vsmgr_register_overlay_info_style_filter("zm_powerup_zombie_blood_overlay", 14000, 15, 1, 0, "generic_filter_zombie_blood_b");
}

toggle_player_zombie_blood_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	clientscripts\mp\zombies\_zm::player_eyes_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump);

	if (isspectating(localclientnum, 0) || isdemoplaying())
	{
		return;
	}

	if (newval == 1)
	{
		if (self islocalplayer() && self getlocalclientnumber() == localclientnum)
		{
			if (!isdefined(self.zombie_blood_fx))
			{
				self.zombie_blood_fx = playviewmodelfx(localclientnum, level._effect["zombie_blood_1st"], "tag_camera");
				playsound(localclientnum, "zmb_zombieblood_start", (0, 0, 0));
				playloopat("zmb_zombieblood_loop", (0, 0, 0));
			}
		}
	}
	else if (isdefined(self.zombie_blood_fx))
	{
		deletefx(localclientnum, self.zombie_blood_fx);
		playsound(localclientnum, "zmb_zombieblood_stop", (0, 0, 0));
		stoploopat("zmb_zombieblood_loop", (0, 0, 0));
		self.zombie_blood_fx = undefined;
	}
}