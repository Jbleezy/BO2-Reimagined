#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_alcatraz_weap_quest;

#using_animtree("fxanim_props");

grief_soul_catcher_state_manager()
{
    wait 1;

    if (is_true(level.scr_zm_ui_gametype_pro))
	{
        for (i = 0; i < level.soul_catchers.size; i++)
        {
            level.soul_catchers[i].is_charged = 1;
        }

        return;
    }

    while ( true )
    {
        level setclientfield( self.script_parameters, 0 );

        self waittill( "first_zombie_killed_in_zone" );

        if ( isdefined( level.soul_catcher_clip[self.script_noteworthy] ) )
            level.soul_catcher_clip[self.script_noteworthy] setvisibletoall();

        level setclientfield( self.script_parameters, 1 );
        anim_length = getanimlength( %o_zombie_dreamcatcher_intro );
        wait( anim_length );

        while ( !self.is_charged )
        {
            level setclientfield( self.script_parameters, 2 );
            self waittill_either( "fully_charged", "finished_eating" );
        }

        level setclientfield( self.script_parameters, 6 );
        anim_length = getanimlength( %o_zombie_dreamcatcher_outtro );
        wait( anim_length );

        if ( isdefined( level.soul_catcher_clip[self.script_noteworthy] ) )
            level.soul_catcher_clip[self.script_noteworthy] delete();

        self.souls_received = 0;
        level thread wolf_spit_out_powerup();
        wait 20;
        self thread soul_catcher_check();
    }
}

wolf_spit_out_powerup()
{
    if ( !( isdefined( level.enable_magic ) && level.enable_magic ) )
        return;

    power_origin_struct = getstruct( "wolf_puke_powerup_origin", "targetname" );

    if ( level.scr_zm_ui_gametype_obj != "zmeat" && randomint( 100 ) < 20 )
    {
        for ( i = 0; i < level.zombie_powerup_array.size; i++ )
        {
            if ( level.zombie_powerup_array[i] == "meat_stink" )
            {
                level.zombie_powerup_index = i;
                found = 1;
                break;
            }
        }
    }
    else
    {
        while ( true )
        {
            level.zombie_powerup_index = randomint( level.zombie_powerup_array.size );

            if ( level.zombie_powerup_array[level.zombie_powerup_index] == "nuke" )
            {
                wait 0.05;
                continue;
            }

            if ( level.scr_zm_ui_gametype_obj == "zmeat" && level.zombie_powerup_array[level.zombie_powerup_index] == "meat_stink" )
            {
                wait 0.05;
                continue;
            }

            break;
        }
    }

    if (level.scr_zm_map_start_location == "docks")
    {
        power_origin_struct = spawnStruct();
        power_origin_struct.origin = ( 41.4695, 6096.17, -102.9326 );
    }

    spawn_infinite_powerup_drop( power_origin_struct.origin, level.zombie_powerup_array[level.zombie_powerup_index] );
    power_ups = get_array_of_closest( power_origin_struct.origin, level.active_powerups, undefined, undefined, 100 );

    if ( isdefined( power_ups[0] ) )
        power_ups[0] movez( 120, 4 );
}