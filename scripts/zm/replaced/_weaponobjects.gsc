#include maps\mp\gametypes_zm\_weaponobjects;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\_ballistic_knife;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_damagefeedback;
#include maps\mp\gametypes_zm\_globallogic_audio;

watchusetrigger(trigger, callback, playersoundonuse, npcsoundonuse)
{
	self endon("delete");
	self endon("hacked");

	while (true)
	{
		trigger waittill("trigger", player);

		if (!isalive(player))
		{
			continue;
		}

		if (isdefined(trigger.triggerteam) && player.pers["team"] != trigger.triggerteam)
		{
			continue;
		}

		if (isdefined(trigger.triggerteamignore) && player.team == trigger.triggerteamignore)
		{
			continue;
		}

		if (isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}

		grenade = player.throwinggrenade;
		isequipment = isweaponequipment(player getcurrentweapon());

		if (isdefined(isequipment) && isequipment)
		{
			grenade = 0;
		}

		if (player usebuttonpressed() && !grenade && !player meleebuttonpressed())
		{
			if (isdefined(playersoundonuse))
			{
				player playlocalsound(playersoundonuse);
			}

			if (isdefined(npcsoundonuse))
			{
				player playsound(npcsoundonuse);
			}

			self thread [[callback]](player);
		}
	}
}