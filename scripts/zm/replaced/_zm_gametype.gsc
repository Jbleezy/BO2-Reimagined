#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

onspawnplayer( predictedspawn )
{
	if ( !isDefined( predictedspawn ) )
	{
		predictedspawn = 0;
	}
	pixbeginevent( "ZSURVIVAL:onSpawnPlayer" );
	self.usingobj = undefined;
	self.is_zombie = 0;
	if ( isDefined( level.custom_spawnplayer ) && is_true( self.player_initialized ) )
	{
		self [[ level.custom_spawnplayer ]]();
		return;
	}
	if ( isDefined( level.customspawnlogic ) )
	{
		self [[ level.customspawnlogic ]]( predictedspawn );
		if ( predictedspawn )
		{
			return;
		}
	}
	else
	{
		self scripts/zm/main/_zm_reimagined_zgrief::set_team();

		if ( flag( "start_zombie_round_logic" ) )
		{
			spawnpoint = maps/mp/zombies/_zm::check_for_valid_spawn_near_team( self, 1 );
		}
		if ( !isDefined( spawnpoint ) )
		{
			match_string = "";
			location = level.scr_zm_map_start_location;
			if ( ( location == "default" || location == "" ) && isDefined( level.default_start_location ) )
			{
				location = level.default_start_location;
			}
			match_string = level.scr_zm_ui_gametype + "_" + location;
			spawnpoints = [];
			structs = getstructarray( "initial_spawn", "script_noteworthy" );
			if ( isdefined( structs ) )
			{
				for ( i = 0; i < structs.size; i++ )
				{
					if ( isdefined( structs[ i ].script_string ) )
					{
						tokens = strtok( structs[ i ].script_string, " " );
						foreach ( token in tokens )
						{
							if ( token == match_string )
							{
								spawnpoints[ spawnpoints.size ] = structs[ i ];
							}
						}
					}
				}
			}
			if ( !isDefined( spawnpoints ) || spawnpoints.size == 0 )
			{
				spawnpoints = getstructarray( "initial_spawn_points", "targetname" );
			}
			spawnpoint = maps/mp/zombies/_zm::getfreespawnpoint( spawnpoints, self );

		}
		if ( predictedspawn )
		{
			self predictspawnpoint( spawnpoint.origin, spawnpoint.angles );
			return;
		}
		else
		{
			self spawn( spawnpoint.origin, spawnpoint.angles, "zsurvival" );
		}
	}
	self.entity_num = self getentitynumber();
	self thread maps/mp/zombies/_zm::onplayerspawned();
	self thread maps/mp/zombies/_zm::player_revive_monitor();
	self freezecontrols( 1 );
	self.spectator_respawn = spawnpoint;
	self.score = self maps/mp/gametypes_zm/_globallogic_score::getpersstat( "score" );
	self.pers[ "participation" ] = 0;

	self.score_total = self.score;
	self.old_score = self.score;
	self.player_initialized = 0;
	self.zombification_time = 0;
	self.enabletext = 1;
	self thread maps/mp/zombies/_zm_blockers::rebuild_barrier_reward_reset();
	if ( !is_true( level.host_ended_game ) )
	{
		self freeze_player_controls( 0 );
		self enableweapons();
	}
	if ( isDefined( level.game_mode_spawn_player_logic ) )
	{
		spawn_in_spectate = [[ level.game_mode_spawn_player_logic ]]();
		if ( spawn_in_spectate )
		{
			self delay_thread( 0.05, maps/mp/zombies/_zm::spawnspectator );
		}
	}
	pixendevent();
}