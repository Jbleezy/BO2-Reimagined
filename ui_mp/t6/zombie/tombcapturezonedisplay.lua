CoD.TCZWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.TCZWaypoint.GAMEMODEFLAG_TARGET = 1
CoD.TCZWaypoint.flagWaypointZOffset = 35
CoD.TCZWaypoint.snapToHeight = -250
CoD.TCZWaypoint.largeIconWidth = 128
CoD.TCZWaypoint.largeIconHeight = 128
CoD.TCZWaypoint.iconAlpha = 1
CoD.TCZWaypoint.pulseAlphaLow = CoD.TCZWaypoint.iconAlpha * 0.35
CoD.TCZWaypoint.pulseAlphaHigh = CoD.TCZWaypoint.iconAlpha
CoD.TCZWaypoint.progressColor = CoD.blueGlow
CoD.TCZWaypoint.CaptureZoneCount = 6
CoD.TCZWaypoint.NumberGlowMaterialsTable = {}
CoD.TCZWaypoint.numberIconIndentWidth = 42
CoD.TCZWaypoint.numberIconIndentHeight = 42
CoD.TCZWaypoint.numberIconSmallIndentWidth = 20
CoD.TCZWaypoint.numberIconSmallIndentHeight = 20
CoD.TCZWaypoint.worldProgressColor = CoD.brightRed
CoD.TCZWaypoint.contestedProgressColor = CoD.yellowGlow
CoD.TCZRoamingZombies = InheritFrom(CoD.ObjectiveWaypoint)
CoD.TCZRoamingZombies.baseWaypointZOffset = 75
CoD.TCZRoamingZombies.iconWidth = 32
CoD.TCZRoamingZombies.iconHeight = 32
LUI.createMenu.TombCaptureZoneDisplay = function(f1_arg0)
	local f1_local0 = CoD.GametypeBase.new("tomb_capture_display", f1_arg0)
	f1_local0.objectiveTypes.ZM_TOMB_OBJ_CAPTURE_1 = CoD.TCZWaypoint
	f1_local0.objectiveTypes.ZM_TOMB_OBJ_CAPTURE_2 = CoD.TCZWaypoint
	f1_local0.objectiveTypes.ZM_TOMB_OBJ_RECAPTURE_2 = CoD.TCZWaypoint
	f1_local0.objectiveTypes.ZM_TOMB_OBJ_RECAPTURE_ZOMBIE = CoD.TCZRoamingZombies
	CoD.TCZWaypoint.MainSpinImageMaterial = RegisterMaterial("hud_zm_tomb_capture_spin")
	CoD.TCZWaypoint.SpinGlowImageMaterial = RegisterMaterial("hud_zm_tomb_capture_spin_glow")
	CoD.TCZWaypoint.ArrowImageMaterial = RegisterMaterial("waypoint_arrow_tomb")
	CoD.TCZRoamingZombies.RoamingZombieMaterial = RegisterMaterial("zm_hud_icon_evil_crusade")
	for f1_local1 = 1, CoD.TCZWaypoint.CaptureZoneCount, 1 do
		CoD.TCZWaypoint.NumberGlowMaterialsTable[f1_local1] = {}
		CoD.TCZWaypoint.NumberGlowMaterialsTable[f1_local1].glowImage = RegisterMaterial("tomb_spinner_" .. f1_local1 .. "_glow")
		CoD.TCZWaypoint.NumberGlowMaterialsTable[f1_local1].shadowImage = RegisterMaterial("tomb_spinner_" .. f1_local1 .. "_shadow")
	end
	f1_local0:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.TCZWaypoint.UpdateVisibility)
	f1_local0.visible = true
	f1_local0.updateVisibility = CoD.TCZWaypoint.UpdateVisibility
	return f1_local0
end

CoD.TCZWaypoint.UpdateVisibility = function(f2_arg0, f2_arg1)
	local f2_local0 = f2_arg1.controller
	if UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_SPECTATING_CLIENT) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(f2_local0) or CoD.ExeProfileVarBool(f2_local0, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(f2_local0)) and CoD.FSM_VISIBILITY(f2_local0) == 0 then
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

CoD.TCZWaypoint.new = function(f3_arg0, f3_arg1)
	local f3_local0 = CoD.ObjectiveWaypoint.new(f3_arg0, f3_arg1, CoD.TCZWaypoint.flagWaypointZOffset)
	f3_local0:setClass(CoD.TCZWaypoint)
	local f3_local1 = Engine.GetObjectiveName(f3_arg0, f3_arg1)
	f3_local0:registerEventHandler("objective_update_" .. f3_local1, f3_local0.update)

	f3_local0.edgePointerContainer:setTopBottom(true, true, -20, 20)
	f3_local0.arrowImage:setTopBottom(false, true, -32, 0)

	f3_local0.mainImage:setImage(CoD.TCZWaypoint.MainSpinImageMaterial)
	f3_local0.arrowImage:setImage(CoD.TCZWaypoint.ArrowImageMaterial)
	f3_local0.progressBackground:close()
	f3_local0.progressController:close()
	f3_local0.progressController:setPriority(100)
	f3_local0:addElement(f3_local0.progressController)
	f3_local0.alphaController:setAlpha(1)
	f3_local0.disablePulse = true
	f3_local0.isOccupied = true
	local f3_local2 = CoD.TCZWaypoint.numberIconIndentWidth
	local f3_local3 = CoD.TCZWaypoint.numberIconIndentHeight
	f3_local0.numberContainer = LUI.UIElement.new()
	f3_local0.numberContainer:setLeftRight(true, true, f3_local2, -f3_local2)
	f3_local0.numberContainer:setTopBottom(true, true, f3_local3, -f3_local3)
	f3_local0.alphaController:addElement(f3_local0.numberContainer)
	f3_local0.numberContainer:alternateStates(0, CoD.TCZWaypoint.PulseLow, CoD.TCZWaypoint.PulseHigh, f3_local0.pulseTime, f3_local0.pulseTime)
	f3_local0.number = LUI.UIImage.new()
	f3_local0.number:setLeftRight(true, true, 0, 0)
	f3_local0.number:setTopBottom(true, true, 0, 0)
	f3_local0.number:setImage(CoD.TCZWaypoint.NumberGlowMaterialsTable[1].shadowImage)
	f3_local0.numberContainer:addElement(f3_local0.number)
	f3_local0.numberGlow = LUI.UIImage.new()
	f3_local0.numberGlow:setLeftRight(true, true, 0, 0)
	f3_local0.numberGlow:setTopBottom(true, true, 0, 0)
	f3_local0.numberGlow:setImage(CoD.TCZWaypoint.NumberGlowMaterialsTable[1].glowImage)
	f3_local0.numberContainer:addElement(f3_local0.numberGlow)
	if string.sub(f3_local1, 0, 19) == "ZM_TOMB_OBJ_CAPTURE" then
		f3_local0.glow = LUI.UIImage.new()
		f3_local0.glow:setLeftRight(true, true, 0, 0)
		f3_local0.glow:setTopBottom(true, true, 0, 0)
		f3_local0.glow:setImage(CoD.TCZWaypoint.SpinGlowImageMaterial)
		f3_local0.glow:setPriority(-100)
		f3_local0.glow:setAlpha(0)
		f3_local0.glow:setRGB(CoD.blueGlow.r, CoD.blueGlow.g, CoD.blueGlow.b)
		f3_local0.glow:registerEventHandler("transition_complete_pulse_low", function(Sender, Event)
			if Event.interrupted ~= true then
				f3_local0.glow:beginAnimation("pulse_high", f3_local0.pulseTime, false, false)
				f3_local0.glow:setAlpha(f3_local0.pulseAlphaHigh)
			end
		end)
		f3_local0.glow:registerEventHandler("transition_complete_pulse_high", function(Sender, Event)
			if Event.interrupted ~= true then
				f3_local0.glow:beginAnimation("pulse_low", f3_local0.pulseTime, false, false)
				f3_local0.glow:setAlpha(f3_local0.pulseAlphaLow)
			end
		end)
		f3_local0.alphaController:addElement(f3_local0.glow)
		f3_local0.glow:beginAnimation("pulse_high")
		f3_local0:registerEventHandler("zc_change_progress_bar_color", CoD.TCZWaypoint.SetCaptureProgressBarColor)
	elseif string.sub(f3_local1, 0, 21) == "ZM_TOMB_OBJ_RECAPTURE" and f3_local0.progressBar then
		f3_local0.progressBar:setRGB(f3_local0.worldProgressColor.r, f3_local0.worldProgressColor.g, f3_local0.worldProgressColor.b)
	end
	f3_local0.updateProgress = CoD.TCZWaypoint.updateProgress
	f3_local0.updatePlayerUsing = CoD.TCZWaypoint.updatePlayerUsing
	return f3_local0
end

CoD.TCZWaypoint.update = function(f4_arg0, f4_arg1)
	local f4_local0 = Engine.GetObjectiveGamemodeFlags(f4_arg1.controller, f4_arg0.index)

	if f4_local0 > 0 then
		f4_arg0.number:setImage(CoD.TCZWaypoint.NumberGlowMaterialsTable[f4_local0].shadowImage)
		f4_arg0.numberGlow:setImage(CoD.TCZWaypoint.NumberGlowMaterialsTable[f4_local0].glowImage)
	end

	local isZombieCaptureWaypoint = false

	if f4_arg1.objId then
		local f4_local1 = Engine.GetObjectiveName(f4_arg1.controller, f4_arg1.objId)

		if string.sub(f4_local1, 0, 19) == "ZM_TOMB_OBJ_CAPTURE" then
			f4_arg0.numberGlow:setAlpha(1)
		elseif string.sub(f4_local1, 0, 21) == "ZM_TOMB_OBJ_RECAPTURE" then
			f4_arg0.numberGlow:setAlpha(0)
		end

		isZombieCaptureWaypoint = f4_local1 == "ZM_TOMB_OBJ_CAPTURE_2"
	end

	CoD.TCZWaypoint.super.update(f4_arg0, f4_arg1)

	local teamID = Engine.GetTeamID(f4_arg1.controller, Engine.GetPredictedClientNum(f4_arg1.controller))
	local isTeamUsing = Engine.ObjectiveIsTeamUsing(f4_arg1.controller, f4_arg0.index, teamID)
	local isAnyOtherTeamUsing = isZombieCaptureWaypoint and f4_arg0.isAnyOtherTeamUsing == 1
	local isBothTeamsUsing = isTeamUsing and isAnyOtherTeamUsing
	local isNoTeamUsing = not isTeamUsing and not isAnyOtherTeamUsing

	if isNoTeamUsing then
		f4_arg0.progressBar:setRGB(CoD.white.r, CoD.white.g, CoD.white.b)
		if f4_arg0.glow then
			f4_arg0.glow:setRGB(CoD.white.r, CoD.white.g, CoD.white.b)
		end
	elseif isBothTeamsUsing then
		f4_arg0.progressBar:setRGB(f4_arg0.contestedProgressColor.r, f4_arg0.contestedProgressColor.g, f4_arg0.contestedProgressColor.b)
		if f4_arg0.glow then
			f4_arg0.glow:setRGB(f4_arg0.contestedProgressColor.r, f4_arg0.contestedProgressColor.g, f4_arg0.contestedProgressColor.b)
		end
	elseif isAnyOtherTeamUsing then
		f4_arg0.progressBar:setRGB(f4_arg0.worldProgressColor.r, f4_arg0.worldProgressColor.g, f4_arg0.worldProgressColor.b)
		if f4_arg0.glow then
			f4_arg0.glow:setRGB(f4_arg0.worldProgressColor.r, f4_arg0.worldProgressColor.g, f4_arg0.worldProgressColor.b)
		end
	else
		f4_arg0.progressBar:setRGB(f4_arg0.progressColor.r, f4_arg0.progressColor.g, f4_arg0.progressColor.b)
		if f4_arg0.glow then
			f4_arg0.glow:setRGB(f4_arg0.progressColor.r, f4_arg0.progressColor.g, f4_arg0.progressColor.b)
		end
	end
end

CoD.TCZWaypoint.updateProgress = function(f5_arg0, f5_arg1, f5_arg2, f5_arg3)
	local f5_local0 = Engine.GetObjectiveProgress(f5_arg1, f5_arg0.index)
	local f5_local1 = true
	if not f5_arg0.showProgressToEveryone and (f5_arg0.playerUsing == nil or f5_arg0.playerUsing == false) then
		f5_local1 = false
	end
	local f5_local2 = true
	if f5_local1 and f5_arg0.mayShowProgress then
		f5_local2 = f5_arg0:mayShowProgress(f5_arg1)
	end
	local f5_local3
	if f5_arg2 == 0 then
		f5_local3 = f5_arg2
	else
		f5_local3 = f5_arg3
	end
	if not f5_local3 and f5_local1 then
		f5_local1 = f5_local2
	end
	if f5_local1 and not f5_arg0.showProgressToEveryone then
		if f5_local3 then
			f5_arg0.progressBar:setupUIImage()
			f5_arg0.progressBar:setShaderVector(0, 1, 0, 0, 0)
		else
			f5_arg0.progressBar:setupObjectiveProgress(f5_arg0.index)
		end
	end
	if f5_arg0.showingProgress == false and f5_local1 == true and (f5_local0 > 0 or f5_local3) then
		local f5_local4 = CoD.ObjectiveWaypoint.progressHeight / 2
		f5_arg0.progressController:beginAnimation("progress", f5_arg0.snapToTime, true, true)
		f5_arg0.progressController:setLeftRight(false, false, -CoD.ObjectiveWaypoint.progressWidth / 2, CoD.ObjectiveWaypoint.progressWidth / 2)
		f5_arg0.progressController:setTopBottom(false, false, -f5_local4 - CoD.ObjectiveWaypoint.progressHeightNudge, f5_local4 - CoD.ObjectiveWaypoint.progressHeightNudge)
		f5_arg0.progressController:setAlpha(1)
		f5_arg0.showingProgress = true
	elseif not (f5_local0 ~= 0 or f5_local3) or f5_local1 == false then
		local f5_local4 = f5_arg0.iconWidth * 0.5
		local f5_local5 = f5_arg0.iconHeight * 0.5
		f5_arg0.progressController:beginAnimation("progress", f5_arg0.snapToTime, true, true)
		f5_arg0.progressController:setLeftRight(false, false, -f5_local4 / 2, f5_local4 / 2)
		f5_arg0.progressController:setTopBottom(false, false, -f5_local5 / 2, f5_local5 / 2)
		f5_arg0.progressController:setAlpha(1)
		f5_arg0.showingProgress = false
	end
end

CoD.TCZWaypoint.updatePlayerUsing = function(f6_arg0, f6_arg1, f6_arg2, f6_arg3)
	local f6_local0 = CoD.ObjectiveWaypoint.isPlayerUsing(f6_arg0, f6_arg1, f6_arg2, f6_arg3)
	if f6_arg0.playerUsing == f6_local0 then
		return
	elseif f6_local0 == true then
		if f6_arg0.playerUsing ~= nil then
			f6_arg0:beginAnimation("snap_in", f6_arg0.snapToTime, true, true)
		end
		f6_arg0:setEntityContainerStopUpdating(true)
		f6_arg0:setLeftRight(false, false, -f6_arg0.largeIconWidth / 2, f6_arg0.largeIconWidth / 2)
		f6_arg0:setTopBottom(false, false, -f6_arg0.largeIconHeight - f6_arg0.snapToHeight, -f6_arg0.snapToHeight)
		f6_arg0.edgePointerContainer:setAlpha(0)
		if f6_arg0.numberContainer then
			f6_arg0.numberContainer:completeAnimation()
			f6_arg0.numberContainer:setLeftRight(true, true, f6_arg0.numberIconIndentWidth, -f6_arg0.numberIconIndentWidth)
			f6_arg0.numberContainer:setTopBottom(true, true, f6_arg0.numberIconIndentHeight, -f6_arg0.numberIconIndentHeight)
		end
	else
		if f6_arg0.playerUsing ~= nil then
			f6_arg0:beginAnimation("snap_out", f6_arg0.snapToTime, true, true)
		end
		f6_arg0:setEntityContainerStopUpdating(false)
		f6_arg0:setLeftRight(false, false, -f6_arg0.iconWidth / 2, f6_arg0.iconWidth / 2)
		f6_arg0:setTopBottom(false, true, -f6_arg0.iconHeight, 0)
		f6_arg0.edgePointerContainer:setAlpha(1)
		if f6_arg0.numberContainer then
			f6_arg0.numberContainer:completeAnimation()
			f6_arg0.numberContainer:setLeftRight(true, true, f6_arg0.numberIconSmallIndentWidth, -f6_arg0.numberIconSmallIndentWidth)
			f6_arg0.numberContainer:setTopBottom(true, true, f6_arg0.numberIconSmallIndentHeight, -f6_arg0.numberIconSmallIndentHeight)
		end
	end
	f6_arg0.playerUsing = f6_local0
end

CoD.TCZWaypoint.SetCaptureProgressBarColor = function(f7_arg0, f7_arg1)
	f7_arg0.isAnyOtherTeamUsing = f7_arg1.newValue
	CoD.TCZWaypoint.update(f7_arg0, f7_arg1)
end

CoD.TCZWaypoint.PulseLow = function(f8_arg0, f8_arg1)
	f8_arg0:beginAnimation("pulse_low", f8_arg1, false, false)
	f8_arg0:setAlpha(CoD.TCZWaypoint.pulseAlphaLow)
end

CoD.TCZWaypoint.PulseHigh = function(f9_arg0, f9_arg1)
	f9_arg0:beginAnimation("pulse_high", time, false, false)
	f9_arg0:setAlpha(CoD.TCZWaypoint.pulseAlphaHigh)
end

CoD.TCZRoamingZombies.new = function(f10_arg0, f10_arg1)
	local f10_local0 = CoD.ObjectiveWaypoint.new(f10_arg0, f10_arg1, CoD.TCZRoamingZombies.baseWaypointZOffset)
	f10_local0:setClass(CoD.TCZRoamingZombies)
	f10_local0:registerEventHandler("objective_update_" .. Engine.GetObjectiveName(f10_arg0, f10_arg1), f10_local0.update)

	f10_local0.edgePointerContainer:setTopBottom(true, true, -20, 20)
	f10_local0.arrowImage:setLeftRight(false, false, -12, 12)
	f10_local0.arrowImage:setTopBottom(false, true, -24, 0)

	f10_local0.mainImage:setImage(CoD.TCZRoamingZombies.RoamingZombieMaterial)
	f10_local0.arrowImage:setImage(CoD.TCZWaypoint.ArrowImageMaterial)
	f10_local0.alphaController:setAlpha(1)
	return f10_local0
end

CoD.TCZRoamingZombies.update = function(f11_arg0, f11_arg1)
	local f11_local0 = f11_arg1.controller
	local f11_local1 = f11_arg0.index
	local f11_local2 = Engine.ObjectiveGetTeamUsingCount(f11_local0, f11_local1)
	if Engine.GetObjectiveEntity(f11_local0, f11_local1) then
		f11_arg0.zOffset = f11_arg0.PlayerZOffset
	else
		f11_arg0.zOffset = CoD.TCZRoamingZombies.baseWaypointZOffset
	end
	CoD.TCZRoamingZombies.super.update(f11_arg0, f11_arg1)
end
