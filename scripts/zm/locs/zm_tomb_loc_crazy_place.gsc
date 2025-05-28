#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_zonemgr;

struct_init()
{
	zone = "zone_chamber_4";
	scripts\zm\replaced\utility::register_map_spawn((10479, -7963, -420), (0, 157.5, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10479, -7849, -420), (0, 202.5, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10397, -7767, -420), (0, 247.5, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10283, -7767, -420), (0, 292.5, 0), zone, 1);
	scripts\zm\replaced\utility::register_map_spawn((10201, -7849, -420), (0, 337.5, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((10201, -7963, -420), (0, 22.5, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((10283, -8045, -420), (0, 67.5, 0), zone, 2);
	scripts\zm\replaced\utility::register_map_spawn((10397, -8045, -420), (0, 112.5, 0), zone, 2);
}

precache()
{

}

main()
{
	level.pap_rotate_on_trigger = 1;
	level.perk_require_look_at_func = ::perk_require_look_at;
	treasure_chest_init();
	enable_zones();
	disable_zones();
	level thread weapon_fx();
	level thread perk_fx();
	level thread pap_fx();
	level thread set_ee_ending();
	level thread scripts\zm\locs\loc_common::init();
}

treasure_chest_init()
{
	level.chests = getstructarray("treasure_chest_use", "targetname");
	maps\mp\zombies\_zm_magicbox::treasure_chest_init("start_chest");
}

enable_zones()
{
	flag_set("activate_zone_chamber");
}

disable_zones()
{
	valid_zones = array("zone_chamber_0", "zone_chamber_1", "zone_chamber_2", "zone_chamber_3", "zone_chamber_4", "zone_chamber_5", "zone_chamber_6", "zone_chamber_7", "zone_chamber_8");
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	foreach (index, zone in level.zones)
	{
		if (!isinarray(valid_zones, index))
		{
			level.zones[index].is_enabled = 0;
			level.zones[index].is_spawning_allowed = 0;

			foreach (spawn_point in spawn_points)
			{
				if (spawn_point.script_noteworthy == index)
				{
					spawn_point.locked = 1;
					break;
				}
			}
		}
	}
}

weapon_fx()
{
	random_wallbuy_trigs = [];

	foreach (wallbuy in level._spawned_wallbuys)
	{
		if (isdefined(wallbuy.script_noteworthy) && issubstr(wallbuy.script_noteworthy, "crazy_place"))
		{
			random_wallbuy_trigs[random_wallbuy_trigs.size] = wallbuy.trigger_stub;

			wallbuy.trigger_stub.script_length = 128;
			wallbuy.trigger_stub.script_width = 128;
		}
	}

	foreach (trig in random_wallbuy_trigs)
	{
		random_trig = random(random_wallbuy_trigs);

		temp_origin = trig.origin;
		trig.origin = random_trig.origin;
		random_trig.origin = temp_origin;

		temp_angles = trig.angles;
		trig.angles = random_trig.angles;
		random_trig.angles = temp_angles;
	}

	foreach (trig in random_wallbuy_trigs)
	{
		weapon = trig.zombie_weapon_upgrade;
		origin = trig.origin + anglestoright(trig.angles) * 5 + anglestoup(trig.angles) * 20;
		angles = trig.angles + (-90, 0, 0);

		ent = spawn_weapon_model(weapon, undefined, origin, angles);

		ent thread rotate_loop();
	}
}

perk_fx()
{
	flag_wait("power_on");

	wait 1;

	random_perk_trigs = [];
	trigs = getentarray("zombie_vending", "targetname");

	foreach (trig in trigs)
	{
		if (trig.script_noteworthy == "specialty_armorvest" || trig.script_noteworthy == "specialty_quickrevive" || trig.script_noteworthy == "specialty_fastreload" || trig.script_noteworthy == "specialty_rof")
		{
			random_perk_trigs[random_perk_trigs.size] = trig;

			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
		}

		if (trig.script_noteworthy == "specialty_weapupgrade")
		{
			trig.clip delete();
		}
	}

	foreach (trig in random_perk_trigs)
	{
		random_trig = random(random_perk_trigs);

		temp_origin = trig.origin;
		trig.origin = random_trig.origin;
		random_trig.origin = temp_origin;

		temp_angles = trig.angles;
		trig.angles = random_trig.angles;
		random_trig.angles = temp_angles;
	}

	foreach (trig in random_perk_trigs)
	{
		model = maps\mp\zombies\_zm_perk_random::get_perk_weapon_model(trig.script_noteworthy);
		origin = trig.origin;
		angles = trig.angles + (0, 0, 10);

		ent = spawn("script_model", origin);
		ent.angles = angles;
		ent setmodel(model);

		ent thread rotate_loop();
	}
}

rotate_loop()
{
	while (1)
	{
		self rotateyaw(360, 1.5);

		wait 1.5;
	}
}

pap_fx()
{
	level endon("intermission");

	level thread pap_fx_delete_on_intermission();

	s_pos = getstruct("player_portal_final", "targetname");

	while (1)
	{
		flag_wait("pack_machine_in_use");

		level.ee_ending_beam_fx = spawn("script_model", s_pos.origin + vectorscale((0, 0, -1), 300.0));
		level.ee_ending_beam_fx.angles = vectorscale((0, 1, 0), 90.0);
		level.ee_ending_beam_fx setmodel("tag_origin");
		playfxontag(level._effect["ee_beam"], level.ee_ending_beam_fx, "tag_origin");
		level.ee_ending_beam_fx playsound("zmb_squest_crystal_sky_pillar_start");
		level.ee_ending_beam_fx playloopsound("zmb_squest_crystal_sky_pillar_loop", 3);

		flag_waitopen("pack_machine_in_use");

		level.ee_ending_beam_fx playsound("zmb_squest_crystal_sky_pillar_stop");
		level.ee_ending_beam_fx delete();
	}
}

pap_fx_delete_on_intermission()
{
	level waittill("intermission");

	if (isdefined(level.ee_ending_beam_fx))
	{
		level.ee_ending_beam_fx playsound("zmb_squest_crystal_sky_pillar_stop");
		level.ee_ending_beam_fx delete();
	}
}

set_ee_ending()
{
	flag_wait("start_zombie_round_logic");

	level setclientfield("ee_sam_portal", 3);

	points = getstructarray("ee_cam", "targetname");

	foreach (point in points)
	{
		target_point = getstruct(point.target, "targetname");

		point.angles += (180, 0, 0);
		target_point.angles += (180, 0, 0);
	}

	level.custom_intermission = maps\mp\zm_tomb_ee_main::player_intermission_ee;
}

perk_require_look_at()
{
	if (self.script_noteworthy == "specialty_armorvest" || self.script_noteworthy == "specialty_quickrevive" || self.script_noteworthy == "specialty_fastreload" || self.script_noteworthy == "specialty_rof" || self.script_noteworthy == "specialty_weapupgrade")
	{
		return 0;
	}

	return 1;
}