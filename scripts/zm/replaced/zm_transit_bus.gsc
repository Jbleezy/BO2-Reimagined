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

#using_animtree("zombie_bus");

bussetup()
{
    flag_init( "ladder_attached" );
    flag_init( "catcher_attached" );
    flag_init( "hatch_attached" );
    self.immediatespeed = 0;
    self.currentspeed = 0;
    self.targetspeed = 0;
    self.ismoving = 0;
    self.isstopping = 0;
    self.gas = 100;
    self.accel = 20;
    self.decel = 60;
    self.radius = 88;
    self.height = 240;
    self.frontdist = 340;
    self.backdist = 55;
    self.floor = 36;
    self.frontlocal = ( self.frontdist - self.radius / 2.0, 0, 0 );
    self.backlocal = ( self.backdist * -1 + self.radius / 2.0, 0, 0 );
    self.drivepath = 0;
    self.zone = "zone_pri";
    self.roadzone = self.zone;
    self.zombiesinside = 0;
    self.zombiesatwindow = 0;
    self.zombiesonroof = 0;
    self.numplayers = 0;
    self.numplayerson = 0;
    self.numplayersonroof = 0;
    self.numplayersinsidebus = 0;
    self.numplayersnear = 0;
    self.numaliveplayersridingbus = 0;
    self.numflattires = 0;
    self.doorsclosed = 1;
    self.doorsdisabledfortime = 0;
    self.stalled = 0;
    self.issafe = 1;
    self.waittimeatdestination = 0;
    self.gracetimeatdestination = 10;
    self.path_blocking = 0;
    self.chase_pos = self.origin;
    self.chase_pos_time = 0;
    self.istouchingignorewindowsvolume = 0;
    level.zm_mantle_over_40_move_speed_override = ::zm_mantle_over_40_move_speed_override;
    self setmovingplatformenabled( 1 );
    self.supportsanimscripted = 1;
    self setvehmaxspeed( 50 );
    self useanimtree( #animtree );
    level.callbackactordamage = ::transit_actor_damage_override_wrapper;
    self maps\mp\zm_transit_automaton::main();
    maps\mp\zm_transit_cling::initializecling();
    self maps\mp\zm_transit_openings::main();
    self bus_upgrades();
    self thread busplowsetup();
    self buslightssetup();
    self busdoorssetup();
    self buspathblockersetup();
    self bussetupbounds();
    self bus_roof_watch();
    self bus_set_nodes();
    self bus_set_exit_triggers();
    self thread bus_audio_setup();
    level thread init_bus_door_anims();
    level thread init_bus_props_anims();
    self thread bususeanimtree();
    self thread bususedoor( 0 );
    self thread busidledoor();
    self thread play_lava_audio();
    self thread busthink();
    self thread busopeningscene();
    busschedule();
    self thread busschedulethink();
    self thread bus_bridge_speedcontrol();
    self.door_nodes_linked = 1;
    self thread bussetdoornodes( 0 );
}

busscheduleadd( stopname, isambush, maxwaittimebeforeleaving, busspeedleaving, gasusage )
{
    assert( isdefined( stopname ) );
    assert( isdefined( isambush ) );
    assert( isdefined( maxwaittimebeforeleaving ) );
    assert( isdefined( busspeedleaving ) );
    destinationindex = self.destinations.size;
    self.destinations[destinationindex] = spawnstruct();
    self.destinations[destinationindex].name = stopname;
    self.destinations[destinationindex].isambush = isambush;
    self.destinations[destinationindex].maxwaittimebeforeleaving = maxwaittimebeforeleaving;
    self.destinations[destinationindex].busspeedleaving = busspeedleaving * 2;
    self.destinations[destinationindex].gasusage = gasusage;
}

busschedulethink()
{
    self endon( "death" );

    while ( true )
    {
        self waittill( "noteworthy", noteworthy, noteworthynode );

        zoneisempty = 1;
        shouldremovegas = 0;
        destinationindex = level.busschedule busschedulegetdestinationindex( noteworthy );

        if ( !isdefined( destinationindex ) || !isdefined( noteworthynode ) )
        {
            continue;
        }

        self.destinationindex = destinationindex;
        self.waittimeatdestination = level.busschedule busschedulegetmaxwaittimebeforeleaving( self.destinationindex );
        self.currentnode = noteworthynode;
        targetspeed = level.busschedule busschedulegetbusspeedleaving( self.destinationindex );

        foreach ( zone in level.zones )
        {
            if ( !isdefined( zone.volumes ) || zone.volumes.size == 0 )
                continue;

            zonename = zone.volumes[0].targetname;

            if ( self maps\mp\zombies\_zm_zonemgr::entity_in_zone( zonename ) )
            {
                self.zone = zonename;
                zonestocheck = [];
                zonestocheck[zonestocheck.size] = zonename;

                switch ( zonename )
                {
                    case "zone_station_ext":
                        zonestocheck[zonestocheck.size] = "zone_trans_1";
                        zonestocheck[zonestocheck.size] = "zone_pri";
                        zonestocheck[zonestocheck.size] = "zone_pri2";
                        zonestocheck[zonestocheck.size] = "zone_amb_bridge";
                        zonestocheck[zonestocheck.size] = "zone_trans_2b";
                        break;
                    case "zone_gas":
                        zonestocheck[zonestocheck.size] = "zone_trans_2";
                        zonestocheck[zonestocheck.size] = "zone_amb_tunnel";
                        zonestocheck[zonestocheck.size] = "zone_gar";
                        zonestocheck[zonestocheck.size] = "zone_trans_diner";
                        zonestocheck[zonestocheck.size] = "zone_trans_diner2";
                        zonestocheck[zonestocheck.size] = "zone_diner_roof";
                        zonestocheck[zonestocheck.size] = "zone_din";
                        zonestocheck[zonestocheck.size] = "zone_roadside_west";
                        zonestocheck[zonestocheck.size] = "zone_roadside_east";
                        zonestocheck[zonestocheck.size] = "zone_trans_3";
                        break;
                    case "zone_far":
                        zonestocheck[zonestocheck.size] = "zone_amb_forest";
                        zonestocheck[zonestocheck.size] = "zone_far_ext";
                        zonestocheck[zonestocheck.size] = "zone_farm_house";
                        zonestocheck[zonestocheck.size] = "zone_brn";
                        zonestocheck[zonestocheck.size] = "zone_trans_5";
                        zonestocheck[zonestocheck.size] = "zone_trans_6";
                        break;
                    case "zone_pow":
                        zonestocheck[zonestocheck.size] = "zone_trans_6";
                        zonestocheck[zonestocheck.size] = "zone_amb_cornfield";
                        zonestocheck[zonestocheck.size] = "zone_trans_7";
                        zonestocheck[zonestocheck.size] = "zone_pow_ext1";
                        zonestocheck[zonestocheck.size] = "zone_prr";
                        zonestocheck[zonestocheck.size] = "zone_pcr";
                        zonestocheck[zonestocheck.size] = "zone_pow_warehouse";
                        break;
                    case "zone_town_north":
                        zonestocheck[zonestocheck.size] = "zone_trans_8";
                        zonestocheck[zonestocheck.size] = "zone_amb_power2town";
                        zonestocheck[zonestocheck.size] = "zone_tbu";
                        zonestocheck[zonestocheck.size] = "zone_town_church";
                        zonestocheck[zonestocheck.size] = "zone_bar";
                        zonestocheck[zonestocheck.size] = "zone_town_east";
                        zonestocheck[zonestocheck.size] = "zone_tow";
                        zonestocheck[zonestocheck.size] = "zone_ban";
                        zonestocheck[zonestocheck.size] = "zone_ban_vault";
                        zonestocheck[zonestocheck.size] = "zone_town_west";
                        zonestocheck[zonestocheck.size] = "zone_town_west2";
                        zonestocheck[zonestocheck.size] = "zone_town_barber";
                        zonestocheck[zonestocheck.size] = "zone_town_south";
                        zonestocheck[zonestocheck.size] = "zone_trans_9";
                        break;
                }

                foreach ( zone in zonestocheck )
                {
                    if ( !( isdefined( zoneisempty ) && zoneisempty ) )
                        continue;

                    if ( maps\mp\zombies\_zm_zonemgr::player_in_zone( zone ) )
                    {
                        zoneisempty = 0;
                    }
                }

                if ( isdefined( zoneisempty ) && zoneisempty )
                {
                    continue;
                }
            }
        }

        if ( isdefined( shouldremovegas ) && shouldremovegas )
            self busgasremove( level.busschedule busschedulegetbusgasusage( self.destinationindex ) );

        if ( isdefined( zoneisempty ) && zoneisempty )
        {
            self busstartmoving( targetspeed );
            continue;
        }

        if ( isdefined( self.skip_next_destination ) && self.skip_next_destination )
        {
            self notify( "skipping_destination" );
            self busstartmoving( targetspeed );
            continue;
        }

        if ( level.busschedule busschedulegetisambushstop( self.destinationindex ) )
        {
            if ( maps\mp\zm_transit_ambush::shouldstartambushround() && self.numplayersinsidebus != 0 )
            {
                self busstopmoving( 1 );
                level.nml_zone_name = "zone_amb_" + noteworthy;
                thread maps\mp\zm_transit_ambush::ambushstartround();
                thread automatonspeak( "inform", "out_of_gas" );
                flag_waitopen( "ambush_round" );
                shouldremovegas = 1;
                thread automatonspeak( "inform", "refueled_gas" );
            }
            else
            {
                continue;
            }
        }
        else
        {
            self notify( "reached_destination" );
            shouldremovegas = 1;
            thread do_automaton_arrival_vox( noteworthy );

            if ( noteworthy == "diner" || noteworthy == "town" || noteworthy == "power" )
            {
                self busstopmoving( 1 );

                if ( noteworthy == "diner" )
                    self bussetdineropenings( 0 );
                else if ( noteworthy == "power" )
                    self bussetpoweropenings( 0 );
                else if ( noteworthy == "town" )
                    self bussettownopenings( 0 );
            }
            else
                self busstopmoving();

            self thread busscheduledepartearly();
        }

        waittimeatdestination = self.waittimeatdestination;

        self thread busshowleavinghud( waittimeatdestination );

        self waittill_any_timeout( waittimeatdestination, "depart_early" );

        self notify( "ready_to_depart" );
        self thread buslightsflash();
        self thread buslightsignal( "turn_signal_left" );
        thread automatonspeak( "inform", "leaving_warning" );
        self thread play_bus_audio( "grace" );
        wait( self.gracetimeatdestination );
        thread automatonspeak( "inform", "leaving" );
        self.accel = 2;
        self busstartmoving( targetspeed );
        self notify( "departing" );
        self setclientfield( "bus_flashing_lights", 0 );
    }
}

busshowleavinghud( time )
{
    self endon("depart_early");

    self thread busshowleavinghud_destroy_on_depart_early();

    while (time > 0)
    {
        players = get_players();
        foreach (player in players)
        {
            if (!isDefined(player.busleavehud))
            {
                hud = newclienthudelem( player );
                hud.alignx = "center";
                hud.aligny = "middle";
                hud.horzalign = "center";
                hud.vertalign = "bottom";
                hud.y = -75;
                hud.foreground = 1;
                hud.hidewheninmenu = 1;
                hud.font = "default";
                hud.fontscale = 1;
                hud.alpha = 1;
                hud.color = ( 1, 1, 1 );
                hud.label = &"Bus departs in: ";
                hud setTimer( time );
                player.busleavehud = hud;
            }

            if (!is_true(player.isonbus))
            {
                player.busleavehud.alpha = 0;
            }
            else
            {
                player.busleavehud.alpha = 1;
            }
        }

        time -= 0.05;
        wait 0.05;
    }

    players = get_players();
    foreach (player in players)
    {
        if (isDefined(player.busleavehud))
        {
            player.busleavehud destroy();
            player.busleavehud = undefined;
        }
    }
}

busshowleavinghud_destroy_on_depart_early()
{
    self waittill("depart_early");

    players = get_players();
    foreach (player in players)
    {
        if (isDefined(player.busleavehud))
        {
            player.busleavehud destroy();
            player.busleavehud = undefined;
        }
    }
}

bus_bridge_speedcontrol()
{
    while ( true )
    {
        self waittill( "reached_node", nextpoint );

        if ( isdefined( nextpoint.script_string ) )
        {
            if (nextpoint.script_string == "map_out_tunnel" || nextpoint.script_string == "map_out_1forest" || nextpoint.script_string == "map_out_corn" || nextpoint.script_string == "map_out_2forest" || nextpoint.script_string == "map_out_bridge")
            {
                self setspeed( self.targetspeed / 2, 10, 10 );
            }
        }

        if ( isdefined( nextpoint.script_string ) )
        {
            if ( nextpoint.script_string == "arrival_slowdown" )
                self thread start_stopping_bus();

            if ( nextpoint.script_string == "arrival_slowdown_fast" )
                self thread start_stopping_bus( 1 );
        }

        if ( isdefined( nextpoint.script_noteworthy ) )
        {
            if ( nextpoint.script_noteworthy == "slow_down" )
            {
                self.targetspeed = 20;

                if ( isdefined( nextpoint.script_float ) )
                {
                    self.targetspeed = nextpoint.script_float * 2;
                }

                self setspeed( self.targetspeed, 160, 10 );
            }
            else if ( nextpoint.script_noteworthy == "turn_signal_left" || nextpoint.script_noteworthy == "turn_signal_right" )
                self thread buslightsignal( nextpoint.script_noteworthy );
            else if ( nextpoint.script_noteworthy == "resume_speed" )
            {
                self.targetspeed = 24;

                if ( isdefined( nextpoint.script_float ) )
                {
                    self.targetspeed = nextpoint.script_float * 2;
                }

                self setspeed( self.targetspeed, 120, 120 );
            }
            else if ( nextpoint.script_noteworthy == "emp_stop_point" )
                self notify( "reached_emp_stop_point" );
            else if ( nextpoint.script_noteworthy == "start_lava" )
                playfxontag( level._effect["bus_lava_driving"], self, "tag_origin" );
            else if ( nextpoint.script_noteworthy == "stop_lava" )
            {

            }
            else if ( nextpoint.script_noteworthy == "bus_scrape" )
                self playsound( "zmb_bus_car_scrape" );
            else if ( nextpoint.script_noteworthy == "arriving" )
            {
                self thread begin_arrival_slowdown();
                self thread play_bus_audio( "arriving" );
                level thread do_player_bus_zombie_vox( "bus_stop", 10 );
                self thread buslightsignal( "turn_signal_right" );
            }
            else if ( nextpoint.script_noteworthy == "enter_transition" )
                playfxontag( level._effect["fx_zbus_trans_fog"], self, "tag_headlights" );
            else if ( nextpoint.script_noteworthy == "bridge" )
            {
                level thread do_automaton_arrival_vox( "bridge" );
                player_near = 0;
                node = getvehiclenode( "bridge_accel_point", "script_noteworthy" );

                if ( isdefined( node ) )
                {
                    players = get_players();

                    foreach ( player in players )
                    {
                        if ( player.isonbus )
                            continue;

                        if ( distancesquared( player.origin, node.origin ) < 6760000 )
                            player_near = 1;
                    }
                }

                if ( player_near )
                {
                    trig = getent( "bridge_trig", "targetname" );
                    trig notify( "trigger" );
                }
            }
            else if ( nextpoint.script_noteworthy == "depot" )
            {
                volume = getent( "depot_lava_pit", "targetname" );
                traverse_volume = getent( "depot_pit_traverse", "targetname" );

                if ( isdefined( volume ) )
                {
                    zombies = getaiarray( level.zombie_team );

                    for ( i = 0; i < zombies.size; i++ )
                    {
                        if ( isdefined( zombies[i].depot_lava_pit ) )
                        {
                            if ( zombies[i] istouching( volume ) )
                                zombies[i] thread [[ zombies[i].depot_lava_pit ]]();

                            continue;
                        }

                        if ( zombies[i] istouching( volume ) )
                        {
                            zombies[i] dodamage( zombies[i].health + 100, zombies[i].origin );
                            continue;
                        }

                        if ( zombies[i] istouching( traverse_volume ) )
                            zombies[i] dodamage( zombies[i].health + 100, zombies[i].origin );
                    }
                }
            }
        }

        waittillframeend;
    }
}

start_stopping_bus( stop_fast )
{
    if ( isdefined( stop_fast ) && stop_fast )
        self setspeed( 4, 30 );
    else
        self setspeed( 4, 10 );
}

begin_arrival_slowdown()
{
    self setspeed( 10, 10, 10 );
}

buspathblockersetup()
{
    self.path_blockers = getentarray( "bus_path_blocker", "targetname" );

    for ( i = 0; i < self.path_blockers.size; i++ )
        self.path_blockers[i] linkto( self, "", self worldtolocalcoords( self.path_blockers[i].origin ), self.path_blockers[i].angles + self.angles );

    cow_catcher_blocker = getent( "cow_catcher_path_blocker", "targetname" );

    if ( isdefined( cow_catcher_blocker ) )
        cow_catcher_blocker linkto( self, "", self worldtolocalcoords( cow_catcher_blocker.origin ), cow_catcher_blocker.angles + self.angles );

    trig = getent( "bus_buyable_weapon1", "script_noteworthy" );
    trig enablelinkto();
    trig linkto( self, "", self worldtolocalcoords( trig.origin ), ( 0, 0, 0 ) );
    trig setinvisibletoall();
    self.buyable_weapon = trig;
    level._spawned_wallbuys[level._spawned_wallbuys.size] = trig;
    weapon_model = getent( trig.target, "targetname" );
    weapon_model.origin += (0, 0, 1);
    weapon_model linkto( self, "", self worldtolocalcoords( weapon_model.origin ), weapon_model.angles + self.angles );
    weapon_model setmovingplatformenabled( 1 );
    weapon_model._linked_ent = trig;
    weapon_model hide();

    self thread bus_buyable_weapon_unitrigger_setup(trig);
}

bus_buyable_weapon_unitrigger_setup(trig)
{
    unitrigger = undefined;
    while (!isDefined(unitrigger))
    {
        for(i = 0; i < level._unitriggers.trigger_stubs.size; i++)
        {
            if(IsDefined(level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade) && level._unitriggers.trigger_stubs[i].zombie_weapon_upgrade == "beretta93r_zm")
            {
                unitrigger = level._unitriggers.trigger_stubs[i];
                break;
            }
        }

        wait 1;
    }

    unitrigger.target = trig.target;
    unitrigger.origin_parent = trig;
    unitrigger.link_parent = trig;
    unitrigger.originfunc = ::bus_buyable_weapon_get_unitrigger_origin;
    unitrigger.onspawnfunc = ::bus_buyable_weapon_on_spawn_trigger;
}

bus_buyable_weapon_get_unitrigger_origin()
{
    return self.origin_parent.origin + (0, 0, -32);
}

bus_buyable_weapon_on_spawn_trigger(trigger)
{
    trigger enablelinkto();
    trigger linkto(self.link_parent);
    trigger setmovingplatformenabled(1);
}

busthink()
{
    no_danger = 0;
    self thread busupdatechasers();
    self thread busupdateplayers();
    self thread busupdatenearzombies();

    while ( true )
    {
        waittillframeend;
        self busupdatespeed();
        self busupdateignorewindows();

        if ( self.ismoving )
            self busupdatenearequipment();

        if ( !( isdefined( level.bus_zombie_danger ) && level.bus_zombie_danger ) && ( self.numplayersonroof || self.numplayersinsidebus ) )
        {
            no_danger++;

            if ( no_danger > 40 )
            {
                level thread do_player_bus_zombie_vox( "bus_zom_none", 40, 60 );
                no_danger = 0;
            }
        }
        else
            no_danger = 0;

        wait 0.1;
    }
}

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
                self.numplayersonroof++;
            }
            else if ( isdefined( player.isonbus ) && player.isonbus )
            {
                self.numplayersinsidebus++;
            }

            wait 0.05;
        }

        wait 0.05;
    }
}

busplowkillzombieuntildeath()
{
    self endon( "death" );

    while ( isdefined( self ) && isalive( self ) )
    {
        if ( isdefined( self.health ) )
        {
            self dodamage( self.health + 666, self.origin, self, self, "none", "MOD_SUICIDE" );
        }

        wait 1;
    }
}