require("T6.HUD.InGameMenus")
CoD.EndGamePopup = {}
CoD.EndGamePopup.AddButton = function(f1_arg0, f1_arg1, f1_arg2)
	local f1_local0 = f1_arg0.buttonList:addButton(f1_arg1)
	f1_local0:setActionEventName(f1_arg2)
	return f1_local0
end

CoD.EndGamePopup.Close = function(f2_arg0, f2_arg1)
	f2_arg0:processEvent({
		name = "close_all_ingame_menus",
		controller = f2_arg1.controller,
	})
end

CoD.EndGamePopup.YesButtonPressed = function(f3_arg0, f3_arg1)
	if CoD.isZombie == true then
		Engine.SetDvar("cl_paused", 0)
	end
	if CoD.isZombie == false then
		if Engine.GameModeIsMode(CoD.GAMEMODE_LEAGUE_MATCH) and Engine.ProbationCheckForQuitWarning(CoD.GAMEMODE_LEAGUE_MATCH) then
			f3_arg0:openMenu("popup_probation_quit_warning", f3_arg1.controller)
			f3_arg0:close()
			return
		elseif Engine.GameModeIsMode(CoD.GAMEMODE_PUBLIC_MATCH) and Engine.ProbationCheckForQuitWarning(CoD.GAMEMODE_PUBLIC_MATCH) then
			f3_arg0:openMenu("popup_probation_quit_warning", f3_arg1.controller)
			f3_arg0:close()
			return
		end
	end
	CoD.EndGamePopup.Close(f3_arg0, f3_arg1)
	CoD.EndGamePopup.FinishEndGame(f3_arg0, f3_arg1)
end

CoD.EndGamePopup.FinishEndGame = function(f4_arg0, f4_arg1)
	if not CoD.isRankedGame() and CoD.isHost() then
		Engine.SendMenuResponse(f4_arg1.controller, "popup_leavegame", "endround")
	elseif not CoD.isHost() and UIExpression.InPrivateParty() == 1 and UIExpression.PrivatePartyHost() == 0 and UIExpression.PrivatePartyHostInLobby() == 1 then
		Engine.UpdateStatsForQuit(f4_arg1.controller, false)
		Engine.Exec(f4_arg1.controller, "disconnect")
		Engine.Exec(f4_arg1.controller, "xstopallparties")
		Engine.GameModeSetMode(CoD.GAMEMODE_PRIVATE_MATCH, false)
		Engine.SessionModeSetPrivate(false)
		Engine.Exec(f4_arg1.controller, "xstartprivateparty")
	elseif not CoD.isHost() and (CoD.isPartyHost() or UIExpression.PrivatePartyHostInLobby() == 0) then
		Engine.UpdateStatsForQuit(f4_arg1.controller, false)
		Engine.Exec(f4_arg1.controller, "disconnect")
	elseif CoD.isRankedGame() and CoD.isHost() and UIExpression.HostMigrationWaitingForPlayers(controller) == 0 and UIExpression.DvarInt(nil, "g_gameEnded") ~= 1 then
		if CoD.isZombie == true then
			Engine.UpdateStatsForQuit(f4_arg1.controller, true)
			if Engine.PartyGetPlayerCount() <= Dvar.migration_minclientcount:get() then
				Engine.SendMenuResponse(f4_arg1.controller, "popup_leavegame", "endround")
			else
				Engine.Exec(f4_arg1.controller, "hostmigration_start")
				Engine.Exec(f4_arg1.controller, "xpartydisbandafterround")
			end
		else
			Engine.UpdateStatsForQuit(f4_arg1.controller, true)
			Engine.Exec(f4_arg1.controller, "hostmigration_start")
			Engine.Exec(f4_arg1.controller, "xpartydisbandafterround")
		end
	end
end

CoD.EndGamePopup.NoButtonPressed = function(f5_arg0, f5_arg1)
	CoD.Menu.ButtonPromptBack(f5_arg0, f5_arg1)
end

CoD.EndGamePopup.AddTitleAndSubtitle = function(f6_arg0, f6_arg1, f6_arg2)
	if f6_arg1 ~= nil then
		local f6_local0 = LUI.UIText.new()
		f6_local0:setLeftRight(true, true, 0, 0)
		f6_local0:setTopBottom(true, false, 0, CoD.textSize.Big)
		f6_local0:setFont(CoD.fonts.Big)
		f6_local0:setAlignment(LUI.Alignment.Left)
		f6_local0:setText(f6_arg1)
		f6_arg0:addElement(f6_local0)
	end
	if f6_arg2 ~= nil then
		local f6_local0 = CoD.textSize.Big + 5
		local f6_local1 = LUI.UIText.new()
		f6_local1:setLeftRight(true, true, 0, 0)
		f6_local1:setTopBottom(true, false, f6_local0, f6_local0 + CoD.textSize.Default)
		f6_local1:setFont(CoD.fonts.Default)
		f6_local1:setAlignment(LUI.Alignment.Left)
		f6_local1:setText(f6_arg2)
		f6_arg0:addElement(f6_local1)
	end
end

LUI.createMenu.EndGamePopup = function(f7_arg0)
	local f7_local0 = CoD.Menu.NewSmallPopup("EndGamePopup")
	f7_local0:setOwner(f7_arg0)
	f7_local0:registerEventHandler("close_all_ingame_menus", CoD.InGameMenu.CloseAllInGameMenus)
	f7_local0:registerEventHandler("endGamePopup_YesButtonPressed", CoD.EndGamePopup.YesButtonPressed)
	f7_local0:registerEventHandler("endGamePopup_NoButtonPressed", CoD.EndGamePopup.NoButtonPressed)
	f7_local0:addSelectButton()
	f7_local0:addBackButton()
	f7_local0.backButtonPrompt = CoD.ButtonPrompt.new("select", "", f7_local0, "button_prompt_back", true)
	f7_local0.startButtonPrompt = CoD.ButtonPrompt.new("start", "", f7_local0, "button_prompt_back", true)
	f7_local0:addRightButtonPrompt(f7_local0.backButtonPrompt)
	f7_local0:addRightButtonPrompt(f7_local0.startButtonPrompt)
	local f7_local1 = "MENU_LEAVE_GAME_RANKED"
	if Engine.ProbationCheckIfPenalizedForQuit(f7_arg0) == true then
		f7_local1 = "MENU_LEAVE_GAME_RANKED_PROBATION"
	end
	if CoD.isZombie == true then
		f7_local1 = "ZOMBIE_LEAVE_GAME_RANKED"
	end
	if Engine.GameModeIsMode(CoD.GAMEMODE_LEAGUE_MATCH) == true then
		f7_local1 = "MENU_LEAVE_GAME_LEAGUES"
	end
	local f7_local2 = Engine.Localize("MENU_QUIT_GAME")
	local f7_local3 = nil
	if CoD.isRankedGame() then
		if CoD.isHost() then
			f7_local2 = Engine.Localize("MENU_QUIT_GAME")
		elseif UIExpression.InPrivateParty() == 1 and UIExpression.PrivatePartyHost() == 0 and UIExpression.PrivatePartyHostInLobby() == 1 then
			f7_local2 = Engine.Localize("MENU_LEAVE_GAME_AND_PARTY")
		else
			f7_local2 = Engine.Localize("MENU_QUIT_GAME")
		end
		f7_local3 = Engine.Localize(f7_local1)
	elseif CoD.isHost() then
		f7_local2 = Engine.Localize("MPUI_END_GAME2")
	elseif UIExpression.InPrivateParty() == 1 and UIExpression.PrivatePartyHost() == 0 and UIExpression.PrivatePartyHostInLobby() == 1 then
		f7_local2 = Engine.Localize("MENU_LEAVE_GAME_AND_PARTY")
	else
		f7_local2 = Engine.Localize("MENU_QUIT_GAME")
	end
	CoD.EndGamePopup.AddTitleAndSubtitle(f7_local0, f7_local2, f7_local3)
	f7_local0.buttonList = CoD.ButtonList.new({
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = false,
		bottomAnchor = true,
		top = -CoD.ButtonPrompt.Height - CoD.CoD9Button.Height * 3 + 10,
		bottom = 0,
	})
	local f7_local4 = CoD.EndGamePopup.AddButton(f7_local0, Engine.Localize("MENU_YES"), "endGamePopup_YesButtonPressed")
	local f7_local5 = CoD.EndGamePopup.AddButton(f7_local0, Engine.Localize("MENU_NO"), "endGamePopup_NoButtonPressed")
	f7_local5:processEvent({
		name = "gain_focus",
	})
	f7_local0:addElement(f7_local0.buttonList)
	return f7_local0
end
