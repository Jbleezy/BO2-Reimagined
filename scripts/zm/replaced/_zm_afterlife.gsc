#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_perk_electric_cherry;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zm_alcatraz_travel;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_ai_basic;

init()
{
	level.zombiemode_using_afterlife = 1;
	flag_init("afterlife_start_over");
	level.afterlife_revive_tool = "syrette_afterlife_zm";
	precacheitem(level.afterlife_revive_tool);
	precachemodel("drone_collision");
	maps\mp\_visionset_mgr::vsmgr_register_info("visionset", "zm_afterlife", 9000, 120, 1, 1);
	maps\mp\_visionset_mgr::vsmgr_register_info("overlay", "zm_afterlife_filter", 9000, 120, 1, 1);

	if (isdefined(level.afterlife_player_damage_override))
		maps\mp\zombies\_zm::register_player_damage_callback(level.afterlife_player_damage_override);
	else
		maps\mp\zombies\_zm::register_player_damage_callback(::afterlife_player_damage_callback);

	registerclientfield("toplayer", "player_lives", 9000, 2, "int");
	registerclientfield("toplayer", "player_in_afterlife", 9000, 1, "int");
	registerclientfield("toplayer", "player_afterlife_mana", 9000, 5, "float");
	registerclientfield("allplayers", "player_afterlife_fx", 9000, 1, "int");
	registerclientfield("toplayer", "clientfield_afterlife_audio", 9000, 1, "int");
	registerclientfield("toplayer", "player_afterlife_refill", 9000, 1, "int");
	registerclientfield("scriptmover", "player_corpse_id", 9000, 3, "int");
	afterlife_load_fx();
	level thread afterlife_hostmigration();
	precachemodel("c_zom_ghost_viewhands");
	precachemodel("c_zom_hero_ghost_fb");
	precacheitem("lightning_hands_zm");
	precachemodel("p6_zm_al_shock_box_on");
	precacheshader("waypoint_revive_afterlife");
	a_afterlife_interact = getentarray("afterlife_interact", "targetname");
	array_thread(a_afterlife_interact, ::afterlife_interact_object_think);
	level.zombie_spawners = getentarray("zombie_spawner", "script_noteworthy");
	array_thread(level.zombie_spawners, ::add_spawn_function, ::afterlife_zombie_damage);
	a_afterlife_triggers = getstructarray("afterlife_trigger", "targetname");

	foreach (struct in a_afterlife_triggers)
		afterlife_trigger_create(struct);

	level.afterlife_interact_dist = 256;
	level.is_player_valid_override = ::is_player_valid_afterlife;
	level.can_revive = ::can_revive_override;
	level.round_prestart_func = ::afterlife_start_zombie_logic;
	level.custom_pap_validation = ::is_player_valid_afterlife;
	level.player_out_of_playable_area_monitor_callback = ::player_out_of_playable_area;
	level thread afterlife_gameover_cleanup();
	level.afterlife_get_spawnpoint = ::afterlife_get_spawnpoint;
	level.afterlife_zapped = ::afterlife_zapped;
	level.afterlife_give_loadout = ::afterlife_give_loadout;
	level.afterlife_save_loadout = ::afterlife_save_loadout;
}

init_player()
{
	flag_wait("initial_players_connected");
	self.lives = 1;

	if (flag("start_zombie_round_logic"))
	{
		self setclientfieldtoplayer("player_lives", self.lives);
	}

	self.afterlife = 0;
	self.afterliferound = level.round_number;
	self.afterlifedeaths = 0;
	self thread afterlife_doors_close();
	self thread afterlife_player_refill_watch();
}

afterlife_add()
{
	if (self.lives < 1)
	{
		self.lives++;
		self thread afterlife_add_fx();
	}

	self playsoundtoplayer("zmb_afterlife_add", self);
	self setclientfieldtoplayer("player_lives", self.lives);
}

afterlife_start_zombie_logic()
{
	flag_wait("start_zombie_round_logic");
	wait 0.5;
	everyone_alive = 0;

	while (isDefined(everyone_alive) && !everyone_alive)
	{
		everyone_alive = 1;
		players = getplayers();

		foreach (player in players)
		{
			if (isDefined(player.afterlife) && player.afterlife)
			{
				everyone_alive = 0;
				wait 0.05;
				break;
			}
		}
	}

	wait 0.5;

	while (level.intermission)
	{
		wait 0.05;
	}

	flag_set("afterlife_start_over");
	wait 2;
	array_func(getplayers(), ::afterlife_add);
}

afterlife_laststand(b_electric_chair = 0)
{
	self endon("disconnect");
	self endon("afterlife_bleedout");
	level endon("end_game");

	if (isdefined(level.afterlife_laststand_override))
	{
		self thread [[level.afterlife_laststand_override]](b_electric_chair);
		return;
	}

	self.dontspeak = 1;
	self.health = self.maxhealth;
	b_has_electric_cherry = 0;

	if (self hasperk("specialty_grenadepulldeath"))
		b_has_electric_cherry = 1;

	self [[level.afterlife_save_loadout]]();
	self afterlife_fake_death();

	if (isdefined(b_electric_chair) && !b_electric_chair)
		wait 1;

	if (isdefined(b_has_electric_cherry) && b_has_electric_cherry && (isdefined(b_electric_chair) && !b_electric_chair))
	{
		self scripts\zm\replaced\_zm_perk_electric_cherry::electric_cherry_laststand();
	}

	self setclientfieldtoplayer("clientfield_afterlife_audio", 1);

	if (flag("afterlife_start_over"))
	{
		self clientnotify("al_t");
		wait 1;
		self thread fadetoblackforxsec(0, 1, 0.5, 0.5, "white");
		wait 0.5;
	}

	self ghost();
	corpse = self afterlife_spawn_corpse();
	self.e_afterlife_corpse = corpse;
	corpse.e_afterlife_player = self;
	self thread afterlife_clean_up_on_disconnect();
	self notify("player_fake_corpse_created");
	self afterlife_fake_revive();
	self afterlife_enter();
	self.e_afterlife_corpse setclientfield("player_corpse_id", self getentitynumber() + 1);
	wait 0.5;
	self show();

	if (!(isdefined(self.hostmigrationcontrolsfrozen) && self.hostmigrationcontrolsfrozen))
		self freezecontrols(0);

	self disableinvulnerability();

	self.e_afterlife_corpse waittill("player_revived", e_reviver);

	self notify("player_revived");
	self enableinvulnerability();
	self.afterlife_revived = 1;
	playsoundatposition("zmb_afterlife_spawn_leave", self.e_afterlife_corpse.origin);
	self afterlife_leave();
	self seteverhadweaponall(1);
	self thread afterlife_revive_invincible();
	self playsound("zmb_afterlife_revived_gasp");
}

afterlife_spawn_corpse()
{
	if (isdefined(self.is_on_gondola) && self.is_on_gondola && level.e_gondola.destination == "roof")
		corpse = maps\mp\zombies\_zm_clone::spawn_player_clone(self, self.origin, undefined);
	else
	{
		trace_start = self.origin;
		trace_end = self.origin + vectorscale((0, 0, -1), 500.0);
		corpse_trace = playerphysicstrace(trace_start, trace_end);
		corpse = spawn_player_clone(self, corpse_trace, undefined);
	}

	corpse.angles = self.angles;
	corpse.ignoreme = 1;
	corpse maps\mp\zombies\_zm_clone::clone_give_weapon(level.start_weapon);
	corpse maps\mp\zombies\_zm_clone::clone_animate("afterlife");
	corpse thread afterlife_revive_trigger_spawn();

	collision = spawn("script_model", corpse.origin + (0, 0, 16));
	collision.angles = corpse.angles;
	collision setmodel("collision_clip_32x32x32");
	collision linkto(corpse);
	collision ghost();
	corpse.collision = collision;

	if (get_players().size == 1)
		corpse thread afterlife_corpse_create_pois();

	return corpse;
}

afterlife_fake_death()
{
	level notify("fake_death");
	self notify("fake_death");
	self takeallweapons();
	self allowstand(0);
	self allowcrouch(0);
	self allowprone(1);
	self setstance("prone");
	self enableinvulnerability();
	self.ignoreme = 1;

	if (self is_jumping())
	{
		while (self is_jumping())
			wait 0.05;
	}

	playfx(level._effect["afterlife_enter"], self.origin);
	self freezecontrols(1);
}

afterlife_fake_revive()
{
	level notify("fake_revive");
	self notify("fake_revive");

	playsoundatposition("zmb_afterlife_spawn_leave", self.origin);

	self allowstand(1);
	self allowcrouch(0);
	self allowprone(0);
	self.ignoreme = 0;
	self setstance("stand");
	self giveweapon("lightning_hands_zm");
	self switchtoweapon("lightning_hands_zm");
	self.score = 0;

	if (flag("afterlife_start_over"))
	{
		spawnpoint = [[level.afterlife_get_spawnpoint]]();
		trace_start = spawnpoint.origin;
		trace_end = spawnpoint.origin + vectorscale((0, 0, -1), 200.0);
		respawn_trace = playerphysicstrace(trace_start, trace_end);
		dir = vectornormalize(self.origin - respawn_trace);
		angles = vectortoangles(dir);
		self setorigin(respawn_trace);
		self setplayerangles(angles);
		playsoundatposition("zmb_afterlife_spawn_enter", spawnpoint.origin);
	}
	else
	{
		playsoundatposition("zmb_afterlife_spawn_enter", self.origin);
	}

	wait 1;
}

afterlife_revive_invincible()
{
	self endon("disconnect");
	wait 2;
	self disableinvulnerability();
	self.afterlife_revived = undefined;
}

afterlife_revive_do_revive(playerbeingrevived, revivergun)
{
	playerbeingrevived_player = playerbeingrevived;
	playerbeingrevived_player.revive_hud.y = -160;
	beingrevivedprogressbar_y = level.primaryprogressbary * -1;

	if (isDefined(playerbeingrevived.e_afterlife_player))
	{
		playerbeingrevived_player = playerbeingrevived.e_afterlife_player;
		playerbeingrevived_player.revive_hud.y = -50;
		beingrevivedprogressbar_y = level.secondaryprogressbary * -2;
	}

	assert(self is_reviving_afterlife(playerbeingrevived));
	revivetime = 3;
	playloop = 0;

	if (isdefined(self.afterlife) && self.afterlife)
	{
		playloop = 1;
		revivetime = 1;
	}

	timer = 0;
	revived = 0;
	playerbeingrevived.revivetrigger.beingrevived = 1;
	playerbeingrevived.revivetrigger sethintstring("");

	if (playerbeingrevived_player != self)
	{
		playerbeingrevived_player.revive_hud settext(&"GAME_PLAYER_IS_REVIVING_YOU", self);
		playerbeingrevived_player revive_hud_show_n_fade(revivetime);
	}

	if (isplayer(playerbeingrevived))
	{
		playerbeingrevived startrevive(self);
	}

	if (!isDefined(playerbeingrevived_player.beingrevivedprogressbar) && playerbeingrevived_player != self)
	{
		playerbeingrevived_player.beingrevivedprogressbar = playerbeingrevived_player createprimaryprogressbar();
		playerbeingrevived_player.beingrevivedprogressbar setpoint("CENTER", undefined, level.primaryprogressbarx, beingrevivedprogressbar_y);
		playerbeingrevived_player.beingrevivedprogressbar.bar.color = (0.5, 0.5, 1);
		playerbeingrevived_player.beingrevivedprogressbar.hidewheninmenu = 1;
		playerbeingrevived_player.beingrevivedprogressbar.bar.hidewheninmenu = 1;
		playerbeingrevived_player.beingrevivedprogressbar.barframe.hidewheninmenu = 1;
		playerbeingrevived_player.beingrevivedprogressbar.sort = 1;
		playerbeingrevived_player.beingrevivedprogressbar.bar.sort = 2;
		playerbeingrevived_player.beingrevivedprogressbar.barframe.sort = 3;
		playerbeingrevived_player.beingrevivedprogressbar.barframe destroy();
		playerbeingrevived_player.beingrevivedprogressbar thread scripts\zm\_zm_reimagined::destroy_on_intermission();
	}

	if (!isdefined(self.reviveprogressbar))
	{
		self.reviveprogressbar = self createprimaryprogressbar();
		self.reviveprogressbar.bar.color = (0.5, 0.5, 1);
		self.reviveprogressbar.foreground = 1;
		self.reviveprogressbar.bar.foreground = 1;
		self.reviveprogressbar.barframe.foreground = 1;
		self.reviveprogressbar.sort = 1;
		self.reviveprogressbar.bar.sort = 2;
		self.reviveprogressbar.barframe.sort = 3;
		self.reviveprogressbar.barframe destroy();
		self.reviveprogressbar thread scripts\zm\_zm_reimagined::destroy_on_intermission();
	}

	if (!isdefined(self.revivetexthud))
		self.revivetexthud = newclienthudelem(self);

	self thread revive_clean_up_on_gameover();
	self thread laststand_clean_up_on_disconnect(playerbeingrevived, revivergun);

	if (!isdefined(self.is_reviving_any))
		self.is_reviving_any = 0;

	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any(playerbeingrevived);
	self.reviveprogressbar updatebar(0.01, 1 / revivetime);
	playerbeingrevived_player.beingrevivedprogressbar updatebar(0.01, 1 / revivetime);
	self.revivetexthud.alignx = "center";
	self.revivetexthud.aligny = "middle";
	self.revivetexthud.horzalign = "center";
	self.revivetexthud.vertalign = "bottom";
	self.revivetexthud.y = -113;

	if (self issplitscreen())
		self.revivetexthud.y = -347;

	self.revivetexthud.foreground = 1;
	self.revivetexthud.font = "default";
	self.revivetexthud.fontscale = 1.8;
	self.revivetexthud.alpha = 1;
	self.revivetexthud.color = (1, 1, 1);
	self.revivetexthud.hidewheninmenu = 1;

	if (self maps\mp\zombies\_zm_pers_upgrades_functions::pers_revive_active())
		self.revivetexthud.color = (0.5, 0.5, 1.0);

	self.revivetexthud settext(&"GAME_REVIVING");
	self thread check_for_failed_revive(playerbeingrevived);
	e_fx = spawn("script_model", playerbeingrevived.revivetrigger.origin);
	e_fx setmodel("tag_origin");
	e_fx thread revive_fx_clean_up_on_disconnect(playerbeingrevived);
	playfxontag(level._effect["afterlife_leave"], e_fx, "tag_origin");

	if (isdefined(playloop) && playloop)
		e_fx playloopsound("zmb_afterlife_reviving", 0.05);

	while (self is_reviving_afterlife(playerbeingrevived))
	{
		wait 0.05;
		timer += 0.05;

		if (self player_is_in_laststand())
			break;

		if (isdefined(playerbeingrevived.revivetrigger.auto_revive) && playerbeingrevived.revivetrigger.auto_revive == 1)
			break;

		if (timer >= revivetime)
		{
			revived = 1;
			break;
		}
	}

	e_fx delete();

	if (isDefined(playerbeingrevived_player.beingrevivedprogressbar))
	{
		playerbeingrevived_player.beingrevivedprogressbar destroyelem();
	}

	if (isDefined(playerbeingrevived_player.revive_hud))
	{
		playerbeingrevived_player.revive_hud.y = -160;

		if (!flag("wait_and_revive"))
		{
			playerbeingrevived_player.revive_hud settext("");
		}
	}

	if (isdefined(self.reviveprogressbar))
	{
		self.reviveprogressbar destroyelem();
	}

	if (isdefined(self.revivetexthud))
	{
		self.revivetexthud destroy();
	}

	if (isdefined(playerbeingrevived.revivetrigger.auto_revive) && playerbeingrevived.revivetrigger.auto_revive == 1)
	{

	}
	else if (!revived)
	{
		if (isplayer(playerbeingrevived))
			playerbeingrevived stoprevive(self);
	}

	playerbeingrevived.revivetrigger sethintstring(&"GAME_BUTTON_TO_REVIVE_PLAYER");
	playerbeingrevived.revivetrigger.beingrevived = 0;
	self notify("do_revive_ended_normally");
	self.is_reviving_any--;

	if (!revived)
		playerbeingrevived thread checkforbleedout(self);

	return revived;
}

afterlife_corpse_cleanup(corpse)
{
	playsoundatposition("zmb_afterlife_revived", corpse.origin);

	if (isdefined(corpse.revivetrigger))
	{
		corpse notify("stop_revive_trigger");
		corpse.revivetrigger delete();
		corpse.revivetrigger = undefined;
	}

	if (isdefined(corpse.collision))
	{
		corpse.collision delete();
		corpse.collision = undefined;
	}

	self.e_afterlife_corpse = undefined;
	corpse setclientfield("player_corpse_id", 0);
	corpse afterlife_corpse_remove_pois();
	corpse ghost();
	self.loadout = undefined;
	wait_network_frame();
	wait_network_frame();
	wait_network_frame();
	corpse delete();
}

afterlife_player_damage_callback(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	if (isdefined(eattacker))
	{
		if (isdefined(eattacker.is_zombie) && eattacker.is_zombie)
		{
			if (isdefined(eattacker.custom_damage_func))
				idamage = eattacker [[eattacker.custom_damage_func]](self);
			else if (isdefined(eattacker.meleedamage) && smeansofdeath != "MOD_GRENADE_SPLASH")
				idamage = eattacker.meleedamage;

			if (isdefined(self.afterlife) && self.afterlife)
			{
				self afterlife_reduce_mana(10);
				self clientnotify("al_d");
				return 0;
			}
		}
	}

	if (isdefined(self.afterlife) && self.afterlife)
		return 0;

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		return 0;

	if (isdefined(eattacker) && (isdefined(eattacker.is_zombie) && eattacker.is_zombie || isplayer(eattacker)))
	{
		if (isdefined(self.hasriotshield) && self.hasriotshield && isdefined(vdir))
		{
			item_dmg = 100;

			if (isdefined(eattacker.custom_item_dmg))
				item_dmg = eattacker.custom_item_dmg;

			if (isdefined(self.hasriotshieldequipped) && self.hasriotshieldequipped)
			{
				if (self player_shield_facing_attacker(vdir, 0.2) && isdefined(self.player_shield_apply_damage))
				{
					self [[self.player_shield_apply_damage]](item_dmg, 0);
					return 0;
				}
			}
			else if (!isdefined(self.riotshieldentity))
			{
				if (!self player_shield_facing_attacker(vdir, -0.2) && isdefined(self.player_shield_apply_damage))
				{
					self [[self.player_shield_apply_damage]](item_dmg, 0);
					return 0;
				}
			}
		}
	}

	if (sweapon == "tower_trap_zm" || sweapon == "tower_trap_upgraded_zm" || sweapon == "none" && shitloc == "riotshield" && !(isdefined(eattacker.is_zombie) && eattacker.is_zombie))
	{
		self.use_adjusted_grenade_damage = 1;
		return 0;
	}

	if (smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH")
	{
		if (sweapon == "blundersplat_explosive_dart_zm")
		{
			if (self hasperk("specialty_flakjacket"))
			{
				self.use_adjusted_grenade_damage = 1;
				idamage = 0;
			}

			if (isalive(self) && !(isdefined(self.is_zombie) && self.is_zombie))
			{
				self.use_adjusted_grenade_damage = 1;
				idamage = 15;
			}
		}
		else
		{
			if (self hasperk("specialty_flakjacket"))
				return 0;

			if (sweapon == "willy_pete_zm")
			{
				return 0;
			}

			if (self.health > 75 && !(isdefined(self.is_zombie) && self.is_zombie))
				idamage = 75;
		}
	}

	if (idamage >= self.health && (isdefined(level.intermission) && !level.intermission))
	{
		if (self.lives > 0 && (isdefined(self.afterlife) && !self.afterlife))
		{
			self playsoundtoplayer("zmb_afterlife_death", self);
			self afterlife_remove();
			self.afterlife = 1;
			self thread afterlife_laststand();

			return 0;
		}
		else
			self thread last_stand_conscience_vo();
	}

	return idamage;
}

afterlife_save_loadout()
{
	primaries = self getweaponslistprimaries();
	currentweapon = self getcurrentweapon();
	self.loadout = spawnstruct();
	self.loadout.player = self;
	self.loadout.weapons = [];
	self.loadout.score = self.score;
	self.loadout.current_weapon = 0;

	foreach (index, weapon in primaries)
	{
		self.loadout.weapons[index] = weapon;
		self.loadout.stockcount[index] = self getweaponammostock(weapon);
		self.loadout.clipcount[index] = self getweaponammoclip(weapon);

		if (weaponisdualwield(weapon))
		{
			weapon_dw = weapondualwieldweaponname(weapon);
			self.loadout.clipcount2[index] = self getweaponammoclip(weapon_dw);
		}

		weapon_alt = weaponaltweaponname(weapon);

		if (weapon_alt != "none")
		{
			self.loadout.stockcountalt[index] = self getweaponammostock(weapon_alt);
			self.loadout.clipcountalt[index] = self getweaponammoclip(weapon_alt);
		}

		if (weapon == currentweapon)
			self.loadout.current_weapon = index;
	}

	self.loadout.equipment = self get_player_equipment();

	if (isdefined(self.loadout.equipment))
		self equipment_take(self.loadout.equipment);

	if (self hasweapon("claymore_zm"))
	{
		self.loadout.hasclaymore = 1;
		self.loadout.claymoreclip = self getweaponammoclip("claymore_zm");
	}

	if (self hasweapon("bouncing_tomahawk_zm") || self hasweapon("upgraded_tomahawk_zm"))
	{
		self.loadout.hastomahawk = 1;
		self setclientfieldtoplayer("tomahawk_in_use", 0);
	}
	else if (self hasweapon("willy_pete_zm"))
	{
		self.loadout.hassmoke = 1;
		self.loadout.smokeclip = self getweaponammoclip("willy_pete_zm");
	}

	self.loadout.perks = afterlife_save_perks(self);
	lethal_grenade = self get_player_lethal_grenade();

	if (self hasweapon(lethal_grenade))
		self.loadout.grenade = self getweaponammoclip(lethal_grenade);
	else
		self.loadout.grenade = 0;

	self.loadout.lethal_grenade = lethal_grenade;
	self set_player_lethal_grenade(undefined);
}

afterlife_give_loadout()
{
	self takeallweapons();
	loadout = self.loadout;
	primaries = self getweaponslistprimaries();

	if (loadout.weapons.size > 1 || primaries.size > 1)
	{
		foreach (weapon in primaries)
			self takeweapon(weapon);
	}

	for (i = 0; i < loadout.weapons.size; i++)
	{
		if (!isdefined(loadout.weapons[i]))
			continue;

		if (loadout.weapons[i] == "none")
			continue;

		weapon = loadout.weapons[i];
		stock_amount = loadout.stockcount[i];
		clip_amount = loadout.clipcount[i];

		if (!self hasweapon(weapon))
		{
			self giveweapon(weapon, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(weapon));
			self setweaponammostock(weapon, stock_amount);
			self setweaponammoclip(weapon, clip_amount);

			if (weaponisdualwield(weapon))
			{
				weapon_dw = weapondualwieldweaponname(weapon);
				self setweaponammoclip(weapon_dw, loadout.clipcount2[i]);
			}

			weapon_alt = weaponaltweaponname(weapon);

			if (weapon_alt != "none")
			{
				self setweaponammostock(weapon_alt, loadout.stockcountalt[i]);
				self setweaponammoclip(weapon_alt, loadout.clipcountalt[i]);
			}
		}
	}

	self setspawnweapon(loadout.weapons[loadout.current_weapon]);
	self switchtoweaponimmediate(loadout.weapons[loadout.current_weapon]);

	if (isdefined(self get_player_melee_weapon()))
	{
		self giveweapon(self get_player_melee_weapon());
		self giveweapon("held_" + self get_player_melee_weapon());
		self setactionslot(2, "weapon", "held_" + self get_player_melee_weapon());
	}

	self.do_not_display_equipment_pickup_hint = 1;
	self maps\mp\zombies\_zm_equipment::equipment_give(self.loadout.equipment);
	self.do_not_display_equipment_pickup_hint = undefined;

	if (isdefined(loadout.hasclaymore) && loadout.hasclaymore && !self hasweapon("claymore_zm"))
	{
		self giveweapon("claymore_zm");
		self set_player_placeable_mine("claymore_zm");
		self setactionslot(4, "weapon", "claymore_zm");
		self setweaponammoclip("claymore_zm", loadout.claymoreclip);
	}

	if (isdefined(loadout.hastomahawk) && loadout.hastomahawk)
	{
		self giveweapon(self.current_tomahawk_weapon);
		self set_player_tactical_grenade(self.current_tomahawk_weapon);
		self setclientfieldtoplayer("tomahawk_in_use", 1);
	}
	else if (isdefined(loadout.hassmoke) && loadout.hassmoke)
	{
		self giveweapon("willy_pete_zm");
		self setweaponammoclip("willy_pete_zm", loadout.smokeclip);
	}

	self.score = loadout.score;
	perk_array = maps\mp\zombies\_zm_perks::get_perk_array(1);

	for (i = 0; i < perk_array.size; i++)
	{
		perk = perk_array[i];
		self unsetperk(perk);
		self set_perk_clientfield(perk, 0);
	}

	if (isdefined(self.keep_perks) && self.keep_perks && isdefined(loadout.perks) && loadout.perks.size > 0)
	{
		for (i = 0; i < loadout.perks.size; i++)
		{
			if (self hasperk(loadout.perks[i]))
				continue;

			if (loadout.perks[i] == "specialty_quickrevive" && flag("solo_game"))
				level.solo_game_free_player_quickrevive = 1;

			if (loadout.perks[i] == "specialty_finalstand")
				continue;

			maps\mp\zombies\_zm_perks::give_perk(loadout.perks[i]);
		}
	}

	self.keep_perks = undefined;
	self set_player_lethal_grenade(self.loadout.lethal_grenade);

	if (loadout.grenade > 0)
	{
		curgrenadecount = 0;

		if (self hasweapon(self get_player_lethal_grenade()))
			self getweaponammoclip(self get_player_lethal_grenade());
		else
			self giveweapon(self get_player_lethal_grenade());

		self setweaponammoclip(self get_player_lethal_grenade(), loadout.grenade + curgrenadecount);
	}
}