CoD.Reimagined = {}

LUI.createMenu.ReimaginedArea = function(LocalClientIndex)
	local safeArea = CoD.Menu.NewSafeAreaFromState("ReimaginedArea", LocalClientIndex)
	safeArea:setOwner(LocalClientIndex)

	local x = 7
	local y = 3

	local enemyCounterWidget = LUI.UIElement.new()
	enemyCounterWidget:setLeftRight(true, false, x, x)
	enemyCounterWidget:setTopBottom(true, false, y, y)
	enemyCounterWidget:setAlpha(0)
	safeArea:addElement(enemyCounterWidget)

	local enemyCounterText = LUI.UIText.new()
	enemyCounterText:setLeftRight(true, false, 0, 1000)
	enemyCounterText:setTopBottom(true, false, 0, CoD.textSize.Default)
	enemyCounterText:setFont(CoD.fonts.Big)
	enemyCounterText:setAlignment(LUI.Alignment.Left)
	enemyCounterWidget:addElement(enemyCounterText)
	enemyCounterWidget.enemyCounterText = enemyCounterText

	enemyCounterWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.EnemyCounterArea.UpdateVisibility)
	enemyCounterWidget:registerEventHandler("hud_update_enemy_counter", CoD.Reimagined.EnemyCounterArea.UpdateEnemyCounter)

	local x = -7
	local y = 18

	local timerWidget = LUI.UIElement.new()
	timerWidget:setLeftRight(false, true, x, x)
	timerWidget:setTopBottom(true, false, y, y)
	timerWidget:setAlpha(0)
	safeArea:addElement(timerWidget)

	local totalTimerText = LUI.UIText.new()
	totalTimerText:setLeftRight(true, false, -1000, 0)
	totalTimerText:setTopBottom(true, false, 0, CoD.textSize.Default)
	totalTimerText:setFont(CoD.fonts.Big)
	totalTimerText:setAlignment(LUI.Alignment.Right)
	timerWidget:addElement(totalTimerText)
	timerWidget.totalTimerText = totalTimerText

	local roundTimerText = LUI.UIText.new()
	roundTimerText:setLeftRight(true, false, -1000, 0)
	roundTimerText:setTopBottom(true, false, 0 + 23, CoD.textSize.Default + 23)
	roundTimerText:setFont(CoD.fonts.Big)
	roundTimerText:setAlignment(LUI.Alignment.Right)
	timerWidget:addElement(roundTimerText)
	timerWidget.roundTimerText = roundTimerText

	local roundTotalTimerText = LUI.UIText.new()
	roundTotalTimerText:setLeftRight(true, false, -1000, 0)
	roundTotalTimerText:setTopBottom(true, false, 0 + 46, CoD.textSize.Default + 46)
	roundTotalTimerText:setFont(CoD.fonts.Big)
	roundTotalTimerText:setAlignment(LUI.Alignment.Right)
	roundTotalTimerText:registerAnimationState("fade_out", {
		alpha = 0,
	})
	roundTotalTimerText:registerAnimationState("fade_in", {
		alpha = 1,
	})
	timerWidget:addElement(roundTotalTimerText)
	timerWidget.roundTotalTimerText = roundTotalTimerText

	timerWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.TimerArea.UpdateVisibility)
	timerWidget:registerEventHandler("hud_update_total_timer", CoD.Reimagined.TimerArea.UpdateTotalTimer)
	timerWidget:registerEventHandler("hud_update_round_timer", CoD.Reimagined.TimerArea.UpdateRoundTimer)
	timerWidget:registerEventHandler("hud_update_round_total_timer", CoD.Reimagined.TimerArea.UpdateRoundTotalTimer)
	timerWidget:registerEventHandler("hud_fade_out_round_total_timer", CoD.Reimagined.TimerArea.FadeOutRoundTotalTimer)
	timerWidget:registerEventHandler("hud_fade_in_round_total_timer", CoD.Reimagined.TimerArea.FadeInRoundTotalTimer)

	local x = 7
	local y = -163
	local width = 169
	local height = 13
	local bgDiff = 2

	local healthBarWidget = LUI.UIElement.new()
	healthBarWidget:setLeftRight(true, false, x, x)
	healthBarWidget:setTopBottom(false, true, y, y)
	healthBarWidget:setAlpha(0)
	healthBarWidget.width = width
	healthBarWidget.height = height
	healthBarWidget.bgDiff = bgDiff
	safeArea:addElement(healthBarWidget)

	local healthBarBg = LUI.UIImage.new()
	healthBarBg:setLeftRight(true, false, 0, 0 + width)
	healthBarBg:setTopBottom(true, false, 0, 0 + height)
	healthBarBg:setImage(RegisterMaterial("white"))
	healthBarBg:setRGB(0, 0, 0)
	healthBarBg:setAlpha(0.5)
	healthBarWidget:addElement(healthBarBg)
	healthBarWidget.healthBarBg = healthBarBg

	local healthBar = LUI.UIImage.new()
	healthBar:setLeftRight(true, false, bgDiff, width - bgDiff)
	healthBar:setTopBottom(true, false, bgDiff, height - bgDiff)
	healthBar:setImage(RegisterMaterial("white"))
	healthBar:setAlpha(1)
	healthBarWidget:addElement(healthBar)
	healthBarWidget.healthBar = healthBar

	local shieldBar = LUI.UIImage.new()
	shieldBar:setLeftRight(true, false, bgDiff, width - bgDiff)
	shieldBar:setTopBottom(true, false, bgDiff, (height - bgDiff) / 2)
	shieldBar:setImage(RegisterMaterial("white"))
	shieldBar:setRGB(0.5, 0.5, 0.5)
	shieldBar:setAlpha(0)
	healthBarWidget:addElement(shieldBar)
	healthBarWidget.shieldBar = shieldBar

	local healthText = LUI.UIText.new()
	healthText:setLeftRight(true, false, width + bgDiff * 2, 0)
	healthText:setTopBottom(true, false, 0 - bgDiff, height + bgDiff)
	healthText:setFont(CoD.fonts.Big)
	healthText:setAlignment(LUI.Alignment.Left)
	healthBarWidget:addElement(healthText)
	healthBarWidget.healthText = healthText

	healthBarWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_health_bar", CoD.Reimagined.HealthBarArea.UpdateHealthBar)

	local x = 7
	local y = -167

	local zoneNameWidget = LUI.UIElement.new()
	zoneNameWidget:setLeftRight(true, false, x, x)
	zoneNameWidget:setTopBottom(false, true, y, y)
	zoneNameWidget:setAlpha(0)
	safeArea:addElement(zoneNameWidget)

	local zoneNameText = LUI.UIText.new()
	zoneNameText:setLeftRight(true, false, 0, 1000)
	zoneNameText:setTopBottom(true, false, -CoD.textSize.Default, 0)
	zoneNameText:setFont(CoD.fonts.Big)
	zoneNameText:setAlignment(LUI.Alignment.Left)
	zoneNameText:registerAnimationState("fade_out", {
		alpha = 0,
	})
	zoneNameText:registerAnimationState("fade_in", {
		alpha = 1,
	})
	zoneNameWidget:addElement(zoneNameText)
	zoneNameWidget.zoneNameText = zoneNameText

	zoneNameWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.ZoneNameArea.UpdateVisibility)
	zoneNameWidget:registerEventHandler("hud_update_zone_name", CoD.Reimagined.ZoneNameArea.UpdateZoneName)
	zoneNameWidget:registerEventHandler("hud_fade_out_zone_name", CoD.Reimagined.ZoneNameArea.FadeOutZoneName)
	zoneNameWidget:registerEventHandler("hud_fade_in_zone_name", CoD.Reimagined.ZoneNameArea.FadeInZoneName)

	return safeArea
end

CoD.Reimagined.EnemyCounterArea = {}
CoD.Reimagined.EnemyCounterArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_enemy_counter") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and (UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 or UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 1) and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.EnemyCounterArea.UpdateEnemyCounter = function(Menu, ClientInstance)
	local enemyCount = ClientInstance.data[1]

	if enemyCount == 0 then
		enemyCount = ""
	end

	Menu.enemyCounterText:setText(Engine.Localize("ZOMBIE_HUD_ENEMIES_REMAINING") .. enemyCount)
end

CoD.Reimagined.TimerArea = {}
CoD.Reimagined.TimerArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_timer") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and (UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 or UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 1) and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.TimerArea.UpdateTotalTimer = function(Menu, ClientInstance)
	local timeNum = ClientInstance.data[1]
	local time = CoD.Reimagined.ConvertNumToTime(timeNum)

	Menu.totalTimerText:setText(Engine.Localize("ZOMBIE_HUD_TOTAL_TIME") .. time)
end

CoD.Reimagined.TimerArea.UpdateRoundTimer = function(Menu, ClientInstance)
	local timeNum = ClientInstance.data[1]
	local time = CoD.Reimagined.ConvertNumToTime(timeNum)

	Menu.roundTimerText:setText(Engine.Localize("ZOMBIE_HUD_ROUND_TIME") .. time)
end

CoD.Reimagined.TimerArea.UpdateRoundTotalTimer = function(Menu, ClientInstance)
	local timeNum = ClientInstance.data[1]
	local time = CoD.Reimagined.ConvertNumToTime(timeNum)

	Menu.roundTotalTimerText:setText(Engine.Localize("ZOMBIE_HUD_ROUND_TOTAL_TIME") .. time)
end

CoD.Reimagined.TimerArea.FadeOutRoundTotalTimer = function(Menu, ClientInstance)
	if ClientInstance.data ~= nil then
		Menu.roundTotalTimerText:animateToState("fade_out", ClientInstance.data[1])
	else
		Menu.roundTotalTimerText:animateToState("fade_out")
	end
end

CoD.Reimagined.TimerArea.FadeInRoundTotalTimer = function(Menu, ClientInstance)
	if ClientInstance.data ~= nil then
		Menu.roundTotalTimerText:animateToState("fade_in", ClientInstance.data[1])
	else
		Menu.roundTotalTimerText:animateToState("fade_in")
	end
end

CoD.Reimagined.HealthBarArea = {}
CoD.Reimagined.HealthBarArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_health_bar") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.HealthBarArea.UpdateHealthBar = function(Menu, ClientInstance)
	local health = ClientInstance.data[1]
	local maxHealth = ClientInstance.data[2]
	local shieldHealth = ClientInstance.data[3]
	local healthPercent = health / maxHealth
	local shieldHealthPercent = shieldHealth / 100

	local healthWidth = math.max(3, (Menu.width * healthPercent) - Menu.bgDiff)

	Menu.healthBar:setLeftRight(true, false, Menu.bgDiff, healthWidth)

	if shieldHealthPercent > 0 then
		local shieldHealthWidth = math.max(3, (Menu.width * shieldHealthPercent) - Menu.bgDiff)

		Menu.shieldBar:setAlpha(1)
		Menu.shieldBar:setLeftRight(true, false, Menu.bgDiff, shieldHealthWidth)
		Menu.healthBar:setTopBottom(true, false, (Menu.height + Menu.bgDiff) / 2, Menu.height - Menu.bgDiff)
		Menu.healthText:setText(health .. " | " .. shieldHealth)
	else
		Menu.shieldBar:setAlpha(0)
		Menu.healthBar:setTopBottom(true, false, Menu.bgDiff, Menu.height - Menu.bgDiff)
		Menu.healthText:setText(health)
	end
end

CoD.Reimagined.ZoneNameArea = {}
CoD.Reimagined.ZoneNameArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_zone_name") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.ZoneNameArea.UpdateZoneName = function(Menu, ClientInstance)
	local zoneName = Engine.Localize(Engine.GetIString(ClientInstance.data[1], "CS_LOCALIZED_STRINGS"))
	Menu.zoneNameText:setText(zoneName)
end

CoD.Reimagined.ZoneNameArea.FadeOutZoneName = function(Menu, ClientInstance)
	if ClientInstance.data ~= nil then
		Menu.zoneNameText:animateToState("fade_out", ClientInstance.data[1])
	else
		Menu.zoneNameText:animateToState("fade_out")
	end
end

CoD.Reimagined.ZoneNameArea.FadeInZoneName = function(Menu, ClientInstance)
	if ClientInstance.data ~= nil then
		Menu.zoneNameText:animateToState("fade_in", ClientInstance.data[1])
	else
		Menu.zoneNameText:animateToState("fade_in")
	end
end

CoD.Reimagined.ConvertNumToTime = function(num)
	local time = ""
	local hrs = 0
	local mins = 0
	local secs = 0

	if num >= 3600 then
		hrs = math.floor(num / 3600)
		num = num - (hrs * 3600)
	end

	if num >= 60 then
		mins = math.floor(num / 60)
		num = num - (mins * 60)
	end

	if num > 0 then
		secs = num
	end

	if hrs > 0 then
		time = tostring(hrs) .. ":" .. string.format("%02d", mins) .. ":" .. string.format("%02d", secs)
	else
		time = tostring(mins) .. ":" .. string.format("%02d", secs)
	end

	return time
end
