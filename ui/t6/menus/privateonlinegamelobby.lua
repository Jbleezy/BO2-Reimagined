require("T6.Menus.PrivateGameLobby")
CoD.PrivateOnlineGameLobby = {}
LUI.createMenu.PrivateOnlineGameLobby = function(f1_arg0)
	local f1_local0 = CoD.PrivateGameLobby.New("PrivateOnlineGameLobby", f1_arg0)

	if CoD.isMultiplayer then
		f1_local0:setPreviousMenu("MainLobby")
	end

	local f1_local1 = Engine.Localize("MPUI_CUSTOM_GAMES_CAPS")

	if CoD.isZombie and UIExpression.DvarBool(nil, "party_solo") == 1 then
		f1_local1 = Engine.Localize("ZMUI_SOLO_PLAY_CAPS")
	end

	f1_local0:addTitle(f1_local1)
	f1_local0.panelManager.panels.buttonPane.titleText = f1_local1

	if UIExpression.DvarString(nil, "ui_gametype_pro_lobby") ~= "" then
		Engine.SetDvar("ui_gametype_pro", UIExpression.DvarString(nil, "ui_gametype_pro_lobby"))
		Engine.SetDvar("ui_gametype_pro_lobby", "")
	end

	if UIExpression.DvarBool(nil, "party_solo") == 1 then
		Engine.PartySetMaxPlayerCount(1)

		if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") == "zencounter" then
			Engine.SetDvar("ui_zm_gamemodegroup", "zsurvival")
			Engine.SetDvar("ui_gametype", "zstandard")
			Engine.SetProfileVar(f1_arg0, CoD.profileKey_gametype, "zstandard")
			Engine.CommitProfileChanges(f1_arg0)
		end
	end

	return f1_local0
end

CoD.PrivateGameLobby.PopulateButtonPrompts = function(PrivateGameLobbyWidget)
	if PrivateGameLobbyWidget.friendsButton ~= nil then
		PrivateGameLobbyWidget.friendsButton:close()
		PrivateGameLobbyWidget.friendsButton = nil
	end

	if PrivateGameLobbyWidget.partyPrivacyButton ~= nil then
		PrivateGameLobbyWidget.partyPrivacyButton:close()
		PrivateGameLobbyWidget.partyPrivacyButton = nil
	end

	if UIExpression.SessionMode_IsSystemlinkGame() == 0 and Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
		PrivateGameLobbyWidget:addFriendsButton()
	end

	if Engine.GameModeIsMode(CoD.GAMEMODE_THEATER) == false then
		CoD.PrivateGameLobby.PopulateButtonPrompts_Project(PrivateGameLobbyWidget)
	end

	if UIExpression.SessionMode_IsSystemlinkGame() == 0 then
		if UIExpression.DvarBool(nil, "party_solo") == 0 then
			PrivateGameLobbyWidget:addPartyPrivacyButton()
		end

		PrivateGameLobbyWidget:addNATType()
	end
end

CoD.PrivateGameLobby.ShouldDisableStartButton_Zombie = function(StartMatchButton, ClientInstance)
	local DisableStartButton = false
	local GamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
	local Gametype = UIExpression.DvarString(nil, "ui_gametype")
	local PartyPlayerCount = Engine.PartyGetPlayerCount()

	if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == true and PartyPlayerCount > 2 then
		if true == Dvar.r_dualPlayEnable:get() then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_DUALVIEW_DISABLED_DESC", CoD.Zombie.GameTypeGroups[Gametype].maxPlayers)
		elseif true == Dvar.r_stereo3DOn:get() then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_STEREOSCOPIC3D_DISABLED_DESC", CoD.Zombie.GameTypeGroups[Gametype].maxPlayers)
		else
			StartMatchButton.hintText = Engine.Localize("MPUI_START_MATCH_DESC")
		end

		if DisableStartButton == true then
			return DisableStartButton
		end
	end

	if Engine.GetGametypeSetting("teamCount") > 1 then
		local PartyTeamAlliesCount = Engine.PartyGetTeamMemberCount(CoD.TEAM_ALLIES)
		local PartyTeamAxisCount = Engine.PartyGetTeamMemberCount(CoD.TEAM_AXIS)

		if PartyTeamAlliesCount > CoD.Zombie.GameTypeGroups[Gametype].maxTeamPlayers or PartyTeamAxisCount > CoD.Zombie.GameTypeGroups[Gametype].maxTeamPlayers then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MAX_TEAM_PLAYERS_DESC", CoD.Zombie.GameTypeGroups[Gametype].maxTeamPlayers)
		elseif PartyTeamAlliesCount < CoD.Zombie.GameTypeGroups[Gametype].minTeamPlayers or PartyTeamAxisCount < CoD.Zombie.GameTypeGroups[Gametype].minTeamPlayers then
			DisableStartButton = true
			StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MIN_TEAM_PLAYERS_DESC")
		else
			StartMatchButton.hintText = Engine.Localize("MPUI_START_MATCH_DESC")
		end
	elseif PartyPlayerCount > CoD.Zombie.GameTypeGroups[Gametype].maxPlayers then
		DisableStartButton = true
		StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MAX_TOTAL_PLAYERS_DESC", CoD.Zombie.GameTypeGroups[Gametype].maxPlayers)
	elseif PartyPlayerCount < CoD.Zombie.GameTypeGroups[Gametype].minPlayers then
		DisableStartButton = true
		StartMatchButton.hintText = Engine.Localize("ZMUI_START_MATCH_MIN_TOTAL_PLAYERS_DESC", CoD.Zombie.GameTypeGroups[Gametype].minPlayers)
	else
		StartMatchButton.hintText = Engine.Localize("MPUI_START_MATCH_DESC")
	end

	return DisableStartButton
end
