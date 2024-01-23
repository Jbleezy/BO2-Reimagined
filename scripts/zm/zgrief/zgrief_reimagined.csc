#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\gametypes\zgrief::onprecachegametype, scripts\zm\replaced\zgrief::onprecachegametype);

	enemy_powerup_hud();
}

enemy_powerup_hud()
{
	registerclientfield("toplayer", "powerup_instant_kill_enemy", 1, 2, "int", undefined, 0, 1);
	registerclientfield("toplayer", "powerup_double_points_enemy", 1, 2, "int", undefined, 0, 1);

	setupclientfieldcodecallbacks("toplayer", 1, "powerup_instant_kill_enemy");
	setupclientfieldcodecallbacks("toplayer", 1, "powerup_double_points_enemy");
}