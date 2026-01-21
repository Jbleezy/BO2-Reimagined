local SCOREBOARD_BACKGROUND_OPACITY = 0.7
local SCOREBOARD_COLUMN_BACKGROUND_OPACITY = 0.2
local f0_local6 = 337
local f0_local7 = 66
local ScoreboardWidgetCreateTeamElement = nil
local SCOREBOARD_FACTION_ICON_OPACITY = 0.3
local f0_local10 = 32
local SCOREBOARD_TIMER_FONT = "Condensed"
local SCOREBOARD_DEFAULT_MAX_COLUMNS = 5
local f0_local14 = 0
local SCOREBOARD_PING_BARS = {}
local f0_local16 = 232
local SCOREBOARD_ROW_SELECTED = {
	name = "row_selected",
}
local ScoreboardWidgetRowSelectorFunc = nil
local f0_local24 = 27
local f0_local25 = 18
local f0_local26 = f0_local24
local f0_local27 = -35
local SCOREBOARD_COLUMN_FONT = "ExtraSmall"
local f0_local29 = f0_local24
local f0_local30 = 190 - f0_local24
local f0_local31 = 2
local f0_local32 = 4
local ScoreboardUpdateTeamElement, ScoreboardWidgetShowGamercardFunc = nil, nil
local f0_local36 = 460
local ScoreboardWidgetToggleMuteFunc, f0_local38, ScoreboardWidgetUpdateFunc = nil, nil, nil
local f0_local40 = CoD.MPZM(0, 4 * f0_local29)
local f0_local41 = f0_local40
local SCOREBOARD_MAX_ROWS = CoD.MPZM(23, 18)
local IsDLCMap2, IsDLCMap4, IsClassic = nil, nil, nil

CoD.ScoreboardRow = InheritFrom(LUI.UIElement)

local ScoreboardWidgetSetOwnerFunc = function(ScoreboardWidget, LocalClientIndex)
	ScoreboardWidget.m_ownerController = LocalClientIndex
end

local ScoreboardWidgetGetOwnerFunc = function(ScoreboardWidget)
	return ScoreboardWidget.m_ownerController
end

local ZombiesCleansedScoreboardCheck = function(ScoreboardColumnName)
	if Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED and ScoreboardColumnName == "MPUI_DOWNS" then
		return "MPUI_RETURNS"
	else
		return ScoreboardColumnName
	end
end

local CreateScoreboardHeaderTitle = function(ScoreboardWidget)
	local HeaderTitle = nil
	if ScoreboardWidget.mode == "theater" then
		HeaderTitle = Engine.Localize("MENU_THEATER_PARTY")
	else
		local Mapname, Gametype = nil, nil
		if ScoreboardWidget.frontEndOnly then
			local AARScoreboardTable = Engine.GetAARScoreboard(ScoreboardWidget.m_ownerController)
			Gametype = AARScoreboardTable.gametype
			Mapname = AARScoreboardTable.mapName
		else
			Gametype = Dvar.ui_gametype:get()
			Mapname = Dvar.ui_mapname:get()
		end
		local StringTable = {}
		if not ScoreboardWidget.frontEndOnly then
			if CoD.isZombie == true then
				StringTable[1] = GetGameModeDisplayName()
				StringTable[2] = " - "
				StringTable[3] = GetMapDisplayName()

				if UIExpression.DvarString(nil, "ui_gametype") == "zsr" then
					StringTable[4] = " - "
					StringTable[5] = Engine.Localize("MPUI_ROUND_X", UIExpression.DvarString(nil, "ui_round_number"))
				end
			else
				StringTable[1] = Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 0, 1, Gametype, 7))
				StringTable[2] = " - "
				StringTable[3] = Engine.Localize(UIExpression.TableLookup(nil, CoD.mapsTable, 0, Mapname, 3))
			end
			local RoundLimit = Engine.GetGametypeSetting("roundLimit")
			local RoundPlayed = Engine.GetRoundsPlayed(ScoreboardWidget.m_ownerController)
			if RoundPlayed ~= nil and RoundLimit ~= 1 then
				table.insert(StringTable, " - ")
				if CoD.IsInOvertime(ScoreboardWidget.m_ownerController) then
					table.insert(StringTable, Engine.Localize("MP_OVERTIME"))
				elseif RoundLimit == 0 then
					table.insert(StringTable, Engine.Localize("MPUI_ROUND_X", RoundPlayed + 1))
				else
					table.insert(StringTable, Engine.Localize("MPUI_ROUND_X_OF_Y", RoundPlayed + 1, RoundLimit))
				end
			end
		end
		HeaderTitle = table.concat(StringTable)
	end
	return HeaderTitle
end

function GetGameModeDisplayName()
	if UIExpression.DvarString(nil, "ui_gametype") == "zclassic" then
		return Engine.Localize("ZMUI_ZCLASSIC_GAMEMODE")
	end

	if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") == "zencounter" and UIExpression.DvarBool(nil, "ui_gametype_pro") == 1 then
		return Engine.Localize("ZMUI_" .. UIExpression.DvarString(nil, "ui_gametype") .. "_PRO")
	end

	return Engine.Localize("ZMUI_" .. UIExpression.DvarString(nil, "ui_gametype"))
end

function GetMapDisplayName()
	if UIExpression.DvarString(nil, "ui_gametype") ~= "zclassic" then
		return GetLocationDisplayName()
	end

	if UIExpression.DvarString(nil, "ui_mapname") == "zm_transit" then
		return Engine.Localize("ZMUI_ZCLASSIC")
	end

	return Engine.Localize("ZMUI_ZCLASSIC_" .. UIExpression.DvarString(nil, "ui_mapname"))
end

function GetLocationDisplayName()
	if UIExpression.DvarString(nil, "ui_zm_mapstartlocation") == "transit" then
		return Engine.Localize("ZMUI_TRANSIT_STARTLOC")
	elseif UIExpression.DvarString(nil, "ui_zm_mapstartlocation") == "nuked" then
		return Engine.Localize("ZMUI_NUKED_STARTLOC")
	elseif UIExpression.DvarString(nil, "ui_zm_mapstartlocation") == "street" then
		return Engine.Localize("ZMUI_STREET_LOC")
	end

	return Engine.Localize("ZMUI_" .. UIExpression.DvarString(nil, "ui_zm_mapstartlocation"))
end

function CreateScoreBoardBody(ScoreboardWidget, LocalClientIndex, UnusedArg1)
	ScoreboardWidget.m_ownerController = LocalClientIndex
	ScoreboardWidget.setOwner = ScoreboardWidgetSetOwnerFunc
	ScoreboardWidget.getOwner = ScoreboardWidgetGetOwnerFunc
	ScoreboardWidget:setOwner(LocalClientIndex)
	ScoreboardWidget.frontEndOnly = UnusedArg1
	ScoreboardWidget.mode = "game"
	SCOREBOARD_PING_BARS[1] = RegisterMaterial("ping_bar_01")
	SCOREBOARD_PING_BARS[2] = RegisterMaterial("ping_bar_02")
	SCOREBOARD_PING_BARS[3] = RegisterMaterial("ping_bar_03")
	SCOREBOARD_PING_BARS[4] = RegisterMaterial("ping_bar_04")
	ScoreboardWidget.scoreboardContainer = CoD.SplitscreenScaler.new({
		rightAnchor = true,
		leftAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = 0,
	}, 1.35)
	ScoreboardWidget:addElement(ScoreboardWidget.scoreboardContainer)
	if not UnusedArg1 then
		ScoreboardWidget.leftButtonPromptBar:close()
		ScoreboardWidget.rightButtonPromptBar:close()
		ScoreboardWidget.scoreboardContainer:addElement(ScoreboardWidget.leftButtonPromptBar)
		ScoreboardWidget.scoreboardContainer:addElement(ScoreboardWidget.rightButtonPromptBar)
	end
	local ScoreboardContainerWidget = LUI.UIElement.new()
	ScoreboardContainerWidget:setLeftRight(true, true, 0, 0)
	ScoreboardContainerWidget:setTopBottom(true, false, 0, f0_local10)
	ScoreboardWidget.scoreboardContainer:addElement(ScoreboardContainerWidget)
	local ScoreboardBackground = LUI.UIImage.new()
	ScoreboardBackground:setLeftRight(true, true, 0, 0)
	ScoreboardBackground:setTopBottom(true, true, 0, 0)
	ScoreboardBackground:setRGB(0, 0, 0)
	ScoreboardBackground:setAlpha(SCOREBOARD_BACKGROUND_OPACITY)
	ScoreboardContainerWidget:addElement(ScoreboardBackground)
	local f5_local2 = LUI.UIImage.new()
	f5_local2:setLeftRight(true, true, 2, -2)
	f5_local2:setTopBottom(true, false, 2, 7)
	f5_local2:setImage(RegisterMaterial("white"))
	f5_local2:setAlpha(0.06)
	ScoreboardContainerWidget:addElement(f5_local2)
	if not UnusedArg1 then
		local ScoreboardGameTimer = CoD.GameTimer.new()
		ScoreboardGameTimer:setLeftRight(true, false, 10, 10)
		ScoreboardGameTimer:setTopBottom(false, false, -CoD.textSize[SCOREBOARD_TIMER_FONT] / 2, CoD.textSize[SCOREBOARD_TIMER_FONT] / 2)
		ScoreboardGameTimer:setFont(CoD.fonts[SCOREBOARD_TIMER_FONT])
		ScoreboardContainerWidget:addElement(ScoreboardGameTimer)
		ScoreboardWidget.gameTimer = ScoreboardGameTimer
	end
	local f5_local5 = f0_local30 + f0_local6
	local headerTitle = LUI.UIText.new()
	headerTitle:setLeftRight(true, false, 5, f5_local5)
	headerTitle:setTopBottom(false, false, -CoD.textSize.Default / 2, CoD.textSize.Default / 2)
	headerTitle:setFont(CoD.fonts.Default)
	-- headerTitle:setAlignment(LUI.Alignment.Center)
	headerTitle:setText(CreateScoreboardHeaderTitle(ScoreboardWidget))
	headerTitle:setRGB(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b)
	ScoreboardContainerWidget:addElement(headerTitle)
	ScoreboardWidget.headerTitle = headerTitle

	local columnHeaderContainer = LUI.UIContainer.new()
	ScoreboardContainerWidget:addElement(columnHeaderContainer)
	ScoreboardWidget.columnHeaderContainer = columnHeaderContainer

	local MaxColumns = SCOREBOARD_DEFAULT_MAX_COLUMNS
	for ScoreboardColumnIndex = 0, MaxColumns - 1, 1 do
		local ScoreboardColumnText = LUI.UIText.new()
		ScoreboardColumnText:setLeftRight(true, false, f5_local5, f5_local5 + f0_local7)
		ScoreboardColumnText:setTopBottom(false, false, -CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2, CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2)
		ScoreboardColumnText:setFont(CoD.fonts[SCOREBOARD_COLUMN_FONT])
		ScoreboardColumnText:setAlignment(LUI.Alignment.Center)
		ScoreboardColumnText:setRGB(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b)
		ScoreboardColumnText:setAlpha(0.5)
		if CoD.isZombie then
			ScoreboardColumnText:setText(Engine.Localize(ZombiesCleansedScoreboardCheck(Engine.GetScoreBoardColumnName(LocalClientIndex, ScoreboardColumnIndex))))
		else
			ScoreboardColumnText:setText(Engine.Localize(Engine.GetScoreBoardColumnName(LocalClientIndex, ScoreboardColumnIndex)))
		end
		columnHeaderContainer:addElement(ScoreboardColumnText)
		f5_local5 = f5_local5 + f0_local7
	end
	local f5_local7 = 5
	local ScoreboardPingNumbers = LUI.UIText.new()
	ScoreboardPingNumbers:setLeftRight(true, false, f5_local5, f5_local5 + f0_local24 + f5_local7)
	ScoreboardPingNumbers:setTopBottom(false, false, -CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2, CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2)
	ScoreboardPingNumbers:setFont(CoD.fonts[SCOREBOARD_COLUMN_FONT])
	ScoreboardPingNumbers:setAlignment(LUI.Alignment.Right)
	ScoreboardPingNumbers:setRGB(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b)
	ScoreboardPingNumbers:setAlpha(0.5)
	ScoreboardPingNumbers:setText(Engine.Localize("CGAME_SB_PING"))
	columnHeaderContainer:addElement(ScoreboardPingNumbers)
	f5_local5 = f5_local5 + f0_local24 + f5_local7
	ScoreboardWidget.teamElements = {}
	local ScoreboardTeamCount = Engine.GetGametypeSetting("teamCount")
	if CoD.isZombie and Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED then
		if ScoreboardTeamCount < 2 then
			ScoreboardTeamCount = 2
		end
	end
	if UnusedArg1 then
		local AARScoreboardTable = Engine.GetAARScoreboard(LocalClientIndex)
		ScoreboardTeamCount = AARScoreboardTable.teamCount
	end
	for Index = 1, ScoreboardTeamCount, 1 do
		local TeamElement = ScoreboardWidgetCreateTeamElement()
		table.insert(ScoreboardWidget.teamElements, TeamElement)
		ScoreboardWidget.scoreboardContainer:addElement(TeamElement)
	end
	ScoreboardWidget.rows = {}
	for ScoreboardRowIndex = 1, SCOREBOARD_MAX_ROWS, 1 do
		local NewRow = CoD.ScoreboardRow.new(LocalClientIndex, ScoreboardRowIndex)
		ScoreboardWidget.scoreboardContainer:addElement(NewRow)
		table.insert(ScoreboardWidget.rows, NewRow)
	end
	if not ScoreboardWidget.frontEndOnly then
		if UIExpression.IsDemoPlaying(LocalClientIndex) == 1 then
			ScoreboardWidget.spectatePlayerButtonPrompt = CoD.ButtonPrompt.new("primary", "", ScoreboardWidget, "button_prompt_spectate_demo_player")
		else
			ScoreboardWidget.muteButtonPrompt = CoD.ButtonPrompt.new("primary", Engine.Localize("MENU_MUTE"), ScoreboardWidget, "button_prompt_toggle_mute")
		end
		if UIExpression.IsDemoPlaying(LocalClientIndex) == 1 then
			ScoreboardWidget.switchScoreboardMode = CoD.ButtonPrompt.new("alt1", "", ScoreboardWidget, "button_prompt_switch_scoreboard_mode", false, false, false, false, "S")
		end
		ScoreboardWidget.showGamerCardButtonPrompt = CoD.ButtonPrompt.new("alt2", Engine.Localize("MENU_LB_VIEW_PLAYER_CARD"), ScoreboardWidget, "button_prompt_show_gamercard", false, false, false, false, "P")
	end
	ScoreboardWidgetUpdateFunc(ScoreboardWidget)
end

local ClientInputSourceChangedCallback = function(ScoreboardWidget, ClientInstance)
	if ScoreboardWidget.spectatePlayerButtonPrompt then
		ScoreboardWidget.spectatePlayerButtonPrompt:processEvent(ClientInstance)
	end
	if ScoreboardWidget.muteButtonPrompt then
		ScoreboardWidget.muteButtonPrompt:processEvent(ClientInstance)
	end
	ScoreboardWidget:dispatchEventToChildren(ClientInstance)
end

LUI.createMenu.Scoreboard = function(LocalClientIndex)
	local BodyVerticalOffset = f0_local41
	if CoD.isZombie == true then
		IsDLCMap2 = CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps)
		IsDLCMap4 = CoD.Zombie.IsDLCMap(CoD.Zombie.DLC4Maps)
		IsClassic = Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLASSIC
		if IsDLCMap2 == true then
			require("T6.Zombie.ScoreboardCraftablesZombie")
		end
		if IsDLCMap4 == true then
			require("T6.Zombie.ScoreboardCraftablesTombZombie")
		end
		if (IsDLCMap2 == true or IsDLCMap4 == true) and IsClassic == true then
			BodyVerticalOffset = f0_local41 + 75
		end
	end
	local ScoreboardWidget = CoD.Menu.NewFromState("Scoreboard")
	ScoreboardWidget:setLeftRight(false, false, -CoD.SDSafeWidth / 2 + f0_local14 / 2, CoD.SDSafeWidth / 2 - f0_local14 / 2)
	ScoreboardWidget:setTopBottom(false, false, -CoD.SDSafeHeight / 2 + BodyVerticalOffset, CoD.SDSafeHeight / 2)
	ScoreboardWidget:setOwner(LocalClientIndex)
	if (IsDLCMap2 == true or IsDLCMap4 == true) and IsClassic == true then
		local CraftablesVerticalOffset = f0_local30 + f0_local6
		if IsDLCMap2 == true then
			CoD.ScoreboardCraftablesZombie.new(ScoreboardWidget, CraftablesVerticalOffset)
		elseif IsDLCMap4 == true then
			CoD.ScoreboardCraftablesTombZombie.new(ScoreboardWidget, CraftablesVerticalOffset)
		end
	end
	CreateScoreBoardBody(ScoreboardWidget, LocalClientIndex)
	ScoreboardWidget.close = ScoreboardWidgetCloseFunc
	ScoreboardWidget:registerEventHandler("close_all_ingame_menus", ScoreboardWidget.close)
	ScoreboardWidget:registerEventHandler("close_scoreboard_menu", ScoreboardWidget.close)
	ScoreboardWidget:registerEventHandler("row_selected", ScoreboardWidgetRowSelectorFunc)
	ScoreboardWidget:registerEventHandler("update_scoreboard", ScoreboardWidgetUpdateFunc)
	ScoreboardWidget:registerEventHandler("button_prompt_show_gamercard", ScoreboardWidgetShowGamercardFunc)
	ScoreboardWidget:registerEventHandler("button_prompt_toggle_mute", ScoreboardWidgetToggleMuteFunc)
	ScoreboardWidget:registerEventHandler("button_prompt_spectate_demo_player", SwitchPlayer)
	ScoreboardWidget:registerEventHandler("button_prompt_switch_scoreboard_mode", SwitchScoreboardMode)
	ScoreboardWidget:registerEventHandler("fullscreen_viewport_start", FullscreenStart)
	ScoreboardWidget:registerEventHandler("fullscreen_viewport_stop", FullscreenStop)
	ScoreboardWidget:registerEventHandler("input_source_changed", ClientInputSourceChangedCallback)
	return ScoreboardWidget
end

ScoreboardWidgetCloseFunc = function(ScoreboardWidget, UnusedArg1)
	ScoreboardWidget.focusableRowIndex = nil
	ScoreboardWidget.selectedClientNum = nil
	ScoreboardWidget.selectedScoreboardIndex = nil
	CoD.Menu.close(ScoreboardWidget)
end

ScoreboardWidgetCreateTeamElement = function(UnusedArg1)
	local ScoreboardFactionWidget = LUI.UIElement.new()
	ScoreboardFactionWidget:setLeftRight(true, true, 0, 0)
	ScoreboardFactionWidget:setUseStencil(true)
	ScoreboardFactionWidget:setAlpha(0)
	local FactionBackground = LUI.UIImage.new()
	FactionBackground:setLeftRight(true, true, 0, 0)
	FactionBackground:setTopBottom(true, true, 0, 0)
	FactionBackground:setImage(RegisterMaterial(CoD.MPZM("menu_mp_cac_grad_stretch", "menu_zm_cac_grad_stretch")))
	FactionBackground:setRGB(0, 0, 0)
	FactionBackground:setAlpha(0.5)
	ScoreboardFactionWidget:addElement(FactionBackground)
	ScoreboardFactionWidget.highlightGlow = LUI.UIImage.new()
	ScoreboardFactionWidget.highlightGlow:setLeftRight(true, false, 2, f0_local30 + f0_local24 - 2)
	ScoreboardFactionWidget.highlightGlow:setTopBottom(false, true, -45, -2)
	ScoreboardFactionWidget.highlightGlow:setImage(RegisterMaterial(CoD.MPZM("menu_mp_cac_grad_stretch", "menu_zm_cac_grad_stretch")))
	ScoreboardFactionWidget.highlightGlow:setAlpha(0.4)
	ScoreboardFactionWidget:addElement(ScoreboardFactionWidget.highlightGlow)
	local f9_local1 = 116
	local f9_local2 = (f0_local30 + f0_local24 - 2) / 2 - f9_local1 / 2
	ScoreboardFactionWidget.factionIcon = LUI.UIImage.new()
	ScoreboardFactionWidget.factionIcon:setLeftRight(true, false, f9_local2, f9_local2 + f9_local1)
	ScoreboardFactionWidget.factionIcon:setTopBottom(false, false, -f9_local1 / 2, f9_local1 / 2)
	ScoreboardFactionWidget.factionIcon:setAlpha(SCOREBOARD_FACTION_ICON_OPACITY)
	ScoreboardFactionWidget:addElement(ScoreboardFactionWidget.factionIcon)
	ScoreboardFactionWidget.background = LUI.UIImage.new()
	ScoreboardFactionWidget.background:setLeftRight(true, true, 0, 0)
	ScoreboardFactionWidget.background:setTopBottom(true, true, 0, 0)
	ScoreboardFactionWidget.background:setRGB(0, 0, 0)
	ScoreboardFactionWidget.background:setAlpha(SCOREBOARD_BACKGROUND_OPACITY)
	ScoreboardFactionWidget:addElement(ScoreboardFactionWidget.background)
	local f9_local4 = LUI.UIImage.new()
	f9_local4:setLeftRight(true, false, 2, f0_local30 + f0_local24 - 2)
	f9_local4:setTopBottom(true, false, 2, 9)
	f9_local4:setImage(RegisterMaterial("white"))
	f9_local4:setAlpha(0.06)
	ScoreboardFactionWidget:addElement(f9_local4)
	local f9_local4 = 5
	ScoreboardFactionWidget.teamScore = LUI.UIText.new()
	ScoreboardFactionWidget.teamScore:setLeftRight(true, false, f9_local4, f9_local4)
	ScoreboardFactionWidget.teamScore:setTopBottom(true, false, -4, CoD.textSize.Big - 4)
	ScoreboardFactionWidget.teamScore:setFont(CoD.fonts.Big)
	ScoreboardFactionWidget.teamScore:setRGB(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b)
	ScoreboardFactionWidget:addElement(ScoreboardFactionWidget.teamScore)
	local f9_local5 = 96
	ScoreboardFactionWidget.factionName = LUI.UIText.new()
	ScoreboardFactionWidget.factionName:setLeftRight(true, false, f9_local4, f9_local4)
	ScoreboardFactionWidget.factionName:setTopBottom(true, false, f9_local5, f9_local5 + CoD.textSize.ExtraSmall)
	ScoreboardFactionWidget.factionName:setFont(CoD.fonts.ExtraSmall)
	ScoreboardFactionWidget.factionName:setRGB(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b)
	ScoreboardFactionWidget:addElement(ScoreboardFactionWidget.factionName)
	return ScoreboardFactionWidget
end

ScoreboardWidgetRowSelectorFunc = function(ScoreboardWidget, ScoreboardRowSelected)
	if ScoreboardWidget.frontEndOnly then
		return
	end
	ScoreboardWidget.focusableRowIndex = ScoreboardRowSelected.row.focusableRowIndex
	ScoreboardWidget.selectedClientNum = ScoreboardRowSelected.row.clientNum
	ScoreboardWidget.selectedScoreboardIndex = ScoreboardRowSelected.row.scoreboardIndex
	f0_local38(ScoreboardWidget, Engine.GetClientNum(ScoreboardWidget:getOwner()))
	if ScoreboardWidget.showGamerCardButtonPrompt ~= nil then
		local f10_local2 = ScoreboardRowSelected.row.playerName.gamertag
		local f10_local3 = f10_local2:len()
		if f10_local3 > 3 and f10_local2:sub(f10_local3, f10_local3) == ")" then
			ScoreboardWidget.showGamerCardButtonPrompt:hide()
		else
			ScoreboardWidget.showGamerCardButtonPrompt:show()
		end
	end
end

ScoreboardWidgetShowGamercardFunc = function(ScoreboardWidget, ClientInstance)
	if ScoreboardWidget.frontEndOnly then
		return
	elseif ScoreboardWidget.selectedClientNum then
		Engine.BlockGameFromKeyEvent()
		CoD.FriendPopup.SelectedPlayerXuid = Engine.GetMatchScoreboardClientXuid(ScoreboardWidget.selectedClientNum)
		CoD.FriendPopup.SelectedPlayerName = Engine.GetFullGamertagForScoreboardIndex(ScoreboardWidget.selectedScoreboardIndex)
		if CoD.FriendPopup.SelectedPlayerXuid and CoD.FriendPopup.SelectedPlayerXuid ~= 0 then
			local GamercardPopup = ScoreboardWidget:openPopup("FriendPopup", ClientInstance.controller)
			GamercardPopup:setClass(CoD.InGameMenu)
			GamercardPopup.isInGameMenu = true
		end
	end
end

ScoreboardWidgetToggleMuteFunc = function(ScoreboardWidget, UnusedArg1)
	if ScoreboardWidget.frontEndOnly then
		return
	elseif ScoreboardWidget.selectedClientNum then
		Engine.TogglePlayerMute(ScoreboardWidget:getOwner(), ScoreboardWidget.selectedClientNum)
		Engine.BlockGameFromKeyEvent()
		ScoreboardWidgetUpdateFunc(ScoreboardWidget)
	end
end

function SwitchPlayer(ScoreboardWidget, UnusedArg1)
	if ScoreboardWidget.frontEndOnly then
		return
	elseif ScoreboardWidget.selectedClientNum then
		Engine.Exec(ScoreboardWidget.m_ownerController, "demo_switchplayer 0 " .. ScoreboardWidget.selectedClientNum)
		Engine.BlockGameFromKeyEvent()
		ScoreboardWidgetUpdateFunc(ScoreboardWidget)
	end
end

function SwitchScoreboardMode(ScoreboardWidget, UnusedArg1)
	if ScoreboardWidget.frontEndOnly then
		return
	elseif ScoreboardWidget.mode == "game" then
		ScoreboardWidget.mode = "theater"
	else
		ScoreboardWidget.mode = "game"
	end
	Engine.BlockGameFromKeyEvent()
	ScoreboardWidgetUpdateFunc(ScoreboardWidget)
end

function FullscreenStart(ScoreboardWidget, ClientInstance)
	ScoreboardWidget.forcedFullscreen = true
	ScoreboardWidget:dispatchEventToChildren(ClientInstance)
end

function FullscreenStop(ScoreboardWidget, ClientInstance)
	ScoreboardWidget.forcedFullscreen = false
	ScoreboardWidget:dispatchEventToChildren(ClientInstance)
end

f0_local38 = function(ScoreboardWidget, ClientNum)
	if ScoreboardWidget.frontEndOnly then
		return
	elseif UIExpression.IsDemoPlaying(ScoreboardWidget.m_ownerController) == 1 then
		if ScoreboardWidget.mode == "theater" then
			ScoreboardWidget.switchScoreboardMode:setText(Engine.Localize("MENU_VIEW_GAME_SCOREBOARD"))
			ScoreboardWidget.spectatePlayerButtonPrompt:close()
		else
			ScoreboardWidget.switchScoreboardMode:setText(Engine.Localize("MENU_VIEW_THEATER_PARTY"))
			if ScoreboardWidget.selectedScoreboardIndex ~= nil then
				ScoreboardWidget.spectatePlayerButtonPrompt:setText(Engine.Localize("MENU_SPECTATE_DEMO_PLAYER", Engine.GetFullGamertagForScoreboardIndex(ScoreboardWidget.selectedScoreboardIndex)))
				if UIExpression.IsDemoClipPlaying() == 0 then
					ScoreboardWidget:addLeftButtonPrompt(ScoreboardWidget.spectatePlayerButtonPrompt)
				end
			end
		end
		ScoreboardWidget:addRightButtonPrompt(ScoreboardWidget.switchScoreboardMode)
	else
		local PlayerMuted = nil
		if ScoreboardWidget.selectedClientNum and ScoreboardWidget.selectedClientNum ~= ClientNum then
			PlayerMuted = Engine.IsPlayerMuteToggled(ScoreboardWidget:getOwner(), ScoreboardWidget.selectedClientNum)
		end
		if PlayerMuted ~= nil and not Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) then
			if PlayerMuted then
				ScoreboardWidget.muteButtonPrompt:setText(Engine.Localize("MENU_UNMUTE"))
			else
				ScoreboardWidget.muteButtonPrompt:setText(Engine.Localize("MENU_MUTE"))
			end
			ScoreboardWidget:addLeftButtonPrompt(ScoreboardWidget.muteButtonPrompt)
		else
			ScoreboardWidget.muteButtonPrompt:close()
		end
		local ShowGamercardButtonPrompt = nil
		if UIExpression.IsGuest(ScoreboardWidget.m_ownerController) ~= 0 or Engine.IsSplitscreen() ~= false or Engine.SessionModeIsMode(CoD.SESSIONMODE_OFFLINE) or Engine.SessionModeIsMode(CoD.SESSIONMODE_SYSTEMLINK) or CoD.isZombie == true and Engine.PartyGetPlayerCount() >= 1 then
			ShowGamercardButtonPrompt = false
		else
			ShowGamercardButtonPrompt = true
		end
		if ShowGamercardButtonPrompt and not CoD.isWIIU and not CoD.isPC then
			ScoreboardWidget:addRightButtonPrompt(ScoreboardWidget.showGamerCardButtonPrompt)
		else
			ScoreboardWidget.showGamerCardButtonPrompt:close()
		end
	end
end

function UpdateGameScoreboard(ScoreboardWidget)
	local ScoreboardTeams = nil
	if CoD.isZombie and Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED then
		ScoreboardTeams = Engine.GetTeamPositions(ScoreboardWidget:getOwner(), 2)
	else
		ScoreboardTeams = Engine.GetTeamPositions(ScoreboardWidget:getOwner())
	end
	if ScoreboardWidget.frontEndOnly then
		local AARScoreboardTable = Engine.GetAARScoreboard(ScoreboardWidget:getOwner())
		ScoreboardTeams = Engine.GetTeamPositions(ScoreboardWidget:getOwner(), AARScoreboardTable.teamCount)
	end

	local ClientNum = nil
	local TeamID = nil

	if not ScoreboardWidget.frontEndOnly then
		ClientNum = Engine.GetClientNum(ScoreboardWidget:getOwner())
		TeamID = Engine.GetTeamID(ScoreboardWidget:getOwner(), ClientNum)

		if #ScoreboardTeams > 1 and ScoreboardTeams[1].team ~= TeamID then
			ScoreboardTeams[1], ScoreboardTeams[2] = ScoreboardTeams[2], ScoreboardTeams[1]
		end
	end

	local TeamElementIndex = 1
	local ScoreboardRowIndex = 1
	local f18_local5 = f0_local10 + f0_local32
	if not ScoreboardWidget.frontEndOnly then
		ScoreboardWidget.gameTimer:setAlpha(1)
	end
	ScoreboardWidget.headerTitle:setText(CreateScoreboardHeaderTitle(ScoreboardWidget))
	ScoreboardWidget.columnHeaderContainer:setAlpha(1)
	local GreatestNumberOfClientsOnATeam = 0
	for Key, ScoreboardTeam in ipairs(ScoreboardTeams) do
		ScoreboardTeam.numClients = Engine.GetMatchScoreboardClientCount(ScoreboardTeam.team)
		if GreatestNumberOfClientsOnATeam < ScoreboardTeam.numClients then
			GreatestNumberOfClientsOnATeam = ScoreboardTeam.numClients
		end
	end
	local MinRowsPerTeam = CoD.MPZM(2, 4)
	if GreatestNumberOfClientsOnATeam <= math.floor(SCOREBOARD_MAX_ROWS / #ScoreboardTeams) then
		MinRowsPerTeam = math.max(MinRowsPerTeam, GreatestNumberOfClientsOnATeam)
	end
	if CoD.isZombie and Engine.GetGametypeSetting("teamCount") > 2 then
		MinRowsPerTeam = 2
	end
	local f18_local12, f18_local13, f18_local14, f18_local15 = nil, nil, nil, nil
	local FocusableRowIndex = 1
	for Key, ScoreboardTeam in ipairs(ScoreboardTeams) do
		if ScoreboardWidget.teamElements[TeamElementIndex] and ScoreboardTeam.numClients > 0 then
			local FactionTeam = nil
			FactionTeam = Engine.GetFactionForTeam(ScoreboardTeam.team)
			if ScoreboardWidget.frontEndOnly then
				local AARScoreboardTable = Engine.GetAARScoreboard(ScoreboardWidget:getOwner())
				FactionTeam = Engine.GetFactionForTeam(ScoreboardTeam.team, AARScoreboardTable.mapName)
			end
			if FactionTeam then
				local FactionColorR, FactionColorG, FactionColorB = Engine.GetFactionColor(FactionTeam)
				if ScoreboardTeam.team == CoD.TEAM_FREE then
					FactionColorR = CoD.offWhite.r
					FactionColorG = CoD.offWhite.g
					FactionColorB = CoD.offWhite.b
				end
				if CoD.isZombie == true then
					local GamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
					local Mapname = CoD.Zombie.GetUIMapName()
					if GamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZCLASSIC then
						FactionColorR = CoD.Zombie.SingleTeamColor.r
						FactionColorG = CoD.Zombie.SingleTeamColor.g
						FactionColorB = CoD.Zombie.SingleTeamColor.b
					elseif GamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZSURVIVAL then
						if CoD.Zombie.IsSurvivalUsingCIAModel == true then
							if Mapname == CoD.Zombie.MAP_ZM_PRISON or Mapname == CoD.Zombie.MAP_ZM_TOMB then
								FactionColorR, FactionColorG, FactionColorB = Engine.GetFactionColor("inmates")
							else
								FactionColorR, FactionColorG, FactionColorB = Engine.GetFactionColor("cia")
							end
						end
					end
				end
				ScoreboardUpdateTeamElement(ScoreboardWidget.teamElements[TeamElementIndex], FactionTeam, FactionColorR, FactionColorG, FactionColorB, ScoreboardTeam, math.max(MinRowsPerTeam, ScoreboardTeam.numClients), f18_local5)
				TeamElementIndex = TeamElementIndex + 1
				f18_local5 = f18_local5 + f0_local31
				for PlayerIndex = 0, ScoreboardTeam.numClients - 1, 1 do
					local ScoreboardRow = ScoreboardWidget.rows[ScoreboardRowIndex]
					f18_local5 = ScoreboardRow:setClient(FactionColorR, FactionColorG, FactionColorB, f18_local5, ScoreboardWidget.mode, ClientNum, FocusableRowIndex, PlayerIndex, ScoreboardTeam, ScoreboardWidget.frontEndOnly)
					if ScoreboardRow.clientNum == ClientNum then
						f18_local15 = ScoreboardRow
					end
					if not ScoreboardWidget.frontEndOnly then
						if FocusableRowIndex == ScoreboardWidget.focusableRowIndex then
							ScoreboardRow:processEvent(LUI.UIButton.GainFocusEvent)
							f18_local14 = ScoreboardRow
						elseif (f18_local15 ~= ScoreboardRow or ScoreboardWidget.focusableRowIndex) and ScoreboardRow:isInFocus() then
							ScoreboardRow:processEvent(LUI.UIButton.LoseFocusEvent)
						end
					end
					ScoreboardRow.navigation.up = f18_local13
					if f18_local13 then
						f18_local13.navigation.down = ScoreboardRow
					end
					f18_local13 = ScoreboardRow
					if not f18_local12 then
						f18_local12 = ScoreboardRow
					end
					ScoreboardRowIndex = ScoreboardRowIndex + 1
					FocusableRowIndex = FocusableRowIndex + 1
				end
				for PlayerIndex = ScoreboardTeam.numClients + 1, MinRowsPerTeam, 1 do
					local ScoreboardRow = ScoreboardWidget.rows[ScoreboardRowIndex]
					if ScoreboardRow:isInFocus() and not ScoreboardWidget.frontEndOnly then
						ScoreboardRow:processEvent(LUI.UIButton.LoseFocusEvent)
					end
					f18_local5 = ScoreboardRow:setClient(FactionColorR, FactionColorG, FactionColorB, f18_local5, ScoreboardWidget.mode)
					ScoreboardRowIndex = ScoreboardRowIndex + 1
				end
				f18_local5 = f18_local5 + f0_local32
			end
		end
	end
	if f18_local12 then
		if f18_local12 ~= f18_local13 then
			f18_local12.navigation.up = f18_local13
			f18_local13.navigation.down = f18_local12
		else
			f18_local13.navigation.up = nil
			f18_local13.navigation.down = nil
		end
	end
	if not f18_local14 and f18_local15 and not ScoreboardWidget.frontEndOnly then
		f18_local15:processEvent(LUI.UIButton.GainFocusEvent)
	end
	while TeamElementIndex <= #ScoreboardWidget.teamElements do
		ScoreboardWidget.teamElements[TeamElementIndex]:setAlpha(0)
		TeamElementIndex = TeamElementIndex + 1
	end
	if ScoreboardRowIndex <= 13 then
		ScoreboardWidget:setTopBottom(false, false, -f0_local36 / 2 + f0_local41, f0_local36 / 2)
	else
		ScoreboardWidget:setTopBottom(false, false, -CoD.SDSafeHeight / 2 + f0_local41, CoD.SDSafeHeight / 2)
	end
	while ScoreboardRowIndex <= #ScoreboardWidget.rows do
		ScoreboardWidget.rows[ScoreboardRowIndex]:setAlpha(0)
		ScoreboardRowIndex = ScoreboardRowIndex + 1
	end
	if not ScoreboardWidget.frontEndOnly then
		ScoreboardWidget.leftButtonPromptBar:setTopBottom(true, false, f18_local5, f18_local5 + CoD.ButtonPrompt.Height)
		ScoreboardWidget.rightButtonPromptBar:setTopBottom(true, false, f18_local5, f18_local5 + CoD.ButtonPrompt.Height)
	end
end

function UpdateTheaterScoreboard(ScoreboardWidget)
	local TeamElementIndex = 1
	local ScoreboardRowIndex = 1
	local f19_local4 = f0_local10 + f0_local32
	if not ScoreboardWidget.frontEndOnly then
		ScoreboardWidget.gameTimer:setAlpha(0)
	end
	ScoreboardWidget.headerTitle:setText(CreateScoreboardHeaderTitle(ScoreboardWidget))
	ScoreboardWidget.columnHeaderContainer:setAlpha(0)
	local PlayerCount = Engine.PartyGetPlayerCount()
	local f19_local10 = math.max(CoD.MPZM(2, 4), PlayerCount)
	local f19_local11, f19_local12, f19_local13, f19_local14 = nil, nil, nil, nil
	local FocusableRowIndex = 1
	if ScoreboardWidget.focusableRowIndex == nil then
		ScoreboardWidget.focusableRowIndex = FocusableRowIndex
	end
	if PlayerCount < ScoreboardWidget.focusableRowIndex then
		ScoreboardWidget.focusableRowIndex = PlayerCount
	end
	local PlayersInLobby = Engine.GetPlayersInLobby()
	ScoreboardUpdateTeamElement(ScoreboardWidget.teamElements[TeamElementIndex], PlayersInLobby[ScoreboardWidget.focusableRowIndex].xuid, CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b, nil, math.max(f19_local10, PlayerCount), f19_local4)
	TeamElementIndex = TeamElementIndex + 1
	f19_local4 = f19_local4 + f0_local32 - 2
	for PlayerIndex = 0, PlayerCount - 1, 1 do
		local ScoreboardRow = ScoreboardWidget.rows[ScoreboardRowIndex]
		f19_local4 = ScoreboardRow:setClient(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b, f19_local4, ScoreboardWidget.mode, nil, FocusableRowIndex, PlayerIndex, nil, ScoreboardWidget.frontEndOnly)
		if ScoreboardRowIndex == 1 then
			f19_local14 = ScoreboardRow[ScoreboardRowIndex]
		end
		if not ScoreboardWidget.frontEndOnly then
			if FocusableRowIndex == ScoreboardWidget.focusableRowIndex then
				ScoreboardRow:processEvent(LUI.UIButton.GainFocusEvent)
				f19_local13 = ScoreboardRow
			elseif (f19_local14 ~= ScoreboardRow or ScoreboardWidget.focusableRowIndex) and ScoreboardRow:isInFocus() then
				ScoreboardRow:processEvent(LUI.UIButton.LoseFocusEvent)
			end
		end
		ScoreboardRow.navigation.up = f19_local12
		if f19_local12 then
			f19_local12.navigation.down = ScoreboardRow
		end
		f19_local12 = ScoreboardRow
		if not f19_local11 then
			f19_local11 = ScoreboardRow
		end
		ScoreboardRowIndex = ScoreboardRowIndex + 1
		FocusableRowIndex = FocusableRowIndex + 1
	end
	for PlayerIndex = PlayerCount + 1, f19_local10, 1 do
		local ScoreboardRow = ScoreboardWidget.rows[ScoreboardRowIndex]
		if ScoreboardRow:isInFocus() and not ScoreboardWidget.frontEndOnly then
			ScoreboardRow:processEvent(LUI.UIButton.LoseFocusEvent)
		end
		f19_local4 = ScoreboardRow:setClient(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b, f19_local4, ScoreboardWidget.mode)
		ScoreboardRowIndex = ScoreboardRowIndex + 1
	end
	if f19_local11 then
		if f19_local11 ~= f19_local12 then
			f19_local11.navigation.up = f19_local12
			f19_local12.navigation.down = f19_local11
		else
			f19_local12.navigation.up = nil
			f19_local12.navigation.down = nil
		end
	end
	if not f19_local13 and f19_local14 and not ScoreboardWidget.frontEndOnly then
		f19_local14:processEvent(LUI.UIButton.GainFocusEvent)
	end
	while TeamElementIndex <= #ScoreboardWidget.teamElements do
		ScoreboardWidget.teamElements[TeamElementIndex]:setAlpha(0)
		TeamElementIndex = TeamElementIndex + 1
	end
	if ScoreboardRowIndex <= 13 then
		ScoreboardWidget:setTopBottom(false, false, -f0_local36 / 2 + f0_local41, f0_local36 / 2)
	else
		ScoreboardWidget:setTopBottom(false, false, -CoD.SDSafeHeight / 2 + f0_local41, CoD.SDSafeHeight / 2)
	end
	while ScoreboardRowIndex <= #ScoreboardWidget.rows do
		ScoreboardWidget.rows[ScoreboardRowIndex]:setAlpha(0)
		ScoreboardRowIndex = ScoreboardRowIndex + 1
	end
	if not ScoreboardWidget.frontEndOnly then
		ScoreboardWidget.leftButtonPromptBar:setTopBottom(true, false, f19_local4, f19_local4 + CoD.ButtonPrompt.Height)
		ScoreboardWidget.rightButtonPromptBar:setTopBottom(true, false, f19_local4, f19_local4 + CoD.ButtonPrompt.Height)
	end
end

ScoreboardWidgetUpdateFunc = function(ScoreboardWidget)
	if ScoreboardWidget.mode == "theater" and not ScoreboardWidget.frontEndOnly then
		UpdateTheaterScoreboard(ScoreboardWidget)
	else
		UpdateGameScoreboard(ScoreboardWidget)
	end
end

ScoreboardUpdateTeamElement = function(TeamElement, FactionTeam, FactionColorR, FactionColorG, FactionColorB, ScoreboardTeam, MinRowsPerTeam, f21_arg7)
	local VerticalOffset = MinRowsPerTeam * f0_local29 + (MinRowsPerTeam + 1) * f0_local31
	TeamElement:setTopBottom(true, false, f21_arg7, f21_arg7 + VerticalOffset)
	TeamElement:setAlpha(1)
	if ScoreboardTeam == nil then
		if CoD.isZombie == false then
			TeamElement.factionIcon:setupPlayerEmblemByXUID(FactionTeam)
			TeamElement.factionIcon:setAlpha(1)
		else
			TeamElement.factionIcon:setAlpha(0)
		end
		TeamElement.factionName:setText("")
		TeamElement.teamScore:setAlpha(0)
	elseif ScoreboardTeam.team ~= CoD.TEAM_FREE then
		if TeamElement.highlightGlow then
			TeamElement.highlightGlow:setRGB(FactionColorR, FactionColorG, FactionColorB)
			TeamElement.highlightGlow:setTopBottom(false, true, -2, -VerticalOffset / 2)
		end
		TeamElement.factionIcon:setImage(RegisterMaterial("faction_" .. FactionTeam))
		TeamElement.factionIcon:setupUIImage()
		TeamElement.factionIcon:setAlpha(1)
		local ScoreboardTeamName = Engine.GetCustomTeamName(ScoreboardTeam.team)
		if ScoreboardTeamName == "" then
			ScoreboardTeamName = Engine.Localize(CoD.MPZM("MPUI_", "ZMUI_") .. FactionTeam .. "_SHORT_CAPS")
		end
		local ShowTeamName = true
		if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
			ShowTeamName = false
		end
		TeamElement.factionName:setText(ScoreboardTeamName)
		TeamElement.teamScore:setText(ScoreboardTeam.score)
		if CoD.isZombie == true then
			local GamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
			local Mapname = CoD.Zombie.GetUIMapName()
			if GamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZCLASSIC then
				if Mapname == CoD.Zombie.MAP_ZM_TOMB then
					TeamElement.factionIcon:setImage(RegisterMaterial("faction_tomb"))
				elseif Mapname == CoD.Zombie.MAP_ZM_BURIED then
					TeamElement.factionIcon:setImage(RegisterMaterial("faction_buried"))
				elseif Mapname == CoD.Zombie.MAP_ZM_PRISON then
					TeamElement.factionIcon:setImage(RegisterMaterial("faction_prison"))
				elseif Mapname == CoD.Zombie.MAP_ZM_HIGHRISE then
					TeamElement.factionIcon:setImage(RegisterMaterial("faction_highrise"))
				else
					TeamElement.factionIcon:setImage(RegisterMaterial("faction_tranzit"))
				end
			elseif GamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZSURVIVAL then
				if Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED and ScoreboardTeam.team == CoD.TEAM_AXIS then
					TeamElement.factionIcon:setImage(RegisterMaterial("faction_zombie"))
				elseif CoD.Zombie.IsSurvivalUsingCIAModel == true then
					if Mapname == CoD.Zombie.MAP_ZM_PRISON or Mapname == CoD.Zombie.MAP_ZM_TOMB then
						TeamElement.factionIcon:setImage(RegisterMaterial("faction_inmates"))
					else
						TeamElement.factionIcon:setImage(RegisterMaterial("faction_cia"))
					end
				end
			elseif GamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
				if Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED and ScoreboardTeam.team == CoD.TEAM_AXIS then
					TeamElement.factionIcon:setImage(RegisterMaterial("faction_zombie"))
				end
			end
			if ShowTeamName then
				TeamElement.factionName:setAlpha(1)
			else
				TeamElement.factionName:setAlpha(0)
			end
			if tonumber(Dvar.ui_scorelimit:get()) > 0 then
				TeamElement.teamScore:setAlpha(1)
			else
				TeamElement.teamScore:setAlpha(0)
			end
		end
	else
		local SortType = CoD.MPZM(CoD.SCOREBOARD_SORT_DEFAULT, CoD.SCOREBOARD_SORT_CLIENTNUM)
		if CoD.isZombie and Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED then
			SortType = CoD.SCOREBOARD_SORT_DEFAULT
		end
		local PlayerScoreboardIndex, PlayerScoreboardClientNum = Engine.GetMatchScoreboardIndexAndClientNumForTeam(0, ScoreboardTeam.team, SortType)
		local f21_local3 = Engine.GetCalloutPlayerData(nil, PlayerScoreboardClientNum)
		if TeamElement.highlightGlow then
			TeamElement.highlightGlow:setRGB(FactionColorR, FactionColorG, FactionColorB)
			TeamElement.highlightGlow:setTopBottom(false, true, -2, -VerticalOffset / 2)
		end
		TeamElement.factionIcon:setupPlayerEmblemServer(f21_local3.playerClientNum)
		TeamElement.factionIcon:setAlpha(1)
		TeamElement.factionName:setText(f21_local3.playerName)
		TeamElement.teamScore:setAlpha(1)
		TeamElement.teamScore:setText(Engine.GetScoreboardColumnForScoreboardIndex(PlayerScoreboardIndex, 0))
	end
	TeamElement.factionName:setRGB(FactionColorR, FactionColorG, FactionColorB)
end

CoD.ScoreboardRow.GetRowTextColor = function(ScoreboardRowIndex)
	if CoD.isZombie == true then
		local ZombiesColorIndex = (ScoreboardRowIndex - 1) % 4 + 1
		return CoD.Zombie.PlayerColors[ZombiesColorIndex].r, CoD.Zombie.PlayerColors[ZombiesColorIndex].g, CoD.Zombie.PlayerColors[ZombiesColorIndex].b
	else
		return CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b
	end
end

CoD.ScoreboardRow.new = function(LocalClientIndex, ScoreboardRowIndex)
	local RowTextColorR, RowTextColorG, RowTextColorB = CoD.ScoreboardRow.GetRowTextColor(ScoreboardRowIndex)
	local ScoreboardRowWidget = LUI.UIElement.new()
	ScoreboardRowWidget:setClass(CoD.ScoreboardRow)
	ScoreboardRowWidget:makeFocusable()
	ScoreboardRowWidget:setLeftRight(true, true, f0_local30, 0)
	ScoreboardRowWidget:setAlpha(0)
	local f23_local4 = LUI.UIImage.new()
	f23_local4:setLeftRight(true, true, f0_local26, f0_local27)
	f23_local4:setTopBottom(true, false, 0, 7)
	f23_local4:setImage(RegisterMaterial("white"))
	f23_local4:setAlpha(0.06)
	ScoreboardRowWidget:addElement(f23_local4)
	local f23_local4 = 0
	ScoreboardRowWidget.statusIcon = LUI.UIImage.new()
	ScoreboardRowWidget.statusIcon:setLeftRight(true, false, f23_local4, f23_local4 + f0_local24)
	ScoreboardRowWidget.statusIcon:setTopBottom(false, false, -f0_local24 / 2, f0_local24 / 2)
	ScoreboardRowWidget.statusIcon:setAlpha(0)
	ScoreboardRowWidget:addElement(ScoreboardRowWidget.statusIcon)
	f23_local4 = f23_local4 + f0_local24
	if not CoD.isZombie then
		ScoreboardRowWidget.rankText = LUI.UIText.new()
		ScoreboardRowWidget.rankText:setLeftRight(true, false, f23_local4, f23_local4 + f0_local25)
		ScoreboardRowWidget.rankText:setTopBottom(false, false, -CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2, CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2)
		ScoreboardRowWidget.rankText:setFont(CoD.fonts[SCOREBOARD_COLUMN_FONT])
		ScoreboardRowWidget.rankText:setAlignment(LUI.Alignment.Right)
		ScoreboardRowWidget.rankText:setRGB(RowTextColorR, RowTextColorG, RowTextColorB)
		ScoreboardRowWidget:addElement(ScoreboardRowWidget.rankText)
		f23_local4 = f23_local4 + f0_local25 + 2
	end
	ScoreboardRowWidget.rankIcon = LUI.UIImage.new()
	ScoreboardRowWidget.rankIcon:setLeftRight(true, false, f23_local4, f23_local4 + f0_local24)
	ScoreboardRowWidget.rankIcon:setTopBottom(false, false, -f0_local24 / 2, f0_local24 / 2)
	ScoreboardRowWidget.rankIcon:setAlpha(0)
	ScoreboardRowWidget:addElement(ScoreboardRowWidget.rankIcon)
	ScoreboardRowWidget.voipIcon = LUI.UIImage.new()
	ScoreboardRowWidget.voipIcon:setLeftRight(true, false, f23_local4, f23_local4 + f0_local24)
	ScoreboardRowWidget.voipIcon:setTopBottom(false, false, -f0_local24 / 2, f0_local24 / 2)
	ScoreboardRowWidget.voipIcon:setAlpha(0)
	ScoreboardRowWidget:addElement(ScoreboardRowWidget.voipIcon)
	f23_local4 = f23_local4 + f0_local24 + 4
	local f23_local7 = f0_local16
	ScoreboardRowWidget.playerName = LUI.UIText.new()
	ScoreboardRowWidget.playerName:setLeftRight(true, false, f23_local4, f23_local4 + f23_local7)
	ScoreboardRowWidget.playerName:setTopBottom(false, false, -CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2, CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2)
	ScoreboardRowWidget.playerName:setFont(CoD.fonts[SCOREBOARD_COLUMN_FONT])
	ScoreboardRowWidget.playerName:setRGB(RowTextColorR, RowTextColorG, RowTextColorB)
	ScoreboardRowWidget:addElement(ScoreboardRowWidget.playerName)
	f23_local4 = f23_local4 + f23_local7
	f23_local4 = f23_local4 + f0_local24
	ScoreboardRowWidget.columnBackgrounds = {}
	ScoreboardRowWidget.columns = {}
	f23_local4 = f0_local6
	local MaxColumns = SCOREBOARD_DEFAULT_MAX_COLUMNS
	for ColumnIndex = 1, MaxColumns, 1 do
		if Engine.GetScoreBoardColumnName(LocalClientIndex, ColumnIndex - 1) ~= "" then
			if ColumnIndex % 2 == 1 then
				local ColumnBackground = LUI.UIImage.new()
				ColumnBackground:setLeftRight(true, false, f23_local4, f23_local4 + f0_local7)
				ColumnBackground:setTopBottom(true, true, 0, 0)
				ColumnBackground:setAlpha(SCOREBOARD_COLUMN_BACKGROUND_OPACITY)
				ScoreboardRowWidget:addElement(ColumnBackground)
				table.insert(ScoreboardRowWidget.columnBackgrounds, ColumnBackground)
			end
			local ColumnText = LUI.UIText.new()
			ColumnText:setLeftRight(true, false, f23_local4, f23_local4 + f0_local7)
			ColumnText:setTopBottom(false, false, -CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2, CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2)
			ColumnText:setFont(CoD.fonts[SCOREBOARD_COLUMN_FONT])
			ColumnText:setAlignment(LUI.Alignment.Center)
			ColumnText:setRGB(RowTextColorR, RowTextColorG, RowTextColorB)
			ScoreboardRowWidget:addElement(ColumnText)
			ScoreboardRowWidget.columns[ColumnIndex] = ColumnText
		end
		f23_local4 = f23_local4 + f0_local7
	end
	f23_local4 = f23_local4 + 3
	ScoreboardRowWidget.pingValue = LUI.UIText.new()
	ScoreboardRowWidget.pingValue:setLeftRight(true, false, f23_local4, f23_local4 + f0_local24)
	ScoreboardRowWidget.pingValue:setTopBottom(false, false, -CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2, CoD.textSize[SCOREBOARD_COLUMN_FONT] / 2)
	ScoreboardRowWidget.pingValue:setFont(CoD.fonts[SCOREBOARD_COLUMN_FONT])
	ScoreboardRowWidget.pingValue:setAlignment(LUI.Alignment.Right)
	ScoreboardRowWidget.pingValue:setRGB(RowTextColorR, RowTextColorG, RowTextColorB)
	ScoreboardRowWidget:addElement(ScoreboardRowWidget.pingValue)
	f23_local4 = f23_local4 + f0_local24
	local f23_local9 = 2
	local f23_local10 = f0_local26 - f23_local9
	local f23_local11 = f0_local27 + f23_local9
	ScoreboardRowWidget.border = CoD.Border.new(f23_local9, CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b, 1, -f23_local9)
	ScoreboardRowWidget.border:setLeftRight(true, true, f23_local10, f23_local11)
	ScoreboardRowWidget.border:setAlpha(0)
	ScoreboardRowWidget:addElement(ScoreboardRowWidget.border)
	return ScoreboardRowWidget
end

CoD.ScoreboardRow.setClient = function(ScoreboardRow, FactionColorR, FactionColorG, FactionColorB, VerticalOffset, ScoreboardMode, ClientNum, FocusableRowIndex, PlayerIndex, ScoreboardTeam, ScoreboardFrontEndOnly)
	local IsTheaterMode = ScoreboardMode == "theater"
	local PlayerRank, PlayerRankIcon, PlayerPrestige, PlayerGamerTag, PlayerScoreboardIndex, PlayerScoreboardClientNum = nil, nil, nil, nil, nil, nil
	local MaxColumns = SCOREBOARD_DEFAULT_MAX_COLUMNS
	ScoreboardRow:beginAnimation("move_row")
	ScoreboardRow:setTopBottom(true, false, VerticalOffset, VerticalOffset + f0_local29)
	ScoreboardRow:setAlpha(1)
	VerticalOffset = VerticalOffset + f0_local29 + f0_local31
	if IsTheaterMode then
		for Key, ColumnBackgrounds in ipairs(ScoreboardRow.columnBackgrounds) do
			ColumnBackgrounds:setAlpha(0)
		end
	else
		for Key, ColumnBackgrounds in ipairs(ScoreboardRow.columnBackgrounds) do
			ColumnBackgrounds:setRGB(FactionColorR, FactionColorG, FactionColorB)
			ColumnBackgrounds:setAlpha(SCOREBOARD_COLUMN_BACKGROUND_OPACITY)
		end
	end
	if PlayerIndex then
		if IsTheaterMode then
			local PlayersInLobby = Engine.GetPlayersInLobby()
			ScoreboardRow.clientNum = nil
			ScoreboardRow.scoreboardIndex = nil
			PlayerRank = PlayersInLobby[FocusableRowIndex].rank
			PlayerPrestige = PlayersInLobby[FocusableRowIndex].prestige
			PlayerRankIcon = PlayersInLobby[FocusableRowIndex].rankIcon
			PlayerGamerTag = PlayersInLobby[FocusableRowIndex].clean_gamertag
			if PlayersInLobby[FocusableRowIndex].clantag ~= "" then
				PlayerGamerTag = CoD.getClanTag(PlayersInLobby[FocusableRowIndex].clantag) .. PlayerGamerTag
			end
		else
			local SortType = CoD.MPZM(CoD.SCOREBOARD_SORT_DEFAULT, CoD.SCOREBOARD_SORT_CLIENTNUM)
			if CoD.isZombie and Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED then
				SortType = CoD.SCOREBOARD_SORT_DEFAULT
			end
			PlayerScoreboardIndex, PlayerScoreboardClientNum = Engine.GetMatchScoreboardIndexAndClientNumForTeam(PlayerIndex, ScoreboardTeam.team, SortType)
			ScoreboardRow.clientNum = PlayerScoreboardClientNum
			ScoreboardRow.scoreboardIndex = PlayerScoreboardIndex
			if CoD.isOnlineGame() then
				PlayerRank = Engine.GetRankForScoreboardIndex(PlayerScoreboardIndex)
				PlayerRankIcon = Engine.GetRankIconForScoreboardIndex(PlayerScoreboardIndex)
				PlayerPrestige = Engine.GetPrestigeForScoreboardIndex(PlayerScoreboardIndex)
			end
			PlayerGamerTag = Engine.GetFullGamertagForScoreboardIndex(PlayerScoreboardIndex)
		end
		ScoreboardRow.focusableRowIndex = FocusableRowIndex
		if PlayerScoreboardClientNum ~= nil and not ScoreboardFrontEndOnly and not IsTheaterMode then
			local ClientStatusIcon = Engine.GetStatusIconForClient(PlayerScoreboardClientNum)
			if ClientStatusIcon then
				ScoreboardRow.statusIcon:setImage(ClientStatusIcon)
				ScoreboardRow.statusIcon:setAlpha(1)
			else
				ScoreboardRow.statusIcon:setAlpha(0)
			end
		else
			ScoreboardRow.statusIcon:setAlpha(0)
		end
		if ScoreboardRow.rankText ~= nil then
			if PlayerPrestige and PlayerPrestige == tonumber(CoD.MAX_PRESTIGE) then
				ScoreboardRow.rankText:setText("")
			elseif PlayerRank and ScoreboardRow.rankText ~= nil then
				ScoreboardRow.rankText:setText(PlayerRank)
			end
		end
		if ScoreboardRow.rankIcon ~= nil then
			if PlayerRankIcon then
				ScoreboardRow.rankIcon:setImage(PlayerRankIcon)
				ScoreboardRow.rankIcon:setAlpha(1)
			else
				ScoreboardRow.rankIcon:setAlpha(0)
			end
		end
		ScoreboardRow.playerName:setText(PlayerGamerTag)
		ScoreboardRow.playerName.gamertag = PlayerGamerTag
		if PlayerScoreboardClientNum ~= nil and not IsTheaterMode then
			if ScoreboardRow.voipIcon ~= nil then
				if not ScoreboardFrontEndOnly then
					ScoreboardRow.voipIcon:setupVoipImage(PlayerScoreboardClientNum)
					ScoreboardRow:addElement(ScoreboardRow.voipIcon)
				else
					ScoreboardRow.voipIcon:close()
				end
			end
			for ColumnIndex = 1, MaxColumns, 1 do
				if ScoreboardRow.columns[ColumnIndex] then
					ScoreboardRow.columns[ColumnIndex]:setText(Engine.GetScoreboardColumnForScoreboardIndex(PlayerScoreboardIndex, ColumnIndex - 1))
				end
			end
			if ScoreboardRow.pingBars ~= nil then
				if not ScoreboardFrontEndOnly then
					ScoreboardRow.pingBars:setImage(SCOREBOARD_PING_BARS[math.max(1, #SCOREBOARD_PING_BARS - math.floor(Engine.GetPingForScoreboardIndex(PlayerScoreboardIndex) / 100))])
					ScoreboardRow.pingBars:setAlpha(1)
				else
					ScoreboardRow.pingBars:setAlpha(0)
				end
			end
			if ScoreboardRow.pingValue ~= nil then
				if not ScoreboardFrontEndOnly then
					local PingValue = Engine.GetPingForScoreboardIndex(PlayerScoreboardIndex)
					if UIExpression.IsDemoPlaying(PlayerIndex) == 1 then
						if PingValue == 0 then
							PingValue = 50
						elseif PingValue == 1 then
							PingValue = 100
						elseif PingValue == 2 then
							PingValue = 200
						elseif PingValue == 3 then
							PingValue = 300
						elseif PingValue < 7 then
							PingValue = 500
						elseif PingValue < 10 then
							PingValue = 999
						end
					end
					ScoreboardRow.pingValue:setText(PingValue)
					ScoreboardRow.pingValue:setAlpha(1)
				end
			else
				ScoreboardRow.pingValue:setAlpha(0)
			end
		else
			if ScoreboardRow.voipIcon ~= nil then
				ScoreboardRow.voipIcon:close()
			end
			for ColumnIndex = 1, MaxColumns, 1 do
				if ScoreboardRow.columns[ColumnIndex] then
					ScoreboardRow.columns[ColumnIndex]:setText("")
				end
			end
			if ScoreboardRow.pingBars ~= nil then
				ScoreboardRow.pingBars:setAlpha(0)
			end
			if ScoreboardRow.pingValue ~= nil then
				ScoreboardRow.pingValue:setAlpha(0)
			end
		end
	else
		ScoreboardRow.clientNum = nil
		ScoreboardRow.focusableRowIndex = nil
		ScoreboardRow.statusIcon:setAlpha(0)
		if ScoreboardRow.rankText ~= nil then
			ScoreboardRow.rankText:setText("")
		end
		if ScoreboardRow.rankIcon ~= nil then
			ScoreboardRow.rankIcon:setAlpha(0)
		end
		ScoreboardRow.playerName:setText("")
		if ScoreboardRow.voipIcon ~= nil then
			ScoreboardRow.voipIcon:close()
		end
		for ColumnIndex = 1, MaxColumns, 1 do
			if ScoreboardRow.columns[ColumnIndex] then
				ScoreboardRow.columns[ColumnIndex]:setText("")
			end
		end
		if ScoreboardRow.pingBars ~= nil then
			ScoreboardRow.pingBars:setAlpha(0)
		end
		if ScoreboardRow.pingValue ~= nil then
			ScoreboardRow.pingValue:setAlpha(0)
		end
	end
	return VerticalOffset
end

CoD.ScoreboardRow.gainFocus = function(Button, EventGainFocus)
	CoD.ScoreboardRow.super.gainFocus(Button, EventGainFocus)
	Button.border:setAlpha(1)
	Button:dispatchEventToChildren(EventGainFocus)
	SCOREBOARD_ROW_SELECTED.row = Button
	Button:dispatchEventToParent(SCOREBOARD_ROW_SELECTED)
end

CoD.ScoreboardRow.loseFocus = function(Button, EventLoseFocus)
	CoD.ScoreboardRow.super.loseFocus(Button, EventLoseFocus)
	Button.border:setAlpha(0)
	Button:dispatchEventToChildren(EventLoseFocus)
end

CoD.ScoreboardRow.focusClient = function(ScoreboardWidget, EventFocusClient)
	if ScoreboardWidget.clientNum == EventFocusClient.clientNum then
		ScoreboardWidget:processEvent(LUI.UIButton.GainFocusEvent)
	elseif ScoreboardWidget:isInFocus() then
		ScoreboardWidget:processEvent(LUI.UIButton.LoseFocusEvent)
	end
end

CoD.ScoreboardRow:registerEventHandler("gain_focus", CoD.ScoreboardRow.gainFocus)
CoD.ScoreboardRow:registerEventHandler("lose_focus", CoD.ScoreboardRow.loseFocus)
CoD.ScoreboardRow:registerEventHandler("focus_client", CoD.ScoreboardRow.focusClient)

function Split(Source, Delimiters)
	local Elements = {}
	local Pattern = "([^" .. Delimiters .. "]+)"
	string.gsub(Source, Pattern, function(value)
		Elements[#Elements + 1] = value
	end)
	return Elements
end
