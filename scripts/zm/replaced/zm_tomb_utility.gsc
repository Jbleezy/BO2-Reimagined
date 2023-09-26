#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_chamber;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_tank;
#include maps\mp\zm_tomb_craftables;
#include maps\mp\zm_tomb_utility;

capture_zombie_spawn_init( animname_set = 0 )
{
    self.targetname = "capture_zombie_ai";

    if ( !animname_set )
        self.animname = "zombie";

    self.sndname = "capzomb";

    if ( isdefined( get_gamemode_var( "pre_init_zombie_spawn_func" ) ) )
        self [[ get_gamemode_var( "pre_init_zombie_spawn_func" ) ]]();

    self thread play_ambient_zombie_vocals();
    self.zmb_vocals_attack = "zmb_vocals_capzomb_attack";
    self.no_damage_points = 1;
    self.deathpoints_already_given = 1;
    self.ignore_enemy_count = 1;
    self.ignoreall = 1;
    self.ignoreme = 1;
    self.allowdeath = 1;
    self.force_gib = 1;
    self.is_zombie = 1;
    self.has_legs = 1;
    self allowedstances( "stand" );
    self.zombie_damaged_by_bar_knockdown = 0;
    self.gibbed = 0;
    self.head_gibbed = 0;
    self.disablearrivals = 1;
    self.disableexits = 1;
    self.grenadeawareness = 0;
    self.badplaceawareness = 0;
    self.ignoresuppression = 1;
    self.suppressionthreshold = 1;
    self.nododgemove = 1;
    self.dontshootwhilemoving = 1;
    self.pathenemylookahead = 0;
    self.badplaceawareness = 0;
    self.chatinitialized = 0;
    self.a.disablepain = 1;
    self disable_react();

    if ( isdefined( level.zombie_health ) )
    {
        self.maxhealth = level.zombie_health;

        if ( isdefined( level.zombie_respawned_health ) && level.zombie_respawned_health.size > 0 )
        {
            self.health = level.zombie_respawned_health[0];
            arrayremovevalue( level.zombie_respawned_health, level.zombie_respawned_health[0] );
        }
        else
            self.health = level.zombie_health;
    }
    else
    {
        self.maxhealth = level.zombie_vars["zombie_health_start"];
        self.health = self.maxhealth;
    }

    self.freezegun_damage = 0;
    self.dropweapon = 0;
    level thread zombie_death_event( self );
    self set_zombie_run_cycle();
    self thread dug_zombie_think();
    self thread zombie_gib_on_damage();
    self thread zombie_damage_failsafe();
    self thread enemy_death_detection();

    if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
    {
        if ( !( isdefined( self.is_inert ) && self.is_inert ) )
            self thread delayed_zombie_eye_glow();
    }

    self.deathfunction = ::zombie_death_animscript;
    self.flame_damage_time = 0;
    self.meleedamage = 50;
    self.no_powerups = 1;
    self zombie_history( "zombie_spawn_init -> Spawned = " + self.origin );
    self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
    self.tesla_head_gib_func = ::zombie_tesla_head_gib;
    self.team = level.zombie_team;

    if ( isdefined( get_gamemode_var( "post_init_zombie_spawn_func" ) ) )
        self [[ get_gamemode_var( "post_init_zombie_spawn_func" ) ]]();

    self.zombie_init_done = 1;
    self notify( "zombie_init_done" );
}

update_staff_accessories( n_element_index )
{
    cur_weapon = self get_player_melee_weapon();

    if ( !issubstr( cur_weapon, "one_inch_punch" ) )
    {
        weapon_to_keep = "knife_zm";
        self.use_staff_melee = 0;

        if ( n_element_index != 0 )
        {
            staff_info = maps\mp\zm_tomb_craftables::get_staff_info_from_element_index( n_element_index );

            if ( staff_info.charger.is_charged )
                staff_info = staff_info.upgrade;

            if ( isdefined( staff_info.melee ) )
            {
                weapon_to_keep = staff_info.melee;
                self.use_staff_melee = 1;
            }
        }

        melee_changed = 0;

        if ( cur_weapon != weapon_to_keep )
        {
            self takeweapon( cur_weapon );
            self giveweapon( weapon_to_keep );
            self set_player_melee_weapon( weapon_to_keep );
            melee_changed = 1;
        }
    }
    else if ( issubstr( cur_weapon, "one_inch_punch" ) && is_true( self.b_punch_upgraded ) )
    {
        self.str_punch_element = get_punch_element_from_index(n_element_index);
        weapon_to_keep = "one_inch_punch_" + self.str_punch_element + "_zm";

        if ( cur_weapon != weapon_to_keep )
        {
            self takeweapon( cur_weapon );
            self giveweapon( weapon_to_keep );
            self set_player_melee_weapon( weapon_to_keep );
        }
    }

    has_revive = self hasweapon( "staff_revive_zm" );
    has_upgraded_staff = 0;
    a_weapons = self getweaponslistprimaries();
    staff_info = maps\mp\zm_tomb_craftables::get_staff_info_from_element_index( n_element_index );

    foreach ( str_weapon in a_weapons )
    {
        if ( is_weapon_upgraded_staff( str_weapon ) )
            has_upgraded_staff = 1;
    }

    if ( has_revive && !has_upgraded_staff )
    {
        self setactionslot( 3, "altmode" );
        self takeweapon( "staff_revive_zm" );
    }
    else if ( !has_revive && has_upgraded_staff )
    {
        self setactionslot( 3, "weapon", "staff_revive_zm" );
        self giveweapon( "staff_revive_zm" );

        if ( isdefined( staff_info ) && isdefined( staff_info.upgrade.revive_ammo_stock ) )
        {
            if ( staff_info.upgrade.revive_ammo_clip < 1 && staff_info.upgrade.revive_ammo_stock >= 1 )
            {
                staff_info.upgrade.revive_ammo_clip += 1;
                staff_info.upgrade.revive_ammo_stock -= 1;
            }

            self setweaponammostock( "staff_revive_zm", staff_info.upgrade.revive_ammo_stock );
            self setweaponammoclip( "staff_revive_zm", staff_info.upgrade.revive_ammo_clip );
        }
        else
        {
            self setweaponammostock( "staff_revive_zm", 3 );
            self setweaponammoclip( "staff_revive_zm", 1 );
        }
    }
}

get_punch_element_from_index(ind)
{
    if ( ind == 1 )
    {
        return "fire";
    }
    else if ( ind == 2 )
    {
        return "air";
    }
    else if ( ind == 3 )
    {
        return "lightning";
    }
    else if ( ind == 4 )
    {
        return "ice";
    }

    return "upgraded";
}

check_solo_status()
{
    level.is_forever_solo_game = 0;
}