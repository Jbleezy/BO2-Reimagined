#include maps\mp\zombies\_zm_weap_one_inch_punch;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_weap_staff_fire;
#include maps\mp\zombies\_zm_weap_staff_water;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_weap_staff_lightning;
#include maps\mp\animscripts\zm_shared;

monitor_melee_swipe()
{
	self endon( "disconnect" );
	self notify( "stop_monitor_melee_swipe" );
	self endon( "stop_monitor_melee_swipe" );
	self endon( "bled_out" );
	self endon( "gr_head_forced_bleed_out" );

	while ( true )
	{
		while ( !self ismeleeing() )
			wait 0.05;

		if ( self getcurrentweapon() == level.riotshield_name )
		{
			wait 0.1;
			continue;
		}

		range_mod = 1;
		self setclientfield( "oneinchpunch_impact", 1 );
		wait_network_frame();
		self setclientfield( "oneinchpunch_impact", 0 );
		v_punch_effect_fwd = anglestoforward( self getplayerangles() );
		v_punch_yaw = get2dyaw( ( 0, 0, 0 ), v_punch_effect_fwd );

		if ( isdefined( self.b_punch_upgraded ) && self.b_punch_upgraded && isdefined( self.str_punch_element ) && self.str_punch_element == "air" )
			range_mod *= 2;

		a_zombies = getaispeciesarray( level.zombie_team, "all" );
		a_zombies = get_array_of_closest( self.origin, a_zombies, undefined, undefined, 100 );

		foreach ( zombie in a_zombies )
		{
			if ( self is_player_facing( zombie, v_punch_yaw ) && distancesquared( self.origin, zombie.origin ) <= 4096 * range_mod )
			{
				self thread zombie_punch_damage( zombie, 1 );
				continue;
			}

			if ( self is_player_facing( zombie, v_punch_yaw ) )
				self thread zombie_punch_damage( zombie, 0.5 );
		}

		while ( self ismeleeing() )
			wait 0.05;

		wait 0.05;
	}
}