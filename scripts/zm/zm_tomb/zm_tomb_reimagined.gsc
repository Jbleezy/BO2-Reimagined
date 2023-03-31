#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;

#include scripts\zm\replaced\zm_tomb_main_quest;
#include scripts\zm\replaced\zm_tomb_quest_air;
#include scripts\zm\replaced\zm_tomb_quest_elec;
#include scripts\zm\replaced\zm_tomb_quest_fire;
#include scripts\zm\replaced\zm_tomb_quest_ice;
#include scripts\zm\replaced\zm_tomb_capture_zones;
#include scripts\zm\replaced\zm_tomb_challenges;
#include scripts\zm\replaced\zm_tomb_craftables;
#include scripts\zm\replaced\zm_tomb_dig;
#include scripts\zm\replaced\zm_tomb_giant_robot;
#include scripts\zm\replaced\zm_tomb_tank;
#include scripts\zm\replaced\zm_tomb_teleporter;
#include scripts\zm\replaced\zm_tomb_utility;
#include scripts\zm\replaced\_zm_ai_mechz;
#include scripts\zm\replaced\_zm_craftables;
#include scripts\zm\replaced\_zm_powerup_zombie_blood;
#include scripts\zm\replaced\_zm_riotshield_tomb;
#include scripts\zm\replaced\_zm_weap_riotshield_tomb;
#include scripts\zm\replaced\_zm_weap_staff_fire;
#include scripts\zm\replaced\_zm_weap_staff_lightning;

main()
{
	replaceFunc(maps\mp\zm_tomb_main_quest::main_quest_init, scripts\zm\replaced\zm_tomb_main_quest::main_quest_init);
    replaceFunc(maps\mp\zm_tomb_main_quest::place_staff_in_charger, scripts\zm\replaced\zm_tomb_main_quest::place_staff_in_charger);
	replaceFunc(maps\mp\zm_tomb_main_quest::watch_for_player_pickup_staff, scripts\zm\replaced\zm_tomb_main_quest::watch_for_player_pickup_staff);
	replaceFunc(maps\mp\zm_tomb_main_quest::staff_upgraded_reload, scripts\zm\replaced\zm_tomb_main_quest::staff_upgraded_reload);
	replaceFunc(maps\mp\zm_tomb_main_quest::watch_staff_ammo_reload, scripts\zm\replaced\zm_tomb_main_quest::watch_staff_ammo_reload);
	replaceFunc(maps\mp\zm_tomb_quest_air::air_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_air::air_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_quest_elec::electric_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_elec::electric_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_quest_fire::fire_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_fire::fire_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_quest_ice::ice_puzzle_1_run, scripts\zm\replaced\zm_tomb_quest_ice::ice_puzzle_1_run);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_2::create_robot_head_trigger, scripts\zm\replaced\zm_tomb_ee_main_step_2::create_robot_head_trigger);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_2::remove_plinth, scripts\zm\replaced\zm_tomb_ee_main_step_2::remove_plinth);
	replaceFunc(maps\mp\zm_tomb_ee_main_step_3::fire_link_cooldown, scripts\zm\replaced\zm_tomb_ee_main_step_3::fire_link_cooldown);
    replaceFunc(maps\mp\zm_tomb_capture_zones::setup_capture_zones, scripts\zm\replaced\zm_tomb_capture_zones::setup_capture_zones);
    replaceFunc(maps\mp\zm_tomb_challenges::challenges_init, scripts\zm\replaced\zm_tomb_challenges::challenges_init);
    replaceFunc(maps\mp\zm_tomb_craftables::init_craftables, scripts\zm\replaced\zm_tomb_craftables::init_craftables);
    replaceFunc(maps\mp\zm_tomb_craftables::include_craftables, scripts\zm\replaced\zm_tomb_craftables::include_craftables);
    replaceFunc(maps\mp\zm_tomb_dig::init_shovel, scripts\zm\replaced\zm_tomb_dig::init_shovel);
    replaceFunc(maps\mp\zm_tomb_dig::waittill_dug, scripts\zm\replaced\zm_tomb_dig::waittill_dug);
	replaceFunc(maps\mp\zm_tomb_dig::increment_player_perk_purchase_limit, scripts\zm\replaced\zm_tomb_dig::increment_player_perk_purchase_limit);
    replaceFunc(maps\mp\zm_tomb_giant_robot::robot_cycling, scripts\zm\replaced\zm_tomb_giant_robot::robot_cycling);
    replaceFunc(maps\mp\zm_tomb_tank::players_on_tank_update, scripts\zm\replaced\zm_tomb_tank::players_on_tank_update);
    replaceFunc(maps\mp\zm_tomb_tank::wait_for_tank_cooldown, scripts\zm\replaced\zm_tomb_tank::wait_for_tank_cooldown);
    replaceFunc(maps\mp\zm_tomb_teleporter::teleporter_init, scripts\zm\replaced\zm_tomb_teleporter::teleporter_init);
    replaceFunc(maps\mp\zm_tomb_utility::update_staff_accessories, scripts\zm\replaced\zm_tomb_utility::update_staff_accessories);
    replaceFunc(maps\mp\zombies\_zm_ai_mechz::mechz_set_starting_health, scripts\zm\replaced\_zm_ai_mechz::mechz_set_starting_health);
    replaceFunc(maps\mp\zombies\_zm_craftables::choose_open_craftable, scripts\zm\replaced\_zm_craftables::choose_open_craftable);
    replaceFunc(maps\mp\zombies\_zm_powerup_zombie_blood::zombie_blood_powerup, scripts\zm\replaced\_zm_powerup_zombie_blood::zombie_blood_powerup);
    replaceFunc(maps\mp\zombies\_zm_riotshield_tomb::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield_tomb::doriotshielddeploy);
    replaceFunc(maps\mp\zombies\_zm_riotshield_tomb::trackriotshield, scripts\zm\replaced\_zm_riotshield_tomb::trackriotshield);
    replaceFunc(maps\mp\zombies\_zm_weap_riotshield_tomb::init, scripts\zm\replaced\_zm_weap_riotshield_tomb::init);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_tomb::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield_tomb::player_damage_shield);
    replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::flame_damage_fx, scripts\zm\replaced\_zm_weap_staff_fire::flame_damage_fx);
    replaceFunc(maps\mp\zombies\_zm_weap_staff_fire::get_impact_damage, scripts\zm\replaced\_zm_weap_staff_fire::get_impact_damage);
    replaceFunc(maps\mp\zombies\_zm_weap_staff_lightning::staff_lightning_ball_kill_zombies, scripts\zm\replaced\_zm_weap_staff_lightning::staff_lightning_ball_kill_zombies);
}

init()
{
	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::tomb_special_weapon_magicbox_check;
	level.custom_magic_box_timer_til_despawn = ::custom_magic_box_timer_til_despawn;

    change_stargate_teleport_return_player_angles();

	level thread increase_solo_door_prices();
	level thread zombie_blood_dig_changes();
	level thread updatecraftables();
}

zombie_init_done()
{
	self.allowpain = 0;
	self thread maps\mp\zm_tomb_distance_tracking::escaped_zombies_cleanup_init();
	self setphysparams( 15, 0, 64 );
}

tomb_special_weapon_magicbox_check(weapon)
{
	if ( weapon == "beacon_zm" )
	{
		if ( isDefined( self.beacon_ready ) && self.beacon_ready )
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	if ( isDefined( level.zombie_weapons[ weapon ].shared_ammo_weapon ) )
	{
		if ( self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( level.zombie_weapons[ weapon ].shared_ammo_weapon ) )
		{
			return 0;
		}
	}
	return 1;
}

change_stargate_teleport_return_player_angles()
{
    struct = getstructarray( "air_teleport_return", "targetname" );
    foreach (pos in struct)
    {
        pos.angles = (0, -120, 0);
    }

    struct = getstructarray( "elec_teleport_return", "targetname" );
    foreach (pos in struct)
    {
        pos.angles = (0, 0, 0);
    }

    struct = getstructarray( "fire_teleport_return", "targetname" );
    foreach (pos in struct)
    {
        pos.angles = (0, -130, 0);
    }

    struct = getstructarray( "ice_teleport_return", "targetname" );
    foreach (pos in struct)
    {
        pos.angles = (0, -110, 0);
    }
}

increase_solo_door_prices()
{
	if(!(is_classic() && level.scr_zm_map_start_location == "tomb"))
	{
		return;
	}

	flag_wait( "initial_blackscreen_passed" );

	if ( isDefined( level.is_forever_solo_game ) && level.is_forever_solo_game )
	{
		a_door_buys = getentarray( "zombie_door", "targetname" );
		array_thread( a_door_buys, ::door_price_increase_for_solo );
		a_debris_buys = getentarray( "zombie_debris", "targetname" );
		array_thread( a_debris_buys, ::door_price_increase_for_solo );
	}
}

door_price_increase_for_solo()
{
	self.zombie_cost += 250;

	if ( self.targetname == "zombie_door" )
	{
		self set_hint_string( self, "default_buy_door", self.zombie_cost );
	}
	else
	{
		self set_hint_string( self, "default_buy_debris", self.zombie_cost );
	}
}

zombie_blood_dig_changes()
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

custom_magic_box_timer_til_despawn( magic_box )
{
	self endon( "kill_weapon_movement" );
	v_float = anglesToForward( magic_box.angles - vectorScale( ( 0, 1, 0 ), 90 ) ) * 40;
	self moveto( self.origin - ( v_float * 0.25 ), level.magicbox_timeout, level.magicbox_timeout * 0.5 );
	wait level.magicbox_timeout;
	if ( isDefined( self ) )
	{
		self delete();
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

	if (can_use && is_true(self.stub.crafted) && !isSubStr(self.stub.craftablespawn.craftable_name, "staff"))
	{
		self sethintstring( self.stub.hint_string, " [Cost: " + self.stub.cost + "]" );
	}
	else
	{
		self sethintstring( self.stub.hint_string );
	}

    return can_use;
}

craftablestub_update_prompt( player, unitrigger )
{
    if ( !self anystub_update_prompt( player ) )
        return false;

    if ( isdefined( self.is_locked ) && self.is_locked )
        return true;

    can_use = 1;

    if ( isdefined( self.custom_craftablestub_update_prompt ) && !self [[ self.custom_craftablestub_update_prompt ]]( player ) )
        return false;

    if ( !( isdefined( self.crafted ) && self.crafted ) )
    {
        if ( !self.craftablespawn craftable_can_use_shared_piece() )
        {
            if ( !isdefined( player.current_craftable_piece ) )
            {
                self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
                return false;
            }
            else if ( !self.craftablespawn craftable_has_piece( player.current_craftable_piece ) )
            {
                self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
                return false;
            }
        }

        assert( isdefined( level.zombie_craftablestubs[self.equipname].str_to_craft ), "Missing craftable hint" );
        self.hint_string = level.zombie_craftablestubs[self.equipname].str_to_craft;
    }
    else if ( self.persistent == 1 )
    {
        if ( maps\mp\zombies\_zm_equipment::is_limited_equipment( self.weaponname ) && maps\mp\zombies\_zm_equipment::limited_equipment_in_use( self.weaponname ) )
        {
            self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
            return false;
        }

        if ( player has_player_equipment( self.weaponname ) )
        {
            self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
            return false;
        }

        if ( self.equipname == "equip_dieseldrone_zm" )
        {
            if (level.quadrotor_status.picked_up)
            {
                self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
                return false;
            }
            else if (flag( "quadrotor_cooling_down" ))
            {
                self.hint_string = "Cooling down";
                return false;
            }
        }

        self.hint_string = self.trigger_hintstring;
    }
    else if ( self.persistent == 2 )
    {
        if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.weaponname, undefined ) )
        {
            self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
            return false;
        }
        else if ( isdefined( self.str_taken ) && self.str_taken )
        {
            self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
            return false;
        }

        self.hint_string = self.trigger_hintstring;
    }
    else
    {
        self.hint_string = "";
        return false;
    }

    return true;
}