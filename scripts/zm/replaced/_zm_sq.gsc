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

sq_complete_time_hud()
{
    hud = newHudElem();
	hud.alignx = "center";
	hud.aligny = "top";
	hud.horzalign = "user_center";
	hud.vertalign = "user_top";
	hud.y += 100;
	hud.fontscale = 1.4;
	hud.alpha = 0;
	hud.color = ( 1, 1, 1 );
	hud.hidewheninmenu = 1;
	hud.foreground = 1;
	hud.label = &"Quest Complete! Time: ";

    hud endon("death");

    hud thread scripts\zm\_zm_reimagined::destroy_on_intermission();

    fade_time = 0.5;

	hud fadeOverTime(fade_time);
	hud.alpha = 1;

    time = int((getTime() - level.timer_hud_start_time) / 1000);

    hud thread scripts\zm\_zm_reimagined::set_time_frozen(time, "forever");

    wait 10;

    hud fadeOverTime(fade_time);
	hud.alpha = 0;

	wait fade_time;

	hud destroy();
}