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
	healthBarWidget.width = width
	healthBarWidget.height = height
	healthBarWidget.bgDiff = bgDiff
	safeArea:addElement(healthBarWidget)

	local healthBarBg = LUI.UIImage.new()
	healthBarBg:setLeftRight(true, false, 0, 0 + width)
	healthBarBg:setTopBottom(false, true, 0, 0 + height)
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
	healthText:setTopBottom(false, true, 0 - bgDiff, height + bgDiff)
	healthText:setFont(CoD.fonts.Condensed)
	healthText:setAlignment(LUI.Alignment.Left)
	healthBarWidget:addElement(healthText)
	healthBarWidget.healthText = healthText

	healthBarWidget:registerEventHandler("hud_update_refresh", CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.Reimagined.HealthBarArea.UpdateVisibility)
	healthBarWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.Perks.UpdateVisibility)
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
	healthBarWidget:registerEventHandler("hud_update_health", CoD.Reimagined.HealthBarArea.UpdateHealthBar)

	healthBarWidget.visible = true

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

	Menu.healthBar:setLeftRight(true, false, Menu.bgDiff, (Menu.width * healthPercent) - Menu.bgDiff)

	if shieldHealthPercent > 0 then
		Menu.shieldBar:setAlpha(1)
		Menu.shieldBar:setLeftRight(true, false, Menu.bgDiff, (Menu.width * shieldHealthPercent) - Menu.bgDiff)
		Menu.healthBar:setTopBottom(true, false, (Menu.height + Menu.bgDiff) / 2, Menu.height - Menu.bgDiff)
		Menu.healthText:setText(health .. " | " .. shieldHealth)
	else
		Menu.shieldBar:setAlpha(0)
		Menu.healthBar:setTopBottom(true, false, Menu.bgDiff, Menu.height - Menu.bgDiff)
		Menu.healthText:setText(health)
	end
end
