#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\gametypes\zgrief::onprecachegametype, scripts\zm\replaced\zgrief::onprecachegametype);
	replaceFunc(clientscripts\mp\gametypes\zgrief::premain, scripts\zm\replaced\zgrief::premain);
	replaceFunc(clientscripts\mp\gametypes\zmeat::main, clientscripts\mp\gametypes\zgrief::main);

	register_clientfields();
}

init()
{
	if (level.scr_zm_ui_gametype == "zturned")
	{
		turned_init();
	}
}

register_clientfields()
{
	registerclientfield("toplayer", "meat_stink", 1, 1, "int", ::meat_stink_cb, 0, 1);
	registerclientfield("toplayer", "meat_glow", 1, 1, "int", ::meat_glow_cb, 0, 1);

	registerclientfield("toplayer", "powerup_instant_kill_enemy", 1, 2, "int", undefined, 0, 1);
	registerclientfield("toplayer", "powerup_double_points_enemy", 1, 2, "int", undefined, 0, 1);

	setupclientfieldcodecallbacks("toplayer", 1, "powerup_instant_kill_enemy");
	setupclientfieldcodecallbacks("toplayer", 1, "powerup_double_points_enemy");
}

turned_init()
{
	clientscripts\mp\zombies\_zm_turned::main();
	clientscripts\mp\zombies\_zm_turned::init();
}