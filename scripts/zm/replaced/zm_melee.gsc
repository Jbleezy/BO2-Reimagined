#include common_scripts\utility;
#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\zm_combat;
#include maps\mp\animscripts\zm_melee;

meleecombat()
{
    self endon( "end_melee" );
    self endon( "killanimscript" );
    assert( canmeleeanyrange() );
    self orientmode( "face enemy" );

    if ( is_true( self.sliding_on_goo ) )
        self animmode( "slide" );
    else
        self animmode( "zonly_physics" );

    for (;;)
    {
        if ( isdefined( self.marked_for_death ) )
            return;

        if ( isdefined( self.enemy ) )
        {
            angles = vectortoangles( self.enemy.origin - self.origin );
            self orientmode( "face angle", angles[1] );
        }

        if ( isdefined( self.zmb_vocals_attack ) )
            self playsound( self.zmb_vocals_attack );

        if ( isdefined( self.nochangeduringmelee ) && self.nochangeduringmelee )
            self.safetochangescript = 0;

        if ( isdefined( self.is_inert ) && self.is_inert )
            return;

        set_zombie_melee_anim_state( self );

        if ( isdefined( self.melee_anim_func ) )
            self thread [[ self.melee_anim_func ]]();

        while ( true )
        {
            self waittill( "melee_anim", note );

            if ( note == "end" )
                break;
            else if ( note == "fire" )
            {
                if ( !isdefined( self.enemy ) )
                    break;

                if ( isdefined( self.dont_die_on_me ) && self.dont_die_on_me )
                    break;

                if ( is_true( self.enemy.zombie_vars["zombie_powerup_zombie_blood_on"] ) )
                    break;

                self.enemy notify( "melee_swipe", self );
                oldhealth = self.enemy.health;
                self melee();

                if ( !isdefined( self.enemy ) )
                    break;

                if ( self.enemy.health >= oldhealth )
                {
                    if ( isdefined( self.melee_miss_func ) )
                        self [[ self.melee_miss_func ]]();
                    else if ( isdefined( level.melee_miss_func ) )
                        self [[ level.melee_miss_func ]]();
                }
            }
            else if ( note == "stop" )
            {
                if ( !cancontinuetomelee() )
                    break;
            }
        }

        if ( is_true( self.sliding_on_goo ) )
            self orientmode( "face enemy" );
        else
            self orientmode( "face default" );

        if ( isdefined( self.nochangeduringmelee ) && self.nochangeduringmelee || is_true( self.sliding_on_goo ) )
        {
            if ( isdefined( self.enemy ) )
            {
                dist_sq = distancesquared( self.origin, self.enemy.origin );

                if ( dist_sq > self.meleeattackdist * self.meleeattackdist )
                {
                    self.safetochangescript = 1;
                    wait 0.1;
                    break;
                }
            }
            else
            {
                self.safetochangescript = 1;
                wait 0.1;
                break;
            }
        }
    }

    if ( is_true( self.sliding_on_goo ) )
        self animmode( "slide" );
    else
        self animmode( "none" );

    self thread maps\mp\animscripts\zm_combat::main();
}