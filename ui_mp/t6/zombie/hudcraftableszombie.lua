require("T6.Zombie.CraftableItemDisplay")
require("T6.Zombie.QuestItemDisplay")
CoD.Craftables = {}
LUI.createMenu.CraftablesArea = function(f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("CraftablesArea", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	f1_local0.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.scaleContainer:setLeftRight(true, false, 8, 8)
	f1_local0.scaleContainer:setTopBottom(true, false, 30, 30)
	f1_local0:addElement(f1_local0.scaleContainer)
	local f1_local1 = LUI.UIVerticalList.new()
	f1_local1:setLeftRight(true, true, 0, 0)
	f1_local1:setTopBottom(true, true, 0, 0)
	local f1_local2 = CoD.QuestItemDisplay.new(f1_local1)
	f1_local0.scaleContainer:addElement(f1_local2)
	local f1_local3 = CoD.QuestItemDisplay.ContainerSize / 4
	if CoD.Zombie.SoloQuestMode == false then
		CoD.QuestItemDisplay.AddPersistentIcon(f1_local2)
		f1_local2:addSpacer(90 - CoD.QuestItemDisplay.ContainerSize)
	end
	local f1_local4 = false
	local f1_local5 = true
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) then
		f1_local5 = false
	end
	if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
		CoD.QuestItemDisplay.AddQuestStatusDisplay(f1_local2, f1_local3, f1_local5, f1_local4)
		f1_local2.shouldFadeOutQuestStatus = true
		f1_local2.highlightRecentItem = true
	end
	local f1_local6 = LUI.UIVerticalList.new()
	f1_local6:setLeftRight(true, true, 0, 0)
	f1_local6:setTopBottom(true, true, 180, 0)
	local f1_local7 = CoD.CraftableItemDisplay.new(f1_local6)
	f1_local0.scaleContainer:addElement(f1_local7)
	if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
		CoD.CraftableItemDisplay.AddDisplayContainer(f1_local7, CoD.CraftableItemDisplay.ContainerSize / 4)
		f1_local7.shouldFadeOutQuestStatus = true
		f1_local7.highlightRecentItem = true
	end
	f1_local0:registerEventHandler("hud_update_refresh", CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Craftables.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Craftables.UpdateVisibility)
	f1_local0.visible = true
	return f1_local0
end

CoD.Craftables.UpdateVisibility = function(f2_arg0, f2_arg1)
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
