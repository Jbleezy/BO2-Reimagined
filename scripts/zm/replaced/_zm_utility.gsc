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