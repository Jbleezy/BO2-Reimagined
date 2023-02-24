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

kick_meat_monitor()
{
	// no kick
}

last_stand_meat_nudge()
{
    // no kick
}