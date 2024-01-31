require("T6.Zombie.CraftablesStaffIcon")

CoD.QuestItemTombDisplay = {}
CoD.QuestItemTombDisplay.IconSize = 48
CoD.QuestItemTombDisplay.FontName = CoD.CraftablesIcon.FontName
CoD.QuestItemTombDisplay.ContainerSize = CoD.QuestItemTombDisplay.IconSize + CoD.textSize[CoD.QuestItemTombDisplay.FontName] + 5
CoD.QuestItemTombDisplay.IconSpacing = 5
CoD.QuestItemTombDisplay.NeedItemAlpha = 0.2
CoD.QuestItemTombDisplay.CrossoutAlpha = 0.75
CoD.QuestItemTombDisplay.glowBackColor = {}
CoD.QuestItemTombDisplay.glowBackColor.r = 1
CoD.QuestItemTombDisplay.glowBackColor.g = 1
CoD.QuestItemTombDisplay.glowBackColor.b = 1
CoD.QuestItemTombDisplay.glowFrontColor = {}
CoD.QuestItemTombDisplay.glowFrontColor.r = 1
CoD.QuestItemTombDisplay.glowFrontColor.g = 1
CoD.QuestItemTombDisplay.glowFrontColor.b = 1
CoD.QuestItemTombDisplay.MOVING_DURATION = 500
CoD.QuestItemTombDisplay.ONSCREEN_DURATION = 5000
CoD.QuestItemTombDisplay.FADE_OUT_DURATION = 500
CoD.QuestItemTombDisplay.PlayerGemClientFieldCount = 4
CoD.QuestItemTombDisplay.PlayerGemClientFieldName = "gem_player"
CoD.QuestItemTombDisplay.PlayerStaffClientFieldCount = 4
CoD.QuestItemTombDisplay.PlayerStaffClientFieldName = "staff_player"
CoD.QuestItemTombDisplay.CRAFTABLE_ITEM_NONE = 0
CoD.QuestItemTombDisplay.STATE_NOTHING = 0
CoD.QuestItemTombDisplay.STATE_GOT_RECORD = 1
CoD.QuestItemTombDisplay.STATE_GOT_CRYSTAL = 2
CoD.QuestItemTombDisplay.STATE_MADE_STAFF = 3
CoD.QuestItemTombDisplay.STATE_GOT_UPGRADE = 4
CoD.QuestItemTombDisplay.STATE_STAFF_PIECE_NEED = 0
CoD.QuestItemTombDisplay.STATE_STAFF_PIECE_HAVE = 1
CoD.QuestItemTombDisplay.STATE_STAFF_PIECE_COMPLETED = 2
CoD.QuestItemTombDisplay.ClientFieldNames = {}
CoD.QuestItemTombDisplay.ClientFieldNames[1] = {
	name = "air",
	color = CoD.CraftablesStaffIcon.YellowWind,
	clientFieldName = "quest_state1",
	gemClientFieldName = "piece_staff_zm_gem_air",
	recordClientFieldName = "piece_record_zm_vinyl_air",
	uStaffClientFieldName = "piece_staff_zm_ustaff_air",
	mStaffClientFieldName = "piece_staff_zm_mstaff_air",
	lStaffClientFieldName = "piece_staff_zm_lstaff_air",
	materialName = "zom_hud_craftable_element_wind",
	num = 2,
}
CoD.QuestItemTombDisplay.ClientFieldNames[2] = {
	name = "water",
	color = CoD.CraftablesStaffIcon.BlueIce,
	clientFieldName = "quest_state2",
	gemClientFieldName = "piece_staff_zm_gem_water",
	recordClientFieldName = "piece_record_zm_vinyl_water",
	uStaffClientFieldName = "piece_staff_zm_ustaff_water",
	mStaffClientFieldName = "piece_staff_zm_mstaff_water",
	lStaffClientFieldName = "piece_staff_zm_lstaff_water",
	materialName = "zom_hud_craftable_element_water",
	num = 4,
}
CoD.QuestItemTombDisplay.ClientFieldNames[3] = {
	name = "lightning",
	color = CoD.CraftablesStaffIcon.PurpleLightning,
	clientFieldName = "quest_state3",
	gemClientFieldName = "piece_staff_zm_gem_lightning",
	recordClientFieldName = "piece_record_zm_vinyl_lightning",
	uStaffClientFieldName = "piece_staff_zm_ustaff_lightning",
	mStaffClientFieldName = "piece_staff_zm_mstaff_lightning",
	lStaffClientFieldName = "piece_staff_zm_lstaff_lightning",
	materialName = "zom_hud_craftable_element_lightning",
	num = 3,
}
CoD.QuestItemTombDisplay.ClientFieldNames[4] = {
	name = "fire",
	color = CoD.CraftablesStaffIcon.RedFire,
	clientFieldName = "quest_state4",
	gemClientFieldName = "piece_staff_zm_gem_fire",
	recordClientFieldName = "piece_record_zm_vinyl_fire",
	uStaffClientFieldName = "piece_staff_zm_ustaff_fire",
	mStaffClientFieldName = "piece_staff_zm_mstaff_fire",
	lStaffClientFieldName = "piece_staff_zm_lstaff_fire",
	materialName = "zom_hud_craftable_element_fire",
	num = 1,
}
CoD.QuestItemTombDisplay.QuestItemName = Engine.Localize("ZM_TOMB_STAFF_PARTS")
CoD.QuestItemTombDisplay.new = function(f1_arg0)
	f1_arg0.id = f1_arg0.id .. ".QuestItemTombDisplay"
	for f1_local0 = 1, #CoD.QuestItemTombDisplay.ClientFieldNames, 1 do
		if not CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].material then
			CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].material = RegisterMaterial(CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].materialName)
		end
	end
	CoD.QuestItemTombDisplay.PreviousIconIndexPerController = {
		-1,
		-1,
		-1,
		-1,
	}
	CoD.QuestItemTombDisplay.CurrentIconIndexPerController = {
		-1,
		-1,
		-1,
		-1,
	}
	CoD.QuestItemTombDisplay.StatusStates = {
		-1,
		-1,
		-1,
		-1,
	}
	CoD.QuestItemTombDisplay.PlayerGemInfo = {
		0,
		0,
		0,
		0,
	}
	CoD.QuestItemTombDisplay.PlayerStaffInfo = {
		0,
		0,
		0,
		0,
	}
	CoD.QuestItemTombDisplay.StavesState = {}
	CoD.QuestItemTombDisplay.StavesState.air = 0
	CoD.QuestItemTombDisplay.StavesState.fire = 0
	CoD.QuestItemTombDisplay.StavesState.lightning = 0
	CoD.QuestItemTombDisplay.StavesState.water = 0
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC4Maps) then
		if CoD.QuestItemTombDisplay.RecordBlankMaterial == nil then
			CoD.QuestItemTombDisplay.RecordBlankMaterial = RegisterMaterial("zom_hud_craftable_rec_blank")
		end
		if CoD.QuestItemTombDisplay.StaffMaterial == nil then
			CoD.QuestItemTombDisplay.StaffMaterial = RegisterMaterial("zom_hud_craftable_staff")
		end
		if CoD.QuestItemTombDisplay.StaffGlowMaterial == nil then
			CoD.QuestItemTombDisplay.StaffGlowMaterial = RegisterMaterial("zom_hud_craftable_staff_glow")
		end
	end
	f1_arg0:registerEventHandler("quest_status_group_fade_out", CoD.QuestItemTombDisplay.FadeoutQuestStatusContainer)
	for f1_local0 = 1, CoD.QuestItemTombDisplay.PlayerGemClientFieldCount, 1 do
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.PlayerGemClientFieldName .. f1_local0, CoD.QuestItemTombDisplay.PlayerGemOwner)
	end
	for f1_local0 = 1, CoD.QuestItemTombDisplay.PlayerStaffClientFieldCount, 1 do
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.PlayerStaffClientFieldName .. f1_local0, CoD.QuestItemTombDisplay.PlayerStaffOwner)
	end
	CoD.QuestItemTombDisplay.QuestClientFieldCount = #CoD.QuestItemTombDisplay.ClientFieldNames
	for f1_local0 = 1, CoD.QuestItemTombDisplay.QuestClientFieldCount, 1 do
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].clientFieldName, CoD.QuestItemTombDisplay.UpdateCompletedStaffDisplay)
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].gemClientFieldName, CoD.QuestItemTombDisplay.UpdateGemDisplay)
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].recordClientFieldName, CoD.QuestItemTombDisplay.UpdateRecordDisplay)
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].uStaffClientFieldName, CoD.QuestItemTombDisplay.UpdateUpperStaffDisplay)
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].mStaffClientFieldName, CoD.QuestItemTombDisplay.UpdateMiddleStaffDisplay)
		f1_arg0:registerEventHandler(CoD.QuestItemTombDisplay.ClientFieldNames[f1_local0].lStaffClientFieldName, CoD.QuestItemTombDisplay.UpdateLowerStaffDisplay)
	end
	f1_arg0.visible = true
	return f1_arg0
end

CoD.QuestItemTombDisplay.AddQuestStatusDisplay = function(f2_arg0, f2_arg1, f2_arg2, f2_arg3, f2_arg4)
	local f2_local0 = 0
	local f2_local1 = 0
	local f2_local2 = 0
	local f2_local3 = 0
	local f2_local4 = 0
	if not f2_arg4 then
		f2_arg4 = 0
	end
	local f2_local5 = CoD.QuestItemTombDisplay.QuestClientFieldCount
	f2_local4 = CoD.QuestItemTombDisplay.IconSize * f2_local5 + CoD.QuestItemTombDisplay.IconSpacing * (f2_local5 - 1)
	local self = LUI.UIElement.new()
	self:setLeftRight(true, false, f2_local1, f2_local1 + f2_local4)
	self:setTopBottom(true, false, f2_local2, f2_local2 + CoD.QuestItemTombDisplay.ContainerSize + f2_arg4)
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
		f2_local7:setTopBottom(true, false, 0, CoD.textSize[CoD.QuestItemTombDisplay.FontName])
		f2_local7:setFont(CoD.fonts[CoD.QuestItemTombDisplay.FontName])
		f2_local7:setAlignment(LUI.Alignment.Left)
		self:addElement(f2_local7)
		f2_local7:setText(CoD.QuestItemTombDisplay.QuestItemName)
	end
	local f2_local7 = 0
	local f2_local8 = 5
	local f2_local9 = -2
	local f2_local10 = "ExtraSmall"
	f2_arg0.statusIcons = {}
	for f2_local11 = 1, CoD.QuestItemTombDisplay.QuestClientFieldCount, 1 do
		local f2_local14 = LUI.UIElement.new()
		f2_local14:setLeftRight(true, false, f2_local7, f2_local7 + CoD.QuestItemTombDisplay.IconSize)
		f2_local14:setTopBottom(false, true, -CoD.QuestItemTombDisplay.IconSize, 0)
		self:addElement(f2_local14)
		CoD.CraftablesStaffIcon.new(f2_local14, CoD.QuestItemTombDisplay.glowBackColor, CoD.QuestItemTombDisplay.glowFrontColor)
		local f2_local15 = LUI.UIImage.new()
		f2_local15:setLeftRight(true, true, 4, -10)
		f2_local15:setTopBottom(true, true, 7, -7)
		f2_local15:setAlpha(0)
		f2_local15:setImage(CoD.QuestItemTombDisplay.StaffGlowMaterial)
		f2_local14.iconGlow = f2_local15
		f2_local14:addElement(f2_local15)
		local f2_local16 = LUI.UIImage.new()
		f2_local16:setLeftRight(true, true, 1, -13)
		f2_local16:setTopBottom(true, true, 7, -7)
		f2_local16:setAlpha(CoD.QuestItemTombDisplay.NeedItemAlpha)
		f2_local16:setImage(CoD.QuestItemTombDisplay.RecordBlankMaterial)
		f2_local14.icon = f2_local16
		f2_local14:addElement(f2_local16)
		local f2_local17 = LUI.UIImage.new()
		f2_local17:setLeftRight(true, true, 23, -5)
		f2_local17:setTopBottom(true, true, 2, -26)
		f2_local17:setAlpha(0)
		f2_local17:setImage(CoD.QuestItemTombDisplay.ClientFieldNames[f2_local11].material)
		f2_local14.smallIcon = f2_local17
		f2_local14:addElement(f2_local17)

		local playerID = LUI.UIText.new()
		playerID:setLeftRight(true, true, f2_local8, 0)
		playerID:setTopBottom(false, true, -CoD.textSize[f2_local10] + f2_local9, f2_local9)
		playerID:setFont(CoD.fonts[f2_local10])
		playerID:setAlignment(LUI.Alignment.Left)
		playerID:setAlpha(1)
		f2_local14:addElement(playerID)
		f2_local14.playerID = playerID

		f2_arg0.statusIcons[f2_local11] = f2_local14
		f2_arg0.statusIcons[f2_local11].elementName = CoD.QuestItemTombDisplay.ClientFieldNames[f2_local11].name
		f2_local7 = f2_local7 + CoD.QuestItemTombDisplay.IconSize + CoD.QuestItemTombDisplay.IconSpacing
	end
	CoD.QuestItemTombDisplay.StatusIconsCount = #f2_arg0.statusIcons
	f2_arg0:addElement(self)
	return f2_local0 + f2_local4 + f2_arg1
end

CoD.QuestItemTombDisplay.PlayerGemOwner = function(f3_arg0, f3_arg1)
	local f3_local0 = 0
	if 0 < f3_arg1.oldValue then
		f3_local0 = (f3_arg1.oldValue - 1) % CoD.QuestItemTombDisplay.QuestClientFieldCount + 1
	end
	local f3_local1 = 0
	if 0 < f3_arg1.newValue then
		f3_local1 = (f3_arg1.newValue - 1) % CoD.QuestItemTombDisplay.QuestClientFieldCount + 1
	end

	f3_local0 = CoD.QuestItemTombDisplay.GetIndexFromNum(f3_local0)
	f3_local1 = CoD.QuestItemTombDisplay.GetIndexFromNum(f3_local1)

	local f3_local2 = tonumber(string.sub(f3_arg1.name, string.len(CoD.QuestItemTombDisplay.PlayerGemClientFieldName) + 1))
	if f3_local2 < 1 or f3_local2 > 4 then
		return
	elseif not f3_arg0.statusIcons then
		return
	elseif 0 < f3_local0 then
		f3_arg0.statusIcons[f3_local0].playerID:setText("")
		CoD.QuestItemTombDisplay.PlayerGemInfo[f3_local0] = 0
	end
	if 0 < f3_local1 then
		f3_arg0.statusIcons[f3_local1].playerID:setRGB(CoD.Zombie.PlayerColors[f3_local2].r, CoD.Zombie.PlayerColors[f3_local2].g, CoD.Zombie.PlayerColors[f3_local2].b)
		f3_arg0.statusIcons[f3_local1].playerID:setText(Engine.Localize("ZMUI_PLAYER_NUM_" .. f3_local2))
		CoD.QuestItemTombDisplay.PlayerGemInfo[f3_local1] = f3_local2
	end
end

CoD.QuestItemTombDisplay.PlayerStaffOwner = function(f3_arg0, f3_arg1)
	local f3_local0 = 0
	if 0 < f3_arg1.oldValue then
		f3_local0 = (f3_arg1.oldValue - 1) % CoD.QuestItemTombDisplay.QuestClientFieldCount + 1
	end
	local f3_local1 = 0
	if 0 < f3_arg1.newValue then
		f3_local1 = (f3_arg1.newValue - 1) % CoD.QuestItemTombDisplay.QuestClientFieldCount + 1
	end

	f3_local0 = CoD.QuestItemTombDisplay.GetIndexFromNum(f3_local0)
	f3_local1 = CoD.QuestItemTombDisplay.GetIndexFromNum(f3_local1)

	local f3_local2 = tonumber(string.sub(f3_arg1.name, string.len(CoD.QuestItemTombDisplay.PlayerStaffClientFieldName) + 1))
	if f3_local2 < 1 or f3_local2 > 4 then
		return
	elseif not f3_arg0.statusIcons then
		return
	elseif 0 < f3_local0 then
		f3_arg0.statusIcons[f3_local0].playerID:setText("")
		CoD.QuestItemTombDisplay.PlayerStaffInfo[f3_local0] = 0
	end
	if 0 < f3_local1 then
		f3_arg0.statusIcons[f3_local1].playerID:setRGB(CoD.Zombie.PlayerColors[f3_local2].r, CoD.Zombie.PlayerColors[f3_local2].g, CoD.Zombie.PlayerColors[f3_local2].b)
		f3_arg0.statusIcons[f3_local1].playerID:setText(Engine.Localize("ZMUI_PLAYER_NUM_" .. f3_local2))
		CoD.QuestItemTombDisplay.PlayerStaffInfo[f3_local1] = f3_local2
	end
end

CoD.QuestItemTombDisplay.UpdateQuest = function(f4_arg0, f4_arg1)
	if f4_arg1.oldValue ~= 0 or f4_arg1.newValue ~= 0 then
		if f4_arg0.questStatusContainer then
			f4_arg0.questStatusContainer:beginAnimation("fade_in", CoD.QuestItemTombDisplay.FADE_OUT_DURATION)
			f4_arg0.questStatusContainer:setAlpha(1)
		end
		if f4_arg0.persQuestTitle then
			f4_arg0.persQuestTitle:beginAnimation("fade_in", CoD.QuestItemTombDisplay.FADE_OUT_DURATION)
			f4_arg0.persQuestTitle:setAlpha(1)
		end
	end
	if f4_arg0.shouldFadeOutQuestStatus then
		CoD.QuestItemTombDisplay.AddFadeOutTimer(f4_arg0)
	end
end

CoD.QuestItemTombDisplay.ScoreboardUpdate = function(f5_arg0, f5_arg1)
	if f5_arg0.questStatusContainer then
		for f5_local0 = 1, #CoD.QuestItemTombDisplay.StatusStates, 1 do
			CoD.QuestItemTombDisplay.UpdateQuestStates(f5_arg0.statusIcons[f5_local0], CoD.QuestItemTombDisplay.StatusStates[f5_local0], f5_local0)
		end
	end
	if f5_arg0.statusIcons then
		for f5_local0 = 1, #CoD.QuestItemTombDisplay.StatusStates, 1 do
			local f5_local3 = CoD.QuestItemTombDisplay.PlayerGemInfo[f5_local0]
			local f5_local4 = CoD.QuestItemTombDisplay.PlayerStaffInfo[f5_local0]
			local f5_local5 = math.max(f5_local3, f5_local4)

			if f5_local5 == 0 then
				f5_arg0.statusIcons[f5_local0].playerID:setText("")
			else
				f5_arg0.statusIcons[f5_local0].playerID:setRGB(CoD.Zombie.PlayerColors[f5_local5].r, CoD.Zombie.PlayerColors[f5_local5].g, CoD.Zombie.PlayerColors[f5_local5].b)
				f5_arg0.statusIcons[f5_local0].playerID:setText(Engine.Localize("ZMUI_PLAYER_NUM_" .. f5_local5))
			end
		end
	end
	CoD.QuestItemTombDisplay.UpdateHighlight(f5_arg0, CoD.QuestItemTombDisplay.PreviousIconIndexPerController[f5_arg1.controller + 1], CoD.QuestItemTombDisplay.CurrentIconIndexPerController[f5_arg1.controller + 1])
end

CoD.QuestItemTombDisplay.AddFadeOutTimer = function(f6_arg0)
	if f6_arg0.questStatusContainer then
		if f6_arg0.fadeOutTimer then
			f6_arg0.fadeOutTimer:close()
			f6_arg0.fadeOutTimer:reset()
		end
		f6_arg0.fadeOutTimer = LUI.UITimer.new(CoD.QuestItemTombDisplay.ONSCREEN_DURATION, "quest_status_group_fade_out", true, f6_arg0)
		f6_arg0:addElement(f6_arg0.fadeOutTimer)
	end
end

CoD.QuestItemTombDisplay.FadeoutQuestStatusContainer = function(f7_arg0, f7_arg1)
	if f7_arg0.questStatusContainer then
		f7_arg0.questStatusContainer:beginAnimation("fade_out", CoD.QuestItemTombDisplay.FADE_OUT_DURATION)
		f7_arg0.questStatusContainer:setAlpha(0)
	end
	if f7_arg0.persQuestTitle then
		f7_arg0.persQuestTitle:beginAnimation("fade_out", CoD.QuestItemTombDisplay.FADE_OUT_DURATION)
		f7_arg0.persQuestTitle:setAlpha(0)
	end
end

CoD.QuestItemTombDisplay.UpdateQuestStatus = function(f8_arg0, f8_arg1, f8_arg2)
	local f8_local0 = f8_arg1.newValue
	local f8_local1 = f8_arg1.oldValue
	local f8_local2 = f8_arg1.name
	if f8_arg2 then
		f8_local2 = f8_arg2
	end
	local f8_local3 = CoD.QuestItemTombDisplay.GetCurrentStatusIndex(f8_arg0, f8_local2)
	if not f8_local3 then
		return
	end
	CoD.QuestItemTombDisplay.StatusStates[f8_local3] = f8_local0
	if not f8_arg0.statusIcons then
		return
	end
	local f8_local4 = f8_arg0.statusIcons[f8_local3]
	if not f8_local4 then
		return
	elseif f8_arg0.highlightRecentItem then
		if f8_local4.highlight.alternatorTimer then
			f8_local4.highlight:closeStateAlternator()
		end
		if f8_local1 < f8_local0 then
			f8_local4.highlight:alternateStates(CoD.QuestItemTombDisplay.ONSCREEN_DURATION, CoD.CraftablesIcon.PulseRedBright, CoD.CraftablesIcon.PulseRedLow, 500, 500, CoD.CraftablesIcon.PulseWhite)
		end
	end
	CoD.QuestItemTombDisplay.UpdateQuestStates(f8_local4, f8_local0, f8_local3)
end

CoD.QuestItemTombDisplay.UpdateQuestStates = function(f9_arg0, f9_arg1, f9_arg2)
	local f9_local0 = CoD.QuestItemTombDisplay.ClientFieldNames[f9_arg2]
	if not f9_local0 then
		return
	end
	local f9_local1 = false
	if f9_arg1 == CoD.QuestItemTombDisplay.STATE_NOTHING then
		DebugPrint("QUEST STATE 1")
	elseif f9_arg1 == CoD.QuestItemTombDisplay.STATE_GOT_RECORD then
		f9_arg0.icon:setImage(CoD.QuestItemTombDisplay.RecordBlankMaterial)
		f9_arg0.icon:setRGB(f9_local0.color.r, f9_local0.color.g, f9_local0.color.b)
		f9_arg0.icon:setAlpha(1)
	elseif f9_arg1 == CoD.QuestItemTombDisplay.STATE_GOT_CRYSTAL then
		f9_arg0.icon:setRGB(1, 1, 1)
		f9_arg0.icon:setImage(CoD.QuestItemTombDisplay.ClientFieldNames[f9_arg2].material)
		f9_arg0.icon:setAlpha(1)
	elseif f9_arg1 == CoD.QuestItemTombDisplay.STATE_MADE_STAFF then
		f9_arg0.icon:setLeftRight(true, true, 4, -10)
		f9_arg0.icon:setRGB(1, 1, 1)
		f9_arg0.icon:setImage(CoD.QuestItemTombDisplay.StaffMaterial)
		f9_arg0.icon:setAlpha(1)
		f9_arg0.smallIcon:setAlpha(1)
		f9_arg0.newStaffPart:setAlpha(0)
	elseif f9_arg1 == CoD.QuestItemTombDisplay.STATE_GOT_UPGRADE then
		f9_arg0.icon:setLeftRight(true, true, 4, -10)
		f9_arg0.icon:setRGB(1, 1, 1)
		f9_arg0.icon:setImage(CoD.QuestItemTombDisplay.StaffMaterial)
		f9_arg0.icon:setAlpha(1)
		f9_arg0.smallIcon:setAlpha(1)
		f9_arg0.iconGlow:setAlpha(1)
		f9_arg0.newStaffPart:setAlpha(0)
	end
	f9_arg0.newStaffPart:setupStaffPieces(3, CoD.QuestItemTombDisplay.StavesState[f9_arg0.elementName], -2)
	f9_arg0.newStaffPart:setRGB(f9_local0.color.r, f9_local0.color.g, f9_local0.color.b)
end

CoD.QuestItemTombDisplay.UpdateCompletedStaffDisplay = function(f10_arg0, f10_arg1)
	local f10_local0 = string.len(f10_arg1.name)
	local num = tonumber(string.sub(f10_arg1.name, f10_local0))
	local index = CoD.QuestItemTombDisplay.GetIndexFromNum(num)
	CoD.QuestItemTombDisplay.UpdateQuestStatus(f10_arg0, f10_arg1, CoD.QuestItemTombDisplay.ClientFieldNames[index].name)
	CoD.QuestItemTombDisplay.UpdateQuest(f10_arg0, f10_arg1)
end

CoD.QuestItemTombDisplay.UpdateGemDisplay = function(f11_arg0, f11_arg1)
	if f11_arg1.newValue == 1 then
		local f11_local0 = string.sub(f11_arg1.name, 20)
		f11_arg1.newValue = 2
		CoD.QuestItemTombDisplay.UpdateQuestStatus(f11_arg0, f11_arg1, f11_local0)
		CoD.QuestItemTombDisplay.UpdateQuest(f11_arg0, f11_arg1)
	end
end

CoD.QuestItemTombDisplay.UpdateRecordDisplay = function(f12_arg0, f12_arg1)
	if f12_arg1.newValue == 1 then
		CoD.QuestItemTombDisplay.UpdateQuestStatus(f12_arg0, f12_arg1, string.sub(f12_arg1.name, 23))
		CoD.QuestItemTombDisplay.UpdateQuest(f12_arg0, f12_arg1)
	end
end

CoD.QuestItemTombDisplay.UpdateStaffDisplay = function(f13_arg0, f13_arg1, f13_arg2)
	if f13_arg1.newValue == 1 then
		local f13_local0 = string.sub(f13_arg1.name, 23)
		local f13_local1 = CoD.QuestItemTombDisplay.GetCurrentStatusIndex(f13_arg0, f13_local0)
		if not f13_local1 then
			return
		end
		local f13_local2 = CoD.QuestItemTombDisplay.StavesState[f13_local0]
		if math.floor(f13_local2 / f13_arg2) % 2 == 0 then
			CoD.QuestItemTombDisplay.StavesState[f13_local0] = f13_local2 + f13_arg2
		end
		if not f13_arg0.statusIcons then
			return
		end
		local f13_local3 = CoD.QuestItemTombDisplay.ClientFieldNames[f13_local1]
		local f13_local4 = f13_arg0.statusIcons[f13_local1].newStaffPart
		f13_local4:setupStaffPieces(3, CoD.QuestItemTombDisplay.StavesState[f13_local0], -2)
		f13_local4:setRGB(f13_local3.color.r, f13_local3.color.g, f13_local3.color.b)
		CoD.QuestItemTombDisplay.UpdateQuest(f13_arg0, f13_arg1)
	end
end

CoD.QuestItemTombDisplay.UpdateUpperStaffDisplay = function(f14_arg0, f14_arg1)
	CoD.QuestItemTombDisplay.UpdateStaffDisplay(f14_arg0, f14_arg1, CoD.CraftablesStaffIcon.UPPERSTAFFBIT)
end

CoD.QuestItemTombDisplay.UpdateMiddleStaffDisplay = function(f15_arg0, f15_arg1)
	CoD.QuestItemTombDisplay.UpdateStaffDisplay(f15_arg0, f15_arg1, CoD.CraftablesStaffIcon.MIDDLESTAFFBIT)
end

CoD.QuestItemTombDisplay.UpdateLowerStaffDisplay = function(f16_arg0, f16_arg1)
	CoD.QuestItemTombDisplay.UpdateStaffDisplay(f16_arg0, f16_arg1, CoD.CraftablesStaffIcon.LOWERSTAFFBIT)
end

CoD.QuestItemTombDisplay.UpdateHighlight = function(f17_arg0, f17_arg1, f17_arg2)
	if f17_arg0.showPlayerHighlight and f17_arg0.statusIcons then
		for f17_local0 = 1, #f17_arg0.statusIcons, 1 do
			f17_arg0.statusIcons[f17_local0].highlight:setAlpha(0.1)
		end
		if f17_arg2 > 0 and f17_arg2 <= #f17_arg0.statusIcons then
			f17_arg0.statusIcons[f17_arg2].highlight:setAlpha(1)
		end
	end
end

CoD.QuestItemTombDisplay.GetCurrentStatusIndex = function(f18_arg0, f18_arg1)
	for f18_local0 = 1, #CoD.QuestItemTombDisplay.ClientFieldNames, 1 do
		if CoD.QuestItemTombDisplay.ClientFieldNames[f18_local0].name == f18_arg1 then
			return f18_local0
		end
	end
end

CoD.QuestItemTombDisplay.GetMaterial = function(f19_arg0)
	local f19_local0 = nil
	for f19_local1 = 1, #CoD.QuestItemTombDisplay.ClientFieldNames, 1 do
		if CoD.QuestItemTombDisplay.ClientFieldNames[f19_local1].name == f19_arg0 then
			f19_local0 = CoD.QuestItemTombDisplay.ClientFieldNames[f19_local1].material
			break
		end
	end
	return f19_local0
end

CoD.QuestItemTombDisplay.GetIndexFromNum = function(num)
	for index = 1, CoD.QuestItemTombDisplay.QuestClientFieldCount, 1 do
		if CoD.QuestItemTombDisplay.ClientFieldNames[index].num == num then
			return index
		end
	end

	return num
end
