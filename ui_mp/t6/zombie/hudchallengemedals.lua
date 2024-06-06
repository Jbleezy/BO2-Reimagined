CoD.HudChallengeMedals = {}
CoD.HudChallengeMedals.MedalTopStart = CoD.Perks.TopStart - 45
CoD.HudChallengeMedals.IconWidth = 50
CoD.HudChallengeMedals.IconHeight = CoD.HudChallengeMedals.IconWidth
CoD.HudChallengeMedals.ONSCREEN_DURATION = 3000
CoD.HudChallengeMedals.MEDAL_OFF = 0
CoD.HudChallengeMedals.MEDAL_ON = 1
CoD.HudChallengeMedals.ClientFieldNames = {}
CoD.HudChallengeMedals.ClientFieldNames[1] = {
	clientFieldName = "challenge_complete_1",
	materialName = "tomb_medal_kill",
}
CoD.HudChallengeMedals.ClientFieldNames[2] = {
	clientFieldName = "challenge_complete_2",
	materialName = "tomb_medal_level",
}
CoD.HudChallengeMedals.ClientFieldNames[3] = {
	clientFieldName = "challenge_complete_3",
	materialName = "tomb_medal_economy",
}
CoD.HudChallengeMedals.ClientFieldNames[4] = {
	clientFieldName = "challenge_complete_4",
	materialName = "tomb_medal_team",
}
LUI.createMenu.ChallengeMedalsArea = function(f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("ChallengeMedalsArea", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	f1_local0.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.scaleContainer:setLeftRight(true, true, 0, 0)
	f1_local0.scaleContainer:setTopBottom(false, true, 0, 0)
	f1_local0:addElement(f1_local0.scaleContainer)
	local f1_local1 = -CoD.HudChallengeMedals.MedalTopStart + 5
	local f1_local2 = LUI.UIHorizontalList.new()
	f1_local2:setLeftRight(true, true, 5, 0)
	f1_local2:setTopBottom(false, true, -CoD.HudChallengeMedals.IconHeight - f1_local1, -f1_local1)
	f1_local0.scaleContainer:addElement(f1_local2)
	f1_local0.medalsContainer = f1_local2
	f1_local0.medals = {}
	for f1_local3 = 1, #CoD.HudChallengeMedals.ClientFieldNames, 1 do
		if not CoD.HudChallengeMedals.ClientFieldNames[f1_local3].material then
			CoD.HudChallengeMedals.ClientFieldNames[f1_local3].material = RegisterMaterial(CoD.HudChallengeMedals.ClientFieldNames[f1_local3].materialName)
		end
		f1_local0:registerEventHandler(CoD.HudChallengeMedals.ClientFieldNames[f1_local3].clientFieldName, CoD.HudChallengeMedals.UpdateMedalDisplay)
	end
	if not CoD.HudChallengeMedals.MedalGlowBigMaterial then
		CoD.HudChallengeMedals.MedalGlowBigMaterial = RegisterMaterial("tomb_medal_glow_big")
	end
	if not CoD.HudChallengeMedals.MedalGlowSmallMaterial then
		CoD.HudChallengeMedals.MedalGlowSmallMaterial = RegisterMaterial("tomb_medal_glow_small")
	end
	f1_local0:registerEventHandler("remove_challenge_medal", CoD.HudChallengeMedals.RemoveMedal)
	f1_local0:registerEventHandler("hud_update_refresh", CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.HudChallengeMedals.UpdateVisibility)
	f1_local0.visible = true
	return f1_local0
end

CoD.HudChallengeMedals.UpdateVisibility = function(f2_arg0, f2_arg1)
	local f2_local0 = f2_arg1.controller
	if UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(f2_local0) or CoD.ExeProfileVarBool(f2_local0, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(f2_local0)) and CoD.FSM_VISIBILITY(f2_local0) == 0 then
		if f2_arg0.visible ~= true then
			f2_arg0:setAlpha(1)
			f2_arg0.m_inputDisabled = nil
			f2_arg0.visible = true
		end
	elseif f2_arg0.visible == true then
		f2_arg0:setAlpha(0)
		f2_arg0.m_inputDisabled = true
		f2_arg0.visible = nil
	end
	f2_arg0:dispatchEventToChildren(f2_arg1)
end

CoD.HudChallengeMedals.UpdateMedalDisplay = function(f3_arg0, f3_arg1)
	local f3_local0 = f3_arg1.newValue
	local f3_local1 = f3_arg1.name
	if f3_local0 == CoD.HudChallengeMedals.MEDAL_OFF then
		local f3_local2 = CoD.HudChallengeMedals.GetMedalIndexFromClientFieldName(f3_arg0, f3_local1)
		if f3_local2 then
			f3_arg0.medals[f3_local2]:setAlpha(0)
			f3_arg0.medals[f3_local2]:beginAnimation("minimize", 500)
			f3_arg0.medals[f3_local2]:setLeftRight(false, false, 0, 0)
			f3_arg0.medals[f3_local2]:setTopBottom(false, false, 0, 0)
			f3_arg0:addElement(LUI.UITimer.new(500, {
				name = "remove_challenge_medal",
				index = f3_local2,
			}, true))
		end
	elseif f3_local0 == CoD.HudChallengeMedals.MEDAL_ON then
		if CoD.HudChallengeMedals.IsMedalInUse(f3_arg0, f3_local1) == true then
			return
		end
		local f3_local2 = CoD.HudChallengeMedals.GetClientfieldMedalIndex(f3_arg0, f3_local1)
		if not f3_local2 then
			return
		end
		local f3_local3 = CoD.HudChallengeMedals.GetFirstAvailableIndex(f3_arg0)
		if f3_local3 then
			local f3_local4 = CoD.HudChallengeMedals.IconWidth
			local f3_local5 = CoD.HudChallengeMedals.IconHeight
			local f3_local6 = CoD.HudChallengeMedals.MedalGlowSmallMaterial
			if string.sub(f3_local1, -1) == "4" == true then
				f3_local4 = CoD.HudChallengeMedals.IconWidth * 1.45
				f3_local6 = CoD.HudChallengeMedals.MedalGlowBigMaterial
			end
			local f3_local7 = LUI.UIImage.new()
			f3_local7:setLeftRight(true, false, 0, f3_local4)
			f3_local7:setTopBottom(true, false, 0, f3_local5)
			f3_local7:setImage(CoD.HudChallengeMedals.ClientFieldNames[f3_local2].material)
			f3_arg0.medalsContainer:addElement(f3_local7)
			f3_local7.medalId = f3_local1
			local f3_local8 = LUI.UIImage.new()
			f3_local8:setLeftRight(true, true, 0, 0)
			f3_local8:setTopBottom(true, true, 0, 0)
			f3_local8:setImage(f3_local6)
			f3_local7:addElement(f3_local8)
			f3_local8:alternateStates(CoD.HudChallengeMedals.ONSCREEN_DURATION, CoD.HudChallengeMedals.PulseBright, CoD.HudChallengeMedals.PulseLow, 500, 500, CoD.CraftablesIcon.PulseOff)
			f3_arg0.medals[f3_local3] = f3_local7
		end
	end
end

CoD.HudChallengeMedals.RemoveMedal = function(f4_arg0, f4_arg1)
	local f4_local0 = f4_arg1.index
	if f4_arg0.medals[f4_local0] then
		f4_arg0.medalsContainer:removeElement(f4_arg0.medals[f4_local0])
		f4_arg0.medals[f4_local0]:close()
		f4_arg0.medals[f4_local0] = nil
		table.remove(f4_arg0.medals, f4_local0)
	end
end

CoD.HudChallengeMedals.GetClientfieldMedalIndex = function(f5_arg0, f5_arg1)
	for f5_local0 = 1, #CoD.HudChallengeMedals.ClientFieldNames, 1 do
		if CoD.HudChallengeMedals.ClientFieldNames[f5_local0].clientFieldName == f5_arg1 then
			return f5_local0
		end
	end
end

CoD.HudChallengeMedals.GetFirstAvailableIndex = function(f6_arg0)
	for f6_local0 = 1, #CoD.HudChallengeMedals.ClientFieldNames, 1 do
		if not f6_arg0.medals[f6_local0] then
			return f6_local0
		elseif not f6_arg0.medals[f6_local0].medalId then
			return f6_local0
		end
	end
end

CoD.HudChallengeMedals.IsMedalInUse = function(f7_arg0, f7_arg1)
	for f7_local0 = 1, #f7_arg0.medals, 1 do
		if f7_arg0.medals[f7_local0].medalId == f7_arg1 then
			return true
		end
	end
	return false
end

CoD.HudChallengeMedals.GetMedalIndexFromClientFieldName = function(f8_arg0, f8_arg1)
	for f8_local0 = 1, #f8_arg0.medals, 1 do
		if f8_arg0.medals[f8_local0].medalId == f8_arg1 then
			return f8_local0
		end
	end
end

CoD.HudChallengeMedals.PulseBright = function(f9_arg0, f9_arg1)
	f9_arg0:beginAnimation("pulse_bright", f9_arg1)
	f9_arg0:setAlpha(1)
end

CoD.HudChallengeMedals.PulseLow = function(f10_arg0, f10_arg1)
	f10_arg0:beginAnimation("pulse_low", f10_arg1)
	f10_arg0:setAlpha(0.2)
end

CoD.CraftablesIcon.PulseOff = function(f11_arg0, f11_arg1)
	f11_arg0:beginAnimation("pulse_off", f11_arg1)
	f11_arg0:setAlpha(0)
end
