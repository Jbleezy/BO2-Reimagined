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

	if ( weapon == "zombie_bullet_crouch_zm" && meansofdeath == "MOD_RIFLE_BULLET" )
	{
		damage_scalar = damage / 600;
		min_damage = int( damage_scalar * level.zombie_health ) + 1;

		if ( damage < min_damage )
		{
			damage = min_damage;
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

	if(weapon == "ray_gun_zm" && meansofdeath == "MOD_PROJECTILE")
	{
		final_damage = 1500;
	}

	if(weapon == "ray_gun_upgraded_zm" && meansofdeath == "MOD_PROJECTILE")
	{
		final_damage = 2000;
	}

	if(maps/mp/zombies/_zm_weapons::get_base_weapon_name(weapon, 1) == "saritch_zm")
	{
		final_damage *= 2;
	}

	if(attacker HasPerk("specialty_rof"))
	{
		if(meansofdeath == "MOD_PISTOL_BULLET" || meansofdeath == "MOD_RIFLE_BULLET")
		{
			final_damage *= 0.75; // TODO: change to 1.5 once fixed
		}
	}

	if(attacker HasPerk("specialty_deadshot"))
	{
		if(is_headshot(weapon, shitloc, meansofdeath))
		{
			if(meansofdeath == "MOD_PISTOL_BULLET" || meansofdeath == "MOD_RIFLE_BULLET")
			{
				if(!isSubStr(weaponClass(weapon), "spread") || maps/mp/zombies/_zm_weapons::get_base_weapon_name(weapon, 1) == "ksg_zm")
				{
					final_damage *= 2;
				}
			}
		}
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

player_damage_override( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	if ( isDefined( level._game_module_player_damage_callback ) )
	{
		self [[ level._game_module_player_damage_callback ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	}
	idamage = self maps/mp/zombies/_zm::check_player_damage_callbacks( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	if ( is_true( self.use_adjusted_grenade_damage ) )
	{
		self.use_adjusted_grenade_damage = undefined;
		if ( self.health > idamage )
		{
			return idamage;
		}
	}
	if ( !idamage )
	{
		return 0;
	}
	if ( self maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
	{
		return 0;
	}
	if ( isDefined( einflictor ) )
	{
		if ( is_true( einflictor.water_damage ) )
		{
			return 0;
		}
	}
	if ( isDefined( eattacker ) && is_true( eattacker.is_zombie ) || isplayer( eattacker ) )
	{
		if ( is_true( self.hasriotshield ) && isDefined( vdir ) )
		{
			if ( is_true( self.hasriotshieldequipped ) )
			{
				if ( self maps/mp/zombies/_zm::player_shield_facing_attacker( vdir, 0.2 ) && isDefined( self.player_shield_apply_damage ) )
				{
					self [[ self.player_shield_apply_damage ]]( 100, 0 );
					return 0;
				}
			}
			else if ( !isDefined( self.riotshieldentity ) )
			{
				if ( !self maps/mp/zombies/_zm::player_shield_facing_attacker( vdir, -0.2 ) && isDefined( self.player_shield_apply_damage ) )
				{
					self [[ self.player_shield_apply_damage ]]( 100, 0 );
					return 0;
				}
			}
		}
	}
	if ( isDefined( eattacker ) )
	{
		if ( isDefined( self.ignoreattacker ) && self.ignoreattacker == eattacker )
		{
			return 0;
		}
		if ( is_true( self.is_zombie ) && is_true( eattacker.is_zombie ) )
		{
			return 0;
		}
		if ( is_true( eattacker.is_zombie ) )
		{
			self.ignoreattacker = eattacker;
			self thread maps/mp/zombies/_zm::remove_ignore_attacker();
			if ( isDefined( eattacker.custom_damage_func ) )
			{
				idamage = eattacker [[ eattacker.custom_damage_func ]]( self );
			}
			else if ( isDefined( eattacker.meleedamage ) )
			{
				idamage = eattacker.meleedamage;
			}
			else
			{
				idamage = 50;
			}
		}
		eattacker notify( "hit_player" );
		if ( smeansofdeath != "MOD_FALLING" )
		{
			self thread maps/mp/zombies/_zm::playswipesound( smeansofdeath, eattacker );
			if ( is_true( eattacker.is_zombie ) || isplayer( eattacker ) )
			{
				self playrumbleonentity( "damage_heavy" );
			}
			canexert = 1;
			if ( is_true( level.pers_upgrade_flopper ) )
			{
				if ( is_true( self.pers_upgrades_awarded[ "flopper" ] ) )
				{
					if ( smeansofdeath != "MOD_PROJECTILE_SPLASH" && smeansofdeath != "MOD_GRENADE" && smeansofdeath != "MOD_GRENADE_SPLASH" )
					{
						canexert = smeansofdeath;
					}
				}
			}
			if ( is_true( canexert ) )
			{
				if ( randomintrange( 0, 1 ) == 0 )
				{
					self thread maps/mp/zombies/_zm_audio::playerexert( "hitmed" );
				}
				else
				{
					self thread maps/mp/zombies/_zm_audio::playerexert( "hitlrg" );
				}
			}
		}
	}
	finaldamage = idamage;
	if ( is_placeable_mine( sweapon ) || sweapon == "freezegun_zm" || sweapon == "freezegun_upgraded_zm" )
	{
		return 0;
	}
	if ( isDefined( self.player_damage_override ) )
	{
		self thread [[ self.player_damage_override ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
	}
	if ( smeansofdeath == "MOD_FALLING" )
	{
		if ( self hasperk( "specialty_flakjacket" ) && isDefined( self.divetoprone ) && self.divetoprone == 1 )
		{
			if ( isDefined( level.zombiemode_divetonuke_perk_func ) )
			{
				[[ level.zombiemode_divetonuke_perk_func ]]( self, self.origin );
			}
			return 0;
		}
		if ( is_true( level.pers_upgrade_flopper ) )
		{
			if ( self maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_flopper_damage_check( smeansofdeath, idamage ) )
			{
				return 0;
			}
		}
	}
	if ( smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH" )
	{
		if ( self hasperk( "specialty_flakjacket" ) )
		{
			return 0;
		}
		if ( is_true( level.pers_upgrade_flopper ) )
		{
			if ( is_true( self.pers_upgrades_awarded[ "flopper" ] ) )
			{
				return 0;
			}
		}
		if ( self.health > 75 && !is_true( self.is_zombie ) )
		{
			return 75;
		}
	}
	if ( idamage < self.health )
	{
		if ( isDefined( eattacker ) )
		{
			if ( isDefined( level.custom_kill_damaged_vo ) )
			{
				eattacker thread [[ level.custom_kill_damaged_vo ]]( self );
			}
			else
			{
				eattacker.sound_damage_player = self;
			}
			if ( !is_true( eattacker.has_legs ) )
			{
				self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "crawl_hit" );
			}
			else if ( isDefined( eattacker.animname ) && eattacker.animname == "monkey_zombie" )
			{
				self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "monkey_hit" );
			}
		}
		return finaldamage;
	}
	if ( isDefined( eattacker ) )
	{
		if ( isDefined( eattacker.animname ) && eattacker.animname == "zombie_dog" )
		{
			self maps/mp/zombies/_zm_stats::increment_client_stat( "killed_by_zdog" );
			self maps/mp/zombies/_zm_stats::increment_player_stat( "killed_by_zdog" );
		}
		else if ( isDefined( eattacker.is_avogadro ) && eattacker.is_avogadro )
		{
			self maps/mp/zombies/_zm_stats::increment_client_stat( "killed_by_avogadro", 0 );
			self maps/mp/zombies/_zm_stats::increment_player_stat( "killed_by_avogadro" );
		}
	}
	self thread maps/mp/zombies/_zm::clear_path_timers();
	if ( level.intermission )
	{
		level waittill( "forever" );
	}
	if ( level.scr_zm_ui_gametype == "zcleansed" && idamage > 0 )
	{
		if ( (!is_true( self.laststand ) && !self maps/mp/zombies/_zm_laststand::player_is_in_laststand()) || !isDefined( self.last_player_attacker ) )
		{
			if(isDefined( eattacker ) && isplayer( eattacker ) && eattacker.team != self.team)
			{
				if ( isDefined( eattacker.maxhealth ) && is_true( eattacker.is_zombie ) )
				{
					eattacker.health = eattacker.maxhealth;
				}
				if ( isDefined( level.player_kills_player ) )
				{
					self thread [[ level.player_kills_player ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
				}
			}
		}
	}
	if ( self hasperk( "specialty_finalstand" ) )
	{
		if ( isDefined( level.chugabud_laststand_func ) )
		{
			self thread [[ level.chugabud_laststand_func ]]();
			return 0;
		}
	}
	players = get_players();
	count = 0;
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ] == self || players[ i ].is_zombie || players[ i ] maps/mp/zombies/_zm_laststand::player_is_in_laststand() || players[ i ].sessionstate == "spectator" )
		{
			count++;
		}
	}
	if ( count < players.size || isDefined( level._game_module_game_end_check ) && ![[ level._game_module_game_end_check ]]() )
	{
		if ( isDefined( self.solo_lives_given ) && self.solo_lives_given < 3 && is_true( level.force_solo_quick_revive ) && self hasperk( "specialty_quickrevive" ) )
		{
			self thread maps/mp/zombies/_zm::wait_and_revive();
		}
		return finaldamage;
	}
	solo_death = is_solo_death( self, players );
	non_solo_death = is_non_solo_death( self, players, count );
	if ( ( solo_death || non_solo_death ) && !is_true( level.no_end_game_check ) )
	{
		level notify( "stop_suicide_trigger" );
		self thread maps/mp/zombies/_zm_laststand::playerlaststand( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime );
		if ( !isDefined( vdir ) )
		{
			vdir = ( 1, 0, 0 );
		}
		self fakedamagefrom( vdir );
		if ( isDefined( level.custom_player_fake_death ) )
		{
			self thread [[ level.custom_player_fake_death ]]( vdir, smeansofdeath );
		}
		else
		{
			self thread maps/mp/zombies/_zm::player_fake_death();
		}
	}
	if ( count == players.size && !is_true( level.no_end_game_check ) )
	{
		if ( players.size == 1 && flag( "solo_game" ) )
		{
			if ( solo_death )
			{
				self.lives = 0;
				level notify( "pre_end_game" );
				wait_network_frame();
				if ( flag( "dog_round" ) )
				{
					maps/mp/zombies/_zm::increment_dog_round_stat( "lost" );
				}
				level notify( "end_game" );
			}
			else
			{
				return finaldamage;
			}
		}
		else
		{
			level notify( "pre_end_game" );
			wait_network_frame();
			if ( flag( "dog_round" ) )
			{
				maps/mp/zombies/_zm::increment_dog_round_stat( "lost" );
			}
			level notify( "end_game" );
		}
		return 0;
	}
	else
	{
		surface = "flesh";
		return finaldamage;
	}
}

is_solo_death( self, players )
{
	if ( players.size == 1 && flag( "solo_game" ) )
	{
		if(self.solo_lives_given >= 3)
		{
			return 1;
		}

		active_perks = 0;
		if(isDefined(self.perks_active))
		{
			active_perks = self.perks_active.size;
		}

		disabled_perks = 0;
		if(isDefined(self.disabled_perks))
		{
			disabled_perks = self.disabled_perks.size;
		}

		if(active_perks <= disabled_perks)
		{
			return 1;
		}
	}

	return 0;
}

is_non_solo_death( self, players, count )
{
	if ( count > 1 || players.size == 1 && !flag( "solo_game" ) )
	{
		return 1;
	}

	return 0;
}

player_laststand( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
	b_alt_visionset = 0;
	self allowjump( 0 );
	currweapon = self getcurrentweapon();
	statweapon = currweapon;
	if ( is_alt_weapon( statweapon ) )
	{
		statweapon = weaponaltweaponname( statweapon );
	}
	self addweaponstat( statweapon, "deathsDuringUse", 1 );
	if ( is_true( self.hasperkspecialtytombstone ) )
	{
		self.laststand_perks = maps/mp/zombies/_zm_tombstone::tombstone_save_perks( self );
	}
	if ( isDefined( self.pers_upgrades_awarded[ "perk_lose" ] ) && self.pers_upgrades_awarded[ "perk_lose" ] )
	{
		self maps/mp/zombies/_zm_pers_upgrades_functions::pers_upgrade_perk_lose_save();
	}
	players = get_players();
	if ( players.size == 1 && flag( "solo_game" ) )
	{
		if ( self.solo_lives_given < 3 )
		{
			active_perks = 0;
			if(isDefined(self.perks_active))
			{
				active_perks = self.perks_active.size;
			}

			disabled_perks = 0;
			if(isDefined(self.disabled_perks))
			{
				disabled_perks = self.disabled_perks.size;
			}

			if(active_perks > disabled_perks)
			{
				self thread maps/mp/zombies/_zm::wait_and_revive();
			}
		}
	}
	if ( self hasperk( "specialty_additionalprimaryweapon" ) )
	{
		self.weapon_taken_by_losing_specialty_additionalprimaryweapon = maps/mp/zombies/_zm::take_additionalprimaryweapon();
	}
	if ( is_true( self.hasperkspecialtytombstone ) )
	{
		self [[ level.tombstone_laststand_func ]]();
		self thread [[ level.tombstone_spawn_func ]]();
		self.hasperkspecialtytombstone = undefined;
		self notify( "specialty_scavenger_stop" );
	}
	self clear_is_drinking();
	self thread maps/mp/zombies/_zm::remove_deadshot_bottle();
	self thread maps/mp/zombies/_zm::remote_revive_watch();
	self maps/mp/zombies/_zm_score::player_downed_penalty();
	self disableoffhandweapons();
	self thread maps/mp/zombies/_zm::last_stand_grenade_save_and_return();
	if ( smeansofdeath != "MOD_SUICIDE" && smeansofdeath != "MOD_FALLING" )
	{
		if ( !is_true( self.intermission ) )
		{
			self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "revive_down" );
		}
		else
		{
			if ( isDefined( level.custom_player_death_vo_func ) &&  !self [[ level.custom_player_death_vo_func ]]() )
			{
				self maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "exert_death" );
			}
		}
	}
	bbprint( "zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "downed", self.origin );
	if ( isDefined( level._zombie_minigun_powerup_last_stand_func ) )
	{
		self thread [[ level._zombie_minigun_powerup_last_stand_func ]]();
	}
	if ( isDefined( level._zombie_tesla_powerup_last_stand_func ) )
	{
		self thread [[ level._zombie_tesla_powerup_last_stand_func ]]();
	}
	if ( self hasperk( "specialty_grenadepulldeath" ) )
	{
		b_alt_visionset = 1;
		if ( isDefined( level.custom_laststand_func ) )
		{
			self thread [[ level.custom_laststand_func ]]();
		}
	}
	if ( is_true( self.intermission ) )
	{
		bbprint( "zombie_playerdeaths", "round %d playername %s deathtype %s x %f y %f z %f", level.round_number, self.name, "died", self.origin );
		wait 0.5;
		self stopsounds();
		level waittill( "forever" );
	}
	if ( !b_alt_visionset )
	{
		visionsetlaststand( "zombie_last_stand", 1 );
	}
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
	self.solo_lives_given++;

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