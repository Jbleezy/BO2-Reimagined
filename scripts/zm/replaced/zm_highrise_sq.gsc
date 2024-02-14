#include maps\mp\zm_highrise_sq;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_highrise_sq_atd;
#include maps\mp\zm_highrise_sq_slb;
#include maps\mp\zm_highrise_sq_ssp;
#include maps\mp\zm_highrise_sq_pts;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_perks;

init()
{
	if (isdefined(level.gamedifficulty) && level.gamedifficulty == 0)
	{
		sq_easy_cleanup();
		return;
	}

	flag_init("sq_disabled");
	flag_init("sq_branch_complete");
	flag_init("sq_tower_active");
	flag_init("sq_player_has_sniper");
	flag_init("sq_player_has_ballistic");
	flag_init("sq_ric_tower_complete");
	flag_init("sq_max_tower_complete");
	flag_init("sq_players_out_of_sync");
	flag_init("sq_ball_picked_up");
	register_map_navcard("navcard_held_zm_highrise", "navcard_held_zm_transit");
	ss_buttons = getentarray("sq_ss_button", "targetname");

	for (i = 0; i < ss_buttons.size; i++)
	{
		ss_buttons[i] usetriggerrequirelookat();
		ss_buttons[i] sethintstring("");
		ss_buttons[i] setcursorhint("HINT_NOICON");
	}

	level thread mahjong_tiles_setup();
	flag_init("sq_nav_built");
	declare_sidequest("sq", ::init_sidequest, ::sidequest_logic, ::complete_sidequest, ::generic_stage_start, ::generic_stage_complete);
	maps\mp\zm_highrise_sq_atd::init();
	maps\mp\zm_highrise_sq_slb::init();
	declare_sidequest("sq_1", ::init_sidequest_1, ::sidequest_logic_1, ::complete_sidequest, ::generic_stage_start, ::generic_stage_complete);
	maps\mp\zm_highrise_sq_ssp::init_1();
	maps\mp\zm_highrise_sq_pts::init_1();
	declare_sidequest("sq_2", ::init_sidequest_2, ::sidequest_logic_2, ::complete_sidequest, ::generic_stage_start, ::generic_stage_complete);
	maps\mp\zm_highrise_sq_ssp::init_2();
	maps\mp\zm_highrise_sq_pts::init_2();
	level thread init_navcard();
	level thread init_navcomputer();
	precache_sidequest_assets();
}

sidequest_logic()
{
	level thread watch_nav_computer_built();
	level thread navcomputer_waitfor_navcard();
	flag_wait("power_on");
	level thread vo_richtofen_power_on();
	flag_wait("sq_nav_built");

	if (!is_true(level.navcomputer_spawned))
		update_sidequest_stats("sq_highrise_started");

	stage_start("sq", "atd");

	level waittill("sq_atd_over");

	stage_start("sq", "slb");

	level waittill("sq_slb_over");

	if (!is_true(level.richcompleted))
		level thread sidequest_start("sq_1");

	if (!is_true(level.maxcompleted))
		level thread sidequest_start("sq_2");

	flag_wait("sq_branch_complete");
	tower_punch_watcher();

	if (flag("sq_ric_tower_complete"))
		update_sidequest_stats("sq_highrise_rich_complete");
	else if (flag("sq_max_tower_complete"))
		update_sidequest_stats("sq_highrise_maxis_complete");
}

tower_punch_watcher()
{
	level thread playtoweraudio();
	a_leg_trigs = [];

	foreach (str_wind in level.a_wind_order)
		a_leg_trigs[a_leg_trigs.size] = "sq_tower_" + str_wind;

	level.n_cur_leg = 0;
	level.sq_leg_punches = 0;

	foreach (str_leg in a_leg_trigs)
	{
		t_leg = getent(str_leg, "script_noteworthy");
		t_leg thread tower_punch_watch_leg(a_leg_trigs);
	}

	flag_wait("sq_tower_active");

	if (flag("sq_ric_tower_complete"))
	{
		exploder_stop(1002);
		exploder_stop(903);
		exploder(1003);
	}
	else
	{
		exploder_stop(902);
		exploder_stop(1003);
		exploder(903);
	}

	wait 1;
	level thread tower_in_sync_lightning();
	wait 1;
	level thread sq_give_all_perks();
}

tower_punch_watch_leg(a_leg_trigs)
{
	level.legs_hit = [];

	while (!flag("sq_tower_active"))
	{
		self waittill("trigger", who);

		if (!isinarray(level.legs_hit, self.script_noteworthy) && isplayer(who) && (issubstr(who.current_melee_weapon, "tazer_knuckles_zm") || issubstr(who.current_melee_weapon, "tazer_knuckles_upgraded_zm")))
		{
			level.legs_hit[level.legs_hit.size] = self.script_noteworthy;
			self playsound("zmb_sq_leg_powerup_" + level.legs_hit.size);

			if (level.legs_hit.size == 4)
				flag_set("sq_tower_active");

			return;
		}
	}
}

sq_give_all_perks()
{
	vending_triggers = getentarray("zombie_vending", "targetname");
	perks = [];

	for (i = 0; i < vending_triggers.size; i++)
	{
		perk = vending_triggers[i].script_noteworthy;

		if (perk == "specialty_weapupgrade")
			continue;

		perks[perks.size] = perk;
	}

	if (flag("sq_ric_tower_complete"))
	{
		v_fireball_start_loc = (1946, 608, 3338);
		n_fireball_exploder = 1001;
	}
	else
	{
		v_fireball_start_loc = (1068, -1362, 3340.5);
		n_fireball_exploder = 901;
	}

	level thread scripts\zm\replaced\_zm_sq::sq_complete_time_hud();

	players = getplayers();

	foreach (player in players)
	{
		player thread sq_give_player_perks(perks, v_fireball_start_loc, n_fireball_exploder);

		level waittill("sq_fireball_hit_player");
	}
}

sq_give_player_perks(perks, v_fireball_start_loc, n_fireball_exploder)
{
	self endon("disconnect");

	exploder(n_fireball_exploder);
	m_fireball = spawn("script_model", v_fireball_start_loc);
	m_fireball setmodel("tag_origin");
	playfxontag(level._effect["sidequest_dragon_fireball_max"], m_fireball, "tag_origin");

	do
	{
		wait_network_frame();
		v_to_player = vectornormalize(self gettagorigin("J_SpineLower") - m_fireball.origin);
		v_move_spot = m_fireball.origin + v_to_player * 48;
		m_fireball.origin = v_move_spot;
	}
	while (distancesquared(m_fireball.origin, self gettagorigin("J_SpineLower")) > 2304);

	m_fireball.origin = self gettagorigin("J_SpineLower");
	m_fireball linkto(self, "J_SpineLower");
	wait 1.5;
	playfx(level._effect["sidequest_flash"], m_fireball.origin);
	m_fireball delete();
	level notify("sq_fireball_hit_player");

	if (is_player_valid(self))
	{
		self thread scripts\zm\replaced\_zm_sq::sq_give_player_all_perks();
	}
}

sq_is_weapon_sniper(str_weapon)
{
	a_snipers = array("dsr50", "as50", "svu");

	foreach (str_sniper in a_snipers)
	{
		if (issubstr(str_weapon, str_sniper))
			return true;
	}

	return false;
}