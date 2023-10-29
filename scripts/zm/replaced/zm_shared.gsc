#include maps\mp\animscripts\zm_shared;
#include maps\mp\animscripts\utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\animscripts\zm_run;

dotraverse( traversestate, traversealias, no_powerups )
{
    self endon( "killanimscript" );
    self traversemode( "nogravity" );
    self traversemode( "noclip" );
    old_powerups = 0;

    if ( isdefined( no_powerups ) && no_powerups )
    {
        old_powerups = self.no_powerups;
        self.no_powerups = 1;
    }

    self.is_traversing = 1;
    self notify( "zombie_start_traverse" );
    self.traversestartnode = self getnegotiationstartnode();
    assert( isdefined( self.traversestartnode ) );
    self orientmode( "face angle", self.traversestartnode.angles[1] );
    self.traversestartz = self.origin[2];

    if ( isdefined( self.pre_traverse ) )
        self [[ self.pre_traverse ]]();

    self setanimstatefromasd( traversestate, traversealias );
    self maps\mp\animscripts\zm_shared::donotetracks( "traverse_anim" );
    self traversemode( "gravity" );
    self.a.nodeath = 0;

    if ( isdefined( self.post_traverse ) )
        self [[ self.post_traverse ]]();

    self maps\mp\animscripts\zm_run::needsupdate();

    if ( !self.isdog )
        self maps\mp\animscripts\zm_run::moverun();

    self.is_traversing = 0;
    self notify( "zombie_end_traverse" );

    if ( isdefined( no_powerups ) && no_powerups && is_true( self.no_powerups ) )
    {
        self.no_powerups = old_powerups;
    }
}