#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc(maps\mp\zm_nuked::give_team_characters, scripts\zm\replaced\zm_nuked::give_team_characters);
	replaceFunc(maps\mp\zm_nuked::moon_rocket_follow_path, scripts\zm\replaced\zm_nuked::moon_rocket_follow_path);
	replaceFunc(maps\mp\zm_nuked::sndgameend, scripts\zm\replaced\zm_nuked::sndgameend);
	replaceFunc(maps\mp\zm_nuked_gamemodes::init, scripts\zm\replaced\zm_nuked_gamemodes::init);
	replaceFunc(maps\mp\zm_nuked_standard::main, scripts\zm\replaced\zm_nuked_standard::main);
	replaceFunc(maps\mp\zm_nuked_perks::init_nuked_perks, scripts\zm\replaced\zm_nuked_perks::init_nuked_perks);
	replaceFunc(maps\mp\zm_nuked_perks::perks_from_the_sky, scripts\zm\replaced\zm_nuked_perks::perks_from_the_sky);

	maps\_explosive_dart::init();
}

init()
{
	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::nuked_special_weapon_magicbox_check;

	if (is_gametype_active("zgrief"))
	{
		sndswitchannouncervox("richtofen");
	}
}

zombie_init_done()
{
	self.meleedamage = 50;
	self.allowpain = 0;

	if (isDefined(self.script_parameters) && self.script_parameters == "crater")
	{
		self thread maps\mp\zm_nuked::zombie_crater_locomotion();
	}

	self setphysparams(15, 0, 48);
}

nuked_special_weapon_magicbox_check(weapon)
{
	return 1;
}