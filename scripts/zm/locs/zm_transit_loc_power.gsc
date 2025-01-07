#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	scripts\zm\replaced\utility::register_perk_struct("specialty_armorvest", "zombie_vending_jugg", (10952, 8055, -565), (0, 270, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_quickrevive", "zombie_vending_quickrevive", (11855, 7308, -758), (0, 220, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_fastreload", "zombie_vending_sleight", (11571, 7723, -757), (0, 0, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_rof", "zombie_vending_doubletap2", (11414, 8930, -352), (0, 0, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_scavenger", "zombie_vending_tombstone", (10946, 8308.77, -408), (0, 270, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", (12333, 8158, -752), (0, 180, 0));

	ind = 0;
	respawnpoints = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	for (i = 0; i < respawnpoints.size; i++)
	{
		if (respawnpoints[i].script_noteworthy == "zone_prr")
		{
			ind = i;
			break;
		}
	}

	zone = "zone_pow";
	scripts\zm\replaced\utility::register_map_spawn_group((10160, 7820, -541), zone, 6000);

	scripts\zm\replaced\utility::register_map_spawn((10160, 8060, -541), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10160, 7996, -541), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10160, 7932, -541), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10160, 7868, -541), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10160, 7772, -541), (0, 0, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((10160, 7708, -541), (0, 0, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((10160, 7644, -541), (0, 0, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((10160, 7580, -541), (0, 0, 0), zone, 2);

	zone = "zone_prr";
	scripts\zm\replaced\utility::register_map_spawn_group(respawnpoints[ind].origin, zone, respawnpoints[ind].script_int);

	respawn_array = getstructarray(respawnpoints[ind].target, "targetname");

	foreach (respawn in respawn_array)
	{
		angles = respawn.angles;

		if (respawn.origin[0] < 12200)
		{
			angles += (0, 90, 0);
		}
		else
		{
			angles += (0, -90, 0);
		}

		scripts\zm\replaced\utility::register_map_spawn(respawn.origin, angles, zone);
	}

	zone = "zone_pow_warehouse";
	scripts\zm\replaced\utility::register_map_spawn_group((11033, 8587, -387), zone, 6000);

	scripts\zm\replaced\utility::register_map_spawn((11341, 8300, -459), (0, 90, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((11341, 8587, -387), (0, 90, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((11341, 8846, -322), (0, 180, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((10630, 8846, -323), (0, -90, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((10630, 8451, -379), (0, 0, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((10884, 8192, -379), (0, 180, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((11359, 8774, -548), (0, -90, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((11719, 8608, -547), (0, -90, 0), zone);
}

precache()
{

}

main()
{
	treasure_chest_init();
	init_barriers();
	show_powerswitch();
	activate_core();
	generatebuildabletarps();
	disable_zombie_spawn_locations();
	disable_player_spawn_locations();
	scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	chest = getstruct("pow_chest", "script_noteworthy");
	level.chests = [];
	level.chests[0] = chest;
	maps\mp\zombies\_zm_magicbox::treasure_chest_init("pow_chest");
}

init_barriers()
{
	// fog before power station
	origin = (10215, 7265, -570);
	angles = (0, 0, 0);
	scripts\zm\locs\loc_common::barrier("collision_clip_wall_512x512x10", origin + (anglesToUp(angles) * 256), angles, 1);
	scripts\zm\locs\loc_common::barrier("veh_t6_civ_microbus_dead", origin + (anglesToForward(angles) * 96) + (anglesToRight(angles) * 48), angles);
	scripts\zm\locs\loc_common::barrier("veh_t6_civ_60s_coupe_dead", origin + (anglesToForward(angles) * -112) + (anglesToRight(angles) * 80), angles + (0, 30, 0));

	// fog after power station
	origin = (10215, 8720, -579);
	angles = (0, 15, 0);
	scripts\zm\locs\loc_common::barrier("collision_clip_wall_512x512x10", origin + (anglesToForward(angles) * -128) + (anglesToUp(angles) * 256), angles, 1);
	scripts\zm\locs\loc_common::barrier("collision_clip_wall_512x512x10", origin + (anglesToForward(angles) * 104) + (anglesToUp(angles) * 256), angles, 1);
	scripts\zm\locs\loc_common::barrier("p6_zm_rocks_large_cluster_01", origin + (anglesToForward(angles) * -176) + (anglesToRight(angles) * -368) + (anglesToUp(angles) * 256), angles + (0, -15, 0));
	scripts\zm\locs\loc_common::barrier("p6_zm_rocks_medium_05", origin + (anglesToForward(angles) * -600) + (anglesToRight(angles) * -50) + (anglesToUp(angles) * -10), angles + (0, 15, 0));
}

show_powerswitch()
{
	body = spawn("script_model", (12237.4, 8512, -749.9));
	body.angles = (0, 0, 0);
	body setModel("p6_zm_buildable_pswitch_body");

	lever = spawn("script_model", (12237.4, 8503, -703.65));
	lever.angles = (0, 0, 0);
	lever setModel("p6_zm_buildable_pswitch_lever");

	hand = spawn("script_model", (12237.7, 8503.1, -684.55));
	hand.angles = (0, 270, 0);
	hand setModel("p6_zm_buildable_pswitch_hand");
}

activate_core()
{
	reactor_core_mover = getent("core_mover", "targetname");

	maps\mp\zm_transit_power::linkentitiestocoremover(reactor_core_mover);

	reactor_core_mover thread maps\mp\zm_transit_power::coremove(0.05);
}

generatebuildabletarps()
{
	// trap
	tarp = spawn("script_model", (11325, 8170, -488));
	tarp.angles = (0, 0, 0);
	tarp setModel("p6_zm_buildable_bench_tarp");
}

disable_zombie_spawn_locations()
{
	level.zones["zone_trans_8"].is_spawning_allowed = 0;
}

disable_player_spawn_locations()
{
	respawnpoints = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	foreach (respawnpoint in respawnpoints)
	{
		if (respawnpoint.script_noteworthy == "zone_pow_warehouse")
		{
			level thread lock_and_unlock_player_spawn_location(respawnpoint, "OnPowDoorWH");
		}
	}
}

lock_and_unlock_player_spawn_location(respawnpoint, flag_str)
{
	respawnpoint.locked = 1;

	flag_wait(flag_str);

	respawnpoint.locked = 0;
}