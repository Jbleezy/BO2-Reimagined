#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_power;

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
		self maps\mp\zombies\_zm_audio::playerexert( "burp" );
		if ( isDefined( level.remove_perk_vo_delay ) && level.remove_perk_vo_delay )
		{
			self maps\mp\zombies\_zm_audio::perk_vox( perk );
		}
		else
		{
			self delay_thread( 1.5, maps\mp\zombies\_zm_audio::perk_vox, perk );
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
	maps\mp\_demo::bookmark( "zm_player_perk", getTime(), self );
	self maps\mp\zombies\_zm_stats::increment_client_stat( "perks_drank" );
	self maps\mp\zombies\_zm_stats::increment_client_stat( perk + "_drank" );
	self maps\mp\zombies\_zm_stats::increment_player_stat( perk + "_drank" );
	self maps\mp\zombies\_zm_stats::increment_player_stat( "perks_drank" );
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
				self maps\mp\zombies\_zm::take_additionalprimaryweapon();
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
		if ( self hasperk( "specialty_armorvest" ) )
		{
			max_total_health = level.zombie_vars[ "zombie_perk_juggernaut_health" ];
		}
		else
		{
			max_total_health = level.player_starting_health;
		}
	}

	if ( isDefined( max_total_health ) )
	{
		if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_jugg_active() )
		{
			max_total_health += level.pers_jugg_upgrade_health_bonus;
		}

		if ( is_true( level.sudden_death ) )
		{
			max_total_health -= 100;
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

initialize_custom_perk_arrays()
{
	if(!isDefined(level._custom_perks))
	{
		level._custom_perks = [];
	}

	level._custom_perks["specialty_movefaster"] = spawnStruct();
	level._custom_perks["specialty_movefaster"].cost = 2500;
	level._custom_perks["specialty_movefaster"].alias = "marathon";
	level._custom_perks["specialty_movefaster"].hint_string = &"ZOMBIE_PERK_MARATHON";
	level._custom_perks["specialty_movefaster"].perk_bottle = "zombie_perk_bottle_marathon";
	level._custom_perks["specialty_movefaster"].perk_machine_thread = ::turn_movefaster_on;
	level._custom_perks["specialty_movefaster"].player_thread_give = ::give_movefaster;
	level._custom_perks["specialty_movefaster"].player_thread_take = ::take_movefaster;

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

	if(getDvar("g_gametype") == "zgrief" && getDvarIntDefault("ui_gametype_pro", 0))
	{
		add_missing_perk_machines();
		remove_perk_machines();
	}
}

add_missing_perk_machines()
{
	structs = getStructArray("zm_perk_machine", "targetname");
	foreach(struct in structs)
	{
		if((level.script == "zm_transit" && level.scr_zm_map_start_location == "transit"))
		{
			if(isDefined(struct.script_noteworthy) && struct.script_noteworthy == "specialty_quickrevive")
			{
				if(isDefined(struct.script_string) && isSubStr(struct.script_string, "zclassic_perks_transit"))
				{
					struct.script_noteworthy = "specialty_armorvest";
					struct.script_string += " zgrief_perks_transit";
				}
			}

			if(isDefined(struct.script_noteworthy) && struct.script_noteworthy == "specialty_fastreload")
			{
				if(isDefined(struct.script_string) && isSubStr(struct.script_string, "zclassic_perks_transit"))
				{
					struct.script_string += " zgrief_perks_transit";
					struct.origin = (-6304, 5363, -57);
					struct.angles += (0, 180, 0);
				}
			}
		}
		else if((level.script == "zm_prison" && level.scr_zm_map_start_location == "cellblock"))
		{
			if(isDefined(struct.script_noteworthy) && struct.script_noteworthy == "specialty_rof")
			{
				if(isDefined(struct.script_string) && isSubStr(struct.script_string, "zgrief_perks_cellblock"))
				{
					struct.script_noteworthy = "specialty_armorvest";
					struct.origin = (1411, 9663, 1335);
					struct.angles += (0, 180, 0);
				}
			}
		}
	}
}

remove_perk_machines()
{
	exceptions = array("specialty_armorvest", "specialty_fastreload");

	structs = getStructArray("zm_perk_machine", "targetname");
	foreach(struct in structs)
	{
		if(isDefined(struct.script_noteworthy) && !isInArray(exceptions, struct.script_noteworthy))
		{
			struct.script_string = "";
		}
	}
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

turn_movefaster_on()
{
	while ( 1 )
	{
		machine = getentarray( "vending_marathon", "targetname" );
		machine_triggers = getentarray( "vending_marathon", "target" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "marathon" ].off_model );
			i++;
		}
		array_thread( machine_triggers, ::set_power_on, 0 );
		level thread do_initial_power_off_callback( machine, "marathon" );
		level waittill( "marathon_on" );
		i = 0;
		while ( i < machine.size )
		{
			machine[ i ] setmodel( level.machine_assets[ "marathon" ].on_model );
			machine[ i ] vibrate( vectorScale( ( 0, -1, 0 ), 100 ), 0,3, 0,4, 3 );
			machine[ i ] playsound( "zmb_perks_power_on" );
			machine[ i ] thread perk_fx( "marathon_light" );
			machine[ i ] thread play_loop_on_machine();
			i++;
		}
		level notify( "specialty_movefaster_power_on" );
		array_thread( machine_triggers, ::set_power_on, 1 );
		if ( isDefined( level.machine_assets[ "marathon" ].power_on_callback ) )
		{
			array_thread( machine, level.machine_assets[ "marathon" ].power_on_callback );
		}
		level waittill( "marathon_off" );
		if ( isDefined( level.machine_assets[ "marathon" ].power_off_callback ) )
		{
			array_thread( machine, level.machine_assets[ "marathon" ].power_off_callback );
		}
		array_thread( machine, ::turn_perk_off );
	}
}

give_movefaster()
{
	self set_perk_clientfield("specialty_longersprint", 1);
}

take_movefaster()
{
	if (IsDefined(self.disabled_perks) && IsDefined(self.disabled_perks["specialty_movefaster"]) && self.disabled_perks["specialty_movefaster"])
	{
		self set_perk_clientfield("specialty_longersprint", 2);
	}
	else
	{
		self set_perk_clientfield( "specialty_longersprint", 0 );
	}
}

wait_for_player_to_take( player, weapon, packa_timer, upgrade_as_attachment )
{
    current_weapon = self.current_weapon;
    upgrade_name = self.upgrade_name;
    upgrade_weapon = upgrade_name;
    self endon( "pap_timeout" );
    level endon( "Pack_A_Punch_off" );

    while ( true )
    {
        packa_timer playloopsound( "zmb_perks_packa_ticktock" );

        self waittill( "trigger", trigger_player );

        if ( isdefined( level.pap_grab_by_anyone ) && level.pap_grab_by_anyone )
            player = trigger_player;

        packa_timer stoploopsound( 0.05 );

        if ( trigger_player == player )
        {
            player maps\mp\zombies\_zm_stats::increment_client_stat( "pap_weapon_grabbed" );
            player maps\mp\zombies\_zm_stats::increment_player_stat( "pap_weapon_grabbed" );
            current_weapon = player getcurrentweapon();

            if ( is_player_valid( player ) && !( player.is_drinking > 0 ) && !is_placeable_mine( current_weapon ) && !is_equipment( current_weapon ) && level.revive_tool != current_weapon && "none" != current_weapon && !player hacker_active() )
            {
                maps\mp\_demo::bookmark( "zm_player_grabbed_packapunch", gettime(), player );
                self notify( "pap_taken" );
                player notify( "pap_taken" );
                player.pap_used = 1;

                if ( !( isdefined( upgrade_as_attachment ) && upgrade_as_attachment ) )
                    player thread do_player_general_vox( "general", "pap_arm", 15, 100 );
                else
                    player thread do_player_general_vox( "general", "pap_arm2", 15, 100 );

                weapon_limit = get_player_weapon_limit( player );
                player maps\mp\zombies\_zm_weapons::take_fallback_weapon();
                primaries = player getweaponslistprimaries();

                if ( isdefined( primaries ) && primaries.size >= weapon_limit )
                    player maps\mp\zombies\_zm_weapons::weapon_give( upgrade_weapon );
                else
                {
                    player giveweapon( upgrade_weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( upgrade_weapon ) );
                    player givestartammo( upgrade_weapon );
					player scripts\zm\_zm_reimagined::change_weapon_ammo(upgrade_weapon);
                }

                player switchtoweapon( upgrade_weapon );

                if ( isdefined( player.restore_ammo ) && player.restore_ammo )
                {
                    new_clip = player.restore_clip + weaponclipsize( upgrade_weapon ) - player.restore_clip_size;
                    new_stock = player.restore_stock + weaponmaxammo( upgrade_weapon ) - player.restore_max;
                    player setweaponammostock( upgrade_weapon, new_stock );
                    player setweaponammoclip( upgrade_weapon, new_clip );
                }

                player.restore_ammo = undefined;
                player.restore_clip = undefined;
                player.restore_stock = undefined;
                player.restore_max = undefined;
                player.restore_clip_size = undefined;
                player maps\mp\zombies\_zm_weapons::play_weapon_vo( upgrade_weapon );
                return;
            }
        }

        wait 0.05;
    }
}