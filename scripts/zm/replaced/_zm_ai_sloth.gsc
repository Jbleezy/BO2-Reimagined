#include maps\mp\zombies\_zm_ai_sloth;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_ai_sloth_buildables;
#include maps\mp\zombies\_zm_ai_sloth_crawler;
#include maps\mp\zombies\_zm_ai_sloth_magicbox;
#include maps\mp\zombies\_zm_ai_sloth_utility;
#include maps\mp\zombies\_zm_ai_sloth_ffotd;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_equip_headchopper;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\animscripts\zm_death;
#include maps\mp\animscripts\zm_run;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\zombies\_zm_weap_time_bomb;

sloth_init_start_funcs()
{
    self.start_funcs = [];
    self.start_funcs["jail_idle"] = ::start_jail_idle;
    self.start_funcs["jail_cower"] = ::start_jail_cower;
    self.start_funcs["jail_open"] = ::start_jail_open;
    self.start_funcs["jail_run"] = ::start_jail_run;
    self.start_funcs["jail_wait"] = ::start_jail_wait;
    self.start_funcs["jail_close"] = ::start_jail_close;
    self.start_funcs["player_idle"] = ::start_player_idle;
    self.start_funcs["roam"] = ::start_roam;
    self.start_funcs["follow"] = ::start_follow;
    self.start_funcs["mansion"] = ::start_mansion;
    self.start_funcs["berserk"] = ::start_berserk;
    self.start_funcs["eat"] = ::start_eat;
    self.start_funcs["crash"] = ::start_crash;
    self.start_funcs["gunshop_run"] = ::start_gunshop_run;
    self.start_funcs["gunshop_candy"] = ::start_gunshop_candy;
    self.start_funcs["table_eat"] = ::start_table_eat;
    self.start_funcs["headbang"] = ::start_headbang;
    self.start_funcs["smell"] = ::start_smell;
    self.start_funcs["context"] = ::start_context;
}

sloth_init_update_funcs()
{
    self.update_funcs = [];
    self.update_funcs["jail_idle"] = ::update_jail_idle;
    self.update_funcs["jail_cower"] = ::update_jail_cower;
    self.update_funcs["jail_open"] = ::update_jail_open;
    self.update_funcs["jail_run"] = ::update_jail_run;
    self.update_funcs["jail_wait"] = ::update_jail_wait;
    self.update_funcs["jail_close"] = ::update_jail_close;
    self.update_funcs["player_idle"] = ::update_player_idle;
    self.update_funcs["roam"] = ::update_roam;
    self.update_funcs["follow"] = ::update_follow;
    self.update_funcs["mansion"] = ::update_mansion;
    self.update_funcs["berserk"] = ::update_berserk;
    self.update_funcs["eat"] = ::update_eat;
    self.update_funcs["crash"] = ::update_crash;
    self.update_funcs["gunshop_run"] = ::update_gunshop_run;
    self.update_funcs["gunshop_candy"] = ::update_gunshop_candy;
    self.update_funcs["table_eat"] = ::update_table_eat;
    self.update_funcs["headbang"] = ::update_headbang;
    self.update_funcs["smell"] = ::update_smell;
    self.update_funcs["context"] = ::update_context;
    self.locomotion_func = ::update_locomotion;
}

start_jail_run( do_pain )
{
    if ( self is_jail_state() )
        return false;

    if ( self.state == "berserk" || self.state == "crash" )
        return false;

    if ( self sloth_is_traversing() )
        return false;

    if ( self.state == "gunshop_candy" || self.state == "table_eat" )
    {
        if ( isdefined( self.bench ) )
        {
            if ( isdefined( level.weapon_bench_reset ) )
                self.bench [[ level.weapon_bench_reset ]]();
        }
    }

    self stop_action();
    self thread sndchangebreathingstate( "happy" );
    self thread action_jail_run( self.jail_start.origin, do_pain );

    if ( self.state == "context" )
    {
        if ( isdefined( self.context.interrupt ) )
            self [[ self.context.interrupt ]]();
    }

    self sloth_init_roam_point();
    thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.gift_trigger );
    return true;
}

action_jail_run( pos, do_pain )
{
    self.needs_action = 0;

    if ( isdefined( self.candy_model ) )
        self.candy_model ghost();

    if ( isdefined( self.booze_model ) )
        self.booze_model ghost();

    if ( is_true( do_pain ) )
    {
        if ( !self sloth_is_traversing() && !is_true( self.is_pain ) )
        {
            self.is_pain = 1;
            self setanimstatefromasd( "zm_pain" );
            self.reset_asd = "zm_pain";
            self thread finish_pain();
            maps\mp\animscripts\zm_shared::donotetracks( "pain_anim" );
            self notify( "pain_done" );
            self.is_pain = 0;
        }
    }

    while ( true )
    {
        if ( !self sloth_is_pain() )
            break;

        wait 0.1;
    }

    self.reset_asd = undefined;
    self animmode( "normal" );
    self set_zombie_run_cycle( "run" );
    self.locomotion = "run";
    self thread sloth_retreat_vo();
    self check_behind_mansion();

    if ( isdefined( self.mansion_goal ) )
    {
        self setgoalpos( self.mansion_goal.origin );

        self waittill( "goal" );

        self action_teleport_to_courtyard();
    }

    self.goalradius = 2;

    self setgoalpos( self.jail_start.origin + (0, 128, 0) );

    self waittill( "goal" );

    self.goalradius = 16;

    self orientmode( "face angle", self.jail_start.angles[1] );

    wait 0.5;

    self.needs_action = 1;
}

start_jail_wait()
{
    self stopanimscripted();
    self action_jail_wait();
    self thread sndchangebreathingstate( "happy" );
    return 1;
}

action_jail_wait()
{
    self.needs_action = 0;
    self setgoalpos( self.origin );
    self.anchor.origin = self.origin;
    self.anchor.angles = self.angles;
    self linkto( self.anchor );
    self setanimstatefromasd( "zm_idle_protect" );
    self.needs_action = 1;
}

update_jail_idle()
{
    if ( is_true( self.open_jail ) )
    {
        level notify( "cell_open" );
        self.open_jail = 0;
    }

    if ( is_true( level.cell_open ) )
    {
        self stop_action();
        self sloth_set_state( "jail_idle" );
    }
}

update_jail_wait()
{
    if (is_true(self.dance_action))
    {
        return;
    }

    players = get_players();

    foreach ( player in players )
    {
        if ( player maps\mp\zombies\_zm_zonemgr::entity_in_zone( "zone_underground_jail" ) )
        {
            return;
        }
    }

    if ( self.needs_action )
        self sloth_set_state( "jail_close" );
}

update_eat()
{
    if ( is_true( self.needs_action ) )
    {
        self setclientfield( "sloth_eating", 0 );

        if ( isdefined( self.candy_model ) )
            self.candy_model ghost();

        context = self check_contextual_actions();

        if ( isdefined( context ) )
        {
            self sloth_set_state( "context", context );
            return;
        }

        self sloth_set_state( "roam" );
    }
}

sloth_check_ragdolls( ignore_zombie )
{
    non_ragdoll = 0;
    zombies = getaispeciesarray( level.zombie_team, "all" );

    for ( i = 0; i < zombies.size; i++ )
    {
        zombie = zombies[i];

        if ( is_true( zombie.is_sloth ) )
            continue;

        if ( isdefined( ignore_zombie ) && zombie == ignore_zombie )
            continue;

        if ( isdefined( self.crawler ) && zombie == self.crawler )
            continue;

        if ( self is_facing( zombie ) )
        {
            dist = distancesquared( self.origin, zombie.origin );

            if ( dist < 4096 )
            {
                if ( !self sloth_ragdoll_zombie( zombie ) )
                {
                    if ( !is_true( self.no_gib ) && non_ragdoll % 3 == 0 )
                    {
                        zombie.force_gib = 1;
                        zombie.a.gib_ref = random( array( "guts", "right_arm", "left_arm", "head" ) );
                        zombie thread maps\mp\animscripts\zm_death::do_gib();
                    }

                    non_ragdoll++;
                    zombie dodamage( zombie.health * 10, zombie.origin );
                    zombie playsound( "zmb_ai_sloth_attack_impact" );
                    zombie.noragdoll = 1;
                    zombie.nodeathragdoll = 1;
                }

                if ( isdefined( self.target_zombie ) && self.target_zombie == zombie )
                    self.target_zombie = undefined;
            }
        }
    }
}

sloth_ragdoll_zombie( zombie )
{
    if ( !isdefined( self.ragdolls ) )
        self.ragdolls = 0;

    if ( self.ragdolls < 4 )
    {
        self.ragdolls++;
        zombie dodamage( zombie.health * 10, zombie.origin );
        zombie playsound( "zmb_ai_sloth_attack_impact" );
        zombie startragdoll();
        zombie setclientfield( "sloth_ragdoll_zombie", 1 );
        self thread sloth_ragdoll_wait();
        return true;
    }

    return false;
}

wait_start_candy_booze( piece )
{
    // remove
}