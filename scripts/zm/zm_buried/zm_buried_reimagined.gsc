#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/zm_buried_buildables;
#include scripts/zm/replaced/_zm_buildables_pooled;
#include scripts/zm/replaced/_zm_equip_subwoofer;
#include scripts/zm/replaced/_zm_banking;
#include scripts/zm/replaced/_zm_weap_slowgun;

main()
{
	precachemodel( "collision_wall_128x128x10_standard" );

	replaceFunc(maps/mp/zm_buried_buildables::init_buildables, scripts/zm/replaced/zm_buried_buildables::init_buildables);
	replaceFunc(maps/mp/zombies/_zm_buildables_pooled::add_buildable_to_pool, scripts/zm/replaced/_zm_buildables_pooled::add_buildable_to_pool);
	replaceFunc(maps/mp/zombies/_zm_equip_subwoofer::startsubwooferdecay, scripts/zm/replaced/_zm_equip_subwoofer::startsubwooferdecay);
	replaceFunc(maps/mp/zombies/_zm_equip_subwoofer::subwoofer_network_choke, scripts/zm/replaced/_zm_equip_subwoofer::subwoofer_network_choke);
	replaceFunc(maps/mp/zombies/_zm_weap_slowgun::watch_reset_anim_rate, scripts/zm/replaced/_zm_weap_slowgun::watch_reset_anim_rate);
	replaceFunc(maps/mp/zombies/_zm_banking::init, scripts/zm/replaced/_zm_banking::init);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_deposit_box, scripts/zm/replaced/_zm_banking::bank_deposit_box);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_deposit_unitrigger, scripts/zm/replaced/_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_withdraw_unitrigger, scripts/zm/replaced/_zm_banking::bank_withdraw_unitrigger);
}

init()
{
	level.special_weapon_magicbox_check = ::buried_special_weapon_magicbox_check;
	level._is_player_in_zombie_stink = maps/mp/zombies/_zm_perk_vulture::_is_player_in_zombie_stink;

	turn_power_on();
	deleteslothbarricades();

	add_jug_collision();

	level thread enable_fountain_transport();
	level thread disable_ghost_free_perk_on_damage();
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