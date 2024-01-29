require("T6.Zombie.CraftablesIcon")

CoD.PersistentItemTombDisplay = {}
CoD.PersistentItemTombDisplay.IconSize = 48
CoD.PersistentItemTombDisplay.FontName = CoD.CraftablesIcon.FontName
CoD.PersistentItemTombDisplay.ContainerSize = CoD.PersistentItemTombDisplay.IconSize + CoD.textSize[CoD.PersistentItemTombDisplay.FontName] + 5
CoD.PersistentItemTombDisplay.IconSpacing = 5
CoD.PersistentItemTombDisplay.NeedItemAlpha = 0.2
CoD.PersistentItemTombDisplay.CrossoutAlpha = 0.75
CoD.PersistentItemTombDisplay.glowBackColor = {}
CoD.PersistentItemTombDisplay.glowBackColor.r = 1
CoD.PersistentItemTombDisplay.glowBackColor.g = 1
CoD.PersistentItemTombDisplay.glowBackColor.b = 1
CoD.PersistentItemTombDisplay.glowFrontColor = {}
CoD.PersistentItemTombDisplay.glowFrontColor.r = 1
CoD.PersistentItemTombDisplay.glowFrontColor.g = 1
CoD.PersistentItemTombDisplay.glowFrontColor.b = 1
CoD.PersistentItemTombDisplay.MOVING_DURATION = 500
CoD.PersistentItemTombDisplay.ONSCREEN_DURATION = 5000
CoD.PersistentItemTombDisplay.FADE_OUT_DURATION = 500
CoD.PersistentItemTombDisplay.ClientFieldName = "craftable"
CoD.PersistentItemTombDisplay.PersistentClientFieldName = "persistent_gem"
CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_NONE = 0
CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_FIRE = 1
CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_AIR = 2
CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_LIGHTNING = 3
CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_WATER = 4
CoD.PersistentItemTombDisplay.STATE_NOT_HOLDING = 0
CoD.PersistentItemTombDisplay.STATE_HOLDING = 1
CoD.PersistentItemTombDisplay.ClientFieldNames = {}
CoD.PersistentItemTombDisplay.ClientFieldNames[1] = {
	clientFieldName = "piece_record_zm_player",
	materialName = "zom_hud_craftable_gramophone",
	iconStartAlpha = CoD.PersistentItemTombDisplay.NeedItemAlpha,
}
CoD.PersistentItemTombDisplay.ClientFieldNames[2] = {
	clientFieldName = "piece_record_zm_vinyl_master",
	materialName = "zom_hud_craftable_record",
	iconStartAlpha = CoD.PersistentItemTombDisplay.NeedItemAlpha,
}
CoD.PersistentItemTombDisplay.ClientFieldNames[3] = {
	clientFieldName = CoD.PersistentItemTombDisplay.PersistentClientFieldName,
	materialName = "white",
	iconStartAlpha = 0,
}
CoD.PersistentItemTombDisplay.GemClientFieldNames = {}
CoD.PersistentItemTombDisplay.GemClientFieldNames[1] = {
	clientFieldName = "piece_staff_zm_gem_fire",
	materialName = "zom_hud_craftable_element_fire",
}
CoD.PersistentItemTombDisplay.GemClientFieldNames[2] = {
	clientFieldName = "piece_staff_zm_gem_air",
	materialName = "zom_hud_craftable_element_wind",
}
CoD.PersistentItemTombDisplay.GemClientFieldNames[3] = {
	clientFieldName = "piece_staff_zm_gem_lightning",
	materialName = "zom_hud_craftable_element_lightning",
}
CoD.PersistentItemTombDisplay.GemClientFieldNames[4] = {
	clientFieldName = "piece_staff_zm_gem_water",
	materialName = "zom_hud_craftable_element_water",
}
CoD.PersistentItemTombDisplay.QuestItemName = Engine.Localize("ZM_TOMB_EQUIPMENT")
CoD.PersistentItemTombDisplay.new = function(f1_arg0)
	f1_arg0.id = f1_arg0.id .. ".PersistentItemTombDisplay"
	for f1_local0 = 1, #CoD.PersistentItemTombDisplay.ClientFieldNames, 1 do
		if not CoD.PersistentItemTombDisplay.ClientFieldNames[f1_local0].material then
			CoD.PersistentItemTombDisplay.ClientFieldNames[f1_local0].material = RegisterMaterial(CoD.PersistentItemTombDisplay.ClientFieldNames[f1_local0].materialName)
		end
	end
	CoD.PersistentItemTombDisplay.StatusStates = {
		-1,
		-1,
	}
	CoD.PersistentItemTombDisplay.GemStatusStates = {}
	CoD.PersistentItemTombDisplay.GemStatusStates[1] = {
		gemIndex = #CoD.PersistentItemTombDisplay.StatusStates + 1,
	}
	f1_arg0:registerEventHandler("persistent_status_group_fade_out", CoD.PersistentItemTombDisplay.FadeoutQuestStatusContainer)
	CoD.PersistentItemTombDisplay.QuestClientFieldCount = #CoD.PersistentItemTombDisplay.ClientFieldNames
	for f1_local0 = 1, CoD.PersistentItemTombDisplay.QuestClientFieldCount, 1 do
		f1_arg0:registerEventHandler(CoD.PersistentItemTombDisplay.ClientFieldNames[f1_local0].clientFieldName, CoD.PersistentItemTombDisplay.UpdateQuest)
	end
	f1_arg0:registerEventHandler(CoD.PersistentItemTombDisplay.ClientFieldName, CoD.PersistentItemTombDisplay.PersistentIconUpdate)
	for f1_local0 = 1, #CoD.PersistentItemTombDisplay.GemClientFieldNames, 1 do
		if not CoD.PersistentItemTombDisplay.GemClientFieldNames[f1_local0].material then
			CoD.PersistentItemTombDisplay.GemClientFieldNames[f1_local0].material = RegisterMaterial(CoD.PersistentItemTombDisplay.GemClientFieldNames[f1_local0].materialName)
		end
	end
	f1_arg0.visible = true
	return f1_arg0
end

CoD.PersistentItemTombDisplay.AddPersistentStatusDisplay = function(f2_arg0, f2_arg1, f2_arg2, f2_arg3, f2_arg4)
	local f2_local0 = 0
	local f2_local1 = 0
	local f2_local2 = 0
	local f2_local3 = 0
	local f2_local4 = 0
	if not f2_arg4 then
		f2_arg4 = 0
	end
	local f2_local5 = CoD.PersistentItemTombDisplay.QuestClientFieldCount
	f2_local4 = CoD.PersistentItemTombDisplay.IconSize * f2_local5 + CoD.PersistentItemTombDisplay.IconSpacing * (f2_local5 - 1)
	local self = LUI.UIElement.new()
	self:setLeftRight(true, false, f2_local1, f2_local1 + f2_local4)
	self:setTopBottom(true, false, f2_local2, f2_local2 + CoD.PersistentItemTombDisplay.ContainerSize + f2_arg4)
	if not f2_arg2 then
		self:setAlpha(0)
	end
	f2_arg0.questStatusContainer = self
	if f2_arg2 == true and f2_arg3 then
		local f2_local7 = LUI.UIImage.new()
		f2_local7:setLeftRight(true, true, -f2_arg3, f2_arg3)
		f2_local7:setTopBottom(true, true, -f2_arg3, f2_arg3)
		f2_local7:setRGB(0, 0, 0)
		f2_local7:setAlpha(0.7)
		self:addElement(f2_local7)
	end
	if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
		local f2_local7 = LUI.UIText.new()
		f2_local7:setLeftRight(true, false, 0, 250)
		f2_local7:setTopBottom(true, false, 0, CoD.textSize[CoD.PersistentItemTombDisplay.FontName])
		f2_local7:setFont(CoD.fonts[CoD.PersistentItemTombDisplay.FontName])
		f2_local7:setAlignment(LUI.Alignment.Left)
		self:addElement(f2_local7)
		f2_local7:setText(CoD.PersistentItemTombDisplay.QuestItemName)
	end
	local f2_local7 = 0
	f2_arg0.statusIcons = {}
	for f2_local8 = 1, CoD.PersistentItemTombDisplay.QuestClientFieldCount, 1 do
		local f2_local11 = LUI.UIElement.new()
		f2_local11:setLeftRight(true, false, f2_local7, f2_local7 + CoD.PersistentItemTombDisplay.IconSize)
		f2_local11:setTopBottom(false, true, -CoD.PersistentItemTombDisplay.IconSize, 0)
		if not f2_arg2 then
			f2_local11:setAlpha(0)
		end
		self:addElement(f2_local11)
		CoD.CraftablesIcon.new(f2_local11, CoD.PersistentItemTombDisplay.glowBackColor, CoD.PersistentItemTombDisplay.glowFrontColor)
		local f2_local12 = LUI.UIImage.new()
		f2_local12:setLeftRight(true, true, 0, 0)
		f2_local12:setTopBottom(true, true, 0, 0)
		f2_local12:setImage(CoD.PersistentItemTombDisplay.ClientFieldNames[f2_local8].material)
		f2_local12:setAlpha(CoD.PersistentItemTombDisplay.ClientFieldNames[f2_local8].iconStartAlpha)
		f2_local11.icon = f2_local12
		f2_local11:addElement(f2_local12)
		f2_arg0.statusIcons[f2_local8] = f2_local11
		f2_arg0.statusIcons[f2_local8].clientFieldName = CoD.PersistentItemTombDisplay.ClientFieldNames[f2_local8].clientFieldName
		f2_local7 = f2_local7 + CoD.PersistentItemTombDisplay.IconSize + CoD.PersistentItemTombDisplay.IconSpacing
	end
	CoD.PersistentItemTombDisplay.StatusIconsCount = #f2_arg0.statusIcons
	f2_arg0:addElement(self)
	return f2_local0 + f2_local4 + f2_arg1
end

CoD.PersistentItemTombDisplay.UpdateQuest = function(f3_arg0, f3_arg1)
	CoD.PersistentItemTombDisplay.UpdateQuestStatus(f3_arg0, f3_arg1)
	CoD.PersistentItemTombDisplay.UpdateQuestContainerAndTitle(f3_arg0, f3_arg1, 1)
end

CoD.PersistentItemTombDisplay.UpdateQuestContainerAndTitle = function(f4_arg0, f4_arg1, updateRecord)
	if f4_arg1.oldValue ~= 0 or f4_arg1.newValue ~= 0 then
		if updateRecord ~= nil then
			if f4_arg1.newValue <= 1 then
				f4_arg0.statusIcons[2].icon:setRGB(1, 1, 1)
			else
				local recordColor = CoD.QuestItemTombDisplay.ClientFieldNames[f4_arg1.newValue - 1].color
				f4_arg0.statusIcons[2].icon:setRGB(recordColor.r, recordColor.g, recordColor.b)
			end
		end

		if f4_arg0.questStatusContainer then
			f4_arg0.questStatusContainer:beginAnimation("fade_in", CoD.PersistentItemTombDisplay.FADE_OUT_DURATION)
			f4_arg0.questStatusContainer:setAlpha(1)
		end
		if f4_arg0.persQuestTitle then
			f4_arg0.persQuestTitle:beginAnimation("fade_in", CoD.PersistentItemTombDisplay.FADE_OUT_DURATION)
			f4_arg0.persQuestTitle:setAlpha(1)
		end
	end
	if f4_arg0.shouldFadeOutQuestStatus then
		CoD.PersistentItemTombDisplay.AddFadeOutTimer(f4_arg0)
	end
end

CoD.PersistentItemTombDisplay.PersistentIconUpdate = function(f5_arg0, f5_arg1)
	local f5_local0 = f5_arg1.newValue
	local f5_local1 = f5_arg1.name
	local f5_local2 = CoD.PersistentItemTombDisplay.GetCurrentStatusIndex(f5_arg0, CoD.PersistentItemTombDisplay.PersistentClientFieldName)
	local f5_local3 = f5_arg0.statusIcons[f5_local2]
	CoD.PersistentItemTombDisplay.GemStatusStates[CoD.PersistentItemTombDisplay.GetCurrentGemIndex(f5_local2)].currentState = f5_local0
	if not f5_local3 then
		return
	else
		CoD.PersistentItemTombDisplay.UpdateQuestContainerAndTitle(f5_arg0, f5_arg1)
		CoD.PersistentItemTombDisplay.UpdatePersistentGemIconStates(f5_local3, f5_local0)
	end
end

CoD.PersistentItemTombDisplay.ScoreboardUpdate = function(f6_arg0, f6_arg1)
	if f6_arg0.questStatusContainer then
		for f6_local0 = 1, #CoD.PersistentItemTombDisplay.StatusStates, 1 do
			CoD.PersistentItemTombDisplay.UpdateQuestStates(f6_arg0.statusIcons[f6_local0], CoD.PersistentItemTombDisplay.StatusStates[f6_local0])
		end
		local f6_local0 = CoD.PersistentItemTombDisplay.GetCurrentStatusIndex(f6_arg0, CoD.PersistentItemTombDisplay.PersistentClientFieldName)
		CoD.PersistentItemTombDisplay.UpdatePersistentGemIconStates(f6_arg0.statusIcons[f6_local0], CoD.PersistentItemTombDisplay.GemStatusStates[CoD.PersistentItemTombDisplay.GetCurrentGemIndex(f6_local0)].currentState)
	end
end

CoD.PersistentItemTombDisplay.AddFadeOutTimer = function(f7_arg0)
	if f7_arg0.questStatusContainer then
		if f7_arg0.fadeOutTimer then
			f7_arg0.fadeOutTimer:close()
			f7_arg0.fadeOutTimer:reset()
		end
		f7_arg0.fadeOutTimer = LUI.UITimer.new(CoD.PersistentItemTombDisplay.ONSCREEN_DURATION, "persistent_status_group_fade_out", true, f7_arg0)
		f7_arg0:addElement(f7_arg0.fadeOutTimer)
	end
end

CoD.PersistentItemTombDisplay.FadeoutQuestStatusContainer = function(f8_arg0, f8_arg1)
	if f8_arg0.questStatusContainer then
		f8_arg0.questStatusContainer:beginAnimation("fade_out", CoD.PersistentItemTombDisplay.FADE_OUT_DURATION)
		f8_arg0.questStatusContainer:setAlpha(0)
	end
	if f8_arg0.persQuestTitle then
		f8_arg0.persQuestTitle:beginAnimation("fade_out", CoD.PersistentItemTombDisplay.FADE_OUT_DURATION)
		f8_arg0.persQuestTitle:setAlpha(0)
	end
end

CoD.PersistentItemTombDisplay.UpdateQuestStatus = function(f9_arg0, f9_arg1)
	local f9_local0 = f9_arg1.newValue
	local f9_local1 = f9_arg1.oldValue
	local f9_local2 = CoD.PersistentItemTombDisplay.GetCurrentStatusIndex(f9_arg0, f9_arg1.name)
	CoD.PersistentItemTombDisplay.StatusStates[f9_local2] = f9_local0
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
			f9_local3.highlight:alternateStates(CoD.PersistentItemTombDisplay.ONSCREEN_DURATION, CoD.CraftablesIcon.PulseRedBright, CoD.CraftablesIcon.PulseRedLow, 500, 500, CoD.CraftablesIcon.PulseWhite)
		end
	end
	CoD.PersistentItemTombDisplay.UpdateQuestStates(f9_local3, f9_local0)
end

CoD.PersistentItemTombDisplay.UpdateQuestStates = function(f10_arg0, f10_arg1)
	if f10_arg1 == CoD.PersistentItemTombDisplay.STATE_NOT_HOLDING then
		f10_arg0:setAlpha(1)
		f10_arg0.icon:setAlpha(CoD.PersistentItemTombDisplay.NeedItemAlpha)
	elseif f10_arg1 == CoD.PersistentItemTombDisplay.STATE_HOLDING then
		f10_arg0:setAlpha(1)
		f10_arg0.icon:setAlpha(1)
		f10_arg0.icon:setRGB(1, 1, 1)
	else
		local recordColor = CoD.QuestItemTombDisplay.ClientFieldNames[f10_arg1 - 1].color
		f10_arg0:setAlpha(1)
		f10_arg0.icon:setAlpha(1)
		f10_arg0.icon:setRGB(recordColor.r, recordColor.g, recordColor.b)
	end
end

CoD.PersistentItemTombDisplay.UpdatePersistentGemIconStates = function(f11_arg0, f11_arg1)
	if f11_arg1 == CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_FIRE or f11_arg1 == CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_AIR or f11_arg1 == CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_LIGHTNING or f11_arg1 == CoD.PersistentItemTombDisplay.CRAFTABLE_ITEM_WATER then
		f11_arg0:setAlpha(1)
		f11_arg0.icon:setAlpha(1)
		f11_arg0.icon:setImage(CoD.PersistentItemTombDisplay.GemClientFieldNames[f11_arg1].material)
	else
		f11_arg0:setAlpha(0)
	end
end

CoD.PersistentItemTombDisplay.UpdateHighlight = function(f12_arg0, f12_arg1, f12_arg2)
	if f12_arg0.showPlayerHighlight and f12_arg0.statusIcons then
		for f12_local0 = 1, #f12_arg0.statusIcons, 1 do
			f12_arg0.statusIcons[f12_local0].highlight:setAlpha(0.1)
		end
		if f12_arg2 > 0 and f12_arg2 <= #f12_arg0.statusIcons then
			f12_arg0.statusIcons[f12_arg2].highlight:setAlpha(1)
		end
	end
end

CoD.PersistentItemTombDisplay.GetCurrentStatusIndex = function(f13_arg0, f13_arg1)
	for f13_local0 = 1, #CoD.PersistentItemTombDisplay.ClientFieldNames, 1 do
		if CoD.PersistentItemTombDisplay.ClientFieldNames[f13_local0].clientFieldName == f13_arg1 then
			return f13_local0
		end
	end
end

CoD.PersistentItemTombDisplay.GetCurrentGemIndex = function(f14_arg0)
	for f14_local0 = 1, #CoD.PersistentItemTombDisplay.GemStatusStates, 1 do
		if CoD.PersistentItemTombDisplay.GemStatusStates[f14_local0].gemIndex == f14_arg0 then
			return f14_local0
		end
	end
end
