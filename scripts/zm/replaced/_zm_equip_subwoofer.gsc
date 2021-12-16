#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

startsubwooferdeploy( weapon, armed )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_subwoofer_zm_taken" );
	self thread maps/mp/zombies/_zm_equip_subwoofer::watchforcleanup();
	if ( isDefined( self.subwoofer_kills ) )
	{
		weapon.subwoofer_kills = self.subwoofer_kills;
		self.subwoofer_kills = undefined;
	}
	if ( !isDefined( weapon.subwoofer_kills ) )
	{
		weapon.subwoofer_kills = 0;
	}
	if ( !isDefined( self.subwoofer_health ) )
	{
		self.subwoofer_health = 60;
		self.subwoofer_power_level = 4;
	}
	if ( isDefined( weapon ) )
	{
		weapon subwoofer_power_on();
		if ( weapon.power_on )
		{
			self thread maps/mp/zombies/_zm_equip_subwoofer::subwooferthink( weapon, armed );
		}
		else
		{
			self iprintlnbold( &"ZOMBIE_NEED_LOCAL_POWER" );
		}
		self thread startsubwooferdecay( weapon );
		self thread maps/mp/zombies/_zm_buildables::delete_on_disconnect( weapon );
		weapon waittill( "death" );
		if ( isDefined( level.subwoofer_sound_ent ) )
		{
			level.subwoofer_sound_ent playsound( "wpn_zmb_electrap_stop" );
			level.subwoofer_sound_ent delete();
			level.subwoofer_sound_ent = undefined;
		}
		self notify( "subwoofer_cleanup" );
	}
}

subwoofer_power_on()
{
	self.power_on = 1;
	self.power_on_time = getTime();
	self.owner thread subwooferthink( self );
}

subwooferthink( weapon, armed )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_subwoofer_zm_taken" );
	weapon notify( "subwooferthink" );
	weapon endon( "subwooferthink" );
	weapon endon( "death" );
	direction_forward = anglesToForward( flat_angle( weapon.angles ) + vectorScale( ( 0, 0, 1 ), 30 ) );
	direction_vector = vectorScale( direction_forward, 512 );
	direction_origin = weapon.origin + direction_vector;
	original_angles = weapon.angles;
	original_origin = weapon.origin;
	tag_spin_origin = weapon gettagorigin( "tag_spin" );
	wait 0.05;
	while ( 1 )
	{
		while ( isDefined( weapon.power_on ) && !weapon.power_on )
		{
			wait 1;
		}
		wait 2;
		if ( isDefined( weapon.power_on ) && !weapon.power_on )
		{
			continue;
		}
		if ( !isDefined( level._subwoofer_choke ) )
		{
			level thread maps/mp/zombies/_zm_equip_subwoofer::subwoofer_choke();
		}
		while ( level._subwoofer_choke )
		{
			wait 0.05;
		}
		level._subwoofer_choke++;
		weapon.subwoofer_network_choke_count = 0;
		weapon thread maps/mp/zombies/_zm_equipment::signal_equipment_activated( 1 );
		vibrateamplitude = 4;
		if ( self.subwoofer_power_level == 3 )
		{
			vibrateamplitude = 8;
		}
		else
		{
			if ( self.subwoofer_power_level == 2 )
			{
				vibrateamplitude = 13;
			}
		}
		if ( self.subwoofer_power_level == 1 )
		{
			vibrateamplitude = 17;
		}
		weapon vibrate( vectorScale( ( 0, 0, 1 ), 100 ), vibrateamplitude, 0.2, 0.3 );
		zombies = get_array_of_closest( weapon.origin, get_round_enemy_array(), undefined, undefined, 1200 );
		players = get_array_of_closest( weapon.origin, get_players(), undefined, undefined, 1200 );
		props = get_array_of_closest( weapon.origin, getentarray( "subwoofer_target", "script_noteworthy" ), undefined, undefined, 1200 );
		entities = arraycombine( zombies, players, 0, 0 );
		entities = arraycombine( entities, props, 0, 0 );
		_a681 = entities;
		_k681 = getFirstArrayKey( _a681 );
		while ( isDefined( _k681 ) )
		{
			ent = _a681[ _k681 ];
			if ( !isDefined( ent ) || !isplayer( ent ) && isai( ent ) && !isalive( ent ) )
			{
			}
			else
			{
				if ( isDefined( ent.ignore_subwoofer ) && ent.ignore_subwoofer )
				{
					break;
				}
				else
				{
					distanceentityandsubwoofer = distance2dsquared( original_origin, ent.origin );
					onlydamage = 0;
					action = undefined;
					if ( distanceentityandsubwoofer <= 32400 )
					{
						action = "burst";
					}
					else if ( distanceentityandsubwoofer <= 230400 )
					{
						action = "fling";
					}
					else if ( distanceentityandsubwoofer <= 1440000 )
					{
						action = "stumble";
					}
					else
					{
					}
					if ( !within_fov( original_origin, original_angles, ent.origin, cos( 45 ) ) )
					{
						if ( isplayer( ent ) )
						{
							ent maps/mp/zombies/_zm_equip_subwoofer::hit_player( action, 0 );
						}
						break;
					}
					else weapon maps/mp/zombies/_zm_equip_subwoofer::subwoofer_network_choke();
					ent_trace_origin = ent.origin;
					if ( isai( ent ) || isplayer( ent ) )
					{
						ent_trace_origin = ent geteye();
					}
					if ( isDefined( ent.script_noteworthy ) && ent.script_noteworthy == "subwoofer_target" )
					{
						ent_trace_origin += vectorScale( ( 0, 0, 1 ), 48 );
					}
					if ( !sighttracepassed( tag_spin_origin, ent_trace_origin, 1, weapon ) )
					{
						break;
					}
					else if ( isDefined( ent.script_noteworthy ) && ent.script_noteworthy == "subwoofer_target" )
					{
						ent notify( "damaged_by_subwoofer" );
						break;
					}
					else
					{
						if ( isDefined( ent.in_the_ground ) && !ent.in_the_ground && isDefined( ent.in_the_ceiling ) && !ent.in_the_ceiling && isDefined( ent.ai_state ) || ent.ai_state == "zombie_goto_entrance" && isDefined( ent.completed_emerging_into_playable_area ) && !ent.completed_emerging_into_playable_area )
						{
							onlydamage = 1;
						}
						if ( isplayer( ent ) )
						{
							ent notify( "player_" + action );
							ent maps/mp/zombies/_zm_equip_subwoofer::hit_player( action, 1 );
							break;
						}
						else if ( isDefined( ent ) )
						{
							ent notify( "zombie_" + action );
							shouldgib = distanceentityandsubwoofer <= 810000;
							if ( action == "fling" )
							{
								ent thread maps/mp/zombies/_zm_equip_subwoofer::fling_zombie( weapon, direction_vector / 4, self, onlydamage );
								weapon.subwoofer_kills++;
								self thread maps/mp/zombies/_zm_audio::create_and_play_dialog( "kill", "subwoofer" );
								break;
							}
							else if ( action == "burst" )
							{
								ent thread maps/mp/zombies/_zm_equip_subwoofer::burst_zombie( weapon, self );
								weapon.subwoofer_kills++;
								self thread maps/mp/zombies/_zm_audio::create_and_play_dialog( "kill", "subwoofer" );
								break;
							}
							else
							{
								if ( action == "stumble" )
								{
									ent thread maps/mp/zombies/_zm_equip_subwoofer::knockdown_zombie( weapon, shouldgib, onlydamage );
								}
							}
						}
					}
				}
			}
			_k681 = getNextArrayKey( _a681, _k681 );
		}
		/*
		if ( weapon.subwoofer_kills >= 45 )
		{
			self thread subwoofer_expired( weapon );
		}
		*/
	}
}

startsubwooferdecay( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "equip_subwoofer_zm_taken" );
	while ( isDefined( weapon ) )
	{
		if ( weapon.power_on )
		{
			self.subwoofer_kills = 0;
			self.subwoofer_health--;

			if ( self.subwoofer_health <= 0 )
			{
				break;
			}
		}
		wait 1;
	}

	self thread maps/mp/zombies/_zm_equip_subwoofer::subwoofer_expired( weapon );

	/*
	if ( isDefined( weapon ) )
	{
		self maps/mp/zombies/_zm_equip_subwoofer::destroy_placed_subwoofer();
		maps/mp/zombies/_zm_equip_subwoofer::subwoofer_disappear_fx( weapon );
	}
	self thread maps/mp/zombies/_zm_equip_subwoofer::wait_and_take_equipment();
	self.subwoofer_health = undefined;
	self.subwoofer_power_level = undefined;
	self.subwoofer_round_start = undefined;
	self.subwoofer_power_on = undefined;
	self.subwoofer_emped = undefined;
	self.subwoofer_emp_time = undefined;
	self maps/mp/zombies/_zm_equip_subwoofer::cleanupoldsubwoofer();
	*/
}