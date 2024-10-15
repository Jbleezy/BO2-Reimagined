#include maps\mp\zm_buried_sq_ip;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_buried_sq;
#include maps\mp\zombies\_zm_zonemgr;

stage_logic()
{
	if (flag("sq_is_max_tower_built"))
	{
		a_button_structs = getstructarray("sq_bp_button", "targetname");
		array_thread(a_button_structs, ::sq_bp_spawn_trigger);
		m_lightboard = getent("sq_bp_board", "targetname");
		m_lightboard setclientfield("buried_sq_bp_set_lightboard", 1);

		while (!flag("sq_ip_puzzle_complete"))
		{
			sq_bp_start_puzzle_lights();
			sq_bp_delete_green_lights();
			wait_network_frame();
			wait_network_frame();
			wait_network_frame();
			wait_network_frame();
			wait_network_frame();
		}
	}
	else
	{
		sq_ml_spawn_levers();
		a_levers = getentarray("sq_ml_lever", "targetname");
		array_thread(a_levers, ::sq_ml_spawn_trigger);
		level thread sq_ml_puzzle_logic();
		flag_wait("sq_ip_puzzle_complete");
	}

	wait_network_frame();
	stage_completed("sq", level._cur_stage_name);
}

sq_bp_start_puzzle_lights()
{
	level endon("sq_bp_wrong_button");
	level endon("sq_bp_timeout");
	a_button_structs = getstructarray("sq_bp_button", "targetname");
	a_tags = [];

	foreach (m_button in a_button_structs)
	{
		a_tags[a_tags.size] = m_button.script_string;
	}

	a_tags = array_randomize(a_tags);
	m_lightboard = getent("sq_bp_board", "targetname");

	foreach (str_tag in a_tags)
	{
		level waittill("sq_bp_correct_button");
	}

	flag_set("sq_ip_puzzle_complete");
	a_button_structs = getstructarray("sq_bp_button", "targetname");

	foreach (s_button in a_button_structs)
	{
		if (isdefined(s_button.trig))
		{
			s_button.trig delete();
		}
	}
}

sq_bp_spawn_trigger()
{
	level endon("sq_ip_puzzle_complete");
	self.trig = spawn("trigger_radius_use", self.origin, 0, 16, 16);
	self.trig setcursorhint("HINT_NOICON");
	self.trig sethintstring(&"ZM_BURIED_SQ_BUT_U");
	self.trig triggerignoreteam();
	self.trig usetriggerrequirelookat();

	while (true)
	{
		self.trig waittill("trigger");

		self.trig sethintstring("");
		level thread sq_bp_button_pressed(self.script_string, self.trig);
		wait 1;
		self.trig sethintstring(&"ZM_BURIED_SQ_BUT_U");
	}
}

sq_bp_button_pressed(str_tag, trig)
{
	trig playsound("zmb_sq_bell_yes");

	if (is_true(trig.triggered))
	{
		return;
	}

	trig.triggered = 1;
	sq_bp_light_on(str_tag, "green");
	level notify("sq_bp_correct_button");
}

sq_ml_puzzle_logic()
{
	a_levers = getentarray("sq_ml_lever", "targetname");
	level.sq_ml_curr_lever = 0;
	a_levers = array_randomize(a_levers);

	for (i = 0; i < a_levers.size; i++)
	{
		a_levers[i].n_lever_order = i;
	}

	while (true)
	{
		level.sq_ml_curr_lever = 0;
		sq_ml_puzzle_wait_for_levers();
		n_correct = 0;

		foreach (m_lever in a_levers)
		{
			playfxontag(level._effect["sq_spark"], m_lever, "tag_origin");
			n_correct++;
			m_lever playsound("zmb_sq_maze_correct_spark");
		}

		if (n_correct == a_levers.size)
		{
			flag_set("sq_ip_puzzle_complete");
		}

		level waittill("zm_buried_maze_changed");

		level notify("sq_ml_reset_levers");
		wait 1;
	}
}