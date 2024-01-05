#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
	init_dvars();
}

init_dvars()
{
	setdvar("ui_gametype_obj", "");
	setdvar("ui_gametype_pro", 0);
	setdvar("ui_round_number", 0);
}