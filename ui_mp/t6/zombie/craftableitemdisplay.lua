require("T6.Zombie.CraftablesIcon")

CoD.CraftableItemDisplay = {}
CoD.CraftableItemDisplay.IconSize = 48
CoD.CraftableItemDisplay.FontName = "ExtraSmall"
CoD.CraftableItemDisplay.ContainerSize = CoD.CraftableItemDisplay.IconSize + CoD.textSize[CoD.CraftableItemDisplay.FontName] + 5
CoD.CraftableItemDisplay.IconSpacing = 5
CoD.CraftableItemDisplay.STATE_OFF = 0
CoD.CraftableItemDisplay.STATE_ON = 1
CoD.CraftableItemDisplay.MOVING_DURATION = 500
CoD.CraftableItemDisplay.ONSCREEN_DURATION = 5000
CoD.CraftableItemDisplay.FADE_OUT_DURATION = 500
CoD.CraftableItemDisplay.CRAFT_ITEM_1 = 1
CoD.CraftableItemDisplay.CRAFT_ITEM_2 = 2
CoD.CraftableItemDisplay.glowBackColor = {}
CoD.CraftableItemDisplay.glowBackColor.r = 1
CoD.CraftableItemDisplay.glowBackColor.g = 1
CoD.CraftableItemDisplay.glowBackColor.b = 1
CoD.CraftableItemDisplay.glowFrontColor = {}
CoD.CraftableItemDisplay.glowFrontColor.r = 1
CoD.CraftableItemDisplay.glowFrontColor.g = 1
CoD.CraftableItemDisplay.glowFrontColor.b = 1
CoD.CraftableItemDisplay.Groups = {}
CoD.CraftableItemDisplay.Groups[CoD.Zombie.MAP_ZM_PRISON] = {}
CoD.CraftableItemDisplay.Groups[CoD.Zombie.MAP_ZM_PRISON][CoD.CraftableItemDisplay.CRAFT_ITEM_1] = {
	text = Engine.Localize("ZM_PRISON_SHIELD"),
	color = {
		0.76,
		0.52,
		0.65,
	},
}
CoD.CraftableItemDisplay.Groups[CoD.Zombie.MAP_ZM_PRISON][CoD.CraftableItemDisplay.CRAFT_ITEM_2] = {
	text = Engine.Localize("ZM_PRISON_ACID_GAT_KIT"),
	color = {
		0.07,
		0.68,
		0.19,
	},
}
CoD.CraftableItemDisplay.ClientFieldNames = {}
CoD.CraftableItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON] = {}
CoD.CraftableItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][1] = {
	clientFieldName = "piece_riotshield_dolly",
	materialName = "zm_hud_icon_dolly",
	group = CoD.CraftableItemDisplay.CRAFT_ITEM_1,
}
CoD.CraftableItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][2] = {
	clientFieldName = "piece_riotshield_door",
	materialName = "zom_hud_craftable_zshield_door",
	group = CoD.CraftableItemDisplay.CRAFT_ITEM_1,
}
CoD.CraftableItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][3] = {
	clientFieldName = "piece_riotshield_clamp",
	materialName = "zom_hud_craftable_zshield_clamp",
	group = CoD.CraftableItemDisplay.CRAFT_ITEM_1,
}
CoD.CraftableItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][4] = {
	clientFieldName = "piece_packasplat_fuse",
	materialName = "zom_hud_craftable_acidr_fuse",
	group = CoD.CraftableItemDisplay.CRAFT_ITEM_2,
}
CoD.CraftableItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][5] = {
	clientFieldName = "piece_packasplat_case",
	materialName = "zom_hud_craftable_acidr_case",
	group = CoD.CraftableItemDisplay.CRAFT_ITEM_2,
}
CoD.CraftableItemDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_PRISON][6] = {
	clientFieldName = "piece_packasplat_blood",
	materialName = "zom_hud_craftable_acidr_blood",
	group = CoD.CraftableItemDisplay.CRAFT_ITEM_2,
}
CoD.CraftableItemDisplay.new = function(f1_arg0)
	f1_arg0.id = f1_arg0.id .. ".CraftableItemDisplay"
	CoD.CraftableItemDisplay.CurrentMapName = CoD.Zombie.GetUIMapName()
	local f1_local0 = CoD.CraftableItemDisplay.CurrentMapName
	if not CoD.CraftableItemDisplay.ClientFieldNames[f1_local0] then
		return
	end
	CoD.CraftableItemDisplay.CraftableStates = {
		0,
		0,
		0,
		0,
		0,
		0,
	}
	for f1_local1 = 1, #CoD.CraftableItemDisplay.ClientFieldNames[f1_local0], 1 do
		f1_arg0:registerEventHandler(CoD.CraftableItemDisplay.ClientFieldNames[f1_local0][f1_local1].clientFieldName, CoD.CraftableItemDisplay.Update)
	end
	return f1_arg0
end

CoD.CraftableItemDisplay.AddDisplayContainer = function(f2_arg0, f2_arg1, f2_arg2, f2_arg3)
	local f2_local0 = CoD.CraftableItemDisplay.CurrentMapName
	for f2_local4, f2_local5 in ipairs(CoD.CraftableItemDisplay.Groups[f2_local0]) do
		f2_local5.count = 0
	end
	for f2_local1 = 1, #CoD.CraftableItemDisplay.ClientFieldNames[f2_local0], 1 do
		local f2_local5 = CoD.CraftableItemDisplay.ClientFieldNames[f2_local0][f2_local1]
		f2_local5.material = RegisterMaterial(f2_local5.materialName)
		for f2_local9, self in ipairs(CoD.CraftableItemDisplay.Groups[f2_local0]) do
			if f2_local5.group == f2_local9 then
				self.count = self.count + 1
			end
		end
	end
	local f2_local1 = 0
	local f2_local2 = 0
	local f2_local3 = 0
	f2_arg0.craftGroups = {}
	f2_arg0.craftItems = {}
	for f2_local4 = 1, #CoD.CraftableItemDisplay.Groups[f2_local0], 1 do
		local f2_local8 = CoD.CraftableItemDisplay.Groups[f2_local0][f2_local4].count
		local f2_local9 = CoD.CraftableItemDisplay.IconSize * f2_local8 + CoD.CraftableItemDisplay.IconSpacing * (f2_local8 - 1)
		local self = LUI.UIElement.new()
		self:setLeftRight(true, false, f2_local1, f2_local1 + f2_local9)
		self:setTopBottom(true, false, f2_local2, f2_local2 + CoD.CraftableItemDisplay.ContainerSize)
		if not f2_arg2 then
			self:setAlpha(0)
		end
		self.id = self.id .. ".CraftGroupContainer"
		f2_arg0:addElement(self)
		self:registerEventHandler("craft_group_fade_out", CoD.CraftableItemDisplay.FadeoutGroupContainer)
		self:registerEventHandler("transition_complete_off_fade_out", CoD.CraftableItemDisplay.FadeOutComplete)
		if f2_arg2 and f2_arg3 then
			local f2_local11 = LUI.UIImage.new()
			f2_local11:setLeftRight(true, true, -f2_arg3, f2_arg3)
			f2_local11:setTopBottom(true, true, -f2_arg3, f2_arg3)
			f2_local11:setRGB(0, 0, 0)
			f2_local11:setAlpha(0.7)
			self:addElement(f2_local11)
			f2_local3 = f2_local3 + f2_arg3
		end
		local f2_local11 = LUI.UIText.new()
		f2_local11:setLeftRight(true, true, 0, 0)
		f2_local11:setTopBottom(true, false, 0, CoD.textSize[CoD.CraftableItemDisplay.FontName])
		f2_local11:setFont(CoD.fonts[CoD.CraftableItemDisplay.FontName])
		f2_local11:setAlignment(LUI.Alignment.Left)
		f2_local11:setText(CoD.CraftableItemDisplay.Groups[f2_local0][f2_local4].text)
		self:addElement(f2_local11)
		f2_arg0.craftGroups[f2_local4] = self
		f2_arg0.craftGroups[f2_local4].color = CoD.CraftableItemDisplay.Groups[f2_local0][f2_local4].color
		local f2_local12 = 0
		for f2_local13 = 1, #CoD.CraftableItemDisplay.ClientFieldNames[f2_local0], 1 do
			local f2_local16 = CoD.CraftableItemDisplay.ClientFieldNames[f2_local0][f2_local13]
			if f2_local16.group == f2_local4 then
				local f2_local17 = LUI.UIElement.new()
				f2_local17:setLeftRight(true, false, f2_local12, f2_local12 + CoD.CraftableItemDisplay.IconSize)
				f2_local17:setTopBottom(false, true, -CoD.CraftableItemDisplay.IconSize, 0)
				f2_local17.id = f2_local17.id .. ".IconContainer"
				f2_local17.groupID = f2_local4
				f2_local17.inUse = nil
				self:addElement(f2_local17)
				CoD.CraftablesIcon.new(f2_local17, CoD.CraftableItemDisplay.glowBackColor, CoD.CraftableItemDisplay.glowFrontColor)
				local f2_local18 = LUI.UIImage.new()
				f2_local18:setLeftRight(true, true, 0, 0)
				f2_local18:setTopBottom(true, true, 0, 0)
				f2_local18:setImage(f2_local16.material)
				f2_local18:setAlpha(0.25)
				f2_local17.icon = f2_local18
				f2_local17:addElement(f2_local18)
				f2_arg0.craftItems[f2_local13] = f2_local17
				f2_local12 = f2_local12 + CoD.CraftableItemDisplay.IconSize + CoD.CraftableItemDisplay.IconSpacing
			end
		end
		f2_local3 = f2_local3 + f2_local9 + f2_arg1
		f2_arg0:addSpacer(f2_arg1)
	end
	f2_arg0.visible = true
	return f2_local3
end

CoD.CraftableItemDisplay.Update = function(f3_arg0, f3_arg1)
	local f3_local0 = CoD.CraftableItemDisplay.GetCraftItemIndexFromClientField(f3_arg1.name)
	if f3_local0 <= 0 then
		return
	end
	CoD.CraftableItemDisplay.CraftableStates[f3_local0] = f3_arg1.newValue
	if f3_arg1.newValue == 1 then
		CoD.CraftableItemDisplay.UpdateCraftableStates(f3_arg0, f3_local0)
	end
end

CoD.CraftableItemDisplay.UpdateCraftableStates = function(f4_arg0, f4_arg1)
	if f4_arg0.craftItems then
		local f4_local0 = f4_arg0.craftItems[f4_arg1]
		if f4_local0 then
			if f4_local0.grunge then
				f4_local0.grunge:setAlpha(CoD.CraftablesIcon.GrungeAlpha)
			end
			f4_local0.icon:setAlpha(1)
			f4_local0:processEvent({
				name = "picked_up",
			})
			if f4_arg0.highlightRecentItem then
				f4_local0.highlight:alternateStates(CoD.CraftableItemDisplay.ONSCREEN_DURATION, CoD.CraftablesIcon.PulseRedBright, CoD.CraftablesIcon.PulseRedLow, 500, 500, CoD.CraftablesIcon.PulseWhite)
			end
			local f4_local1 = f4_arg0.craftGroups[f4_local0.groupID]
			if f4_local1 then
				f4_local1:beginAnimation("fade_in", CoD.CraftableItemDisplay.FADE_OUT_DURATION)
				f4_local1:setAlpha(1)
				if f4_local0.grunge then
					f4_local0.grunge:setRGB(f4_local1.color[1], f4_local1.color[2], f4_local1.color[3])
				end
				if f4_arg0.shouldFadeOutQuestStatus then
					CoD.CraftableItemDisplay.AddFadeOutTimer(f4_local1)
				end
			end
		end
	end
end

CoD.CraftableItemDisplay.GetCraftItemIndexFromClientField = function(f5_arg0)
	local f5_local0 = CoD.CraftableItemDisplay.CurrentMapName
	for f5_local1 = 1, #CoD.CraftableItemDisplay.ClientFieldNames[f5_local0], 1 do
		if CoD.CraftableItemDisplay.ClientFieldNames[f5_local0][f5_local1].clientFieldName == f5_arg0 then
			return f5_local1
		end
	end
	return -1
end

CoD.CraftableItemDisplay.AddFadeOutTimer = function(f6_arg0)
	if f6_arg0.fadeOutTimer then
		f6_arg0.fadeOutTimer:close()
		f6_arg0.fadeOutTimer:reset()
	end
	f6_arg0.fadeOutTimer = LUI.UITimer.new(CoD.CraftableItemDisplay.ONSCREEN_DURATION, "craft_group_fade_out", true, f6_arg0)
	f6_arg0:addElement(f6_arg0.fadeOutTimer)
end

CoD.CraftableItemDisplay.FadeoutGroupContainer = function(f7_arg0, f7_arg1)
	f7_arg0:beginAnimation("off_fade_out", CoD.CraftableItemDisplay.FADE_OUT_DURATION)
	f7_arg0:setAlpha(0)
end

CoD.CraftableItemDisplay.FadeOutComplete = function(f8_arg0, f8_arg1)
	if f8_arg1.interrupted ~= true then
		f8_arg0:dispatchEventToParent({
			name = "craft_group_update_position",
		})
	end
end

CoD.CraftableItemDisplay.ScoreboardUpdate = function(f9_arg0, f9_arg1)
	for f9_local0 = 1, #CoD.CraftableItemDisplay.CraftableStates, 1 do
		if CoD.CraftableItemDisplay.CraftableStates[f9_local0] == 1 then
			CoD.CraftableItemDisplay.UpdateCraftableStates(f9_arg0, f9_local0)
		end
	end
end
