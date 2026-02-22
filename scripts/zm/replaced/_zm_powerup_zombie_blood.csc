#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_audio;
#include clientscripts\mp\_filter;
#include clientscripts\mp\zombies\_zm_powerups;
#include clientscripts\mp\_visionset_mgr;

toggle_player_zombie_blood_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
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