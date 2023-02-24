#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_highrise_classic;

insta_kill_player( perks_can_respawn_player, kill_if_falling )
{
	self endon( "disconnect" );
	if ( isDefined( perks_can_respawn_player ) && perks_can_respawn_player == 0 )
	{
		if ( self hasperk( "specialty_quickrevive" ) )
		{
			self unsetperk( "specialty_quickrevive" );
		}
		if ( self hasperk( "specialty_finalstand" ) )
		{
			self unsetperk( "specialty_finalstand" );
		}
	}
	self maps\mp\zombies\_zm_buildables::player_return_piece_to_original_spawn();
	if ( isDefined( self.insta_killed ) && self.insta_killed )
	{
		return;
	}
	if ( isDefined( self.ignore_insta_kill ) )
	{
		self.disable_chugabud_corpse = 1;
		return;
	}
	if ( self hasperk( "specialty_finalstand" ) )
	{
		self.ignore_insta_kill = 1;
		self.disable_chugabud_corpse = 1;
		self dodamage( self.health + 1000, ( 0, 0, 1 ) );
		return;
	}
	if ( !isDefined( kill_if_falling ) || kill_if_falling == 0 )
	{
		if ( !self isonground() )
		{
			return;
		}
	}
	if ( is_player_killable( self ) )
	{
		self.insta_killed = 1;
		in_last_stand = 0;
		self notify( "chugabud_effects_cleanup" );
		if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			in_last_stand = 1;
		}
		self thread blood_splat();
		if ( getnumconnectedplayers() == 1 )
		{
			if ( isDefined( self.solo_lives_given ) && self.solo_lives_given < 3 )
			{
				self.waiting_to_revive = 1;
				points = getstruct( "zone_green_start", "script_noteworthy" );
				spawn_points = getstructarray( points.target, "targetname" );
				point = spawn_points[ 0 ];
				if ( in_last_stand == 0 )
				{
					self dodamage( self.health + 1000, ( 0, 0, 1 ) );
				}
				wait 0.5;
				self freezecontrols( 1 );
				wait 0.25;
				self setorigin( point.origin + vectorScale( ( 0, 0, 1 ), 20 ) );
				self.angles = point.angles;
				if ( in_last_stand )
				{
					flag_set( "instant_revive" );
					self.stopflashingbadlytime = getTime() + 1000;
					wait_network_frame();
					flag_clear( "instant_revive" );
				}
				else
				{
					self thread maps\mp\zombies\_zm_laststand::auto_revive( self );
					self.waiting_to_revive = 0;
					self.solo_respawn = 0;
					self.lives--;
				}
				self freezecontrols( 0 );
				self.insta_killed = 0;
			}
			else
			{
				self dodamage( self.health + 1000, ( 0, 0, 1 ) );
			}
		}
		else
		{
			self dodamage( self.health + 1000, ( 0, 0, 1 ) );
			wait_network_frame();
			self.bleedout_time = 0;
		}
		self.insta_killed = 0;
	}
}