CoD.HUDDigit = InheritFrom(LUI.UIElement)
CoD.HUDDigit.Width = 32
CoD.HUDDigit.Spacing = 22
CoD.HUDDigit.BigBottomNumbersY = -87
CoD.HUDDigit.BigNumbersHeight = 64
CoD.HUDDigit.SmallDigitScale = 0.75
CoD.HUDDigit.SmallDigitHeightOffset = 4
CoD.HUDDigit.SmallDigitHeightDifference = 12
CoD.HUDDigit.SmallNumbersHeight = CoD.HUDDigit.BigNumbersHeight * CoD.HUDDigit.SmallDigitScale
CoD.HUDDigit.Slash = 10
CoD.HUDDigit.Line = 11
local f0_local0, f0_local1, f0_local2 = nil
local f0_local3 = 500
local f0_local4, f0_local5, f0_local6 = nil
CoD.HUDDigit.new = function()
	f0_local0()
	local Widget = LUI.UIElement.new()
	Widget:setClass(CoD.HUDDigit)
	Widget.foreground = LUI.UIImage.new()
	Widget.foreground:setLeftRight(true, true, 0, 0)
	Widget.foreground:setTopBottom(true, true, 0, 0)
	Widget.foreground:registerEventHandler("transition_complete_normal", f0_local4)
	Widget.foreground:registerEventHandler("transition_complete_pulse_red", f0_local6)
	Widget:addElement(Widget.foreground)
	if CoD.isZombie == false then
		Widget.background = LUI.UIImage.new()
		Widget.background:setLeftRight(true, true, 0, 0)
		Widget.background:setTopBottom(true, true, 0, 0)
		Widget.background:setRGB(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b)
		Widget.background:setAlpha(0.6)
		Widget.background:registerEventHandler("transition_complete_normal", f0_local4)
		Widget.background:registerEventHandler("transition_complete_pulse_red", f0_local5)
		Widget:addElement(Widget.background)
	end
	return Widget
end

f0_local0 = function()
	if not f0_local1 then
		local f2_local0 = "transit_"
		if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC0Maps) then
			f2_local0 = "nuked_"
		elseif CoD.Zombie.IsDLCMap(CoD.Zombie.DLC1Maps) then
			f2_local0 = "highrise_"
		elseif CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) then
			f2_local0 = "hell_"
		elseif CoD.Zombie.IsDLCMap(CoD.Zombie.DLC3Maps) then
			f2_local0 = "buried_"
		elseif CoD.Zombie.IsDLCMap(CoD.Zombie.DLC4Maps) then
			f2_local0 = "tomb_"
		end

		if f2_local0 ~= "" then
			f0_local2 = {}
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "0")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "1")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "2")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "3")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "4")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "5")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "6")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "7")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "8")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "9")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "slash")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_zm_num_" .. f2_local0 .. "line")
		else
			f0_local2 = {}
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_0_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_1_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_2_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_3_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_4_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_5_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_6_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_7_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_8_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_9_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_slash_white")
			f0_local2[#f0_local2 + 1] = RegisterMaterial("hud_sp_num_big_line_white")
		end
	end
end

CoD.HUDDigit.setDigit = function(f3_arg0, f3_arg1, f3_arg2)
	if f3_arg2 then
		if not f3_arg0.pulsing then
			f3_arg0.pulsing = true
			if f3_arg0.background then
				f0_local4(f3_arg0.background)
			end
			f0_local4(f3_arg0.foreground)
		end
	elseif f3_arg0.pulsing then
		f3_arg0.pulsing = nil
		if f3_arg0.background then
			f0_local5(f3_arg0.background)
		end
		f0_local6(f3_arg0.foreground)
	end
	if f3_arg0.background then
		f3_arg0.background:setImage(f0_local1[f3_arg1 + 1])
	end
	f3_arg0.foreground:setImage(f0_local2[f3_arg1 + 1])
	f3_arg0:setAlpha(1)
end

f0_local4 = function(f4_arg0, f4_arg1)
	if f4_arg1 and f4_arg1.interrupted then
		return
	else
		f4_arg0:beginAnimation("pulse_red", f0_local3)
		f4_arg0:setRGB(1, 0, 0)
	end
end

f0_local5 = function(f5_arg0, f5_arg1)
	if f5_arg1 and f5_arg1.interrupted then
		return
	elseif f5_arg1 then
		f5_arg0:beginAnimation("normal", f0_local3)
	else
		f5_arg0:completeAnimation()
	end
	f5_arg0:setRGB(1, 1, 1)
end

f0_local6 = function(f6_arg0, f6_arg1)
	if f6_arg1 and f6_arg1.interrupted then
		return
	elseif f6_arg1 then
		f6_arg0:beginAnimation("normal", f0_local3)
	else
		f6_arg0:completeAnimation()
	end
	f6_arg0:setRGB(1, 1, 1)
end
