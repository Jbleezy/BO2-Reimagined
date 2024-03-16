#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

lava_damage_depot()
{
	trigs = getentarray("lava_damage", "targetname");
	volume = getent("depot_lava_volume", "targetname");
	exploder(2);

	foreach (trigger in trigs)
	{
		if (isDefined(trigger.script_string) && trigger.script_string == "depot_lava")
		{
			trig = trigger;
		}
	}

	if (isDefined(trig))
	{
		trig.script_float = 0.05;
	}

	flag_wait("power_on");

	while (!volume maps\mp\zm_transit::depot_lava_seen())
	{
		wait 0.05;
	}

	if (isDefined(trig))
	{
		trig.script_float = 0.4;
		earthquake(0.5, 1.5, trig.origin, 1000);
		level clientnotify("earth_crack");
		crust = getent("depot_black_lava", "targetname");
		crust delete();
	}

	stop_exploder(2);
	exploder(3);
}

sndplaymusicegg(player, ent)
{
	song = sndplaymusicegg_get_song_for_origin(ent);
	time = sndplaymusicegg_get_time_for_song(song);

	level.music_override = 1;
	wait 1;
	ent playsound(song);
	level thread sndplaymusicegg_wait(time);
	level waittill_either("end_game", "sndSongDone");
	ent stopsounds();
	wait 0.05;
	ent delete();
	level.music_override = 0;
}

sndplaymusicegg_wait(time)
{
	level endon("end_game");
	wait time;
	level notify("sndSongDone");
}

sndplaymusicegg_get_song_for_origin(ent)
{
	if (ent.origin == (1864, -7, -19))
	{
		return "mus_zmb_secret_song";
	}
	else if (ent.origin == (7914, -6557, 269))
	{
		return "mus_zmb_secret_song_a7x_carry_on";
	}
	else if (ent.origin == (-7562, 4570, -19))
	{
		return "mus_zmb_secret_song_skrillex_try_it_out";
	}

	return "";
}

sndplaymusicegg_get_time_for_song(song)
{
	if (song == "mus_zmb_secret_song")
	{
		return 256;
	}
	else if (song == "mus_zmb_secret_song_a7x_carry_on")
	{
		return 254;
	}
	else if (song == "mus_zmb_secret_song_skrillex_try_it_out")
	{
		return 231;
	}

	return 0;
}