#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

get_next_powerup()
{
    powerup = level.zombie_powerup_array[level.zombie_powerup_index];
    level.zombie_powerup_index++;

    if ( level.zombie_powerup_index >= level.zombie_powerup_array.size )
    {
        level.zombie_powerup_index = 0;
        randomize_powerups();
		level thread play_fx_on_powerup_dropped();
    }

    return powerup;
}

play_fx_on_powerup_dropped()
{
	level waittill( "powerup_dropped", powerup );

	if ( powerup.solo )
	{
		playfx( level._effect["powerup_grabbed_solo"], powerup.origin );
		playfx( level._effect["powerup_grabbed_wave_solo"], powerup.origin );
	}
	else if ( powerup.caution )
	{
		playfx( level._effect["powerup_grabbed_caution"], powerup.origin );
		playfx( level._effect["powerup_grabbed_wave_caution"], powerup.origin );
	}
	else
	{
		playfx( level._effect["powerup_grabbed"], powerup.origin );
		playfx( level._effect["powerup_grabbed_wave"], powerup.origin );
	}
}

powerup_grab( powerup_team )
{
    if ( isdefined( self ) && self.zombie_grabbable )
    {
        self thread powerup_zombie_grab( powerup_team );
        return;
    }

    self endon( "powerup_timedout" );
    self endon( "powerup_grabbed" );
    range_squared = 4096;

    while ( isdefined( self ) )
    {
        players = array_randomize(get_players());

        for ( i = 0; i < players.size; i++ )
        {
            if ( ( self.powerup_name == "minigun" || self.powerup_name == "tesla" || self.powerup_name == "random_weapon" || self.powerup_name == "meat_stink" ) && ( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() || players[i] usebuttonpressed() && players[i] in_revive_trigger() ) )
                continue;

            if ( isdefined( self.can_pick_up_in_last_stand ) && !self.can_pick_up_in_last_stand && players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
                continue;

			if ( players[i].sessionstate != "playing" )
				continue;

            ignore_range = 0;

            if ( isdefined( players[i].ignore_range_powerup ) && players[i].ignore_range_powerup == self )
            {
                players[i].ignore_range_powerup = undefined;
                ignore_range = 1;
            }

            if ( distancesquared( players[i] getCentroid(), self.origin ) < range_squared || ignore_range )
            {
                if ( isdefined( level._powerup_grab_check ) )
                {
                    if ( !self [[ level._powerup_grab_check ]]( players[i] ) )
                        continue;
                }

                if ( isdefined( level.zombie_powerup_grab_func ) )
                    level thread [[ level.zombie_powerup_grab_func ]]();
                else
                {
                    switch ( self.powerup_name )
                    {
                        case "nuke":
                            level thread nuke_powerup( self, players[i].team );
                            players[i] thread powerup_vo( "nuke" );
                            zombies = getaiarray( level.zombie_team );
                            players[i].zombie_nuked = arraysort( zombies, self.origin );
                            players[i] notify( "nuke_triggered" );
                            break;
                        case "full_ammo":
                            level thread full_ammo_powerup( self, players[i] );
                            players[i] thread powerup_vo( "full_ammo" );
                            break;
                        case "double_points":
                            level thread double_points_powerup( self, players[i] );
                            players[i] thread powerup_vo( "double_points" );
                            break;
                        case "insta_kill":
                            level thread insta_kill_powerup( self, players[i] );
                            players[i] thread powerup_vo( "insta_kill" );
                            break;
                        case "carpenter":
                            if ( is_classic() )
                                players[i] thread maps\mp\zombies\_zm_pers_upgrades::persistent_carpenter_ability_check();

                            if ( isdefined( level.use_new_carpenter_func ) )
                                level thread [[ level.use_new_carpenter_func ]]( self.origin );
                            else
                                level thread start_carpenter( self.origin );

                            players[i] thread powerup_vo( "carpenter" );
                            break;
                        case "fire_sale":
                            level thread start_fire_sale( self );
                            players[i] thread powerup_vo( "firesale" );
                            break;
                        case "bonfire_sale":
                            level thread start_bonfire_sale( self );
                            players[i] thread powerup_vo( "firesale" );
                            break;
                        case "minigun":
                            level thread minigun_weapon_powerup( players[i] );
                            players[i] thread powerup_vo( "minigun" );
                            break;
                        case "free_perk":
                            level thread free_perk_powerup( self );
                            break;
                        case "tesla":
                            level thread tesla_weapon_powerup( players[i] );
                            players[i] thread powerup_vo( "tesla" );
                            break;
                        case "random_weapon":
                            if ( !level random_weapon_powerup( self, players[i] ) )
                                continue;
                            break;
                        case "bonus_points_player":
                            level thread bonus_points_player_powerup( self, players[i] );
                            players[i] thread powerup_vo( "bonus_points_solo" );
                            break;
                        case "bonus_points_team":
                            level thread bonus_points_team_powerup( self );
                            players[i] thread powerup_vo( "bonus_points_team" );
                            break;
                        case "teller_withdrawl":
                            level thread teller_withdrawl( self, players[i] );
                            break;
                        default:
                            if ( isdefined( level._zombiemode_powerup_grab ) )
                                level thread [[ level._zombiemode_powerup_grab ]]( self, players[i] );
                            break;
                    }
                }

                maps\mp\_demo::bookmark( "zm_player_powerup_grabbed", gettime(), players[i] );

                if ( should_award_stat( self.powerup_name ) )
                {
                    players[i] maps\mp\zombies\_zm_stats::increment_client_stat( "drops" );
                    players[i] maps\mp\zombies\_zm_stats::increment_player_stat( "drops" );
                    players[i] maps\mp\zombies\_zm_stats::increment_client_stat( self.powerup_name + "_pickedup" );
                    players[i] maps\mp\zombies\_zm_stats::increment_player_stat( self.powerup_name + "_pickedup" );
                }

                if ( self.solo )
                {
                    playfx( level._effect["powerup_grabbed_solo"], self.origin );
                    playfx( level._effect["powerup_grabbed_wave_solo"], self.origin );
                }
                else if ( self.caution )
                {
                    playfx( level._effect["powerup_grabbed_caution"], self.origin );
                    playfx( level._effect["powerup_grabbed_wave_caution"], self.origin );
                }
                else
                {
                    playfx( level._effect["powerup_grabbed"], self.origin );
                    playfx( level._effect["powerup_grabbed_wave"], self.origin );
                }

                if ( isdefined( self.stolen ) && self.stolen )
                    level notify( "monkey_see_monkey_dont_achieved" );

                if ( isdefined( self.grabbed_level_notify ) )
                    level notify( self.grabbed_level_notify );

                self.claimed = 1;
                self.power_up_grab_player = players[i];
                wait 0.1;
                playsoundatposition( "zmb_powerup_grabbed", self.origin );
                self stoploopsound();
                self hide();

                if ( self.powerup_name != "fire_sale" )
                {
                    if ( isdefined( self.power_up_grab_player ) )
                    {
                        if ( isdefined( level.powerup_intro_vox ) )
                        {
                            level thread [[ level.powerup_intro_vox ]]( self );
                            return;
                        }
                        else if ( isdefined( level.powerup_vo_available ) )
                        {
                            can_say_vo = [[ level.powerup_vo_available ]]();

                            if ( !can_say_vo )
                            {
                                self powerup_delete();
                                self notify( "powerup_grabbed" );
                                return;
                            }
                        }
                    }
                }

                level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog( self.powerup_name, self.power_up_grab_player.pers["team"] );
                self powerup_delete();
                self notify( "powerup_grabbed" );
            }
        }

        wait 0.1;
    }
}

full_ammo_powerup( drop_item, player )
{
	clip_only = 0;
	if(level.scr_zm_ui_gametype == "zgrief")
	{
		clip_only = 1;
		drop_item.hint = &"Clip Ammo!";
	}

	players = get_players( player.team );
	if ( isdefined( level._get_game_module_players ) )
	{
		players = [[ level._get_game_module_players ]]( player );
	}
	i = 0;
	while ( i < players.size )
	{
		if ( players[ i ] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
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
				if(clip_only)
				{
					new_ammo = players[i] getWeaponAmmoStock(primary_weapons[x]) + weaponClipSize(primary_weapons[x]);
					if(weaponDualWieldWeaponName(primary_weapons[x]) != "none")
					{
						new_ammo += weaponClipSize(weaponDualWieldWeaponName(primary_weapons[x]));
					}

					if(new_ammo > weaponMaxAmmo(primary_weapons[x]))
					{
						new_ammo = weaponMaxAmmo(primary_weapons[x]);
					}

					players[i] setWeaponAmmoStock(primary_weapons[x], new_ammo);
				}
				else
				{
					players[i] givemaxammo(primary_weapons[x]);
				}

				players[i] scripts\zm\_zm_reimagined::change_weapon_ammo(primary_weapons[x]);
			}
			x++;
		}
		i++;
	}
	level thread maps\mp\zombies\_zm_powerups::full_ammo_on_hud( drop_item, player.team );

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
		if ( players[ i ] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
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
				players[i] giveweapon(weapon, 0, players[i] maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(weapon));
				players[i] setweaponammostock(weapon, stock_ammo);
				players[i] setweaponammostock(alt_weapon, stock_ammo_alt);
				players[i] setweaponammoclip(dual_wield_weapon, 0);
			}

			players[i] setweaponammoclip(weapon, 0);
			players[i] setweaponammoclip(alt_weapon, 0);
		}

		players[i] setweaponammoclip(players[i] get_player_lethal_grenade(), 0);
		players[i] setweaponammoclip(players[i] get_player_tactical_grenade(), 0);
		players[i] setweaponammoclip(players[i] get_player_placeable_mine(), 0);

		i++;
	}

	level thread empty_clip_on_hud( drop_item, team );
}

empty_clip_on_hud( drop_item, team )
{
	self endon( "disconnect" );
	hudelem = maps\mp\gametypes_zm\_hud_util::createserverfontstring( "objective", 2, team );
	hudelem maps\mp\gametypes_zm\_hud_util::setpoint( "TOP", undefined, 0, level.zombie_vars[ "zombie_timer_offset" ] - ( level.zombie_vars[ "zombie_timer_offset_interval" ] * 2 ) );
	hudelem.sort = 0.5;
	hudelem.color = (0.21, 0, 0);
	hudelem.alpha = 0;
	hudelem fadeovertime( 0.5 );
	hudelem.alpha = 1;
	hudelem.label = &"Clip Empty!";
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
	player = getClosest(location, get_players(player_team));
	playfx( drop_item.fx, location );
	level thread maps\mp\zombies\_zm_powerups::nuke_flash( player_team );
	wait 0.5;
	zombies = getaiarray( level.zombie_team );
	zombies = arraysort( zombies, location );
	zombies_nuked = [];

	for ( i = 0; i < zombies.size; i++ )
    {
        if ( isdefined( zombies[i].ignore_nuke ) && zombies[i].ignore_nuke )
            continue;

        if ( isdefined( zombies[i].marked_for_death ) && zombies[i].marked_for_death )
            continue;

        if ( isdefined( zombies[i].nuke_damage_func ) )
        {
            zombies[i] thread [[ zombies[i].nuke_damage_func ]]();
            continue;
        }

        if ( is_magic_bullet_shield_enabled( zombies[i] ) )
            continue;

        zombies[i].marked_for_death = 1;
        zombies[i].nuked = 1;
        zombies_nuked[zombies_nuked.size] = zombies[i];
    }

	for ( i = 0; i < zombies_nuked.size; i++ )
    {
        if ( !isdefined( zombies_nuked[i] ) )
            continue;

        if ( is_magic_bullet_shield_enabled( zombies_nuked[i] ) )
            continue;

        if ( i < 5 && !zombies_nuked[i].isdog )
            zombies_nuked[i] thread maps\mp\animscripts\zm_death::flame_death_fx();

        if ( !zombies_nuked[i].isdog )
        {
            if ( !( isdefined( zombies_nuked[i].no_gib ) && zombies_nuked[i].no_gib ) )
                zombies_nuked[i] maps\mp\zombies\_zm_spawner::zombie_head_gib();

            zombies_nuked[i] playsound( "evt_nuked" );
        }

		zombies_nuked[i].deathpoints_already_given = 1;
		zombies_nuked[i] dodamage( zombies_nuked[i].health + 666, zombies_nuked[i].origin, player, player, "none", "MOD_UNKNOWN", 0, "none" );
    }

	players = get_players( player_team );
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] maps\mp\zombies\_zm_score::player_add_points( "nuke_powerup", 400 );
	}

	if(level.scr_zm_ui_gametype == "zgrief")
	{
		players = get_players(getOtherTeam(player_team));
		for(i = 0; i < players.size; i++)
		{
			if(is_player_valid(players[i]))
			{
				score = 400 * maps\mp\zombies\_zm_score::get_points_multiplier(player);

				if(players[i].score < score)
				{
					players[i] maps\mp\zombies\_zm_score::minus_to_player_score(players[i].score);
				}
				else
				{
					players[i] maps\mp\zombies\_zm_score::minus_to_player_score(score);
				}

				radiusDamage(players[i].origin + (0, 0, 5), 10, 80, 80);
			}
			else if(players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				if (isDefined(level.player_suicide_func))
				{
					players[i] thread [[level.player_suicide_func]]();
				}
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
		player thread maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_insta_kill_upgrade_check();
	}

	team = player.team;

	time = 30;
	if(level.scr_zm_ui_gametype == "zgrief")
	{
		time = 15;
		level thread half_damage_powerup( drop_item, player );
	}

	if ( level.zombie_vars[ team ][ "zombie_powerup_insta_kill_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_insta_kill_time" ] += time;
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
	level.zombie_vars[ team ][ "zombie_powerup_insta_kill_time" ] = time;

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

	time = 15;

	if ( level.zombie_vars[ team ][ "zombie_powerup_half_damage_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_half_damage_time" ] += time;
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
	level.zombie_vars[ team ][ "zombie_powerup_half_damage_time" ] = time;
}

double_points_powerup( drop_item, player )
{
	team = player.team;

	time = 30;
	if(level.scr_zm_ui_gametype == "zgrief")
	{
		time = 15;
		level thread half_points_powerup( drop_item, player );
	}

	if ( level.zombie_vars[ team ][ "zombie_powerup_point_doubler_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_point_doubler_time" ] += time;
		return;
	}

	if ( is_true( level.pers_upgrade_double_points ) )
	{
		player thread maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_double_points_pickup_start();
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
	level.zombie_vars[ team ][ "zombie_powerup_point_doubler_time" ] = time;

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

	time = 15;

	if ( level.zombie_vars[ team ][ "zombie_powerup_point_halfer_on" ] )
	{
		level.zombie_vars[ team ][ "zombie_powerup_point_halfer_time" ] += time;
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
	level.zombie_vars[ team ][ "zombie_powerup_point_halfer_time" ] = time;
}