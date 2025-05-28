#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\zombies\_zm_laststand;

inits()
{
	a_walls = getentarray("chamber_wall", "script_noteworthy");

	foreach (e_wall in a_walls)
	{
		e_wall.down_origin = e_wall.origin;
		e_wall.up_origin = (e_wall.origin[0], e_wall.origin[1], e_wall.origin[2] + 1000);
	}

	level.n_chamber_wall_active = 0;
	flag_wait("start_zombie_round_logic");

	foreach (e_wall in a_walls)
	{
		e_wall moveto(e_wall.up_origin, 0.05);
		e_wall connectpaths();
	}
}