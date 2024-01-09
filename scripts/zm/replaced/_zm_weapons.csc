#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
	spawn_list = [];
	spawnable_weapon_spawns = getstructarray("weapon_upgrade", "targetname");
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("bowie_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("sickle_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("tazer_upgrade", "targetname"), 1, 0);
	spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("buildable_wallbuy", "targetname"), 1, 0);

	if (!level.headshots_only)
		spawnable_weapon_spawns = arraycombine(spawnable_weapon_spawns, getstructarray("claymore_purchase", "targetname"), 1, 0);

	location = level.scr_zm_map_start_location;

	if ((location == "default" || location == "") && isdefined(level.default_start_location))
		location = level.default_start_location;

	match_string = level.scr_zm_ui_gametype + "_" + location;
	match_string_plus_space = " " + match_string;

	for (i = 0; i < spawnable_weapon_spawns.size; i++)
	{
		spawnable_weapon = spawnable_weapon_spawns[i];

		if (isdefined(spawnable_weapon.zombie_weapon_upgrade) && spawnable_weapon.zombie_weapon_upgrade == "sticky_grenade_zm" && is_true(level.headshots_only))
			continue;

		if (!isdefined(spawnable_weapon.script_noteworthy) || spawnable_weapon.script_noteworthy == "")
		{
			spawn_list[spawn_list.size] = spawnable_weapon;
			continue;
		}

		matches = strtok(spawnable_weapon.script_noteworthy, ",");

		for (j = 0; j < matches.size; j++)
		{
			if (matches[j] == match_string || matches[j] == match_string_plus_space)
				spawn_list[spawn_list.size] = spawnable_weapon;
		}
	}

	level._active_wallbuys = [];

	for (i = 0; i < spawn_list.size; i++)
	{
		spawn_list[i].script_label = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;
		level._active_wallbuys[spawn_list[i].script_label] = spawn_list[i];
		numbits = 2;

		if (isdefined(level._wallbuy_override_num_bits))
			numbits = level._wallbuy_override_num_bits;

		registerclientfield("world", spawn_list[i].script_label, 1, numbits, "int", ::wallbuy_callback, 0);
		target_struct = getstruct(spawn_list[i].target, "targetname");

		if (spawn_list[i].targetname == "buildable_wallbuy")
		{
			bits = 4;

			if (isdefined(level.buildable_wallbuy_weapons))
				bits = getminbitcountfornum(level.buildable_wallbuy_weapons.size + 1);

			registerclientfield("world", spawn_list[i].script_label + "_idx", 12000, bits, "int", ::wallbuy_callback_idx, 0);
		}
	}

	onplayerconnect_callback(::wallbuy_player_connect);
}

wallbuy_player_connect(localclientnum)
{
	keys = getarraykeys(level._active_wallbuys);

	if (isdefined(level.createfx_enabled) && level.createfx_enabled)
		return;

	for (i = 0; i < keys.size; i++)
	{
		wallbuy = level._active_wallbuys[keys[i]];

		if (isdefined(wallbuy.script_string) && wallbuy.script_string == "bus_buyable_weapon1")
		{
			continue;
		}

		fx = level._effect["m14_zm_fx"];

		if (wallbuy.targetname == "buildable_wallbuy")
			fx = level._effect["dynamic_wallbuy_fx"];
		else if (isdefined(level._effect[wallbuy.zombie_weapon_upgrade + "_fx"]))
			fx = level._effect[wallbuy.zombie_weapon_upgrade + "_fx"];

		wallbuy.fx[localclientnum] = playfx(localclientnum, fx, wallbuy.origin, anglestoforward(wallbuy.angles), anglestoup(wallbuy.angles), 0.1);
		target_struct = getstruct(wallbuy.target, "targetname");

		if (wallbuy.targetname == "buildable_wallbuy")
			continue;

		target_model = spawn_weapon_model(localclientnum, wallbuy.zombie_weapon_upgrade, target_struct.model, target_struct.origin, target_struct.angles);
		target_model hide();
		target_model.parent_struct = target_struct;

		target_model offset_model(wallbuy.zombie_weapon_upgrade);

		wallbuy.models[localclientnum] = target_model;
	}
}

wallbuy_callback_idx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	basefield = getsubstr(fieldname, 0, fieldname.size - 4);
	struct = level._active_wallbuys[basefield];

	if (newval == 0)
	{
		if (isdefined(struct.models[localclientnum]))
			struct.models[localclientnum] hide();
	}
	else if (newval > 0)
	{
		weaponname = level.buildable_wallbuy_weapons[newval - 1];

		if (!isdefined(struct.models))
			struct.models = [];

		if (!isdefined(struct.models[localclientnum]))
		{
			target_struct = getstruct(struct.target, "targetname");
			model = undefined;

			if (isdefined(level.buildable_wallbuy_weapon_models[weaponname]))
				model = level.buildable_wallbuy_weapon_models[weaponname];

			angles = target_struct.angles;

			if (isdefined(level.buildable_wallbuy_weapon_angles[weaponname]))
			{
				switch (level.buildable_wallbuy_weapon_angles[weaponname])
				{
					case 90:
						angles = vectortoangles(anglestoright(angles));
						break;

					case 180:
						angles = vectortoangles(anglestoforward(angles) * -1);
						break;

					case 270:
						angles = vectortoangles(anglestoright(angles) * -1);
						break;
				}
			}

			target_model = spawn_weapon_model(localclientnum, weaponname, model, target_struct.origin, angles);
			target_model hide();
			target_model.parent_struct = target_struct;

			target_model offset_model(weaponname);

			struct.models[localclientnum] = target_model;

			if (isdefined(struct.fx[localclientnum]))
			{
				stopfx(localclientnum, struct.fx[localclientnum]);
				struct.fx[localclientnum] = undefined;
			}

			fx = level._effect["m14_zm_fx"];

			if (isdefined(level._effect[weaponname + "_fx"]))
				fx = level._effect[weaponname + "_fx"];

			struct.fx[localclientnum] = playfx(localclientnum, fx, struct.origin, anglestoforward(struct.angles), anglestoup(struct.angles), 0.1);
			level notify("wallbuy_updated");
		}
	}
}

offset_model(weaponname)
{
	model_offset = (0, 0, 0);

	if (weaponname == "saritch_zm")
	{
		model_offset = (7, 0, 0);
	}
	else if (weaponname == "insas_zm")
	{
		model_offset = (3, 0, 1);
	}
	else if (weaponname == "vector_zm")
	{
		model_offset = (7, 0, 3);
	}

	self.parent_struct.origin += (anglestoforward(self.parent_struct.angles) * model_offset[0]) + (anglestoright(self.parent_struct.angles) * model_offset[1]) + (anglestoup(self.parent_struct.angles) * model_offset[2]);
}