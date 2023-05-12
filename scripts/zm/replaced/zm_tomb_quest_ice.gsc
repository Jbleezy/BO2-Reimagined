#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_quest_ice;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zm_tomb_vo;

ice_puzzle_1_run()
{
    level waittill( "elemental_staff_water_crafted", player );
    flag_set( "staff_water_zm_upgrade_unlocked" );
}

ice_puzzle_1_init()
{
    ice_tiles_randomize();
    a_ceiling_tile_brushes = getentarray( "ice_ceiling_tile", "script_noteworthy" );
    level.unsolved_tiles = a_ceiling_tile_brushes;

    a_ice_ternary_digit_brushes = getentarray( "ice_chamber_digit", "targetname" );

    foreach ( digit in a_ice_ternary_digit_brushes )
    {
        digit ghost();
        digit notsolid();
    }
}