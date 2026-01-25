#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc(maps\mp\zm_nuked::survival_init, scripts\zm\replaced\zm_nuked::survival_init);
	replaceFunc(maps\mp\zm_nuked::precache_team_characters, scripts\zm\replaced\zm_nuked::precache_team_characters);
	replaceFunc(maps\mp\zm_nuked::give_team_characters, scripts\zm\replaced\zm_nuked::give_team_characters);
	replaceFunc(maps\mp\zm_nuked::moon_rocket_follow_path, scripts\zm\replaced\zm_nuked::moon_rocket_follow_path);
	replaceFunc(maps\mp\zm_nuked::sndgameend, scripts\zm\replaced\zm_nuked::sndgameend);
	replaceFunc(maps\mp\zm_nuked_gamemodes::init, scripts\zm\replaced\zm_nuked_gamemodes::init);
	replaceFunc(maps\mp\zm_nuked_standard::main, scripts\zm\replaced\zm_nuked_standard::main);
	replaceFunc(maps\mp\zm_nuked_perks::init_nuked_perks, scripts\zm\replaced\zm_nuked_perks::init_nuked_perks);
	replaceFunc(maps\mp\zm_nuked_perks::perks_from_the_sky, scripts\zm\replaced\zm_nuked_perks::perks_from_the_sky);

	level._effect["dog_phase_trail"] = loadfx("maps/zombie/fx_zombie_tesla_bolt_secondary");
	level._effect["dog_phasing"] = loadfx("maps/zombie/fx_zmb_avog_phasing");

	maps\_explosive_dart::init();
}

init()
{
	level.mixed_rounds_enabled = 1;

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::nuked_special_weapon_magicbox_check;

	if (is_encounter())
	{
		maps\mp\zombies\_zm_ai_dogs::init();
		sndswitchannouncervox("richtofen");
	}

	level thread increase_dog_health();
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

increase_dog_health()
{
	flag_wait("start_zombie_round_logic");

	level.dog_health = 1600;
}