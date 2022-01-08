#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;

check_quickrevive_for_hotjoin(disconnecting_player)
{
	// always use coop quick revive
}

last_stand_pistol_rank_init()
{
	level.pistol_values = [];
	level.pistol_values[ level.pistol_values.size ] = "m1911_zm";
	level.pistol_values[ level.pistol_values.size ] = "c96_zm";
	level.pistol_values[ level.pistol_values.size ] = "cz75_zm";
	level.pistol_values[ level.pistol_values.size ] = "cz75dw_zm";
	level.pistol_values[ level.pistol_values.size ] = "kard_zm";
	level.pistol_values[ level.pistol_values.size ] = "fiveseven_zm";
	level.pistol_values[ level.pistol_values.size ] = "beretta93r_zm";
	level.pistol_values[ level.pistol_values.size ] = "beretta93r_extclip_zm";
	level.pistol_values[ level.pistol_values.size ] = "fivesevendw_zm";
	level.pistol_values[ level.pistol_values.size ] = "rnma_zm";
	level.pistol_values[ level.pistol_values.size ] = "python_zm";
	level.pistol_values[ level.pistol_values.size ] = "judge_zm";
	level.pistol_values[ level.pistol_values.size ] = "cz75_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "cz75dw_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "kard_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "fiveseven_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "c96_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "beretta93r_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "beretta93r_extclip_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "fivesevendw_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "rnma_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "python_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "judge_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "ray_gun_zm";
	level.pistol_values[ level.pistol_values.size ] = "ray_gun_upgraded_zm";
	level.pistol_value_solo_replace_below = level.pistol_values.size - 1;
	level.pistol_values[ level.pistol_values.size ] = "m1911_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "raygun_mark2_zm";
	level.pistol_values[ level.pistol_values.size ] = "raygun_mark2_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "freezegun_zm";
	level.pistol_values[ level.pistol_values.size ] = "freezegun_upgraded_zm";
	level.pistol_values[ level.pistol_values.size ] = "microwavegundw_zm";
	level.pistol_values[ level.pistol_values.size ] = "microwavegundw_upgraded_zm";
}

actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	if ( !isDefined( self ) || !isDefined( attacker ) )
	{
		return damage;
	}

	if ( weapon == "tazer_knuckles_zm" || weapon == "jetgun_zm" )
	{
		self.knuckles_extinguish_flames = 1;
	}
	else if ( weapon != "none" )
	{
		self.knuckles_extinguish_flames = undefined;
	}

	if ( isDefined( attacker.animname ) && attacker.animname == "quad_zombie" )
	{
		if ( isDefined( self.animname ) && self.animname == "quad_zombie" )
		{
			return 0;
		}
	}

	if ( !isplayer( attacker ) && isDefined( self.non_attacker_func ) )
	{
		if ( is_true( self.non_attack_func_takes_attacker ) )
		{
			return self [[ self.non_attacker_func ]]( damage, weapon, attacker );
		}
		else
		{
			return self [[ self.non_attacker_func ]]( damage, weapon );
		}
	}

	if ( !isplayer( attacker ) && !isplayer( self ) )
	{
		return damage;
	}

	if ( !isDefined( damage ) || !isDefined( meansofdeath ) )
	{
		return damage;
	}

	if ( meansofdeath == "" )
	{
		return damage;
	}

	old_damage = damage;
	final_damage = damage;

	if ( isDefined( self.actor_damage_func ) )
	{
		final_damage = [[ self.actor_damage_func ]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
	}

	if ( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
	{
		attacker = attacker.owner;
	}

	if ( is_true( self.in_water ) )
	{
		if ( int( final_damage ) >= self.health )
		{
			self.water_damage = 1;
		}
	}

	attacker thread maps/mp/gametypes_zm/_weapons::checkhit( weapon );

	if(maps/mp/zombies/_zm_weapons::get_base_weapon_name(weapon, 1) == "saritch_zm")
	{
		final_damage *= 2;
	}

	if(attacker HasPerk("specialty_deadshot") && is_headshot(weapon, shitloc, meansofdeath) && WeaponClass(weapon) != "spread" && WeaponClass(weapon) != "pistol spread")
	{
		final_damage *= 2;
	}

	if ( attacker maps/mp/zombies/_zm_pers_upgrades_functions::pers_mulit_kill_headshot_active() && is_headshot( weapon, shitloc, meansofdeath ) )
	{
		final_damage *= 2;
	}

	if(is_true(level.zombie_vars[attacker.team]["zombie_half_damage"]))
	{
		final_damage /= 2;
	}

	if ( is_true( level.headshots_only ) && isDefined( attacker ) && isplayer( attacker ) )
	{
		if ( meansofdeath == "MOD_MELEE" && shitloc == "head" || meansofdeath == "MOD_MELEE" && shitloc == "helmet" )
		{
			return int( final_damage );
		}

		if ( is_explosive_damage( meansofdeath ) )
		{
			return int( final_damage );
		}
		else if ( !is_headshot( weapon, shitloc, meansofdeath ) )
		{
			return 0;
		}
	}

	return int( final_damage );
}

callback_playerdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	if ( isDefined( eattacker ) && isplayer( eattacker ) && eattacker.sessionteam == self.sessionteam && !eattacker hasperk( "specialty_noname" ) && isDefined( self.is_zombie ) && !self.is_zombie )
	{
		self maps/mp/zombies/_zm::process_friendly_fire_callbacks( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
		if ( self != eattacker )
		{
			return;
		}
		else if ( smeansofdeath != "MOD_GRENADE_SPLASH" && smeansofdeath != "MOD_GRENADE" && smeansofdeath != "MOD_EXPLOSIVE" && smeansofdeath != "MOD_PROJECTILE" && smeansofdeath != "MOD_PROJECTILE_SPLASH" && smeansofdeath != "MOD_BURNED" && smeansofdeath != "MOD_SUICIDE" )
		{
			return;
		}
	}
	if ( is_true( level.pers_upgrade_insta_kill ) )
	{
		self maps/mp/zombies/_zm_pers_upgrades_functions::pers_insta_kill_melee_swipe( smeansofdeath, eattacker );
	}
	if ( isDefined( self.overrideplayerdamage ) )
	{
		idamage = self [[ self.overrideplayerdamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	}
	else if ( isDefined( level.overrideplayerdamage ) )
	{
		idamage = self [[ level.overrideplayerdamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	}
	if ( is_true( self.magic_bullet_shield ) )
	{
		maxhealth = self.maxhealth;
		self.health += idamage;
		self.maxhealth = maxhealth;
	}
	if ( isDefined( self.divetoprone ) && self.divetoprone == 1 )
	{
		if ( smeansofdeath == "MOD_GRENADE_SPLASH" )
		{
			dist = distance2d( vpoint, self.origin );
			if ( dist > 32 )
			{
				dot_product = vectordot( anglesToForward( self.angles ), vdir );
				if ( dot_product > 0 )
				{
					idamage = int( idamage * 0.5 );
				}
			}
		}
	}
	if ( isDefined( level.prevent_player_damage ) )
	{
		if ( self [[ level.prevent_player_damage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime ) )
		{
			return;
		}
	}
	idflags |= level.idflags_no_knockback;
	if ( idamage > 0 && shitloc == "riotshield" )
	{
		shitloc = "torso_upper";
	}

	// remove grenade shellshock
	if(smeansofdeath == "MOD_GRENADE")
	{
		smeansofdeath = "MOD_PROJECTILE";
	}
	else if(smeansofdeath == "MOD_GRENADE_SPLASH")
	{
		smeansofdeath = "MOD_PROJECTILE_SPLASH";
	}

	self maps/mp/zombies/_zm::finishplayerdamagewrapper( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
}

getfreespawnpoint( spawnpoints, player )
{
	if ( !isDefined( spawnpoints ) )
	{
		return undefined;
	}

	spawnpoints = array_randomize( spawnpoints );

	if ( !isDefined( game[ "spawns_randomized" ] ) )
	{
		game[ "spawns_randomized" ] = 1;
		random_chance = randomint( 100 );
		if ( random_chance > 50 )
		{
			set_game_var( "side_selection", 1 );
		}
		else
		{
			set_game_var( "side_selection", 2 );
		}
	}

	side_selection = get_game_var( "side_selection" );
	if ( get_game_var( "switchedsides" ) )
	{
		if ( side_selection == 2 )
		{
			side_selection = 1;
		}
		else
		{
			if ( side_selection == 1 )
			{
				side_selection = 2;
			}
		}
	}

	if(!is_true(self.team_set))
	{
		self waittill("team_set");
	}

	if ( isdefined( player ) && isdefined( player.team ) )
	{
		i = 0;
		while ( isdefined( spawnpoints ) && i < spawnpoints.size )
		{
			if ( side_selection == 1 )
			{
				if ( player.team != "allies" && isdefined( spawnpoints[ i ].script_int ) && spawnpoints[ i ].script_int == 1 )
				{
					arrayremovevalue( spawnpoints, spawnpoints[ i ] );
					i = 0;
				}
				else if ( player.team == "allies" && isdefined( spawnpoints[ i ].script_int) && spawnpoints[ i ].script_int == 2 )
				{
					arrayremovevalue( spawnpoints, spawnpoints[ i ] );
					i = 0;
				}
				else
				{
					i++;
				}
			}
			else
			{
				if ( player.team == "allies" && isdefined( spawnpoints[ i ].script_int ) && spawnpoints[ i ].script_int == 1 )
				{
					arrayremovevalue(spawnpoints, spawnpoints[i]);
					i = 0;
				}
				else if ( player.team != "allies" && isdefined( spawnpoints[ i ].script_int ) && spawnpoints[ i ].script_int == 2 )
				{
					arrayremovevalue( spawnpoints, spawnpoints[ i ] );
					i = 0;
				}
				else
				{
					i++;
				}
			}
		}
	}

	if ( !isdefined( self.playernum ) )
	{
		num = 0;
		players = get_players();

		for(num = 0; num < 4; num++)
		{
			valid_num = true;

			foreach(player in players)
			{
				if(player != self && isDefined(player.team_set) && player.team == self.team && player.playernum == num)
				{
					valid_num = false;
					break;
				}
			}

			if(valid_num)
			{
				break;
			}
		}

		self.playernum = num;
	}

	for ( j = 0; j < spawnpoints.size; j++ )
	{
		if ( !isdefined( game[ self.team + "_spawnpoints_randomized" ] ) )
		{
			game[ self.team + "_spawnpoints_randomized" ] = 1;

			for ( m = 0; m < spawnpoints.size; m++ )
			{
				spawnpoints[ m ].en_num = m;
			}
		}

		if ( spawnpoints[ j ].en_num == self.playernum )
		{
			return spawnpoints[ j ];
		}
	}

	return spawnpoints[ 0 ];
}

wait_and_revive()
{
	flag_set( "wait_and_revive" );
	if ( isDefined( self.waiting_to_revive ) && self.waiting_to_revive == 1 )
	{
		return;
	}
	if ( is_true( self.pers_upgrades_awarded[ "perk_lose" ] ) )
	{
		self maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}
	self.waiting_to_revive = 1;
	if ( isDefined( level.exit_level_func ) )
	{
		self thread [[ level.exit_level_func ]]();
	}
	else if ( get_players().size == 1 )
	{
		self thread maps/mp/zombies/_zm::default_exit_level();
	}
	solo_revive_time = 10;
	self.revive_hud settext( &"ZOMBIE_REVIVING_SOLO", self );
	self maps/mp/zombies/_zm_laststand::revive_hud_show_n_fade( solo_revive_time );
	if ( !isDefined( self.beingrevivedprogressbar ) )
	{
		self.beingrevivedprogressbar = self createprimaryprogressbar();
        self.beingrevivedprogressbar setpoint(undefined, "CENTER", level.primaryprogressbarx, -1 * level.primaryprogressbary);
        self.beingrevivedprogressbar.bar.color = (0.5, 0.5, 1);
        self.beingrevivedprogressbar.hidewheninmenu = 1;
        self.beingrevivedprogressbar.bar.hidewheninmenu = 1;
        self.beingrevivedprogressbar.barframe.hidewheninmenu = 1;
	}
	self.beingrevivedprogressbar updatebar( 0.01, 1 / solo_revive_time );
	flag_wait_or_timeout( "instant_revive", solo_revive_time );
	if ( flag( "instant_revive" ) )
	{
		self maps/mp/zombies/_zm_laststand::revive_hud_show_n_fade( 1 );
	}
	if ( isDefined( self.beingrevivedprogressbar ) )
	{
		self.beingrevivedprogressbar destroyelem();
	}
	flag_clear( "wait_and_revive" );
	self maps/mp/zombies/_zm_laststand::auto_revive( self );
	self.lives--;

	self.waiting_to_revive = 0;
	if ( is_true( self.pers_upgrades_awarded[ "perk_lose" ] ) )
	{
		self thread maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_perk_lose_restore();
	}
}

end_game()
{
	level waittill( "end_game" );
	maps/mp/zombies/_zm::check_end_game_intermission_delay();
	clientnotify( "zesn" );
	if ( isDefined( level.sndgameovermusicoverride ) )
	{
		level thread maps/mp/zombies/_zm_audio::change_zombie_music( level.sndgameovermusicoverride );
	}
	else
	{
		level thread maps/mp/zombies/_zm_audio::change_zombie_music( "game_over" );
	}
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		setclientsysstate( "lsm", "0", players[ i ] );
	}
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ] maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
		{
			players[ i ] recordplayerdeathzombies();
			players[ i ] maps/mp/zombies/_zm_stats::increment_player_stat( "deaths" );
			players[ i ] maps/mp/zombies/_zm_stats::increment_client_stat( "deaths" );
			players[ i ] maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
		}
		if ( isdefined( players[ i ].revivetexthud) )
		{
			players[ i ].revivetexthud destroy();
		}
	}
	stopallrumbles();
	level.intermission = 1;
	level.zombie_vars[ "zombie_powerup_insta_kill_time" ] = 0;
	level.zombie_vars[ "zombie_powerup_fire_sale_time" ] = 0;
	level.zombie_vars[ "zombie_powerup_point_doubler_time" ] = 0;
	wait 0.1;
	game_over = [];
	survived = [];
	players = get_players();
	if ( !isDefined( level._supress_survived_screen ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( isDefined( level.custom_game_over_hud_elem ) )
			{
				game_over[ i ] = [[ level.custom_game_over_hud_elem ]]( players[ i ] );
			}
			else
			{
				game_over[ i ] = newclienthudelem( players[ i ] );
				game_over[ i ].alignx = "center";
				game_over[ i ].aligny = "middle";
				game_over[ i ].horzalign = "center";
				game_over[ i ].vertalign = "middle";
				game_over[ i ].y -= 130;
				game_over[ i ].foreground = 1;
				game_over[ i ].fontscale = 3;
				game_over[ i ].alpha = 0;
				game_over[ i ].color = ( 1, 1, 1 );
				game_over[ i ].hidewheninmenu = 1;
				game_over[ i ] settext( &"ZOMBIE_GAME_OVER" );
				game_over[ i ] fadeovertime( 1 );
				game_over[ i ].alpha = 1;
			}
			survived[ i ] = newclienthudelem( players[ i ] );
			survived[ i ].alignx = "center";
			survived[ i ].aligny = "middle";
			survived[ i ].horzalign = "center";
			survived[ i ].vertalign = "middle";
			survived[ i ].y -= 100;
			survived[ i ].foreground = 1;
			survived[ i ].fontscale = 2;
			survived[ i ].alpha = 0;
			survived[ i ].color = ( 1, 1, 1 );
			survived[ i ].hidewheninmenu = 1;

			if ( level.round_number < 2 )
			{
				if ( level.script == "zombie_moon" )
				{
					if ( !isDefined( level.left_nomans_land ) )
					{
						nomanslandtime = level.nml_best_time;
						player_survival_time = int( nomanslandtime / 1000 );
						player_survival_time_in_mins = maps/mp/zombies/_zm::to_mins( player_survival_time );
						survived[ i ] settext( &"ZOMBIE_SURVIVED_NOMANS", player_survival_time_in_mins );
					}
					else if ( level.left_nomans_land == 2 )
					{
						survived[ i ] settext( &"ZOMBIE_SURVIVED_ROUND" );
					}
				}
				else
				{
					survived[ i ] settext( &"ZOMBIE_SURVIVED_ROUND" );
				}
			}
			else
			{
				survived[ i ] settext( &"ZOMBIE_SURVIVED_ROUNDS", level.round_number );
			}
			survived[ i ] fadeovertime( 1 );
			survived[ i ].alpha = 1;
		}
	}
	if ( isDefined( level.custom_end_screen ) )
	{
		level [[ level.custom_end_screen ]]();
	}
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] setclientammocounterhide( 1 );
		players[ i ] setclientminiscoreboardhide( 1 );
	}
	uploadstats();
	maps/mp/zombies/_zm_stats::update_players_stats_at_match_end( players );
	maps/mp/zombies/_zm_stats::update_global_counters_on_match_end();
	wait 1;
	wait 3.95;
	players = get_players();
	foreach ( player in players )
	{
		if ( isdefined( player.sessionstate ) && player.sessionstate == "spectator" )
		{
			player.sessionstate = "playing";
		}
	}
	wait 0.05;
	players = get_players();
	if ( !isDefined( level._supress_survived_screen ) )
	{
		for(i = 0; i < players.size; i++)
		{
			survived[ i ] destroy();
			game_over[ i ] destroy();
		}
	}
	for ( i = 0; i < players.size; i++ )
	{
		if ( isDefined( players[ i ].survived_hud ) )
		{
			players[ i ].survived_hud destroy();
		}
		if ( isDefined( players[ i ].game_over_hud ) )
		{
			players[ i ].game_over_hud destroy();
		}
	}
	maps/mp/zombies/_zm::intermission();
	wait level.zombie_vars[ "zombie_intermission_time" ];
	level notify( "stop_intermission" );
	array_thread( get_players(), maps/mp/zombies/_zm::player_exit_level );
	bbprint( "zombie_epilogs", "rounds %d", level.round_number );
	wait 1.5;
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ] cameraactivate( 0 );
	}
	exitlevel( 0 );
	wait 666;
}