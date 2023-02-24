#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\replaced\zm_highrise_classic;
#include scripts\zm\replaced\_zm_chugabud;
#include scripts\zm\replaced\_zm_banking;

main()
{
	replaceFunc(maps\mp\zm_highrise_classic::insta_kill_player, scripts\zm\replaced\zm_highrise_classic::insta_kill_player);
	replaceFunc(maps\mp\zombies\_zm_chugabud::chugabud_bleed_timeout, scripts\zm\replaced\_zm_chugabud::chugabud_bleed_timeout);
	replaceFunc(maps\mp\zombies\_zm_banking::init, scripts\zm\replaced\_zm_banking::init);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_box, scripts\zm\replaced\_zm_banking::bank_deposit_box);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_unitrigger, scripts\zm\replaced\_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger, scripts\zm\replaced\_zm_banking::bank_withdraw_unitrigger);
}

init()
{
	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::highrise_special_weapon_magicbox_check;
	level.check_for_valid_spawn_near_team_callback = ::highrise_respawn_override;

    level thread elevator_solo_revive_fix();
}

zombie_init_done()
{
	self.allowpain = 0;
	self.zombie_path_bad = 0;
	self thread maps\mp\zm_highrise_distance_tracking::escaped_zombies_cleanup_init();
	self thread maps\mp\zm_highrise::elevator_traverse_watcher();
	if ( self.classname == "actor_zm_highrise_basic_03" )
	{
		health_bonus = int( self.maxhealth * 0.05 );
		self.maxhealth += health_bonus;
		if ( self.headmodel == "c_zom_zombie_chinese_head3_helmet" )
		{
			self.maxhealth += health_bonus;
		}
		self.health = self.maxhealth;
	}
	self setphysparams( 15, 0, 64 );
}

highrise_special_weapon_magicbox_check(weapon)
{
	return 1;
}

highrise_respawn_override( revivee, return_struct )
{
	players = array_randomize(get_players());
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	if ( spawn_points.size == 0 )
	{
		return undefined;
	}

	for ( i = 0; i < players.size; i++ )
	{
		if ( is_player_valid( players[ i ], undefined, 1 ) && players[ i ] != self )
		{
			for ( j = 0; j < spawn_points.size; j++ )
			{
				if ( isDefined( spawn_points[ j ].script_noteworthy ) )
				{
					zone = level.zones[ spawn_points[ j ].script_noteworthy ];
					for ( k = 0; k < zone.volumes.size; k++ )
					{
						if ( players[ i ] istouching( zone.volumes[ k ] ) )
						{
							closest_group = j;
							spawn_location = maps\mp\zombies\_zm::get_valid_spawn_location( revivee, spawn_points, closest_group, return_struct );
							if ( isDefined( spawn_location ) )
							{
								return spawn_location;
							}
						}
					}
				}
			}
		}
	}
}

elevator_solo_revive_fix()
{
	if (!(is_classic() && level.scr_zm_map_start_location == "rooftop"))
	{
		return;
	}

	flag_wait( "start_zombie_round_logic" );

	if (!flag("solo_game"))
	{
		return;
	}

	flag_wait( "perks_ready" );
	flag_wait( "initial_blackscreen_passed" );
	wait 1;

	revive_elevator = undefined;
	foreach (elevator in level.elevators)
	{
		if (elevator.body.perk_type == "vending_revive")
		{
			revive_elevator = elevator;
			break;
		}
	}

	revive_elevator.body.elevator_stop = 1;
	revive_elevator.body.lock_doors = 1;
	revive_elevator.body maps\mp\zm_highrise_elevators::perkelevatordoor(0);

	flag_wait( "power_on" );

	revive_elevator.body.elevator_stop = 0;
	revive_elevator.body.lock_doors = 0;
	revive_elevator.body maps\mp\zm_highrise_elevators::perkelevatordoor(1);
}