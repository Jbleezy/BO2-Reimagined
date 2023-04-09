#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

revive_do_revive( playerbeingrevived, revivergun )
{
	revivetime = 3;
	if ( self hasperk( "specialty_quickrevive" ) )
	{
		revivetime /= 1.5;
	}
	if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active() )
	{
		revivetime *= 0.5;
	}
	if ( isdefined( self.e_chugabud_corpse ) )
	{
		revivetime *= 0.5;
	}
	timer = 0;
	revived = 0;
	playerbeingrevived.revivetrigger.beingrevived = 1;
	playerbeingrevived.revive_hud settext( &"ZOMBIE_PLAYER_IS_REVIVING_YOU", self );
	playerbeingrevived maps\mp\zombies\_zm_laststand::revive_hud_show_n_fade( 3 );
	playerbeingrevived.revivetrigger sethintstring( "" );
	if ( isplayer( playerbeingrevived ) )
	{
		playerbeingrevived startrevive( self );
	}
    if ( !isDefined( playerbeingrevived.beingrevivedprogressbar ) )
	{
		playerbeingrevived.beingrevivedprogressbar = playerbeingrevived createprimaryprogressbar();
        playerbeingrevived.beingrevivedprogressbar setpoint("CENTER", undefined, level.primaryprogressbarx, -1 * level.primaryprogressbary);
        playerbeingrevived.beingrevivedprogressbar.bar.color = (0.5, 0.5, 1);
        playerbeingrevived.beingrevivedprogressbar.hidewheninmenu = 1;
        playerbeingrevived.beingrevivedprogressbar.bar.hidewheninmenu = 1;
        playerbeingrevived.beingrevivedprogressbar.barframe.hidewheninmenu = 1;
		playerbeingrevived.beingrevivedprogressbar thread scripts\zm\_zm_reimagined::destroy_on_intermission();
	}
	if ( !isDefined( self.reviveprogressbar ) )
	{
		self.reviveprogressbar = self createprimaryprogressbar();
        self.reviveprogressbar.bar.color = (0.5, 0.5, 1);
		self.reviveprogressbar thread scripts\zm\_zm_reimagined::destroy_on_intermission();
	}
	if ( !isDefined( self.revivetexthud ) )
	{
		self.revivetexthud = newclienthudelem( self );
	}
	self thread laststand_clean_up_on_disconnect( playerbeingrevived, revivergun );
	if ( !isDefined( self.is_reviving_any ) )
	{
		self.is_reviving_any = 0;
	}
	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any( playerbeingrevived );
	self.reviveprogressbar updatebar( 0.01, 1 / revivetime );
    playerbeingrevived.beingrevivedprogressbar updatebar( 0.01, 1 / revivetime );
	self.revivetexthud.alignx = "center";
	self.revivetexthud.aligny = "middle";
	self.revivetexthud.horzalign = "center";
	self.revivetexthud.vertalign = "bottom";
	self.revivetexthud.y = -113;
	if ( self issplitscreen() )
	{
		self.revivetexthud.y = -347;
	}
	self.revivetexthud.foreground = 1;
	self.revivetexthud.font = "default";
	self.revivetexthud.fontscale = 1.8;
	self.revivetexthud.alpha = 1;
	self.revivetexthud.color = ( 1, 1, 1 );
	self.revivetexthud.hidewheninmenu = 1;
	if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active() )
	{
		self.revivetexthud.color = ( 0.5, 0.5, 1 );
	}
	self.revivetexthud settext( &"ZOMBIE_REVIVING" );
	self thread maps\mp\zombies\_zm_laststand::check_for_failed_revive( playerbeingrevived );
	while ( self maps\mp\zombies\_zm_laststand::is_reviving( playerbeingrevived ) )
	{
		wait 0.05;
		timer += 0.05;
		if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			break;
		}
		else if ( isDefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
		{
			break;
		}
		if ( timer >= revivetime )
		{
			revived = 1;
			break;
		}
	}
    if ( isDefined( playerbeingrevived.beingrevivedprogressbar ) )
	{
		playerbeingrevived.beingrevivedprogressbar destroyelem();
	}
	if ( isDefined( self.reviveprogressbar ) )
	{
		self.reviveprogressbar destroyelem();
	}
	if ( isDefined( self.revivetexthud ) )
	{
		self.revivetexthud destroy();
	}
	if ( isDefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
	{
	}
	else if ( !revived )
	{
		if ( isplayer( playerbeingrevived ) )
		{
			playerbeingrevived stoprevive( self );
		}
	}
	playerbeingrevived.revivetrigger sethintstring( &"ZOMBIE_BUTTON_TO_REVIVE_PLAYER" );
	playerbeingrevived.revivetrigger.beingrevived = 0;
	self notify( "do_revive_ended_normally" );
	self.is_reviving_any--;

	if ( !revived )
	{
		playerbeingrevived thread maps\mp\zombies\_zm_laststand::checkforbleedout( self );
	}
	return revived;
}

laststand_clean_up_on_disconnect( playerbeingrevived, revivergun )
{
	self endon( "do_revive_ended_normally" );

	revivetrigger = playerbeingrevived.revivetrigger;

	playerbeingrevived waittill( "disconnect" );

	if ( isDefined( revivetrigger ) )
	{
		revivetrigger delete();
	}

	self maps\mp\zombies\_zm_laststand::cleanup_suicide_hud();

	if ( isDefined( self.reviveprogressbar ) )
	{
		self.reviveprogressbar destroyelem();
	}

	if ( isDefined( self.revivetexthud ) )
	{
		self.revivetexthud destroy();
	}

	self maps\mp\zombies\_zm_laststand::revive_give_back_weapons( revivergun );
}

laststand_clean_up_reviving_any( playerbeingrevived )
{
	self endon( "do_revive_ended_normally" );

	playerbeingrevived waittill_any( "disconnect", "zombified", "stop_revive_trigger" );

	self.is_reviving_any--;
	if ( self.is_reviving_any < 0 )
	{
		self.is_reviving_any = 0;
	}

	if ( isDefined( playerbeingrevived.beingrevivedprogressbar ) )
	{
		playerbeingrevived.beingrevivedprogressbar destroyelem();
	}
}

revive_give_back_weapons( gun )
{
	revive_tool = level.revive_tool;
	if ( is_true( self.afterlife ) )
    {
		revive_tool = level.afterlife_revive_tool;
	}

	cur_wep = self getCurrentWeapon();

	self takeweapon( revive_tool );

	if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		return;
	}

    if (cur_wep != revive_tool)
    {
        return;
    }

	if (self hasWeapon("item_meat_zm"))
    {
        return;
    }

	if (self hasWeapon("screecher_arms_zm"))
    {
        return;
    }

	if ( gun != "none" && !is_placeable_mine( gun ) && gun != "equip_gasmask_zm" && gun != "lower_equip_gasmask_zm" && self hasweapon( gun ) )
	{
		self switchtoweapon( gun );
	}
	else
	{
		primaryweapons = self getweaponslistprimaries();
		if ( isDefined( primaryweapons ) && primaryweapons.size > 0 )
		{
			self switchtoweapon( primaryweapons[ 0 ] );
		}
	}
}

revive_hud_think()
{
	self endon( "disconnect" );

	while ( 1 )
	{
		wait 0.1;
		if ( !maps\mp\zombies\_zm_laststand::player_any_player_in_laststand() )
		{
			continue;
		}
		players = get_players();
		playertorevive = undefined;
		i = 0;
		while ( i < players.size )
		{
			if ( !isDefined( players[ i ].revivetrigger ) || !isDefined( players[ i ].revivetrigger.createtime ) )
			{
				i++;
				continue;
			}
			if ( !isDefined( playertorevive ) || playertorevive.revivetrigger.createtime > players[ i ].revivetrigger.createtime )
			{
				playertorevive = players[ i ];
			}
			i++;
		}
		if ( isDefined( playertorevive ) )
		{
			i = 0;
			while ( i < players.size )
			{
				if ( players[ i ] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
				{
					i++;
					continue;
				}
				if ( getDvar( "g_gametype" ) == "vs" )
				{
					if ( players[ i ].team != playertorevive.team )
					{
						i++;
						continue;
					}
				}
				if ( is_encounter() )
				{
					if ( players[ i ].sessionteam != playertorevive.sessionteam )
					{
						i++;
						continue;
					}
					if ( is_true( level.hide_revive_message ) )
					{
						i++;
						continue;
					}
				}
				players[ i ] thread maps\mp\zombies\_zm_laststand::faderevivemessageover( playertorevive, 3 );
				i++;
			}
			playertorevive.revivetrigger.createtime = undefined;
		}
	}
}

auto_revive( reviver, dont_enable_weapons )
{
    if ( isdefined( self.revivetrigger ) )
    {
        self.revivetrigger.auto_revive = 1;

        if ( self.revivetrigger.beingrevived == 1 )
        {
            while ( true )
            {
                if ( self.revivetrigger.beingrevived == 0 )
                    break;

                wait_network_frame();
            }
        }

        self.revivetrigger.auto_trigger = 0;
    }

    self reviveplayer();
    self maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg( "health_reboot", 1, 0 );
    setclientsysstate( "lsm", "0", self );
    self notify( "stop_revive_trigger" );

    if ( isdefined( self.revivetrigger ) )
    {
        self.revivetrigger delete();
        self.revivetrigger = undefined;
    }

    self cleanup_suicide_hud();

    if ( !isdefined( dont_enable_weapons ) || dont_enable_weapons == 0 )
        self laststand_enable_player_weapons();

    self allowjump( 1 );
    self.ignoreme = 0;
    self.laststand = undefined;

    if ( reviver != self )
    {
        reviver.revives++;
        reviver maps\mp\zombies\_zm_stats::increment_client_stat( "revives" );
        reviver maps\mp\zombies\_zm_stats::increment_player_stat( "revives" );
        self recordplayerrevivezombies( reviver );
        maps\mp\_demo::bookmark( "zm_player_revived", gettime(), self, reviver );
    }

    self notify( "player_revived", reviver );
}

playerlaststand( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    self notify( "entering_last_stand" );

    if ( isdefined( level._game_module_player_laststand_callback ) )
        self [[ level._game_module_player_laststand_callback ]]( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );

    if ( self player_is_in_laststand() )
        return;

    if ( isdefined( self.in_zombify_call ) && self.in_zombify_call )
        return;

    self thread player_last_stand_stats( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );

    if ( isdefined( level.playerlaststand_func ) )
        [[ level.playerlaststand_func ]]( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );

    self.health = 1;
    self.laststand = 1;
    self.ignoreme = 1;
    self thread maps\mp\gametypes_zm\_gameobjects::onplayerlaststand();
    self thread maps\mp\zombies\_zm_buildables::onplayerlaststand();

    if ( !( isdefined( self.no_revive_trigger ) && self.no_revive_trigger ) )
        self revive_trigger_spawn();
    else
        self undolaststand();

    if ( isdefined( self.is_zombie ) && self.is_zombie )
    {
        self takeallweapons();

        if ( isdefined( attacker ) && isplayer( attacker ) && attacker != self )
            attacker notify( "killed_a_zombie_player", einflictor, self, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration );
    }
    else
    {
        self laststand_disable_player_weapons();
        self laststand_give_pistol();
    }

    if ( isdefined( level.playersuicideallowed ) && level.playersuicideallowed && get_players().size > 1 )
    {
        if ( !isdefined( level.canplayersuicide ) || self [[ level.canplayersuicide ]]() )
            self thread suicide_trigger_spawn();
    }

    if ( level.laststandgetupallowed )
        self thread laststand_getup();
    else
    {
        bleedout_time = getdvarfloat( "player_lastStandBleedoutTime" );
        self thread laststand_bleedout( bleedout_time );
    }

    if ( "zcleansed" != level.gametype )
        maps\mp\_demo::bookmark( "zm_player_downed", gettime(), self );

    self notify( "player_downed" );
    self thread refire_player_downed();
    self thread cleanup_laststand_on_disconnect();
}