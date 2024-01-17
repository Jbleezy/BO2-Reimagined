#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	precache_shaders();

	level thread random_map_rotation();
	level thread map_vote();
}

precache_shaders()
{
	precacheshader("menu_zm_popup");
	precacheshader("loadscreen_zm_transit_zclassic_transit");
	precacheshader("loadscreen_zm_highrise_zclassic_rooftop");
	precacheshader("loadscreen_zm_prison_zclassic_prison");
	precacheshader("loadscreen_zm_buried_zclassic_processing");
	precacheshader("loadscreen_zm_tomb_zclassic_tomb");
	precacheshader("loadscreen_zm_transit_zstandard_transit");
	precacheshader("loadscreen_zm_transit_zstandard_farm");
	precacheshader("loadscreen_zm_transit_zstandard_town");
	precacheshader("loadscreen_zm_nuked_zstandard_nuked");
	precacheshader("loadscreen_zm_transit_zgrief_transit");
	precacheshader("loadscreen_zm_transit_zgrief_farm");
	precacheshader("loadscreen_zm_transit_zgrief_town");
	precacheshader("loadscreen_zm_prison_zgrief_cellblock");
	precacheshader("loadscreen_zm_buried_zgrief_street");
	precacheshader("loadscreen_zm_transit_dr_zcleansed_diner");
}

random_map_rotation()
{
	initial_map = 0;

	if (getDvar("sv_mapRotationRandom") == "")
	{
		initial_map = 1;
		setDvar("sv_mapRotationRandom", 1);
	}

	if (!initial_map && getDvar("sv_mapRotationCurrent") != "")
	{
		return;
	}

	rotation_string = getDvar("sv_mapRotation");
	rotation_array = rotation_string_to_array(rotation_string);

	if (rotation_array.size < 2)
	{
		return;
	}

	// randomize maps
	rotation_array = array_randomize(rotation_array);

	// make sure current map isn't first
	// except for initially since map hasn't been played
	if (!initial_map)
	{
		location = get_location_from_rotation(rotation_array[0]);
		mapname = get_mapname_from_rotation(rotation_array[0]);

		if (level.scr_zm_map_start_location == location && level.script == mapname)
		{
			num = randomIntRange(1, rotation_array.size);
			rotation_array = array_swap(rotation_array, 0, num);
		}
	}

	rotation_string = rotation_array_to_string(rotation_array);

	setDvar("sv_mapRotation", rotation_string);
	setDvar("sv_mapRotationCurrent", rotation_string);

	// make initial map random
	if (initial_map)
	{
		exitLevel(0);
	}
}

map_vote()
{
	level waittill("intermission");

	level.map_vote_active = 0;
	rotation_array = array_randomize(rotation_string_to_array(getDvar("sv_mapRotation")));

	if (rotation_array.size >= 3)
	{
		level.map_vote_active = 1;
	}

	level.obj_vote_active = 0;
	obj_array = [];

	if (is_gametype_active("zgrief"))
	{
		obj_array = array_randomize(strTok(getDvar("ui_gametype_obj"), " "));

		if (obj_array.size >= 3)
		{
			level.obj_vote_active = 1;
			arrayRemoveValue(obj_array, level.scr_zm_ui_gametype_obj);
		}
	}

	if (!level.map_vote_active && !level.obj_vote_active)
	{
		return;
	}

	vote_time = level.zombie_vars["zombie_intermission_time"];

	maps = [];
	exclude_locs = [];

	for (i = 0; i < 3; i++)
	{
		maps[i] = [];
	}

	gametype = getSubStr(level.scr_zm_ui_gametype, 1, level.scr_zm_ui_gametype.size);

	maps[1]["rotation_string"] = "exec zm_" + gametype + "_" + level.scr_zm_map_start_location + ".cfg map " + level.script;
	maps[1]["map_name"] = level.script;
	maps[1]["loc_name"] = level.scr_zm_map_start_location;
	maps[1]["gametype_name"] = level.scr_zm_ui_gametype;

	if (level.obj_vote_active)
	{
		maps[1]["obj_name"] = level.scr_zm_ui_gametype_obj;
	}

	exclude_locs[exclude_locs.size] = maps[1]["loc_name"];

	rotation = undefined;

	foreach (rotation in rotation_array)
	{
		if (!isInArray(exclude_locs, get_location_from_rotation(rotation)))
		{
			break;
		}
	}

	maps[0]["rotation_string"] = rotation;
	maps[0]["map_name"] = get_mapname_from_rotation(rotation);
	maps[0]["loc_name"] = get_location_from_rotation(rotation);
	maps[0]["gametype_name"] = "z" + get_gametype_from_rotation(rotation);

	if (level.obj_vote_active)
	{
		maps[0]["obj_name"] = obj_array[0];
	}

	exclude_locs[exclude_locs.size] = maps[0]["loc_name"];

	rotation = undefined;

	foreach (rotation in rotation_array)
	{
		if (!isInArray(exclude_locs, get_location_from_rotation(rotation)))
		{
			break;
		}
	}

	maps[2]["rotation_string"] = rotation;
	maps[2]["map_name"] = get_mapname_from_rotation(rotation);
	maps[2]["loc_name"] = get_location_from_rotation(rotation);
	maps[2]["gametype_name"] = "z" + get_gametype_from_rotation(rotation);

	if (level.obj_vote_active)
	{
		maps[2]["obj_name"] = obj_array[1];
	}

	y_pos = -102.5;

	vote_timer_hud = create_map_vote_timer_hud(0, y_pos, vote_time);

	y_pos += 12.5;

	vote_input_hud = create_map_vote_input_hud(0, y_pos);

	y_pos = 150;

	map_image_hud = [];
	map_image_hud[0] = create_map_image_hud(get_image_for_loc(maps[0]["map_name"], maps[0]["loc_name"], maps[0]["gametype_name"]), -200, y_pos);
	map_image_hud[1] = create_map_image_hud(get_image_for_loc(maps[1]["map_name"], maps[1]["loc_name"], maps[1]["gametype_name"]), 0, y_pos);
	map_image_hud[2] = create_map_image_hud(get_image_for_loc(maps[2]["map_name"], maps[2]["loc_name"], maps[2]["gametype_name"]), 200, y_pos);

	map_name_hud = [];
	map_name_hud[0] = create_map_name_hud(get_name_for_loc(maps[0]["map_name"], maps[0]["loc_name"], maps[0]["gametype_name"]), -200, y_pos);
	map_name_hud[1] = create_map_name_hud(get_name_for_loc(maps[1]["map_name"], maps[1]["loc_name"], maps[1]["gametype_name"]), 0, y_pos);
	map_name_hud[2] = create_map_name_hud(get_name_for_loc(maps[2]["map_name"], maps[2]["loc_name"], maps[2]["gametype_name"]), 200, y_pos);

	y_pos += 20;

	level.map_vote_count_hud = [];
	level.map_vote_count_hud[0] = create_map_vote_count_hud(-200, y_pos);
	level.map_vote_count_hud[1] = create_map_vote_count_hud(0, y_pos);
	level.map_vote_count_hud[2] = create_map_vote_count_hud(200, y_pos);

	level.map_votes = [];
	level.map_votes[0] = 0;
	level.map_votes[1] = 0;
	level.map_votes[2] = 0;

	obj_name_hud = [];
	level.obj_vote_count_hud = [];
	level.obj_votes = [];

	if (level.obj_vote_active)
	{
		y_pos = 207;

		obj_name_hud[0] = create_map_gametype_hud([[level.get_gamemode_display_name_func]](maps[0]["obj_name"]), -200, y_pos);
		obj_name_hud[1] = create_map_gametype_hud([[level.get_gamemode_display_name_func]](maps[1]["obj_name"]), 0, y_pos);
		obj_name_hud[2] = create_map_gametype_hud([[level.get_gamemode_display_name_func]](maps[2]["obj_name"]), 200, y_pos);

		y_pos += 20;

		level.obj_vote_count_hud[0] = create_map_vote_count_hud(-200, y_pos);
		level.obj_vote_count_hud[1] = create_map_vote_count_hud(0, y_pos);
		level.obj_vote_count_hud[2] = create_map_vote_count_hud(200, y_pos);

		level.obj_votes[0] = 0;
		level.obj_votes[1] = 0;
		level.obj_votes[2] = 0;
	}

	array_thread(get_players(), ::player_choose_map);

	wait vote_time;

	map_won_ind = get_map_winner();

	for (i = 0; i < 3; i++)
	{
		if (i != map_won_ind)
		{
			map_image_hud[i].alpha = 0;
			map_name_hud[i].alpha = 0;
			level.map_vote_count_hud[i].alpha = 0;
		}
	}

	if (map_won_ind != 1)
	{
		map_image_hud[map_won_ind] moveOverTime(0.5);
		map_name_hud[map_won_ind] moveOverTime(0.5);
		level.map_vote_count_hud[map_won_ind] moveOverTime(0.5);

		map_image_hud[map_won_ind].x = 0;
		map_name_hud[map_won_ind].x = 0;
		level.map_vote_count_hud[map_won_ind].x = 0;
	}

	players = get_players();

	foreach (player in players)
	{
		player.map_select.hud.alpha = 0;
	}

	if (level.obj_vote_active)
	{
		obj_won_ind =get_obj_winner();

		for (i = 0; i < 3; i++)
		{
			if (i != obj_won_ind)
			{
				obj_name_hud[i].alpha = 0;
				level.obj_vote_count_hud[i].alpha = 0;
			}
		}

		if (obj_won_ind != 1)
		{
			obj_name_hud[obj_won_ind] moveOverTime(0.5);
			level.obj_vote_count_hud[obj_won_ind] moveOverTime(0.5);

			obj_name_hud[obj_won_ind].x = 0;
			level.obj_vote_count_hud[obj_won_ind].x = 0;
		}

		players = get_players();

		foreach (player in players)
		{
			player.obj_select.hud.alpha = 0;
		}

		setDvar("ui_gametype_obj_cur", maps[obj_won_ind]["obj_name"]);
	}

	vote_input_hud.alpha = 0;
	vote_timer_hud.alpha = 0;

	setDvar("sv_mapRotationCurrent", maps[map_won_ind]["rotation_string"]);
}

create_map_image_hud(image, x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.sort = -1;
	hud.alpha = 1;
	hud setShader(image, 175, 85);

	return hud;
}

create_map_name_hud(name, x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.8;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.alpha = 1;
	hud setText(name);

	return hud;
}

create_map_gametype_hud(name, x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.5;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.alpha = 1;
	hud setText(name);

	return hud;
}

create_map_vote_count_hud(x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.2;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.alpha = 1;
	hud setValue(0);

	return hud;
}

create_map_vote_input_hud(x, y)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.2;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.alpha = 1;
	hud setText(&"ZOMBIE_VOTE_HOWTO");

	return hud;
}

create_map_vote_timer_hud(x, y, time)
{
	hud = newHudElem();
	hud.x = x;
	hud.y = y;
	hud.font = "objective";
	hud.fontscale = 1.2;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.alpha = 1;
	hud.label = &"ZOMBIE_HUD_VOTE_TIME";
	hud setTimer(time);

	return hud;
}

create_map_select_hud(x, y)
{
	hud = newClientHudElem(self);
	hud.x = x;
	hud.y = y + 2.5;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.alpha = 1;
	hud setShader("menu_zm_popup", 180, 95);

	return hud;
}

create_obj_select_hud(x, y)
{
	hud = newClientHudElem(self);
	hud.x = x;
	hud.y = y + 2.5;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.alpha = 1;
	hud setShader("menu_zm_popup", 180, 40);

	return hud;
}

player_choose_map()
{
	self endon("disconnect");

	wait 0.1;

	self.sessionstate = "playing"; // must change sessionstate or hud elems don't show
	self setOrigin((0, 0, -10000));

	self.map_select = spawnStruct();
	self.map_select.hud = self create_map_select_hud(0, 150);
	self.map_select.ind = 1;
	self.map_select.selected = 0;
	self.map_select.name = "map";

	if (level.obj_vote_active)
	{
		self.obj_select = spawnStruct();
		self.obj_select.hud = self create_obj_select_hud(0, 215);
		self.obj_select.ind = 1;
		self.obj_select.selected = 0;
		self.obj_select.name = "obj";

		self.obj_select.hud.alpha = 0;
	}

	self notifyonplayercommand("left", "+speed_throw");
	self notifyonplayercommand("left", "+moveleft");
	self notifyonplayercommand("right", "+attack");
	self notifyonplayercommand("right", "+moveright");
	self notifyonplayercommand("select", "+usereload");
	self notifyonplayercommand("select", "+activate");
	self notifyonplayercommand("select", "+gostand");

	self thread left_watcher();
	self thread right_watcher();
	self thread select_watcher();

	level waittill("stop_intermission");

	self.map_select.hud destroy();

	if (level.obj_vote_active)
	{
		self.obj_select.hud destroy();
	}
}

left_watcher()
{
	level endon("stop_intermission");
	self endon("disconnect");

	while (1)
	{
		self waittill("left");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		if (select.ind == 0)
		{
			select.ind = 2;
			select.hud.x += 400;
			continue;
		}

		select.ind--;
		select.hud.x -= 200;
	}
}

right_watcher()
{
	level endon("stop_intermission");
	self endon("disconnect");

	while (1)
	{
		self waittill("right");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		if (select.ind == 2)
		{
			select.ind = 0;
			select.hud.x -= 400;
			continue;
		}

		select.ind++;
		select.hud.x += 200;
	}
}

select_watcher()
{
	level endon("stop_intermission");
	self endon("disconnect");

	while (1)
	{
		self waittill("select");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		if (!select.selected)
		{
			select.selected = 1;
			select.hud.color = (0, 1, 0);

			if (select.name == "map")
			{
				level.map_votes[select.ind]++;
				level.map_vote_count_hud[select.ind] setValue(level.map_votes[select.ind]);

				self.obj_select.hud.alpha = 1;
			}
			else
			{
				level.obj_votes[select.ind]++;
				level.obj_vote_count_hud[select.ind] setValue(level.obj_votes[select.ind]);
			}
		}
	}
}

get_player_select()
{
	if (self.map_select.selected)
	{
		if (level.obj_vote_active)
		{
			if (self.obj_select.selected)
			{
				return undefined;
			}

			return self.obj_select;
		}

		return undefined;
	}

	return self.map_select;
}

get_map_winner()
{
	// if no one voted, stay on current map
	if (level.map_votes[0] == 0 && level.map_votes[1] == 0 && level.map_votes[2] == 0)
	{
		return 1;
	}

	winner_ind = array(0);

	for (i = 1; i < 3; i++)
	{
		if (level.map_votes[i] == level.map_votes[winner_ind[0]])
		{
			winner_ind[winner_ind.size] = i;
		}
		else if (level.map_votes[i] > level.map_votes[winner_ind[0]])
		{
			winner_ind = array(i);
		}
	}

	return random(winner_ind);
}

get_obj_winner()
{
	// if no one voted, stay on current obj
	if (level.obj_votes[0] == 0 && level.obj_votes[1] == 0 && level.obj_votes[2] == 0)
	{
		return 1;
	}

	winner_ind = array(0);

	for (i = 1; i < 3; i++)
	{
		if (level.obj_votes[i] == level.obj_votes[winner_ind[0]])
		{
			winner_ind[winner_ind.size] = i;
		}
		else if (level.obj_votes[i] > level.obj_votes[winner_ind[0]])
		{
			winner_ind = array(i);
		}
	}

	return random(winner_ind);
}

get_name_for_loc(mapname, locname, gametypename)
{
	if (locname == "transit")
	{
		if (gametypename == "zclassic")
		{
			return &"ZMUI_CLASSIC_TRANSIT";
		}
		else
		{
			return &"ZMUI_TRANSIT_STARTLOC";
		}
	}
	else if (locname == "farm")
	{
		return &"ZMUI_FARM";
	}
	else if (locname == "town")
	{
		return &"ZMUI_TOWN";
	}
	else if (locname == "diner")
	{
		return &"ZMUI_DINER";
	}
	else if (locname == "power")
	{
		return &"ZMUI_POWER";
	}
	else if (locname == "tunnel")
	{
		return &"ZMUI_TUNNEL";
	}
	else if (locname == "cornfield")
	{
		return &"ZMUI_CORNFIELD";
	}
	else if (locname == "nuked")
	{
		return &"ZMUI_NUKED_STARTLOC";
	}
	else if (locname == "rooftop")
	{
		return &"ZMUI_CLASSIC_ROOFTOP";
	}
	else if (locname == "prison")
	{
		return &"ZMUI_CLASSIC_PRISON";
	}
	else if (locname == "cellblock")
	{
		return &"ZMUI_CELLBLOCK";
	}
	else if (locname == "docks")
	{
		return &"ZMUI_DOCKS";
	}
	else if (locname == "processing")
	{
		return &"ZMUI_CLASSIC_BURIED";
	}
	else if (locname == "street")
	{
		return &"ZMUI_STREET_LOC";
	}
	else if (locname == "maze")
	{
		return &"ZMUI_MAZE";
	}
	else if (locname == "tomb")
	{
		return &"ZMUI_CLASSIC_TOMB";
	}

	return "";
}

get_image_for_loc(mapname, locname, gametypename)
{
	if (locname == "diner")
	{
		return "loadscreen_zm_transit_dr_zcleansed_diner";
	}
	else if (locname == "power" || locname == "tunnel" || locname == "cornfield")
	{
		return "loadscreen_zm_transit_zstandard_transit";
	}
	else if (locname == "nuked")
	{
		return "loadscreen_zm_nuked_zstandard_nuked";
	}
	else if (locname == "docks")
	{
		return "loadscreen_zm_prison_zgrief_cellblock";
	}
	else if (locname == "maze")
	{
		return "loadscreen_zm_buried_zgrief_street";
	}

	return "loadscreen_" + mapname + "_" + gametypename + "_" + locname;
}

rotation_string_to_array(rotation_string)
{
	rotation_array = [];

	tokens = strTok(rotation_string, " ");

	for (i = 0; i < tokens.size; i += 4)
	{
		rotation_array[rotation_array.size] = tokens[i] + " " + tokens[i+1] + " " + tokens[i+2] + " " + tokens[i+3];
	}

	return rotation_array;
}

rotation_array_to_string(rotation_array)
{
	rotation_string = "";

	for (i = 0; i < rotation_array.size; i++)
	{
		rotation_string += rotation_array[i];

		if (i < (rotation_array.size - 1))
		{
			rotation_string += " ";
		}
	}

	return rotation_string;
}

get_gametype_from_rotation(rotation)
{
	tokens = strTok(rotation, " ");

	location = tokens[1]; // zm_gametype_location.cfg
	location = strTok(location, ".");
	location = location[0]; // zm_gametype_location
	location = strTok(location, "_");
	location = location[1]; // gametype

	return location;
}

get_location_from_rotation(rotation)
{
	tokens = strTok(rotation, " ");

	location = tokens[1]; // zm_gametype_location.cfg
	location = strTok(location, ".");
	location = location[0]; // zm_gametype_location
	location = strTok(location, "_");
	location = location[2]; // location

	return location;
}

get_mapname_from_rotation(rotation)
{
	tokens = strTok(rotation, " ");

	mapname = tokens[3];

	return mapname;
}