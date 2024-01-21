CoD.AmmoCounter = {}
CoD.AmmoCounter.TextHeight = 28
CoD.AmmoCounter.LowAmmoFadeTime = 500
CoD.AmmoCounter.PulseDuration = 500
CoD.AmmoCounter.new = function(f1_arg0)
	local Widget = LUI.UIElement.new(f1_arg0)
	Widget:registerAnimationState("hide", {
		alphaMultiplier = 0,
	})
	Widget:registerAnimationState("show", {
		alphaMultiplier = 1,
	})
	Widget:animateToState("hide")
	local f1_local1 = 36
	local Widget_1 = LUI.UIElement.new({
		left = -90,
		top = f1_local1,
		right = 10,
		bottom = f1_local1 + 40,
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = false,
		bottomAnchor = false,
	})
	Widget:addElement(Widget_1)
	local f1_local3 = CoD.AmmoCounter.TextHeight
	Widget.ammoLabel = LUI.UIText.new({
		left = -1,
		top = -4,
		right = 0,
		bottom = 4,
		leftAnchor = false,
		topAnchor = true,
		rightAnchor = true,
		bottomAnchor = true,
		alpha = 1,
	})
	Widget.ammoLabel:setFont(CoD.fonts.Big)
	Widget.ammoLabel:registerAnimationState("pulse_low", {
		alpha = 1,
	})
	Widget.ammoLabel:registerAnimationState("pulse_high", {
		alpha = 0.5,
	})
	Widget.ammoLabel:registerEventHandler("transition_complete_pulse_high", CoD.AmmoCounter.Ammo_PulseHigh)
	Widget.ammoLabel:registerEventHandler("transition_complete_pulse_low", CoD.AmmoCounter.Ammo_PulseLow)
	Widget_1:addElement(Widget.ammoLabel)
	Widget:registerEventHandler("hud_update_refresh", CoD.AmmoCounter.UpdateVisibility)
	Widget:registerEventHandler("hud_update_weapon", CoD.AmmoCounter.UpdateVisibility)
	Widget:registerEventHandler("hud_update_ammo", CoD.AmmoCounter.UpdateAmmo)
	return Widget
end

CoD.AmmoCounter.UpdateAmmo = function(f2_arg0, f2_arg1)
	if f2_arg1.ammoInClip == 0 and f2_arg1.ammoStock == 0 and f2_arg1.lowClip ~= true then
		return
	end

	local f2_local0 = f2_arg1.ammoInClip .. "/" .. f2_arg1.ammoStock
	if f2_arg1.ammoInDWClip then
		f2_local0 = f2_arg1.ammoInDWClip .. " | " .. f2_local0
	end
	f2_arg0.ammoLabel:setText(f2_local0)
	if f2_arg1.lowClip and f2_arg0.lowAmmo ~= true then
		f2_arg0.lowAmmo = true
		if true == CoD.isZombie then
			f2_arg0.ammoLabel:animateToState("pulse_high", CoD.AmmoCounter.LowAmmoFadeTime)
		end
	elseif f2_arg1.lowClip ~= true and f2_arg0.lowAmmo == true then
		f2_arg0.lowAmmo = nil
		if true == CoD.isZombie then
			f2_arg0.ammoLabel:animateToState("default", CoD.AmmoCounter.LowAmmoFadeTime)
		end
	end
end

CoD.AmmoCounter.ShouldHideAmmoCounter = function(f3_arg0, f3_arg1)
	if f3_arg0.weapon ~= nil then
		if Engine.IsWeaponType(f3_arg0.weapon, "melee") then
			return true
		elseif CoD.isZombie == true and (f3_arg1.inventorytype == 1 or f3_arg1.inventorytype == 2) then
			return true
		elseif CoD.isZombie == true and (Engine.IsWeaponType(f3_arg0.weapon, "gas") or Engine.IsOverheatWeapon(f3_arg0.weapon)) then
			return true
		end
	end
	return false
end

CoD.AmmoCounter.UpdateVisibility = function(f4_arg0, f4_arg1)
	local f4_local0 = f4_arg1.controller
	if f4_arg1.weapon ~= nil then
		f4_arg0.weapon = f4_arg1.weapon
	end
	if CoD.AmmoCounter.ShouldHideAmmoCounter(f4_arg0, f4_arg1) then
		if f4_arg0.visible == true then
			f4_arg0:animateToState("hide")
			f4_arg0.visible = nil
		end
		f4_arg0:dispatchEventToChildren(f4_arg1)
	elseif f4_arg0.visible ~= true then
		f4_arg0:animateToState("show")
		f4_arg0.visible = true
	end
end

CoD.AmmoCounter.Ammo_PulseHigh = function(f5_arg0, f5_arg1)
	if f5_arg1.interrupted ~= true then
		f5_arg0:animateToState("pulse_low", CoD.AmmoCounter.LowAmmoFadeTime, true, false)
	end
end

CoD.AmmoCounter.Ammo_PulseLow = function(f6_arg0, f6_arg1)
	if f6_arg1.interrupted ~= true then
		f6_arg0:animateToState("pulse_high", CoD.AmmoCounter.LowAmmoFadeTime, false, true)
	end
end
