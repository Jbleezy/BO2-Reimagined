require("T6.Zombie.CraftablesIcon")

CoD.CraftableItemTombDisplay = {}
CoD.CraftableItemTombDisplay.IconSize = 48
CoD.CraftableItemTombDisplay.FontName = "ExtraSmall"
CoD.CraftableItemTombDisplay.ContainerSize = CoD.CraftableItemTombDisplay.IconSize + CoD.textSize[CoD.CraftableItemTombDisplay.FontName] + 5
CoD.CraftableItemTombDisplay.IconSpacing = 5
CoD.CraftableItemTombDisplay.MOVING_DURATION = 500
CoD.CraftableItemTombDisplay.ONSCREEN_DURATION = 5000
CoD.CraftableItemTombDisplay.FADE_OUT_DURATION = 500
CoD.CraftableItemTombDisplay.CRAFT_ITEM_1 = 1
CoD.CraftableItemTombDisplay.CRAFT_ITEM_2 = 2
CoD.CraftableItemTombDisplay.glowBackColor = {}
CoD.CraftableItemTombDisplay.glowBackColor.r = 1
CoD.CraftableItemTombDisplay.glowBackColor.g = 1
CoD.CraftableItemTombDisplay.glowBackColor.b = 1
CoD.CraftableItemTombDisplay.glowFrontColor = {}
CoD.CraftableItemTombDisplay.glowFrontColor.r = 1
CoD.CraftableItemTombDisplay.glowFrontColor.g = 1
CoD.CraftableItemTombDisplay.glowFrontColor.b = 1
CoD.CraftableItemTombDisplay.Groups = {}
CoD.CraftableItemTombDisplay.Groups[CoD.Zombie.MAP_ZM_TOMB] = {}
CoD.CraftableItemTombDisplay.Groups[CoD.Zombie.MAP_ZM_TOMB][CoD.CraftableItemTombDisplay.CRAFT_ITEM_1] = {
	text = Engine.Localize("ZM_TOMB_ZOMBIE_SHIELD"),
	color = {
		0.76,
		0.52,
		0.65,
	},
}
CoD.CraftableItemTombDisplay.Groups[CoD.Zombie.MAP_ZM_TOMB][CoD.CraftableItemTombDisplay.CRAFT_ITEM_2] = {
	text = Engine.Localize("ZM_TOMB_QUADROTOR"),
	color = {
		1.0,
		0.4,
		0.0,
	},
}
CoD.CraftableItemTombDisplay.ClientFieldNames = {}
CoD.CraftableItemTombDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_TOMB] = {}
CoD.CraftableItemTombDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_TOMB][1] = {
	clientFieldName = "piece_riotshield_dolly",
	materialName = "zom_hud_craftable_zshield_vizor",
	group = CoD.CraftableItemTombDisplay.CRAFT_ITEM_1,
}
CoD.CraftableItemTombDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_TOMB][2] = {
	clientFieldName = "piece_riotshield_door",
	materialName = "zom_hud_craftable_zshield_body",
	group = CoD.CraftableItemTombDisplay.CRAFT_ITEM_1,
}
CoD.CraftableItemTombDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_TOMB][3] = {
	clientFieldName = "piece_riotshield_clamp",
	materialName = "zom_hud_craftable_zshield_feet",
	group = CoD.CraftableItemTombDisplay.CRAFT_ITEM_1,
}
CoD.CraftableItemTombDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_TOMB][4] = {
	clientFieldName = "piece_quadrotor_zm_body",
	materialName = "zom_hud_craftable_zquad_body",
	group = CoD.CraftableItemTombDisplay.CRAFT_ITEM_2,
}
CoD.CraftableItemTombDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_TOMB][5] = {
	clientFieldName = "piece_quadrotor_zm_brain",
	materialName = "zom_hud_craftable_zquad_brain",
	group = CoD.CraftableItemTombDisplay.CRAFT_ITEM_2,
}
CoD.CraftableItemTombDisplay.ClientFieldNames[CoD.Zombie.MAP_ZM_TOMB][6] = {
	clientFieldName = "piece_quadrotor_zm_engine",
	materialName = "zom_hud_craftable_zquad_engine",
	group = CoD.CraftableItemTombDisplay.CRAFT_ITEM_2,
}
CoD.CraftableItemTombDisplay.new = function(f1_arg0)
	f1_arg0.id = f1_arg0.id .. ".CraftableItemTombDisplay"
	CoD.CraftableItemTombDisplay.CurrentMapName = CoD.Zombie.GetUIMapName()
	local f1_local0 = CoD.CraftableItemTombDisplay.CurrentMapName
	if not CoD.CraftableItemTombDisplay.ClientFieldNames[f1_local0] then
		return
	end
	CoD.CraftableItemTombDisplay.CraftableStates = {
		0,
		0,
		0,
		0,
		0,
		0,
	}
	for f1_local1 = 1, #CoD.CraftableItemTombDisplay.ClientFieldNames[f1_local0], 1 do
		f1_arg0:registerEventHandler(CoD.CraftableItemTombDisplay.ClientFieldNames[f1_local0][f1_local1].clientFieldName, CoD.CraftableItemTombDisplay.Update)
	end
	return f1_arg0
end

CoD.CraftableItemTombDisplay.AddDisplayContainer = function(f2_arg0, f2_arg1, f2_arg2, f2_arg3, f2_arg4)
	local f2_local0 = CoD.CraftableItemTombDisplay.CurrentMapName
	for f2_local4, f2_local5 in ipairs(CoD.CraftableItemTombDisplay.Groups[f2_local0]) do
		f2_local5.count = 0
	end
	for f2_local1 = 1, #CoD.CraftableItemTombDisplay.ClientFieldNames[f2_local0], 1 do
		local f2_local5 = CoD.CraftableItemTombDisplay.ClientFieldNames[f2_local0][f2_local1]
		f2_local5.material = RegisterMaterial(f2_local5.materialName)
		for f2_local9, self in ipairs(CoD.CraftableItemTombDisplay.Groups[f2_local0]) do
			if f2_local5.group == f2_local9 then
				self.count = self.count + 1
			end
		end
	end
	local f2_local1 = 0
	local f2_local2 = 0
	local f2_local3 = 0
	if not f2_arg4 then
		f2_arg4 = 0
	end
	f2_arg0.craftGroups = {}
	f2_arg0.craftItems = {}
	for f2_local4 = 1, #CoD.CraftableItemTombDisplay.Groups[f2_local0], 1 do
		local f2_local8 = CoD.CraftableItemTombDisplay.Groups[f2_local0][f2_local4].count
		local f2_local9 = CoD.CraftableItemTombDisplay.IconSize * f2_local8 + CoD.CraftableItemTombDisplay.IconSpacing * (f2_local8 - 1)
		local self = LUI.UIElement.new()
		self:setLeftRight(true, false, f2_local1, f2_local1 + f2_local9)
		self:setTopBottom(true, false, f2_local2, f2_local2 + CoD.CraftableItemTombDisplay.ContainerSize + f2_arg4)
		if not f2_arg2 then
			self:setAlpha(0)
		end
		self.id = self.id .. ".CraftGroupContainer"
		f2_arg0:addElement(self)
		self:registerEventHandler("craft_group_fade_out", CoD.CraftableItemTombDisplay.FadeoutGroupContainer)
		self:registerEventHandler("transition_complete_off_fade_out", CoD.CraftableItemTombDisplay.FadeOutComplete)
		if f2_arg2 and f2_arg3 then
			local f2_local11 = LUI.UIImage.new()
			f2_local11:setLeftRight(true, true, -f2_arg3, f2_arg3)
			f2_local11:setTopBottom(true, true, -f2_arg3, f2_arg3)
			f2_local11:setRGB(0, 0, 0)
			f2_local11:setAlpha(0.7)
			self:addElement(f2_local11)
			f2_local3 = f2_local3 + f2_arg3
		end
		if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
			local f2_local11 = LUI.UIText.new()
			f2_local11:setLeftRight(true, true, 0, 0)
			f2_local11:setTopBottom(true, false, 0, CoD.textSize[CoD.CraftableItemTombDisplay.FontName])
			f2_local11:setFont(CoD.fonts[CoD.CraftableItemTombDisplay.FontName])
			f2_local11:setAlignment(LUI.Alignment.Left)
			f2_local11:setText(CoD.CraftableItemTombDisplay.Groups[f2_local0][f2_local4].text)
			self:addElement(f2_local11)
		end
		f2_arg0.craftGroups[f2_local4] = self
		f2_arg0.craftGroups[f2_local4].color = CoD.CraftableItemTombDisplay.Groups[f2_local0][f2_local4].color
		local f2_local11 = 0
		for f2_local12 = 1, #CoD.CraftableItemTombDisplay.ClientFieldNames[f2_local0], 1 do
			local f2_local15 = CoD.CraftableItemTombDisplay.ClientFieldNames[f2_local0][f2_local12]
			if f2_local15.group == f2_local4 then
				local f2_local16 = LUI.UIElement.new()
				f2_local16:setLeftRight(true, false, f2_local11, f2_local11 + CoD.CraftableItemTombDisplay.IconSize)
				f2_local16:setTopBottom(false, true, -CoD.CraftableItemTombDisplay.IconSize, 0)
				f2_local16.id = f2_local16.id .. ".IconContainer"
				f2_local16.groupID = f2_local4
				f2_local16.inUse = nil
				self:addElement(f2_local16)
				CoD.CraftablesIcon.new(f2_local16, CoD.CraftableItemTombDisplay.glowBackColor, CoD.CraftableItemTombDisplay.glowFrontColor)
				local f2_local17 = LUI.UIImage.new()
				f2_local17:setLeftRight(true, true, 0, 0)
				f2_local17:setTopBottom(true, true, 0, 0)
				f2_local17:setImage(f2_local15.material)
				f2_local17:setAlpha(0.25)
				f2_local16.icon = f2_local17
				f2_local16:addElement(f2_local17)
				f2_arg0.craftItems[f2_local12] = f2_local16
				f2_local11 = f2_local11 + CoD.CraftableItemTombDisplay.IconSize + CoD.CraftableItemTombDisplay.IconSpacing
			end
		end
		f2_local3 = f2_local3 + f2_local9 + f2_arg1
		f2_arg0:addSpacer(f2_arg1)
	end
	f2_arg0.visible = true
	return f2_local3
end

CoD.CraftableItemTombDisplay.Update = function(f3_arg0, f3_arg1)
	local f3_local0 = CoD.CraftableItemTombDisplay.GetCraftItemIndexFromClientField(f3_arg1.name)
	if f3_local0 <= 0 then
		return
	end
	CoD.CraftableItemTombDisplay.CraftableStates[f3_local0] = f3_arg1.newValue
	if f3_arg1.newValue == 1 then
		CoD.CraftableItemTombDisplay.UpdateCraftableStates(f3_arg0, f3_local0)
	end
end

CoD.CraftableItemTombDisplay.UpdateCraftableStates = function(f4_arg0, f4_arg1)
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
				f4_local0.highlight:alternateStates(CoD.CraftableItemTombDisplay.ONSCREEN_DURATION, CoD.CraftablesIcon.PulseRedBright, CoD.CraftablesIcon.PulseRedLow, 500, 500, CoD.CraftablesIcon.PulseWhite)
			end
			local f4_local1 = f4_arg0.craftGroups[f4_local0.groupID]
			if f4_local1 then
				f4_local1:beginAnimation("fade_in", CoD.CraftableItemTombDisplay.FADE_OUT_DURATION)
				f4_local1:setAlpha(1)
				if f4_local0.grunge then
					f4_local0.grunge:setRGB(f4_local1.color[1], f4_local1.color[2], f4_local1.color[3])
				end
				if f4_arg0.shouldFadeOutQuestStatus then
					CoD.CraftableItemTombDisplay.AddFadeOutTimer(f4_local1)
				end
			end
		end
	end
end

CoD.CraftableItemTombDisplay.GetCraftItemIndexFromClientField = function(f5_arg0)
	local f5_local0 = CoD.CraftableItemTombDisplay.CurrentMapName
	for f5_local1 = 1, #CoD.CraftableItemTombDisplay.ClientFieldNames[f5_local0], 1 do
		if CoD.CraftableItemTombDisplay.ClientFieldNames[f5_local0][f5_local1].clientFieldName == f5_arg0 then
			return f5_local1
		end
	end
	return -1
end

CoD.CraftableItemTombDisplay.AddFadeOutTimer = function(f6_arg0)
	if f6_arg0.fadeOutTimer then
		f6_arg0.fadeOutTimer:close()
		f6_arg0.fadeOutTimer:reset()
	end
	f6_arg0.fadeOutTimer = LUI.UITimer.new(CoD.CraftableItemTombDisplay.ONSCREEN_DURATION, "craft_group_fade_out", true, f6_arg0)
	f6_arg0:addElement(f6_arg0.fadeOutTimer)
end

CoD.CraftableItemTombDisplay.FadeoutGroupContainer = function(f7_arg0, f7_arg1)
	f7_arg0:beginAnimation("off_fade_out", CoD.CraftableItemTombDisplay.FADE_OUT_DURATION)
	f7_arg0:setAlpha(0)
end

CoD.CraftableItemTombDisplay.FadeOutComplete = function(f8_arg0, f8_arg1)
	if f8_arg1.interrupted ~= true then
		f8_arg0:dispatchEventToParent({
			name = "craft_group_update_position",
		})
	end
end

CoD.CraftableItemTombDisplay.ScoreboardUpdate = function(f9_arg0, f9_arg1)
	for f9_local0 = 1, #CoD.CraftableItemTombDisplay.CraftableStates, 1 do
		if CoD.CraftableItemTombDisplay.CraftableStates[f9_local0] == 1 then
			CoD.CraftableItemTombDisplay.UpdateCraftableStates(f9_arg0, f9_local0)
		end
	end
end
