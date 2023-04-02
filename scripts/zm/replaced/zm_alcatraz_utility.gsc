#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_craftables;

#using_animtree("fxanim_props");

blundergat_upgrade_station()
{
    t_upgrade = getent( "blundergat_upgrade", "targetname" );
    t_upgrade.equipname = "packasplat";
    t_upgrade.cost = t_upgrade scripts\zm\_zm_reimagined::get_equipment_cost();
    t_upgrade sethintstring( &"ZM_PRISON_CONVERT_START", " [Cost: " + t_upgrade.cost + "]" );
    t_upgrade usetriggerrequirelookat();
    waittill_crafted( "packasplat" );
    m_converter = t_upgrade.m_upgrade_machine;
    v_angles = m_converter gettagangles( "tag_origin" );
    v_weapon_origin_offset = anglestoforward( v_angles ) * 1 + anglestoright( v_angles ) * 10 + anglestoup( v_angles ) * 1.75;
    v_weapon_angles_offset = ( 0, 90, -90 );
    m_converter.v_weapon_origin = m_converter gettagorigin( "tag_origin" ) + v_weapon_origin_offset;
    m_converter.v_weapon_angles = v_angles + v_weapon_angles_offset;
    m_converter useanimtree( #animtree );
    m_converter.fxanims["close"] = %fxanim_zom_al_packasplat_start_anim;
    m_converter.fxanims["inject"] = %fxanim_zom_al_packasplat_idle_anim;
    m_converter.fxanims["open"] = %fxanim_zom_al_packasplat_end_anim;
    m_converter.n_start_time = getanimlength( m_converter.fxanims["close"] );
    m_converter.n_idle_time = getanimlength( m_converter.fxanims["inject"] );
    m_converter.n_end_time = getanimlength( m_converter.fxanims["open"] );

    while ( true )
    {
        t_upgrade thread blundergat_change_hintstring( &"ZM_PRISON_CONVERT_START", " [Cost: " + t_upgrade.cost + "]" );

        t_upgrade waittill( "trigger", player );

        if ( isdefined( level.custom_craftable_validation ) )
        {
            valid = t_upgrade [[ level.custom_craftable_validation ]]( player );

            if ( !valid )
                continue;
        }

        str_valid_weapon = undefined;

        if ( player hasweapon( "blundergat_zm" ) )
            str_valid_weapon = "blundergat_zm";
        else if ( player hasweapon( "blundergat_upgraded_zm" ) )
            str_valid_weapon = "blundergat_upgraded_zm";

        if (player.score < t_upgrade.cost)
        {
            self play_sound_on_ent( "no_purchase" );
            player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "no_money_weapon" );
            continue;
        }

        if ( isdefined( str_valid_weapon ) )
        {
            player maps\mp\zombies\_zm_score::minus_to_player_score( t_upgrade.cost );
			t_upgrade play_sound_on_ent( "purchase" );

            player takeweapon( str_valid_weapon );
            player.is_pack_splatting = 1;
            t_upgrade setinvisibletoall();
            m_converter.worldgun = spawn_weapon_model( str_valid_weapon, undefined, m_converter.v_weapon_origin, m_converter.v_weapon_angles );
            m_converter blundergat_upgrade_station_inject( str_valid_weapon );
            t_upgrade thread blundergat_change_hintstring( &"ZM_PRISON_CONVERT_PICKUP" );

            if ( isdefined( player ) )
            {
                t_upgrade setvisibletoplayer( player );
                t_upgrade thread wait_for_player_to_take( player, str_valid_weapon );
            }

            t_upgrade thread wait_for_timeout();
            t_upgrade waittill_any( "acid_timeout", "acid_taken" );

            if ( isdefined( player ) )
                player.is_pack_splatting = undefined;

            m_converter.worldgun delete();
            wait 0.5;
            t_upgrade setvisibletoall();
        }
        else
        {
            t_upgrade thread blundergat_change_hintstring( &"ZM_PRISON_MISSING_BLUNDERGAT" );
            wait 2;
        }
    }
}

blundergat_change_hintstring( hint_string, hint_string_cost )
{
    self notify( "new_change_hint_string" );
    self endon( "new_change_hint_string" );

    while ( isdefined( self.is_locked ) && self.is_locked )
        wait 0.05;

    if (isDefined(hint_string_cost))
    {
        self sethintstring( hint_string, hint_string_cost );
    }
    else
    {
        self sethintstring( hint_string );
    }

    wait 0.05;

    if (isDefined(hint_string_cost))
    {
        self sethintstring( hint_string, hint_string_cost );
    }
    else
    {
        self sethintstring( hint_string );
    }
}