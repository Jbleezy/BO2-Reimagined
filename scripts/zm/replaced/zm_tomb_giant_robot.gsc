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

init_giant_robot_glows()
{
	maps\mp\zm_tomb_giant_robot_ffotd::init_giant_robot_glows_start();
	precacheitem("falling_hands_tomb_zm");
	precachemodel("veh_t6_dlc_zm_robot_foot_hatch");
	precachemodel("veh_t6_dlc_zm_robot_foot_hatch_lights");
	flag_init("foot_shot");
	flag_init("three_robot_round");
	flag_init("fire_link_enabled");
	flag_init("timeout_vo_robot_0");
	flag_init("timeout_vo_robot_1");
	flag_init("timeout_vo_robot_2");
	level thread setup_giant_robot_devgui();
	level.gr_foot_hatch_closed = [];
	level.gr_foot_hatch_closed[0] = [];
	level.gr_foot_hatch_closed[0]["left"] = 1;
	level.gr_foot_hatch_closed[0]["right"] = 1;
	level.gr_foot_hatch_closed[1] = [];
	level.gr_foot_hatch_closed[1]["left"] = 1;
	level.gr_foot_hatch_closed[1]["right"] = 1;
	level.gr_foot_hatch_closed[2] = [];
	level.gr_foot_hatch_closed[2]["left"] = 1;
	level.gr_foot_hatch_closed[2]["right"] = 1;
	a_gr_head_triggers = getstructarray("giant_robot_head_exit_trigger", "script_noteworthy");

	foreach (struct in a_gr_head_triggers)
	{
		gr_head_exit_trigger_start(struct);
	}

	level thread handle_wind_tunnel_bunker_collision();
	level thread handle_tank_bunker_collision();
	maps\mp\zm_tomb_giant_robot_ffotd::init_giant_robot_glows_end();
}

#using_animtree("zm_tomb_giant_robot_hatch");

giant_robot_initial_spawns()
{
	flag_wait("start_zombie_round_logic");
	level.a_giant_robots = [];

	for (i = 0; i < 3; i++)
	{
		level.gr_foot_hatch_closed[i]["right"] = 1;
		level.gr_foot_hatch_closed[i]["left"] = 1;
		trig_stomp_kill_right = getent("trig_stomp_kill_right_" + i, "targetname");
		trig_stomp_kill_left = getent("trig_stomp_kill_left_" + i, "targetname");
		trig_stomp_kill_right enablelinkto();
		trig_stomp_kill_left enablelinkto();
		clip_foot_right = getent("clip_foot_right_" + i, "targetname");
		clip_foot_left = getent("clip_foot_left_" + i, "targetname");
		sp_giant_robot = getent("ai_giant_robot_" + i, "targetname");
		ai = sp_giant_robot spawnactor();
		ai maps\mp\zm_tomb_giant_robot_ffotd::giant_robot_spawn_start();
		ai.is_giant_robot = 1;
		ai.giant_robot_id = i;
		tag_right_foot = ai gettagorigin("TAG_ATTACH_HATCH_RI");
		tag_left_foot = ai gettagorigin("TAG_ATTACH_HATCH_LE");
		trig_stomp_kill_right.origin = tag_right_foot + vectorscale((0, 0, 1), 72.0);
		trig_stomp_kill_right.angles = ai gettagangles("TAG_ATTACH_HATCH_RI");
		trig_stomp_kill_left.origin = tag_left_foot + vectorscale((0, 0, 1), 72.0);
		trig_stomp_kill_left.angles = ai gettagangles("TAG_ATTACH_HATCH_LE");
		wait 0.1;
		trig_stomp_kill_right linkto(ai, "TAG_ATTACH_HATCH_RI", vectorscale((0, 0, 1), 72.0));
		wait_network_frame();
		trig_stomp_kill_left linkto(ai, "TAG_ATTACH_HATCH_LE", vectorscale((0, 0, 1), 72.0));
		wait_network_frame();
		ai.trig_stomp_kill_right = trig_stomp_kill_right;
		ai.trig_stomp_kill_left = trig_stomp_kill_left;
		clip_foot_right.origin = tag_right_foot + (0, 0, 0);
		clip_foot_left.origin = tag_left_foot + (0, 0, 0);
		clip_foot_right.angles = ai gettagangles("TAG_ATTACH_HATCH_RI");
		clip_foot_left.angles = ai gettagangles("TAG_ATTACH_HATCH_LE");
		wait 0.1;
		clip_foot_right linkto(ai, "TAG_ATTACH_HATCH_RI", (0, 0, 0));
		wait_network_frame();
		clip_foot_left linkto(ai, "TAG_ATTACH_HATCH_LE", (0, 0, 0));
		wait_network_frame();
		ai.clip_foot_right = clip_foot_right;
		ai.clip_foot_left = clip_foot_left;
		ai.is_zombie = 0;
		ai.targetname = "giant_robot_walker_" + i;
		ai.animname = "giant_robot_walker";
		ai.script_noteworthy = "giant_robot";
		ai.audio_type = "giant_robot";
		ai.ignoreall = 1;
		ai.ignoreme = 1;
		ai setcandamage(0);
		ai magic_bullet_shield();
		ai setplayercollision(1);
		ai setforcenocull();
		ai setfreecameralockonallowed(0);
		ai.goalradius = 100000;
		ai setgoalpos(ai.origin);
		ai setclientfield("register_giant_robot", 1);
		ai ghost();
		ai ent_flag_init("robot_head_entered");
		ai ent_flag_init("kill_trigger_active");
		level.a_giant_robots[i] = ai;
		ai maps\mp\zm_tomb_giant_robot_ffotd::giant_robot_spawn_end();
		wait_network_frame();
	}

	level thread robot_cycling();
}

robot_cycling()
{
	three_robot_round = 0;
	last_robot = -1;

	if (is_classic())
	{
		level thread giant_robot_intro_walk(1);
		level waittill("giant_robot_intro_complete");
	}

	while (true)
	{
		if (!is_classic())
		{
			number = 0;

			if (getdvar("ui_zm_mapstartlocation") == "trenches")
			{
				number = 1;
			}
			else if (getdvar("ui_zm_mapstartlocation") == "church")
			{
				number = 2;
			}

			level thread giant_robot_start_walk(number, 0);

			level waittill("giant_robot_walk_cycle_complete");

			wait 5;

			continue;
		}

		if (!(level.round_number % 4) && three_robot_round != level.round_number)
		{
			flag_set("three_robot_round");
		}

		if (flag("ee_all_staffs_upgraded") && !flag("ee_mech_zombie_hole_opened"))
		{
			flag_set("three_robot_round");
		}

		if (flag("three_robot_round"))
		{
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
			three_robot_round = level.round_number;
			last_robot = -1;
			flag_clear("three_robot_round");
		}
		else
		{
			if (!flag("activate_zone_nml"))
			{
				random_number = randomint(2);
			}
			else
			{
				do
				{
					random_number = randomint(3);
				}
				while (random_number == last_robot);
			}

			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);

			level waittill("giant_robot_walk_cycle_complete");

			wait 5;
		}
	}
}

giant_robot_start_walk(n_robot_id, b_has_hatch)
{
	if (!isdefined(b_has_hatch))
	{
		b_has_hatch = 1;
	}

	ai = getent("giant_robot_walker_" + n_robot_id, "targetname");
	level.gr_foot_hatch_closed[n_robot_id]["left"] = 1;
	level.gr_foot_hatch_closed[n_robot_id]["right"] = 1;
	ai.b_has_hatch = b_has_hatch;
	ai ent_flag_clear("kill_trigger_active");
	ai ent_flag_clear("robot_head_entered");

	if (isdefined(ai.b_has_hatch) && ai.b_has_hatch)
	{
		m_sole_left = getent("target_sole_left_" + n_robot_id, "targetname");
		m_sole_right = getent("target_sole_right_" + n_robot_id, "targetname");
	}

	if (isdefined(m_sole_left) && (isdefined(ai.b_has_hatch) && ai.b_has_hatch))
	{
		m_sole_left setcandamage(1);
		m_sole_left.health = 99999;
		m_sole_left.hatch_foot = "left";
		m_sole_left useanimtree(#animtree);
		m_sole_left unlink();
	}

	if (isdefined(m_sole_right) && (isdefined(ai.b_has_hatch) && ai.b_has_hatch))
	{
		m_sole_right setcandamage(1);
		m_sole_right.health = 99999;
		m_sole_right.hatch_foot = "right";
		m_sole_right useanimtree(#animtree);
		m_sole_right unlink();
	}

	wait 10;

	level thread giant_robot_attach_sole(ai, m_sole_left);
	level thread giant_robot_attach_sole(ai, m_sole_right);

	wait 0.1;

	if (!(isdefined(ai.b_has_hatch) && ai.b_has_hatch))
	{
		ai attach("veh_t6_dlc_zm_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
		ai attach("veh_t6_dlc_zm_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
	}

	wait 0.05;
	ai thread giant_robot_think(ai.trig_stomp_kill_right, ai.trig_stomp_kill_left, ai.clip_foot_right, ai.clip_foot_left, m_sole_left, m_sole_right, n_robot_id);
}

giant_robot_attach_sole(ai, m_sole)
{
	if (isdefined(m_sole))
	{
		if (m_sole.hatch_foot == "left")
		{
			n_sole_origin = ai gettagorigin("TAG_ATTACH_HATCH_LE");
			v_sole_angles = ai gettagangles("TAG_ATTACH_HATCH_LE");
			str_sole_tag = "TAG_ATTACH_HATCH_LE";
		}
		else if (m_sole.hatch_foot == "right")
		{
			n_sole_origin = ai gettagorigin("TAG_ATTACH_HATCH_RI");
			v_sole_angles = ai gettagangles("TAG_ATTACH_HATCH_RI");
			str_sole_tag = "TAG_ATTACH_HATCH_RI";
		}

		m_sole.origin = n_sole_origin;
		m_sole.angles = v_sole_angles;
		wait 0.1;
		m_sole linkto(ai, str_sole_tag, (0, 0, 0));
		m_sole show();
		ai attach("veh_t6_dlc_zm_robot_foot_hatch_lights", str_sole_tag);
	}
}

giant_robot_think(trig_stomp_kill_right, trig_stomp_kill_left, clip_foot_right, clip_foot_left, m_sole_left, m_sole_right, n_robot_id)
{
	self thread robot_walk_animation(n_robot_id);
	self show();

	if (isdefined(m_sole_left))
	{
		self thread sole_cleanup(m_sole_left);
	}

	if (isdefined(m_sole_right))
	{
		self thread sole_cleanup(m_sole_right);
	}

	self.is_walking = 1;
	self thread monitor_footsteps(trig_stomp_kill_right, "right");
	self thread monitor_footsteps(trig_stomp_kill_left, "left");
	self thread monitor_footsteps_fx(trig_stomp_kill_right, "right");
	self thread monitor_footsteps_fx(trig_stomp_kill_left, "left");
	self thread monitor_shadow_notetracks("right");
	self thread monitor_shadow_notetracks("left");
	self thread sndgrthreads("left");
	self thread sndgrthreads("right");

	if (isdefined(m_sole_left) && level.gr_foot_hatch_closed[n_robot_id]["left"] && (isdefined(self.b_has_hatch) && self.b_has_hatch))
	{
		self thread giant_robot_foot_waittill_sole_shot(m_sole_left);
	}

	if (isdefined(m_sole_right) && level.gr_foot_hatch_closed[n_robot_id]["right"] && (isdefined(self.b_has_hatch) && self.b_has_hatch))
	{
		self thread giant_robot_foot_waittill_sole_shot(m_sole_right);
	}

	a_players = getplayers();

	if (n_robot_id != 3 && !(isdefined(level.giant_robot_discovered) && level.giant_robot_discovered))
	{
		foreach (player in a_players)
		{
			player thread giant_robot_discovered_vo(self);
		}
	}
	else if (flag("three_robot_round") && !(isdefined(level.three_robot_round_vo) && level.three_robot_round_vo))
	{
		foreach (player in a_players)
		{
			player thread three_robot_round_vo(self);
		}
	}

	if (n_robot_id != 3 && !(isdefined(level.shoot_robot_vo) && level.shoot_robot_vo))
	{
		foreach (player in a_players)
		{
			player thread shoot_at_giant_robot_vo(self);
		}
	}

	self waittill("giant_robot_stop");
	self.is_walking = 0;
	self stopanimscripted();
	sp_giant_robot = getent("ai_giant_robot_" + self.giant_robot_id, "targetname");
	self.origin = sp_giant_robot.origin;
	level setclientfield("play_foot_open_fx_robot_" + self.giant_robot_id, 0);
	self ghost();
	self detachall();
	level notify("giant_robot_walk_cycle_complete");
}

giant_robot_foot_waittill_sole_shot(m_sole)
{
	self endon("death");
	self endon("giant_robot_stop");

	if (isdefined(m_sole.hatch_foot) && m_sole.hatch_foot == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
		n_foot = 2;
	}
	else if (isdefined(m_sole.hatch_foot) && m_sole.hatch_foot == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
		n_foot = 1;
	}

	self waittillmatch("scripted_walk", "kill_zombies_leftfoot_1");
	wait 1;
	m_sole waittill("damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weaponname, idflags);
	m_sole.health = 99999;
	level.gr_foot_hatch_closed[self.giant_robot_id][m_sole.hatch_foot] = 0;
	level setclientfield("play_foot_open_fx_robot_" + self.giant_robot_id, n_foot);
	m_sole clearanim(%ai_zombie_giant_robot_hatch_close, 1);
	m_sole setanim(%ai_zombie_giant_robot_hatch_open, 1, 0.2, 1);
	n_time = getanimlength(%ai_zombie_giant_robot_hatch_open);
	wait(n_time);
	m_sole clearanim(%ai_zombie_giant_robot_hatch_open, 1);
	m_sole setanim(%ai_zombie_giant_robot_hatch_open_idle, 1, 0.2, 1);
}

activate_kill_trigger(robot, foot_side)
{
	level endon("stop_kill_trig_think");

	m_sole = getent("target_sole_" + foot_side + "_" + robot.giant_robot_id, "targetname");

	if (foot_side == "left")
	{
		str_foot_tag = "TAG_ATTACH_HATCH_LE";
	}
	else if (foot_side == "right")
	{
		str_foot_tag = "TAG_ATTACH_HATCH_RI";
	}

	while (robot ent_flag("kill_trigger_active"))
	{
		a_zombies = getaispeciesarray(level.zombie_team, "all");
		a_zombies_to_kill = [];

		foreach (zombie in a_zombies)
		{
			if (distancesquared(zombie.origin, self.origin) < 360000)
			{
				if (isdefined(zombie.is_giant_robot) && zombie.is_giant_robot)
				{
					continue;
				}

				if (isdefined(zombie.marked_for_death) && zombie.marked_for_death)
				{
					continue;
				}

				if (isdefined(zombie.robot_stomped) && zombie.robot_stomped)
				{
					continue;
				}

				if (zombie istouching(self))
				{
					if (isdefined(zombie.is_mechz) && zombie.is_mechz)
					{
						zombie thread maps\mp\zombies\_zm_ai_mechz::mechz_robot_stomp_callback();
						continue;
					}

					zombie setgoalpos(zombie.origin);
					zombie.marked_for_death = 1;
					a_zombies_to_kill[a_zombies_to_kill.size] = zombie;
					continue;
				}

				if (!(isdefined(zombie.is_mechz) && zombie.is_mechz) && (isdefined(zombie.has_legs) && zombie.has_legs) && (isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area))
				{
					n_my_z = zombie.origin[2];
					v_giant_robot = robot gettagorigin(str_foot_tag);
					n_giant_robot_z = v_giant_robot[2];
					z_diff = abs(n_my_z - n_giant_robot_z);

					if (z_diff <= 100)
					{
						zombie.v_punched_from = self.origin;
						zombie animcustom(maps\mp\zombies\_zm_weap_one_inch_punch::knockdown_zombie_animate);
					}
				}
			}
		}

		if (a_zombies_to_kill.size > 0)
		{
			level thread zombie_stomp_death(robot, a_zombies_to_kill);
			robot thread zombie_stomped_by_gr_vo(foot_side);
		}

		if (isdefined(level.maxis_quadrotor))
		{
			if (level.maxis_quadrotor istouching(self))
			{
				level.maxis_quadrotor thread quadrotor_stomp_death();
			}
		}

		a_boxes = getentarray("foot_box", "script_noteworthy");

		foreach (m_box in a_boxes)
		{
			if (m_box istouching(self))
			{
				m_box notify("robot_foot_stomp");
			}
		}

		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			if (is_player_valid(players[i], 0, 1))
			{
				if (!players[i] istouching(self))
				{
					continue;
				}

				if (players[i] is_in_giant_robot_footstep_safe_spot())
				{
					continue;
				}

				if (isdefined(players[i].in_giant_robot_head))
				{
					continue;
				}

				if (isdefined(players[i].is_stomped) && players[i].is_stomped)
				{
					continue;
				}

				if (!level.gr_foot_hatch_closed[robot.giant_robot_id][foot_side] && isdefined(m_sole.hatch_foot) && (isdefined(robot.b_has_hatch) && robot.b_has_hatch) && issubstr(self.targetname, m_sole.hatch_foot) && !self player_is_in_laststand())
				{
					players[i].ignoreme = 1;
					players[i].teleport_initial_origin = self.origin;

					if (robot.giant_robot_id == 0)
					{
						level thread maps\mp\zm_tomb_teleporter::stargate_teleport_player("head_0_teleport_player", players[i], 4.0, 0);
						players[i].in_giant_robot_head = 0;
					}
					else if (robot.giant_robot_id == 1)
					{
						level thread maps\mp\zm_tomb_teleporter::stargate_teleport_player("head_1_teleport_player", players[i], 4.0, 0);
						players[i].in_giant_robot_head = 1;

						if (players[i] maps\mp\zombies\_zm_zonemgr::player_in_zone("zone_bunker_4d") || players[i] maps\mp\zombies\_zm_zonemgr::player_in_zone("zone_bunker_4c"))
						{
							players[i].entered_foot_from_tank_bunker = 1;
						}
					}
					else
					{
						level thread maps\mp\zm_tomb_teleporter::stargate_teleport_player("head_2_teleport_player", players[i], 4.0, 0);
						players[i].in_giant_robot_head = 2;
					}

					robot ent_flag_set("robot_head_entered");
					players[i] maps\mp\zombies\_zm_stats::increment_client_stat("tomb_giant_robot_accessed", 0);
					players[i] maps\mp\zombies\_zm_stats::increment_player_stat("tomb_giant_robot_accessed");
					players[i] playsoundtoplayer("zmb_bot_elevator_ride_up", players[i]);
					start_wait = 0.0;
					black_screen_wait = 4.0;
					fade_in_time = 0.01;
					fade_out_time = 0.2;
					players[i] thread fadetoblackforxsec(start_wait, black_screen_wait, fade_in_time, fade_out_time, "white");
					n_transition_time = start_wait + black_screen_wait + fade_in_time + fade_out_time;
					n_start_time = start_wait + fade_in_time;
					players[i] thread player_transition_into_robot_head_start(n_start_time);
					players[i] thread player_transition_into_robot_head_finish(n_transition_time);
					players[i] thread player_death_watch_on_giant_robot();
					continue;
				}
				else
				{
					if (isdefined(players[i].dig_vars["has_helmet"]) && players[i].dig_vars["has_helmet"])
					{
						players[i] thread player_stomp_fake_death(robot);
					}
					else
					{
						players[i] thread player_stomp_death(robot);
					}

					start_wait = 0.0;
					black_screen_wait = 5.0;
					fade_in_time = 0.01;
					fade_out_time = 0.2;
					players[i] thread fadetoblackforxsec(start_wait, black_screen_wait, fade_in_time, fade_out_time, "black", 1);
				}
			}
		}

		wait 0.05;
	}
}

player_stomp_death(robot)
{
	self endon("death");
	self endon("disconnect");

	self.insta_killed = 1;
	self.is_stomped = 1;

	self disableinvulnerability();
	self.lives = 0;
	self dodamage(self.health + 1000, self.origin);
	self scripts\zm\_zm_reimagined::player_suicide();

	self.is_stomped = 0;
	self.insta_killed = 0;
}

giant_robot_close_head_entrance(foot_side)
{
	wait 5.0;
	level.gr_foot_hatch_closed[self.giant_robot_id][foot_side] = 1;
	level setclientfield("play_foot_open_fx_robot_" + self.giant_robot_id, 0);
	m_sole = getent("target_sole_" + foot_side + "_" + self.giant_robot_id, "targetname");

	if (isdefined(m_sole))
	{
		m_sole clearanim(%ai_zombie_giant_robot_hatch_open, 1);
		m_sole clearanim(%ai_zombie_giant_robot_hatch_open_idle, 1);
		m_sole setanim(%ai_zombie_giant_robot_hatch_close, 1, 0.2, 1);
	}

	if (isdefined(foot_side))
	{
		if (foot_side == "right")
		{
			str_tag = "TAG_ATTACH_HATCH_RI";
		}
		else if (foot_side == "left")
		{
			str_tag = "TAG_ATTACH_HATCH_LE";
		}

		self detach("veh_t6_dlc_zm_robot_foot_hatch_lights", str_tag);
	}
}