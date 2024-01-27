require("T6.Zombie.AfterlifeWaypoint")
CoD.HudAfterlifeDisplay = {}
CoD.HudAfterlifeDisplay.OutOfAfterLifeIconAlpha = 1
CoD.HudAfterlifeDisplay.IconRatio = 2
CoD.HudAfterlifeDisplay.IconWidth = 100
CoD.HudAfterlifeDisplay.IconHeight = CoD.HudAfterlifeDisplay.IconWidth / CoD.HudAfterlifeDisplay.IconRatio
CoD.HudAfterlifeDisplay.InventoryWidth = 64
CoD.HudAfterlifeDisplay.InventoryHeight = CoD.HudAfterlifeDisplay.InventoryWidth / CoD.HudAfterlifeDisplay.IconRatio
CoD.HudAfterlifeDisplay.PULSE_DURATION = 3000
LUI.createMenu.AfterlifeArea = function(f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("AfterlifeArea", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	CoD.HudAfterlifeDisplay.AfterlifeMeterMaterial = RegisterMaterial("hud_zombie_afterlife_meter")
	f1_local0.bottomScaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.bottomScaleContainer:setLeftRight(false, false, 0, 0)
	f1_local0.bottomScaleContainer:setTopBottom(false, true, 0, 0)
	f1_local0:addElement(f1_local0.bottomScaleContainer)
	local f1_local1 = 15
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(false, false, -CoD.HudAfterlifeDisplay.IconWidth / 2, CoD.HudAfterlifeDisplay.IconWidth / 2)
	Widget:setTopBottom(false, true, -CoD.HudAfterlifeDisplay.IconHeight - f1_local1, -f1_local1)
	Widget:setAlpha(0)
	f1_local0.bottomScaleContainer:addElement(Widget)
	f1_local0.afterlifeIconContainer = Widget

	local afterlifeIcon = LUI.UIImage.new()
	afterlifeIcon:setLeftRight(true, true, 0, 0)
	afterlifeIcon:setTopBottom(true, true, 0, 0)
	afterlifeIcon:setImage(CoD.HudAfterlifeDisplay.AfterlifeMeterMaterial)
	afterlifeIcon:setAlpha(CoD.HudAfterlifeDisplay.OutOfAfterLifeIconAlpha)
	afterlifeIcon:setShaderVector(0, -1, 0, 0, 0)
	Widget:addElement(afterlifeIcon)
	f1_local0.afterlifeIcon = afterlifeIcon

	f1_local0.bottomRightScaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.bottomRightScaleContainer:setLeftRight(false, true, 25, 25)
	f1_local0.bottomRightScaleContainer:setTopBottom(false, true, -17, -17)
	f1_local0:addElement(f1_local0.bottomRightScaleContainer)

	local f1_local5 = -32
	local f1_local6 = 135
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(false, true, -CoD.HudAfterlifeDisplay.InventoryWidth + f1_local5, f1_local5)
	Widget:setTopBottom(false, true, -CoD.HudAfterlifeDisplay.InventoryHeight - f1_local6, -f1_local6)
	Widget:setAlpha(0)
	f1_local0.bottomRightScaleContainer:addElement(Widget)
	f1_local0.afterLifeInventoryContainer = Widget
	local f1_local8 = LUI.UIImage.new()
	f1_local8:setLeftRight(true, true, 0, 0)
	f1_local8:setTopBottom(true, true, 0, 0)
	f1_local8:setImage(CoD.HudAfterlifeDisplay.AfterlifeMeterMaterial)
	f1_local8:setAlpha(0.5)
	f1_local8:setShaderVector(0, 1, 0, 0, 0)
	Widget:addElement(f1_local8)
	local f1_local9 = "Default"
	local f1_local10 = CoD.fonts[f1_local9]
	local f1_local11 = CoD.textSize[f1_local9]
	local f1_local12 = 5
	local f1_local13 = 5

	local afterlifeInventoryCount = LUI.UIText.new()
	afterlifeInventoryCount:setLeftRight(true, true, 0, -f1_local12)
	afterlifeInventoryCount:setTopBottom(false, true, -f1_local11 + f1_local13, f1_local13)
	afterlifeInventoryCount:setFont(f1_local10)
	afterlifeInventoryCount:setAlignment(LUI.Alignment.Right)
	Widget:addElement(afterlifeInventoryCount)
	f1_local0.afterlifeInventoryCount = afterlifeInventoryCount

	CoD.AfterlifeWaypoint.RegisterMaterials()
	f1_local0.afterlifeWaypointIcons = {}
	f1_local0.inAfterlife = true
	f1_local0.clientNum = -1
	f1_local0:registerEventHandler("player_lives", CoD.HudAfterlifeDisplay.UpdatePlayerLives)
	f1_local0:registerEventHandler("player_in_afterlife", CoD.HudAfterlifeDisplay.UpdatePlayerInAfterlife)
	f1_local0:registerEventHandler("player_afterlife_mana", CoD.HudAfterlifeDisplay.UpdateAfterlifeMana)
	f1_local0:registerEventHandler("player_corpse_id", CoD.HudAfterlifeDisplay.UpdateAfterlifeWaypoint)
	f1_local0:registerEventHandler("demo_jump", CoD.HudAfterlifeDisplay.UpdateAfterlifeIconsDemoJump)
	f1_local0:registerEventHandler("hud_update_refresh", CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.HudAfterlifeDisplay.UpdateVisibility)
	f1_local0.visible = true
	return f1_local0
end

CoD.HudAfterlifeDisplay.UpdateVisibility = function(f2_arg0, f2_arg1)
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

CoD.HudAfterlifeDisplay.UpdatePlayerLives = function(f3_arg0, f3_arg1)
	f3_arg0.afterlifeInventoryCount:setText(f3_arg1.newValue)
	if f3_arg1.oldValue < f3_arg1.newValue then
		if f3_arg0.afterLifeInventoryContainer.alternatorTimer then
			f3_arg0.afterLifeInventoryContainer:closeStateAlternator()
		end
		f3_arg0.afterLifeInventoryContainer:alternateStates(CoD.HudAfterlifeDisplay.PULSE_DURATION, CoD.HudAfterlifeDisplay.PulseOff, CoD.HudAfterlifeDisplay.PulseOn, 500, 500, CoD.HudAfterlifeDisplay.PulseOn)
	end
end

CoD.HudAfterlifeDisplay.UpdatePlayerInAfterlife = function(f4_arg0, f4_arg1)
	local f4_local0 = f4_arg0.entNum ~= f4_arg1.entNum
	f4_arg0.entNum = f4_arg1.entNum
	if f4_arg1.newValue == 1 then
		f4_arg0.inAfterlife = true
		f4_arg0.afterlifeIconContainer:setAlpha(1)
		if f4_arg1.wasDemoJump == false and f4_local0 == false then
			f4_arg0.afterlifeIcon:setShaderVector(0, 1, 0, 0, 0)
		end
		f4_arg0.afterLifeInventoryContainer:setAlpha(0)
		f4_arg0.clientNum = f4_arg1.entNum
	else
		f4_arg0.inAfterlife = false
		f4_arg0.afterlifeIconContainer:setAlpha(0)
		f4_arg0.afterlifeIcon:setShaderVector(0, 1, 0, 0, 0)
		f4_arg0.afterLifeInventoryContainer:setAlpha(1)
		f4_arg0.clientNum = f4_arg1.entNum
	end
end

CoD.HudAfterlifeDisplay.UpdateAfterlifeMana = function(f5_arg0, f5_arg1)
	local f5_local0 = f5_arg0.entNum ~= f5_arg1.entNum
	f5_arg0.afterlifeIcon:completeAnimation()
	if f5_arg1.newValue ~= 0 and f5_arg1.wasDemoJump == false and f5_local0 == false then
		f5_arg0.afterlifeIcon:beginAnimation("update_meter", 1500)
	end
	f5_arg0.afterlifeIcon:setShaderVector(0, f5_arg1.newValue, 0, 0, 0)
end

CoD.HudAfterlifeDisplay.UpdateAfterlifeWaypoint = function(f6_arg0, f6_arg1)
	local f6_local0 = f6_arg1.newValue
	local f6_local1 = f6_local0 - 1
	local f6_local2 = f6_arg1.entNum
	if f6_local0 == CoD.AfterlifeWaypoint.ICON_STATE_CLEAR then
		local f6_local3 = 0
		for f6_local4 = 1, #f6_arg0.afterlifeWaypointIcons, 1 do
			if f6_arg0.afterlifeWaypointIcons[f6_local4].entNum == f6_local2 then
				f6_local3 = f6_local4
			end
			if f6_arg0.inAfterlife == false then
				f6_arg0.afterlifeWaypointIcons[f6_local4].alphaController:setAlpha(1)
			end
		end
		if f6_local3 > 0 then
			f6_arg0.afterlifeWaypointIcons[f6_local3]:close()
			table.remove(f6_arg0.afterlifeWaypointIcons, f6_local3)
		end
	else
		if CoD.HudAfterlifeDisplay.AfterlifeWaypointExists(f6_arg0, f6_local2) then
			return
		end
		local f6_local3 = CoD.AfterlifeWaypoint.new(f6_local2)
		f6_arg0:addElement(f6_local3)
		f6_local3.entNum = f6_local2
		table.insert(f6_arg0.afterlifeWaypointIcons, f6_local3)
		if f6_local1 == f6_arg0.clientNum then
			for f6_local4 = 1, #f6_arg0.afterlifeWaypointIcons, 1 do
				f6_arg0.afterlifeWaypointIcons[f6_local4].alphaController:setAlpha(0)
			end
			f6_local3.alphaController:setAlpha(1)
		elseif f6_arg0.inAfterlife == true then
			f6_local3.alphaController:setAlpha(0)
		end
	end
end

CoD.HudAfterlifeDisplay.UpdateAfterlifeIconsDemoJump = function(f7_arg0, f7_arg1)
	local f7_local0 = {}
	for f7_local1 = 1, #f7_arg0.afterlifeWaypointIcons, 1 do
		if Engine.IsEntityNumberInUse(f7_arg1.controller, f7_arg0.afterlifeWaypointIcons[f7_local1].entNum, CoD.EntityType.ET_SCRIPTMOVER) == false then
			table.insert(f7_local0, f7_local1)
		end
	end
	for f7_local1 = 1, #f7_local0, 1 do
		if f7_arg0.afterlifeWaypointIcons[f7_local0[f7_local1]] then
			f7_arg0.afterlifeWaypointIcons[f7_local0[f7_local1]]:close()
			table.remove(f7_arg0.afterlifeWaypointIcons, f7_local0[f7_local1])
		end
	end
end

CoD.HudAfterlifeDisplay.AfterlifeWaypointExists = function(f8_arg0, f8_arg1)
	local f8_local0 = false
	for f8_local1 = 1, #f8_arg0.afterlifeWaypointIcons, 1 do
		if f8_arg0.afterlifeWaypointIcons[f8_local1].entNum == f8_arg1 then
			f8_local0 = true
			break
		end
	end
	return f8_local0
end

CoD.HudAfterlifeDisplay.PulseOff = function(f9_arg0, f9_arg1)
	f9_arg0:beginAnimation("pulse_off", f9_arg1)
	f9_arg0:setAlpha(0.1)
end

CoD.HudAfterlifeDisplay.PulseOn = function(f10_arg0, f10_arg1)
	f10_arg0:beginAnimation("pulse_on", f10_arg1)
	f10_arg0:setAlpha(1)
end
