#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

brutus_health_increases()
{
	if(level.scr_zm_ui_gametype == "zgrief")
	{
		return;
	}

	if ( level.round_number > level.brutus_last_spawn_round )
	{
		a_players = getplayers();
		n_player_modifier = 1;
		if ( a_players.size > 1 )
		{
			n_player_modifier = a_players.size * 0.75;
		}
		level.brutus_round_count++;
		level.brutus_health = int( level.brutus_health_increase * n_player_modifier * level.brutus_round_count );
		level.brutus_expl_dmg_req = int( level.brutus_explosive_damage_increase * n_player_modifier * level.brutus_round_count );
		if ( level.brutus_health >= ( 5000 * n_player_modifier ) )
		{
			level.brutus_health = int( 5000 * n_player_modifier );
		}
		if ( level.brutus_expl_dmg_req >= ( 4500 * n_player_modifier ) )
		{
			level.brutus_expl_dmg_req = int( 4500 * n_player_modifier );
		}
		level.brutus_last_spawn_round = level.round_number;
	}
}

brutus_cleanup_at_end_of_grief_round()
{
	// stays on map
}