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