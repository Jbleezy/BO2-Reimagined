#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_player;

menuautoassign( comingfrommenu )
{
	teamkeys = getarraykeys( level.teams );
	assignment = self get_assigned_team();
	self closemenus();

	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.class = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;
	self updateobjectivetext();

	if ( level.teambased )
		self.sessionteam = assignment;
	else
	{
		self.sessionteam = "none";
		self.ffateam = assignment;
	}

	self notify( "joined_team" );
	level notify( "joined_team" );
	self notify( "end_respawn" );
	self beginclasschoice();
	self setclientscriptmainmenu( game["menu_class"] );
}

get_assigned_team()
{
	teamplayers = [];
	teamplayers["axis"] = 0;
	teamplayers["allies"] = 0;

	players = get_players();

	foreach ( player in players )
	{
		if ( !isDefined(player.team) || (player.team != "axis" && player.team != "allies") )
		{
			continue;
		}

		if ( player == self )
		{
			continue;
		}

		teamplayers[player.team]++;
	}

	if ( teamplayers["axis"] <= teamplayers["allies"] )
	{
		guids = strTok(getDvar("team_axis"), " ");

		foreach ( guid in guids )
		{
			if ( self getguid() == int(guid) )
			{
				arrayRemoveValue(guids, guid);

				guid_text = "";

				foreach (guid in guids)
				{
					guid_text += guid + " ";
				}

				setDvar("team_axis", guid_text);

				return "axis";
			}
		}
	}

	if ( teamplayers["allies"] <= teamplayers["axis"] )
	{
		guids = strTok(getDvar("team_allies"), " ");

		foreach ( guid in guids )
		{
			if ( self getguid() == int(guid) )
			{
				arrayRemoveValue(guids, guid);

				guid_text = "";

				foreach (guid in guids)
				{
					guid_text += guid + " ";
				}

				setDvar("team_allies", guid_text);

				return "allies";
			}
		}
	}

	if ( teamplayers["allies"] == teamplayers["axis"] )
	{
		if ( randomint( 100 ) >= 50 )
		{
			return "axis";
		}
		else
		{
			return "allies";
		}
	}
	else
	{
		if ( teamplayers["allies"] > teamplayers["axis"] )
		{
			return "axis";
		}
		else
		{
			return "allies";
		}
	}
}