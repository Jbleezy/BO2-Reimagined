#include maps\mp\zm_buried_sq_bt;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_buried_sq;

stage_vo_watch_gallows()
{
	level endon("sq_bt_over");
	level endon("end_game_reward_starts_maxis");
	level endon("end_game_reward_starts_richtofen");
	s_struct = getstruct("sq_gallows", "targetname");
	trigger = spawn("trigger_radius", s_struct.origin, 0, 128, 72);

	trigger waittill("trigger");

	trigger delete();
	m_maxis_vo_spot = spawn("script_model", s_struct.origin);
	m_maxis_vo_spot setmodel("tag_origin");

	if (flag("sq_intro_vo_done"))
		maxissay("vox_maxi_sidequest_gallows_0", m_maxis_vo_spot);

	level waittill("mtower_object_planted");

	if (flag("sq_intro_vo_done"))
		maxissay("vox_maxi_sidequest_parts_3", m_maxis_vo_spot, 1);

	m_maxis_vo_spot delete();
}

stage_vo_watch_guillotine()
{
	level endon("sq_bt_over");
	level endon("end_game_reward_starts_maxis");
	level endon("end_game_reward_starts_richtofen");
	s_struct = getstruct("sq_guillotine", "targetname");
	trigger = spawn("trigger_radius", s_struct.origin, 0, 128, 72);

	trigger waittill("trigger");

	trigger delete();
	richtofensay("vox_zmba_sidequest_gallows_0", 9);
	richtofensay("vox_zmba_sidequest_gallows_1", 12);

	level waittill("rtower_object_planted");

	richtofensay("vox_zmba_sidequest_parts_3", 11);
}