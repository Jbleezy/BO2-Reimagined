CoD.Reimagined = {}

LUI.createMenu.ReimaginedArea = function(LocalClientIndex)
	local safeArea = CoD.Menu.NewSafeAreaFromState("ReimaginedArea", LocalClientIndex)
	safeArea:setOwner(LocalClientIndex)

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
	zoneNameWidget.width = width
	zoneNameWidget.height = height
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
	zoneNameText:animateToState("fade_in")
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

CoD.Reimagined.HealthBarArea = {}
CoD.Reimagined.HealthBarArea.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f2_local0, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
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
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
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
	Menu.zoneNameText:animateToState("fade_out", 250)
end

CoD.Reimagined.ZoneNameArea.FadeInZoneName = function(Menu, ClientInstance)
	Menu.zoneNameText:animateToState("fade_in", 250)
end
