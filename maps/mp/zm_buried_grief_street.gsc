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
	//tunnel_chest = getstruct( "tunnels_chest1", "script_noteworthy" );
	jail_chest = getstruct( "jail_chest1", "script_noteworthy" );
	gun_chest = getstruct( "gunshop_chest", "script_noteworthy" );
	setdvar( "disableLookAtEntityLogic", 1 );
	level.chests = [];
	level.chests[ level.chests.size ] = start_chest;
	level.chests[ level.chests.size ] = court_chest;
	//level.chests[ level.chests.size ] = tunnel_chest;
	level.chests[ level.chests.size ] = jail_chest;
	level.chests[ level.chests.size ] = gun_chest;
	maps/mp/zombies/_zm_magicbox::treasure_chest_init( "start_chest" );
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
	builddynamicwallbuy( "bank", "beretta93r_zm" );
	builddynamicwallbuy( "bar", "pdw57_zm" );
	builddynamicwallbuy( "church", "ak74u_zm" );
	builddynamicwallbuy( "courthouse", "mp5k_zm" );
	builddynamicwallbuy( "generalstore", "m16_zm" );
	builddynamicwallbuy( "mansion", "an94_zm" );
	builddynamicwallbuy( "morgue", "svu_zm" );
	builddynamicwallbuy( "prison", "claymore_zm" );
	builddynamicwallbuy( "stables", "bowie_knife_zm" );
	builddynamicwallbuy( "stablesroof", "frag_grenade_zm" );
	builddynamicwallbuy( "toystore", "tazer_knuckles_zm" );
	builddynamicwallbuy( "candyshop", "870mcs_zm" );
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
		struct.script_int = init_spawn.script_int;
		struct.script_noteworthy = "initial_spawn";
		struct.script_string = "zgrief_street";

		size = level.struct_class_names["script_noteworthy"][struct.script_noteworthy].size;
		level.struct_class_names["script_noteworthy"][struct.script_noteworthy][size] = struct;
	}
}