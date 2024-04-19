main()
{
	level._effect["dart_light"] = loadfx("weapon/titus/fx_titus_bolt_blink_os");
}

spawned(localclientnum)
{
	player = getlocalplayer(localclientnum);
	enemy = 0;
	self.fxtagname = "tag_origin";

	if (self.team != player.team)
		enemy = 1;

	self thread loop_local_sound(localclientnum, "wpn_titus_alert", 0.3, level._effect["dart_light"]);
}

loop_local_sound(localclientnum, alias, interval, fx)
{
	self endon("entityshutdown");

	while (true)
	{
		self playsound(localclientnum, alias);
		n_id = playfxontag(localclientnum, fx, self, self.fxtagname);
		wait(interval);
		stopfx(localclientnum, n_id);
		interval /= 1.2;

		if (interval < 0.1)
			interval = 0.1;
	}
}