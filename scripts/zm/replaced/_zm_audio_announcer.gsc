#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

playleaderdialogonplayer(dialog, team, waittime)
{
	self endon("disconnect");

	if (level.allowzmbannouncer)
	{
		if (!isDefined(game["zmbdialog"][dialog]))
		{
			return;
		}
	}

	if (isDefined(self.zmbdialoggroups[dialog]))
	{
		group = dialog;
		dialog = self.zmbdialoggroups[group];
		self.zmbdialoggroups[group] = undefined;
	}

	if (level.allowzmbannouncer)
	{
		alias = game["zmbdialog"]["prefix"] + "_" + game["zmbdialog"][dialog];
		variant = self getleaderdialogvariant(alias);

		if (!isDefined(variant))
		{
			full_alias = alias;
		}
		else
		{
			full_alias = alias + "_" + variant;
		}

		self playlocalsound(full_alias);
	}
}

getleaderdialogvariant(alias)
{
	if (!isdefined(alias))
	{
		return;
	}

	if (!isdefined(level.announcer_dialog))
	{
		level.announcer_dialog = [];
		level.announcer_dialog_available = [];
	}

	num_variants = maps\mp\zombies\_zm_spawner::get_number_variants(alias);

	if (num_variants <= 0)
	{
		return undefined;
	}

	for (i = 0; i < num_variants; i++)
	{
		level.announcer_dialog[alias][i] = i;
	}

	level.announcer_dialog_available[alias] = [];

	if (level.announcer_dialog_available[alias].size <= 0)
	{
		level.announcer_dialog_available[alias] = level.announcer_dialog[alias];
	}

	variation = random(level.announcer_dialog_available[alias]);
	arrayremovevalue(level.announcer_dialog_available[alias], variation);
	return variation;
}

init_griefvox(prefix)
{
	postfix = scripts\zm\_zm_reimagined::get_grief_vox_postfix();

	init_gamemodecommonvox(prefix);
	createvox("1_player_down", "1rivdown" + postfix, prefix);
	createvox("2_player_down", "2rivdown" + postfix, prefix);
	createvox("3_player_down", "3rivdown" + postfix, prefix);
	createvox("4_player_down", "4rivdown" + postfix, prefix);
	createvox("grief_restarted", "restart" + postfix, prefix);
	createvox("grief_lost", "lose" + postfix, prefix);
	createvox("grief_won", "win" + postfix, prefix);
	createvox("1_player_left", "1rivup" + postfix, prefix);
	createvox("2_player_left", "2rivup" + postfix, prefix);
	createvox("3_player_left", "3rivup" + postfix, prefix);
	createvox("last_player", "solo" + postfix, prefix);
}