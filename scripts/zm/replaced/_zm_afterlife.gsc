#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_afterlife;

init_player()
{
	flag_wait( "initial_players_connected" );
	self.lives = 1;
	self setclientfieldtoplayer( "player_lives", self.lives );
	self.afterlife = 0;
	self.afterliferound = level.round_number;
	self.afterlifedeaths = 0;
	self thread afterlife_doors_close();
	self thread afterlife_player_refill_watch();
}

afterlife_add()
{
	if ( self.lives < 1 )
    {
        self.lives++;
        self thread afterlife_add_fx();
    }
	self playsoundtoplayer( "zmb_afterlife_add", self );
	self setclientfieldtoplayer( "player_lives", self.lives );
}

afterlife_start_zombie_logic()
{
	flag_wait( "start_zombie_round_logic" );
	wait 0.5;
	everyone_alive = 0;
	while ( isDefined( everyone_alive ) && !everyone_alive )
	{
		everyone_alive = 1;
		players = getplayers();
		foreach (player in players)
		{
			if ( isDefined( player.afterlife ) && player.afterlife )
			{
				everyone_alive = 0;
				wait 0.05;
				break;
			}
		}
	}
	wait 0.5;
	while ( level.intermission )
	{
		wait 0.05;
	}
	flag_set( "afterlife_start_over" );
	wait 2;
	array_func( getplayers(), ::afterlife_add );
}

afterlife_laststand( b_electric_chair = 0 )
{
    self endon( "disconnect" );
    self endon( "afterlife_bleedout" );
    level endon( "end_game" );

    if ( isdefined( level.afterlife_laststand_override ) )
    {
        self thread [[ level.afterlife_laststand_override ]]( b_electric_chair );
        return;
    }

    self.dontspeak = 1;
    self.health = 1000;
    b_has_electric_cherry = 0;

    if ( self hasperk( "specialty_grenadepulldeath" ) )
        b_has_electric_cherry = 1;

    self [[ level.afterlife_save_loadout ]]();
    self afterlife_fake_death();

    if ( isdefined( b_electric_chair ) && !b_electric_chair )
        wait 1;

    if ( isdefined( b_has_electric_cherry ) && b_has_electric_cherry && ( isdefined( b_electric_chair ) && !b_electric_chair ) )
    {
        self maps\mp\zombies\_zm_perk_electric_cherry::electric_cherry_laststand();
    }

    self setclientfieldtoplayer( "clientfield_afterlife_audio", 1 );

    if ( flag( "afterlife_start_over" ) )
    {
        self clientnotify( "al_t" );
        wait 1;
        self thread fadetoblackforxsec( 0, 1, 0.5, 0.5, "white" );
        wait 0.5;
    }

    self ghost();
    self.e_afterlife_corpse = self afterlife_spawn_corpse();
    self thread afterlife_clean_up_on_disconnect();
    self notify( "player_fake_corpse_created" );
    self afterlife_fake_revive();
    self afterlife_enter();
    self.e_afterlife_corpse setclientfield( "player_corpse_id", self getentitynumber() + 1 );
    wait 0.5;
    self show();

    if ( !( isdefined( self.hostmigrationcontrolsfrozen ) && self.hostmigrationcontrolsfrozen ) )
        self freezecontrols( 0 );

    self disableinvulnerability();

    self.e_afterlife_corpse waittill( "player_revived", e_reviver );

    self notify( "player_revived" );
    self seteverhadweaponall( 1 );
    self enableinvulnerability();
    self.afterlife_revived = 1;
    playsoundatposition( "zmb_afterlife_spawn_leave", self.e_afterlife_corpse.origin );
    self afterlife_leave();
    self thread afterlife_revive_invincible();
    self playsound( "zmb_afterlife_revived_gasp" );
}

afterlife_fake_death()
{
    level notify( "fake_death" );
    self notify( "fake_death" );
    self takeallweapons();
    self allowstand( 0 );
    self allowcrouch( 0 );
    self allowprone( 1 );
    self setstance( "prone" );
    self enableinvulnerability();
	self.ignoreme = 1;

    if ( self is_jumping() )
    {
        while ( self is_jumping() )
            wait 0.05;
    }

    playfx( level._effect["afterlife_enter"], self.origin );
    self freezecontrols( 1 );
}

afterlife_revive_do_revive( playerbeingrevived, revivergun )
{
    assert( self is_reviving_afterlife( playerbeingrevived ) );
    revivetime = 3;
    playloop = 0;

    if ( isdefined( self.afterlife ) && self.afterlife )
    {
        playloop = 1;
        revivetime = 1;
    }

    timer = 0;
    revived = 0;
    playerbeingrevived.revivetrigger.beingrevived = 1;
    playerbeingrevived.revive_hud settext( &"GAME_PLAYER_IS_REVIVING_YOU", self );
    playerbeingrevived revive_hud_show_n_fade( 3.0 );
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

    if ( !isdefined( self.reviveprogressbar ) )
	{
		self.reviveprogressbar = self createprimaryprogressbar();
		self.reviveprogressbar.bar.color = (0.5, 0.5, 1);
		self.reviveprogressbar thread scripts\zm\_zm_reimagined::destroy_on_intermission();
	}

    if ( !isdefined( self.revivetexthud ) )
        self.revivetexthud = newclienthudelem( self );

    self thread revive_clean_up_on_gameover();
    self thread laststand_clean_up_on_disconnect( playerbeingrevived, revivergun );

    if ( !isdefined( self.is_reviving_any ) )
        self.is_reviving_any = 0;

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
        self.revivetexthud.y = -347;

    self.revivetexthud.foreground = 1;
    self.revivetexthud.font = "default";
    self.revivetexthud.fontscale = 1.8;
    self.revivetexthud.alpha = 1;
    self.revivetexthud.color = ( 1, 1, 1 );
    self.revivetexthud.hidewheninmenu = 1;

    if ( self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active() )
        self.revivetexthud.color = ( 0.5, 0.5, 1.0 );

    self.revivetexthud settext( &"GAME_REVIVING" );
    self thread check_for_failed_revive( playerbeingrevived );
    e_fx = spawn( "script_model", playerbeingrevived.revivetrigger.origin );
    e_fx setmodel( "tag_origin" );
    e_fx thread revive_fx_clean_up_on_disconnect( playerbeingrevived );
    playfxontag( level._effect["afterlife_leave"], e_fx, "tag_origin" );

    if ( isdefined( playloop ) && playloop )
        e_fx playloopsound( "zmb_afterlife_reviving", 0.05 );

    while ( self is_reviving_afterlife( playerbeingrevived ) )
    {
        wait 0.05;
        timer += 0.05;

        if ( self player_is_in_laststand() )
            break;

        if ( isdefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
            break;

        if ( timer >= revivetime )
        {
            revived = 1;
            break;
        }
    }

    e_fx delete();

	if ( isDefined( playerbeingrevived.beingrevivedprogressbar ) )
	{
		playerbeingrevived.beingrevivedprogressbar destroyelem();
	}

    if ( isdefined( self.reviveprogressbar ) )
	{
		self.reviveprogressbar destroyelem();
	}

    if ( isdefined( self.revivetexthud ) )
	{
		self.revivetexthud destroy();
	}

    if ( isdefined( playerbeingrevived.revivetrigger.auto_revive ) && playerbeingrevived.revivetrigger.auto_revive == 1 )
    {

    }
    else if ( !revived )
    {
        if ( isplayer( playerbeingrevived ) )
            playerbeingrevived stoprevive( self );
    }

    playerbeingrevived.revivetrigger sethintstring( &"GAME_BUTTON_TO_REVIVE_PLAYER" );
    playerbeingrevived.revivetrigger.beingrevived = 0;
    self notify( "do_revive_ended_normally" );
    self.is_reviving_any--;

    if ( !revived )
        playerbeingrevived thread checkforbleedout( self );

    return revived;
}