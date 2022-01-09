#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

full_ammo_powerup( drop_item, player )
{
	players = get_players( player.team );
	if ( isdefined( level._get_game_module_players ) )
	{
		players = [[ level._get_game_module_players ]]( player );
	}
	i = 0;
	while ( i < players.size )
	{
		if ( players[ i ] maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
		{
			i++;
			continue;
		}
		primary_weapons = players[ i ] getweaponslist( 1 );
		players[ i ] notify( "zmb_max_ammo" );
		players[ i ] notify( "zmb_lost_knife" );
		players[ i ] notify( "zmb_disable_claymore_prompt" );
		players[ i ] notify( "zmb_disable_spikemore_prompt" );
		x = 0;
		while ( x < primary_weapons.size )
		{
			if ( level.headshots_only && is_lethal_grenade(primary_weapons[ x ] ) )
			{
				x++;
				continue;
			}
			if ( isdefined( level.zombie_include_equipment ) && isdefined( level.zombie_include_equipment[ primary_weapons[ x ] ] ) )
			{
				x++;
				continue;
			}
			if ( isdefined( level.zombie_weapons_no_max_ammo ) && isdefined( level.zombie_weapons_no_max_ammo[ primary_weapons[ x ] ] ) )
			{
				x++;
				continue;
			}
			if ( players[ i ] hasweapon( primary_weapons[ x ] ) )
			{
				players[ i ] givemaxammo( primary_weapons[ x ] );
			}
			x++;
		}
		i++;
	}
	level thread maps/mp/zombies/_zm_powerups::full_ammo_on_hud( drop_item, player.team );

	if(level.scr_zm_ui_gametype == "zgrief")
	{
		level thread empty_clip_powerup( drop_item, player );
	}
}

empty_clip_powerup( drop_item, player )
{
	team = getOtherTeam(player.team);

	i = 0;
	players = get_players(team);
	while(i < players.size)
	{
		if ( players[ i ] maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
		{
			i++;
			continue;
		}

		primaries = players[i] getweaponslistprimaries();
		foreach(weapon in primaries)
		{
			dual_wield_weapon = weaponDualWieldWeaponName(weapon);
			alt_weapon = weaponAltWeaponName(weapon);

			// setweaponammoclip on dual wield weapons only works right when the weapon is given, wtf
			if(dual_wield_weapon != "none")
			{
				stock_ammo = players[i] getweaponammostock(weapon, 0);
				stock_ammo_alt = players[i] getweaponammostock(alt_weapon, 0);
				players[i] takeweapon(weapon);
				players[i] giveweapon(weapon, 0, players[i] maps/mp/zombies/_zm_weapons::get_pack_a_punch_weapon_options(weapon));
				players[i] setweaponammostock(weapon, stock_ammo);
				players[i] setweaponammostock(alt_weapon, stock_ammo_alt);
				players[i] setweaponammoclip(dual_wield_weapon, 0);
			}

			players[i] setweaponammoclip(weapon, 0);
			players[i] setweaponammoclip(alt_weapon, 0);
		}

		i++;
	}

	level thread empty_clip_on_hud( drop_item, team );
}

empty_clip_on_hud( drop_item, team )
{
	self endon( "disconnect" );
	hudelem = maps/mp/gametypes_zm/_hud_util::createserverfontstring( "objective", 2, team );
	hudelem maps/mp/gametypes_zm/_hud_util::setpoint( "TOP", undefined, 0, level.zombie_vars[ "zombie_timer_offset" ] - ( level.zombie_vars[ "zombie_timer_offset_interval" ] * 2 ) );
	hudelem.sort = 0.5;
	hudelem.color = (0.21, 0, 0);
	hudelem.alpha = 0;
	hudelem fadeovertime( 0.5 );
	hudelem.alpha = 1;
	hudelem.label = &"Empty Clip!";
	hudelem thread empty_clip_move_hud( team );
}

empty_clip_move_hud( team )
{
	wait 0.5;
	move_fade_time = 1.5;
	self fadeovertime( move_fade_time );
	self moveovertime( move_fade_time );
	self.y = 270;
	self.alpha = 0;
	wait move_fade_time;
	self destroy();
}

nuke_powerup( drop_item, player_team )
{
	location = drop_item.origin;
	playfx( drop_item.fx, location );
	level thread maps/mp/zombies/_zm_powerups::nuke_flash( player_team );
	wait 0.5;
	zombies = getaiarray( level.zombie_team );
	zombies = arraysort( zombies, location );
	zombies_nuked = [];
	i = 0;
	while ( i < zombies.size )
	{
		if ( is_true( zombies[ i ].ignore_nuke ) )
		{
			i++;
			continue;
		}
		if ( is_true( zombies[ i ].marked_for_death ) )
		{
			i++;
			continue;
		}
		if ( isdefined( zombies[ i ].nuke_damage_func ) )
		{
			zombies[ i ] thread [[ zombies[ i ].nuke_damage_func ]]();
			i++;
			continue;
		}
		if ( is_magic_bullet_shield_enabled( zombies[ i ] ) )
		{
			i++;
			continue;
		}
		zombies[ i ].marked_for_death = 1;
		//imported from bo3 _zm_powerup_nuke.gsc
		if ( !zombies[ i ].nuked && !is_magic_bullet_shield_enabled( zombies[ i ] ) )
		{
			zombies[ i ].nuked = 1;
			zombies_nuked[ zombies_nuked.size ] = zombies[ i ];
		}
		i++;
	}
	i = 0;
	while ( i < zombies_nuked.size )
	{
		if ( !isdefined( zombies_nuked[ i ] ) )
		{
			i++;
			continue;
		}
		if ( is_magic_bullet_shield_enabled( zombies_nuked[ i ] ) )
		{
			i++;
			continue;
		}
		if ( i < 5 && !zombies_nuked[ i ].isdog )
		{
			zombies_nuked[ i ] thread maps/mp/animscripts/zm_death::flame_death_fx();
		}
		if ( !zombies_nuked[ i ].isdog )
		{
			if ( !is_true( zombies_nuked[ i ].no_gib ) )
			{
				zombies_nuked[ i ] maps/mp/zombies/_zm_spawner::zombie_head_gib();
			}
			zombies_nuked[ i ] playsound("evt_nuked");
		}
		zombies_nuked[ i ] dodamage(zombies_nuked[i].health + 666, zombies_nuked[ i ].origin );
		i++;
	}
	players = get_players( player_team );
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] maps/mp/zombies/_zm_score::player_add_points( "nuke_powerup", 400 );
	}

	if(level.scr_zm_ui_gametype == "zgrief")
	{
		players = get_players(getOtherTeam(player_team));
		for(i = 0; i < players.size; i++)
		{
			if(is_player_valid(players[i]))
			{
				radiusDamage(players[i].origin, 10, 80, 80);
			}
		}
	}
}

insta_kill_powerup( drop_item, player )
{
	if ( isDefined( level.insta_kill_powerup_override ) )
	{
		level thread [[ level.insta_kill_powerup_override ]]( drop_item, player );
		return;
	}

	if ( is_classic() )
	{
		player thread maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_insta_kill_upgrade_check();
	}

	team = player.team;

	if(level.scr_zm_ui_gametype == "zgrief")
	{
		level thread half_damage_powerup( drop_item, player );
	}

	if ( level.zombie_vars[ team ][ "zombie_powerup_insta_kill_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_insta_kill_time" ] += 30;
		return;
	}

	temp_enta = spawn( "script_origin", ( 0, 0, 0 ) );
	temp_enta playloopsound( "zmb_insta_kill_loop" );

	level.zombie_vars[ team ][ "zombie_insta_kill" ] = 1;
	level.zombie_vars[ team ][ "zombie_powerup_insta_kill_on" ] = 1;

	while ( level.zombie_vars[ team ][ "zombie_powerup_insta_kill_time" ] >= 0 )
	{
		wait 0.05;
		level.zombie_vars[ team ][ "zombie_powerup_insta_kill_time" ] -= 0.05;
	}

	level.zombie_vars[ team ][ "zombie_insta_kill" ] = 0;
	level.zombie_vars[ team ][ "zombie_powerup_insta_kill_on" ] = 0;
	level.zombie_vars[ team ][ "zombie_powerup_insta_kill_time" ] = 30;

	get_players()[ 0 ] playsoundtoteam( "zmb_insta_kill", team );
	temp_enta stoploopsound( 2 );
	temp_enta delete();

	players = get_players( team );
	i = 0;
	while ( i < players.size )
	{
		if ( isDefined( players[ i ] ) )
		{
			players[ i ] notify( "insta_kill_over" );
		}
		i++;
	}
}

half_damage_powerup( drop_item, player )
{
	team = getOtherTeam(player.team);

	if ( level.zombie_vars[ team ][ "zombie_powerup_half_damage_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_half_damage_time" ] += 30;
		return;
	}

	level.zombie_vars[ team ][ "zombie_half_damage" ] = 1;
	level.zombie_vars[ team ][ "zombie_powerup_half_damage_on" ] = 1;

	while ( level.zombie_vars[ team ][ "zombie_powerup_half_damage_time" ] >= 0 )
	{
		wait 0.05;
		level.zombie_vars[ team ][ "zombie_powerup_half_damage_time" ] -= 0.05;
	}

	level.zombie_vars[ team ][ "zombie_half_damage" ] = 0;
	level.zombie_vars[ team ][ "zombie_powerup_half_damage_on" ] = 0;
	level.zombie_vars[ team ][ "zombie_powerup_half_damage_time" ] = 30;
}

double_points_powerup( drop_item, player )
{
	team = player.team;

	if(level.scr_zm_ui_gametype == "zgrief")
	{
		level thread half_points_powerup( drop_item, player );
	}

	if ( level.zombie_vars[ team ][ "zombie_powerup_point_doubler_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_point_doubler_time" ] += 30;
		return;
	}

	if ( is_true( level.pers_upgrade_double_points ) )
	{
		player thread maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_double_points_pickup_start();
	}

	if ( isDefined( level.current_game_module ) && level.current_game_module == 2 )
	{
		if ( isDefined( player._race_team ) )
		{
			if ( player._race_team == 1 )
			{
				level._race_team_double_points = 1;
			}
			else
			{
				level._race_team_double_points = 2;
			}
		}
	}

	players = get_players( team );
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] setclientfield( "score_cf_double_points_active", 1 );
	}

	temp_ent = spawn( "script_origin", ( 0, 0, 0 ) );
	temp_ent playloopsound( "zmb_double_point_loop" );

	level.zombie_vars[ team ][ "zombie_point_scalar" ] *= 2;
	level.zombie_vars[ team ][ "zombie_powerup_point_doubler_on" ] = 1;

	while ( level.zombie_vars[ team ][ "zombie_powerup_point_doubler_time" ] >= 0 )
	{
		wait 0.05;
		level.zombie_vars[ team ][ "zombie_powerup_point_doubler_time" ] -= 0.05;
	}

	level.zombie_vars[ team ][ "zombie_point_scalar" ] /= 2;
	level.zombie_vars[ team ][ "zombie_powerup_point_doubler_on" ] = 0;
	level.zombie_vars[ team ][ "zombie_powerup_point_doubler_time" ] = 30;

	temp_ent stoploopsound( 2 );
	temp_ent delete();

	players = get_players( team );
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] playsound( "zmb_points_loop_off" );
		players[ i ] setclientfield( "score_cf_double_points_active", 0 );
	}

	level._race_team_double_points = undefined;
}

half_points_powerup( drop_item, player )
{
	team = getOtherTeam(player.team);

	if ( level.zombie_vars[ team ][ "zombie_powerup_point_halfer_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_point_halfer_time" ] += 30;
		return;
	}

	level.zombie_vars[ team ][ "zombie_point_scalar" ] /= 2;
	level.zombie_vars[ team ][ "zombie_powerup_point_halfer_on" ] = 1;

	while ( level.zombie_vars[ team ][ "zombie_powerup_point_halfer_time" ] >= 0 )
	{
		wait 0.05;
		level.zombie_vars[ team ][ "zombie_powerup_point_halfer_time" ] -= 0.05;
	}

	level.zombie_vars[ team ][ "zombie_point_scalar" ] *= 2;
	level.zombie_vars[ team ][ "zombie_powerup_point_halfer_on" ] = 0;
	level.zombie_vars[ team ][ "zombie_powerup_point_halfer_time" ] = 30;
}