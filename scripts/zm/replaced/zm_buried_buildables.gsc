#include maps\mp\zm_buried_buildables;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_buildables_pooled;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_unitrigger;

watch_cell_open_close( door )
{
	level.cell_open = 0;

	while ( true )
	{
		level waittill( "cell_open" );

		level.cell_open = 1;

		level waittill( "cell_close" );

		level.cell_open = 0;
	}
}