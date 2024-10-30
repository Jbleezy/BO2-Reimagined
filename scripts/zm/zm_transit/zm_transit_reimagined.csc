#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_transit::start_zombie_stuff, scripts\zm\replaced\zm_transit::start_zombie_stuff);
	replaceFunc(clientscripts\mp\zm_transit_classic::sidequest_complete_pyramid_watch, scripts\zm\replaced\zm_transit_classic::sidequest_complete_pyramid_watch);
}

init()
{
	level.sndchargeshot_func = ::sndchargeshot;
}

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
		alias = "wpn_metalstormsnp_charge_";

		if (self.sndcurrentcharge == 1)
		{
			self.sndchargeloopent playloopsound(alias + "loop", 1.5);
		}

		playsound(localclientnum, alias + "plr_" + self.sndcurrentcharge, (0, 0, 0));
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