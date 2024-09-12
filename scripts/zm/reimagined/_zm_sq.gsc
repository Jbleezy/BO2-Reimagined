#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

navcomputer_waitfor_navcard()
{
	trig_pos = getstruct("sq_common_key", "targetname");
	navcomputer_use_trig = spawn("trigger_radius_use", trig_pos.origin, 0, 48, 48);
	navcomputer_use_trig.cost = 100000;
	navcomputer_use_trig setcursorhint("HINT_NOICON");
	navcomputer_use_trig sethintstring(&"ZOMBIE_NAVCARD_USE", navcomputer_use_trig.cost);
	navcomputer_use_trig triggerignoreteam();

	while (true)
	{
		navcomputer_use_trig waittill("trigger", who);

		if (isplayer(who) && is_player_valid(who))
		{
			if (who.score >= navcomputer_use_trig.cost)
			{
				who maps\mp\zombies\_zm_score::minus_to_player_score(navcomputer_use_trig.cost);

				navcomputer_use_trig sethintstring(&"ZOMBIE_NAVCARD_SUCCESS");
				navcomputer_use_trig playsound("zmb_sq_navcard_success");

				players = get_players();

				foreach (player in players)
				{
					player freezecontrols(1);
				}

				level notify("end_game");

				return;
			}
			else
			{
				navcomputer_use_trig playsound("zmb_sq_navcard_fail");
			}
		}
	}
}

sq_give_player_all_perks()
{
	perks = [];

	if (isDefined(level._random_perk_machine_perk_list))
	{
		perks = array_randomize(level._random_perk_machine_perk_list);
	}
	else
	{
		machines = array_randomize(getentarray("zombie_vending", "targetname"));

		for (i = 0; i < machines.size; i++)
		{
			if (machines[i].script_noteworthy == "specialty_weapupgrade")
			{
				continue;
			}

			perks[perks.size] = machines[i].script_noteworthy;
		}
	}

	foreach (perk in perks)
	{
		if (isdefined(self.perk_purchased) && self.perk_purchased == perk)
		{
			continue;
		}

		if (self hasperk(perk) || self maps\mp\zombies\_zm_perks::has_perk_paused(perk))
		{
			continue;
		}

		self maps\mp\zombies\_zm_perks::give_perk(perk, 0);
		wait 0.25;
	}
}

sq_play_song()
{
	ent = spawn("script_origin", (0, 0, 0));
	song = sq_get_song_for_map();
	time = sq_get_time_for_song(song);

	while (1)
	{
		level waittill("end_of_round");

		if (!is_true(level.music_override))
		{
			break;
		}
	}

	level.music_override = 1;
	ent playsound(song);
	level thread sq_song_wait(time);
	level waittill_either("end_game", "sndSongDone");
	ent stopsounds();
	wait 0.05;
	ent delete();
	level.music_override = 0;
}

sq_song_wait(time)
{
	level endon("end_game");
	wait time;
	level notify("sndSongDone");
}

sq_get_song_for_map()
{
	if (level.script == "zm_transit")
	{
		return "mus_zmb_secret_song_benn_just_like_you";
	}
	else if (level.script == "zm_highrise")
	{
		return "mus_zmb_secret_song_benn_high_risers";
	}
	else if (level.script == "zm_buried")
	{
		return "mus_zmb_secret_song_benn_bury_me";
	}
	else if (level.script == "zm_prison")
	{
		return "mus_zmb_secret_song_benn_alcatraz";
	}
	else if (level.script == "zm_tomb")
	{
		return "mus_zmb_secret_song_benn_the_divider";
	}

	return "";
}

sq_get_time_for_song(song)
{
	if (song == "mus_zmb_secret_song_benn_just_like_you")
	{
		return 268;
	}
	else if (song == "mus_zmb_secret_song_benn_high_risers")
	{
		return 196;
	}
	else if (song == "mus_zmb_secret_song_benn_bury_me")
	{
		return 293;
	}
	else if (song == "mus_zmb_secret_song_benn_alcatraz")
	{
		return 370;
	}
	else if (song == "mus_zmb_secret_song_benn_the_divider")
	{
		return 312;
	}

	return 0;
}

sq_complete_time_hud()
{
	level.quest_timer_hud_value = level.total_timer_hud_value;

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_quest_timer", 1, level.quest_timer_hud_value);
		player luinotifyevent(&"hud_fade_in_quest_timer", 1, 500);
	}

	wait 10;

	level.quest_timer_hud_value = undefined;

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_fade_out_quest_timer", 1, 500);
	}
}