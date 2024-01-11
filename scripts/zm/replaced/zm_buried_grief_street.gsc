#include maps\mp\zm_buried_grief_street;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_equip_subwoofer;
#include maps\mp\zombies\_zm_equip_springpad;
#include maps\mp\zombies\_zm_equip_turbine;
#include maps\mp\zombies\_zm_equip_headchopper;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_race_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

precache()
{
	precachemodel("collision_wall_128x128x10_standard");
	precachemodel("collision_wall_256x256x10_standard");
	precachemodel("collision_wall_512x512x10_standard");
	precachemodel("zm_collision_buried_street_grief");
	precachemodel("p6_zm_bu_buildable_bench_tarp");

	level.chalk_buildable_pieces_hide = 1;
	griefbuildables = array("chalk", "turbine", "springpad_zm", "subwoofer_zm", "headchopper_zm");
	maps\mp\zm_buried_buildables::include_buildables(griefbuildables);
	maps\mp\zm_buried_buildables::init_buildables(griefbuildables);
	maps\mp\zombies\_zm_equip_turbine::init();
	maps\mp\zombies\_zm_equip_turbine::init_animtree();
	maps\mp\zombies\_zm_equip_springpad::init(&"ZM_BURIED_EQ_SP_PHS", &"ZM_BURIED_EQ_SP_HTS");
	maps\mp\zombies\_zm_equip_subwoofer::init(&"ZM_BURIED_EQ_SW_PHS", &"ZM_BURIED_EQ_SW_HTS");
	maps\mp\zombies\_zm_equip_headchopper::init(&"ZM_BURIED_EQ_HC_PHS", &"ZM_BURIED_EQ_HC_HTS");
}

main()
{
	level.buildables_built["pap"] = 1;
	level.equipment_team_pick_up = 1;
	level.zones["zone_mansion"].is_enabled = 0;
	level thread maps\mp\zombies\_zm_buildables::think_buildables();
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects("street");
	street_treasure_chest_init();
	deleteslothbarricades();
	disable_tunnels();
	powerswitchstate(1);
	level.enemy_location_override_func = ::enemy_location_override;
	spawnmapcollision("zm_collision_buried_street_grief");
	flag_wait("initial_blackscreen_passed");
	flag_wait("start_zombie_round_logic");
	wait 1;
	builddynamicwallbuys();
	buildbuildables();
	turnperkon("revive");
	turnperkon("doubletap");
	turnperkon("marathon");
	turnperkon("juggernog");
	turnperkon("sleight");
	turnperkon("additionalprimaryweapon");
	turnperkon("Pack_A_Punch");
}

enemy_location_override(zombie, enemy)
{
	location = enemy.origin;

	if (isDefined(self.reroute) && self.reroute)
	{
		if (isDefined(self.reroute_origin))
		{
			location = self.reroute_origin;
		}
	}

	return location;
}

street_treasure_chest_init()
{
	start_chest = getstruct("start_chest", "script_noteworthy");
	court_chest = getstruct("courtroom_chest1", "script_noteworthy");
	jail_chest = getstruct("jail_chest1", "script_noteworthy");
	gun_chest = getstruct("gunshop_chest", "script_noteworthy");
	setdvar("disableLookAtEntityLogic", 1);
	level.chests = [];
	level.chests[level.chests.size] = start_chest;
	level.chests[level.chests.size] = court_chest;
	level.chests[level.chests.size] = jail_chest;
	level.chests[level.chests.size] = gun_chest;

	chest_names = array("start_chest", "courtroom_chest1", "jail_chest1", "gunshop_chest");
	chest_name = random(chest_names);
	maps\mp\zombies\_zm_magicbox::treasure_chest_init(chest_name);
}

builddynamicwallbuys()
{
	builddynamicwallbuy("prison", "ballista_zm");
	builddynamicwallbuy("morgue", "pdw57_zm");
	builddynamicwallbuy("bar", "vector_zm");
	builddynamicwallbuy("church", "svu_zm");
	builddynamicwallbuy("mansion", "an94_zm");
}

buildbuildables()
{
	buildbuildable("headchopper_zm");
	buildbuildable("springpad_zm");
	buildbuildable("subwoofer_zm");
	buildbuildable("turbine");
}

disable_tunnels()
{
	// main tunnel saloon side
	origin = (770, -863, 320);
	angles = (0, 180, -35);
	collision = spawn("script_model", origin + anglesToUp(angles) * 128);
	collision.angles = angles;
	collision setmodel("collision_wall_256x256x10_standard");
	model = spawn("script_model", origin);
	model.angles = angles;
	model setmodel("p6_zm_bu_sloth_blocker_medium");

	// main tunnel courthouse side
	origin = (349, 579, 240);
	angles = (0, 0, -10);
	collision = spawn("script_model", origin + anglesToUp(angles) * 64);
	collision.angles = angles;
	collision setmodel("collision_wall_128x128x10_standard");
	model = spawn("script_model", origin);
	model.angles = angles;
	model setmodel("p6_zm_bu_sloth_blocker_medium");

	// main tunnel above general store
	origin = (-123, -801, 326);
	angles = (0, 0, 90);
	collision = spawn("script_model", origin);
	collision.angles = angles;
	collision setmodel("collision_wall_128x128x10_standard");

	// main tunnel above jail
	origin = (-852, 408, 379);
	angles = (0, 0, 90);
	collision = spawn("script_model", origin);
	collision.angles = angles;
	collision setmodel("collision_wall_512x512x10_standard");

	// main tunnel above stables
	origin = (-713, -313, 287);
	angles = (0, 0, 90);
	collision = spawn("script_model", origin);
	collision.angles = angles;
	collision setmodel("collision_wall_128x128x10_standard");

	// bank top
	model = spawn("script_model", (-371.839, -448.016, 224.125));
	model.angles = (0, 180, -90);
	model setmodel("p6_zm_bu_wood_planks_106x171");
	model = spawn("script_model", (-381.252, -443.056, 144.125), 1);
	model.angles = (0, 0, 0);
	model setmodel("collision_clip_wall_128x128x10");
	model disconnectpaths();

	// bank tunnel
	model = spawn("script_model", (-54.6069, -1129.47, 6.125));
	model.angles = (0, 0, 0);
	model setmodel("p6_zm_bu_wood_planks_106x171");
	model = spawn("script_model", (-92.6853, -1075.92, 8.125));
	model.angles = (0, 140, 0);
	model setmodel("p6_zm_bu_sloth_blocker_medium");
	model = spawn("script_model", (-40.3028, -1158.31, 3.125));
	model.angles = (0, -90, -15);
	model setmodel("p6_zm_bu_victorian_couch");
	model = spawn("script_model", (-75.4725, -1156.37, 52.125));
	model.angles = (0, 0, 180);
	model setmodel("p6_zm_work_bench");
	model = spawn("script_model", (-53.4637, -1165.89, 8.125), 1);
	model.angles = (0, 0, 0);
	model setmodel("collision_clip_64x64x128");
	model disconnectpaths();

	// zombie spawns
	level.zones["zone_tunnels_center"].is_enabled = 0;
	level.zones["zone_tunnels_center"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_north"].is_enabled = 0;
	level.zones["zone_tunnels_north"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_north2"].is_enabled = 0;
	level.zones["zone_tunnels_north2"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_south"].is_enabled = 0;
	level.zones["zone_tunnels_south"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_south2"].is_enabled = 0;
	level.zones["zone_tunnels_south2"].is_spawning_allowed = 0;
	level.zones["zone_tunnels_south3"].is_enabled = 0;
	level.zones["zone_tunnels_south3"].is_spawning_allowed = 0;
	level.zones["zone_bank"].is_enabled = 0;
	level.zones["zone_bank"].is_spawning_allowed = 0;

	// player spawns
	invalid_zones = array("zone_start", "zone_tunnels_center", "zone_tunnels_north", "zone_tunnels_south");
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	foreach (spawn_point in spawn_points)
	{
		if (isinarray(invalid_zones, spawn_point.script_noteworthy))
		{
			spawn_point.locked = 1;
		}
	}
}