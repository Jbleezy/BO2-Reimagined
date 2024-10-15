#include maps\mp\zombies\_zm_challenges;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_score;

#using_animtree("fxanim_props_dlc4");

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

			if (isdefined(player.intermission) && player.intermission || is_melee_weapon(current_weapon) || is_placeable_mine(current_weapon) || is_equipment_that_blocks_purchase(current_weapon) || current_weapon == "none" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || player isthrowinggrenade() || player in_revive_trigger() || player isswitchingweapons() || player.is_drinking > 0)
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
			self.stub.hint_string = &"";
			self sethintstring(self.stub.hint_string);
			level thread open_box(player, self.stub);
		}
	}
}