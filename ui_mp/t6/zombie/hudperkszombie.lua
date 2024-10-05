CoD.Perks = {}
CoD.Perks.TopStart = -140
CoD.Perks.IconSize = 36
CoD.Perks.Spacing = 8
CoD.Perks.STATE_NOTOWNED = 0
CoD.Perks.STATE_OWNED = 1
CoD.Perks.STATE_PAUSED = 2
CoD.Perks.STATE_TBD = 3
CoD.Perks.ClientFieldNames = {}
CoD.Perks.ClientFieldNames[1] = {
	clientFieldName = "perk_additional_primary_weapon",
	material = RegisterMaterial("specialty_additionalprimaryweapon_zombies"),
}
CoD.Perks.ClientFieldNames[2] = {
	clientFieldName = "perk_dead_shot",
	material = RegisterMaterial("specialty_ads_zombies"),
}
CoD.Perks.ClientFieldNames[3] = {
	clientFieldName = "perk_dive_to_nuke",
	material = RegisterMaterial("specialty_divetonuke_zombies"),
}
CoD.Perks.ClientFieldNames[4] = {
	clientFieldName = "perk_double_tap",
	material = RegisterMaterial("specialty_doubletap_zombies"),
}
CoD.Perks.ClientFieldNames[5] = {
	clientFieldName = "perk_juggernaut",
	material = RegisterMaterial("specialty_juggernaut_zombies"),
}
CoD.Perks.ClientFieldNames[6] = {
	clientFieldName = "perk_marathon",
	material = RegisterMaterial("specialty_marathon_zombies"),
}
CoD.Perks.ClientFieldNames[7] = {
	clientFieldName = "perk_quick_revive",
	material = RegisterMaterial("specialty_quickrevive_zombies"),
}
CoD.Perks.ClientFieldNames[8] = {
	clientFieldName = "perk_sleight_of_hand",
	material = RegisterMaterial("specialty_fastreload_zombies"),
}
CoD.Perks.ClientFieldNames[9] = {
	clientFieldName = "perk_tombstone",
	material = RegisterMaterial("specialty_tombstone_zombies"),
}
CoD.Perks.ClientFieldNames[10] = {
	clientFieldName = "perk_chugabud",
	material = RegisterMaterial("specialty_chugabud_zombies"),
}
CoD.Perks.ClientFieldNames[11] = {
	clientFieldName = "perk_electric_cherry",
	material = RegisterMaterial("specialty_electric_cherry_zombie"),
}
CoD.Perks.ClientFieldNames[12] = {
	clientFieldName = "perk_vulture",
	material = RegisterMaterial("specialty_vulture_zombies"),
	glowMaterial = RegisterMaterial("zm_hud_stink_perk_glow"),
}
CoD.Perks.SpecialtyToClientFieldNames = {
	specialty_armorvest = "perk_juggernaut",
	specialty_quickrevive = "perk_quick_revive",
	specialty_fastreload = "perk_sleight_of_hand",
	specialty_rof = "perk_double_tap",
	specialty_movefaster = "perk_marathon",
	specialty_flakjacket = "perk_dive_to_nuke",
	specialty_deadshot = "perk_dead_shot",
	specialty_additionalprimaryweapon = "perk_additional_primary_weapon",
	specialty_scavenger = "perk_tombstone",
	specialty_finalstand = "perk_chugabud",
	specialty_grenadepulldeath = "perk_electric_cherry",
	specialty_nomotionsensor = "perk_vulture",
}
CoD.Perks.PulseDuration = 200
CoD.Perks.PulseScale = 1.3
CoD.Perks.PausedAlpha = 0.3
LUI.createMenu.PerksArea = function(LocalClientIndex)
	local PerksAreaWidget = CoD.Menu.NewSafeAreaFromState("PerksArea", LocalClientIndex)
	PerksAreaWidget:setOwner(LocalClientIndex)
	PerksAreaWidget.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	PerksAreaWidget.scaleContainer:setLeftRight(true, false, 10, 0)
	PerksAreaWidget.scaleContainer:setTopBottom(false, true, 0, 0)
	PerksAreaWidget:addElement(PerksAreaWidget.scaleContainer)
	CoD.Perks.MeterBlackMaterial = RegisterMaterial("zm_hud_stink_ani_black")
	CoD.Perks.MeterGreenMaterial = RegisterMaterial("zm_hud_stink_ani_green")
	local f1_local1, f1_local2 = nil, nil
	PerksAreaWidget.perks = {}
	for ClientFieldIndex = 1, #CoD.Perks.ClientFieldNames, 1 do
		f1_local1 = (CoD.Perks.IconSize + CoD.Perks.Spacing) * (ClientFieldIndex - 1)
		f1_local2 = f1_local1 + CoD.Perks.IconSize
		local Widget = LUI.UIElement.new()
		Widget:setLeftRight(true, false, f1_local1, f1_local2)
		Widget:setTopBottom(false, true, CoD.Perks.TopStart, CoD.Perks.TopStart + CoD.Perks.IconSize)
		Widget:setScale(1)
		Widget.perkId = nil

		local perkIcon = LUI.UIImage.new()
		perkIcon:setLeftRight(true, true, 0, 0)
		perkIcon:setTopBottom(true, true, 0, 0)
		perkIcon:setAlpha(0)
		Widget:addElement(perkIcon)
		Widget.perkIcon = perkIcon

		Widget:registerEventHandler("transition_complete_pulse", CoD.Perks.IconPulseFinish)
		PerksAreaWidget.scaleContainer:addElement(Widget)
		PerksAreaWidget.perks[ClientFieldIndex] = Widget
		PerksAreaWidget:registerEventHandler(CoD.Perks.ClientFieldNames[ClientFieldIndex].clientFieldName, CoD.Perks.Update)
	end
	PerksAreaWidget:registerEventHandler("hud_update_perk_order", CoD.Perks.UpdateOrder)
	PerksAreaWidget:registerEventHandler("hud_update_refresh", CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Perks.UpdateVisibility)
	PerksAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Perks.UpdateVisibility)
	PerksAreaWidget.visible = true
	return PerksAreaWidget
end

CoD.Perks.UpdateVisibility = function(Menu, ClientInstance)
	local f2_local0 = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(f2_local0) or CoD.ExeProfileVarBool(f2_local0, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(f2_local0)) and CoD.FSM_VISIBILITY(f2_local0) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.Perks.GetMaterial = function(Menu, ClientFieldName)
	local Material = nil
	for ClientFieldIndex = 1, #CoD.Perks.ClientFieldNames, 1 do
		if CoD.Perks.ClientFieldNames[ClientFieldIndex].clientFieldName == ClientFieldName then
			Material = CoD.Perks.ClientFieldNames[ClientFieldIndex].material
			break
		end
	end
	return Material
end

CoD.Perks.GetGlowMaterial = function(Menu, ClientFieldName)
	local Material = nil
	for ClientFieldIndex = 1, #CoD.Perks.ClientFieldNames, 1 do
		if CoD.Perks.ClientFieldNames[ClientFieldIndex].clientFieldName == ClientFieldName then
			if CoD.Perks.ClientFieldNames[ClientFieldIndex].glowMaterial then
				Material = CoD.Perks.ClientFieldNames[ClientFieldIndex].glowMaterial
				break
			end
		end
	end
	return Material
end

CoD.Perks.RemovePerkIcon = function(Menu, OwnedPerkIndex)
	local PerkWidget, NextPerkWidget = nil, nil
	for PerkIndex = OwnedPerkIndex, #CoD.Perks.ClientFieldNames, 1 do
		PerkWidget = Menu.perks[PerkIndex]
		if not PerkWidget.perkId then
			break
		elseif PerkIndex ~= #CoD.Perks.ClientFieldNames then
			NextPerkWidget = Menu.perks[PerkIndex + 1]
		end
		if not NextPerkWidget then
			PerkWidget.perkIcon:setAlpha(0)
			if PerkWidget.perkGlowIcon then
			else
				PerkWidget.perkId = nil
				break
			end
			PerkWidget.perkGlowIcon:setAlpha(0)
		elseif not NextPerkWidget.perkId then
			PerkWidget.perkIcon:setAlpha(0)
			if PerkWidget.perkGlowIcon then
				PerkWidget.perkGlowIcon:close()
				PerkWidget.perkGlowIcon = nil
			end
			if PerkWidget.meterContainer then
			else
				PerkWidget.perkId = nil
				break
			end
			PerkWidget.meterContainer:close()
			PerkWidget.meterContainer = nil
		else
			PerkWidget.perkIcon:setImage(CoD.Perks.GetMaterial(Menu, NextPerkWidget.perkId))
			local f5_local5 = CoD.Perks.GetGlowMaterial(Menu, NextPerkWidget.perkId)
			if f5_local5 and PerkWidget.perkGlowIcon then
				PerkWidget.perkGlowIcon:setImage(f5_local5)
			end
		end
		PerkWidget.perkId = NextPerkWidget.perkId
	end
end

CoD.Perks.Update = function(Menu, ClientInstance)
	local PerkWidget = nil
	for OwnedPerkIndex = 1, #CoD.Perks.ClientFieldNames, 1 do
		PerkWidget = Menu.perks[OwnedPerkIndex]
		if ClientInstance.newValue == CoD.Perks.STATE_OWNED then
			if not PerkWidget.perkId then
				PerkWidget.perkId = ClientInstance.name
				PerkWidget.perkIcon:setImage(CoD.Perks.GetMaterial(Menu, ClientInstance.name))
				PerkWidget.perkIcon:setAlpha(1)

				if PerkWidget.perkId == "perk_vulture" then
					CoD.Perks.AddVultureMeter(Menu, PerkWidget)
					CoD.Perks.AddGlowIcon(Menu, PerkWidget)

					local f6_local4 = CoD.Perks.GetGlowMaterial(Menu, ClientInstance.name)
					if f6_local4 and PerkWidget.perkGlowIcon then
						PerkWidget.perkGlowIcon:setImage(f6_local4)
					end
				end

				break
			elseif PerkWidget.perkId == ClientInstance.name then
				PerkWidget:beginAnimation("pulse", CoD.Perks.PulseDuration)
				PerkWidget:setScale(CoD.Perks.PulseScale)
				PerkWidget.perkIcon:beginAnimation("pulse", CoD.Perks.PulseDuration)
				PerkWidget.perkIcon:setAlpha(1)
				if PerkWidget.perkGlowIcon then
					PerkWidget.perkGlowIcon:beginAnimation("pulse", CoD.Perks.PulseDuration)
				end

				break
			end
		end
		if ClientInstance.newValue == CoD.Perks.STATE_NOTOWNED then
			if PerkWidget.perkId == ClientInstance.name then
				CoD.Perks.RemovePerkIcon(Menu, OwnedPerkIndex)
				break
			end
		end
		if ClientInstance.newValue == CoD.Perks.STATE_PAUSED then
			if PerkWidget.perkId == ClientInstance.name then
				PerkWidget:beginAnimation("pulse", CoD.Perks.PulseDuration)
				PerkWidget:setScale(CoD.Perks.PulseScale)
				PerkWidget.perkIcon:beginAnimation("pulse", CoD.Perks.PulseDuration)
				PerkWidget.perkIcon:setAlpha(CoD.Perks.PausedAlpha)
				if PerkWidget.perkGlowIcon then
					PerkWidget.perkGlowIcon:beginAnimation("pulse", CoD.Perks.PulseDuration)
					PerkWidget.perkGlowIcon:setAlpha(0)
				end

				break
			end
		end
		if ClientInstance.newValue == CoD.Perks.STATE_TBD then
		end
	end
end

CoD.Perks.UpdateOrder = function(Menu, ClientInstance)
	local OrderedPerks = UIExpression.DvarString(nil, "perk_order")
	local OrderedPerksIndex = 0
	local OrderedPerksStartIndex = 1

	for OwnedPerkIndex = 1, #CoD.Perks.ClientFieldNames, 1 do
		local OwnedPerkWidget = Menu.perks[OwnedPerkIndex]

		if not OwnedPerkWidget.perkId then
			OrderedPerksStartIndex = OwnedPerkIndex
			break
		end
	end

	for Perk in string.gmatch(OrderedPerks, "(.-);") do
		local PerkWidget = Menu.perks[OrderedPerksStartIndex + OrderedPerksIndex]
		PerkWidget.perkId = CoD.Perks.SpecialtyToClientFieldNames[Perk]
		PerkWidget.perkIcon:setImage(CoD.Perks.GetMaterial(Menu, PerkWidget.perkId))

		if PerkWidget.perkId == "perk_vulture" then
			CoD.Perks.AddVultureMeter(Menu, PerkWidget)
			CoD.Perks.AddGlowIcon(Menu, PerkWidget)

			local GlowMaterial = CoD.Perks.GetGlowMaterial(Menu, PerkWidget.perkId)
			if GlowMaterial and PerkWidget.perkGlowIcon then
				PerkWidget.perkGlowIcon:setImage(GlowMaterial)
			end
		else
			if PerkWidget.perkGlowIcon then
				PerkWidget.perkGlowIcon:close()
				PerkWidget.perkGlowIcon = nil
			end

			if PerkWidget.meterContainer then
				PerkWidget.meterContainer:close()
				PerkWidget.meterContainer = nil
			end
		end

		OrderedPerksIndex = OrderedPerksIndex + 1
	end
end

CoD.Perks.IconPulseFinish = function(Menu, ClientInstance)
	if ClientInstance.interrupted ~= true then
		Menu:beginAnimation("pulse_done", CoD.Perks.PulseDuration)
		Menu:setScale(1)
	end
end

CoD.Perks.AddGlowIcon = function(Menu, PerkWidget)
	if not PerkWidget.perkGlowIcon then
		local GlowIcon = LUI.UIImage.new()
		GlowIcon:setLeftRight(true, true, -CoD.Perks.IconSize / 2, CoD.Perks.IconSize / 2)
		GlowIcon:setTopBottom(true, true, -CoD.Perks.IconSize / 2, CoD.Perks.IconSize / 2)
		GlowIcon:setAlpha(0)
		PerkWidget:addElement(GlowIcon)
		PerkWidget.perkGlowIcon = GlowIcon
	end
end

CoD.Perks.AddVultureMeter = function(Menu, PerkWidget)
	if not PerkWidget.meterContainer then
		local f9_local0 = CoD.Perks.TopStart + CoD.Perks.IconSize * 2
		local f9_local1 = -CoD.Perks.IconSize

		local meterContainer = LUI.UIElement.new()
		meterContainer:setLeftRight(true, false, 0, CoD.Perks.IconSize)
		meterContainer:setTopBottom(false, true, f9_local0 + 5, f9_local1 + 5)
		meterContainer:setAlpha(0)
		meterContainer:setPriority(-10)
		PerkWidget:addElement(meterContainer)
		PerkWidget.meterContainer = meterContainer

		local f9_local3 = LUI.UIImage.new()
		f9_local3:setLeftRight(true, true, -CoD.Perks.IconSize / 2, CoD.Perks.IconSize / 2)
		f9_local3:setTopBottom(true, true, 0, 0)
		f9_local3:setImage(CoD.Perks.MeterBlackMaterial)
		meterContainer:addElement(f9_local3)
		local f9_local4 = LUI.UIImage.new()
		f9_local4:setLeftRight(true, true, -CoD.Perks.IconSize / 2, CoD.Perks.IconSize / 2)
		f9_local4:setTopBottom(true, true, 0, 0)
		f9_local4:setImage(CoD.Perks.MeterGreenMaterial)
		meterContainer:addElement(f9_local4)
		PerkWidget:registerEventHandler("vulture_perk_disease_meter", CoD.Perks.UpdateVultureDiseaseMeter)
	end
end

CoD.Perks.UpdateVultureDiseaseMeter = function(Menu, ClientInstance)
	local f10_local0 = ClientInstance.newValue
	if Menu.meterContainer then
		Menu.meterContainer:setAlpha(f10_local0)
	end
	if Menu.perkGlowIcon then
		Menu.perkGlowIcon:setAlpha(f10_local0)
	end
end
