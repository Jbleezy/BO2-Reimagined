#include maps\mp\zm_nuked_standard;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_magicbox;

main()
{
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects("nuked");
	maps\mp\zombies\_zm_game_module::set_current_game_module(level.game_module_standard_index);
	level.enemy_location_override_func = ::enemy_location_override;
	nuked_treasure_chest_init();
	flag_wait("initial_blackscreen_passed");
	flag_set("power_on");
}