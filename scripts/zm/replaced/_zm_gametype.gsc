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

onplayerspawned()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	for ( ;; )
	{
		self waittill_either( "spawned_player", "fake_spawned_player" );
		if ( isDefined( level.match_is_ending ) && level.match_is_ending )
		{
			return;
		}
		if ( self maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
		{
			self thread maps/mp/zombies/_zm_laststand::auto_revive( self );
		}
		if ( isDefined( level.custom_player_fake_death_cleanup ) )
		{
			self [[ level.custom_player_fake_death_cleanup ]]();
		}
		self setstance( "stand" );
		self.zmbdialogqueue = [];
		self.zmbdialogactive = 0;
		self.zmbdialoggroups = [];
		self.zmbdialoggroup = "";
		if ( is_encounter() )
		{
			if ( self.team == "axis" )
			{
				self.characterindex = 0;
				self._encounters_team = "A";
				self._team_name = &"ZOMBIE_RACE_TEAM_1";
			}
			else
			{
				self.characterindex = 1;
				self._encounters_team = "B";
				self._team_name = &"ZOMBIE_RACE_TEAM_2";
			}
		}
		self takeallweapons();
		if ( isDefined( level.givecustomcharacters ) )
		{
			self [[ level.givecustomcharacters ]]();
		}
		self giveweapon( "knife_zm" );
		if ( isDefined( level.onplayerspawned_restore_previous_weapons ) )
		{
			weapons_restored = self [[ level.onplayerspawned_restore_previous_weapons ]]();
		}
		if ( isDefined( weapons_restored ) && !weapons_restored || !isDefined( weapons_restored ) )
		{
			self give_start_weapon( 1 );
		}
		weapons_restored = 0;
		if ( isDefined( level._team_loadout ) )
		{
			self giveweapon( level._team_loadout );
			self switchtoweapon( level._team_loadout );
		}
		if ( isDefined( level.gamemode_post_spawn_logic ) )
		{
			self [[ level.gamemode_post_spawn_logic ]]();
		}
	}
}

hide_gump_loading_for_hotjoiners()
{
	if(isDefined(level.scr_zm_ui_gametype_obj) && level.scr_zm_ui_gametype_obj != "zgrief")
	{
		return;
	}

	self endon( "disconnect" );
	self.rebuild_barrier_reward = 1;
	self.is_hotjoining = 1;
	num = self getsnapshotackindex();
	while ( num == self getsnapshotackindex() )
	{
		wait 0.25;
	}
	wait 0.5;
	self maps/mp/zombies/_zm::spawnspectator();
	self.is_hotjoining = 0;
	self.is_hotjoin = 1;
	if ( is_true( level.intermission ) || is_true( level.host_ended_game ) )
	{
		setclientsysstate( "levelNotify", "zi", self );
		self setclientthirdperson( 0 );
		self resetfov();
		self.health = 100;
		self thread [[ level.custom_intermission ]]();
	}
}