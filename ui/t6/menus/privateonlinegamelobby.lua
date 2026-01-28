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
