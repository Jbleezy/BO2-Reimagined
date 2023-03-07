#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_transit_utility;
#include maps\mp\zm_transit_automaton;
#include maps\mp\zm_transit_cling;
#include maps\mp\zm_transit_openings;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_transit_ambush;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_weap_emp_bomb;
#include maps\mp\zm_transit_lava;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_transit_bus;

busupdateplayers()
{
    level endon( "end_game" );

    while ( true )
    {
        self.numplayers = 0;
        self.numplayerson = 0;
        self.numplayersonroof = 0;
        self.numplayersinsidebus = 0;
        self.numplayersnear = 0;
        self.numaliveplayersridingbus = 0;
        self.frontworld = self localtoworldcoords( self.frontlocal );
        self.backworld = self localtoworldcoords( self.backlocal );
        self.bus_riders_alive = [];

        players = get_players();

        foreach ( player in players )
        {
            if ( !isalive( player ) )
                continue;

            self.numplayers++;

            if ( distance2d( player.origin, self.origin ) < 1700 )
                self.numplayersnear++;

            playerisinbus = 0;
            mover = player getmoverent();

            if ( isdefined( mover ) )
            {
                if ( isdefined( mover.targetname ) )
                {
                    if ( mover.targetname == "the_bus" || mover.targetname == "bus_path_blocker" || mover.targetname == "hatch_clip" || mover.targetname == "ladder_mantle" )
                        playerisinbus = 1;
                }

                if ( isdefined( mover.equipname ) )
                {
                    if ( mover.equipname == "riotshield_zm" )
                    {
                        if ( isdefined( mover.isonbus ) && mover.isonbus )
                            playerisinbus = 1;
                    }
                }

                if ( isdefined( mover.is_zombie ) && mover.is_zombie && ( isdefined( mover.isonbus ) && mover.isonbus ) )
                    playerisinbus = 1;
            }

            if ( playerisinbus )
            {
                self.numplayerson++;

                if ( is_player_valid( player ) )
                {
                    self.numaliveplayersridingbus++;
                    self.bus_riders_alive[self.bus_riders_alive.size] = player;
                }
            }

            ground_ent = player getgroundent();

            if ( player isonladder() )
                ground_ent = mover;

            if ( isdefined( ground_ent ) )
            {
                if ( isdefined( ground_ent.is_zombie ) && ground_ent.is_zombie )
                    player thread zombie_surf( ground_ent );
                else
                {
                    if ( playerisinbus && !( isdefined( player.isonbus ) && player.isonbus ) )
                    {
                        bbprint( "zombie_events", "category %s type %s round %d playername %s", "BUS", "player_enter", level.round_number, player.name );
                        player thread bus_audio_interior_loop( self );
                        player clientnotify( "OBS" );
                        player setclientplayerpushamount( 0 );

                        if ( randomint( 100 ) > 80 && level.automaton.greeting_timer == 0 )
                        {
                            thread automatonspeak( "convo", "player_enter" );
                            level.automaton thread greeting_timer();
                        }
                    }

                    if ( !playerisinbus && ( isdefined( player.isonbus ) && player.isonbus ) )
                    {
                        bbprint( "zombie_events", "category %s type %s round %d playername %s", "BUS", "player_exit", level.round_number, player.name );
                        self.buyable_weapon setinvisibletoplayer( player );
                        player setclientplayerpushamount( 1 );
                        player notify( "left bus" );
                        player clientnotify( "LBS" );

                        if ( randomint( 100 ) > 80 && level.automaton.greeting_timer == 0 )
                        {
                            thread automatonspeak( "convo", "player_leave" );
                            level.automaton thread greeting_timer();
                        }
                    }

                    player.isonbus = playerisinbus;
                    player.isonbusroof = player _entityisonroof();
                }
            }

            if ( isdefined( player.isonbusroof ) && player.isonbusroof )
            {
                self.buyable_weapon setinvisibletoplayer( player );
                self.numplayersonroof++;
            }
            else if ( isdefined( player.isonbus ) && player.isonbus )
            {
                self.buyable_weapon setvisibletoplayer( player );
                self.numplayersinsidebus++;
            }

            wait 0.05;
        }

        wait 0.05;
    }
}