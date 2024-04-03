require("T6.HUD.HUDDigit")

if UIExpression.DvarString(nil, "additionalPrimaryWeaponName") == "" then
	Engine.SetDvar("additionalPrimaryWeaponName", "")
end

CoD.AmmoAreaZombie = {}
CoD.AmmoAreaZombie.Right = -28
CoD.AmmoAreaZombie.Bottom = -7
CoD.AmmoAreaZombie.FireRateMaterials = {}
CoD.AmmoAreaZombie.FireRateRight = 0
CoD.AmmoAreaZombie.LowAmmoPulseDuration = 500
CoD.AmmoAreaZombie.WeaponLabelRight = CoD.AmmoAreaZombie.FireRateRight - 15
CoD.AmmoAreaZombie.WeaponLabelRightOffset = 58
CoD.AmmoAreaZombie.WeaponLabelSpacing = -98
CoD.AmmoAreaZombie.WeaponFontName = "Default"
CoD.AmmoAreaZombie.WeaponSelectionDelay = 2000
CoD.AmmoAreaZombie.WeaponSelectionDuration = 100
CoD.AmmoAreaZombie.AttachmentMoveDuration = 200
CoD.AmmoAreaZombie.StencilRightOffset = -45
CoD.AmmoAreaZombie.CircleSize = 128
CoD.AmmoAreaZombie.InventoryIconSize = 64
CoD.AmmoAreaZombie.InventoryIconEnabledAlpha = 1
CoD.AmmoAreaZombie.InventoryAnimationDuration = 250
LUI.createMenu.AmmoAreaZombie = function(f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("AmmoAreaZombie", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	f1_local0.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.scaleContainer:setLeftRight(false, true, 0, 0)
	f1_local0.scaleContainer:setTopBottom(false, true, 0, 0)
	f1_local0:addElement(f1_local0.scaleContainer)
	local f1_local1 = nil
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) then
		f1_local1 = "hell_"
	elseif CoD.Zombie.IsDLCMap(CoD.Zombie.DLC3Maps) then
		f1_local1 = "buried_"
	elseif CoD.Zombie.IsDLCMap(CoD.Zombie.DLC4Maps) then
		f1_local1 = "tomb_"
	end
	if f1_local1 then
		if not CoD.AmmoAreaZombie.DpadImage then
			CoD.AmmoAreaZombie.DpadImage = RegisterMaterial("hud_zm_" .. f1_local1 .. "dpad")
		end
		if not CoD.AmmoAreaZombie.DpadBarImage then
			CoD.AmmoAreaZombie.DpadBarImage = RegisterMaterial("hud_zm_" .. f1_local1 .. "dpad_bar")
		end
	end
	local f1_local2 = 0
	local f1_local3 = 15
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(false, true, -CoD.AmmoAreaZombie.CircleSize - f1_local2, -f1_local2)
	Widget:setTopBottom(false, true, -CoD.AmmoAreaZombie.CircleSize - f1_local3, -f1_local3)
	f1_local0:addElement(Widget)
	Widget.id = "DpadCircle"
	Widget.visible = true
	Widget:registerEventHandler("hud_update_actionslots", CoD.AmmoAreaZombie.UpdateActionSlots)
	Widget:registerEventHandler("hud_update_inventory_weapon", CoD.AmmoAreaZombie.UpdateInventoryWeapon)
	-- Widget:registerEventHandler("hud_fade_dpad", CoD.AmmoAreaZombie.UpdateFading)
	local f1_local5 = 256
	local f1_local6 = f1_local5 / 16
	local f1_local7 = f1_local2 + CoD.AmmoAreaZombie.CircleSize / 2
	local f1_local8 = f1_local6
	local f1_local9 = LUI.UIImage.new()
	f1_local9:setLeftRight(false, true, -f1_local5 - f1_local7, -f1_local7)
	f1_local9:setTopBottom(false, true, -f1_local6 - f1_local8, -f1_local8)
	f1_local9:setImage(CoD.AmmoAreaZombie.DpadBarImage)
	Widget:addElement(f1_local9)
	local f1_local10 = LUI.UIImage.new()
	f1_local10:setLeftRight(true, true, 0, 0)
	f1_local10:setTopBottom(true, true, 0, 0)
	f1_local10:setImage(CoD.AmmoAreaZombie.DpadImage)
	Widget:addElement(f1_local10)
	local f1_local11 = CoD.OffhandIcons.Size * 1.5 * 3
	local f1_local12 = -1 - CoD.AmmoAreaZombie.CircleSize / 2 + f1_local6
	local f1_local13 = f1_local3 - 4
	local f1_local14 = CoD.OffhandIcons.new("lethal")
	f1_local14:setLeftRight(false, true, f1_local12 - f1_local11, f1_local12)
	f1_local14:setTopBottom(false, true, f1_local13 - CoD.OffhandIcons.Size, f1_local13)
	Widget:addElement(f1_local14)
	local f1_local15 = CoD.OffhandIcons.new("tactical")
	f1_local15:setLeftRight(false, true, f1_local12 - f1_local11 * 2, f1_local12 - f1_local11)
	f1_local15:setTopBottom(false, true, f1_local13 - CoD.OffhandIcons.Size, f1_local13)
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) then
		if not CoD.AmmoAreaZombie.TomahawkOutline then
			CoD.AmmoAreaZombie.TomahawkOutline = RegisterMaterial("hud_hatchet_outline_32")
		end
		if not CoD.AmmoAreaZombie.UpgradeTomahawkOutline then
			CoD.AmmoAreaZombie.UpgradeTomahawkOutline = RegisterMaterial("hud_hatchet_outline_32_blue")
		end
		f1_local15.iconOutlineImage = CoD.AmmoAreaZombie.TomahawkOutline
		f1_local15:registerEventHandler("tomahawk_in_use", CoD.OffhandIcons.UpdateTomahawkInUse)
		f1_local15:registerEventHandler("upgraded_tomahawk_in_use", CoD.OffhandIcons.UpgradeTomahawkIcon)
	end
	Widget:addElement(f1_local15)
	local f1_local16 = 3

	local inventoryWeapon = LUI.UIElement.new()
	inventoryWeapon:setLeftRight(false, false, 0, CoD.AmmoAreaZombie.CircleSize / 2)
	inventoryWeapon:setTopBottom(true, false, f1_local16 - CoD.AmmoAreaZombie.InventoryIconSize, f1_local16)
	inventoryWeapon:setAlpha(0)
	Widget:addElement(inventoryWeapon)
	Widget.inventoryWeapon = inventoryWeapon

	local inventoryWeaponIcon = LUI.UIImage.new()
	inventoryWeaponIcon:setLeftRight(false, false, -CoD.AmmoAreaZombie.InventoryIconSize / 2, CoD.AmmoAreaZombie.InventoryIconSize / 2)
	inventoryWeaponIcon:setTopBottom(true, false, 10, 10 + CoD.AmmoAreaZombie.InventoryIconSize)
	inventoryWeaponIcon:setAlpha(CoD.AmmoAreaZombie.InventoryIconEnabledAlpha)
	inventoryWeapon:addElement(inventoryWeaponIcon)
	Widget.inventoryWeaponIcon = inventoryWeaponIcon

	local f1_local19 = LUI.UIText.new()
	f1_local19:setLeftRight(false, false, -1, 1)
	f1_local19:setTopBottom(false, true, -10, 14)
	f1_local19:setText(Engine.Localize("MPUI_HINT_INVENTORY_CAPS", UIExpression.KeyBinding(f1_arg0, "+weapnext_inventory")))
	f1_local19:setFont(CoD.fonts.Big)
	inventoryWeapon:addElement(f1_local19)
	local f1_local20 = CoD.AmmoAreaZombie.Bottom + CoD.HUDDigit.BigBottomNumbersY
	local f1_local21 = CoD.HUDDigit.Width
	local f1_local22 = CoD.HUDDigit.BigNumbersHeight
	local f1_local23 = CoD.HUDDigit.Spacing
	local f1_local24 = 9
	f1_local0.ammoDigits = {}
	for f1_local25 = 1, f1_local24, 1 do
		local f1_local28 = f1_local25
		local f1_local29 = CoD.HUDDigit.new()
		f1_local29:setLeftRight(false, true, -f1_local21, 0)
		f1_local29:setTopBottom(false, true, f1_local20, f1_local20 + f1_local22)
		f1_local29:setAlpha(0)
		Widget:addElement(f1_local29)
		table.insert(f1_local0.ammoDigits, f1_local29)
	end
	f1_local0.weaponLabelContainer = LUI.UIElement.new()
	f1_local0.weaponLabelContainer:setLeftRight(true, true, -CoD.AmmoAreaZombie.CircleSize * 3, -CoD.AmmoAreaZombie.CircleSize + 15)
	f1_local0.weaponLabelContainer:setTopBottom(true, true, 0, 0)
	f1_local0.weaponLabelContainer:setAlpha(0)
	Widget:addElement(f1_local0.weaponLabelContainer)
	local f1_local25 = CoD.AmmoAreaZombie.WeaponFontName
	local f1_local26 = CoD.fonts[f1_local25]
	local f1_local27 = CoD.textSize[f1_local25]
	local f1_local28 = 30
	local f1_local29 = LUI.UIText.new()
	f1_local29:setLeftRight(true, true, 0, 0)
	f1_local29:setTopBottom(false, false, -f1_local27 / 2 - f1_local28, f1_local27 / 2 - f1_local28)
	f1_local29:setFont(f1_local26)
	f1_local29:setAlignment(LUI.Alignment.Right)
	f1_local0.weaponLabelContainer:addElement(f1_local29)
	f1_local0.weaponText = f1_local29

	local additionalPrimaryWeaponImageSize = 24
	f1_local0.additionalPrimaryWeaponImage = LUI.UIImage.new({
		left = -additionalPrimaryWeaponImageSize,
		top = -additionalPrimaryWeaponImageSize / 2 - f1_local28 - additionalPrimaryWeaponImageSize,
		right = 0,
		bottom = additionalPrimaryWeaponImageSize / 2 - f1_local28 - additionalPrimaryWeaponImageSize,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = false,
		material = RegisterMaterial("specialty_additionalprimaryweapon_zombies"),
		alpha = 0,
	})
	f1_local0.weaponLabelContainer:addElement(f1_local0.additionalPrimaryWeaponImage)

	f1_local0:registerEventHandler("hud_update_ammo", CoD.AmmoAreaZombie.UpdateAmmo)
	f1_local0:registerEventHandler("hud_update_weapon", CoD.AmmoAreaZombie.UpdateWeapon)
	f1_local0:registerEventHandler("hud_update_weapon_select", CoD.AmmoAreaZombie.UpdateWeaponSelect)
	f1_local0:registerEventHandler("hud_update_refresh", CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_overheat", CoD.AmmoAreaZombie.UpdateOverheat)
	f1_local0:registerEventHandler("hud_update_fuel", CoD.AmmoAreaZombie.UpdateFuel)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_GAME_ENDED, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_HARDCORE, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_SELECTING_LOCATION, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.AmmoAreaZombie.UpdateVisibility)
	f1_local0:setAlpha(0)
	return f1_local0
end

CoD.AmmoAreaZombie.UpdateActionSlots = function(f2_arg0, f2_arg1)
	if f2_arg0.actionSlots == nil then
		f2_arg0.actionSlots = {}
	else
		for f2_local3, f2_local4 in pairs(f2_arg0.actionSlots) do
			f2_local4:close()
		end
		f2_arg0.actionSlots = {}
	end
	for f2_local4, f2_local12 in pairs(f2_arg1.actionSlotData) do
		local f2_local13 = CoD.AmmoAreaZombie.CircleSize / 4
		local f2_local14 = f2_local13 * f2_local12.aspectRatio
		local f2_local5 = nil
		if f2_local12.ammo > 0 or f2_local4 == 1 then
			f2_local5 = CoD.HUDAlphaFull
		else
			f2_local5 = CoD.HUDAlphaEmpty
		end
		local f2_local6, f2_local7 = nil
		if f2_local4 == 1 then
			f2_local7 = {
				left = -f2_local14 / 2,
				top = CoD.AmmoAreaZombie.CircleSize / 4 - f2_local13 / 2 - 9,
				right = f2_local14 / 2,
				bottom = CoD.AmmoAreaZombie.CircleSize / 4 + f2_local13 / 2 - 9,
				leftAnchor = false,
				topAnchor = true,
				rightAnchor = false,
				bottomAnchor = false,
			}
		elseif f2_local4 == 2 then
			f2_local7 = {
				left = -f2_local14 / 2,
				top = -CoD.AmmoAreaZombie.CircleSize / 4 - f2_local13 / 2 + 2,
				right = f2_local14 / 2,
				bottom = -CoD.AmmoAreaZombie.CircleSize / 4 + f2_local13 / 2 + 2,
				leftAnchor = false,
				topAnchor = false,
				rightAnchor = false,
				bottomAnchor = true,
			}
		elseif f2_local4 == 3 then
			f2_local7 = {
				left = CoD.AmmoAreaZombie.CircleSize / 4 - f2_local14 / 2 - 2,
				top = -f2_local13 / 2,
				right = CoD.AmmoAreaZombie.CircleSize / 4 + f2_local14 / 2 - 2,
				bottom = f2_local13 / 2,
				leftAnchor = true,
				topAnchor = false,
				rightAnchor = false,
				bottomAnchor = false,
			}
		elseif f2_local4 == 4 then
			f2_local7 = {
				left = -CoD.AmmoAreaZombie.CircleSize / 4 - f2_local14 / 2 + 5,
				top = -f2_local13 / 2,
				right = -CoD.AmmoAreaZombie.CircleSize / 4 + f2_local14 / 2 + 5,
				bottom = f2_local13 / 2,
				leftAnchor = false,
				topAnchor = false,
				rightAnchor = true,
				bottomAnchor = false,
			}
		end
		if f2_local7 ~= nil then
			local Widget = LUI.UIElement.new(f2_local7)
			if Widget ~= nil then
				f2_arg0:addElement(Widget)
				f2_arg0.actionSlots[f2_local4] = Widget
				local f2_local9 = LUI.UIImage.new()
				f2_local9:setLeftRight(true, true, 0, 0)
				f2_local9:setTopBottom(true, true, 0, 0)
				f2_local9:setRGB(CoD.HUDBaseColor.r, CoD.HUDBaseColor.g, CoD.HUDBaseColor.b)
				f2_local9:setAlpha(f2_local5)
				f2_local9:setImage(f2_local12.material)
				Widget:addElement(f2_local9)
				if f2_local4 ~= 1 and f2_local4 ~= 2 and f2_local12.hasSelectFireAttachment == false then
					local f2_local10 = LUI.UIText.new()
					f2_local10:setLeftRight(false, false, -10, 10)
					f2_local10:setTopBottom(false, false, -CoD.textSize.Default / 2, CoD.textSize.Default / 2)
					f2_local10:setRGB(1, 1, 1)
					f2_local10:setAlpha(CoD.HUDAlphaFull)
					f2_local10:setText(f2_local12.ammo)
					Widget:addElement(f2_local10)
				end
				if CoD.isPC and UIExpression.DvarBool(nil, "hud_dpad_controller") == 0 then
					local f2_local10 = 200
					local f2_local11 = nil
					if f2_local4 == 1 then
						f2_local11 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local14,
							right = 0,
							topAnchor = false,
							bottomAnchor = false,
							top = -f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							bottom = f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							alignment = LUI.Alignment.Right,
						}
					elseif f2_local4 == 3 then
						f2_local11 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local14,
							right = 0,
							topAnchor = false,
							bottomAnchor = false,
							top = -f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							bottom = f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							alignment = LUI.Alignment.Right,
						}
					elseif f2_local4 == 2 then
						f2_local11 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local14,
							right = 0,
							topAnchor = false,
							bottomAnchor = true,
							top = -f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							bottom = f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							alignment = LUI.Alignment.Right,
						}
					elseif f2_local4 == 4 then
						f2_local11 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local14,
							right = 0,
							topAnchor = false,
							bottomAnchor = true,
							top = -f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							bottom = f2_local14 / 2 - f2_local4 * f2_local14 - f2_local10,
							alignment = LUI.Alignment.Right,
						}
					end
					if f2_local11 ~= nil then
						Widget.slotIndex = f2_local4
						Widget.keyPrompt = LUI.UIText.new(f2_local11)
						Widget.keyPrompt:setRGB(CoD.yellowGlow.r, CoD.yellowGlow.g, CoD.yellowGlow.b)
						Widget.keyPrompt:setFont(CoD.fonts.Condensed)
						Widget.keyPrompt:setTopBottom(false, false, -CoD.textSize.Default / 2, CoD.textSize.Default / 2)
						Widget.keyPrompt:setLeftRight(false, true, -f2_local14 - 120, -f2_local14 - 10)
						Widget.keyPrompt:setAlpha(0.5)
						Widget.keyPrompt:setAlignment(LUI.Alignment.Right)
						Widget:registerAnimationState("KeyPrompt", f2_local11)
						Widget:addElement(Widget.keyPrompt)
						if CoD.useController and Engine.LastInput_Gamepad() or UIExpression.DvarBool(nil, "hud_dpad_controller") == 1 then
							CoD.AmmoAreaZombie.ActionSlotInputSourceChanged(Widget, {
								source = 0,
							})
						else
							CoD.AmmoAreaZombie.ActionSlotInputSourceChanged(Widget, {
								source = 1,
							})
						end
					end
				end
			end
		end
	end
end

CoD.AmmoAreaZombie.UpdateInventoryWeapon = function(f3_arg0, f3_arg1)
	local f3_local0 = f3_arg0.inventoryWeapon
	local f3_local1 = nil
	if f3_arg1.teleported ~= true then
		f3_local1 = CoD.AmmoAreaZombie.InventoryAnimationDuration
	end
	if f3_arg1.materialName ~= nil then
		f3_arg0.inventoryWeaponIcon:setImage(f3_arg1.material)
		f3_local0:beginAnimation("show", f3_local1)
		f3_local0:setAlpha(1)
	else
		f3_local0:beginAnimation("hide", f3_local1)
		f3_local0:setAlpha(0)
	end
end

CoD.AmmoAreaZombie.UpdateFading = function(f4_arg0, f4_arg1)
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 then
		if f4_arg1.alpha == 0 then
			f4_arg0:beginAnimation("fading", 500)
		end
		f4_arg0:setAlpha(f4_arg1.alpha)
	end
end

CoD.AmmoAreaZombie.GetThreeDigits = function(f5_arg0)
	local f5_local0 = math.floor(f5_arg0 / 100)
	f5_arg0 = f5_arg0 - f5_local0 * 100
	local f5_local1 = math.floor(f5_arg0 / 10)
	return f5_local0, f5_local1, f5_arg0 - f5_local1 * 10
end

CoD.AmmoAreaZombie.UpdateAmmo = function(f6_arg0, f6_arg1)
	if f6_arg1.ammoInClip == 0 and f6_arg1.ammoStock == 0 and f6_arg1.lowClip ~= true then
		return
	end

	local f6_local0 = #f6_arg0.ammoDigits
	if f6_arg0.hideAmmo then
		for f6_local1 = 1, f6_local0, 1 do
			f6_arg0.ammoDigits[f6_local1]:setAlpha(0)
		end
		return
	else
		local f6_local1 = f6_arg1.lowClip
		local f6_local2 = CoD.AmmoAreaZombie.Right - 20 - 60
		local f6_local3 = CoD.HUDDigit.Width
		local f6_local4 = CoD.HUDDigit.Spacing
		local f6_local5 = CoD.HUDDigit.BigBottomNumbersY
		local f6_local6 = CoD.HUDDigit.BigNumbersHeight
		local f6_local7 = f6_local3 * CoD.HUDDigit.SmallDigitScale
		local f6_local8 = f6_local4 * CoD.HUDDigit.SmallDigitScale
		local f6_local9 = f6_local5 + CoD.HUDDigit.SmallDigitHeightDifference
		local f6_local10 = f6_local6 * CoD.HUDDigit.SmallDigitScale
		local f6_local11, f6_local12, f6_local13 = CoD.AmmoAreaZombie.GetThreeDigits(f6_arg1.ammoStock)
		local f6_local14 = 1
		f6_arg0.ammoDigits[1]:setDigit(f6_local13)
		f6_arg0.ammoDigits[1]:setLeftRight(false, true, f6_local2 - f6_local7, f6_local2)
		f6_arg0.ammoDigits[1]:setTopBottom(false, true, f6_local9, f6_local9 + f6_local10)
		f6_local2 = f6_local2 - f6_local8
		if f6_local11 > 0 or f6_local12 > 0 then
			f6_arg0.ammoDigits[2]:setDigit(f6_local12)
			f6_arg0.ammoDigits[2]:setLeftRight(false, true, f6_local2 - f6_local7, f6_local2)
			f6_arg0.ammoDigits[2]:setTopBottom(false, true, f6_local9, f6_local9 + f6_local10)
			f6_local2 = f6_local2 - f6_local8
			f6_local14 = 2
		end
		if f6_local11 > 0 then
			f6_arg0.ammoDigits[3]:setDigit(f6_local11)
			f6_arg0.ammoDigits[3]:setLeftRight(false, true, f6_local2 - f6_local7, f6_local2)
			f6_arg0.ammoDigits[3]:setTopBottom(false, true, f6_local9, f6_local9 + f6_local10)
			f6_local2 = f6_local2 - f6_local8
			f6_local14 = 3
		end
		f6_local14 = f6_local14 + 1
		f6_arg0.ammoDigits[f6_local14]:setDigit(CoD.HUDDigit.Slash)
		f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local7, f6_local2)
		f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local9, f6_local9 + f6_local10)
		f6_local2 = f6_local2 - f6_local8
		f6_local14 = f6_local14 + 1
		local f6_local15, f6_local16, f6_local17 = CoD.AmmoAreaZombie.GetThreeDigits(f6_arg1.ammoInClip)
		f6_local13 = f6_local17
		f6_local12 = f6_local16
		f6_local11 = f6_local15
		f6_arg0.ammoDigits[f6_local14]:setDigit(f6_local13, f6_local1)
		f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local3, f6_local2)
		f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local5, f6_local5 + f6_local6)
		f6_local2 = f6_local2 - f6_local4
		if f6_local11 > 0 or f6_local12 > 0 then
			f6_local14 = f6_local14 + 1
			f6_arg0.ammoDigits[f6_local14]:setDigit(f6_local12, f6_local1)
			f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local3, f6_local2)
			f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local5, f6_local5 + f6_local6)
			f6_local2 = f6_local2 - f6_local4
		end
		if f6_local11 > 0 then
			f6_local14 = f6_local14 + 1
			f6_arg0.ammoDigits[f6_local14]:setDigit(f6_local11, f6_local1)
			f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local3, f6_local2)
			f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local5, f6_local5 + f6_local6)
			f6_local2 = f6_local2 - f6_local4
		end
		if f6_arg1.ammoInDWClip then
			f6_local14 = f6_local14 + 1
			f6_arg0.ammoDigits[f6_local14]:setDigit(CoD.HUDDigit.Line)
			f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local3, f6_local2)
			f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local5, f6_local5 + f6_local6)
			f6_local2 = f6_local2 - f6_local4
			f6_local15 = f6_arg1.lowDWClip
			f6_local14 = f6_local14 + 1
			local f6_local16, f6_local17, f6_local18 = CoD.AmmoAreaZombie.GetThreeDigits(f6_arg1.ammoInDWClip)
			f6_local13 = f6_local18
			f6_local12 = f6_local17
			f6_local11 = f6_local16
			f6_arg0.ammoDigits[f6_local14]:setDigit(f6_local13, f6_local15)
			f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local3, f6_local2)
			f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local5, f6_local5 + f6_local6)
			f6_local2 = f6_local2 - f6_local4
			if f6_local11 > 0 or f6_local12 > 0 then
				f6_local14 = f6_local14 + 1
				f6_arg0.ammoDigits[f6_local14]:setDigit(f6_local12, f6_local15)
				f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local3, f6_local2)
				f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local5, f6_local5 + f6_local6)
				f6_local2 = f6_local2 - f6_local4
			end
			if f6_local11 > 0 then
				f6_local14 = f6_local14 + 1
				f6_arg0.ammoDigits[f6_local14]:setDigit(f6_local11, f6_local15)
				f6_arg0.ammoDigits[f6_local14]:setLeftRight(false, true, f6_local2 - f6_local3, f6_local2)
				f6_arg0.ammoDigits[f6_local14]:setTopBottom(false, true, f6_local5, f6_local5 + f6_local6)
				f6_local2 = f6_local2 - f6_local4
			end
		end
		for f6_local15 = f6_local14 + 1, f6_local0, 1 do
			f6_arg0.ammoDigits[f6_local15]:setAlpha(0)
		end
		f6_arg0:dispatchEventToChildren(f6_arg1)
	end
end

CoD.AmmoAreaZombie.UpdateFuel = function(f7_arg0, f7_arg1) end

CoD.AmmoAreaZombie.UpdateOverheat = function(f8_arg0, f8_arg1)
	if CoD.AmmoAreaZombie.ShouldHideOverheatCounter(f8_arg0, f8_arg1) then
		return
	end

	local f8_local0 = f8_arg1.overheat
	local f8_local1 = #f8_arg0.ammoDigits
	if f8_arg0.hideAmmo then
		for f8_local2 = 1, f8_local1, 1 do
			f8_arg0.ammoDigits[f8_local2]:setAlpha(0)
		end
		return
	else
		local f8_local2 = CoD.AmmoAreaZombie.Right - 90
		local f8_local3 = CoD.HUDDigit.Width
		local f8_local4 = CoD.HUDDigit.Spacing + 2
		local f8_local5 = CoD.HUDDigit.BigBottomNumbersY
		local f8_local6 = CoD.HUDDigit.BigNumbersHeight
		local f8_local7, f8_local8, f8_local9 = CoD.AmmoAreaZombie.GetThreeDigits(f8_arg1.heatPercent)
		local f8_local10 = 1

		f8_local2 = f8_local2 + (f8_local4 / 2)

		f8_arg0.ammoDigits[f8_local10]:setDigit(10, f8_local0)
		f8_arg0.ammoDigits[f8_local10]:setLeftRight(false, true, f8_local2 - f8_local3, f8_local2)
		f8_arg0.ammoDigits[f8_local10]:setTopBottom(false, true, f8_local5, f8_local5 + f8_local6)
		f8_local10 = f8_local10 + 1

		local digitRatio = 2.5
		local offsetLeftRight = 15
		local offsetTopBottom = 7
		f8_arg0.ammoDigits[f8_local10]:setDigit(0, f8_local0)
		f8_arg0.ammoDigits[f8_local10]:setLeftRight(false, true, f8_local2 - (f8_local3 / digitRatio) - offsetLeftRight, f8_local2 - offsetLeftRight)
		f8_arg0.ammoDigits[f8_local10]:setTopBottom(false, true, f8_local5 + offsetTopBottom, f8_local5 + (f8_local6 / digitRatio) + offsetTopBottom)
		f8_local10 = f8_local10 + 1

		offsetLeftRight = 4
		offsetTopBottom = 31
		f8_arg0.ammoDigits[f8_local10]:setDigit(0, f8_local0)
		f8_arg0.ammoDigits[f8_local10]:setLeftRight(false, true, f8_local2 - (f8_local3 / digitRatio) - offsetLeftRight, f8_local2 - offsetLeftRight)
		f8_arg0.ammoDigits[f8_local10]:setTopBottom(false, true, f8_local5 + offsetTopBottom, f8_local5 + (f8_local6 / digitRatio) + offsetTopBottom)
		f8_local10 = f8_local10 + 1

		f8_local2 = f8_local2 - f8_local4

		f8_arg0.ammoDigits[f8_local10]:setDigit(f8_local9, f8_local0)
		f8_arg0.ammoDigits[f8_local10]:setLeftRight(false, true, f8_local2 - f8_local3, f8_local2)
		f8_arg0.ammoDigits[f8_local10]:setTopBottom(false, true, f8_local5, f8_local5 + f8_local6)
		f8_local2 = f8_local2 - f8_local4
		f8_local10 = f8_local10 + 1

		if f8_local7 > 0 or f8_local8 > 0 then
			f8_arg0.ammoDigits[f8_local10]:setDigit(f8_local8, f8_local0)
			f8_arg0.ammoDigits[f8_local10]:setLeftRight(false, true, f8_local2 - f8_local3, f8_local2)
			f8_arg0.ammoDigits[f8_local10]:setTopBottom(false, true, f8_local5, f8_local5 + f8_local6)
			f8_local2 = f8_local2 - f8_local4
			f8_local10 = f8_local10 + 1
		end

		if f8_local7 > 0 then
			f8_arg0.ammoDigits[f8_local10]:setDigit(f8_local7, f8_local0)
			f8_arg0.ammoDigits[f8_local10]:setLeftRight(false, true, f8_local2 - f8_local3, f8_local2)
			f8_arg0.ammoDigits[f8_local10]:setTopBottom(false, true, f8_local5, f8_local5 + f8_local6)
			f8_local2 = f8_local2 - f8_local4
			f8_local10 = f8_local10 + 1
		end

		for f8_local11 = f8_local10, f8_local1, 1 do
			f8_arg0.ammoDigits[f8_local11]:setAlpha(0)
		end
		f8_arg0:dispatchEventToChildren(f8_arg1)
	end
end

CoD.AmmoAreaZombie.UpdateVisibility = function(f9_arg0, f9_arg1)
	local f9_local0 = f9_arg1.controller
	if UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_GAME_ENDED) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_HUD_HARDCORE) == 0 and UIExpression.IsVisibilityBitSet(f9_local0, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(f9_local0) or CoD.ExeProfileVarBool(f9_local0, "shoutcaster_inventory") and Engine.IsSpectatingActiveClient(f9_local0)) and CoD.FSM_VISIBILITY(f9_local0) == 0 then
		if f9_arg0.visible ~= true then
			f9_arg0:setAlpha(1)
			f9_arg0.visible = true
		end
	elseif f9_arg0.visible == true then
		f9_arg0:setAlpha(0)
		f9_arg0.visible = nil
	end
	f9_arg0:dispatchEventToChildren(f9_arg1)
	CoD.AmmoAreaZombie.UpdateAmmoVisibility(f9_arg0, f9_arg1)
end

CoD.AmmoAreaZombie.ShouldHideAmmoCounter = function(f10_arg0, f10_arg1)
	if f10_arg0.weapon ~= nil then
		if Engine.IsWeaponType(f10_arg0.weapon, "melee") then
			return true
		elseif CoD.isZombie == true and (f10_arg1.inventorytype == 1 or f10_arg1.inventorytype == 2) then
			return true
		end
	end
	return false
end

CoD.AmmoAreaZombie.ShouldHideOverheatCounter = function(f10_arg0, f10_arg1)
	if f10_arg0.weapon ~= nil then
		if CoD.isZombie == true and (Engine.IsWeaponType(f10_arg0.weapon, "gas") or Engine.IsOverheatWeapon(f10_arg0.weapon)) then
			return false
		end
	end
	return true
end

CoD.AmmoAreaZombie.UpdateAmmoVisibility = function(f11_arg0, f11_arg1)
	if f11_arg1.weapon ~= nil then
		f11_arg0.weapon = f11_arg1.weapon
	end
	if CoD.AmmoAreaZombie.ShouldHideAmmoCounter(f11_arg0, f11_arg1) then
		for f11_local0 = 1, #f11_arg0.ammoDigits, 1 do
			f11_arg0.ammoDigits[f11_local0]:setAlpha(0)
		end
	end
end

CoD.AmmoAreaZombie.UpdateWeapon = function(f12_arg0, f12_arg1)
	if f12_arg1.weapon and (Engine.IsWeaponType(f12_arg1.weapon, "melee") or Engine.IsWeaponType(f12_arg1.weapon, "riotshield") or Engine.IsWeaponType(f12_arg1.weapon, "grenade")) then
		f12_arg0.hideAmmo = true
	else
		f12_arg0.hideAmmo = nil
	end
	CoD.AmmoAreaZombie.UpdateVisibility(f12_arg0, f12_arg1)
	f12_arg0:dispatchEventToChildren(f12_arg1)
end

CoD.AmmoAreaZombie.UpdateWeaponSelect = function(f13_arg0, f13_arg1)
	f13_arg0.weaponLabelName = UIExpression.ToUpper(nil, Engine.Localize(f13_arg1.weaponDisplayName))
	f13_arg0.additionalPrimaryWeaponName = UIExpression.ToUpper(nil, Engine.Localize(UIExpression.DvarString(nil, "additionalPrimaryWeaponName")))

	f13_arg0.weaponLabelContainer:setAlpha(1)
	f13_arg0.weaponText:setText(f13_arg0.weaponLabelName)
	-- f13_arg0.weaponLabelContainer:beginAnimation("fade_out", CoD.WeaponLabel.FadeTime)
	-- f13_arg0.weaponLabelContainer:setAlpha(0)

	if UIExpression.DvarString(nil, "additionalPrimaryWeaponName") ~= "" and f13_arg0.additionalPrimaryWeaponName == f13_arg0.weaponLabelName then
		f13_arg0.additionalPrimaryWeaponImage:setAlpha(1)
	else
		f13_arg0.additionalPrimaryWeaponImage:setAlpha(0)
	end

	f13_arg0:dispatchEventToChildren(f13_arg1)
end

CoD.AmmoAreaZombie.SetKeyBind = function(f14_arg0)
	local f14_local0, f14_local1 = nil
	if f14_arg0.keyPrompt ~= nil and f14_arg0.slotIndex ~= nil then
		if f14_arg0.slotIndex == 4 then
			f14_local1 = "+actionslot 4"
		elseif f14_arg0.slotIndex == 3 then
			f14_local1 = "+actionslot 3"
		elseif f14_arg0.slotIndex == 1 then
			f14_local1 = "+actionslot 1"
		elseif f14_arg0.slotIndex == 2 then
			f14_local1 = "+actionslot 2"
		end
		if f14_local1 ~= nil then
			f14_arg0.keyPrompt:setText(Engine.GetKeyBindingLocalizedString(0, f14_local1, 0))
		end
	end
end

CoD.AmmoAreaZombie.ActionSlotInputSourceChanged = function(f15_arg0, f15_arg1)
	if CoD.isPC then
		if CoD.useController and f15_arg1.source == 0 or UIExpression.DvarBool(nil, "hud_dpad_controller") == 1 then
			f15_arg0:animateToState("default")
			if f15_arg0.keyPrompt ~= nil then
				f15_arg0.keyPrompt:setAlpha(0)
			end
		else
			f15_arg0:animateToState("KeyPrompt")
			CoD.AmmoAreaZombie.SetKeyBind(f15_arg0)
			if f15_arg0.keyPrompt ~= nil then
				f15_arg0.keyPrompt:setAlpha(0.8)
			end
		end
	end
end

CoD.AmmoAreaZombie.InputSourceChanged = function(f16_arg0, f16_arg1)
	if CoD.isPC then
		if f16_arg0.carouselArrows ~= nil then
			f16_arg0.carouselArrows:setAlpha(1)
		end
		if f16_arg0.circleBackground ~= nil then
			f16_arg0.circleBackground:setAlpha(0)
		end
		if f16_arg0.actionSlots ~= nil then
			for f16_local3, f16_local4 in pairs(f16_arg0.actionSlots) do
				CoD.AmmoAreaZombie.ActionSlotInputSourceChanged(f16_local4, f16_arg1)
			end
		end
	end
end
