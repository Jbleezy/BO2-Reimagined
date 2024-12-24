require("T6.HUD.ObjectiveWaypoint")
CoD.GametypeBase = InheritFrom(CoD.Menu)
CoD.GametypeBase.CarryIconSize = 64
CoD.GametypeBase.CarryIconRightOffset = -106
CoD.GametypeBase.CarryIconBottomOffset = -120
CoD.GametypeBase.maxObjectives = 32
CoD.GametypeBase.mapIconType = 0
CoD.GametypeBase.GametypeInfoLeftOffset = 13
CoD.GametypeBase.GametypeInfoTopOffset = 185
CoD.GametypeBase.shoutcasterMapIconType = 1
CoD.CarepackageObjective = {}
CoD.ObjectiveRemoteMortar = InheritFrom(CoD.ObjectiveWaypoint)
CoD.ObjectiveBomb = InheritFrom(CoD.ObjectiveWaypoint)
CoD.ObjectiveBomb.GroundZOffset = 32
CoD.ObjectiveBombSite = InheritFrom(CoD.ObjectiveWaypoint)
CoD.ObjectiveBombSite.BombSiteZOffset = 64
CoD.ObjectiveBombSite.OBJECTIVE_FLAG_PLANTED = 1
CoD.ObjectiveBombSite.disablePulse = true
CoD.ObjectiveDefuseSite = InheritFrom(CoD.ObjectiveWaypoint)
CoD.ObjectiveDefuseSite.DefuseSiteZOffset = 32
CoD.ObjectiveDefuseSite.disablePulse = true
local f0_local0 = nil
CoD.GametypeBase.new = function(f1_arg0, f1_arg1)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState(f1_arg0, f1_arg1)
	f1_local0:setClass(CoD.GametypeBase)
	f1_local0:setAlpha(0)
	f1_local0.objectiveTypes = {
		bomb = CoD.ObjectiveBomb,
		carepackage = CoD.CarepackageObjective,
		remotemortar = CoD.ObjectiveRemoteMortar,
	}
	f1_local0.objectives = {}
	return f1_local0
end

CoD.GametypeBase.NewObjectiveEvent = function(f2_arg0, f2_arg1)
	local f2_local0 = f2_arg0:createObjectiveIfNeeded(f2_arg1, f2_arg1.objId)
	if f2_local0 then
		f2_local0:update(f2_arg1)
	end
end

CoD.GametypeBase.createObjectiveIfNeeded = function(f3_arg0, f3_arg1, f3_arg2)
	local f3_local0 = Engine.GetObjectiveName(f3_arg1.controller, f3_arg2)
	local f3_local1 = f3_arg0.objectives[f3_arg2]
	if f3_local0 and f3_arg0.objectiveTypes[f3_local0] then
		if not f3_local1 then
			f3_local1 = f3_arg0.objectiveTypes[f3_local0].new(f3_arg1.controller, f3_arg2)
			f3_arg0:addElement(f3_local1)
			f3_arg0.objectives[f3_arg2] = f3_local1
		end
		return f3_local1
	else
	end
end

CoD.GametypeBase.Refresh = function(f4_arg0, f4_arg1)
	for f4_local0 = 0, CoD.GametypeBase.maxObjectives - 1, 1 do
		f4_arg0:createObjectiveIfNeeded(f4_arg1, f4_local0)
		local f4_local3 = Engine.GetObjectiveName(f4_arg1.controller, f4_local0)
		local f4_local4 = f4_arg0.objectives[f4_local0]
		if f4_local4 then
			if f4_local3 and f4_local3 ~= "" then
				f4_local4:update(f4_arg1)
			else
				f4_local4:close()
				f4_arg0.objectives[f4_local0] = nil
			end
		end
	end
	f4_arg0:updateVisibility(f4_arg1)
end

CoD.GametypeBase.SetCompassObjectiveIcon = function(f5_arg0, f5_arg1, f5_arg2, f5_arg3)
	if f5_arg2 then
		Engine.SetObjectiveIcon(f5_arg0, f5_arg1, CoD.GametypeBase.mapIconType, f5_arg2)
	else
		Engine.ClearObjectiveIcon(f5_arg0, f5_arg1, CoD.GametypeBase.mapIconType)
	end
	Engine.SetObjectiveIcon(f5_arg0, f5_arg1, CoD.GametypeBase.shoutcasterMapIconType, f5_arg3)
end

CoD.GametypeBase.ClearCompassObjectiveIcon = function(f6_arg0, f6_arg1)
	Engine.ClearObjectiveIcon(f6_arg0, f6_arg1, CoD.GametypeBase.mapIconType)
	Engine.ClearObjectiveIcon(f6_arg0, f6_arg1, CoD.GametypeBase.shoutcasterMapIconType)
end

CoD.GametypeBase.setCarryIcon = function(f7_arg0, f7_arg1)
	if f7_arg1 then
		if not f7_arg0.carryIcon then
			f7_arg0.carryIconScaleContainer = CoD.SplitscreenScaler.new(nil, CoD.SplitscreenMultiplier)
			f7_arg0.carryIconScaleContainer:setLeftRight(false, true, 0, 0)
			f7_arg0.carryIconScaleContainer:setTopBottom(false, true, 0, 0)
			f7_arg0:addElement(f7_arg0.carryIconScaleContainer)
			f7_arg0.carryIcon = LUI.UIImage.new()
			f7_arg0.carryIcon:setLeftRight(false, true, CoD.GametypeBase.CarryIconRightOffset - CoD.GametypeBase.CarryIconSize, CoD.GametypeBase.CarryIconRightOffset)
			f7_arg0.carryIcon:setTopBottom(false, true, CoD.GametypeBase.CarryIconBottomOffset - CoD.GametypeBase.CarryIconSize, CoD.GametypeBase.CarryIconBottomOffset)
			f7_arg0.carryIconScaleContainer:addElement(f7_arg0.carryIcon)
		end
		f7_arg0.carryIcon:setImage(f7_arg1)
	elseif f7_arg0.carryIcon then
		f7_arg0.carryIcon:close()
		f7_arg0.carryIcon = nil
		f7_arg0.carryIconScaleContainer:close()
		f7_arg0.carryIconScaleContainer = nil
	end
end

CoD.GametypeBase.SetCarryIconEvent = function(f8_arg0, f8_arg1)
	f8_arg0:setCarryIcon(f8_arg1.material)
end

CoD.GametypeBase.updateVisibility = function(f9_arg0, f9_arg1)
	local f9_local0 = f9_arg1.controller
	if UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_GAME_ENDED) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 then
		if f9_arg0.visible ~= true then
			f9_arg0:setAlpha(1)
			f9_arg0.visible = true
		end
	elseif f9_arg0.visible == true then
		f9_arg0:setAlpha(0)
		f9_arg0.visible = nil
	end
	f9_arg0:dispatchEventToChildren(f9_arg1)
end

CoD.GametypeBase:registerEventHandler("new_objective", CoD.GametypeBase.NewObjectiveEvent)
CoD.GametypeBase:registerEventHandler("set_carry_icon", CoD.GametypeBase.SetCarryIconEvent)
CoD.GametypeBase:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_GAME_ENDED, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_KILLCAM, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.GametypeBase.updateVisibility)
CoD.GametypeBase:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.GametypeBase.updateVisibility)
CoD.ObjectiveBomb.new = function(f10_arg0, f10_arg1)
	local f10_local0 = CoD.ObjectiveWaypoint.new(f10_arg0, f10_arg1, CoD.ObjectiveBomb.GroundZOffset)
	f10_local0:setClass(CoD.ObjectiveBomb)
	f10_local0:registerEventHandler("objective_update_" .. Engine.GetObjectiveName(f10_arg0, f10_arg1), f10_local0.update)
	return f10_local0
end

CoD.ObjectiveBomb.update = function(f11_arg0, f11_arg1)
	local f11_local0 = f11_arg1.controller
	local f11_local1 = f11_arg0.index
	local f11_local2 = Engine.GetObjectiveEntity(f11_local0, f11_local1)
	if f11_local2 then
		f11_arg0.zOffset = f11_arg0.PlayerZOffset
	else
		f11_arg0.zOffset = f11_arg0.GroundZOffset
	end
	CoD.ObjectiveBomb.super.update(f11_arg0, f11_arg1)
	local f11_local3 = f11_arg0:shouldShow(f11_arg1)
	local f11_local4 = CoD.ObjectiveBomb.shouldShowToCaster(f11_arg0, f11_arg1)
	local f11_local5 = nil
	if f11_local3 then
		if f11_local2 then
			f11_local5 = "waypoint_defend"
			f11_arg0.arrowImage:setImage(RegisterMaterial(CoD.ObjectiveWaypoint.ArrowMaterialNameGreen))
		else
			f11_local5 = "waypoint_bomb"
			f11_arg0.arrowImage:setImage(RegisterMaterial(CoD.ObjectiveWaypoint.ArrowMaterialNameYellow))
		end
		f11_arg0.mainImage:setImage(RegisterMaterial(f11_local5))
	end
	if f11_local3 == true or f11_local4 == true then
		CoD.GametypeBase.SetCompassObjectiveIcon(f11_local0, f11_local1, f11_local5, "white_waypoint_bomb")
	else
		CoD.GametypeBase.ClearCompassObjectiveIcon(f11_local0, f11_local1)
	end
	if f11_local2 == Engine.GetPredictedClientNum(f11_local0) then
		f11_arg0:setCarryIcon(RegisterMaterial("hud_suitcase_bomb"))
	else
		f11_arg0:setCarryIcon(nil)
	end
end

CoD.ObjectiveBomb.shouldShow = function(f12_arg0, f12_arg1)
	if not CoD.ObjectiveBomb.super.shouldShow(f12_arg0, f12_arg1) then
		return false
	elseif not f12_arg0:isOwnedByMyTeam(f12_arg1.controller) then
		return false
	else
		return true
	end
end

CoD.ObjectiveBomb.shouldShowToCaster = function(f13_arg0, f13_arg1)
	if Engine.GetObjectiveState(f13_arg1.controller, f13_arg0.index) ~= CoD.OBJECTIVESTATE_ACTIVE then
		return false
	elseif Engine.IsShoutcaster(f13_arg1.controller) then
		return true
	else
		return false
	end
end

CoD.ObjectiveBombSite.new = function(f14_arg0, f14_arg1)
	local f14_local0 = CoD.ObjectiveWaypoint.new(f14_arg0, f14_arg1, CoD.ObjectiveBombSite.BombSiteZOffset)
	f14_local0:setClass(CoD.ObjectiveBombSite)
	f14_local0:registerEventHandler("objective_update_" .. Engine.GetObjectiveName(f14_arg0, f14_arg1), f14_local0.update)
	return f14_local0
end

CoD.ObjectiveBombSite.update = function(f15_arg0, f15_arg1)
	CoD.ObjectiveBombSite.super.update(f15_arg0, f15_arg1)
	local f15_local0 = f15_arg1.controller
	local f15_local1 = f15_arg0.index
	local f15_local2 = Engine.GetObjectiveName(f15_local0, f15_local1)
	if not f15_local2 then
		return
	end
	local f15_local3 = string.sub(f15_local2, -2)
	local f15_local4 = Engine.GetObjectiveGamemodeFlags(f15_local0, f15_arg0.index) == CoD.ObjectiveBombSite.OBJECTIVE_FLAG_PLANTED
	local f15_local5 = Engine.GetGametypeSetting("multiBomb") == 1
	local f15_local6 = nil
	if f15_arg0:isOwnedByMyTeam(f15_local0) then
		if f15_local4 then
			f15_local6 = "waypoint_defuse"
			f15_arg0.arrowImage:setImage(RegisterMaterial(CoD.ObjectiveWaypoint.ArrowMaterialNameRed))
		else
			f15_local6 = "waypoint_defend"
			f15_arg0.arrowImage:setImage(RegisterMaterial(CoD.ObjectiveWaypoint.ArrowMaterialNameGreen))
		end
		if f15_local5 then
			f15_arg0:setCarryIcon(nil)
		end
	else
		if f15_local4 then
			f15_local6 = "waypoint_defend"
			f15_arg0.arrowImage:setImage(RegisterMaterial(CoD.ObjectiveWaypoint.ArrowMaterialNameGreen))
		else
			f15_local6 = "waypoint_target"
			f15_arg0.arrowImage:setImage(RegisterMaterial(CoD.ObjectiveWaypoint.ArrowMaterialNameRed))
		end
		if f15_local5 then
			f15_arg0:setCarryIcon(RegisterMaterial("hud_suitcase_bomb"))
		end
	end
	local f15_local7 = f15_local6 .. f15_local3
	f15_arg0.mainImage:setImage(RegisterMaterial(f15_local7))
	CoD.GametypeBase.SetCompassObjectiveIcon(f15_local0, f15_local1, f15_local7, "white_" .. f15_local7)
end

CoD.ObjectiveDefuseSite.new = function(f16_arg0, f16_arg1)
	local f16_local0 = CoD.ObjectiveWaypoint.new(f16_arg0, f16_arg1, CoD.ObjectiveDefuseSite.DefuseSiteZOffset)
	f16_local0:setClass(CoD.ObjectiveDefuseSite)
	f16_local0:registerEventHandler("objective_update_" .. Engine.GetObjectiveName(f16_arg0, f16_arg1), f16_local0.update)
	return f16_local0
end

CoD.ObjectiveDefuseSite.update = CoD.ObjectiveBombSite.update
CoD.CarepackageObjective.new = function(f17_arg0, f17_arg1) end

CoD.ObjectiveRemoteMortar.new = function(f18_arg0, f18_arg1)
	local f18_local0 = CoD.ObjectiveWaypoint.new(f18_arg0, f18_arg1, 0)
	f18_local0:setClass(CoD.ObjectiveRemoteMortar)
	f18_local0.arrowImage:close()
	return f18_local0
end

CoD.ObjectiveRemoteMortar.update = function(f19_arg0, f19_arg1)
	local f19_local0 = f19_arg1.controller
	local f19_local1 = f19_arg0.index
	Engine.SetObjectiveRotateWithEntity(f19_local0, f19_local1, CoD.GametypeBase.mapIconType, true)
	Engine.SetObjectiveColorMaterialInCode(f19_local0, f19_local1, CoD.GametypeBase.mapIconType, true)
	CoD.GametypeBase.SetCompassObjectiveIcon(f19_local0, f19_local1, "compass_lodestar", "compass_lodestar")
end
