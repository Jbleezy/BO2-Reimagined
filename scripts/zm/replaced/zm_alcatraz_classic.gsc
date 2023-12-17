#include maps\mp\zm_alcatraz_classic;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\replaced\_zm_afterlife;

give_afterlife()
{
	onplayerconnect_callback(scripts\zm\replaced\_zm_afterlife::init_player);
	flag_wait("initial_players_connected");
	wait 0.5;
	start_pos = 1;
	players = getplayers();

	foreach (player in players)
	{
		if (isDefined(player.afterlife) && !player.afterlife)
		{
			player thread fake_kill_player(start_pos);
			start_pos++;
		}
	}
}