CoD.DPadArea = {}
CoD.DPadArea.CircleSize = 128
CoD.DPadArea.InterlacedLinesWidth = 300
CoD.DPadArea.InterlacedLinesHeight = 150
CoD.DPadArea.InventoryAnimationDuration = 250
CoD.DPadArea.ArrowColor = {
	r = 1,
	g = 1,
	b = 1
}
CoD.DPadArea.RewardIconSize = 64
CoD.DPadArea.InterlacedLinesMaterial = RegisterMaterial("hud_dpad_blood")
CoD.DPadArea.CircleBackgroundMaterial = RegisterMaterial("hud_lui_dpad_circle")
CoD.DPadArea.ArrowMaterial = RegisterMaterial("hud_lui_arrow_global")
CoD.OffhandIcons.Width_Zombie = CoD.OffhandIcons.Width * 3
if CoD.isPS3 == true then
	CoD.DPadArea.DPadMaterial = RegisterMaterial("hud_dpad_ps3")
else
	CoD.DPadArea.DPadMaterial = RegisterMaterial("hud_dpad_xenon")
end
LUI.createMenu.DPadArea = function (f1_arg0)
	local f1_local0 = CoD.Menu.NewSafeAreaFromState("DPadArea", f1_arg0)
	f1_local0:setOwner(f1_arg0)
	f1_local0.scaleContainer = CoD.SplitscreenScaler.new(nil, CoD.Zombie.SplitscreenMultiplier)
	f1_local0.scaleContainer:setLeftRight(false, true, 0, 0)
	f1_local0.scaleContainer:setTopBottom(false, true, 0, 0)
	f1_local0:addElement(f1_local0.scaleContainer)
	local Widget = LUI.UIElement.new()
	f1_local0.scaleContainer:addElement(Widget)
	Widget:setLeftRight(false, true, -CoD.DPadArea.CircleSize, 0)
	Widget:setTopBottom(false, true, -CoD.DPadArea.CircleSize, 0)
	Widget.id = "DpadCircle"
	local f1_local2 = 10
	Widget:addElement(LUI.UIImage.new({
		left = -CoD.DPadArea.InterlacedLinesWidth,
		top = f1_local2 - CoD.DPadArea.InterlacedLinesHeight,
		right = 0,
		bottom = f1_local2,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = true,
		red = 0.21,
		green = 0,
		blue = 0,
		material = CoD.DPadArea.InterlacedLinesMaterial
	}))
	Widget.circleBackground = LUI.UIImage.new()
	Widget.circleBackground:setLeftRight(true, true, 0, 0)
	Widget.circleBackground:setTopBottom(true, true, 0, 0)
	Widget.circleBackground:setImage(CoD.DPadArea.CircleBackgroundMaterial)
	Widget:addElement(Widget.circleBackground)
	CoD.OffhandIcons.Width = CoD.OffhandIcons.Width_Zombie
	Widget:addElement(CoD.AmmoCounter.new({
		left = 0,
		top = 0,
		right = 0,
		bottom = 0,
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = true,
		bottomAnchor = true
	}))
	Widget:addElement(CoD.OtherAmmoCounters.new({
		left = 0,
		top = 0,
		right = 0,
		bottom = 0,
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = true,
		bottomAnchor = true
	}))
	local f1_local3 = -88
	local f1_local4 = -131
	Widget:addElement(CoD.WeaponLabel.new({
		left = f1_local4 - 100,
		top = f1_local3 - CoD.WeaponLabel.TextHeight,
		right = f1_local4,
		bottom = f1_local3,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = true
	}))
	local f1_local5 = -1
	local f1_local6 = -1
	Widget:addElement(CoD.OffhandIcons.new("lethal", {
		left = f1_local5 - CoD.OffhandIcons.Width,
		top = f1_local6 - CoD.OffhandIcons.Size,
		right = f1_local5,
		bottom = f1_local6,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = true
	}))
	Widget:addElement(CoD.OffhandIcons.new("tactical", {
		left = f1_local5 - CoD.OffhandIcons.Width * 2,
		top = f1_local6 - CoD.OffhandIcons.Size,
		right = f1_local5 - CoD.OffhandIcons.Width,
		bottom = f1_local6,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = true
	}))
	Widget.carouselArrows = LUI.UIElement.new({
		left = 0,
		top = 0,
		right = 0,
		bottom = 0,
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = true,
		bottomAnchor = true
	})
	Widget:addElement(Widget.carouselArrows)
	local f1_local7 = 8
	local f1_local8 = 8
	local f1_local9 = 4
	Widget.carouselArrows:addElement(LUI.UIImage.new({
		left = -f1_local7 / 2,
		top = -f1_local9 - f1_local8,
		right = f1_local7 / 2,
		bottom = -f1_local9,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = false,
		bottomAnchor = false,
		red = CoD.DPadArea.ArrowColor.r,
		green = CoD.DPadArea.ArrowColor.g,
		blue = CoD.DPadArea.ArrowColor.b,
		alpha = CoD.HUDAlphaFull,
		material = CoD.DPadArea.ArrowMaterial
	}))
	Widget.carouselArrows:addElement(LUI.UIImage.new({
		left = -f1_local7 / 2,
		top = f1_local9,
		right = f1_local7 / 2,
		bottom = f1_local9 + f1_local8,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = false,
		bottomAnchor = false,
		red = CoD.DPadArea.ArrowColor.r,
		green = CoD.DPadArea.ArrowColor.g,
		blue = CoD.DPadArea.ArrowColor.b,
		alpha = CoD.HUDAlphaFull,
		material = CoD.DPadArea.ArrowMaterial,
		zRot = 180
	}))
	Widget.carouselArrows:addElement(LUI.UIImage.new({
		left = -f1_local9 - f1_local8 / 2 - f1_local7 / 2,
		top = -f1_local8 / 2,
		right = -f1_local9 - f1_local8 / 2 + f1_local7 / 2,
		bottom = f1_local8 / 2,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = false,
		bottomAnchor = false,
		red = CoD.DPadArea.ArrowColor.r,
		green = CoD.DPadArea.ArrowColor.g,
		blue = CoD.DPadArea.ArrowColor.b,
		alpha = CoD.HUDAlphaFull,
		material = CoD.DPadArea.ArrowMaterial,
		zRot = 90
	}))
	Widget.carouselArrows:addElement(LUI.UIImage.new({
		left = f1_local9 + f1_local8 / 2 - f1_local7 / 2,
		top = -f1_local8 / 2,
		right = f1_local9 + f1_local8 / 2 + f1_local7 / 2,
		bottom = f1_local8 / 2,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = false,
		bottomAnchor = false,
		red = CoD.DPadArea.ArrowColor.r,
		green = CoD.DPadArea.ArrowColor.g,
		blue = CoD.DPadArea.ArrowColor.b,
		alpha = CoD.HUDAlphaFull,
		material = CoD.DPadArea.ArrowMaterial,
		zRot = -90
	}))
	local f1_local10 = 3

	local inventoryWeapon = LUI.UIElement.new({
		left = 0,
		top = f1_local10 - CoD.DPadArea.RewardIconSize,
		right = CoD.DPadArea.CircleSize / 2,
		bottom = f1_local10,
		leftAnchor = false,
		topAnchor = true,
		rightAnchor = false,
		bottomAnchor = false,
		alpha = 0
	})
	inventoryWeapon:registerAnimationState("show", {
		alpha = 1
	})
	Widget:addElement(inventoryWeapon)
	Widget.inventoryWeapon = inventoryWeapon

	local inventoryWeaponIcon = LUI.UIImage.new({
		left = -CoD.DPadArea.RewardIconSize / 2,
		top = 10,
		right = CoD.DPadArea.RewardIconSize / 2,
		bottom = 10 + CoD.DPadArea.RewardIconSize,
		leftAnchor = false,
		topAnchor = true,
		rightAnchor = false,
		bottomAnchor = false,
		alpha = CoD.DPadArea.RewardIconEnabledAlpha
	})
	inventoryWeapon:addElement(inventoryWeaponIcon)
	Widget.inventoryWeaponIcon = inventoryWeaponIcon

	local f1_local13 = LUI.UIText.new({
		left = -1,
		top = -10,
		right = 1,
		bottom = 14,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = false,
		bottomAnchor = true
	})
	f1_local13:setText(Engine.Localize("MPUI_HINT_INVENTORY_CAPS", UIExpression.KeyBinding(f1_arg0, "+weapnext_inventory")))
	f1_local13:setFont(CoD.fonts.Big)
	inventoryWeapon:addElement(f1_local13)
	Widget:registerEventHandler("hud_update_refresh", CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_EMP_ACTIVE, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_FLASH_BANGED, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_ZOMBIE, CoD.DPadArea.UpdateVisibility)
	Widget:registerEventHandler("hud_update_actionslots", CoD.DPadArea.UpdateActionSlots)
	Widget:registerEventHandler("hud_update_inventory_weapon", CoD.DPadArea.UpdateInventoryWeapon)
	Widget:registerEventHandler("hud_fade_dpad", CoD.DPadArea.UpdateFading)
	Widget:registerEventHandler("hud_update_team_change", CoD.DPadArea.UpdateTeamChange)
	if CoD.isPC then
		Widget:registerEventHandler("input_source_changed", CoD.DPadArea.InputSourceChanged)
		if CoD.useController and Engine.LastInput_Gamepad() then
			CoD.DPadArea.InputSourceChanged(Widget, {
				source = 0
			})
		else
			CoD.DPadArea.InputSourceChanged(Widget, {
				source = 1
			})
		end
	end
	Widget.visible = true
	return f1_local0
end

CoD.DPadArea.UpdateActionSlots = function (f2_arg0, f2_arg1)
	if f2_arg0.actionSlots == nil then
		f2_arg0.actionSlots = {}
	else
		for f2_local3, f2_local4 in pairs(f2_arg0.actionSlots) do
			f2_local4:close()
		end
		f2_arg0.actionSlots = {}
	end
	for f2_local4, f2_local9 in pairs(f2_arg1.actionSlotData) do
		local f2_local10 = CoD.DPadArea.CircleSize / 4
		local f2_local11 = f2_local10 * f2_local9.aspectRatio
		local f2_local5 = nil
		if f2_local9.ammo > 0 then
			f2_local5 = CoD.HUDAlphaFull
		else
			f2_local5 = CoD.HUDAlphaEmpty
		end
		local Widget, f2_local7 = nil
		if f2_local4 == 1 then
			f2_local7 = {
				left = -f2_local11 / 2,
				top = CoD.DPadArea.CircleSize / 4 - f2_local10 / 2,
				right = f2_local11 / 2,
				bottom = CoD.DPadArea.CircleSize / 4 + f2_local10 / 2,
				leftAnchor = false,
				topAnchor = true,
				rightAnchor = false,
				bottomAnchor = false,
				alphaMultiplier = 1
			}
		elseif f2_local4 == 2 then
			f2_local7 = {
				left = -f2_local11 / 2,
				top = -CoD.DPadArea.CircleSize / 4 - f2_local10 / 2,
				right = f2_local11 / 2,
				bottom = -CoD.DPadArea.CircleSize / 4 + f2_local10 / 2,
				leftAnchor = false,
				topAnchor = false,
				rightAnchor = false,
				bottomAnchor = true,
				alphaMultiplier = 1
			}
		elseif f2_local4 == 3 then
			f2_local7 = {
				left = CoD.DPadArea.CircleSize / 4 - f2_local11 / 2,
				top = -f2_local10 / 2,
				right = CoD.DPadArea.CircleSize / 4 + f2_local11 / 2,
				bottom = f2_local10 / 2,
				leftAnchor = true,
				topAnchor = false,
				rightAnchor = false,
				bottomAnchor = false,
				alphaMultiplier = 1
			}
		elseif f2_local4 == 4 then
			f2_local7 = {
				left = -CoD.DPadArea.CircleSize / 4 - f2_local11 / 2,
				top = -f2_local10 / 2,
				right = -CoD.DPadArea.CircleSize / 4 + f2_local11 / 2,
				bottom = f2_local10 / 2,
				leftAnchor = false,
				topAnchor = false,
				rightAnchor = true,
				bottomAnchor = false
			}
		end
		if f2_local7 ~= nil then
			Widget = LUI.UIElement.new(f2_local7)
			if Widget ~= nil then
				f2_arg0:addElement(Widget)
				f2_arg0.actionSlots[f2_local4] = Widget
				Widget:addElement(LUI.UIImage.new({
					left = 0,
					top = 0,
					right = 0,
					bottom = 0,
					leftAnchor = true,
					topAnchor = true,
					rightAnchor = true,
					bottomAnchor = true,
					red = CoD.HUDBaseColor.r,
					green = CoD.HUDBaseColor.g,
					blue = CoD.HUDBaseColor.b,
					alpha = f2_local5,
					material = f2_local9.material
				}))
				if f2_local4 ~= 1 and f2_local4 ~= 2 and f2_local9.hasSelectFireAttachment == false then
					local f2_local8 = LUI.UIText.new({
						left = -10,
						top = -CoD.textSize.Default / 2,
						right = 10,
						bottom = CoD.textSize.Default / 2,
						leftAnchor = false,
						topAnchor = false,
						rightAnchor = false,
						bottomAnchor = false,
						red = 1,
						green = 1,
						blue = 1,
						alpha = CoD.HUDAlphaFull
					})
					f2_local8:setText(f2_local9.ammo)
					Widget:addElement(f2_local8)
				end
				if CoD.isPC then
					local f2_local8 = nil
					if f2_local4 == 1 then
						f2_local8 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local11,
							right = 0,
							topAnchor = false,
							bottomAnchor = false,
							top = -f2_local11 / 2 - f2_local4 * f2_local11,
							bottom = f2_local11 / 2 - f2_local4 * f2_local11,
							alignment = LUI.Alignment.Right
						}
					elseif f2_local4 == 3 then
						f2_local8 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local11,
							right = 0,
							topAnchor = false,
							bottomAnchor = false,
							top = -f2_local11 / 2 - f2_local4 * f2_local11,
							bottom = f2_local11 / 2 - f2_local4 * f2_local11,
							alignment = LUI.Alignment.Right
						}
					elseif f2_local4 == 2 then
						f2_local8 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local11,
							right = 0,
							topAnchor = false,
							bottomAnchor = true,
							top = -f2_local11 / 2 - f2_local4 * f2_local11,
							bottom = f2_local11 / 2 - f2_local4 * f2_local11,
							alignment = LUI.Alignment.Right
						}
					elseif f2_local4 == 4 then
						f2_local8 = {
							leftAnchor = false,
							rightAnchor = true,
							left = -f2_local11,
							right = 0,
							topAnchor = false,
							bottomAnchor = true,
							top = -f2_local11 / 2 - f2_local4 * f2_local11,
							bottom = f2_local11 / 2 - f2_local4 * f2_local11,
							alignment = LUI.Alignment.Right
						}
					end
					if f2_local8 ~= nil then
						Widget.slotIndex = f2_local4
						Widget.keyPrompt = LUI.UIText.new(f2_local8)
						Widget.keyPrompt:setRGB(CoD.yellowGlow.r, CoD.yellowGlow.g, CoD.yellowGlow.b)
						Widget.keyPrompt:setFont(CoD.fonts.Condensed)
						Widget.keyPrompt:setTopBottom(false, false, -CoD.textSize.Default / 2, CoD.textSize.Default / 2)
						Widget.keyPrompt:setLeftRight(false, true, -f2_local11 - 120, -f2_local11 - 10)
						Widget.keyPrompt:setAlpha(0.5)
						Widget.keyPrompt:setAlignment(LUI.Alignment.Right)
						Widget:registerAnimationState("KeyPrompt", f2_local8)
						Widget:addElement(Widget.keyPrompt)
						if CoD.useController and Engine.LastInput_Gamepad() then
							CoD.DPadArea.ActionSlotInputSourceChanged(Widget, {
								source = 0
							})
						else
							CoD.DPadArea.ActionSlotInputSourceChanged(Widget, {
								source = 1
							})
						end
					end
				end
			end
		end
	end
end

CoD.DPadArea.UpdateInventoryWeapon = function (f3_arg0, f3_arg1)
	local f3_local0 = f3_arg0.inventoryWeapon
	local f3_local1 = nil
	if f3_arg1.teleported ~= true then
		f3_local1 = CoD.DPadArea.InventoryAnimationDuration
	end
	if f3_arg1.materialName ~= nil then
		local f3_local2 = f3_arg0.inventoryWeaponIcon
		f3_local2:registerAnimationState("default", {
			material = f3_arg1.material
		})
		f3_local2:animateToState("default")
		f3_local0:animateToState("show", f3_local1)
	else
		f3_local0:animateToState("default", f3_local1)
	end
end

CoD.DPadArea.UpdateFading = function (f4_arg0, f4_arg1)
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 then
		if f4_arg1.alpha == 0 then
			f4_arg0:beginAnimation("fading", 500)
		end
		f4_arg0:setAlpha(f4_arg1.alpha)
	end
end

CoD.DPadArea.UpdateVisibility = function (f5_arg0, f5_arg1)
	local f5_local0 = f5_arg1.controller
	if UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_EMP_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_IS_FLASH_BANGED) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_IN_KILLCAM) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_IS_SCOPED) == 0 and UIExpression.IsVisibilityBitSet(f5_local0, CoD.BIT_IS_PLAYER_ZOMBIE) == 0 and (not CoD.IsShoutcaster(f5_local0) or CoD.ExeProfileVarBool(f5_local0, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(f5_local0)) and CoD.FSM_VISIBILITY(f5_local0) == 0 then
		if f5_arg0.visible ~= true then
			f5_arg0:setAlpha(1)
			f5_arg0.m_inputDisabled = nil
			f5_arg0.visible = true
		end
	elseif f5_arg0.visible == true then
		f5_arg0:setAlpha(0)
		f5_arg0.m_inputDisabled = true
		f5_arg0.visible = nil
	end
	f5_arg0:dispatchEventToChildren(f5_arg1)
end

CoD.DPadArea.UpdateTeamChange = function (f6_arg0, f6_arg1)
	if Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED then
		if f6_arg1.team == CoD.TEAM_AXIS then
			if f6_arg0.visible == true then
				f6_arg0:setAlpha(0)
				f6_arg0.m_inputDisabled = true
				f6_arg0.visible = false
			end
		elseif f6_arg0.visible ~= true then
			f6_arg0:setAlpha(1)
			f6_arg0.m_inputDisabled = nil
			f6_arg0.visible = true
		end
	end
end

CoD.DPadArea.SetKeyBind = function (f7_arg0)
	local f7_local0, f7_local1 = nil
	if f7_arg0.keyPrompt ~= nil and f7_arg0.slotIndex ~= nil then
		if f7_arg0.slotIndex == 4 then
			f7_local1 = "+actionslot 4"
		elseif f7_arg0.slotIndex == 3 then
			f7_local1 = "+actionslot 3"
		elseif f7_arg0.slotIndex == 1 then
			f7_local1 = "+actionslot 1"
		elseif f7_arg0.slotIndex == 2 then
			f7_local1 = "+actionslot 2"
		end
		if f7_local1 ~= nil then
			f7_arg0.keyPrompt:setText(Engine.GetKeyBindingLocalizedString(0, f7_local1, 0))
		end
	end
end

CoD.DPadArea.ActionSlotInputSourceChanged = function (f8_arg0, f8_arg1)
	if CoD.isPC then
		if CoD.useController and f8_arg1.source == 0 then
			f8_arg0:animateToState("default")
			if f8_arg0.keyPrompt ~= nil then
				f8_arg0.keyPrompt:setAlpha(0)
			end
		else
			f8_arg0:animateToState("KeyPrompt")
			CoD.DPadArea.SetKeyBind(f8_arg0)
			if f8_arg0.keyPrompt ~= nil then
				f8_arg0.keyPrompt:setAlpha(0.8)
			end
		end
	end
end

CoD.DPadArea.InputSourceChanged = function (f9_arg0, f9_arg1)
	if CoD.isPC then
		if CoD.useController and f9_arg1.source == 0 then
			if f9_arg0.carouselArrows ~= nil then
				f9_arg0.carouselArrows:setAlpha(1)
			end
			if f9_arg0.circleBackground ~= nil then
				f9_arg0.circleBackground:setAlpha(1)
			end
		else
			if f9_arg0.carouselArrows ~= nil then
				f9_arg0.carouselArrows:setAlpha(0)
			end
			if f9_arg0.circleBackground ~= nil then
				f9_arg0.circleBackground:setAlpha(0)
			end
		end
		if f9_arg0.actionSlots ~= nil then
			for f9_local3, f9_local4 in pairs(f9_arg0.actionSlots) do
				CoD.DPadArea.ActionSlotInputSourceChanged(f9_local4, f9_arg1)
			end
		end
	end
end