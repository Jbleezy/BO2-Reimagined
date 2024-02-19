#include maps\mp\zombies\_zm_perk_random;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_perks;

machine_selector()
{
	while (true)
	{
		level waittill("random_perk_moving");

		machines = getentarray("random_perk_machine", "targetname");

		if (machines.size == 1)
		{
			new_machine = machines[0];
			new_machine thread machine_think();
			continue;
		}

		do
			new_machine = machines[randomint(machines.size)];

		while (new_machine == level.random_perk_start_machine);

		level.random_perk_start_machine = new_machine;
		new_machine thread machine_think();
	}
}

trigger_visible_to_player(player)
{
	self setinvisibletoplayer(player);
	visible = 1;

	if (isdefined(self.stub.trigger_target.machine_user))
	{
		if (player != self.stub.trigger_target.machine_user)
			visible = 0;
	}
	else if (!player can_buy_perk())
		visible = 0;

	if (!visible)
		return false;

	self setvisibletoplayer(player);
	return true;
}

can_buy_perk()
{
	if (isdefined(self.is_drinking) && self.is_drinking > 0)
		return false;

	current_weapon = self getcurrentweapon();

	if (is_equipment_that_blocks_purchase(current_weapon))
		return false;

	if (self in_revive_trigger())
		return false;

	if (current_weapon == "none")
		return false;

	return true;
}

wunderfizzstub_update_prompt(player)
{
	self setcursorhint("HINT_NOICON");

	if (!self trigger_visible_to_player(player))
		return false;

	self.hint_parm1 = undefined;

	if (isdefined(self.stub.trigger_target.is_locked) && self.stub.trigger_target.is_locked)
	{
		self.hint_string = &"ZM_TOMB_RPU";
		return false;
	}
	else if (self.stub.trigger_target.is_current_ball_location)
	{
		if (isdefined(self.stub.trigger_target.machine_user))
		{
			if (isdefined(self.stub.trigger_target.grab_perk_hint) && self.stub.trigger_target.grab_perk_hint)
			{
				n_purchase_limit = player get_player_perk_purchase_limit();

				if (player.num_perks >= n_purchase_limit)
				{
					self.hint_string = &"ZM_TOMB_RPT";
					return false;
				}
				else
				{
					self.hint_string = &"ZM_TOMB_RPP";
					return true;
				}
			}
			else
				return false;
		}
		else
		{
			n_purchase_limit = player get_player_perk_purchase_limit();

			if (player.num_perks >= n_purchase_limit)
			{
				self.hint_string = &"ZM_TOMB_RPT";
				return false;
			}
			else
			{
				self.hint_string = &"ZM_TOMB_RPB";
				self.hint_parm1 = level._random_zombie_perk_cost;
				return true;
			}
		}
	}
	else
	{
		self.hint_string = &"ZM_TOMB_RPE";
		return false;
	}
}