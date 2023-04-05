#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\zombies\_zm_pers_upgrades;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_stats;

set_global_stat( stat_name, value )
{
    if ( is_true( level.zm_disable_recording_stats ) )
        return;

	if ( issubstr( tolower( stat_name ), "sq_" ) || issubstr( tolower( stat_name ), "navcard_" ) )
		value = 0;

    self setdstat( "PlayerStatsList", stat_name, "StatValue", value );
}