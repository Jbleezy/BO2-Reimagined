require("T6.Zombie.CraftablesIcon")

CoD.QuestItemDisplay = {}
CoD.QuestItemDisplay.IconSize = 48
CoD.QuestItemDisplay.FontName = CoD.CraftablesIcon.FontName
CoD.QuestItemDisplay.ContainerSize = CoD.QuestItemDisplay.IconSize + CoD.textSize[CoD.QuestItemDisplay.FontName] + 5
CoD.QuestItemDisplay.IconSpacing = 5
CoD.QuestItemDisplay.NeedItemAlpha = 0.2
CoD.QuestItemDisplay.CrossoutAlpha = 0.75
CoD.QuestItemDisplay.glowBackColor = {}
CoD.QuestItemDisplay.glowBackColor.r = 1
CoD.QuestItemDisplay.glowBackColor.g = 1
CoD.QuestItemDisplay.glowBackColor.b = 1
CoD.QuestItemDisplay.glowFrontColor = {}
CoD.QuestItemDisplay.glowFrontColor.r = 1
CoD.QuestItemDisplay.glowFrontColor.g = 1
CoD.QuestItemDisplay.glowFrontColor.b = 1
CoD.QuestItemDisplay.MOVING_DURATION = 500
CoD.QuestItemDisplay.ONSCREEN_DURATION = 5000
CoD.QuestItemDisplay.FADE_OUT_DURATION = 500
CoD.QuestItemDisplay.ClientFieldName = "craftable"
CoD.QuestItemDisplay.PlayerClientFieldCount = 4
CoD.QuestItemDisplay.PlayerClientFieldName = "piece_player"
CoD.QuestItemDisplay.KeyClientFieldName = "piece_key_warden"
CoD.QuestItemDisplay.PlaneCraftedClientFieldName = "quest_plane_craft_complete"
CoD.QuestItemDisplay.CRAFTABLE_ITEM_NONE = 0
CoD.QuestItemDisplay.STATE_NEED_FIRST_ITEM = 0
CoD.QuestItemDisplay.STATE_HAVE_FIRST_ITEM = 1
CoD.QuestItemDisplay.STATE_NEED_SECOND_ITEM = 2
CoD.QuestItemDisplay.STATE_HAVE_SECOND_ITEM = 3
CoD.QuestItemDisplay.STATE_USED_SECOND_ITEM = 4
CoD.QuestItemDisplay.STATE_NEED_THIRD_ITEM = 5
CoD.QuestItemDisplay.STATE_HAVE_THIRD_ITEM = 6
CoD.QuestItemDisplay.STATE_USED_THIRD_ITEM = 7
CoD.QuestItemDisplay.ClientFieldNames = {}
CoD.QuestItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON] = {}
CoD.QuestItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][1] = {
	clientFieldName = "quest_state1",
	materialName = "zom_hud_craftable_plane_cloth",
}
CoD.QuestItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][2] = {
	clientFieldName = "quest_state2",
	materialName = "zom_hud_craftable_plane_tanks",
}
CoD.QuestItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][3] = {
	clientFieldName = "quest_state3",
	materialName = "zom_hud_craftable_plane_engines",
}
CoD.QuestItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][4] = {
	clientFieldName = "quest_state4",
	materialName = "zom_hud_craftable_plane_valve",
}
CoD.QuestItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][5] = {
	clientFieldName = "quest_state5",
	materialName = "zom_hud_craftable_plane_rigging",
}
CoD.QuestItemDisplay.QuestItemName = {}
CoD.QuestItemDisplay.QuestItemName[CoD.Zombie.MAP_ZM_PRISON] = Engine.Localize("ZM_PRISON_PLANE_PARTS")
CoD.QuestItemDisplay.new = function(f1_arg0)
	f1_arg0.id = f1_arg0.id .. ".QuestItemDisplay"
	CoD.QuestItemDisplay.CurrentMapName = CoD.Zombie.GetUIMapName()
	local f1_local0 = CoD.QuestItemDisplay.CurrentMapName
	if not CoD.QuestItemDisplay.ClientFieldNames[f1_local0] then
		return
	elseif f1_local0 and CoD.QuestItemDisplay.ClientFieldNames[f1_local0] then
		for f1_local1 = 1, #CoD.QuestItemDisplay.ClientFieldNames[f1_local0], 1 do
			if not CoD.QuestItemDisplay.ClientFieldNames[f1_local0][f1_local1].material then
				CoD.QuestItemDisplay.ClientFieldNames[f1_local0][f1_local1].material = RegisterMaterial(CoD.QuestItemDisplay.ClientFieldNames[f1_local0][f1_local1].materialName)
			end
		end
	end
	CoD.QuestItemDisplay.PreviousIconIndexPerController = {
		-1,
		-1,
		-1,
		-1,
	}
	CoD.QuestItemDisplay.CurrentIconIndexPerController = {
		-1,
		-1,
		-1,
		-1,
	}
	CoD.QuestItemDisplay.StatusStates = {
		-1,
		-1,
		-1,
		-1,
		-1,
	}
	CoD.QuestItemDisplay.PlayerPieceInfo = {
		0,
		0,
		0,
		0,
		0,
	}
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) then
		if CoD.QuestItemDisplay.QuestPlusMaterial == nil then
			CoD.QuestItemDisplay.QuestPlusMaterial = RegisterMaterial("zom_hud_craftable_plane_gascan")
		end
		if CoD.QuestItemDisplay.KeyMaterial == nil then
			CoD.QuestItemDisplay.KeyMaterial = RegisterMaterial("zom_hud_icon_epod_key")
		end
		if CoD.QuestItemDisplay.CrossoutMaterial == nil then
			CoD.QuestItemDisplay.CrossoutMaterial = RegisterMaterial("hud_zombie_checkmark")
		end
		CoD.QuestItemDisplay.HaveKeyInScoreboard = false
	end
	f1_arg0:registerEventHandler(CoD.QuestItemDisplay.ClientFieldName, CoD.QuestItemDisplay.PersistentIconUpdate)
	f1_arg0:registerEventHandler("quest_status_group_fade_out", CoD.QuestItemDisplay.FadeoutQuestStatusContainer)
	if CoD.Zombie.SoloQuestMode == false then
		for f1_local1 = 1, CoD.QuestItemDisplay.PlayerClientFieldCount, 1 do
			f1_arg0:registerEventHandler(CoD.QuestItemDisplay.PlayerClientFieldName .. f1_local1, CoD.QuestItemDisplay.PlayerPieceOwner)
		end
	end
	CoD.QuestItemDisplay.QuestClientFieldCount = #CoD.QuestItemDisplay.ClientFieldNames[f1_local0]
	for f1_local1 = 1, CoD.QuestItemDisplay.QuestClientFieldCount, 1 do
		f1_arg0:registerEventHandler(CoD.QuestItemDisplay.ClientFieldNames[f1_local0][f1_local1].clientFieldName, CoD.QuestItemDisplay.UpdateQuest)
	end
	f1_arg0:registerEventHandler(CoD.QuestItemDisplay.KeyClientFieldName, CoD.QuestItemDisplay.UpdateKeyStatus)
	f1_arg0:registerEventHandler(CoD.QuestItemDisplay.PlaneCraftedClientFieldName, CoD.QuestItemDisplay.UpdatedPlaneCompletedStatus)
	f1_arg0.visible = true
	return f1_arg0
end

CoD.QuestItemDisplay.AddPersistentIcon = function(f2_arg0)
	local f2_local0 = 0
	local f2_local1 = 0
	local self = LUI.UIElement.new()
	self:setLeftRight(true, false, f2_local0, f2_local0 + CoD.QuestItemDisplay.ContainerSize)
	self:setTopBottom(true, false, f2_local1, f2_local1 + CoD.QuestItemDisplay.ContainerSize)
	self:setAlpha(0)
	f2_arg0.persQuestContainer = self
	if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
		local f2_local3 = LUI.UIText.new()
		f2_local3:setLeftRight(true, false, 0, 250)
		f2_local3:setTopBottom(true, false, 0, CoD.textSize[CoD.QuestItemDisplay.FontName])
		f2_local3:setFont(CoD.fonts[CoD.QuestItemDisplay.FontName])
		f2_local3:setAlignment(LUI.Alignment.Left)
		self:addElement(f2_local3)
		f2_local3:setText(Engine.Localize("ZMUI_QUEST_ITEM"))
		f2_arg0.persQuestTitle = f2_local3
	end
	local f2_local3 = LUI.UIElement.new()
	f2_local3:setLeftRight(true, false, 0, CoD.QuestItemDisplay.IconSize)
	f2_local3:setTopBottom(false, true, -CoD.QuestItemDisplay.IconSize, 0)
	self:addElement(f2_local3)
	CoD.CraftablesIcon.new(f2_local3, CoD.QuestItemDisplay.glowBackColor, CoD.QuestItemDisplay.glowFrontColor)
	-- if f2_local3.grunge then
	-- 	f2_local3.grunge:setAlpha(CoD.CraftablesIcon.GrungeAlpha)
	-- end
	local f2_local4 = LUI.UIImage.new()
	f2_local4:setLeftRight(true, true, 0, 0)
	f2_local4:setTopBottom(true, true, 0, 0)
	f2_local4:setAlpha(0)
	f2_local4.inUse = nil
	f2_arg0.craftableIcon = f2_local4
	f2_local3:addElement(f2_local4)

	f2_local4.highlight = CoD.Border.new(1, 1, 1, 1, 0.1)
	f2_local4.highlight:setPriority(100)
	f2_local4.highlight:setLeftRight(true, true, 0, 0)
	f2_local4.highlight:setTopBottom(true, true, 0, 0)
	f2_local4.highlight:registerEventHandler("button_over", CoD.CraftablesIcon.HighlightButtonOver)
	f2_local4.highlight:registerEventHandler("button_up", CoD.CraftablesIcon.HighlightButtonUp)
	f2_local4:addElement(f2_local4.highlight)

	f2_arg0:addElement(self)
end

CoD.QuestItemDisplay.AddQuestStatusDisplay = function(f3_arg0, f3_arg1, f3_arg2, f3_arg3, f3_arg4)
	local f3_local0 = CoD.QuestItemDisplay.CurrentMapName
	local f3_local1 = 0
	local f3_local2 = 0
	local f3_local3 = 0
	local f3_local4 = 0
	local f3_local5 = 0
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) and f3_arg2 == true then
		f3_local5 = CoD.QuestItemDisplay.IconSize
		local self = LUI.UIElement.new()
		self:setLeftRight(true, false, f3_local2, f3_local2 + f3_local5)
		self:setTopBottom(true, false, f3_local3, f3_local3 + CoD.QuestItemDisplay.ContainerSize)
		self:setAlpha(1)
		f3_arg0.keyStatusContainer = self
		if f3_arg3 == true and f3_arg4 then
			local f3_local7 = LUI.UIImage.new()
			f3_local7:setLeftRight(true, true, -f3_arg4, f3_arg4)
			f3_local7:setTopBottom(true, true, -f3_arg4, f3_arg4)
			f3_local7:setRGB(0, 0, 0)
			f3_local7:setAlpha(0.7)
			self:addElement(f3_local7)
			f3_local1 = f3_local1 + f3_arg4
		end
		local f3_local7 = LUI.UIText.new()
		f3_local7:setLeftRight(true, false, 0, 250)
		f3_local7:setTopBottom(true, false, 0, CoD.textSize[CoD.QuestItemDisplay.FontName])
		f3_local7:setFont(CoD.fonts[CoD.QuestItemDisplay.FontName])
		f3_local7:setAlignment(LUI.Alignment.Left)
		self:addElement(f3_local7)
		f3_local7:setText(Engine.Localize("ZMUI_KEY"))
		f3_arg0.keyStatusTitle = f3_local7
		f3_arg0:addElement(self)
		local f3_local8 = LUI.UIElement.new()
		f3_local8:setLeftRight(true, false, f3_local4, f3_local4 + CoD.QuestItemDisplay.IconSize)
		f3_local8:setTopBottom(false, true, -CoD.QuestItemDisplay.IconSize, 0)
		self:addElement(f3_local8)
		CoD.CraftablesIcon.new(f3_local8, CoD.QuestItemDisplay.glowBackColor, CoD.QuestItemDisplay.glowFrontColor)
		local f3_local9 = LUI.UIImage.new()
		f3_local9:setLeftRight(true, true, 0, 0)
		f3_local9:setTopBottom(true, true, 0, 0)
		f3_local9:setImage(CoD.QuestItemDisplay.KeyMaterial)
		f3_local9:setAlpha(CoD.QuestItemDisplay.NeedItemAlpha)
		f3_arg0.keyStatusContainer.icon = f3_local9
		f3_local8:addElement(f3_local9)
		f3_local4 = f3_local4 + CoD.QuestItemDisplay.IconSize + CoD.QuestItemDisplay.IconSpacing
		f3_local1 = f3_local1 + f3_local5 + f3_arg1
		f3_arg0:addSpacer(f3_arg1)
	end
	local self = CoD.QuestItemDisplay.QuestClientFieldCount
	f3_local5 = CoD.QuestItemDisplay.IconSize * self + CoD.QuestItemDisplay.IconSpacing * (self - 1)
	local f3_local7 = LUI.UIElement.new()
	f3_local7:setLeftRight(true, false, f3_local2, f3_local2 + f3_local5)
	f3_local7:setTopBottom(true, false, f3_local3, f3_local3 + CoD.QuestItemDisplay.ContainerSize)
	f3_local7:setAlpha(0)
	f3_arg0.questStatusContainer = f3_local7
	if f3_arg3 == true and f3_arg4 then
		local f3_local8 = LUI.UIImage.new()
		f3_local8:setLeftRight(true, true, -f3_arg4, f3_arg4)
		f3_local8:setTopBottom(true, true, -f3_arg4, f3_arg4)
		f3_local8:setRGB(0, 0, 0)
		f3_local8:setAlpha(0.7)
		f3_local7:addElement(f3_local8)
	end
	local f3_local8 = LUI.UIText.new()
	f3_local8:setLeftRight(true, false, 0, 250)
	f3_local8:setTopBottom(true, false, 0, CoD.textSize[CoD.QuestItemDisplay.FontName])
	f3_local8:setFont(CoD.fonts[CoD.QuestItemDisplay.FontName])
	f3_local8:setAlignment(LUI.Alignment.Left)
	f3_local7:addElement(f3_local8)
	f3_local8:setText(CoD.QuestItemDisplay.QuestItemName[f3_local0])
	f3_arg0.questStatusTitle = f3_local8
	local f3_local9 = 0
	local f3_local10 = 5
	local f3_local11 = -2
	local f3_local12 = "ExtraSmall"
	f3_arg0.statusIcons = {}
	for f3_local13 = 1, CoD.QuestItemDisplay.QuestClientFieldCount, 1 do
		local f3_local16 = LUI.UIElement.new()
		f3_local16:setLeftRight(true, false, f3_local9, f3_local9 + CoD.QuestItemDisplay.IconSize)
		f3_local16:setTopBottom(false, true, -CoD.QuestItemDisplay.IconSize, 0)
		f3_local7:addElement(f3_local16)
		CoD.CraftablesIcon.new(f3_local16, CoD.QuestItemDisplay.glowBackColor, CoD.QuestItemDisplay.glowFrontColor)
		local f3_local17 = LUI.UIImage.new()
		f3_local17:setLeftRight(true, true, 0, 0)
		f3_local17:setTopBottom(true, true, 0, 0)
		f3_local17:setAlpha(CoD.QuestItemDisplay.NeedItemAlpha)
		f3_local16.icon = f3_local17
		f3_local16:addElement(f3_local17)
		local f3_local18 = LUI.UIImage.new()
		f3_local18:setLeftRight(true, true, 0, 0)
		f3_local18:setTopBottom(true, true, 0, 0)
		f3_local18:setImage(CoD.QuestItemDisplay.CrossoutMaterial)
		f3_local18:setAlpha(0)
		f3_local16.crossoutImage = f3_local18
		f3_local16:addElement(f3_local18)

		local playerID = LUI.UIText.new()
		playerID:setLeftRight(true, true, 0, -f3_local10)
		playerID:setTopBottom(false, true, -CoD.textSize[f3_local12] + f3_local11, f3_local11)
		playerID:setFont(CoD.fonts[f3_local12])
		playerID:setAlignment(LUI.Alignment.Right)
		playerID:setAlpha(1)
		f3_local16:addElement(playerID)
		f3_local16.playerID = playerID

		f3_arg0.statusIcons[f3_local13] = f3_local16
		f3_arg0.statusIcons[f3_local13].clientFieldName = CoD.QuestItemDisplay.ClientFieldNames[f3_local0][f3_local13].clientFieldName
		f3_local9 = f3_local9 + CoD.QuestItemDisplay.IconSize + CoD.QuestItemDisplay.IconSpacing
	end
	CoD.QuestItemDisplay.StatusIconsCount = #f3_arg0.statusIcons
	f3_arg0:addElement(f3_local7)
	return f3_local1 + f3_local5 + f3_arg1
end

CoD.QuestItemDisplay.PlayerPieceOwner = function(f4_arg0, f4_arg1)
	local f4_local0 = 0
	if 0 < f4_arg1.oldValue then
		f4_local0 = (f4_arg1.oldValue - 1) % CoD.QuestItemDisplay.QuestClientFieldCount + 1
	end
	local f4_local1 = 0
	if 0 < f4_arg1.newValue then
		f4_local1 = (f4_arg1.newValue - 1) % CoD.QuestItemDisplay.QuestClientFieldCount + 1
	end
	local f4_local2 = tonumber(string.sub(f4_arg1.name, string.len(CoD.QuestItemDisplay.PlayerClientFieldName) + 1))
	if f4_local2 < 1 or f4_local2 > 4 then
		return
	elseif not f4_arg0.statusIcons then
		return
	elseif 0 < f4_local0 then
		f4_arg0.statusIcons[f4_local0].playerID:setText("")
		CoD.QuestItemDisplay.PlayerPieceInfo[f4_local0] = 0
	end
	if 0 < f4_local1 then
		f4_arg0.statusIcons[f4_local1].playerID:setRGB(CoD.Zombie.PlayerColors[f4_local2].r, CoD.Zombie.PlayerColors[f4_local2].g, CoD.Zombie.PlayerColors[f4_local2].b)
		f4_arg0.statusIcons[f4_local1].playerID:setText(Engine.Localize("ZMUI_PLAYER_NUM_" .. f4_local2))
		CoD.QuestItemDisplay.PlayerPieceInfo[f4_local1] = f4_local2
	end
end

CoD.QuestItemDisplay.UpdateQuest = function(f5_arg0, f5_arg1)
	CoD.QuestItemDisplay.UpdateQuestStatus(f5_arg0, f5_arg1)
	if f5_arg1.oldValue ~= 0 or f5_arg1.newValue ~= 0 then
		if f5_arg0.questStatusContainer then
			f5_arg0.questStatusContainer:beginAnimation("fade_in", CoD.QuestItemDisplay.FADE_OUT_DURATION)
			f5_arg0.questStatusContainer:setAlpha(1)
		end
		if f5_arg0.persQuestTitle then
			f5_arg0.persQuestTitle:beginAnimation("fade_in", CoD.QuestItemDisplay.FADE_OUT_DURATION)
			f5_arg0.persQuestTitle:setAlpha(1)
		end
	end
	if f5_arg0.shouldFadeOutQuestStatus then
		CoD.QuestItemDisplay.AddFadeOutTimer(f5_arg0)
	end
end

CoD.QuestItemDisplay.ScoreboardUpdate = function(f6_arg0, f6_arg1)
	if f6_arg0.questStatusContainer then
		for f6_local0 = 1, #CoD.QuestItemDisplay.StatusStates, 1 do
			CoD.QuestItemDisplay.UpdateQuestStates(f6_arg0.statusIcons[f6_local0], CoD.QuestItemDisplay.StatusStates[f6_local0])
		end
	end
	if f6_arg0.statusIcons then
		for f6_local0 = 1, #CoD.QuestItemDisplay.PlayerPieceInfo, 1 do
			local f6_local3 = CoD.QuestItemDisplay.PlayerPieceInfo[f6_local0]
			if f6_local3 == 0 then
				f6_arg0.statusIcons[f6_local0].playerID:setText("")
			else
				f6_arg0.statusIcons[f6_local0].playerID:setRGB(CoD.Zombie.PlayerColors[f6_local3].r, CoD.Zombie.PlayerColors[f6_local3].g, CoD.Zombie.PlayerColors[f6_local3].b)
				f6_arg0.statusIcons[f6_local0].playerID:setText(Engine.Localize("ZMUI_PLAYER_NUM_" .. f6_local3))
			end
		end
	end
	local f6_local0 = CoD.QuestItemDisplay.PreviousIconIndexPerController[f6_arg1.controller + 1]
	local f6_local1 = CoD.QuestItemDisplay.CurrentIconIndexPerController[f6_arg1.controller + 1]
	CoD.QuestItemDisplay.UpdateKeyIconState(f6_arg0, f6_local0, f6_local1)
	CoD.QuestItemDisplay.UpdatePersistentIconState(f6_arg0, f6_local0, f6_local1)
	if CoD.Zombie.SoloQuestMode == false then
		CoD.QuestItemDisplay.UpdateHighlight(f6_arg0, f6_local0, f6_local1)
	end
end

CoD.QuestItemDisplay.AddFadeOutTimer = function(f7_arg0)
	if f7_arg0.questStatusContainer then
		if f7_arg0.fadeOutTimer then
			f7_arg0.fadeOutTimer:close()
			f7_arg0.fadeOutTimer:reset()
		end
		f7_arg0.fadeOutTimer = LUI.UITimer.new(CoD.QuestItemDisplay.ONSCREEN_DURATION, "quest_status_group_fade_out", true, f7_arg0)
		f7_arg0:addElement(f7_arg0.fadeOutTimer)
	end
end

CoD.QuestItemDisplay.FadeoutQuestStatusContainer = function(f8_arg0, f8_arg1)
	if f8_arg0.questStatusContainer then
		f8_arg0.questStatusContainer:beginAnimation("fade_out", CoD.QuestItemDisplay.FADE_OUT_DURATION)
		f8_arg0.questStatusContainer:setAlpha(0)
	end
	if f8_arg0.persQuestContainer then
		f8_arg0.persQuestContainer:beginAnimation("fade_out", CoD.QuestItemDisplay.FADE_OUT_DURATION)
		f8_arg0.persQuestContainer:setAlpha(0)
	end
end

CoD.QuestItemDisplay.UpdateQuestStatus = function(f9_arg0, f9_arg1)
	local f9_local0 = f9_arg1.newValue
	local f9_local1 = f9_arg1.oldValue
	local f9_local2 = CoD.QuestItemDisplay.GetCurrentStatusIndex(f9_arg0, f9_arg1.name)
	CoD.QuestItemDisplay.StatusStates[f9_local2] = f9_local0
	if not f9_arg0.statusIcons then
		return
	end
	local f9_local3 = f9_arg0.statusIcons[f9_local2]
	if not f9_local3 then
		return
	elseif f9_arg0.highlightRecentItem then
		if f9_local3.highlight.alternatorTimer then
			f9_local3.highlight:closeStateAlternator()
		end
		if f9_local1 < f9_local0 then
			f9_local3.highlight:alternateStates(CoD.QuestItemDisplay.ONSCREEN_DURATION, CoD.CraftablesIcon.PulseRedBright, CoD.CraftablesIcon.PulseRedLow, 500, 500, CoD.CraftablesIcon.PulseWhite)
		end
	end
	CoD.QuestItemDisplay.UpdateQuestStates(f9_local3, f9_local0)
end

CoD.QuestItemDisplay.UpdateQuestStates = function(f10_arg0, f10_arg1)
	if f10_arg1 == CoD.QuestItemDisplay.STATE_NEED_FIRST_ITEM or f10_arg1 == CoD.QuestItemDisplay.STATE_HAVE_FIRST_ITEM or f10_arg1 == CoD.QuestItemDisplay.STATE_NEED_SECOND_ITEM then
		f10_arg0.crossoutImage:setAlpha(0)
		-- if f10_arg0.grunge then
		-- 	f10_arg0.grunge:setAlpha(0)
		-- end
		f10_arg0.icon:setImage(CoD.QuestItemDisplay.GetMaterial(f10_arg0.clientFieldName))
		f10_arg0.icon:setAlpha(CoD.QuestItemDisplay.NeedItemAlpha)
	elseif f10_arg1 == CoD.QuestItemDisplay.STATE_HAVE_SECOND_ITEM then
		f10_arg0.crossoutImage:setAlpha(0)
		-- if f10_arg0.grunge then
		-- 	f10_arg0.grunge:setAlpha(CoD.CraftablesIcon.GrungeAlpha)
		-- end
		f10_arg0.icon:setImage(CoD.QuestItemDisplay.GetMaterial(f10_arg0.clientFieldName))
		f10_arg0.icon:setAlpha(1)
	elseif f10_arg1 == CoD.QuestItemDisplay.STATE_USED_SECOND_ITEM then
		f10_arg0.crossoutImage:setAlpha(CoD.QuestItemDisplay.CrossoutAlpha)
		f10_arg0.icon:setImage(CoD.QuestItemDisplay.GetMaterial(f10_arg0.clientFieldName))
		f10_arg0.icon:setAlpha(CoD.QuestItemDisplay.NeedItemAlpha)
	elseif f10_arg1 == CoD.QuestItemDisplay.STATE_NEED_THIRD_ITEM then
		f10_arg0.crossoutImage:setAlpha(0)
		-- if f10_arg0.grunge then
		-- 	f10_arg0.grunge:setAlpha(0)
		-- end
		f10_arg0.icon:setImage(CoD.QuestItemDisplay.QuestPlusMaterial)
		f10_arg0.icon:setAlpha(CoD.QuestItemDisplay.NeedItemAlpha)
	elseif f10_arg1 == CoD.QuestItemDisplay.STATE_HAVE_THIRD_ITEM then
		f10_arg0.crossoutImage:setAlpha(0)
		-- if f10_arg0.grunge then
		-- 	f10_arg0.grunge:setAlpha(CoD.CraftablesIcon.GrungeAlpha)
		-- end
		f10_arg0.icon:setImage(CoD.QuestItemDisplay.QuestPlusMaterial)
		f10_arg0.icon:setAlpha(1)
	elseif f10_arg1 == CoD.QuestItemDisplay.STATE_USED_THIRD_ITEM then
		f10_arg0.crossoutImage:setAlpha(CoD.QuestItemDisplay.CrossoutAlpha)
		f10_arg0.icon:setImage(CoD.QuestItemDisplay.QuestPlusMaterial)
		f10_arg0.icon:setAlpha(0.5)
	end
end

CoD.QuestItemDisplay.PersistentIconUpdate = function(f11_arg0, f11_arg1)
	CoD.QuestItemDisplay.PreviousIconIndexPerController[f11_arg1.controller + 1] = f11_arg1.oldValue
	CoD.QuestItemDisplay.CurrentIconIndexPerController[f11_arg1.controller + 1] = f11_arg1.newValue
	CoD.QuestItemDisplay.UpdatePersistentIconState(f11_arg0, f11_arg1.oldValue, f11_arg1.newValue)
	CoD.QuestItemDisplay.UpdateHighlight(f11_arg0, f11_arg1.oldValue, f11_arg1.newValue)
end

CoD.QuestItemDisplay.UpdateHighlight = function(f12_arg0, f12_arg1, f12_arg2)
	if f12_arg0.showPlayerHighlight and f12_arg0.statusIcons then
		for f12_local0 = 1, #f12_arg0.statusIcons, 1 do
			f12_arg0.statusIcons[f12_local0].highlight:setAlpha(0.1)
		end
		if f12_arg2 > 0 and f12_arg2 <= #f12_arg0.statusIcons then
			f12_arg0.statusIcons[f12_arg2].highlight:setAlpha(1)
		end
	end
end

CoD.QuestItemDisplay.UpdatePersistentIconState = function(f13_arg0, f13_arg1, f13_arg2)
	local f13_local0 = CoD.QuestItemDisplay.CurrentMapName
	if not f13_local0 or f13_arg2 < 0 then
		return
	elseif f13_arg0.craftableIcon then
		if f13_arg2 == CoD.QuestItemDisplay.CRAFTABLE_ITEM_NONE then
			f13_arg0.craftableIcon.inUse = nil
			if f13_arg0.isPlaneCraftedCompleted == true then
				f13_arg0:beginAnimation("fade_out", CoD.QuestItemDisplay.FADE_OUT_DURATION)
				f13_arg0.persQuestContainer:setAlpha(0)
			elseif CoD.QuestItemDisplay.HaveKeyInScoreboard == true then
				f13_arg0.craftableIcon:setAlpha(1)
				f13_arg0.craftableIcon:setImage(CoD.QuestItemDisplay.KeyMaterial)
				if f13_arg0.persQuestTitle then
					f13_arg0.persQuestTitle:setText(Engine.Localize("ZMUI_KEY"))
					f13_arg0.persQuestTitle:setAlpha(1)
				end
				CoD.QuestItemDisplay.AddFadeOutTimer(f13_arg0)
			else
				f13_arg0.persQuestContainer:beginAnimation("fade_out", CoD.QuestItemDisplay.FADE_OUT_DURATION)
				f13_arg0.persQuestContainer:setAlpha(0)
			end
		else
			if CoD.QuestItemDisplay.ClientFieldNames[f13_local0] then
				f13_arg0.craftableIcon:setAlpha(1)
				if CoD.QuestItemDisplay.STATE_HAVE_THIRD_ITEM <= f13_arg2 then
					f13_arg0.craftableIcon:setImage(CoD.QuestItemDisplay.QuestPlusMaterial)
				else
					f13_arg0.craftableIcon:setImage(CoD.QuestItemDisplay.ClientFieldNames[f13_local0][f13_arg2].material)
				end
				f13_arg0.craftableIcon.inUse = true
			end
			if f13_arg0.persQuestTitle then
				f13_arg0.persQuestTitle:setText(Engine.Localize("ZMUI_QUEST_ITEM"))
			end
			f13_arg0.persQuestContainer:setAlpha(1)
		end
	end
end

CoD.QuestItemDisplay.UpdateKeyStatus = function(f14_arg0, f14_arg1)
	CoD.QuestItemDisplay.HaveKeyInScoreboard = true
	CoD.QuestItemDisplay.UpdateKeyIconState(f14_arg0, f14_arg1.oldValue, f14_arg1.newValue)
end

CoD.QuestItemDisplay.UpdateKeyIconState = function(f15_arg0, f15_arg1, f15_arg2)
	if not CoD.QuestItemDisplay.CurrentMapName or f15_arg2 < 0 then
		return
	elseif f15_arg0.craftableIcon and f15_arg1 == 0 and f15_arg2 == 1 then
		f15_arg0.craftableIcon:setAlpha(1)
		f15_arg0.craftableIcon:setImage(CoD.QuestItemDisplay.KeyMaterial)
		f15_arg0.craftableIcon.highlight:alternateStates(CoD.QuestItemDisplay.ONSCREEN_DURATION, CoD.CraftablesIcon.PulseRedBright, CoD.CraftablesIcon.PulseRedLow, 500, 500, CoD.CraftablesIcon.PulseWhite)
		f15_arg0.craftableIcon.inUse = true
		f15_arg0.persQuestContainer:setAlpha(1)
		if f15_arg0.persQuestTitle then
			f15_arg0.persQuestTitle:setText(Engine.Localize("ZMUI_KEY"))
			f15_arg0.persQuestTitle:beginAnimation("fade_in", CoD.QuestItemDisplay.FADE_OUT_DURATION)
			f15_arg0.persQuestTitle:setAlpha(1)
		end
		CoD.QuestItemDisplay.AddFadeOutTimer(f15_arg0)
	end
	if f15_arg0.keyStatusContainer and CoD.QuestItemDisplay.HaveKeyInScoreboard == true then
		f15_arg0.keyStatusContainer.icon:setAlpha(1)
	end
end

CoD.QuestItemDisplay.UpdatedPlaneCompletedStatus = function(f16_arg0, f16_arg1)
	if f16_arg1.newValue == 0 then
		f16_arg0.isPlaneCraftedCompleted = false
	else
		f16_arg0.isPlaneCraftedCompleted = true
		if f16_arg0.persQuestContainer then
			f16_arg0.persQuestContainer:setAlpha(0)
		end
	end
end

CoD.QuestItemDisplay.GetCurrentStatusIndex = function(f17_arg0, f17_arg1)
	local f17_local0 = CoD.QuestItemDisplay.CurrentMapName
	for f17_local1 = 1, #CoD.QuestItemDisplay.ClientFieldNames[f17_local0], 1 do
		if CoD.QuestItemDisplay.ClientFieldNames[f17_local0][f17_local1].clientFieldName == f17_arg1 then
			return f17_local1
		end
	end
end

CoD.QuestItemDisplay.GetMaterial = function(f18_arg0)
	local f18_local0 = CoD.QuestItemDisplay.CurrentMapName
	if not f18_local0 then
		return
	end
	local f18_local1 = nil
	for f18_local2 = 1, #CoD.QuestItemDisplay.ClientFieldNames[f18_local0], 1 do
		if CoD.QuestItemDisplay.ClientFieldNames[f18_local0][f18_local2].clientFieldName == f18_arg0 then
			f18_local1 = CoD.QuestItemDisplay.ClientFieldNames[f18_local0][f18_local2].material
			break
		end
	end
	return f18_local1
end
