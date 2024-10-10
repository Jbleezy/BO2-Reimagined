#include maps\mp\zombies\_zm_craftables;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\_demo;

choose_open_craftable(player)
{
	self endon("kill_choose_open_craftable");
	n_playernum = player getentitynumber();
	self.b_open_craftable_checking_input = 1;
	b_got_input = 1;
	hinttexthudelem = newclienthudelem(player);
	hinttexthudelem.alignx = "center";
	hinttexthudelem.aligny = "middle";
	hinttexthudelem.horzalign = "center";
	hinttexthudelem.vertalign = "bottom";
	hinttexthudelem.y = -100;

	if (player issplitscreen())
	{
		hinttexthudelem.y = -50;
	}

	hinttexthudelem.foreground = 1;
	hinttexthudelem.hidewheninmenu = 1;
	hinttexthudelem.font = "default";
	hinttexthudelem.fontscale = 1.0;
	hinttexthudelem.alpha = 1;
	hinttexthudelem.color = (1, 1, 1);
	hinttexthudelem settext(&"ZM_CRAFTABLES_CHANGE_BUILD");

	if (!isdefined(self.opencraftablehudelem))
	{
		self.opencraftablehudelem = [];
	}

	self.opencraftablehudelem[n_playernum] = hinttexthudelem;

	if (self.n_open_craftable_choice < 0)
	{
		self.n_open_craftable_choice = self.a_uts_open_craftables_available.size - 1;
		self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
		self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
		self.playertrigger[n_playernum] sethintstring(self.hint_string);
	}

	while (isdefined(self.playertrigger[n_playernum]) && !self.crafted)
	{
		if (!player isTouching(self.playertrigger[n_playernum]) || !player is_player_looking_at(self.playertrigger[n_playernum].origin, 0.76) || player isSprinting() || player isThrowingGrenade())
		{
			self.opencraftablehudelem[n_playernum].alpha = 0;
			wait 0.05;
			continue;
		}

		self.opencraftablehudelem[n_playernum].alpha = 1;

		if (player actionslotonebuttonpressed())
		{
			self.n_open_craftable_choice++;
			b_got_input = 1;
		}
		else if (player actionslottwobuttonpressed())
		{
			self.n_open_craftable_choice--;
			b_got_input = 1;
		}

		if (self.n_open_craftable_choice >= self.a_uts_open_craftables_available.size)
		{
			self.n_open_craftable_choice = 0;
		}
		else if (self.n_open_craftable_choice < 0)
		{
			self.n_open_craftable_choice = self.a_uts_open_craftables_available.size - 1;
		}

		if (b_got_input)
		{
			self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
			self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
			self.playertrigger[n_playernum] sethintstring(self.hint_string);
			b_got_input = 0;
		}

		wait 0.05;
	}

	self.b_open_craftable_checking_input = 0;
	self.opencraftablehudelem[n_playernum] destroy();
	self.opencraftablehudelem[n_playernum] = undefined;
}

craftable_use_hold_think_internal(player)
{
	wait 0.01;

	if (!isdefined(self))
	{
		self notify("craft_failed");

		if (isdefined(player.craftableaudio))
		{
			player.craftableaudio delete();
			player.craftableaudio = undefined;
		}

		return;
	}

	if (!isdefined(self.usetime))
	{
		self.usetime = int(3000);
	}

	self.craft_time = self.usetime;
	self.craft_start_time = gettime();
	craft_time = self.craft_time;
	craft_start_time = self.craft_start_time;
	player disable_player_move_states(1);
	player increment_is_drinking();
	orgweapon = player getcurrentweapon();
	player giveweapon("zombie_builder_zm");
	player switchtoweapon("zombie_builder_zm");
	self.stub.craftablespawn craftable_set_piece_crafting(player.current_craftable_piece);
	player thread player_progress_bar(craft_start_time, craft_time);

	if (isdefined(level.craftable_craft_custom_func))
	{
		player thread [[level.craftable_craft_custom_func]](self.stub);
	}

	while (isdefined(self) && player player_continue_crafting(self.stub.craftablespawn) && gettime() - self.craft_start_time < self.craft_time)
	{
		wait 0.05;
	}

	player notify("craftable_progress_end");

	if (player hasWeapon(orgweapon))
	{
		player switchToWeapon(orgweapon);
	}
	else
	{
		player maps\mp\zombies\_zm_weapons::switch_back_primary_weapon(orgweapon);
	}

	player takeweapon("zombie_builder_zm");

	if (isdefined(player.is_drinking) && player.is_drinking)
	{
		player decrement_is_drinking();
	}

	player enable_player_move_states();

	if (isdefined(self) && player player_continue_crafting(self.stub.craftablespawn) && gettime() - self.craft_start_time >= self.craft_time)
	{
		self.stub.craftablespawn craftable_clear_piece_crafting(player.current_craftable_piece);
		self notify("craft_succeed");
	}
	else
	{
		if (isdefined(player.craftableaudio))
		{
			player.craftableaudio delete();
			player.craftableaudio = undefined;
		}

		self.stub.craftablespawn craftable_clear_piece_crafting(player.current_craftable_piece);
		self notify("craft_failed");
	}
}

player_progress_bar_update(start_time, craft_time)
{
	self endon("entering_last_stand");
	self endon("death");
	self endon("disconnect");
	self endon("craftable_progress_end");

	self.usebar updatebar(0.01, 1000 / craft_time);

	while (isdefined(self) && gettime() - start_time < craft_time)
	{
		wait 0.05;
	}
}

update_open_table_status()
{
	thread update_open_table_status_actual();
}

update_open_table_status_actual()
{
	wait 0.05; // wait for .crafted to be set

	b_open_craftables_remaining = 0;

	foreach (uts_craftable in level.a_uts_craftables)
	{
		if (is_true(uts_craftable.craftablestub.is_open_table) && !is_true(uts_craftable.crafted) && uts_craftable.craftablespawn.craftable_name != "open_table" && uts_craftable.craftablespawn craftable_can_use_shared_piece())
		{
			b_open_craftables_remaining++;
		}
	}

	if (!b_open_craftables_remaining)
	{
		foreach (uts_craftable in level.a_uts_craftables)
		{
			if (uts_craftable.craftablespawn.craftable_name == "open_table")
			{
				thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(uts_craftable);
			}
		}
	}
}

onbeginuseuts(player)
{
	if (isdefined(self.craftablestub.onbeginuse))
	{
		self [[self.craftablestub.onbeginuse]](player);
	}

	if (isdefined(player) && !isdefined(player.craftableaudio))
	{
		player.craftableaudio = spawn("script_origin", player.origin);
		player.craftableaudio playloopsound("zmb_buildable_loop");
	}
}