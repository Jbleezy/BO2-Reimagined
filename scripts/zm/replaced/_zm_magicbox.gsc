#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

treasure_chest_move( player_vox )
{
	level waittill( "weapon_fly_away_start" );
	players = get_players();
	array_thread( players, maps/mp/zombies/_zm_magicbox::play_crazi_sound );
	if ( isDefined( player_vox ) )
	{
		player_vox delay_thread( randomintrange( 2, 7 ), maps/mp/zombies/_zm_audio::create_and_play_dialog, "general", "box_move" );
	}
	level waittill( "weapon_fly_away_end" );
	if ( isDefined( self.zbarrier ) )
	{
		self maps/mp/zombies/_zm_magicbox::hide_chest( 1 );
	}
	wait 0.1;
	if ( level.zombie_vars[ "zombie_powerup_fire_sale_on" ] == 1 && self [[ level._zombiemode_check_firesale_loc_valid_func ]]() )
	{
		current_sale_time = level.zombie_vars[ "zombie_powerup_fire_sale_time" ];
		wait_network_frame();
		self thread maps/mp/zombies/_zm_magicbox::fire_sale_fix();
		level.zombie_vars[ "zombie_powerup_fire_sale_time" ] = current_sale_time;
		while ( level.zombie_vars[ "zombie_powerup_fire_sale_time" ] > 0 )
		{
			wait 0.1;
		}
	}
	level.verify_chest = 0;
	if ( isDefined( level._zombiemode_custom_box_move_logic ) )
	{
		[[ level._zombiemode_custom_box_move_logic ]]();
	}
	else
	{
		maps/mp/zombies/_zm_magicbox::default_box_move_logic();
	}
	if ( isDefined( level.chests[ level.chest_index ].box_hacks[ "summon_box" ] ) )
	{
		level.chests[ level.chest_index ] [[ level.chests[ level.chest_index ].box_hacks[ "summon_box" ] ]]( 0 );
	}
	playfx( level._effect[ "poltergeist" ], level.chests[ level.chest_index ].zbarrier.origin );
	level.chests[ level.chest_index ] maps/mp/zombies/_zm_magicbox::show_chest();
	flag_clear( "moving_chest_now" );
	self.zbarrier.chest_moving = 0;
}

treasure_chest_timeout()
{
	self endon( "user_grabbed_weapon" );
	self.zbarrier endon( "box_hacked_respin" );
	self.zbarrier endon( "box_hacked_rerespin" );
	wait level.magicbox_timeout;
	self notify( "trigger", level );
}

timer_til_despawn( v_float )
{
	self endon( "kill_weapon_movement" );
	self moveto( self.origin - ( v_float * 0.85 ), level.magicbox_timeout, level.magicbox_timeout * 0.5 );
	wait level.magicbox_timeout;
	if ( isDefined( self ) )
	{
		self delete();
	}
}