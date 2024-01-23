CoD.PowerUps = {}
CoD.PowerUps.IconSize = 48
CoD.PowerUps.UpgradeIconSize = 36
CoD.PowerUps.EnemyIconSize = 48
CoD.PowerUps.Spacing = 8
CoD.PowerUps.STATE_OFF = 0
CoD.PowerUps.STATE_ON = 1
CoD.PowerUps.STATE_FLASHING_OFF = 2
CoD.PowerUps.STATE_FLASHING_ON = 3
CoD.PowerUps.FLASHING_STAGE_DURATION = 500
CoD.PowerUps.MOVING_DURATION = 500
CoD.PowerUps.UpGradeIconColorRed = {
	r = 1,
	g = 0,
	b = 0,
}
CoD.PowerUps.EnemyIconColorRed = {
	r = 0.21,
	g = 0,
	b = 0,
}
CoD.PowerUps.ClientFieldNames = {}
CoD.PowerUps.ClientFieldNames[1] = {
	clientFieldName = "powerup_instant_kill",
	material = RegisterMaterial("specialty_instakill_zombies"),
}
CoD.PowerUps.ClientFieldNames[2] = {
	clientFieldName = "powerup_double_points",
	material = RegisterMaterial("specialty_doublepoints_zombies"),
	z_material = RegisterMaterial("specialty_doublepoints_zombies_blue"),
}
CoD.PowerUps.ClientFieldNames[3] = {
	clientFieldName = "powerup_fire_sale",
	material = RegisterMaterial("specialty_firesale_zombies"),
}
CoD.PowerUps.ClientFieldNames[4] = {
	clientFieldName = "powerup_bon_fire",
	material = RegisterMaterial("zom_icon_bonfire"),
}
CoD.PowerUps.ClientFieldNames[5] = {
	clientFieldName = "powerup_mini_gun",
	material = RegisterMaterial("zom_icon_minigun"),
}
CoD.PowerUps.ClientFieldNames[6] = {
	clientFieldName = "powerup_zombie_blood",
	material = RegisterMaterial("specialty_zomblood_zombies"),
}
CoD.PowerUps.UpgradeClientFieldNames = {}
CoD.PowerUps.UpgradeClientFieldNames[1] = {
	clientFieldName = CoD.PowerUps.ClientFieldNames[1].clientFieldName .. "_ug",
	material = RegisterMaterial("specialty_instakill_zombies"),
	color = CoD.PowerUps.UpGradeIconColorRed,
}
CoD.PowerUps.EnemyClientFieldNames = {}
CoD.PowerUps.EnemyClientFieldNames[1] = {
	clientFieldName = CoD.PowerUps.ClientFieldNames[1].clientFieldName .. "_enemy",
	material = RegisterMaterial("specialty_instakill_zombies"),
	color = CoD.PowerUps.EnemyIconColorRed,
}
CoD.PowerUps.EnemyClientFieldNames[2] = {
	clientFieldName = CoD.PowerUps.ClientFieldNames[2].clientFieldName .. "_enemy",
	material = RegisterMaterial("specialty_doublepoints_zombies"),
	color = CoD.PowerUps.EnemyIconColorRed,
}
LUI.createMenu.PowerUpsArea = function(LocalClientIndex)
	local PowerupsAreaWidget = CoD.Menu.NewSafeAreaFromState("PowerUpsArea", LocalClientIndex)
	PowerupsAreaWidget:setOwner(LocalClientIndex)
	PowerupsAreaWidget.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	PowerupsAreaWidget.scaleContainer:setLeftRight(false, false, 0, 0)
	PowerupsAreaWidget.scaleContainer:setTopBottom(false, true, 0, 0)
	PowerupsAreaWidget:addElement(PowerupsAreaWidget.scaleContainer)
	local f1_local1 = CoD.PowerUps.IconSize * 0.5
	local f1_local2 = CoD.PowerUps.IconSize + CoD.PowerUps.UpgradeIconSize + 10
	local Widget = nil

	PowerupsAreaWidget.powerUps = {}
	for ClientFieldIndex = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		Widget = LUI.UIElement.new()
		Widget:setLeftRight(false, false, -f1_local1, f1_local1)
		Widget:setTopBottom(false, true, -f1_local2, 0)
		Widget:registerEventHandler("transition_complete_off_fade_out", CoD.PowerUps.PowerUpIcon_UpdatePosition)

		local powerUpIcon = LUI.UIImage.new()
		powerUpIcon:setLeftRight(true, true, 0, 0)
		powerUpIcon:setTopBottom(false, true, -CoD.PowerUps.IconSize, 0)
		powerUpIcon:setAlpha(0)
		Widget:addElement(powerUpIcon)
		Widget.powerUpIcon = powerUpIcon

		local upgradePowerUpIcon = LUI.UIImage.new()
		upgradePowerUpIcon:setLeftRight(false, false, -CoD.PowerUps.UpgradeIconSize / 2, CoD.PowerUps.UpgradeIconSize / 2)
		upgradePowerUpIcon:setTopBottom(true, false, 0, CoD.PowerUps.UpgradeIconSize)
		upgradePowerUpIcon:setAlpha(0)
		Widget:addElement(upgradePowerUpIcon)
		Widget.upgradePowerUpIcon = upgradePowerUpIcon

		Widget.powerupId = nil
		PowerupsAreaWidget.scaleContainer:addElement(Widget)
		PowerupsAreaWidget.powerUps[ClientFieldIndex] = Widget
		PowerupsAreaWidget:registerEventHandler(CoD.PowerUps.ClientFieldNames[ClientFieldIndex].clientFieldName, CoD.PowerUps.Update)
		PowerupsAreaWidget:registerEventHandler(CoD.PowerUps.ClientFieldNames[ClientFieldIndex].clientFieldName .. "_ug", CoD.PowerUps.UpgradeUpdate)
	end

	PowerupsAreaWidget.enemyPowerUps = {}
	for ClientFieldIndex = 1, #CoD.PowerUps.EnemyClientFieldNames, 1 do
		Widget = LUI.UIElement.new()
		Widget:setLeftRight(false, false, -f1_local1, f1_local1)
		Widget:setTopBottom(false, true, -f1_local2, 0)
		Widget:registerEventHandler("transition_complete_off_fade_out", CoD.PowerUps.PowerUpIcon_UpdatePosition)

		local enemyPowerUpIcon = LUI.UIImage.new()
		enemyPowerUpIcon:setLeftRight(false, false, -CoD.PowerUps.EnemyIconSize / 2, CoD.PowerUps.EnemyIconSize / 2)
		enemyPowerUpIcon:setTopBottom(true, false, 0 - CoD.PowerUps.Spacing, CoD.PowerUps.EnemyIconSize - CoD.PowerUps.Spacing)
		enemyPowerUpIcon:setAlpha(0)
		Widget:addElement(enemyPowerUpIcon)
		Widget.enemyPowerUpIcon = enemyPowerUpIcon

		Widget.powerupId = nil
		PowerupsAreaWidget.scaleContainer:addElement(Widget)
		PowerupsAreaWidget.enemyPowerUps[ClientFieldIndex] = Widget
		PowerupsAreaWidget:registerEventHandler(CoD.PowerUps.EnemyClientFieldNames[ClientFieldIndex].clientFieldName, CoD.PowerUps.EnemyUpdate)
	end

	PowerupsAreaWidget.activePowerUpCount = 0
	PowerupsAreaWidget.activeEnemyPowerUpCount = 0
	PowerupsAreaWidget:registerEventHandler("hud_update_refresh", CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PowerUps.UpdateVisibility)
	PowerupsAreaWidget:registerEventHandler("powerups_update_position", CoD.PowerUps.UpdatePosition)
	PowerupsAreaWidget.visible = true
	return PowerupsAreaWidget
end

CoD.PowerUps.UpdateVisibility = function(Menu, ClientInstance)
	local LocalClientIndex = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_SCOREBOARD_OPEN) == 0 and (not CoD.IsShoutcaster(LocalClientIndex) or CoD.ExeProfileVarBool(LocalClientIndex, "shoutcaster_teamscore")) and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IS_FLASH_BANGED) == 0 then
		if not Menu.visible then
			Menu:setAlpha(1)
			Menu.visible = true
		end
	elseif Menu.visible then
		Menu:setAlpha(0)
		Menu.visible = nil
	end
end

CoD.PowerUps.Update = function(Menu, ClientInstance)
	CoD.PowerUps.UpdateState(Menu, ClientInstance)
	CoD.PowerUps.UpdatePosition(Menu, ClientInstance)
end

CoD.PowerUps.UpdateState = function(Menu, ClientInstance)
	local PowerUpWidget = nil
	local ExistingPowerUpIndex = CoD.PowerUps.GetExistingPowerUpIndex(Menu, ClientInstance.name)
	if ExistingPowerUpIndex ~= nil then
		PowerUpWidget = Menu.powerUps[ExistingPowerUpIndex]
		if ClientInstance.newValue == CoD.PowerUps.STATE_ON then
			PowerUpWidget.powerUpId = ClientInstance.name
			PowerUpWidget.powerUpIcon:setImage(CoD.PowerUps.GetMaterial(Menu, ClientInstance.controller, ClientInstance.name))
			PowerUpWidget.powerUpIcon:setAlpha(1)
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_OFF then
			PowerUpWidget.powerUpIcon:beginAnimation("off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidget.powerUpIcon:setAlpha(0)
			PowerUpWidget.upgradePowerUpIcon:beginAnimation("off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidget.upgradePowerUpIcon:setAlpha(0)
			PowerUpWidget.powerUpId = nil
			Menu.activePowerUpCount = Menu.activePowerUpCount - 1
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_OFF then
			PowerUpWidget.powerUpIcon:beginAnimation("fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidget.powerUpIcon:setAlpha(0)
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_ON then
			PowerUpWidget.powerUpIcon:beginAnimation("fade_in", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidget.powerUpIcon:setAlpha(1)
		end
	elseif ClientInstance.newValue == CoD.PowerUps.STATE_ON or ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_ON then
		local f4_local2 = CoD.PowerUps.GetFirstAvailablePowerUpIndex(Menu)
		if f4_local2 ~= nil then
			PowerUpWidget = Menu.powerUps[f4_local2]
			PowerUpWidget.powerUpId = ClientInstance.name
			PowerUpWidget.powerUpIcon:setImage(CoD.PowerUps.GetMaterial(Menu, ClientInstance.controller, ClientInstance.name))
			PowerUpWidget.powerUpIcon:setAlpha(1)
			Menu.activePowerUpCount = Menu.activePowerUpCount + 1
		end
	end
end

CoD.PowerUps.UpgradeUpdate = function(Menu, ClientInstance)
	CoD.PowerUps.UpgradeUpdateState(Menu, ClientInstance)
end

CoD.PowerUps.UpgradeUpdateState = function(Menu, ClientInstance)
	local PowerUpWidgetIcon = nil
	local ExistingPowerUpIndex = CoD.PowerUps.GetExistingPowerUpIndex(Menu, string.sub(ClientInstance.name, 0, -4))
	if ExistingPowerUpIndex ~= nil then
		PowerUpWidgetIcon = Menu.powerUps[ExistingPowerUpIndex].upgradePowerUpIcon
		if ClientInstance.newValue == CoD.PowerUps.STATE_ON then
			PowerUpWidgetIcon:setImage(CoD.PowerUps.GetUpgradeMaterial(Menu, ClientInstance.name))
			PowerUpWidgetIcon:setAlpha(1)
			CoD.PowerUps.SetUpgradeColor(PowerUpWidgetIcon, ClientInstance.name)
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_OFF then
			PowerUpWidgetIcon:beginAnimation("off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidgetIcon:setAlpha(0)
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_OFF then
			PowerUpWidgetIcon:beginAnimation("fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidgetIcon:setAlpha(0)
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_ON then
			PowerUpWidgetIcon:beginAnimation("fade_in", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidgetIcon:setAlpha(1)
		end
	end
end

CoD.PowerUps.EnemyUpdate = function(Menu, ClientInstance)
	CoD.PowerUps.EnemyUpdateState(Menu, ClientInstance)
	CoD.PowerUps.EnemyUpdatePosition(Menu, ClientInstance)
end

CoD.PowerUps.EnemyUpdateState = function(Menu, ClientInstance)
	local PowerUpWidget = nil
	local ExistingPowerUpIndex = CoD.PowerUps.GetExistingEnemyPowerUpIndex(Menu, ClientInstance.name)
	if ExistingPowerUpIndex ~= nil then
		PowerUpWidget = Menu.enemyPowerUps[ExistingPowerUpIndex]
		if ClientInstance.newValue == CoD.PowerUps.STATE_ON then
			PowerUpWidget.powerupId = ClientInstance.name
			PowerUpWidget.enemyPowerUpIcon:setImage(CoD.PowerUps.GetEnemyMaterial(Menu, ClientInstance.controller, ClientInstance.name))
			PowerUpWidget.enemyPowerUpIcon:setAlpha(1)
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_OFF then
			PowerUpWidget.enemyPowerUpIcon:beginAnimation("off_fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidget.enemyPowerUpIcon:setAlpha(0)
			PowerUpWidget.powerupId = nil
			Menu.activeEnemyPowerUpCount = Menu.activeEnemyPowerUpCount - 1
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_OFF then
			PowerUpWidget.enemyPowerUpIcon:beginAnimation("fade_out", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidget.enemyPowerUpIcon:setAlpha(0)
		elseif ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_ON then
			PowerUpWidget.enemyPowerUpIcon:beginAnimation("fade_in", CoD.PowerUps.FLASHING_STAGE_DURATION)
			PowerUpWidget.enemyPowerUpIcon:setAlpha(1)
		end
	elseif ClientInstance.newValue == CoD.PowerUps.STATE_ON or ClientInstance.newValue == CoD.PowerUps.STATE_FLASHING_ON then
		local f4_local2 = CoD.PowerUps.GetFirstAvailableEnemyPowerUpIndex(Menu)
		if f4_local2 ~= nil then
			PowerUpWidget = Menu.enemyPowerUps[f4_local2]
			PowerUpWidget.powerupId = ClientInstance.name
			PowerUpWidget.enemyPowerUpIcon:setImage(CoD.PowerUps.GetEnemyMaterial(Menu, ClientInstance.controller, ClientInstance.name))
			PowerUpWidget.enemyPowerUpIcon:setAlpha(1)
			CoD.PowerUps.SetEnemyColor(PowerUpWidget.enemyPowerUpIcon, ClientInstance.name)
			Menu.activeEnemyPowerUpCount = Menu.activeEnemyPowerUpCount + 1
		end
	end
end

CoD.PowerUps.GetMaterial = function(Menu, LocalClientIndex, ClientFieldName)
	local f7_local0 = nil
	for f7_local1 = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if CoD.PowerUps.ClientFieldNames[f7_local1].clientFieldName == ClientFieldName then
			f7_local0 = CoD.PowerUps.ClientFieldNames[f7_local1].material
			if UIExpression.IsVisibilityBitSet(LocalClientIndex, CoD.BIT_IS_PLAYER_ZOMBIE) == 1 and CoD.PowerUps.ClientFieldNames[f7_local1].z_material then
				f7_local0 = CoD.PowerUps.ClientFieldNames[f7_local1].z_material
				break
			end
		end
	end
	return f7_local0
end

CoD.PowerUps.GetUpgradeMaterial = function(Menu, ClientFieldName)
	local f8_local0 = nil
	for PowerUpIndex = 1, #CoD.PowerUps.UpgradeClientFieldNames, 1 do
		if CoD.PowerUps.UpgradeClientFieldNames[PowerUpIndex].clientFieldName == ClientFieldName then
			f8_local0 = CoD.PowerUps.UpgradeClientFieldNames[PowerUpIndex].material
			break
		end
	end
	return f8_local0
end

CoD.PowerUps.GetEnemyMaterial = function(Menu, LocalClientIndex, ClientFieldName)
	local f8_local0 = nil
	for PowerUpIndex = 1, #CoD.PowerUps.EnemyClientFieldNames, 1 do
		if CoD.PowerUps.EnemyClientFieldNames[PowerUpIndex].clientFieldName == ClientFieldName then
			f8_local0 = CoD.PowerUps.EnemyClientFieldNames[PowerUpIndex].material
			break
		end
	end
	return f8_local0
end

CoD.PowerUps.SetUpgradeColor = function(Menu, ClientFieldName)
	local f9_local0 = nil
	for PowerUpIndex = 1, #CoD.PowerUps.UpgradeClientFieldNames, 1 do
		if CoD.PowerUps.UpgradeClientFieldNames[PowerUpIndex].clientFieldName == ClientFieldName then
			if CoD.PowerUps.UpgradeClientFieldNames[PowerUpIndex].color then
				Menu:setRGB(CoD.PowerUps.UpgradeClientFieldNames[PowerUpIndex].color.r, CoD.PowerUps.UpgradeClientFieldNames[PowerUpIndex].color.g, CoD.PowerUps.UpgradeClientFieldNames[PowerUpIndex].color.b)
				break
			end
		end
	end
end

CoD.PowerUps.SetEnemyColor = function(Menu, ClientFieldName)
	local f9_local0 = nil
	for PowerUpIndex = 1, #CoD.PowerUps.EnemyClientFieldNames, 1 do
		if CoD.PowerUps.EnemyClientFieldNames[PowerUpIndex].clientFieldName == ClientFieldName then
			if CoD.PowerUps.EnemyClientFieldNames[PowerUpIndex].color then
				Menu:setRGB(CoD.PowerUps.EnemyClientFieldNames[PowerUpIndex].color.r, CoD.PowerUps.EnemyClientFieldNames[PowerUpIndex].color.g, CoD.PowerUps.EnemyClientFieldNames[PowerUpIndex].color.b)
				break
			end
		end
	end
end

CoD.PowerUps.GetExistingPowerUpIndex = function(Menu, PowerUpId)
	for PowerUpIndex = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if Menu.powerUps[PowerUpIndex].powerUpId == PowerUpId then
			return PowerUpIndex
		end
	end
	return nil
end

CoD.PowerUps.GetExistingEnemyPowerUpIndex = function(Menu, PowerUpId)
	for PowerUpIndex = 1, #CoD.PowerUps.EnemyClientFieldNames, 1 do
		if Menu.enemyPowerUps[PowerUpIndex].powerupId == PowerUpId then
			return PowerUpIndex
		end
	end
	return nil
end

CoD.PowerUps.GetFirstAvailablePowerUpIndex = function(Menu)
	for PowerUpIndex = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		if not Menu.powerUps[PowerUpIndex].powerUpId then
			return PowerUpIndex
		end
	end
	return nil
end

CoD.PowerUps.GetFirstAvailableEnemyPowerUpIndex = function(Menu)
	for PowerUpIndex = 1, #CoD.PowerUps.EnemyClientFieldNames, 1 do
		if not Menu.enemyPowerUps[PowerUpIndex].powerupId then
			return PowerUpIndex
		end
	end
	return nil
end

CoD.PowerUps.PowerUpIcon_UpdatePosition = function(Menu, ClientInstance)
	if ClientInstance.interrupted ~= true then
		Menu:dispatchEventToParent({
			name = "powerups_update_position",
		})
	end
end

CoD.PowerUps.UpdatePosition = function(Menu, ClientInstance)
	local PowerUpWidget = nil
	local f13_local1 = 0
	local f13_local2 = 0
	local f13_local3 = nil
	for PowerUpIndex = 1, #CoD.PowerUps.ClientFieldNames, 1 do
		PowerUpWidget = Menu.powerUps[PowerUpIndex]
		if PowerUpWidget.powerUpId ~= nil then
			if not f13_local3 then
				f13_local1 = -(CoD.PowerUps.IconSize * 0.5 * Menu.activePowerUpCount + CoD.PowerUps.Spacing * 0.5 * (Menu.activePowerUpCount - 1))
			else
				f13_local1 = f13_local3 + CoD.PowerUps.IconSize + CoD.PowerUps.Spacing
			end
			f13_local2 = f13_local1 + CoD.PowerUps.IconSize
			PowerUpWidget:beginAnimation("move", CoD.PowerUps.MOVING_DURATION)
			PowerUpWidget:setLeftRight(false, false, f13_local1, f13_local2)
			f13_local3 = f13_local1
		end
	end
end

CoD.PowerUps.EnemyUpdatePosition = function(Menu, ClientInstance)
	local PowerUpWidget = nil
	local f13_local1 = 0
	local f13_local2 = 0
	local f13_local3 = nil
	for PowerUpIndex = 1, #CoD.PowerUps.EnemyClientFieldNames, 1 do
		PowerUpWidget = Menu.enemyPowerUps[PowerUpIndex]
		if PowerUpWidget.powerupId ~= nil then
			if not f13_local3 then
				f13_local1 = -(CoD.PowerUps.EnemyIconSize * 0.5 * Menu.activeEnemyPowerUpCount + CoD.PowerUps.Spacing * 0.5 * (Menu.activeEnemyPowerUpCount - 1))
			else
				f13_local1 = f13_local3 + CoD.PowerUps.EnemyIconSize + CoD.PowerUps.Spacing
			end
			f13_local2 = f13_local1 + CoD.PowerUps.EnemyIconSize
			PowerUpWidget:beginAnimation("move", CoD.PowerUps.MOVING_DURATION)
			PowerUpWidget:setLeftRight(false, false, f13_local1, f13_local2)
			f13_local3 = f13_local1
		end
	end
end
