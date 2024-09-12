#include maps\mp\zm_alcatraz_utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;

#using_animtree("fxanim_props");

blundergat_upgrade_station()
{
	t_upgrade = getent("blundergat_upgrade", "targetname");
	t_upgrade.equipname = "packasplat";
	t_upgrade.cost = t_upgrade scripts\zm\_zm_reimagined::get_equipment_cost();
	t_upgrade sethintstring(&"ZM_PRISON_CONVERT_START", t_upgrade.cost);
	t_upgrade usetriggerrequirelookat();
	waittill_crafted("packasplat");
	m_converter = t_upgrade.m_upgrade_machine;
	v_angles = m_converter gettagangles("tag_origin");
	v_weapon_origin_offset = anglestoforward(v_angles) * 1 + anglestoright(v_angles) * 10 + anglestoup(v_angles) * 1.75;
	v_weapon_angles_offset = (0, 90, -90);
	m_converter.v_weapon_origin = m_converter gettagorigin("tag_origin") + v_weapon_origin_offset;
	m_converter.v_weapon_angles = v_angles + v_weapon_angles_offset;
	m_converter useanimtree(#animtree);
	m_converter.fxanims["close"] = %fxanim_zom_al_packasplat_start_anim;
	m_converter.fxanims["inject"] = %fxanim_zom_al_packasplat_idle_anim;
	m_converter.fxanims["open"] = %fxanim_zom_al_packasplat_end_anim;
	m_converter.n_start_time = getanimlength(m_converter.fxanims["close"]);
	m_converter.n_idle_time = getanimlength(m_converter.fxanims["inject"]);
	m_converter.n_end_time = getanimlength(m_converter.fxanims["open"]);

	while (true)
	{
		t_upgrade thread blundergat_change_hintstring(&"ZM_PRISON_CONVERT_START", t_upgrade.cost);

		t_upgrade waittill("trigger", player);

		if (isdefined(level.custom_craftable_validation))
		{
			valid = t_upgrade [[level.custom_craftable_validation]](player);

			if (!valid)
			{
				continue;
			}
		}

		if (player.score < t_upgrade.cost)
		{
			self play_sound_on_ent("no_purchase");
			player maps\mp\zombies\_zm_audio::create_and_play_dialog("general", "no_money_weapon");
			continue;
		}

		str_valid_weapon = player getcurrentweapon();

		if (str_valid_weapon == "blundergat_zm" || str_valid_weapon == "blundergat_upgraded_zm")
		{
			player maps\mp\zombies\_zm_score::minus_to_player_score(t_upgrade.cost);
			t_upgrade play_sound_on_ent("purchase");

			player thread maps\mp\zombies\_zm_perks::do_knuckle_crack();
			player.is_pack_splatting = 1;
			t_upgrade setinvisibletoall();

			options = player get_pack_a_punch_weapon_options(str_valid_weapon);
			m_converter.worldgun = spawn_weapon_model(str_valid_weapon, undefined, m_converter.v_weapon_origin, m_converter.v_weapon_angles, options);
			m_converter blundergat_upgrade_station_inject(str_valid_weapon, options);
			t_upgrade thread blundergat_change_hintstring(&"ZM_PRISON_CONVERT_PICKUP");

			if (isdefined(player))
			{
				t_upgrade setvisibletoplayer(player);
				t_upgrade thread wait_for_player_to_take(player, str_valid_weapon);
			}

			t_upgrade thread wait_for_timeout();
			t_upgrade waittill_any("acid_timeout", "acid_taken");

			t_upgrade setinvisibletoall();

			if (isdefined(player))
			{
				player.is_pack_splatting = undefined;
			}

			m_converter.worldgun delete();
			wait 0.5;
			t_upgrade setvisibletoall();
		}
		else
		{
			t_upgrade thread blundergat_change_hintstring(&"ZM_PRISON_MISSING_BLUNDERGAT");
			wait 2;
		}
	}
}

blundergat_change_hintstring(hint_string, hint_string_cost)
{
	self notify("new_change_hint_string");
	self endon("new_change_hint_string");

	while (isdefined(self.is_locked) && self.is_locked)
	{
		wait 0.05;
	}

	if (isDefined(hint_string_cost))
	{
		self sethintstring(hint_string, hint_string_cost);
	}
	else
	{
		self sethintstring(hint_string);
	}

	wait 0.05;

	if (isDefined(hint_string_cost))
	{
		self sethintstring(hint_string, hint_string_cost);
	}
	else
	{
		self sethintstring(hint_string);
	}
}

blundergat_upgrade_station_inject(str_weapon_model, options)
{
	wait 0.5;
	self playsound("zmb_acidgat_upgrade_machine");
	self setanim(self.fxanims["close"], 1, 0, 1);
	wait(self.n_start_time);

	for (i = 0; i < 3; i++)
	{
		self setanim(self.fxanims["inject"], 1, 0, 1);
		wait(self.n_idle_time);
	}

	self.worldgun delete();

	if (str_weapon_model == "blundergat_zm")
	{
		self.worldgun = spawn_weapon_model("blundersplat_zm", undefined, self.v_weapon_origin, self.v_weapon_angles, options);
	}
	else
	{
		self.worldgun = spawn_weapon_model("blundersplat_upgraded_zm", undefined, self.v_weapon_origin, self.v_weapon_angles, options);
	}

	self setanim(self.fxanims["open"], 1, 0, 1);
	wait(self.n_end_time);
	wait 0.5;
}

wait_for_player_to_take(player, str_valid_weapon)
{
	self endon("acid_timeout");
	player endon("disconnect");

	while (true)
	{
		self waittill("trigger", trigger_player);

		if (isdefined(level.custom_craftable_validation))
		{
			valid = self [[level.custom_craftable_validation]](player);

			if (!valid)
			{
				continue;
			}
		}

		if (trigger_player == player)
		{
			current_weapon = player getcurrentweapon();

			if (is_player_valid(player) && !(player.is_drinking > 0) && !is_melee_weapon(current_weapon) && !is_placeable_mine(current_weapon) && !is_equipment(current_weapon) && level.revive_tool != current_weapon && "none" != current_weapon && !player hacker_active())
			{
				self notify("acid_taken");
				player notify("acid_taken");
				weapon_limit = get_player_weapon_limit(player);
				primaries = player getweaponslistprimaries();

				if (isdefined(primaries) && primaries.size >= weapon_limit)
				{
					player takeweapon(current_weapon);
				}

				str_new_weapon = undefined;

				if (str_valid_weapon == "blundergat_zm")
				{
					str_new_weapon = "blundersplat_zm";
				}
				else
				{
					str_new_weapon = "blundersplat_upgraded_zm";
				}

				if (player hasweapon("blundersplat_zm"))
				{
					player givemaxammo("blundersplat_zm");
				}
				else if (player hasweapon("blundersplat_upgraded_zm"))
				{
					player givemaxammo("blundersplat_upgraded_zm");
				}
				else
				{
					player giveweapon(str_new_weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(str_new_weapon));
					player switchtoweapon(str_new_weapon);
					player givestartammo(str_new_weapon);
				}

				player thread do_player_general_vox("general", "player_recieves_blundersplat");
				player notify("player_obtained_acidgat");
				player thread player_lost_blundersplat_watcher();
				return;
			}
		}
	}
}

alcatraz_audio_get_mod_type_override(impact, mod, weapon, zombie, instakill, dist, player)
{
	close_dist = 4096;
	med_dist = 15376;
	far_dist = 75625;
	a_str_mod = [];

	if (isdefined(zombie.my_soul_catcher))
	{
		if (!(isdefined(zombie.my_soul_catcher.wolf_kill_cooldown) && zombie.my_soul_catcher.wolf_kill_cooldown))
		{
			if (!(isdefined(player.soul_catcher_cooldown) && player.soul_catcher_cooldown))
			{
				if (isdefined(zombie.my_soul_catcher.souls_received) && zombie.my_soul_catcher.souls_received > 0)
				{
					a_str_mod[a_str_mod.size] = "wolf_kill";
				}
				else if (isdefined(zombie.my_soul_catcher.souls_received) && zombie.my_soul_catcher.souls_received == 0)
				{
					if (!(isdefined(level.wolf_encounter_vo_played) && level.wolf_encounter_vo_played))
					{
						if (level.soul_catchers_charged == 0)
						{
							zombie.my_soul_catcher thread maps\mp\zm_alcatraz_weap_quest::first_wolf_encounter_vo();
						}
					}
				}
			}
		}
	}

	if (weapon == "blundergat_zm" || weapon == "blundergat_upgraded_zm")
	{
		a_str_mod[a_str_mod.size] = "blundergat";
	}

	if (isdefined(zombie.damageweapon) && (zombie.damageweapon == "blundersplat_explosive_dart_zm" || zombie.damageweapon == "blundersplat_explosive_dart_upgraded_zm"))
	{
		a_str_mod[a_str_mod.size] = "acidgat";
	}

	if (isdefined(zombie.damageweapon) && zombie.damageweapon == "bouncing_tomahawk_zm")
	{
		a_str_mod[a_str_mod.size] = "retriever";
	}

	if (isdefined(zombie.damageweapon) && zombie.damageweapon == "upgraded_tomahawk_zm")
	{
		a_str_mod[a_str_mod.size] = "redeemer";
	}

	if (weapon == "minigun_alcatraz_zm" || weapon == "minigun_alcatraz_upgraded_zm")
	{
		a_str_mod[a_str_mod.size] = "death_machine";
	}

	if (is_headshot(weapon, impact, mod) && dist >= far_dist)
	{
		a_str_mod[a_str_mod.size] = "headshot";
	}

	if (is_explosive_damage(mod) && weapon != "ray_gun_zm" && weapon != "ray_gun_upgraded_zm" && !(isdefined(zombie.is_on_fire) && zombie.is_on_fire))
	{
		if (!isinarray(a_str_mod, "retriever") && !isinarray(a_str_mod, "redeemer"))
		{
			if (!instakill)
			{
				a_str_mod[a_str_mod.size] = "explosive";
			}
			else
			{
				a_str_mod[a_str_mod.size] = "weapon_instakill";
			}
		}
	}

	if (weapon == "ray_gun_zm" || weapon == "ray_gun_upgraded_zm")
	{
		if (dist > far_dist)
		{
			if (!instakill)
			{
				a_str_mod[a_str_mod.size] = "raygun";
			}
			else
			{
				a_str_mod[a_str_mod.size] = "weapon_instakill";
			}
		}
	}

	if (instakill)
	{
		if (mod == "MOD_MELEE")
		{
			a_str_mod[a_str_mod.size] = "melee_instakill";
		}
		else
		{
			a_str_mod[a_str_mod.size] = "weapon_instakill";
		}
	}

	if (mod != "MOD_MELEE" && !zombie.has_legs)
	{
		a_str_mod[a_str_mod.size] = "crawler";
	}

	if (mod != "MOD_BURNED" && dist < close_dist)
	{
		a_str_mod[a_str_mod.size] = "closekill";
	}

	if (a_str_mod.size == 0)
	{
		str_mod_final = "default";
	}
	else if (a_str_mod.size == 1)
	{
		str_mod_final = a_str_mod[0];
	}
	else
	{
		for (i = 0; i < a_str_mod.size; i++)
		{
			if (cointoss())
			{
				str_mod_final = a_str_mod[i];
			}
		}

		str_mod_final = a_str_mod[randomint(a_str_mod.size)];
	}

	if (str_mod_final == "wolf_kill")
	{
		player thread wolf_kill_cooldown_watcher(zombie.my_soul_catcher);
	}

	return str_mod_final;
}

check_solo_status()
{
	level.is_forever_solo_game = 0;
}