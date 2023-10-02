#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_powerup_zombie_blood;
#include maps\mp\zm_tomb_dig;

init_shovel()
{
    precachemodel( "p6_zm_tm_dig_mound" );
    precachemodel( "p6_zm_tm_dig_mound_blood" );
    precachemodel( "p6_zm_tm_shovel" );
    precachemodel( "zombie_pickup_perk_bottle" );
    precachemodel( "t6_wpn_claymore_world" );
    maps\mp\zombies\_zm_audio_announcer::createvox( "blood_money", "powerup_blood_money" );
    onplayerconnect_callback( ::init_shovel_player );

    level.get_player_perk_purchase_limit = ::get_player_perk_purchase_limit;
    level.bonus_points_powerup_override = ::bonus_points_powerup_override;
    level thread dig_powerups_tracking();
    level thread dig_spots_init();
    registerclientfield( "world", "shovel_player1", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "shovel_player2", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "shovel_player3", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "shovel_player4", 14000, 2, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player1", 14000, 1, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player2", 14000, 1, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player3", 14000, 1, "int", undefined, 0 );
    registerclientfield( "world", "helmet_player4", 14000, 1, "int", undefined, 0 );
}

init_shovel_player()
{
    self.dig_vars["has_shovel"] = 1;
    self.dig_vars["has_upgraded_shovel"] = 0;
    self.dig_vars["has_helmet"] = 0;
    self.dig_vars["n_spots_dug"] = 0;
    self.dig_vars["n_losing_streak"] = 0;

	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 1 );

	self thread dig_disconnect_watch( n_player );
}

dig_disconnect_watch( n_player )
{
	self waittill( "disconnect" );
	level setclientfield( "shovel_player" + n_player, 0 );
	level setclientfield( "helmet_player" + n_player, 0 );
}

waittill_dug( s_dig_spot )
{
    while ( true )
    {
        self waittill( "trigger", player );

        if ( isdefined( player.dig_vars["has_shovel"] ) && player.dig_vars["has_shovel"] )
        {
            player playsound( "evt_dig" );
            s_dig_spot.dug = 1;
            level.n_dig_spots_cur--;
            playfx( level._effect["digging"], self.origin );
            player setclientfieldtoplayer( "player_rumble_and_shake", 1 );
            player maps\mp\zombies\_zm_stats::increment_client_stat( "tomb_dig", 0 );
            player maps\mp\zombies\_zm_stats::increment_player_stat( "tomb_dig" );
            s_staff_piece = s_dig_spot maps\mp\zm_tomb_main_quest::dig_spot_get_staff_piece( player );

            if ( isdefined( s_staff_piece ) )
            {
                s_staff_piece maps\mp\zm_tomb_main_quest::show_ice_staff_piece( self.origin );
                player dig_reward_dialog( "dig_staff_part" );
            }
            else
            {
                n_good_chance = 50;

                if ( player.dig_vars["n_spots_dug"] == 0 || player.dig_vars["n_losing_streak"] == 3 )
                {
                    player.dig_vars["n_losing_streak"] = 0;
                    n_good_chance = 100;
                }

                if ( player.dig_vars["has_upgraded_shovel"] )
                {
                    if ( !player.dig_vars["has_helmet"] )
                    {
                        player.dig_vars["n_spots_dug"]++;

                        if ( player.dig_vars["n_spots_dug"] >= 40 )
                        {
                            player.dig_vars["has_helmet"] = 1;
                            n_player = player getentitynumber() + 1;
                            level setclientfield( "helmet_player" + n_player, 1 );
                            player playsoundtoplayer( "zmb_squest_golden_anything", player );
                            player maps\mp\zombies\_zm_stats::increment_client_stat( "tomb_golden_hard_hat", 0 );
                            player maps\mp\zombies\_zm_stats::increment_player_stat( "tomb_golden_hard_hat" );
                            return;
                        }
                    }

                    n_good_chance = 70;
                }

                n_prize_roll = randomint( 100 );

                if ( n_prize_roll > n_good_chance )
                {
                    if ( cointoss() )
                    {
                        player dig_reward_dialog( "dig_grenade" );
                        self thread dig_up_grenade( player );
                    }
                    else
                    {
                        player dig_reward_dialog( "dig_zombie" );
                        self thread dig_up_zombie( player, s_dig_spot );
                    }

                    player.dig_vars["n_losing_streak"]++;
                }
                else if ( cointoss() )
                    self thread dig_up_powerup( player );
                else
                {
                    player dig_reward_dialog( "dig_gun" );
                    self thread dig_up_weapon( player );
                }
            }

            if ( !player.dig_vars["has_upgraded_shovel"] )
            {
                player.dig_vars["n_spots_dug"]++;

                if ( player.dig_vars["n_spots_dug"] >= 20 )
                {
                    player.dig_vars["has_upgraded_shovel"] = 1;
                    player thread ee_zombie_blood_dig();
                    n_player = player getentitynumber() + 1;
                    level setclientfield( "shovel_player" + n_player, 2 );
                    player playsoundtoplayer( "zmb_squest_golden_anything", player );
                    player maps\mp\zombies\_zm_stats::increment_client_stat( "tomb_golden_shovel", 0 );
                    player maps\mp\zombies\_zm_stats::increment_player_stat( "tomb_golden_shovel" );
                }
            }

            return;
        }
    }
}

increment_player_perk_purchase_limit()
{
    perk = maps\mp\zombies\_zm_perk_random::get_weighted_random_perk(self);

    if (self hasPerk(perk))
    {
        return;
    }

    self maps\mp\zombies\_zm_perks::give_perk(perk);
}

dig_up_weapon( digger )
{
    a_common_weapons = array( "ballista_zm", "c96_zm", "870mcs_zm" );
    a_rare_weapons = array( "dsr50_zm", "srm1216_zm" );

    if ( digger.dig_vars["has_upgraded_shovel"] )
        a_rare_weapons = combinearrays( a_rare_weapons, array( "claymore_zm", "ak74u_zm", "ksg_zm", "mp40_zm", "mp44_zm" ) );

    str_weapon = undefined;

    if ( randomint( 100 ) < 90 )
        str_weapon = a_common_weapons[getarraykeys( a_common_weapons )[randomint( getarraykeys( a_common_weapons ).size )]];
    else
        str_weapon = a_rare_weapons[getarraykeys( a_rare_weapons )[randomint( getarraykeys( a_rare_weapons ).size )]];

    v_spawnpt = self.origin + ( 0, 0, 40 );
    v_spawnang = ( 0, 0, 0 );
    str_spec_model = undefined;

    if ( str_weapon == "claymore_zm" )
    {
        str_spec_model = "t6_wpn_claymore_world";
        v_spawnang += vectorscale( ( 0, 1, 0 ), 90.0 );
    }

    v_angles = digger getplayerangles();
    v_angles = ( 0, v_angles[1], 0 ) + vectorscale( ( 0, 1, 0 ), 90.0 ) + v_spawnang;
    m_weapon = spawn_weapon_model( str_weapon, str_spec_model, v_spawnpt, v_angles );

    if ( str_weapon == "claymore_zm" )
    {
        m_weapon setmodel( "t6_wpn_claymore_world" );
        v_spawnang += vectorscale( ( 0, 0, 1 ), 90.0 );
    }

    m_weapon.angles = v_angles;
    m_weapon playloopsound( "evt_weapon_digup" );
    m_weapon thread timer_til_despawn( v_spawnpt, 40 * -1 );
    m_weapon endon( "dig_up_weapon_timed_out" );
    playfxontag( level._effect["special_glow"], m_weapon, "tag_origin" );
    m_weapon.trigger = tomb_spawn_trigger_radius( v_spawnpt, 100, 1 );
    m_weapon.trigger.hint_string = &"ZM_TOMB_X2PU";
    m_weapon.trigger.hint_parm1 = getweapondisplayname( str_weapon );

    while (1)
    {
        m_weapon.trigger waittill( "trigger", player );

        current_weapon = player getCurrentWeapon();

        if ( is_player_valid( player ) && !player.is_drinking && !is_melee_weapon( current_weapon ) && !is_placeable_mine( current_weapon ) && !is_equipment( current_weapon ) && level.revive_tool != current_weapon && "none" != current_weapon && !player hacker_active() )
        {
            break;
        }
    }

    m_weapon.trigger notify( "weapon_grabbed" );
    m_weapon.trigger thread swap_weapon( str_weapon, player );

    if ( isdefined( m_weapon.trigger ) )
    {
        m_weapon.trigger tomb_unitrigger_delete();
        m_weapon.trigger = undefined;
    }

    if ( isdefined( m_weapon ) )
        m_weapon delete();

    if ( player != digger )
        digger notify( "dig_up_weapon_shared" );
}

swap_weapon( str_weapon, e_player )
{
    str_current_weapon = e_player getcurrentweapon();

    if ( str_weapon == "claymore_zm" )
    {
        if ( !e_player hasweapon( str_weapon ) )
        {
            e_player thread maps\mp\zombies\_zm_weap_claymore::show_claymore_hint( "claymore_purchased" );
            e_player thread maps\mp\zombies\_zm_weap_claymore::claymore_setup();
            e_player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", "grenade" );
        }
        else
            e_player givemaxammo( str_weapon );

        return;
    }

    if ( is_player_valid( e_player ) && !e_player.is_drinking && !is_placeable_mine( str_current_weapon ) && !is_equipment( str_current_weapon ) && level.revive_tool != str_current_weapon && "none" != str_current_weapon && !e_player hacker_active() )
    {
        if ( !e_player hasweapon( str_weapon ) )
            e_player take_old_weapon_and_give_new( str_current_weapon, str_weapon );
        else
            e_player givemaxammo( str_weapon );
    }
}

take_old_weapon_and_give_new( current_weapon, weapon )
{
    a_weapons = self getweaponslistprimaries();

    if ( isdefined( a_weapons ) && a_weapons.size >= get_player_weapon_limit( self ) )
        self takeweapon( current_weapon );

    self giveweapon( weapon );
    self givestartammo( weapon );
    self switchtoweapon( weapon );
}