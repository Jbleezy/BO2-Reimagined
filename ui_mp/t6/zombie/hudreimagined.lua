CoD.Reimagined = {}

LUI.createMenu.ReimaginedArea = function(LocalClientIndex)
	local safeArea = CoD.Menu.NewSafeAreaFromState("ReimaginedArea", LocalClientIndex)
	safeArea:setOwner(LocalClientIndex)

	local enemyCounterWidget = LUI.UIElement.new()
	enemyCounterWidget:setLeftRight(true, true, 7, 7)
	enemyCounterWidget:setTopBottom(true, false, 3, 3)
	enemyCounterWidget:setAlpha(0)
	safeArea:addElement(enemyCounterWidget)

	local enemyCounterText = LUI.UIText.new()
	enemyCounterText:setLeftRight(true, true, 0, 0)
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

	local timerWidget = LUI.UIElement.new()
	timerWidget:setLeftRight(true, true, -7, -7)
	timerWidget:setTopBottom(true, false, 18, 18)
	timerWidget:setAlpha(0)
	safeArea:addElement(timerWidget)

	local totalTimerText = LUI.UIText.new()
	totalTimerText:setLeftRight(true, true, 0, 0)
	totalTimerText:setTopBottom(true, false, 0, CoD.textSize.Default)
	totalTimerText:setFont(CoD.fonts.Big)
	totalTimerText:setAlignment(LUI.Alignment.Right)
	timerWidget:addElement(totalTimerText)
	timerWidget.totalTimerText = totalTimerText

	local roundTimerText = LUI.UIText.new()
	roundTimerText:setLeftRight(true, true, 0, 0)
	roundTimerText:setTopBottom(true, false, 0 + 23, CoD.textSize.Default + 23)
	roundTimerText:setFont(CoD.fonts.Big)
	roundTimerText:setAlignment(LUI.Alignment.Right)
	timerWidget:addElement(roundTimerText)
	timerWidget.roundTimerText = roundTimerText

	local roundTotalTimerText = LUI.UIText.new()
	roundTotalTimerText:setLeftRight(true, true, 0, 0)
	roundTotalTimerText:setTopBottom(true, false, 0 + 46, CoD.textSize.Default + 46)
	roundTotalTimerText:setFont(CoD.fonts.Big)
	roundTotalTimerText:setAlignment(LUI.Alignment.Right)
	roundTotalTimerText:setAlpha(0)
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

	local healthBarWidget = LUI.UIElement.new()
	healthBarWidget:setLeftRight(true, true, 7, 7)
	healthBarWidget:setTopBottom(false, true, -163, -163)
	healthBarWidget:setAlpha(0)
	healthBarWidget.width = 169
	healthBarWidget.height = 13
	healthBarWidget.bgDiff = 2
	safeArea:addElement(healthBarWidget)

	local healthBarBg = LUI.UIImage.new()
	healthBarBg:setLeftRight(true, false, 0, 0 + healthBarWidget.width)
	healthBarBg:setTopBottom(true, false, 0, 0 + healthBarWidget.height)
	healthBarBg:setImage(RegisterMaterial("white"))
	healthBarBg:setRGB(0, 0, 0)
	healthBarBg:setAlpha(0.5)
	healthBarWidget:addElement(healthBarBg)
	healthBarWidget.healthBarBg = healthBarBg

	local healthBar = LUI.UIImage.new()
	healthBar:setLeftRight(true, false, healthBarWidget.bgDiff, healthBarWidget.width - healthBarWidget.bgDiff)
	healthBar:setTopBottom(true, false, healthBarWidget.bgDiff, healthBarWidget.height - healthBarWidget.bgDiff)
	healthBar:setImage(RegisterMaterial("white"))
	healthBar:setAlpha(1)
	healthBarWidget:addElement(healthBar)
	healthBarWidget.healthBar = healthBar

	local shieldBar = LUI.UIImage.new()
	shieldBar:setLeftRight(true, false, healthBarWidget.bgDiff, healthBarWidget.width - healthBarWidget.bgDiff)
	shieldBar:setTopBottom(true, false, healthBarWidget.bgDiff, (healthBarWidget.height - healthBarWidget.bgDiff) / 2)
	shieldBar:setImage(RegisterMaterial("white"))
	shieldBar:setRGB(0.5, 0.5, 0.5)
	shieldBar:setAlpha(0)
	healthBarWidget:addElement(shieldBar)
	healthBarWidget.shieldBar = shieldBar

	local healthText = LUI.UIText.new()
	healthText:setLeftRight(true, true, healthBarWidget.width + healthBarWidget.bgDiff * 2, 0)
	healthText:setTopBottom(true, false, 0 - healthBarWidget.bgDiff, healthBarWidget.height + healthBarWidget.bgDiff)
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

	local zoneNameWidget = LUI.UIElement.new()
	zoneNameWidget:setLeftRight(true, true, 7, 7)
	zoneNameWidget:setTopBottom(false, true, -167, -167)
	zoneNameWidget:setAlpha(0)
	safeArea:addElement(zoneNameWidget)

	local zoneNameText = LUI.UIText.new()
	zoneNameText:setLeftRight(true, true, 0, 0)
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

	local questTimerWidget = LUI.UIElement.new()
	questTimerWidget:setLeftRight(true, true, 0, 0)
	questTimerWidget:setTopBottom(false, false, -200, -200)
	questTimerWidget:setAlpha(0)
	safeArea:addElement(questTimerWidget)

	local questTimerText = LUI.UIText.new()
	questTimerText:setLeftRight(true, true, 0, 0)
	questTimerText:setTopBottom(false, false, 0, CoD.textSize.Default)
	questTimerText:setFont(CoD.fonts.Big)
	questTimerText:setAlignment(LUI.Alignment.Center)
	questTimerText:setAlpha(0)
	questTimerText:registerAnimationState("fade_out", {
		alpha = 0,
	})
	questTimerText:registerAnimationState("fade_in", {
		alpha = 1,
	})
	questTimerWidget:addElement(questTimerText)
	questTimerWidget.questTimerText = questTimerText

	questTimerWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.QuestTimerArea.UpdateVisibility)
	questTimerWidget:registerEventHandler("hud_update_quest_timer", CoD.Reimagined.QuestTimerArea.UpdateQuestTimer)
	questTimerWidget:registerEventHandler("hud_fade_out_quest_timer", CoD.Reimagined.QuestTimerArea.FadeOutQuestTimer)
	questTimerWidget:registerEventHandler("hud_fade_in_quest_timer", CoD.Reimagined.QuestTimerArea.FadeInQuestTimer)

	local gameModeNameWidget = LUI.UIElement.new()
	gameModeNameWidget:setLeftRight(true, true, 0, 0)
	gameModeNameWidget:setTopBottom(true, false, 3, 3)
	gameModeNameWidget:setAlpha(0)
	safeArea:addElement(gameModeNameWidget)

	local gameModeNameText = LUI.UIText.new()
	gameModeNameText:setLeftRight(true, true, 0, 0)
	gameModeNameText:setTopBottom(true, false, 0, CoD.textSize.ExtraSmall)
	gameModeNameText:setFont(CoD.fonts.Big)
	gameModeNameText:setAlignment(LUI.Alignment.Center)
	gameModeNameWidget:addElement(gameModeNameText)
	gameModeNameWidget.gameModeNameText = gameModeNameText

	gameModeNameWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.GameModeNameArea.UpdateVisibility)
	gameModeNameWidget:registerEventHandler("hud_update_game_mode_name", CoD.Reimagined.GameModeNameArea.UpdateGameModeName)

	local gameModeScoreWidget = LUI.UIElement.new()
	gameModeScoreWidget:setLeftRight(true, true, 0, 0)
	gameModeScoreWidget:setTopBottom(true, false, 26, 26)
	gameModeScoreWidget:setAlpha(0)
	gameModeScoreWidget.iconSize = 42
	safeArea:addElement(gameModeScoreWidget)

	local gameModeScoreFriendlyIcon = LUI.UIImage.new()
	gameModeScoreFriendlyIcon:setLeftRight(false, false, -105 - (gameModeScoreWidget.iconSize / 2), -105 + (gameModeScoreWidget.iconSize / 2))
	gameModeScoreFriendlyIcon:setTopBottom(true, false, 0, gameModeScoreWidget.iconSize)
	gameModeScoreFriendlyIcon:setAlpha(0)
	gameModeScoreWidget:addElement(gameModeScoreFriendlyIcon)
	gameModeScoreWidget.gameModeScoreFriendlyIcon = gameModeScoreFriendlyIcon

	local gameModeScoreEnemyIcon = LUI.UIImage.new()
	gameModeScoreEnemyIcon:setLeftRight(false, false, 105 - (gameModeScoreWidget.iconSize / 2), 105 + (gameModeScoreWidget.iconSize / 2))
	gameModeScoreEnemyIcon:setTopBottom(true, false, 0, gameModeScoreWidget.iconSize)
	gameModeScoreEnemyIcon:setAlpha(0)
	gameModeScoreWidget:addElement(gameModeScoreEnemyIcon)
	gameModeScoreWidget.gameModeScoreEnemyIcon = gameModeScoreEnemyIcon

	local gameModeScoreFriendlyText = LUI.UIText.new()
	gameModeScoreFriendlyText:setLeftRight(true, true, -40, -40)
	gameModeScoreFriendlyText:setTopBottom(true, false, -10, -10 + CoD.textSize.Morris)
	gameModeScoreFriendlyText:setFont(CoD.fonts.Morris)
	gameModeScoreFriendlyText:setAlignment(LUI.Alignment.Center)
	gameModeScoreFriendlyText:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
	gameModeScoreWidget:addElement(gameModeScoreFriendlyText)
	gameModeScoreWidget.gameModeScoreFriendlyText = gameModeScoreFriendlyText

	local gameModeScoreEnemyText = LUI.UIText.new()
	gameModeScoreEnemyText:setLeftRight(true, true, 40, 40)
	gameModeScoreEnemyText:setTopBottom(true, false, -10, -10 + CoD.textSize.Morris)
	gameModeScoreEnemyText:setFont(CoD.fonts.Morris)
	gameModeScoreEnemyText:setAlignment(LUI.Alignment.Center)
	gameModeScoreEnemyText:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
	gameModeScoreWidget:addElement(gameModeScoreEnemyText)
	gameModeScoreWidget.gameModeScoreEnemyText = gameModeScoreEnemyText

	gameModeScoreWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.GameModeScoreArea.UpdateVisibility)
	gameModeScoreWidget:registerEventHandler("hud_update_team_change", CoD.Reimagined.GameModeScoreArea.UpdateTeamChange)
	gameModeScoreWidget:registerEventHandler("hud_update_scores", CoD.Reimagined.GameModeScoreArea.UpdateScores)

	local gameModeScoreDetailedWidget = LUI.UIElement.new()
	gameModeScoreDetailedWidget:setLeftRight(true, true, 0, 0)
	gameModeScoreDetailedWidget:setTopBottom(true, false, 66, 66)
	gameModeScoreDetailedWidget:setAlpha(0)
	gameModeScoreDetailedWidget.iconSize = 42
	safeArea:addElement(gameModeScoreDetailedWidget)

	local gameModeScoreScoringTeam = LUI.UIImage.new()
	gameModeScoreScoringTeam.iconSize = 28
	gameModeScoreScoringTeam:setLeftRight(false, false, 0 - (gameModeScoreScoringTeam.iconSize / 2), 0 + (gameModeScoreScoringTeam.iconSize / 2))
	gameModeScoreScoringTeam:setTopBottom(true, false, 0, gameModeScoreScoringTeam.iconSize)
	gameModeScoreScoringTeam:setImage(RegisterMaterial("hud_icon_scoring_team"))
	gameModeScoreScoringTeam:setAlpha(0)
	gameModeScoreDetailedWidget:addElement(gameModeScoreScoringTeam)
	gameModeScoreDetailedWidget.gameModeScoreScoringTeam = gameModeScoreScoringTeam

	local gameModeScoreFriendlyPlayerCount = LUI.UIImage.new()
	gameModeScoreFriendlyPlayerCount:setLeftRight(false, false, -40 - (gameModeScoreDetailedWidget.iconSize / 2), -40 + (gameModeScoreDetailedWidget.iconSize / 2))
	gameModeScoreFriendlyPlayerCount:setTopBottom(true, false, 6, 6 + gameModeScoreDetailedWidget.iconSize)
	gameModeScoreFriendlyPlayerCount:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
	gameModeScoreFriendlyPlayerCount:setAlpha(0)
	gameModeScoreDetailedWidget:addElement(gameModeScoreFriendlyPlayerCount)
	gameModeScoreDetailedWidget.gameModeScoreFriendlyPlayerCount = gameModeScoreFriendlyPlayerCount

	local gameModeScoreEnemyPlayerCount = LUI.UIImage.new()
	gameModeScoreEnemyPlayerCount:setLeftRight(false, false, 40 - (gameModeScoreDetailedWidget.iconSize / 2), 40 + (gameModeScoreDetailedWidget.iconSize / 2))
	gameModeScoreEnemyPlayerCount:setTopBottom(true, false, 6, 6 + gameModeScoreDetailedWidget.iconSize)
	gameModeScoreEnemyPlayerCount:setRGB(CoD.RoundStatus.DefaultColor.r, CoD.RoundStatus.DefaultColor.g, CoD.RoundStatus.DefaultColor.b)
	gameModeScoreEnemyPlayerCount:setAlpha(0)
	gameModeScoreDetailedWidget:addElement(gameModeScoreEnemyPlayerCount)
	gameModeScoreDetailedWidget.gameModeScoreEnemyPlayerCount = gameModeScoreEnemyPlayerCount

	gameModeScoreDetailedWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_team_change", CoD.Reimagined.GameModeScoreDetailedArea.UpdateTeamChange)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_scoring_team", CoD.Reimagined.GameModeScoreDetailedArea.UpdateScoringTeam)
	gameModeScoreDetailedWidget:registerEventHandler("hud_update_player_count", CoD.Reimagined.GameModeScoreDetailedArea.UpdatePlayerCount)

	local containmentWidget = LUI.UIElement.new()
	containmentWidget:setLeftRight(true, true, 7, 7)
	containmentWidget:setTopBottom(true, false, 3, 3)
	containmentWidget:setAlpha(0)
	safeArea:addElement(containmentWidget)

	local containmentZoneText = LUI.UIText.new()
	containmentZoneText:setLeftRight(true, true, 0, 0)
	containmentZoneText:setTopBottom(true, false, 0, CoD.textSize.Default)
	containmentZoneText:setFont(CoD.fonts.Big)
	containmentZoneText:setAlignment(LUI.Alignment.Left)
	containmentWidget:addElement(containmentZoneText)
	containmentWidget.containmentZoneText = containmentZoneText

	local containmentTimeText = LUI.UIText.new()
	containmentTimeText:setLeftRight(true, true, 0, 0)
	containmentTimeText:setTopBottom(true, false, 0 + 23, CoD.textSize.Default + 23)
	containmentTimeText:setFont(CoD.fonts.Big)
	containmentTimeText:setAlignment(LUI.Alignment.Left)
	containmentWidget:addElement(containmentTimeText)
	containmentWidget.containmentTimeText = containmentTimeText

	containmentWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.Reimagined.ContainmentArea.UpdateVisibility)
	containmentWidget:registerEventHandler("hud_update_containment_zone", CoD.Reimagined.ContainmentArea.UpdateContainmentZone)
	containmentWidget:registerEventHandler("hud_update_containment_time", CoD.Reimagined.ContainmentArea.UpdateContainmentTime)

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

	if shieldHealthPercent > 0 then
		local shieldHealthWidth = math.max(3, (Menu.width * shieldHealthPercent) - Menu.bgDiff)

		Menu.shieldBar:setAlpha(1)

		Menu.shieldBar:beginAnimation("slide", 50, true, true)
		Menu.shieldBar:setLeftRight(true, false, Menu.bgDiff, shieldHealthWidth)

		Menu.healthBar:setTopBottom(true, false, (Menu.height + Menu.bgDiff) / 2, Menu.height - Menu.bgDiff)
		Menu.healthText:setText(health .. " | " .. shieldHealth)
	else
		Menu.shieldBar:setAlpha(0)

		Menu.healthBar:setTopBottom(true, false, Menu.bgDiff, Menu.height - Menu.bgDiff)
		Menu.healthText:setText(health)
	end

	Menu.healthBar:beginAnimation("slide", 50, true, true)
	Menu.healthBar:setLeftRight(true, false, Menu.bgDiff, healthWidth)
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

CoD.Reimagined.QuestTimerArea = {}
CoD.Reimagined.QuestTimerArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and (UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 or UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 1) and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.QuestTimerArea.UpdateQuestTimer = function(Menu, ClientInstance)
	local timeNum = ClientInstance.data[1]
	local time = CoD.Reimagined.ConvertNumToTime(timeNum)

	Menu.questTimerText:setText(Engine.Localize("ZOMBIE_HUD_QUEST_COMPLETE_TIME") .. time)
end

CoD.Reimagined.QuestTimerArea.FadeOutQuestTimer = function(Menu, ClientInstance)
	if ClientInstance.data ~= nil then
		Menu.questTimerText:animateToState("fade_out", ClientInstance.data[1])
	else
		Menu.questTimerText:animateToState("fade_out")
	end
end

CoD.Reimagined.QuestTimerArea.FadeInQuestTimer = function(Menu, ClientInstance)
	if ClientInstance.data ~= nil then
		Menu.questTimerText:animateToState("fade_in", ClientInstance.data[1])
	else
		Menu.questTimerText:animateToState("fade_in")
	end
end

CoD.Reimagined.GameModeNameArea = {}
CoD.Reimagined.GameModeNameArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_game_mode_name") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.GameModeNameArea.UpdateGameModeName = function(Menu, ClientInstance)
	local gameModeNameName = Engine.Localize(Engine.GetIString(ClientInstance.data[1], "CS_LOCALIZED_STRINGS"))

	Menu.gameModeNameText:setText(gameModeNameName)
end

CoD.Reimagined.GameModeScoreArea = {}
CoD.Reimagined.GameModeScoreArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_game_mode_score") ~= 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.GameModeScoreArea.UpdateTeamChange = function(Menu, ClientInstance)
	if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		return
	end

	if Menu.team ~= ClientInstance.team then
		Menu.team = ClientInstance.team
		local FactionTeam = Engine.GetFactionForTeam(ClientInstance.team)
		local EnemyFactionTeam = Engine.GetFactionForTeam(CoD.Reimagined.GetOtherTeam(ClientInstance.team))

		if Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZTURNED then
			if ClientInstance.team == CoD.TEAM_AXIS then
				FactionTeam = "zombie"
			else
				EnemyFactionTeam = "zombie"
			end
		end

		if FactionTeam ~= "" then
			Menu.gameModeScoreFriendlyIcon:setImage(RegisterMaterial("faction_" .. FactionTeam))
			Menu.gameModeScoreFriendlyIcon:setAlpha(1)
			Menu.gameModeScoreEnemyIcon:setImage(RegisterMaterial("faction_" .. EnemyFactionTeam))
			Menu.gameModeScoreEnemyIcon:setAlpha(1)

			if Menu.yourScore ~= nil and Menu.enemyScore ~= nil then
				Menu.yourScore, Menu.enemyScore = Menu.enemyScore, Menu.yourScore

				CoD.Reimagined.GameModeScoreArea.UpdateScores(Menu, ClientInstance)
			end
		else
			Menu.gameModeScoreFriendlyIcon:setAlpha(0)
			Menu.gameModeScoreEnemyIcon:setAlpha(0)
		end
	end
end

CoD.Reimagined.GameModeScoreArea.UpdateScores = function(Menu, ClientInstance)
	if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		return
	end

	if ClientInstance.name ~= "hud_update_team_change" then
		Menu.yourScore = ClientInstance.yourScore
		Menu.enemyScore = ClientInstance.enemyScore
	end

	Menu.gameModeScoreFriendlyText:setText(Menu.yourScore)
	Menu.gameModeScoreEnemyText:setText(Menu.enemyScore)
end

CoD.Reimagined.GameModeScoreDetailedArea = {}
CoD.Reimagined.GameModeScoreDetailedArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_game_mode_score") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.GameModeScoreDetailedArea.UpdateTeamChange = function(Menu, ClientInstance)
	if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		return
	end

	if Menu.team ~= ClientInstance.team then
		Menu.team = ClientInstance.team
		local FactionTeam = Engine.GetFactionForTeam(ClientInstance.team)
		local EnemyFactionTeam = Engine.GetFactionForTeam(CoD.Reimagined.GetOtherTeam(ClientInstance.team))
		if FactionTeam ~= "" then
			if Menu.scoringTeam ~= nil then
				if Menu.scoringTeam == 1 then
					Menu.scoringTeam = 2
				elseif Menu.scoringTeam == 2 then
					Menu.scoringTeam = 1
				end

				CoD.Reimagined.GameModeScoreDetailedArea.UpdateScoringTeam(Menu, ClientInstance)
			end

			if Menu.yourPlayerCount ~= nil and Menu.enemyPlayerCount ~= nil then
				Menu.yourPlayerCount, Menu.enemyPlayerCount = Menu.enemyPlayerCount, Menu.yourPlayerCount

				CoD.Reimagined.GameModeScoreDetailedArea.UpdatePlayerCount(Menu, ClientInstance)
			end
		end
	end
end

CoD.Reimagined.GameModeScoreDetailedArea.UpdateScoringTeam = function(Menu, ClientInstance)
	if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		return
	end

	if ClientInstance.name ~= "hud_update_team_change" then
		if ClientInstance.data ~= nil then
			Menu.scoringTeam = ClientInstance.data[1]
		else
			Menu.scoringTeam = nil
		end
	end

	if Menu.scoringTeam == nil then
		Menu.gameModeScoreScoringTeam:setAlpha(0)
		return
	end

	if Menu.scoringTeam == 0 then
		Menu.gameModeScoreScoringTeam:setRGB(1, 1, 1)
		Menu.gameModeScoreScoringTeam:setAlpha(1)

		Menu.gameModeScoreScoringTeam:beginAnimation("slide", 250, true, true)
		Menu.gameModeScoreScoringTeam:setLeftRight(false, false, 0 - (Menu.gameModeScoreScoringTeam.iconSize / 2), 0 + (Menu.gameModeScoreScoringTeam.iconSize / 2))
	elseif Menu.scoringTeam == 1 then
		Menu.gameModeScoreScoringTeam:setRGB(0, 1, 0)
		Menu.gameModeScoreScoringTeam:setAlpha(1)

		Menu.gameModeScoreScoringTeam:beginAnimation("slide", 250, true, true)
		Menu.gameModeScoreScoringTeam:setLeftRight(false, false, -105 - (Menu.gameModeScoreScoringTeam.iconSize / 2), -105 + (Menu.gameModeScoreScoringTeam.iconSize / 2))
	elseif Menu.scoringTeam == 2 then
		Menu.gameModeScoreScoringTeam:setRGB(1, 0, 0)
		Menu.gameModeScoreScoringTeam:setAlpha(1)

		Menu.gameModeScoreScoringTeam:beginAnimation("slide", 250, true, true)
		Menu.gameModeScoreScoringTeam:setLeftRight(false, false, 105 - (Menu.gameModeScoreScoringTeam.iconSize / 2), 105 + (Menu.gameModeScoreScoringTeam.iconSize / 2))
	elseif Menu.scoringTeam == 3 then
		Menu.gameModeScoreScoringTeam:setRGB(1, 1, 0)
		Menu.gameModeScoreScoringTeam:setAlpha(1)

		Menu.gameModeScoreScoringTeam:beginAnimation("slide", 250, true, true)
		Menu.gameModeScoreScoringTeam:setLeftRight(false, false, 0 - (Menu.gameModeScoreScoringTeam.iconSize / 2), 0 + (Menu.gameModeScoreScoringTeam.iconSize / 2))
	elseif Menu.scoringTeam == 4 then
		Menu.gameModeScoreScoringTeam:setRGB(0.5, 0.5, 0.5)
		Menu.gameModeScoreScoringTeam:setAlpha(0.5)

		Menu.gameModeScoreScoringTeam:beginAnimation("slide", 250, true, true)
		Menu.gameModeScoreScoringTeam:setLeftRight(false, false, 0 - (Menu.gameModeScoreScoringTeam.iconSize / 2), 0 + (Menu.gameModeScoreScoringTeam.iconSize / 2))
	else
		Menu.gameModeScoreScoringTeam:setAlpha(0)
	end
end

CoD.Reimagined.GameModeScoreDetailedArea.UpdatePlayerCount = function(Menu, ClientInstance)
	if UIExpression.DvarString(nil, "ui_zm_gamemodegroup") ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		return
	end

	local prevYourPlayerCount = Menu.yourPlayerCount or 0
	local prevEnemyPlayerCount = Menu.enemyPlayerCount or 0

	if ClientInstance.name ~= "hud_update_team_change" then
		if ClientInstance.data ~= nil then
			Menu.yourPlayerCount = ClientInstance.data[1]
			Menu.enemyPlayerCount = ClientInstance.data[2]
		else
			Menu.yourPlayerCount = nil
			Menu.enemyPlayerCount = nil
		end
	end

	if Menu.yourPlayerCount == nil or Menu.enemyPlayerCount == nil then
		Menu.gameModeScoreFriendlyPlayerCount:setAlpha(0)
		Menu.gameModeScoreEnemyPlayerCount:setAlpha(0)
		return
	end

	if Menu.yourPlayerCount > 0 then
		local offset = (4 - Menu.yourPlayerCount) * (Menu.iconSize / 8)

		Menu.gameModeScoreFriendlyPlayerCount:setImage(RegisterMaterial("chalkmarks_hellcatraz_" .. Menu.yourPlayerCount))
		Menu.gameModeScoreFriendlyPlayerCount:setAlpha(1)

		if prevYourPlayerCount > 0 then
			Menu.gameModeScoreFriendlyPlayerCount:beginAnimation("slide", 250, true, true)
		end

		Menu.gameModeScoreFriendlyPlayerCount:setLeftRight(false, false, -40 + offset - (Menu.iconSize / 2), -40 + offset + (Menu.iconSize / 2))
	else
		Menu.gameModeScoreFriendlyPlayerCount:setAlpha(0)
	end

	if Menu.enemyPlayerCount > 0 then
		local offset = (4 - Menu.enemyPlayerCount) * (Menu.iconSize / 8)

		Menu.gameModeScoreEnemyPlayerCount:setImage(RegisterMaterial("chalkmarks_hellcatraz_" .. Menu.enemyPlayerCount))
		Menu.gameModeScoreEnemyPlayerCount:setAlpha(1)

		if prevEnemyPlayerCount > 0 then
			Menu.gameModeScoreEnemyPlayerCount:beginAnimation("slide", 250, true, true)
		end

		Menu.gameModeScoreEnemyPlayerCount:setLeftRight(false, false, 40 + offset - (Menu.iconSize / 2), 40 + offset + (Menu.iconSize / 2))
	else
		Menu.gameModeScoreEnemyPlayerCount:setAlpha(0)
	end
end

CoD.Reimagined.ContainmentArea = {}
CoD.Reimagined.ContainmentArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_containment") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and (UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 or UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 1) and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.Reimagined.ContainmentArea.UpdateContainmentZone = function(Menu, ClientInstance)
	local zoneName = Engine.Localize(Engine.GetIString(ClientInstance.data[1], "CS_LOCALIZED_STRINGS"))

	Menu.containmentZoneText:setText(Engine.Localize("ZOMBIE_HUD_CONTAINMENT_ZONE") .. zoneName)
end

CoD.Reimagined.ContainmentArea.UpdateContainmentTime = function(Menu, ClientInstance)
	local timeNum = ClientInstance.data[1]
	local time = ""

	if timeNum >= 0 then
		time = CoD.Reimagined.ConvertNumToTime(timeNum)
	end

	Menu.containmentTimeText:setText(Engine.Localize("ZOMBIE_HUD_CONTAINMENT_TIME") .. time)
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

CoD.Reimagined.GetOtherTeam = function(team)
	if team == CoD.TEAM_ALLIES then
		return CoD.TEAM_AXIS
	elseif team == CoD.TEAM_AXIS then
		return CoD.TEAM_ALLIES
	end

	return team
end
