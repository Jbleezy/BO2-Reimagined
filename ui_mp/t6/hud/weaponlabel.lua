CoD.WeaponLabel = {}
CoD.WeaponLabel.TextHeight = 32
CoD.WeaponLabel.FadeTime = 2000
CoD.WeaponLabel.new = function (f1_arg0)
	local Widget = LUI.UIElement.new(f1_arg0)
	local f1_local1 = CoD.WeaponLabel.TextHeight
	Widget.weaponLabel = LUI.UIText.new({
		left = -1,
		top = -f1_local1 / 2,
		right = 0,
		bottom = f1_local1 / 2,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = false,
		alphaMultiplier = 1
	})
	Widget.weaponLabel:setFont(CoD.fonts.Big)
	Widget.weaponLabel:registerAnimationState("fade_out", {
		alphaMultiplier = 0
	})
	Widget:addElement(Widget.weaponLabel)
	Widget:registerEventHandler("hud_update_weapon_select", CoD.WeaponLabel.UpdateWeapon)
	return Widget
end

CoD.WeaponLabel.UpdateWeapon = function (f2_arg0, f2_arg1)
	f2_arg0.weaponLabel:animateToState("default")
	if CoD.isZombie == true then
		f2_arg0.weaponLabel:setText(Engine.Localize(f2_arg1.weaponDisplayName))
	else
		f2_arg0.weaponLabel:setText(UIExpression.ToUpper(nil, Engine.Localize(f2_arg1.weaponDisplayName)))
	end
	-- f2_arg0.weaponLabel:animateToState("fade_out", CoD.WeaponLabel.FadeTime)
end