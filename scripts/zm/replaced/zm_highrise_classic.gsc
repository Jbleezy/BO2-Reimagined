#include maps\mp\zm_highrise_classic;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

highrise_pap_move_in(trigger, origin_offset, angles_offset)
{
	level endon("Pack_A_Punch_off");
	trigger endon("pap_player_disconnected");
	pap_machine = trigger.perk_machine;
	worldgun = trigger.worldgun;
	worldgundw = trigger.worldgun.worldgundw;
	offset = origin_offset[2];
	trigger.worldgun rotateto(self.angles + angles_offset + vectorscale((0, 1, 0), 90.0), 0.35, 0, 0);
	offsetdw = vectorscale((1, 1, 1), 3.0);

	if (isdefined(trigger.worldgun.worldgundw))
	{
		worldgundw rotateto(self.angles + angles_offset + vectorscale((0, 1, 0), 90.0), 0.35, 0, 0);
	}

	elapsed_time_counter = 0;

	while (isdefined(worldgun) && elapsed_time_counter < 0.5)
	{
		worldgun.origin = (worldgun.origin[0], worldgun.origin[1], pap_machine.origin[2] + offset);

		if (isdefined(worldgundw))
		{
			worldgundw.origin = (worldgundw.origin[0], worldgundw.origin[1], pap_machine.origin[2] + offset + offsetdw[2]);
		}

		elapsed_time_counter += 0.05;
		wait 0.05;
	}

	move_vec = (self.origin + origin_offset - worldgun.origin) * 0.05 / 0.5;
	elapsed_time_counter = 0;

	while (isdefined(worldgun) && elapsed_time_counter < 0.5)
	{
		worldgun.origin = (worldgun.origin[0] + move_vec[0], worldgun.origin[1] + move_vec[1], pap_machine.origin[2] + offset);

		if (isdefined(worldgundw))
		{
			worldgundw.origin = (worldgundw.origin[0] + move_vec[0], worldgundw.origin[1] + move_vec[1], pap_machine.origin[2] + offset + offsetdw[2]);
		}

		elapsed_time_counter += 0.05;
		wait 0.05;
	}
}

squashed_death_init(kill_if_falling)
{
	while (true)
	{
		self waittill("trigger", who);

		if (!(isdefined(who.insta_killed) && who.insta_killed))
		{
			if (isplayer(who))
			{
				who thread elevator_black_screen_squash_check();
				who thread insta_kill_player(1, kill_if_falling);
			}
			else if (isai(who))
			{
				if (is_true(who.in_the_ceiling) || !is_true(who.completed_emerging_into_playable_area))
				{
					continue;
				}

				playfx(level._effect["zomb_gib"], who.origin);

				if (isdefined(who.is_leaper) && who.is_leaper)
				{
					who maps\mp\zombies\_zm_ai_leaper::leaper_cleanup();
					who dodamage(who.health + 100, who.origin);
				}
				else
				{
					who delete();
				}

				who.insta_killed = 1;
			}
		}
	}
}

insta_kill_player(perks_can_respawn_player, kill_if_falling)
{
	self endon("disconnect");

	if (isDefined(self.insta_killed) && self.insta_killed)
	{
		return;
	}

	if (!is_player_killable(self))
	{
		return;
	}

	self.insta_killed = 1;

	self maps\mp\zombies\_zm_buildables::player_return_piece_to_original_spawn();

	self playlocalsound(level.zmb_laugh_alias);

	self.lives = 0;
	self dodamage(self.health + 1000, self.origin);
	self scripts\zm\_zm_reimagined::player_suicide();

	self.insta_killed = 0;
}

escape_pod()
{
	escape_pod = getent("elevator_bldg1a_body", "targetname");
	escape_pod setmovingplatformenabled(1);
	escape_pod escapeelevatoruseanimtree();
	escape_pod_trigger = getent("escape_pod_trigger", "targetname");
	escape_pod.is_elevator = 1;
	escape_pod._post_host_migration_thread = maps\mp\zm_highrise_elevators::escape_pod_host_migration_respawn_check;

	if (!isdefined(escape_pod_trigger))
	{
		return;
	}

	escape_pod.home_origin = escape_pod.origin;
	escape_pod.link_start = [];
	escape_pod.link_end = [];
	escape_pod_blocker_door = getent("elevator_bldg1a_body_door_clip", "targetname");
	number_of_times_used = 0;
	used_at_least_once = 0;
	escape_pod setanim(level.escape_elevator_1_state);
	escape_pod setclientfield("clientfield_escape_pod_light_fx", 1);
	escape_pod thread escape_pod_state_run();
	escape_pod_trigger thread escape_pod_walk_on_off(escape_pod);

	while (true)
	{
		escape_pod setanim(level.escape_elevator_idle);

		if (isdefined(escape_pod_blocker_door))
		{
			escape_pod escape_pod_linknodes("escape_pod_door_l_node");
			escape_pod escape_pod_linknodes("escape_pod_door_r_node");
			escape_pod_blocker_door unlink();
			escape_pod_blocker_door thread trigger_off();
		}

		if (is_true(used_at_least_once))
		{
			wait 3;
		}

		level thread escape_pod_wait_for_players_inside(escape_pod, escape_pod_trigger);

		flag_set("escape_pod_needs_reset");

		level waittill("reset_escape_pod");

		flag_clear("escape_pod_needs_reset");

		level notify("escape_pod_falling_begin");

		players_in_escape_pod = escape_pod_trigger escape_pod_get_all_alive_players_inside();

		foreach (player in players_in_escape_pod)
		{
			player.riding_escape_pod = 1;
			player allowjump(0);
		}

		if (isdefined(escape_pod_blocker_door))
		{
			escape_pod_blocker_door trigger_on();
			escape_pod_blocker_door linkto(escape_pod);
			escape_pod escape_pod_unlinknodes("escape_pod_door_l_node");
			escape_pod escape_pod_unlinknodes("escape_pod_door_r_node");
		}

		escape_pod.escape_pod_state = 5;
		escape_pod thread escape_pod_shake();
		wait(getanimlength(level.escape_elevator_5_state) - 0.05);
		escape_pod setanim(level.escape_elevator_drop);
		escape_pod setclientfield("clientfield_escape_pod_light_fx", 0);
		escape_pod setclientfield("clientfield_escape_pod_sparks_fx", 1);
		escape_pod thread escape_pod_move();
		escape_pod thread escape_pod_rotate();

		escape_pod waittill("reached_destination");

		number_of_times_used++;
		escape_pod thread impact_animate();

		if (number_of_times_used == 1)
		{
			level.escape_elevator_idle = level.escape_elevator_damage_idle_state;
			level.escape_elevator_drop = level.escape_elevator_damage_drop_state;
			level.escape_elevator_impact = level.escape_elevator_damage_impact_state;
		}

		level notify("escape_pod_falling_complete");

		if (isdefined(escape_pod_blocker_door))
		{
			escape_pod_blocker_door unlink();
			escape_pod_blocker_door trigger_off();
			escape_pod escape_pod_linknodes("escape_pod_door_l_node");
			escape_pod escape_pod_linknodes("escape_pod_door_r_node");
		}

		escape_pod setclientfield("clientfield_escape_pod_sparks_fx", 0);
		escape_pod setclientfield("clientfield_escape_pod_impact_fx", 1);
		escape_pod setclientfield("clientfield_escape_pod_light_fx", 1);
		flag_set("escape_pod_needs_reset");

		level waittill("reset_escape_pod");

		flag_clear("escape_pod_needs_reset");
		escape_pod setclientfield("clientfield_escape_pod_impact_fx", 0);
		escape_pod thread escape_pod_breaking_rotate();
		wait 6;
		escape_pod playsound("zmb_elevator_run_start");
		escape_pod playloopsound("zmb_elevator_run", 1);
		level notify("escape_pod_moving_back_to_start_position");

		if (isdefined(escape_pod_blocker_door))
		{
			escape_pod_blocker_door trigger_on();
			escape_pod_blocker_door linkto(escape_pod);
			escape_pod escape_pod_unlinknodes("escape_pod_door_l_node");
			escape_pod escape_pod_unlinknodes("escape_pod_door_r_node");
		}

		escape_pod moveto(escape_pod.home_origin, 3, 0.1, 0.1);

		escape_pod waittill("movedone");

		escape_pod stoploopsound(1);
		escape_pod playsound("zmb_esc_pod_crash");
		escape_pod playsound("zmb_elevator_run_stop");
		escape_pod playsound("zmb_elevator_ding");
		escape_pod thread reset_impact_animate();
		used_at_least_once = 1;
	}
}

escape_pod_wait_for_players_inside(escape_pod, escape_pod_trigger)
{
	level endon("reset_escape_pod");

	while (true)
	{
		players_in_escape_pod = escape_pod_trigger escape_pod_get_all_alive_players_inside();

		if (players_in_escape_pod.size == 0)
		{
			escape_pod.escape_pod_state = 1;
			wait 0.05;
			continue;
		}

		players_in_escape_pod = escape_pod_trigger escape_pod_get_all_alive_players_inside();

		if (players_in_escape_pod.size > 0)
		{
			escape_pod.escape_pod_state = 2;

			escape_pod thread escape_pod_tell_fx();
			wait 3;
			players_in_escape_pod = escape_pod_trigger escape_pod_get_all_alive_players_inside();

			if (players_in_escape_pod.size > 0)
			{
				break;
			}
		}

		wait 0.05;
	}

	level notify("reset_escape_pod");
}

escape_pod_get_all_alive_players_inside()
{
	players = get_players();
	players_in_escape_pod = [];

	foreach (player in players)
	{
		if (player.sessionstate != "spectator")
		{
			if (player istouching(self))
			{
				players_in_escape_pod[players_in_escape_pod.size] = player;
			}
		}
	}

	return players_in_escape_pod;
}

turn_off_whoswho()
{
	self setclientfieldtoplayer("clientfield_whos_who_filter", 0);
}