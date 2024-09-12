#include maps\mp\zm_buried_sq_ts;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_sidequests;

ts_sign_damage_watch()
{
	level endon("sq_sign_damaged");
	self ts_sign_deactivate();

	while (true)
	{
		self waittill("damage", n_damage, e_attacker, v_direction, v_point, str_type, str_tag, str_model, str_part, str_weapon);

		if (ts_is_bowie_knife(str_weapon) || ts_is_galvaknuckles(str_weapon))
		{
			self thread ts_sign_activate();

			ts_sign_check_all_activated(e_attacker, self);
		}
	}
}

ts_sign_check_all_activated(e_attacker, m_last_touched)
{
	a_signs = getentarray("sq_tunnel_sign", "targetname");
	a_signs_active = [];

	foreach (m_sign in a_signs)
	{
		if (m_sign.ts_sign_activated)
		{
			a_signs_active[a_signs_active.size] = m_sign;
		}
	}

	if (a_signs_active.size == a_signs.size)
	{
		level.m_sq_start_sign = m_last_touched;
		level.e_sq_sign_attacker = e_attacker;
		level notify("sq_sign_damaged");
	}
}

ts_is_bowie_knife(str_weapon)
{
	if (str_weapon == "knife_ballistic_bowie_zm" || str_weapon == "knife_ballistic_bowie_upgraded_zm" || issubstr(str_weapon, "bowie_knife_zm"))
	{
		return true;
	}

	return false;
}

ts_is_galvaknuckles(str_weapon)
{
	if (scripts\zm\_zm_reimagined::is_tazer_weapon(str_weapon))
	{
		return true;
	}

	return false;
}