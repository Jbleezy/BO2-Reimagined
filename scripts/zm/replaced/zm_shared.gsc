#include maps\mp\animscripts\zm_shared;
#include maps\mp\animscripts\utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\animscripts\zm_run;

dotraverse(traversestate, traversealias, no_powerups)
{
	if (level.script == "zm_nuked" && is_true(self.isdog))
	{
		self thread dog_teleport();
		return;
	}

	self endon("killanimscript");
	self traversemode("nogravity");
	self traversemode("noclip");
	old_powerups = 0;

	if (isdefined(no_powerups) && no_powerups)
	{
		old_powerups = self.no_powerups;
		self.no_powerups = 1;
	}

	self.is_traversing = 1;
	self notify("zombie_start_traverse");
	self.traversestartnode = self getnegotiationstartnode();
	assert(isdefined(self.traversestartnode));
	self orientmode("face angle", self.traversestartnode.angles[1]);
	self.traversestartz = self.origin[2];

	if (isdefined(self.pre_traverse))
	{
		self [[self.pre_traverse]]();
	}

	self setanimstatefromasd(traversestate, traversealias);
	self maps\mp\animscripts\zm_shared::donotetracks("traverse_anim");
	self traversemode("gravity");
	self.a.nodeath = 0;

	if (isdefined(self.post_traverse))
	{
		self [[self.post_traverse]]();
	}

	self maps\mp\animscripts\zm_run::needsupdate();

	if (!self.isdog)
	{
		self maps\mp\animscripts\zm_run::moverun();
	}

	self.is_traversing = 0;
	self notify("zombie_end_traverse");

	if (isdefined(no_powerups) && no_powerups && is_true(self.no_powerups))
	{
		self.no_powerups = old_powerups;
	}
}

dog_teleport()
{
	self endon("death");

	if (is_true(self.teleporting))
	{
		return;
	}

	self.teleporting = 1;
	self.ignoreall = 1;
	self.actor_damage_func = ::dog_teleport_no_damage;
	self thread dog_teleport_delete_ents_on_death();
	self setaimanimweights(0, 0);
	self setanimstatefromasd("zm_stop_idle");
	end_node = self getnegotiationendnode();

	if (isdefined(self.fx_dog_eye))
	{
		self.fx_dog_eye delete();
	}

	if (isdefined(self.fx_dog_trail))
	{
		self.fx_dog_trail delete();
	}

	self.fx_dog_eye = spawn("script_model", self gettagorigin("J_EyeBall_LE"));
	self.fx_dog_eye.angles = self gettagangles("J_EyeBall_LE");
	self.fx_dog_eye setmodel("tag_origin");
	self.fx_dog_eye linkto(self, "J_EyeBall_LE");

	self.fx_dog_trail = spawn("script_model", self gettagorigin("tag_origin"));
	self.fx_dog_trail.angles = self gettagangles("tag_origin");
	self.fx_dog_trail setmodel("tag_origin");
	self.fx_dog_trail linkto(self, "tag_origin");

	self stoploopsound();

	self ghost();
	self forceteleport(self.origin, end_node.angles);

	self.phase_fx = spawn("script_model", self getcentroid());
	self.phase_fx.angles = self.angles;
	self.phase_fx setmodel("tag_origin");
	self.phase_fx linkto(self);

	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	playfxontag(level._effect["dog_phase_trail"], self.phase_fx, "tag_origin");
	playfx(level._effect["dog_phasing"], self.origin);
	self playsound("zmb_hellhound_warp_out");
	self.anchor moveto(end_node.origin, 0.5);

	self.anchor waittill("movedone");

	if (isdefined(self.phase_fx))
	{
		self.phase_fx delete();
	}

	if (isdefined(self.anchor))
	{
		self.anchor delete();
	}

	self forceteleport(end_node.origin, end_node.angles);
	playfx(level._effect["dog_phasing"], self.origin);
	self playsound("zmb_hellhound_warp_in");
	self show();

	maps\mp\zombies\_zm_net::network_safe_play_fx_on_tag("dog_fx", 2, level._effect["dog_eye_glow"], self.fx_dog_eye, "tag_origin");
	maps\mp\zombies\_zm_net::network_safe_play_fx_on_tag("dog_fx", 2, self.fx_dog_trail_type, self.fx_dog_trail, "tag_origin");
	self playloopsound(self.fx_dog_trail_sound);

	self setaimanimweights(0, 0);

	if (self.a.movement == "run")
	{
		self setanimstatefromasd("zm_move_run");
	}
	else
	{
		self setanimstatefromasd("zm_move_walk");
	}

	self notify("dog_teleport_done");

	self.actor_damage_func = undefined;
	self.ignoreall = 0;
	self.teleporting = undefined;
}

dog_teleport_delete_ents_on_death()
{
	self endon("dog_teleport_done");

	self waittill("death");

	if (isdefined(self.phase_fx))
	{
		self.phase_fx delete();
	}

	if (isdefined(self.anchor))
	{
		self.anchor delete();
	}
}

dog_teleport_no_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	return 0;
}