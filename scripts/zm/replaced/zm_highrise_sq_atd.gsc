#include maps\mp\zm_highrise_sq_atd;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_highrise_sq;

init()
{
	flag_init("sq_atd_elevator0");
	flag_init("sq_atd_elevator1");
	flag_init("sq_atd_elevator2");
	flag_init("sq_atd_elevator3");
	flag_init("sq_atd_elevator_activated");
	flag_init("sq_atd_drg_puzzle_1st_error");
	flag_init("sq_atd_drg_puzzle_complete");
	declare_sidequest_stage("sq", "atd", ::init_stage, ::stage_logic, ::exit_stage_1);
	sq_atd_dragon_icon_setup();
}

stage_logic()
{
	sq_atd_elevators();
	sq_atd_drg_puzzle();
	stage_completed("sq", level._cur_stage_name);
}

sq_atd_elevators()
{
	a_elevators = array("elevator_bldg1b_trigger", "elevator_bldg1d_trigger", "elevator_bldg3b_trigger", "elevator_bldg3c_trigger");
	a_elevator_flags = array("sq_atd_elevator0", "sq_atd_elevator1", "sq_atd_elevator2", "sq_atd_elevator3");

	for (i = 0; i < a_elevators.size; i++)
	{
		trig_elevator = getent(a_elevators[i], "targetname");
		trig_elevator thread sq_atd_watch_elevator(a_elevator_flags[i]);
	}

	while (!flag("sq_atd_elevator0") || !flag("sq_atd_elevator1") || !flag("sq_atd_elevator2") || !flag("sq_atd_elevator3"))
	{
		flag_wait_any_array(a_elevator_flags);
		wait 0.5;
	}

	flag_set("sq_atd_elevator_activated");
	vo_richtofen_atd_elevators();
	level thread vo_maxis_atd_elevators();
}

sq_atd_watch_elevator(str_flag)
{
	level endon("sq_atd_elevator_activated");

	while (true)
	{
		self waittill("trigger", e_who);

		if (!isplayer(e_who))
		{
			wait 0.05;
			continue;
		}

		a_dragon_icons = getentarray("elevator_dragon_icon", "targetname");

		foreach (m_icon in a_dragon_icons)
		{
			if (issubstr(self.targetname, m_icon.script_noteworthy))
			{
				v_off_pos = m_icon.m_lit_icon.origin;
				m_icon.m_lit_icon unlink();
				m_icon unlink();
				m_icon.m_lit_icon.origin = m_icon.origin;
				m_icon.origin = v_off_pos;
				m_icon.m_lit_icon linkto(m_icon.m_elevator);
				m_icon linkto(m_icon.m_elevator);
				m_icon playsound("zmb_sq_symbol_light");
				break;
			}
		}

		flag_set(str_flag);
		return;
	}
}

sq_atd_drg_puzzle()
{
	level.sq_atd_cur_drg = 0;
	a_puzzle_trigs = getentarray("trig_atd_drg_puzzle", "targetname");
	a_puzzle_trigs = array_randomize(a_puzzle_trigs);

	for (i = 0; i < a_puzzle_trigs.size; i++)
	{
		a_puzzle_trigs[i] thread drg_puzzle_trig_think(i);
	}

	while (level.sq_atd_cur_drg < 4)
	{
		wait 1;
	}

	flag_set("sq_atd_drg_puzzle_complete");
	level thread vo_maxis_atd_order_complete();
}

drg_puzzle_trig_think(n_order_id)
{
	self.drg_active = 0;
	m_unlit = getent(self.target, "targetname");
	m_lit = m_unlit.lit_icon;
	v_top = m_unlit.origin;
	v_hidden = m_lit.origin;

	self waittill("trigger", e_who);

	m_lit.origin = v_top;
	m_unlit.origin = v_hidden;
	m_lit playsound("zmb_sq_symbol_light");
	self.drg_active = 1;
	level thread vo_richtofen_atd_order(level.sq_atd_cur_drg);
	level.sq_atd_cur_drg++;
}