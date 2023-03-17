#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_utility;

#include scripts\zm\replaced\zm_alcatraz_classic;
#include scripts\zm\replaced\zm_alcatraz_gamemodes;
#include scripts\zm\replaced\zm_alcatraz_utility;
#include scripts\zm\replaced\zm_alcatraz_weap_quest;
#include scripts\zm\replaced\_zm_afterlife;
#include scripts\zm\replaced\_zm_ai_brutus;
#include scripts\zm\replaced\_zm_craftables;
#include scripts\zm\replaced\_zm_riotshield_prison;
#include scripts\zm\replaced\_zm_weap_riotshield_prison;

main()
{
	replaceFunc(maps\mp\zm_alcatraz_classic::give_afterlife, scripts\zm\replaced\zm_alcatraz_classic::give_afterlife);
	replaceFunc(maps\mp\zm_alcatraz_gamemodes::init, scripts\zm\replaced\zm_alcatraz_gamemodes::init);
	replaceFunc(maps\mp\zm_alcatraz_utility::blundergat_upgrade_station, scripts\zm\replaced\zm_alcatraz_utility::blundergat_upgrade_station);
	replaceFunc(maps\mp\zm_alcatraz_weap_quest::grief_soul_catcher_state_manager, scripts\zm\replaced\zm_alcatraz_weap_quest::grief_soul_catcher_state_manager);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_add, scripts\zm\replaced\_zm_afterlife::afterlife_add);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_spawn, scripts\zm\replaced\_zm_ai_brutus::brutus_spawn);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_health_increases, scripts\zm\replaced\_zm_ai_brutus::brutus_health_increases);
	replaceFunc(maps\mp\zombies\_zm_ai_brutus::brutus_cleanup_at_end_of_grief_round, scripts\zm\replaced\_zm_ai_brutus::brutus_cleanup_at_end_of_grief_round);
	replaceFunc(maps\mp\zombies\_zm_craftables::choose_open_craftable, scripts\zm\replaced\_zm_craftables::choose_open_craftable);
	replaceFunc(maps\mp\zombies\_zm_riotshield_prison::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield_prison::doriotshielddeploy);
	replaceFunc(maps\mp\zombies\_zm_riotshield_prison::trackriotshield, scripts\zm\replaced\_zm_riotshield_prison::trackriotshield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::init, scripts\zm\replaced\_zm_weap_riotshield_prison::init);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield_prison::player_damage_shield);
}

init()
{
	precacheModel("t6_wpn_zmb_severedhead_world");

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::check_for_special_weapon_limit_exist;
	level.round_prestart_func = scripts\zm\replaced\_zm_afterlife::afterlife_start_zombie_logic;

	level.zombie_powerups["meat_stink"].model_name = "t6_wpn_zmb_severedhead_world";

	add_adjacent_zone( "zone_dock", "zone_dock_puzzle", "always_on" ); // "docks_inner_gate_unlocked"

	remove_acid_trap_player_spawn();

	tower_trap_changes();

	plane_set_need_all_pieces();
	plane_set_pieces_shared();

	level thread plane_auto_refuel();
	level thread updatecraftables();
}

zombie_init_done()
{
	self.allowpain = 0;
	self setphysparams( 15, 0, 64 );
}

check_for_special_weapon_limit_exist(weapon)
{
	if ( weapon != "blundergat_zm" && weapon != "minigun_alcatraz_zm" )
	{
		return 1;
	}
	players = get_players();
	count = 0;
	if ( weapon == "blundergat_zm" )
	{
		if ( self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( "blundersplat_zm" ) )
		{
			return 0;
		}
		if ( self afterlife_weapon_limit_check( "blundergat_zm" ) )
		{
			return 0;
		}
		limit = level.limited_weapons[ "blundergat_zm" ];
	}
	else
	{
		if ( self afterlife_weapon_limit_check( "minigun_alcatraz_zm" ) )
		{
			return 0;
		}
		limit = level.limited_weapons[ "minigun_alcatraz_zm" ];
	}
	i = 0;
	while ( i < players.size )
	{
		if ( weapon == "blundergat_zm" )
		{
			if ( players[ i ] maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( "blundersplat_zm" ) || isDefined( players[ i ].is_pack_splatting ) && players[ i ].is_pack_splatting )
			{
				count++;
				i++;
				continue;
			}
		}
		else
		{
			if ( players[ i ] afterlife_weapon_limit_check( weapon ) )
			{
				count++;
			}
		}
		i++;
	}
	if ( count >= limit )
	{
		return 0;
	}
	return 1;
}

remove_acid_trap_player_spawn()
{
	spawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();
	foreach(spawn_point in spawn_points)
	{
		if(spawn_point.script_noteworthy == "zone_cafeteria")
		{
			spawn_array = getstructarray( spawn_point.target, "targetname" );
			foreach(spawn in spawn_array)
			{
				if(spawn.origin == (2536, 9704, 1360))
				{
					arrayremovevalue(spawn_array, spawn);
					return;
				}
			}
		}
	}
}

tower_trap_changes()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	// need to override the original function call
	// this level var is threaded though so it doesn't work
	level.custom_tower_trap_fires_func = ::tower_trap_fires_override;

	trap_trigs = getentarray( "tower_trap_activate_trigger", "targetname" );
	foreach (trig in trap_trigs)
	{
		trig thread tower_trap_trigger_think();
		trig thread tower_upgrade_trigger_think();
	}
}

tower_trap_fires_override( zombies )
{

}

tower_trap_trigger_think()
{
	while (1)
	{
		self waittill("switch_activated");
		self thread activate_tower_trap();
	}
}

activate_tower_trap()
{
	self endon( "tower_trap_off" );

	if ( isDefined( self.upgraded ) )
	{
		self.weapon_name = "tower_trap_upgraded_zm";
		self.tag_to_target = "J_SpineLower";
		self.trap_reload_time = 1.5;
	}
	else
	{
		self.weapon_name = "tower_trap_zm";
		self.tag_to_target = "J_Head";
		self.trap_reload_time = 0.75;
	}

	while ( 1 )
	{
		zombies = getaiarray( level.zombie_team );
		zombies_sorted = [];
		foreach ( zombie in zombies )
		{
			if ( zombie istouching( self.range_trigger ) )
			{
				zombies_sorted[ zombies_sorted.size ] = zombie;
			}
		}

		if ( zombies_sorted.size <= 0 )
		{
			wait_network_frame();
			continue;
		}

		self tower_trap_fires( zombies_sorted );
	}
}

tower_trap_fires( zombies )
{
	self endon( "tower_trap_off" );

	org = getstruct( self.range_trigger.target, "targetname" );
	index = randomintrange( 0, zombies.size );

	while ( isalive( zombies[ index ] ) )
	{
		target = zombies[ index ];
		zombietarget = target gettagorigin( self.tag_to_target );

		if ( sighttracepassed( org.origin, zombietarget, 1, undefined ) )
		{
			self thread tower_trap_magicbullet_think( org, target, zombietarget );
			wait self.trap_reload_time;
			continue;
		}
		else
		{
			arrayremovevalue( zombies, target, 0 );
			wait_network_frame();
			if ( zombies.size <= 0 )
			{
				return;
			}
			else
			{
				index = randomintrange( 0, zombies.size );
			}
		}
	}
}

tower_trap_magicbullet_think( org, target, zombietarget )
{
	bullet = magicbullet( self.weapon_name, org.origin, zombietarget );
	bullet waittill( "death" );

	if ( self.weapon_name == "tower_trap_zm" )
	{
		if ( isDefined( target ) && isDefined( target.animname ) && target.health > 0 && target.animname != "brutus_zombie" )
		{
			if ( !isDefined( target.no_gib ) || !target.no_gib )
			{
				target maps\mp\zombies\_zm_spawner::zombie_head_gib();
			}
			target dodamage( target.health + 1000, target.origin );
		}
	}
	else if ( self.weapon_name == "tower_trap_upgraded_zm" )
	{
		radiusdamage( bullet.origin, 256, level.zombie_health * 1.5, level.zombie_health / 2, self, "MOD_GRENADE_SPLASH", "tower_trap_upgraded_zm" );
	}
}

tower_upgrade_trigger_think()
{
	flag_wait( "initial_blackscreen_passed" );
	flag_wait( "start_zombie_round_logic" );
	wait 0.05;

	while (1)
	{
		level waittill( self.upgrade_trigger.script_string );
		self.upgraded = 1;
		level waittill( "between_round_over" );
		self.upgraded = undefined;
	}
}

plane_set_need_all_pieces()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	level.zombie_craftablestubs["plane"].need_all_pieces = 1;
	level.zombie_craftablestubs["refuelable_plane"].need_all_pieces = 1;
}

plane_set_pieces_shared()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	foreach(stub in level.zombie_include_craftables)
	{
		if(stub.name == "plane" || stub.name == "refuelable_plane")
		{
			foreach(piece in stub.a_piecestubs)
			{
				piece.is_shared = 1;
				piece.client_field_state = undefined;
			}
		}
	}
}

plane_auto_refuel()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "prison"))
	{
		return;
	}

	for ( ;; )
	{
		flag_wait( "spawn_fuel_tanks" );

		wait 0.05;

		scripts\zm\_zm_reimagined::buildcraftable( "refuelable_plane" );
	}
}

updatecraftables()
{
	flag_wait( "start_zombie_round_logic" );

	wait 1;

	foreach (stub in level._unitriggers.trigger_stubs)
	{
		if(IsDefined(stub.equipname))
		{
			stub.cost = stub scripts\zm\_zm_reimagined::get_equipment_cost();
			stub.trigger_func = ::craftable_place_think;
			stub.prompt_and_visibility_func = ::craftabletrigger_update_prompt;
		}
	}
}

craftable_place_think()
{
    self endon( "kill_trigger" );
    player_crafted = undefined;

    while ( !( isdefined( self.stub.crafted ) && self.stub.crafted ) )
    {
        self waittill( "trigger", player );

        if ( isdefined( level.custom_craftable_validation ) )
        {
            valid = self [[ level.custom_craftable_validation ]]( player );

            if ( !valid )
                continue;
        }

        if ( player != self.parent_player )
            continue;

        if ( isdefined( player.screecher_weapon ) )
            continue;

        if ( !is_player_valid( player ) )
        {
            player thread ignore_triggers( 0.5 );
            continue;
        }

        status = player player_can_craft( self.stub.craftablespawn );

        if ( !status )
        {
            self.stub.hint_string = "";
            self sethintstring( self.stub.hint_string );

            if ( isdefined( self.stub.oncantuse ) )
                self.stub [[ self.stub.oncantuse ]]( player );
        }
        else
        {
            if ( isdefined( self.stub.onbeginuse ) )
                self.stub [[ self.stub.onbeginuse ]]( player );

            result = self craftable_use_hold_think( player );
            team = player.pers["team"];

            if ( isdefined( self.stub.onenduse ) )
                self.stub [[ self.stub.onenduse ]]( team, player, result );

            if ( !result )
                continue;

            if ( isdefined( self.stub.onuse ) )
                self.stub [[ self.stub.onuse ]]( player );

            prompt = player player_craft( self.stub.craftablespawn );
            player_crafted = player;
            self.stub.hint_string = prompt;
            self sethintstring( self.stub.hint_string );
        }
    }

    if ( isdefined( self.stub.craftablestub.onfullycrafted ) )
    {
        b_result = self.stub [[ self.stub.craftablestub.onfullycrafted ]]();

        if ( !b_result )
            return;
    }

    if ( isdefined( player_crafted ) )
    {

    }

    if ( self.stub.persistent == 0 )
    {
        self.stub craftablestub_remove();
        thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.stub );
        return;
    }

    if ( self.stub.persistent == 3 )
    {
        stub_uncraft_craftable( self.stub, 1 );
        return;
    }

    if ( self.stub.persistent == 2 )
    {
        if ( isdefined( player_crafted ) )
            self craftabletrigger_update_prompt( player_crafted );

        if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.stub.weaponname, undefined ) )
        {
            self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
            self sethintstring( self.stub.hint_string );
            return;
        }

        if ( isdefined( self.stub.str_taken ) && self.stub.str_taken )
        {
            self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
            self sethintstring( self.stub.hint_string );
            return;
        }

        if ( isdefined( self.stub.model ) )
        {
            self.stub.model notsolid();
            self.stub.model show();
        }

        while ( self.stub.persistent == 2 )
        {
            self waittill( "trigger", player );

            if ( isdefined( player.screecher_weapon ) )
                continue;

            if ( isdefined( level.custom_craftable_validation ) )
            {
                valid = self [[ level.custom_craftable_validation ]]( player );

                if ( !valid )
                    continue;
            }

            if ( !( isdefined( self.stub.crafted ) && self.stub.crafted ) )
            {
                self.stub.hint_string = "";
                self sethintstring( self.stub.hint_string );
                return;
            }

            if ( player != self.parent_player )
                continue;

            if ( !is_player_valid( player ) )
            {
                player thread ignore_triggers( 0.5 );
                continue;
            }

            self.stub.bought = 1;

            if ( isdefined( self.stub.model ) )
                self.stub.model thread model_fly_away( self );

            player maps\mp\zombies\_zm_weapons::weapon_give( self.stub.weaponname );

            if ( isdefined( level.zombie_include_craftables[self.stub.equipname].onbuyweapon ) )
                self [[ level.zombie_include_craftables[self.stub.equipname].onbuyweapon ]]( player );

            if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.stub.weaponname, undefined ) )
                self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
            else
                self.stub.hint_string = &"ZOMBIE_GO_TO_THE_BOX";

            self sethintstring( self.stub.hint_string );
            player track_craftables_pickedup( self.stub.craftablespawn );
        }
    }
    else if ( !isdefined( player_crafted ) || self craftabletrigger_update_prompt( player_crafted ) )
    {
        if ( isdefined( self.stub.model ) )
        {
            self.stub.model notsolid();
            self.stub.model show();
        }

        while ( self.stub.persistent == 1 )
        {
            self waittill( "trigger", player );

            if ( isdefined( player.screecher_weapon ) )
                continue;

            if ( isdefined( level.custom_craftable_validation ) )
            {
                valid = self [[ level.custom_craftable_validation ]]( player );

                if ( !valid )
                    continue;
            }

            if ( !( isdefined( self.stub.crafted ) && self.stub.crafted ) )
            {
                self.stub.hint_string = "";
                self sethintstring( self.stub.hint_string );
                return;
            }

            if ( player != self.parent_player )
                continue;

            if ( !is_player_valid( player ) )
            {
                player thread ignore_triggers( 0.5 );
                continue;
            }

			if (player.score < self.stub.cost)
			{
				self play_sound_on_ent( "no_purchase" );
				continue;
			}

            if ( player has_player_equipment( self.stub.weaponname ) )
                continue;

            if ( isdefined( level.zombie_craftable_persistent_weapon ) )
            {
                if ( self [[ level.zombie_craftable_persistent_weapon ]]( player ) )
                    continue;
            }

            if ( isdefined( level.zombie_custom_equipment_setup ) )
            {
                if ( self [[ level.zombie_custom_equipment_setup ]]( player ) )
                    continue;
            }

            if ( !maps\mp\zombies\_zm_equipment::is_limited_equipment( self.stub.weaponname ) || !maps\mp\zombies\_zm_equipment::limited_equipment_in_use( self.stub.weaponname ) )
            {
				player maps\mp\zombies\_zm_score::minus_to_player_score( self.stub.cost );
				self play_sound_on_ent( "purchase" );

                player maps\mp\zombies\_zm_equipment::equipment_buy( self.stub.weaponname );
                player giveweapon( self.stub.weaponname );
                player setweaponammoclip( self.stub.weaponname, 1 );

                if ( isdefined( level.zombie_include_craftables[self.stub.equipname].onbuyweapon ) )
                    self [[ level.zombie_include_craftables[self.stub.equipname].onbuyweapon ]]( player );
                else if ( self.stub.weaponname != "keys_zm" )
                    player setactionslot( 1, "weapon", self.stub.weaponname );

                if ( isdefined( level.zombie_craftablestubs[self.stub.equipname].str_taken ) )
                    self.stub.hint_string = level.zombie_craftablestubs[self.stub.equipname].str_taken;
                else
                    self.stub.hint_string = "";

                self sethintstring( self.stub.hint_string );
                player track_craftables_pickedup( self.stub.craftablespawn );
            }
            else
            {
                self.stub.hint_string = "";
                self sethintstring( self.stub.hint_string );
            }
        }
    }
}

craftabletrigger_update_prompt( player )
{
    can_use = self.stub craftablestub_update_prompt( player );

	if (can_use && is_true(self.stub.crafted))
	{
		self sethintstring( self.stub.hint_string, " [Cost: " + self.stub.cost + "]" );
	}
	else
	{
		self sethintstring( self.stub.hint_string );
	}

    return can_use;
}