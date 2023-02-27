#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_alcatraz_weap_quest;

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

    spawn_infinite_powerup_drop( power_origin_struct.origin, level.zombie_powerup_array[level.zombie_powerup_index] );
    power_ups = get_array_of_closest( power_origin_struct.origin, level.active_powerups, undefined, undefined, 100 );

    if ( isdefined( power_ups[0] ) )
        power_ups[0] movez( 120, 4 );
}