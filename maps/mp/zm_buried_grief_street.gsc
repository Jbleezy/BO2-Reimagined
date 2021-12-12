#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_equip_subwoofer;
#include maps/mp/zombies/_zm_equip_springpad;
#include maps/mp/zombies/_zm_equip_turbine;
#include maps/mp/zm_buried_buildables;
#include maps/mp/zm_buried_gamemodes;
#include maps/mp/zombies/_zm_race_utility;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

precache()
{
	precachemodel( "zm_collision_buried_street_grief" );
	precachemodel( "p6_zm_bu_buildable_bench_tarp" );
	level.chalk_buildable_pieces_hide = 1;
	griefbuildables = array( "chalk", "turbine", "springpad_zm", "subwoofer_zm" );
	maps/mp/zm_buried_buildables::include_buildables( griefbuildables );
	maps/mp/zm_buried_buildables::init_buildables( griefbuildables );
	maps/mp/zombies/_zm_equip_turbine::init();
	maps/mp/zombies/_zm_equip_turbine::init_animtree();
	maps/mp/zombies/_zm_equip_springpad::init( &"ZM_BURIED_EQ_SP_PHS", &"ZM_BURIED_EQ_SP_HTS" );
	maps/mp/zombies/_zm_equip_subwoofer::init( &"ZM_BURIED_EQ_SW_PHS", &"ZM_BURIED_EQ_SW_HTS" );
}

street_treasure_chest_init()
{
	start_chest = getstruct( "start_chest", "script_noteworthy" );
	court_chest = getstruct( "courtroom_chest1", "script_noteworthy" );
	tunnel_chest = getstruct( "tunnels_chest1", "script_noteworthy" );
	jail_chest = getstruct( "jail_chest1", "script_noteworthy" );
	gun_chest = getstruct( "gunshop_chest", "script_noteworthy" );
	setdvar( "disableLookAtEntityLogic", 1 );
	level.chests = [];
	level.chests[ level.chests.size ] = start_chest;
	level.chests[ level.chests.size ] = court_chest;
	level.chests[ level.chests.size ] = tunnel_chest;
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
	buildbuildable( "springpad_zm" );
	buildbuildable( "subwoofer_zm" );
	buildbuildable( "turbine" );
}