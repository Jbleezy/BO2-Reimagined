#include maps\mp\zm_transit_ai_screecher;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_ai_screecher;
#include maps\mp\zm_transit_utility;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_gump;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zm_transit;

init()
{
	level.screecher_should_burrow = ::screecher_should_burrow;
	level.screecher_should_runaway = ::screecher_should_runaway;
	level.screecher_cleanup = ::transit_screecher_cleanup;
	level.screecher_init_done = ::screecher_init_done;
	level.portals = [];

	lights = getstructarray( "screecher_escape", "targetname" );
	lights = array_randomize( lights );

	for (i = 0; i < lights.size; i++)
	{
		dest_ind = i + 1;

		if (dest_ind >= lights.size)
		{
			dest_ind = 0;
		}

		lights[i].dest_light = lights[dest_ind];
	}
}

screecher_init_done()
{
	self endon("death");

	self.maxhealth = 150;
	self.health = self.maxhealth;

	while (true)
	{
		ground_ent = self getgroundent();

		if (isdefined(ground_ent) && ground_ent == level.the_bus)
		{
			self dodamage(self.health + 666, self.origin);
		}

		wait 0.1;
	}
}

player_wait_land()
{
	self endon("disconnect");

	while (!self isonground())
		wait 0.1;

	if (level.portals.size > 0)
	{
		remove_portal = undefined;

		foreach (portal in level.portals)
		{
			dist_sq = distance2dsquared(self.origin, portal.origin);

			if (dist_sq < 4096)
			{
				remove_portal = portal;
				break;
			}
		}

		if (isdefined(remove_portal))
		{
			portal portal_use(self);
			wait 0.5;
		}
	}
}

portal_use(player)
{
	player playsoundtoplayer("zmb_screecher_portal_warp_2d", player);
	self thread teleport_player(player);
	playsoundatposition("zmb_screecher_portal_end", self.hole.origin);
}

teleport_player( player )
{
	if ( isdefined( self.dest_light ) )
	{
		playsoundatposition( "zmb_screecher_portal_arrive", self.dest_light.origin );
		player maps\mp\zombies\_zm_gump::player_teleport_blackscreen_on();
		player setorigin( self.dest_light.origin );
		player notify( "used_screecher_hole" );
		player maps\mp\zombies\_zm_stats::increment_client_stat( "screecher_teleporters_used", 0 );
		player maps\mp\zombies\_zm_stats::increment_player_stat( "screecher_teleporters_used" );
	}
}