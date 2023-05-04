#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_weapon_locker;

triggerweaponslockerisvalidweaponpromptupdate( player, weaponname )
{
    retrievingweapon = player wl_has_stored_weapondata();

    if ( !retrievingweapon )
    {
        weaponname = player get_nonalternate_weapon( weaponname );

        if ( !triggerweaponslockerisvalidweapon( weaponname ) )
            self sethintstring( &"ZOMBIE_WEAPON_LOCKER_DENY" );
        else
            self sethintstring( &"ZOMBIE_WEAPON_LOCKER_STORE" );
    }
    else
    {
        weapondata = player wl_get_stored_weapondata();

        if ( isdefined( level.remap_weapon_locker_weapons ) )
            weapondata = remap_weapon( weapondata, level.remap_weapon_locker_weapons );

        weapontogive = weapondata["name"];
        primaries = player getweaponslistprimaries();
        maxweapons = get_player_weapon_limit( player );
        weaponname = player get_nonalternate_weapon( weaponname );

        if ( isdefined( primaries ) && primaries.size >= maxweapons || weapontogive == weaponname )
        {
            if ( !triggerweaponslockerisvalidweapon( weaponname ) )
            {
                self sethintstring( &"ZOMBIE_WEAPON_LOCKER_DENY" );
                return;
            }
        }

        self sethintstring( &"ZOMBIE_WEAPON_LOCKER_GRAB" );
    }

    self thread show_current_weapon(player);
}

show_current_weapon(player)
{
	stub = self.stub;

	if (!isDefined(stub.weaponlockerhud))
	{
		stub.weaponlockerhud = [];
	}

	num = player getentitynumber();

    displayname = "None";
    if (player wl_has_stored_weapondata())
    {
        weapondata = player wl_get_stored_weapondata();

        if ( isdefined( level.remap_weapon_locker_weapons ) )
            weapondata = remap_weapon( weapondata, level.remap_weapon_locker_weapons );

        displayname = getweapondisplayname( weapondata["name"] );
    }

	if (isDefined(stub.weaponlockerhud[num]))
	{
		stub.weaponlockerhud[num] settext( displayname );
		return;
	}

	hud = newclienthudelem( player );
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.horzalign = "center";
	hud.vertalign = "bottom";
	hud.y = -100;
	hud.foreground = 1;
	hud.hidewheninmenu = 1;
	hud.font = "default";
	hud.fontscale = 1;
	hud.alpha = 1;
	hud.color = ( 1, 1, 1 );
	hud.label = &"Placed Weapon: ";
	hud settext( displayname );
	stub.weaponlockerhud[num] = hud;

	while ( isDefined( self ) )
	{
		if (!player isTouching(self) || player isSprinting() || player isThrowingGrenade())
		{
			hud.alpha = 0;
			wait 0.05;
			continue;
		}

		hud.alpha = 1;

		wait 0.05;
	}

	stub.weaponlockerhud[num] destroy();
	stub.weaponlockerhud[num] = undefined;
}