#include maps\mp\gametypes_zm\_hud;

fadetoblackforxsec(startwait, blackscreenwait, fadeintime, fadeouttime, shadername, n_sort)
{
	if (!isdefined(n_sort))
		n_sort = 50;

	wait(startwait);

	if (!isdefined(self))
		return;

	if (!isdefined(self.blackscreen))
		self.blackscreen = newclienthudelem(self);

	self.blackscreen.x = 0;
	self.blackscreen.y = 0;
	self.blackscreen.horzalign = "fullscreen";
	self.blackscreen.vertalign = "fullscreen";
	self.blackscreen.foreground = 1;
	self.blackscreen.hidewhendead = 0;
	self.blackscreen.hidewheninmenu = 1;
	self.blackscreen.sort = n_sort;

	if (isdefined(shadername))
		self.blackscreen setshader(shadername, 640, 480);
	else
		self.blackscreen setshader("black", 640, 480);

	self.blackscreen.alpha = 0;

	if (fadeintime > 0)
		self.blackscreen fadeovertime(fadeintime);

	self.blackscreen.alpha = 1;
	wait(fadeintime);

	if (!isdefined(self.blackscreen))
		return;

	wait(blackscreenwait);

	if (!isdefined(self.blackscreen))
		return;

	if (fadeouttime > 0)
		self.blackscreen fadeovertime(fadeouttime);

	self.blackscreen.alpha = 0;
	wait(fadeouttime);

	if (isdefined(self.blackscreen))
	{
		self.blackscreen destroy();
		self.blackscreen = undefined;
	}
}