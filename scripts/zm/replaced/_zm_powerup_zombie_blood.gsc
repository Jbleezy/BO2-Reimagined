#include maps\mp\zombies\_zm_powerup_zombie_blood;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_visionset_mgr;

init(str_zombie_model)
{
	level.str_zombie_blood_model = str_zombie_model;
	precachemodel(level.str_zombie_blood_model);
	level.str_zombie_blood_view = "c_zom_zombie_viewhands";
	precachemodel(level.str_zombie_blood_view);
	registerclientfield("allplayers", "player_zombie_blood_fx", 14000, 1, "int");
	level._effect["zombie_blood"] = loadfx("maps/zombie_tomb/fx_tomb_pwr_up_zmb_blood");
	level._effect["zombie_blood_1st"] = loadfx("maps/zombie_tomb/fx_zm_blood_overlay_pclouds");
	add_zombie_powerup("zombie_blood", "p6_zm_tm_blood_power_up", &"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_always_drop, 1, 0, 0, undefined, "powerup_zombie_blood", "zombie_powerup_zombie_blood_time", "zombie_powerup_zombie_blood_on");
	powerup_set_can_pick_up_in_last_stand("zombie_blood", 0);
	onplayerconnect_callback(::init_player_zombie_blood_vars);
	level.a_zombie_blood_entities = [];
	array_thread(getentarray("zombie_blood_visible", "targetname"), ::make_zombie_blood_entity);

	if (!isdefined(level.vsmgr_prio_visionset_zm_powerup_zombie_blood))
	{
		level.vsmgr_prio_visionset_zm_powerup_zombie_blood = 15;
	}

	if (!isdefined(level.vsmgr_prio_overlay_zm_powerup_zombie_blood))
	{
		level.vsmgr_prio_overlay_zm_powerup_zombie_blood = 16;
	}

	maps\mp\_visionset_mgr::vsmgr_register_info("visionset", "zm_powerup_zombie_blood_visionset", 14000, level.vsmgr_prio_visionset_zm_powerup_zombie_blood, 15, 1);
	maps\mp\_visionset_mgr::vsmgr_register_info("overlay", "zm_powerup_zombie_blood_overlay", 14000, level.vsmgr_prio_overlay_zm_powerup_zombie_blood, 15, 1);
}

zombie_blood_powerup(m_powerup, e_player)
{
	e_player notify("zombie_blood");
	e_player endon("zombie_blood");
	e_player endon("disconnect");
	e_player thread powerup_vo("zombie_blood");
	e_player._show_solo_hud = 1;

	if (is_true(e_player.zombie_vars["zombie_powerup_zombie_blood_on"]))
	{
		e_player.zombie_vars["zombie_powerup_zombie_blood_time"] += 30;
	}
	else
	{
		e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
	}

	e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 1;
	level notify("player_zombie_blood", e_player);
	maps\mp\_visionset_mgr::vsmgr_activate("visionset", "zm_powerup_zombie_blood_visionset", e_player);
	maps\mp\_visionset_mgr::vsmgr_activate("overlay", "zm_powerup_zombie_blood_overlay", e_player);
	e_player setclientfield("player_zombie_blood_fx", 1);
	__new = [];

	foreach (__key, __value in level.a_zombie_blood_entities)
	{
		if (isdefined(__value))
		{
			if (isstring(__key))
			{
				__new[__key] = __value;
				continue;
			}

			__new[__new.size] = __value;
		}
	}

	level.a_zombie_blood_entities = __new;

	foreach (e_zombie_blood in level.a_zombie_blood_entities)
	{
		if (isdefined(e_zombie_blood.e_unique_player))
		{
			if (e_zombie_blood.e_unique_player == e_player)
			{
				e_zombie_blood setvisibletoplayer(e_player);
			}

			continue;
		}

		e_zombie_blood setvisibletoplayer(e_player);
	}

	if (!isdefined(e_player.m_fx))
	{
		v_origin = e_player gettagorigin("J_SpineLower");
		v_angles = e_player gettagangles("J_SpineLower");
		m_fx = spawn("script_model", v_origin);
		m_fx setmodel("tag_origin");
		m_fx.angles = v_angles;
		m_fx linkto(e_player, "J_SpineLower", (0, 0, 0), (0, 0, 0));
		m_fx thread fx_disconnect_watch(e_player);
		playfxontag(level._effect["zombie_blood"], m_fx, "tag_origin");
		e_player.m_fx = m_fx;
		e_player.m_fx playloopsound("zmb_zombieblood_3rd_loop", 1);

		if (isdefined(level.str_zombie_blood_model))
		{
			e_player.hero_model = e_player.model;
			e_player setmodel(level.str_zombie_blood_model);
		}

		if (isdefined(level.str_zombie_blood_view))
		{
			e_player.hero_view = e_player getviewmodel();
			e_player setviewmodel(level.str_zombie_blood_view);
		}
	}

	e_player thread watch_zombie_blood_early_exit();

	while (e_player.zombie_vars["zombie_powerup_zombie_blood_time"] >= 0)
	{
		wait 0.05;
		e_player.zombie_vars["zombie_powerup_zombie_blood_time"] -= 0.05;
	}

	e_player notify("zombie_blood_over");

	if (isdefined(e_player.characterindex))
	{
		e_player playsound("vox_plr_" + e_player.characterindex + "_exert_grunt_" + randomintrange(0, 3));
	}

	e_player.m_fx delete();
	maps\mp\_visionset_mgr::vsmgr_deactivate("visionset", "zm_powerup_zombie_blood_visionset", e_player);
	maps\mp\_visionset_mgr::vsmgr_deactivate("overlay", "zm_powerup_zombie_blood_overlay", e_player);
	e_player.zombie_vars["zombie_powerup_zombie_blood_on"] = 0;
	e_player.zombie_vars["zombie_powerup_zombie_blood_time"] = 30;
	e_player._show_solo_hud = 0;
	e_player setclientfield("player_zombie_blood_fx", 0);

	e_player.early_exit = undefined;

	__new = [];

	foreach (__key, __value in level.a_zombie_blood_entities)
	{
		if (isdefined(__value))
		{
			if (isstring(__key))
			{
				__new[__key] = __value;
				continue;
			}

			__new[__new.size] = __value;
		}
	}

	level.a_zombie_blood_entities = __new;

	foreach (e_zombie_blood in level.a_zombie_blood_entities)
	{
		e_zombie_blood setinvisibletoplayer(e_player);
	}

	if (isdefined(e_player.hero_model))
	{
		e_player setmodel(e_player.hero_model);
		e_player.hero_model = undefined;
	}

	if (isdefined(e_player.hero_view))
	{
		e_player setviewmodel(e_player.hero_view);
		e_player.hero_view = undefined;
	}
}