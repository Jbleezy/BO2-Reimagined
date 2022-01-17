#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/zm_transit;
#include scripts/zm/replaced/zm_transit_gamemodes;
#include scripts/zm/replaced/zm_transit_utility;
#include scripts/zm/replaced/_zm_weap_emp_bomb;
#include scripts/zm/replaced/_zm_equip_electrictrap;
#include scripts/zm/replaced/_zm_equip_turret;
#include scripts/zm/replaced/_zm_banking;

main()
{
	replaceFunc(maps/mp/zm_transit::lava_damage_depot, scripts/zm/replaced/zm_transit::lava_damage_depot);
	replaceFunc(maps/mp/zm_transit_gamemodes::init, scripts/zm/replaced/zm_transit_gamemodes::init);
	replaceFunc(maps/mp/zm_transit_utility::solo_tombstone_removal, scripts/zm/replaced/zm_transit_utility::solo_tombstone_removal);
	replaceFunc(maps/mp/zombies/_zm_weap_emp_bomb::emp_detonate, scripts/zm/replaced/_zm_weap_emp_bomb::emp_detonate);
	replaceFunc(maps/mp/zombies/_zm_equip_electrictrap::startelectrictrapdeploy, scripts/zm/replaced/_zm_equip_electrictrap::startelectrictrapdeploy);
	replaceFunc(maps/mp/zombies/_zm_equip_turret::startturretdeploy, scripts/zm/replaced/_zm_equip_turret::startturretdeploy);
	replaceFunc(maps/mp/zombies/_zm_banking::init, scripts/zm/replaced/_zm_banking::init);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_deposit_box, scripts/zm/replaced/_zm_banking::bank_deposit_box);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_deposit_unitrigger, scripts/zm/replaced/_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_withdraw_unitrigger, scripts/zm/replaced/_zm_banking::bank_withdraw_unitrigger);

	include_weapons_grief();
}

init()
{
	level.grenade_safe_to_bounce = ::grenade_safe_to_bounce;

	screecher_spawner_changes();
	zombie_spawn_location_changes();
	path_exploit_fixes();

	level thread power_local_electric_doors_globally();
	level thread b23r_hint_string_fix();
	level thread power_station_vision_change();
}

include_weapons_grief()
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
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "knife_ballistic_zm", 1 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "ray_gun_zm", 4 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "ray_gun_upgraded_zm", 4 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "knife_ballistic_upgraded_zm", 0 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "knife_ballistic_no_melee_zm", 0 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "knife_ballistic_no_melee_upgraded_zm", 0 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "knife_ballistic_bowie_zm", 0 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "knife_ballistic_bowie_upgraded_zm", 0 );
	include_weapon( "raygun_mark2_zm" );
	include_weapon( "raygun_mark2_upgraded_zm", 0 );
	maps/mp/zombies/_zm_weapons::add_weapon_to_content( "raygun_mark2_zm", "dlc3" );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "raygun_mark2_zm", 1 );
	maps/mp/zombies/_zm_weapons::add_limited_weapon( "raygun_mark2_upgraded_zm", 1 );
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
				local_power[local_power.size] = maps/mp/zombies/_zm_power::add_local_power( zombie_doors[i].origin, 16 );
			}
		}

		flag_waitopen( "power_on" );

		for (i = 0; i < local_power.size; i++)
		{
			maps/mp/zombies/_zm_power::end_local_power( local_power[i] );
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
			hint = maps/mp/zombies/_zm_weapons::get_weapon_hint(trig.zombie_weapon_upgrade);
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

	if ( self maps/mp/zm_transit_lava::object_touching_lava() )
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
	level thread maps/mp/zombies/_zm_ffotd::path_exploit_fix( zombie_trigger_origin, zombie_trigger_radius, zombie_trigger_height, player_trigger_origin, player_trigger_radius, zombie_goto_point );
}

power_station_vision_change()
{
	level.default_r_exposureValue = 3;
	level.changed_r_exposureValue = 4;
	time = 1;

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
				if(player maps/mp/zombies/_zm_zonemgr::entity_in_zone("zone_prr") || player maps/mp/zombies/_zm_zonemgr::entity_in_zone("zone_pcr"))
				{
					player.power_station_vision_set = 1;
					player thread change_dvar_over_time("r_exposureValue", level.changed_r_exposureValue, time, 1);
				}
			}
			else
			{
				if(!(player maps/mp/zombies/_zm_zonemgr::entity_in_zone("zone_prr") || player maps/mp/zombies/_zm_zonemgr::entity_in_zone("zone_pcr")))
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