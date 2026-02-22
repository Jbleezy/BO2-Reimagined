#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;
#include clientscripts\mp\_audio;

main()
{
	replaceFunc(clientscripts\mp\gametypes\zgrief::onprecachegametype, scripts\zm\replaced\zgrief::onprecachegametype);
	replaceFunc(clientscripts\mp\gametypes\zgrief::premain, scripts\zm\replaced\zgrief::premain);
	replaceFunc(clientscripts\mp\gametypes\zmeat::main, clientscripts\mp\gametypes\zgrief::main);

	if (getdvar("g_gametype") == "zturned")
	{
		level._effect["zombie_blood"] = loadfx("maps/zombie_tomb/fx_tomb_pwr_up_zmb_blood");
		level._effect["zombie_blood_1st"] = loadfx("maps/zombie_tomb/fx_zm_blood_overlay_pclouds");
	}

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

	level thread turned_spawn_protection_start_think();
	level thread turned_spawn_protection_stop_think();
	level thread turned_spawn_protection_start_and_stop_think();
}

turned_spawn_protection_start_think()
{
	while (1)
	{
		level waittill("turned_spawn_protection_start");

		player = getlocalplayers()[0];

		player.turned_zombie_spawn_protection_fx = playviewmodelfx(0, level._effect["zombie_blood_1st"], "tag_camera");

		playsound(0, "zmb_zombieblood_start", (0, 0, 0));

		playloopat("zmb_zombieblood_loop", (0, 0, 0));
	}
}

turned_spawn_protection_stop_think()
{
	while (1)
	{
		level waittill("turned_spawn_protection_stop");

		player = getlocalplayers()[0];

		if (isdefined(player.turned_zombie_spawn_protection_fx))
		{
			deletefx(0, player.turned_zombie_spawn_protection_fx);
		}

		playsound(0, "zmb_zombieblood_stop", (0, 0, 0));

		stoploopat("zmb_zombieblood_loop", (0, 0, 0));
	}
}

turned_spawn_protection_start_and_stop_think()
{
	while (1)
	{
		level waittill("turned_spawn_protection_start_and_stop");

		playsound(0, "zmb_zombieblood_start", (0, 0, 0));

		playsound(0, "zmb_zombieblood_stop", (0, 0, 0));
	}
}