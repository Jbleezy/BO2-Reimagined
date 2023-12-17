#include maps\mp\zm_highrise_sq_ssp;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zm_highrise_sq;

ssp1_watch_ball(str_complete_flag)
{
	self watch_model_sliquification(10, str_complete_flag);
	self thread ssp1_rotate_ball();
	self playloopsound("zmb_sq_ball_rotate_loop", 0.25);
}

watch_model_sliquification(n_end_limit, str_complete_flag)
{
	n_count = 0;
	self setcandamage(1);

	while (!flag(str_complete_flag))
	{
		self waittill("damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weaponname);

		if (issubstr(weaponname, "slipgun") && !flag("sq_ball_picked_up"))
		{
			n_count++;

			if (n_count >= n_end_limit)
			{
				self notify("sq_sliquified");

				if (isdefined(self.t_pickup))
					self.t_pickup delete();

				flag_set(str_complete_flag);
			}
			else if (n_count == 1)
				level notify("ssp1_ball_first_sliquified");
			else if (n_count == 5)
				level notify("ssp1_ball_sliquified_2");
		}
	}
}

init_2()
{
	flag_init("ssp2_maxis_keep_going_said");
	flag_init("ssp2_maxis_reincarnate_said");
	flag_init("ssp2_corpses_in_place");
	flag_init("ssp2_resurrection_done");
	flag_init("ssp2_statue_complete");
	maps\mp\zombies\_zm_spawner::add_custom_zombie_spawn_logic(::ssp_2_zombie_death_check);
	declare_sidequest_stage("sq_2", "ssp_2", ::init_stage_2, ::stage_logic_2, ::exit_stage_2);
}

stage_logic_2()
{
	level thread ssp2_advance_dragon();
	corpse_room_watcher();
	stage_completed("sq_2", "ssp_2");
}

ssp_2_zombie_death_check()
{
	self waittill("death");

	if (!isdefined(self))
		return;

	t_corpse_room = getent("corpse_room_trigger", "targetname");

	if (self istouching(t_corpse_room))
		level notify("ssp2_corpse_made", 1);
}

corpse_room_watcher()
{
	t_corpse_room = getent("corpse_room_trigger", "targetname");
	n_count = 0;

	while (!flag("ssp2_resurrection_done"))
	{
		level waittill("ssp2_corpse_made", is_in_room);

		if (is_in_room)
			n_count++;
		else
			n_count = 0;

		if (n_count == 1 && !flag("ssp2_maxis_keep_going_said"))
		{
			flag_set("ssp2_maxis_keep_going_said");
			level thread maps\mp\zm_highrise_sq::maxissay("vox_maxi_sidequest_reincar_zombie_0");
		}
		else if (n_count >= 15)
		{
			flag_set("ssp2_corpses_in_place");
			vo_maxis_ssp_complete();
			flag_set("ssp2_resurrection_done");
		}
	}
}