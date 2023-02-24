#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zombies\_zm_buildables;

init_buildables( buildablesenabledlist )
{
	registerclientfield( "scriptmover", "buildable_glint_fx", 12000, 1, "int" );
	precacheitem( "chalk_draw_zm" );
	precacheitem( "no_hands_zm" );
	level._effect[ "wallbuy_replace" ] = loadfx( "maps\zombie_buried\fx_buried_booze_candy_spawn" );
	level._effect[ "wallbuy_drawing" ] = loadfx( "maps\zombie\fx_zmb_wall_dyn_chalk_drawing" );
	level.str_buildables_build = &"ZOMBIE_BUILD_SQ_COMMON";
	level.str_buildables_building = &"ZOMBIE_BUILDING_SQ_COMMON";
	level.str_buildables_grab_part = &"ZOMBIE_BUILD_PIECE_GRAB";
	level.str_buildables_swap_part = &"ZOMBIE_BUILD_PIECE_SWITCH";
	level.safe_place_for_buildable_piece = ::safe_place_for_buildable_piece;
	level.buildable_slot_count = max( 1, 2 ) + 1;
	level.buildable_clientfields = [];
	level.buildable_clientfields[ 0 ] = "buildable";
	level.buildable_clientfields[ 1 ] = "buildable" + "_pu";
	level.buildable_piece_counts = [];
	level.buildable_piece_counts[ 0 ] = 15;
	level.buildable_piece_counts[ 1 ] = 4;
	if ( -1 )
	{
		level.buildable_clientfields[ 2 ] = "buildable" + "_sq";
		level.buildable_piece_counts[ 2 ] = 13;
	}
	if ( isinarray( buildablesenabledlist, "sq_common" ) )
	{
		add_zombie_buildable( "sq_common", level.str_buildables_build, level.str_buildables_building );
	}
	if ( isinarray( buildablesenabledlist, "buried_sq_tpo_switch" ) )
	{
		add_zombie_buildable( "buried_sq_tpo_switch", level.str_buildables_build, level.str_buildables_building );
	}
	if ( isinarray( buildablesenabledlist, "buried_sq_ghost_lamp" ) )
	{
		add_zombie_buildable( "buried_sq_ghost_lamp", level.str_buildables_build, level.str_buildables_building );
	}
	if ( isinarray( buildablesenabledlist, "buried_sq_bt_m_tower" ) )
	{
		add_zombie_buildable( "buried_sq_bt_m_tower", level.str_buildables_build, level.str_buildables_building );
	}
	if ( isinarray( buildablesenabledlist, "buried_sq_bt_r_tower" ) )
	{
		add_zombie_buildable( "buried_sq_bt_r_tower", level.str_buildables_build, level.str_buildables_building );
	}
	if ( isinarray( buildablesenabledlist, "buried_sq_oillamp" ) )
	{
		add_zombie_buildable( "buried_sq_oillamp", level.str_buildables_build, level.str_buildables_building, &"NULL_EMPTY" );
	}
	if ( isinarray( buildablesenabledlist, "turbine" ) )
	{
		add_zombie_buildable( "turbine", level.str_buildables_build, level.str_buildables_building, &"ZOMBIE_BUILD_PIECE_HAVE_ONE" );
		add_zombie_buildable_vox_category( "turbine", "trb" );
	}
	if ( isinarray( buildablesenabledlist, "springpad_zm" ) )
	{
		add_zombie_buildable( "springpad_zm", level.str_buildables_build, level.str_buildables_building, &"ZOMBIE_BUILD_PIECE_HAVE_ONE" );
		add_zombie_buildable_vox_category( "springpad_zm", "stm" );
	}
	if ( isinarray( buildablesenabledlist, "subwoofer_zm" ) )
	{
		add_zombie_buildable( "subwoofer_zm", level.str_buildables_build, level.str_buildables_building, &"ZOMBIE_BUILD_PIECE_HAVE_ONE" );
		add_zombie_buildable_vox_category( "subwoofer_zm", "sw" );
	}
	if ( isinarray( buildablesenabledlist, "headchopper_zm" ) )
	{
		add_zombie_buildable( "headchopper_zm", level.str_buildables_build, level.str_buildables_building, &"ZOMBIE_BUILD_PIECE_HAVE_ONE" );
		add_zombie_buildable_vox_category( "headchopper_zm", "hc" );
	}
	if ( isinarray( buildablesenabledlist, "booze" ) )
	{
		add_zombie_buildable( "booze", &"ZM_BURIED_LEAVE_BOOZE", level.str_buildables_building, &"NULL_EMPTY" );
		add_zombie_buildable_piece_vox_category( "booze", "booze" );
	}
	if ( isinarray( buildablesenabledlist, "candy" ) )
	{
		add_zombie_buildable( "candy", &"ZM_BURIED_LEAVE_CANDY", level.str_buildables_building, &"NULL_EMPTY" );
		add_zombie_buildable_piece_vox_category( "candy", "candy" );
	}
	if ( isinarray( buildablesenabledlist, "chalk" ) )
	{
		add_zombie_buildable( "chalk", &"NULL_EMPTY", level.str_buildables_building, &"NULL_EMPTY" );
		add_zombie_buildable_piece_vox_category( "chalk", "gunshop_chalk", 300 );
	}
	if ( isinarray( buildablesenabledlist, "sloth" ) )
	{
		add_zombie_buildable( "sloth", &"ZM_BURIED_BOOZE_GV", level.str_buildables_building, &"NULL_EMPTY" );
	}
	if ( isinarray( buildablesenabledlist, "keys_zm" ) )
	{
		add_zombie_buildable( "keys_zm", &"ZM_BURIED_KEYS_BL", level.str_buildables_building, &"NULL_EMPTY" );
		add_zombie_buildable_piece_vox_category( "keys_zm", "key" );
	}
	level thread chalk_host_migration();
}