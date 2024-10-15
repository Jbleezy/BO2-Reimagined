#include maps\mp\zm_buried_sq_tpo;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\_visionset_mgr;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm;
#include maps\mp\zm_buried_sq;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zm_buried_buildables;

stage_logic()
{
	flag_set("sq_tpo_stage_started");

	if (flag("sq_is_ric_tower_built"))
	{
		stage_logic_richtofen();
	}
	else
	{
		stage_logic_maxis();
	}

	stage_completed("sq", level._cur_stage_name);
}

stage_logic_maxis()
{
	flag_clear("sq_wisp_success");
	flag_clear("sq_wisp_failed");

	while (!flag("sq_wisp_success"))
	{
		stage_start("sq", "ts");

		level waittill("sq_ts_over");

		stage_start("sq", "ctw");

		level waittill("sq_ctw_over");
	}

	level._cur_stage_name = "tpo";
}

stage_logic_richtofen()
{
	level endon("sq_tpo_generator_powered");

	e_time_bomb_volume = getent("sq_tpo_timebomb_volume", "targetname");

	do
	{
		flag_clear("sq_tpo_time_bomb_in_valid_location");

		b_time_bomb_in_valid_location = 0;

		while (1)
		{
			if (isdefined(level.time_bomb_save_data) && isdefined(level.time_bomb_save_data.time_bomb_model))
			{
				b_time_bomb_in_valid_location = level.time_bomb_save_data.time_bomb_model istouching(e_time_bomb_volume);
				level.time_bomb_save_data.time_bomb_model.sq_location_valid = b_time_bomb_in_valid_location;
			}

			if (b_time_bomb_in_valid_location)
			{
				break;
			}

			level waittill("new_time_bomb_set");
		}

		playfxontag(level._effect["sq_tpo_time_bomb_fx"], level.time_bomb_save_data.time_bomb_model, "tag_origin");
		flag_set("sq_tpo_time_bomb_in_valid_location");
		flag_set("sq_tpo_players_in_position_for_time_warp");
		wait_for_time_bomb_to_be_detonated_or_thrown_again();
		level notify("sq_tpo_stop_checking_time_bomb_volume");

		if (flag("time_bomb_restore_active"))
		{
			if (flag("sq_tpo_players_in_position_for_time_warp"))
			{
				special_round_start();
				level notify("sq_tpo_special_round_started");
				start_item_hunt_with_timeout(60);
				special_round_end();
				level notify("sq_tpo_special_round_ended");
			}
		}

		wait_network_frame();
	}
	while (!flag("sq_tpo_generator_powered"));
}

special_round_start()
{
	flag_set("sq_tpo_special_round_active");
	level.sq_tpo.times_searched = 0;
	flag_clear("time_bomb_detonation_enabled");
	level thread sndsidequestnoirmusic();
	make_super_zombies(1);
	a_players = get_players();

	foreach (player in a_players)
	{
		vsmgr_activate("visionset", "cheat_bw", player);
	}

	level setclientfield("sq_tpo_special_round_active", 1);
}

special_round_end()
{
	level setclientfield("sq_tpo_special_round_active", 0);
	level notify("sndEndNoirMusic");
	make_super_zombies(0);
	level._time_bomb.functionality_override = 0;
	flag_set("time_bomb_detonation_enabled");
	scripts\zm\replaced\_zm_weap_time_bomb::time_bomb_detonation();

	a_players = get_players();

	foreach (player in a_players)
	{
		vsmgr_deactivate("visionset", "cheat_bw", player);
		player notify("search_done");
	}

	clean_up_special_round();
	flag_clear("sq_tpo_special_round_active");
}

promote_to_corpse_model(str_model)
{
	v_spawn_point = groundtrace(self.origin + vectorscale((0, 0, 1), 10.0), self.origin + vectorscale((0, 0, -1), 300.0), 0, undefined)["position"];
	self.corpse_model = spawn("script_model", v_spawn_point);
	self.corpse_model.angles = self.angles;
	self.corpse_model setmodel(str_model);
	self.corpse_model.targetname = "sq_tpo_corpse_model";
	self _pose_corpse();
	self.corpse_model.unitrigger = setup_unitrigger(&"ZM_BURIED_SQ_SCH", ::unitrigger_think);
}

unitrigger_think()
{
	self endon("kill_trigger");
	self thread unitrigger_killed();
	b_trigger_used = 0;

	while (!b_trigger_used)
	{
		self waittill("trigger", player);

		b_progress_bar_done = 0;
		n_frame_count = 0;

		while (player usebuttonpressed() && !b_progress_bar_done)
		{
			if (!isdefined(self.progress_bar))
			{
				self.progress_bar = player createprimaryprogressbar();
				self.progress_bar updatebar(0.01, 1 / 1.5);
				self.progress_bar_text = player createprimaryprogressbartext();
				self.progress_bar_text settext(&"ZM_BURIED_SQ_SEARCHING");
				self thread _kill_progress_bar();
			}

			n_progress_amount = n_frame_count / 30.0;
			n_frame_count++;

			if (n_progress_amount == 1)
			{
				b_progress_bar_done = 1;
			}

			wait 0.05;
		}

		self _delete_progress_bar();

		if (b_progress_bar_done)
		{
			b_trigger_used = 1;
		}
	}

	if (b_progress_bar_done)
	{
		self.stub.hint_string = "";
		self sethintstring(self.stub.hint_string);

		if (item_is_on_corpse())
		{
			iprintlnbold(&"ZM_BURIED_SQ_FND");
			player give_player_sq_tpo_switch();
		}
		else
		{
			iprintlnbold(&"ZM_BURIED_SQ_NFND");
		}

		self thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.stub);
	}
}