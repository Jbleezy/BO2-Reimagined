#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_alcatraz_utility;

#include scripts\zm\replaced\zm_alcatraz_classic;
#include scripts\zm\replaced\_zm_afterlife;
#include scripts\zm\replaced\_zm_ai_brutus;
#include scripts\zm\replaced\zgrief;
#include scripts\zm\replaced\zmeat;

main()
{
	replaceFunc(maps\mp\zm_alcatraz_classic::give_afterlife, scripts\zm\replaced\zm_alcatraz_classic::give_afterlife);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_add, scripts\zm\replaced\_zm_afterlife::afterlife_add);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_spawn, scripts\zm\replaced\_zm_ai_brutus::brutus_spawn);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_health_increases, scripts\zm\replaced\_zm_ai_brutus::brutus_health_increases);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_cleanup_at_end_of_grief_round, scripts\zm\replaced\_zm_ai_brutus::brutus_cleanup_at_end_of_grief_round);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_stink_on_ground, scripts\zm\replaced\zgrief::meat_stink_on_ground);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_stink_player, scripts\zm\replaced\zgrief::meat_stink_player);
	replaceFunc(maps\mp\gametypes_zm\zmeat::item_meat_watch_trigger, scripts\zm\replaced\zmeat::item_meat_watch_trigger);
	replaceFunc(maps\mp\gametypes_zm\zmeat::kick_meat_monitor, scripts\zm\replaced\zmeat::kick_meat_monitor);
	replaceFunc(maps\mp\gametypes_zm\zmeat::last_stand_meat_nudge, scripts\zm\replaced\zmeat::last_stand_meat_nudge);
}

init()
{
	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::check_for_special_weapon_limit_exist;
	level.round_prestart_func = scripts\zm\replaced\_zm_afterlife::afterlife_start_zombie_logic;
	level.zgrief_meat_stink = maps\mp\gametypes_zm\zgrief::meat_stink;
	level.zgrief_meat_stink_player_create = maps\mp\gametypes_zm\zgrief::meat_stink_player_create;
	level.zgrief_meat_stink_player_cleanup = maps\mp\gametypes_zm\zgrief::meat_stink_player_cleanup;
	level.zmeat_create_item_meat_watcher = maps\mp\gametypes_zm\zmeat::create_item_meat_watcher;

	remove_acid_trap_player_spawn();

	tower_trap_changes();

	plane_set_need_all_pieces();
	plane_set_pieces_shared();

	level thread plane_auto_refuel();
}

zombie_init_done()
{
	self.allowpain = 0;
	self setphysparams( 15, 0, 64 );
}

check_for_special_weapon_limit_exist(weapon)
{
	if ( weapon != "blundergat_zm" && weapon != "minigun_alcatraz_zm" )
	{
		return 1;
	}
	players = get_players();
	count = 0;
	if ( weapon == "blundergat_zm" )
	{
		if ( self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( "blundersplat_zm" ) )
		{
			return 0;
		}
		if ( self afterlife_weapon_limit_check( "blundergat_zm" ) )
		{
			return 0;
		}
		limit = level.limited_weapons[ "blundergat_zm" ];
	}
	else
	{
		if ( self afterlife_weapon_limit_check( "minigun_alcatraz_zm" ) )
		{
			return 0;
		}
		limit = level.limited_weapons[ "minigun_alcatraz_zm" ];
	}
	i = 0;
	while ( i < players.size )
	{
		if ( weapon == "blundergat_zm" )
		{
			if ( players[ i ] maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( "blundersplat_zm" ) || isDefined( players[ i ].is_pack_splatting ) && players[ i ].is_pack_splatting )
			{
				count++;
				i++;
				continue;
			}
		}
		else
		{
			if ( players[ i ] afterlife_weapon_limit_check( weapon ) )
			{
				count++;
			}
		}
		i++;
	}
	if ( count >= limit )
	{
		return 0;
	}
	return 1;
}

remove_acid_trap_player_spawn()
{
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();
	foreach(spawn_point in spawn_points)
	{
		if(spawn_point.script_noteworthy == "zone_cafeteria")
		{
			spawn_array = getstructarray( spawn_point.target, "targetname" );
			foreach(spawn in spawn_array)
			{
				if(spawn.origin == (2536, 9704, 1360))
				{
					arrayremovevalue(spawn_array, spawn);
					return;
				}
			}
		}
	}
}

tower_trap_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	// need to override the original function call
	// this level var is threaded though so it doesn't work
	level.custom_tower_trap_fires_func = ::tower_trap_fires_override;

	trap_trigs = getentarray( "tower_trap_activate_trigger", "targetname" );
	foreach (trig in trap_trigs)
	{
		trig thread tower_trap_trigger_think();
		trig thread tower_upgrade_trigger_think();
	}
}

tower_trap_fires_override( zombies )
{

}

tower_trap_trigger_think()
{
	while (1)
	{
		self waittill("switch_activated");
		self thread activate_tower_trap();
	}
}

activate_tower_trap()
{
	self endon( "tower_trap_off" );

	if ( isDefined( self.upgraded ) )
	{
		self.weapon_name = "tower_trap_upgraded_zm";
		self.tag_to_target = "J_SpineLower";
		self.trap_reload_time = 1.5;
	}
	else
	{
		self.weapon_name = "tower_trap_zm";
		self.tag_to_target = "J_Head";
		self.trap_reload_time = 0.75;
	}

	while ( 1 )
	{
		zombies = getaiarray( level.zombie_team );
		zombies_sorted = [];
		foreach ( zombie in zombies )
		{
			if ( zombie istouching( self.range_trigger ) )
			{
				zombies_sorted[ zombies_sorted.size ] = zombie;
			}
		}

		if ( zombies_sorted.size <= 0 )
		{
			wait_network_frame();
			continue;
		}

		self tower_trap_fires( zombies_sorted );
	}
}

tower_trap_fires( zombies )
{
	self endon( "tower_trap_off" );

	org = getstruct( self.range_trigger.target, "targetname" );
	index = randomintrange( 0, zombies.size );

	while ( isalive( zombies[ index ] ) )
	{
		target = zombies[ index ];
		zombietarget = target gettagorigin( self.tag_to_target );

		if ( sighttracepassed( org.origin, zombietarget, 1, undefined ) )
		{
			self thread tower_trap_magicbullet_think( org, target, zombietarget );
			wait self.trap_reload_time;
			continue;
		}
		else
		{
			arrayremovevalue( zombies, target, 0 );
			wait_network_frame();
			if ( zombies.size <= 0 )
			{
				return;
			}
			else
			{
				index = randomintrange( 0, zombies.size );
			}
		}
	}
}

tower_trap_magicbullet_think( org, target, zombietarget )
{
	bullet = magicbullet( self.weapon_name, org.origin, zombietarget );
	bullet waittill( "death" );

	if ( self.weapon_name == "tower_trap_zm" )
	{
		if ( isDefined( target ) && isDefined( target.animname ) && target.health > 0 && target.animname != "brutus_zombie" )
		{
			if ( !isDefined( target.no_gib ) || !target.no_gib )
			{
				target maps\mp\zombies\_zm_spawner::zombie_head_gib();
			}
			target dodamage( target.health + 1000, target.origin );
		}
	}
	else if ( self.weapon_name == "tower_trap_upgraded_zm" )
	{
		radiusdamage( bullet.origin, 256, level.zombie_health * 1.5, level.zombie_health / 2, self, "MOD_GRENADE_SPLASH", "tower_trap_upgraded_zm" );
	}
}

tower_upgrade_trigger_think()
{
	flag_wait( "initial_blackscreen_passed" );
	flag_wait( "start_zombie_round_logic" );
	wait 0.05;

	while (1)
	{
		level waittill( self.upgrade_trigger.script_string );
		self.upgraded = 1;
		level waittill( "between_round_over" );
		self.upgraded = undefined;
	}
}

plane_set_need_all_pieces()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	level.zombie_craftablestubs["plane"].need_all_pieces = 1;
	level.zombie_craftablestubs["refuelable_plane"].need_all_pieces = 1;
}

plane_set_pieces_shared()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	foreach(stub in level.zombie_include_craftables)
	{
		if(stub.name == "plane" || stub.name == "refuelable_plane")
		{
			foreach(piece in stub.a_piecestubs)
			{
				piece.is_shared = 1;
				piece.client_field_state = undefined;
			}
		}
	}
}

plane_auto_refuel()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	for ( ;; )
	{
		flag_wait( "spawn_fuel_tanks" );

		wait 0.05;

		scripts\zm\_zm_reimagined::buildcraftable( "refuelable_plane" );
	}
}