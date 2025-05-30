#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	level.update_stats_func = ::update_stats;
	level.server_stat_message_func = ::server_stat_message;

	precache_shaders();
	set_dvars();

	level thread on_player_connect();
	level thread server_message_watcher();
	level thread intermission_message();

	level thread random_map_rotation();
	level thread map_vote();

	level thread update_stats_on_end_game();

	if (is_gametype_active("zgrief"))
	{
		level thread connect_timeout_changes();
		level thread afk_kick_watcher();
	}
}

precache_shaders()
{
	precacheshader("menu_zm_popup");
	precacheshader("menu_zm_transit_zclassic_transit");
	precacheshader("menu_zm_highrise_zclassic_rooftop");
	precacheshader("menu_zm_prison_zclassic_prison");
	precacheshader("menu_zm_buried_zclassic_processing");
	precacheshader("menu_zm_tomb_zclassic_tomb");
	precacheshader("menu_zm_transit_zsurvival_transit");
	precacheshader("menu_zm_transit_zsurvival_diner");
	precacheshader("menu_zm_transit_zsurvival_farm");
	precacheshader("menu_zm_transit_zsurvival_power");
	precacheshader("menu_zm_transit_zsurvival_town");
	precacheshader("menu_zm_transit_zsurvival_tunnel");
	precacheshader("menu_zm_transit_zsurvival_cornfield");
	precacheshader("menu_zm_highrise_zsurvival_shopping_mall");
	precacheshader("menu_zm_highrise_zsurvival_dragon_rooftop");
	precacheshader("menu_zm_highrise_zsurvival_sweatshop");
	precacheshader("menu_zm_nuked_zsurvival_nuked");
	precacheshader("menu_zm_prison_zsurvival_cellblock");
	precacheshader("menu_zm_prison_zsurvival_docks");
	precacheshader("menu_zm_buried_zsurvival_street");
	precacheshader("menu_zm_buried_zsurvival_maze");
	precacheshader("menu_zm_tomb_zsurvival_trenches");
	precacheshader("menu_zm_tomb_zsurvival_excavation_site");
	precacheshader("menu_zm_tomb_zsurvival_church");
	precacheshader("menu_zm_tomb_zsurvival_crazy_place");
}

set_dvars()
{
	if (getDvar("changelog_link") == "")
	{
		setDvar("changelog_link", "github.com/Jbleezy/BO2-Reimagined");
	}

	if (getDvar("discord_link") == "")
	{
		setDvar("discord_link", "dsc.gg/Jbleezy");
	}

	if (getDvar("donate_link") == "")
	{
		setDvar("donate_link", "ko-fi.com/Jbleezy");
	}

	setDvar("sv_sayName", "");
}

on_player_connect()
{
	while (1)
	{
		level waittill("connected", player);

		player thread wait_and_show_connect_message();
		player thread remove_loss_on_reconnect();
	}
}

wait_and_show_connect_message()
{
	self endon("disconnect");

	flag_wait("initial_players_connected");

	server_message("changelog", self, 1);
}

server_message_watcher()
{
	while (1)
	{
		level waittill("say", message, player, hidden);

		if (!hidden)
		{
			continue;
		}

		server_message(toLower(message), player);
	}
}

server_message(message_str, player, tell = 0)
{
	message_array = strTok(message_str, " ");
	message = message_array[0];

	text = "";

	if (message == "changelog")
	{
		text = "Changelog: " + getDvar("changelog_link");
	}
	else if (message == "discord")
	{
		text = "Discord: " + getDvar("discord_link");
	}
	else if (message == "donate")
	{
		text = "Donate: " + getDvar("donate_link");
	}
	else if (message == "stat")
	{
		if (isdefined(level.server_stat_message_func))
		{
			[[level.server_stat_message_func]](message_str, player);
		}

		return;
	}
	else
	{
		return;
	}

	if (isDefined(player) && tell)
	{
		player tell(text);
	}
	else
	{
		say(text);
	}
}

intermission_message()
{
	level waittill("intermission");

	server_message("discord");
	server_message("donate");
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

	map_rotation_string = getDvar("sv_mapRotation");
	map_rotation_array = rotation_string_to_array(map_rotation_string);

	if (map_rotation_array.size < 2)
	{
		return;
	}

	// randomize maps
	map_rotation_array = array_randomize(map_rotation_array);

	// make sure current map isn't first
	// except for initially since map hasn't been played
	if (!initial_map)
	{
		location = get_location_from_rotation(map_rotation_array[0]);
		map = get_map_from_rotation(map_rotation_array[0]);

		if (level.scr_zm_map_start_location == location && level.script == map)
		{
			num = randomIntRange(1, map_rotation_array.size);
			map_rotation_array = array_swap(map_rotation_array, 0, num);
		}
	}

	map_rotation_string = rotation_array_to_string(map_rotation_array);

	setDvar("sv_mapRotation", map_rotation_string);
	setDvar("sv_mapRotationCurrent", map_rotation_string);

	// make initial map random
	if (initial_map)
	{
		exitLevel(0);
	}
}

map_vote()
{
	level waittill("intermission");

	map_rotation_array = array_randomize(rotation_string_to_array(getDvar("sv_mapRotation")));

	if (map_rotation_array.size < 3)
	{
		return;
	}

	gametype_rotation_array = [];

	if (is_gametype_active("zgrief"))
	{
		gametype_rotation_array = array_randomize(strTok(getDvar("sv_gametypeRotation"), " "));

		if (gametype_rotation_array.size < 1)
		{
			gametype_rotation_array = array(level.scr_zm_ui_gametype_obj);
		}
	}

	time = level.zombie_vars["zombie_intermission_time"];

	maps = [];
	exclude = [];

	for (i = 0; i < 3; i++)
	{
		maps[i] = [];
	}

	gametype = getSubStr(level.scr_zm_ui_gametype, 1, level.scr_zm_ui_gametype.size);

	maps[1]["rotation_string"] = "execgts zm_" + gametype + "_" + level.scr_zm_map_start_location + ".cfg map " + level.script;
	maps[1]["map_name"] = level.script;
	maps[1]["loc_name"] = level.scr_zm_map_start_location;
	maps[1]["gametype_name"] = level.scr_zm_ui_gametype;

	if (is_gametype_active("zgrief"))
	{
		maps[1]["gametype_name"] = level.scr_zm_ui_gametype_obj;
	}

	exclude[exclude.size] = maps[1]["loc_name"];

	rotation = undefined;

	foreach (map_rotation in map_rotation_array)
	{
		if (!isInArray(exclude, get_location_from_rotation(map_rotation)))
		{
			rotation = map_rotation;
			break;
		}
	}

	maps[0]["rotation_string"] = rotation;
	maps[0]["map_name"] = get_map_from_rotation(rotation);
	maps[0]["loc_name"] = get_location_from_rotation(rotation);
	maps[0]["gametype_name"] = "z" + get_gametype_from_rotation(rotation);

	if (is_gametype_active("zgrief"))
	{
		maps[0]["gametype_name"] = random(gametype_rotation_array);
	}

	exclude[exclude.size] = maps[0]["loc_name"];

	rotation = undefined;

	foreach (map_rotation in map_rotation_array)
	{
		if (!isInArray(exclude, get_location_from_rotation(map_rotation)))
		{
			rotation = map_rotation;
			break;
		}
	}

	maps[2]["rotation_string"] = rotation;
	maps[2]["map_name"] = get_map_from_rotation(rotation);
	maps[2]["loc_name"] = get_location_from_rotation(rotation);
	maps[2]["gametype_name"] = "z" + get_gametype_from_rotation(rotation);

	if (is_gametype_active("zgrief"))
	{
		maps[2]["gametype_name"] = random(gametype_rotation_array);
	}

	y = 87;

	if (is_gametype_active("zgrief"))
	{
		y += 81;
	}

	level.zombie_vars["vote_timer_hud"] = create_map_vote_timer_hud(0, y - 58, time);

	level.zombie_vars["map_image_hud"] = [];
	level.zombie_vars["map_image_hud"][0] = create_map_image_hud(get_image_for_loc(maps[0]["map_name"], maps[0]["loc_name"], maps[0]["gametype_name"]), -200, y);
	level.zombie_vars["map_image_hud"][1] = create_map_image_hud(get_image_for_loc(maps[1]["map_name"], maps[1]["loc_name"], maps[1]["gametype_name"]), 0, y);
	level.zombie_vars["map_image_hud"][2] = create_map_image_hud(get_image_for_loc(maps[2]["map_name"], maps[2]["loc_name"], maps[2]["gametype_name"]), 200, y);

	level.zombie_vars["map_name_hud"] = [];
	level.zombie_vars["map_name_hud"][0] = create_map_name_hud(get_name_for_loc(maps[0]["map_name"], maps[0]["loc_name"], maps[0]["gametype_name"]), -200, y);
	level.zombie_vars["map_name_hud"][1] = create_map_name_hud(get_name_for_loc(maps[1]["map_name"], maps[1]["loc_name"], maps[1]["gametype_name"]), 0, y);
	level.zombie_vars["map_name_hud"][2] = create_map_name_hud(get_name_for_loc(maps[2]["map_name"], maps[2]["loc_name"], maps[2]["gametype_name"]), 200, y);

	level.zombie_vars["gametype_name_hud"] = [];
	level.zombie_vars["gametype_name_hud"][0] = create_gametype_name_hud(get_name_for_gametype(maps[0]["gametype_name"]), -200, y + 16);
	level.zombie_vars["gametype_name_hud"][1] = create_gametype_name_hud(get_name_for_gametype(maps[1]["gametype_name"]), 0, y + 16);
	level.zombie_vars["gametype_name_hud"][2] = create_gametype_name_hud(get_name_for_gametype(maps[2]["gametype_name"]), 200, y + 16);

	level.zombie_vars["map_vote_count_hud"] = [];
	level.zombie_vars["map_vote_count_hud"][0] = create_map_vote_count_hud(-200, y + 30);
	level.zombie_vars["map_vote_count_hud"][1] = create_map_vote_count_hud(0, y + 30);
	level.zombie_vars["map_vote_count_hud"][2] = create_map_vote_count_hud(200, y + 30);

	level.zombie_vars["vote_input_hud"] = create_map_vote_input_hud(0, y + 52);

	level.zombie_vars["map_votes"] = [];
	level.zombie_vars["map_votes"][0] = 0;
	level.zombie_vars["map_votes"][1] = 0;
	level.zombie_vars["map_votes"][2] = 0;

	array_thread(get_players(), ::player_choose_map, y);

	wait time;

	level notify("stop_vote");

	players = get_players();

	index = get_map_winner();

	for (i = 0; i < 3; i++)
	{
		if (i != index)
		{
			level.zombie_vars["map_image_hud"][i].alpha = 0;
			level.zombie_vars["map_name_hud"][i].alpha = 0;
			level.zombie_vars["gametype_name_hud"][i].alpha = 0;
			level.zombie_vars["map_vote_count_hud"][i].alpha = 0;
		}
	}

	if (index != 1)
	{
		level.zombie_vars["map_image_hud"][index] moveOverTime(0.5);
		level.zombie_vars["map_name_hud"][index] moveOverTime(0.5);
		level.zombie_vars["gametype_name_hud"][index] moveOverTime(0.5);
		level.zombie_vars["map_vote_count_hud"][index] moveOverTime(0.5);

		level.zombie_vars["map_image_hud"][index].x = 0;
		level.zombie_vars["map_name_hud"][index].x = 0;
		level.zombie_vars["gametype_name_hud"][index].x = 0;
		level.zombie_vars["map_vote_count_hud"][index].x = 0;
	}

	foreach (player in players)
	{
		if (!isdefined(player.map_select))
		{
			continue;
		}

		for (i = 0; i < 3; i++)
		{
			if (i != index)
			{
				player.map_select.hud[i].alpha = 0;
			}
			else
			{
				player.map_select.hud[i].color = (1, 1, 1);
			}
		}

		if (index != 1)
		{
			player.map_select.hud[index] moveOverTime(0.5);
			player.map_select.hud[index].x = 0;
		}
	}

	level.zombie_vars["vote_input_hud"].alpha = 0;
	level.zombie_vars["vote_timer_hud"].alpha = 0;

	wait 1.5;

	setDvar("sv_mapRotationCurrent", maps[index]["rotation_string"]);

	if (is_gametype_active("zgrief"))
	{
		setDvar("ui_gametype_obj", maps[index]["gametype_name"]);
	}
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
	hud.foreground = 1;
	hud.alpha = 0.7;
	hud setShader(image, 180, 100);

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
	hud.sort = 1;
	hud.foreground = 1;
	hud.alpha = 1;
	hud setText(name);

	return hud;
}

create_gametype_name_hud(name, x, y)
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
	hud.sort = 1;
	hud.foreground = 1;
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
	hud.sort = 1;
	hud.foreground = 1;
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
	hud.foreground = 1;
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
	hud.foreground = 1;
	hud.alpha = 1;
	hud.label = &"ZOMBIE_HUD_VOTE_TIME";
	hud setTimer(time);

	return hud;
}

create_map_select_hud(x, y)
{
	hud = newClientHudElem(self);
	hud.x = x;
	hud.y = y;
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.foreground = 1;
	hud.alpha = 0.7;
	hud setShader("menu_zm_popup", 180, 100);

	return hud;
}

player_choose_map(y)
{
	self endon("disconnect");

	self.map_select = spawnStruct();
	self.map_select.ind = 1;
	self.map_select.selected = 0;
	self.map_select.hud = [];
	self.map_select.hud[0] = self create_map_select_hud(-200, y);
	self.map_select.hud[1] = self create_map_select_hud(0, y);
	self.map_select.hud[2] = self create_map_select_hud(200, y);
	self.map_select.hud[self.map_select.ind].color = (1, 1, 0);

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

	level waittill("stop_vote");

	self.map_select.hud destroy();
}

left_watcher()
{
	level endon("stop_vote");
	self endon("disconnect");

	while (1)
	{
		self waittill("left");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		prev_ind = select.ind;

		select.ind--;

		if (select.ind < 0)
		{
			select.ind = 2;
		}

		select.hud[prev_ind].color = (1, 1, 1);
		select.hud[select.ind].color = (1, 1, 0);
	}
}

right_watcher()
{
	level endon("stop_vote");
	self endon("disconnect");

	while (1)
	{
		self waittill("right");

		select = self get_player_select();

		if (!isdefined(select))
		{
			continue;
		}

		prev_ind = select.ind;

		select.ind++;

		if (select.ind > 2)
		{
			select.ind = 0;
		}

		select.hud[prev_ind].color = (1, 1, 1);
		select.hud[select.ind].color = (1, 1, 0);
	}
}

select_watcher()
{
	level endon("stop_vote");
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
			select.hud[select.ind].color = (0, 1, 0);

			level.zombie_vars["map_votes"][select.ind]++;
			level.zombie_vars["map_vote_count_hud"][select.ind] setValue(level.zombie_vars["map_votes"][select.ind]);
		}
	}
}

get_player_select()
{
	if (self.map_select.selected)
	{
		return undefined;
	}

	return self.map_select;
}

get_map_winner()
{
	// if no one voted, stay on current map
	if (level.zombie_vars["map_votes"][0] == 0 && level.zombie_vars["map_votes"][1] == 0 && level.zombie_vars["map_votes"][2] == 0)
	{
		return 1;
	}

	winner = array(0);

	for (i = 1; i < 3; i++)
	{
		if (level.zombie_vars["map_votes"][i] == level.zombie_vars["map_votes"][winner[0]])
		{
			winner[winner.size] = i;
		}
		else if (level.zombie_vars["map_votes"][i] > level.zombie_vars["map_votes"][winner[0]])
		{
			winner = array(i);
		}
	}

	return random(winner);
}

get_name_for_loc(map, location, gametype)
{
	if (location == "transit")
	{
		if (gametype == "zclassic")
		{
			return &"ZMUI_CLASSIC_TRANSIT";
		}
		else
		{
			return &"ZMUI_TRANSIT_STARTLOC";
		}
	}
	else if (location == "farm")
	{
		return &"ZMUI_FARM";
	}
	else if (location == "town")
	{
		return &"ZMUI_TOWN";
	}
	else if (location == "diner")
	{
		return &"ZMUI_DINER";
	}
	else if (location == "power")
	{
		return &"ZMUI_POWER";
	}
	else if (location == "tunnel")
	{
		return &"ZMUI_TUNNEL";
	}
	else if (location == "cornfield")
	{
		return &"ZMUI_CORNFIELD";
	}
	else if (location == "nuked")
	{
		return &"ZMUI_NUKED_STARTLOC";
	}
	else if (location == "rooftop")
	{
		return &"ZMUI_CLASSIC_ROOFTOP";
	}
	else if (location == "shopping_mall")
	{
		return &"ZMUI_SHOPPING_MALL";
	}
	else if (location == "dragon_rooftop")
	{
		return &"ZMUI_DRAGON_ROOFTOP";
	}
	else if (location == "sweatshop")
	{
		return &"ZMUI_SWEATSHOP";
	}
	else if (location == "prison")
	{
		return &"ZMUI_CLASSIC_PRISON";
	}
	else if (location == "cellblock")
	{
		return &"ZMUI_CELLBLOCK";
	}
	else if (location == "docks")
	{
		return &"ZMUI_DOCKS";
	}
	else if (location == "processing")
	{
		return &"ZMUI_CLASSIC_BURIED";
	}
	else if (location == "street")
	{
		return &"ZMUI_STREET_LOC";
	}
	else if (location == "maze")
	{
		return &"ZMUI_MAZE";
	}
	else if (location == "tomb")
	{
		return &"ZMUI_CLASSIC_TOMB";
	}
	else if (location == "trenches")
	{
		return &"ZMUI_TRENCHES";
	}
	else if (location == "excavation_site")
	{
		return &"ZMUI_EXCAVATION_SITE";
	}
	else if (location == "church")
	{
		return &"ZMUI_CHURCH";
	}
	else if (location == "crazy_place")
	{
		return &"ZMUI_CRAZY_PLACE";
	}

	return &"";
}

get_name_for_gametype(gametype)
{
	if (gametype == "zclassic")
	{
		return &"ZMUI_ZCLASSIC_GAMEMODE";
	}
	else if (gametype == "zstandard")
	{
		return &"ZMUI_ZSTANDARD";
	}
	else if (isdefined(level.get_gamemode_display_name_func))
	{
		return [[level.get_gamemode_display_name_func]](gametype);
	}

	return &"";
}

get_image_for_loc(map, location, gametype)
{
	if (gametype != "zclassic")
	{
		gametype = "zsurvival";
	}

	return "menu_" + map + "_" + gametype + "_" + location;
}

rotation_string_to_array(string)
{
	array = [];

	tokens = strTok(string, " ");

	for (i = 0; i < tokens.size; i += 4)
	{
		array[array.size] = tokens[i] + " " + tokens[i + 1] + " " + tokens[i + 2] + " " + tokens[i + 3];
	}

	return array;
}

rotation_array_to_string(array)
{
	string = "";

	for (i = 0; i < array.size; i++)
	{
		string += array[i];

		if (i < (array.size - 1))
		{
			string += " ";
		}
	}

	return string;
}

get_gametype_from_rotation(rotation)
{
	rotation_toks = strTok(rotation, " ");
	zm_gametype_location_cfg = rotation_toks[1]; // zm_gametype_location.cfg
	zm_gametype_location_cfg_toks = strTok(zm_gametype_location_cfg, ".");
	zm_gametype_location = zm_gametype_location_cfg_toks[0]; // zm_gametype_location
	zm_gametype_location_toks = strTok(zm_gametype_location, "_");
	gametype = zm_gametype_location_toks[1]; // gametype

	return gametype;
}

get_location_from_rotation(rotation)
{
	rotation_toks = strTok(rotation, " ");
	zm_gametype_location_cfg = rotation_toks[1]; // zm_gametype_location.cfg
	zm_gametype_location_cfg_toks = strTok(zm_gametype_location_cfg, ".");
	zm_gametype_location = zm_gametype_location_cfg_toks[0]; // zm_gametype_location
	zm_gametype_location_toks = strTok(zm_gametype_location, "_");
	location = "";

	for (i = 2; i < zm_gametype_location_toks.size; i++)
	{
		if (i > 2)
		{
			location += "_";
		}

		location += zm_gametype_location_toks[i]; // location
	}

	return location;
}

get_map_from_rotation(rotation)
{
	rotation_toks = strTok(rotation, " ");
	map = rotation_toks[3];

	return map;
}

remove_loss_on_reconnect()
{
	guids = strTok(getDvar("disconnected_players"), " ");

	foreach (guid in guids)
	{
		if (self getguid() == int(guid))
		{
			update_stats(self, 1);
			return;
		}
	}
}

server_stat_message(message_str, player)
{
	stat_player = undefined;
	message_array = strTok(message_str, " ");

	if (message_array.size == 1)
	{
		stat_player = player;
	}
	else
	{
		players = get_players();

		foreach (other_player in players)
		{
			if (message_array[1] == getSubStr(toLower(other_player.name), 0, message_array[1].size))
			{
				stat_player = other_player;
				break;
			}
		}
	}

	if (!isDefined(stat_player))
	{
		player tell("Player not found");
		return;
	}

	text = "";
	path = "stats/" + stat_player getguid() + ".csv";

	if (fs_testfile(path))
	{
		file = fs_fopen(path, "read");
		text = fs_read(file);
		fs_fclose(file);
	}

	text_array = strTok(text, ",\n");

	if (is_gametype_active("zgrief"))
	{
		wins = 0;
		losses = 0;
		total_wins = 0;
		total_losses = 0;

		gamemode_str = get_gamemode_stat_str();
		total_str = "Total";

		if (is_true(level.scr_zm_ui_gametype_pro))
		{
			total_str += " Pro";
		}

		for (i = 2; i < text_array.size; i += 2)
		{
			if (text_array[i] == total_str + " Wins")
			{
				total_wins = text_array[i + 1];
			}
			else if (text_array[i] == total_str + " Losses")
			{
				total_losses = text_array[i + 1];
			}
			else if (text_array[i] == gamemode_str + " Wins")
			{
				wins = text_array[i + 1];
			}
			else if (text_array[i] == gamemode_str + " Losses")
			{
				losses = text_array[i + 1];
			}
		}

		say(gamemode_str + " - " + stat_player.name + ":");
		say("Wins - " + wins + ", Losses - " + losses);

		say(total_str + " - " + stat_player.name + ":");
		say("Wins - " + total_wins + ", Losses - " + total_losses);
	}
	else
	{
		round = 0;

		map_str = get_map_stat_str();

		for (i = 2; i < text_array.size; i += 2)
		{
			if (text_array[i] == map_str)
			{
				round = text_array[i + 1];
			}
		}

		say(map_str + " - " + stat_player.name + ":");
		say("Highest Round - " + round);
	}
}

update_stats_on_end_game()
{
	level waittill("end_game");

	setDvar("disconnected_players", "");

	update_stats();

	if (is_gametype_active("zgrief"))
	{
		players = get_players();

		foreach (player in players)
		{
			player tell_grief_stats();
		}
	}
}

update_stats(disconnecting_player, remove_loss = 0)
{
	if (isDefined(disconnecting_player))
	{
		if (!flag("initial_blackscreen_passed") || is_true(level.intermission))
		{
			return;
		}

		if (!remove_loss)
		{
			setDvar("disconnected_players", getDvar("disconnected_players") + disconnecting_player getguid() + " ");
		}
	}

	players = get_players();

	if (isDefined(disconnecting_player))
	{
		players = array(disconnecting_player);
	}

	foreach (player in players)
	{
		if (player is_bot())
		{
			continue;
		}

		win = 0;
		loss = 0;

		if (isDefined(disconnecting_player))
		{
			if (!remove_loss)
			{
				loss = 1;
			}
		}
		else
		{
			if (player._encounters_team == level.gamemodulewinningteam)
			{
				win = 1;
			}
			else
			{
				loss = 1;
			}
		}

		text = "";
		path = "stats/" + player getguid() + ".csv";

		if (fs_testfile(path))
		{
			file = fs_fopen(path, "read");
			text = fs_read(file);
			fs_fclose(file);
		}

		text_array = strTok(text, ",\n");

		if (text_array.size == 0)
		{
			text_array[0] = "Name";
		}

		if (!isDefined(text_array[1]) || text_array[1] != player.name)
		{
			text_array[1] = player.name;
		}

		if (is_gametype_active("zgrief"))
		{
			found = 0;
			stat_str = "Total";

			if (is_true(level.scr_zm_ui_gametype_pro))
			{
				stat_str += " Pro";
			}

			if (win)
			{
				stat_str += " Wins";
			}
			else
			{
				stat_str += " Losses";
			}

			for (i = 2; i < text_array.size; i += 2)
			{
				if (text_array[i] == stat_str)
				{
					if (!isDefined(text_array[i + 1]))
					{
						text_array[i + 1] = 0;
					}
					else
					{
						text_array[i + 1] = int(text_array[i + 1]);
					}

					if (isDefined(disconnecting_player) && remove_loss)
					{
						if (text_array[i + 1] > 0)
						{
							text_array[i + 1]--;
						}
					}
					else
					{
						text_array[i + 1]++;
					}

					found = 1;
					break;
				}
			}

			if (!found)
			{
				stat_str = "Total";

				if (is_true(level.scr_zm_ui_gametype_pro))
				{
					stat_str += " Pro";
				}

				text_array[text_array.size] = stat_str + " Wins";

				if (is_true(win))
				{
					text_array[text_array.size] = 1;
				}
				else
				{
					text_array[text_array.size] = 0;
				}

				text_array[text_array.size] = stat_str + " Losses";

				if (!is_true(win))
				{
					text_array[text_array.size] = 1;
				}
				else
				{
					text_array[text_array.size] = 0;
				}
			}

			found = 0;
			stat_str = get_gamemode_stat_str();

			if (win)
			{
				stat_str += " Wins";
			}
			else
			{
				stat_str += " Losses";
			}

			for (i = 2; i < text_array.size; i += 2)
			{
				if (text_array[i] == stat_str)
				{
					if (!isDefined(text_array[i + 1]))
					{
						text_array[i + 1] = 0;
					}
					else
					{
						text_array[i + 1] = int(text_array[i + 1]);
					}

					if (isDefined(disconnecting_player) && is_true(remove_loss))
					{
						if (text_array[i + 1] > 0)
						{
							text_array[i + 1]--;
						}
					}
					else
					{
						text_array[i + 1]++;
					}

					found = 1;
					break;
				}
			}

			if (!found)
			{
				stat_str = get_gamemode_stat_str();

				text_array[text_array.size] = stat_str + " Wins";

				if (is_true(win))
				{
					text_array[text_array.size] = 1;
				}
				else
				{
					text_array[text_array.size] = 0;
				}

				text_array[text_array.size] = stat_str + " Losses";

				if (!is_true(win))
				{
					text_array[text_array.size] = 1;
				}
				else
				{
					text_array[text_array.size] = 0;
				}
			}
		}
		else
		{
			found = 0;
			stat_str = get_map_stat_str();

			for (i = 2; i < text_array.size; i += 2)
			{
				if (text_array[i] == stat_str)
				{
					if (!isDefined(text_array[i + 1]) || int(text_array[i + 1]) < level.round_number)
					{
						text_array[i + 1] = level.round_number;
					}

					found = 1;
					break;
				}
			}

			if (!found)
			{
				text_array[text_array.size] = stat_str;
				text_array[text_array.size] = level.round_number;
			}
		}

		text = "";

		for (i = 0; i < text_array.size; i++)
		{
			text += text_array[i];

			if (i < (text_array.size - 1))
			{
				text += ",";
			}
		}

		text += "\n";

		file = fs_fopen(path, "write");
		fs_write(file, text);
		fs_fclose(file);
	}
}

get_map_stat_str()
{
	if (level.script == "zm_transit")
	{
		if (level.scr_zm_map_start_location == "transit")
		{
			if (is_classic())
			{
				return "TranZit";
			}
			else
			{
				return "Bus Depot";
			}
		}
		else if (level.scr_zm_map_start_location == "diner")
		{
			return "Diner";
		}
		else if (level.scr_zm_map_start_location == "farm")
		{
			return "Farm";
		}
		else if (level.scr_zm_map_start_location == "power")
		{
			return "Power Station";
		}
		else if (level.scr_zm_map_start_location == "town")
		{
			return "Town";
		}
		else if (level.scr_zm_map_start_location == "tunnel")
		{
			return "Tunnel";
		}
		else if (level.scr_zm_map_start_location == "cornfield")
		{
			return "Cornfield";
		}
	}
	else if (level.script == "zm_nuked")
	{
		if (level.scr_zm_map_start_location == "nuked")
		{
			return "Nuketown";
		}
	}
	else if (level.script == "zm_highrise")
	{
		if (level.scr_zm_map_start_location == "rooftop")
		{
			return "Die Rise";
		}
		else if (level.scr_zm_map_start_location == "shopping_mall")
		{
			return "Shopping Mall";
		}
		else if (level.scr_zm_map_start_location == "dragon_rooftop")
		{
			return "Dragon Rooftop";
		}
		else if (level.scr_zm_map_start_location == "sweatshop")
		{
			return "Sweatshop";
		}
	}
	else if (level.script == "zm_prison")
	{
		if (level.scr_zm_map_start_location == "prison")
		{
			return "Mob of the Dead";
		}
		else if (level.scr_zm_map_start_location == "cellblock")
		{
			return "Cell Block";
		}
		else if (level.scr_zm_map_start_location == "docks")
		{
			return "Docks";
		}
	}
	else if (level.script == "zm_buried")
	{
		if (level.scr_zm_map_start_location == "processing")
		{
			return "Buried";
		}
		else if (level.scr_zm_map_start_location == "street")
		{
			return "Borough";
		}
		else if (level.scr_zm_map_start_location == "maze")
		{
			return "Maze";
		}
	}
	else if (level.script == "zm_tomb")
	{
		if (level.scr_zm_map_start_location == "tomb")
		{
			return "Origins";
		}
		else if (level.scr_zm_map_start_location == "trenches")
		{
			return "Trenches";
		}
		else if (level.scr_zm_map_start_location == "excavation_site")
		{
			return "Excavation Site";
		}
		else if (level.scr_zm_map_start_location == "church")
		{
			return "Church";
		}
		else if (level.scr_zm_map_start_location == "crazy_place")
		{
			return "The Crazy Place";
		}
	}

	return "";
}

get_gamemode_stat_str()
{
	gamemode = "";

	if (level.scr_zm_ui_gametype_obj == "zgrief")
	{
		gamemode = "Grief";
	}
	else if (level.scr_zm_ui_gametype_obj == "zsnr")
	{
		gamemode = "Search & Rezurrect";
	}
	else if (level.scr_zm_ui_gametype_obj == "zrace")
	{
		gamemode = "Race";
	}
	else if (level.scr_zm_ui_gametype_obj == "zcontainment")
	{
		gamemode = "Containment";
	}
	else if (level.scr_zm_ui_gametype_obj == "zmeat")
	{
		gamemode = "Meat";
	}

	if (level.scr_zm_ui_gametype_pro)
	{
		gamemode += " Pro";
	}

	return gamemode;
}

tell_grief_stats()
{
	text = "";
	path = "stats/" + self getguid() + ".csv";

	if (fs_testfile(path))
	{
		file = fs_fopen(path, "read");
		text = fs_read(file);
		fs_fclose(file);
	}

	text_array = strTok(text, ",\n");

	wins = 0;
	losses = 0;
	total_wins = 0;
	total_losses = 0;

	gamemode_str = get_gamemode_stat_str();
	total_str = "Total";

	if (is_true(level.scr_zm_ui_gametype_pro))
	{
		total_str += " Pro";
	}

	for (i = 2; i < text_array.size; i += 2)
	{
		if (text_array[i] == total_str + " Wins")
		{
			total_wins = text_array[i + 1];
		}
		else if (text_array[i] == total_str + " Losses")
		{
			total_losses = text_array[i + 1];
		}
		else if (text_array[i] == gamemode_str + " Wins")
		{
			wins = text_array[i + 1];
		}
		else if (text_array[i] == gamemode_str + " Losses")
		{
			losses = text_array[i + 1];
		}
	}

	self tell(gamemode_str + ":");
	self tell("Wins - " + wins + ", Losses - " + losses);

	self tell(total_str + ":");
	self tell("Wins - " + total_wins + ", Losses - " + total_losses);
}

connect_timeout_changes()
{
	setDvar("sv_connectTimeout", 30);

	flag_wait("initial_players_connected");

	setDvar("sv_connectTimeout", 60);
}

afk_kick_watcher()
{
	level endon("end_game");

	flag_wait("initial_blackscreen_passed");

	time_to_kick = 120000;

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			if (player any_button_pressed() || player is_bot())
			{
				player.afk_time = undefined;
				continue;
			}

			if (player.sessionstate == "spectator")
			{
				if (isDefined(player.afk_time))
				{
					player.afk_time += 50;
					continue;
				}
			}

			if (!isDefined(player.afk_time))
			{
				player.afk_time = getTime();
			}

			if ((getTime() - player.afk_time) >= time_to_kick)
			{
				kick(player getEntityNumber());
			}
		}

		wait 0.05;
	}
}

any_button_pressed()
{
	if (self actionslotonebuttonpressed() || self actionslottwobuttonpressed() || self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed() || self attackbuttonpressed() || self fragbuttonpressed() || self inventorybuttonpressed() || self jumpbuttonpressed() || self meleebuttonpressed() || self secondaryoffhandbuttonpressed() || self sprintbuttonpressed() || self stancebuttonpressed() || self throwbuttonpressed() || self usebuttonpressed() || self changeseatbuttonpressed())
	{
		return 1;
	}

	return 0;
}