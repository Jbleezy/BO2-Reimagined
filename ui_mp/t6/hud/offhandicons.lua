CoD.OffhandIcons = {}
CoD.OffhandIcons.Size = 24
CoD.OffhandIcons.Spacing = 1
CoD.OffhandIcons.AlphaMultiplier = 0.75
CoD.OffhandIcons.Width = CoD.OffhandIcons.Size * 1.5
CoD.OffhandIcons.new = function (HudRef, InstanceRef)
	local Widget = LUI.UIElement.new(InstanceRef)
	Widget.type = HudRef
	Widget.setMaterialAndQuantity = CoD.OffhandIcons.SetMaterialAndQuantity
	Widget:registerEventHandler("hud_update_offhand", CoD.OffhandIcons.UpdateOffhand)
	return Widget
end

CoD.OffhandIcons.SetMaterialAndQuantity = function (f2_arg0, f2_arg1, f2_arg2)
	local f2_local0 = nil
	if f2_arg0.icons == nil then
		f2_local0 = {}
		f2_arg0.icons = f2_local0
	else
		f2_local0 = f2_arg0.icons
	end
	local f2_local1 = CoD.OffhandIcons.Size
	local f2_local2 = 0
	local f2_local3 = f2_local1 * CoD.OffhandIcons.Spacing
	local f2_local4 = CoD.OffhandIcons.AlphaMultiplier
	local f2_local5 = CoD.HUDAlphaFull * math.pow(f2_local4, f2_arg2 - 1)
	for f2_local6 = 1, f2_arg2, 1 do
		local f2_local9 = f2_local0[f2_local6]
		if f2_local9 ~= nil then
			f2_local9:beginAnimation("default")
			f2_local9:setAlpha(CoD.HUDAlphaFull)
			f2_local9:setImage(f2_arg1)
		else
			f2_local9 = LUI.UIImage.new()
			f2_local9:setLeftRight(false, true, f2_local2 - f2_local1, f2_local2)
			f2_local9:setTopBottom(false, true, -f2_local1, 0)
			f2_local9:setRGB(CoD.HUDBaseColor.r, CoD.HUDBaseColor.g, CoD.HUDBaseColor.b)
			f2_local9:setAlpha(CoD.HUDAlphaFull)
			f2_local9:setImage(f2_arg1)
			f2_local0[f2_local6] = f2_local9
			f2_arg0:addElement(f2_local9)
		end
		f2_local2 = f2_local2 - f2_local3
		f2_local5 = f2_local5 / f2_local4
	end
	local f2_local6 = #f2_local0
	for f2_local7 = f2_arg2 + 1, f2_local6, 1 do
		f2_local0[f2_local7]:close()
		f2_local0[f2_local7] = nil
	end
end

CoD.OffhandIcons.UpdateOffhand = function (f3_arg0, f3_arg1)
	local f3_local0 = f3_arg1[f3_arg0.type]
	if f3_local0 == nil then
		if not f3_arg0.iconOutline then
			f3_arg0:setMaterialAndQuantity(nil, 0)
		end
	else
		f3_arg0:setMaterialAndQuantity(f3_local0.material, f3_local0.ammo)
	end
end

CoD.OffhandIcons.UpdateTomahawkInUse = function (f4_arg0, f4_arg1)
	local f4_local0 = f4_arg1.newValue
	if f4_local0 == 0 then
		if f4_arg0.iconOutline then
			f4_arg0.iconOutline:close()
			f4_arg0.iconOutline = nil
			f4_arg0:setMaterialAndQuantity(nil, 0)
		end
	elseif f4_local0 == 1 then
		if not f4_arg0.iconOutline then
			f4_arg0.iconOutline = LUI.UIImage.new()
			f4_arg0.iconOutline:setLeftRight(false, true, -CoD.OffhandIcons.Size * 1.5, CoD.OffhandIcons.Size * 0.5)
			f4_arg0.iconOutline:setTopBottom(false, true, -CoD.OffhandIcons.Size * 1.5, CoD.OffhandIcons.Size * 0.5)
			f4_arg0.iconOutline:setRGB(CoD.HUDBaseColor.r, CoD.HUDBaseColor.g, CoD.HUDBaseColor.b)
			f4_arg0.iconOutline:setAlpha(CoD.HUDAlphaFull)
			f4_arg0.iconOutline:setImage(f4_arg0.iconOutlineImage)
			f4_arg0.iconOutline:setPriority(-10)
			f4_arg0:addElement(f4_arg0.iconOutline)
		end
		f4_arg0.iconOutline:setAlpha(CoD.HUDAlphaFull)
	elseif f4_local0 == 2 then
		if f4_arg0.iconOutline then
			f4_arg0.icons[1]:alternateStates(0, CoD.OffhandIcons.PulseLow, CoD.OffhandIcons.PulseBright, 500, 500)
			f4_arg0.iconOutline:setAlpha(0)
		end
	elseif f4_arg0.iconOutline then
		f4_arg0.icons[1]:closeStateAlternator()
		f4_arg0.icons[1]:setAlpha(CoD.HUDAlphaFull)
		f4_arg0.iconOutline:setAlpha(CoD.HUDAlphaFull)
	end
end

CoD.OffhandIcons.UpgradeTomahawkIcon = function (f5_arg0, f5_arg1)
	if f5_arg1.newValue == 0 then
		f5_arg0.iconOutlineImage = CoD.AmmoAreaZombie.TomahawkOutline
	else
		f5_arg0.iconOutlineImage = CoD.AmmoAreaZombie.UpgradeTomahawkOutline
		if f5_arg0.iconOutline then
			f5_arg0.iconOutline:setImage(f5_arg0.iconOutlineImage)
		end
	end
end

CoD.OffhandIcons.PulseBright = function (f6_arg0, f6_arg1)
	f6_arg0:beginAnimation("pulse_low", f6_arg1)
	f6_arg0:setAlpha(1)
end

CoD.OffhandIcons.PulseLow = function (f7_arg0, f7_arg1)
	f7_arg0:beginAnimation("pulse_high", f7_arg1)
	f7_arg0:setAlpha(0.1)
end