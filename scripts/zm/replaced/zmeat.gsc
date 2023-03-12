#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include maps\mp\zombies\_zm_game_module_meat_utility;

item_meat_watch_trigger( meat_id, trigger, callback, playersoundonuse, npcsoundonuse )
{
	self endon( "death" );
	self thread maps\mp\gametypes_zm\zmeat::item_quick_trigger( meat_id, trigger );
	while ( 1 )
	{
		trigger waittill( "usetrigger", player );
		if ( !isalive( player ) )
		{
			continue;
		}
		if ( !is_player_valid( player ) )
		{
			continue;
		}
		if ( player has_powerup_weapon() )
		{
			continue;
		}
		if ( player maps\mp\zombies\_zm_laststand::is_reviving_any() )
		{
			continue;
		}
        volley = 0;
		if ( self.meat_is_flying )
		{
            if ( player isMeleeing() )
            {
                volley = 1;
            }
		}
		player.volley_meat = volley;
		if ( is_true( self._fake_meat ) )
		{
			maps\mp\gametypes_zm\zmeat::add_meat_event( "player_fake_take", player, self );
		}
		else if ( volley )
		{
			maps\mp\gametypes_zm\zmeat::add_meat_event( "player_volley", player, self );
		}
		else if ( self.meat_is_moving )
		{
			maps\mp\gametypes_zm\zmeat::add_meat_event( "player_catch", player, self );
		}
		else
		{
			maps\mp\gametypes_zm\zmeat::add_meat_event( "player_take", player, self );
		}
		if ( is_true( self._fake_meat ) )
		{
			player playlocalsound( level.zmb_laugh_alias );
			wait_network_frame();
			if ( !isDefined( self ) )
			{
				return;
			}
			self maps\mp\gametypes_zm\zmeat::cleanup_meat();
			return;
		}
		curr_weap = player getcurrentweapon();
		if ( !maps\mp\gametypes_zm\zmeat::is_meat( curr_weap ) )
		{
			player.pre_meat_weapon = curr_weap;
		}
		if ( self.meat_is_moving )
		{
			if ( volley )
			{
				self maps\mp\gametypes_zm\zmeat::item_meat_volley( player );
			}
			else
			{
				self maps\mp\gametypes_zm\zmeat::item_meat_caught( player, self.meat_is_flying );
			}
		}
		self maps\mp\gametypes_zm\zmeat::item_meat_pickup();
		if ( isDefined( playersoundonuse ) )
		{
			player playlocalsound( playersoundonuse );
		}
		if ( isDefined( npcsoundonuse ) )
		{
			player playsound( npcsoundonuse );
		}
		if ( volley )
		{
			player thread spike_the_meat( self );
		}
		else
		{
			self thread [[ callback ]]( player );
			if ( !isDefined( player._meat_hint_shown ) )
			{
				player thread maps\mp\gametypes_zm\zmeat::show_meat_throw_hint();
				player._meat_hint_shown = 1;
			}
		}
	}
}

spike_the_meat( meat )
{
	if ( is_true( self._kicking_meat ) )
	{
		return;
	}
	fake_meat = 0;
	self._kicking_meat = 1;
	self._spawning_meat = 1;
	org = self getweaponmuzzlepoint();
	vel = meat getvelocity();
	if ( !is_true( meat._fake_meat ) )
	{
		meat maps\mp\gametypes_zm\zmeat::cleanup_meat();
		level._last_person_to_throw_meat = self;
		level._last_person_to_throw_meat_time = getTime();
		level._meat_splitter_activated = 0;
	}
	else
	{
		fake_meat = 1;
		meat maps\mp\gametypes_zm\zmeat::cleanup_meat();
	}
	kickangles = self.angles;
	launchdir = anglesToForward( kickangles );
	speed = length( vel );
	launchvel = vectorScale( launchdir, speed );
	grenade = self magicgrenadetype( get_gamemode_var( "item_meat_name" ), org, ( launchvel[ 0 ], launchvel[ 1 ], 120 ) );
	grenade playsound( "zmb_meat_meat_tossed" );
	grenade thread maps\mp\gametypes_zm\zmeat::waittill_loopstart();
	if ( fake_meat )
	{
		grenade._fake_meat = 1;
		grenade thread maps\mp\gametypes_zm\zmeat::delete_on_real_meat_pickup();
		level._kicked_meat = grenade;
	}
	wait 0.1;
	self._spawning_meat = 0;
	self._kicking_meat = 0;
	if ( !fake_meat )
	{
		level notify( "meat_thrown", self );
		level notify( "meat_kicked" );
	}
}

create_item_meat_watcher()
{
    wait 0.05;
    watcher = self maps\mp\gametypes_zm\_weaponobjects::createuseweaponobjectwatcher( "item_meat", get_gamemode_var( "item_meat_name" ), self.team );
    watcher.pickup = ::item_meat_on_pickup;
    watcher.onspawn = ::item_meat_spawned;
    watcher.onspawnretrievetriggers = ::play_item_meat_on_spawn_retrieve_trigger;
    watcher.headicon = 0;
}

item_meat_on_spawn_retrieve_trigger( watcher, player, weaponname )
{
    self endon( "death" );
    add_meat_event( "meat_spawn", self );

    while ( isdefined( level.splitting_meat ) && level.splitting_meat )
        wait 0.15;

    if ( isdefined( player ) )
    {
        self setowner( player );
        self setteam( player.pers["team"] );
        self.owner = player;
        self.oldangles = self.angles;

        if ( player hasweapon( weaponname ) )
        {
            if ( !( isdefined( self._fake_meat ) && self._fake_meat ) )
                player thread player_wait_take_meat( weaponname );
            else
            {
                player takeweapon( weaponname );
                player decrement_is_drinking();
            }
        }

        if ( !( isdefined( self._fake_meat ) && self._fake_meat ) )
        {
            if ( !( isdefined( self._respawned_meat ) && self._respawned_meat ) )
            {
                level notify( "meat_thrown", player );
                level._last_person_to_throw_meat = player;
                level._last_person_to_throw_meat_time = gettime();
            }
        }
    }

	level.meat_player = undefined;

	player setMoveSpeedScale(1);

	if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		player.player_waypoint.alpha = 1;
	}

	players = get_players();
	foreach (other_player in players)
	{
		other_player thread maps\mp\gametypes_zm\zgrief::meat_stink_player_cleanup();

		if (is_player_valid(other_player) && !is_true(other_player.spawn_protection) && !is_true(other_player.revive_protection))
		{
			other_player.ignoreme = 0;
		}

		other_player thread scripts\zm\zgrief\zgrief_reimagined::show_grief_hud_msg("Meat thrown!");
	}

    if ( !( isdefined( self._fake_meat ) && self._fake_meat ) )
    {
        level._meat_moving = 1;

        if ( isdefined( level.item_meat ) && level.item_meat != self )
            level.item_meat cleanup_meat();

        level.item_meat = self;
    }

    self thread item_meat_watch_stationary();
    self thread item_meat_watch_bounce();
    self.item_meat_pick_up_trigger = spawn( "trigger_radius_use", self.origin, 0, 36, 72 );
    self.item_meat_pick_up_trigger setcursorhint( "HINT_NOICON" );
    self.item_meat_pick_up_trigger sethintstring( &"ZOMBIE_MEAT_PICKUP" );
    self.item_meat_pick_up_trigger enablelinkto();
    self.item_meat_pick_up_trigger linkto( self );
    self.item_meat_pick_up_trigger triggerignoreteam();
    level.item_meat_pick_up_trigger = self.item_meat_pick_up_trigger;
    self thread item_meat_watch_shutdown();
    self.meat_id = indexinarray( level._fake_meats, self );

    if ( !isdefined( self.meat_id ) )
        self.meat_id = 0;

    if ( isdefined( level.dont_allow_meat_interaction ) && level.dont_allow_meat_interaction )
        self.item_meat_pick_up_trigger setinvisibletoall();
    else
    {
        self thread item_meat_watch_trigger( self.meat_id, self.item_meat_pick_up_trigger, ::item_meat_on_pickup, level.meat_pickupsoundplayer, level.meat_pickupsound );
        self thread kick_meat_monitor();
        self thread last_stand_meat_nudge();
    }

    self._respawned_meat = undefined;
}

item_meat_watch_bounce()
{
    self endon( "death" );
    self endon( "picked_up" );
    self.meat_is_flying = 1;

	while (1)
	{
		self waittill( "grenade_bounce", pos, normal, ent );

		playfxontag( level._effect["meat_marker"], self, "tag_origin" );

		if ( isdefined( level.meat_bounce_override ) )
		{
			self thread [[ level.meat_bounce_override ]]( pos, normal, ent, true );
		}
	}

    self.meat_is_flying = 0;
}

item_meat_watch_stationary()
{
    self endon( "death" );
    self endon( "picked_up" );
    self.meat_is_moving = 1;

    self waittill( "stationary", pos, normal );

	if ( isdefined( level.meat_bounce_override ) )
	{
		self thread [[ level.meat_bounce_override ]]( pos, normal, undefined, false );
	}

    self.meat_is_moving = 0;

	self delete();
}

kick_meat_monitor()
{
	// no kick
}

last_stand_meat_nudge()
{
    // no kick
}