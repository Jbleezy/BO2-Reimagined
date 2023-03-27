#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_ai_screecher;
#include maps\mp\_visionset_mgr;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_stats;

screecher_detach( player )
{
    self endon( "death" );
    self.state = "detached";

    if ( !isdefined( self.linked_ent ) )
        return;

    if ( isdefined( player ) )
    {
        player clientnotify( "scrEnd" );

        player allowprone( 1 );

        player takeweapon( "screecher_arms_zm" );

        if ( !getdvarint( _hash_E7EF8EB7 ) )
            player stoppoisoning();

        if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !( isdefined( player.intermission ) && player.intermission ) )
            player decrement_is_drinking();

        if ( isdefined( player.screecher_weapon ) && player.screecher_weapon != "none" && is_player_valid( player ) && !is_equipment_that_blocks_purchase( player.screecher_weapon ) )
            player switchtoweapon( player.screecher_weapon );
        else if ( flag( "solo_game" ) && player hasperk( "specialty_quickrevive" ) )
        {

        }
        else if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
        {
            primaryweapons = player getweaponslistprimaries();

            if ( isdefined( primaryweapons ) && primaryweapons.size > 0 )
                player switchtoweapon( primaryweapons[0] );
        }

        player.screecher_weapon = undefined;
    }

    self unlink();
    self setclientfield( "render_third_person", 0 );

    if ( isdefined( self.linked_ent ) )
    {
        self.linked_ent.screecher = undefined;
        self.linked_ent setmovespeedscale( 1 );
        self.linked_ent = undefined;
    }

    self.green_light = player.green_light;
    self animcustom( ::screecher_jump_down );

    self waittill( "jump_down_done" );

    maps\mp\_visionset_mgr::vsmgr_deactivate( "overlay", "zm_ai_screecher_blur", player );
    self animmode( "normal" );
    self.ignoreall = 1;
    self setplayercollision( 1 );

    if ( isdefined( level.screecher_should_burrow ) )
    {
        if ( self [[ level.screecher_should_burrow ]]() )
        {
            return;
        }
    }

    self thread screecher_runaway();
}

screecher_cleanup()
{
    self waittill( "death", attacker );

    if ( isdefined( attacker ) && isplayer( attacker ) )
    {
        if ( isdefined( self.damagelocation ) && isdefined( self.damagemod ) )
            level thread maps\mp\zombies\_zm_audio::player_zombie_kill_vox( self.damagelocation, attacker, self.damagemod, self );
    }

    if ( isdefined( self.loopsoundent ) )
    {
        self.loopsoundent delete();
        self.loopsoundent = undefined;
    }

    player = self.linked_ent;

    if ( isdefined( player ) )
    {
        player playsound( "zmb_vocals_screecher_death" );
        player setmovespeedscale( 1 );
        maps\mp\_visionset_mgr::vsmgr_deactivate( "overlay", "zm_ai_screecher_blur", player );

        if ( isdefined( player.screecher_weapon ) )
        {
            player clientnotify( "scrEnd" );

            player allowprone( 1 );

            player takeweapon( "screecher_arms_zm" );

            if ( !getdvarint( _hash_E7EF8EB7 ) )
                player stoppoisoning();

            if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !( isdefined( player.intermission ) && player.intermission ) )
                player decrement_is_drinking();

            if ( player.screecher_weapon != "none" && is_player_valid( player ) )
                player switchtoweapon( player.screecher_weapon );
            else
            {
                primaryweapons = player getweaponslistprimaries();

                if ( isdefined( primaryweapons ) && primaryweapons.size > 0 )
                    player switchtoweapon( primaryweapons[0] );
            }

            player.screecher_weapon = undefined;
        }
    }

    if ( isdefined( self.claw_fx ) )
        self.claw_fx destroy();

    if ( isdefined( self.anchor ) )
        self.anchor delete();

    if ( isdefined( level.screecher_cleanup ) )
        self [[ level.screecher_cleanup ]]();

    if ( level.zombie_screecher_count > 0 )
    {
        level.zombie_screecher_count--;
    }
}