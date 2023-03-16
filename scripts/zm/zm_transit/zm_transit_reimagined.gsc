#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\replaced\zm_transit;
#include scripts\zm\replaced\zm_transit_gamemodes;
#include scripts\zm\replaced\zm_transit_utility;
#include scripts\zm\replaced\zm_transit_bus;
#include scripts\zm\replaced\_zm_riotshield;
#include scripts\zm\replaced\_zm_weap_riotshield;
#include scripts\zm\replaced\_zm_weap_jetgun;
#include scripts\zm\replaced\_zm_weap_emp_bomb;
#include scripts\zm\replaced\_zm_equip_electrictrap;
#include scripts\zm\replaced\_zm_equip_turret;
#include scripts\zm\replaced\_zm_banking;
#include scripts\zm\replaced\_zm_weapon_locker;

main()
{
	replaceFunc(maps\mp\zm_transit::lava_damage_depot, scripts\zm\replaced\zm_transit::lava_damage_depot);
	replaceFunc(maps\mp\zm_transit_gamemodes::init, scripts\zm\replaced\zm_transit_gamemodes::init);
	replaceFunc(maps\mp\zm_transit_utility::solo_tombstone_removal, scripts\zm\replaced\zm_transit_utility::solo_tombstone_removal);
	replaceFunc(maps\mp\zm_transit_bus::busupdateplayers, scripts\zm\replaced\zm_transit_bus::busupdateplayers);
	replaceFunc(maps\mp\zombies\_zm_riotshield::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield::doriotshielddeploy);
	replaceFunc(maps\mp\zombies\_zm_riotshield::trackriotshield, scripts\zm\replaced\_zm_riotshield::trackriotshield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::init, scripts\zm\replaced\_zm_weap_riotshield::init);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield::player_damage_shield);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::is_jetgun_firing, scripts\zm\replaced\_zm_weap_jetgun::is_jetgun_firing);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::jetgun_check_enemies_in_range, scripts\zm\replaced\_zm_weap_jetgun::jetgun_check_enemies_in_range);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::jetgun_grind_zombie, scripts\zm\replaced\_zm_weap_jetgun::jetgun_grind_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::handle_overheated_jetgun, scripts\zm\replaced\_zm_weap_jetgun::handle_overheated_jetgun);
	replaceFunc(maps\mp\zombies\_zm_weap_jetgun::jetgun_network_choke, scripts\zm\replaced\_zm_weap_jetgun::jetgun_network_choke);
	replaceFunc(maps\mp\zombies\_zm_weap_emp_bomb::emp_detonate, scripts\zm\replaced\_zm_weap_emp_bomb::emp_detonate);
	replaceFunc(maps\mp\zombies\_zm_equip_electrictrap::startelectrictrapdeploy, scripts\zm\replaced\_zm_equip_electrictrap::startelectrictrapdeploy);
	replaceFunc(maps\mp\zombies\_zm_equip_electrictrap::cleanupoldtrap, scripts\zm\replaced\_zm_equip_electrictrap::cleanupoldtrap);
	replaceFunc(maps\mp\zombies\_zm_equip_electrictrap::etrap_choke, scripts\zm\replaced\_zm_equip_electrictrap::etrap_choke);
	replaceFunc(maps\mp\zombies\_zm_equip_turret::startturretdeploy, scripts\zm\replaced\_zm_equip_turret::startturretdeploy);
	replaceFunc(maps\mp\zombies\_zm_banking::init, scripts\zm\replaced\_zm_banking::init);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_box, scripts\zm\replaced\_zm_banking::bank_deposit_box);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_unitrigger, scripts\zm\replaced\_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger, scripts\zm\replaced\_zm_banking::bank_withdraw_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_weapon_locker::triggerweaponslockerisvalidweaponpromptupdate, scripts\zm\replaced\_zm_weapon_locker::triggerweaponslockerisvalidweaponpromptupdate);
	replaceFunc(maps\mp\zombies\_zm_zonemgr::manage_zones, ::manage_zones);

	grief_include_weapons();
	electric_door_changes();
}

init()
{
	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::transit_special_weapon_magicbox_check;
	level.grenade_safe_to_bounce = ::grenade_safe_to_bounce;

	screecher_spawner_changes();
	zombie_spawn_location_changes();
	path_exploit_fixes();

	level thread power_local_electric_doors_globally();
	level thread b23r_hint_string_fix();
	level thread power_station_vision_change();
}

grief_include_weapons()
{
	if ( getDvar( "g_gametype" ) != "zgrief" )
	{
		return;
	}

	include_weapon( "ray_gun_zm" );
	include_weapon( "ray_gun_upgraded_zm", 0 );
	include_weapon( "tazer_knuckles_zm", 0 );
	include_weapon( "knife_ballistic_no_melee_zm", 0 );
	include_weapon( "knife_ballistic_no_melee_upgraded_zm", 0 );
	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", 0 );
	include_weapon( "knife_ballistic_bowie_zm", 0 );
	include_weapon( "knife_ballistic_bowie_upgraded_zm", 0 );
	level._uses_retrievable_ballisitic_knives = 1;
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_zm", 1 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "ray_gun_zm", 4 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "ray_gun_upgraded_zm", 4 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_upgraded_zm", 0 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_no_melee_zm", 0 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_no_melee_upgraded_zm", 0 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_bowie_zm", 0 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "knife_ballistic_bowie_upgraded_zm", 0 );
	include_weapon( "raygun_mark2_zm" );
	include_weapon( "raygun_mark2_upgraded_zm", 0 );
	maps\mp\zombies\_zm_weapons::add_weapon_to_content( "raygun_mark2_zm", "dlc3" );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "raygun_mark2_zm", 1 );
	maps\mp\zombies\_zm_weapons::add_limited_weapon( "raygun_mark2_upgraded_zm", 1 );
}

zombie_init_done()
{
	self.allowpain = 0;
	self setphysparams( 15, 0, 64 );
}

transit_special_weapon_magicbox_check(weapon)
{
	return 1;
}

screecher_spawner_changes()
{
	level.screecher_spawners = getentarray( "screecher_zombie_spawner", "script_noteworthy" );
	array_thread( level.screecher_spawners, ::add_spawn_function, ::screecher_prespawn_decrease_health );
}

screecher_prespawn_decrease_health()
{
	self.player_score = 12;
}

electric_door_changes()
{
	if( is_classic() && level.scr_zm_map_start_location == "transit" )
	{
		return;
	}

	zombie_doors = getentarray( "zombie_door", "targetname" );
	for ( i = 0; i < zombie_doors.size; i++ )
	{
		if ( isDefined( zombie_doors[i].script_noteworthy ) && (zombie_doors[i].script_noteworthy == "local_electric_door" || zombie_doors[i].script_noteworthy == "electric_door") )
		{
			zombie_doors[i].script_noteworthy = "default";
			zombie_doors[i].zombie_cost = 750;

			// link Bus Depot and Farm electric doors together
			new_target = undefined;
			if (zombie_doors[i].target == "pf1766_auto2353")
			{
				new_target = "pf1766_auto2352";

			}
			else if (zombie_doors[i].target == "pf1766_auto2358")
			{
				new_target = "pf1766_auto2357";
			}

			if (isDefined(new_target))
			{
				targets = getentarray( zombie_doors[i].target, "targetname" );
				zombie_doors[i].target = new_target;

				foreach (target in targets)
				{
					target.targetname = zombie_doors[i].target;
				}
			}
		}
	}
}

power_local_electric_doors_globally()
{
	if( !(is_classic() && level.scr_zm_map_start_location == "transit") )
	{
		return;
	}

	for ( ;; )
	{
		flag_wait( "power_on" );

		local_power = [];
		zombie_doors = getentarray( "zombie_door", "targetname" );
		for ( i = 0; i < zombie_doors.size; i++ )
		{
			if ( isDefined( zombie_doors[i].script_noteworthy ) && zombie_doors[i].script_noteworthy == "local_electric_door" )
			{
				local_power[local_power.size] = maps\mp\zombies\_zm_power::add_local_power( zombie_doors[i].origin, 16 );
			}
		}

		flag_waitopen( "power_on" );

		for (i = 0; i < local_power.size; i++)
		{
			maps\mp\zombies\_zm_power::end_local_power( local_power[i] );
			local_power[i] = undefined;
		}
	}
}

b23r_hint_string_fix()
{
	flag_wait( "initial_blackscreen_passed" );
	wait 0.05;

	trigs = getentarray("weapon_upgrade", "targetname");
	foreach (trig in trigs)
	{
		if (trig.zombie_weapon_upgrade == "beretta93r_zm")
		{
			hint = maps\mp\zombies\_zm_weapons::get_weapon_hint(trig.zombie_weapon_upgrade);
			cost = level.zombie_weapons[trig.zombie_weapon_upgrade].cost;
			trig sethintstring(hint, cost);
		}
	}
}

grenade_safe_to_bounce( player, weapname )
{
	if ( !is_offhand_weapon( weapname ) )
	{
		return 1;
	}

	if ( self maps\mp\zm_transit_lava::object_touching_lava() )
	{
		return 0;
	}

	return 1;
}

zombie_spawn_location_changes()
{
	for ( z = 0; z < level.zone_keys.size; z++ )
	{
		zone = level.zones[ level.zone_keys[ z ] ];

        i = 0;
        while ( i < zone.spawn_locations.size )
        {
            if ( zone.spawn_locations[ i ].origin == ( 9963, 8025, -554.9 ) )
            {
                zone.spawn_locations[ i ].origin += ( 0, 0, -32 );
            }

            i++;
		}
	}
}

path_exploit_fixes()
{
	// town bookstore near jug
	zombie_trigger_origin = ( 1045, -1521, 128 );
	zombie_trigger_radius = 96;
	zombie_trigger_height = 64;
	player_trigger_origin = ( 1116, -1547, 128 );
	player_trigger_radius = 72;
	zombie_goto_point = ( 1098, -1521, 128 );
	level thread maps\mp\zombies\_zm_ffotd::path_exploit_fix( zombie_trigger_origin, zombie_trigger_radius, zombie_trigger_height, player_trigger_origin, player_trigger_radius, zombie_goto_point );
}

power_station_vision_change()
{
	level.default_r_exposureValue = 3;
	level.changed_r_exposureValue = 4;
	time = 1;

	flag_wait( "start_zombie_round_logic" );

	while(1)
	{
		players = get_players();
		foreach(player in players)
		{
			if(!isDefined(player.power_station_vision_set))
			{
				player.power_station_vision_set = 0;
				player.r_exposureValue = level.default_r_exposureValue;
				player setClientDvar("r_exposureTweak", 1);
				player setClientDvar("r_exposureValue", level.default_r_exposureValue);
			}

			if(!player.power_station_vision_set)
			{
				if(player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_prr") || player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_pcr"))
				{
					player.power_station_vision_set = 1;
					player thread change_dvar_over_time("r_exposureValue", level.changed_r_exposureValue, time, 1);
				}
			}
			else
			{
				if(!(player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_prr") || player maps\mp\zombies\_zm_zonemgr::entity_in_zone("zone_pcr")))
				{
					player.power_station_vision_set = 0;
					player thread change_dvar_over_time("r_exposureValue", level.default_r_exposureValue, time, 0);
				}
			}
		}

		wait 0.05;
	}
}

change_dvar_over_time(dvar, val, time, increment)
{
	self notify("change_dvar_over_time");
	self endon("change_dvar_over_time");

	intervals = time * 20;
	rate = (level.changed_r_exposureValue - level.default_r_exposureValue) / intervals;

	i = 0;
	while(i < intervals)
	{
		if(increment)
		{
			self.r_exposureValue += rate;

			if(self.r_exposureValue > val)
			{
				self.r_exposureValue = val;
			}
		}
		else
		{
			self.r_exposureValue -= rate;

			if(self.r_exposureValue < val)
			{
				self.r_exposureValue = val;
			}
		}

		self setClientDvar(dvar, self.r_exposureValue);

		if(self.r_exposureValue == val)
		{
			return;
		}

		i++;
		wait 0.05;
	}

	self setClientDvar(dvar, val);
}

manage_zones( initial_zone )
{
	level.zone_manager_init_func = ::transit_zone_init;

	if (!isInArray(initial_zone, "zone_amb_tunnel"))
	{
		initial_zone[initial_zone.size] = "zone_amb_tunnel";
	}

	if (!isInArray(initial_zone, "zone_amb_cornfield"))
	{
		initial_zone[initial_zone.size] = "zone_amb_cornfield";
	}

	if (!isInArray(initial_zone, "zone_cornfield_prototype"))
	{
		initial_zone[initial_zone.size] = "zone_cornfield_prototype";
	}

	deactivate_initial_barrier_goals();
	zone_choke = 0;
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();
	for ( i = 0; i < spawn_points.size; i++ )
	{
		spawn_points[ i ].locked = 1;
	}
	if ( isDefined( level.zone_manager_init_func ) )
	{
		[[ level.zone_manager_init_func ]]();
	}

	if ( isarray( initial_zone ) )
	{
		for ( i = 0; i < initial_zone.size; i++ )
		{
			zone_init( initial_zone[ i ] );
			enable_zone( initial_zone[ i ] );
		}
	}
	else
	{
		zone_init( initial_zone );
		enable_zone( initial_zone );
	}
	setup_zone_flag_waits();
	zkeys = getarraykeys( level.zones );
	level.zone_keys = zkeys;
	level.newzones = [];
	for ( z = 0; z < zkeys.size; z++ )
	{
		level.newzones[ zkeys[ z ] ] = spawnstruct();
	}
	oldzone = undefined;
	flag_set( "zones_initialized" );
	flag_wait( "begin_spawning" );
	while ( getDvarInt( "noclip" ) == 0 || getDvarInt( "notarget" ) != 0 )
	{
		for( z = 0; z < zkeys.size; z++ )
		{
			level.newzones[ zkeys[ z ] ].is_active = 0;
			level.newzones[ zkeys[ z ] ].is_occupied = 0;
		}
		a_zone_is_active = 0;
		a_zone_is_spawning_allowed = 0;
		level.zone_scanning_active = 1;
		z = 0;
		while ( z < zkeys.size )
		{
			zone = level.zones[ zkeys[ z ] ];
			newzone = level.newzones[ zkeys[ z ] ];
			if( !zone.is_enabled )
			{
				z++;
				continue;
			}
			if ( isdefined(level.zone_occupied_func ) )
			{
				newzone.is_occupied = [[ level.zone_occupied_func ]]( zkeys[ z ] );
			}
			else
			{
				newzone.is_occupied = player_in_zone( zkeys[ z ] );
			}
			if ( newzone.is_occupied )
			{
				newzone.is_active = 1;
				a_zone_is_active = 1;
				if ( zone.is_spawning_allowed )
				{
					a_zone_is_spawning_allowed = 1;
				}
				if ( !isdefined(oldzone) || oldzone != newzone )
				{
					level notify( "newzoneActive", zkeys[ z ] );
					oldzone = newzone;
				}
				azkeys = getarraykeys( zone.adjacent_zones );
				for ( az = 0; az < zone.adjacent_zones.size; az++ )
				{
					if ( zone.adjacent_zones[ azkeys[ az ] ].is_connected && level.zones[ azkeys[ az ] ].is_enabled )
					{
						level.newzones[ azkeys[ az ] ].is_active = 1;
						if ( level.zones[ azkeys[ az ] ].is_spawning_allowed )
						{
							a_zone_is_spawning_allowed = 1;
						}
					}
				}
			}
			zone_choke++;
			if ( zone_choke >= 3 )
			{
				zone_choke = 0;
				wait 0.05;
			}
			z++;
		}
		level.zone_scanning_active = 0;
		for ( z = 0; z < zkeys.size; z++ )
		{
			level.zones[ zkeys[ z ] ].is_active = level.newzones[ zkeys[ z ] ].is_active;
			level.zones[ zkeys[ z ] ].is_occupied = level.newzones[ zkeys[ z ] ].is_occupied;
		}
		if ( !a_zone_is_active || !a_zone_is_spawning_allowed )
		{
			if ( isarray( initial_zone ) )
			{
				level.zones[ initial_zone[ 0 ] ].is_active = 1;
				level.zones[ initial_zone[ 0 ] ].is_occupied = 1;
				level.zones[ initial_zone[ 0 ] ].is_spawning_allowed = 1;
			}
			else
			{
				level.zones[ initial_zone ].is_active = 1;
				level.zones[ initial_zone ].is_occupied = 1;
				level.zones[ initial_zone ].is_spawning_allowed = 1;
			}
		}
		[[ level.create_spawner_list_func ]]( zkeys );
		level.active_zone_names = maps\mp\zombies\_zm_zonemgr::get_active_zone_names();
		wait 1;
	}
}

transit_zone_init()
{
    flag_init( "always_on" );
    flag_init( "init_classic_adjacencies" );
    flag_set( "always_on" );

    if ( is_classic() )
    {
        flag_set( "init_classic_adjacencies" );
        add_adjacent_zone( "zone_trans_2", "zone_trans_2b", "init_classic_adjacencies" );
        add_adjacent_zone( "zone_station_ext", "zone_trans_2b", "init_classic_adjacencies", 1 );
        add_adjacent_zone( "zone_town_west2", "zone_town_west", "init_classic_adjacencies" );
        add_adjacent_zone( "zone_town_south", "zone_town_church", "init_classic_adjacencies" );
        add_adjacent_zone( "zone_trans_pow_ext1", "zone_trans_7", "init_classic_adjacencies" );
        add_adjacent_zone( "zone_far", "zone_far_ext", "OnFarm_enter" );
    }
    else
    {
        playable_area = getentarray( "player_volume", "script_noteworthy" );

        foreach ( area in playable_area )
        {
            add_adjacent_zone( "zone_station_ext", "zone_trans_2b", "always_on" );

            if ( isdefined( area.script_parameters ) && area.script_parameters == "classic_only" )
                area delete();
        }
    }

    add_adjacent_zone( "zone_pri2", "zone_station_ext", "OnPriDoorYar", 1 );
    add_adjacent_zone( "zone_pri2", "zone_pri", "OnPriDoorYar3", 1 );

    if ( getdvar( "ui_zm_mapstartlocation" ) == "transit" )
    {
        level thread disconnect_door_zones( "zone_pri2", "zone_station_ext", "OnPriDoorYar" );
        level thread disconnect_door_zones( "zone_pri2", "zone_pri", "OnPriDoorYar3" );
    }

    add_adjacent_zone( "zone_station_ext", "zone_pri", "OnPriDoorYar2" );
    add_adjacent_zone( "zone_roadside_west", "zone_din", "OnGasDoorDin" );
    add_adjacent_zone( "zone_roadside_west", "zone_gas", "always_on" );
    add_adjacent_zone( "zone_roadside_east", "zone_gas", "always_on" );
    add_adjacent_zone( "zone_roadside_east", "zone_gar", "OnGasDoorGar" );
    add_adjacent_zone( "zone_trans_diner", "zone_roadside_west", "always_on", 1 );
    add_adjacent_zone( "zone_trans_diner", "zone_gas", "always_on", 1 );
    add_adjacent_zone( "zone_trans_diner2", "zone_roadside_east", "always_on", 1 );
    add_adjacent_zone( "zone_gas", "zone_din", "OnGasDoorDin" );
    add_adjacent_zone( "zone_gas", "zone_gar", "OnGasDoorGar" );
    add_adjacent_zone( "zone_diner_roof", "zone_din", "OnGasDoorDin", 1 );
    add_adjacent_zone( "zone_tow", "zone_bar", "always_on", 1 );
    add_adjacent_zone( "zone_bar", "zone_tow", "OnTowDoorBar", 1 );
    add_adjacent_zone( "zone_tow", "zone_ban", "OnTowDoorBan" );
    add_adjacent_zone( "zone_ban", "zone_ban_vault", "OnTowBanVault" );
    add_adjacent_zone( "zone_tow", "zone_town_north", "always_on" );
    add_adjacent_zone( "zone_town_north", "zone_ban", "OnTowDoorBan" );
    add_adjacent_zone( "zone_tow", "zone_town_west", "always_on" );
    add_adjacent_zone( "zone_tow", "zone_town_south", "always_on" );
    add_adjacent_zone( "zone_town_south", "zone_town_barber", "always_on", 1 );
    add_adjacent_zone( "zone_tow", "zone_town_east", "always_on" );
    add_adjacent_zone( "zone_town_east", "zone_bar", "OnTowDoorBar" );
    add_adjacent_zone( "zone_tow", "zone_town_barber", "always_on", 1 );
    add_adjacent_zone( "zone_town_barber", "zone_tow", "OnTowDoorBarber", 1 );
    add_adjacent_zone( "zone_town_barber", "zone_town_west", "OnTowDoorBarber" );
    add_adjacent_zone( "zone_far_ext", "zone_brn", "OnFarm_enter" );
    add_adjacent_zone( "zone_far_ext", "zone_farm_house", "open_farmhouse" );
    add_adjacent_zone( "zone_prr", "zone_pow", "OnPowDoorRR", 1 );
    add_adjacent_zone( "zone_pcr", "zone_prr", "OnPowDoorRR" );
    add_adjacent_zone( "zone_pcr", "zone_pow_warehouse", "OnPowDoorWH" );
    add_adjacent_zone( "zone_pow", "zone_pow_warehouse", "always_on" );
    add_adjacent_zone( "zone_tbu", "zone_tow", "vault_opened", 1 );
	add_adjacent_zone( "zone_trans_8","zone_pow", "always_on", 1 );
    add_adjacent_zone( "zone_trans_8", "zone_pow_warehouse", "always_on", 1 );
}