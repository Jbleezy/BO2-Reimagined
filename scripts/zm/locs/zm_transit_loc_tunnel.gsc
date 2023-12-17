#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_zonemgr;

#include scripts\zm\replaced\utility;
#include scripts\zm\locs\loc_common;

struct_init()
{
	scripts\zm\replaced\utility::register_perk_struct("specialty_armorvest", "zombie_vending_jugg", (-11541, -2630, 194), (0, -180, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_quickrevive", "zombie_vending_quickrevive", (-10780, -2565, 224), (0, 274, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_fastreload", "zombie_vending_sleight", (-11373, -1674, 192), (0, -89, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_rof", "zombie_vending_doubletap2", (-11170, -590, 196), (0, -10, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_longersprint", "zombie_vending_marathon", (-11681, -734, 228), (0, -19, 0));
	scripts\zm\replaced\utility::register_perk_struct("specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", (-11301, -2096, 184), (0, 115, 0));

	zone = "zone_amb_tunnel";
	scripts\zm\replaced\utility::register_map_spawn_group((-11246, -1695, 220), zone, 1000);
	scripts\zm\replaced\utility::register_map_spawn((-11406, -667, 220), (0, -6, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-11568, -1179, 220), (0, 0, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-11473, -1924, 220), (0, -15, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-11457, -2400, 220), (0, 2, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((-10971, -770, 220), (0, 164, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-11009, -1126, 220), (0, 179, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-11028, -1996, 220), (0, -176, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-11017, -2384, 220), (0, -176, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((-10916, -408, 220), (0, -100, 0), zone);
	scripts\zm\replaced\utility::register_map_spawn((-10965, -2987, 220), (0, 95, 0), zone);
}

precache()
{
	start_chest_zbarrier = getEnt("start_chest_zbarrier", "script_noteworthy");
	start_chest_zbarrier.origin = (-10803, -1897, 196);
	start_chest_zbarrier.angles = (0, 89, 0);
	start_chest = spawnStruct();
	start_chest.origin = start_chest_zbarrier.origin;
	start_chest.angles = start_chest_zbarrier.angles;
	start_chest.script_noteworthy = "start_chest";
	start_chest.zombie_cost = 950;
	collision = spawn("script_model", start_chest_zbarrier.origin + (0, 0, 64), 1);
	collision.angles = start_chest_zbarrier.angles;
	collision setmodel("collision_clip_32x32x128");
	collision disconnectpaths();
	collision = spawn("script_model", start_chest_zbarrier.origin + (0, -32, 64), 1);
	collision.angles = start_chest_zbarrier.angles;
	collision setmodel("collision_clip_32x32x128");
	collision disconnectpaths();
	collision = spawn("script_model", start_chest_zbarrier.origin + (0, 32, 64), 1);
	collision.angles = start_chest_zbarrier.angles;
	collision setmodel("collision_clip_32x32x128");
	collision disconnectpaths();

	level.chests = [];
	level.chests[0] = start_chest;
}

main()
{
	init_wallbuys();
	init_barriers();
	disable_zombie_spawn_locations();
	maps\mp\zombies\_zm_magicbox::treasure_chest_init(random(array("start_chest")));
	scripts\zm\locs\loc_common::init();
}

init_wallbuys()
{
	scripts\zm\replaced\utility::wallbuy("m14_zm", "m14", "weapon_upgrade", (-11166, -2844, 247), (0, -86, 0));
	scripts\zm\replaced\utility::wallbuy("rottweil72_zm", "olympia", "weapon_upgrade", (-10735, -2960, 247), (0, 97, 0));
	scripts\zm\replaced\utility::wallbuy("ak74u_zm", "ak74u", "weapon_upgrade", (-10656, -752, 247), (0, 83, 0));
	scripts\zm\replaced\utility::wallbuy("m16_zm", "m16", "weapon_upgrade", (-11839, -1695.1, 287), (0, 270, 0));
	scripts\zm\replaced\utility::wallbuy("sticky_grenade_zm", "sticky_grenade", "weapon_upgrade", (-11839, -2406, 283), (0, -93, 0));
	scripts\zm\replaced\utility::wallbuy("bowie_knife_zm", "bowie_knife", "bowie_upgrade", (-10787, -1430, 247), (0, 88, 0));
}

init_barriers()
{
	origin = (-11270, -500, 255);
	angles = (0, 195, 0);
	scripts\zm\replaced\utility::barrier("collision_player_wall_512x512x10", origin + (anglesToRight(angles) * -25) + (anglesToForward(angles) * 150), angles);
	scripts\zm\replaced\utility::barrier("veh_t6_civ_60s_coupe_dead", origin + (anglesToUp(angles) * -63) + (anglesToForward(angles) * 125) + (anglesToRight(angles) * 25), angles);
	scripts\zm\replaced\utility::barrier("veh_t6_civ_smallwagon_dead", origin + (anglesToUp(angles) * -63) + (anglesToForward(angles) * -30) + (anglesToRight(angles) * 50), angles + (0, -90, 0));

	origin = (-10750, -3275, 255);
	angles = (0, 195, 0);
	scripts\zm\replaced\utility::barrier("collision_player_wall_512x512x10", origin + (anglesToRight(angles) * 55), angles);
	scripts\zm\replaced\utility::barrier("veh_t6_civ_movingtrk_cab_dead", origin, angles);
}

disable_zombie_spawn_locations()
{
	for (z = 0; z < level.zone_keys.size; z++)
	{
		zone = level.zones[level.zone_keys[z]];

		i = 0;

		while (i < zone.spawn_locations.size)
		{
			if (zone.spawn_locations[i].origin == (-11447, -3424, 254.2))
			{
				zone.spawn_locations[i].is_enabled = false;
			}
			else if (zone.spawn_locations[i].origin == (-11093, 393, 192))
			{
				zone.spawn_locations[i].is_enabled = false;
			}
			else if (zone.spawn_locations[i].origin == (-10944, -3846, 221.14))
			{
				zone.spawn_locations[i].is_enabled = false;
			}
			else if (zone.spawn_locations[i].origin == (-10836, 1195, 209.7))
			{
				zone.spawn_locations[i].is_enabled = false;
			}
			else if (zone.spawn_locations[i].origin == (-11251, -4397, 200.02))
			{
				zone.spawn_locations[i].is_enabled = false;
			}
			else if (zone.spawn_locations[i].origin == (-11334, -5280, 212.7))
			{
				zone.spawn_locations[i].is_enabled = false;
			}
			else if (zone.spawn_locations[i].origin == (-11347, -3134, 283.9))
			{
				zone.spawn_locations[i].is_enabled = false;
			}

			i++;
		}
	}
}