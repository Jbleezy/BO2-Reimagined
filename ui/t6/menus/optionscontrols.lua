require("T6.KeyBindSelector")
require("T6.ButtonLayoutOptions")
require("T6.StickLayoutOptions")

CoD.OptionsControls = {}
CoD.OptionsControls.CurrentTabIndex = nil

CoD.OptionsControls.Button_AddChoices_LookSensitivity = function(sensitivities)
	sensitivities.strings = {
		Engine.Localize("MENU_SENSITIVITY_VERY_LOW_CAPS"),
		Engine.Localize("MENU_SENSITIVITY_LOW_CAPS"),
		"3",
		Engine.Localize("MENU_SENSITIVITY_MEDIUM_CAPS"),
		"5",
		"6",
		"7",
		Engine.Localize("MENU_SENSITIVITY_HIGH_CAPS"),
		"9",
		"10",
		Engine.Localize("MENU_SENSITIVITY_VERY_HIGH_CAPS"),
		"12",
		"13",
		Engine.Localize("MENU_SENSITIVITY_INSANE_CAPS"),
	}
	sensitivities.values = {
		CoD.SENSITIVITY_1,
		CoD.SENSITIVITY_2,
		CoD.SENSITIVITY_3,
		CoD.SENSITIVITY_4,
		CoD.SENSITIVITY_5,
		CoD.SENSITIVITY_6,
		CoD.SENSITIVITY_7,
		CoD.SENSITIVITY_8,
		CoD.SENSITIVITY_9,
		CoD.SENSITIVITY_10,
		CoD.SENSITIVITY_11,
		CoD.SENSITIVITY_12,
		CoD.SENSITIVITY_13,
		CoD.SENSITIVITY_14,
	}
	CoD.Options.Button_AddChoices(sensitivities)
end

CoD.OptionsControls.Button_AddChoices_InvertMouse = function(lookTabButtonList, LocalClientIndex)
	lookTabButtonList:addChoice(LocalClientIndex, Engine.Localize("MENU_NO_CAPS"), 0.02)
	lookTabButtonList:addChoice(LocalClientIndex, Engine.Localize("MENU_YES_CAPS"), -0.02)
end

CoD.OptionsControls.Callback_GamepadSelector = function(gamepadEnabled, client)
	if client then
		Engine.SetHardwareProfileValue(gamepadEnabled.parentSelectorButton.m_profileVarName, gamepadEnabled.value)
		if gamepadEnabled.value == 1 then
			Dvar.gpad_enabled:set(true)
			Engine.Exec(0, "execcontrollerbindings")
		else
			Dvar.gpad_enabled:set(false)
		end
	end
end

CoD.OptionsControls.Button_AddChoices_Gamepad = function(gamepadButtonList)
	gamepadButtonList:addChoice(Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsControls.Callback_GamepadSelector)
	gamepadButtonList:addChoice(Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsControls.Callback_GamepadSelector)
end

CoD.OptionsControls.AddKeyBindingElements = function(localClientIndex, buttonList, keyCommandsAndLabels)
	for Key, keyCommandAndLabel in ipairs(keyCommandsAndLabels) do
		if keyCommandAndLabel.command == "break" then
			buttonList:addSpacer(CoD.CoD9Button.Height / 2)
		else
			if keyCommandAndLabel.hint ~= nil then
				buttonList:addKeyBindSelector(localClientIndex, Engine.Localize(keyCommandAndLabel.label), keyCommandAndLabel.command, CoD.BIND_PLAYER, keyCommandAndLabel.hint)
			else
				buttonList:addKeyBindSelector(localClientIndex, Engine.Localize(keyCommandAndLabel.label), keyCommandAndLabel.command, CoD.BIND_PLAYER)
			end
		end
	end
end

CoD.OptionsControls.Button_AddChoices_YesOrNo = function(lookTabButtonList, LocalClientIndex)
	lookTabButtonList.strings = {
		Engine.Localize("MENU_NO_CAPS"),
		Engine.Localize("MENU_YES_CAPS"),
	}
	lookTabButtonList.values = {
		0,
		1,
	}
	CoD.OptionsControls.Button_AddChoices(lookTabButtonList, LocalClientIndex)
end

CoD.OptionsControls.Button_AddChoices = function(lookTabButtonList, LocalClientIndex)
	if lookTabButtonList.strings == nil or #lookTabButtonList.strings == 0 then
		return
	end
	for StringIndex = 1, #lookTabButtonList.strings, 1 do
		lookTabButtonList:addChoice(LocalClientIndex, lookTabButtonList.strings[StringIndex], lookTabButtonList.values[StringIndex])
	end
end

CoD.OptionsControls.CreateLookTab = function(lookTab, localClientIndex)
	local lookTabContainer = LUI.UIContainer.new()
	local lookTabButtonList = CoD.Options.CreateButtonList()
	lookTab.buttonList = lookTabButtonList
	lookTabContainer:addElement(lookTabButtonList)
	CoD.OptionsControls.AddKeyBindingElements(localClientIndex, lookTabButtonList, {
		{
			command = "+leanleft",
			label = "MENU_LEAN_LEFT_CAPS",
		},
		{
			command = "+leanright",
			label = "MENU_LEAN_RIGHT_CAPS",
		},
		{
			command = "+lookup",
			label = "MENU_LOOK_UP_CAPS",
		},
		{
			command = "+lookdown",
			label = "MENU_LOOK_DOWN_CAPS",
		},
		{
			command = "+left",
			label = "MENU_TURN_LEFT_CAPS",
		},
		{
			command = "+right",
			label = "MENU_TURN_RIGHT_CAPS",
		},
		{
			command = "+mlook",
			label = "MENU_MOUSE_LOOK_CAPS",
		},
		{
			command = "centerview",
			label = "MENU_CENTER_VIEW_CAPS",
		},
	})
	lookTabButtonList:addSpacer(CoD.CoD9Button.Height / 2)
	CoD.OptionsControls.Button_AddChoices_InvertMouse(lookTabButtonList:addDvarLeftRightSelector(localClientIndex, Engine.Localize("MENU_INVERT_MOUSE_CAPS"), "m_pitch"), localClientIndex)
	CoD.OptionsControls.Button_AddChoices_YesOrNo(lookTabButtonList:addDvarLeftRightSelector(localClientIndex, Engine.Localize("MENU_FREE_LOOK_CAPS"), "cl_freelook"), localClientIndex)
	local MouseSensitivityOptions = lookTabButtonList:addProfileLeftRightSlider(localClientIndex, Engine.Localize("MENU_MOUSE_SENSITIVITY_CAPS"), "mouseSensitivity", 0.01, 30, "Use the left and right arrow keys for more precise adjustments.", nil, nil, CoD.Options.AdjustSFX)
	MouseSensitivityOptions:setNumericDisplayFormatString("%.2f")
	MouseSensitivityOptions:setRoundToFraction(0.5)
	MouseSensitivityOptions:setBarSpeed(0.01)
	return lookTabContainer
end

CoD.OptionsControls.CreateMoveTab = function(moveTab, localClientIndex)
	local moveTabContainer = LUI.UIContainer.new()
	local moveTabButtonList = CoD.Options.CreateButtonList()
	moveTab.buttonList = moveTabButtonList
	moveTabContainer:addElement(moveTabButtonList)
	CoD.OptionsControls.AddKeyBindingElements(localClientIndex, moveTabButtonList, {
		{
			command = "+forward",
			label = "MENU_FORWARD_CAPS",
		},
		{
			command = "+back",
			label = "MENU_BACKPEDAL_CAPS",
		},
		{
			command = "+moveleft",
			label = "MENU_MOVE_LEFT_CAPS",
		},
		{
			command = "+moveright",
			label = "MENU_MOVE_RIGHT_CAPS",
		},
		{
			command = "break",
		},
		{
			command = "+gostand",
			label = "MENU_STANDJUMP_CAPS",
		},
		{
			command = "gocrouch",
			label = "MENU_GO_TO_CROUCH_CAPS",
		},
		{
			command = "goprone",
			label = "MENU_GO_TO_PRONE_CAPS",
		},
		{
			command = "togglecrouch",
			label = "MENU_TOGGLE_CROUCH_CAPS",
		},
		{
			command = "toggleprone",
			label = "MENU_TOGGLE_PRONE_CAPS",
		},
		{
			command = "+movedown",
			label = "MENU_CROUCH_CAPS",
		},
		{
			command = "+prone",
			label = "MENU_PRONE_CAPS",
		},
		{
			command = "break",
		},
		{
			command = "+stance",
			label = "PLATFORM_CHANGE_STANCE_CAPS",
		},
		{
			command = "+strafe",
			label = "MENU_STRAFE_CAPS",
		},
	})
	return moveTabContainer
end

CoD.OptionsControls.CreateCombatTab = function(combatTab, localClientIndex)
	local combatTabContainer = LUI.UIContainer.new()
	local combatTabButtonList = CoD.Options.CreateButtonList()
	combatTab.buttonList = combatTabButtonList
	combatTabContainer:addElement(combatTabButtonList)
	CoD.OptionsControls.AddKeyBindingElements(localClientIndex, combatTabButtonList, {
		{
			command = "+attack",
			label = "MENU_ATTACK_CAPS",
		},
		{
			command = "+speed_throw",
			label = "MENU_AIM_DOWN_THE_SIGHT_CAPS",
		},
		{
			command = "+toggleads_throw",
			label = "MENU_TOGGLE_AIM_DOWN_THE_SIGHT_CAPS",
		},
		{
			command = "+melee",
			label = "MENU_MELEE_ATTACK_CAPS",
		},
		{
			command = "+weapnext_inventory",
			label = "PLATFORM_SWITCH_WEAPON_CAPS",
		},
		{
			command = "weapprev",
			label = "PLATFORM_NEXT_WEAPON_CAPS",
		},
		{
			command = "+reload",
			label = "MENU_RELOAD_WEAPON_CAPS",
		},
		{
			command = "+sprint",
			label = "MENU_SPRINT_CAPS",
		},
		{
			command = "+breath_sprint",
			label = "MENU_SPRINT_HOLD_BREATH_CAPS",
		},
		{
			command = "+holdbreath",
			label = "MENU_STEADY_SNIPER_RIFLE_CAPS",
		},
		{
			command = "+frag",
			label = "PLATFORM_THROW_PRIMARY_CAPS",
		},
		{
			command = "+smoke",
			label = "PLATFORM_THROW_SECONDARY_CAPS",
		},
	})
	return combatTabContainer
end

CoD.OptionsControls.CreateInteractTab = function(interactTab, localClientIndex)
	local interactTabContainer = LUI.UIContainer.new()
	local interactTabButtonList = CoD.Options.CreateButtonList()
	interactTab.buttonList = interactTabButtonList
	interactTabContainer:addElement(interactTabButtonList)
	local interactTabContents = {}
	if CoD.isZombie then
		interactTabContents = {
			{
				command = "+activate",
				label = "MENU_USE_CAPS",
			},
			{
				command = "break",
			},
			{
				command = "+actionslot 3",
				label = "PLATFORM_ACTIONSLOT_3",
			},
			{
				command = "+actionslot 1",
				label = "MENU_EQUIPMENT_CAPS",
			},
			{
				command = "+actionslot 2",
				label = "MENU_MELEE_WEAPON_CAPS",
			},
			{
				command = "+actionslot 4",
				label = "MENU_PLACEABLE_MINE_CAPS",
			},
			{
				command = "break",
			},
			{
				command = "screenshotjpeg",
				label = "MENU_SCREENSHOT_CAPS",
			},
		}
	elseif CoD.isMultiplayer then
		interactTabContents = {
			{
				command = "+activate",
				label = "MENU_USE_CAPS",
			},
			{
				command = "break",
			},
			{
				command = "+actionslot 3",
				label = "PLATFORM_ACTIONSLOT_3",
			},
			{
				command = "+actionslot 1",
				label = "PLATFORM_NEXT_SCORE_STREAK_CAPS",
			},
			{
				command = "+actionslot 2",
				label = "PLATFORM_PREVIOUS_SCORE_STREAK_CAPS",
			},
			{
				command = "+actionslot 4",
				label = "PLATFORM_ACTIVATE_SCORE_STREAK_CAPS",
			},
			{
				command = "break",
			},
			{
				command = "screenshotjpeg",
				label = "MENU_SCREENSHOT_CAPS",
			},
		}
	end
	table.insert(interactTabContents, {
		command = "chooseclass_hotkey",
		label = "MPUI_CHOOSE_CLASS_CAPS",
	})
	table.insert(interactTabContents, {
		command = "+scores",
		label = "PLATFORM_SCOREBOARD_CAPS",
	})
	table.insert(interactTabContents, {
		command = "togglescores",
		label = "PLATFORM_SCOREBOARD_TOGGLE_CAPS",
	})
	table.insert(interactTabContents, {
		command = "break",
	})
	table.insert(interactTabContents, {
		command = "+talk",
		label = "MENU_VOICE_CHAT_BUTTON_CAPS",
	})
	table.insert(interactTabContents, {
		command = "chatmodepublic",
		label = "MENU_CHAT_CAPS",
	})
	table.insert(interactTabContents, {
		command = "chatmodeteam",
		label = "MENU_TEAM_CHAT_CAPS",
	})
	CoD.OptionsControls.AddKeyBindingElements(localClientIndex, interactTabButtonList, interactTabContents)
	return interactTabContainer
end

CoD.OptionsControls.CreateGamepadTab = function(gamepadTab, localClientIndex)
	local gamepadButtonListContainer = LUI.UIContainer.new()
	local gamepadButtonList = CoD.Options.CreateButtonList()
	gamepadTab.buttonList = gamepadButtonList
	gamepadButtonListContainer:addElement(gamepadButtonList)
	CoD.OptionsControls.Button_AddChoices_Gamepad(gamepadButtonList:addHardwareProfileLeftRightSelector(Engine.Localize("PLATFORM_ENABLE_GAMEPAD_CAPS"), "gpad_enabled"))
	if UIExpression.IsInGame() == 1 and UIExpression.DvarBool(nil, "sv_allowAimAssist") == 0 then
		local targetAssistSelector = gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("MENU_TARGET_ASSIST_CAPS"), "somethingalwaysfalse", "Target Assist is disabled on this server.")
		targetAssistSelector:lock()
		CoD.Options.Button_AddChoices_EnabledOrDisabled(targetAssistSelector)
	else
		local targetAssistSelector = gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("MENU_TARGET_ASSIST_CAPS"), "input_targetAssist", Engine.Localize("MENU_TARGET_ASSIST_DESC"))
		CoD.Options.Button_AddChoices_EnabledOrDisabled(targetAssistSelector)
	end
	CoD.Options.Button_AddChoices_EnabledOrDisabled(gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("MENU_LOOK_INVERSION_CAPS"), "input_invertpitch", Engine.Localize("MENU_LOOK_INVERSION_DESC")))
	CoD.Options.Button_AddChoices_EnabledOrDisabled(gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("PLATFORM_CONTROLLER_VIBRATION_CAPS"), "gpad_rumble", Engine.Localize("PLATFORM_CONTROLLER_VIBRATION_DESC")))
	if UIExpression.IsDemoPlaying(localClientIndex) ~= 0 then
		local theaterButtonLayout = gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("MENU_THEATER_BUTTON_LAYOUT_CAPS"), "demo_controllerconfig", Engine.Localize("MENU_THEATER_BUTTON_LAYOUT_DESC"))
		CoD.ButtonLayout.AddChoices(theaterButtonLayout, localClientIndex)
		theaterButtonLayout:disableCycling()
		theaterButtonLayout:registerEventHandler("button_action", CoD.OptionsControls.Button_ButtonLayout)
	else
		local gamepadThumbSticksOptions = gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("MENU_THUMBSTICK_LAYOUT_CAPS"), "gpad_sticksConfig", Engine.Localize("MENU_THUMBSTICK_LAYOUT_DESC"))
		CoD.StickLayout.AddChoices(gamepadThumbSticksOptions)
		gamepadThumbSticksOptions:disableCycling()
		gamepadThumbSticksOptions:registerEventHandler("button_action", CoD.OptionsControls.Button_StickLayout)
		local gamepadButtonsOptions = gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("MENU_BUTTON_LAYOUT_CAPS"), "gpad_buttonsConfig", Engine.Localize("MENU_BUTTON_LAYOUT_DESC"))
		CoD.ButtonLayout.AddChoices(gamepadButtonsOptions, localClientIndex)
		gamepadButtonsOptions:disableCycling()
		gamepadButtonsOptions:registerEventHandler("button_action", CoD.OptionsControls.Button_ButtonLayout)
	end
	CoD.OptionsControls.Button_AddChoices_LookSensitivity(gamepadButtonList:addProfileLeftRightSelector(localClientIndex, Engine.Localize("MENU_LOOK_SENSITIVITY_CAPS"), "input_viewSensitivity", Engine.Localize("PLATFORM_LOOK_SENSITIVITY_DESC")))
	local GamepadDeadzoneMin = gamepadButtonList:addDvarLeftRightSlider(localClientIndex, "DEADZONE MAX", "gpad_stick_deadzone_max", 0.01, 1, "Stick maximum input threshold.")
	GamepadDeadzoneMin:setNumericDisplayFormatString("%.2f")
	GamepadDeadzoneMin:setRoundToFraction(0.01)
	GamepadDeadzoneMin:setBarSpeed(0.20)
	local FOVScaleSlider = gamepadButtonList:addDvarLeftRightSlider(localClientIndex, "DEADZONE MIN", "gpad_stick_deadzone_min", 0.2, 1, "Stick minimum input threshold. Lower values make the sticks more responsive to tiny movements.")
	FOVScaleSlider:setNumericDisplayFormatString("%.2f")
	FOVScaleSlider:setRoundToFraction(0.01)
	FOVScaleSlider:setBarSpeed(0.20)
	return gamepadButtonListContainer
end

CoD.OptionsControls.TabChanged = function(controlsWidget, controlsTab)
	controlsWidget.buttonList = controlsWidget.tabManager.buttonList
	local child = controlsWidget.buttonList:getFirstChild()
	while not child.m_focusable do
		child = child:getNextSibling()
	end
	if child ~= nil then
		child:processEvent({
			name = "gain_focus",
		})
	end
	CoD.OptionsControls.CurrentTabIndex = controlsTab.tabIndex

	if controlsWidget.tabManager ~= nil and controlsWidget.tabManager.currentTabHeader ~= nil and controlsWidget.tabManager.currentTabHeader.tabBg ~= nil then
		controlsWidget.tabManager.currentTabHeader.tabBg:setAlpha(0)
	end
end

CoD.OptionsControls.DefaultPopup_RestoreDefaultControls = function(defaultsPopup, client)
	Engine.SetProfileVar(client.controller, "input_invertpitch", 0)
	Engine.SetProfileVar(client.controller, "gpad_rumble", 1)
	Engine.SetProfileVar(client.controller, "gpad_sticksConfig", CoD.THUMBSTICK_DEFAULT)
	Engine.SetProfileVar(client.controller, "gpad_buttonsConfig", CoD.BUTTONS_DEFAULT)
	Engine.SetProfileVar(client.controller, "input_viewSensitivity", CoD.SENSITIVITY_4)
	Engine.SetProfileVar(client.controller, "mouseSensitivity", 5)
	local defaultControlsConfig = "default_controls"
	if CoD.isMultiplayer then
		defaultControlsConfig = "default_mp_controls"
	end
	local language = Engine.GetLanguage()
	if language then
		defaultControlsConfig = defaultControlsConfig .. "_" .. language
	end
	Engine.ExecNow(client.controller, "exec " .. defaultControlsConfig)
	Engine.Exec(client.controller, "execcontrollerbindings")
	Dvar.gpad_stick_deadzone_max:set(0.01)
	Dvar.gpad_stick_deadzone_min:set(0.2)
	Engine.SyncHardwareProfileWithDvars()
	defaultsPopup:goBack(client.controller)
end

CoD.OptionsControls.OnFinishControls = function(menu, client)
	Engine.Exec(client.controller, "updateMustHaveBindings")
	if UIExpression.IsInGame() == 1 then
		Engine.Exec(client.controller, "updateVehicleBindings")
	end
	if CoD.useController and Engine.LastInput_Gamepad() then
		menu:dispatchEventToRoot({
			name = "input_source_changed",
			controller = client.controller,
			source = 0,
		})
	else
		menu:dispatchEventToRoot({
			name = "input_source_changed",
			controller = client.controller,
			source = 1,
		})
	end
end

CoD.OptionsControls.CloseMenu = function(menu, client)
	CoD.OptionsControls.OnFinishControls(menu, client)
	CoD.Options.CloseMenu(menu, client)
end

CoD.OptionsControls.OpenDefaultPopup = function(popup, client)
	local menu = popup:openMenu("SetDefaultControlsPopup", client.controller)
	menu:registerEventHandler("confirm_action", CoD.OptionsControls.DefaultPopup_RestoreDefaultControls)
	popup:close()
end

CoD.OptionsControls.OpenButtonLayout = function(buttonLayout, client)
	buttonLayout:saveState()
	buttonLayout:openMenu("ButtonLayout", client.controller)
	buttonLayout:close()
end

CoD.OptionsControls.OpenStickLayout = function(stickLayout, client)
	stickLayout:saveState()
	stickLayout:openMenu("StickLayout", client.controller)
	stickLayout:close()
end

CoD.OptionsControls.Button_StickLayout = function(gamepadThumbSticksOptions, client)
	gamepadThumbSticksOptions:dispatchEventToParent({
		name = "open_stick_layout",
		controller = client.controller,
	})
end

CoD.OptionsControls.Button_ButtonLayout = function(gamepadButtonsOptions, client)
	gamepadButtonsOptions:dispatchEventToParent({
		name = "open_button_layout",
		controller = client.controller,
	})
end

LUI.createMenu.OptionsControlsMenu = function(localClientIndex)
	local controlsWidget = nil
	if UIExpression.IsInGame() == 1 then
		controlsWidget = CoD.InGameMenu.New("OptionsControlsMenu", localClientIndex, Engine.Localize("MENU_CONTROLS_CAPS"))
	else
		controlsWidget = CoD.Menu.New("OptionsControlsMenu")
		controlsWidget:addTitle(Engine.Localize("MENU_CONTROLS_CAPS"), LUI.Alignment.Center)
		controlsWidget:addLargePopupBackground()
	end
	controlsWidget:setPreviousMenu("OptionsMenu")
	controlsWidget:setOwner(localClientIndex)
	controlsWidget:registerEventHandler("button_prompt_back", CoD.OptionsControls.Back)
	controlsWidget:registerEventHandler("restore_default_controls", CoD.OptionsControls.RestoreDefaultControls)
	controlsWidget:registerEventHandler("tab_changed", CoD.OptionsControls.TabChanged)
	controlsWidget:registerEventHandler("open_button_layout", CoD.OptionsControls.OpenButtonLayout)
	controlsWidget:registerEventHandler("open_stick_layout", CoD.OptionsControls.OpenStickLayout)
	controlsWidget:registerEventHandler("open_default_popup", CoD.OptionsControls.OpenDefaultPopup)
	controlsWidget:addSelectButton()
	controlsWidget:addBackButton()
	CoD.Options.AddResetPrompt(controlsWidget)
	local controlsTabs = CoD.Options.SetupTabManager(controlsWidget, 800)
	controlsTabs:addTab(localClientIndex, "MENU_LOOK_CAPS", CoD.OptionsControls.CreateLookTab)
	controlsTabs:addTab(localClientIndex, "MENU_MOVE_CAPS", CoD.OptionsControls.CreateMoveTab)
	controlsTabs:addTab(localClientIndex, "MENU_COMBAT_CAPS", CoD.OptionsControls.CreateCombatTab)
	controlsTabs:addTab(localClientIndex, "MENU_INTERACT_CAPS", CoD.OptionsControls.CreateInteractTab)
	controlsTabs:addTab(localClientIndex, "PLATFORM_GAMEPAD_CAPS", CoD.OptionsControls.CreateGamepadTab)
	if CoD.OptionsControls.CurrentTabIndex then
		controlsTabs:loadTab(localClientIndex, CoD.OptionsControls.CurrentTabIndex)
	else
		controlsTabs:refreshTab(localClientIndex)
	end
	return controlsWidget
end
