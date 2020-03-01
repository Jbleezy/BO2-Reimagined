#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
	level.inital_spawn = true;
	thread onplayerconnect();
}

onplayerconnect()
{
	while(true)
	{
		level waittill("connecting", player);
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "spawned_player" );

		if(level.inital_spawn)
		{
			level.inital_spawn = false;

			level thread post_all_players_spawned();
		}

		self set_movement_dvars();

		self set_player_lethal_grenade_semtex();

		self bank_clear_account_value();
		self weapon_locker_clear_stored_weapondata();

		self setperk( "specialty_unlimitedsprint" );

		self thread on_equipment_placed();
		self thread give_additional_perks();

		self thread electric_cherry_unlimited();

		self thread screecher_remove_hint();

		self thread jetgun_fast_cooldown();
		self thread jetgun_fast_spinlerp();
		self thread jetgun_overheated_fix();

		self thread vulture_disable_stink_while_standing();

		self thread tomb_give_shovel();

		//self thread test();

		//self.score = 1000000;
		//maps/mp/zombies/_zm_perks::give_perk( "specialty_armorvest", 0 );
		//self GiveWeapon("ray_gun_zm");
		//self GiveMaxAmmo("ray_gun_zm");
	}
}

post_all_players_spawned()
{
	flag_wait( "start_zombie_round_logic" );

	wait 0.05;

	disable_high_round_walkers();

	disable_perk_pause();
	enable_free_perks_before_power();

	disable_carpenter();

	disable_bank_teller();

	wallbuy_changes();

	zone_changes();

	enemies_ignore_equipments();

	screecher_spawner_changes();
	screecher_remove_near_miss();

	electric_trap_always_kill();

	jetgun_disable_explode_overheat();
	jetgun_remove_forced_weapon_switch();
	jetgun_remove_drop_fn();

	depot_remove_lava_collision();
	depot_grief_close_local_electric_doors();

	town_move_staminup_machine();

	slipgun_always_kill();
	slipgun_disable_reslip();

	buried_turn_power_on();

	borough_move_quickrevive_machine();
	borough_move_speedcola_machine();
	borough_move_staminup_machine();

	tomb_remove_weighted_random_perks();
	tomb_challenges_changes();
	tomb_soul_box_changes();

	//disable_pers_upgrades(); // TODO

	level thread buildbuildables();
	level thread buildcraftables();

	level thread zombie_health_fix();

	level thread transit_power_local_electric_doors_globally();

	level thread depot_grief_link_nodes();

	level thread prison_auto_refuel_plane();

	level thread buried_deleteslothbarricades();
	level thread buried_enable_fountain_transport();

	level thread tomb_remove_shovels_from_map();
	level thread tomb_zombie_blood_dig_changes();

	//level.round_number = 115;
	//level.zombie_move_speed = 105;
	//level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;

	//level.local_doors_stay_open = 1;
	//level.power_local_doors_globally = 1;
}

set_movement_dvars()
{
	setdvar( "player_backSpeedScale", 1 );
	setdvar( "player_strafeSpeedScale", 1 );
	setdvar( "player_sprintStrafeSpeedScale", 1 );
}

set_player_lethal_grenade_semtex()
{
	if (level.script != "zm_transit" && level.script != "zm_nuked" && level.script != "zm_highrise" && level.script != "zm_tomb")
	{
		return;
	}

	self takeweapon( self get_player_lethal_grenade() );
	self set_player_lethal_grenade( "sticky_grenade_zm" );
	self giveweapon( self get_player_lethal_grenade() );
	self setweaponammoclip( self get_player_lethal_grenade(), 0 );
}

disable_high_round_walkers()
{
	level.speed_change_round = undefined;
}

disable_bank_teller()
{
	/*
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(IsDefined(level._unitriggers.trigger_stubs[i].targetname))
		{
			if(level._unitriggers.trigger_stubs[i].targetname == "bank_deposit" || level._unitriggers.trigger_stubs[i].targetname == "bank_withdraw")
			{
				maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( level._unitriggers.trigger_stubs[i] );
			}
		}
	}
	*/

	level notify( "stop_bank_teller" );
	bank_teller_dmg_trig = getent( "bank_teller_tazer_trig", "targetname" );
	if(IsDefined(bank_teller_dmg_trig))
	{
		bank_teller_transfer_trig = getent( bank_teller_dmg_trig.target, "targetname" );
		bank_teller_dmg_trig delete();
		bank_teller_transfer_trig delete();
	}
}

bank_clear_account_value()
{
	self.account_value = 0;
	self maps/mp/zombies/_zm_stats::set_map_stat( "depositBox", player.account_value, level.banking_map );
}

disable_weapon_locker()
{
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(IsDefined(level._unitriggers.trigger_stubs[i].targetname))
		{
			if(level._unitriggers.trigger_stubs[i].targetname == "weapon_locker")
			{
				maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( level._unitriggers.trigger_stubs[i] );
			}
		}
	}
}

weapon_locker_clear_stored_weapondata()
{
	if ( level.weapon_locker_online )
	{
		self maps/mp/zombies/_zm_stats::clear_stored_weapondata( level.weapon_locker_map );
	}
	else
	{
		self.stored_weapon_data = undefined;
	}
}

disable_pers_upgrades()
{
	level.pers_upgrades_keys = [];
	level.pers_upgrades = [];
}

disable_carpenter()
{
	arrayremoveindex(level.zombie_include_powerups, "carpenter");
	arrayremoveindex(level.zombie_powerups, "carpenter");
	arrayremovevalue(level.zombie_powerup_array, "carpenter");
}

wallbuy_changes()
{
	if(!is_classic())
	{
		if(level.scr_zm_map_start_location == "farm")
		{
			if(level.scr_zm_ui_gametype == "zstandard")
			{
				remove_wallbuy("tazer_knuckles_zm");
			}

			add_wallbuy("claymore_zm");
		}
	}
}

remove_wallbuy( name )
{
	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(IsDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade) && level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade == name)
		{
			maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( level._unitriggers.trigger_stubs[i] );
		}
	}
}

add_wallbuy( name )
{
	struct = undefined;
	spawnable_weapon_spawns = getstructarray( "weapon_upgrade", "targetname" );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "bowie_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "sickle_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "tazer_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "buildable_wallbuy", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "claymore_purchase", "targetname" ), 1, 0 );
	for(i = 0; i < spawnable_weapon_spawns.size; i++)
	{
		if(IsDefined(spawnable_weapon_spawns[i].zombie_weapon_upgrade) && spawnable_weapon_spawns[i].zombie_weapon_upgrade == name)
		{
			struct = spawnable_weapon_spawns[i];
			break;
		}
	}

	if(!IsDefined(struct))
	{
		return;
	}

	target_struct = getstruct( struct.target, "targetname" );
	tempmodel = spawn( "script_model", ( 0, 0, 0 ) );
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = struct.origin;
	unitrigger_stub.angles = struct.angles;

	tempmodel setmodel( target_struct.model );
	tempmodel useweaponhidetags( struct.zombie_weapon_upgrade );
	mins = tempmodel getmins();
	maxs = tempmodel getmaxs();
	absmins = tempmodel getabsmins();
	absmaxs = tempmodel getabsmaxs();
	bounds = absmaxs - absmins;
	unitrigger_stub.script_length = bounds[ 0 ] * 0.25;
	unitrigger_stub.script_width = bounds[ 1 ];
	unitrigger_stub.script_height = bounds[ 2 ];

	unitrigger_stub.origin -= anglesToRight( unitrigger_stub.angles ) * ( unitrigger_stub.script_length * 0.4 );
	unitrigger_stub.target = struct.target;
	unitrigger_stub.targetname = struct.targetname;
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	if ( struct.targetname == "weapon_upgrade" )
	{
		unitrigger_stub.cost = maps/mp/zombies/_zm_weapons::get_weapon_cost( struct.zombie_weapon_upgrade );
		if ( isDefined( level.monolingustic_prompt_format ) && !level.monolingustic_prompt_format )
		{
			unitrigger_stub.hint_string = maps/mp/zombies/_zm_weapons::get_weapon_hint( struct.zombie_weapon_upgrade );
			unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
			return;
		}
		else
		{
			unitrigger_stub.hint_parm1 = maps/mp/zombies/_zm_weapons::get_weapon_display_name( struct.zombie_weapon_upgrade );
			if ( isDefined( unitrigger_stub.hint_parm1 ) || unitrigger_stub.hint_parm1 == "" && unitrigger_stub.hint_parm1 == "none" )
			{
				unitrigger_stub.hint_parm1 = "missing weapon name " + struct.zombie_weapon_upgrade;
			}
			unitrigger_stub.hint_parm2 = unitrigger_stub.cost;
			unitrigger_stub.hint_string = &"ZOMBIE_WEAPONCOSTONLY";
		}
	}
	unitrigger_stub.weapon_upgrade = struct.zombie_weapon_upgrade;
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = 1;
	if ( isDefined( struct.require_look_from ) && struct.require_look_from )
	{
		unitrigger_stub.require_look_from = 1;
	}
	unitrigger_stub.zombie_weapon_upgrade = struct.zombie_weapon_upgrade;

	//unitrigger_stub.clientfieldname = clientfieldname;
	unitrigger_stub.clientfieldname = undefined;
	model = spawn( "script_model", struct.origin );
	//model.angles = struct.angles;
	model.angles = struct.angles + (0, 90, 0);
	//model.targetname = struct.target;
	model setmodel( target_struct.model );
	model useweaponhidetags( struct.zombie_weapon_upgrade );
	//model hide();

	maps/mp/zombies/_zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, 1 );
	if ( is_melee_weapon( unitrigger_stub.zombie_weapon_upgrade ) )
	{
		if ( unitrigger_stub.zombie_weapon_upgrade == "tazer_knuckles_zm" && isDefined( level.taser_trig_adjustment ) )
		{
			unitrigger_stub.origin += level.taser_trig_adjustment;
		}
		maps/mp/zombies/_zm_unitrigger::register_static_unitrigger( unitrigger_stub, maps/mp/zombies/_zm_weapons::weapon_spawn_think );
	}
	else if ( unitrigger_stub.zombie_weapon_upgrade == "claymore_zm" )
	{
		unitrigger_stub.prompt_and_visibility_func = maps/mp/zombies/_zm_weap_claymore::claymore_unitrigger_update_prompt;
		maps/mp/zombies/_zm_unitrigger::register_static_unitrigger( unitrigger_stub, maps/mp/zombies/_zm_weap_claymore::buy_claymores );
		//model thread claymore_rotate_model_when_bought();
	}
	else
	{
		unitrigger_stub.prompt_and_visibility_func = maps/mp/zombies/_zm_weapons::wall_weapon_update_prompt;
		maps/mp/zombies/_zm_unitrigger::register_static_unitrigger( unitrigger_stub, maps/mp/zombies/_zm_weapons::weapon_spawn_think );
	}
	struct.trigger_stub = unitrigger_stub;
}

claymore_rotate_model_when_bought()
{
	og_origin = self.origin;

	while (og_origin == self.origin)
	{
		wait 0.05;
	}

	self.angles += ( 0, 90, 0 );
}

disable_perk_pause()
{
	for (i = 0; i < level.powered_items.size; i++)
	{
		item = level.powered_items[i];

		if (IsDefined(item.target) && IsDefined(item.target.targetname) && item.target.targetname == "zombie_vending")
		{
			item.power_off_func = ::perk_power_off;
		}
	}
}

perk_power_off( origin, radius )
{
	notify_name = self.target maps/mp/zombies/_zm_perks::getvendingmachinenotify();
	if ( isDefined( notify_name ) && notify_name == "revive" )
	{
		if ( level flag_exists( "solo_game" ) && flag( "solo_game" ) )
		{
			return;
		}
	}

	self.target notify( "death" );
	self.target thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	if ( isDefined( self.target.perk_hum ) )
	{
		self.target.perk_hum delete();
	}
	//maps/mp/zombies/_zm_perks::perk_pause( self.target.script_noteworthy );
	level notify( self.target maps/mp/zombies/_zm_perks::getvendingmachinenotify() + "_off" );
}

enable_free_perks_before_power()
{
	level.disable_free_perks_before_power = undefined;
}

buildbuildables()
{
	// need a wait or else some buildables dont build
	wait 1;

	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "transit")
		{
			buildbuildable( "powerswitch" );
			buildbuildable( "pap" );
			buildbuildable( "turbine" );
			buildbuildable( "electric_trap" );
			buildbuildable( "turret" ); // TODO - fix turret loop sound not going away when picked up
			buildbuildable( "riotshield_zm" );
			buildbuildable( "jetgun_zm" );
			buildbuildable( "sq_common" );

			// power switch is not showing up from forced build
			show_powerswitch();
		}
		else if(level.scr_zm_map_start_location == "rooftop")
		{
			buildbuildable( "slipgun_zm" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "sq_common" );
		}
		else if(level.scr_zm_map_start_location == "processing")
		{
			level waittill( "buildables_setup" ); // wait for buildables to randomize
			wait 0.05;

			removebuildable( "keys_zm" );
			removebuildable( "turbine" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "subwoofer_zm" );
			buildbuildable( "headchopper_zm" );
			buildbuildable( "sq_common" );
		}
	}
	else
	{
		if(level.scr_zm_map_start_location == "street")
		{
			flag_wait( "initial_blackscreen_passed" ); // wait for buildables to be built
			wait 1;

			removebuildableafterbuilt( "turbine" );
		}
	}
}

buildbuildable( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.buildable_stubs)
	{
		if ( !isDefined( buildable ) || stub.equipname == buildable )
		{
			if ( isDefined( buildable ) || stub.persistent != 3 )
			{
				stub maps/mp/zombies/_zm_buildables::buildablestub_finish_build( player );
				stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
				foreach (piece in stub.buildablezone.pieces)
				{
					piece maps/mp/zombies/_zm_buildables::piece_unspawn();
				}
				stub.model notsolid();
				stub.model show();
				return;
			}
		}
	}
}

removebuildable( buildable )
{
	foreach (stub in level.buildable_stubs)
	{
		if ( !isDefined( buildable ) || stub.equipname == buildable )
		{
			if ( isDefined( buildable ) || stub.persistent != 3 )
			{
				stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
				foreach (piece in stub.buildablezone.pieces)
				{
					piece maps/mp/zombies/_zm_buildables::piece_unspawn();
				}
				maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( stub );
				return;
			}
		}
	}
}

removebuildableafterbuilt( buildable )
{
	foreach (stub in level._unitriggers.trigger_stubs)
	{
		if(IsDefined(stub.equipname) && stub.equipname == buildable)
		{
			stub.model hide();
			maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( stub );
			return;
		}
	}
}

// MOTD/Origins style buildables
buildcraftables()
{
	// need a wait or else some buildables dont build
	wait 1;

	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "prison")
		{
			buildcraftable( "alcatraz_shield_zm" );
			buildcraftable( "packasplat" );
		}
		else if(level.scr_zm_map_start_location == "tomb")
		{
			buildcraftable( "tomb_shield_zm" );
			buildcraftable( "equip_dieseldrone_zm" );
			takecraftableparts( "gramophone" );
		}
	}
}

takecraftableparts( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.zombie_include_craftables)
	{
		if ( stub.name == buildable )
		{
			foreach (piece in stub.a_piecestubs)
			{
				piecespawn = piece.piecespawn;
				if ( isDefined( piecespawn ) )
				{
					player player_take_piece( piecespawn );
				}
			}

			return;
		}
	}
}

buildcraftable( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.a_uts_craftables)
	{
		if ( stub.craftablestub.name == buildable )
		{
			foreach (piece in stub.craftablespawn.a_piecespawns)
			{
				piecespawn = get_craftable_piece( stub.craftablestub.name, piece.piecename );
				if ( isDefined( piecespawn ) )
				{
					player player_take_piece( piecespawn );
				}
			}

			return;
		}
	}
}

get_craftable_piece( str_craftable, str_piece )
{
	foreach (uts_craftable in level.a_uts_craftables)
	{
		if ( uts_craftable.craftablestub.name == str_craftable )
		{
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
			{
				if ( piecespawn.piecename == str_piece )
				{
					return piecespawn;
				}
			}
		}
	}
	return undefined;
}

player_take_piece( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
	{
		piecespawn [[ piecestub.onpickup ]]( self );
	}

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
	{
		if ( isDefined( piecestub.client_field_id ) )
		{
			level setclientfield( piecestub.client_field_id, 1 );
		}
	}
	else
	{
		if ( isDefined( piecestub.client_field_state ) )
		{
			self setclientfieldtoplayer( "craftable", piecestub.client_field_state );
		}
	}

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
	{
		piecespawn.in_shared_inventory = 1;
	}

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

piece_unspawn()
{
	if ( isDefined( self.model ) )
	{
		self.model delete();
	}
	self.model = undefined;
	if ( isDefined( self.unitrigger ) )
	{
		thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.unitrigger );
	}
	self.unitrigger = undefined;
}

remove_buildable_pieces( buildable_name )
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == buildable_name)
		{
			pieces = buildable.buildablepieces;
			for(i = 0; i < pieces.size; i++)
			{
				pieces[i] maps/mp/zombies/_zm_buildables::piece_unspawn();
			}
			return;
		}
	}
}

enemies_ignore_equipments()
{
	equipment = getFirstArrayKey(level.zombie_include_equipment);
	while (isDefined(equipment))
	{
		maps/mp/zombies/_zm_equipment::enemies_ignore_equipment(equipment);
		equipment = getNextArrayKey(level.zombie_include_equipment, equipment);
	}
}

electric_trap_always_kill()
{
	level.etrap_damage = maps/mp/zombies/_zm::ai_zombie_health( 255 );
}

jetgun_increase_grind_range()
{
	level.zombies_vars["jetgun_grind_range"] = 256;
}

jetgun_fast_cooldown()
{
	self endon( "death_or_disconnect" );

	if ( !maps/mp/zombies/_zm_weapons::is_weapon_included( "jetgun_zm" ) )
	{
		return;
	}

	while ( 1 )
	{
		if (!IsDefined(self.jetgun_heatval))
		{
			wait 0.05;
			continue;
		}

		if ( self getcurrentweapon() == "jetgun_zm" )
		{
			if (self AttackButtonPressed())
			{
				if (self IsMeleeing())
				{
					self.jetgun_heatval += .875; // have to add .025 if holding weapon

					if (self.jetgun_heatval > 100)
					{
						self.jetgun_heatval = 100;
					}

					self setweaponoverheating( self.jetgun_overheating, self.jetgun_heatval );
				}
			}
			else
			{
				self.jetgun_heatval -= .075; // have to add .025 if holding weapon

				if (self.jetgun_heatval < 0)
				{
					self.jetgun_heatval = 0;
				}

				self setweaponoverheating( self.jetgun_overheating, self.jetgun_heatval );
			}
		}
		else
		{
			self.jetgun_heatval -= .1;

			if (self.jetgun_heatval < 0)
			{
				self.jetgun_heatval = 0;
			}
		}

		wait 0.05;
	}
}

jetgun_fast_spinlerp()
{
	self endon( "death_or_disconnect" );

	if ( !maps/mp/zombies/_zm_weapons::is_weapon_included( "jetgun_zm" ) )
	{
		return;
	}

	previous_spinlerp = 0;

	while ( 1 )
	{
		if ( self getcurrentweapon() == "jetgun_zm" )
		{
			if (self AttackButtonPressed() && !self IsSwitchingWeapons())
			{
				previous_spinlerp -= 0.0166667;
				if (previous_spinlerp < -1)
				{
					previous_spinlerp = -1;
				}

				if (self IsMeleeing())
				{
					self setcurrentweaponspinlerp(previous_spinlerp / 2);
				}
				else
				{
					self setcurrentweaponspinlerp(previous_spinlerp);
				}
			}
			else
			{
				previous_spinlerp += 0.01;
				if (previous_spinlerp > 0)
				{
					previous_spinlerp = 0;
				}
				self setcurrentweaponspinlerp(0);
			}
		}
		else
		{
			previous_spinlerp = 0;
		}

		wait 0.05;
	}
}

jetgun_disable_explode_overheat()
{
	level.explode_overheated_jetgun = false;
	level.unbuild_overheated_jetgun = false;
	level.take_overheated_jetgun = true;
}

jetgun_overheated_fix()
{
	self endon( "disconnect" );

	if ( !maps/mp/zombies/_zm_weapons::is_weapon_included( "jetgun_zm" ) )
	{
		return;
	}

	while ( 1 )
	{
		self waittill( "jetgun_overheated" );

		weapon_org = self gettagorigin( "tag_weapon" );
		self dodamage( 50, weapon_org );
		self playsound( "wpn_jetgun_explo" );

		wait 0.05;

		self.jetgun_heatval = 100;
		self.jetgun_overheating = 0;
	}
}

jetgun_remove_forced_weapon_switch()
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == "jetgun_zm")
		{
			buildable.onbuyweapon = undefined;
			return;
		}
	}
}

jetgun_remove_drop_fn()
{
	level.zombie_equipment["jetgun_zm"].drop_fn = undefined;
}

slipgun_always_kill()
{
	level.slipgun_damage = maps/mp/zombies/_zm::ai_zombie_health( 255 );
}

slipgun_disable_reslip()
{
	level.zombie_vars["slipgun_reslip_rate"] = 0;
}

on_equipment_placed()
{
	self endon( "death" );
	self endon( "disconnect" );

	//level.equipment_etrap_needs_power = 0;
	//level.equipment_turret_needs_power = 0;
	//level.equipment_subwoofer_needs_power = 0;

	for ( ;; )
	{
		self waittill( "equipment_placed", weapon, weapname );

		if ( (IsDefined(level.turret_name) && weapname == level.turret_name) || (IsDefined(level.electrictrap_name) && weapname == level.electrictrap_name) || (IsDefined(level.subwoofer_name) && weapname == level.subwoofer_name) )
		{
			weapon.local_power = maps/mp/zombies/_zm_power::add_local_power( weapon.origin, 16 );

			weapon thread remove_local_power_on_death(weapon.local_power);

			if ( IsDefined(level.turret_name) && weapname == level.turret_name )
			{
				self thread turret_decay(weapon);

				self thread turret_disable_team_damage(weapon);
			}
			else if ( IsDefined(level.electrictrap_name) && weapname == level.electrictrap_name )
			{
				self thread electrictrap_decay(weapon);
			}
		}
	}
}

remove_local_power_on_death( local_power )
{
	while ( isDefined(self) )
	{
		wait 0.05;
	}

	maps/mp/zombies/_zm_power::end_local_power( local_power );
}

turret_disable_team_damage( weapon )
{
	self endon ( "death" );
	weapon endon( "death" );

	while ( !IsDefined( weapon.turret ) )
	{
		wait 0.05;
	}

	weapon.turret.damage_own_team = 0;
}

turret_decay( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( !isDefined( self.turret_health ) )
	{
		self.turret_health = 60;
	}

	while ( isDefined( weapon ) )
	{
		if ( weapon.power_on )
		{
			self.turret_health--;

			if ( self.turret_health <= 0 )
			{
				self thread turret_expired( weapon );
				return;
			}
		}
		wait 1;
	}
}

turret_expired( weapon )
{
	maps/mp/zombies/_zm_equipment::equipment_disappear_fx( weapon.origin );
	self cleanupoldturret();
	self maps/mp/zombies/_zm_equipment::equipment_release( level.turret_name );
	self.turret_health = undefined;
}

cleanupoldturret()
{
	if ( isDefined( self.buildableturret ) )
	{
		if ( isDefined( self.buildableturret.stub ) )
		{
			thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.buildableturret.stub );
			self.buildableturret.stub = undefined;
		}
		if ( isDefined( self.buildableturret.turret ) )
		{
			if ( isDefined( self.buildableturret.turret.sound_ent ) )
			{
				self.buildableturret.turret.sound_ent delete();
			}
			self.buildableturret.turret delete();
		}
		if ( isDefined( self.buildableturret.sound_ent ) )
		{
			self.buildableturret.sound_ent delete();
			self.buildableturret.sound_ent = undefined;
		}
		self.buildableturret delete();
		self.turret_health = undefined;
	}
	else
	{
		if ( isDefined( self.turret ) )
		{
			self.turret notify( "stop_burst_fire_unmanned" );
			self.turret delete();
		}
	}
	self.turret = undefined;
	self notify( "turret_cleanup" );
}

electrictrap_decay( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( !isDefined( self.electrictrap_health ) )
	{
		self.electrictrap_health = 60;
	}

	while ( isDefined( weapon ) )
	{
		if ( weapon.power_on )
		{
			self.electrictrap_health--;

			if ( self.electrictrap_health <= 0 )
			{
				self thread electrictrap_expired( weapon );
				return;
			}
		}
		wait 1;
	}
}

electrictrap_expired( weapon )
{
	maps/mp/zombies/_zm_equipment::equipment_disappear_fx( weapon.origin );
	self cleanupoldtrap();
	self maps/mp/zombies/_zm_equipment::equipment_release( level.electrictrap_name );
	self.electrictrap_health = undefined;
}

cleanupoldtrap()
{
	if ( isDefined( self.buildableelectrictrap ) )
	{
		if ( isDefined( self.buildableelectrictrap.stub ) )
		{
			thread maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( self.buildableelectrictrap.stub );
			self.buildableelectrictrap.stub = undefined;
		}
		self.buildableelectrictrap delete();
	}
	if ( isDefined( level.electrap_sound_ent ) )
	{
		level.electrap_sound_ent delete();
		level.electrap_sound_ent = undefined;
	}
}

give_additional_perks()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill_any("perk_acquired", "perk_lost");

		if (self HasPerk("specialty_fastreload"))
		{
			self SetPerk("specialty_fastads");
			self SetPerk("specialty_fastweaponswitch");
			self Setperk( "specialty_fasttoss" );
		}
		else
		{
			self UnsetPerk("specialty_fastads");
			self UnsetPerk("specialty_fastweaponswitch");
			self Unsetperk( "specialty_fasttoss" );
		}

		if (self HasPerk("specialty_deadshot"))
		{
			self SetPerk("specialty_stalker");
			self Setperk( "specialty_sprintrecovery" );
		}
		else
		{
			self UnsetPerk("specialty_stalker");
			self Unsetperk( "specialty_sprintrecovery" );
		}

		if (self HasPerk("specialty_longersprint"))
		{
			self Setperk( "specialty_movefaster" );
		}
		else
		{
			self Unsetperk( "specialty_movefaster" );
		}
	}
}

electric_cherry_unlimited()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		self.consecutive_electric_cherry_attacks = 0;

		wait 0.5;
	}
}

zombie_health_fix()
{
	for ( ;; )
	{
		level waittill( "start_of_round" );

		wait 0.05;

		if(level.zombie_health > 1000000)
		{
			level.zombie_health = 1000000;
		}
	}
}

show_powerswitch()
{
	getent( "powerswitch_p6_zm_buildable_pswitch_hand", "targetname" ) show();
	getent( "powerswitch_p6_zm_buildable_pswitch_body", "targetname" ) show();
	getent( "powerswitch_p6_zm_buildable_pswitch_lever", "targetname" ) show();
}

zone_changes()
{
	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "rooftop")
		{
			// AN94 to Debris
			level.zones[ "zone_orange_level3a" ].adjacent_zones[ "zone_orange_level3b" ].is_connected = 0;

			// Trample Steam to Skyscraper
			level.zones[ "zone_green_level3b" ].adjacent_zones[ "zone_blue_level1c" ] structdelete();
			level.zones[ "zone_green_level3b" ].adjacent_zones[ "zone_blue_level1c" ] = undefined;
		}
	}
	else
	{
		if(level.scr_zm_map_start_location == "farm")
		{
			// Barn to Farm
			flag_set("OnFarm_enter");
		}
	}
}

screecher_remove_hint()
{
	self.screecher_seen_hint = 1;
}

screecher_remove_near_miss()
{
	level.near_miss = 2;
}

screecher_spawner_changes()
{
	level.screecher_spawners = getentarray( "screecher_zombie_spawner", "script_noteworthy" );
	array_thread( level.screecher_spawners, ::add_spawn_function, ::screecher_prespawn_decrease_health );
}

screecher_prespawn_decrease_health()
{
	self.player_score = 12;
}

transit_power_local_electric_doors_globally()
{
	if( !(is_classic() && level.scr_zm_map_start_location == "transit") )
	{
		return;	
	}

	local_power = [];

	for ( ;; )
	{
		flag_wait( "power_on" );

		zombie_doors = getentarray( "zombie_door", "targetname" );
		for ( i = 0; i < zombie_doors.size; i++ )
		{
			if ( isDefined( zombie_doors[i].script_noteworthy ) && zombie_doors[i].script_noteworthy == "local_electric_door" )
			{
				local_power[local_power.size] = maps/mp/zombies/_zm_power::add_local_power( zombie_doors[i].origin, 16 );
			}
		}

		flag_waitopen( "power_on" );

		for (i = 0; i < local_power.size; i++)
		{
			maps/mp/zombies/_zm_power::end_local_power( local_power[i] );
			local_power[i] = undefined;
		}
		local_power = [];
	}
}

depot_remove_lava_collision()
{
	if(!(!is_classic() && level.scr_zm_map_start_location == "transit"))
	{
		return;
	}

	ents = getEntArray( "script_model", "classname");
	foreach (ent in ents)
	{
		if (IsDefined(ent.model))
		{
			if (ent.model == "zm_collision_transit_busdepot_survival")
			{
				ent delete();
			}
			else if (ent.model == "veh_t6_civ_smallwagon_dead" && ent.origin[0] == -6663.96 && ent.origin[1] == 4816.34)
			{
				ent delete();
			}
			else if (ent.model == "veh_t6_civ_microbus_dead" && ent.origin[0] == -6807.05 && ent.origin[1] == 4765.23)
			{
				ent delete();
			}
			else if (ent.model == "veh_t6_civ_movingtrk_cab_dead" && ent.origin[0] == -6652.9 && ent.origin[1] == 4767.7)
			{
				ent delete();
			}
			else if (ent.model == "p6_zm_rocks_small_cluster_01")
			{
				ent delete();
			}
		}
	}

	// spawn in new map edge collisions
	// the lava collision and the map edge collisions are all the same entity
	collision1 = spawn( "script_model", ( -5898, 4653, 0 ) );
	collision1.angles = (0, 55, 0);
	collision1 setmodel( "collision_wall_512x512x10_standard" );
	collision2 = spawn( "script_model", ( -8062, 4700, 0 ) );
	collision2.angles = (0, 70, 0);
	collision2 setmodel( "collision_wall_512x512x10_standard" );
	collision3 = spawn( "script_model", ( -7881, 5200, 0 ) );
	collision3.angles = (0, 70, 0);
	collision3 setmodel( "collision_wall_512x512x10_standard" );
}

depot_grief_close_local_electric_doors()
{
	if(!(level.scr_zm_ui_gametype == "zgrief" && level.scr_zm_map_start_location == "transit"))
	{
		return;
	}

	zombie_doors = getentarray( "zombie_door", "targetname" );
	foreach (door in zombie_doors)
	{
		if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
		{
			door delete();
		}
	}
}

depot_grief_link_nodes()
{
	if(!(level.scr_zm_ui_gametype == "zgrief" && level.scr_zm_map_start_location == "transit"))
	{
		return;
	}

	flag_wait( "initial_blackscreen_passed" );
	wait 0.05;

	nodes = getnodearray( "classic_only_traversal", "targetname" );
	foreach (node in nodes)
	{
		link_nodes( node, getnode( node.target, "targetname" ) );
	}
}

town_move_staminup_machine()
{
	if (!(!is_classic() && level.scr_zm_map_start_location == "town"))
	{
		return;	
	}

	perk_struct = undefined;
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach (struct in structs)
	{
		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_longersprint" && IsSubStr(struct.script_string, "zclassic"))
			{
				perk_struct = struct;
				break;
			}
		}
	}

	if(!IsDefined(perk_struct))
	{
		return;
	}

	// delete old machine
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	for (i = 0; i < vending_trigger.size; i++)
	{
		trig = vending_triggers[i];
		if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_longersprint")
		{
			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
			trig delete();
			break;
		}
	}

	// spawn new machine
	use_trigger = spawn( "trigger_radius_use", perk_struct.origin + vectorScale( ( 0, 0, 1 ), 30 ), 0, 40, 70 );
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = perk_struct.script_noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn( "script_model", perk_struct.origin );
	perk_machine.angles = perk_struct.angles;
	perk_machine setmodel( perk_struct.model );
	bump_trigger = spawn( "trigger_radius", perk_struct.origin + AnglesToRight(perk_struct.angles) * 32, 0, 35, 32 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn( "script_model", perk_struct.origin, 1 );
	collision.angles = perk_struct.angles;
	collision setmodel( "zm_collision_perks1" );
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if ( isDefined( perk_struct.blocker_model ) )
	{
		use_trigger.blocker_model = perk_struct.blocker_model;
	}
	if ( isDefined( perk_struct.script_int ) )
	{
		perk_machine.script_int = perk_struct.script_int;
	}
	if ( isDefined( perk_struct.turn_on_notify ) )
	{
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}
	use_trigger.script_sound = "mus_perks_stamin_jingle";
	use_trigger.script_string = "marathon_perk";
	use_trigger.script_label = "mus_perks_stamin_sting";
	use_trigger.target = "vending_marathon";
	perk_machine.script_string = "marathon_perk";
	perk_machine.targetname = "vending_marathon";
	bump_trigger.script_string = "marathon_perk";

	level thread maps/mp/zombies/_zm_perks::turn_marathon_on();
	use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();
}

prison_auto_refuel_plane()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	for ( ;; )
	{
		flag_wait( "spawn_fuel_tanks" );

		wait 0.05;

		buildcraftable( "refuelable_plane" );
	}
}

buried_turn_power_on()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	trigger = getent( "use_elec_switch", "targetname" );
	if ( isDefined( trigger ) )
	{
		trigger delete();
	}
	master_switch = getent( "elec_switch", "targetname" );
	if ( isDefined( master_switch ) )
	{
		master_switch notsolid();
		master_switch rotateroll( -90, 0.3 );
		clientnotify( "power_on" );
		flag_set( "power_on" );
	}
}

buried_deleteslothbarricades()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	sloth_trigs = getentarray( "sloth_barricade", "targetname" );
	foreach (trig in sloth_trigs)
	{
		if ( isDefined( trig.script_flag ) && level flag_exists( trig.script_flag ) )
		{
			flag_set( trig.script_flag );
		}
		parts = getentarray( trig.target, "targetname" );
		array_thread( parts, ::self_delete );
	}

	array_thread( sloth_trigs, ::self_delete );
}

buried_enable_fountain_transport()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	flag_wait( "initial_blackscreen_passed" );

	wait 1;

	level notify( "courtyard_fountain_open" );
}

vulture_disable_stink_while_standing()
{
	self endon( "disconnect" );

	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	while(!isDefined(self.perk_vulture))
	{
		wait 0.05;
	}

	while(1)
	{
		if (!self.perk_vulture.active)
		{
			wait 0.05;
			continue;
		}

		self.perk_vulture.is_in_zombie_stink = 1;
		self.perk_vulture.stink_time_entered = undefined;

		b_player_in_zombie_stink = 0;
		a_close_points = arraysort( level.perk_vulture.zombie_stink_array, self.origin, 1, 300 );
		if ( a_close_points.size > 0 )
		{
			b_player_in_zombie_stink = self _is_player_in_zombie_stink( a_close_points );
		}

		if (b_player_in_zombie_stink)
		{
			vel = self GetVelocity();
			magnitude = sqrt((vel[0] * vel[0]) + (vel[1] * vel[1]) + (vel[2] * vel[2]));
			if (magnitude < 125)
			{
				self.perk_vulture.is_in_zombie_stink = 0;

				wait 0.25;

				while (self.vulture_stink_value > 0)
				{
					wait 0.05;
				}
			}
		}

		wait 0.05;
	}
}

_is_player_in_zombie_stink( a_points )
{
	b_is_in_stink = 0;
	i = 0;
	while ( i < a_points.size )
	{
		if ( distancesquared( a_points[ i ].origin, self.origin ) < 4900 )
		{
			b_is_in_stink = 1;
		}
		i++;
	}
	return b_is_in_stink;
}

borough_move_quickrevive_machine()
{
	if (!(!is_classic() && level.scr_zm_map_start_location == "street"))
	{
		return;	
	}

	perk_struct = undefined;
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach (struct in structs)
	{
		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_quickrevive" && IsSubStr(struct.script_string, "zclassic"))
			{
				perk_struct = struct;
				break;
			}
		}
	}

	if(!IsDefined(perk_struct))
	{
		return;
	}

	// delete old machine
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	for (i = 0; i < vending_trigger.size; i++)
	{
		trig = vending_triggers[i];
		if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_quickrevive")
		{
			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
			trig delete();
			break;
		}
	}

	// spawn new machine
	use_trigger = spawn( "trigger_radius_use", perk_struct.origin + vectorScale( ( 0, 0, 1 ), 30 ), 0, 40, 70 );
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = perk_struct.script_noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn( "script_model", perk_struct.origin );
	perk_machine.angles = perk_struct.angles;
	perk_machine setmodel( perk_struct.model );
	bump_trigger = spawn( "trigger_radius", perk_struct.origin + AnglesToRight(perk_struct.angles) * 32, 0, 35, 32 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn( "script_model", perk_struct.origin, 1 );
	collision.angles = perk_struct.angles;
	collision setmodel( "zm_collision_perks1" );
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if ( isDefined( perk_struct.blocker_model ) )
	{
		use_trigger.blocker_model = perk_struct.blocker_model;
	}
	if ( isDefined( perk_struct.script_int ) )
	{
		perk_machine.script_int = perk_struct.script_int;
	}
	if ( isDefined( perk_struct.turn_on_notify ) )
	{
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}

	use_trigger.script_sound = "mus_perks_revive_jingle";
	use_trigger.script_string = "revive_perk";
	use_trigger.script_label = "mus_perks_revive_sting";
	use_trigger.target = "vending_revive";
	perk_machine.script_string = "revive_perk";
	perk_machine.targetname = "vending_revive";
	bump_trigger.script_string = "revive_perk";

	level thread maps/mp/zombies/_zm_perks::turn_revive_on();
	use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();
}

borough_move_speedcola_machine()
{
	if (!(!is_classic() && level.scr_zm_map_start_location == "street"))
	{
		return;	
	}

	perk_struct = undefined;
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach (struct in structs)
	{
		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_fastreload" && IsSubStr(struct.script_string, "zclassic"))
			{
				perk_struct = struct;
				break;
			}
		}
	}

	if(!IsDefined(perk_struct))
	{
		return;
	}

	// delete old machine
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	for (i = 0; i < vending_trigger.size; i++)
	{
		trig = vending_triggers[i];
		if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_fastreload")
		{
			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
			trig delete();
			break;
		}
	}

	// spawn new machine
	use_trigger = spawn( "trigger_radius_use", perk_struct.origin + vectorScale( ( 0, 0, 1 ), 30 ), 0, 40, 70 );
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = perk_struct.script_noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn( "script_model", perk_struct.origin );
	perk_machine.angles = perk_struct.angles;
	perk_machine setmodel( perk_struct.model );
	bump_trigger = spawn( "trigger_radius", perk_struct.origin + AnglesToRight(perk_struct.angles) * 32, 0, 35, 32 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn( "script_model", perk_struct.origin, 1 );
	collision.angles = perk_struct.angles;
	collision setmodel( "zm_collision_perks1" );
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if ( isDefined( perk_struct.blocker_model ) )
	{
		use_trigger.blocker_model = perk_struct.blocker_model;
	}
	if ( isDefined( perk_struct.script_int ) )
	{
		perk_machine.script_int = perk_struct.script_int;
	}
	if ( isDefined( perk_struct.turn_on_notify ) )
	{
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}

	use_trigger.script_sound = "mus_perks_speed_jingle";
	use_trigger.script_string = "speedcola_perk";
	use_trigger.script_label = "mus_perks_speed_sting";
	use_trigger.target = "vending_sleight";
	perk_machine.script_string = "speedcola_perk";
	perk_machine.targetname = "vending_sleight";
	bump_trigger.script_string = "speedcola_perk";

	level thread maps/mp/zombies/_zm_perks::turn_sleight_on();
	use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();
}

borough_move_staminup_machine()
{
	if (!(!is_classic() && level.scr_zm_map_start_location == "street"))
	{
		return;	
	}

	perk_struct = undefined;
	perk_location_struct = undefined;
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach (struct in structs)
	{
		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_longersprint" && IsSubStr(struct.script_string, "zclassic"))
			{
				perk_struct = struct;
			}
			else if (struct.script_noteworthy == "specialty_quickrevive" && IsSubStr(struct.script_string, "zgrief"))
			{
				perk_location_struct = struct;
			}
		}
	}

	if(!IsDefined(perk_struct) || !IsDefined(perk_location_struct))
	{
		return;
	}

	// delete old machine
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	for (i = 0; i < vending_trigger.size; i++)
	{
		trig = vending_triggers[i];
		if (IsDefined(trig.script_noteworthy) && trig.script_noteworthy == "specialty_longersprint")
		{
			trig.clip delete();
			trig.machine delete();
			trig.bump delete();
			trig delete();
			break;
		}
	}

	// spawn new machine
	use_trigger = spawn( "trigger_radius_use", perk_location_struct.origin + vectorScale( ( 0, 0, 1 ), 30 ), 0, 40, 70 );
	use_trigger.targetname = "zombie_vending";
	use_trigger.script_noteworthy = perk_struct.script_noteworthy;
	use_trigger triggerignoreteam();
	perk_machine = spawn( "script_model", perk_location_struct.origin );
	perk_machine.angles = perk_location_struct.angles;
	perk_machine setmodel( perk_struct.model );
	bump_trigger = spawn( "trigger_radius", perk_location_struct.origin + AnglesToRight(perk_location_struct.angles) * 32, 0, 35, 32 );
	bump_trigger.script_activated = 1;
	bump_trigger.script_sound = "zmb_perks_bump_bottle";
	bump_trigger.targetname = "audio_bump_trigger";
	bump_trigger thread maps/mp/zombies/_zm_perks::thread_bump_trigger();
	collision = spawn( "script_model", perk_location_struct.origin, 1 );
	collision.angles = perk_location_struct.angles;
	collision setmodel( "zm_collision_perks1" );
	collision.script_noteworthy = "clip";
	collision disconnectpaths();
	use_trigger.clip = collision;
	use_trigger.machine = perk_machine;
	use_trigger.bump = bump_trigger;
	if ( isDefined( perk_struct.blocker_model ) )
	{
		use_trigger.blocker_model = perk_struct.blocker_model;
	}
	if ( isDefined( perk_struct.script_int ) )
	{
		perk_machine.script_int = perk_struct.script_int;
	}
	if ( isDefined( perk_struct.turn_on_notify ) )
	{
		perk_machine.turn_on_notify = perk_struct.turn_on_notify;
	}

	use_trigger.script_sound = "mus_perks_stamin_jingle";
	use_trigger.script_string = "marathon_perk";
	use_trigger.script_label = "mus_perks_stamin_sting";
	use_trigger.target = "vending_marathon";
	perk_machine.script_string = "marathon_perk";
	perk_machine.targetname = "vending_marathon";
	bump_trigger.script_string = "marathon_perk";

	level thread maps/mp/zombies/_zm_perks::turn_marathon_on();
	use_trigger thread maps/mp/zombies/_zm_perks::vending_trigger_think();
	use_trigger thread maps/mp/zombies/_zm_perks::electric_perks_dialog();
}

tomb_remove_weighted_random_perks()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	level.custom_random_perk_weights = undefined;
}

tomb_remove_shovels_from_map()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	flag_wait( "initial_blackscreen_passed" );

	stubs = level._unitriggers.trigger_stubs;
	for(i = 0; i < stubs.size; i++)
	{
		stub = stubs[i];
		if(IsDefined(stub.e_shovel))
		{
			stub.e_shovel delete();
			maps/mp/zombies/_zm_unitrigger::unregister_unitrigger( stub );
		}
	}
}

tomb_give_shovel()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	self.dig_vars[ "has_shovel" ] = 1;
	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 1 );
}

tomb_challenges_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	level._challenges.a_stats["zc_points_spent"].fp_give_reward = ::tomb_reward_random_perk;
}

tomb_reward_random_perk( player, s_stat )
{
	if (!isDefined(player.tomb_reward_perk))
	{
		player.tomb_reward_perk = player get_random_perk();
	}
	else if (isDefined( self.perk_purchased ) && self.perk_purchased == player.tomb_reward_perk)
	{
		player.tomb_reward_perk = player get_random_perk();
	}
	else if (self hasperk( player.tomb_reward_perk ) || self maps/mp/zombies/_zm_perks::has_perk_paused( player.tomb_reward_perk ))
	{
		player.tomb_reward_perk = player get_random_perk();
	}

	perk = player.tomb_reward_perk;
	if (!isDefined(perk))
	{
		return 0;
	}

	model = get_perk_weapon_model(perk);
	if (!isDefined(model))
	{
		return 0;
	}

	m_reward = spawn( "script_model", self.origin );
	m_reward.angles = self.angles + vectorScale( ( 0, 1, 0 ), 180 );
	m_reward setmodel( model );
	m_reward playsound( "zmb_spawn_powerup" );
	m_reward playloopsound( "zmb_spawn_powerup_loop", 0.5 );
	wait_network_frame();
	if ( !reward_rise_and_grab( m_reward, 50, 2, 2, 10 ) )
	{
		return 0;
	}
	if ( player hasperk( perk ) || player maps/mp/zombies/_zm_perks::has_perk_paused( perk ) )
	{
		m_reward thread bottle_reject_sink( player );
		return 0;
	}
	m_reward stoploopsound( 0.1 );
	player playsound( "zmb_powerup_grabbed" );
	m_reward thread maps/mp/zombies/_zm_perks::vending_trigger_post_think( player, perk );
	m_reward delete();
	player increment_player_perk_purchase_limit();
	player maps/mp/zombies/_zm_stats::increment_client_stat( "tomb_perk_extension", 0 );
	player maps/mp/zombies/_zm_stats::increment_player_stat( "tomb_perk_extension" );
	player thread player_perk_purchase_limit_fix();
	return 1;
}

get_random_perk()
{
	perks = [];
	for (i = 0; i < level._random_perk_machine_perk_list.size; i++)
	{
		perk = level._random_perk_machine_perk_list[ i ];
		if ( isDefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			continue;
		}
		else
		{
			if ( !self hasperk( perk ) && !self maps/mp/zombies/_zm_perks::has_perk_paused( perk ) )
			{
				perks[ perks.size ] = perk;
			}
		}
	}
	if ( perks.size > 0 )
	{
		perks = array_randomize( perks );
		random_perk = perks[ 0 ];
		return random_perk;
	}
}

get_perk_weapon_model( perk )
{
	switch( perk )
	{
		case "specialty_armorvest":
		case "specialty_armorvest_upgrade":
			weapon = level.machine_assets[ "juggernog" ].weapon;
			break;
		case "specialty_quickrevive":
		case "specialty_quickrevive_upgrade":
			weapon = level.machine_assets[ "revive" ].weapon;
			break;
		case "specialty_fastreload":
		case "specialty_fastreload_upgrade":
			weapon = level.machine_assets[ "speedcola" ].weapon;
			break;
		case "specialty_rof":
		case "specialty_rof_upgrade":
			weapon = level.machine_assets[ "doubletap" ].weapon;
			break;
		case "specialty_longersprint":
		case "specialty_longersprint_upgrade":
			weapon = level.machine_assets[ "marathon" ].weapon;
			break;
		case "specialty_flakjacket":
		case "specialty_flakjacket_upgrade":
			weapon = level.machine_assets[ "divetonuke" ].weapon;
			break;
		case "specialty_deadshot":
		case "specialty_deadshot_upgrade":
			weapon = level.machine_assets[ "deadshot" ].weapon;
			break;
		case "specialty_additionalprimaryweapon":
		case "specialty_additionalprimaryweapon_upgrade":
			weapon = level.machine_assets[ "additionalprimaryweapon" ].weapon;
			break;
		case "specialty_scavenger":
		case "specialty_scavenger_upgrade":
			weapon = level.machine_assets[ "tombstone" ].weapon;
			break;
		case "specialty_finalstand":
		case "specialty_finalstand_upgrade":
			weapon = level.machine_assets[ "whoswho" ].weapon;
			break;
	}
	if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].perk_bottle ) )
	{
		weapon = level._custom_perks[ perk ].perk_bottle;
	}
	return getweaponmodel( weapon );
}

increment_player_perk_purchase_limit()
{
	if ( !isDefined( self.player_perk_purchase_limit ) )
	{
		self.player_perk_purchase_limit = level.perk_purchase_limit;
	}
	self.player_perk_purchase_limit++;
}

player_perk_purchase_limit_fix()
{
	self endon("disconnect");

	while (self.pers[ "tomb_perk_extension" ] < 5)
	{
		wait .5;
	}

	if (self.player_perk_purchase_limit < 9)
	{
		self.player_perk_purchase_limit = 9;
	}
}

reward_rise_and_grab( m_reward, n_z, n_rise_time, n_delay, n_timeout )
{
	m_reward movez( n_z, n_rise_time );
	wait n_rise_time;
	if ( n_timeout > 0 )
	{
		m_reward thread reward_sink( n_delay, n_z, n_timeout + 1 );
	}
	self reward_grab_wait( n_timeout );
	if ( self ent_flag( "reward_timeout" ) )
	{
		return 0;
	}
	return 1;
}

reward_sink( n_delay, n_z, n_time )
{
	if ( isDefined( n_delay ) )
	{
		wait n_delay;
		if ( isDefined( self ) )
		{
			self movez( n_z * -1, n_time );
		}
	}
}

reward_grab_wait( n_timeout )
{
	if ( !isDefined( n_timeout ) )
	{
		n_timeout = 10;
	}
	self ent_flag_clear( "reward_timeout" );
	self ent_flag_set( "waiting_for_grab" );
	self endon( "waiting_for_grab" );
	if ( n_timeout > 0 )
	{
		wait n_timeout;
		self ent_flag_set( "reward_timeout" );
		self ent_flag_clear( "waiting_for_grab" );
	}
	else
	{
		self ent_flag_waitopen( "waiting_for_grab" );
	}
}

bottle_reject_sink( player )
{
	n_time = 1;
	player playlocalsound( level.zmb_laugh_alias );
	self thread reward_sink( 0, 61, n_time );
	wait n_time;
	self delete();
}

tomb_zombie_blood_dig_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	while (1)
	{
		for (i = 0; i < level.a_zombie_blood_entities.size; i++)
		{
			ent = level.a_zombie_blood_entities[i];
			if (IsDefined(ent.e_unique_player))
			{
				if (!isDefined(ent.e_unique_player.initial_zombie_blood_dig))
				{
					ent.e_unique_player.initial_zombie_blood_dig = 0;
				}

				ent.e_unique_player.initial_zombie_blood_dig++;
				iprintln(ent.e_unique_player.initial_zombie_blood_dig);
				if (ent.e_unique_player.initial_zombie_blood_dig <= 2)
				{
					ent setvisibletoplayer(ent.e_unique_player);
				}
				else
				{
					ent thread set_visible_after_rounds(ent.e_unique_player, 3);
				}

				arrayremovevalue(level.a_zombie_blood_entities, ent);
			}
		}

		wait .5;
	}
}

set_visible_after_rounds(player, num)
{
	for (i = 0; i < num; i++)
	{
		level waittill( "end_of_round" );
	}

	self setvisibletoplayer(player);
}

tomb_soul_box_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	a_boxes = getentarray( "foot_box", "script_noteworthy" );
	array_thread( a_boxes, ::tomb_soul_box_decrease_kill_requirement );
}

tomb_soul_box_decrease_kill_requirement()
{
	self endon( "box_finished" );

	while (1)
	{
		self waittill( "soul_absorbed" );

		wait 0.05;

		self.n_souls_absorbed += 10;
		
		self waittill( "robot_foot_stomp" );
	}
}

test()
{
	while(1)
	{
		wait 1;
	}
}