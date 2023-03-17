#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_prison;
#include maps\mp\zombies\_zm_zonemgr;
#include scripts\zm\locs\loc_common;

struct_init()
{
    level.struct_class_names[ "targetname" ][ "zm_perk_machine" ] = [];

	scripts\zm\replaced\utility::register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 473.92, 6638.99, 208 ), ( 0, 102, 0 ) );
    scripts\zm\replaced\utility::register_perk_struct( "specialty_weapupgrade", "p6_zm_al_vending_pap_on", ( -1769, 5391, -72 ), ( 0, 100, 0 ) );

    ind = 0;
    respawnpoints = getstructarray( "player_respawn_point", "targetname" );
    for(i = 0; i < respawnpoints.size; i++)
    {
        if(respawnpoints[i].script_noteworthy == "zone_dock")
        {
            ind = i;
            break;
        }
    }

	level.struct_class_names[ "script_noteworthy" ][ "initial_spawn" ] = [];

	respawn_array = getstructarray(respawnpoints[ind].target, "targetname");
    i = 0;
    foreach(respawn in respawn_array)
    {
        if (respawn.origin == (-664, 5944, 0))
        {
            continue;
        }

        script_int = int(i / 2) + 1;

        origin = respawn.origin + (anglesToRight(respawn.angles) * 32);
		angles = respawn.angles;

        scripts\zm\replaced\utility::register_map_initial_spawnpoint( origin, angles, script_int );

		origin = respawn.origin + (anglesToRight(respawn.angles) * -32);
		angles = respawn.angles;

        scripts\zm\replaced\utility::register_map_initial_spawnpoint( origin, angles, script_int );

        i++;
    }
}

precache()
{
	setdvar( "disableLookAtEntityLogic", 1 );
	level.chests = [];
	level.chests[0] = getstruct( "dock_chest", "script_noteworthy" );
}

main()
{
    flag_set("gondola_roof_to_dock");
    init_wallbuys();
    init_barriers();
    set_box_weapons();
    disable_zombie_spawn_locations();
    disable_player_spawn_locations();
    create_key_door_unitrigger( 4, 98, 112, 108 );
    level thread open_inner_gate();
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects( "cellblock" );
	maps\mp\zombies\_zm_magicbox::treasure_chest_init( "dock_chest" );
	precacheshader( "zm_al_wth_zombie" );
	array_thread( level.zombie_spawners, ::add_spawn_function, maps\mp\zm_alcatraz_grief_cellblock::remove_zombie_hats_for_grief );
	maps\mp\zombies\_zm_ai_brutus::precache();
	maps\mp\zombies\_zm_ai_brutus::init();
	level._effect["butterflies"] = loadfx( "maps/zombie_alcatraz/fx_alcatraz_skull_elec" );
	scripts\zm\locs\loc_common::init();
    level thread maps\mp\zm_alcatraz_traps::init_tower_trap_trigs();
}

set_box_weapons()
{
    if(isDefined(level.zombie_weapons["thompson_zm"]))
	{
		level.zombie_weapons["thompson_zm"].is_in_box = 0;
	}
	if(isDefined(level.zombie_weapons["beretta93r_zm"]))
	{
		level.zombie_weapons["beretta93r_zm"].is_in_box = 1;
	}
}

init_wallbuys()
{
    scripts\zm\replaced\utility::wallbuy( "m14_zm", "m14", "weapon_upgrade", ( 305, 6376, 319 ), ( 0, -80, 0 ) );
    scripts\zm\replaced\utility::wallbuy( "rottweil72_zm", "olympia", "weapon_upgrade", ( -709, 5721, -19.875 ), ( 0, -80, 30 ) );
	scripts\zm\replaced\utility::wallbuy( "uzi_zm", "uzi", "weapon_upgrade", ( -219, 7156, 122 ), ( 0, 190, 0 ) );
}

init_barriers()
{
    // left
    model = spawn( "script_model", (-90.4585, 7669.56, 114.511));
    model.angles = (90, -10, 55);
    model setmodel("p6_zm_al_horrific_bed_mattress_3");
    model = spawn( "script_model", (-111.549, 7667.96, 97.125));
    model.angles = (0, 0, 90);
    model setmodel("zm_al_kitchen_table_01");
    model = spawn( "script_model", (-113.959, 7638.7, 75.0369));
    model.angles = (6, 0, -6);
    model setmodel("afr_corrugated_metal4x8_holes");
    model = spawn( "script_model", (-106.911, 7636.47, 64.125));
    model.angles = (0, 0, 0);
    model setmodel("collision_clip_wall_128x128x10");

    // right
    model = spawn( "script_model", (48.6213, 7639.88, 74.125));
    model.angles = (22, -44, 0);
    model setmodel("p6_zm_al_infirmary_case");
    model = spawn( "script_model", (44.9895, 7601.56, 81.125));
    model.angles = (-5, -41, -8);
    model setmodel("afr_corrugated_metal4x8_holes");
    model = spawn( "script_model", (98.769, 7602.89, 64.125));
    model.angles = (0, -142, 0);
    model setmodel("p6_zm_al_desk_small");
    model = spawn( "script_model", (43.2479, 7606.2, 66.125));
    model.angles = (0, -45, 0);
    model setmodel("collision_clip_wall_128x128x10");
}

disable_zombie_spawn_locations()
{
	for ( z = 0; z < level.zone_keys.size; z++ )
	{
        zone = level.zones[ level.zone_keys[ z ] ];

        i = 0;
        while ( i < zone.spawn_locations.size )
        {
            if (zone.spawn_locations[i].origin == (615.8, 7875.9, 95))
            {
                zone.spawn_locations[i].is_enabled = false;
            }
            else if (zone.spawn_locations[i].origin == (663.8, 7827.9, 95))
            {
                zone.spawn_locations[i].is_enabled = false;
            }

            i++;
        }
	}
}

disable_player_spawn_locations()
{
    spawn_points = getstructarray( "player_respawn_point", "targetname" );
    foreach(spawn_point in spawn_points)
    {
        if(spawn_point.script_noteworthy == "zone_citadel_basement")
        {
            spawn_point.script_noteworthy = "none";
        }
    }
}

create_key_door_unitrigger( piece_num, width, height, length )
{
    t_key_door = getstruct( "key_door_" + piece_num + "_trigger", "targetname" );
    t_key_door.unitrigger_stub = spawnstruct();
    t_key_door.unitrigger_stub.origin = t_key_door.origin;
    t_key_door.unitrigger_stub.angles = t_key_door.angles;
    t_key_door.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
    t_key_door.unitrigger_stub.hint_string = &"ZM_PRISON_KEY_DOOR_LOCKED";
    t_key_door.unitrigger_stub.cursor_hint = "HINT_NOICON";
    t_key_door.unitrigger_stub.script_width = width;
    t_key_door.unitrigger_stub.script_height = height;
    t_key_door.unitrigger_stub.script_length = length;
    t_key_door.unitrigger_stub.n_door_index = piece_num;
    t_key_door.unitrigger_stub.require_look_at = 0;
    t_key_door.unitrigger_stub.prompt_and_visibility_func = ::key_door_trigger_visibility;
    t_key_door.unitrigger_stub.cost = 2000;
    maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( t_key_door.unitrigger_stub, ::master_key_door_trigger_thread );
}

key_door_trigger_visibility( player )
{
    b_is_invis = player.afterlife || isdefined( self.stub.master_key_door_opened ) && self.stub.master_key_door_opened || self.stub.n_door_index == 2 && !flag( "generator_challenge_completed" );
    self setinvisibletoplayer( player, b_is_invis );

    self sethintstring( &"ZOMBIE_BUTTON_BUY_OPEN_DOOR_2000" );

    return !b_is_invis;
}

master_key_door_trigger_thread()
{
    self endon( "death" );
    self endon( "kill_trigger" );
    n_door_index = self.stub.n_door_index;
    b_door_open = 0;

    while ( !b_door_open )
    {
        self waittill( "trigger", e_triggerer );

        if ( is_player_valid(e_triggerer) && e_triggerer.score >= self.stub.cost )
        {
            e_triggerer maps\mp\zombies\_zm_score::minus_to_player_score( self.stub.cost );
			e_triggerer play_sound_on_ent( "purchase" );

            self.stub.master_key_door_opened = 1;
            self.stub maps\mp\zombies\_zm_unitrigger::run_visibility_function_for_all_triggers();
            level thread open_custom_door_master_key( n_door_index, e_triggerer );
            self playsound( "evt_quest_door_open" );
            b_door_open = 1;
        }
    }

    level thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.stub );
}

open_custom_door_master_key( n_door_index, e_triggerer )
{
    m_lock = getent( "masterkey_lock_" + n_door_index, "targetname" );
    m_lock playsound( "zmb_quest_key_unlock" );
    playfxontag( level._effect["fx_alcatraz_unlock_door"], m_lock, "tag_origin" );
    wait 0.5;
    m_lock delete();

    m_gate_01 = getent( "cable_puzzle_gate_01", "targetname" );
    m_gate_01 moveto( m_gate_01.origin + ( -16, 80, 0 ), 0.5 );
    m_gate_01 connectpaths();
    gate_1_monsterclip = getent( "docks_gate_1_monsterclip", "targetname" );
    gate_1_monsterclip.origin += vectorscale( ( 0, 0, 1 ), 256.0 );
    gate_1_monsterclip disconnectpaths();
    gate_1_monsterclip.origin -= vectorscale( ( 0, 0, 1 ), 256.0 );

    if ( isdefined( e_triggerer ) )
        e_triggerer door_rumble_on_open();

    m_gate_01 playsound( "zmb_chainlink_open" );
    flag_set( "docks_inner_gate_unlocked" );
    flag_set( "docks_inner_gate_open" );
}

door_rumble_on_open()
{
    self endon( "disconnect" );
    level endon( "end_game" );
    self setclientfieldtoplayer( "rumble_door_open", 1 );
    wait_network_frame();
    self setclientfieldtoplayer( "rumble_door_open", 0 );
}

open_inner_gate()
{
    m_gate_02 = getent( "cable_puzzle_gate_02", "targetname" );

    m_gate_02 moveto( m_gate_02.origin + ( -16, 80, 0 ), 0.5 );
    wait( 0.75 );
    m_gate_02 connectpaths();
    gate_2_monsterclip = getent( "docks_gate_2_monsterclip", "targetname" );
    gate_2_monsterclip.origin += vectorscale( ( 0, 0, 1 ), 256.0 );
    gate_2_monsterclip disconnectpaths();
    gate_2_monsterclip.origin -= vectorscale( ( 0, 0, 1 ), 256.0 );
    m_gate_02 playsound( "zmb_chainlink_close" );
}