#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;

init()
{
	level.enemy_location_override_func = ::enemy_location_override;
	flag_wait("initial_blackscreen_passed");
	maps\mp\zombies\_zm_game_module::turn_power_on_and_open_doors();
	increase_pap_collision();
	flag_wait("start_zombie_round_logic");
	wait 1;
	level notify("revive_on");
	wait_network_frame();
	level notify("doubletap_on");
	wait_network_frame();
	level notify("marathon_on");
	wait_network_frame();
	level notify("juggernog_on");
	wait_network_frame();
	level notify("sleight_on");
	wait_network_frame();
	level notify("tombstone_on");
	wait_network_frame();
	level notify("additionalprimaryweapon_on");
	wait_network_frame();
	level notify("Pack_A_Punch_on");
}

enemy_location_override(zombie, enemy)
{
	location = enemy.origin;

	if (is_true(self.reroute))
	{
		if (isDefined(self.reroute_origin))
		{
			location = self.reroute_origin;
		}
	}

	return location;
}

increase_pap_collision()
{
	pap_triggers = getentarray("specialty_weapupgrade", "script_noteworthy");

	foreach (pap_trigger in pap_triggers)
	{
		if (isdefined(pap_trigger.clip))
		{
			collision = spawn("script_model", pap_trigger.clip.origin + anglestoforward(pap_trigger.clip.angles) * -8, 1);
			collision.angles = pap_trigger.clip.angles;
			collision setmodel("zm_collision_perks1");
			collision.script_noteworthy = "clip";
			collision disconnectpaths();
			pap_trigger.clip2 = collision;

			pap_trigger.clip.origin += anglestoforward(pap_trigger.clip.angles) * 8;
		}
	}
}

barrier(model, origin, angles, disconnect_paths = 0)
{
	barrier = undefined;

	if (disconnect_paths)
	{
		barrier = spawn("script_model", origin, 1);
	}
	else
	{
		barrier = spawn("script_model", origin);
	}

	barrier.angles = angles;
	barrier setModel(model);

	if (disconnect_paths)
	{
		barrier disconnectPaths();
	}
}