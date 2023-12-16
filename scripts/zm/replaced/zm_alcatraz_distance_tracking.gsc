#include maps\mp\zm_alcatraz_distance_tracking;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_spawner;

delete_zombie_noone_looking( how_close, how_high )
{
	self endon( "death" );

	if ( !isdefined( how_close ) )
		how_close = 1500;

	if ( !isdefined( how_high ) )
		how_close = 600;

	distance_squared_check = how_close * how_close;
	too_far_dist = distance_squared_check * 3;

	if ( isdefined( level.zombie_tracking_too_far_dist ) )
		too_far_dist = level.zombie_tracking_too_far_dist * level.zombie_tracking_too_far_dist;

	self.inview = 0;
	self.player_close = 0;
	players = get_players();

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i].sessionstate == "spectator" )
			continue;

		if ( isdefined( level.only_track_targeted_players ) )
		{
			if ( !isdefined( self.favoriteenemy ) || self.favoriteenemy != players[i] )
				continue;
		}

		can_be_seen = self player_can_see_me( players[i] );

		if ( can_be_seen && distancesquared( self.origin, players[i].origin ) < too_far_dist )
			self.inview++;

		if ( distancesquared( self.origin, players[i].origin ) < distance_squared_check && abs( self.origin[2] - players[i].origin[2] ) < how_high )
			self.player_close++;
	}

	wait 0.1;

	if ( self.inview == 0 && self.player_close == 0 )
	{
		if ( !isdefined( self.animname ) || isdefined( self.animname ) && self.animname != "zombie" )
			return;

		if ( isdefined( self.electrified ) && self.electrified == 1 )
			return;

		if ( isdefined( self.in_the_ground ) && self.in_the_ground == 1 )
			return;

		if ( !( isdefined( self.exclude_distance_cleanup_adding_to_total ) && self.exclude_distance_cleanup_adding_to_total ) && !( isdefined( self.isscreecher ) && self.isscreecher ) )
		{
			level.zombie_total++;

			if ( self.health < level.zombie_health )
				level.zombie_respawned_health[level.zombie_respawned_health.size] = self.health;
		}

		self maps\mp\zombies\_zm_spawner::reset_attack_spot();
		self notify( "zombie_delete" );
		self delete();
		recalc_zombie_array();
	}
}