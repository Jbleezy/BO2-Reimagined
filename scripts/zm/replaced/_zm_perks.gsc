#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_perks;

perk_pause( perk )
{
	// disabled
}

perk_unpause( perk )
{
	// disabled
}

destroy_weapon_in_blackout( player )
{
	self endon( "pap_timeout" );
	self endon( "pap_taken" );
	self endon( "pap_player_disconnected" );

	level waittill( "Pack_A_Punch_off" );

	if ( isDefined( self.worldgun ) )
	{
		if ( isDefined( self.worldgun.worldgundw ) )
		{
			self.worldgun.worldgundw delete();
		}
		self.worldgun delete();
	}

	self.perk_machine.wait_flag rotateTo( self.perk_machine.angles + (0, 180, 180), 0.25, 0, 0 );
}

give_perk( perk, bought )
{
	self setperk( perk );
	self.num_perks++;
	if ( isDefined( bought ) && bought )
	{
		self maps/mp/zombies/_zm_audio::playerexert( "burp" );
		if ( isDefined( level.remove_perk_vo_delay ) && level.remove_perk_vo_delay )
		{
			self maps/mp/zombies/_zm_audio::perk_vox( perk );
		}
		else
		{
			self delay_thread( 1.5, maps/mp/zombies/_zm_audio::perk_vox, perk );
		}
		self setblur( 4, 0.1 );
		wait 0.1;
		self setblur( 0, 0.1 );
		self notify( "perk_bought" );
	}
	self perk_set_max_health_if_jugg( perk, 1, 0 );
	if ( isDefined( level.disable_deadshot_clientfield ) && !level.disable_deadshot_clientfield )
	{
		if ( perk == "specialty_deadshot" )
		{
			self setclientfieldtoplayer( "deadshot_perk", 1 );
		}
		else
		{
			if ( perk == "specialty_deadshot_upgrade" )
			{
				self setclientfieldtoplayer( "deadshot_perk", 1 );
			}
		}
	}
	if ( perk == "specialty_scavenger" )
	{
		self.hasperkspecialtytombstone = 1;
	}
	players = get_players();
	if ( use_solo_revive() && perk == "specialty_quickrevive" )
	{
		self.lives = 1;
		if ( !isDefined( level.solo_lives_given ) )
		{
			level.solo_lives_given = 0;
		}
		if ( isDefined( level.solo_game_free_player_quickrevive ) )
		{
			level.solo_game_free_player_quickrevive = undefined;
		}
		else
		{
			level.solo_lives_given++;
		}
		if ( level.solo_lives_given >= 3 )
		{
			flag_set( "solo_revive" );
		}
		self thread solo_revive_buy_trigger_move( perk );
	}
	if ( perk == "specialty_finalstand" )
	{
		self.hasperkspecialtychugabud = 1;
		self notify( "perk_chugabud_activated" );
	}
	if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].player_thread_give ) )
	{
		self thread [[ level._custom_perks[ perk ].player_thread_give ]]();
	}
	self set_perk_clientfield( perk, 1 );
	maps/mp/_demo::bookmark( "zm_player_perk", getTime(), self );
	self maps/mp/zombies/_zm_stats::increment_client_stat( "perks_drank" );
	self maps/mp/zombies/_zm_stats::increment_client_stat( perk + "_drank" );
	self maps/mp/zombies/_zm_stats::increment_player_stat( perk + "_drank" );
	self maps/mp/zombies/_zm_stats::increment_player_stat( "perks_drank" );
	if ( !isDefined( self.perk_history ) )
	{
		self.perk_history = [];
	}
	self.perk_history = add_to_array( self.perk_history, perk, 0 );
	if ( !isDefined( self.perks_active ) )
	{
		self.perks_active = [];
	}
	self.perks_active[ self.perks_active.size ] = perk;
	self notify( "perk_acquired" );
	self thread perk_think( perk );
}

perk_think( perk )
{
	perk_str = perk + "_stop";
	result = self waittill_any_return( "fake_death", "death", "player_downed", perk_str );
	do_retain = 1;
	if ( use_solo_revive() && perk == "specialty_quickrevive" )
	{
		do_retain = 0;
	}
	if ( do_retain )
	{
		if ( is_true( self._retain_perks ) )
		{
			return;
		}
		else if ( isDefined( self._retain_perks_array ) && is_true( self._retain_perks_array[ perk ] ) )
		{
			return;
		}
	}
	self unsetperk( perk );
	self.num_perks--;

	switch( perk )
	{
		case "specialty_armorvest":
			self setmaxhealth( self.premaxhealth );
			break;
		case "specialty_additionalprimaryweapon":
			if ( result == perk_str )
			{
				self maps/mp/zombies/_zm::take_additionalprimaryweapon();
			}
			break;
		case "specialty_deadshot":
			if ( !is_true( level.disable_deadshot_clientfield ) )
			{
				self setclientfieldtoplayer( "deadshot_perk", 0 );
			}
			break;
		case "specialty_deadshot_upgrade":
			if ( !is_true( level.disable_deadshot_clientfield ) )
			{
				self setclientfieldtoplayer( "deadshot_perk", 0 );
			}
			break;
	}
	if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].player_thread_take ) )
	{
		self thread [[ level._custom_perks[ perk ].player_thread_take ]]();
	}
	self set_perk_clientfield( perk, 0 );
	self.perk_purchased = undefined;
	if ( isDefined( level.perk_lost_func ) )
	{
		self [[ level.perk_lost_func ]]( perk );
	}
	if ( isDefined( self.perks_active ) && isinarray( self.perks_active, perk ) )
	{
		arrayremovevalue( self.perks_active, perk, 0 );
	}
	self notify( "perk_lost" );
}

perk_set_max_health_if_jugg( perk, set_premaxhealth, clamp_health_to_max_health )
{
	max_total_health = undefined;
	if ( perk == "specialty_armorvest" )
	{
		if ( set_premaxhealth )
		{
			self.premaxhealth = self.maxhealth;
		}
		max_total_health = level.zombie_vars[ "zombie_perk_juggernaut_health" ];
	}
	else if ( perk == "specialty_armorvest_upgrade" )
	{
		if ( set_premaxhealth )
		{
			self.premaxhealth = self.maxhealth;
		}
		max_total_health = level.zombie_vars[ "zombie_perk_juggernaut_health_upgrade" ];
	}
	else if ( perk == "jugg_upgrade" )
	{
		if ( set_premaxhealth )
		{
			self.premaxhealth = self.maxhealth;
		}
		if ( self hasperk( "specialty_armorvest" ) )
		{
			max_total_health = level.zombie_vars[ "zombie_perk_juggernaut_health" ];
		}
		else
		{
			max_total_health = level.player_starting_health;
		}
	}
	else if ( perk == "health_reboot" )
	{
		if(isDefined(level.scr_zm_ui_gametype_obj) && level.scr_zm_ui_gametype_obj == "zcontainment")
		{
			return;
		}

		max_total_health = level.player_starting_health;
	}
	if ( isDefined( max_total_health ) )
	{
		if ( self maps/mp/zombies/_zm_pers_upgrades_functions::pers_jugg_active() )
		{
			max_total_health += level.pers_jugg_upgrade_health_bonus;
		}
		if ( is_true( level.sudden_death ) && isDefined( level.sudden_death_health_loss ) )
		{
			max_total_health -= level.sudden_death_health_loss;
		}
		missinghealth = self.maxhealth - self.health;
		self setmaxhealth( max_total_health );
		self.health -= missinghealth;
		if ( isDefined( clamp_health_to_max_health ) && clamp_health_to_max_health == 1 )
		{
			if ( self.health > self.maxhealth )
			{
				self.health = self.maxhealth;
			}
		}
	}
}

// modifying this function because it is right before perk_machine_spawn_init and has a lot less code
initialize_custom_perk_arrays()
{
	if(!isDefined(level._custom_perks))
	{
		level._custom_perks = [];
	}

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_longersprint";
	struct.scr_zm_ui_gametype = "zstandard";
	struct.scr_zm_map_start_location = "town";
	struct.origin_offset = (-4, 0, 0);
	move_perk_machine("zm_transit", "town", "specialty_quickrevive", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_longersprint";
	struct.scr_zm_ui_gametype = "zclassic";
	struct.scr_zm_map_start_location = "transit";
	move_perk_machine("zm_transit", "town", "specialty_longersprint", struct);

	struct = spawnStruct();
	struct.origin = (1852, -825, -56);
	struct.angles = (0, 180, 0);
	struct.script_string = "zgrief";
	move_perk_machine("zm_transit", "town", "specialty_scavenger", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_quickrevive";
	struct.scr_zm_ui_gametype = "zgrief";
	struct.scr_zm_map_start_location = "street";
	move_perk_machine("zm_buried", "street", "specialty_longersprint", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_fastreload";
	struct.scr_zm_ui_gametype = "zgrief";
	struct.scr_zm_map_start_location = "street";
	struct.origin_offset = (0, -32, 0);
	move_perk_machine("zm_buried", "street", "specialty_quickrevive", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_fastreload";
	struct.scr_zm_ui_gametype = "zclassic";
	struct.scr_zm_map_start_location = "processing";
	move_perk_machine("zm_buried", "street", "specialty_fastreload", struct);
}

move_perk_machine(map, location, perk, move_struct)
{
	if(!(level.script == map && level.scr_zm_map_start_location == location))
	{
		return;
	}

	perk_struct = undefined;
	structs = getStructArray("zm_perk_machine", "targetname");

	foreach(struct in structs)
	{
		if(isDefined(struct.script_noteworthy) && struct.script_noteworthy == perk)
		{
			if(isDefined(struct.script_string) && isSubStr(struct.script_string, "perks_" + location))
			{
				perk_struct = struct;
				break;
			}
		}
	}

	if(!isDefined(perk_struct))
	{
		return;
	}

	if(isDefined(move_struct.script_string))
	{
		gametypes = strTok(move_struct.script_string, " ");
		foreach(gametype in gametypes)
		{
			perk_struct.script_string += " " + gametype + "_perks_" + location;
		}
	}

	if(isDefined(move_struct.origin))
	{
		perk_struct.origin = move_struct.origin;
		perk_struct.angles = move_struct.angles;

		return;
	}

	foreach(struct in structs)
	{
		if(isDefined(struct.script_noteworthy) && struct.script_noteworthy == move_struct.script_noteworthy)
		{
			if(isDefined(struct.script_string) && isSubStr(struct.script_string, move_struct.scr_zm_ui_gametype + "_perks_" + move_struct.scr_zm_map_start_location))
			{
				perk_struct.origin = struct.origin;
				perk_struct.angles = struct.angles;

				if(isDefined(move_struct.origin_offset))
				{
					perk_struct.origin += move_struct.origin_offset;
				}

				break;
			}
		}
	}
}