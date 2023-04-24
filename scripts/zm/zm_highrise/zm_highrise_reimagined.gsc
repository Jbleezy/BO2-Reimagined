#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\replaced\zm_highrise_sq;
#include scripts\zm\replaced\zm_highrise_atd;
#include scripts\zm\replaced\zm_highrise_ssp;
#include scripts\zm\replaced\zm_highrise_pts;
#include scripts\zm\replaced\zm_highrise_gamemodes;
#include scripts\zm\replaced\zm_highrise_classic;
#include scripts\zm\replaced\zm_highrise_buildables;
#include scripts\zm\replaced\zm_highrise_elevators;
#include scripts\zm\replaced\zm_highrise_distance_tracking;
#include scripts\zm\replaced\_zm_ai_leaper;
#include scripts\zm\replaced\_zm_chugabud;
#include scripts\zm\replaced\_zm_equip_springpad;
#include scripts\zm\replaced\_zm_weap_slipgun;
#include scripts\zm\replaced\_zm_banking;
#include scripts\zm\replaced\_zm_weapon_locker;
#include scripts\zm\replaced\_zm_sq;

main()
{
	replaceFunc(maps\mp\zm_highrise_sq::navcomputer_waitfor_navcard, scripts\zm\replaced\_zm_sq::navcomputer_waitfor_navcard);
	replaceFunc(maps\mp\zm_highrise_sq::init, scripts\zm\replaced\zm_highrise_sq::init);
	replaceFunc(maps\mp\zm_highrise_sq_atd::init, scripts\zm\replaced\zm_highrise_sq_atd::init);
	replaceFunc(maps\mp\zm_highrise_sq_ssp::ssp1_watch_ball, scripts\zm\replaced\zm_highrise_sq_ssp::ssp1_watch_ball);
	replaceFunc(maps\mp\zm_highrise_sq_ssp::init_2, scripts\zm\replaced\zm_highrise_sq_ssp::init_2);
	replaceFunc(maps\mp\zm_highrise_sq_pts::init_1, scripts\zm\replaced\zm_highrise_sq_pts::init_1);
	replaceFunc(maps\mp\zm_highrise_sq_pts::init_2, scripts\zm\replaced\zm_highrise_sq_pts::init_2);
	replaceFunc(maps\mp\zm_highrise_sq_pts::pts_should_player_create_trigs, scripts\zm\replaced\zm_highrise_sq_pts::pts_should_player_create_trigs);
	replaceFunc(maps\mp\zm_highrise_gamemodes::init, scripts\zm\replaced\zm_highrise_gamemodes::init);
	replaceFunc(maps\mp\zm_highrise_buildables::init_buildables, scripts\zm\replaced\zm_highrise_buildables::init_buildables);
	replaceFunc(maps\mp\zm_highrise_buildables::include_buildables, scripts\zm\replaced\zm_highrise_buildables::include_buildables);
	replaceFunc(maps\mp\zm_highrise_elevators::init_elevator_perks, scripts\zm\replaced\zm_highrise_elevators::init_elevator_perks);
	replaceFunc(maps\mp\zm_highrise_elevators::elevator_think, scripts\zm\replaced\zm_highrise_elevators::elevator_think);
	replaceFunc(maps\mp\zm_highrise_elevators::faller_location_logic, scripts\zm\replaced\zm_highrise_elevators::faller_location_logic);
	replaceFunc(maps\mp\zm_highrise_distance_tracking::zombie_tracking_init, scripts\zm\replaced\zm_highrise_distance_tracking::zombie_tracking_init);
	replaceFunc(maps\mp\zm_highrise_distance_tracking::delete_zombie_noone_looking, scripts\zm\replaced\zm_highrise_distance_tracking::delete_zombie_noone_looking);
	replaceFunc(maps\mp\zombies\_zm_ai_leaper::leaper_round_tracker, scripts\zm\replaced\_zm_ai_leaper::leaper_round_tracker);
	replaceFunc(maps\mp\zombies\_zm_equip_springpad::springpadthink, scripts\zm\replaced\_zm_equip_springpad::springpadthink);
	replaceFunc(maps\mp\zombies\_zm_weap_slipgun::init, scripts\zm\replaced\_zm_weap_slipgun::init);
	replaceFunc(maps\mp\zombies\_zm_weap_slipgun::slipgun_zombie_1st_hit_response, scripts\zm\replaced\_zm_weap_slipgun::slipgun_zombie_1st_hit_response);
	replaceFunc(maps\mp\zombies\_zm_banking::init, scripts\zm\replaced\_zm_banking::init);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_box, scripts\zm\replaced\_zm_banking::bank_deposit_box);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_unitrigger, scripts\zm\replaced\_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger, scripts\zm\replaced\_zm_banking::bank_withdraw_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_weapon_locker::triggerweaponslockerisvalidweaponpromptupdate, scripts\zm\replaced\_zm_weapon_locker::triggerweaponslockerisvalidweaponpromptupdate);
}

init()
{
	precacheshader( "specialty_chugabud_zombies" );

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::highrise_special_weapon_magicbox_check;
	level.check_for_valid_spawn_near_team_callback = ::highrise_respawn_override;
	level.zm_traversal_override = ::zm_traversal_override;
	level.chugabud_laststand_func = scripts\zm\replaced\_zm_chugabud::chugabud_laststand;

	slipgun_change_ammo();

	level thread elevator_call();
	level thread escape_pod_call();
}

zombie_init_done()
{
	self.allowpain = 0;
	self.zombie_path_bad = 0;
	self thread maps\mp\zm_highrise_distance_tracking::escaped_zombies_cleanup_init();
	self thread maps\mp\zm_highrise::elevator_traverse_watcher();
	if ( self.classname == "actor_zm_highrise_basic_03" )
	{
		health_bonus = int( self.maxhealth * 0.05 );
		self.maxhealth += health_bonus;
		if ( self.headmodel == "c_zom_zombie_chinese_head3_helmet" )
		{
			self.maxhealth += health_bonus;
		}
		self.health = self.maxhealth;
	}
	self setphysparams( 15, 0, 48 );
}

highrise_special_weapon_magicbox_check(weapon)
{
	return 1;
}

highrise_respawn_override( revivee, return_struct )
{
	players = array_randomize(get_players());
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	if ( spawn_points.size == 0 )
	{
		return undefined;
	}

	for ( i = 0; i < players.size; i++ )
	{
		if ( is_player_valid( players[ i ], undefined, 1 ) && players[ i ] != self )
		{
			for ( j = 0; j < spawn_points.size; j++ )
			{
				if ( isDefined( spawn_points[ j ].script_noteworthy ) )
				{
					zone = level.zones[ spawn_points[ j ].script_noteworthy ];
					for ( k = 0; k < zone.volumes.size; k++ )
					{
						if ( players[ i ] istouching( zone.volumes[ k ] ) )
						{
							closest_group = j;
							spawn_location = maps\mp\zombies\_zm::get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
							if ( isDefined( spawn_location ) )
							{
								return spawn_location;
							}
						}
					}
				}
			}
		}
	}
}

zm_traversal_override( traversealias )
{
	if ( traversealias == "dierise_traverse_3_high_to_low" )
	{
		traversealias = "dierise_traverse_2_high_to_low";
		self.pre_traverse = ::change_origin;
	}

    return traversealias;
}

change_origin()
{
	self.pre_traverse = undefined;
	self.origin += anglestoforward( self.traversestartnode.angles ) * -16;
	self orientmode( "face angle", self.traversestartnode.angles[1] + 15 );
}

slipgun_change_ammo()
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == "slipgun_zm")
		{
			buildable.onbuyweapon = ::onbuyweapon_slipgun;
			return;
		}
	}
}

onbuyweapon_slipgun( player )
{
    player givestartammo( self.stub.weaponname );
    player switchtoweapon( self.stub.weaponname );
	player scripts\zm\_zm_reimagined::change_weapon_ammo(self.stub.weaponname);
    level notify( "slipgun_bought", player );
}

elevator_call()
{
	trigs = getentarray( "elevator_key_console_trigger", "targetname" );

	foreach (trig in trigs)
	{
		elevatorname = trig.script_noteworthy;

		if ( isdefined( elevatorname ) && isdefined( trig.script_parameters ) )
		{
			elevator = level.elevators[elevatorname];
			floor = int( trig.script_parameters );
			flevel = elevator maps\mp\zm_highrise_elevators::elevator_level_for_floor( floor );
			trig.elevator = elevator;
			trig.floor = flevel;
		}

		trig.cost = 250;
		trig usetriggerrequirelookat();
		trig sethintstring( &"ZOMBIE_NEED_POWER" );
	}

	flag_wait( "power_on" );

	foreach (trig in trigs)
	{
		trig thread elevator_call_think();
		trig thread watch_elevator_prompt();
		trig thread watch_elevator_body_prompt();
	}

	foreach (elevator in level.elevators)
	{
		elevator thread watch_elevator_lights();
	}
}

elevator_call_think()
{
	self notify( "elevator_call_think" );
	self endon( "elevator_call_think" );

	while ( 1 )
	{
		cost_active = 0;
		if ( !self.elevator.body.is_moving && self.elevator maps\mp\zm_highrise_elevators::elevator_is_on_floor( self.floor ) && !is_true( self.elevator.body.start_location_wait ) )
		{
			if ( !is_true( self.elevator.body.elevator_stop ) )
			{
				self sethintstring( "Hold ^3[{+activate}]^7 to lock elevator" );
			}
			else
			{
				self sethintstring( "Hold ^3[{+activate}]^7 to unlock elevator" );
			}
		}
		else
		{
			if ( self.elevator maps\mp\zm_highrise_elevators::elevator_is_on_floor( self.floor ) && !is_true( self.elevator.body.start_location_wait ) )
			{
				self sethintstring( "The elevator is on the way" );
				return;
			}

			cost_active = 1;
			self sethintstring( &"ZM_HIGHRISE_BUILD_KEYS", " [Cost: " + self.cost + "]" );
		}

		self trigger_on();

		self waittill( "trigger", who );

		if ( !is_player_valid( who ) )
        {
			continue;
		}

		if ( cost_active )
		{
			if ( who.score < self.cost )
			{
				play_sound_at_pos( "no_purchase", self.origin );
				who maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "door_deny" );
				continue;
			}

			who maps\mp\zombies\_zm_score::minus_to_player_score( self.cost );
			play_sound_at_pos( "purchase", self.origin );
		}

		self playsound( "zmb_elevator_ding" );

		if ( !self.elevator.body.is_moving && self.elevator maps\mp\zm_highrise_elevators::elevator_is_on_floor( self.floor ) && !is_true( self.elevator.body.start_location_wait ) )
		{
			if ( !is_true( self.elevator.body.elevator_stop ) )
			{
				self.elevator.body setanim( level.perk_elevators_anims[self.elevator.body.perk_type][1] );
				self.elevator.body.elevator_stop = 1;
			}
			else
			{
				self.elevator.body.elevator_stop = 0;
			}

			continue;
		}

		self.elevator.body.elevator_stop = 0;
		self.elevator.body.elevator_force_go = 1;
		self maps\mp\zm_highrise_buildables::onuseplantobject_elevatorkey( who );

		if ( is_true( self.elevator.body.start_location_wait ) && self.elevator maps\mp\zm_highrise_elevators::elevator_is_on_floor( self.floor ) )
		{
			self sethintstring( "Hold ^3[{+activate}]^7 to lock elevator" );

			while ( is_true( self.elevator.body.start_location_wait ) )
			{
				wait 0.05;
			}

			continue;
		}

		self sethintstring( "The elevator is on the way" );

		return;
	}
}

watch_elevator_prompt()
{
    while ( 1 )
    {
        self.elevator waittill( "floor_changed" );

		self thread do_watch_elevator_prompt();
    }
}

do_watch_elevator_prompt()
{
	self notify( "do_watch_elevator_prompt" );
	self endon( "do_watch_elevator_prompt" );
	self endon( "do_watch_elevator_body_prompt" );

	if ( is_true( self.elevator.body.elevator_force_go ) )
	{
		while ( !is_true( self.elevator.body.is_moving ) && !is_true( self.elevator.body.start_location_wait ) )
		{
			wait 0.05;
		}

		if ( is_true( self.elevator.body.start_location_wait ) )
		{
			while ( is_true( self.elevator.body.start_location_wait ) )
			{
				wait 0.05;
			}

			self.elevator.body.elevator_force_go = 0;
			self thread elevator_call_think();
		}
		else
		{
			self thread elevator_call_think();
		}
	}
	else
	{
		self thread elevator_call_think();
	}
}

watch_elevator_body_prompt()
{
    while ( 1 )
    {
        msg = self.elevator.body waittill_any_return( "movedone", "startwait" );

		self thread do_watch_elevator_body_prompt( msg );
    }
}

do_watch_elevator_body_prompt( msg )
{
	self notify( "do_watch_elevator_body_prompt" );
	self endon( "do_watch_elevator_body_prompt" );
	self endon( "do_watch_elevator_prompt" );

	if ( msg == "movedone" )
	{
		while ( is_true( self.elevator.body.is_moving ) )
		{
			wait 0.05;
		}

		self.elevator.body.elevator_force_go = 0;
		self thread elevator_call_think();
	}
	else
	{
		self thread elevator_call_think();
	}
}

watch_elevator_lights()
{
	set = 1;
	dir = "_d";

	while ( 1 )
	{
		if ( is_true( self.body.elevator_stop ) )
		{
			if ( set )
			{
				set = 0;

				dir = self.dir;
			}

			clientnotify( self.name + dir );

			if ( dir == "_d" )
			{
				dir = "_u";
			}
			else
			{
				dir = "_d";
			}
		}
		else if ( !set )
		{
			set = 1;

			clientnotify( self.name + self.dir );
		}

		wait 0.05;
	}
}

escape_pod_call()
{
	trig = getent( "escape_pod_key_console_trigger", "targetname" );

	trig.cost = 750;
	trig usetriggerrequirelookat();

	trig thread escape_pod_call_think();
}

escape_pod_call_think()
{
	while ( 1 )
	{
		flag_wait( "escape_pod_needs_reset" );

		self sethintstring( &"ZM_HIGHRISE_BUILD_KEYS", " [Cost: " + self.cost + "]" );

		self waittill( "trigger", who );

		if ( !is_player_valid( who ) )
        {
			continue;
		}

		if ( who.score < self.cost )
		{
			play_sound_at_pos( "no_purchase", self.origin );
			who maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "door_deny" );
			continue;
		}

		who maps\mp\zombies\_zm_score::minus_to_player_score( self.cost );
		play_sound_at_pos( "purchase", self.origin );

		self playsound( "zmb_buildable_complete" );

		self sethintstring( "The elevator is on the way" );

		self maps\mp\zm_highrise_buildables::onuseplantobject_escapepodkey( who );

		flag_waitopen( "escape_pod_needs_reset" );
	}
}