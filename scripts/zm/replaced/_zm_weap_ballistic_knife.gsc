#include maps\mp\zombies\_zm_weap_ballistic_knife;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

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
		return;
	}

	if (isDefined(endpos))
	{
		retrievable_model = spawn("script_model", endpos);
		retrievable_model setmodel("t5_weapon_ballistic_knife_blade_retrieve");
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