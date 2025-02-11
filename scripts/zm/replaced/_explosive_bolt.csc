#include clientscripts\mp\_explosive_bolt;
#include clientscripts\mp\_utility;

fx_think(localclientnum)
{
	self notify("light_disable");
	self endon("entityshutdown");
	self endon("light_disable");
	self waittill_dobj(localclientnum);
	interval = 0.2;

	for (;;)
	{
		self stop_light_fx(localclientnum);
		self start_light_fx(localclientnum);
		self fullscreen_fx(localclientnum);
		self playsound(localclientnum, "wpn_crossbow_alert");
		serverwait(localclientnum, interval, 0.01, "player_switch");
		interval = clamp(interval / 1.2, 0.08, 0.2);
	}
}

start_light_fx(localclientnum)
{
	friend = self friendnotfoe(localclientnum);
	player = getlocalplayer(localclientnum);

	if (issubstr(self.weapon, "upgraded"))
	{
		self.fx = playfxontag(localclientnum, level._effect["crossbow_enemy_light"], self, "tag_origin");
	}
	else
	{
		self.fx = playfxontag(localclientnum, level._effect["crossbow_friendly_light"], self, "tag_origin");
	}
}