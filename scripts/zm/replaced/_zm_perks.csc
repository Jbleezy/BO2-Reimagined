#include clientscripts\mp\zombies\_zm_perks;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_fx;
#include clientscripts\mp\_filter;

perks_register_clientfield()
{
	bits = 1;

	if (clientscripts\mp\zombies\_zm_weapons::is_weapon_included("emp_grenade_zm"))
	{
		bits = 2;
	}

	if (is_true(level.zombiemode_using_additionalprimaryweapon_perk))
	{
		registerclientfield("toplayer", "perk_additional_primary_weapon", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_deadshot_perk))
	{
		registerclientfield("toplayer", "perk_dead_shot", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_doubletap_perk))
	{
		registerclientfield("toplayer", "perk_double_tap", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_juggernaut_perk))
	{
		registerclientfield("toplayer", "perk_juggernaut", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_marathon_perk))
	{
		registerclientfield("toplayer", "perk_marathon", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_revive_perk))
	{
		registerclientfield("toplayer", "perk_quick_revive", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_sleightofhand_perk))
	{
		registerclientfield("toplayer", "perk_sleight_of_hand", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_tombstone_perk))
	{
		registerclientfield("toplayer", "perk_tombstone", 1, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (is_true(level.zombiemode_using_perk_intro_fx))
	{
		registerclientfield("scriptmover", "clientfield_perk_intro_fx", 1000, 1, "int", ::perk_meteor_fx, 0);
	}

	if (is_true(level.zombiemode_using_chugabud_perk))
	{
		registerclientfield("toplayer", "perk_chugabud", 1000, bits, "int", level.zombies_global_perk_client_callback, 0, 1);
	}

	if (level._custom_perks.size > 0)
	{
		a_keys = getarraykeys(level._custom_perks);

		for (i = 0; i < a_keys.size; i++)
		{
			if (isdefined(level._custom_perks[a_keys[i]].clientfield_register))
			{
				level [[level._custom_perks[a_keys[i]].clientfield_register]]();
			}
		}
	}

	level thread perk_init_code_callbacks();
}