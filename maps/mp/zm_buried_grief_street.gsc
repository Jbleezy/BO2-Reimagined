#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_equip_subwoofer;
#include maps/mp/zombies/_zm_equip_springpad;
#include maps/mp/zombies/_zm_equip_turbine;
//#include maps/mp/zombies/_zm_equip_headchopper;
#include maps/mp/zm_buried_buildables;
#include maps/mp/zm_buried_gamemodes;
#include maps/mp/zombies/_zm_race_utility;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

precache()
{
	// trig = getent("turbine_buildable_trigger", "targetname");
    // if(isDefined(trig))
    // {
    //     trig.targetname = "headchopper_buildable_trigger";
    // }

	precachemodel( "collision_wall_128x128x10_standard" );
	precachemodel( "collision_wall_256x256x10_standard" );
	precachemodel( "collision_wall_512x512x10_standard" );
	precachemodel( "zm_collision_buried_street_grief" );
	precachemodel( "p6_zm_bu_buildable_bench_tarp" );
	level.chalk_buildable_pieces_hide = 1;
	griefbuildables = array( "chalk", "turbine", "springpad_zm", "subwoofer_zm" );
	//griefbuildables = array( "chalk", "headchopper_zm", "springpad_zm", "subwoofer_zm" );
	maps/mp/zm_buried_buildables::include_buildables( griefbuildables );
	maps/mp/zm_buried_buildables::init_buildables( griefbuildables );
	maps/mp/zombies/_zm_equip_turbine::init();
	maps/mp/zombies/_zm_equip_turbine::init_animtree();
	maps/mp/zombies/_zm_equip_springpad::init( &"ZM_BURIED_EQ_SP_PHS", &"ZM_BURIED_EQ_SP_HTS" );
	maps/mp/zombies/_zm_equip_subwoofer::init( &"ZM_BURIED_EQ_SW_PHS", &"ZM_BURIED_EQ_SW_HTS" );
    //maps/mp/zombies/_zm_equip_headchopper::init( &"ZM_BURIED_EQ_HC_PHS", &"ZM_BURIED_EQ_HC_HTS" );
}

street_treasure_chest_init()
{
	start_chest = getstruct( "start_chest", "script_noteworthy" );
	court_chest = getstruct( "courtroom_chest1", "script_noteworthy" );
	jail_chest = getstruct( "jail_chest1", "script_noteworthy" );
	gun_chest = getstruct( "gunshop_chest", "script_noteworthy" );
	setdvar( "disableLookAtEntityLogic", 1 );
	level.chests = [];
	level.chests[ level.chests.size ] = start_chest;
	level.chests[ level.chests.size ] = court_chest;
	level.chests[ level.chests.size ] = jail_chest;
	level.chests[ level.chests.size ] = gun_chest;

	chest_names = array("start_chest", "courtroom_chest1", "jail_chest1", "gunshop_chest");
	chest_name = random(chest_names);
	maps/mp/zombies/_zm_magicbox::treasure_chest_init( chest_name );
}

main()
{
	level.buildables_built[ "pap" ] = 1;
	level.equipment_team_pick_up = 1;
	level thread maps/mp/zombies/_zm_buildables::think_buildables();
	maps/mp/gametypes_zm/_zm_gametype::setup_standard_objects( "street" );
	street_treasure_chest_init();
	generatebuildabletarps();
	deletebuildabletarp( "courthouse" );
	deletebuildabletarp( "bar" );
	deletebuildabletarp( "generalstore" );
	deleteslothbarricades();

	disable_tunnels();
	move_quickrevive_machine();
	move_speedcola_machine();
	move_staminup_machine();
	override_spawn_init();

	powerswitchstate( 1 );
	level.enemy_location_override_func = ::enemy_location_override;
	spawnmapcollision( "zm_collision_buried_street_grief" );
	flag_wait( "initial_blackscreen_passed" );
	flag_wait( "start_zombie_round_logic" );
	wait 1;
	builddynamicwallbuys();
	buildbuildables();
	turnperkon( "revive" );
	turnperkon( "doubletap" );
	turnperkon( "marathon" );
	turnperkon( "juggernog" );
	turnperkon( "sleight" );
	turnperkon( "additionalprimaryweapon" );
	turnperkon( "Pack_A_Punch" );
}

enemy_location_override( zombie, enemy )
{
	location = enemy.origin;
	if ( isDefined( self.reroute ) && self.reroute )
	{
		if ( isDefined( self.reroute_origin ) )
		{
			location = self.reroute_origin;
		}
	}
	return location;
}

builddynamicwallbuys()
{
	builddynamicwallbuy( "morgue", "pdw57_zm" );
	builddynamicwallbuy( "church", "svu_zm" );
	builddynamicwallbuy( "mansion", "an94_zm" );

	scripts/zm/main/_zm_reimagined::wallbuy_increase_trigger_radius();
	scripts/zm/main/_zm_reimagined::wallbuy_decrease_upgraded_ammo_cost();
}

builddynamicwallbuy( location, weaponname )
{
	foreach ( stub in level.chalk_builds )
	{
		wallbuy = getstruct( stub.target, "targetname" );

		if ( isDefined( wallbuy.script_location ) && wallbuy.script_location == location )
		{
			spawned_wallbuy = undefined;
			for ( i = 0; i < level._spawned_wallbuys.size; i++ )
			{
				if ( level._spawned_wallbuys[ i ].target == wallbuy.targetname )
				{
					spawned_wallbuy = level._spawned_wallbuys[ i ];
					break;
				}
			}

			if ( !isDefined( spawned_wallbuy ) )
			{
				origin = wallbuy.origin;

				// center wallbuy chalk and model, and adjust wallbuy trigger
				if(weaponname == "pdw57_zm")
				{
					origin += anglesToForward(wallbuy.angles) * 12;
					wallbuy.origin += anglesToForward(wallbuy.angles) * 3;
				}
				else if(weaponname == "svu_zm")
				{
					origin += anglesToForward(wallbuy.angles) * 24;
					wallbuy.origin += anglesToForward(wallbuy.angles) * 15;
				}

				struct = spawnStruct();
				struct.target = wallbuy.targetname;
				level._spawned_wallbuys[level._spawned_wallbuys.size] = struct;

				// move model foreward so it always shows in front of chalk
				model = spawn_weapon_model( weaponname, undefined, origin + anglesToRight(wallbuy.angles) * -0.25, wallbuy.angles );
				model.targetname = struct.target;
				model setmodel( getWeaponModel(weaponname) );
				model useweaponhidetags( weaponname );
				model hide();

				chalk_fx = weaponname + "_fx";
				thread scripts/zm/main/_zm_reimagined::playchalkfx( chalk_fx, origin, wallbuy.angles );
			}

			maps/mp/zombies/_zm_weapons::add_dynamic_wallbuy( weaponname, wallbuy.targetname, 1 );
			thread wait_and_remove( stub, stub.buildablezone.pieces[ 0 ] );
		}
	}
}

buildbuildables()
{
    // hack for headchopper model
    // foreach(stub in level.buildable_stubs)
	// {
	// 	if(stub.equipname == "headchopper_zm")
    //     {
    //         origin_offset = (anglesToRight(stub.angles) * 8.57037) + (anglesToUp(stub.angles) * 17.78);
    //         angles_offset = (61.5365, 90.343, 0.216167);

    //         stub.model setModel("t6_wpn_zmb_chopper");
    //         stub.model.origin += origin_offset;
    //         stub.model.angles = stub.angles + angles_offset;
    //     }
    // }

	//buildbuildable( "headchopper_zm" );
	buildbuildable( "springpad_zm" );
	buildbuildable( "subwoofer_zm" );
	buildbuildable( "turbine" );
}

disable_tunnels()
{
	// stables tunnel entrance
	origin = (-1502, -262, 26);
	angles = ( 0, 90, 5 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
	model = spawn( "script_model", origin + (0, 60, 0) );
	model.angles = angles;
	model setmodel( "p6_zm_bu_wood_door_bare" );
	model = spawn( "script_model", origin + (0, -60, 0) );
	model.angles = angles;
	model setmodel( "p6_zm_bu_wood_door_bare_right" );

	// stables tunnel exit
	origin = (-22, -1912, 269);
	angles = ( 0, -90, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 128 );
	collision.angles = angles;
	collision setmodel( "collision_wall_256x256x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// saloon tunnel entrance
	origin = (488, -1778, 188);
	angles = ( 0, 0, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// saloon tunnel exit
	origin = (120, -1984, 228);
	angles = ( 0, 45, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 128 );
	collision.angles = angles;
	collision setmodel( "collision_wall_256x256x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// main tunnel saloon side
	origin = (770, -863, 320);
	angles = ( 0, 180, -35 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 128 );
	collision.angles = angles;
	collision setmodel( "collision_wall_256x256x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// main tunnel courthouse side
	origin = (349, 579, 240);
	angles = ( 0, 0, -10 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
	model = spawn( "script_model", origin );
	model.angles = angles;
	model setmodel( "p6_zm_bu_sloth_blocker_medium" );

	// main tunnel above general store
	origin = (-123, -801, 326);
	angles = ( 0, 0, 90 );
	collision = spawn( "script_model", origin );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );

	// main tunnel above jail
	origin = (-852, 408, 379);
	angles = ( 0, 0, 90 );
	collision = spawn( "script_model", origin );
	collision.angles = angles;
	collision setmodel( "collision_wall_512x512x10_standard" );

	// main tunnel above stables
	origin = (-713, -313, 287);
	angles = ( 0, 0, 90 );
	collision = spawn( "script_model", origin );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );

	// gunsmith debris
	debris_trigs = getentarray( "zombie_debris", "targetname" );
	foreach ( debris_trig in debris_trigs )
	{
		if ( debris_trig.target == "pf728_auto2534" )
		{
			debris_trig delete();
		}
	}

	// zombie spawns
	level.zones["zone_tunnel_gun2saloon"].is_enabled = 0;
	level.zones["zone_tunnel_gun2saloon"].is_spawning_allowed = 0;
	level.zones["zone_tunnel_gun2stables2"].is_enabled = 0;
	level.zones["zone_tunnel_gun2stables2"].is_spawning_allowed = 0;
	foreach ( spawn_location in level.zones["zone_stables"].spawn_locations )
	{
		if ( spawn_location.origin == ( -1551, -611, 36.69 ) )
		{
			spawn_location.is_enabled = false;
		}
	}

	// player spawns
	invalid_zones = array("zone_start", "zone_tunnels_center", "zone_tunnels_north", "zone_tunnels_south");
	spawn_points = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
	foreach(spawn_point in spawn_points)
	{
		if(isinarray(invalid_zones, spawn_point.script_noteworthy))
		{
			spawn_point.locked = 1;
		}
	}
}

move_quickrevive_machine()
{
	if (level.scr_zm_map_start_location != "street")
	{
		return;
	}

	perk_struct = undefined;
	perk_location_struct = undefined;
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach (struct in structs)
	{
		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_quickrevive" && IsSubStr(struct.script_string, "zgrief"))
			{
				perk_struct = struct;
			}
			else if (struct.script_noteworthy == "specialty_fastreload" && IsSubStr(struct.script_string, "zgrief"))
			{
				perk_location_struct = struct;
			}
		}
	}

	if(!IsDefined(perk_struct) || !IsDefined(perk_location_struct))
	{
		return;
	}

	// delete old machine
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	for (i = 0; i < vending_trigger.size; i++)
	{
		trig = vending_triggers[i];
		if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_quickrevive")
		{
			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
			trig delete();
			break;
		}
	}

	// spawn new machine
	perk_location_struct.origin += (0, -32, 0); // fix for location being off
	use_trigger = spawn( "trigger_radius_use", perk_location_struct.origin + vectorScale( ( 0, 0, 1 ), 30 ), 0, 40, 70 );
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = perk_struct.script_noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn( "script_model", perk_location_struct.origin );
	perk_machine.angles = perk_location_struct.angles;
	perk_machine setmodel( perk_struct.model );
	bump_trigger = spawn( "trigger_radius", perk_location_struct.origin + AnglesToRight(perk_location_struct.angles) * 32, 0, 35, 32 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn( "script_model", perk_location_struct.origin, 1 );
	collision.angles = perk_location_struct.angles;
	collision setmodel( "zm_collision_perks1" );
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if ( isDefined( perk_struct.blocker_model ) )
	{
		use_trigger.blocker_model = perk_struct.blocker_model;
	}
	if ( isDefined( perk_struct.script_int ) )
	{
		perk_machine.script_int = perk_struct.script_int;
	}
	if ( isDefined( perk_struct.turn_on_notify ) )
	{
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}

	use_trigger.script_sound = "mus_perks_revive_jingle";
	use_trigger.script_string = "revive_perk";
	use_trigger.script_label = "mus_perks_revive_sting";
	use_trigger.target = "vending_revive";
	perk_machine.script_string = "revive_perk";
	perk_machine.targetname = "vending_revive";
	bump_trigger.script_string = "revive_perk";

	level thread maps/mp/zombies/_zm_perks::turn_revive_on();
	use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();

	powered_on = maps/mp/zombies/_zm_perks::get_perk_machine_start_state( use_trigger.script_noteworthy );
	maps/mp/zombies/_zm_power::add_powered_item( maps/mp/zombies/_zm_power::perk_power_on, scripts/zm/main/_zm_reimagined::perk_power_off, maps/mp/zombies/_zm_power::perk_range, maps/mp/zombies/_zm_power::cost_low_if_local, 0, powered_on, use_trigger );
}

move_speedcola_machine()
{
	if (level.scr_zm_map_start_location != "street")
	{
		return;
	}

	perk_struct = undefined;
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach (struct in structs)
	{
		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_fastreload" && IsSubStr(struct.script_string, "zclassic"))
			{
				perk_struct = struct;
				break;
			}
		}
	}

	if(!IsDefined(perk_struct))
	{
		return;
	}

	// delete old machine
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	for (i = 0; i < vending_trigger.size; i++)
	{
		trig = vending_triggers[i];
		if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_fastreload")
		{
			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
			trig delete();
			break;
		}
	}

	// spawn new machine
	use_trigger = spawn( "trigger_radius_use", perk_struct.origin + vectorScale( ( 0, 0, 1 ), 30 ), 0, 40, 70 );
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = perk_struct.script_noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn( "script_model", perk_struct.origin );
	perk_machine.angles = perk_struct.angles;
	perk_machine setmodel( perk_struct.model );
	bump_trigger = spawn( "trigger_radius", perk_struct.origin + AnglesToRight(perk_struct.angles) * 32, 0, 35, 32 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn( "script_model", perk_struct.origin, 1 );
	collision.angles = perk_struct.angles;
	collision setmodel( "zm_collision_perks1" );
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if ( isDefined( perk_struct.blocker_model ) )
	{
		use_trigger.blocker_model = perk_struct.blocker_model;
	}
	if ( isDefined( perk_struct.script_int ) )
	{
		perk_machine.script_int = perk_struct.script_int;
	}
	if ( isDefined( perk_struct.turn_on_notify ) )
	{
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}

	use_trigger.script_sound = "mus_perks_speed_jingle";
	use_trigger.script_string = "speedcola_perk";
	use_trigger.script_label = "mus_perks_speed_sting";
	use_trigger.target = "vending_sleight";
	perk_machine.script_string = "speedcola_perk";
	perk_machine.targetname = "vending_sleight";
	bump_trigger.script_string = "speedcola_perk";

	level thread maps/mp/zombies/_zm_perks::turn_sleight_on();
	use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();

	powered_on = maps/mp/zombies/_zm_perks::get_perk_machine_start_state( use_trigger.script_noteworthy );
	maps/mp/zombies/_zm_power::add_powered_item( maps/mp/zombies/_zm_power::perk_power_on, scripts/zm/main/_zm_reimagined::perk_power_off, maps/mp/zombies/_zm_power::perk_range, maps/mp/zombies/_zm_power::cost_low_if_local, 0, powered_on, use_trigger );
}

move_staminup_machine()
{
	if (level.scr_zm_map_start_location != "street")
	{
		return;
	}

	perk_struct = undefined;
	perk_location_struct = undefined;
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach (struct in structs)
	{
		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_longersprint" && IsSubStr(struct.script_string, "zgrief"))
			{
				perk_struct = struct;
			}
			else if (struct.script_noteworthy == "specialty_quickrevive" && IsSubStr(struct.script_string, "zgrief"))
			{
				perk_location_struct = struct;
			}
		}
	}

	if(!IsDefined(perk_struct) || !IsDefined(perk_location_struct))
	{
		return;
	}

	// delete old machine
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	for (i = 0; i < vending_trigger.size; i++)
	{
		trig = vending_triggers[i];
		if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_longersprint")
		{
			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
			trig delete();
			break;
		}
	}

	// spawn new machine
	use_trigger = spawn( "trigger_radius_use", perk_location_struct.origin + vectorScale( ( 0, 0, 1 ), 30 ), 0, 40, 70 );
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = perk_struct.script_noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn( "script_model", perk_location_struct.origin );
	perk_machine.angles = perk_location_struct.angles;
	perk_machine setmodel( perk_struct.model );
	bump_trigger = spawn( "trigger_radius", perk_location_struct.origin + AnglesToRight(perk_location_struct.angles) * 32, 0, 35, 32 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn( "script_model", perk_location_struct.origin, 1 );
	collision.angles = perk_location_struct.angles;
	collision setmodel( "zm_collision_perks1" );
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if ( isDefined( perk_struct.blocker_model ) )
	{
		use_trigger.blocker_model = perk_struct.blocker_model;
	}
	if ( isDefined( perk_struct.script_int ) )
	{
		perk_machine.script_int = perk_struct.script_int;
	}
	if ( isDefined( perk_struct.turn_on_notify ) )
	{
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}

	use_trigger.script_sound = "mus_perks_stamin_jingle";
	use_trigger.script_string = "marathon_perk";
	use_trigger.script_label = "mus_perks_stamin_sting";
	use_trigger.target = "vending_marathon";
	perk_machine.script_string = "marathon_perk";
	perk_machine.targetname = "vending_marathon";
	bump_trigger.script_string = "marathon_perk";

	level thread maps/mp/zombies/_zm_perks::turn_marathon_on();
	use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();

	powered_on = maps/mp/zombies/_zm_perks::get_perk_machine_start_state( use_trigger.script_noteworthy );
	maps/mp/zombies/_zm_power::add_powered_item( maps/mp/zombies/_zm_power::perk_power_on, scripts/zm/main/_zm_reimagined::perk_power_off, maps/mp/zombies/_zm_power::perk_range, maps/mp/zombies/_zm_power::cost_low_if_local, 0, powered_on, use_trigger );
}

override_spawn_init()
{
	// remove existing initial spawns
	structs = getstructarray("initial_spawn", "script_noteworthy");
	array_delete(structs, true);
	level.struct_class_names["script_noteworthy"]["initial_spawn"] = [];

	// set new initial spawns to be same as respawns already on map
	ind = 0;
	spawn_points = maps/mp/gametypes_zm/_zm_gametype::get_player_spawns_for_gametype();
	for(i = 0; i < spawn_points.size; i++)
	{
		if(spawn_points[i].script_noteworthy == "zone_stables")
		{
			ind = i;
			break;
		}
	}

	init_spawn_array = getstructarray(spawn_points[ind].target, "targetname");
	foreach(init_spawn in init_spawn_array)
	{
		struct = spawnStruct();
		struct.origin = init_spawn.origin;
		struct.angles = init_spawn.angles;
		struct.radius = init_spawn.radius;

		if(struct.origin == (-722.02, -151.75, 124.14))
		{
			struct.script_int = 1;
		}
		else if(struct.origin == (-891.27, -209.95, 137.94))
		{
			struct.script_int = 2;
		}
		else
		{
			struct.script_int = init_spawn.script_int;
		}

		struct.script_noteworthy = "initial_spawn";
		struct.script_string = "zgrief_street";

		size = level.struct_class_names["script_noteworthy"][struct.script_noteworthy].size;
		level.struct_class_names["script_noteworthy"][struct.script_noteworthy][size] = struct;
	}
}