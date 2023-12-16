#include maps\mp\zm_highrise_distance_tracking;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_ai_basic;

zombie_tracking_init()
{
	level.zombie_respawned_health = [];

	if ( !isdefined( level.zombie_tracking_dist ) )
		level.zombie_tracking_dist = 1000;

	if ( !isdefined( level.zombie_tracking_high ) )
		level.zombie_tracking_high = 500;

	if ( !isdefined( level.zombie_tracking_wait ) )
		level.zombie_tracking_wait = 10;

	building_trigs = getentarray( "zombie_fell_off", "targetname" );

	if ( isdefined( building_trigs ) )
		array_thread( building_trigs, ::zombies_off_building );

	level.distance_tracker_aggressive_distance = 500;
	level.distance_tracker_aggressive_height = 200;

	while ( true )
	{
		zombies = get_round_enemy_array();

		if ( !isdefined( zombies ) || isdefined( level.ignore_distance_tracking ) && level.ignore_distance_tracking )
		{
			wait( level.zombie_tracking_wait );
			continue;
		}
		else
		{
			for ( i = 0; i < zombies.size; i++ )
			{
				if ( isdefined( zombies[i] ) && !( isdefined( zombies[i].ignore_distance_tracking ) && zombies[i].ignore_distance_tracking ) )
					zombies[i] thread delete_zombie_noone_looking( level.zombie_tracking_dist, level.zombie_tracking_high );
			}
		}

		wait( level.zombie_tracking_wait );
	}
}

zombies_off_building()
{
	while ( true )
	{
		self waittill( "trigger", who );

		if ( !isplayer( who ) && !( isdefined( who.is_leaper ) && who.is_leaper ) )
		{
			if ( !( isdefined( who.exclude_distance_cleanup_adding_to_total ) && who.exclude_distance_cleanup_adding_to_total ) && !( isdefined( who.is_leaper ) && who.is_leaper ) )
			{
				level.zombie_total++;

				if ( who.health < level.zombie_health )
					level.zombie_respawned_health[level.zombie_respawned_health.size] = who.health;
			}

			who maps\mp\zombies\_zm_spawner::reset_attack_spot();
			who notify( "zombie_delete" );
			who dodamage( who.health + 666, who.origin, who );
			recalc_zombie_array();
		}

		wait 0.1;
	}
}

delete_zombie_noone_looking( how_close, how_high )
{
	self endon( "death" );

	if ( !isdefined( how_close ) )
		how_close = 1000;

	if ( !isdefined( how_high ) )
		how_high = 500;

	distance_squared_check = how_close * how_close;
	height_squared_check = how_high * how_high;
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