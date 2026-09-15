#include clientscripts\mp\zm_tomb_ee;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_filter;
#include clientscripts\mp\_audio;
#include clientscripts\mp\zm_tomb_ee_lights;

wagon_fire_fx_loop(localclientnum, fieldname)
{
	level notify("stop_" + fieldname);
	self endon("stop_" + fieldname);

	s_pos = getstruct(fieldname, "targetname");

	while (true)
	{
		playfx(localclientnum, level._effect["wagon_fire"], s_pos.origin, anglestoforward(s_pos.angles), anglestoup(s_pos.angles));
		serverwait(localclientnum, 0.5);
	}
}

tablet_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	a_structs = getstructarray("tablet_charge_pos", "targetname");
	s_box = get_array_of_closest(self.origin, a_structs)[0];
	e_fx = spawn(localclientnum, self gettagorigin("J_SpineUpper"), "script_model");
	e_fx setmodel("tag_origin");
	e_fx playsound(localclientnum, "zmb_squest_charge_soul_leave");
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(s_box.origin, 1);
	e_fx waittill("movedone");
	playsound(localclientnum, "zmb_squest_charge_soul_impact", e_fx.origin);
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	serverwait(localclientnum, 0.3);
	e_fx delete();
}

create_beacon_portal(localclientnum)
{
	self endon("disconnect");
	self endon("stop_beacon_portal");

	while (true)
	{
		playfx(localclientnum, level._effect["bottle_glow"], (-141, 4464, -322) + (60, 10, 25));
		serverwait(localclientnum, 0.1);
	}
}

zombie_soul_portal_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	v_dest = getent(localclientnum, "ee_sam_portal", "targetname").origin;
	e_fx = spawn(localclientnum, self gettagorigin("J_SpineUpper"), "script_model");
	e_fx setmodel("tag_origin");
	playsound(localclientnum, "zmb_squest_charge_soul_leave", self.origin);
	playfxontag(localclientnum, level._effect["staff_soul"], e_fx, "tag_origin");
	e_fx moveto(v_dest, 1);
	e_fx waittill("movedone");
	playsound(localclientnum, "zmb_squest_charge_soul_impact", v_dest);
	playfxontag(localclientnum, level._effect["staff_charge"], e_fx, "tag_origin");
	serverwait(localclientnum, 0.3);
	e_fx delete();
}

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