#include maps\mp\zm_tomb_challenges;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_vo;
#include raw\maps\mp\_zm_challenges;
#include maps\mp\zombies\_zm_challenges;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_powerup_zombie_blood;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_weap_one_inch_punch;

challenges_init()
{
	level.challenges_add_stats = ::tomb_challenges_add_stats;
	maps\mp\zombies\_zm_challenges::init();
}

tomb_challenges_add_stats()
{
	n_kills = 115;
	n_zone_caps = 6;
	n_points_spent = 30000;
	n_boxes_filled = 4;

	add_stat("zc_headshots", 0, &"ZM_TOMB_CH1", n_kills, undefined, ::reward_packed_weapon);
	add_stat("zc_zone_captures", 0, &"ZM_TOMB_CH2", n_zone_caps, undefined, ::reward_powerup_max_ammo);
	add_stat("zc_points_spent", 0, &"ZM_TOMB_CH3", n_points_spent, undefined, ::reward_random_perk, ::track_points_spent);
	add_stat("zc_boxes_filled", 1, &"ZM_TOMB_CHT", n_boxes_filled, undefined, ::reward_one_inch_punch, ::init_box_footprints);
}

reward_packed_weapon(player, s_stat)
{
	if (!isdefined(s_stat.str_reward_weapon))
	{
		a_weapons = array("scar_zm", "sa58_zm", "mp44_zm");
		s_stat.str_reward_weapon = maps\mp\zombies\_zm_weapons::get_upgrade_weapon(random(a_weapons));
	}

	m_weapon = spawn("script_model", self.origin);
	m_weapon.angles = self.angles + vectorscale((0, 1, 0), 180.0);
	m_weapon playsound("zmb_spawn_powerup");
	m_weapon playloopsound("zmb_spawn_powerup_loop", 0.5);
	str_model = getweaponmodel(s_stat.str_reward_weapon);
	options = player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(s_stat.str_reward_weapon);
	m_weapon useweaponmodel(s_stat.str_reward_weapon, str_model, options);
	wait_network_frame();

	if (!reward_rise_and_grab(m_weapon, 50, 2, 2, 10))
	{
		return false;
	}

	player maps\mp\zombies\_zm_weapons::weapon_give(s_stat.str_reward_weapon);

	player switchtoweapon(s_stat.str_reward_weapon);
	m_weapon stoploopsound(0.1);
	player playsound("zmb_powerup_grabbed");
	m_weapon delete();
	return true;
}

reward_random_perk(player, s_stat)
{
	if (!isDefined(player.tomb_reward_perk))
	{
		player.tomb_reward_perk = player get_random_perk();
	}
	else if (isDefined(self.perk_purchased) && self.perk_purchased == player.tomb_reward_perk)
	{
		player.tomb_reward_perk = player get_random_perk();
	}
	else if (self hasperk(player.tomb_reward_perk) || self maps\mp\zombies\_zm_perks::has_perk_paused(player.tomb_reward_perk))
	{
		player.tomb_reward_perk = player get_random_perk();
	}

	perk = player.tomb_reward_perk;

	if (!isDefined(perk))
	{
		return 0;
	}

	model = maps\mp\zombies\_zm_perk_random::get_perk_weapon_model(perk);

	if (!isDefined(model))
	{
		return 0;
	}

	m_reward = spawn("script_model", self.origin);
	m_reward.angles = self.angles + vectorScale((0, 1, 0), 180);
	m_reward setmodel(model);
	m_reward playsound("zmb_spawn_powerup");
	m_reward playloopsound("zmb_spawn_powerup_loop", 0.5);
	wait_network_frame();

	if (!maps\mp\zombies\_zm_challenges::reward_rise_and_grab(m_reward, 50, 2, 2, 10))
	{
		return 0;
	}

	if (player hasperk(perk) || player maps\mp\zombies\_zm_perks::has_perk_paused(perk))
	{
		m_reward thread maps\mp\zm_tomb_challenges::bottle_reject_sink(player);
		return 0;
	}

	m_reward stoploopsound(0.1);
	player playsound("zmb_powerup_grabbed");
	m_reward thread maps\mp\zombies\_zm_perks::vending_trigger_post_think(player, perk);
	m_reward delete();
	return 1;
}

get_random_perk()
{
	perks = [];

	for (i = 0; i < level._random_perk_machine_perk_list.size; i++)
	{
		perk = level._random_perk_machine_perk_list[i];

		if (isDefined(self.perk_purchased) && self.perk_purchased == perk)
		{
			continue;
		}
		else
		{
			if (!self hasperk(perk) && !self maps\mp\zombies\_zm_perks::has_perk_paused(perk))
			{
				perks[perks.size] = perk;
			}
		}
	}

	if (perks.size > 0)
	{
		perks = array_randomize(perks);
		random_perk = perks[0];
		return random_perk;
	}
}

init_box_footprints()
{
	level.n_soul_boxes_completed = 0;
	flag_init("vo_soul_box_intro_played");
	flag_init("vo_soul_box_continue_played");
	a_boxes = getentarray("foot_box", "script_noteworthy");
	array_thread(a_boxes, ::box_footprint_think);
}

#using_animtree("fxanim_props_dlc4");

box_footprint_think()
{
	self.n_souls_absorbed = 0;
	n_souls_required = 20;

	self useanimtree(#animtree);
	self thread watch_for_foot_stomp();
	wait 1;
	self setclientfield("foot_print_box_glow", 1);
	wait 1;
	self setclientfield("foot_print_box_glow", 0);

	while (self.n_souls_absorbed < n_souls_required)
	{
		self waittill("soul_absorbed", player);

		self.n_souls_absorbed++;

		if (self.n_souls_absorbed == 1)
		{
			self clearanim(%o_zombie_dlc4_challenge_box_close, 0);
			self setanim(%o_zombie_dlc4_challenge_box_open);
			self delay_thread(1, ::setclientfield, "foot_print_box_glow", 1);

			if (isdefined(player) && !flag("vo_soul_box_intro_played"))
			{
				player delay_thread(1.5, ::richtofenrespondvoplay, "zm_box_start", 0, "vo_soul_box_intro_played");
			}
		}

		if (self.n_souls_absorbed == floor(n_souls_required / 4))
		{
			if (isdefined(player) && flag("vo_soul_box_intro_played") && !flag("vo_soul_box_continue_played"))
			{
				player thread richtofenrespondvoplay("zm_box_continue", 1, "vo_soul_box_continue_played");
			}
		}

		if (self.n_souls_absorbed == floor(n_souls_required / 2) || self.n_souls_absorbed == floor(n_souls_required / 1.3))
		{
			if (isdefined(player))
			{
				player create_and_play_dialog("soul_box", "zm_box_encourage");
			}
		}

		if (self.n_souls_absorbed == n_souls_required)
		{
			wait 1;
			self clearanim(%o_zombie_dlc4_challenge_box_open, 0);
			self setanim(%o_zombie_dlc4_challenge_box_close);
		}
	}

	self notify("box_finished");
	level.n_soul_boxes_completed++;
	e_volume = getent(self.target, "targetname");
	e_volume delete();
	self delay_thread(0.5, ::setclientfield, "foot_print_box_glow", 0);
	wait 1;
	self movez(30, 1, 1);
	wait 0.5;
	n_rotations = randomintrange(5, 7);
	v_start_angles = self.angles;

	for (i = 0; i < n_rotations; i++)
	{
		v_rotate_angles = v_start_angles + (randomfloatrange(-10, 10), randomfloatrange(-10, 10), randomfloatrange(-10, 10));
		n_rotate_time = randomfloatrange(0.2, 0.4);
		self rotateto(v_rotate_angles, n_rotate_time);

		self waittill("rotatedone");
	}

	self rotateto(v_start_angles, 0.3);
	self movez(-60, 0.5, 0.5);

	self waittill("rotatedone");

	trace_start = self.origin + vectorscale((0, 0, 1), 200.0);
	trace_end = self.origin;
	fx_trace = bullettrace(trace_start, trace_end, 0, self);
	playfx(level._effect["mech_booster_landing"], fx_trace["position"], anglestoforward(self.angles), anglestoup(self.angles));
	playsoundatposition("zmb_footprintbox_disappear", self.origin);

	self waittill("movedone");

	level maps\mp\zombies\_zm_challenges::increment_stat("zc_boxes_filled");

	if (isdefined(player))
	{
		if (level.n_soul_boxes_completed == 1)
		{
			player thread richtofenrespondvoplay("zm_box_complete");
		}
		else if (level.n_soul_boxes_completed == 4)
		{
			player thread richtofenrespondvoplay("zm_box_final_complete", 1);
		}
	}

	self delete();
}