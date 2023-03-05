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