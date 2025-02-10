#include clientscripts\mp\_sticky_grenade;
#include clientscripts\mp\_utility;

start_light_fx(localclientnum)
{
	friend = self friendnotfoe(localclientnum);
	player = getlocalplayer(localclientnum);

	self.fx = playfxontag(localclientnum, level._effect["grenade_friendly_light"], self, "tag_fx");
}