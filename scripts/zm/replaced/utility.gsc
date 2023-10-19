#include maps\mp\zombies\_load;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;

struct_class_init()
{
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_linkname" ] = [];
	level.struct_class_names[ "script_unitrigger_type" ] = [];
	foreach ( s_struct in level.struct )
	{
		if ( isDefined( s_struct.targetname ) )
		{
			if ( !isDefined( level.struct_class_names[ "targetname" ][ s_struct.targetname ] ) )
			{
				level.struct_class_names[ "targetname" ][ s_struct.targetname ] = [];
			}
			size = level.struct_class_names[ "targetname" ][ s_struct.targetname ].size;
			level.struct_class_names[ "targetname" ][ s_struct.targetname ][ size ] = s_struct;
		}
		if ( isDefined( s_struct.target ) )
		{
			if ( !isDefined( level.struct_class_names[ "target" ][ s_struct.target ] ) )
			{
				level.struct_class_names[ "target" ][ s_struct.target ] = [];
			}
			size = level.struct_class_names[ "target" ][ s_struct.target ].size;
			level.struct_class_names[ "target" ][ s_struct.target ][ size ] = s_struct;
		}
		if ( isDefined( s_struct.script_noteworthy ) )
		{
			if ( !isDefined( level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] ) )
			{
				level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] = [];
			}
			size = level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ].size;
			level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ][ size ] = s_struct;
		}
		if ( isDefined( s_struct.script_linkname ) )
		{
			level.struct_class_names[ "script_linkname" ][ s_struct.script_linkname ][ 0 ] = s_struct;
		}
		if ( isDefined( s_struct.script_unitrigger_type ) )
		{
			if ( !isDefined( level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] ) )
			{
				level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] = [];
			}
			size = level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ].size;
			level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ][ size ] = s_struct;
		}
	}
	gametype = getDvar( "g_gametype" );
	location = getDvar( "ui_zm_mapstartlocation" );
	if ( array_validate( level.add_struct_gamemode_location_funcs ) )
	{
		if ( array_validate( level.add_struct_gamemode_location_funcs[ gametype ] ) )
		{
			if ( array_validate( level.add_struct_gamemode_location_funcs[ gametype ][ location ] ) )
			{
				for ( i = 0; i < level.add_struct_gamemode_location_funcs[ gametype ][ location ].size; i++ )
				{
					[[ level.add_struct_gamemode_location_funcs[ gametype ][ location ][ i ] ]]();
				}
			}
		}
	}
}

add_struct( s_struct )
{
	if ( isDefined( s_struct.targetname ) )
	{
		if ( !isDefined( level.struct_class_names[ "targetname" ][ s_struct.targetname ] ) )
		{
			level.struct_class_names[ "targetname" ][ s_struct.targetname ] = [];
		}
		size = level.struct_class_names[ "targetname" ][ s_struct.targetname ].size;
		level.struct_class_names[ "targetname" ][ s_struct.targetname ][ size ] = s_struct;
	}
	if ( isDefined( s_struct.script_noteworthy ) )
	{
		if ( !isDefined( level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] ) )
		{
			level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] = [];
		}
		size = level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ].size;
		level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ][ size ] = s_struct;
	}
	if ( isDefined( s_struct.target ) )
	{
		if ( !isDefined( level.struct_class_names[ "target" ][ s_struct.target ] ) )
		{
			level.struct_class_names[ "target" ][ s_struct.target ] = [];
		}
		size = level.struct_class_names[ "target" ][ s_struct.target ].size;
		level.struct_class_names[ "target" ][ s_struct.target ][ size ] = s_struct;
	}
	if ( isDefined( s_struct.script_linkname ) )
	{
		level.struct_class_names[ "script_linkname" ][ s_struct.script_linkname ][ 0 ] = s_struct;
	}
	if ( isDefined( s_struct.script_unitrigger_type ) )
	{
		if ( !isDefined( level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] ) )
		{
			level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] = [];
		}
		size = level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ].size;
		level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ][ size ] = s_struct;
	}
}

register_perk_struct( name, model, origin, angles )
{
	perk_struct = spawnStruct();
	perk_struct.targetname = "zm_perk_machine";
	perk_struct.origin = origin;
	perk_struct.angles = angles;
	perk_struct.script_noteworthy = name;
	perk_struct.model = model;

	if ( name == "specialty_weapupgrade" )
	{
		flag_struct = spawnStruct();
		flag_struct.targetname = "weapupgrade_flag_targ";
		flag_struct.origin = origin + ( anglesToForward( angles ) * 29 ) + ( anglesToRight( angles ) * -13.5 ) + ( anglesToUp( angles ) * 49.5 );
		flag_struct.angles = angles + ( 0, 180, 180 );
		flag_struct.model = "zombie_sign_please_wait";
		perk_struct.target = flag_struct.targetname;

		add_struct( flag_struct );
	}

	add_struct( perk_struct );
}

register_map_spawn_point( origin, zone, dist )
{
	spawn_point_struct = spawnStruct();
	spawn_point_struct.targetname = "player_respawn_point";
	spawn_point_struct.origin = origin;
	spawn_point_struct.locked = !zone_is_enabled( zone );
	spawn_point_struct.script_int = dist;
	spawn_point_struct.script_noteworthy = zone;
	spawn_point_struct.script_string = getDvar( "g_gametype" ) + "_" + getDvar( "ui_zm_mapstartlocation" );
	spawn_point_struct.target = zone + "_player_spawns";

	add_struct( spawn_point_struct );
}

register_map_spawn( origin, angles, zone, team_num )
{
	spawn_struct = spawnStruct();
	spawn_struct.targetname = zone + "_player_spawns";
	spawn_struct.origin = origin;
	spawn_struct.angles = angles;
	spawn_struct.script_string = getDvar( "g_gametype" ) + "_" + getDvar( "ui_zm_mapstartlocation" );

	if ( isDefined( team_num ) )
	{
		spawn_struct.script_noteworthy = "initial_spawn";
		spawn_struct.script_int = team_num;
	}

	add_struct( spawn_struct );
}

wallbuy( weapon_name, target, targetname, origin, angles, play_chalk_fx = 1 )
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = origin;
	unitrigger_stub.angles = angles;

	model_name = undefined;
	if ( weapon_name == "sticky_grenade_zm" )
	{
		model_name = "semtex_bag";
	}
	else if ( weapon_name == "claymore_zm" )
	{
		model_name = "t6_wpn_claymore_world";
	}

	wallmodel = spawn_weapon_model( weapon_name, model_name, origin, angles );
	wallmodel.targetname = target;
	wallmodel useweaponhidetags( weapon_name );
	wallmodel hide();

	absmins = wallmodel getabsmins();
	absmaxs = wallmodel getabsmaxs();
	bounds = absmaxs - absmins;

	unitrigger_stub.script_length = 64;
	unitrigger_stub.script_width = bounds[ 1 ];
	unitrigger_stub.script_height = bounds[ 2 ];
	unitrigger_stub.target = target;
	unitrigger_stub.targetname = targetname;
	unitrigger_stub.cursor_hint = "HINT_NOICON";

	// move model forward so it always shows in front of chalk
	wallmodel.origin += anglesToRight( wallmodel.angles ) * -0.3;
	unitrigger_stub.origin += anglesToRight( wallmodel.angles ) * -0.3;

	if ( unitrigger_stub.targetname == "weapon_upgrade" )
	{
		unitrigger_stub.cost = get_weapon_cost( weapon_name );
		if ( !is_true( level.monolingustic_prompt_format ) )
		{
			unitrigger_stub.hint_string = get_weapon_hint( weapon_name );
			unitrigger_stub.hint_parm1 = unitrigger_stub.cost;
		}
		else
		{
			unitrigger_stub.hint_parm1 = get_weapon_display_name( weapon_name );
			if ( !isDefined( unitrigger_stub.hint_parm1 ) || unitrigger_stub.hint_parm1 == "" || unitrigger_stub.hint_parm1 == "none" )
			{
				unitrigger_stub.hint_parm1 = "missing weapon name " + weapon_name;
			}
			unitrigger_stub.hint_parm2 = unitrigger_stub.cost;
			unitrigger_stub.hint_string = &"ZOMBIE_WEAPONCOSTONLY";
		}
	}

	unitrigger_stub.weapon_upgrade = weapon_name;
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.require_look_at = 1;
	unitrigger_stub.require_look_from = 0;
	unitrigger_stub.zombie_weapon_upgrade = weapon_name;
	maps\mp\zombies\_zm_unitrigger::unitrigger_force_per_player_triggers( unitrigger_stub, 1 );

	if ( is_melee_weapon( weapon_name ) )
	{
		melee_weapon = undefined;
		foreach(melee_weapon in level._melee_weapons)
		{
			if(melee_weapon.weapon_name == weapon_name)
			{
				break;
			}
		}

		if(isDefined(melee_weapon))
		{
			unitrigger_stub.cost = melee_weapon.cost;
			unitrigger_stub.hint_string = melee_weapon.hint_string;
			unitrigger_stub.weapon_name = melee_weapon.weapon_name;
			unitrigger_stub.flourish_weapon_name = melee_weapon.flourish_weapon_name;
			unitrigger_stub.ballistic_weapon_name = melee_weapon.ballistic_weapon_name;
			unitrigger_stub.ballistic_upgraded_weapon_name = melee_weapon.ballistic_upgraded_weapon_name;
			unitrigger_stub.vo_dialog_id = melee_weapon.vo_dialog_id;
			unitrigger_stub.flourish_fn = melee_weapon.flourish_fn;

			if(is_true(level.disable_melee_wallbuy_icons))
			{
				unitrigger_stub.cursor_hint = "HINT_NOICON";
				unitrigger_stub.cursor_hint_weapon = undefined;
			}
			else
			{
				unitrigger_stub.cursor_hint = "HINT_WEAPON";
				unitrigger_stub.cursor_hint_weapon = melee_weapon.weapon_name;
			}
		}

		if(weapon_name == "tazer_knuckles_zm")
		{
			unitrigger_stub.origin += (anglesToForward(angles) * -7) + (anglesToRight(angles) * -2);
		}

		wallmodel.origin += anglesToForward(angles) * -8; // _zm_melee_weapon::melee_weapon_show moves this back

		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( unitrigger_stub, ::melee_weapon_think );
	}
	else if ( weapon_name == "claymore_zm" )
	{
		wallmodel.angles += (0, 90, 0);
		wallmodel.script_int = 90; // fix for model sliding right to left

		unitrigger_stub.prompt_and_visibility_func = scripts\zm\replaced\_zm_weap_claymore::claymore_unitrigger_update_prompt;
		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( unitrigger_stub, scripts\zm\replaced\_zm_weap_claymore::buy_claymores );
	}
	else
	{
		if( is_lethal_grenade( unitrigger_stub.zombie_weapon_upgrade ) )
			unitrigger_stub.prompt_and_visibility_func = scripts\zm\replaced\_zm_weapons::lethal_grenade_update_prompt;
		else
			unitrigger_stub.prompt_and_visibility_func = ::wall_weapon_update_prompt;

		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( unitrigger_stub, ::weapon_spawn_think );
	}

	if(weaponType(weapon_name) == "grenade")
	{
		unitrigger_stub thread wallbuy_grenade_model_fix();
	}

	if (play_chalk_fx)
	{
		chalk_fx = weapon_name + "_fx";
		level thread playchalkfx( chalk_fx, origin, angles );
	}
}

playchalkfx( effect, origin, angles )
{
	while ( 1 )
	{
		fx = SpawnFX( level._effect[ effect ], origin, AnglesToForward( angles ), AnglesToUp( angles ) );
		TriggerFX( fx );
		level waittill( "connected", player );
		fx Delete();
	}
}


// fixes grenade wallbuy model doing first trigger animation everytime
wallbuy_grenade_model_fix()
{
	model = getent(self.target, "targetname");
	if(!isDefined(model))
	{
		return;
	}

	model waittill("movedone");

	self.target = undefined;
}

barrier( model, origin, angles, not_solid )
{
	if ( !isDefined( level.survival_barriers ) )
	{
		level.survival_barriers = [];
		level.survival_barriers_index = 0;
	}
	level.survival_barriers[ level.survival_barriers_index ] = spawn( "script_model", origin );
	level.survival_barriers[ level.survival_barriers_index ] setModel( model );
	level.survival_barriers[ level.survival_barriers_index ] rotateTo( angles, 0.1 );
	if ( is_true( not_solid ) )
	{
		level.survival_barriers[ level.survival_barriers_index ] notSolid();
	}
	level.survival_barriers_index++;
}

add_struct_location_gamemode_func( gametype, location, func )
{
	if ( !isDefined( level.add_struct_gamemode_location_funcs ) )
	{
		level.add_struct_gamemode_location_funcs = [];
	}
	if ( !isDefined( level.add_struct_gamemode_location_funcs[ gametype ] ) )
	{
		level.add_struct_gamemode_location_funcs[ gametype ] = [];
	}
	if ( !isDefined( level.add_struct_gamemode_location_funcs[ gametype ][ location ] ) )
	{
		level.add_struct_gamemode_location_funcs[ gametype ][ location ] = [];
	}
	level.add_struct_gamemode_location_funcs[ gametype ][ location ][ level.add_struct_gamemode_location_funcs[ gametype ][ location ].size ] = func;
}