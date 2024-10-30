#include clientscripts\mp\zm_transit_classic;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\zombies\_zm_ai_screecher;
#include clientscripts\mp\zombies\_zm_ai_avogadro;
#include clientscripts\mp\zm_transit_buildables;
#include clientscripts\mp\_visionset_mgr;

sidequest_complete_pyramid_watch()
{
	level thread maxis_sidequest_complete_pyramid_watch();
	level thread richtofen_sidequest_complete_pyramid_watch();
}

maxis_sidequest_complete_pyramid_watch()
{
	electric_struct = getstruct("sq_common_tower_fx", "targetname");

	while (true)
	{
		event = level waittill_any_return8("sqm_zsd", "sqm_zsf", "sqm_zsb", "sqm_zsbd", "sqm_zsbt", "sqm_zsh", "sqm_zsp", "sqm_zsc");

		zone_origin = strtok(event, "_")[1];
		level thread sidequest_complete_fx_triangle_runner("maxis", zone_origin, electric_struct);
	}
}

richtofen_sidequest_complete_pyramid_watch()
{
	electric_struct = getstruct("sq_common_tower_fx", "targetname");

	while (true)
	{
		event = level waittill_any_return8("sqr_zsd", "sqr_zsf", "sqr_zsb", "sqr_zsbd", "sqr_zsbt", "sqr_zsh", "sqr_zsp", "sqr_zsc");

		zone_origin = strtok(event, "_")[1];
		level thread sidequest_complete_fx_triangle_runner("richtofen", zone_origin, electric_struct);
	}
}