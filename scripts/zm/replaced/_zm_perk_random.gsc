#include maps\mp\zombies\_zm_perk_random;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_perks;

machine_selector()
{
	while ( true )
	{
		level waittill( "random_perk_moving" );

		machines = getentarray( "random_perk_machine", "targetname" );

		if ( machines.size == 1 )
		{
			new_machine = machines[0];
			new_machine thread machine_think();
			continue;
		}

		do
			new_machine = machines[randomint( machines.size )];
		while ( new_machine == level.random_perk_start_machine );

		level.random_perk_start_machine = new_machine;
		new_machine thread machine_think();
	}
}

trigger_visible_to_player( player )
{
	self setinvisibletoplayer( player );
	visible = 1;

	if ( isdefined( self.stub.trigger_target.machine_user ) )
	{
		if ( player != self.stub.trigger_target.machine_user )
			visible = 0;
	}
	else if ( !player can_buy_perk() )
		visible = 0;

	if ( !visible )
		return false;

	self setvisibletoplayer( player );
	return true;
}

can_buy_perk()
{
	if ( isdefined( self.is_drinking ) && self.is_drinking > 0 )
		return false;

	current_weapon = self getcurrentweapon();

	if ( is_equipment_that_blocks_purchase( current_weapon ) )
		return false;

	if ( self in_revive_trigger() )
		return false;

	if ( current_weapon == "none" )
		return false;

	return true;
}