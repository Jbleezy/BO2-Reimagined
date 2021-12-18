#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/_zm_equip_subwoofer;

main()
{
	precachemodel( "collision_wall_128x128x10_standard" );

	//replaceFunc(maps/mp/zombies/_zm_equip_subwoofer::startsubwooferdecay, scripts/zm/replaced/_zm_equip_subwoofer::startsubwooferdecay);
}

init()
{
	add_jug_collision();
}

add_jug_collision()
{
	origin = (-664, 1050, 8);
	angles = ( 0, 0, 0 );
	collision = spawn( "script_model", origin + anglesToUp(angles) * 64 );
	collision.angles = angles;
	collision setmodel( "collision_wall_128x128x10_standard" );
}