#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps/mp/zombies/_zm_weapon_locker;

main()
{
	if ( !isDefined( level.weapon_locker_map ) )
	{
		level.weapon_locker_map = level.script;
	}
	level.weapon_locker_online = 0;
	weapon_lockers = getstructarray( "weapons_locker", "targetname" );
	array_thread( weapon_lockers, ::triggerweaponslockerwatch );
}