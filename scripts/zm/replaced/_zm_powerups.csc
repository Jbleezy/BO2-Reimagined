#include clientscripts\mp\zombies\_zm_powerups;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
	add_zombie_powerup("insta_kill", "powerup_instant_kill");
	add_zombie_powerup("double_points", "powerup_double_points");
	add_zombie_powerup("fire_sale", "powerup_fire_sale");
	add_zombie_powerup("bonfire_sale", "powerup_bon_fire");
	add_zombie_powerup("minigun", "powerup_mini_gun");
	add_zombie_powerup("tesla", "powerup_tesla");
	add_zombie_powerup("insta_kill_ug", "powerup_instant_kill_ug", 5000);
	add_zombie_powerup("nuke");
	add_zombie_powerup("full_ammo");
	add_zombie_powerup("carpenter");
	add_zombie_powerup("free_perk");
	add_zombie_powerup("random_weapon");
	add_zombie_powerup("bonus_points_player");
	add_zombie_powerup("bonus_points_team");
	add_zombie_powerup("lose_points_team");
	add_zombie_powerup("lose_perk");
	add_zombie_powerup("empty_clip");
	level thread set_clientfield_code_callbacks();

	if (!is_true(level.createfx_enabled))
	{
		level._effect["powerup_on"] = loadfx("misc/fx_zombie_powerup_on");
		level._effect["powerup_on_solo"] = loadfx("misc/fx_zombie_powerup_solo_on");
		level._effect["powerup_on_caution"] = loadfx("misc/fx_zombie_powerup_on_red");
	}

	if (is_true(level.using_zombie_powerups))
	{
		level._effect["powerup_on_red"] = loadfx("misc/fx_zombie_powerup_on_red");
	}

	registerclientfield("scriptmover", "powerup_fx", 1000, 3, "int", ::powerup_fx_callback);
}