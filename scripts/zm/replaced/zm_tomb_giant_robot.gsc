#include maps\mp\zm_tomb_giant_robot;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\animscripts\zm_death;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_giant_robot_ffotd;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\zombies\_zm_weap_one_inch_punch;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm;

robot_cycling()
{
	three_robot_round = 0;
	last_robot = -1;
	level thread giant_robot_intro_walk(1);

	level waittill("giant_robot_intro_complete");

	while (true)
	{
		if (!(level.round_number % 4) && three_robot_round != level.round_number)
			flag_set("three_robot_round");

		if (flag("ee_all_staffs_upgraded") && !flag("ee_mech_zombie_hole_opened"))
			flag_set("three_robot_round");

		if (flag("three_robot_round"))
		{
			level.zombie_ai_limit = 22;
			random_number = randomint(3);

			level thread giant_robot_start_walk(2);

			wait 5;

			level thread giant_robot_start_walk(0);

			wait 5;

			level thread giant_robot_start_walk(1);

			level waittill("giant_robot_walk_cycle_complete");

			level waittill("giant_robot_walk_cycle_complete");

			level waittill("giant_robot_walk_cycle_complete");

			wait 5;
			level.zombie_ai_limit = 24;
			three_robot_round = level.round_number;
			last_robot = -1;
			flag_clear("three_robot_round");
		}
		else
		{
			if (!flag("activate_zone_nml"))
				random_number = randomint(2);
			else
			{
				do
					random_number = randomint(3);

				while (random_number == last_robot);
			}

			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);

			level waittill("giant_robot_walk_cycle_complete");

			wait 5;
		}
	}
}