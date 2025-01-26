#include maps\mp\gametypes_zm\_serversettings;

init()
{
	level.hostname = getdvar("sv_hostname");

	if (level.hostname == "")
	{
		level.hostname = "CoDHost";
	}

	setdvar("sv_hostname", level.hostname);
	setdvar("ui_hostname", level.hostname);
	makedvarserverinfo("ui_hostname", "CoDHost");
	level.motd = getdvar("scr_motd");

	if (level.motd == "")
	{
		level.motd = "";
	}

	setdvar("scr_motd", level.motd);
	setdvar("ui_motd", level.motd);
	makedvarserverinfo("ui_motd", "");
	level.allowvote = getdvar("g_allowVote");

	if (level.allowvote == "")
	{
		level.allowvote = "1";
	}

	setdvar("g_allowvote", level.allowvote);
	setdvar("ui_allowvote", level.allowvote);
	makedvarserverinfo("ui_allowvote", "1");
	level.allow_teamchange = "0";
	level.friendlyfire = getgametypesetting("friendlyfiretype");
	setdvar("ui_friendlyfire", level.friendlyfire);
	makedvarserverinfo("ui_friendlyfire", "0");

	if (getdvar("scr_mapsize") == "")
	{
		setdvar("scr_mapsize", "64");
	}
	else if (getdvarfloat("scr_mapsize") >= 64)
	{
		setdvar("scr_mapsize", "64");
	}
	else if (getdvarfloat("scr_mapsize") >= 32)
	{
		setdvar("scr_mapsize", "32");
	}
	else if (getdvarfloat("scr_mapsize") >= 16)
	{
		setdvar("scr_mapsize", "16");
	}
	else
	{
		setdvar("scr_mapsize", "8");
	}

	level.mapsize = getdvarfloat("scr_mapsize");
	constraingametype(getdvar("g_gametype"));
	constrainmapsize(level.mapsize);

	for (;;)
	{
		updateserversettings();
		wait 5;
	}
}