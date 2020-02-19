#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
	level.inital_spawn = true;
	thread onplayerconnect();
	//SetDvar("r_enablePlayerShadow", 1); // Causes laser flickering
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

		set_movement_dvars();

		self setperk( "specialty_unlimitedsprint" );

		self thread on_equipment_placed();
		self thread give_additional_perks();

		self thread jetgun_fast_cooldown();
		self thread jetgun_fast_spinlerp();
		self thread jetgun_overheated_fix();

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

	disable_carpenter();

	disable_bank();
	disable_weapon_locker();

	zone_changes();

	electric_trap_always_kill();

	jetgun_disable_explode_overheat();

	slipgun_always_kill();
	slipgun_disable_reslip();

	//disable_pers_upgrades(); // TODO

	//level thread replace_wallbuys(); // TODO

	level thread buildbuildables();
	level thread buildcraftables();

	level thread zombie_health_fix();

	level thread jetgun_remove_forced_weapon_switch();

	level thread transit_power_local_electric_doors_globally();

	level thread town_move_staminup_machine();

	level thread prison_auto_refuel_plane();

	level thread buried_deleteslothbarricades();
	level thread buried_enable_fountain_transport();

	level thread tomb_remove_weighted_random_perks();
	level thread tomb_remove_shovels_from_map();

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

disable_high_round_walkers()
{
	level.speed_change_round = undefined;
}

disable_bank()
{
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

	level notify( "stop_bank_teller" );
	bank_teller_dmg_trig = getent( "bank_teller_tazer_trig", "targetname" );
	if(IsDefined(bank_teller_dmg_trig))
	{
		bank_teller_transfer_trig = getent( bank_teller_dmg_trig.target, "targetname" );
		bank_teller_dmg_trig delete();
		bank_teller_transfer_trig delete();
	}
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

replace_wallbuys()
{
	if(level.scr_zm_ui_gametype == "zstandard")
	{
		if(level.scr_zm_map_start_location == "farm")
		{
			replace_wallbuy( "tazer_knuckles_zm", "claymore_zm" );
		}
	}
}

replace_wallbuy( replace_from, replace_to )
{
	str = level.scr_zm_ui_gametype + "_" + level.scr_zm_map_start_location;
	replace_from_struct = undefined;
	replace_to_struct = undefined;
	spawnable_weapon_spawns = getstructarray( "weapon_upgrade", "targetname" );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "bowie_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "sickle_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "tazer_upgrade", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "buildable_wallbuy", "targetname" ), 1, 0 );
	spawnable_weapon_spawns = arraycombine( spawnable_weapon_spawns, getstructarray( "claymore_purchase", "targetname" ), 1, 0 );
	for(i = 0; i < spawnable_weapon_spawns.size; i++)
	{
		if(IsDefined(spawnable_weapon_spawns[i].zombie_weapon_upgrade))
		{
			if(spawnable_weapon_spawns[i].zombie_weapon_upgrade == replace_from && IsDefined(spawnable_weapon_spawns[i].script_noteworthy) && IsSubStr(spawnable_weapon_spawns[i].script_noteworthy, str))
			{
				replace_from_struct = spawnable_weapon_spawns[i];
			}
			else if(spawnable_weapon_spawns[i].zombie_weapon_upgrade == replace_to)
			{
				replace_to_struct = spawnable_weapon_spawns[i];
			}
		}
	}

	for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
	{
		if(IsDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade))
		{
			if(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade == replace_from)
			{
				level._unitriggers.trigger_stubs[i].weapon_upgrade = replace_to_struct.zombie_weapon_upgrade;
				level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade = replace_to_struct.zombie_weapon_upgrade;
				level._unitriggers.trigger_stubs[i].targetname = replace_to_struct.targetname;
				level._unitriggers.trigger_stubs[i].cost = maps/mp/zombies/_zm_weapons::get_weapon_cost( replace_to_struct.zombie_weapon_upgrade );
				level._unitriggers.trigger_stubs[i].hint_string = maps/mp/zombies/_zm_weapons::get_weapon_hint( replace_to_struct.zombie_weapon_upgrade );
				level._unitriggers.trigger_stubs[i].hint_parm1 = level._unitriggers.trigger_stubs[i].cost;
				//clientfieldname = ( replace_to_struct.zombie_weapon_upgrade + "_" ) + replace_from_struct.origin;
				//level._unitriggers.trigger_stubs[i].clientfieldname = clientfieldname;

				if(replace_to_struct.targetname == "claymore_purchase")
				{
					//level._unitriggers.trigger_stubs[i].trigger_func = ::maps/mp/zombies/_zm_weap_claymore::buy_claymores;
					//level._unitriggers.trigger_stubs[i].prompt_and_visibility_func = ::maps/mp/zombies/_zm_weap_claymore::claymore_unitrigger_update_prompt;
				}

				break;
			}
		}
	}
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

			// power switch is not showing up from forced build
			show_powerswitch();
		}
		else if(level.scr_zm_map_start_location == "rooftop")
		{
			buildbuildable( "slipgun_zm" );
			buildbuildable( "springpad_zm" );
		}
		else if(level.scr_zm_map_start_location == "processing")
		{
			buildbuildable( "turbine" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "subwoofer_zm" );
			buildbuildable( "headchopper_zm" );
		}
	}
}

buildbuildable( buildable )
{
	player = get_players()[ 0 ];
	_a197 = level.buildable_stubs;
	_k197 = getFirstArrayKey( _a197 );
	while ( isDefined( _k197 ) )
	{
		stub = _a197[ _k197 ];
		if ( !isDefined( buildable ) || stub.equipname == buildable )
		{
			if ( isDefined( buildable ) || stub.persistent != 3 )
			{
				stub maps/mp/zombies/_zm_buildables::buildablestub_finish_build( player );
				stub maps/mp/zombies/_zm_buildables::buildablestub_remove();
				_a206 = stub.buildablezone.pieces;
				_k206 = getFirstArrayKey( _a206 );
				while ( isDefined( _k206 ) )
				{
					piece = _a206[ _k206 ];
					piece maps/mp/zombies/_zm_buildables::piece_unspawn();
					_k206 = getNextArrayKey( _a206, _k206 );
				}
				stub.model notsolid();
				stub.model show();
				return;
			}
		}
		_k197 = getNextArrayKey( _a197, _k197 );
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
	_a197 = level.zombie_include_craftables;
	_k197 = getFirstArrayKey( _a197 );
	while ( isDefined( _k197 ) )
	{
		stub = _a197[ _k197 ];
		if ( stub.name == buildable )
		{
			_a206 = stub.a_piecestubs;
			_k206 = getFirstArrayKey( _a206 );
			while ( isDefined( _k206 ) )
			{
				piece = _a206[ _k206 ];

				piecespawn = piece.piecespawn;
				if ( isDefined( piecespawn ) )
				{
					player player_take_piece( piecespawn );
				}
				
				_k206 = getNextArrayKey( _a206, _k206 );
			}

			return;
		}
		_k197 = getNextArrayKey( _a197, _k197 );
	}
}

buildcraftable( buildable )
{
	player = get_players()[ 0 ];
	_a197 = level.a_uts_craftables;
	_k197 = getFirstArrayKey( _a197 );
	while ( isDefined( _k197 ) )
	{
		stub = _a197[ _k197 ];
		if ( stub.craftablestub.name == buildable )
		{
			_a206 = stub.craftablespawn.a_piecespawns;
			_k206 = getFirstArrayKey( _a206 );
			while ( isDefined( _k206 ) )
			{
				piece = _a206[ _k206 ];
				piecespawn = get_craftable_piece( stub.craftablestub.name, piece.piecename );
				if ( isDefined( piecespawn ) )
				{
					player player_take_piece( piecespawn );
				}
				_k206 = getNextArrayKey( _a206, _k206 );
			}

			return;
		}
		_k197 = getNextArrayKey( _a197, _k197 );
	}
}

get_craftable_piece( str_craftable, str_piece )
{
	_a3564 = level.a_uts_craftables;
	_k3564 = getFirstArrayKey( _a3564 );
	while ( isDefined( _k3564 ) )
	{
		uts_craftable = _a3564[ _k3564 ];
		if ( uts_craftable.craftablestub.name == str_craftable )
		{
			_a3568 = uts_craftable.craftablespawn.a_piecespawns;
			_k3568 = getFirstArrayKey( _a3568 );
			while ( isDefined( _k3568 ) )
			{
				piecespawn = _a3568[ _k3568 ];
				if ( piecespawn.piecename == str_piece )
				{
					return piecespawn;
				}
				_k3568 = getNextArrayKey( _a3568, _k3568 );
			}
		}
		else _k3564 = getNextArrayKey( _a3564, _k3564 );
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
	buildables = level.zombie_include_buildables;
	buildables_key = getFirstArrayKey( buildables );
	while(IsDefined(buildables_key))
	{
		buildable = buildables[buildables_key];

		if(IsDefined(buildable.name) && buildable.name == buildable_name)
		{
			pieces = buildable.buildablepieces;
			for(i = 0; i < pieces.size; i++)
			{
				pieces[i] maps/mp/zombies/_zm_buildables::piece_unspawn();
			}
			return;
		}

		buildables_key = getNextArrayKey( buildables, buildables_key );
	}
}

enemies_ignore_equipments()
{
	maps/mp/zombies/_zm_equipment::enemies_ignore_equipment("turbine");
	maps/mp/zombies/_zm_equipment::enemies_ignore_equipment("electric_trap");
	maps/mp/zombies/_zm_equipment::enemies_ignore_equipment("turret");
	maps/mp/zombies/_zm_equipment::enemies_ignore_equipment("riotshield_zm");
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
	buildables = level.zombie_include_buildables;
	buildables_key = getFirstArrayKey( buildables );
	while(IsDefined(buildables_key))
	{
		buildable = buildables[buildables_key];

		if(IsDefined(buildable.name) && buildable.name == "jetgun_zm")
		{
			buildable.onbuyweapon = undefined;
			return;
		}

		buildables_key = getNextArrayKey( buildables, buildables_key );
	}
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

town_move_staminup_machine()
{
	if (!(!is_classic() && level.scr_zm_map_start_location == "town"))
	{
		return;	
	}

	structs = getstructarray("zm_perk_machine", "targetname");
	structs_key = getFirstArrayKey(structs);
	perk_struct = undefined;
	while (IsDefined(structs_key))
	{
		struct = structs[structs_key];

		if (IsDefined(struct.script_noteworthy) && IsDefined(struct.script_string))
		{
			if (struct.script_noteworthy == "specialty_longersprint" && IsSubStr(struct.script_string, "zclassic_perks_transit"))
			{
				perk_struct = struct;
				break;
			}
		}

		structs_key = getNextArrayKey(structs, structs_key);
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

}

buried_deleteslothbarricades()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "processing"))
	{
		return;
	}

	sloth_trigs = getentarray( "sloth_barricade", "targetname" );
	_a77 = sloth_trigs;
	_k77 = getFirstArrayKey( _a77 );
	while ( isDefined( _k77 ) )
	{
		trig = _a77[ _k77 ];
		if ( isDefined( trig.script_flag ) && level flag_exists( trig.script_flag ) )
		{
			flag_set( trig.script_flag );
		}
		parts = getentarray( trig.target, "targetname" );
		array_thread( parts, ::self_delete );
		_k77 = getNextArrayKey( _a77, _k77 );
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

test()
{
	while (!IsDefined(level.staminup_struct))
	{
		wait 0.05;
	}

	while(1)
	{
		iprintlnbold("distance: " + Distance(self.origin, level.staminup_struct.origin));

		wait 1;
	}
}