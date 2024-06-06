require("T6.Zombie.CraftableItemTombDisplay")
require("T6.Zombie.QuestItemTombDisplay")
require("T6.Zombie.PersistentItemTombDisplay")
require("T6.Zombie.CaptureZoneWheelTombDisplay")
CoD.CraftablesTomb = {}
CoD.CraftablesTomb.ContainerHeight = CoD.QuestItemTombDisplay.IconSize + CoD.textSize[CoD.QuestItemTombDisplay.FontName] + 10
CoD.CraftablesTomb.ONSCREEN_DURATION = 3000
CoD.CraftablesTomb.WHEEL_ONSCREEN_DURATION = 5000
CoD.CraftablesTomb.FADE_IN_DURATION = 500
CoD.CraftablesTomb.FADE_OUT_DURATION = 500
CoD.CraftablesTomb.NEED_ALL_ZONES = 0
CoD.CraftablesTomb.ALL_ZONES_CAPTURED = 1
CoD.CraftablesTomb.ZONE_CAPTURED = 1
CoD.CraftablesTomb.ZONE_LOST = 2
CoD.CraftablesTomb.TotalZoneCount = 6
CoD.CraftablesTomb.ZoneWheelBlueColor = CoD.greenBlue
CoD.CraftablesTomb.ZoneWheelRedColor = CoD.red
CoD.CraftablesTomb.TabletTopStart = -CoD.Perks.TopStart + 99
CoD.CraftablesTomb.OneInchIconWidth = 50
CoD.CraftablesTomb.OneInchIconHeight = CoD.CraftablesTomb.OneInchIconWidth
CoD.CraftablesTomb.NEED_TABLET = 0
CoD.CraftablesTomb.HAVE_TABLET_CLEAN = 1
CoD.CraftablesTomb.NEED_TABLET_DIRTY = 2
LUI.createMenu.CraftablesTombArea = function(f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("CraftablesTombArea", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	f1_local0.topLeftScaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.topLeftScaleContainer:setLeftRight(true, false, 8, 8)
	f1_local0.topLeftScaleContainer:setTopBottom(true, false, 30, 30)
	f1_local0:addElement(f1_local0.topLeftScaleContainer)
	local f1_local1 = CoD.QuestItemTombDisplay.IconSize
	local f1_local2 = CoD.QuestItemTombDisplay.ContainerSize / 4
	local f1_local3 = false
	local f1_local4 = LUI.UIHorizontalList.new()
	f1_local4:setLeftRight(true, true, 0, 0)
	f1_local4:setTopBottom(true, false, 0, CoD.CraftablesTomb.ContainerHeight)
	local f1_local5 = CoD.PersistentItemTombDisplay.new(f1_local4)
	f1_local5.shouldFadeOutQuestStatus = true
	f1_local5.highlightRecentItem = true
	f1_local0.topLeftScaleContainer:addElement(f1_local5)
	CoD.PersistentItemTombDisplay.AddPersistentStatusDisplay(f1_local5, f1_local2, f1_local3)
	local f1_local6 = 90
	local f1_local7 = LUI.UIHorizontalList.new()
	f1_local7:setLeftRight(true, true, 0, 0)
	f1_local7:setTopBottom(true, false, f1_local6, f1_local6 + CoD.CraftablesTomb.ContainerHeight)
	local f1_local8 = CoD.QuestItemTombDisplay.new(f1_local7)
	f1_local0.topLeftScaleContainer:addElement(f1_local8)
	if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
		CoD.QuestItemTombDisplay.AddQuestStatusDisplay(f1_local8, f1_local2, f1_local3)
		f1_local8.shouldFadeOutQuestStatus = true
		f1_local8.highlightRecentItem = true
	end
	local f1_local9 = f1_local6 + 90
	local f1_local10 = LUI.UIVerticalList.new()
	f1_local10:setLeftRight(true, true, 0, 0)
	f1_local10:setTopBottom(true, false, f1_local9, f1_local9 + CoD.CraftablesTomb.ContainerHeight)
	local f1_local11 = CoD.CraftableItemTombDisplay.new(f1_local10)
	f1_local0.topLeftScaleContainer:addElement(f1_local11)
	if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
		CoD.CraftableItemTombDisplay.AddDisplayContainer(f1_local11, CoD.CraftableItemTombDisplay.ContainerSize / 4, f1_local3)
		f1_local11.shouldFadeOutQuestStatus = true
		f1_local11.highlightRecentItem = true
	end
	f1_local0.topRightScaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.topRightScaleContainer:setLeftRight(false, true, 0, 0)
	f1_local0.topRightScaleContainer:setTopBottom(true, false, 0, 0)
	f1_local0:addElement(f1_local0.topRightScaleContainer)
	local f1_local12 = 0
	local f1_local13 = 60
	local f1_local14 = 120
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(false, true, -f1_local14 - f1_local12, -f1_local12)
	Widget:setTopBottom(true, false, f1_local13, f1_local14 + f1_local13)
	Widget:setAlpha(0)
	f1_local0.topRightScaleContainer:addElement(Widget)
	f1_local0.captureZoneWheelContainer = Widget
	local f1_local16 = CoD.CaptureZoneWheelTombDisplay.new(f1_local0.captureZoneWheelContainer)
	if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
		CoD.CaptureZoneWheelTombDisplay.AddCaptureZoneWheel(f1_local16, f1_local14, f1_local3)
		f1_local16.shouldFadeOutQuestStatus = true
	end
	CoD.CraftablesTomb.OneInchPunchCleanMaterial = RegisterMaterial("zm_hud_icon_oneinch_clean")
	CoD.CraftablesTomb.OneInchPunchDirtyMaterial = RegisterMaterial("zm_hud_icon_oneinch_dirty")
	f1_local0.bottomLeftScaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.bottomLeftScaleContainer:setLeftRight(true, false, 0, 0)
	f1_local0.bottomLeftScaleContainer:setTopBottom(false, true, 0, 0)
	f1_local0:addElement(f1_local0.bottomLeftScaleContainer)
	local f1_local17 = CoD.CraftablesTomb.TabletTopStart
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(true, false, 0, CoD.CraftablesTomb.OneInchIconWidth)
	Widget:setTopBottom(false, true, -CoD.CraftablesTomb.OneInchIconHeight - f1_local17, -f1_local17)
	Widget:setAlpha(0)
	f1_local0.bottomLeftScaleContainer:addElement(Widget)
	f1_local0.tabletContainer = Widget

	local tabletIcon = LUI.UIImage.new()
	tabletIcon:setLeftRight(true, true, 0, 0)
	tabletIcon:setTopBottom(true, true, 0, 0)
	tabletIcon:setImage(CoD.CraftablesTomb.OneInchPunchDirtyMaterial)
	Widget:addElement(tabletIcon)
	f1_local0.tabletIcon = tabletIcon

	f1_local0:registerEventHandler("player_tablet_state", CoD.CraftablesTomb.UpdateTabletState)
	f1_local0:registerEventHandler("hud_update_refresh", CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.CraftablesTomb.UpdateVisibility)
	f1_local0.visible = true
	return f1_local0
end

CoD.CraftablesTomb.UpdateVisibility = function(f2_arg0, f2_arg1)
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

CoD.CraftablesTomb.UpdateTabletState = function(f3_arg0, f3_arg1)
	local f3_local0 = f3_arg1.newValue
	if f3_local0 == CoD.CraftablesTomb.NEED_TABLET then
		f3_arg0.tabletContainer:setAlpha(0)
	elseif f3_local0 == CoD.CraftablesTomb.HAVE_TABLET_CLEAN then
		f3_arg0.tabletIcon:setImage(CoD.CraftablesTomb.OneInchPunchCleanMaterial)
		f3_arg0.tabletContainer:setAlpha(1)
	elseif f3_local0 == CoD.CraftablesTomb.NEED_TABLET_DIRTY then
		f3_arg0.tabletIcon:setImage(CoD.CraftablesTomb.OneInchPunchDirtyMaterial)
		f3_arg0.tabletContainer:setAlpha(1)
	end
end
