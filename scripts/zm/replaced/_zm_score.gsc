#include maps\mp\zombies\_zm_score;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

add_to_player_score( points, add_to_total )
{
	if ( !isDefined( add_to_total ) )
	{
		add_to_total = 1;
	}
	if ( !isDefined( points ) || level.intermission )
	{
		return;
	}
	points = int(points); // points must be an int
	self.score += points;
	self.pers[ "score" ] = self.score;
	if ( add_to_total )
	{
		self.score_total += points;
	}
	self incrementplayerstat( "score", points );
}

minus_to_player_score( points )
{
	if ( !isDefined( points ) || level.intermission )
	{
		return;
	}
	points = int(points); // points must be an int
	self.score -= points;
	self.pers[ "score" ] = self.score;
}

player_add_points_kill_bonus( mod, hit_location )
{
	if ( mod == "MOD_MELEE" )
	{
		self score_cf_increment_info( "death_melee" );
		return level.zombie_vars["zombie_score_bonus_melee"];
	}

	if ( mod == "MOD_BURNED" )
	{
		self score_cf_increment_info( "death_torso" );
		return level.zombie_vars["zombie_score_bonus_burn"];
	}

	score = 0;

	if ( isdefined( hit_location ) )
	{
		switch ( hit_location )
		{
		case "helmet":
		case "head":
		case "neck":
			self score_cf_increment_info( "death_head" );
			score = level.zombie_vars["zombie_score_bonus_head"];
			break;
		default:
			self score_cf_increment_info( "death_normal" );
			break;
		}
	}

	return score;
}