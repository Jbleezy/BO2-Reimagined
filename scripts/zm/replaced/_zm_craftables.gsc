#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_demo;

choose_open_craftable( player )
{
    self endon( "kill_choose_open_craftable" );
    n_playernum = player getentitynumber();
    self.b_open_craftable_checking_input = 1;
    b_got_input = 1;
    hinttexthudelem = newclienthudelem( player );
    hinttexthudelem.alignx = "center";
    hinttexthudelem.aligny = "middle";
    hinttexthudelem.horzalign = "center";
    hinttexthudelem.vertalign = "bottom";
    hinttexthudelem.y = -100;

    if ( player issplitscreen() )
        hinttexthudelem.y = -50;

    hinttexthudelem.foreground = 1;
    hinttexthudelem.hidewheninmenu = 1;
    hinttexthudelem.font = "default";
    hinttexthudelem.fontscale = 1.0;
    hinttexthudelem.alpha = 1;
    hinttexthudelem.color = ( 1, 1, 1 );
    hinttexthudelem settext( &"ZM_CRAFTABLES_CHANGE_BUILD" );

    if ( !isdefined( self.opencraftablehudelem ) )
        self.opencraftablehudelem = [];

    self.opencraftablehudelem[n_playernum] = hinttexthudelem;

    while ( isdefined( self.playertrigger[n_playernum] ) && !self.crafted )
    {
        if (!player isTouching(self.playertrigger[n_playernum]) || !player is_player_looking_at( self.playertrigger[n_playernum].origin, 0.76 ) || player isSprinting() || player isThrowingGrenade())
		{
			self.opencraftablehudelem[n_playernum].alpha = 0;
			wait 0.05;
			continue;
		}

        self.opencraftablehudelem[n_playernum].alpha = 1;

        if ( player actionslotonebuttonpressed() )
        {
            self.n_open_craftable_choice++;
            b_got_input = 1;
        }
        else if ( player actionslottwobuttonpressed() )
        {
            self.n_open_craftable_choice--;
            b_got_input = 1;
        }

        if ( self.n_open_craftable_choice >= self.a_uts_open_craftables_available.size )
            self.n_open_craftable_choice = 0;
        else if ( self.n_open_craftable_choice < 0 )
            self.n_open_craftable_choice = self.a_uts_open_craftables_available.size - 1;

        if ( b_got_input )
        {
            self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
            self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
            self.playertrigger[n_playernum] sethintstring( self.hint_string );
            b_got_input = 0;
        }

        wait 0.05;
    }

    self.b_open_craftable_checking_input = 0;
    self.opencraftablehudelem[n_playernum] destroy();
    self.opencraftablehudelem[n_playernum] = undefined;
}