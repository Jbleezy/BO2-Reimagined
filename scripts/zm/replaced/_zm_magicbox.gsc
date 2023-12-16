#include maps\mp\zombies\_zm_magicbox;
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
	init_starting_chest_location( start_chest_name );
	array_thread( level.chests, ::treasure_chest_think );
}

init_starting_chest_location( start_chest_name )
{
	level.chest_index = 0;
	start_chest_found = 0;

	if ( level.chests.size == 1 )
	{
		start_chest_found = 1;

		if ( isdefined( level.chests[level.chest_index].zbarrier ) )
			level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state( "initial" );
	}
	else
	{
		for ( i = 0; i < level.chests.size; i++ )
		{
			if ( isdefined( level.random_pandora_box_start ) && level.random_pandora_box_start == 1 )
			{
				if ( start_chest_found || isdefined( level.chests[i].start_exclude ) && level.chests[i].start_exclude == 1 )
					level.chests[i] hide_chest();
				else
				{
					level.chests = array_swap( level.chests, level.chest_index, i );
					level.chests[level.chest_index].hidden = 0;

					if ( isdefined( level.chests[level.chest_index].zbarrier ) )
						level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state( "initial" );

					start_chest_found = 1;
				}

				continue;
			}

			if ( start_chest_found || !isdefined( level.chests[i].script_noteworthy ) || !issubstr( level.chests[i].script_noteworthy, start_chest_name ) )
			{
				level.chests[i] hide_chest();
				continue;
			}

			level.chests = array_swap( level.chests, level.chest_index, i );
			level.chests[level.chest_index].hidden = 0;

			if ( isdefined( level.chests[level.chest_index].zbarrier ) )
				level.chests[level.chest_index].zbarrier set_magic_box_zbarrier_state( "initial" );

			start_chest_found = 1;
		}
	}

	if ( !isdefined( level.pandora_show_func ) )
		level.pandora_show_func = ::default_pandora_show_func;

	level.chests[level.chest_index] thread [[ level.pandora_show_func ]]();
}

treasure_chest_think()
{
	self endon( "kill_chest_think" );
	user = undefined;
	user_cost = undefined;
	self.box_rerespun = undefined;
	self.weapon_out = undefined;
	self thread unregister_unitrigger_on_kill_think();

	while ( true )
	{
		if ( !isdefined( self.forced_user ) )
		{
			self waittill( "trigger", user );

			if ( user == level )
				continue;
		}
		else
			user = self.forced_user;

		if ( user in_revive_trigger() )
		{
			wait 0.1;
			continue;
		}

		if ( user.is_drinking > 0 )
		{
			wait 0.1;
			continue;
		}

		if ( isdefined( self.disabled ) && self.disabled )
		{
			wait 0.1;
			continue;
		}

		if ( user getcurrentweapon() == "none" )
		{
			wait 0.1;
			continue;
		}

		reduced_cost = undefined;

		if ( is_player_valid( user ) && user maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active() )
			reduced_cost = int( self.zombie_cost / 2 );

		if ( isdefined( level.using_locked_magicbox ) && level.using_locked_magicbox && ( isdefined( self.is_locked ) && self.is_locked ) )
		{
			if ( user.score >= level.locked_magic_box_cost )
			{
				user maps\mp\zombies\_zm_score::minus_to_player_score( level.locked_magic_box_cost );
				self.zbarrier set_magic_box_zbarrier_state( "unlocking" );
				self.unitrigger_stub run_visibility_function_for_all_triggers();
			}
			else
				user maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money_box" );

			wait 0.1;
			continue;
		}
		else if ( isdefined( self.auto_open ) && is_player_valid( user ) )
		{
			if ( !isdefined( self.no_charge ) )
			{
				user maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost );
				user_cost = self.zombie_cost;
			}
			else
				user_cost = 0;

			self.chest_user = user;
			break;
		}
		else if ( is_player_valid( user ) && user.score >= self.zombie_cost )
		{
			user maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost );
			user_cost = self.zombie_cost;
			self.chest_user = user;
			break;
		}
		else if ( isdefined( reduced_cost ) && user.score >= reduced_cost )
		{
			user maps\mp\zombies\_zm_score::minus_to_player_score( reduced_cost );
			user_cost = reduced_cost;
			self.chest_user = user;
			break;
		}
		else if ( user.score < self.zombie_cost )
		{
			play_sound_at_pos( "no_purchase", self.origin );
			user maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money_box" );
			continue;
		}

		wait 0.05;
	}

	flag_set( "chest_has_been_used" );
	maps\mp\_demo::bookmark( "zm_player_use_magicbox", gettime(), user );
	user maps\mp\zombies\_zm_stats::increment_client_stat( "use_magicbox" );
	user maps\mp\zombies\_zm_stats::increment_player_stat( "use_magicbox" );

	if ( isdefined( level._magic_box_used_vo ) )
		user thread [[ level._magic_box_used_vo ]]();

	self thread watch_for_emp_close();

	if ( isdefined( level.using_locked_magicbox ) && level.using_locked_magicbox )
		self thread maps\mp\zombies\_zm_magicbox_lock::watch_for_lock();

	self._box_open = 1;
	self._box_opened_by_fire_sale = 0;

	if ( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] && !isdefined( self.auto_open ) && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() )
		self._box_opened_by_fire_sale = 1;

	if ( isdefined( self.chest_lid ) )
		self.chest_lid thread treasure_chest_lid_open();

	if ( isdefined( self.zbarrier ) )
	{
		play_sound_at_pos( "open_chest", self.origin );
		play_sound_at_pos( "music_chest", self.origin );
		self.zbarrier set_magic_box_zbarrier_state( "open" );
	}

	self.timedout = 0;
	self.weapon_out = 1;
	self.zbarrier thread treasure_chest_weapon_spawn( self, user );
	self.zbarrier thread treasure_chest_glowfx();
	thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
	self.zbarrier waittill_any( "randomization_done", "box_hacked_respin" );

	if ( flag( "moving_chest_now" ) && !self._box_opened_by_fire_sale && isdefined( user_cost ) )
		user maps\mp\zombies\_zm_score::add_to_player_score( user_cost, 0 );

	if ( flag( "moving_chest_now" ) && !level.zombie_vars["zombie_powerup_fire_sale_on"] && !self._box_opened_by_fire_sale )
		self thread treasure_chest_move( self.chest_user );
	else
	{
		self.grab_weapon_hint = 1;
		self.grab_weapon_name = self.zbarrier.weapon_string;
		self.chest_user = user;
		thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );

		if ( isdefined( self.zbarrier ) && !is_true( self.zbarrier.closed_by_emp ) )
			self thread treasure_chest_timeout();

		while ( !( isdefined( self.closed_by_emp ) && self.closed_by_emp ) )
		{
			self waittill( "trigger", grabber );

			self.weapon_out = undefined;

			if ( isdefined( level.magic_box_grab_by_anyone ) && level.magic_box_grab_by_anyone )
			{
				if ( isplayer( grabber ) )
					user = grabber;
			}

			if ( isdefined( level.pers_upgrade_box_weapon ) && level.pers_upgrade_box_weapon )
				self maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_box_weapon_used( user, grabber );

			if ( isdefined( grabber.is_drinking ) && grabber.is_drinking > 0 )
			{
				wait 0.1;
				continue;
			}

			if ( grabber == user && user getcurrentweapon() == "none" )
			{
				wait 0.1;
				continue;
			}

			if ( grabber != level && ( isdefined( self.box_rerespun ) && self.box_rerespun ) )
				user = grabber;

			if ( grabber == user || grabber == level )
			{
				self.box_rerespun = undefined;
				current_weapon = "none";

				if ( is_player_valid( user ) )
					current_weapon = user getcurrentweapon();

				if ( grabber == user && is_player_valid( user ) && !( user.is_drinking > 0 ) && !is_melee_weapon( current_weapon ) && !is_placeable_mine( current_weapon ) && !is_equipment( current_weapon ) && level.revive_tool != current_weapon )
				{
					bbprint( "zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %s", user.name, user.score, level.round_number, self.zombie_cost, self.zbarrier.weapon_string, self.origin, "magic_accept" );
					self notify( "user_grabbed_weapon" );
					user notify( "user_grabbed_weapon" );
					user thread treasure_chest_give_weapon( self.zbarrier.weapon_string );
					maps\mp\_demo::bookmark( "zm_player_grabbed_magicbox", gettime(), user );
					user maps\mp\zombies\_zm_stats::increment_client_stat( "grabbed_from_magicbox" );
					user maps\mp\zombies\_zm_stats::increment_player_stat( "grabbed_from_magicbox" );
					break;
				}
				else if ( grabber == level )
				{
					unacquire_weapon_toggle( self.zbarrier.weapon_string );
					self.timedout = 1;

					if ( is_player_valid( user ) )
						bbprint( "zombie_uses", "playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type %S", user.name, user.score, level.round_number, self.zombie_cost, self.zbarrier.weapon_string, self.origin, "magic_reject" );

					break;
				}
			}

			wait 0.05;
		}

		self.grab_weapon_hint = 0;
		self.zbarrier notify( "weapon_grabbed" );

		if ( !( isdefined( self._box_opened_by_fire_sale ) && self._box_opened_by_fire_sale ) )
			level.chest_accessed += 1;

		if ( level.chest_moves > 0 && isdefined( level.pulls_since_last_ray_gun ) )
			level.pulls_since_last_ray_gun += 1;

		if ( isdefined( level.pulls_since_last_tesla_gun ) )
			level.pulls_since_last_tesla_gun += 1;

		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );

		if ( isdefined( self.chest_lid ) )
			self.chest_lid thread treasure_chest_lid_close( self.timedout );

		if ( isdefined( self.zbarrier ) )
		{
			self.zbarrier set_magic_box_zbarrier_state( "close" );
			play_sound_at_pos( "close_chest", self.origin );

			self.zbarrier waittill( "closed" );

			wait 1;
		}
		else
			wait 3.0;

		if ( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() || self == level.chests[level.chest_index] )
			thread maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, ::magicbox_unitrigger_think );
	}

	self._box_open = 0;
	self._box_opened_by_fire_sale = 0;
	self.chest_user = undefined;
	self notify( "chest_accessed" );
	self thread treasure_chest_think();
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
	rand = undefined;
	number_cycles = 37;

	if ( isdefined( level.custom_magicbox_float_height ) )
		v_float = anglestoup( self.angles ) * level.custom_magicbox_float_height;
	else
		v_float = anglestoup( self.angles ) * 40;

	if ( isdefined( level.custom_magic_box_weapon_wait ) )
		[[ level.custom_magic_box_weapon_wait ]]();

	start_origin = self.origin;
	end_origin = self.origin + v_float;
	angles = self.angles + (0, 180, 0);

	if (level.script == "zm_tomb")
	{
		v_move = anglestoright( self.angles ) * -20;
		start_origin = self.origin + v_float + v_move;
		angles = self.angles;
	}

	// angle is opposite of what it should be on upside down box
	if (angles[2] < 0)
	{
		angles = (angles[0], angles[1], -360 - angles[2] );
	}

	dw_offset = (anglesToForward(angles) * -3) + (anglesToRight(angles) * -3) + (anglesToUp(angles) * -3);

	self.weapon_model = spawn("script_model", start_origin);
	self.weapon_model.angles = angles;
	self.weapon_model_dw = spawn("script_model", self.weapon_model.origin + dw_offset);
	self.weapon_model_dw.angles = self.weapon_model.angles;
	self.weapon_model_dw hide();

	self.weapon_model moveto( end_origin, 3, 2, 0.9 );
	self.weapon_model_dw moveto( end_origin + dw_offset, 3, 2, 0.9 );

	for ( i = 0; i < number_cycles; i++ )
	{
		rand = treasure_chest_chooseweightedrandomweapon( player, rand, 0 );
		modelname = getweaponmodel( rand );

		if ( isdefined( self.weapon_model ) )
		{
			self.weapon_model useweaponmodel( rand, modelname );

			if ( weapondualwieldweaponname( rand ) != "none" )
			{
				self.weapon_model_dw useweaponmodel( weapondualwieldweaponname( rand ), modelname );
				self.weapon_model_dw show();
			}
			else
			{
				self.weapon_model_dw hide();
			}
		}

		if ( i < 20 )
		{
			wait 0.05;
		}
		else if ( i < 30 )
		{
			wait 0.1;
		}
		else if ( i < 35 )
		{
			wait 0.2;
		}
		else
		{
			wait 0.3;
		}
	}

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

			joker_angles = angles - vectorscale( ( 0, 1, 0 ), 90.0 );
			if ( angles[2] < 0 )
			{
				joker_angles = angles + vectorscale( ( 0, 1, 0 ), 90.0 );
			}

			// delete and respawn the joker model so that it faces the correct angle right away
			origin = self.weapon_model.origin;
			self.weapon_model delete();
			self.weapon_model = spawn("script_model", origin);
			self.weapon_model.angles = joker_angles;
			self.weapon_model setmodel( level.chest_joker_model );
			self.weapon_model_dw hide();

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
			rand = treasure_chest_chooseweightedrandomweapon( player, rand );

		modelname = getweaponmodel( rand );
		self.weapon_string = rand;
		self.weapon_model useweaponmodel( rand, modelname );

		if ( weapondualwieldweaponname( rand ) != "none" )
		{
			self.weapon_model_dw useweaponmodel( weapondualwieldweaponname( rand ), modelname );
			self.weapon_model_dw show();
		}
		else
		{
			self.weapon_model_dw hide();
		}
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

treasure_chest_chooseweightedrandomweapon( player, prev_weapon, add_to_acquired = 1 )
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
				if (isDefined(prev_weapon) && prev_weapon == keys[i])
				{
					continue;
				}

				if (add_to_acquired)
				{
					player.random_weapons_acquired[player.random_weapons_acquired.size] = keys[i];
				}

				return keys[i];
			}
		}
	}

	if (isDefined(prev_weapon))
	{
		if (add_to_acquired)
		{
			player.random_weapons_acquired[player.random_weapons_acquired.size] = prev_weapon;
		}

		return prev_weapon;
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
		default_box_move_logic();
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

default_box_move_logic()
{
	index = -1;

	for ( i = 0; i < level.chests.size; i++ )
	{
		if ( issubstr( level.chests[i].script_noteworthy, "move" + ( level.chest_moves + 1 ) ) && i != level.chest_index )
		{
			index = i;
			break;
		}
	}

	if ( index != -1 )
		level.chest_index = index;
	else
		level.chest_index++;

	if ( level.chest_index >= level.chests.size )
	{
		temp_chest_name = level.chests[level.chest_index - 1].script_noteworthy;
		level.chest_index = 0;
		level.chests = array_randomize( level.chests );

		if ( temp_chest_name == level.chests[level.chest_index].script_noteworthy )
		{
			level.chests = array_swap( level.chests, level.chest_index, 1 );
		}
	}
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

decide_hide_show_hint( endon_notify, second_endon_notify, onlyplayer )
{
	self endon( "death" );

	if ( isdefined( endon_notify ) )
		self endon( endon_notify );

	if ( isdefined( second_endon_notify ) )
		self endon( second_endon_notify );

	if ( !isdefined( level._weapon_show_hint_choke ) )
		level thread weapon_show_hint_choke();

	use_choke = 0;

	if ( isdefined( level._use_choke_weapon_hints ) && level._use_choke_weapon_hints == 1 )
		use_choke = 1;

	is_grenade = 0;
	if ( isDefined( self.zombie_weapon_upgrade ) && weaponType( self.zombie_weapon_upgrade ) == "grenade" )
	{
		is_grenade = 1;
	}

	while ( true )
	{
		last_update = gettime();

		if ( isdefined( self.chest_user ) && !isdefined( self.box_rerespun ) )
		{
			if ( is_melee_weapon( self.chest_user getcurrentweapon() ) || is_placeable_mine( self.chest_user getcurrentweapon() ) || self.chest_user hacker_active() )
				self setinvisibletoplayer( self.chest_user );
			else
				self setvisibletoplayer( self.chest_user );
		}
		else if ( isdefined( onlyplayer ) )
		{
			if ( is_grenade || onlyplayer can_buy_weapon() )
				self setinvisibletoplayer( onlyplayer, 0 );
			else
				self setinvisibletoplayer( onlyplayer, 1 );
		}
		else
		{
			players = get_players();

			for ( i = 0; i < players.size; i++ )
			{
				if ( is_grenade || players[i] can_buy_weapon() )
				{
					self setinvisibletoplayer( players[i], 0 );
					continue;
				}

				self setinvisibletoplayer( players[i], 1 );
			}
		}

		if ( use_choke )
		{
			while ( level._weapon_show_hint_choke > 4 && gettime() < last_update + 150 )
				wait 0.05;
		}
		else
			wait 0.1;

		level._weapon_show_hint_choke++;
	}
}

trigger_visible_to_player( player )
{
	self setinvisibletoplayer( player );
	visible = 1;

	if ( isdefined( self.stub.trigger_target.chest_user ) && !isdefined( self.stub.trigger_target.box_rerespun ) )
	{
		if ( player != self.stub.trigger_target.chest_user || is_melee_weapon( self.stub.trigger_target.chest_user getcurrentweapon() ) || is_placeable_mine( self.stub.trigger_target.chest_user getcurrentweapon() ) || self.stub.trigger_target.chest_user hacker_active() )
			visible = 0;
	}
	else
	{
		is_chest = 0;
		foreach ( chest in level.chests )
		{
			if ( self.stub.trigger_target == chest )
			{
				is_chest = 1;
				break;
			}
		}

		if ( !is_chest && !player can_buy_weapon( ) )
		{
			visible = 0;
		}
	}

	if ( !visible )
		return false;

	self setvisibletoplayer( player );
	return true;
}

can_buy_weapon()
{
	if ( isdefined( self.is_drinking ) && self.is_drinking > 0 )
		return false;

	if ( self hacker_active() )
		return false;

	current_weapon = self getcurrentweapon();

	if ( is_melee_weapon( current_weapon ) || is_placeable_mine( current_weapon ) || is_equipment_that_blocks_purchase( current_weapon ) )
		return false;

	if ( self in_revive_trigger() )
		return false;

	if ( current_weapon == "none" )
		return false;

	return true;
}