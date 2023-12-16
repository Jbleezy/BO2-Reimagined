#include maps\mp\zombies\_zm_weap_riotshield_tomb;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_riotshield_tomb;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_weaponobjects;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_audio;

init()
{
	maps\mp\zombies\_zm_riotshield_tomb::init();
	set_zombie_var( "riotshield_cylinder_radius", 360 );
	set_zombie_var( "riotshield_fling_range", 90 );
	set_zombie_var( "riotshield_gib_range", 90 );
	set_zombie_var( "riotshield_gib_damage", 75 );
	set_zombie_var( "riotshield_knockdown_range", 90 );
	set_zombie_var( "riotshield_knockdown_damage", 15 );
	set_zombie_var( "riotshield_hit_points", 1500 );
	set_zombie_var( "riotshield_fling_damage_shield", 100 );
	set_zombie_var( "riotshield_knockdown_damage_shield", 15 );
	level.riotshield_network_choke_count = 0;
	level.riotshield_gib_refs = [];
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "guts";
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "right_arm";
	level.riotshield_gib_refs[level.riotshield_gib_refs.size] = "left_arm";
	level.riotshield_damage_callback = ::player_damage_shield;
	level.deployed_riotshield_damage_callback = ::deployed_damage_shield;
	level.transferriotshield = ::transferriotshield;
	level.cantransferriotshield = ::cantransferriotshield;
	maps\mp\zombies\_zm_spawner::register_zombie_damage_callback( ::riotshield_zombie_damage_response );
	maps\mp\zombies\_zm_equipment::register_equipment( "tomb_shield_zm", &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_RIOTSHIELD_HOWTO", "riotshield_zm_icon", "riotshield", ::riotshield_activation_watcher_thread, undefined, ::dropshield, ::pickupshield );
	maps\mp\gametypes_zm\_weaponobjects::createretrievablehint( "riotshield", &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING" );
	onplayerconnect_callback( ::onplayerconnect );
}

onplayerconnect()
{
	self.player_shield_reset_health = ::player_init_shield_health;
	self.player_shield_apply_damage = ::player_damage_shield;
	self.player_shield_reset_location = ::player_init_shield_location;
	self thread watchriotshielduse();
	self thread watchriotshieldmelee();
	self thread player_watch_laststand();
}

player_damage_shield( idamage, bheld )
{
	damagemax = level.zombie_vars["riotshield_hit_points"];

	if ( !isdefined( self.shielddamagetaken ) )
		self.shielddamagetaken = 0;

	self.shielddamagetaken += idamage;

	if ( self.shielddamagetaken >= damagemax )
	{
		if ( bheld || !isdefined( self.shield_ent ) )
		{
			self playrumbleonentity( "damage_heavy" );
			earthquake( 1.0, 0.75, self.origin, 100 );
			self playsound( "wpn_riotshield_zm_destroy" );
			self thread player_take_riotshield();
		}
		else
		{
			shield_origin = self.shield_ent.origin;
			playsoundatposition( "fly_riotshield_zm_impact_zombies", shield_origin );

			if ( is_true( self.shield_ent.destroy_begun ) )
				return;

			self.shield_ent.destroy_begun = 1;
			self thread player_wait_and_take_riotshield();
		}
	}
	else
	{
		if ( bheld || !isdefined( self.shield_ent ) )
		{
			self playrumbleonentity( "damage_light" );
			earthquake( 0.5, 0.5, self.origin, 100 );
			self playsound( "fly_riotshield_zm_impact_zombies" );
		}
		else
		{
			shield_origin = self.shield_ent.origin;
			playsoundatposition( "fly_riotshield_zm_impact_zombies", shield_origin );
		}

		self player_set_shield_health( self.shielddamagetaken, damagemax );
	}
}

player_wait_and_take_riotshield()
{
	shield_origin = self.shield_ent.origin;
	level thread maps\mp\zombies\_zm_equipment::equipment_disappear_fx( shield_origin, level._riotshield_dissapear_fx );
	wait 1;
	playsoundatposition( "wpn_riotshield_zm_destroy", shield_origin );
	self thread player_take_riotshield();
}

watchriotshieldmelee()
{
	for (;;)
	{
		self waittill( "weapon_melee", weapon );

		if ( weapon == level.riotshield_name )
			self riotshield_melee();
	}
}

riotshield_melee()
{
	if ( !isdefined( level.riotshield_knockdown_enemies ) )
	{
		level.riotshield_knockdown_enemies = [];
		level.riotshield_knockdown_gib = [];
		level.riotshield_fling_enemies = [];
		level.riotshield_fling_vecs = [];
	}

	self riotshield_get_enemies_in_range();
	shield_damage = 0;
	level.riotshield_network_choke_count = 0;

	for ( i = 0; i < level.riotshield_fling_enemies.size; i++ )
	{
		riotshield_network_choke();

		if ( isdefined( level.riotshield_fling_enemies[i] ) )
		{
			level.riotshield_fling_enemies[i] thread riotshield_fling_zombie( self, level.riotshield_fling_vecs[i], i );
			shield_damage += level.zombie_vars["riotshield_fling_damage_shield"];
		}
	}

	for ( i = 0; i < level.riotshield_knockdown_enemies.size; i++ )
	{
		riotshield_network_choke();
		level.riotshield_knockdown_enemies[i] thread riotshield_knockdown_zombie( self, level.riotshield_knockdown_gib[i] );
		shield_damage += level.zombie_vars["riotshield_knockdown_damage_shield"];
	}

	level.riotshield_knockdown_enemies = [];
	level.riotshield_knockdown_gib = [];
	level.riotshield_fling_enemies = [];
	level.riotshield_fling_vecs = [];

	if ( shield_damage )
		self player_damage_shield( shield_damage, 0 );
}

riotshield_fling_zombie( player, fling_vec, index )
{
	if ( !isdefined( self ) || !isalive( self ) )
		return;

	if ( isdefined( self.ignore_riotshield ) && self.ignore_riotshield )
		return;

	if ( isdefined( self.riotshield_fling_func ) )
	{
		self [[ self.riotshield_fling_func ]]( player );
		return;
	}

	damage = 2500;
	self dodamage( damage, player.origin, player, player, 0, "MOD_MELEE", 0, level.riotshield_name );

	if ( self.health < 1 )
	{
		self.riotshield_death = 1;
		player maps\mp\zombies\_zm_score::player_add_points( "death", "MOD_MELEE" );
		self startragdoll();
		self launchragdoll( fling_vec );
	}
	else
	{
		player maps\mp\zombies\_zm_score::player_add_points( "damage_light" );
	}
}

zombie_knockdown( player, gib )
{
	if ( isdefined( level.override_riotshield_damage_func ) )
		self [[ level.override_riotshield_damage_func ]]( player, gib );
	else
	{
		if ( gib )
		{
			self.a.gib_ref = random( level.riotshield_gib_refs );
			self thread maps\mp\animscripts\zm_death::do_gib();
		}
	}
}

riotshield_knockdown_zombie( player, gib )
{
	self endon( "death" );
	playsoundatposition( "vox_riotshield_forcehit", self.origin );
	playsoundatposition( "wpn_riotshield_proj_impact", self.origin );

	if ( !isdefined( self ) || !isalive( self ) )
		return;

	if ( isdefined( self.riotshield_knockdown_func ) )
		self [[ self.riotshield_knockdown_func ]]( player, gib );
	else
		self zombie_knockdown( player, gib );

	self dodamage( level.zombie_vars["riotshield_knockdown_damage"], player.origin, player, player, 0, "MOD_MELEE", 0, level.riotshield_name );
	self playsound( "fly_riotshield_forcehit" );

	if ( self.health < 1 )
	{
		player maps\mp\zombies\_zm_score::player_add_points( "death", "MOD_MELEE" );
	}
	else
	{
		player maps\mp\zombies\_zm_score::player_add_points( "damage_light" );
	}
}