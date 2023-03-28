#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_ai_quadrotor;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_tomb_craftables;

vinyl_add_pickup( str_craftable_name, str_piece_name, str_model_name, str_bit_clientfield, str_quest_clientfield, str_vox_id )
{
    if (str_bit_clientfield == "piece_record_zm_player" || str_bit_clientfield == "piece_record_zm_vinyl_master")
    {
        str_bit_clientfield = undefined;
    }

    b_one_time_vo = 1;
    craftable = generate_zombie_craftable_piece( str_craftable_name, str_piece_name, str_model_name, 32, 62, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, str_bit_clientfield, 1, str_vox_id, b_one_time_vo );
    craftable thread watch_part_pickup( str_quest_clientfield, 1 );
    return craftable;
}

quadrotor_control_thread()
{
	self endon( "bled_out" );
	self endon( "disconnect" );

	while ( 1 )
	{
		if ( self actionslottwobuttonpressed() && self hasweapon( "equip_dieseldrone_zm" ) )
		{
            prev_wep = self getCurrentWeapon();

			self waittill( "weapon_change_complete" );

			self playsound( "veh_qrdrone_takeoff" );

            if(self hasweapon(prev_wep) && prev_wep != "equip_dieseldrone_zm")
            {
                self switchtoweapon( prev_wep );
            }
            else
            {
                self switchtoweapon( self getweaponslistprimaries()[0] );
            }

			self waittill( "weapon_change_complete" );

			if ( self hasweapon( "equip_dieseldrone_zm" ) )
			{
				self takeweapon( "equip_dieseldrone_zm" );
				self setactionslot( 2, "" );
			}

			str_vehicle = "heli_quadrotor_zm";
			if ( flag( "ee_maxis_drone_retrieved" ) )
			{
				str_vehicle = "heli_quadrotor_upgraded_zm";
			}

			qr = spawnvehicle( "veh_t6_dlc_zm_quadrotor", "quadrotor_ai", str_vehicle, self.origin + vectorScale( ( 0, 0, 1 ), 96 ), self.angles );
			level thread maps\mp\zm_tomb_craftables::quadrotor_death_watcher( qr );
			qr thread maps\mp\zm_tomb_craftables::quadrotor_instance_watcher( self );
			return;
		}

		wait 0.05;
	}
}

setup_quadrotor_purchase( player )
{
    if ( self.stub.weaponname == "equip_dieseldrone_zm" )
    {
        if ( players_has_weapon( "equip_dieseldrone_zm" ) )
            return true;

        quadrotor = getentarray( "quadrotor_ai", "targetname" );

        if ( quadrotor.size >= 1 )
            return true;

		player maps\mp\zombies\_zm_score::minus_to_player_score( self.stub.cost );
		self play_sound_on_ent( "purchase" );

        quadrotor_set_unavailable();
        player giveweapon( "equip_dieseldrone_zm" );
        player setweaponammoclip( "equip_dieseldrone_zm", 1 );
        player playsoundtoplayer( "zmb_buildable_pickup_complete", player );

        if ( isdefined( self.stub.craftablestub.use_actionslot ) )
            player setactionslot( self.stub.craftablestub.use_actionslot, "weapon", "equip_dieseldrone_zm" );
        else
            player setactionslot( 2, "weapon", "equip_dieseldrone_zm" );

        player notify( "equip_dieseldrone_zm_given" );
        level thread quadrotor_watcher( player );
        player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "build_dd_plc" );

		self.stub.hint_string = "Took " + getWeaponDisplayName(self.stub.weaponname);
		self sethintstring(self.stub.hint_string);

        return true;
    }

    return false;
}

tomb_custom_craftable_validation( player )
{
    if ( self.stub.equipname == "equip_dieseldrone_zm" )
    {
        level.quadrotor_status.pickup_trig = self.stub;

        if ( level.quadrotor_status.crafted )
            return !level.quadrotor_status.picked_up && !flag( "quadrotor_cooling_down" );
    }

    if ( !issubstr( self.stub.weaponname, "staff" ) )
        return 1;

    if ( !( isdefined( level.craftables_crafted[self.stub.equipname] ) && level.craftables_crafted[self.stub.equipname] ) )
        return 1;

    if ( !player can_pickup_staff() )
        return 0;

	e_upgraded_staff = maps\mp\zm_tomb_craftables::get_staff_info_from_weapon_name( self.stub.weaponname );

	if (is_true(e_upgraded_staff.ee_in_use))
	{
		return 0;
	}

    s_elemental_staff = get_staff_info_from_weapon_name( self.stub.weaponname, 0 );
    weapons = player getweaponslistprimaries();

    foreach ( weapon in weapons )
    {
        if ( issubstr( weapon, "staff" ) && weapon != s_elemental_staff.weapname )
            player takeweapon( weapon );
    }

    return 1;
}

quadrotor_set_unavailable()
{
    level.quadrotor_status.picked_up = 1;
	level.quadrotor_status.pickup_trig.model ghost();
}