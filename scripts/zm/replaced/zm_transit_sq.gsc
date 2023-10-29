#include maps\mp\zm_transit_sq;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_transit_utility;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_unitrigger;

maxis_sidequest_a()
{
    level endon( "power_on" );
    level.sq_progress["maxis"]["A_turbine_1"] = undefined;
    level.sq_progress["maxis"]["A_turbine_2"] = undefined;

    if ( !( isdefined( level.sq_progress["maxis"]["B_complete"] ) && level.sq_progress["maxis"]["B_complete"] ) )
        level.sq_progress["maxis"]["A_complete"] = 0;

    while ( true )
    {
        players = get_players();

        foreach ( player in players )
        {
            if ( isdefined( player.buildableturbine ) && player.buildableturbine istouching( level.sq_volume ) )
            {
                level notify( "maxi_terminal_vox" );
                player.buildableturbine thread turbine_watch_cleanup();

                if ( !isdefined( level.sq_progress["maxis"]["A_turbine_1"] ) )
                {
                    level.sq_progress["maxis"]["A_turbine_1"] = player.buildableturbine;
                    level.sq_progress["maxis"]["A_turbine_1"] thread turbine_power_watcher( player );
                    continue;
                }

                if ( !isdefined( level.sq_progress["maxis"]["A_turbine_2"] ) )
                {
                    level.sq_progress["maxis"]["A_turbine_2"] = player.buildableturbine;
                    level.sq_progress["maxis"]["A_turbine_2"] thread turbine_power_watcher( player );
                }
            }
        }

        if ( get_how_many_progressed_from( "maxis", "A_turbine_1", "A_turbine_2" ) >= 1 )
        {
            if ( avogadro_at_tower() )
                level thread maxissay( "vox_maxi_turbine_2tower_avo_0", ( 7737, -416, -142 ) );
            else
                level thread maxissay( "vox_maxi_turbine_2tower_0", ( 7737, -416, -142 ) );

            update_sidequest_stats( "sq_transit_maxis_stage_2" );
            level thread maxis_sidequest_complete_check( "A_complete" );
        }

        level waittill_either( "turbine_deployed", "equip_turbine_zm_cleaned_up" );

        if ( !level.sq_progress["maxis"]["B_complete"] )
            level.sq_progress["maxis"]["A_complete"] = 0;
        else
            break;
    }
}

turbine_power_watcher( player )
{
    level endon( "end_avogadro_turbines" );
    self endon( "death" );
    self.powered = undefined;
    turbine_failed_vo = undefined;

    while ( isdefined( self ) )
    {
        wait 0.05;

        if ( is_true( player.turbine_power_is_on ) && !is_true( player.turbine_emped ) )
		{
			self.powered = 1;
		}
        else if ( is_true( player.turbine_emped ) || !is_true( player.turbine_power_is_on ) )
        {
            wait 2;
            self.powered = 0;
        }
    }
}

maxis_sidequest_b()
{
    level endon( "power_on" );

    while ( true )
    {
        level waittill( "stun_avogadro", avogadro );

        if ( ( isdefined( level.sq_progress["maxis"]["A_turbine_1"] ) && is_true( level.sq_progress["maxis"]["A_turbine_1"].powered ) ) || ( isdefined( level.sq_progress["maxis"]["A_turbine_2"] ) && is_true( level.sq_progress["maxis"]["A_turbine_2"].powered ) ) )
        {
            if ( isdefined( avogadro ) && avogadro istouching( level.sq_volume ) )
            {
                level notify( "end_avogadro_turbines" );
                break;
            }
        }
    }


    level notify( "maxis_stage_b" );
    level thread maxissay( "vox_maxi_avogadro_emp_0", ( 7737, -416, -142 ) );
    update_sidequest_stats( "sq_transit_maxis_stage_3" );
    player = get_players();
    player[0] setclientfield( "sq_tower_sparks", 1 );
    player[0] setclientfield( "screecher_maxis_lights", 1 );
    level thread maxis_sidequest_complete_check( "B_complete" );
}

maxis_sidequest_c()
{
    flag_wait( "power_on" );
    flag_waitopen( "power_on" );
    level endon( "power_on" );
	level.sq_progress["maxis"]["C_screecher_dark"] = 0;
	for(i = 0; i < 8; i++)
	{
		level.sq_progress["maxis"]["C_screecher_" + i] = undefined;
	}
    level.sq_progress["maxis"]["C_complete"] = 0;
    turbine_1_talked = 0;
    turbine_2_talked = 0;
    screech_zones = getstructarray( "screecher_escape", "targetname" );

    while ( true )
    {
        players = get_players();

        foreach ( player in players )
        {
            if ( isdefined( player.buildableturbine ) )
            {
                for ( x = 0; x < screech_zones.size; x++ )
                {
                    zone = screech_zones[x];

                    if ( distancesquared( player.buildableturbine.origin, zone.origin ) < zone.radius * zone.radius )
                    {
                        player.buildableturbine thread turbine_watch_cleanup();

                        zone_used = 0;
						for(i = 0; i < 8; i++)
						{
							if ( isdefined( level.sq_progress["maxis"]["C_screecher_" + i] ) && zone == level.sq_progress["maxis"]["C_screecher_" + i] )
							{
								zone_used = 1;
								break;
							}
						}

						if ( !zone_used )
						{
                            if ( level.sq_progress["maxis"]["B_complete"] && level.sq_progress["maxis"]["A_complete"] )
                            {
                                if ( !turbine_1_talked )
                                {
                                    turbine_1_talked = 1;
                                    level thread maxissay( "vox_maxi_turbine_1light_0", zone.origin );
                                }

                                level thread set_screecher_zone_origin_and_notify( zone.script_noteworthy, "sq_max" );
							    level.sq_progress["maxis"]["C_screecher_" + level.sq_progress["maxis"]["C_screecher_dark"]] = zone;
							    level.sq_progress["maxis"]["C_screecher_dark"]++;

                                if ( level.sq_progress["maxis"]["C_screecher_dark"] >= 8 )
                                {
                                    if ( !turbine_2_talked )
                                    {
                                        turbine_2_talked = 1;
                                        level thread maxissay( "vox_maxi_turbine_2light_on_0", zone.origin );
                                    }

                                    player = get_players();
                                    player[0] setclientfield( "screecher_maxis_lights", 0 );
                                    level maxis_sidequest_complete_check( "C_complete" );
                                    return;
                                }
                            }
						}

						continue;
                    }
                }
            }
        }

        level waittill_either( "turbine_deployed", "equip_turbine_zm_cleaned_up" );
        level.sq_progress["maxis"]["C_complete"] = 0;
    }
}

maxis_sidequest_complete()
{
    update_sidequest_stats( "sq_transit_maxis_complete" );
    level sidequest_complete( "maxis" );
    level.sq_progress["maxis"]["FINISHED"] = 1;
    level.maxcompleted = 1;
    clientnotify( "sq_kfx" );

    if ( isdefined( level.richcompleted ) && level.richcompleted )
        level clientnotify( "sq_krt" );

    wait 1;
    clientnotify( "sqm" );
    level thread droppowerup( "maxis" );
}

richtofen_sidequest_c()
{
    level endon( "power_off" );
    level endon( "richtofen_sq_complete" );
    screech_zones = getstructarray( "screecher_escape", "targetname" );
    level thread screecher_light_hint();
    level.sq_richtofen_c_screecher_lights = [];

    while ( true )
    {
        level waittill( "safety_light_power_off", screecher_zone );

        if ( !level.sq_progress["rich"]["A_complete"] || !level.sq_progress["rich"]["B_complete"] )
        {
            level thread richtofensay( "vox_zmba_sidequest_emp_nomag_0" );
            continue;
        }

		if ( isinarray( level.sq_richtofen_c_screecher_lights, screecher_zone.target.script_noteworthy ) )
		{
			continue;
		}

		level thread set_screecher_zone_origin_and_notify( screecher_zone.target.script_noteworthy, "sq_rich" );
        level.sq_richtofen_c_screecher_lights[level.sq_richtofen_c_screecher_lights.size] = screecher_zone.target.script_noteworthy;
        level.sq_progress["rich"]["C_screecher_light"]++;

        if ( level.sq_progress["rich"]["C_screecher_light"] >= 8 )
            break;
    }

    level thread richtofensay( "vox_zmba_sidequest_4emp_mag_0" );
    level notify( "richtofen_c_complete" );
    player = get_players();
    player[0] setclientfield( "screecher_sq_lights", 0 );
    level thread richtofen_sidequest_complete_check( "C_complete" );
}

richtofen_sidequest_complete()
{
    update_sidequest_stats( "sq_transit_rich_complete" );
    level thread sidequest_complete( "richtofen" );
    level.sq_progress["rich"]["FINISHED"] = 1;
    level.richcompleted = 1;
    clientnotify( "sq_kfx" );

    if ( isdefined( level.maxcompleted ) && level.maxcompleted )
        level clientnotify( "sq_kmt" );

    wait 1;
    clientnotify( "sqr" );
    level thread droppowerup( "richtofen" );
}

set_screecher_zone_origin_and_notify( script_noteworthy, notify_str )
{
	level set_screecher_zone_origin( script_noteworthy );
	wait 1;
	clientnotify( notify_str );
}

droppowerup( story )
{
    level thread scripts\zm\replaced\_zm_sq::sq_complete_time_hud();

    players = get_players();
    foreach ( player in players )
    {
        if ( is_player_valid( player ) )
        {
            player thread scripts\zm\replaced\_zm_sq::sq_give_player_all_perks();
        }
    }

    center_struct = getstruct( "sq_common_tower_fx", "targetname" );
    trace = bullettrace( center_struct.origin, center_struct.origin - vectorscale( ( 0, 0, 1 ), 999999.0 ), 0, undefined );
    poweruporigin = trace["position"] + vectorscale( ( 0, 0, 1 ), 25.0 );
    mintime = 120;
    maxtime = 360;

    while ( true )
    {
        trail = spawn( "script_model", center_struct.origin );
        trail setmodel( "tag_origin" );
        wait 0.5;
        playfxontag( level._effect[story + "_sparks"], trail, "tag_origin" );
        trail moveto( poweruporigin, 10 );

        trail waittill( "movedone" );

        level thread droppoweruptemptation( story, poweruporigin );
        wait 1;
        trail delete();
        wait( randomintrange( mintime, maxtime ) );
    }
}