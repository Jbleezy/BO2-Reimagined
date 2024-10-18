#include clientscripts\mp\zm_tomb_amb;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_ambientpackage;
#include clientscripts\mp\_music;
#include clientscripts\mp\_audio;

sndchargeshot(localclientnum, weaponname, chargeshotlevel)
{
	self.sndcurrentcharge = chargeshotlevel;

	if (!isdefined(self.sndchargeloopent))
	{
		self.sndchargeloopent = spawn(0, (0, 0, 0), "script_origin");
	}

	self thread sndstoploopent();

	if (!isdefined(self.sndlastcharge) || self.sndcurrentcharge != self.sndlastcharge)
	{
		alias = "wpn_firestaff_charge_";

		if (weaponname == "staff_water_upgraded_zm")
		{
			alias = "wpn_waterstaff_charge_";
		}
		else if (weaponname == "staff_lightning_upgraded_zm")
		{
			alias = "wpn_lightningstaff_charge_";
		}
		else if (weaponname == "staff_air_upgraded_zm")
		{
			alias = "wpn_airstaff_charge_";
		}

		if (self.sndcurrentcharge == 1)
		{
			self.sndchargeloopent playloopsound(alias + "loop", 1.5);
		}

		playsound(localclientnum, alias + self.sndcurrentcharge, (0, 0, 0));
		self.sndlastcharge = self.sndcurrentcharge;
	}
}

sndstoploopent()
{
	level notify("sndstoploopent");
	level endon("sndstoploopent");

	wait 0.05;

	self.sndchargeloopent stoploopsound();
	self.sndcurrentcharge = 0;
	self.sndlastcharge = undefined;
}