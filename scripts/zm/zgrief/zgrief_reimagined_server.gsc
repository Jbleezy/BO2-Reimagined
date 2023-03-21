#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

main()
{
	if (getDvar("g_gametype") != "zgrief")
	{
		return;
	}

	if (!isDedicated())
    {
        return;
    }
}

init()
{
	if (getDvar("g_gametype") != "zgrief")
	{
		return;
	}

    if (!isDedicated())
    {
        return;
    }

    precache_map_strings();
    precache_map_images();
    precacheshader("menu_zm_popup");

    level thread connect_timeout_changes();
    level thread random_map_rotation();
    level thread map_vote();
}

precache_map_strings()
{
    precachestring(&"ZMUI_TRANSIT_STARTLOC");
    precachestring(&"ZMUI_FARM");
    precachestring(&"ZMUI_TOWN");
    precachestring(&"ZMUI_DINER");
    precachestring(&"ZMUI_TUNNEL");
    precachestring(&"ZMUI_CELLBLOCK");
    precachestring(&"ZMUI_STREET_LOC");
}

precache_map_images()
{
    preCacheShader("loadscreen_zm_transit_zgrief_transit");
    preCacheShader("loadscreen_zm_transit_zgrief_farm");
    preCacheShader("loadscreen_zm_transit_zgrief_town");
    preCacheShader("loadscreen_zm_transit_dr_zcleansed_diner");
    preCacheShader("loadscreen_zm_prison_zgrief_cellblock");
    preCacheShader("loadscreen_zm_buried_zgrief_street");
}

connect_timeout_changes()
{
	setDvar("sv_connectTimeout", 30);

	flag_wait("initial_players_connected");

	setDvar("sv_connectTimeout", 60);
}

random_map_rotation()
{
	initial_map = 0;
	if(getDvar("sv_mapRotationRandom") == "")
	{
		initial_map = 1;
		setDvar("sv_mapRotationRandom", 1);
	}

	if(!initial_map && getDvar("sv_mapRotationCurrent") != "")
	{
		return;
	}

	rotation_string = getDvar("sv_mapRotation");
    rotation_array = rotation_string_to_array(rotation_string);

	if(rotation_array.size < 2)
	{
		return;
	}

	// randomize maps
	rotation_array = array_randomize(rotation_array);

	// make sure current map isn't first
	// except for initially since map hasn't been played
	if(!initial_map)
	{
        location = get_location_from_rotation(rotation_array[0]);
        mapname = get_mapname_from_rotation(rotation_array[0]);

		if(level.scr_zm_map_start_location == location && level.script == mapname)
		{
			num = randomIntRange(1, rotation_array.size);
			rotation_array = array_swap(rotation_array, 0, num);
		}
	}

	rotation_string = rotation_array_to_string(rotation_array);

	setDvar("sv_mapRotation", rotation_string);
	setDvar("sv_mapRotationCurrent", rotation_string);

	// make initial map random
	if(initial_map)
	{
		exitLevel(0);
	}
}

rotation_string_to_array(rotation_string)
{
    rotation_array = [];

    tokens = strTok(rotation_string, " ");
	for(i = 0; i < tokens.size; i += 4)
	{
		rotation_array[rotation_array.size] = tokens[i] + " " + tokens[i+1] + " " + tokens[i+2] + " " + tokens[i+3];
	}

    return rotation_array;
}

rotation_array_to_string(rotation_array)
{
    rotation_string = "";

    for(i = 0; i < rotation_array.size; i++)
	{
		rotation_string += rotation_array[i];

		if(i < (rotation_array.size - 1))
		{
			rotation_string += " ";
		}
	}

    return rotation_string;
}

get_location_from_rotation(rotation)
{
    tokens = strTok(rotation, " ");

    location = tokens[1]; // zm_gamemode_location.cfg
    location = strTok(location, ".");
    location = location[0]; // zm_gamemode_location
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

map_vote()
{
    level.vote_time = (level.zombie_vars["zombie_intermission_time"] / 2) - 0.25;

    level waittill("intermission");

    maps = [];
    exclude_locs = [];
    rotation_string = getDvar("sv_mapRotation");
    rotation_array = rotation_string_to_array(rotation_string);
    rotation_array = array_randomize(rotation_array);

    location = level.scr_zm_map_start_location;
    if (level.scr_zm_map_start_location == "cellblock" && getDvar("ui_zm_mapstartlocation_fake") == "docks")
    {
        location = getDvar("ui_zm_mapstartlocation_fake");
    }
    if (level.scr_zm_map_start_location == "street" && getDvar("ui_zm_mapstartlocation_fake") == "maze")
    {
        location = getDvar("ui_zm_mapstartlocation_fake");
    }

    for (i = 0; i < 3; i++)
    {
        maps[i] = [];
    }

    maps[1]["rotation_string"] = "exec zm_grief_" + location + ".cfg map " + level.script;
    maps[1]["map_name"] = level.script;
    maps[1]["loc_name"] = location;
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

    gametype_array = array_randomize(strTok(getDvar("ui_gametype_obj"), " "));

    maps[1]["gametype_name"] = level.scr_zm_ui_gametype_obj;
    arrayRemoveValue(gametype_array, maps[1]["gametype_name"]);

    maps[0]["gametype_name"] = gametype_array[0];
    maps[2]["gametype_name"] = gametype_array[1];

    image_hud = [];
    image_hud[0] = create_map_image_hud(get_image_for_loc(maps[0]["map_name"], maps[0]["loc_name"]), -200, 170);
    image_hud[1] = create_map_image_hud(get_image_for_loc(maps[1]["map_name"], maps[1]["loc_name"]), 0, 170);
    image_hud[2] = create_map_image_hud(get_image_for_loc(maps[2]["map_name"], maps[2]["loc_name"]), 200, 170);

    name_hud = [];
    name_hud[0] = create_map_name_hud(get_name_for_loc(maps[0]["loc_name"]), -200, 170);
    name_hud[1] = create_map_name_hud(get_name_for_loc(maps[1]["loc_name"]), 0, 170);
    name_hud[2] = create_map_name_hud(get_name_for_loc(maps[2]["loc_name"]), 200, 170);

    level.map_votes = [];
    level.map_votes[0] = 0;
    level.map_votes[1] = 0;
    level.map_votes[2] = 0;

    level.vote_hud = [];
    level.vote_hud[0] = create_map_vote_hud(-200, 205);
    level.vote_hud[1] = create_map_vote_hud(0, 205);
    level.vote_hud[2] = create_map_vote_hud(200, 205);

    vote_timer_hud = create_map_vote_timer_hud(0, 230);

    array_thread( get_players(), ::player_choose_map );

    wait level.vote_time;

    map_won_ind = get_map_winner();

    for (i = 0; i < 3; i++)
    {
        if (i != map_won_ind)
        {
            image_hud[i].alpha = 0;
            name_hud[i].alpha = 0;
            level.vote_hud[i].alpha = 0;
        }
    }

    map_won_ind_x = undefined;

    if (map_won_ind != 1)
    {
        map_won_ind_x = image_hud[map_won_ind].x;

        image_hud[map_won_ind] moveOverTime(0.5);
        name_hud[map_won_ind] moveOverTime(0.5);
        level.vote_hud[map_won_ind] moveOverTime(0.5);

        image_hud[map_won_ind].x = 0;
        name_hud[map_won_ind].x = 0;
        level.vote_hud[map_won_ind].x = 0;
    }

    players = get_players();
    foreach (player in players)
    {
        player.map_select_hud.alpha = 0;
    }

    wait 0.5;

    for (i = 0; i < 3; i++)
    {
        if (i != map_won_ind)
        {
            image_hud[i] setShader(get_image_for_loc(maps[map_won_ind]["map_name"], maps[map_won_ind]["loc_name"]), 175, 100);
            name_hud[i] setText(get_name_for_loc(maps[map_won_ind]["loc_name"]));

            image_hud[i].alpha = 1;
            name_hud[i].alpha = 1;
        }
    }

    if (isDefined(map_won_ind_x))
    {
        image_hud[map_won_ind].x = map_won_ind_x;
        name_hud[map_won_ind].x = map_won_ind_x;
        level.vote_hud[map_won_ind].x = map_won_ind_x;
    }

    for (i = 0; i < level.vote_hud.size; i++)
    {
        level.map_votes[i] = 0;
        level.vote_hud[i] setValue(0);
        level.vote_hud[i].alpha = 1;
    }

    players = get_players();
    foreach (player in players)
    {
        player.map_select_hud.x = 0;
        player.map_select_hud.alpha = 1;
        player.map_select_ind = 1;
        player.map_selected = 0;
    }

    gametype_hud = [];
    gametype_hud[0] = create_map_gametype_hud(scripts\zm\zgrief\zgrief_reimagined::get_gamemode_display_name(maps[0]["gametype_name"]), -200, 187.5);
    gametype_hud[1] = create_map_gametype_hud(scripts\zm\zgrief\zgrief_reimagined::get_gamemode_display_name(maps[1]["gametype_name"]), 0, 187.5);
    gametype_hud[2] = create_map_gametype_hud(scripts\zm\zgrief\zgrief_reimagined::get_gamemode_display_name(maps[2]["gametype_name"]), 200, 187.5);

    vote_timer_hud setTimer(level.vote_time);

    level waittill("stop_intermission");

    gametype_won_ind = get_map_winner();

    for (i = 0; i < 3; i++)
    {
        if (i != gametype_won_ind)
        {
            image_hud[i].alpha = 0;
            name_hud[i].alpha = 0;
            gametype_hud[i].alpha = 0;
            level.vote_hud[i].alpha = 0;
        }
    }

    if (gametype_won_ind != 1)
    {
        image_hud[gametype_won_ind] moveOverTime(0.5);
        name_hud[gametype_won_ind] moveOverTime(0.5);
        gametype_hud[gametype_won_ind] moveOverTime(0.5);
        level.vote_hud[gametype_won_ind] moveOverTime(0.5);

        image_hud[gametype_won_ind].x = 0;
        name_hud[gametype_won_ind].x = 0;
        gametype_hud[gametype_won_ind].x = 0;
        level.vote_hud[gametype_won_ind].x = 0;
    }

    players = get_players();
    foreach (player in players)
    {
        player.map_select_hud.alpha = 0;
    }

    vote_timer_hud.alpha = 0;

    if (map_won_ind == 1)
    {
        level.map_restart = 1;
    }
    else
    {
        makeDvarServerInfo("ui_zm_mapstartlocation", maps[map_won_ind]["loc_name"]);
        setDvar("ui_zm_mapstartlocation", maps[map_won_ind]["loc_name"]);

        setDvar("ui_gametype_obj_cur", maps[gametype_won_ind]["gametype_name"]);

        // can only map_restart() from and to added Tranzit maps, others get client field mismatch
        added_maps = array("diner", "power", "tunnel", "cornfield");

        if (isInArray(added_maps, maps[map_won_ind]["loc_name"]) && isInArray(added_maps, level.scr_zm_map_start_location))
        {
            level.map_restart = 1;
        }
        else
        {
            setDvar("sv_mapRotationCurrent", maps[map_won_ind]["rotation_string"]);
        }
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
    hud.alpha = 1;
    hud setshader(image, 175, 100);

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

create_map_vote_hud(x, y)
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

create_map_vote_timer_hud(x, y)
{
    hud = newHudElem();
    hud.x = 0;
    hud.y = y;
    hud.font = "objective";
    hud.fontscale = 1.2;
    hud.horzalign = "center";
    hud.vertalign = "middle";
    hud.alignx = "center";
    hud.aligny = "middle";
    hud.alpha = 1;
    hud setTimer(level.vote_time);

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
    hud setshader("menu_zm_popup", 175, 110);

    return hud;
}

player_choose_map()
{
    self endon("disconnect");

    wait 0.1;

    self.sessionstate = "playing"; // must change sessionstate or hud elems don't show
    self setOrigin((0, 0, -10000));
    self.map_select_hud = self create_map_select_hud(0, 170);
    self.map_select_ind = 1;
    self.map_selected = 0;

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

    level waittill( "stop_intermission" );

    self.map_select_hud destroy();
}

left_watcher()
{
    level endon( "stop_intermission" );
    self endon("disconnect");

    while(1)
    {
        self waittill("left");

        if (self.map_selected)
        {
            continue;
        }

        if (self.map_select_ind == 0)
        {
            self.map_select_ind = 2;
            self.map_select_hud.x += 400;
            continue;
        }

        self.map_select_ind--;
        self.map_select_hud.x -= 200;
    }
}

right_watcher()
{
    level endon( "stop_intermission" );
    self endon("disconnect");

    while(1)
    {
        self waittill("right");

        if (self.map_selected)
        {
            continue;
        }

        if (self.map_select_ind == 2)
        {
            self.map_select_ind = 0;
            self.map_select_hud.x -= 400;
            continue;
        }

        self.map_select_ind++;
        self.map_select_hud.x += 200;
    }
}

select_watcher()
{
    level endon( "stop_intermission" );
    self endon("disconnect");

    while(1)
    {
        self waittill("select");

        if (!self.map_selected)
        {
            self.map_selected = 1;
            self.map_select_hud.color = (0, 1, 0);

            level.map_votes[self.map_select_ind]++;
            level.vote_hud[self.map_select_ind] setValue(level.map_votes[self.map_select_ind]);
        }
        else
        {
            self.map_selected = 0;
            self.map_select_hud.color = (1, 1, 1);

            level.map_votes[self.map_select_ind]--;
            level.vote_hud[self.map_select_ind] setValue(level.map_votes[self.map_select_ind]);
        }
    }
}

get_map_winner()
{
    winner_ind = array(0);

    for (i = 1; i < 3; i++)
    {
        if (level.map_votes[i] == level.map_votes[winner_ind[0]])
        {
            winner_ind[winner_ind.size] = i;
        }
        else if(level.map_votes[i] > level.map_votes[winner_ind[0]])
        {
            winner_ind = array(i);
        }
    }

    if (winner_ind.size > 1 && isInArray(winner_ind, 1))
    {
        arrayRemoveValue(winner_ind, 1);
    }

    return random(winner_ind);
}

get_name_for_loc(locname)
{
    if (locname == "transit")
    {
        return &"ZMUI_TRANSIT_STARTLOC";
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
        return "Power Station";
    }
    else if (locname == "tunnel")
    {
        return &"ZMUI_TUNNEL";
    }
    else if (locname == "cornfield")
    {
        return "Cornfield";
    }
    else if (locname == "cellblock")
    {
        return &"ZMUI_CELLBLOCK";
    }
    else if (locname == "docks")
    {
        return "Docks";
    }
    else if (locname == "street")
    {
        return &"ZMUI_STREET_LOC";
    }
    else if (locname == "maze")
    {
        return "Maze";
    }

    return "";
}

get_image_for_loc(mapname, locname)
{
    if (locname == "diner")
    {
        return "loadscreen_zm_transit_dr_zcleansed_diner";
    }
    else if (locname == "power" || locname == "tunnel" || locname == "cornfield")
    {
        return "loadscreen_zm_transit_zgrief_transit";
    }
    else if (locname == "docks")
    {
        return "loadscreen_zm_prison_zgrief_cellblock";
    }
    else if (locname == "maze")
    {
        return "loadscreen_zm_buried_zgrief_street";
    }

    return "loadscreen_" + mapname + "_zgrief_" + locname;
}