#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_chugabud;

chugabud_laststand()
{
    self endon( "player_suicide" );
    self endon( "disconnect" );
    self endon( "chugabud_bleedout" );

	if ( isdefined( self.e_chugabud_corpse ) )
	{
		self notify( "chugabud_handle_multiple_instances" );
		return;
	}

    self maps\mp\zombies\_zm_laststand::increment_downed_stat();
    self.ignore_insta_kill = 1;
    self.health = self.maxhealth;
    self chugabud_save_loadout();
    self chugabud_fake_death();
    wait 3;

    if ( isdefined( self.insta_killed ) && self.insta_killed || isdefined( self.disable_chugabud_corpse ) )
        create_corpse = 0;
    else
        create_corpse = 1;

    if ( create_corpse == 1 )
    {
        if ( isdefined( level._chugabug_reject_corpse_override_func ) )
        {
            reject_corpse = self [[ level._chugabug_reject_corpse_override_func ]]( self.origin );

            if ( reject_corpse )
                create_corpse = 0;
        }
    }

    if ( create_corpse == 1 )
    {
        self thread activate_chugabud_effects_and_audio();
        corpse = self chugabud_spawn_corpse();
        corpse thread chugabud_corpse_revive_icon( self );
        self.e_chugabud_corpse = corpse;
        corpse thread chugabud_corpse_cleanup_on_spectator( self );
		corpse thread chugabud_corpse_cleanup_on_disconnect( self );

        if ( isdefined( level.whos_who_client_setup ) )
            corpse setclientfield( "clientfield_whos_who_clone_glow_shader", 1 );
    }

    self chugabud_fake_revive();
    wait 0.1;
    self.ignore_insta_kill = undefined;
    self.disable_chugabud_corpse = undefined;

    if ( create_corpse == 0 )
    {
        self notify( "chugabud_effects_cleanup" );
        return;
    }

    bleedout_time = getdvarfloat( "player_lastStandBleedoutTime" );
    self thread chugabud_bleed_timeout( bleedout_time, corpse );
    self thread chugabud_handle_multiple_instances( corpse );

    corpse waittill( "player_revived", e_reviver );

    if ( isdefined( e_reviver ) && e_reviver == self )
        self notify( "whos_who_self_revive" );

    self perk_abort_drinking( 0.1 );
    self maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg( "health_reboot", 1, 0 );
    self setorigin( corpse.origin );
    self setplayerangles( corpse.angles );

    if ( self player_is_in_laststand() )
    {
        self thread chugabud_laststand_cleanup( corpse, "player_revived" );
        self enableweaponcycling();
        self enableoffhandweapons();
        self auto_revive( self, 1 );
        return;
    }

    self chugabud_laststand_cleanup( corpse, undefined );
}

chugabud_fake_death()
{
    level notify( "fake_death" );
    self notify( "fake_death" );
    self takeallweapons();
    self allowstand( 0 );
    self allowcrouch( 0 );
    self allowprone( 1 );
	self setstance( "prone" );
    self.ignoreme = 1;
    self enableinvulnerability();

	if ( self is_jumping() )
    {
        while ( self is_jumping() )
            wait 0.05;
    }

    self freezecontrols( 1 );
}

chugabud_fake_revive()
{
    level notify( "fake_revive" );
    self notify( "fake_revive" );
    playsoundatposition( "evt_ww_disappear", self.origin );
    playfx( level._effect["chugabud_revive_fx"], self.origin );
    spawnpoint = chugabud_get_spawnpoint();

    if ( isdefined( level._chugabud_post_respawn_override_func ) )
        self [[ level._chugabud_post_respawn_override_func ]]( spawnpoint.origin );

    if ( isdefined( level.chugabud_force_corpse_position ) )
    {
        if ( isdefined( self.e_chugabud_corpse ) )
            self.e_chugabud_corpse forceteleport( level.chugabud_force_corpse_position );

        level.chugabud_force_corpse_position = undefined;
    }

    if ( isdefined( level.chugabud_force_player_position ) )
    {
        spawnpoint.origin = level.chugabud_force_player_position;
        level.chugabud_force_player_position = undefined;
    }

    self setorigin( spawnpoint.origin );
    self setplayerangles( spawnpoint.angles );
    playsoundatposition( "evt_ww_appear", spawnpoint.origin );
    playfx( level._effect["chugabud_revive_fx"], spawnpoint.origin );
    self allowstand( 1 );
    self allowcrouch( 1 );
    self allowprone( 1 );
    self.ignoreme = 0;
    self setstance( "stand" );
    self freezecontrols( 0 );
	self chugabud_give_loadout();
	self seteverhadweaponall( 1 );
    self.score = self.loadout.score;
    self.pers["score"] = self.loadout.score;

    wait 2;

    self disableinvulnerability();
}

chugabud_give_loadout()
{
    self takeallweapons();
    loadout = self.loadout;
    primaries = self getweaponslistprimaries();

    if ( loadout.weapons.size > 1 || primaries.size > 1 )
    {
        foreach ( weapon in primaries )
            self takeweapon( weapon );
    }

	weapons_given = 0;
    for ( i = 0; i < loadout.weapons.size; i++ )
    {
        if ( !isdefined( loadout.weapons[i] ) )
            continue;

        if ( loadout.weapons[i]["name"] == "none" )
            continue;

        self maps\mp\zombies\_zm_weapons::weapondata_give( loadout.weapons[i] );

		weapons_given++;
		if (weapons_given >= 2)
		{
			break;
		}
    }

    if ( loadout.current_weapon >= 0 && isdefined( loadout.weapons[loadout.current_weapon]["name"] ) )
        self switchtoweapon( loadout.weapons[loadout.current_weapon]["name"] );

    self giveweapon( "knife_zm" );
    self maps\mp\zombies\_zm_equipment::equipment_give( self.loadout.equipment );
    loadout restore_weapons_for_chugabud( self );
    self chugabud_restore_claymore();
    self.score = loadout.score;
    self.pers["score"] = loadout.score;
    perk_array = maps\mp\zombies\_zm_perks::get_perk_array( 1 );

    for ( i = 0; i < perk_array.size; i++ )
    {
        perk = perk_array[i];
        self unsetperk( perk );
        self.num_perks--;
        self set_perk_clientfield( perk, 0 );
    }

    self chugabud_restore_grenades();

    if ( maps\mp\zombies\_zm_weap_cymbal_monkey::cymbal_monkey_exists() )
    {
        if ( loadout.zombie_cymbal_monkey_count )
        {
            self maps\mp\zombies\_zm_weap_cymbal_monkey::player_give_cymbal_monkey();
            self setweaponammoclip( "cymbal_monkey_zm", loadout.zombie_cymbal_monkey_count );
        }
    }
}

chugabud_give_perks()
{
	loadout = self.loadout;

	if ( isdefined( loadout.perks ) && loadout.perks.size > 0 )
    {
        for ( i = 0; i < loadout.perks.size; i++ )
        {
            if ( self hasperk( loadout.perks[i] ) )
                continue;

            if ( loadout.perks[i] == "specialty_quickrevive" && flag( "solo_game" ) )
                level.solo_game_free_player_quickrevive = 1;

            if ( loadout.perks[i] == "specialty_finalstand" )
                continue;

            maps\mp\zombies\_zm_perks::give_perk( loadout.perks[i] );
        }
    }
}

chugabud_corpse_revive_icon( player )
{
    self endon( "death" );
    height_offset = 30;
    index = player.clientid;
	self.revive_waypoint_origin = spawn( "script_model", self.origin + (0, 0, height_offset) );
	self.revive_waypoint_origin setmodel( "tag_origin" );
	self.revive_waypoint_origin linkto( self );

    hud_elem = newhudelem();
    self.revive_hud_elem = hud_elem;
    hud_elem.alpha = 1;
    hud_elem.archived = 1;
	hud_elem.hidewheninmenu = 1;
    hud_elem.immunetodemogamehudsettings = 1;
    hud_elem setwaypoint( 1, "specialty_chugabud_zombies" );
	hud_elem settargetent( self.revive_waypoint_origin );
}

chugabud_corpse_cleanup( corpse, was_revived )
{
    self notify( "chugabud_effects_cleanup" );

    if ( was_revived )
    {
        playsoundatposition( "evt_ww_appear", corpse.origin );
        playfx( level._effect["chugabud_revive_fx"], corpse.origin );
    }
    else
    {
        playsoundatposition( "evt_ww_disappear", corpse.origin );
        playfx( level._effect["chugabud_bleedout_fx"], corpse.origin );
        self notify( "chugabud_bleedout" );
    }

    if ( isdefined( corpse.revivetrigger ) )
    {
        corpse notify( "stop_revive_trigger" );
        corpse.revivetrigger delete();
        corpse.revivetrigger = undefined;
    }

    if ( isdefined( corpse.revive_hud_elem ) )
    {
        corpse.revive_hud_elem destroy();
        corpse.revive_hud_elem = undefined;
    }

	if ( isdefined( corpse.revive_waypoint_origin ) )
    {
        corpse.revive_waypoint_origin delete();
        corpse.revive_waypoint_origin = undefined;
    }

    self.loadout = undefined;
    wait 0.1;
    corpse delete();
    self.e_chugabud_corpse = undefined;
}

chugabud_handle_multiple_instances( corpse )
{
    corpse endon( "death" );

	self waittill( "chugabud_handle_multiple_instances" );

	self thread chugabud_laststand_wait( corpse );
    self chugabud_corpse_cleanup( corpse, 0 );
}

chugabud_laststand_wait( corpse )
{
	corpse waittill( "death" );

	self chugabud_laststand();
}

chugabud_corpse_cleanup_on_disconnect( player )
{
	self endon( "death" );

    player waittill( "disconnect" );

	player chugabud_corpse_cleanup( self, 0 );
}

chugabud_laststand_cleanup( corpse, str_notify )
{
    if ( isdefined( str_notify ) )
        self waittill( str_notify );

	self setstance( "stand" );
	self thread chugabud_leave_freeze();
	self thread chugabud_revive_invincible();
	self chugabud_give_perks();
    self chugabud_corpse_cleanup( corpse, 1 );
}

chugabud_leave_freeze()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    self freezecontrols( 1 );

    wait 0.5;

    if ( !is_true( self.hostmigrationcontrolsfrozen ) )
        self freezecontrols( 0 );
}

chugabud_revive_invincible()
{
    self endon( "disconnect" );
	level endon( "end_game" );

	self.health = self.maxhealth;
	self enableinvulnerability();

    wait 2;

    self disableinvulnerability();
}

chugabud_bleed_timeout( delay, corpse )
{
	self endon( "player_suicide" );
	self endon( "disconnect" );
	corpse endon( "death" );

	wait delay;

	if ( isDefined( corpse.revivetrigger ) )
	{
		while ( corpse.revivetrigger.beingrevived )
		{
			wait 0.01;
		}
	}

	self chugabud_corpse_cleanup( corpse, 0 );
}