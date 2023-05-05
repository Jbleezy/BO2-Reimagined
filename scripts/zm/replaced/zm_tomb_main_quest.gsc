#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_quest_air;
#include maps\mp\zm_tomb_quest_fire;
#include maps\mp\zm_tomb_quest_ice;
#include maps\mp\zm_tomb_quest_elec;
#include maps\mp\zm_tomb_quest_crypt;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zm_tomb_craftables;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zm_tomb_ee_main_step_7;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_amb;
#include maps\mp\zombies\_zm_audio;

main_quest_init()
{
    flag_init( "dug" );
    flag_init( "air_open" );
    flag_init( "fire_open" );
    flag_init( "lightning_open" );
    flag_init( "ice_open" );
    flag_init( "panels_solved" );
    flag_init( "fire_solved" );
    flag_init( "ice_solved" );
    flag_init( "chamber_puzzle_cheat" );
    flag_init( "activate_zone_crypt" );
    level.callbackvehicledamage = ::aircrystalbiplanecallback_vehicledamage;
    level.game_mode_custom_onplayerdisconnect = ::player_disconnect_callback;
    onplayerconnect_callback( ::onplayerconnect );
    staff_air = getent( "prop_staff_air", "targetname" );
    staff_fire = getent( "prop_staff_fire", "targetname" );
    staff_lightning = getent( "prop_staff_lightning", "targetname" );
    staff_water = getent( "prop_staff_water", "targetname" );
    staff_air.weapname = "staff_air_zm";
    staff_fire.weapname = "staff_fire_zm";
    staff_lightning.weapname = "staff_lightning_zm";
    staff_water.weapname = "staff_water_zm";
    staff_air.element = "air";
    staff_fire.element = "fire";
    staff_lightning.element = "lightning";
    staff_water.element = "water";
    staff_air.craftable_name = "elemental_staff_air";
    staff_fire.craftable_name = "elemental_staff_fire";
    staff_lightning.craftable_name = "elemental_staff_lightning";
    staff_water.craftable_name = "elemental_staff_water";
    staff_air.charger = getstruct( "staff_air_charger", "script_noteworthy" );
    staff_fire.charger = getstruct( "staff_fire_charger", "script_noteworthy" );
    staff_lightning.charger = getstruct( "zone_bolt_chamber", "script_noteworthy" );
    staff_water.charger = getstruct( "staff_ice_charger", "script_noteworthy" );
    staff_fire.quest_clientfield = "quest_state1";
    staff_air.quest_clientfield = "quest_state2";
    staff_lightning.quest_clientfield = "quest_state3";
    staff_water.quest_clientfield = "quest_state4";
    staff_fire.enum = 1;
    staff_air.enum = 2;
    staff_lightning.enum = 3;
    staff_water.enum = 4;
    level.a_elemental_staffs = [];
    level.a_elemental_staffs[level.a_elemental_staffs.size] = staff_air;
    level.a_elemental_staffs[level.a_elemental_staffs.size] = staff_fire;
    level.a_elemental_staffs[level.a_elemental_staffs.size] = staff_lightning;
    level.a_elemental_staffs[level.a_elemental_staffs.size] = staff_water;

    foreach ( staff in level.a_elemental_staffs )
    {
        staff.charger.charges_received = 0;
        staff.charger.is_inserted = 0;
        staff thread place_staffs_encasement();
        staff thread staff_charger_check();
        staff ghost();
    }

    staff_air_upgraded = getent( "prop_staff_air_upgraded", "targetname" );
    staff_fire_upgraded = getent( "prop_staff_fire_upgraded", "targetname" );
    staff_lightning_upgraded = getent( "prop_staff_lightning_upgraded", "targetname" );
    staff_water_upgraded = getent( "prop_staff_water_upgraded", "targetname" );
    staff_air_upgraded.weapname = "staff_air_upgraded_zm";
    staff_fire_upgraded.weapname = "staff_fire_upgraded_zm";
    staff_lightning_upgraded.weapname = "staff_lightning_upgraded_zm";
    staff_water_upgraded.weapname = "staff_water_upgraded_zm";
    staff_air_upgraded.melee = "staff_air_melee_zm";
    staff_fire_upgraded.melee = "staff_fire_melee_zm";
    staff_lightning_upgraded.melee = "staff_lightning_melee_zm";
    staff_water_upgraded.melee = "staff_water_melee_zm";
    staff_air_upgraded.base_weapname = "staff_air_zm";
    staff_fire_upgraded.base_weapname = "staff_fire_zm";
    staff_lightning_upgraded.base_weapname = "staff_lightning_zm";
    staff_water_upgraded.base_weapname = "staff_water_zm";
    staff_air_upgraded.element = "air";
    staff_fire_upgraded.element = "fire";
    staff_lightning_upgraded.element = "lightning";
    staff_water_upgraded.element = "water";
    staff_air_upgraded.charger = staff_air.charger;
    staff_fire_upgraded.charger = staff_fire.charger;
    staff_lightning_upgraded.charger = staff_lightning.charger;
    staff_water_upgraded.charger = staff_water.charger;
    staff_fire_upgraded.enum = 1;
    staff_air_upgraded.enum = 2;
    staff_lightning_upgraded.enum = 3;
    staff_water_upgraded.enum = 4;
    staff_air.upgrade = staff_air_upgraded;
    staff_fire.upgrade = staff_fire_upgraded;
    staff_water.upgrade = staff_water_upgraded;
    staff_lightning.upgrade = staff_lightning_upgraded;
    level.a_elemental_staffs_upgraded = [];
    level.a_elemental_staffs_upgraded[level.a_elemental_staffs_upgraded.size] = staff_air_upgraded;
    level.a_elemental_staffs_upgraded[level.a_elemental_staffs_upgraded.size] = staff_fire_upgraded;
    level.a_elemental_staffs_upgraded[level.a_elemental_staffs_upgraded.size] = staff_lightning_upgraded;
    level.a_elemental_staffs_upgraded[level.a_elemental_staffs_upgraded.size] = staff_water_upgraded;

    foreach ( staff_upgraded in level.a_elemental_staffs_upgraded )
    {
        staff_upgraded.charger.charges_received = 0;
        staff_upgraded.charger.is_inserted = 0;
        staff_upgraded.charger.is_charged = 0;
        staff_upgraded.prev_ammo_clip = weaponclipsize( staff_upgraded.weapname );
        staff_upgraded.prev_ammo_stock = weaponmaxammo( staff_upgraded.weapname );
        staff_upgraded thread place_staffs_encasement();
        staff_upgraded ghost();
    }

    foreach ( staff in level.a_elemental_staffs )
    {
        staff.prev_ammo_clip = weaponclipsize( staff.weapname );
        staff.prev_ammo_stock = weaponmaxammo( staff.weapname );
        staff.upgrade.downgrade = staff;
        staff.upgrade useweaponmodel( staff.weapname );
        staff.upgrade showallparts();
    }

    level.staffs_charged = 0;
    array_thread( level.zombie_spawners, ::add_spawn_function, ::zombie_spawn_func );
    level thread watch_for_staff_upgrades();
    level thread chambers_init();
    level thread maps\mp\zm_tomb_quest_air::main();
    level thread maps\mp\zm_tomb_quest_fire::main();
    level thread maps\mp\zm_tomb_quest_ice::main();
    level thread maps\mp\zm_tomb_quest_elec::main();
    level thread maps\mp\zm_tomb_quest_crypt::main();
    level thread maps\mp\zm_tomb_chamber::main();
    level thread maps\mp\zm_tomb_vo::watch_occasional_line( "puzzle", "puzzle_confused", "vo_puzzle_confused" );
    level thread maps\mp\zm_tomb_vo::watch_occasional_line( "puzzle", "puzzle_good", "vo_puzzle_good" );
    level thread maps\mp\zm_tomb_vo::watch_occasional_line( "puzzle", "puzzle_bad", "vo_puzzle_bad" );
    level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_clue( "vox_sam_ice_staff_clue_0", "sam_clue_dig", "elemental_staff_water_all_pieces_found" );
    level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_clue( "vox_sam_fire_staff_clue_0", "sam_clue_mechz", "mechz_killed" );
    level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_clue( "vox_sam_fire_staff_clue_1", "sam_clue_biplane", "biplane_down" );
    level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_clue( "vox_sam_fire_staff_clue_2", "sam_clue_zonecap", "staff_piece_capture_complete" );
    level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_clue( "vox_sam_lightning_staff_clue_0", "sam_clue_tank", "elemental_staff_lightning_all_pieces_found" );
    level thread maps\mp\zm_tomb_vo::watch_one_shot_samantha_clue( "vox_sam_wind_staff_clue_0", "sam_clue_giant", "elemental_staff_air_all_pieces_found" );
    level.dig_spawners = getentarray( "zombie_spawner_dig", "script_noteworthy" );
    array_thread( level.dig_spawners, ::add_spawn_function, ::dug_zombie_spawn_init );
}

zombie_spawn_func()
{
    self.actor_killed_override = ::zombie_killed_override;
}

zombie_killed_override( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime )
{
    if ( flag( "ee_sam_portal_active" ) && !flag( "ee_souls_absorbed" ) )
    {
        maps\mp\zm_tomb_ee_main_step_7::ee_zombie_killed_override( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime );
        return;
    }

    if ( maps\mp\zm_tomb_challenges::footprint_zombie_killed( attacker ) )
        return;

    n_max_dist_sq = 9000000;

    if ( isplayer( attacker ) || sweapon == "one_inch_punch_zm" )
    {
        if ( !flag( "fire_puzzle_1_complete" ) )
            maps\mp\zm_tomb_quest_fire::sacrifice_puzzle_zombie_killed( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime );

        s_nearest_staff = undefined;
        n_nearest_dist_sq = n_max_dist_sq;

        foreach ( staff in level.a_elemental_staffs )
        {
            if ( isdefined( staff.charger.full ) && staff.charger.full )
                continue;

            if ( staff.charger.is_inserted || staff.upgrade.charger.is_inserted )
            {
                dist_sq = distance2dsquared( self.origin, staff.origin );

                if ( dist_sq <= n_nearest_dist_sq )
                {
                    n_nearest_dist_sq = dist_sq;
                    s_nearest_staff = staff;
                }
            }
        }

        if ( isdefined( s_nearest_staff ) && !isSubStr(sweapon, "staff") )
        {
            s_nearest_staff.charger.charges_received++;
            s_nearest_staff.charger thread zombie_soul_to_charger( self, s_nearest_staff.enum );
        }
    }
}

place_staff_in_charger()
{
    flag_set( "charger_ready_" + self.enum );
    v_trigger_pos = self.charger.origin;
    v_trigger_pos = ( v_trigger_pos[0], v_trigger_pos[1], v_trigger_pos[2] - 30.0 );

    if ( !isDefined( self.charge_trigger ) )
    {
        self.charge_trigger = tomb_spawn_trigger_radius( v_trigger_pos, 120, 1, ::staff_charger_get_player_msg );
        self.charge_trigger.require_look_at = 1;
        self.charge_trigger.staff_data = self;
    }

    self.trigger set_unitrigger_hint_string( "" );
    insert_message = self staff_get_insert_message();
    self.charge_trigger set_unitrigger_hint_string( insert_message );
    self.charge_trigger trigger_on();

    waittill_staff_inserted();
}

waittill_staff_inserted()
{
    while ( true )
    {
        self.charge_trigger waittill( "trigger", player );

        weapon_available = 1;

        if ( isdefined( player ) )
        {
            weapon_available = player getcurrentweapon() == self.weapname;

            if ( weapon_available )
                player takeweapon( self.weapname );
        }

        if ( weapon_available )
        {
            self.charger.is_inserted = 1;
            self thread debug_staff_charge();
            maps\mp\zm_tomb_craftables::clear_player_staff( self.weapname );
            self.charge_trigger set_unitrigger_hint_string( "" );
            self.charge_trigger trigger_off();

            if ( isdefined( self.charger.angles ) )
                self.angles = self.charger.angles;

            self moveto( self.charger.origin, 0.05 );

            self waittill( "movedone" );

            self setclientfield( "staff_charger", self.enum );
            self.charger.full = 0;
            self show();
            self playsound( "zmb_squest_charge_place_staff" );
            return;
        }
        else
        {
            self.charge_trigger thread insert_staff_hint_charger(player, self.enum);
        }
    }
}

watch_for_player_pickup_staff()
{
    staff_picked_up = 0;
    pickup_message = self staff_get_pickup_message();
    self.trigger set_unitrigger_hint_string( pickup_message );
    self show();
    self.trigger trigger_on();

    while ( !staff_picked_up )
    {
        self.trigger waittill( "trigger", player );

        self notify( "retrieved", player );

        if ( player can_pickup_staff() )
        {
            weapon_drop = player getcurrentweapon();
            a_weapons = player getweaponslistprimaries();
            n_max_other_weapons = get_player_weapon_limit( player ) - 1;

            if ( issubstr( weapon_drop, "staff" ) )
            {
                n_index = get_staff_enum_from_element_weapon( weapon_drop );
                e_staff_standard = get_staff_info_from_element_index( n_index );
                e_staff_standard_upgraded = e_staff_standard.upgrade;
                e_staff_standard_upgraded.charge_trigger notify( "trigger", player );
            }
            else if ( a_weapons.size > n_max_other_weapons )
            {
                player takeweapon( weapon_drop );
            }

            player thread watch_staff_ammo_reload();
            self ghost();
            self setinvisibletoall();
            player giveweapon( self.weapname );
            player switchtoweapon( self.weapname );
            clip_size = weaponclipsize( self.weapname );
            player setweaponammoclip( self.weapname, clip_size );
            player givemaxammo( self.weapname );
            player givemaxammo( "staff_revive_zm" );
            self.owner = player;
            level notify( "stop_staff_sound" );
            self notify( "staff_equip" );
            staff_picked_up = 1;
            self.charger.is_inserted = 0;
            self setclientfield( "staff_charger", 0 );
            self.charger.full = 1;
            maps\mp\zm_tomb_craftables::set_player_staff( self.weapname, player );
        }
        else
        {
            self.trigger thread swap_staff_hint_charger(player);
        }
    }
}

get_staff_enum_from_element_weapon(weapon_drop)
{
    if (isSubStr(weapon_drop, "fire"))
    {
        return 1;
    }
    else if (isSubStr(weapon_drop, "air"))
    {
        return 2;
    }
    else if (isSubStr(weapon_drop, "lightning"))
    {
        return 3;
    }
    else if (isSubStr(weapon_drop, "water"))
    {
        return 4;
    }

    return 1;
}

can_pickup_staff()
{
    if ( is_melee_weapon( self getcurrentweapon() ) || is_placeable_mine( self getcurrentweapon() ) )
    {
        return 0;
    }

    b_has_staff = self player_has_staff();
    b_staff_equipped = issubstr( self getcurrentweapon(), "staff" ) && self getcurrentweapon() != "staff_revive_zm";

    return !b_has_staff || b_staff_equipped;
}

insert_staff_hint_charger(player, enum)
{
    num = player getentitynumber();

    self.playertrigger[num] notify("insert_staff_hint_charger");
    self.playertrigger[num] endon("insert_staff_hint_charger");
    self.playertrigger[num] endon("death");

    element = "";
    if (enum == 1)
    {
        element = "Fire";
    }
    else if (enum == 2)
    {
        element = "Wind";
    }
    else if (enum == 3)
    {
        element = "Lightning";
    }
    else if (enum == 4)
    {
        element = "Ice";
    }

    self.playertrigger[num] sethintstring(element + " Staff Required");

    wait 3;

    self.playertrigger[num] sethintstring(self.hint_string);
}

swap_staff_hint_charger(player)
{
    num = player getentitynumber();

    self.playertrigger[num] notify("swap_staff_hint_charger");
    self.playertrigger[num] endon("swap_staff_hint_charger");
    self.playertrigger[num] endon("death");

    self.playertrigger[num] sethintstring(&"ZM_TOMB_OSO");

    wait 3;

    self.playertrigger[num] sethintstring(self.hint_string);
}

staff_upgraded_reload()
{
    self endon( "staff_equip" );

    clip_size = weaponclipsize( self.weapname );
    max_ammo = weaponmaxammo( self.weapname );
    revive_max_ammo = weaponmaxammo( "staff_revive_zm" );
    n_count = int( max_ammo / 20 );
    b_reloaded = 0;

    while ( true )
    {
        if ( self.prev_ammo_clip < clip_size )
        {
            clip_add = clip_size - self.prev_ammo_clip;

            if (clip_add > self.prev_ammo_stock)
            {
                clip_add = self.prev_ammo_stock;
            }

            self.prev_ammo_clip += clip_add;
            self.prev_ammo_stock -= clip_add;
        }

        if ( self.revive_ammo_clip < 1 && self.revive_ammo_stock >= 1 )
        {
            self.revive_ammo_clip += 1;
            self.revive_ammo_stock -= 1;
        }

        if ( self.prev_ammo_stock >= max_ammo && self.revive_ammo_stock >= revive_max_ammo )
        {
            self.prev_ammo_stock = max_ammo;
            self.revive_ammo_stock = revive_max_ammo;
            self setclientfield( "staff_charger", 0 );
            self.charger.full = 1;
            self thread staff_glow_fx();
        }

        self.charger waittill( "soul_received" );

        self.prev_ammo_stock += n_count;
        self.revive_ammo_stock += 1;
    }
}

staff_glow_fx()
{
    e_staff_standard = get_staff_info_from_element_index( self.enum );

    if (isDefined(e_staff_standard.e_fx))
    {
        return;
    }

    e_staff_standard.e_fx = spawn( "script_model", e_staff_standard.upgrade.origin + vectorscale( ( 0, 0, 1 ), 8.0 ) );
    e_staff_standard.e_fx setmodel( "tag_origin" );
    e_staff_standard.e_fx setclientfield( "element_glow_fx", e_staff_standard.upgrade.enum );

    self waittill( "staff_equip" );

    e_staff_standard.e_fx delete();
}

chambers_init()
{
    flag_init( "gramophone_placed" );
    array_thread( getentarray( "trigger_death_floor", "targetname" ), ::monitor_chamber_death_trigs );
    a_stargate_gramophones = getstructarray( "stargate_gramophone_pos", "targetname" );
    array_thread( a_stargate_gramophones, ::run_gramophone_teleporter );
    a_door_main = getentarray( "chamber_entrance", "targetname" );
    array_thread( a_door_main, ::run_gramophone_door, "vinyl_master" );
}

run_gramophone_teleporter( str_vinyl_record )
{
    self.has_vinyl = 0;
    self.gramophone_model = undefined;
    self thread watch_gramophone_vinyl_pickup();
    t_gramophone = tomb_spawn_trigger_radius( self.origin, 60.0, 1 );
    t_gramophone set_unitrigger_hint_string( &"ZM_TOMB_PLGR" );

    if (!isDefined(level.gramophone_teleporter_triggers))
    {
        level.gramophone_teleporter_triggers = [];
    }

    level.gramophone_teleporter_triggers[level.gramophone_teleporter_triggers.size] = t_gramophone;

    level waittill( "gramophone_vinyl_player_picked_up" );

    while ( true )
    {
        t_gramophone waittill( "trigger", player );

        if ( !isdefined( self.gramophone_model ) )
        {
            if ( !flag( "gramophone_placed" ) )
            {
                self.gramophone_model = spawn( "script_model", self.origin );
                self.gramophone_model.angles = self.angles;
                self.gramophone_model setmodel( "p6_zm_tm_gramophone" );
                //level setclientfield( "piece_record_zm_player", 0 );
                flag_set( "gramophone_placed" );

                foreach (trigger in level.gramophone_teleporter_triggers)
                {
                    if (trigger != t_gramophone)
                    {
                        trigger set_unitrigger_hint_string( &"ZM_TOMB_GREL" );
                    }
                }

                t_gramophone set_unitrigger_hint_string( "" );
                t_gramophone trigger_off();
                str_song_id = self get_gramophone_song();
                self.gramophone_model playsound( str_song_id );
                player thread maps\mp\zm_tomb_vo::play_gramophone_place_vo();
                maps\mp\zm_tomb_teleporter::stargate_teleport_enable( self.script_int );
                flag_wait( "teleporter_building_" + self.script_int );
                flag_waitopen( "teleporter_building_" + self.script_int );
                t_gramophone trigger_on();
                t_gramophone set_unitrigger_hint_string( &"ZM_TOMB_PUGR" );

                if ( isdefined( self.script_flag ) )
                    flag_set( self.script_flag );
            }
            else
            {
                t_gramophone set_unitrigger_hint_string( &"ZM_TOMB_GREL" );
            }
        }
        else
        {
            self.gramophone_model stopsounds();
            self.gramophone_model ghost();
            player playsound( "zmb_craftable_pickup" );
            flag_clear( "gramophone_placed" );
            //level setclientfield( "piece_record_zm_player", 1 );
            break;
        }
    }

    arrayremovevalue(level.gramophone_teleporter_triggers, t_gramophone);
    foreach (trigger in level.gramophone_teleporter_triggers)
    {
        if (trigger != t_gramophone)
        {
            trigger set_unitrigger_hint_string( &"ZM_TOMB_PLGR" );
        }
    }

    t_gramophone tomb_unitrigger_delete();

    wait 0.05;

    self.gramophone_model delete();
    self.gramophone_model = undefined;
}

run_gramophone_door( str_vinyl_record )
{
    flag_init( self.targetname + "_opened" );
    trig_position = getstruct( self.targetname + "_position", "targetname" );
    trig_position.has_vinyl = 0;
    trig_position.gramophone_model = undefined;
    trig_position.script_int = randomIntRange(1, 5);
    trig_position thread watch_gramophone_vinyl_pickup();
    trig_position thread door_watch_open_sesame();
    t_door = tomb_spawn_trigger_radius( trig_position.origin, 60.0, 1 );
    t_door set_unitrigger_hint_string( &"ZM_TOMB_PLGR" );
    level waittill_any( "gramophone_vinyl_player_picked_up", "open_sesame", "open_all_gramophone_doors" );
    trig_position.trigger = t_door;

    while ( !trig_position.has_vinyl )
        wait 0.05;

    t_door.initial_placed = 1;
    trig_position.gramophone_model = spawn( "script_model", trig_position.origin );
    trig_position.gramophone_model.angles = trig_position.angles;
    trig_position.gramophone_model setmodel( "p6_zm_tm_gramophone" );
    flag_set( "gramophone_placed" );
    //level setclientfield( "piece_record_zm_player", 0 );

    foreach (trigger in level.gramophone_teleporter_triggers)
    {
        trigger set_unitrigger_hint_string( &"ZM_TOMB_GREL" );
    }

    while ( true )
    {
        t_door waittill( "trigger", player );

        if ( is_true( t_door.initial_placed ) )
        {
            t_door.initial_placed = 0;
            t_door set_unitrigger_hint_string( "" );
            t_door trigger_off();
            str_song = trig_position get_gramophone_song();
            trig_position.gramophone_model playsound(str_song);

            self playsound( "zmb_crypt_stairs" );
            wait 6.0;
            chamber_blocker();
            flag_set( self.targetname + "_opened" );

            if ( isdefined( trig_position.script_flag ) )
                flag_set( trig_position.script_flag );

            level setclientfield( "crypt_open_exploder", 1 );
            self movez( -260, 10.0, 1.0, 1.0 );

            self waittill( "movedone" );

            self connectpaths();
            self delete();
            t_door trigger_on();
            t_door set_unitrigger_hint_string( &"ZM_TOMB_PUGR" );
        }
        else
        {
            trig_position.gramophone_model stopsounds();
            trig_position.gramophone_model ghost();
            flag_clear( "gramophone_placed" );
            player playsound( "zmb_craftable_pickup" );
            //level setclientfield( "piece_record_zm_player", 1 );
            break;
        }
    }

    foreach (trigger in level.gramophone_teleporter_triggers)
    {
        trigger set_unitrigger_hint_string( &"ZM_TOMB_PLGR" );
    }

    t_door tomb_unitrigger_delete();
    trig_position.trigger = undefined;

    wait 0.05;

    trig_position.gramophone_model delete();
    trig_position.gramophone_model = undefined;
}

watch_staff_ammo_reload()
{
    // removed max ammo clip fill
}