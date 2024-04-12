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

init_griefvox(prefix)
{
	postfix = "";

	if (level.script == "zm_nuked")
	{
		postfix = "_rich";
	}

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