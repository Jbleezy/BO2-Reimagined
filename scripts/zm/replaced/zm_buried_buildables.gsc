#include maps\mp\zm_buried_buildables;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_buildables_pooled;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_unitrigger;

prepare_chalk_weapon_list()
{
	level.buildable_wallbuy_weapons = [];
	level.buildable_wallbuy_weapon_hints = [];
	level.buildable_wallbuy_pickup_hints = [];

	if (getdvar("ui_zm_mapstartlocation") == "maze")
	{
		level.buildable_wallbuy_weapons[0] = "saritch_zm";
		level.buildable_wallbuy_weapons[1] = "ballista_zm";
		level.buildable_wallbuy_weapons[2] = "beretta93r_zm";
		level.buildable_wallbuy_weapons[3] = "pdw57_zm";
		level.buildable_wallbuy_weapons[4] = "an94_zm";
		level.buildable_wallbuy_weapons[5] = "lsat_zm";

		foreach (buildable_wallbuy_weapon in level.buildable_wallbuy_weapons)
		{
			level.buildable_wallbuy_weapon_hints[buildable_wallbuy_weapon] = undefined;
			level.buildable_wallbuy_pickup_hints[buildable_wallbuy_weapon] = undefined;
		}
	}
	else
	{
		level.buildable_wallbuy_weapons[0] = "vector_zm";
		level.buildable_wallbuy_weapons[1] = "an94_zm";
		level.buildable_wallbuy_weapons[2] = "pdw57_zm";
		level.buildable_wallbuy_weapons[3] = "svu_zm";
		level.buildable_wallbuy_weapons[4] = "tazer_knuckles_zm";
		level.buildable_wallbuy_weapons[5] = "870mcs_zm";

		level.buildable_wallbuy_weapon_hints["vector_zm"] = &"ZM_BURIED_WB_VECTOR";
		level.buildable_wallbuy_weapon_hints["an94_zm"] = &"ZM_BURIED_WB_AN94";
		level.buildable_wallbuy_weapon_hints["pdw57_zm"] = &"ZM_BURIED_WB_PDW57";
		level.buildable_wallbuy_weapon_hints["svu_zm"] = &"ZM_BURIED_WB_SVU";
		level.buildable_wallbuy_weapon_hints["tazer_knuckles_zm"] = &"ZM_BURIED_WB_TAZER";
		level.buildable_wallbuy_weapon_hints["870mcs_zm"] = &"ZM_BURIED_WB_870MCS";

		level.buildable_wallbuy_pickup_hints["vector_zm"] = &"ZM_BURIED_PU_VECTOR";
		level.buildable_wallbuy_pickup_hints["an94_zm"] = &"ZM_BURIED_PU_AN94";
		level.buildable_wallbuy_pickup_hints["pdw57_zm"] = &"ZM_BURIED_PU_PDW57";
		level.buildable_wallbuy_pickup_hints["svu_zm"] = &"ZM_BURIED_PU_SVU";
		level.buildable_wallbuy_pickup_hints["tazer_knuckles_zm"] = &"ZM_BURIED_PU_TAZER";
		level.buildable_wallbuy_pickup_hints["870mcs_zm"] = &"ZM_BURIED_PU_870MCS";
	}

	level.buildable_wallbuy_weapon_models = [];
	level.buildable_wallbuy_weapon_angles = [];

	foreach (buildable_wallbuy_weapon in level.buildable_wallbuy_weapons)
	{
		level.buildable_wallbuy_weapon_models[buildable_wallbuy_weapon] = undefined;
		level.buildable_wallbuy_weapon_angles[buildable_wallbuy_weapon] = undefined;
	}

	foreach (model in level.buildable_wallbuy_weapon_models)
	{
		if (isdefined(model))
			precachemodel(model);
	}
}

init_buildables(buildablesenabledlist)
{
	registerclientfield("scriptmover", "buildable_glint_fx", 12000, 1, "int");
	precacheitem("chalk_draw_zm");
	precacheitem("no_hands_zm");
	level._effect["wallbuy_replace"] = loadfx("maps/zombie_buried/fx_buried_booze_candy_spawn");
	level._effect["wallbuy_drawing"] = loadfx("maps/zombie/fx_zmb_wall_dyn_chalk_drawing");
	level.str_buildables_build = &"ZOMBIE_BUILD_SQ_COMMON";
	level.str_buildables_building = &"ZOMBIE_BUILDING_SQ_COMMON";
	level.str_buildables_grab_part = &"ZOMBIE_BUILD_PIECE_GRAB";
	level.str_buildables_swap_part = &"ZOMBIE_BUILD_PIECE_SWITCH";
	level.safe_place_for_buildable_piece = ::safe_place_for_buildable_piece;
	level.buildable_slot_count = max(1, 2) + 1;
	level.buildable_clientfields = [];
	level.buildable_clientfields[0] = "buildable";
	level.buildable_clientfields[1] = "buildable" + "_pu";
	level.buildable_piece_counts = [];
	level.buildable_piece_counts[0] = 15;
	level.buildable_piece_counts[1] = 4;

	if (-1)
	{
		level.buildable_clientfields[2] = "buildable" + "_sq";
		level.buildable_piece_counts[2] = 13;
	}

	if (isinarray(buildablesenabledlist, "sq_common"))
		add_zombie_buildable("sq_common", level.str_buildables_build, level.str_buildables_building);

	if (isinarray(buildablesenabledlist, "buried_sq_tpo_switch"))
		add_zombie_buildable("buried_sq_tpo_switch", level.str_buildables_build, level.str_buildables_building);

	if (isinarray(buildablesenabledlist, "buried_sq_ghost_lamp"))
		add_zombie_buildable("buried_sq_ghost_lamp", level.str_buildables_build, level.str_buildables_building);

	if (isinarray(buildablesenabledlist, "buried_sq_bt_m_tower"))
		add_zombie_buildable("buried_sq_bt_m_tower", &"ZM_BURIED_BUILD_MTOWER", level.str_buildables_building);

	if (isinarray(buildablesenabledlist, "buried_sq_bt_r_tower"))
		add_zombie_buildable("buried_sq_bt_r_tower", &"ZM_BURIED_BUILD_RTOWER", level.str_buildables_building);

	if (isinarray(buildablesenabledlist, "buried_sq_oillamp"))
		add_zombie_buildable("buried_sq_oillamp", level.str_buildables_build, level.str_buildables_building, &"NULL_EMPTY");

	if (isinarray(buildablesenabledlist, "turbine"))
	{
		add_zombie_buildable("turbine", &"ZOMBIE_BUILD_TURBINE", level.str_buildables_building, &"ZOMBIE_BOUGHT_TURBINE");
		add_zombie_buildable_vox_category("turbine", "trb");
	}

	if (isinarray(buildablesenabledlist, "springpad_zm"))
	{
		add_zombie_buildable("springpad_zm", &"ZM_BURIED_BUILD_SPRINGPAD", level.str_buildables_building, &"ZM_BURIED_BOUGHT_SPRINGPAD");
		add_zombie_buildable_vox_category("springpad_zm", "stm");
	}

	if (isinarray(buildablesenabledlist, "subwoofer_zm"))
	{
		add_zombie_buildable("subwoofer_zm", &"ZM_BURIED_BUILD_SUBWOOFER", level.str_buildables_building, &"ZM_BURIED_BOUGHT_SUBWOOFER");
		add_zombie_buildable_vox_category("subwoofer_zm", "sw");
	}

	if (isinarray(buildablesenabledlist, "headchopper_zm"))
	{
		add_zombie_buildable("headchopper_zm", &"ZM_BURIED_BUILD_HEADCHOPPER", level.str_buildables_building, &"ZM_BURIED_BOUGHT_HEADCHOPPER");
		add_zombie_buildable_vox_category("headchopper_zm", "hc");
	}

	if (isinarray(buildablesenabledlist, "booze"))
	{
		add_zombie_buildable("booze", &"ZM_BURIED_LEAVE_BOOZE", level.str_buildables_building, &"NULL_EMPTY");
		add_zombie_buildable_piece_vox_category("booze", "booze");
	}

	if (isinarray(buildablesenabledlist, "candy"))
	{
		add_zombie_buildable("candy", &"ZM_BURIED_LEAVE_CANDY", level.str_buildables_building, &"NULL_EMPTY");
		add_zombie_buildable_piece_vox_category("candy", "candy");
	}

	if (isinarray(buildablesenabledlist, "chalk"))
	{
		add_zombie_buildable("chalk", &"NULL_EMPTY", level.str_buildables_building, &"NULL_EMPTY");
		add_zombie_buildable_piece_vox_category("chalk", "gunshop_chalk", 300);
	}

	if (isinarray(buildablesenabledlist, "sloth"))
		add_zombie_buildable("sloth", &"ZM_BURIED_BOOZE_GV", level.str_buildables_building, &"NULL_EMPTY");

	if (isinarray(buildablesenabledlist, "keys_zm"))
	{
		add_zombie_buildable("keys_zm", &"ZM_BURIED_KEYS_BL", level.str_buildables_building, &"NULL_EMPTY");
		add_zombie_buildable_piece_vox_category("keys_zm", "key");
	}

	level thread chalk_host_migration();
}

subwooferbuildable()
{
	stub = maps\mp\zombies\_zm_buildables::buildable_trigger_think("subwoofer_zm_buildable_trigger", "subwoofer_zm", "equip_subwoofer_zm", &"ZM_BURIED_GRAB_SUBWOOFER", 1, 1);
	maps\mp\zombies\_zm_buildables_pooled::add_buildable_to_pool(stub, "buried");
}

springpadbuildable()
{
	stub = maps\mp\zombies\_zm_buildables::buildable_trigger_think("springpad_zm_buildable_trigger", "springpad_zm", "equip_springpad_zm", &"ZM_BURIED_GRAB_SPRINGPAD", 1, 1);
	maps\mp\zombies\_zm_buildables_pooled::add_buildable_to_pool(stub, "buried");
}

headchopperbuildable()
{
	stub = maps\mp\zombies\_zm_buildables::buildable_trigger_think("headchopper_buildable_trigger", "headchopper_zm", "equip_headchopper_zm", &"ZM_BURIED_GRAB_HEADCHOPPER", 1, 1);
	maps\mp\zombies\_zm_buildables_pooled::add_buildable_to_pool(stub, "buried");
}

watch_cell_open_close(door)
{
	level.cell_open = 0;

	while (true)
	{
		level waittill("cell_open");

		level.cell_open = 1;

		level waittill("cell_close");

		level.cell_open = 0;
	}
}