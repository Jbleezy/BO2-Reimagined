#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox_lock;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\_demo;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_magicbox;

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

treasure_chest_weapon_spawn( chest, player, respin )
{
    if ( isdefined( level.using_locked_magicbox ) && level.using_locked_magicbox )
    {
        self.owner endon( "box_locked" );
        self thread maps\mp\zombies\_zm_magicbox_lock::clean_up_locked_box();
    }

    self endon( "box_hacked_respin" );
    self thread clean_up_hacked_box();
    assert( isdefined( player ) );
    self.weapon_string = undefined;
    modelname = undefined;
    rand = undefined;
    number_cycles = 40;

    if ( isdefined( chest.zbarrier ) )
    {
        if ( isdefined( level.custom_magic_box_do_weapon_rise ) )
            chest.zbarrier thread [[ level.custom_magic_box_do_weapon_rise ]]();
        else
            chest.zbarrier thread magic_box_do_weapon_rise();
    }

    for ( i = 0; i < number_cycles; i++ )
    {
        if ( i < 20 )
        {
            wait 0.05;
            continue;
        }

        if ( i < 30 )
        {
            wait 0.1;
            continue;
        }

        if ( i < 35 )
        {
            wait 0.2;
            continue;
        }

        if ( i < 38 )
            wait 0.3;
    }

    if ( isdefined( level.custom_magic_box_weapon_wait ) )
        [[ level.custom_magic_box_weapon_wait ]]();

	if ( isdefined( level.custom_magicbox_float_height ) )
		v_float = anglestoup( self.angles ) * level.custom_magicbox_float_height;
	else
		v_float = anglestoup( self.angles ) * 40;

    wait 0.1;

    if ( getdvar( "magic_chest_movable" ) == "1" && !( isdefined( chest._box_opened_by_fire_sale ) && chest._box_opened_by_fire_sale ) && !( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() ) )
    {
        random = randomint( 100 );

        if ( !isdefined( level.chest_min_move_usage ) )
            level.chest_min_move_usage = 4;

        if ( level.chest_accessed < level.chest_min_move_usage )
            chance_of_joker = -1;
        else
        {
            chance_of_joker = level.chest_accessed + 20;

            if ( level.chest_moves == 0 && level.chest_accessed >= 8 )
                chance_of_joker = 100;

            if ( level.chest_accessed >= 4 && level.chest_accessed < 8 )
            {
                if ( random < 15 )
                    chance_of_joker = 100;
                else
                    chance_of_joker = -1;
            }

            if ( level.chest_moves > 0 )
            {
                if ( level.chest_accessed >= 8 && level.chest_accessed < 13 )
                {
                    if ( random < 30 )
                        chance_of_joker = 100;
                    else
                        chance_of_joker = -1;
                }

                if ( level.chest_accessed >= 13 )
                {
                    if ( random < 50 )
                        chance_of_joker = 100;
                    else
                        chance_of_joker = -1;
                }
            }
        }

        if ( isdefined( chest.no_fly_away ) )
            chance_of_joker = -1;

        if ( isdefined( level._zombiemode_chest_joker_chance_override_func ) )
            chance_of_joker = [[ level._zombiemode_chest_joker_chance_override_func ]]( chance_of_joker );

        if ( chance_of_joker > random )
        {
            self.weapon_string = undefined;
			self.weapon_model = spawn( "script_model", self.origin + v_float );
			self.weapon_model.angles = self.angles + vectorscale( ( 0, 1, 0 ), 90.0 );
			self.weapon_model setmodel( level.chest_joker_model );

            self.chest_moving = 1;
            flag_set( "moving_chest_now" );
            level.chest_accessed = 0;
            level.chest_moves++;
        }
    }

	if ( !is_true( self.chest_moving ) )
    {
        if ( isdefined( player.pers_upgrades_awarded["box_weapon"] ) && player.pers_upgrades_awarded["box_weapon"] )
            rand = maps\mp\zombies\_zm_pers_upgrades_functions::pers_treasure_chest_choosespecialweapon( player );
        else
            rand = treasure_chest_chooseweightedrandomweapon( player );

        self.weapon_string = rand;
		self.weapon_model = spawn_weapon_model( rand, undefined, self.origin + v_float, self.angles + vectorscale( ( 0, 1, 0 ), 180.0 ) );

        if ( weapon_is_dual_wield( rand ) )
            self.weapon_model_dw = spawn_weapon_model( rand, get_left_hand_weapon_model_name( rand ), self.weapon_model.origin - vectorscale( ( 1, 1, 1 ), 3.0 ), self.weapon_model.angles );
    }

    self notify( "randomization_done" );

    if ( flag( "moving_chest_now" ) && !( level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() ) )
    {
        if ( isdefined( level.chest_joker_custom_movement ) )
            self [[ level.chest_joker_custom_movement ]]();
        else
        {
            wait 0.5;
            level notify( "weapon_fly_away_start" );
            wait 2;

            if ( isdefined( self.weapon_model ) )
            {
                v_fly_away = self.origin + anglestoup( self.angles ) * 500;
                self.weapon_model moveto( v_fly_away, 4, 3 );
            }

            if ( isdefined( self.weapon_model_dw ) )
            {
                v_fly_away = self.origin + anglestoup( self.angles ) * 500;
                self.weapon_model_dw moveto( v_fly_away, 4, 3 );
            }

            self.weapon_model waittill( "movedone" );

            self.weapon_model delete();

            if ( isdefined( self.weapon_model_dw ) )
            {
                self.weapon_model_dw delete();
                self.weapon_model_dw = undefined;
            }

            self notify( "box_moving" );
            level notify( "weapon_fly_away_end" );
        }
    }
    else
    {
        acquire_weapon_toggle( rand, player );

        if ( rand == "tesla_gun_zm" || rand == "ray_gun_zm" )
        {
            if ( rand == "ray_gun_zm" )
                level.pulls_since_last_ray_gun = 0;

            if ( rand == "tesla_gun_zm" )
            {
                level.pulls_since_last_tesla_gun = 0;
                level.player_seen_tesla_gun = 1;
            }
        }

        if ( !isdefined( respin ) )
        {
            if ( isdefined( chest.box_hacks["respin"] ) )
                self [[ chest.box_hacks["respin"] ]]( chest, player );
        }
        else if ( isdefined( chest.box_hacks["respin_respin"] ) )
            self [[ chest.box_hacks["respin_respin"] ]]( chest, player );

        if ( isdefined( level.custom_magic_box_timer_til_despawn ) )
            self.weapon_model thread [[ level.custom_magic_box_timer_til_despawn ]]( self );
        else
            self.weapon_model thread timer_til_despawn( v_float );

        if ( isdefined( self.weapon_model_dw ) )
        {
            if ( isdefined( level.custom_magic_box_timer_til_despawn ) )
                self.weapon_model_dw thread [[ level.custom_magic_box_timer_til_despawn ]]( self );
            else
                self.weapon_model_dw thread timer_til_despawn( v_float );
        }

        self waittill( "weapon_grabbed" );

        if ( !chest.timedout )
        {
            if ( isdefined( self.weapon_model ) )
                self.weapon_model delete();

            if ( isdefined( self.weapon_model_dw ) )
                self.weapon_model_dw delete();
        }
    }

    self.weapon_string = undefined;
    self notify( "box_spin_done" );
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