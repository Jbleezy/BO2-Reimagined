#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\_visionset_mgr;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm;
#include maps\mp\zm_buried_sq;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zm_buried_sq_tpo;

stage_logic_maxis()
{
    flag_clear( "sq_wisp_success" );
    flag_clear( "sq_wisp_failed" );

    while ( !flag( "sq_wisp_success" ) )
    {
        stage_start( "sq", "ts" );

        level waittill( "sq_ts_over" );

        stage_start( "sq", "ctw" );

        level waittill( "sq_ctw_over" );
    }

    level._cur_stage_name = "tpo";
}