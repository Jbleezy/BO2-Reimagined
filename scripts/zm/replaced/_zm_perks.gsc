#include maps\mp\zombies\_zm_perks;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_power;

init()
{
	level.additionalprimaryweapon_limit = 3;
	level.perk_purchase_limit = 4;

	if (!level.createfx_enabled)
	{
		perks_register_clientfield();
	}

	if (!level.enable_magic)
	{
		return;
	}

	initialize_custom_perk_arrays();
	perk_machine_spawn_init();
	vending_weapon_upgrade_trigger = [];
	vending_triggers = getentarray("zombie_vending", "targetname");

	for (i = 0; i < vending_triggers.size; i++)
	{
		if (isdefined(vending_triggers[i].script_noteworthy) && vending_triggers[i].script_noteworthy == "specialty_weapupgrade")
		{
			vending_weapon_upgrade_trigger[vending_weapon_upgrade_trigger.size] = vending_triggers[i];
			arrayremovevalue(vending_triggers, vending_triggers[i]);
		}
	}

	old_packs = getentarray("zombie_vending_upgrade", "targetname");

	for (i = 0; i < old_packs.size; i++)
	{
		vending_weapon_upgrade_trigger[vending_weapon_upgrade_trigger.size] = old_packs[i];
	}

	flag_init("pack_machine_in_use");

	if (vending_triggers.size < 1)
	{
		return;
	}

	if (vending_weapon_upgrade_trigger.size >= 1)
	{
		array_thread(vending_weapon_upgrade_trigger, ::vending_weapon_upgrade);
	}

	level.machine_assets = [];

	if (!isdefined(level.custom_vending_precaching))
	{
		level.custom_vending_precaching = ::default_vending_precaching;
	}

	[[level.custom_vending_precaching]]();

	if (!isdefined(level.packapunch_timeout))
	{
		level.packapunch_timeout = 15;
	}

	set_zombie_var("zombie_perk_cost", 2000);
	set_zombie_var("zombie_perk_juggernaut_health", 160);
	set_zombie_var("zombie_perk_juggernaut_health_upgrade", 190);
	array_thread(vending_triggers, ::vending_trigger_think);
	array_thread(vending_triggers, ::electric_perks_dialog);

	if (isdefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk)
	{
		level thread turn_doubletap_on();
	}

	if (isdefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk)
	{
		level thread turn_marathon_on();
	}

	if (isdefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk)
	{
		level thread turn_jugger_on();
	}

	if (isdefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk)
	{
		level thread turn_revive_on();
	}

	if (isdefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk)
	{
		level thread turn_sleight_on();
	}

	if (isdefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk)
	{
		level thread turn_deadshot_on();
	}

	if (isdefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
	{
		level thread turn_tombstone_on();
	}

	if (isdefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk)
	{
		level thread turn_additionalprimaryweapon_on();
	}

	if (isdefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk)
	{
		level thread turn_chugabud_on();
	}

	if (level._custom_perks.size > 0)
	{
		a_keys = getarraykeys(level._custom_perks);

		for (i = 0; i < a_keys.size; i++)
		{
			if (isdefined(level._custom_perks[a_keys[i]].perk_machine_thread))
			{
				level thread [[level._custom_perks[a_keys[i]].perk_machine_thread]]();
			}
		}
	}

	if (isdefined(level._custom_turn_packapunch_on))
	{
		level thread [[level._custom_turn_packapunch_on]]();
	}
	else
	{
		level thread turn_packapunch_on();
	}

	if (isdefined(level.quantum_bomb_register_result_func))
	{
		[[level.quantum_bomb_register_result_func]]("give_nearest_perk", ::quantum_bomb_give_nearest_perk_result, 10, ::quantum_bomb_give_nearest_perk_validation);
	}

	level thread perk_hostmigration();
}

perks_register_clientfield()
{
	bits = 1;

	if (isdefined(level.zombie_include_weapons) && isdefined(level.zombie_include_weapons["emp_grenade_zm"]))
	{
		bits = 2;
	}

	if (isdefined(level.zombiemode_using_additionalprimaryweapon_perk) && level.zombiemode_using_additionalprimaryweapon_perk)
	{
		registerclientfield("toplayer", "perk_additional_primary_weapon", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_deadshot_perk) && level.zombiemode_using_deadshot_perk)
	{
		registerclientfield("toplayer", "perk_dead_shot", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_doubletap_perk) && level.zombiemode_using_doubletap_perk)
	{
		registerclientfield("toplayer", "perk_double_tap", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_juggernaut_perk) && level.zombiemode_using_juggernaut_perk)
	{
		registerclientfield("toplayer", "perk_juggernaut", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_marathon_perk) && level.zombiemode_using_marathon_perk)
	{
		registerclientfield("toplayer", "perk_marathon", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_revive_perk) && level.zombiemode_using_revive_perk)
	{
		registerclientfield("toplayer", "perk_quick_revive", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_sleightofhand_perk) && level.zombiemode_using_sleightofhand_perk)
	{
		registerclientfield("toplayer", "perk_sleight_of_hand", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_tombstone_perk) && level.zombiemode_using_tombstone_perk)
	{
		registerclientfield("toplayer", "perk_tombstone", 1, bits, "int");
	}

	if (isdefined(level.zombiemode_using_perk_intro_fx) && level.zombiemode_using_perk_intro_fx)
	{
		registerclientfield("scriptmover", "clientfield_perk_intro_fx", 1000, 1, "int");
	}

	if (isdefined(level.zombiemode_using_chugabud_perk) && level.zombiemode_using_chugabud_perk)
	{
		registerclientfield("toplayer", "perk_chugabud", 1000, bits, "int");
	}

	if (isdefined(level._custom_perks))
	{
		a_keys = getarraykeys(level._custom_perks);

		for (i = 0; i < a_keys.size; i++)
		{
			if (isdefined(level._custom_perks[a_keys[i]].clientfield_register))
			{
				level [[level._custom_perks[a_keys[i]].clientfield_register]]();
			}
		}
	}
}

default_vending_precaching()
{
	if (isdefined(level.zombiemode_using_pack_a_punch) && level.zombiemode_using_pack_a_punch)
	{
		precacheitem("zombie_knuckle_crack");
		precachemodel("p6_anim_zm_buildable_pap");
		precachemodel("p6_anim_zm_buildable_pap_on");
		precachestring(&"ZOMBIE_PERK_PACKAPUNCH");
		precachestring(&"ZOMBIE_PERK_PACKAPUNCH_ATT");
		level._effect["packapunch_fx"] = loadfx("maps/zombie/fx_zombie_packapunch");
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
		precachemodel("p6_zm_al_vending_ads_on");
		precachestring(&"ZOMBIE_PERK_DEADSHOT");
		level._effect["deadshot_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
		level.machine_assets["deadshot"] = spawnstruct();
		level.machine_assets["deadshot"].weapon = "zombie_perk_bottle_deadshot";
		level.machine_assets["deadshot"].off_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].on_model = "p6_zm_al_vending_ads_on";
		level.machine_assets["deadshot"].power_on_callback = ::vending_deadshot_power_on;
		level.machine_assets["deadshot"].power_off_callback = ::vending_deadshot_power_off;
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

vending_deadshot_power_on()
{
	if (level.script == "zm_prison")
	{
		self setclientfield("toggle_perk_machine_power", 2);
	}
	else
	{
		level thread scripts\zm\_zm_reimagined::clientnotifyloop("toggle_vending_deadshot_power_on", "deadshot_off");
	}
}

vending_deadshot_power_off()
{
	if (level.script == "zm_prison")
	{
		self setclientfield("toggle_perk_machine_power", 1);
	}
	else
	{
		level thread scripts\zm\_zm_reimagined::clientnotifyloop("toggle_vending_deadshot_power_off", "deadshot_on");
	}
}

turn_chugabud_on()
{
	maps\mp\zombies\_zm_chugabud::init();

	if (isdefined(level.vsmgr_prio_visionset_zm_whos_who))
	{
		maps\mp\_visionset_mgr::vsmgr_register_info("visionset", "zm_whos_who", 5000, level.vsmgr_prio_visionset_zm_whos_who, 1, 1);
	}

	while (true)
	{
		machine = getentarray("vending_chugabud", "targetname");
		machine_triggers = getentarray("vending_chugabud", "target");

		for (i = 0; i < machine.size; i++)
		{
			machine[i] setmodel(level.machine_assets["whoswho"].off_model);
		}

		level thread do_initial_power_off_callback(machine, "whoswho");
		array_thread(machine_triggers, ::set_power_on, 0);
		level waittill("chugabud_on");

		for (i = 0; i < machine.size; i++)
		{
			machine[i] setmodel(level.machine_assets["whoswho"].on_model);
			machine[i] vibrate(vectorscale((0, -1, 0), 100.0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx("whoswho_light");
			machine[i] thread play_loop_on_machine();
		}

		level notify("specialty_finalstand_power_on");
		array_thread(machine_triggers, ::set_power_on, 1);

		if (isdefined(level.machine_assets["whoswho"].power_on_callback))
		{
			array_thread(machine, level.machine_assets["whoswho"].power_on_callback);
		}

		level waittill("chugabud_off");

		if (isdefined(level.machine_assets["whoswho"].power_off_callback))
		{
			array_thread(machine, level.machine_assets["whoswho"].power_off_callback);
		}

		array_thread(machine, ::turn_perk_off);
		players = get_players();

		foreach (player in players)
		{
			player.hasperkspecialtychugabud = undefined;
		}
	}
}

vending_trigger_think()
{
	self endon("death");
	wait 0.01;
	perk = self.script_noteworthy;
	solo = 0;
	start_on = 0;
	level.revive_machine_is_solo = 0;

	if (isdefined(perk) && (perk == "specialty_quickrevive" || perk == "specialty_quickrevive_upgrade"))
	{
		flag_wait("start_zombie_round_logic");
		solo = use_solo_revive();
		self endon("stop_quickrevive_logic");
		level.quick_revive_trigger = self;

		if (solo)
		{
			if (!is_true(level.revive_machine_is_solo))
			{
				start_on = 1;
				players = get_players();

				foreach (player in players)
				{
					if (!isdefined(player.lives))
					{
						player.lives = 0;
					}
				}

				level maps\mp\zombies\_zm::set_default_laststand_pistol(1);
			}

			level.revive_machine_is_solo = 1;
		}
	}

	self sethintstring(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	self usetriggerrequirelookat();
	cost = level.zombie_vars["zombie_perk_cost"];

	switch (perk)
	{
		case "specialty_armorvest_upgrade":
		case "specialty_armorvest":
			cost = 2500;
			break;

		case "specialty_quickrevive_upgrade":
		case "specialty_quickrevive":
			if (solo)
			{
				cost = 500;
			}
			else
			{
				cost = 1500;
			}

			break;

		case "specialty_fastreload_upgrade":
		case "specialty_fastreload":
			cost = 3000;
			break;

		case "specialty_rof_upgrade":
		case "specialty_rof":
			cost = 2000;
			break;

		case "specialty_longersprint_upgrade":
		case "specialty_longersprint":
			cost = 2000;
			break;

		case "specialty_deadshot_upgrade":
		case "specialty_deadshot":
			cost = 1500;
			break;

		case "specialty_additionalprimaryweapon_upgrade":
		case "specialty_additionalprimaryweapon":
			cost = 4000;
			break;
	}

	if (isdefined(level._custom_perks[perk]) && isdefined(level._custom_perks[perk].cost))
	{
		cost = level._custom_perks[perk].cost;
	}

	self.cost = cost;

	if (!start_on)
	{
		notify_name = perk + "_power_on";

		level waittill(notify_name);
	}

	start_on = 0;

	if (!isdefined(level._perkmachinenetworkchoke))
	{
		level._perkmachinenetworkchoke = 0;
	}
	else
	{
		level._perkmachinenetworkchoke++;
	}

	for (i = 0; i < level._perkmachinenetworkchoke; i++)
	{
		wait_network_frame();
	}

	self thread maps\mp\zombies\_zm_audio::perks_a_cola_jingle_timer();
	self thread check_player_has_perk(perk);

	switch (perk)
	{
		case "specialty_armorvest_upgrade":
		case "specialty_armorvest":
			self sethintstring(&"ZOMBIE_PERK_JUGGERNAUT", cost);
			break;

		case "specialty_quickrevive_upgrade":
		case "specialty_quickrevive":
			if (solo)
			{
				self sethintstring(&"ZOMBIE_PERK_QUICKREVIVE_SOLO", cost);
			}
			else
			{
				self sethintstring(&"ZOMBIE_PERK_QUICKREVIVE", cost);
			}

			break;

		case "specialty_fastreload_upgrade":
		case "specialty_fastreload":
			self sethintstring(&"ZOMBIE_PERK_FASTRELOAD", cost);
			break;

		case "specialty_rof_upgrade":
		case "specialty_rof":
			self sethintstring(&"ZOMBIE_PERK_DOUBLETAP", cost);
			break;

		case "specialty_longersprint_upgrade":
		case "specialty_longersprint":
			self sethintstring(&"ZOMBIE_PERK_MARATHON", cost);
			break;

		case "specialty_deadshot_upgrade":
		case "specialty_deadshot":
			self sethintstring(&"ZOMBIE_PERK_DEADSHOT", cost);
			break;

		case "specialty_additionalprimaryweapon_upgrade":
		case "specialty_additionalprimaryweapon":
			self sethintstring(&"ZOMBIE_PERK_ADDITIONALPRIMARYWEAPON", cost);
			break;

		case "specialty_scavenger_upgrade":
		case "specialty_scavenger":
			self sethintstring(&"ZOMBIE_PERK_TOMBSTONE", cost);
			break;

		case "specialty_finalstand_upgrade":
		case "specialty_finalstand":
			self sethintstring(&"ZOMBIE_PERK_CHUGABUD", cost);
			break;

		default:
			self sethintstring(perk + " Cost: " + level.zombie_vars["zombie_perk_cost"]);
	}

	if (isdefined(level._custom_perks[perk]) && isdefined(level._custom_perks[perk].hint_string))
	{
		self sethintstring(level._custom_perks[perk].hint_string, cost);
	}

	for (;;)
	{
		self waittill("trigger", player);

		index = maps\mp\zombies\_zm_weapons::get_player_index(player);

		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(player.intermission) && player.intermission)
		{
			continue;
		}

		if (player in_revive_trigger())
		{
			continue;
		}

		if (player isthrowinggrenade())
		{
			wait 0.1;
			continue;
		}

		if (player isswitchingweapons())
		{
			wait 0.1;
			continue;
		}

		if (player.is_drinking > 0)
		{
			wait 0.1;
			continue;
		}

		if (player hasperk(perk) || player has_perk_paused(perk))
		{
			cheat = 0;

			if (cheat != 1)
			{
				self playsound("evt_perk_deny");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 1);
				continue;
			}
		}

		if (isdefined(level.custom_perk_validation))
		{
			valid = self [[level.custom_perk_validation]](player);

			if (!valid)
			{
				continue;
			}
		}

		current_cost = cost;

		if (player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			current_cost = player maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_double_points_cost(current_cost);
		}

		if (player.score < current_cost)
		{
			self playsound("evt_perk_deny");
			player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 0);
			continue;
		}

		sound = "evt_bottle_dispense";
		playsoundatposition(sound, self.origin);
		player maps\mp\zombies\_zm_score::minus_to_player_score(current_cost, 1);
		player.perk_purchased = perk;
		self thread maps\mp\zombies\_zm_audio::play_jingle_or_stinger(self.script_label);
		self thread vending_trigger_post_think(player, perk);
	}
}

vending_trigger_post_think(player, perk)
{
	player endon("disconnect");
	player endon("end_game");
	player endon("perk_abort_drinking");
	player.pre_temp_weapon = player perk_give_bottle_begin(perk);
	evt = player waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");

	if (evt == "weapon_change_complete")
	{
		player thread wait_give_perk(perk, 1);
	}

	player perk_give_bottle_end(player.pre_temp_weapon, perk);

	if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(player.intermission) && player.intermission)
	{
		player.lastactiveweapon = player.pre_temp_weapon;
		return;
	}

	player.pre_temp_weapon = undefined;

	player notify("burp");

	if (isdefined(level.pers_upgrade_cash_back) && level.pers_upgrade_cash_back)
	{
		player maps\mp\zombies\_zm_pers_upgrades_functions::cash_back_player_drinks_perk();
	}

	if (isdefined(level.pers_upgrade_perk_lose) && level.pers_upgrade_perk_lose)
	{
		player thread maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_perk_lose_bought();
	}

	if (isdefined(level.perk_bought_func))
	{
		player [[level.perk_bought_func]](perk);
	}

	player.perk_purchased = undefined;

	if (is_false(self.power_on))
	{
		wait 1;
		perk_pause(self.script_noteworthy);
	}

	bbprint("zombie_uses", "playername %s playerscore %d round %d name %s x %f y %f z %f type %s", player.name, player.score, level.round_number, perk, self.origin, "perk");
}

perk_give_bottle_end(gun, perk)
{
	self endon("perk_abort_drinking");
	assert(!is_zombie_perk_bottle(gun));
	assert(gun != level.revive_tool);
	self enable_player_move_states();
	weapon = "";

	switch (perk)
	{
		case "specialty_rof_upgrade":
		case "specialty_rof":
			weapon = level.machine_assets["doubletap"].weapon;
			break;

		case "specialty_longersprint_upgrade":
		case "specialty_longersprint":
			weapon = level.machine_assets["marathon"].weapon;
			break;

		case "specialty_flakjacket_upgrade":
		case "specialty_flakjacket":
			weapon = level.machine_assets["divetonuke"].weapon;
			break;

		case "specialty_armorvest_upgrade":
		case "specialty_armorvest":
			weapon = level.machine_assets["juggernog"].weapon;
			self.jugg_used = 1;
			break;

		case "specialty_quickrevive_upgrade":
		case "specialty_quickrevive":
			weapon = level.machine_assets["revive"].weapon;
			break;

		case "specialty_fastreload_upgrade":
		case "specialty_fastreload":
			weapon = level.machine_assets["speedcola"].weapon;
			self.speed_used = 1;
			break;

		case "specialty_deadshot_upgrade":
		case "specialty_deadshot":
			weapon = level.machine_assets["deadshot"].weapon;
			break;

		case "specialty_additionalprimaryweapon_upgrade":
		case "specialty_additionalprimaryweapon":
			weapon = level.machine_assets["additionalprimaryweapon"].weapon;
			break;

		case "specialty_scavenger_upgrade":
		case "specialty_scavenger":
			weapon = level.machine_assets["tombstone"].weapon;
			break;

		case "specialty_finalstand_upgrade":
		case "specialty_finalstand":
			weapon = level.machine_assets["whoswho"].weapon;
			break;
	}

	if (isdefined(level._custom_perks[perk]) && isdefined(level._custom_perks[perk].perk_bottle))
	{
		weapon = level._custom_perks[perk].perk_bottle;
	}

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(self.intermission) && self.intermission)
	{
		self takeweapon(weapon);
		return;
	}

	self takeweapon(weapon);

	if (self is_multiple_drinking())
	{
		self decrement_is_drinking();
		return;
	}
	else if (gun != "none" && !is_equipment_that_blocks_purchase(gun))
	{
		self switchtoweapon(gun);

		if (is_melee_weapon(gun))
		{
			self decrement_is_drinking();
			return;
		}
	}
	else
	{
		primaryweapons = self getweaponslistprimaries();

		if (isdefined(primaryweapons) && primaryweapons.size > 0)
		{
			self switchtoweapon(primaryweapons[0]);
		}
	}

	self waittill("weapon_change_complete");

	if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !(isdefined(self.intermission) && self.intermission))
	{
		self decrement_is_drinking();
	}
}

vending_weapon_upgrade()
{
	level endon("Pack_A_Punch_off");
	wait 0.01;
	perk_machine = getent(self.target, "targetname");
	self.perk_machine = perk_machine;
	perk_machine_sound = getentarray("perksacola", "targetname");
	packa_rollers = spawn("script_origin", self.origin);
	packa_timer = spawn("script_origin", self.origin);
	packa_rollers linkto(self);
	packa_timer linkto(self);

	if (isdefined(perk_machine.target))
	{
		perk_machine.wait_flag = getent(perk_machine.target, "targetname");
	}

	pap_is_buildable = self is_buildable();

	if (pap_is_buildable)
	{
		self trigger_off();
		perk_machine hide();

		if (isdefined(perk_machine.wait_flag))
		{
			perk_machine.wait_flag hide();
		}

		wait_for_buildable("pap");
		self trigger_on();
		perk_machine show();

		if (isdefined(perk_machine.wait_flag))
		{
			perk_machine.wait_flag show();
		}
	}

	self usetriggerrequirelookat();
	self sethintstring(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	power_off = !self maps\mp\zombies\_zm_power::pap_is_on();

	if (power_off)
	{
		pap_array = [];
		pap_array[0] = perk_machine;
		level thread do_initial_power_off_callback(pap_array, "packapunch");

		level waittill("Pack_A_Punch_on");
	}

	self enable_trigger();

	if (isdefined(level.machine_assets["packapunch"].power_on_callback))
	{
		perk_machine thread [[level.machine_assets["packapunch"].power_on_callback]]();
	}

	self thread vending_machine_trigger_think();
	perk_machine playloopsound("zmb_perks_packa_loop");
	self thread shutoffpapsounds(perk_machine, packa_rollers, packa_timer);
	self thread vending_weapon_upgrade_cost();

	for (;;)
	{
		self.pack_player = undefined;

		self waittill("trigger", player);

		index = maps\mp\zombies\_zm_weapons::get_player_index(player);
		current_weapon = player getcurrentweapon();

		if ("microwavegun_zm" == current_weapon)
		{
			current_weapon = "microwavegundw_zm";
		}

		current_weapon = player maps\mp\zombies\_zm_weapons::switch_from_alt_weapon(current_weapon);

		if (isdefined(level.custom_pap_validation))
		{
			valid = self [[level.custom_pap_validation]](player);

			if (!valid)
			{
				continue;
			}
		}

		if (!player maps\mp\zombies\_zm_magicbox::can_buy_weapon() || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || isdefined(player.intermission) && player.intermission || player isthrowinggrenade() || !player maps\mp\zombies\_zm_weapons::can_upgrade_weapon(current_weapon))
		{
			wait 0.1;
			continue;
		}

		if (player isswitchingweapons())
		{
			wait 0.1;

			if (player isswitchingweapons())
			{
				continue;
			}
		}

		if (!maps\mp\zombies\_zm_weapons::is_weapon_or_base_included(current_weapon))
		{
			continue;
		}

		current_cost = self.cost;
		player.restore_ammo = undefined;
		player.restore_clip = undefined;
		player.restore_stock = undefined;
		player_restore_clip_size = undefined;
		player.restore_max = undefined;
		upgrade_as_attachment = will_upgrade_weapon_as_attachment(current_weapon);

		if (upgrade_as_attachment)
		{
			current_cost = self.attachment_cost;
			player.restore_ammo = 1;
			player.restore_clip = player getweaponammoclip(current_weapon);
			player.restore_clip_size = weaponclipsize(current_weapon);
			player.restore_stock = player getweaponammostock(current_weapon);
			player.restore_max = weaponmaxammo(current_weapon);
		}

		if (player maps\mp\zombies\_zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			current_cost = player maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_double_points_cost(current_cost);
		}

		if (!upgrade_as_attachment && player.score < current_cost)
		{
			self playsound("evt_perk_deny");

			if (isdefined(level.custom_pap_deny_vo_func))
			{
				player [[level.custom_pap_deny_vo_func]]();
			}
			else
			{
				player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "perk_deny", undefined, 0);
			}

			continue;
		}

		self.pack_player = player;
		flag_set("pack_machine_in_use");
		maps\mp\_demo::bookmark("zm_player_use_packapunch", gettime(), player);
		player maps\mp\zombies\_zm_stats::increment_client_stat("use_pap");
		player maps\mp\zombies\_zm_stats::increment_player_stat("use_pap");
		self thread destroy_weapon_in_blackout(player);
		self thread destroy_weapon_on_disconnect(player);

		if (!upgrade_as_attachment)
		{
			player maps\mp\zombies\_zm_score::minus_to_player_score(current_cost, 1);
		}

		sound = "evt_bottle_dispense";
		playsoundatposition(sound, self.origin);
		self thread maps\mp\zombies\_zm_audio::play_jingle_or_stinger("mus_perks_packa_sting");
		player maps\mp\zombies\_zm_audio::create_and_play_dialog("weapon_pickup", "upgrade_wait");
		self disable_trigger();
		self sethintstring("");

		if (!(isdefined(upgrade_as_attachment) && upgrade_as_attachment))
		{
			player thread do_player_general_vox("general", "pap_wait", 10, 100);
		}
		else
		{
			player thread do_player_general_vox("general", "pap_wait2", 10, 100);
		}

		player thread do_knuckle_crack();
		self.current_weapon = current_weapon;
		upgrade_name = maps\mp\zombies\_zm_weapons::get_upgrade_weapon(current_weapon, upgrade_as_attachment);
		player third_person_weapon_upgrade(current_weapon, upgrade_name, packa_rollers, perk_machine, self);
		self enable_trigger();
		self sethintstring(&"ZOMBIE_GET_UPGRADED");

		if (isdefined(player))
		{
			self setinvisibletoall();
			self setvisibletoplayer(player);
			self thread wait_for_player_to_take(player, current_weapon, packa_timer, upgrade_as_attachment);
		}

		self thread wait_for_timeout(current_weapon, packa_timer, player);
		self waittill_any("pap_timeout", "pap_taken", "pap_player_disconnected");
		self.current_weapon = "";

		if (isdefined(self.worldgun) && isdefined(self.worldgun.worldgundw))
		{
			self.worldgun.worldgundw delete();
		}

		if (isdefined(self.worldgun))
		{
			self.worldgun delete();
		}

		if (isdefined(level.zombiemode_reusing_pack_a_punch) && level.zombiemode_reusing_pack_a_punch)
		{
			self sethintstring(&"ZOMBIE_PERK_PACKAPUNCH_ATT", self.cost);
		}
		else
		{
			self sethintstring(&"ZOMBIE_PERK_PACKAPUNCH", self.cost);
		}

		self setvisibletoall();
		self.pack_player = undefined;
		flag_clear("pack_machine_in_use");
	}
}

destroy_weapon_in_blackout(player)
{
	self endon("pap_timeout");
	self endon("pap_taken");
	self endon("pap_player_disconnected");

	level waittill("Pack_A_Punch_off");

	if (isDefined(self.worldgun))
	{
		if (isDefined(self.worldgun.worldgundw))
		{
			self.worldgun.worldgundw delete();
		}

		self.worldgun delete();
	}

	self.perk_machine.wait_flag rotateTo(self.perk_machine.angles + (0, 180, 180), 0.25, 0, 0);
}

give_perk(perk, bought)
{
	self setperk(perk);
	self.num_perks++;

	if (isDefined(bought) && bought)
	{
		self maps\mp\zombies\_zm_audio::playerexert("burp");

		if (isDefined(level.remove_perk_vo_delay) && level.remove_perk_vo_delay)
		{
			self maps\mp\zombies\_zm_audio::perk_vox(perk);
		}
		else
		{
			self delay_thread(1.5, maps\mp\zombies\_zm_audio::perk_vox, perk);
		}

		self notify("perk_bought");
	}

	self perk_set_max_health_if_jugg(perk, 1, 0);

	if (!(isDefined(level.disable_deadshot_clientfield) && level.disable_deadshot_clientfield))
	{
		if (perk == "specialty_deadshot")
		{
			self setclientfieldtoplayer("deadshot_perk", 1);
		}
		else
		{
			if (perk == "specialty_deadshot_upgrade")
			{
				self setclientfieldtoplayer("deadshot_perk", 1);
			}
		}
	}

	if (perk == "specialty_scavenger")
	{
		self.hasperkspecialtytombstone = 1;
	}

	players = get_players();

	if (use_solo_revive() && perk == "specialty_quickrevive")
	{
		self.lives = 1;

		if (!isDefined(level.solo_lives_given))
		{
			level.solo_lives_given = 0;
		}

		if (isDefined(level.solo_game_free_player_quickrevive))
		{
			level.solo_game_free_player_quickrevive = undefined;
		}
		else
		{
			level.solo_lives_given++;
		}

		if (level.solo_lives_given >= 3)
		{
			flag_set("solo_revive");
		}

		self thread solo_revive_buy_trigger_move(perk);
	}

	if (perk == "specialty_finalstand")
	{
		self.hasperkspecialtychugabud = 1;
		self notify("perk_chugabud_activated");
	}

	if (perk == "specialty_additionalprimaryweapon")
	{
		self scripts\zm\replaced\_zm::restore_additionalprimaryweapon();
		self notify("perk_additionalprimaryweapon_activated");
	}

	if (isDefined(level._custom_perks[perk]) && isDefined(level._custom_perks[perk].player_thread_give))
	{
		self thread [[level._custom_perks[perk].player_thread_give]]();
	}

	self set_perk_clientfield(perk, 1);
	maps\mp\_demo::bookmark("zm_player_perk", getTime(), self);
	self maps\mp\zombies\_zm_stats::increment_client_stat("perks_drank");
	self maps\mp\zombies\_zm_stats::increment_client_stat(perk + "_drank");
	self maps\mp\zombies\_zm_stats::increment_player_stat(perk + "_drank");
	self maps\mp\zombies\_zm_stats::increment_player_stat("perks_drank");

	if (!isDefined(self.perk_history))
	{
		self.perk_history = [];
	}

	self.perk_history = add_to_array(self.perk_history, perk, 0);

	if (!isDefined(self.perks_active))
	{
		self.perks_active = [];
	}

	self.perks_active[self.perks_active.size] = perk;
	self notify("perk_acquired");
	self thread perk_think(perk);
}

perk_think(perk)
{
	self endon("disconnect");

	perk_str = perk + "_stop";
	result = self waittill_any_return("fake_death", "death", "player_downed", perk_str);
	do_retain = 1;

	if (use_solo_revive() && perk == "specialty_quickrevive")
	{
		do_retain = 0;
	}

	if (do_retain)
	{
		if (is_true(self._retain_perks))
		{
			return;
		}
		else if (isDefined(self._retain_perks_array) && is_true(self._retain_perks_array[perk]))
		{
			return;
		}
	}

	self unsetperk(perk);
	self.num_perks--;

	switch (perk)
	{
		case "specialty_armorvest":
			self setmaxhealth(self.premaxhealth);
			break;

		case "specialty_additionalprimaryweapon":
			if (result == perk_str)
			{
				self maps\mp\zombies\_zm::take_additionalprimaryweapon();
			}

			break;

		case "specialty_deadshot":
			if (!is_true(level.disable_deadshot_clientfield))
			{
				self setclientfieldtoplayer("deadshot_perk", 0);
			}

			break;

		case "specialty_deadshot_upgrade":
			if (!is_true(level.disable_deadshot_clientfield))
			{
				self setclientfieldtoplayer("deadshot_perk", 0);
			}

			break;

		case "specialty_scavenger":
			self.hasperkspecialtytombstone = undefined;
			break;
	}

	if (isDefined(level._custom_perks[perk]) && isDefined(level._custom_perks[perk].player_thread_take))
	{
		self thread [[level._custom_perks[perk].player_thread_take]]();
	}

	self set_perk_clientfield(perk, 0);
	self.perk_purchased = undefined;

	if (isDefined(level.perk_lost_func))
	{
		self [[level.perk_lost_func]](perk);
	}

	if (isDefined(self.perks_active) && isinarray(self.perks_active, perk))
	{
		arrayremovevalue(self.perks_active, perk, 0);
	}

	if (isDefined(self.disabled_perks) && isDefined(self.disabled_perks[perk]))
	{
		self.disabled_perks[perk] = undefined;
	}

	self notify("perk_lost");
}

perk_set_max_health_if_jugg(perk, set_premaxhealth, clamp_health_to_max_health)
{
	max_total_health = undefined;

	if (perk == "specialty_armorvest")
	{
		if (set_premaxhealth)
		{
			self.premaxhealth = self.maxhealth;
		}

		max_total_health = level.zombie_vars["zombie_perk_juggernaut_health"];
	}
	else if (perk == "specialty_armorvest_upgrade")
	{
		if (set_premaxhealth)
		{
			self.premaxhealth = self.maxhealth;
		}

		max_total_health = level.zombie_vars["zombie_perk_juggernaut_health_upgrade"];
	}
	else if (perk == "jugg_upgrade")
	{
		if (set_premaxhealth)
		{
			self.premaxhealth = self.maxhealth;
		}

		if (self hasperk("specialty_armorvest"))
		{
			max_total_health = level.zombie_vars["zombie_perk_juggernaut_health"];
		}
		else
		{
			max_total_health = level.player_starting_health;
		}
	}
	else if (perk == "health_reboot")
	{
		if (self hasperk("specialty_armorvest"))
		{
			max_total_health = level.zombie_vars["zombie_perk_juggernaut_health"];
		}
		else
		{
			max_total_health = level.player_starting_health;
		}
	}

	if (isDefined(max_total_health))
	{
		if (self maps\mp\zombies\_zm_pers_upgrades_functions::pers_jugg_active())
		{
			max_total_health += level.pers_jugg_upgrade_health_bonus;
		}

		if (is_true(level.sudden_death))
		{
			max_total_health -= 100;
		}

		missinghealth = self.maxhealth - self.health;
		self setmaxhealth(max_total_health);
		self.health -= missinghealth;

		if (isDefined(clamp_health_to_max_health) && clamp_health_to_max_health == 1)
		{
			if (self.health > self.maxhealth)
			{
				self.health = self.maxhealth;
			}
		}
	}
}

set_perk_clientfield(perk, state)
{
	switch (perk)
	{
		case "specialty_additionalprimaryweapon":
			self setclientfieldtoplayer("perk_additional_primary_weapon", state);
			break;

		case "specialty_deadshot":
			self setclientfieldtoplayer("perk_dead_shot", state);
			break;

		case "specialty_flakjacket":
			self setclientfieldtoplayer("perk_dive_to_nuke", state);
			break;

		case "specialty_rof":
			self setclientfieldtoplayer("perk_double_tap", state);
			break;

		case "specialty_armorvest":
			self setclientfieldtoplayer("perk_juggernaut", state);
			break;

		case "specialty_movefaster":
			self setclientfieldtoplayer("perk_marathon", state);
			break;

		case "specialty_quickrevive":
			self setclientfieldtoplayer("perk_quick_revive", state);
			break;

		case "specialty_fastreload":
			self setclientfieldtoplayer("perk_sleight_of_hand", state);
			break;

		case "specialty_scavenger":
			self setclientfieldtoplayer("perk_tombstone", state);
			break;

		case "specialty_finalstand":
			self setclientfieldtoplayer("perk_chugabud", state);
			break;

		default:
			break;
	}

	if (isdefined(level._custom_perks[perk]) && isdefined(level._custom_perks[perk].clientfield_set))
	{
		self [[level._custom_perks[perk].clientfield_set]](state);
	}
}

initialize_custom_perk_arrays()
{
	if (!isDefined(level._custom_perks))
	{
		level._custom_perks = [];
	}

	level._custom_perks["specialty_movefaster"] = spawnStruct();
	level._custom_perks["specialty_movefaster"].cost = 2500;
	level._custom_perks["specialty_movefaster"].alias = "marathon";
	level._custom_perks["specialty_movefaster"].hint_string = &"ZOMBIE_PERK_MARATHON";
	level._custom_perks["specialty_movefaster"].perk_bottle = "zombie_perk_bottle_marathon";
	level._custom_perks["specialty_movefaster"].perk_machine_thread = ::turn_movefaster_on;

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_longersprint";
	struct.scr_zm_ui_gametype = "zstandard";
	struct.scr_zm_map_start_location = "town";
	struct.origin_offset = (-4, 0, 0);
	move_perk_machine("zm_transit", "town", "specialty_quickrevive", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_longersprint";
	struct.scr_zm_ui_gametype = "zclassic";
	struct.scr_zm_map_start_location = "transit";
	move_perk_machine("zm_transit", "town", "specialty_longersprint", struct);

	struct = spawnStruct();
	struct.origin = (1852, -825, -56);
	struct.angles = (0, 180, 0);
	struct.script_string = "zgrief";
	move_perk_machine("zm_transit", "town", "specialty_scavenger", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_quickrevive";
	struct.scr_zm_ui_gametype = "zgrief";
	struct.scr_zm_map_start_location = "street";
	move_perk_machine("zm_buried", "street", "specialty_longersprint", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_fastreload";
	struct.scr_zm_ui_gametype = "zgrief";
	struct.scr_zm_map_start_location = "street";
	struct.origin_offset = (0, -32, 0);
	move_perk_machine("zm_buried", "street", "specialty_quickrevive", struct);

	struct = spawnStruct();
	struct.script_noteworthy = "specialty_fastreload";
	struct.scr_zm_ui_gametype = "zclassic";
	struct.scr_zm_map_start_location = "processing";
	move_perk_machine("zm_buried", "street", "specialty_fastreload", struct);

	if (getDvar("g_gametype") == "zgrief" && getDvarIntDefault("ui_gametype_pro", 0))
	{
		remove_pap_machine();
	}
}

remove_pap_machine()
{
	exceptions = array("specialty_armorvest", "specialty_fastreload");

	structs = getStructArray("zm_perk_machine", "targetname");

	foreach (struct in structs)
	{
		if (isDefined(struct.script_noteworthy) && struct.script_noteworthy == "specialty_weapupgrade")
		{
			struct.script_string = "";
		}
	}
}

move_perk_machine(map, location, perk, move_struct)
{
	if (!(level.script == map && level.scr_zm_map_start_location == location))
	{
		return;
	}

	perk_struct = undefined;
	structs = getStructArray("zm_perk_machine", "targetname");

	foreach (struct in structs)
	{
		if (isDefined(struct.script_noteworthy) && struct.script_noteworthy == perk)
		{
			if (isDefined(struct.script_string) && isSubStr(struct.script_string, "perks_" + location))
			{
				perk_struct = struct;
				break;
			}
		}
	}

	if (!isDefined(perk_struct))
	{
		return;
	}

	if (isDefined(move_struct.script_string))
	{
		gametypes = strTok(move_struct.script_string, " ");

		foreach (gametype in gametypes)
		{
			perk_struct.script_string += " " + gametype + "_perks_" + location;
		}
	}

	if (isDefined(move_struct.origin))
	{
		perk_struct.origin = move_struct.origin;
		perk_struct.angles = move_struct.angles;

		return;
	}

	foreach (struct in structs)
	{
		if (isDefined(struct.script_noteworthy) && struct.script_noteworthy == move_struct.script_noteworthy)
		{
			if (isDefined(struct.script_string) && isSubStr(struct.script_string, move_struct.scr_zm_ui_gametype + "_perks_" + move_struct.scr_zm_map_start_location))
			{
				perk_struct.origin = struct.origin;
				perk_struct.angles = struct.angles;

				if (isDefined(move_struct.origin_offset))
				{
					perk_struct.origin += move_struct.origin_offset;
				}

				break;
			}
		}
	}
}

turn_movefaster_on()
{
	while (1)
	{
		machine = getentarray("vending_marathon", "targetname");
		machine_triggers = getentarray("vending_marathon", "target");
		i = 0;

		while (i < machine.size)
		{
			machine[i] setmodel(level.machine_assets["marathon"].off_model);
			i++;
		}

		array_thread(machine_triggers, ::set_power_on, 0);
		level thread do_initial_power_off_callback(machine, "marathon");
		level waittill("marathon_on");
		i = 0;

		while (i < machine.size)
		{
			machine[i] setmodel(level.machine_assets["marathon"].on_model);
			machine[i] vibrate(vectorScale((0, -1, 0), 100), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx("marathon_light");
			machine[i] thread play_loop_on_machine();
			i++;
		}

		level notify("specialty_movefaster_power_on");
		array_thread(machine_triggers, ::set_power_on, 1);

		if (isDefined(level.machine_assets["marathon"].power_on_callback))
		{
			array_thread(machine, level.machine_assets["marathon"].power_on_callback);
		}

		level waittill("marathon_off");

		if (isDefined(level.machine_assets["marathon"].power_off_callback))
		{
			array_thread(machine, level.machine_assets["marathon"].power_off_callback);
		}

		array_thread(machine, ::turn_perk_off);
	}
}

turn_tombstone_on()
{
	level endon("tombstone_removed");

	while (true)
	{
		machine = getentarray("vending_tombstone", "targetname");
		machine_triggers = getentarray("vending_tombstone", "target");

		for (i = 0; i < machine.size; i++)
		{
			machine[i] setmodel(level.machine_assets["tombstone"].off_model);
		}

		level thread do_initial_power_off_callback(machine, "tombstone");
		array_thread(machine_triggers, ::set_power_on, 0);

		level waittill("tombstone_on");

		for (i = 0; i < machine.size; i++)
		{
			machine[i] setmodel(level.machine_assets["tombstone"].on_model);
			machine[i] vibrate(vectorscale((0, -1, 0), 100.0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx("tombstone_light");
			machine[i] thread play_loop_on_machine();
		}

		level notify("specialty_scavenger_power_on");
		array_thread(machine_triggers, ::set_power_on, 1);

		if (isdefined(level.machine_assets["tombstone"].power_on_callback))
		{
			array_thread(machine, level.machine_assets["tombstone"].power_on_callback);
		}

		level waittill("tombstone_off");

		if (isdefined(level.machine_assets["tombstone"].power_off_callback))
		{
			array_thread(machine, level.machine_assets["tombstone"].power_off_callback);
		}

		array_thread(machine, ::turn_perk_off);
		players = get_players();
	}
}

wait_for_player_to_take(player, weapon, packa_timer, upgrade_as_attachment)
{
	current_weapon = self.current_weapon;
	upgrade_name = self.upgrade_name;
	upgrade_weapon = upgrade_name;
	self endon("pap_timeout");
	level endon("Pack_A_Punch_off");

	while (true)
	{
		packa_timer playloopsound("zmb_perks_packa_ticktock");

		self waittill("trigger", trigger_player);

		if (isdefined(level.pap_grab_by_anyone) && level.pap_grab_by_anyone)
		{
			player = trigger_player;
		}

		packa_timer stoploopsound(0.05);

		if (trigger_player == player)
		{
			player maps\mp\zombies\_zm_stats::increment_client_stat("pap_weapon_grabbed");
			player maps\mp\zombies\_zm_stats::increment_player_stat("pap_weapon_grabbed");
			current_weapon = player getcurrentweapon();

			primaries = player getweaponslistprimaries();
			weapon_limit = get_player_weapon_limit(player);

			if (is_player_valid(player) && !(player.is_drinking > 0) && level.revive_tool != current_weapon && "none" != current_weapon && !player hacker_active() && (primaries.size < weapon_limit || (!is_melee_weapon(current_weapon) && !is_placeable_mine(current_weapon) && !is_equipment(current_weapon))))
			{
				maps\mp\_demo::bookmark("zm_player_grabbed_packapunch", gettime(), player);
				self notify("pap_taken");
				player notify("pap_taken");
				player.pap_used = 1;

				if (!(isdefined(upgrade_as_attachment) && upgrade_as_attachment))
				{
					player thread do_player_general_vox("general", "pap_arm", 15, 100);
				}
				else
				{
					player thread do_player_general_vox("general", "pap_arm2", 15, 100);
				}

				weapon_limit = get_player_weapon_limit(player);
				player maps\mp\zombies\_zm_weapons::take_fallback_weapon();
				primaries = player getweaponslistprimaries();

				if (isdefined(primaries) && primaries.size >= weapon_limit)
				{
					player maps\mp\zombies\_zm_weapons::weapon_give(upgrade_weapon);
				}
				else
				{
					player giveweapon(upgrade_weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(upgrade_weapon));
					player givestartammo(upgrade_weapon);
					player notify("weapon_ammo_change");
				}

				player switchtoweapon(upgrade_weapon);

				if (isdefined(player.restore_ammo) && player.restore_ammo)
				{
					new_clip = player.restore_clip + weaponclipsize(upgrade_weapon) - player.restore_clip_size;
					new_stock = player.restore_stock + weaponmaxammo(upgrade_weapon) - player.restore_max;
					player setweaponammostock(upgrade_weapon, new_stock);
					player setweaponammoclip(upgrade_weapon, new_clip);
				}

				player.restore_ammo = undefined;
				player.restore_clip = undefined;
				player.restore_stock = undefined;
				player.restore_max = undefined;
				player.restore_clip_size = undefined;
				player maps\mp\zombies\_zm_weapons::play_weapon_vo(upgrade_weapon);
				return;
			}
		}

		wait 0.05;
	}
}

check_player_has_perk(perk)
{
	self endon("death");

	dist = 16384;

	while (true)
	{
		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			if (distancesquared(players[i].origin, self.origin) < dist)
			{
				if (!players[i] hasperk(perk) && !players[i] has_perk_paused(perk) && !players[i] in_revive_trigger() && !is_equipment_that_blocks_purchase(players[i] getcurrentweapon()) && !players[i] hacker_active() && !players[i].is_drinking)
				{
					self setinvisibletoplayer(players[i], 0);
					continue;
				}

				self setinvisibletoplayer(players[i], 1);
			}
		}

		wait 0.05;
	}
}

get_perk_array(ignore_chugabud)
{
	perk_array = [];
	trigs = getentarray("zombie_vending", "targetname");

	foreach (trig in trigs)
	{
		if (trig.script_noteworthy == "specialty_finalstand" && is_true(ignore_chugabud))
		{
			continue;
		}

		if (self hasperk(trig.script_noteworthy))
		{
			perk_array[perk_array.size] = trig.script_noteworthy;
		}
	}

	return perk_array;
}

do_initial_power_off_callback(machine_array, perkname)
{
	if (!isdefined(level.machine_assets[perkname]))
	{
		return;
	}

	if (!isdefined(level.machine_assets[perkname].power_off_callback))
	{
		return;
	}

	if (is_true(level.machine_assets[perkname].initial_power_off_callback_done))
	{
		return;
	}

	level.machine_assets[perkname].initial_power_off_callback_done = 1;

	wait 0.05;
	array_thread(machine_array, level.machine_assets[perkname].power_off_callback);
}

perk_pause(perk)
{
	// disabled
}

perk_unpause(perk)
{
	// disabled
}