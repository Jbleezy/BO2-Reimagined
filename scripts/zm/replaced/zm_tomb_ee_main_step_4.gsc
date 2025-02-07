#include maps\mp\zm_tomb_ee_main_step_4;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_ee_main;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\zombies\_zm_ai_mechz_dev;
#include maps\mp\zombies\_zm_ai_mechz_claw;
#include maps\mp\zombies\_zm_ai_mechz_ft;
#include maps\mp\zombies\_zm_ai_mechz_booster;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_ai_mechz_ffotd;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\animscripts\zm_shared;

stage_logic()
{
	flag_wait("ee_quadrotor_disabled");
	level thread sndee4music();

	while (get_mechz_enemy_array().size > 0)
	{
		wait 0.05;
	}

	if (!flag("ee_mech_zombie_fight_completed"))
	{
		while (level.ee_mech_zombies_spawned < 4)
		{
			if (level.ee_mech_zombies_alive < 4)
			{
				ai = spawn_zombie(level.mechz_spawners[0]);
				ai thread ee_mechz_spawn(level.ee_mech_zombies_spawned % 4);
				level.ee_mech_zombies_alive++;
				level.ee_mech_zombies_spawned++;
			}

			wait(randomfloatrange(0.5, 1));
		}
	}

	flag_wait("ee_mech_zombie_fight_completed");
	wait_network_frame();
	stage_completed("little_girl_lost", level._cur_stage_name);
}

get_mechz_enemy_array()
{
	valid_enemies = [];
	enemies = getaispeciesarray(level.zombie_team, "all");

	foreach (enemy in enemies)
	{
		if (isdefined(enemy.is_mechz) && enemy.is_mechz)
		{
			valid_enemies[valid_enemies.size] = enemy;
		}
	}

	return valid_enemies;
}