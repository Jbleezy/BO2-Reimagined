#include maps\mp\zm_tomb_tank;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zm_tomb_amb;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_weap_staff_fire;
#include maps\mp\zombies\_zm_spawner;

init()
{
	registerclientfield("vehicle", "tank_tread_fx", 14000, 1, "int");
	registerclientfield("vehicle", "tank_flamethrower_fx", 14000, 2, "int");
	registerclientfield("vehicle", "tank_cooldown_fx", 14000, 2, "int");

	if (!is_classic())
	{
		tank = getent("tank", "targetname");
		tank delete();

		trigs = getentarray("trig_tank_station_call", "targetname");

		foreach (trig in trigs)
		{
			trig delete();
		}

		return;
	}

	tank_precache();
	onplayerconnect_callback(::onplayerconnect);
	level.enemy_location_override_func = ::enemy_location_override;
	level.adjust_enemyoverride_func = ::adjust_enemyoverride;
	level.zm_mantle_over_40_move_speed_override = ::zm_mantle_over_40_move_speed_override;
	level.vh_tank = getent("tank", "targetname");
	level.vh_tank tank_setup();
	level.vh_tank thread tankuseanimtree();
	level.vh_tank thread tank_discovery_vo();
	level thread maps\mp\zm_tomb_vo::watch_occasional_line("tank", "tank_flame_zombie", "vo_tank_flame_zombie");
	level thread maps\mp\zm_tomb_vo::watch_occasional_line("tank", "tank_leave", "vo_tank_leave");
	level thread maps\mp\zm_tomb_vo::watch_occasional_line("tank", "tank_cooling", "vo_tank_cooling");
}

players_on_tank_update()
{
	flag_wait("start_zombie_round_logic");
	self thread tank_disconnect_paths();

	while (true)
	{
		a_players = getplayers();

		foreach (e_player in a_players)
		{
			if (is_player_valid(e_player))
			{
				if (isdefined(e_player.b_already_on_tank) && !e_player.b_already_on_tank && e_player entity_on_tank())
				{
					e_player.b_already_on_tank = 1;
					self.n_players_on++;

					if (self ent_flag("tank_cooldown"))
					{
						level notify("vo_tank_cooling", e_player);
					}

					e_player thread tank_rumble_update();
					e_player thread tank_rides_around_map_achievement_watcher();
					e_player setclientdvars(
					    "player_view_pitch_up", 85,
					    "player_view_pitch_down", 85);

					foreach (trig in self.t_rear_tread)
					{
						e_player thread tank_push_player_off_edge(trig);
					}

					continue;
				}

				if (isdefined(e_player.b_already_on_tank) && e_player.b_already_on_tank && !e_player entity_on_tank())
				{
					e_player.b_already_on_tank = 0;
					self.n_players_on--;
					level notify("vo_tank_leave", e_player);
					e_player notify("player_jumped_off_tank");
					e_player setclientfieldtoplayer("player_rumble_and_shake", 0);
					e_player setclientdvars(
					    "player_view_pitch_up", 89.9999,
					    "player_view_pitch_down", 89.9999);
				}
			}
		}

		wait 0.05;
	}
}

tank_push_player_off_edge(trig)
{
	self endon("player_jumped_off_tank");

	while (self.b_already_on_tank)
	{
		trig waittill("trigger", player);

		if (player == self && self isonground())
		{
			amount = 150;

			if (level.vh_tank ent_flag("tank_moving"))
			{
				amount = -150;
			}

			v_push = anglestoforward(trig.angles) * amount;
			self setvelocity(v_push);
		}

		wait 0.05;
	}
}

wait_for_tank_cooldown()
{
	self thread snd_fuel();

	self.n_cooldown_timer = 30;

	wait(self.n_cooldown_timer);
	level notify("stp_cd");
	self playsound("zmb_tank_ready");
	self playloopsound("zmb_tank_idle");
}

activate_tank_wait_with_no_cost()
{
	// removed
}