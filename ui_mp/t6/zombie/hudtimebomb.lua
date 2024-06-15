CoD.HudTimeBomb = {}
CoD.HudTimeBomb.IconWidth = 50
CoD.HudTimeBomb.IconHeight = CoD.HudTimeBomb.IconWidth
LUI.createMenu.TimeBombArea = function(f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("TimeBombArea", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	f1_local0.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.scaleContainer:setLeftRight(true, false, 0, 0)
	f1_local0.scaleContainer:setTopBottom(false, true, 0, 0)
	f1_local0:addElement(f1_local0.scaleContainer)
	local f1_local1 = CoD.RoundStatus.ChalkSize + 94
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(true, false, 0, CoD.HudTimeBomb.IconWidth)
	Widget:setTopBottom(false, true, -CoD.HudTimeBomb.IconHeight - f1_local1, -f1_local1)
	Widget:setAlpha(0)
	f1_local0.scaleContainer:addElement(Widget)
	f1_local0.timeBombContainer = Widget
	local f1_local3 = LUI.UIImage.new()
	f1_local3:setLeftRight(true, true, 0, 0)
	f1_local3:setTopBottom(true, true, 0, 0)
	f1_local3:setImage(RegisterMaterial("zombie_hud_time_bomb_64"))
	Widget:addElement(f1_local3)
	local f1_local4 = "Default"
	local f1_local5 = CoD.fonts[f1_local4]
	local f1_local6 = CoD.textSize[f1_local4]

	local roundText = LUI.UIText.new()
	roundText:setLeftRight(true, true, 0, 0)
	roundText:setTopBottom(false, false, -f1_local6 / 2, f1_local6 / 2)
	roundText:setFont(f1_local5)
	Widget:addElement(roundText)
	f1_local0.roundText = roundText

	f1_local0:registerEventHandler("time_bomb_saved_round_number", CoD.HudTimeBomb.DisplayTimeBomb)
	f1_local0:registerEventHandler("hud_update_refresh", CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.HudTimeBomb.UpdateVisibility)
	f1_local0.visible = true
	return f1_local0
end

CoD.HudTimeBomb.UpdateVisibility = function(f2_arg0, f2_arg1)
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

CoD.HudTimeBomb.DisplayTimeBomb = function(f3_arg0, f3_arg1)
	if f3_arg1.newValue == 0 then
		f3_arg0.timeBombContainer:setAlpha(0)
		-- f3_arg0.roundText:setText("")
	else
		f3_arg0.timeBombContainer:setAlpha(1)
		-- f3_arg0.roundText:setText(f3_arg1.newValue)
	end
end
