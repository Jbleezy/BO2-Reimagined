#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

navcomputer_waitfor_navcard()
{
    trig_pos = getstruct( "sq_common_key", "targetname" );
    navcomputer_use_trig = spawn( "trigger_radius_use", trig_pos.origin, 0, 48, 48 );
	navcomputer_use_trig.cost = 100000;
    navcomputer_use_trig setcursorhint( "HINT_NOICON" );
    navcomputer_use_trig sethintstring( &"ZOMBIE_NAVCARD_USE", " [Cost: " + navcomputer_use_trig.cost + "]" );
    navcomputer_use_trig triggerignoreteam();

    while ( true )
    {
        navcomputer_use_trig waittill( "trigger", who );

        if ( isplayer( who ) && is_player_valid( who ) )
        {
            if ( who.score >= navcomputer_use_trig.cost )
            {
				who maps\mp\zombies\_zm_score::minus_to_player_score( navcomputer_use_trig.cost );

                navcomputer_use_trig sethintstring( &"ZOMBIE_NAVCARD_SUCCESS" );
                navcomputer_use_trig playsound( "zmb_sq_navcard_success" );

				players = get_players();
				foreach (player in players)
				{
					player freezecontrols(1);
				}

				level notify( "end_game" );

                return;
            }
			else
			{
                navcomputer_use_trig playsound( "zmb_sq_navcard_fail" );
			}
        }
    }
}

sq_give_player_all_perks()
{
    machines = array_randomize( getentarray( "zombie_vending", "targetname" ) );
    perks = [];

    for ( i = 0; i < machines.size; i++ )
    {
        if ( machines[i].script_noteworthy == "specialty_weapupgrade" )
            continue;

        perks[perks.size] = machines[i].script_noteworthy;
    }

    foreach ( perk in perks )
    {
        if ( isdefined( self.perk_purchased ) && self.perk_purchased == perk )
            continue;

        if ( self hasperk( perk ) || self maps\mp\zombies\_zm_perks::has_perk_paused( perk ) )
            continue;

        self maps\mp\zombies\_zm_perks::give_perk( perk, 0 );
        wait 0.25;
    }
}