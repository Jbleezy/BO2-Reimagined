#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\replaced\zm_nuked_perks;

main()
{
	replaceFunc(maps\mp\zm_nuked_perks::init_nuked_perks, scripts\zm\replaced\zm_nuked_perks::init_nuked_perks);
	replaceFunc(maps\mp\zm_nuked_perks::perks_from_the_sky, scripts\zm\replaced\zm_nuked_perks::perks_from_the_sky);
}

init()
{
    level.zombie_init_done = ::zombie_init_done;
    level.special_weapon_magicbox_check = ::nuked_special_weapon_magicbox_check;
}

zombie_init_done()
{
	self.allowpain = 0;
	if ( isDefined( self.script_parameters ) && self.script_parameters == "crater" )
	{
		self thread maps\mp\zm_nuked::zombie_crater_locomotion();
	}
    self setphysparams( 15, 0, 48 );
}

nuked_special_weapon_magicbox_check(weapon)
{
	return 1;
}