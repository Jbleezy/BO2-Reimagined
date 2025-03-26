#include maps\mp\zm_highrise;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weapon_locker;
#include maps\mp\zm_highrise_gamemodes;
#include maps\mp\zm_highrise_sq;
#include maps\mp\zombies\_zm_banking;
#include maps\mp\zm_highrise_fx;
#include maps\mp\zm_highrise_ffotd;
#include maps\mp\zm_highrise_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_highrise_amb;
#include maps\mp\zm_highrise_elevators;
#include maps\mp\zombies\_load;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\zm_highrise_classic;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\_sticky_grenade;
#include maps\mp\zombies\_zm_weap_bowie;
#include maps\mp\zombies\_zm_weap_cymbal_monkey;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_weap_slipgun;
#include maps\mp\zombies\_zm_weap_tazer_knuckles;
#include maps\mp\zm_highrise_achievement;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_highrise_distance_tracking;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_perks;
#include character\c_highrise_player_farmgirl;
#include character\c_highrise_player_oldman;
#include character\c_highrise_player_engineer;
#include character\c_highrise_player_reporter;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_chugabud;

zclassic_preinit()
{
	setdvar("player_sliding_velocity_cap", 80.0);
	setdvar("player_sliding_wishspeed", 800.0);
	registerclientfield("scriptmover", "clientfield_escape_pod_tell_fx", 5000, 1, "int");
	registerclientfield("scriptmover", "clientfield_escape_pod_sparks_fx", 5000, 1, "int");
	registerclientfield("scriptmover", "clientfield_escape_pod_impact_fx", 5000, 1, "int");
	registerclientfield("scriptmover", "clientfield_escape_pod_light_fx", 5000, 1, "int");
	registerclientfield("actor", "clientfield_whos_who_clone_glow_shader", 5000, 1, "int");
	registerclientfield("toplayer", "clientfield_whos_who_audio", 5000, 1, "int");
	registerclientfield("toplayer", "clientfield_whos_who_filter", 5000, 1, "int");
	level.whos_who_client_setup = 1;
	maps\mp\zm_highrise_sq::sq_highrise_clientfield_init();
	precachemodel("p6_zm_keycard");
	precachemodel("p6_zm_hr_keycard");
	precachemodel("fxanim_zom_highrise_trample_gen_mod");
	level.banking_map = "zm_transit";
	level.weapon_locker_map = "zm_transit";
	level thread maps\mp\zombies\_zm_banking::init();
	survival_init();

	if (!(isdefined(level.banking_update_enabled) && level.banking_update_enabled))
	{
		return;
	}

	weapon_locker = spawnstruct();
	weapon_locker.origin = (2107, 98, 1150);
	weapon_locker.angles = vectorscale((0, 1, 0), 60.0);
	weapon_locker.targetname = "weapons_locker";
	deposit_spot = spawnstruct();
	deposit_spot.origin = (2247, 553, 1326);
	deposit_spot.angles = vectorscale((0, 1, 0), 60.0);
	deposit_spot.script_length = 16;
	deposit_spot.targetname = "bank_deposit";
	withdraw_spot = spawnstruct();
	withdraw_spot.origin = (2280, 611, 1330);
	withdraw_spot.angles = vectorscale((0, 1, 0), 60.0);
	withdraw_spot.script_length = 16;
	withdraw_spot.targetname = "bank_withdraw";
	level thread maps\mp\zombies\_zm_weapon_locker::main();
	weapon_locker thread maps\mp\zombies\_zm_weapon_locker::triggerweaponslockerwatch();
	level thread maps\mp\zombies\_zm_banking::main();
	deposit_spot thread maps\mp\zombies\_zm_banking::bank_deposit_unitrigger();
	withdraw_spot thread maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger();
}

custom_vending_precaching()
{
	if (isdefined(level.zombiemode_using_pack_a_punch) && level.zombiemode_using_pack_a_punch)
	{
		precacheitem("zombie_knuckle_crack");
		precachemodel("p6_anim_zm_buildable_pap");
		precachemodel("p6_anim_zm_buildable_pap_on");
		precachestring(&"ZOMBIE_PERK_PACKAPUNCH");
		precachestring(&"ZOMBIE_PERK_PACKAPUNCH_ATT");
		level._effect["packapunch_fx"] = loadfx("maps/zombie/fx_zmb_highrise_packapunch");
		level.machine_assets["packapunch"] = spawnstruct();
		level.machine_assets["packapunch"].weapon = "zombie_knuckle_crack";
		level.machine_assets["packapunch"].off_model = "p6_anim_zm_buildable_pap";
		level.machine_assets["packapunch"].on_model = "p6_anim_zm_buildable_pap_on";
	}

	if (isdefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk)
	{
		precacheitem("zombie_perk_bottle_additionalprimaryweapon");
		precacheshader("specialty_additionalprimaryweapon_zombies");
		precachemodel("zombie_vending_three_gun");
		precachemodel("zombie_vending_three_gun_on");
		precachestring(&"ZOMBIE_PERK_ADDITIONALWEAPONPERK");
		level._effect["additionalprimaryweapon_light"] = loadfx("misc/fx_zombie_cola_arsenal_on");
		level.machine_assets["additionalprimaryweapon"] = spawnstruct();
		level.machine_assets["additionalprimaryweapon"].weapon = "zombie_perk_bottle_additionalprimaryweapon";
		level.machine_assets["additionalprimaryweapon"].off_model = "zombie_vending_three_gun";
		level.machine_assets["additionalprimaryweapon"].on_model = "zombie_vending_three_gun_on";
	}

	if (isdefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk)
	{
		precacheitem("zombie_perk_bottle_deadshot");
		precacheshader("specialty_ads_zombies");
		precachemodel("zombie_vending_ads");
		precachemodel("zombie_vending_ads_on");
		precachestring(&"ZOMBIE_PERK_DEADSHOT");
		level._effect["deadshot_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "zombie_vending_ads";
		level.machine_assets["deadshot"].on_model = "zombie_vending_ads_on";
	}

	if (isdefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk)
	{
		precacheitem("zombie_perk_bottle_doubletap");
		precacheshader("specialty_doubletap_zombies");
		precachemodel("zombie_vending_doubletap2");
		precachemodel("zombie_vending_doubletap2_on");
		precachestring(&"ZOMBIE_PERK_DOUBLETAP");
		level._effect["doubletap_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
		level.machine_assets["doubletap"] = spawnstruct();
		level.machine_assets["doubletap"].weapon = "zombie_perk_bottle_doubletap";
		level.machine_assets["doubletap"].off_model = "zombie_vending_doubletap2";
		level.machine_assets["doubletap"].on_model = "zombie_vending_doubletap2_on";
	}

	if (isdefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk)
	{
		precacheitem("zombie_perk_bottle_jugg");
		precacheshader("specialty_juggernaut_zombies");
		precachemodel("zombie_vending_jugg");
		precachemodel("zombie_vending_jugg_on");
		precachestring(&"ZOMBIE_PERK_JUGGERNAUT");
		level._effect["jugger_light"] = loadfx("misc/fx_zombie_cola_jugg_on");
		level.machine_assets["juggernog"] = spawnstruct();
		level.machine_assets["juggernog"].weapon = "zombie_perk_bottle_jugg";
		level.machine_assets["juggernog"].off_model = "zombie_vending_jugg";
		level.machine_assets["juggernog"].on_model = "zombie_vending_jugg_on";
	}

	if (isdefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk)
	{
		precacheitem("zombie_perk_bottle_marathon");
		precacheshader("specialty_marathon_zombies");
		precachemodel("zombie_vending_marathon");
		precachemodel("zombie_vending_marathon_on");
		precachestring(&"ZOMBIE_PERK_MARATHON");
		level._effect["marathon_light"] = loadfx("maps/zombie/fx_zmb_cola_staminup_on");
		level.machine_assets["marathon"] = spawnstruct();
		level.machine_assets["marathon"].weapon = "zombie_perk_bottle_marathon";
		level.machine_assets["marathon"].off_model = "zombie_vending_marathon";
		level.machine_assets["marathon"].on_model = "zombie_vending_marathon_on";
	}

	if (isdefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk)
	{
		precacheitem("zombie_perk_bottle_revive");
		precacheshader("specialty_quickrevive_zombies");
		precachemodel("zombie_vending_revive");
		precachemodel("zombie_vending_revive_on");
		precachestring(&"ZOMBIE_PERK_QUICKREVIVE");
		level._effect["revive_light"] = loadfx("misc/fx_zombie_cola_revive_on");
		level._effect["revive_light_flicker"] = loadfx("maps/zombie/fx_zmb_cola_revive_flicker");
		level.machine_assets["revive"] = spawnstruct();
		level.machine_assets["revive"].weapon = "zombie_perk_bottle_revive";
		level.machine_assets["revive"].off_model = "zombie_vending_revive";
		level.machine_assets["revive"].on_model = "zombie_vending_revive_on";
	}

	if (isdefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk)
	{
		precacheitem("zombie_perk_bottle_sleight");
		precacheshader("specialty_fastreload_zombies");
		precachemodel("zombie_vending_sleight");
		precachemodel("zombie_vending_sleight_on");
		precachestring(&"ZOMBIE_PERK_FASTRELOAD");
		level._effect["sleight_light"] = loadfx("misc/fx_zombie_cola_on");
		level.machine_assets["speedcola"] = spawnstruct();
		level.machine_assets["speedcola"].weapon = "zombie_perk_bottle_sleight";
		level.machine_assets["speedcola"].off_model = "zombie_vending_sleight";
		level.machine_assets["speedcola"].on_model = "zombie_vending_sleight_on";
	}

	if (isdefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
	{
		precacheitem("zombie_perk_bottle_tombstone");
		precacheshader("specialty_tombstone_zombies");
		precachemodel("zombie_vending_tombstone");
		precachemodel("zombie_vending_tombstone_on");
		precachemodel("ch_tombstone1");
		precachestring(&"ZOMBIE_PERK_TOMBSTONE");
		level._effect["tombstone_light"] = loadfx("misc/fx_zombie_cola_revive_on");
		level.machine_assets["tombstone"] = spawnstruct();
		level.machine_assets["tombstone"].weapon = "zombie_perk_bottle_tombstone";
		level.machine_assets["tombstone"].off_model = "zombie_vending_tombstone";
		level.machine_assets["tombstone"].on_model = "zombie_vending_tombstone_on";
	}

	if (isdefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk)
	{
		precacheitem("zombie_perk_bottle_whoswho");
		precacheshader("specialty_chugabud_zombies");
		precachemodel("p6_zm_vending_chugabud");
		precachemodel("p6_zm_vending_chugabud_on");
		precachestring(&"ZOMBIE_PERK_CHUGABUD");
		level._effect["whoswho_light"] = loadfx("misc/fx_zombie_cola_on");
		level.machine_assets["whoswho"] = spawnstruct();
		level.machine_assets["whoswho"].weapon = "zombie_perk_bottle_whoswho";
		level.machine_assets["whoswho"].off_model = "p6_zm_vending_chugabud";
		level.machine_assets["whoswho"].on_model = "p6_zm_vending_chugabud_on";
	}

	if (level._custom_perks.size > 0)
	{
		a_keys = getarraykeys(level._custom_perks);

		for (i = 0; i < a_keys.size; i++)
		{
			if (isdefined(level._custom_perks[a_keys[i]].precache_func))
			{
				level [[level._custom_perks[a_keys[i]].precache_func]]();
			}
		}
	}
}

highrise_respawn_override(revivee, return_struct)
{
	players = array_randomize(get_players());
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

	if (spawn_points.size == 0)
	{
		return undefined;
	}

	for (i = 0; i < players.size; i++)
	{
		if (is_player_valid(players[i], undefined, 1) && players[i] != self)
		{
			for (j = 0; j < spawn_points.size; j++)
			{
				if (isDefined(spawn_points[j].script_noteworthy))
				{
					zone = level.zones[spawn_points[j].script_noteworthy];

					for (k = 0; k < zone.volumes.size; k++)
					{
						if (players[i] istouching(zone.volumes[k]))
						{
							closest_group = j;
							spawn_location = maps\mp\zombies\_zm::get_valid_spawn_location(revivee, spawn_points, closest_group, return_struct);

							if (isDefined(spawn_location))
							{
								return spawn_location;
							}
						}
					}
				}
			}
		}
	}
}

zm_highrise_zone_monitor_callback()
{
	b_kill_player = 1;

	if (!self isonground())
	{
		b_kill_player = 0;
	}

	if (b_kill_player)
	{
		self thread maps\mp\zm_highrise_classic::insta_kill_player(0, 0);
	}

	return b_kill_player;
}

is_magic_box_in_inverted_building()
{
	b_is_in_inverted_building = 0;
	a_boxes_in_inverted_building = array("start_chest", "orange_level3_chest");
	str_location = level.chests[level.chest_index].script_noteworthy;
	assert(isdefined(str_location), "is_magic_box_in_inverted_building() can't find magic box location");

	for (i = 0; i < a_boxes_in_inverted_building.size; i++)
	{
		if (a_boxes_in_inverted_building[i] == str_location)
		{
			b_is_in_inverted_building = 1;
		}
	}

	return b_is_in_inverted_building;
}