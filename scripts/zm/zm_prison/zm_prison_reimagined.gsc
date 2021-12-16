#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts/zm/replaced/_zm_ai_brutus;

main()
{
	replaceFunc(maps/mp/zombies/_zm_ai_brutus::brutus_health_increases, scripts/zm/replaced/_zm_ai_brutus::brutus_health_increases);
}