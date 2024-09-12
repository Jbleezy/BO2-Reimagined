#include clientscripts\mp\zombies\_zm_ai_mechz;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

mechzfootstepcbfunc(localclientnum, pos, surface, notetrack, bone)
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
			rumble = "shotgun_fire";

			if (n_distance <= 750)
			{
				rumble = "mechz_footsteps";
			}

			if (!is_true(players[i].mechz_camshake))
			{
				players[i] earthquake(0.25, 0.1, self.origin, 1500);
				players[i] thread prevent_camshake_stacking();
			}

			playerlocalclientnum = players[i] getlocalclientnumber();

			if (isdefined(playerlocalclientnum))
			{
				playrumbleonposition(playerlocalclientnum, rumble, self.origin);
			}
		}
	}

	if (bone == "j_ball_ri")
	{
		playfxontag(localclientnum, level._effect["mech_footstep_steam"], self, "tag_foot_steam_RI");
	}
	else if (bone == "j_ball_le")
	{
		playfxontag(localclientnum, level._effect["mech_footstep_steam"], self, "tag_foot_steam_LE");
	}

	footstepdoeverything();
}