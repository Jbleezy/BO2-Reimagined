CoD.RoundStatus = {}
CoD.RoundStatus.FactionIconLeftOffset = 7
CoD.RoundStatus.FactionIconSize = 91
CoD.RoundStatus.RoundIconLeftOffset = 0
CoD.RoundStatus.TextLeftOffset = 7
CoD.RoundStatus.LeftOffset = 0
CoD.RoundStatus.ChalkTop = -96
CoD.RoundStatus.ChalkSize = 96
CoD.RoundStatus.SpecialLeftOffset = 3
CoD.RoundStatus.SpecialRoundIconSize = 85
CoD.RoundStatus.RoundCenterHeight = 80
CoD.RoundStatus.Chalks = {}
CoD.RoundStatus.FirstRoundDuration = 1000
CoD.RoundStatus.FirstRoundIdleDuration = 3000
CoD.RoundStatus.FirstRoundFallDuration = 2000
CoD.RoundStatus.RoundPulseDuration = 500
CoD.RoundStatus.RoundPulseTimes = 10
CoD.RoundStatus.RoundPulseTimesDelta = 5
CoD.RoundStatus.RoundPulseTimesMin = 2
CoD.RoundStatus.RoundMax = 100
CoD.RoundStatus.ChalkFontName = "Morris"
LUI.createMenu.RoundStatus = function(LocalClientIndex)
	local RoundStatusWidget = CoD.Menu.NewSafeAreaFromState("RoundStatus", LocalClientIndex)
	CoD.RoundStatus.DefaultColor = {
		r = 0.21,
		g = 0,
		b = 0,
	}
	CoD.RoundStatus.AlternatePulseColor = {
		r = 1,
		g = 1,
		b = 1,
	}
	CoD.RoundStatus.Chalks[1] = RegisterMaterial("chalkmarks_hellcatraz_1")
	CoD.RoundStatus.Chalks[2] = RegisterMaterial("chalkmarks_hellcatraz_2")
	CoD.RoundStatus.Chalks[3] = RegisterMaterial("chalkmarks_hellcatraz_3")
	CoD.RoundStatus.Chalks[4] = RegisterMaterial("chalkmarks_hellcatraz_4")
	CoD.RoundStatus.Chalks[5] = RegisterMaterial("chalkmarks_hellcatraz_5")
	RoundStatusWidget.gameTypeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
	RoundStatusWidget.gameType = UIExpression.DvarString(nil, "ui_gametype")
	RoundStatusWidget.startRound = Engine.GetGametypeSetting("startRound")
	if RoundStatusWidget.gameTypeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		CoD.RoundStatus.LeftOffset = CoD.RoundStatus.FactionIconLeftOffset
	else
		CoD.RoundStatus.LeftOffset = CoD.RoundStatus.RoundIconLeftOffset
	end
	RoundStatusWidget.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	RoundStatusWidget.scaleContainer:setLeftRight(true, false, 0, 0)
	RoundStatusWidget.scaleContainer:setTopBottom(false, true, 0, 0)
	RoundStatusWidget:addElement(RoundStatusWidget.scaleContainer)
	local f1_local1, f1_local2, f1_local3, f1_local4 = Engine.GetUserSafeAreaForController(LocalClientIndex)
	RoundStatusWidget.safeAreaWidth = (f1_local3 - f1_local1) / RoundStatusWidget.scaleContainer.scale
	RoundStatusWidget.safeAreaHeight = (f1_local4 - f1_local2) / RoundStatusWidget.scaleContainer.scale
	RoundStatusWidget.chalkCenterTop = -RoundStatusWidget.safeAreaHeight * 0.5 - CoD.RoundStatus.ChalkSize * 1.5
	RoundStatusWidget.roundContainer = LUI.UIElement.new()
	RoundStatusWidget.roundContainer:setLeftRight(true, false, 0, 0)
	RoundStatusWidget.roundContainer:setTopBottom(false, true, 0, 0)
	RoundStatusWidget.scaleContainer:addElement(RoundStatusWidget.roundContainer)
	RoundStatusWidget.roundIconContainer = LUI.UIElement.new()
	RoundStatusWidget.roundIconContainer:setLeftRight(true, false, 0, 0)
	RoundStatusWidget.roundIconContainer:setTopBottom(false, true, 0, 0)
	RoundStatusWidget.scaleContainer:addElement(RoundStatusWidget.roundIconContainer)
	local f1_local5 = RoundStatusWidget.safeAreaWidth * 0.5
	RoundStatusWidget.roundTextCenter = LUI.UIText.new()
	RoundStatusWidget.roundTextCenter:setLeftRight(true, false, f1_local5 * 0.5 + CoD.RoundStatus.ChalkSize * -0.5, f1_local5 * 0.5 + CoD.RoundStatus.ChalkSize * 0.5)
	RoundStatusWidget.roundTextCenter:setTopBottom(false, true, RoundStatusWidget.chalkCenterTop, RoundStatusWidget.chalkCenterTop + CoD.RoundStatus.RoundCenterHeight)
	RoundStatusWidget.roundTextCenter:setFont(CoD.fonts[CoD.RoundStatus.ChalkFontName])
	RoundStatusWidget.roundTextCenter:setAlignment(LUI.Alignment.Center)
	RoundStatusWidget.roundTextCenter:setAlpha(0)
	RoundStatusWidget.roundTextCenter:registerEventHandler("transition_complete_first_round", CoD.RoundStatus.ShowFirstRoundFinish)
	RoundStatusWidget.roundTextCenter:registerEventHandler("transition_complete_idle", CoD.RoundStatus.ShowFirstRoundTextCenterIdleFinish)
	RoundStatusWidget.roundContainer:addElement(RoundStatusWidget.roundTextCenter)
	RoundStatusWidget.roundText = LUI.UIText.new()
	RoundStatusWidget.roundText:setLeftRight(true, false, CoD.RoundStatus.TextLeftOffset, CoD.RoundStatus.TextLeftOffset + CoD.RoundStatus.ChalkSize)
	RoundStatusWidget.roundText:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
	RoundStatusWidget.roundText:setFont(CoD.fonts[CoD.RoundStatus.ChalkFontName])
	RoundStatusWidget.roundText:setAlpha(0)
	RoundStatusWidget.roundText:registerEventHandler("transition_complete_first_round", CoD.RoundStatus.ShowFirstRoundFinish)
	RoundStatusWidget.roundText:registerEventHandler("transition_complete_idle", CoD.RoundStatus.ShowFirstRoundTextIdleFinish)
	RoundStatusWidget.roundText:registerEventHandler("transition_complete_round_switch_show", CoD.RoundStatus.RoundSwitchShowFinish)
	RoundStatusWidget.roundText:registerEventHandler("transition_complete_round_switch_hide", CoD.RoundStatus.RoundSwitchHideFinish)
	RoundStatusWidget.roundContainer:addElement(RoundStatusWidget.roundText)
	RoundStatusWidget.roundChalk1 = LUI.UIImage.new()
	RoundStatusWidget.roundChalk1:setLeftRight(true, false, CoD.RoundStatus.LeftOffset, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize)
	RoundStatusWidget.roundChalk1:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
	RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[1])
	RoundStatusWidget.roundChalk1:setAlpha(0)
	RoundStatusWidget.roundChalk1:registerEventHandler("transition_complete_first_round", CoD.RoundStatus.ShowFirstRoundFinish)
	RoundStatusWidget.roundChalk1:registerEventHandler("transition_complete_idle", CoD.RoundStatus.ShowFirstRoundChalk1IdleFinish)
	RoundStatusWidget.roundChalk1:registerEventHandler("transition_complete_round_switch_show", CoD.RoundStatus.RoundSwitchShowFinish)
	RoundStatusWidget.roundChalk1:registerEventHandler("transition_complete_round_switch_hide", CoD.RoundStatus.RoundSwitchHideFinish)
	RoundStatusWidget.roundContainer:addElement(RoundStatusWidget.roundChalk1)
	RoundStatusWidget.roundChalk2 = LUI.UIImage.new()
	RoundStatusWidget.roundChalk2:setLeftRight(true, false, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize * 2)
	RoundStatusWidget.roundChalk2:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
	RoundStatusWidget.roundChalk2:setImage(CoD.RoundStatus.Chalks[1])
	RoundStatusWidget.roundChalk2:setAlpha(0)
	RoundStatusWidget.roundChalk2:registerEventHandler("transition_complete_first_round", CoD.RoundStatus.ShowFirstRoundFinish)
	RoundStatusWidget.roundChalk2:registerEventHandler("transition_complete_idle", CoD.RoundStatus.ShowFirstRoundChalk2IdleFinish)
	RoundStatusWidget.roundChalk2:registerEventHandler("transition_complete_round_switch_show", CoD.RoundStatus.RoundSwitchShowFinish)
	RoundStatusWidget.roundChalk2:registerEventHandler("transition_complete_round_switch_hide", CoD.RoundStatus.RoundSwitchHideFinish)
	RoundStatusWidget.roundContainer:addElement(RoundStatusWidget.roundChalk2)
	RoundStatusWidget.factionIcon = LUI.UIImage.new()
	RoundStatusWidget.factionIcon:setLeftRight(true, false, CoD.RoundStatus.FactionIconLeftOffset, CoD.RoundStatus.FactionIconLeftOffset + CoD.RoundStatus.FactionIconSize)
	RoundStatusWidget.factionIcon:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.FactionIconSize)
	RoundStatusWidget.factionIcon:setAlpha(0)
	RoundStatusWidget.scaleContainer:addElement(RoundStatusWidget.factionIcon)
	RoundStatusWidget:registerEventHandler("hud_update_refresh", CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.RoundStatus.UpdateVisibility)
	RoundStatusWidget:registerEventHandler("hud_update_rounds_played", CoD.RoundStatus.UpdateRoundsPlayed)
	RoundStatusWidget:registerEventHandler("hud_update_team_change", CoD.RoundStatus.UpdateTeamChange)
	RoundStatusWidget:registerEventHandler("sq_tpo_special_round_active", CoD.RoundStatus.UpdateSpecialRound)
	RoundStatusWidget.timebombOverride = false
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC3Maps) then
		RoundStatusWidget:registerEventHandler("time_bomb_lua_override", CoD.RoundStatus.TimeBombRoundAnimationOverride)
	end
	RoundStatusWidget.visible = true
	return RoundStatusWidget
end

CoD.RoundStatus.UpdateVisibility = function(RoundStatusWidget, ClientInstance)
	local f2_local0 = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and (not CoD.IsShoutcaster(f2_local0) or CoD.ExeProfileVarBool(f2_local0, "shoutcaster_teamscore")) and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_FLASH_BANGED) == 0 then
		if not RoundStatusWidget.visible then
			RoundStatusWidget:setAlpha(1)
			RoundStatusWidget.visible = true
		end
	elseif RoundStatusWidget.visible then
		RoundStatusWidget:setAlpha(0)
		RoundStatusWidget.visible = nil
	end
end

CoD.RoundStatus.UpdateRoundsPlayed = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.data ~= nil then
		ClientInstance.roundsPlayed = ClientInstance.data[1]
	end

	if RoundStatusWidget.gameType == CoD.Zombie.GAMETYPE_ZCLASSIC or RoundStatusWidget.gameType == CoD.Zombie.GAMETYPE_ZSTANDARD then
		if RoundStatusWidget.startRound == ClientInstance.roundsPlayed then
			if ClientInstance.wasDemoJump == false and RoundStatusWidget.timebombOverride == false and CoD.Zombie.AllowRoundAnimation == 1 then
				CoD.RoundStatus.ShowFirstRound(RoundStatusWidget, ClientInstance.roundsPlayed)
			else
				RoundStatusWidget.roundChalk1:setLeftRight(true, false, CoD.RoundStatus.LeftOffset, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize)
				RoundStatusWidget.roundChalk1:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
				if not ClientInstance.wasDemoJump then
					ClientInstance.wasDemoJump = RoundStatusWidget.timebombOverride == true
				end
				CoD.RoundStatus.StartNewRound(RoundStatusWidget, ClientInstance.roundsPlayed, ClientInstance.wasDemoJump)
			end
		elseif RoundStatusWidget.startRound < ClientInstance.roundsPlayed then
			RoundStatusWidget.roundChalk1:setLeftRight(true, false, CoD.RoundStatus.LeftOffset, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize)
			RoundStatusWidget.roundChalk1:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
			RoundStatusWidget.roundChalk2:setLeftRight(true, false, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize * 2)
			RoundStatusWidget.roundChalk2:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
			RoundStatusWidget.roundText:setLeftRight(true, false, CoD.RoundStatus.TextLeftOffset, CoD.RoundStatus.TextLeftOffset + CoD.RoundStatus.ChalkSize)
			RoundStatusWidget.roundText:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
			if not ClientInstance.wasDemoJump then
				ClientInstance.wasDemoJump = RoundStatusWidget.timebombOverride == true
			end
			CoD.RoundStatus.StartNewRound(RoundStatusWidget, ClientInstance.roundsPlayed, ClientInstance.wasDemoJump)
		else
			CoD.RoundStatus.HideAllRoundIcons(RoundStatusWidget, ClientInstance)
		end
	else
		CoD.RoundStatus.HideAllRoundIcons(RoundStatusWidget, ClientInstance)
	end
end

CoD.RoundStatus.ShowFirstRound = function(RoundStatusWidget, FirstRoundValue)
	local f4_local0 = Engine.Localize("ZOMBIE_ROUND")
	local f4_local1_1, f4_local1_2, f4_local1_3, f4_local1_4 = GetTextDimensions(f4_local0, CoD.fonts[CoD.RoundStatus.ChalkFontName], CoD.RoundStatus.ChalkSize)
	local f4_local2 = f4_local1_3
	local f4_local3 = RoundStatusWidget.safeAreaWidth * 0.5
	local f4_local4 = RoundStatusWidget.chalkCenterTop
	RoundStatusWidget.roundTextCenter:setLeftRight(false, true, f4_local3 + CoD.RoundStatus.ChalkSize * -0.5 - f4_local2, f4_local3 + CoD.RoundStatus.ChalkSize * 0.5 + f4_local2)
	RoundStatusWidget.roundTextCenter:setText(f4_local0)
	RoundStatusWidget.roundTextCenter:setAlpha(1)
	RoundStatusWidget.roundTextCenter:beginAnimation("first_round", CoD.RoundStatus.FirstRoundDuration)
	RoundStatusWidget.roundTextCenter:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
	if FirstRoundValue <= 5 then
		if FirstRoundValue == 1 then
			local f4_local5 = f4_local3 - 15
			RoundStatusWidget.roundChalk1:setLeftRight(true, false, f4_local5, f4_local5 + CoD.RoundStatus.ChalkSize)
		else
			RoundStatusWidget.roundChalk1:setLeftRight(true, false, f4_local3 + CoD.RoundStatus.ChalkSize * -0.5, f4_local3 + CoD.RoundStatus.ChalkSize * 0.5)
		end
		RoundStatusWidget.roundChalk1:setTopBottom(false, true, f4_local4 + CoD.RoundStatus.ChalkSize, f4_local4 + CoD.RoundStatus.ChalkSize * 2)
		RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[FirstRoundValue])
		RoundStatusWidget.roundChalk1:setAlpha(1)
		RoundStatusWidget.roundChalk1:beginAnimation("first_round", CoD.RoundStatus.FirstRoundDuration)
		RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundChalk2:completeAnimation()
		RoundStatusWidget.roundChalk2:setAlpha(0)
		RoundStatusWidget.roundText:completeAnimation()
		RoundStatusWidget.roundText:setAlpha(0)
	elseif FirstRoundValue <= 10 then
		RoundStatusWidget.roundChalk1:setLeftRight(true, false, f4_local3 - CoD.RoundStatus.ChalkSize, f4_local3)
		RoundStatusWidget.roundChalk1:setTopBottom(false, true, f4_local4 + CoD.RoundStatus.ChalkSize, f4_local4 + CoD.RoundStatus.ChalkSize * 2)
		RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[5])
		RoundStatusWidget.roundChalk1:setAlpha(1)
		RoundStatusWidget.roundChalk1:beginAnimation("first_round", CoD.RoundStatus.FirstRoundDuration)
		RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundChalk2:setLeftRight(true, false, f4_local3, f4_local3 + CoD.RoundStatus.ChalkSize)
		RoundStatusWidget.roundChalk2:setTopBottom(false, true, f4_local4 + CoD.RoundStatus.ChalkSize, f4_local4 + CoD.RoundStatus.ChalkSize * 2)
		RoundStatusWidget.roundChalk2:setImage(CoD.RoundStatus.Chalks[FirstRoundValue - 5])
		RoundStatusWidget.roundChalk2:setAlpha(1)
		RoundStatusWidget.roundChalk2:beginAnimation("first_round", CoD.RoundStatus.FirstRoundDuration)
		RoundStatusWidget.roundChalk2:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
	else
		local f4_local5_1, f4_local5_2, f4_local5_3, f4_local5_4 = GetTextDimensions(FirstRoundValue, CoD.fonts[CoD.RoundStatus.ChalkFontName], CoD.RoundStatus.ChalkSize)
		local f4_local6 = f4_local5_3
		RoundStatusWidget.roundText:setLeftRight(true, false, f4_local3 + CoD.RoundStatus.ChalkSize * -0.5 - f4_local6, f4_local3 + CoD.RoundStatus.ChalkSize * 0.5 + f4_local6)
		RoundStatusWidget.roundText:setTopBottom(false, true, f4_local4 + CoD.RoundStatus.ChalkSize, f4_local4 + CoD.RoundStatus.ChalkSize * 2)
		RoundStatusWidget.roundText:setText(FirstRoundValue)
		RoundStatusWidget.roundText:setAlignment(LUI.Alignment.Center)
		RoundStatusWidget.roundText:setAlpha(1)
		RoundStatusWidget.roundText:beginAnimation("first_round", CoD.RoundStatus.FirstRoundDuration)
		RoundStatusWidget.roundText:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
	end
end

CoD.RoundStatus.ShowFirstRoundFinish = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.interrupted ~= true then
		RoundStatusWidget:beginAnimation("idle", CoD.RoundStatus.FirstRoundIdleDuration)
	end
end

CoD.RoundStatus.ShowFirstRoundTextCenterIdleFinish = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.interrupted ~= true then
		RoundStatusWidget:beginAnimation("fade_out", CoD.RoundStatus.FirstRoundDuration)
		RoundStatusWidget:setAlpha(0)
	end
end

CoD.RoundStatus.ShowFirstRoundTextIdleFinish = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.interrupted ~= true then
		RoundStatusWidget:beginAnimation("fall_down", CoD.RoundStatus.FirstRoundFallDuration)
		RoundStatusWidget:setLeftRight(true, false, CoD.RoundStatus.LeftOffset, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize)
		RoundStatusWidget:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
	end
end

CoD.RoundStatus.ShowFirstRoundChalk1IdleFinish = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.interrupted ~= true then
		RoundStatusWidget:beginAnimation("fall_down", CoD.RoundStatus.FirstRoundFallDuration)
		RoundStatusWidget:setLeftRight(true, false, CoD.RoundStatus.LeftOffset, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize)
		RoundStatusWidget:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
	end
end

CoD.RoundStatus.ShowFirstRoundChalk2IdleFinish = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.interrupted ~= true then
		RoundStatusWidget:beginAnimation("fall_down", CoD.RoundStatus.FirstRoundFallDuration)
		RoundStatusWidget:setLeftRight(true, false, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize, CoD.RoundStatus.LeftOffset + CoD.RoundStatus.ChalkSize * 2)
		RoundStatusWidget:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.ChalkSize)
	end
end

CoD.RoundStatus.StartNewRound = function(RoundStatusWidget, RoundsPlayed, WasDemoJump)
	if RoundsPlayed <= 5 then
		RoundStatusWidget.roundChalk1:setAlpha(1)
		if WasDemoJump == true then
			RoundStatusWidget.roundChalk1:completeAnimation()
			RoundStatusWidget.roundChalk1:setAlpha(1)
			RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
			RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[RoundsPlayed])
		else
			if RoundsPlayed > 1 then
				RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[RoundsPlayed - 1])
			end
			RoundStatusWidget.roundChalk1.pulseTimes = 0
			RoundStatusWidget.roundChalk1.material = CoD.RoundStatus.Chalks[RoundsPlayed]
			RoundStatusWidget.roundChalk1.showInLastPulse = true
			RoundStatusWidget.roundChalk1.showInPreviousPulses = true
			RoundStatusWidget.roundChalk1:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundChalk1:setAlpha(0)
			RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
		end
		RoundStatusWidget.roundChalk2:completeAnimation()
		RoundStatusWidget.roundChalk2:setAlpha(0)
		RoundStatusWidget.roundText:completeAnimation()
		RoundStatusWidget.roundText:setAlpha(0)
	elseif RoundsPlayed == 6 then
		RoundStatusWidget.roundChalk1:setAlpha(1)
		RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[5])
		if WasDemoJump == true then
			RoundStatusWidget.roundChalk2:setAlpha(1)
			RoundStatusWidget.roundChalk2:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
			RoundStatusWidget.roundChalk2:setImage(CoD.RoundStatus.Chalks[1])
		else
			RoundStatusWidget.roundChalk1.pulseTimes = 0
			RoundStatusWidget.roundChalk1.material = CoD.RoundStatus.Chalks[5]
			RoundStatusWidget.roundChalk1.showInLastPulse = true
			RoundStatusWidget.roundChalk1.showInPreviousPulses = true
			RoundStatusWidget.roundChalk1:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundChalk1:setAlpha(0)
			RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
			RoundStatusWidget.roundChalk2.pulseTimes = 0
			RoundStatusWidget.roundChalk2.material = CoD.RoundStatus.Chalks[RoundsPlayed - 5]
			RoundStatusWidget.roundChalk2.showInLastPulse = true
			RoundStatusWidget.roundChalk2.showInPreviousPulses = false
			RoundStatusWidget.roundChalk2:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundChalk2:setAlpha(0)
			RoundStatusWidget.roundChalk2:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
		end
		RoundStatusWidget.roundText:completeAnimation()
		RoundStatusWidget.roundText:setAlpha(0)
	elseif RoundsPlayed <= 10 then
		RoundStatusWidget.roundChalk1:setAlpha(1)
		RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[5])
		RoundStatusWidget.roundChalk2:setAlpha(1)
		RoundStatusWidget.roundChalk2:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundChalk2:setImage(CoD.RoundStatus.Chalks[RoundsPlayed - 5 - 1])
		if WasDemoJump == true then
			RoundStatusWidget.roundChalk1:setAlpha(1)
			RoundStatusWidget.roundChalk2:setAlpha(1)
			RoundStatusWidget.roundChalk2:setImage(CoD.RoundStatus.Chalks[RoundsPlayed - 5])
		else
			RoundStatusWidget.roundChalk1.pulseTimes = 0
			RoundStatusWidget.roundChalk1.material = CoD.RoundStatus.Chalks[5]
			RoundStatusWidget.roundChalk1.showInLastPulse = true
			RoundStatusWidget.roundChalk1.showInPreviousPulses = true
			RoundStatusWidget.roundChalk1:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundChalk1:setAlpha(0)
			RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
			RoundStatusWidget.roundChalk2.pulseTimes = 0
			RoundStatusWidget.roundChalk2.material = CoD.RoundStatus.Chalks[RoundsPlayed - 5]
			RoundStatusWidget.roundChalk2.showInLastPulse = true
			RoundStatusWidget.roundChalk2.showInPreviousPulses = true
			RoundStatusWidget.roundChalk2:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundChalk2:setAlpha(0)
			RoundStatusWidget.roundChalk2:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
		end
		RoundStatusWidget.roundText:completeAnimation()
		RoundStatusWidget.roundText:setAlpha(0)
	elseif RoundsPlayed == 11 then
		RoundStatusWidget.roundChalk1:setAlpha(1)
		RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundChalk1:setImage(CoD.RoundStatus.Chalks[5])
		RoundStatusWidget.roundChalk2:setAlpha(1)
		RoundStatusWidget.roundChalk2:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundChalk2:setImage(CoD.RoundStatus.Chalks[5])
		if WasDemoJump == true then
			RoundStatusWidget.roundChalk1:setAlpha(0)
			RoundStatusWidget.roundChalk2:setAlpha(0)
			RoundStatusWidget.roundText:setAlpha(1)
			RoundStatusWidget.roundText:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
			RoundStatusWidget.roundText:setText(RoundsPlayed)
		else
			RoundStatusWidget.roundChalk1.pulseTimes = 0
			RoundStatusWidget.roundChalk1.material = CoD.RoundStatus.Chalks[5]
			RoundStatusWidget.roundChalk1.showInLastPulse = false
			RoundStatusWidget.roundChalk1.showInPreviousPulses = true
			RoundStatusWidget.roundChalk1:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundChalk1:setAlpha(0)
			RoundStatusWidget.roundChalk1:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
			RoundStatusWidget.roundChalk2.pulseTimes = 0
			RoundStatusWidget.roundChalk2.material = CoD.RoundStatus.Chalks[5]
			RoundStatusWidget.roundChalk2.showInLastPulse = false
			RoundStatusWidget.roundChalk2.showInPreviousPulses = true
			RoundStatusWidget.roundChalk2:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundChalk2:setAlpha(0)
			RoundStatusWidget.roundChalk2:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
			RoundStatusWidget.roundText.pulseTimes = 0
			RoundStatusWidget.roundText.material = RoundsPlayed
			RoundStatusWidget.roundText.showInLastPulse = true
			RoundStatusWidget.roundText.showInPreviousPulses = false
			RoundStatusWidget.roundText:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundText:setAlpha(0)
			RoundStatusWidget.roundText:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
		end
	else
		RoundStatusWidget.roundText:setAlpha(1)
		RoundStatusWidget.roundText:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
		RoundStatusWidget.roundText:setText(RoundsPlayed - 1)
		if WasDemoJump == true then
			RoundStatusWidget.roundText:setText(RoundsPlayed)
		else
			RoundStatusWidget.roundText.pulseTimes = 0
			RoundStatusWidget.roundText.material = RoundsPlayed
			RoundStatusWidget.roundText.showInLastPulse = true
			RoundStatusWidget.roundText.showInPreviousPulses = true
			RoundStatusWidget.roundText:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			RoundStatusWidget.roundText:setAlpha(0)
			RoundStatusWidget.roundText:setRGB(CoD.RoundStatus.AlternatePulseColor.r, CoD.RoundStatus.AlternatePulseColor.g, CoD.RoundStatus.AlternatePulseColor.b)
		end
		RoundStatusWidget.roundChalk1:completeAnimation()
		RoundStatusWidget.roundChalk1:setAlpha(0)
		RoundStatusWidget.roundChalk2:completeAnimation()
		RoundStatusWidget.roundChalk2:setAlpha(0)
	end
end

CoD.RoundStatus.RoundSwitchShowFinish = function(RoundText, ClientInstance)
	if ClientInstance.interrupted ~= true then
		RoundText.pulseTimes = RoundText.pulseTimes + 1
		if RoundText.pulseTimes <= CoD.RoundStatus.RoundPulseTimes then
			if RoundText.pulseTimes > CoD.RoundStatus.RoundPulseTimes - 1 then
				RoundText:beginAnimation("round_switch_hide", CoD.RoundStatus.FirstRoundDuration)
				RoundText:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
			else
				RoundText:beginAnimation("round_switch_hide", CoD.RoundStatus.RoundPulseDuration)
			end
			RoundText:setAlpha(0)
		end
	end
end

CoD.RoundStatus.RoundSwitchHideFinish = function(RoundText, ClientInstance)
	if ClientInstance.interrupted ~= true then
		local RoundNumberIsVisible = 1
		if RoundText.pulseTimes > CoD.RoundStatus.RoundPulseTimes - 1 then
			if type(RoundText.material) == "number" then
				RoundText:setText(RoundText.material)
			else
				RoundText:setImage(RoundText.material)
			end
			if RoundText.showInLastPulse == false then
				RoundNumberIsVisible = 0
			end
			RoundText:beginAnimation("round_switch_show", CoD.RoundStatus.FirstRoundDuration)
		else
			if RoundText.showInPreviousPulses == false then
				RoundNumberIsVisible = 0
			end
			RoundText:beginAnimation("round_switch_show", CoD.RoundStatus.RoundPulseDuration)
		end
		RoundText:setAlpha(RoundNumberIsVisible)
	end
end

CoD.RoundStatus.UpdateTeamChange = function(RoundStatusWidget, ClientInstance)
	if RoundStatusWidget.team ~= ClientInstance.team and type(ClientInstance.team) == "number" and ClientInstance.team < CoD.TEAM_SPECTATOR then
		RoundStatusWidget.team = ClientInstance.team
		if RoundStatusWidget.team ~= CoD.TEAM_FREE then
			local FactionTeam = Engine.GetFactionForTeam(ClientInstance.team)
			if FactionTeam ~= "" and RoundStatusWidget.gameTypeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
				if CoD.Zombie.GAMETYPE_ZCLEANSED == Dvar.ui_gametype:get() and RoundStatusWidget.team == CoD.TEAM_AXIS then
					FactionTeam = "zombie"
				elseif CoD.Zombie.GAMETYPE_ZMEAT == Dvar.ui_gametype:get() and RoundStatusWidget.team == CoD.TEAM_AXIS then
					FactionTeam = "cia"
				end
				RoundStatusWidget.factionIcon:setImage(RegisterMaterial("faction_" .. FactionTeam))
				RoundStatusWidget.factionIcon:setAlpha(1)
			else
				RoundStatusWidget.factionIcon:setAlpha(0)
			end
		else
			RoundStatusWidget.factionIcon:setAlpha(0)
		end
	end
end

CoD.RoundStatus.HideAllRoundIcons = function(RoundStatusWidget, ClientInstance)
	RoundStatusWidget.roundTextCenter:setAlpha(0)
	RoundStatusWidget.roundText:setAlpha(0)
	RoundStatusWidget.roundChalk1:setAlpha(0)
	RoundStatusWidget.roundChalk2:setAlpha(0)
end

CoD.RoundStatus.UpdateSpecialRound = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.newValue == 1 then
		if not RoundStatusWidget.specialRoundIcon then
			RoundStatusWidget.specialRoundIcon = LUI.UIImage.new()
			RoundStatusWidget.specialRoundIcon:setLeftRight(true, false, CoD.RoundStatus.SpecialLeftOffset, CoD.RoundStatus.SpecialLeftOffset + CoD.RoundStatus.SpecialRoundIconSize)
			RoundStatusWidget.specialRoundIcon:setTopBottom(false, true, CoD.RoundStatus.ChalkTop, CoD.RoundStatus.ChalkTop + CoD.RoundStatus.SpecialRoundIconSize / 2)
			RoundStatusWidget.specialRoundIcon:setImage(RegisterMaterial("hud_zm_chalk_infinity"))
			RoundStatusWidget.specialRoundIcon:setAlpha(0)
			RoundStatusWidget.roundIconContainer:addElement(RoundStatusWidget.specialRoundIcon)
		end
		RoundStatusWidget.specialRoundIcon:beginAnimation("fade_in", 1000)
		RoundStatusWidget.specialRoundIcon:setAlpha(1)
		RoundStatusWidget.roundContainer:beginAnimation("fade_out", 500)
		RoundStatusWidget.roundContainer:setAlpha(0)
	else
		RoundStatusWidget.specialRoundIcon:beginAnimation("fade_out", 500)
		RoundStatusWidget.specialRoundIcon:setAlpha(0)
		RoundStatusWidget.roundContainer:beginAnimation("fade_in", 1000)
		RoundStatusWidget.roundContainer:setAlpha(1)
	end
end

CoD.RoundStatus.TimeBombRoundAnimationOverride = function(RoundStatusWidget, ClientInstance)
	if ClientInstance.newValue == 1 then
		RoundStatusWidget.timebombOverride = true
	else
		RoundStatusWidget.timebombOverride = false
	end
end
