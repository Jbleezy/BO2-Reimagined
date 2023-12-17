#include maps\mp\zombies\_zm_power;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

standard_powered_items()
{
	flag_wait("start_zombie_round_logic");
	vending_triggers = getentarray("zombie_vending", "targetname");
	i = 0;

	while (i < vending_triggers.size)
	{
		if (vending_triggers[i].script_noteworthy == "specialty_weapupgrade")
		{
			i++;
			continue;
		}

		powered_on = maps\mp\zombies\_zm_perks::get_perk_machine_start_state(vending_triggers[i].script_noteworthy);
		add_powered_item(::perk_power_on, ::perk_power_off, ::perk_range, ::cost_low_if_local, 0, powered_on, vending_triggers[i]);
		i++;
	}

	pack_a_punch = getentarray("specialty_weapupgrade", "script_noteworthy");

	foreach (trigger in pack_a_punch)
	{
		powered_on = maps\mp\zombies\_zm_perks::get_perk_machine_start_state(trigger.script_noteworthy);
		trigger.powered = add_powered_item(::pap_power_on, ::pap_power_off, ::pap_range, ::cost_low_if_local, 0, powered_on, trigger);
	}

	zombie_doors = getentarray("zombie_door", "targetname");

	foreach (door in zombie_doors)
	{
		if (isDefined(door.script_noteworthy) && door.script_noteworthy == "electric_door")
		{
			add_powered_item(::door_power_on, ::door_power_off, ::door_range, ::cost_door, 0, 0, door);
		}

		if (isDefined(door.script_noteworthy) && door.script_noteworthy == "local_electric_door")
		{
			power_sources = 0;

			if (!is_true(level.power_local_doors_globally))
			{
				power_sources = 1;
			}

			add_powered_item(::door_local_power_on, ::door_local_power_off, ::door_range, ::cost_door, power_sources, 0, door);
		}
	}

	thread watch_global_power();
}

perk_power_off(origin, radius)
{
	self.target notify("death");
	self.target thread maps\mp\zombies\_zm_perks::vending_trigger_think();

	if (isDefined(self.target.perk_hum))
	{
		self.target.perk_hum delete();
	}

	maps\mp\zombies\_zm_perks::perk_pause(self.target.script_noteworthy);
	level notify(self.target maps\mp\zombies\_zm_perks::getvendingmachinenotify() + "_off");
}