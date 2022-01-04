#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/zm_tomb_craftables;
#include scripts/zm/replaced/zm_tomb_dig;

main()
{
	replaceFunc(maps/mp/zm_tomb_craftables::quadrotor_control_thread, scripts/zm/replaced/zm_tomb_craftables::quadrotor_control_thread);
	replaceFunc(maps/mp/zm_tomb_dig::dig_disconnect_watch, scripts/zm/replaced/zm_tomb_dig::dig_disconnect_watch);
}

init()
{
	level.map_on_player_connect = ::on_player_connect;
	level.custom_magic_box_timer_til_despawn = ::custom_magic_box_timer_til_despawn;

	challenges_changes();
	soul_box_changes();

	level thread increase_solo_door_prices();
	level thread remove_shovels_from_map();
	level thread zombie_blood_dig_changes();
}

on_player_connect()
{
	self thread give_shovel();
}

increase_solo_door_prices()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	flag_wait( "initial_blackscreen_passed" );

	if ( isDefined( level.is_forever_solo_game ) && level.is_forever_solo_game )
	{
		a_door_buys = getentarray( "zombie_door", "targetname" );
		array_thread( a_door_buys, ::door_price_increase_for_solo );
		a_debris_buys = getentarray( "zombie_debris", "targetname" );
		array_thread( a_debris_buys, ::door_price_increase_for_solo );
	}
}

door_price_increase_for_solo()
{
	self.zombie_cost += 250;

	if ( self.targetname == "zombie_door" )
	{
		self set_hint_string( self, "default_buy_door", self.zombie_cost );
	}
	else
	{
		self set_hint_string( self, "default_buy_debris", self.zombie_cost );
	}
}

remove_shovels_from_map()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	flag_wait( "initial_blackscreen_passed" );

	stubs = level._unitriggers.trigger_stubs;
	for(i = 0; i < stubs.size; i++)
	{
		stub = stubs[i];
		if(IsDefined(stub.e_shovel))
		{
			stub.e_shovel delete();
			maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( stub );
		}
	}
}

give_shovel()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	self waittill("spawned_player");

	self.dig_vars[ "has_shovel" ] = 1;
	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 1 );
}

challenges_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	level._challenges.a_stats["zc_points_spent"].fp_give_reward = ::reward_random_perk;
}

reward_random_perk( player, s_stat )
{
	if (!isDefined(player.tomb_reward_perk))
	{
		player.tomb_reward_perk = player get_random_perk();
	}
	else if (isDefined( self.perk_purchased ) && self.perk_purchased == player.tomb_reward_perk)
	{
		player.tomb_reward_perk = player get_random_perk();
	}
	else if (self hasperk( player.tomb_reward_perk ) || self maps/mp/zombies/_zm_perks::has_perk_paused( player.tomb_reward_perk ))
	{
		player.tomb_reward_perk = player get_random_perk();
	}

	perk = player.tomb_reward_perk;
	if (!isDefined(perk))
	{
		return 0;
	}

	model = maps/mp/zombies/_zm_perk_random::get_perk_weapon_model(perk);
	if (!isDefined(model))
	{
		return 0;
	}

	m_reward = spawn( "script_model", self.origin );
	m_reward.angles = self.angles + vectorScale( ( 0, 1, 0 ), 180 );
	m_reward setmodel( model );
	m_reward playsound( "zmb_spawn_powerup" );
	m_reward playloopsound( "zmb_spawn_powerup_loop", 0.5 );
	wait_network_frame();
	if ( !maps/mp/zombies/_zm_challenges::reward_rise_and_grab( m_reward, 50, 2, 2, 10 ) )
	{
		return 0;
	}
	if ( player hasperk( perk ) || player maps/mp/zombies/_zm_perks::has_perk_paused( perk ) )
	{
		m_reward thread maps/mp/zm_tomb_challenges::bottle_reject_sink( player );
		return 0;
	}
	m_reward stoploopsound( 0.1 );
	player playsound( "zmb_powerup_grabbed" );
	m_reward thread maps/mp/zombies/_zm_perks::vending_trigger_post_think( player, perk );
	m_reward delete();
	player increment_player_perk_purchase_limit();
	player maps/mp/zombies/_zm_stats::increment_client_stat( "tomb_perk_extension", 0 );
	player maps/mp/zombies/_zm_stats::increment_player_stat( "tomb_perk_extension" );
	player thread player_perk_purchase_limit_fix();
	return 1;
}

get_random_perk()
{
	perks = [];
	for (i = 0; i < level._random_perk_machine_perk_list.size; i++)
	{
		perk = level._random_perk_machine_perk_list[ i ];
		if ( isDefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			continue;
		}
		else
		{
			if ( !self hasperk( perk ) && !self maps/mp/zombies/_zm_perks::has_perk_paused( perk ) )
			{
				perks[ perks.size ] = perk;
			}
		}
	}
	if ( perks.size > 0 )
	{
		perks = array_randomize( perks );
		random_perk = perks[ 0 ];
		return random_perk;
	}
}

increment_player_perk_purchase_limit()
{
	if ( !isDefined( self.player_perk_purchase_limit ) )
	{
		self.player_perk_purchase_limit = level.perk_purchase_limit;
	}
	self.player_perk_purchase_limit++;
}

player_perk_purchase_limit_fix()
{
	self endon("disconnect");

	while (self.pers[ "tomb_perk_extension" ] < 5)
	{
		wait .5;
	}

	if (self.player_perk_purchase_limit < 9)
	{
		self.player_perk_purchase_limit = 9;
	}
}

zombie_blood_dig_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	while (1)
	{
		for (i = 0; i < level.a_zombie_blood_entities.size; i++)
		{
			ent = level.a_zombie_blood_entities[i];
			if (IsDefined(ent.e_unique_player))
			{
				if (!isDefined(ent.e_unique_player.initial_zombie_blood_dig))
				{
					ent.e_unique_player.initial_zombie_blood_dig = 0;
				}

				ent.e_unique_player.initial_zombie_blood_dig++;
				if (ent.e_unique_player.initial_zombie_blood_dig <= 2)
				{
					ent setvisibletoplayer(ent.e_unique_player);
				}
				else
				{
					ent thread set_visible_after_rounds(ent.e_unique_player, 3);
				}

				arrayremovevalue(level.a_zombie_blood_entities, ent);
			}
		}

		wait .5;
	}
}

set_visible_after_rounds(player, num)
{
	for (i = 0; i < num; i++)
	{
		level waittill( "end_of_round" );
	}

	self setvisibletoplayer(player);
}

soul_box_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	a_boxes = getentarray( "foot_box", "script_noteworthy" );
	array_thread( a_boxes, ::soul_box_decrease_kill_requirement );
}

soul_box_decrease_kill_requirement()
{
	self endon( "box_finished" );

	while (1)
	{
		self waittill( "soul_absorbed" );

		wait 0.05;

		self.n_souls_absorbed += 10;

		self waittill( "robot_foot_stomp" );
	}
}

custom_magic_box_timer_til_despawn( magic_box )
{
	self endon( "kill_weapon_movement" );
	v_float = anglesToForward( magic_box.angles - vectorScale( ( 0, 1, 0 ), 90 ) ) * 40;
	self moveto( self.origin - ( v_float * 0.25 ), level.magicbox_timeout, level.magicbox_timeout * 0.5 );
	wait level.magicbox_timeout;
	if ( isDefined( self ) )
	{
		self delete();
	}
}