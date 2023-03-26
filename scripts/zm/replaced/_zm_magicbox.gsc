#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

treasure_chest_init( start_chest_name )
{
	flag_init( "moving_chest_enabled" );
	flag_init( "moving_chest_now" );
	flag_init( "chest_has_been_used" );
	level.chest_moves = 0;
	level.chest_level = 0;
	if ( level.chests.size == 0 )
	{
		return;
	}
	i = 0;
	while ( i < level.chests.size )
	{
		level.chests[ i ].box_hacks = [];
		level.chests[ i ].orig_origin = level.chests[ i ].origin;
		level.chests[ i ] maps\mp\zombies\_zm_magicbox::get_chest_pieces();
		if ( isDefined( level.chests[ i ].zombie_cost ) )
		{
			level.chests[ i ].old_cost = level.chests[ i ].zombie_cost;
			i++;
			continue;
		}
		else
		{
			level.chests[ i ].old_cost = 950;
		}
		i++;
	}
	if ( (getDvar("g_gametype") == "zgrief" && getDvarIntDefault("ui_gametype_pro", 0)) || !level.enable_magic )
	{
		foreach (chest in level.chests)
		{
			chest maps\mp\zombies\_zm_magicbox::hide_chest();
		}
		return;
	}
	level.chest_accessed = 0;
	if ( level.chests.size > 1 )
	{
		flag_set( "moving_chest_enabled" );
		level.chests = array_randomize( level.chests );
	}
	else
	{
		level.chest_index = 0;
		level.chests[ 0 ].no_fly_away = 1;
	}
	maps\mp\zombies\_zm_magicbox::init_starting_chest_location( start_chest_name );
	array_thread( level.chests, maps\mp\zombies\_zm_magicbox::treasure_chest_think );
}

treasure_chest_move( player_vox )
{
	level waittill( "weapon_fly_away_start" );
	players = get_players();
	array_thread( players, maps\mp\zombies\_zm_magicbox::play_crazi_sound );
	if ( isDefined( player_vox ) )
	{
		player_vox delay_thread( randomintrange( 2, 7 ), maps\mp\zombies\_zm_audio::create_and_play_dialog, "general", "box_move" );
	}
	level waittill( "weapon_fly_away_end" );
	if ( isDefined( self.zbarrier ) )
	{
		self maps\mp\zombies\_zm_magicbox::hide_chest( 1 );
	}
	wait 0.1;
	if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 1 && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() )
	{
		current_sale_time = level.zombie_vars[ "zombie_powerup_fire_sale_time" ];
		wait_network_frame();
		self thread maps\mp\zombies\_zm_magicbox::fire_sale_fix();
		level.zombie_vars[ "zombie_powerup_fire_sale_time" ] = current_sale_time;
		while ( level.zombie_vars[ "zombie_powerup_fire_sale_time" ] > 0 )
		{
			wait 0.1;
		}
	}
	level.verify_chest = 0;
	if ( isDefined( level._zombiemode_custom_box_move_logic ) )
	{
		[[ level._zombiemode_custom_box_move_logic ]]();
	}
	else
	{
		maps\mp\zombies\_zm_magicbox::default_box_move_logic();
	}
	if ( isDefined( level.chests[ level.chest_index ].box_hacks[ "summon_box" ] ) )
	{
		level.chests[ level.chest_index ] [[ level.chests[ level.chest_index ].box_hacks[ "summon_box" ] ]]( 0 );
	}
	playfx( level._effect[ "poltergeist" ], level.chests[ level.chest_index ].zbarrier.origin );
	level.chests[ level.chest_index ] maps\mp\zombies\_zm_magicbox::show_chest();
	flag_clear( "moving_chest_now" );
	self.zbarrier.chest_moving = 0;
}

treasure_chest_timeout()
{
	self endon( "user_grabbed_weapon" );
	self.zbarrier endon( "box_hacked_respin" );
	self.zbarrier endon( "box_hacked_rerespin" );
	wait level.magicbox_timeout;
	self notify( "trigger", level );
}

timer_til_despawn( v_float )
{
	self endon( "kill_weapon_movement" );
	self moveto( self.origin - ( v_float * 0.85 ), level.magicbox_timeout, level.magicbox_timeout * 0.5 );
	wait level.magicbox_timeout;
	if ( isDefined( self ) )
	{
		self delete();
	}
}

treasure_chest_chooseweightedrandomweapon( player )
{
    keys = array_randomize( getarraykeys( level.zombie_weapons ) );

    if ( isdefined( level.customrandomweaponweights ) )
        keys = player [[ level.customrandomweaponweights ]]( keys );

    pap_triggers = getentarray( "specialty_weapupgrade", "script_noteworthy" );

	if (!isDefined(player.random_weapons_acquired))
	{
		player.random_weapons_acquired = [];
	}

    for ( i = 0; i < keys.size; i++ )
    {
        if ( treasure_chest_canplayerreceiveweapon( player, keys[i], pap_triggers ) )
		{
			if (!isInArray(player.random_weapons_acquired, keys[i]))
			{
				player.random_weapons_acquired[player.random_weapons_acquired.size] = keys[i];
				return keys[i];
			}
		}
    }

	if (player.random_weapons_acquired.size > 0)
	{
		player.random_weapons_acquired = [];
		return treasure_chest_chooseweightedrandomweapon(player);
	}

    return keys[0];
}