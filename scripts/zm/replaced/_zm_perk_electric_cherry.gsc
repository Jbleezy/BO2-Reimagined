#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_score;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_ai_basic;

electric_cherry_laststand()
{
	visionsetlaststand( "zombie_last_stand", 1 );

	if ( isdefined( self ) )
	{
		playfx( level._effect["electric_cherry_explode"], self.origin );
		self playsound( "zmb_cherry_explode" );
		self notify( "electric_cherry_start" );
		wait 0.05;
		a_zombies = get_round_enemy_array();
		a_zombies = get_array_of_closest( self.origin, a_zombies, undefined, undefined, 500 );

		for ( i = 0; i < a_zombies.size; i++ )
		{
			if ( isalive( self ) )
			{
				a_zombies[i] thread electric_cherry_death_fx();

				if ( isdefined( self.cherry_kills ) )
					self.cherry_kills++;

				self maps\mp\zombies\_zm_score::add_to_player_score( 40 );

				wait 0.1;
				a_zombies[i] dodamage( a_zombies[i].health + 1000, self.origin, self, self, "none" );
			}
		}

		self notify( "electric_cherry_end" );
	}
}