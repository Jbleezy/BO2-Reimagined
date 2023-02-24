#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

emp_detonate(grenade)
{
	grenade_owner = undefined;

	if ( isDefined( grenade.owner ) )
	{
		grenade_owner = grenade.owner;
	}

	grenade waittill( "explode", grenade_origin );

	emp_radius = level.zombie_vars[ "emp_perk_off_range" ];
	emp_time = level.zombie_vars[ "emp_perk_off_time" ];
	origin = grenade_origin;

	if ( !isDefined( origin ) )
	{
		return;
	}

	level notify( "emp_detonate", origin, emp_radius );
	self thread maps\mp\zombies\_zm_weap_emp_bomb::emp_detonate_zombies( grenade_origin, grenade_owner );

	if ( isDefined( level.custom_emp_detonate ) )
	{
		thread [[ level.custom_emp_detonate ]]( grenade_origin );
	}

	if ( isDefined( grenade_owner ) )
	{
		grenade_owner thread maps\mp\zombies\_zm_weap_emp_bomb::destroyequipment( origin, emp_radius );
	}

	emp_players( origin, emp_radius, grenade_owner );
	disabled_list = maps\mp\zombies\_zm_power::change_power_in_radius( -1, origin, emp_radius );

	wait emp_time;

	maps\mp\zombies\_zm_power::revert_power_to_list( 1, origin, emp_radius, disabled_list );
}

emp_players(origin, radius, owner)
{
	rsquared = radius * radius;
	players = get_players();
	foreach(player in players)
	{
		if(distancesquared(origin, player.origin) < rsquared)
		{
			if(is_player_valid(player) || player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				time = 30;
				player shellshock( "frag_grenade_mp", 2 );
				player thread player_perk_pause_and_unpause_all_perks(time);
				player thread player_emp_fx(time);
			}
		}
	}
}

player_emp_fx(time)
{
	self notify("player_emp_fx");
	self endon("player_emp_fx");
	self endon("disconnect");
	self endon("bled_out");
	self endon("player_suicide");

	wait_time = 2.5;
	for(i = 0; i < time; i += wait_time)
	{
		playfxontag( level._effect[ "elec_torso" ], self, "J_SpineLower" );

		wait wait_time;
	}
}

player_perk_pause_and_unpause_all_perks(time)
{
	self notify("player_perk_pause_and_unpause_all_perks");
	self endon("player_perk_pause_and_unpause_all_perks");
	self endon("disconnect");

	self player_perk_pause_all_perks();
	self thread player_perk_pause_all_perks_acquired(time);

	self waittill_any_or_timeout(time, "bled_out", "player_suicide");

	self player_perk_unpause_all_perks();
}

player_perk_pause_all_perks_acquired(time)
{
	self endon("player_perk_pause_all_perks_acquired_timeout");
	self endon("player_perk_pause_and_unpause_all_perks");
	self endon("disconnect");

	while(1)
	{
		self waittill("perk_acquired");

		wait 0.05;

		self player_perk_pause_all_perks();
	}
}

player_perk_pause_all_perks()
{
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		self player_perk_pause( trigger.script_noteworthy );
	}
}

player_perk_unpause_all_perks()
{
	self notify("player_perk_pause_all_perks_acquired_timeout");

	vending_triggers = getentarray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		self player_perk_unpause( trigger.script_noteworthy );
	}
}

player_perk_pause( perk )
{
	if ( perk == "Pack_A_Punch" || perk == "specialty_weapupgrade" )
	{
		return;
	}

	if ( !isDefined( self.disabled_perks ) )
	{
		self.disabled_perks = [];
	}
	if ( !is_true( self.disabled_perks[ perk ] ) )
	{
		self.disabled_perks[ perk ] = self hasperk( perk );
	}
	if ( self.disabled_perks[ perk ] )
	{
		self unsetperk( perk );
		self maps\mp\zombies\_zm_perks::set_perk_clientfield( perk, 2 );
		if ( perk == "specialty_armorvest" || perk == "specialty_armorvest_upgrade" )
		{
			self setmaxhealth( self.premaxhealth );
			if ( self.health > self.maxhealth )
			{
				self.health = self.maxhealth;
			}
		}
		if ( perk == "specialty_additionalprimaryweapon" || perk == "specialty_additionalprimaryweapon_upgrade" )
		{
			self maps\mp\zombies\_zm::take_additionalprimaryweapon();
		}
		if ( issubstr( perk, "specialty_scavenger" ) )
		{
			self.hasperkspecialtytombstone = 0;
		}
		if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].player_thread_take ) )
		{
			self thread [[ level._custom_perks[ perk ].player_thread_take ]]();
		}
	}

	self notify("perk_acquired");
}

player_perk_unpause( perk )
{
	if ( !isDefined( perk ) )
	{
		return;
	}

	if ( perk == "Pack_A_Punch" )
	{
		return;
	}

	if ( isDefined( self.disabled_perks ) && is_true( self.disabled_perks[ perk ] ) )
	{
		self.disabled_perks[ perk ] = 0;
		self maps\mp\zombies\_zm_perks::set_perk_clientfield( perk, 1 );
		self setperk( perk );
		if ( issubstr( perk, "specialty_scavenger" ) )
		{
			self.hasperkspecialtytombstone = 1;
		}
		self maps\mp\zombies\_zm_perks::perk_set_max_health_if_jugg( perk, 0, 0 );
		if ( isDefined( level._custom_perks[ perk ] ) && isDefined( level._custom_perks[ perk ].player_thread_give ) )
		{
			self thread [[ level._custom_perks[ perk ].player_thread_give ]]();
		}
	}

	self notify("perk_lost");
}