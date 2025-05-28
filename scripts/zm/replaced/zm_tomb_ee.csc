#include clientscripts\mp\zm_tomb_ee;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_filter;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zm_tomb_ee_lights;

set_ee_portal_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	e_fx = getent(localclientnum, "ee_sam_portal", "targetname");

	if (isdefined(e_fx.fx_id))
	{
		e_fx stoploopsound(5);
		stopfx(localclientnum, e_fx.fx_id);
	}

	if (newval == 1)
	{
		e_fx.fx_id = playfxontag(localclientnum, level._effect["foot_box_glow"], e_fx, "tag_origin");
		e_fx playloopsound("zmb_squest_sam_portal_closed_loop", 1);
	}
	else if (newval == 2)
	{
		e_fx.fx_id = playfxontag(localclientnum, level._effect["ee_vortex"], e_fx, "tag_origin");
		playsound(0, "zmb_squest_sam_portal_open", e_fx.origin);
		e_fx playloopsound("zmb_squest_sam_portal_open_loop", 1);
	}
	else if (newval == 3)
	{
		e_fx.fx_id = playfxontag(localclientnum, level._effect["ee_vortex"], e_fx, "tag_origin");

		e_sound = spawn(localclientnum, e_fx.origin + vectorscale((0, 0, 1), 500.0), "script_origin");
		e_sound playloopsound("zmb_squest_sam_portal_open_loop", 1);
	}
}