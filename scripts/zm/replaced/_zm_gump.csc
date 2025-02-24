#include clientscripts\mp\zombies\_zm_gump;
#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

watch_spectation_player(lcn, gump_trigs)
{
	spectatecolor = (0, 0, 0);
	followed = playerbeingspectated(lcn);

	for (;;)
	{
		wait 0.01;
		new_followed = playerbeingspectated(lcn);

		if (followed != new_followed)
		{
			followed = new_followed;
			sethidegumpalpha(lcn, spectatecolor);
			self find_new_gump(gump_trigs, lcn, followed);
		}
	}
}

demo_monitor(gump_trigs)
{
	if (!level.isdemoplaying)
	{
		return;
	}

	test_ent = spawn(0, (0, 0, 0), "script_model");
	test_ent setmodel("tag_origin");
	test_ent hide();
	spectatecolor = (0, 0, 0);
	localclientnum = 0;
	level.gump_view_index_camera_intermission = 100;
	level.gump_view_index_camera_movie = 101;
	level.gump_view_index_camera_edit = 102;
	level.gump_view_index_camera_dolly = 103;
	prev_gump_info = spawnstruct();
	prev_gump_info.gump = "";
	prev_gump_info.view = -1;
	prev_gump_info thread gump_demo_jump_listener();
	curr_gump_info = spawnstruct();
	curr_gump_info.gump = "";
	curr_gump_info.view = -1;

	while (true)
	{
		curr_gump_info get_gump_info(localclientnum, test_ent, gump_trigs);

		if (prev_gump_info.gump != curr_gump_info.gump)
		{
			thread load_gump_for_player(localclientnum, curr_gump_info.gump);

			if (prev_gump_info.view != curr_gump_info.view || level.gump_view_index_camera_intermission == curr_gump_info.view)
			{
				sethidegumpalpha(localclientnum, spectatecolor);
			}
		}

		prev_gump_info.gump = curr_gump_info.gump;
		prev_gump_info.view = curr_gump_info.view;
		wait 0.01;
	}
}