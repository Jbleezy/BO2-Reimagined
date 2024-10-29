#include maps\mp\zombies\_zm_zonemgr;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_zm_gametype;

create_spawner_list(zkeys)
{
	level.zombie_spawn_locations = [];
	level.inert_locations = [];
	level.enemy_dog_locations = [];
	level.zombie_screecher_locations = [];
	level.zombie_avogadro_locations = [];
	level.quad_locations = [];
	level.zombie_leaper_locations = [];
	level.zombie_astro_locations = [];
	level.zombie_brutus_locations = [];
	level.zombie_mechz_locations = [];
	level.zombie_napalm_locations = [];

	for (z = 0; z < zkeys.size; z++)
	{
		zone = level.zones[zkeys[z]];

		if (zone.is_enabled && zone.is_active && zone.is_spawning_allowed)
		{
			for (i = 0; i < zone.spawn_locations.size; i++)
			{
				if (zone.spawn_locations[i].is_enabled)
				{
					level.zombie_spawn_locations[level.zombie_spawn_locations.size] = zone.spawn_locations[i];
				}
			}

			for (x = 0; x < zone.inert_locations.size; x++)
			{
				if (zone.inert_locations[x].is_enabled)
				{
					level.inert_locations[level.inert_locations.size] = zone.inert_locations[x];
				}
			}

			for (x = 0; x < zone.dog_locations.size; x++)
			{
				if (zone.dog_locations[x].is_enabled)
				{
					level.enemy_dog_locations[level.enemy_dog_locations.size] = zone.dog_locations[x];
				}
			}

			for (x = 0; x < zone.avogadro_locations.size; x++)
			{
				if (zone.avogadro_locations[x].is_enabled)
				{
					level.zombie_avogadro_locations[level.zombie_avogadro_locations.size] = zone.avogadro_locations[x];
				}
			}

			for (x = 0; x < zone.quad_locations.size; x++)
			{
				if (zone.quad_locations[x].is_enabled)
				{
					level.quad_locations[level.quad_locations.size] = zone.quad_locations[x];
				}
			}

			for (x = 0; x < zone.leaper_locations.size; x++)
			{
				if (zone.leaper_locations[x].is_enabled)
				{
					level.zombie_leaper_locations[level.zombie_leaper_locations.size] = zone.leaper_locations[x];
				}
			}

			for (x = 0; x < zone.astro_locations.size; x++)
			{
				if (zone.astro_locations[x].is_enabled)
				{
					level.zombie_astro_locations[level.zombie_astro_locations.size] = zone.astro_locations[x];
				}
			}

			for (x = 0; x < zone.napalm_locations.size; x++)
			{
				if (zone.napalm_locations[x].is_enabled)
				{
					level.zombie_napalm_locations[level.zombie_napalm_locations.size] = zone.napalm_locations[x];
				}
			}

			for (x = 0; x < zone.brutus_locations.size; x++)
			{
				if (zone.brutus_locations[x].is_enabled)
				{
					level.zombie_brutus_locations[level.zombie_brutus_locations.size] = zone.brutus_locations[x];
				}
			}

			for (x = 0; x < zone.mechz_locations.size; x++)
			{
				if (zone.mechz_locations[x].is_enabled)
				{
					level.zombie_mechz_locations[level.zombie_mechz_locations.size] = zone.mechz_locations[x];
				}
			}
		}

		if (zone.is_enabled && zone.is_spawning_allowed)
		{
			for (x = 0; x < zone.screecher_locations.size; x++)
			{
				if (zone.screecher_locations[x].is_enabled)
				{
					level.zombie_screecher_locations[level.zombie_screecher_locations.size] = zone.screecher_locations[x];
				}
			}
		}
	}
}