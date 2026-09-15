#include clientscripts\mp\zombies\_zm_perk_random;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

start_vortex_fx(localclientnum)
{
	self endon("activation_electricity_finished");
	self endon("entityshutdown");

	if (!isdefined(self.glow_location))
	{
		self.glow_location = spawn(localclientnum, self.origin, "script_model");
		self.glow_location.angles = self.angles;
		self.glow_location setmodel("tag_origin");
	}

	self thread fx_activation_electric_loop(localclientnum);
	self thread fx_artifact_pulse_thread(localclientnum);
	playsound(localclientnum, "zmb_rand_perk_vortex_sparks", self.origin);
	serverwait(localclientnum, 0.5);
	self thread fx_bottle_cycling(localclientnum);
	soundloopemitter("zmb_rand_perk_vortex", self.origin);
}

stop_vortex_fx(localclientnum)
{
	self endon("entityshutdown");

	self notify("bottle_cycling_finished");
	playsound(localclientnum, "zmb_rand_perk_vortex_sparks", self.origin);
	serverwait(localclientnum, 0.5);
	soundstoploopemitter("zmb_rand_perk_vortex", self.origin);

	if (!isdefined(self))
	{
		return;
	}

	self notify("activation_electricity_finished");

	if (isdefined(self.glow_location))
	{
		self.glow_location delete();
	}

	self.artifact_glow_setting = 1;
	self.machinery_glow_setting = 0.7;
	self setshaderconstant(localclientnum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
}

fx_artifact_pulse_thread(localclientnum)
{
	self endon("activation_electricity_finished");
	self endon("entityshutdown");

	while (isdefined(self))
	{
		shader_amount = sin(getrealtime() * 0.2);

		if (shader_amount < 0)
		{
			shader_amount = shader_amount * -1;
		}

		shader_amount = 0.75 - shader_amount * 0.75;
		self.artifact_glow_setting = shader_amount;
		self.machinery_glow_setting = 1.0;
		self setshaderconstant(localclientnum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
		serverwait(localclientnum, 0.05);
	}
}

fx_activation_electric_loop(localclientnum)
{
	self endon("activation_electricity_finished");
	self endon("entityshutdown");

	while (true)
	{
		if (isdefined(self.glow_location))
		{
			playfxontag(localclientnum, level._effect["perk_machine_activation_electric_loop"], self.glow_location, "tag_origin");
		}

		serverwait(localclientnum, 0.1);
	}
}

fx_bottle_cycling(localclientnum)
{
	self endon("bottle_cycling_finished");

	while (true)
	{
		if (isdefined(self.glow_location))
		{
			playfxontag(localclientnum, level._effect["bottle_glow"], self.glow_location, "tag_origin");
		}

		serverwait(localclientnum, 0.1);
	}
}

fx_departure_steam(localclientnum)
{
	self endon("departure_steam_finished");

	n_end_time = getrealtime() + 5000;

	while (isdefined(self) && n_end_time > getrealtime())
	{
		self._departure_steam = playfxontag(localclientnum, level._effect["perk_machine_steam"], self, "tag_origin");
		serverwait(localclientnum, 0.1);
	}
}

fx_location_indicator(localclientnum)
{
	self endon("ball_departed");
	self endon("entityshutdown");
	level endon("demo_jump");

	while (isdefined(self))
	{
		if (isdefined(self))
		{
			self._location_indicator = playfx(localclientnum, level._effect["perk_machine_location"], self.origin);
		}

		serverwait(localclientnum, 1.5);
	}
}