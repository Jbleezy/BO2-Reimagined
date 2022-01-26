#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

track_players_intersection_tracker()
{
	// BO2 has built in push mechanic
}

is_headshot( sweapon, shitloc, smeansofdeath )
{
	if ( smeansofdeath == "MOD_MELEE" || smeansofdeath == "MOD_BAYONET" || smeansofdeath == "MOD_IMPACT" || smeansofdeath == "MOD_UNKNOWN" || smeansofdeath == "MOD_IMPACT" )
	{
		return 0;
	}

	if ( shitloc == "head" || shitloc == "helmet" || sHitLoc == "neck" )
	{
		return 1;
	}

	return 0;
}

create_zombie_point_of_interest_attractor_positions( num_attract_dists, diff_per_dist, attractor_width )
{
	self endon( "death" );
	forward = ( 0, 1, 0 );
	if ( !isDefined( self.num_poi_attracts ) || isDefined( self.script_noteworthy ) && self.script_noteworthy != "zombie_poi" )
	{
		return;
	}
	if ( !isDefined( num_attract_dists ) )
	{
		num_attract_dists = 4;
	}
	if ( !isDefined( diff_per_dist ) )
	{
		diff_per_dist = 45;
	}
	if ( !isDefined( attractor_width ) )
	{
		attractor_width = 45;
	}
	self.attract_to_origin = 0;
	self.num_attract_dists = num_attract_dists;
	self.last_index = [];
	for ( i = 0; i < num_attract_dists; i++ )
	{
		self.last_index[ i ] = -1;
	}
	self.attract_dists = [];
	for ( i = 0; i < self.num_attract_dists; i++ )
	{
		self.attract_dists[ i ] = diff_per_dist * ( i + 1 );
	}
	max_positions = [];
	for ( i = 0; i < self.num_attract_dists; i++ )
	{
		max_positions[ i ] = int( ( 6.28 * self.attract_dists[ i ] ) / attractor_width );
	}
	num_attracts_per_dist = self.num_poi_attracts / self.num_attract_dists;
	self.max_attractor_dist = self.attract_dists[ self.attract_dists.size - 1 ] * 1.1;
	diff = 0;
	actual_num_positions = [];
	i = 0;
	while ( i < self.num_attract_dists )
	{
		if ( num_attracts_per_dist > ( max_positions[ i ] + diff ) )
		{
			actual_num_positions[ i ] = max_positions[ i ];
			diff += num_attracts_per_dist - max_positions[ i ];
			i++;
			continue;
		}
		actual_num_positions[ i ] = num_attracts_per_dist + diff;
		diff = 0;
		i++;
	}
	self.attractor_positions = [];
	failed = 0;
	angle_offset = 0;
	prev_last_index = -1;
	for ( j = 0; j < 4; j++)
	{
		if ( ( actual_num_positions[ j ] + failed ) < max_positions[ j ] )
		{
			actual_num_positions[ j ] += failed;
			failed = 0;
		}
		else if ( actual_num_positions[ j ] < max_positions[ j ] )
		{
			actual_num_positions[ j ] = max_positions[ j ];
			failed = max_positions[ j ] - actual_num_positions[ j ];
		}
		failed += self generated_radius_attract_positions( forward, angle_offset, actual_num_positions[ j ], self.attract_dists[ j ] );
		angle_offset += 15;
		self.last_index[ j ] = int( ( actual_num_positions[ j ] - failed ) + prev_last_index );
		prev_last_index = self.last_index[ j ];

		self notify( "attractor_positions_generated" );
		level notify( "attractor_positions_generated" );
	}
}