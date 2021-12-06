#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

main()
{
	if ( getDvar( "g_gametype" ) != "zgrief" )
    {
		return;
    }

	replaceFunc(maps/mp/zombies/_zm_game_module::wait_for_team_death_and_round_end, ::wait_for_team_death_and_round_end);
	replaceFunc(maps/mp/zombies/_zm_blockers::handle_post_board_repair_rewards, ::handle_post_board_repair_rewards);
}

init()
{
    if ( getDvar( "g_gametype" ) != "zgrief" )
    {
		return;
    }

	if ( getDvarInt( "zombies_minplayers" ) < 2 || getDvarInt( "zombies_minplayers" ) == "" )
	{
		setDvar( "zombies_minplayers", 2 );
	}

	level thread on_player_connect();
	level thread grief_score_hud();
	level thread set_grief_vars();
	level thread init_round_start_wait(5);
	level thread unlimited_zombies();
	//level thread spawn_bots(7);
}

on_player_connect()
{
    while ( 1 )
    {
    	level waittill( "connected", player );
       	player set_team();
		player [[ level.givecustomcharacters ]]();
    }
}

set_team()
{
	teamplayersallies = countplayers( "allies");
	teamplayersaxis = countplayers( "axis");
	if ( teamplayersallies > teamplayersaxis )
	{
		self.team = "axis";
		self.sessionteam = "axis";
	 	self.pers[ "team" ] = "axis";
		self._encounters_team = "A";
	}
	else
	{
		self.team = "allies";
		self.sessionteam = "allies";
		self.pers[ "team" ] = "allies";
		self._encounters_team = "B";
	}
}

grief_score_hud()
{
	level.grief_hud = spawnstruct();
	level.grief_hud.icon = [];
	level.grief_hud.score = [];
	icon = [];

	icon["axis"] = "faction_cia";
	icon["allies"] = "faction_cdc";
	if(level.script == "zm_prison")
	{
		icon["axis"] = "faction_inmates";
		icon["allies"] = "faction_guards";
	}

	level.grief_hud.icon["axis"] = newHudElem();
	level.grief_hud.icon["axis"].alignx = "center";
	level.grief_hud.icon["axis"].aligny = "top";
	level.grief_hud.icon["axis"].horzalign = "user_center";
	level.grief_hud.icon["axis"].vertalign = "user_top";
	level.grief_hud.icon["axis"].x += 67.5;
	level.grief_hud.icon["axis"].y += 2;
	level.grief_hud.icon["axis"].hideWhenInMenu = 1;
	level.grief_hud.icon["axis"].alpha = 0;
	level.grief_hud.icon["axis"] setShader(icon["axis"], 32, 32);

	level.grief_hud.icon["allies"] = newHudElem();
	level.grief_hud.icon["allies"].alignx = "center";
	level.grief_hud.icon["allies"].aligny = "top";
	level.grief_hud.icon["allies"].horzalign = "user_center";
	level.grief_hud.icon["allies"].vertalign = "user_top";
	level.grief_hud.icon["allies"].x -= 67.5;
	level.grief_hud.icon["allies"].y += 2;
	level.grief_hud.icon["allies"].hideWhenInMenu = 1;
	level.grief_hud.icon["allies"].alpha = 0;
	level.grief_hud.icon["allies"] setShader(icon["allies"], 32, 32);

	level.grief_hud.score["axis"] = newHudElem();
	level.grief_hud.score["axis"].alignx = "center";
	level.grief_hud.score["axis"].aligny = "top";
	level.grief_hud.score["axis"].horzalign = "user_center";
	level.grief_hud.score["axis"].vertalign = "user_top";
	level.grief_hud.score["axis"].x += 22.5;
	level.grief_hud.score["axis"].y -= 4;
	level.grief_hud.score["axis"].fontscale = 3.5;
	level.grief_hud.score["axis"].color = (0.21, 0, 0);
	level.grief_hud.score["axis"].hideWhenInMenu = 1;
	level.grief_hud.score["axis"].alpha = 0;
	level.grief_hud.score["axis"] setValue(0);

	level.grief_hud.score["allies"] = newHudElem();
	level.grief_hud.score["allies"].alignx = "center";
	level.grief_hud.score["allies"].aligny = "top";
	level.grief_hud.score["allies"].horzalign = "user_center";
	level.grief_hud.score["allies"].vertalign = "user_top";
	level.grief_hud.score["allies"].x -= 22.5;
	level.grief_hud.score["allies"].y -= 4;
	level.grief_hud.score["allies"].fontscale = 3.5;
	level.grief_hud.score["allies"].color = (0.21, 0, 0);
	level.grief_hud.score["allies"].hideWhenInMenu = 1;
	level.grief_hud.score["allies"].alpha = 0;
	level.grief_hud.score["allies"] setValue(0);

	flag_wait( "initial_blackscreen_passed" );

	level.grief_hud.icon["axis"].alpha = 1;
	level.grief_hud.icon["allies"].alpha = 1;
	level.grief_hud.score["axis"].alpha = 1;
	level.grief_hud.score["allies"].alpha = 1;
}

set_grief_vars()
{
	level.noroundnumber = 1;
	level.round_number = 0;
	level.player_starting_points = 10000;
	level.zombie_vars["zombie_health_start"] = 2000;
	level.zombie_vars["zombie_spawn_delay"] = 0.5;
	level.custom_end_screen = ::custom_end_screen;
	level._game_module_player_damage_callback = ::game_module_player_damage_callback;

	level.grief_winning_score = 3;
	level.grief_score = [];
	level.grief_score["A"] = 0;
	level.grief_score["B"] = 0;

	flag_wait( "start_zombie_round_logic" ); // needs a wait

	level.zombie_move_speed = 100;
}

init_round_start_wait(time)
{
	flag_clear("spawn_zombies");

	flag_wait("initial_blackscreen_passed");

	round_start_wait(time);
}

wait_for_team_death_and_round_end()
{
	level endon( "game_module_ended" );
	level endon( "end_game" );

	checking_for_round_end = 0;
	level.isresetting_grief = 0;
	while ( 1 )
	{
		cdc_alive = 0;
		cia_alive = 0;
		players = get_players();
		i = 0;
		while ( i < players.size )
		{
			if ( !isDefined( players[ i ]._encounters_team ) )
			{
				i++;
				continue;
			}
			if ( players[ i ]._encounters_team == "A" )
			{
				if ( is_player_valid( players[ i ] ) )
				{
					cia_alive++;
				}
				i++;
				continue;
			}
			if ( is_player_valid( players[ i ] ) )
			{
				cdc_alive++;
			}
			i++;
		}

		if ( !checking_for_round_end )
		{
			if ( cia_alive == 0 )
			{
				level thread round_end( "B" );
				checking_for_round_end = 1;
			}
			else if ( cdc_alive == 0 )
			{
				level thread round_end( "A" );
				checking_for_round_end = 1;
			}
		}

		if ( cia_alive > 0 && cdc_alive > 0 )
		{
			level notify( "stop_round_end_check" );
			checking_for_round_end = 0;
		}

		wait 0.05;
	}
}

zombie_goto_round(target_round)
{
	level notify( "restart_round" );

	if ( target_round < 1 )
	{
		target_round = 1;
	}

	level.zombie_total = 0;
	maps/mp/zombies/_zm::ai_calculate_health( target_round );
	zombies = get_round_enemy_array();
	if ( isDefined( zombies ) )
	{
		for ( i = 0; i < zombies.size; i++ )
		{
			zombies[ i ] dodamage( zombies[ i ].health + 666, zombies[ i ].origin );
		}
	}

	maps/mp/zombies/_zm_game_module::respawn_players();
	players = get_players();
	foreach(player in players)
	{
		if(player.score < level.player_starting_points)
		{
			player maps/mp/zombies/_zm_score::add_to_player_score(level.player_starting_points - player.score);
		}
	}

	round_start_wait(5);
}

round_start_wait(time)
{
	level thread zombie_spawn_wait(time + 5);

	players = get_players();
	foreach(player in players)
	{
		player freezeControls(1);
		player enableInvulnerability();
	}

	round_start_countdown_hud = round_start_countdown_hud(time);

	wait time;

	round_start_countdown_hud round_start_countdown_hud_destroy();

	players = get_players();
	foreach(player in players)
	{
		player freezeControls(0);
		player disableInvulnerability();
	}
}

round_start_countdown_hud(time)
{
	countdown = createServerFontString( "objective", 2.2 );
    countdown setPoint( "CENTER", "CENTER", 0, 0 );
    countdown.foreground = false;
    countdown.alpha = 1;
    countdown.color = ( 1, 1, 0 );
    countdown.hidewheninmenu = true;
    countdown maps/mp/gametypes_zm/_hud::fontpulseinit();
    countdown thread round_start_countdown_hud_timer(time);

	countdown.countdown_text = createServerFontString( "objective", 1.5 );
    countdown.countdown_text setPoint( "CENTER", "CENTER", 0, -40 );
    countdown.countdown_text.foreground = false;
    countdown.countdown_text.alpha = 1;
    countdown.countdown_text.color = ( 1.000, 1.000, 1.000 );
    countdown.countdown_text.hidewheninmenu = true;
    countdown.countdown_text.label = &"ROUND BEGINS IN";

	return countdown;
}

round_start_countdown_hud_destroy()
{
	self.countdown_text destroy();
	self destroy();
}

round_start_countdown_hud_timer(time)
{
    timer = time;
    while ( true )
    {
        self setValue( timer );
        wait 1;
        timer--;
        if ( timer <= 5 )
        {
            self thread countdown_pulse( self, timer );
            break;
        }
    }
}

countdown_pulse( hud_elem, duration )
{
    level endon( "end_game" );
    waittillframeend;
    while ( duration > 0 && !level.gameended )
    {
        hud_elem thread maps/mp/gametypes_zm/_hud::fontpulse( level );
        wait ( hud_elem.inframes * 0.05 );
        hud_elem setvalue( duration );
        duration--;
        wait ( 1 - ( hud_elem.inframes * 0.05 ) );
    }
}

zombie_spawn_wait(time)
{
	flag_clear("spawn_zombies");

	wait time;

	flag_set("spawn_zombies");
}

round_end(winner)
{
	team = "axis";
	if(winner == "B")
	{
		team = "allies";
	}

	level.grief_score[winner]++;

	if(level.grief_score[winner] == level.grief_winning_score)
	{
		level.grief_hud.score[team] setValue(level.grief_score[winner]);
		level.gamemodulewinningteam = winner;
		level.zombie_vars[ "spectators_respawn" ] = 0;
		players = get_players();
		i = 0;
		while ( i < players.size )
		{
			players[ i ] freezecontrols( 1 );
			if ( players[ i ]._encounters_team == winner )
			{
				players[ i ] thread maps/mp/zombies/_zm_audio_announcer::leaderdialogonplayer( "grief_won" );
				i++;
				continue;
			}
			players[ i ] thread maps/mp/zombies/_zm_audio_announcer::leaderdialogonplayer( "grief_lost" );
			i++;
		}
		level notify( "game_module_ended", winner );
		level._game_module_game_end_check = undefined;
		maps/mp/gametypes_zm/_zm_gametype::track_encounters_win_stats( level.gamemodulewinningteam );
		level notify( "end_game" );
	}
	else
	{
		wait 0.5;

		level.grief_hud.score[team] setValue(level.grief_score[winner]);

		players = get_players();
		foreach(player in players)
		{
			if(is_player_valid(player))
			{
				// don't give perk
				player notify("perk_abort_drinking");
				// save weapons
				player [[level._game_module_player_laststand_callback]]();
			}
		}

		level thread maps/mp/zombies/_zm_audio_announcer::leaderdialog( "grief_restarted" );

		level.isresetting_grief = 1;
		level notify( "end_round_think" );
		level.zombie_vars[ "spectators_respawn" ] = 1;
		level notify( "keep_griefing" );
		zombie_goto_round( level.round_number );
		level thread maps/mp/zombies/_zm_game_module::reset_grief();
		level thread maps/mp/zombies/_zm::round_think( 1 );
	}
}

custom_end_screen()
{
	players = get_players();
	i = 0;
	while ( i < players.size )
	{
		players[ i ].game_over_hud = newclienthudelem( players[ i ] );
		players[ i ].game_over_hud.alignx = "center";
		players[ i ].game_over_hud.aligny = "middle";
		players[ i ].game_over_hud.horzalign = "center";
		players[ i ].game_over_hud.vertalign = "middle";
		players[ i ].game_over_hud.y -= 130;
		players[ i ].game_over_hud.foreground = 1;
		players[ i ].game_over_hud.fontscale = 3;
		players[ i ].game_over_hud.alpha = 0;
		players[ i ].game_over_hud.color = ( 1, 1, 1 );
		players[ i ].game_over_hud.hidewheninmenu = 1;
		players[ i ].game_over_hud settext( &"ZOMBIE_GAME_OVER" );
		players[ i ].game_over_hud fadeovertime( 1 );
		players[ i ].game_over_hud.alpha = 1;
		if ( players[ i ] issplitscreen() )
		{
			players[ i ].game_over_hud.fontscale = 2;
			players[ i ].game_over_hud.y += 40;
		}
		players[ i ].survived_hud = newclienthudelem( players[ i ] );
		players[ i ].survived_hud.alignx = "center";
		players[ i ].survived_hud.aligny = "middle";
		players[ i ].survived_hud.horzalign = "center";
		players[ i ].survived_hud.vertalign = "middle";
		players[ i ].survived_hud.y -= 100;
		players[ i ].survived_hud.foreground = 1;
		players[ i ].survived_hud.fontscale = 2;
		players[ i ].survived_hud.alpha = 0;
		players[ i ].survived_hud.color = ( 1, 1, 1 );
		players[ i ].survived_hud.hidewheninmenu = 1;
		if ( players[ i ] issplitscreen() )
		{
			players[ i ].survived_hud.fontscale = 1.5;
			players[ i ].survived_hud.y += 40;
		}
		winner_text = "YOU WIN!";
		loser_text = "YOU LOSE!";

		if ( isDefined( level.host_ended_game ) && level.host_ended_game )
		{
			players[ i ].survived_hud settext( &"MP_HOST_ENDED_GAME" );
		}
		else
		{
			if ( isDefined( level.gamemodulewinningteam ) && players[ i ]._encounters_team == level.gamemodulewinningteam )
			{
				players[ i ].survived_hud settext( winner_text );
			}
			else
			{
				players[ i ].survived_hud settext( loser_text );
			}
		}
		players[ i ].survived_hud fadeovertime( 1 );
		players[ i ].survived_hud.alpha = 1;
		i++;
	}
}

game_module_player_damage_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime )
{
	self.last_damage_from_zombie_or_player = 0;
	if ( isDefined( eattacker ) )
	{
		if ( isplayer( eattacker ) && eattacker == self )
		{
			return;
		}
		if ( isDefined( eattacker.is_zombie ) || eattacker.is_zombie && isplayer( eattacker ) )
		{
			self.last_damage_from_zombie_or_player = 1;
		}
	}

	if ( is_true( self._being_shellshocked ) || self maps/mp/zombies/_zm_laststand::player_is_in_laststand() )
	{
		return;
	}

	if ( isplayer( eattacker ) && isDefined( eattacker._encounters_team ) && eattacker._encounters_team != self._encounters_team )
	{
		if ( is_true( self.hasriotshield ) && isDefined( vdir ) )
		{
			if ( is_true( self.hasriotshieldequipped ) )
			{
				if ( self maps/mp/zombies/_zm::player_shield_facing_attacker( vdir, 0.2 ) && isDefined( self.player_shield_apply_damage ) )
				{
					return;
				}
			}
			else if ( !isdefined( self.riotshieldentity ) )
			{
				if ( !self maps/mp/zombies/_zm::player_shield_facing_attacker( vdir, -0.2 ) && isdefined( self.player_shield_apply_damage ) )
				{
					return;
				}
			}
		}

		if ( isDefined( level._game_module_player_damage_grief_callback ) )
		{
			self [[ level._game_module_player_damage_grief_callback ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime );
		}

		if ( isDefined( level._effect[ "butterflies" ] ) )
		{
			if ( isDefined( sweapon ) && weapontype( sweapon ) == "grenade" )
			{
				playfx( level._effect[ "butterflies" ], self.origin + vectorScale( ( 1, 1, 1 ), 40 ) );
			}
			else
			{
				playfx( level._effect[ "butterflies" ], vpoint, vdir );
			}
		}

		self thread add_grief_score(eattacker);
		self thread do_game_mode_shellshock();
		self playsound( "zmb_player_hit_ding" );
	}
}

do_game_mode_shellshock()
{
	self shellshock( "grief_stab_zm", 0.5 );
}

add_grief_score(attacker)
{
	if(is_player_valid(attacker) && self.health < self.maxhealth)
	{
		attacker maps/mp/zombies/_zm_score::add_to_player_score(10);
	}
}

unlimited_zombies()
{
	while(1)
	{
		if(!level.isresetting_grief)
		{
			level.zombie_total = 100;
		}

		wait 1;
	}
}

handle_post_board_repair_rewards( cost, zbarrier )
{
	self maps/mp/zombies/_zm_stats::increment_client_stat( "boards" );
	self maps/mp/zombies/_zm_stats::increment_player_stat( "boards" );
	if ( isDefined( self.pers[ "boards" ] ) && ( self.pers[ "boards" ] % 10 ) == 0 )
	{
		self thread do_player_general_vox( "general", "reboard", 90 );
	}
	self maps/mp/zombies/_zm_pers_upgrades_functions::pers_boards_updated( zbarrier );
	self.rebuild_barrier_reward += cost;

	self maps/mp/zombies/_zm_score::player_add_points( "rebuild_board", cost );
	self play_sound_on_ent( "purchase" );

	if ( isDefined( self.board_repair ) )
	{
		self.board_repair += 1;
	}
}

spawn_bots(num)
{
	level waittill( "connected", player );

	for(i = 0; i < num; i++)
	{
		bot = addtestclient();

		wait 0.5; // need wait or bots don't spawn at correct origin
	}
}