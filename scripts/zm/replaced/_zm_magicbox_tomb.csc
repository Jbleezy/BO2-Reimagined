#include clientscripts\mp\zombies\_zm_magicbox_tomb;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

magicbox_ambient_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if (!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localclientnum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel("tag_origin");
	}

	if (isdefined(self.fx_obj.curr_amb_fx))
	{
		stopfx(localclientnum, self.fx_obj.curr_amb_fx);
	}

	if (isdefined(self.fx_obj.curr_amb_fx_power))
	{
		stopfx(localclientnum, self.fx_obj.curr_amb_fx_power);
	}

	if (newval == 0)
	{
		self.fx_obj playloopsound("zmb_hellbox_amb_low");
		playsound(0, "zmb_hellbox_leave", self.fx_obj.origin);
		stopfx(localclientnum, self.fx_obj.curr_amb_fx);
	}
	else if (newval == 1)
	{
		self.fx_obj.curr_amb_fx = playfxontag(localclientnum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin");
		self.fx_obj playloopsound("zmb_hellbox_amb_low");
		playsound(0, "zmb_hellbox_arrive", self.fx_obj.origin);
	}
	else if (newval == 2)
	{
		self.fx_obj.curr_amb_fx_power = playfxontag(localclientnum, level._effect["box_powered"], self.fx_obj, "tag_origin");
		self.fx_obj.curr_amb_fx = playfxontag(localclientnum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin");
		self.fx_obj playloopsound("zmb_hellbox_amb_high");
		playsound(0, "zmb_hellbox_arrive", self.fx_obj.origin);
	}
	else if (newval == 3)
	{
		self.fx_obj.curr_amb_fx_power = playfxontag(localclientnum, level._effect["box_unpowered"], self.fx_obj, "tag_origin");
		self.fx_obj.curr_amb_fx = playfxontag(localclientnum, level._effect["box_gone_ambient"], self.fx_obj, "tag_origin");
		self.fx_obj playloopsound("zmb_hellbox_amb_high");
		playsound(0, "zmb_hellbox_leave", self.fx_obj.origin);
	}
}

fx_magicbox_portal(localclientnum)
{
	self endon("magicbox_portal_finished");

	serverwait(localclientnum, 0.5);

	while (true)
	{
		self.fx_obj_2.curr_portal_fx = playfxontag(localclientnum, level._effect["box_portal"], self.fx_obj_2, "tag_origin");
		serverwait(localclientnum, 0.1);
	}
}