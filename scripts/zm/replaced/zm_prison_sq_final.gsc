#include maps\mp\zm_prison_sq_final;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zm_alcatraz_sq_nixie;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_alcatraz_sq;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm;

stage_one()
{
	if (isdefined(level.gamedifficulty) && level.gamedifficulty == 0)
	{
		sq_final_easy_cleanup();
		return;
	}

	precachemodel("p6_zm_al_audio_headset_icon");
	flag_wait("quest_completed_thrice");
	flag_wait("spoon_obtained");
	flag_wait("warden_blundergat_obtained");

	for (i = 1; i < 4; i++)
	{
		m_nixie_tube = getent("nixie_tube_" + i, "targetname");
		m_nixie_tube thread nixie_tube_scramble_protected_effects(i);
	}

	level waittill_multiple("nixie_tube_trigger_1", "nixie_tube_trigger_2", "nixie_tube_trigger_3");
	nixie_tube_off();

	m_nixie_tube = getent("nixie_tube_1", "targetname");
	m_nixie_tube playsoundwithnotify("vox_brutus_nixie_right_0", "scary_voice");

	m_nixie_tube waittill("scary_voice");

	wait 3;
	level thread stage_two();
}

stage_two()
{
	audio_logs = [];
	audio_logs[0] = [];
	audio_logs[0][0] = "vox_guar_tour_vo_1_0";
	audio_logs[0][1] = "vox_guar_tour_vo_2_0";
	audio_logs[0][2] = "vox_guar_tour_vo_3_0";
	audio_logs[2] = [];
	audio_logs[2][0] = "vox_guar_tour_vo_4_0";
	audio_logs[3] = [];
	audio_logs[3][0] = "vox_guar_tour_vo_5_0";
	audio_logs[3][1] = "vox_guar_tour_vo_6_0";
	audio_logs[4] = [];
	audio_logs[4][0] = "vox_guar_tour_vo_7_0";
	audio_logs[5] = [];
	audio_logs[5][0] = "vox_guar_tour_vo_8_0";
	audio_logs[6] = [];
	audio_logs[6][0] = "vox_guar_tour_vo_9_0";
	audio_logs[6][1] = "vox_guar_tour_vo_10_0";
	play_sq_audio_log(0, audio_logs[0], 0);

	for (i = 2; i <= 6; i++)
	{
		play_sq_audio_log(i, audio_logs[i], 1);
	}

	level.m_headphones delete();
	t_plane_fly_afterlife = getent("plane_fly_afterlife_trigger", "script_noteworthy");
	t_plane_fly_afterlife playsound("zmb_easteregg_laugh");
	t_plane_fly_afterlife trigger_on();

	level thread scripts\zm\reimagined\_zm_sq::sq_play_song();

	players = get_players();

	foreach (player in players)
	{
		if (is_player_valid(player))
		{
			player thread scripts\zm\reimagined\_zm_sq::sq_give_player_all_perks();
		}
	}
}

final_flight_trigger()
{
	t_plane_fly = getent("plane_fly_trigger", "targetname");
	self setcursorhint("HINT_NOICON");
	self sethintstring("");

	while (isdefined(self))
	{
		self waittill("trigger", e_triggerer);

		if (isplayer(e_triggerer))
		{
			if (isdefined(level.custom_plane_validation))
			{
				valid = self [[level.custom_plane_validation]](e_triggerer);

				if (!valid)
				{
					continue;
				}
			}

			players = getplayers();

			b_everyone_is_ready = 1;

			foreach (player in players)
			{
				if (!isdefined(player) || player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
				{
					b_everyone_is_ready = 0;
				}
			}

			if (!b_everyone_is_ready)
			{
				continue;
			}

			if (flag("plane_is_away"))
			{
				continue;
			}

			flag_set("plane_is_away");
			t_plane_fly trigger_off();

			foreach (player in players)
			{
				if (isdefined(player))
				{
					player thread final_flight_player_thread();
				}
			}

			return;
		}
	}
}

final_flight_player_thread()
{
	self endon("death_or_disconnect");
	self.on_a_plane = 1;
	self.dontspeak = 1;
	self setclientfieldtoplayer("isspeaking", 1);

	if (!(isdefined(self.afterlife) && self.afterlife))
	{
		self.keep_perks = 1;
		self afterlife_remove();
		self.afterlife = 1;
		self thread afterlife_laststand();

		self waittill("player_fake_corpse_created");
	}

	self afterlife_infinite_mana(1);
	level.final_flight_activated = 1;
	level.final_flight_players[level.final_flight_players.size] = self;
	a_nml_teleport_targets = [];

	for (i = 1; i < 6; i++)
	{
		a_nml_teleport_targets[i - 1] = getstruct("nml_telepoint_" + i, "targetname");
	}

	self.n_passenger_index = level.final_flight_players.size;
	a_players = [];
	a_players = getplayers();

	if (a_players.size == 1)
	{
		self.n_passenger_index = 1;
	}

	m_plane_craftable = getent("plane_craftable", "targetname");
	m_plane_about_to_crash = getent("plane_about_to_crash", "targetname");
	m_plane_about_to_crash ghost();
	veh_plane_flyable = getent("plane_flyable", "targetname");
	veh_plane_flyable show();
	flag_set("plane_boarded");
	t_plane_fly = getent("plane_fly_trigger", "targetname");
	str_hint_string = "BOARD FINAL FLIGHT";
	t_plane_fly sethintstring(str_hint_string);
	self playerlinktodelta(m_plane_craftable, "tag_player_crouched_" + (self.n_passenger_index + 1));
	self allowcrouch(1);
	self allowstand(0);
	self clientnotify("sndFFCON");
	flag_wait("plane_departed");
	level notify("sndStopBrutusLoop");
	self clientnotify("sndPS");
	self playsoundtoplayer("zmb_plane_takeoff", self);
	level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent("plane_takeoff", self);
	m_plane_craftable ghost();
	self playerlinktodelta(veh_plane_flyable, "tag_player_crouched_" + (self.n_passenger_index + 1));
	self setclientfieldtoplayer("effects_escape_flight", 1);
	flag_wait("plane_approach_bridge");
	self thread maps\mp\zm_alcatraz_sq::snddelayedimp();
	self setclientfieldtoplayer("effects_escape_flight", 2);
	self unlink();
	self playerlinktoabsolute(veh_plane_flyable, "tag_player_crouched_" + (self.n_passenger_index + 1));
	flag_wait("plane_zapped");
	flag_set("activate_player_zone_bridge");
	self playsoundtoplayer("zmb_plane_fall", self);
	self setclientfieldtoplayer("effects_escape_flight", 3);
	self.dontspeak = 1;
	self setclientfieldtoplayer("isspeaking", 1);
	self playerlinktodelta(m_plane_about_to_crash, "tag_player_crouched_" + (self.n_passenger_index + 1), 1, 0, 0, 0, 0, 1);
	flag_wait("plane_crashed");
	self thread fadetoblackforxsec(0, 2, 0, 0.5, "black");
	self unlink();
	self allowstand(1);
	self setstance("stand");
	self allowcrouch(0);
	flag_clear("spawn_zombies");
	self setorigin(a_nml_teleport_targets[self.n_passenger_index].origin);
	e_poi = getstruct("plane_crash_poi", "targetname");
	vec_to_target = e_poi.origin - self.origin;
	vec_to_target = vectortoangles(vec_to_target);
	vec_to_target = (0, vec_to_target[1], 0);
	self setplayerangles(vec_to_target);
	n_shellshock_duration = 5;
	self shellshock("explosion", n_shellshock_duration);
	self.on_a_plane = 0;
	stage_final();
}

stage_final()
{
	level notify("stage_final");
	level endon("stage_final");
	b_everyone_alive = 0;

	while (isdefined(b_everyone_alive) && !b_everyone_alive)
	{
		b_everyone_alive = 1;
		a_players = getplayers();

		foreach (player in a_players)
		{
			if (isdefined(player.afterlife) && player.afterlife)
			{
				b_everyone_alive = 0;
				wait 0.05;
				break;
			}
		}
	}

	level._should_skip_ignore_player_logic = ::final_showdown_zombie_logic;
	flag_set("spawn_zombies");
	array_func(getplayers(), maps\mp\zombies\_zm_afterlife::afterlife_remove);
	p_weasel = undefined;
	a_player_team = [];
	a_players = getplayers();

	foreach (player in a_players)
	{
		player.dontspeak = 1;
		player setclientfieldtoplayer("isspeaking", 1);

		if (player.character_name == "Arlington")
		{
			p_weasel = player;
			continue;
		}

		a_player_team[a_player_team.size] = player;
	}

	if (isdefined(p_weasel) && a_player_team.size > 0)
	{
		level.longregentime = 1000000;
		level.playerhealth_regularregendelay = 1000000;
		p_weasel.team = level.zombie_team;
		p_weasel.pers["team"] = level.zombie_team;
		p_weasel.sessionteam = level.zombie_team;
		p_weasel.maxhealth = a_player_team.size * 2000;
		p_weasel.health = p_weasel.maxhealth;

		foreach (player in a_player_team)
		{
			player.maxhealth = 2000;
			player.health = player.maxhealth;
		}

		level thread final_showdown_track_weasel(p_weasel);
		level thread final_showdown_track_team(a_player_team);
		n_spawns_needed = 2;

		for (i = n_spawns_needed; i > 0; i--)
		{
			maps\mp\zombies\_zm_ai_brutus::brutus_spawn_in_zone("zone_golden_gate_bridge", 1);
		}

		level thread final_battle_vo(p_weasel, a_player_team);
		level notify("pop_goes_the_weasel_achieved");

		level waittill("showdown_over");
	}
	else if (isdefined(p_weasel))
	{
		level.winner = "weasel";
	}
	else
	{
		level.winner = "team";
	}

	level clientnotify("sndSQF");
	level.brutus_respawn_after_despawn = 0;
	level thread clean_up_final_brutuses();
	wait 2;

	level notify("stop_timers");

	if (level.winner == "weasel")
	{
		a_players = getplayers();

		foreach (player in a_players)
		{
			player freezecontrols(1);
			player maps\mp\zombies\_zm_stats::increment_client_stat("prison_ee_good_ending", 0);
			player thread fadetoblackforxsec(0, 5, 0.5, 0, "white");
			player create_ending_message(&"ZM_PRISON_GOOD");
			player.client_hint.sort = 55;
			player.client_hint.color = (0, 0, 0);
			playsoundatposition("zmb_quest_final_white_good", (0, 0, 0));
			level.sndgameovermusicoverride = "game_over_final_good";
		}

		level.custom_intermission = ::player_intermission_bridge;
	}
	else
	{
		a_players = getplayers();

		foreach (player in a_players)
		{
			player freezecontrols(1);
			player maps\mp\zombies\_zm_stats::increment_client_stat("prison_ee_bad_ending", 0);
			player thread fadetoblackforxsec(0, 5, 0.5, 0, "white");
			player create_ending_message(&"ZM_PRISON_BAD");
			player.client_hint.sort = 55;
			player.client_hint.color = (0, 0, 0);
			playsoundatposition("zmb_quest_final_white_bad", (0, 0, 0));
			level.sndgameovermusicoverride = "game_over_final_bad";
		}
	}

	wait 5;
	a_players = getplayers();

	foreach (player in a_players)
	{
		if (isdefined(player.client_hint))
		{
			player thread destroy_tutorial_message();
		}

		if (isdefined(player.revivetrigger))
		{
			player thread revive_success(player, 0);
			player cleanup_suicide_hud();
		}

		if (isdefined(player))
		{
			player ghost();
		}
	}

	if (isdefined(p_weasel))
	{
		p_weasel.team = "allies";
		p_weasel.pers["team"] = "allies";
		p_weasel.sessionteam = "allies";
		p_weasel ghost();
	}

	level notify("end_game");
}

final_battle_vo(p_weasel, a_player_team)
{
	level endon("showdown_over");
	wait 10;
	a_players = arraycopy(a_player_team);
	player = a_players[randomintrange(0, a_players.size)];
	arrayremovevalue(a_players, player);

	if (a_players.size > 0)
	{
		player_2 = a_players[randomintrange(0, a_players.size)];
	}

	if (isdefined(player))
	{
		player final_battle_reveal();
	}

	wait 3;

	if (isdefined(p_weasel))
	{
		p_weasel playsoundontag("vox_plr_3_end_scenario_0", "J_Head");
	}

	wait 1;

	foreach (player in a_player_team)
	{
		level thread final_showdown_create_icon(player, p_weasel);
		level thread final_showdown_create_icon(p_weasel, player);
	}

	wait 10;

	if (isdefined(player_2))
	{
		player_2 playsoundontag("vox_plr_" + player_2.characterindex + "_end_scenario_1", "J_Head");
	}
	else if (isdefined(player))
	{
		player playsoundontag("vox_plr_" + player.characterindex + "_end_scenario_1", "J_Head");
	}

	wait 4;

	if (isdefined(p_weasel))
	{
		p_weasel playsoundontag("vox_plr_3_end_scenario_1", "J_Head");
		p_weasel.dontspeak = 0;
		p_weasel setclientfieldtoplayer("isspeaking", 0);
	}

	foreach (player in a_player_team)
	{
		player.dontspeak = 0;
		player setclientfieldtoplayer("isspeaking", 0);
	}
}

final_showdown_create_icon(player, enemy)
{
	height_offset = 72;
	waypoint_origin = spawn("script_model", enemy.origin + (0, 0, height_offset));
	waypoint_origin setmodel("tag_origin");
	waypoint_origin linkto(enemy);

	hud_elem = newclienthudelem(player);
	hud_elem.alpha = 1;
	hud_elem.archived = 1;
	hud_elem.hidewheninmenu = 1;
	hud_elem.color = (1, 0, 0);
	hud_elem setwaypoint(1, "waypoint_kill_red");
	hud_elem settargetent(waypoint_origin);

	waittill_any_ents(level, "showdown_over", enemy, "disconnect");

	waypoint_origin delete();
	hud_elem destroy();
}