#include maps\mp\zombies\_zm_ai_ghost;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_ai_ghost_ffotd;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_weap_slowgun;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_ai_basic;

prespawn()
{
	self endon("death");
	level endon("intermission");
	self maps\mp\zombies\_zm_ai_ghost_ffotd::prespawn_start();
	self.startinglocation = self.origin;
	self.animname = "ghost_zombie";
	self.audio_type = "ghost";
	self.has_legs = 1;
	self.no_gib = 1;
	self.ignore_enemy_count = 1;
	self.ignore_equipment = 1;
	self.ignore_claymore = 0;
	self.force_killable_timer = 0;
	self.noplayermeleeblood = 1;
	self.paralyzer_hit_callback = ::paralyzer_callback;
	self.paralyzer_slowtime = 0;
	self.paralyzer_score_time_ms = gettime();
	self.ignore_slowgun_anim_rates = undefined;
	self.reset_anim = ::ghost_reset_anim;
	self.custom_springpad_fling = ::ghost_springpad_fling;
	self.bookcase_entering_callback = ::bookcase_entering_callback;
	self.ignore_subwoofer = 1;
	self.ignore_headchopper = 1;
	self.ignore_spring_pad = 1;
	recalc_zombie_array();
	self setphysparams(15, 0, 72);
	self.cant_melee = 1;

	if (isdefined(self.spawn_point))
	{
		spot = self.spawn_point;

		if (!isdefined(spot.angles))
		{
			spot.angles = (0, 0, 0);
		}

		self forceteleport(spot.origin, spot.angles);
	}

	self set_zombie_run_cycle("run");
	self setanimstatefromasd("zm_move_run");
	self.actor_damage_func = ::ghost_damage_func;
	self.deathfunction = ::ghost_death_func;
	self.maxhealth = level.ghost_health;
	self.health = level.ghost_health;
	self.zombie_init_done = 1;
	self notify("zombie_init_done");
	self.allowpain = 0;
	self.ignore_nuke = 1;
	self animmode("normal");
	self orientmode("face enemy");
	self bloodimpact("none");
	self.forcemovementscriptstate = 0;
	self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();

	if (isdefined(self.is_spawned_in_ghost_zone) && self.is_spawned_in_ghost_zone)
	{
		self.pathenemyfightdist = 0;
	}

	self maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area();
	self setfreecameralockonallowed(0);
	self.startinglocation = self.origin;

	if (isdefined(level.ghost_custom_think_logic))
	{
		self [[level.ghost_custom_think_logic]]();
	}

	self.bad_path_failsafe = maps\mp\zombies\_zm_ai_ghost_ffotd::ghost_bad_path_failsafe;
	self thread ghost_think();
	self.attack_time = 0;
	self.ignore_inert = 1;
	self.subwoofer_burst_func = ::subwoofer_burst_func;
	self.subwoofer_fling_func = ::subwoofer_fling_func;
	self.subwoofer_knockdown_func = ::subwoofer_knockdown_func;
	self maps\mp\zombies\_zm_ai_ghost_ffotd::prespawn_end();
}

ghost_zone_spawning_think()
{
	level endon("intermission");

	if (isdefined(level.intermission) && level.intermission)
	{
		return;
	}

	if (!isdefined(level.female_ghost_spawner))
	{
		return;
	}

	while (true)
	{
		if (level.zombie_ghost_count >= level.zombie_ai_limit_ghost)
		{
			wait 0.1;
			continue;
		}

		valid_player_count = 0;
		valid_players = [];

		while (valid_player_count < 1)
		{
			players = getplayers();
			valid_player_count = 0;

			foreach (player in players)
			{
				if (is_player_valid(player) && !is_player_fully_claimed(player))
				{
					if (isdefined(player.is_in_ghost_zone) && player.is_in_ghost_zone)
					{
						valid_player_count++;
						valid_players[valid_players.size] = player;
					}
				}
			}

			wait 0.1;
		}

		valid_players = array_randomize(valid_players);
		spawn_point = get_best_spawn_point(valid_players[0]);

		if (!isdefined(spawn_point))
		{
			wait 0.1;
			continue;
		}

		ghost_ai = undefined;

		if (isdefined(level.female_ghost_spawner))
		{
			ghost_ai = spawn_zombie(level.female_ghost_spawner, level.female_ghost_spawner.targetname, spawn_point);
		}
		else
		{
			return;
		}

		if (isdefined(ghost_ai))
		{
			ghost_ai setclientfield("ghost_fx", 3);
			ghost_ai.spawn_point = spawn_point;
			ghost_ai.is_ghost = 1;
			ghost_ai.is_spawned_in_ghost_zone = 1;
			ghost_ai.find_target = 1;
			level.zombie_ghost_count++;
		}
		else
		{
			return;
		}

		wait 0.1;
	}
}

should_last_ghost_drop_powerup()
{
	if (flag("time_bomb_restore_active"))
	{
		return false;
	}

	if (!isdefined(level.ghost_round_last_ghost_origin))
	{
		return false;
	}

	if (!is_true(level.ghost_round_no_damage))
	{
		return false;
	}

	return true;
}