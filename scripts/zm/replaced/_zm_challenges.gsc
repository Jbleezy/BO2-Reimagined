#include maps\mp\zombies\_zm_challenges;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_score;

onplayerspawned()
{
	self endon("disconnect");

	for (;;)
	{
		self waittill("spawned_player");

		foreach (s_stat in level._challenges.a_players[self.characterindex].a_stats)
		{
			if (s_stat.b_medal_awarded && !s_stat.b_reward_claimed)
			{
				foreach (m_board in level.a_m_challenge_boards)
				{
					self setclientfieldtoplayer(s_stat.s_parent.cf_complete, 1);
				}
			}
		}

		foreach (s_stat in level._challenges.s_team.a_stats)
		{
			if (s_stat.b_medal_awarded && s_stat.a_b_player_rewarded[self.entity_num])
			{
				foreach (m_board in level.a_m_challenge_boards)
				{
					self setclientfieldtoplayer(s_stat.s_parent.cf_complete, 1);
				}
			}
		}
	}
}

team_stats_init(n_index)
{
	if (!isdefined(level._challenges.s_team))
	{
		level._challenges.s_team = spawnstruct();
		level._challenges.s_team.a_stats = [];
	}

	s_team_set = level._challenges.s_team;

	foreach (s_challenge in level._challenges.a_stats)
	{
		if (s_challenge.b_team)
		{
			if (!isdefined(s_team_set.a_stats[s_challenge.str_name]))
			{
				s_team_set.a_stats[s_challenge.str_name] = spawnstruct();
			}

			s_stat = s_team_set.a_stats[s_challenge.str_name];
			s_stat.s_parent = s_challenge;
			s_stat.n_value = 0;
			s_stat.b_medal_awarded = 0;
			s_stat.b_reward_claimed = 0;
			s_stat.a_b_player_rewarded = array(0, 0, 0, 0, 0, 0, 0, 0);
			s_stat.str_medal_tag = "j_g_medal";
			s_stat.str_glow_tag = "j_g_glow";
			s_stat.b_display_tag = 1;
		}
	}

	s_team_set.n_completed = 0;
	s_team_set.n_medals_held = 0;
}

stat_reward_available(stat, player)
{
	if (isstring(stat))
	{
		s_stat = get_stat(stat, player);
	}
	else
	{
		s_stat = stat;
	}

	if (!s_stat.b_medal_awarded)
	{
		return false;
	}

	if (s_stat.b_reward_claimed)
	{
		return false;
	}

	if (s_stat.s_parent.b_team && s_stat.a_b_player_rewarded[player.entity_num])
	{
		return false;
	}

	return true;
}

player_has_unclaimed_team_reward()
{
	foreach (s_stat in level._challenges.s_team.a_stats)
	{
		if (s_stat.b_medal_awarded && !s_stat.a_b_player_rewarded[self.entity_num])
		{
			return true;
		}
	}

	return false;
}

get_reward_stat(s_category)
{
	foreach (s_stat in s_category.a_stats)
	{
		if (s_stat.b_medal_awarded && !s_stat.b_reward_claimed)
		{
			if (s_stat.s_parent.b_team && s_stat.a_b_player_rewarded[self.entity_num])
			{
				continue;
			}

			return s_stat;
		}
	}

	return undefined;
}

spawn_reward(player, s_select_stat)
{
	if (isdefined(player))
	{
		player endon("death_or_disconnect");

		if (isdefined(s_select_stat))
		{
			s_category = get_reward_category(player, s_select_stat);

			if (stat_reward_available(s_select_stat, player))
			{
				s_stat = s_select_stat;
			}
		}

		if (!isdefined(s_stat))
		{
			s_category = get_reward_category(player);
			s_stat = player get_reward_stat(s_category);
		}

		if (self [[s_stat.s_parent.fp_give_reward]](player, s_stat))
		{
			if (isdefined(s_stat.s_parent.cf_complete))
			{
				player setclientfieldtoplayer(s_stat.s_parent.cf_complete, 0);
			}

			if (s_stat.s_parent.b_team)
			{
				s_stat.a_b_player_rewarded[player.entity_num] = 1;

				return;
			}

			s_stat.b_reward_claimed = 1;
			s_category.n_medals_held--;
		}
	}
}

#using_animtree("fxanim_props_dlc4");

box_init()
{
	self useanimtree(#animtree);

	self delay_thread(0.75, ::setclientfield, "foot_print_box_glow", 1);
	self delay_thread(1.5, ::setclientfield, "foot_print_box_glow", 0);

	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = self.origin + (0, 0, 0);
	s_unitrigger_stub.angles = self.angles;
	s_unitrigger_stub.radius = 64;
	s_unitrigger_stub.script_length = 64;
	s_unitrigger_stub.script_width = 64;
	s_unitrigger_stub.script_height = 64;
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.hint_string = &"";
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_unitrigger_stub.prompt_and_visibility_func = ::box_prompt_and_visiblity;
	s_unitrigger_stub ent_flag_init("waiting_for_grab");
	s_unitrigger_stub ent_flag_init("reward_timeout");
	s_unitrigger_stub.b_busy = 0;
	s_unitrigger_stub.m_box = self;
	s_unitrigger_stub.b_disable_trigger = 0;

	if (isdefined(self.script_string))
	{
		s_unitrigger_stub.str_location = self.script_string;
	}

	if (isdefined(s_unitrigger_stub.m_box.target))
	{
		s_unitrigger_stub.m_board = getent(s_unitrigger_stub.m_box.target, "targetname");
		s_unitrigger_stub board_init(s_unitrigger_stub.m_board);
	}

	unitrigger_force_per_player_triggers(s_unitrigger_stub, 1);
	level.a_uts_challenge_boxes[level.a_uts_challenge_boxes.size] = s_unitrigger_stub;
	maps\mp\zombies\_zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, ::box_think);
}

update_box_prompt(player)
{
	self endon("kill_trigger");
	player endon("death_or_disconnect");

	str_hint = &"";
	str_old_hint = &"";
	m_board = self.stub.m_board;
	self sethintstring(str_hint);

	if (!is_classic())
	{
		self.cost = 9000;
	}

	while (true)
	{
		s_hint_tag = undefined;
		b_showing_stat = 0;
		self.b_can_open = 0;

		if (self.stub.b_busy)
		{
			if (self.stub ent_flag("waiting_for_grab") && (!isdefined(self.stub.player_using) || self.stub.player_using == player))
			{
				str_hint = &"ZM_TOMB_CH_G";
			}
			else
			{
				str_hint = &"";
			}
		}
		else
		{
			if (is_classic())
			{
				str_hint = &"";
				player.s_lookat_stat = undefined;
				n_closest_dot = 0.996;
				v_eye_origin = player getplayercamerapos();
				v_eye_direction = anglestoforward(player getplayerangles());

				foreach (str_tag, s_tag in m_board.a_s_medal_tags)
				{
					if (!s_tag.s_stat.b_display_tag)
					{
						continue;
					}

					v_tag_origin = s_tag.v_origin;
					v_eye_to_tag = vectornormalize(v_tag_origin - v_eye_origin);
					n_dot = vectordot(v_eye_to_tag, v_eye_direction);

					if (n_dot > n_closest_dot)
					{
						n_closest_dot = n_dot;
						str_hint = s_tag.s_stat.s_parent.str_hint;
						s_hint_tag = s_tag;
						b_showing_stat = 1;
						self.b_can_open = 0;

						if (s_tag.n_character_index == player.characterindex || s_tag.n_character_index == 4)
						{
							player.s_lookat_stat = s_tag.s_stat;

							if (stat_reward_available(s_tag.s_stat, player))
							{
								str_hint = &"ZM_TOMB_CH_S";
								b_showing_stat = 0;
								self.b_can_open = 1;
							}
						}
					}
				}

				if (str_hint == &"")
				{
					if (player player_has_unclaimed_team_reward())
					{
						str_hint = &"ZM_TOMB_CH_O";
						self.b_can_open = 1;
					}
					else
					{
						str_hint = &"ZM_TOMB_CH_V";
					}
				}
			}
			else
			{
				if (player player_has_unclaimed_team_reward())
				{
					str_hint = &"ZM_TOMB_PERK_ONEINCH";
					self.b_can_open = 1;
				}
			}
		}

		if (str_old_hint != str_hint)
		{
			str_old_hint = str_hint;
			self.stub.hint_string = str_hint;

			if (isdefined(s_hint_tag))
			{
				str_name = s_hint_tag.s_stat.s_parent.str_name;
				n_character_index = s_hint_tag.n_character_index;

				if (n_character_index != 4)
				{
					s_player_stat = level._challenges.a_players[n_character_index].a_stats[str_name];
				}
			}

			if (isdefined(self.cost) && self.b_can_open)
			{
				self sethintstring(self.stub.hint_string, self.cost);
			}
			else
			{
				self sethintstring(self.stub.hint_string);
			}
		}

		wait 0.1;
	}
}

box_think()
{
	self endon("kill_trigger");
	s_team = level._challenges.s_team;

	while (true)
	{
		self waittill("trigger", player);

		if (!is_player_valid(player))
		{
			continue;
		}

		if (self.stub.b_busy)
		{
			current_weapon = player getcurrentweapon();

			if (isdefined(player.intermission) && player.intermission || is_placeable_mine(current_weapon) || is_equipment_that_blocks_purchase(current_weapon) || current_weapon == "none" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || player isthrowinggrenade() || player in_revive_trigger() || player isswitchingweapons() || player.is_drinking > 0)
			{
				wait 0.1;
				continue;
			}

			if (self.stub ent_flag("waiting_for_grab"))
			{
				if (!isdefined(self.stub.player_using))
				{
					self.stub.player_using = player;
				}

				if (player == self.stub.player_using)
				{
					self.stub ent_flag_clear("waiting_for_grab");
				}
			}

			wait 0.05;
			continue;
		}

		if (self.b_can_open)
		{
			if (isdefined(self.cost))
			{
				if (player.score < self.cost)
				{
					play_sound_at_pos("no_purchase", self.origin);
					continue;
				}

				player minus_to_player_score(self.cost);
				play_sound_at_pos("purchase", self.origin);
			}

			self.stub.hint_string = &"";
			self sethintstring(self.stub.hint_string);
			level thread open_box(player, self.stub);
		}
	}
}