#include maps\mp\zombies\_zm_clone;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

spawn_player_clone( player, origin = player.origin, forceweapon, forcemodel )
{
    primaryweapons = player getweaponslistprimaries();

    if ( isdefined( forceweapon ) )
        weapon = forceweapon;
    else if ( primaryweapons.size )
        weapon = primaryweapons[0];
    else
        weapon = player getcurrentweapon();

    weaponmodel = getweaponmodel( weapon );
    spawner = getent( "fake_player_spawner", "targetname" );

    if ( isdefined( spawner ) )
    {
        while ( getfreeactorcount() < 1 )
        {
            wait 0.05;
        }

        clone = spawner spawnactor();
        clone.origin = origin;
        clone.isactor = 1;
    }
    else
    {
        clone = spawn( "script_model", origin );
        clone.isactor = 0;
    }

    if ( isdefined( forcemodel ) )
        clone setmodel( forcemodel );
    else
    {
        clone setmodel( self.model );

        if ( isdefined( player.headmodel ) )
        {
            clone.headmodel = player.headmodel;
            clone attach( clone.headmodel, "", 1 );
        }
    }

    if ( weaponmodel != "" && weaponmodel != "none" )
        clone attach( weaponmodel, "tag_weapon_right" );

    clone.team = player.team;
    clone.is_inert = 1;
    clone.zombie_move_speed = "walk";
    clone.script_noteworthy = "corpse_clone";
    clone.actor_damage_func = ::clone_damage_func;
    return clone;
}