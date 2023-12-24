#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	if ( !isdefined( level.ballistic_knife_autorecover ) )
		level.ballistic_knife_autorecover = 1;

	if ( isdefined( level._uses_retrievable_ballisitic_knives ) && level._uses_retrievable_ballisitic_knives == 1 )
	{
		precachemodel( "t6_wpn_ballistic_knife_projectile" );
		precachemodel( "t6_wpn_ballistic_knife_blade_retrieve" );
	}
}

on_spawn(watcher, player)
{
	player endon("death");
	player endon("disconnect");
	player endon("zmb_lost_knife");
	level endon("game_ended");

	is_upgraded = player maps\mp\zombies\_zm_melee_weapon::has_upgraded_ballistic_knife();

	self waittill("stationary", endpos, normal, angles, attacker, prey, bone);

	if (is_upgraded && isDefined(prey) && isplayer(prey) && prey.team == player.team && prey maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		prey.revived_by_weapon = watcher.weapon;
		return;
	}

	if (isDefined(level.object_touching_lava) && self [[level.object_touching_lava]]())
	{
		return;
	}

	if (isDefined(endpos))
	{
		retrievable_model = spawn("script_model", endpos);
		retrievable_model setmodel("t6_wpn_ballistic_knife_blade_retrieve");
		retrievable_model setowner(player);
		retrievable_model.owner = player;
		retrievable_model.angles = angles;
		retrievable_model.name = watcher.weapon;
		isfriendly = 0;

		if (isDefined(prey))
		{
			if (isplayer(prey))
			{
				isfriendly = 1;
			}
			else if (isai(prey) && player.team == prey.team)
			{
				isfriendly = 1;
			}

			if (isfriendly)
			{
				retrievable_model physicslaunch(normal, (randomint(10), randomint(10), randomint(10)));
				normal = (0, 0, 1);
			}
			else
			{
				retrievable_model linkto(prey, bone);
				retrievable_model thread force_drop_knives_to_ground_on_death(player, prey);
			}
		}

		watcher.objectarray[watcher.objectarray.size] = retrievable_model;
		retrievable_model thread drop_knives_to_ground(player);

		if (isfriendly)
		{
			player notify("ballistic_knife_stationary", retrievable_model, normal);
		}
		else
		{
			player notify("ballistic_knife_stationary", retrievable_model, normal, prey);
		}
	}
}

watch_use_trigger(trigger, model, callback, weapon, playersoundonuse, npcsoundonuse)
{
	self endon("death");
	self endon("delete");
	level endon("game_ended");
	autorecover = is_true(level.ballistic_knife_autorecover);

	while (1)
	{
		trigger waittill("trigger", player);

		if (!isalive(player))
		{
			continue;
		}

		if (isDefined(trigger.triggerteam) && player.team != trigger.triggerteam)
		{
			continue;
		}

		if (isDefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}

		if (isDefined(trigger.owner) && player != trigger.owner)
		{
			continue;
		}

		if (player getcurrentweapon() == weapon && player getweaponammostock(weapon) >= weaponmaxammo(weapon))
		{
			continue;
		}

		if (!autorecover && !is_true(trigger.force_pickup))
		{
			if (player.throwinggrenade || player meleebuttonpressed())
			{
				continue;
			}
		}

		if (isDefined(playersoundonuse))
		{
			player playlocalsound(playersoundonuse);
		}

		if (isDefined(npcsoundonuse))
		{
			player playsound(npcsoundonuse);
		}

		player thread [[callback]](weapon, model, trigger);
		return;
	}
}

pick_up( weapon, model, trigger )
{
	if (!self hasweapon(weapon))
	{
		foreach (primary in self getweaponslistprimaries())
		{
			if (issubstr(primary, "knife_ballistic"))
			{
				weapon = primary;
				break;
			}
		}
	}

	current_weapon = self getcurrentweapon();

	if ( current_weapon != weapon )
	{
		clip_ammo = self getweaponammoclip( weapon );

		if ( !clip_ammo )
			self setweaponammoclip( weapon, 1 );
		else
		{
			new_ammo_stock = self getweaponammostock( weapon ) + 1;
			self setweaponammostock( weapon, new_ammo_stock );
		}
	}
	else
	{
		new_ammo_stock = self getweaponammostock( weapon ) + 1;
		self setweaponammostock( weapon, new_ammo_stock );
	}

	self maps\mp\zombies\_zm_stats::increment_client_stat( "ballistic_knives_pickedup" );
	self maps\mp\zombies\_zm_stats::increment_player_stat( "ballistic_knives_pickedup" );
	model destroy_ent();
	trigger destroy_ent();
}