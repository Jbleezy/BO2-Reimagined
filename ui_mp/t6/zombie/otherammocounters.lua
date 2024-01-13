CoD.OtherAmmoCounters = {}
CoD.OtherAmmoCounters.TextHeight = 28
CoD.OtherAmmoCounters.LowAmmoFadeTime = 500
CoD.OtherAmmoCounters.PulseDuration = 500
CoD.OtherAmmoCounters.NormalColor = {
	r = 1,
	g = 1,
	b = 1
}
CoD.OtherAmmoCounters.OverheatColor = {
	r = 1,
	g = 0,
	b = 0
}
CoD.OtherAmmoCounters.LowFuelColor = {
	r = 1,
	g = 1,
	b = 0
}
CoD.OtherAmmoCounters.new = function ()
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(true, true, 0, 0)
	Widget:setTopBottom(true, true, 0, 0)
	Widget:setAlpha(0)
	local f1_local1 = 36
	local f1_local2 = 40
	local Widget_1 = LUI.UIElement.new()
	Widget_1:setLeftRight(true, false, -90, 10)
	Widget_1:setTopBottom(true, false, f1_local1, f1_local1 + f1_local2)
	Widget:addElement(Widget_1)
	local f1_local4 = CoD.OtherAmmoCounters.TextHeight
	Widget.ammoLabel = LUI.UIText.new()
	Widget.ammoLabel:setLeftRight(false, true, -1, 0)
	Widget.ammoLabel:setTopBottom(true, true, -4, 4)
	Widget.ammoLabel:setFont(CoD.fonts.Big)
	Widget.ammoLabel:registerEventHandler("transition_complete_pulse_high", CoD.OtherAmmoCounters.Ammo_PulseHigh)
	Widget.ammoLabel:registerEventHandler("transition_complete_pulse_low", CoD.OtherAmmoCounters.Ammo_PulseLow)
	Widget_1:addElement(Widget.ammoLabel)
	Widget:registerEventHandler("hud_update_refresh", CoD.OtherAmmoCounters.UpdateVisibility)
	Widget:registerEventHandler("hud_update_weapon", CoD.OtherAmmoCounters.UpdateVisibility)
	Widget:registerEventHandler("hud_update_overheat", CoD.OtherAmmoCounters.UpdateHeat)
	Widget:registerEventHandler("hud_update_fuel", CoD.OtherAmmoCounters.UpdateFuel)
	return Widget
end

CoD.OtherAmmoCounters.UpdateHeat = function (f2_arg0, f2_arg1)
	f2_arg0.ammoLabel:setText(f2_arg1.heatPercent .. "%")
	if f2_arg1.overheat and f2_arg0.overheat ~= true then
		f2_arg0.overheat = true
		f2_arg0.ammoLabel:beginAnimation("pulse_high", CoD.OtherAmmoCounters.LowAmmoFadeTime)
		f2_arg0.ammoLabel:setAlpha(0.5)
	elseif f2_arg1.overheat ~= true and f2_arg0.overheat == true then
		f2_arg0.overheat = nil
		f2_arg0.ammoLabel:beingAnimation("default", CoD.OtherAmmoCounters.LowAmmoFadeTime)
		f2_arg0.ammoLabel:setAlpha(1)
	end
	if f2_arg1.overheat then
		f2_arg0.ammoLabel:setRGB(CoD.OtherAmmoCounters.OverheatColor.r, CoD.OtherAmmoCounters.OverheatColor.g, CoD.OtherAmmoCounters.OverheatColor.b)
	else
		f2_arg0.ammoLabel:setRGB(CoD.OtherAmmoCounters.NormalColor.r, CoD.OtherAmmoCounters.NormalColor.g, CoD.OtherAmmoCounters.NormalColor.b)
	end
end

CoD.OtherAmmoCounters.UpdateFuel = function (f3_arg0, f3_arg1)
	f3_arg0.ammoLabel:setText(f3_arg1.fuelPercent .. "%")
	if f3_arg1.lowFuel and f3_arg0.lowFuel ~= true then
		f3_arg0.lowFuel = true
	elseif f3_arg1.lowFuel ~= true and f3_arg0.lowFuel == true then
		f3_arg0.lowFuel = nil
		f3_arg0.ammoLabel:animateToState("default", CoD.OtherAmmoCounters.LowAmmoFadeTime)
		f3_arg0.ammoLabel:setAlpha(1)
	end
	if f3_arg1.lowFuel then
		f3_arg0.ammoLabel:setRGB(CoD.OtherAmmoCounters.LowFuelColor.r, CoD.OtherAmmoCounters.LowFuelColor.g, CoD.OtherAmmoCounters.LowFuelColor.b)
	else
		f3_arg0.ammoLabel:setRGB(CoD.OtherAmmoCounters.NormalColor.r, CoD.OtherAmmoCounters.NormalColor.g, CoD.OtherAmmoCounters.NormalColor.b)
	end
end

CoD.OtherAmmoCounters.ShouldHideAmmoCounter = function (f4_arg0, f4_arg1)
	if f4_arg0.weapon ~= nil then
		if CoD.isZombie == true and (Engine.IsWeaponType(f4_arg0.weapon, "gas") or Engine.IsOverheatWeapon(f4_arg0.weapon)) then
			return false
		end
	end
	return true
end

CoD.OtherAmmoCounters.UpdateVisibility = function (f5_arg0, f5_arg1)
	local f5_local0 = f5_arg1.controller
	if f5_arg1.weapon ~= nil then
		f5_arg0.weapon = f5_arg1.weapon
	end
	if CoD.OtherAmmoCounters.ShouldHideAmmoCounter(f5_arg0, f5_arg1) then
		if f5_arg0.visible == true then
			f5_arg0:beginAnimation("hide")
			f5_arg0:setAlpha(0)
			f5_arg0.visible = nil
		end
		f5_arg0:dispatchEventToChildren(f5_arg1)
	elseif f5_arg0.visible ~= true then
		f5_arg0:beginAnimation("show")
		f5_arg0:setAlpha(1)
		f5_arg0.visible = true
	end
end

CoD.OtherAmmoCounters.Ammo_PulseHigh = function (f6_arg0, f6_arg1)
	if f6_arg1.interrupted ~= true then
		f6_arg0:beginAnimation("pluse_low", CoD.OtherAmmoCounters.LowAmmoFadeTime, true, false)
		f6_arg0:setAlpha(1)
	end
end

CoD.OtherAmmoCounters.Ammo_PulseLow = function (f7_arg0, f7_arg1)
	if f7_arg1.interrupted ~= true then
		f7_arg0:beginAnimation("pulse_high", CoD.OtherAmmoCounters.LowAmmoFadeTime, false, true)
		f7_arg0:setAlpha(0.5)
	end
end