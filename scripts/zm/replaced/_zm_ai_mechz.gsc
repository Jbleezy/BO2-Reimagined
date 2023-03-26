#include maps\mp\zombies\_zm_zonemgr;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zombies\_zm_ai_mechz_dev;
#include maps\mp\zombies\_zm_ai_mechz_claw;
#include maps\mp\zombies\_zm_ai_mechz_ft;
#include maps\mp\zombies\_zm_ai_mechz_booster;
#include maps\mp\zombies\_zm_ai_mechz_ffotd;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zombies\_zm_ai_basic;

mechz_set_starting_health()
{
    self.maxhealth = level.mechz_health;
    self.helmet_dmg = 0;
    self.helmet_dmg_for_removal = self.maxhealth * level.mechz_helmet_health_percentage;
    self.powerplant_cover_dmg = 0;
    self.powerplant_cover_dmg_for_removal = self.maxhealth * level.mechz_powerplant_expose_health_percentage;
    self.powerplant_dmg = 0;
    self.powerplant_dmg_for_destroy = self.maxhealth * level.mechz_powerplant_destroyed_health_percentage;
    level.mechz_explosive_dmg_to_cancel_claw = self.maxhealth * level.mechz_explosive_dmg_to_cancel_claw_percentage;

    self.health = level.mechz_health;
    self.non_attacker_func = ::mechz_non_attacker_damage_override;
    self.non_attack_func_takes_attacker = 1;
    self.actor_damage_func = ::mechz_damage_override;
    self.instakill_func = ::mechz_instakill_override;
    self.nuke_damage_func = ::mechz_nuke_override;
}

mechz_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, poffsettime, boneindex )
{
    num_tiers = level.mechz_armor_info.size + 1;
    old_health_tier = int( num_tiers * self.health / self.maxhealth );
    bonename = getpartname( "c_zom_mech_body", boneindex );

    if ( isdefined( attacker ) && isalive( attacker ) && isplayer( attacker ) && ( level.zombie_vars[attacker.team]["zombie_insta_kill"] || isdefined( attacker.personal_instakill ) && attacker.personal_instakill ) )
    {
        n_mechz_damage_percent = 1.0;
        n_mechz_headshot_modifier = 2.0;
    }
    else
    {
        n_mechz_damage_percent = level.mechz_damage_percent;
        n_mechz_headshot_modifier = 1.0;
    }

    if ( isdefined( weapon ) && is_weapon_shotgun( weapon ) )
    {
        n_mechz_damage_percent *= level.mechz_shotgun_damage_mod;
        n_mechz_headshot_modifier *= level.mechz_shotgun_damage_mod;
    }

    if ( damage <= 10 )
        n_mechz_damage_percent = 1.0;

    if ( ( is_explosive_damage( meansofdeath ) && weapon != "c96_upgraded_zm" && weapon != "raygun_mark2_zm" && weapon != "raygun_mark2_upgraded_zm" ) || issubstr( weapon, "staff" ) )
    {
        if ( n_mechz_damage_percent < 0.5 )
            n_mechz_damage_percent = 0.5;

        if ( !( isdefined( self.has_helmet ) && self.has_helmet ) && issubstr( weapon, "staff" ) && n_mechz_damage_percent < 1.0 )
            n_mechz_damage_percent = 1.0;

        final_damage = damage * n_mechz_damage_percent;

        if ( !isdefined( self.explosive_dmg_taken ) )
            self.explosive_dmg_taken = 0;

        self.explosive_dmg_taken += final_damage;
        self.helmet_dmg += final_damage;

        if ( isdefined( self.explosive_dmg_taken_on_grab_start ) )
        {
            if ( isdefined( self.e_grabbed ) && self.explosive_dmg_taken - self.explosive_dmg_taken_on_grab_start > level.mechz_explosive_dmg_to_cancel_claw )
            {
                if ( isdefined( self.has_helmet ) && self.has_helmet && self.helmet_dmg < self.helmet_dmg_for_removal || !( isdefined( self.has_helmet ) && self.has_helmet ) )
                    self thread mechz_claw_shot_pain_reaction();

                self thread ent_released_from_claw_grab_achievement( attacker, self.e_grabbed );
                self thread mechz_claw_release();
            }
        }
    }
    else if ( shitloc != "head" && shitloc != "helmet" )
    {
        if ( bonename == "tag_powersupply" )
        {
            final_damage = damage * n_mechz_damage_percent;

            if ( !( isdefined( self.powerplant_covered ) && self.powerplant_covered ) )
                self.powerplant_dmg += final_damage;
            else
                self.powerplant_cover_dmg += final_damage;
        }

        if ( isdefined( self.e_grabbed ) && ( shitloc == "left_hand" || shitloc == "left_arm_lower" || shitloc == "left_arm_upper" ) )
        {
            if ( isdefined( self.e_grabbed ) )
                self thread mechz_claw_shot_pain_reaction();

            self thread ent_released_from_claw_grab_achievement( attacker, self.e_grabbed );
            self thread mechz_claw_release( 1 );
        }

        final_damage = damage * n_mechz_damage_percent;
    }
    else if ( !( isdefined( self.has_helmet ) && self.has_helmet ) )
        final_damage = damage * n_mechz_headshot_modifier;
    else
    {
        final_damage = damage * n_mechz_damage_percent;
        self.helmet_dmg += final_damage;
    }

    if ( !isdefined( weapon ) || weapon == "none" )
    {
        if ( !isplayer( attacker ) )
            final_damage = 0;
    }

    new_health_tier = int( num_tiers * ( self.health - final_damage ) / self.maxhealth );

    if ( old_health_tier > new_health_tier )
    {
        while ( old_health_tier > new_health_tier )
        {
            if ( old_health_tier < num_tiers )
                self mechz_launch_armor_piece();

            old_health_tier--;
        }
    }

    if ( isdefined( self.has_helmet ) && self.has_helmet && self.helmet_dmg >= self.helmet_dmg_for_removal )
    {
        self.has_helmet = 0;
        self detach( "c_zom_mech_faceplate", "J_Helmet" );

        if ( sndmechzisnetworksafe( "destruction" ) )
            self playsound( "zmb_ai_mechz_destruction" );

        if ( sndmechzisnetworksafe( "angry" ) )
            self playsound( "zmb_ai_mechz_vox_angry" );

        self.fx_field |= 1024;
        self.fx_field &= ~2048;
        self setclientfield( "mechz_fx", self.fx_field );

        if ( !( isdefined( self.not_interruptable ) && self.not_interruptable ) && !( isdefined( self.is_traversing ) && self.is_traversing ) )
        {
            self mechz_interrupt();
            self animscripted( self.origin, self.angles, "zm_pain_faceplate" );
            self maps\mp\animscripts\zm_shared::donotetracks( "pain_anim_faceplate" );
        }

        self thread shoot_mechz_head_vo();
    }

    if ( isdefined( self.powerplant_covered ) && self.powerplant_covered && self.powerplant_cover_dmg >= self.powerplant_cover_dmg_for_removal )
    {
        self.powerplant_covered = 0;
        self detach( "c_zom_mech_powersupply_cap", "tag_powersupply" );
        cap_model = spawn( "script_model", self gettagorigin( "tag_powersupply" ) );
        cap_model.angles = self gettagangles( "tag_powersupply" );
        cap_model setmodel( "c_zom_mech_powersupply_cap" );
        cap_model physicslaunch( cap_model.origin, anglestoforward( cap_model.angles ) );
        cap_model thread mechz_delayed_item_delete();

        if ( sndmechzisnetworksafe( "destruction" ) )
            self playsound( "zmb_ai_mechz_destruction" );

        if ( !( isdefined( self.not_interruptable ) && self.not_interruptable ) && !( isdefined( self.is_traversing ) && self.is_traversing ) )
        {
            self mechz_interrupt();
            self animscripted( self.origin, self.angles, "zm_pain_powercore" );
            self maps\mp\animscripts\zm_shared::donotetracks( "pain_anim_powercore" );
        }
    }
    else if ( !( isdefined( self.powerplant_covered ) && self.powerplant_covered ) && ( isdefined( self.has_powerplant ) && self.has_powerplant ) && self.powerplant_dmg >= self.powerplant_dmg_for_destroy )
    {
        self.has_powerplant = 0;
        self thread mechz_stun( level.mechz_powerplant_stun_time );

        if ( sndmechzisnetworksafe( "destruction" ) )
            self playsound( "zmb_ai_mechz_destruction" );
    }

    return final_damage;
}