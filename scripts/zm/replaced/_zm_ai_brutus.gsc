#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\zombies\_zm_score;

brutus_spawn( starting_health, has_helmet, helmet_hits, explosive_dmg_taken, zone_name )
{
	level.num_pulls_since_brutus_spawn = 0;
	self set_zombie_run_cycle( "run" );
	if ( !isDefined( has_helmet ) )
	{
		self.has_helmet = 1;
	}
	else
	{
		self.has_helmet = has_helmet;
	}
	if ( !isDefined( helmet_hits ) )
	{
		self.helmet_hits = 0;
	}
	else
	{
		self.helmet_hits = helmet_hits;
	}
	if ( !isDefined( explosive_dmg_taken ) )
	{
		self.explosive_dmg_taken = 0;
	}
	else
	{
		self.explosive_dmg_taken = explosive_dmg_taken;
	}
	if ( !isDefined( starting_health ) )
	{
		self brutus_health_increases();
		self.maxhealth = level.brutus_health;
		self.health = level.brutus_health;
	}
	else
	{
		self.maxhealth = starting_health;
		self.health = starting_health;
	}
	self.explosive_dmg_req = level.brutus_expl_dmg_req;
	self.no_damage_points = 1;
	self endon( "death" );
	level endon( "intermission" );
	self.animname = "brutus_zombie";
	self.audio_type = "brutus";
	self.has_legs = 1;
	self.ignore_all_poi = 1;
	self.is_brutus = 1;
	self.ignore_enemy_count = 1;
	self.instakill_func = ::brutus_instakill_override;
	self.nuke_damage_func = ::brutus_nuke_override;
	self.melee_anim_func = ::melee_anim_func;
	self.meleedamage = 99;
	self.custom_item_dmg = 1000;
	self.brutus_lockdown_state = 0;
	recalc_zombie_array();
	self setphysparams( 20, 0, 60 );
	self.zombie_init_done = 1;
	self notify( "zombie_init_done" );
	self.allowpain = 0;
	self animmode( "normal" );
	self orientmode( "face enemy" );
	self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();
	self setfreecameralockonallowed( 0 );
	level thread maps\mp\zombies\_zm_spawner::zombie_death_event( self );
	self thread maps\mp\zombies\_zm_spawner::enemy_death_detection();
	if ( isDefined( zone_name ) && zone_name == "zone_golden_gate_bridge" )
	{
		wait randomfloat( 1.5 );
		spawn_pos = get_random_brutus_spawn_pos( zone_name );
	}
	else
	{
		spawn_pos = get_best_brutus_spawn_pos( zone_name );
	}
	if ( !isDefined( spawn_pos ) )
	{
		self delete();
		return;
	}
	if ( !isDefined( spawn_pos.angles ) )
	{
		spawn_pos.angles = ( 0, 0, 0 );
	}
	if ( isDefined( level.brutus_do_prologue ) && level.brutus_do_prologue )
	{
		self brutus_spawn_prologue( spawn_pos );
	}
	if ( !self.has_helmet )
	{
		self detach( "c_zom_cellbreaker_helmet" );
	}
	level.brutus_count++;
	self maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area();
	self thread snddelayedmusic();
	self thread brutus_death();
	self thread brutus_check_zone();
	self thread brutus_watch_enemy();
	self forceteleport( spawn_pos.origin, spawn_pos.angles );
	self.cant_melee = 1;
	self.not_interruptable = 1;
	self.actor_damage_func = ::brutus_damage_override;
	self.non_attacker_func = ::brutus_non_attacker_damage_override;
	self thread brutus_lockdown_client_effects( 0.5 );
	playfx( level._effect[ "brutus_spawn" ], self.origin );
	playsoundatposition( "zmb_ai_brutus_spawn", self.origin );
	self animscripted( spawn_pos.origin, spawn_pos.angles, "zm_spawn" );
	self thread maps\mp\animscripts\zm_shared::donotetracks( "spawn_anim" );
	self waittillmatch( "spawn_anim" );
	self.not_interruptable = 0;
	self.cant_melee = 0;
	self thread brutus_chest_flashlight();
	self thread brutus_find_flesh();
	self thread maps\mp\zombies\_zm_spawner::delayed_zombie_eye_glow();
	level notify( "brutus_spawned", self, "spawn_complete" );
	logline1 = "INFO: _zm_ai_brutus.gsc brutus_spawn() completed its operation " + "\n";
	logprint( logline1 );
}

brutus_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, poffsettime, boneindex )
{
	if ( isDefined( attacker ) && isalive( attacker ) && isplayer( attacker ) && level.zombie_vars[ attacker.team ][ "zombie_insta_kill" ] || isDefined( attacker.personal_instakill ) && attacker.personal_instakill )
	{
		n_brutus_damage_percent = 1;
		n_brutus_headshot_modifier = 2;
	}
	else
	{
		n_brutus_damage_percent = level.brutus_damage_percent;
		n_brutus_headshot_modifier = 1;
	}
	if ( isDefined( weapon ) && is_weapon_shotgun( weapon ) )
	{
		n_brutus_damage_percent *= level.brutus_shotgun_damage_mod;
		n_brutus_headshot_modifier *= level.brutus_shotgun_damage_mod;
	}
	if ( isDefined( weapon ) && weapon == "bouncing_tomahawk_zm" && isDefined( inflictor ) )
	{
		self playsound( "wpn_tomahawk_imp_zombie" );
		if ( self.has_helmet )
		{
			if ( damage == 1 )
			{
				return 0;
			}
			if ( isDefined( inflictor.n_cookedtime ) && inflictor.n_cookedtime >= 2000 )
			{
				self.helmet_hits = level.brutus_helmet_shots;
			}
			else if ( isDefined( inflictor.n_grenade_charge_power ) && inflictor.n_grenade_charge_power >= 2 )
			{
				self.helmet_hits = level.brutus_helmet_shots;
			}
			else
			{
				self.helmet_hits++;
			}
			if ( self.helmet_hits >= level.brutus_helmet_shots )
			{
				self thread brutus_remove_helmet( vdir );
				if ( level.brutus_in_grief )
				{
					player_points = level.brutus_points_for_helmet;
				}
				else
				{
					multiplier = maps\mp\zombies\_zm_score::get_points_multiplier( self );
					player_points = multiplier * round_up_score( level.brutus_points_for_helmet, 5 );
				}
				if ( isDefined( attacker ) && isplayer( attacker ) )
				{
					attacker add_to_player_score( player_points );
					attacker.pers[ "score" ] = attacker.score;
					level notify( "brutus_helmet_removed", attacker );
				}
			}
			return damage * n_brutus_damage_percent;
		}
		else
		{
			return damage;
		}
	}
	if ( ( meansofdeath == "MOD_MELEE" || meansofdeath == "MOD_IMPACT" ) && isDefined( meansofdeath ) )
	{
		if ( weapon == "alcatraz_shield_zm" )
		{
			shield_damage = level.zombie_vars[ "riotshield_fling_damage_shield" ];
			inflictor maps\mp\zombies\_zm_weap_riotshield_prison::player_damage_shield( shield_damage, 0 );
			return 0;
		}
	}
	if ( isDefined( level.zombiemode_using_afterlife ) && level.zombiemode_using_afterlife && weapon == "lightning_hands_zm" )
	{
		self thread brutus_afterlife_teleport();
		return 0;
	}
	if ( is_explosive_damage( meansofdeath ) && weapon != "raygun_mark2_zm" && weapon != "raygun_mark2_upgraded_zm" )
	{
		self.explosive_dmg_taken += damage;
		if ( !self.has_helmet )
		{
			scaler = n_brutus_headshot_modifier;
		}
		else
		{
			scaler = level.brutus_damage_percent;
		}
		if ( self.explosive_dmg_taken >= self.explosive_dmg_req && isDefined( self.has_helmet ) && self.has_helmet )
		{
			self thread brutus_remove_helmet( vectorScale( ( 0, 1, 0 ), 10 ) );
			if ( level.brutus_in_grief )
			{
				player_points = level.brutus_points_for_helmet;
			}
			else
			{
				multiplier = maps\mp\zombies\_zm_score::get_points_multiplier( self );
				player_points = multiplier * round_up_score( level.brutus_points_for_helmet, 5 );
			}
			attacker add_to_player_score( player_points );
			attacker.pers[ "score" ] = inflictor.score;
		}
		return damage * scaler;
	}
	else if ( shitloc != "head" && shitloc != "helmet" )
	{
		return damage * n_brutus_damage_percent;
	}
	else
	{
		return int( self scale_helmet_damage( attacker, damage, n_brutus_headshot_modifier, n_brutus_damage_percent, vdir ) );
	}
}

brutus_health_increases()
{
	if(level.scr_zm_ui_gametype == "zgrief")
	{
		return;
	}

	if ( level.round_number > level.brutus_last_spawn_round )
	{
		a_players = getplayers();
		n_player_modifier = 1;
		if ( a_players.size > 1 )
		{
			n_player_modifier = a_players.size * 0.75;
		}
		level.brutus_round_count++;
		level.brutus_health = int( level.brutus_health_increase * n_player_modifier * level.brutus_round_count );
		level.brutus_expl_dmg_req = int( level.brutus_explosive_damage_increase * n_player_modifier * level.brutus_round_count );
		if ( level.brutus_health >= ( 5000 * n_player_modifier ) )
		{
			level.brutus_health = int( 5000 * n_player_modifier );
		}
		if ( level.brutus_expl_dmg_req >= ( 4500 * n_player_modifier ) )
		{
			level.brutus_expl_dmg_req = int( 4500 * n_player_modifier );
		}
		level.brutus_last_spawn_round = level.round_number;
	}
}

brutus_cleanup_at_end_of_grief_round()
{
	// stays on map
}