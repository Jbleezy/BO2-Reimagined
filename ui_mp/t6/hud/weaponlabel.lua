if UIExpression.DvarString(nil, "additionalPrimaryWeaponName") == "" then
	Engine.SetDvar("additionalPrimaryWeaponName", "")
end

CoD.WeaponLabel = {}
CoD.WeaponLabel.TextHeight = 32
CoD.WeaponLabel.FadeTime = 2000
CoD.WeaponLabel.WeaponFontName = "Default"
CoD.WeaponLabel.new = function(f1_arg0)
	local Widget = LUI.UIElement.new(f1_arg0)
	local f1_local1 = CoD.textSize[CoD.WeaponLabel.WeaponFontName]
	local f1_local2 = CoD.fonts[CoD.WeaponLabel.WeaponFontName]
	Widget.weaponLabel = LUI.UIText.new({
		left = -1,
		top = -f1_local1 / 2,
		right = 0,
		bottom = f1_local1 / 2,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = false,
		alphaMultiplier = 1,
	})
	Widget.weaponLabel:setFont(f1_local2)
	Widget.weaponLabel:registerAnimationState("fade_out", {
		alphaMultiplier = 0,
	})
	Widget:addElement(Widget.weaponLabel)

	local additionalPrimaryWeaponImageSize = f1_local1 * 0.75
	Widget.additionalPrimaryWeaponImage = LUI.UIImage.new({
		left = -additionalPrimaryWeaponImageSize,
		top = -additionalPrimaryWeaponImageSize / 2 - additionalPrimaryWeaponImageSize - 2,
		right = 0,
		bottom = additionalPrimaryWeaponImageSize / 2 - additionalPrimaryWeaponImageSize - 2,
		leftAnchor = false,
		topAnchor = false,
		rightAnchor = true,
		bottomAnchor = false,
		material = RegisterMaterial("specialty_additionalprimaryweapon_zombies"),
		alpha = 0,
	})
	Widget:addElement(Widget.additionalPrimaryWeaponImage)

	Widget:registerEventHandler("hud_update_weapon_select", CoD.WeaponLabel.UpdateWeapon)
	return Widget
end

CoD.WeaponLabel.UpdateWeapon = function(Menu, ClientInstance)
	Menu.weaponLabelName = UIExpression.ToUpper(nil, Engine.Localize(ClientInstance.weaponDisplayName))
	Menu.additionalPrimaryWeaponName = UIExpression.ToUpper(nil, Engine.Localize(UIExpression.DvarString(nil, "additionalPrimaryWeaponName")))

	Menu.weaponLabel:animateToState("default")
	Menu.weaponLabel:setText(Menu.weaponLabelName)
	-- f2_arg0.weaponLabel:animateToState("fade_out", CoD.WeaponLabel.FadeTime)

	if UIExpression.DvarString(nil, "additionalPrimaryWeaponName") ~= "" and Menu.additionalPrimaryWeaponName == Menu.weaponLabelName then
		Menu.additionalPrimaryWeaponImage:setAlpha(1)
	else
		Menu.additionalPrimaryWeaponImage:setAlpha(0)
	end
end
