#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\replaced\_zm_buildables_pooled;
#include scripts\zm\replaced\_zm_equip_subwoofer;
#include scripts\zm\replaced\_zm_banking;
#include scripts\zm\replaced\_zm_weap_slowgun;
#include scripts\zm\replaced\zgrief;
#include scripts\zm\replaced\zmeat;

main()
{
	precachemodel( "collision_wall_128x128x10_standard" );

	replaceFunc(maps\mp\zombies\_zm_buildables_pooled::add_buildable_to_pool, scripts\zm\replaced\_zm_buildables_pooled::add_buildable_to_pool);
	replaceFunc(maps\mp\zombies\_zm_equip_subwoofer::startsubwooferdecay, scripts\zm\replaced\_zm_equip_subwoofer::startsubwooferdecay);
	replaceFunc(maps\mp\zombies\_zm_equip_subwoofer::subwoofer_network_choke, scripts\zm\replaced\_zm_equip_subwoofer::subwoofer_network_choke);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::watch_reset_anim_rate, scripts\zm\replaced\_zm_weap_slowgun::watch_reset_anim_rate);
	replaceFunc(maps\mp\zombies\_zm_banking::init, scripts\zm\replaced\_zm_banking::init);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_box, scripts\zm\replaced\_zm_banking::bank_deposit_box);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_unitrigger, scripts\zm\replaced\_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger, scripts\zm\replaced\_zm_banking::bank_withdraw_unitrigger);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_stink_on_ground, scripts\zm\replaced\zgrief::meat_stink_on_ground);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_stink_player, scripts\zm\replaced\zgrief::meat_stink_player);
	replaceFunc(maps\mp\gametypes_zm\zmeat::item_meat_watch_trigger, scripts\zm\replaced\zmeat::item_meat_watch_trigger);
	replaceFunc(maps\mp\gametypes_zm\zmeat::kick_meat_monitor, scripts\zm\replaced\zmeat::kick_meat_monitor);
	replaceFunc(maps\mp\gametypes_zm\zmeat::last_stand_meat_nudge, scripts\zm\replaced\zmeat::last_stand_meat_nudge);
}

init()
{
	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::buried_special_weapon_magicbox_check;
	level._is_player_in_zombie_stink = maps\mp\zombies\_zm_perk_vulture::_is_player_in_zombie_stink;
	level.zgrief_meat_stink_player_create = maps\mp\gametypes_zm\zgrief::meat_stink_player_create;
	level.zmeat_create_item_meat_watcher = maps\mp\gametypes_zm\zmeat::create_item_meat_watcher;

	if(is_gametype_active("zgrief"))
	{
		level.check_for_valid_spawn_near_team_callback = ::zgrief_respawn_override;
	}

	level.zombie_buildables["turbine"].bought = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
	level.zombie_buildables["springpad_zm"].bought = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
	level.zombie_buildables["subwoofer_zm"].bought = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
	level.zombie_buildables["headchopper_zm"].bought = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";

	turn_power_on();
	deleteslothbarricades();

	add_jug_collision();

	level thread enable_fountain_transport();
	level thread disable_ghost_free_perk_on_damage();
}

zombie_init_done()
{
	self.allowpain = 0;
	self.zombie_path_bad = 0;
	self thread maps\mp\zm_buried_distance_tracking::escaped_zombies_cleanup_init();
	self setphysparams( 15, 0, 64 );
}

buried_special_weapon_magicbox_check(weapon)
{
	if ( weapon == "time_bomb_zm" )
	{
		players = get_players();
		i = 0;
		while ( i < players.size )
		{
			if ( is_player_valid( players[ i ], undefined, 1 ) && players[ i ] is_player_tactical_grenade( weapon ) )
			{
				return 0;
			}
			i++;
		}
	}
	return 1;
}

zgrief_respawn_override( revivee, return_struct )
{
	players = array_randomize(get_players());
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();
	grief_initial = getstructarray( "street_standard_player_spawns", "targetname" );

	foreach ( struct in grief_initial )
	{
		if ( isDefined( struct.script_int ) && struct.script_int == 2000 )
		{
			spawn_points[ spawn_points.size ] = struct;
			initial_point = struct;
			initial_point.locked = 0;
		}
	}

	if ( spawn_points.size == 0 )
	{
		return undefined;
	}

	closest_group = undefined;
	closest_distance = 100000000;
	backup_group = undefined;
	backup_distance = 100000000;
	i = 0;

	while ( i < players.size )
	{
		if ( is_player_valid( players[ i ], undefined, 1 ) && players[ i ] != self )
		{
			j = 0;
			while ( j < spawn_points.size )
			{
				if ( isDefined( spawn_points[ j ].script_int ) )
				{
					ideal_distance = spawn_points[ j ].script_int;
				}
				else
				{
					ideal_distance = 1000;
				}

				if ( spawn_points[ j ].locked == 0 )
				{
					plyr_dist = distancesquared( players[ i ].origin, spawn_points[ j ].origin );
					if ( plyr_dist < ( ideal_distance * ideal_distance ) )
					{
						if ( plyr_dist < closest_distance )
						{
							closest_distance = plyr_dist;
							closest_group = j;
						}
						j++;
						continue;
					}
					else
					{
						if ( plyr_dist < backup_distance )
						{
							backup_group = j;
							backup_distance = plyr_dist;
						}
					}
				}
				j++;
			}
		}

		if ( !isDefined( closest_group ) )
		{
			closest_group = backup_group;
		}

		if ( isDefined( closest_group ) )
		{
			spawn_location = maps\mp\zombies\_zm::get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
			if ( isDefined( spawn_location ) && !positionwouldtelefrag( spawn_location.origin ) )
			{
				if ( isDefined( spawn_location.plyr ) && spawn_location.plyr != revivee getentitynumber() )
				{
					i++;
					continue;
				}
				else
				{
					return spawn_location;
				}
			}
		}
		i++;
	}

	if ( isDefined( initial_point ) )
	{
		k = 0;
		while ( k < spawn_points.size )
		{
			if ( spawn_points[ k ] == initial_point )
			{
				closest_group = k;
				spawn_location = maps\mp\zombies\_zm::get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
				return spawn_location;
			}
			k++;
		}
	}

	return undefined;
}

turn_power_on()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	trigger = getent( "use_elec_switch", "targetname" );
	if ( isDefined( trigger ) )
	{
		trigger delete();
	}
	master_switch = getent( "elec_switch", "targetname" );
	if ( isDefined( master_switch ) )
	{
		master_switch notsolid();
		master_switch rotateroll( -90, 0.3 );
		clientnotify( "power_on" );
		flag_set( "power_on" );
	}
}

deleteslothbarricades()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	sloth_trigs = getentarray( "sloth_barricade", "targetname" );
	foreach (trig in sloth_trigs)
	{
		if ( isDefined( trig.script_flag ) && level flag_exists( trig.script_flag ) )
		{
			flag_set( trig.script_flag );
		}
		parts = getentarray( trig.target, "targetname" );
		array_thread( parts, ::self_delete );
	}

	array_thread( sloth_trigs, ::self_delete );
}

enable_fountain_transport()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	flag_wait( "initial_blackscreen_passed" );

	wait 1;

	level notify( "courtyard_fountain_open" );
}

disable_ghost_free_perk_on_damage()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	while (1)
	{
		disable_ghost_free_perk();
	}
}

disable_ghost_free_perk()
{
	level endon( "ghost_round_end" );

	flag_wait( "spawn_ghosts" );

	level waittill_any("ghost_drained_player", "ghost_damaged_player");

	while (!isDefined(level.ghost_round_last_ghost_origin))
	{
		wait 0.05;
	}

	level.ghost_round_last_ghost_origin = undefined;

	flag_waitopen( "spawn_ghosts" );
}

add_jug_collision()
{
	origin = (-664, 1050, 8);
	angles = ( 0, 0, 0 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
}