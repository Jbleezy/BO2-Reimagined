#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/zm_highrise_classic;
#include scripts/zm/replaced/_zm_chugabud;
#include scripts/zm/replaced/_zm_banking;

main()
{
	replaceFunc(maps/mp/zm_highrise_classic::insta_kill_player, scripts/zm/replaced/zm_highrise_classic::insta_kill_player);
	replaceFunc(maps/mp/zombies/_zm_chugabud::chugabud_bleed_timeout, scripts/zm/replaced/_zm_chugabud::chugabud_bleed_timeout);
	replaceFunc(maps/mp/zombies/_zm_banking::init, scripts/zm/replaced/_zm_banking::init);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_deposit_box, scripts/zm/replaced/_zm_banking::bank_deposit_box);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_deposit_unitrigger, scripts/zm/replaced/_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps/mp/zombies/_zm_banking::bank_withdraw_unitrigger, scripts/zm/replaced/_zm_banking::bank_withdraw_unitrigger);
}

init()
{
    level thread elevator_solo_revive_fix();
}

elevator_solo_revive_fix()
{
	if (!(is_classic() && level.scr_zm_map_start_location == "rooftop"))
	{
		return;
	}

	flag_wait( "start_zombie_round_logic" );

	if (!flag("solo_game"))
	{
		return;
	}

	flag_wait( "perks_ready" );
	flag_wait( "initial_blackscreen_passed" );
	wait 1;

	revive_elevator = undefined;
	foreach (elevator in level.elevators)
	{
		if (elevator.body.perk_type == "vending_revive")
		{
			revive_elevator = elevator;
			break;
		}
	}

	revive_elevator.body.elevator_stop = 1;
	revive_elevator.body.lock_doors = 1;
	revive_elevator.body maps/mp/zm_highrise_elevators::perkelevatordoor(0);

	flag_wait( "power_on" );

	revive_elevator.body.elevator_stop = 0;
	revive_elevator.body.lock_doors = 0;
	revive_elevator.body maps/mp/zm_highrise_elevators::perkelevatordoor(1);
}