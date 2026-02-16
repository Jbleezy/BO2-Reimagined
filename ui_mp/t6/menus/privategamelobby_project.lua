CoD.PrivateGameLobby.GameTypeSettings = {}
CoD.PrivateGameLobby.DvarDefaults = {}
CoD.PrivateGameLobby.DvarDefaults["character_dialog"] = 1
CoD.PrivateGameLobby.DvarDefaults["ui_gametype_pro"] = 0
CoD.PrivateGameLobby.Dvars = {}
CoD.PrivateGameLobby.Dvars[1] = {}
CoD.PrivateGameLobby.Dvars[1].id = "character_dialog"
CoD.PrivateGameLobby.Dvars[1].name = "ZMUI_CHARACTER_DIALOG_CAPS"
CoD.PrivateGameLobby.Dvars[1].hintText = "ZMUI_CHARACTER_DIALOG_DESC"
CoD.PrivateGameLobby.Dvars[1].labels = {}
CoD.PrivateGameLobby.Dvars[1].labels[1] = "MENU_ENABLED_CAPS"
CoD.PrivateGameLobby.Dvars[1].labels[2] = "MENU_DISABLED_CAPS"
CoD.PrivateGameLobby.Dvars[1].values = {}
CoD.PrivateGameLobby.Dvars[1].values[1] = 1
CoD.PrivateGameLobby.Dvars[1].values[2] = 0
CoD.PrivateGameLobby.Dvars[1].gameTypes = {}
CoD.PrivateGameLobby.Dvars[1].gameTypes[1] = "zclassic"
CoD.PrivateGameLobby.Dvars[2] = {}
CoD.PrivateGameLobby.Dvars[2].id = "ui_gametype_pro"
CoD.PrivateGameLobby.Dvars[2].name = "MPUI_PRO_CAPS"
CoD.PrivateGameLobby.Dvars[2].hintText = "ZMUI_PRO_DESC"
CoD.PrivateGameLobby.Dvars[2].labels = {}
CoD.PrivateGameLobby.Dvars[2].labels[1] = "MENU_DISABLED_CAPS"
CoD.PrivateGameLobby.Dvars[2].labels[2] = "MENU_ENABLED_CAPS"
CoD.PrivateGameLobby.Dvars[2].values = {}
CoD.PrivateGameLobby.Dvars[2].values[1] = 0
CoD.PrivateGameLobby.Dvars[2].values[2] = 1
CoD.PrivateGameLobby.Dvars[2].gameTypes = {}
CoD.PrivateGameLobby.Dvars[2].gameTypes[1] = "zsr"
CoD.PrivateGameLobby.Dvars[2].gameTypes[2] = "zgrief"
CoD.PrivateGameLobby.Dvars[2].gameTypes[3] = "zrace"
CoD.PrivateGameLobby.Dvars[2].gameTypes[4] = "zcontainment"
CoD.PrivateGameLobby.Dvars[2].gameTypes[5] = "zmeat"
CoD.PrivateGameLobby.Dvars[2].gameTypes[6] = "zturned"

CoD.PrivateGameLobby.ButtonPrompt_TeamPrev = function(f1_arg0, ClientInstance)
	if Engine.PartyHostIsReadyToStart() == true then
		return
	else
		Engine.LocalPlayerPartyPrevTeam(ClientInstance.controller)
		Engine.PlaySound("cac_loadout_edit_submenu")
	end
end

CoD.PrivateGameLobby.ButtonPrompt_TeamNext = function(f2_arg0, ClientInstance)
	if Engine.PartyHostIsReadyToStart() == true then
		return
	else
		Engine.LocalPlayerPartyNextTeam(ClientInstance.controller)
		Engine.PlaySound("cac_loadout_edit_submenu")
	end
end

CoD.PrivateGameLobby.ShouldEnableTeamCycling = function(PrivateGameLobbyWidget)
	if PrivateGameLobbyWidget.panelManager == nil then
		return false
	elseif not PrivateGameLobbyWidget.panelManager:isPanelOnscreen("lobbyPane") then
		return false
	elseif Engine.PartyIsReadyToStart() == true then
		return false
	elseif Engine.PartyHostIsReadyToStart() == true then
		return false
	elseif Engine.GetGametypeSetting("autoTeamBalance") == 1 and Engine.GetGametypeSetting("allowspectating") ~= 1 then
		return false
	else
		return true
	end
end

CoD.PrivateGameLobby.SetupTeamCycling = function(PrivateGameLobbyWidget)
	if CoD.PrivateGameLobby.ShouldEnableTeamCycling(PrivateGameLobbyWidget) then
		PrivateGameLobbyWidget.cycleTeamButtonPrompt:enable()
	else
		PrivateGameLobbyWidget.cycleTeamButtonPrompt:disable()
	end
end

CoD.PrivateGameLobby.CurrentPanelChanged = function(PrivateGameLobbyWidget, f5_arg1)
	CoD.Lobby.CurrentPanelChanged(PrivateGameLobbyWidget, f5_arg1)
	CoD.PrivateGameLobby.SetupTeamCycling(PrivateGameLobbyWidget)
end

CoD.PrivateGameLobby.ButtonPrompt_PartyUpdateStatus = function(PrivateGameLobbyWidget, f6_arg1)
	CoD.GameLobby.UpdateStatusText(PrivateGameLobbyWidget, f6_arg1)
	CoD.PrivateGameLobby.SetupTeamCycling(PrivateGameLobbyWidget)
	PrivateGameLobbyWidget:dispatchEventToChildren(f6_arg1)
end

CoD.PrivateGameLobby.DoesGametypeSupportBots = function(Gametype)
	return true
end

CoD.PrivateGameLobby.BotButton_Update = function(BotsButton)
	local Gametype = UIExpression.DvarString(nil, "ui_gameType")
	local EnemyBots = UIExpression.DvarInt(nil, "bot_enemies")
	BotsButton.starImage:setAlpha(0)
	if not CoD.IsGametypeTeamBased() then
		Engine.SetDvar("bot_friends", 0)
	end
	if CoD.IsGametypeTeamBased() and EnemyBots > 9 then
		Engine.SetDvar("bot_enemies", 9)
	end
	if CoD.PrivateGameLobby.DoesGametypeSupportBots(Gametype) then
		BotsButton.hintText = Engine.Localize("MENU_BOTS_HINT")
		BotsButton:enable()
		if UIExpression.DvarInt(nil, "bot_friends") ~= 0 or EnemyBots ~= 0 then
			BotsButton.starImage:setAlpha(1)
		end
	else
		BotsButton.hintText = Engine.Localize("MENU_BOTS_NOT_SUPPORTED_" .. Gametype)
		BotsButton:disable()
	end
end

CoD.PrivateGameLobby.PopulateButtons_Project_Multiplayer = function(PrivateGameLobbyButtonPane, IsHost)
	if IsHost == true then
		local SetupGameText = Engine.Localize("MPUI_SETUP_GAME_CAPS")
		local f9_local1_1, f9_local1_2, f9_local1_3, f9_local1_4 = GetTextDimensions(SetupGameText, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
		PrivateGameLobbyButtonPane.body.setupGameButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(SetupGameText)
		PrivateGameLobbyButtonPane.body.setupGameButton.hintText = Engine.Localize("MPUI_SETUP_GAME_DESC")
		PrivateGameLobbyButtonPane.body.setupGameButton:setActionEventName("open_setup_game_flyout")
		PrivateGameLobbyButtonPane.body.setupGameButton:registerEventHandler("button_update", CoD.PrivateGameLobby.Button_UpdateHostButton)
		if PrivateGameLobbyButtonPane.body.widestButtonTextWidth < f9_local1_3 then
			PrivateGameLobbyButtonPane.body.widestButtonTextWidth = f9_local1_3
		end
		local SetupBotsText = Engine.Localize("MENU_SETUP_BOTS_CAPS")
		local f9_local2_1, f9_local2_2, f9_local2_3, f9_local2_4 = GetTextDimensions(SetupBotsText, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
		PrivateGameLobbyButtonPane.body.botsButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(SetupBotsText)
		PrivateGameLobbyButtonPane.body.botsButton:setActionEventName("open_bots_menu")
		PrivateGameLobbyButtonPane.body.botsButton:registerEventHandler("gamelobby_update", CoD.PrivateGameLobby.BotButton_Update)
		if PrivateGameLobbyButtonPane.body.widestButtonTextWidth < f9_local2_3 then
			PrivateGameLobbyButtonPane.body.widestButtonTextWidth = f9_local2_3
		end
		local recImage = LUI.UIImage.new()
		recImage:setLeftRight(true, false, f9_local2_3 + 5, f9_local2_3 + 5 + 30)
		recImage:setTopBottom(false, false, -15, 15)
		recImage:setAlpha(0)
		recImage:setImage(RegisterMaterial(CoD.MPZM("ui_host", "ui_host_zm")))
		PrivateGameLobbyButtonPane.body.botsButton:addElement(recImage)
		PrivateGameLobbyButtonPane.body.botsButton.starImage = recImage
		CoD.PrivateGameLobby.BotButton_Update(PrivateGameLobbyButtonPane.body.botsButton)
		PrivateGameLobbyButtonPane.body.buttonList:addSpacer(CoD.CoD9Button.Height / 2)
	end
	local CreateAClassText = Engine.Localize("MENU_CREATE_A_CLASS_CAPS")
	local f9_local3_1, f9_local3_2, f9_local3_3, f9_local3_4 = GetTextDimensions(CreateAClassText, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
	PrivateGameLobbyButtonPane.body.createAClassButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(CreateAClassText)
	PrivateGameLobbyButtonPane.body.createAClassButton.id = "CoD9Button." .. "PrivateGameLobby." .. Engine.Localize("MENU_CREATE_A_CLASS_CAPS")
	CoD.CACUtility.SetupCACLock(PrivateGameLobbyButtonPane.body.createAClassButton)
	PrivateGameLobbyButtonPane.body.createAClassButton:registerEventHandler("button_action", CoD.GameLobby.Button_CAC)
	if PrivateGameLobbyButtonPane.body.widestButtonTextWidth < f9_local3_3 then
		PrivateGameLobbyButtonPane.body.widestButtonTextWidth = f9_local3_3
	end
	local ScorestreakText = Engine.Localize("MENU_SCORE_STREAKS_CAPS")
	local f9_local4_1, f9_local4_2, f9_local4_3, f9_local4_4 = GetTextDimensions(ScorestreakText, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
	PrivateGameLobbyButtonPane.body.rewardsButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(ScorestreakText)
	PrivateGameLobbyButtonPane.body.rewardsButton.id = "CoD9Button." .. "PrivateGameLobby." .. Engine.Localize("MENU_SCORE_STREAKS_CAPS")
	PrivateGameLobbyButtonPane.body.rewardsButton.hintText = Engine.Localize("FEATURE_KILLSTREAKS_DESC")
	CoD.SetupButtonLock(PrivateGameLobbyButtonPane.body.rewardsButton, nil, "FEATURE_KILLSTREAKS", "FEATURE_KILLSTREAKS_DESC")
	PrivateGameLobbyButtonPane.body.rewardsButton:registerEventHandler("button_action", CoD.GameLobby.Button_Rewards)
	if PrivateGameLobbyButtonPane.body.widestButtonTextWidth < f9_local4_3 then
		PrivateGameLobbyButtonPane.body.widestButtonTextWidth = f9_local4_3
	end
	PrivateGameLobbyButtonPane.body.barracksButtonSpacer = PrivateGameLobbyButtonPane.body.buttonList:addSpacer(CoD.CoD9Button.Height / 2)
	PrivateGameLobbyButtonPane.body.barracksButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(Engine.Localize("MENU_BARRACKS_CAPS"))
	PrivateGameLobbyButtonPane.body.barracksButton.id = "CoD9Button." .. "PrivateGameLobby." .. Engine.Localize("MENU_BARRACKS_CAPS")
	CoD.SetupBarracksLock(PrivateGameLobbyButtonPane.body.barracksButton)
	PrivateGameLobbyButtonPane.body.barracksButton:setActionEventName("open_barracks")
	PrivateGameLobbyButtonPane.body.buttonList:addSpacer(CoD.CoD9Button.Height / 4, 200)
	if IsHost and UIExpression.SessionMode_IsOnlineGame() == 1 then
		local ToggleDemoRecording = PrivateGameLobbyButtonPane.body.buttonList:addButton(Engine.Localize("CUSTOM_GAME_RECORDING_CAPS"))
		ToggleDemoRecording.hintText = Engine.Localize("CUSTOM_GAME_RECORDING_DESC")
		ToggleDemoRecording:registerEventHandler("button_action", CoD.PrivateGameLobby.DemoRecordingButton_ToggleDemoRecording)

		local recImage = LUI.UIImage.new()
		recImage:setLeftRight(false, true, -130, -100)
		recImage:setTopBottom(false, false, -15, 15)
		recImage:setAlpha(1)
		recImage:setImage(RegisterMaterial("codtv_recording"))

		local recText = LUI.UIText.new({
			leftAnchor = false,
			rightAnchor = true,
			left = -100,
			right = -40,
			topAnchor = false,
			bottomAnchor = false,
			top = -CoD.textSize.Condensed / 2,
			bottom = CoD.textSize.Condensed / 2,
			font = CoD.fonts.Condensed,
			alignment = LUI.Alignment.Left,
		})
		ToggleDemoRecording:addElement(recImage)
		ToggleDemoRecording.recImage = recImage

		ToggleDemoRecording:addElement(recText)
		ToggleDemoRecording.recText = recText

		CoD.PrivateGameLobby.UpdateDemoRecordingButton(ToggleDemoRecording)
	end
	if Engine.SessionModeIsMode(CoD.SESSIONMODE_SYSTEMLINK) == false and UIExpression.DvarBool(nil, "webm_encUiEnabledCustom") == 1 then
		CoD.Lobby.AddLivestreamButton(PrivateGameLobbyButtonPane, 10, IsHost)
	end
end

CoD.PrivateGameLobby.UpdateDemoRecordingButton = function(ToggleDemoRecording)
	if Dvar.demo_recordPrivateMatch:get() then
		ToggleDemoRecording.recImage:setRGB(1, 0, 0)
		ToggleDemoRecording.recText:setText(Engine.Localize("MENU_ON_CAPS"))
	else
		ToggleDemoRecording.recImage:setRGB(0.3, 0.3, 0.3)
		ToggleDemoRecording.recText:setText(Engine.Localize("MENU_OFF_CAPS"))
	end
end

CoD.PrivateGameLobby.DemoRecordingButton_ToggleDemoRecording = function(ToggleDemoRecording, f11_arg1)
	Dvar.demo_recordPrivateMatch:set(not Dvar.demo_recordPrivateMatch:get())
	CoD.PrivateGameLobby.UpdateDemoRecordingButton(ToggleDemoRecording)
end

CoD.PrivateGameLobby.PopulateFlyoutButtons_Project_Multiplayer = function(PrivateGameLobbyButtonPane)
	if not CoD.isZombie then
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeMapButton = PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.buttonList:addButton(Engine.Localize("MPUI_CHANGE_MAP_CAPS"))
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeMapButton.hintText = Engine.Localize("MPUI_CHANGE_MAP_DESC")
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeMapButton:setActionEventName("open_change_map")
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeMapButton:registerEventHandler("button_update", CoD.PrivateGameLobby.Button_UpdateHostButton)
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeGameModeButton = PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.buttonList:addButton(Engine.Localize("MPUI_CHANGE_GAME_MODE_CAPS"))
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeGameModeButton.hintText = Engine.Localize("MPUI_CHANGE_GAME_MODE_DESC")
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeGameModeButton:setActionEventName("open_change_game_mode")
		PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.changeGameModeButton:registerEventHandler("button_update", CoD.PrivateGameLobby.Button_UpdateHostButton)
	end
	PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.editGameOptionsButton = PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.buttonList:addButton(Engine.Localize("MPUI_EDIT_GAME_RULES_CAPS"))
	PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.editGameOptionsButton.hintText = Engine.Localize("MPUI_EDIT_GAME_RULES_DESC")
	PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.editGameOptionsButton:setActionEventName("open_editGameOptions_menu")
	PrivateGameLobbyButtonPane.body.setupGameFlyoutContainer.editGameOptionsButton:registerEventHandler("button_update", CoD.PrivateGameLobby.Button_UpdateHostButton)
end

local AddGameOptionsButtons = function(PrivateGameLobbyButtonPane, GameOptions, GameOptionsType)
	local Gametype = UIExpression.DvarString(nil, "ui_gameType")
	local f13_local1 = 220
	if Gametype == "zcleansed" then
		f13_local1 = 170
	end
	local Mapname = UIExpression.DvarString(nil, "ui_mapname")
	local GametypeIsValid = false
	local MapIsValid = false
	for GameOptionsIndex = 1, #GameOptions, 1 do
		GametypeIsValid = false
		if GameOptions[GameOptionsIndex].gameTypes ~= nil then
			for GametypeIndex = 1, #GameOptions[GameOptionsIndex].gameTypes, 1 do
				if GameOptions[GameOptionsIndex].gameTypes[GametypeIndex] == Gametype then
					GametypeIsValid = true
				end
			end
		else
			GametypeIsValid = true
		end
		if GameOptions[GameOptionsIndex].maps ~= nil then
			for MapIndex = 1, #GameOptions[GameOptionsIndex].maps, 1 do
				if GameOptions[GameOptionsIndex].maps[MapIndex] == Mapname then
					MapIsValid = true
					break
				end
			end
			if not MapIsValid then
				GametypeIsValid = false
			end
		end
		if GametypeIsValid then
			local GameOptionsButton = nil
			if GameOptionsType == "gts" then
				GameOptionsButton = PrivateGameLobbyButtonPane.body.buttonList:addGametypeSettingLeftRightSelector(PrivateGameLobbyButtonPane.panelManager.m_ownerController, Engine.Localize(GameOptions[GameOptionsIndex].name), GameOptions[GameOptionsIndex].id, Engine.Localize(GameOptions[GameOptionsIndex].hintText), f13_local1)
			elseif GameOptionsType == "dvar" then
				GameOptionsButton = PrivateGameLobbyButtonPane.body.buttonList:addDvarLeftRightSelector(PrivateGameLobbyButtonPane.panelManager.m_ownerController, Engine.Localize(GameOptions[GameOptionsIndex].name), GameOptions[GameOptionsIndex].id, Engine.Localize(GameOptions[GameOptionsIndex].hintText), f13_local1)
			end
			for LabelIndex = 1, #GameOptions[GameOptionsIndex].labels, 1 do
				GameOptionsButton:addChoice(PrivateGameLobbyButtonPane.panelManager.m_ownerController, Engine.Localize(GameOptions[GameOptionsIndex].labels[LabelIndex]), GameOptions[GameOptionsIndex].values[LabelIndex])
			end
			GameOptionsButton:registerEventHandler("gain_focus", CoD.PrivateGameLobby.ButtonGainFocusZombie)
			GameOptionsButton:registerEventHandler("lose_focus", CoD.PrivateGameLobby.ButtonLoseFocusZombie)
			GameOptionsButton:registerEventHandler("start_game", GameOptionsButton.disable)
			GameOptionsButton:registerEventHandler("cancel_start_game", GameOptionsButton.enable)
			GameOptionsButton:registerEventHandler("gamelobby_update", CoD.PrivateGameLobby.ButtonGameLobbyUpdate_Zombie)
		end
	end
end

CoD.PrivateGameLobby.PopulateButtons_Project_Zombie = function(PrivateGameLobbyButtonPane, IsHost)
	if IsHost == true then
		PrivateGameLobbyButtonPane.body.changeMapButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(Engine.Localize("MPUI_CHANGE_MAP_CAPS"))
		PrivateGameLobbyButtonPane.body.changeMapButton.hintText = Engine.Localize("MPUI_CHANGE_MAP_DESC")
		PrivateGameLobbyButtonPane.body.changeMapButton:setActionEventName("open_change_map")
		PrivateGameLobbyButtonPane.body.changeMapButton:registerEventHandler("button_update", CoD.PrivateGameLobby.Button_UpdateHostButton)
		PrivateGameLobbyButtonPane.body.changeGameModeButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(Engine.Localize("MPUI_CHANGE_GAME_MODE_CAPS"))
		PrivateGameLobbyButtonPane.body.changeGameModeButton.hintText = Engine.Localize("MPUI_CHANGE_GAME_MODE_DESC")
		PrivateGameLobbyButtonPane.body.changeGameModeButton:setActionEventName("open_change_game_mode")
		PrivateGameLobbyButtonPane.body.changeGameModeButton:registerEventHandler("button_update", CoD.PrivateGameLobby.Button_UpdateHostButton)
		PrivateGameLobbyButtonPane.body.buttonList:addSpacer(CoD.CoD9Button.Height * 1)
		-- local SetupGameText = Engine.Localize("MPUI_SETUP_GAME_CAPS")
		-- local f9_local1_1, f9_local1_2, f9_local1_3, f9_local1_4 = GetTextDimensions(SetupGameText, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
		-- PrivateGameLobbyButtonPane.body.setupGameButton = PrivateGameLobbyButtonPane.body.buttonList:addButton(SetupGameText)
		-- PrivateGameLobbyButtonPane.body.setupGameButton.hintText = Engine.Localize("MPUI_SETUP_GAME_DESC")
		-- PrivateGameLobbyButtonPane.body.setupGameButton:setActionEventName("open_setup_game_flyout")
		-- PrivateGameLobbyButtonPane.body.setupGameButton:registerEventHandler("button_update", CoD.PrivateGameLobby.Button_UpdateHostButton)
		-- if PrivateGameLobbyButtonPane.body.widestButtonTextWidth < f9_local1_3 then
		-- 	PrivateGameLobbyButtonPane.body.widestButtonTextWidth = f9_local1_3
		-- end
		AddGameOptionsButtons(PrivateGameLobbyButtonPane, CoD.PrivateGameLobby.GameTypeSettings, "gts")
		AddGameOptionsButtons(PrivateGameLobbyButtonPane, CoD.PrivateGameLobby.Dvars, "dvar")
		PrivateGameLobbyButtonPane:registerEventHandler("start_game", CoD.PrivateGameLobby.ButtonStartGame)
		PrivateGameLobbyButtonPane:registerEventHandler("enable_sliding_zm", CoD.PrivateGameLobby.EnableSlidingZombie)
		PrivateGameLobbyButtonPane.defaultFocusButton = PrivateGameLobbyButtonPane.body.startMatchButton
		PrivateGameLobbyButtonPane.body.buttonList.hintText:setAlpha(1)
		if CoD.useController == true and not PrivateGameLobbyButtonPane:restoreState() then
			PrivateGameLobbyButtonPane.body.buttonList:selectElementIndex(1)
		end
		-- local ToggleDemoRecording = PrivateGameLobbyButtonPane.body.buttonList:addButton(Engine.Localize("CUSTOM_GAME_RECORDING_CAPS"))
		-- ToggleDemoRecording.hintText = Engine.Localize("CUSTOM_GAME_RECORDING_DESC")
		-- ToggleDemoRecording:registerEventHandler("button_action", CoD.PrivateGameLobby.DemoRecordingButton_ToggleDemoRecording)
		-- local recImage = LUI.UIImage.new()
		-- recImage:setLeftRight(false, true, -130, -100)
		-- recImage:setTopBottom(false, false, -15, 15)
		-- recImage:setAlpha(1)
		-- recImage:setImage(RegisterMaterial("codtv_recording"))
		-- local recText = LUI.UIText.new({
		-- 	leftAnchor = false,
		-- 	rightAnchor = true,
		-- 	left = -100,
		-- 	right = -40,
		-- 	topAnchor = false,
		-- 	bottomAnchor = false,
		-- 	top = -CoD.textSize.Condensed / 2,
		-- 	bottom = CoD.textSize.Condensed / 2,
		-- 	font = CoD.fonts.Condensed,
		-- 	alignment = LUI.Alignment.Left
		-- })
		-- ToggleDemoRecording:addElement(recImage)
		-- ToggleDemoRecording.recImage = recImage
		-- ToggleDemoRecording:addElement(recText)
		-- ToggleDemoRecording.recText = recText
		-- CoD.PrivateGameLobby.UpdateDemoRecordingButton(ToggleDemoRecording)
	else
		PrivateGameLobbyButtonPane.defaultFocusButton = nil
		PrivateGameLobbyButtonPane.body.buttonList.hintText:setAlpha(0)
	end
	if PrivateGameLobbyButtonPane.menuName ~= "TheaterLobby" then
		CoD.GameGlobeZombie.MoveToUpDirectly()
	end
end

CoD.PrivateGameLobby.ButtonStartGame = function(PrivateGameLobbyButtonPane, ClientInstance)
	Engine.Exec(ClientInstance.controller, "xpartygo")
end

CoD.PrivateGameLobby.ButtonGameLobbyUpdate_Zombie = function(GametypeSettingButton, f14_arg1)
	GametypeSettingButton:refreshChoice()
	GametypeSettingButton:dispatchEventToChildren(f14_arg1)
end

CoD.PrivateGameLobby.ButtonGainFocusZombie = function(GametypeSettingButton, ClientInstance)
	CoD.CoD9Button.GainFocus(GametypeSettingButton, ClientInstance)
	GametypeSettingButton:dispatchEventToParent({
		name = "enable_sliding_zm",
		enableSliding = false,
		controller = ClientInstance.controller,
	})
end

CoD.PrivateGameLobby.ButtonLoseFocusZombie = function(GametypeSettingButton, ClientInstance)
	CoD.CoD9Button.LoseFocus(GametypeSettingButton, ClientInstance)
	GametypeSettingButton:dispatchEventToParent({
		name = "enable_sliding_zm",
		enableSliding = true,
		controller = ClientInstance.controller,
	})
end

CoD.PrivateGameLobby.EnableSlidingZombie = function(f17_arg0, f17_arg1)
	f17_arg0.panelManager.slidingEnabled = f17_arg1.enableSliding
end

CoD.PrivateGameLobby.PopulateButtons_Project = function(PrivateGameLobbyButtonPane, IsHost)
	if CoD.isZombie == true then
		CoD.PrivateGameLobby.PopulateButtons_Project_Zombie(PrivateGameLobbyButtonPane, IsHost)
	else
		CoD.PrivateGameLobby.PopulateButtons_Project_Multiplayer(PrivateGameLobbyButtonPane, IsHost)
	end
end

local LobbyTeamChangeAllowed = function()
	if Engine.GetGametypeSetting("allowSpectating") == 1 then
		return true
	elseif Engine.GetGametypeSetting("autoTeamBalance") == 1 then
		return false
	elseif CoD.IsGametypeTeamBased() == true then
		if CoD.isZombie == true and Engine.GetGametypeSetting("teamCount") == 1 then
			return false
		else
			return true
		end
	else
		return false
	end
end

CoD.PrivateGameLobby.PopulateButtonPrompts_Project = function(PrivateGameLobbyWidget)
	if PrivateGameLobbyWidget.cycleTeamButtonPrompt ~= nil then
		PrivateGameLobbyWidget.cycleTeamButtonPrompt:close()
	end
	if LobbyTeamChangeAllowed() then
		PrivateGameLobbyWidget.cycleTeamButtonPrompt = CoD.DualButtonPrompt.new("shoulderl", Engine.Localize("MPUI_CHANGE_ROLE"), "shoulderr", PrivateGameLobbyWidget, "button_prompt_team_prev", "button_prompt_team_next", false, nil, nil, nil, nil, "A", "D")
		CoD.PrivateGameLobby.SetupTeamCycling(PrivateGameLobbyWidget)
		PrivateGameLobbyWidget:addRightButtonPrompt(PrivateGameLobbyWidget.cycleTeamButtonPrompt)
		PrivateGameLobbyWidget:registerEventHandler("button_prompt_team_prev", CoD.PrivateGameLobby.ButtonPrompt_TeamPrev)
		PrivateGameLobbyWidget:registerEventHandler("button_prompt_team_next", CoD.PrivateGameLobby.ButtonPrompt_TeamNext)
		PrivateGameLobbyWidget:registerEventHandler("current_panel_changed", CoD.PrivateGameLobby.CurrentPanelChanged)
		PrivateGameLobbyWidget:registerEventHandler("party_update_status", CoD.PrivateGameLobby.ButtonPrompt_PartyUpdateStatus)
	else
		PrivateGameLobbyWidget:registerEventHandler("party_update_status", CoD.GameLobby.UpdateStatusText)
	end
end

CoD.PrivateGameLobby.LeaveLobby_Project_Multiplayer = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.SetDvar("invite_visible", 1)
	Engine.SetGametype(Dvar.ui_gametype:get())
	if Engine.SessionModeIsMode(CoD.SESSIONMODE_OFFLINE) == true or Engine.SessionModeIsMode(CoD.SESSIONMODE_SYSTEMLINK) == true then
		Engine.ExecNow(ClientInstance.controller, "xstopallparties")
		CoD.resetGameModes()
	elseif Engine.SessionModeIsMode(CoD.SESSIONMODE_PRIVATE) == true then
		if UIExpression.PrivatePartyHost(ClientInstance.controller) == 0 or ClientInstance.name ~= nil and ClientInstance.name == "confirm_leave_alone" then
			Engine.ExecNow(ClientInstance.controller, "xstopallparties")
		else
			Engine.ExecNow(ClientInstance.controller, "xstoppartykeeptogether")
		end
		CoD.resetGameModes()
		CoD.StartMainLobby(ClientInstance.controller)
	elseif Engine.IsSignedInToDemonware(ClientInstance.controller) == true and Engine.HasMPPrivileges(ClientInstance.controller) == true then
		Engine.ExecNow(ClientInstance.controller, "xstoppartykeeptogether")
		CoD.resetGameModes()
		CoD.StartMainLobby(ClientInstance.controller)
	else
		Engine.ExecNow(ClientInstance.controller, "xstopprivateparty")
		CoD.resetGameModes()
	end
	Engine.SessionModeSetPrivate(false)
	PrivateGameLobbyWidget:processEvent({
		name = "lose_host",
	})
	PrivateGameLobbyWidget:goBack(ClientInstance)
end

CoD.PrivateGameLobby.LeaveLobby_Project_Zombie_After_Animation = function(PrivateGameLobbyWidget, ClientInstance)
	CoD.PrivateGameLobby.LeaveLobby_Project_Multiplayer(PrivateGameLobbyWidget, {
		name = PrivateGameLobbyWidget.leaveType,
		controller = ClientInstance.controller,
	})
	PrivateGameLobbyWidget.leaveType = nil
end

CoD.PrivateGameLobby.LeaveLobby_Project_Zombie = function(PrivateGameLobbyWidget, ClientInstance)
	PrivateGameLobbyWidget.leaveType = ClientInstance.name
	CoD.GameGlobeZombie.gameGlobe.currentMenu = PrivateGameLobbyWidget
	if PrivateGameLobbyWidget.menuName == "TheaterLobby" then
		CoD.GameGlobeZombie.MoveToCornerFromUp(ClientInstance.controller, false)
	else
		CoD.GameGlobeZombie.MoveToCornerFromUp(ClientInstance.controller)
	end
	CoD.PrivateGameLobby.LeaveLobby_Project_Zombie_After_Animation(PrivateGameLobbyWidget, ClientInstance)
end

CoD.PrivateGameLobby.LeaveLobby_Project = function(PrivateGameLobbyWidget, ClientInstance)
	if CoD.isZombie == true then
		CoD.PrivateGameLobby.LeaveLobby_Project_Zombie(PrivateGameLobbyWidget, ClientInstance)
	else
		CoD.PrivateGameLobby.LeaveLobby_Project_Multiplayer(PrivateGameLobbyWidget, ClientInstance)
	end
end

CoD.PrivateGameLobby.OpenChangeStartLoc = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_GAMETYPE)
	local f27_local0 = PrivateGameLobbyWidget:openMenu("SelectStartLocZM", ClientInstance.controller)
	f27_local0:setPreviousMenu("SelectMapZM")
	CoD.SelectStartLocZombie.GoToPreChoices(f27_local0, ClientInstance)
	PrivateGameLobbyWidget:close()
end

CoD.PrivateGameLobby.OpenChangeMapZM = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_MAP)
	PrivateGameLobbyWidget:openPopup("SelectMapListZM", ClientInstance.controller)
end

CoD.PrivateGameLobby.OpenChangeGameModeZM = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_GAMETYPE)
	PrivateGameLobbyWidget:openPopup("SelectGameModeListZM", ClientInstance.controller)
end

CoD.PrivateGameLobby.OpenSetupGameFlyout = function(PrivateGameLobbyWidget, f28_arg1)
	if PrivateGameLobbyWidget.buttonPane ~= nil and PrivateGameLobbyWidget.buttonPane.body ~= nil then
		CoD.PrivateGameLobby.RemoveSetupGameFlyout(PrivateGameLobbyWidget.buttonPane)
		CoD.PrivateGameLobby.AddSetupGameFlyout(PrivateGameLobbyWidget.buttonPane)
		PrivateGameLobbyWidget.panelManager.slidingEnabled = false
		CoD.ButtonList.DisableInput(PrivateGameLobbyWidget.buttonPane.body.buttonList)
		PrivateGameLobbyWidget.buttonPane.body.buttonList:animateToState("disabled")
		PrivateGameLobbyWidget.buttonPane.body.setupGameFlyoutContainer:processEvent({
			name = "gain_focus",
		})
		PrivateGameLobbyWidget:registerEventHandler("button_prompt_back", CoD.PrivateGameLobby.CloseSetupGameFlyout)
	end
end

CoD.PrivateGameLobby.CloseSetupGameFlyout = function(PrivateGameLobbyWidget, f29_arg1)
	if PrivateGameLobbyWidget.buttonPane ~= nil and PrivateGameLobbyWidget.buttonPane.body ~= nil and PrivateGameLobbyWidget.buttonPane.body.setupGameFlyoutContainer ~= nil then
		CoD.PrivateGameLobby.RemoveSetupGameFlyout(PrivateGameLobbyWidget.buttonPane)
		CoD.ButtonList.EnableInput(PrivateGameLobbyWidget.buttonPane.body.buttonList)
		PrivateGameLobbyWidget.buttonPane.body.buttonList:animateToState("default")
		PrivateGameLobbyWidget:registerEventHandler("button_prompt_back", CoD.PrivateGameLobby.ButtonBack)
		PrivateGameLobbyWidget.panelManager.slidingEnabled = true
		Engine.PlaySound("cac_cmn_backout")
	end
end

CoD.PrivateGameLobby.OpenBotsMenu = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_EDITING_GAME_OPTIONS)
	PrivateGameLobbyWidget:openPopup("EditBotOptions", ClientInstance.controller)
	Engine.PlaySound("cac_screen_fade")
end

CoD.PrivateGameLobby.OpenChangeMap = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_MAP)
	PrivateGameLobbyWidget:openPopup("ChangeMap", ClientInstance.controller)
	Engine.PlaySound("cac_screen_fade")
end

CoD.PrivateGameLobby.OpenChangeGameMode = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_GAMETYPE)
	PrivateGameLobbyWidget:openPopup("ChangeGameMode", ClientInstance.controller)
	Engine.PlaySound("cac_screen_fade")
end

CoD.PrivateGameLobby.OpenEditGameOptionsMenu = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_EDITING_GAME_OPTIONS)
	PrivateGameLobbyWidget:openPopup("EditGameOptions", ClientInstance.controller)
	Engine.PlaySound("cac_screen_fade")
end

CoD.PrivateGameLobby.OpenViewGameOptionsMenu = function(PrivateGameLobbyWidget, ClientInstance)
	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_EDITING_GAME_OPTIONS)
	PrivateGameLobbyWidget:openPopup("ViewGameOptions", ClientInstance.controller)
end

CoD.PrivateGameLobby.CloseAllPopups = function(PrivateGameLobbyWidget, ClientInstance)
	CoD.PrivateGameLobby.CloseSetupGameFlyout(PrivateGameLobbyWidget, ClientInstance)
	CoD.Menu.MenuChanged(PrivateGameLobbyWidget, ClientInstance)
end

CoD.PrivateGameLobby.RegisterEventHandler_Project = function(PrivateGameLobbyWidget)
	if CoD.isZombie == true then
		PrivateGameLobbyWidget:registerEventHandler("open_change_startLoc", CoD.PrivateGameLobby.OpenChangeStartLoc)
		PrivateGameLobbyWidget:registerEventHandler("open_setup_game_flyout", CoD.PrivateGameLobby.OpenSetupGameFlyout)
		PrivateGameLobbyWidget:registerEventHandler("open_change_map", CoD.PrivateGameLobby.OpenChangeMapZM)
		PrivateGameLobbyWidget:registerEventHandler("open_change_game_mode", CoD.PrivateGameLobby.OpenChangeGameModeZM)
		PrivateGameLobbyWidget:registerEventHandler("open_editGameOptions_menu", CoD.PrivateGameLobby.OpenEditGameOptionsMenu)
		PrivateGameLobbyWidget:registerEventHandler("open_viewGameOptions_menu", CoD.PrivateGameLobby.OpenViewGameOptionsMenu)
	else
		PrivateGameLobbyWidget:registerEventHandler("open_setup_game_flyout", CoD.PrivateGameLobby.OpenSetupGameFlyout)
		PrivateGameLobbyWidget:registerEventHandler("open_bots_menu", CoD.PrivateGameLobby.OpenBotsMenu)
		PrivateGameLobbyWidget:registerEventHandler("open_change_map", CoD.PrivateGameLobby.OpenChangeMap)
		PrivateGameLobbyWidget:registerEventHandler("open_change_game_mode", CoD.PrivateGameLobby.OpenChangeGameMode)
		PrivateGameLobbyWidget:registerEventHandler("open_editGameOptions_menu", CoD.PrivateGameLobby.OpenEditGameOptionsMenu)
		PrivateGameLobbyWidget:registerEventHandler("open_viewGameOptions_menu", CoD.PrivateGameLobby.OpenViewGameOptionsMenu)
		PrivateGameLobbyWidget:registerEventHandler("close_all_popups", CoD.PrivateGameLobby.CloseAllPopups)
	end
end
