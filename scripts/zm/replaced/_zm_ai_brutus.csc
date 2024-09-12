#include clientscripts\mp\zombies\_zm_ai_brutus;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

brutusfootstepcbfunc(localclientnum, pos, surface, notetrack, bone)
{
	players = getlocalplayers();

	for (i = 0; i < players.size; i++)
	{
		if (!players[i] isplayer())
		{
			continue;
		}

		n_distance = distance2d(self.origin, players[i].origin);

		if (abs(self.origin[2] - players[i].origin[2]) < 100 && n_distance < 1500)
		{
			if (!is_true(players[i].brutus_camshake))
			{
				players[i] earthquake(0.375, 0.1, self.origin, 1500);
				players[i] thread prevent_camshake_stacking();
			}

			playerlocalclientnum = players[i] getlocalclientnumber();

			if (isdefined(playerlocalclientnum))
			{
				playrumbleonposition(playerlocalclientnum, "brutus_footsteps", self.origin);
			}
		}
	}

	footstepdoeverything();
}

prevent_camshake_stacking()
{
	self.brutus_camshake = 1;
	wait 0.1;
	self.brutus_camshake = 0;
}