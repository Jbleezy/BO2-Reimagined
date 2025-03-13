#include maps\mp\zombies\_zm_ai_quadrotor;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\_quadrotor;
#include maps\_vehicle;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_laststand;

quadrotor_movementupdate()
{
	level endon("end_game");
	self endon("death");
	self endon("change_state");
	assert(isalive(self));
	a_powerups = [];
	old_goalpos = self.goalpos;
	self.goalpos = self make_sure_goal_is_well_above_ground(self.goalpos);

	if (!self.vehonpath)
	{
		if (isdefined(self.attachedpath))
		{
			self script_delay();
		}
		else if (distancesquared(self.origin, self.goalpos) < 10000 && (self.goalpos[2] > old_goalpos[2] + 10 || self.origin[2] + 10 < self.goalpos[2]))
		{
			self setvehgoalpos(self.goalpos, 1, 2, 0);
			self pathvariableoffset(vectorscale((0, 0, 1), 20.0), 2);
			self waittill_any_or_timeout(4, "near_goal", "force_goal");
		}
		else
		{
			goalpos = self quadrotor_get_closest_node();
			self setvehgoalpos(goalpos, 1, 2, 0);
			self waittill_any_or_timeout(2, "near_goal", "force_goal");
		}
	}

	assert(isalive(self));
	self setvehicleavoidance(1);
	goalfailures = 0;

	while (true)
	{
		self waittill_pathing_done();
		self thread quadrotor_blink_lights();

		if (self.returning_home)
		{
			self setneargoalnotifydist(64);
			self setheliheightlock(0);
			is_valid_exit_path_found = 0;
			quadrotor_table = level.quadrotor_status.pickup_trig.model;
			is_valid_exit_path_found = self setvehgoalpos(quadrotor_table.origin, 1, 2, 1);

			if (is_valid_exit_path_found)
			{
				self notify("attempting_return");
				self waittill_any("near_goal", "force_goal", "reached_end_node", "return_timeout");
				continue;
			}

			self setneargoalnotifydist(8);
			str_zone = level.quadrotor_status.str_zone;

			switch (str_zone)
			{
				case "zone_nml_9":
					exit_path = getvehiclenode("quadrotor_nml_exit_path", "targetname");
					is_valid_exit_path_found = self setvehgoalpos(exit_path.origin, 1, 2, 1);
					break;

				case "zone_bunker_5a":
					if (flag("activate_zone_nml"))
					{
						exit_path = getvehiclenode("quadrotor_bunker_north_exit_path", "targetname");
						is_valid_exit_path_found = self setvehgoalpos(exit_path.origin, 1, 2, 1);
					}
					else
					{

					}

					if (!is_valid_exit_path_found)
					{
						if (flag("activate_zone_bunker_3b"))
						{
							exit_path = getvehiclenode("quadrotor_bunker_west_exit_path", "targetname");
							is_valid_exit_path_found = self setvehgoalpos(exit_path.origin, 1, 2, 1);
						}
						else
						{

						}
					}

					if (!is_valid_exit_path_found)
					{
						if (flag("activate_zone_bunker_4b"))
						{
							exit_path = getvehiclenode("quadrotor_bunker_south_exit_path", "targetname");
							is_valid_exit_path_found = self setvehgoalpos(exit_path.origin, 1, 2, 1);
						}
						else
						{

						}
					}

					break;

				case "zone_village_2":
					break;
			}

			if (is_valid_exit_path_found)
			{
				self waittill_any("near_goal", "force_goal");
				self cancelaimove();
				self clearvehgoalpos();
				self pathvariableoffsetclear();
				self pathfixedoffsetclear();
				self clearlookatent();
				self setvehicleavoidance(0);
				self.drivepath = 1;
				self attachpath(exit_path);
				self pathvariableoffset(vectorscale((1, 1, 1), 8.0), randomintrange(1, 3));
				self drivepath(exit_path);
				wait 1;
				self notify("attempting_return");
			}
			else
			{
				self thread quadrotor_escape_into_air();
			}

			self waittill_any("near_goal", "force_goal", "reached_end_node", "return_timeout");
		}

		if (!isdefined(self.revive_target))
		{
			player = self player_in_last_stand_within_range(500);

			if (isdefined(player))
			{
				self.revive_target = player;
				player.quadrotor_revive = 1;
				vox_line = "vox_maxi_drone_revive_" + randomintrange(0, 5);
				maps\mp\zm_tomb_vo::maxissay(vox_line, self);
			}
		}

		if (isdefined(self.revive_target))
		{
			origin = self.revive_target.origin;
			origin = (origin[0], origin[1], origin[2] + 150);
			z = self getheliheightlockheight(origin);
			origin = (origin[0], origin[1], z);

			if (self setvehgoalpos(origin, 1, 2, 1))
			{
				self waittill_any("near_goal", "force_goal", "reached_end_node");
				level thread watch_for_fail_revive(self);
				wait 1;

				if (isdefined(self.revive_target) && self.revive_target maps\mp\zombies\_zm_laststand::player_is_in_laststand())
				{
					playfxontag(level._effect["staff_charge"], self.revive_target, "tag_origin");
					self.revive_target notify("remote_revive", self.player_owner);
					self.revive_target do_player_general_vox("quadrotor", "rspnd_drone_revive", undefined, 100);
					self.player_owner notify("revived_player_with_quadrotor");
				}

				self.revive_target = undefined;
				self setvehgoalpos(origin, 1);
				wait 1;
				continue;
			}
			else
			{
				player.quadrotor_revive = undefined;
			}

			wait 0.1;
		}

		a_powerups = [];

		if (level.active_powerups.size > 0 && isdefined(self.player_owner))
		{
			a_powerups = get_array_of_closest(self.player_owner.origin, level.active_powerups, undefined, undefined, 500);
		}

		if (a_powerups.size > 0)
		{
			b_got_powerup = 0;

			foreach (powerup in a_powerups)
			{
				if (self setvehgoalpos(powerup.origin, 1, 2, 1))
				{
					self waittill_any("near_goal", "force_goal", "reached_end_node");

					if (isdefined(powerup))
					{
						self.player_owner.ignore_range_powerup = powerup;
						b_got_powerup = 1;
					}

					wait 1;
					break;
				}
			}

			if (b_got_powerup)
			{
				continue;
			}

			wait 0.1;
		}

		a_special_items = getentarray("quad_special_item", "script_noteworthy");

		if (level.n_ee_medallions > 0 && isdefined(self.player_owner))
		{
			e_special_item = getclosest(self.player_owner.origin, a_special_items, 500);

			if (isdefined(e_special_item))
			{
				self setneargoalnotifydist(4);

				if (isdefined(e_special_item.target))
				{
					s_start_pos = getstruct(e_special_item.target, "targetname");
					self setvehgoalpos(s_start_pos.origin, 1, 0, 1);
					self waittill_any("near_goal", "force_goal", "reached_end_node");
				}

				self setvehgoalpos(e_special_item.origin + vectorscale((0, 0, 1), 30.0), 1, 0, 1);
				self waittill_any("near_goal", "force_goal", "reached_end_node");
				wait 1;
				playfx(level._effect["staff_charge"], e_special_item.origin);
				e_special_item hide();
				level.n_ee_medallions--;
				level notify("quadrotor_medallion_found", self);

				if (isdefined(e_special_item.target))
				{
					s_start_pos = getstruct(e_special_item.target, "targetname");
					self setvehgoalpos(s_start_pos.origin, 1, 0, 1);
					self waittill_any("near_goal", "force_goal", "reached_end_node");
				}

				if (level.n_ee_medallions == 0)
				{
					s_mg_spawn = getstruct("mgspawn", "targetname");
					self setvehgoalpos(s_mg_spawn.origin + vectorscale((0, 0, 1), 30.0), 1, 0, 1);
					self waittill_any("near_goal", "force_goal", "reached_end_node");
					wait 1;
					playfx(level._effect["staff_charge"], s_mg_spawn.origin);
					e_special_item playsound("zmb_perks_packa_ready_tomb");
					flag_set("ee_medallions_collected");
				}

				e_special_item delete();
				self setneargoalnotifydist(30);
				self setvehgoalpos(self.origin, 1);
			}
		}

		if (isdefined(level.quadrotor_custom_behavior))
		{
			self [[level.quadrotor_custom_behavior]]();
		}

		goalpos = quadrotor_find_new_position();

		if (self setvehgoalpos(goalpos, 1, 2, 1))
		{
			goalfailures = 0;

			if (isdefined(self.goal_node))
			{
				self.goal_node.quadrotor_claimed = 1;
			}

			if (isdefined(self.enemy) && self vehcansee(self.enemy))
			{
				if (randomint(100) > 50)
				{
					self setlookatent(self.enemy);
				}
			}

			self waittill_any_timeout(12, "near_goal", "force_goal", "reached_end_node");

			if (isdefined(self.enemy) && self vehcansee(self.enemy))
			{
				self setlookatent(self.enemy);
				wait(randomfloatrange(1, 4));
				self clearlookatent();
			}

			if (isdefined(self.goal_node))
			{
				self.goal_node.quadrotor_claimed = undefined;
			}
		}
		else
		{
			goalfailures++;

			if (isdefined(self.goal_node))
			{
				self.goal_node.quadrotor_fails = 1;
			}

			if (goalfailures == 1)
			{
				wait 0.5;
				continue;
			}
			else if (goalfailures == 2)
			{
				goalpos = self.origin;
			}
			else if (goalfailures == 3)
			{
				goalpos = self quadrotor_get_closest_node();
				self setvehgoalpos(goalpos, 1);
				self waittill("near_goal");
			}
			else if (goalfailures > 3)
			{
				self.goalpos = make_sure_goal_is_well_above_ground(goalpos);
			}

			old_goalpos = goalpos;
			offset = (randomfloatrange(-50, 50), randomfloatrange(-50, 50), randomfloatrange(50, 150));
			goalpos = goalpos + offset;
			goalpos = quadrotor_adjust_goal_for_enemy_height(goalpos);

			if (self quadrotor_check_move(goalpos))
			{
				self setvehgoalpos(goalpos, 1);
				self waittill_any("near_goal", "force_goal", "start_vehiclepath");
				wait(randomfloatrange(1, 3));

				if (!self.vehonpath)
				{
					self setvehgoalpos(old_goalpos, 1);
					self waittill_any("near_goal", "force_goal", "start_vehiclepath");
				}
			}

			wait 0.5;
		}
	}
}