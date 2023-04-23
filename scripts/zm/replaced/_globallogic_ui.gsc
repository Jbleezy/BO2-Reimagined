#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_globallogic_ui;

menuautoassign( comingfrommenu )
{
    teamkeys = getarraykeys( level.teams );
    assignment = teamkeys[randomint( teamkeys.size )];
    self closemenus();

    if ( isdefined( level.forceallallies ) && level.forceallallies )
        assignment = "allies";
    else if ( level.teambased )
    {
        if ( getdvarint( "party_autoteams" ) == 1 )
        {
            if ( level.allow_teamchange == "1" && ( self.hasspawned || comingfrommenu ) )
                assignment = "";
            else
            {
                team = getassignedteam( self );

                switch ( team )
                {
                    case 1:
                        assignment = teamkeys[1];
                        break;
                    case 2:
                        assignment = teamkeys[0];
                        break;
                    case 3:
                        assignment = teamkeys[2];
                        break;
                    case 4:
                        if ( !isdefined( level.forceautoassign ) || !level.forceautoassign )
                        {
                            self setclientscriptmainmenu( game["menu_class"] );
                            return;
                        }
                    default:
                        assignment = "";

                        if ( isdefined( level.teams[team] ) )
                            assignment = team;
                        else if ( team == "spectator" && !level.forceautoassign )
                        {
                            self setclientscriptmainmenu( game["menu_class"] );
                            return;
                        }
                }
            }
        }

        if ( assignment == "" || getdvarint( "party_autoteams" ) == 0 )
        {
            if ( sessionmodeiszombiesgame() )
            {
                if (level.allow_teamchange)
                {
                    if (assignment == "")
                    {
                        guids = strTok(getDvar("team_axis"), " ");
                        foreach (guid in guids)
                        {
                            if (self getguid() == int(guid))
                            {
                                assignment = "axis";
                                break;
                            }
                        }
                    }

                    if (assignment == "")
                    {
                        guids = strTok(getDvar("team_allies"), " ");
                        foreach (guid in guids)
                        {
                            if (self getguid() == int(guid))
                            {
                                assignment = "allies";
                                break;
                            }
                        }
                    }
                }

                if (assignment == "")
                {
                    assignment = get_lowest_team();
                }
            }
        }

        if ( assignment == self.pers["team"] && ( self.sessionstate == "playing" || self.sessionstate == "dead" ) )
        {
            self beginclasschoice();
            return;
        }
    }
    else if ( getdvarint( "party_autoteams" ) == 1 )
    {
        if ( level.allow_teamchange != "1" || !self.hasspawned && !comingfrommenu )
        {
            team = getassignedteam( self );

            if ( isdefined( level.teams[team] ) )
                assignment = team;
            else if ( team == "spectator" && !level.forceautoassign )
            {
                self setclientscriptmainmenu( game["menu_class"] );
                return;
            }
        }
    }

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

    self.joined_team = true;
    self notify( "joined_team" );
    level notify( "joined_team" );
    self notify( "end_respawn" );
    self beginclasschoice();
    self setclientscriptmainmenu( game["menu_class"] );
}

get_lowest_team()
{
	teamplayers = [];
	teamplayers["axis"] = countplayers("axis");
	teamplayers["allies"] = countplayers("allies");

	// don't count self
	teamplayers[self.team]--;

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