require("T6.HUD.InGameMenus")
CoD.RestartGamePopup = {}
CoD.RestartGamePopup.AddButton = function(f1_arg0, f1_arg1, f1_arg2, f1_arg3)
	local f1_local0 = f1_arg0.buttonList:addButton(f1_arg1)
	f1_local0:setActionEventName(f1_arg2)
	if f1_arg3 == true then
		f1_local0:disable()
	end
	return f1_local0
end

CoD.RestartGamePopup.YesButtonPressed = function(f6_arg0, f6_arg1)
	Engine.SetDvar("cl_paused", 0)
	Engine.ExecNow(f6_arg1.controller, "fast_restart")
end

CoD.RestartGamePopup.NoButtonPressed = function(f7_arg0, f7_arg1)
	CoD.Menu.ButtonPromptBack(f7_arg0, f7_arg1)
end

LUI.createMenu.RestartGamePopup = function(f8_arg0)
	local f8_local0 = CoD.Menu.NewSmallPopup("RestartGamePopup")
	f8_local0:setOwner(f8_arg0)
	f8_local0:registerEventHandler("close_all_ingame_menus", CoD.InGameMenu.CloseAllInGameMenus)
	f8_local0:registerEventHandler("restartGamePopup_YesButtonPressed", CoD.RestartGamePopup.YesButtonPressed)
	f8_local0:registerEventHandler("restartGamePopup_NoButtonPressed", CoD.RestartGamePopup.NoButtonPressed)
	f8_local0:addSelectButton()
	f8_local0:addBackButton()
	local f8_local1 = 5
	local f8_local2 = LUI.UIText.new()
	f8_local2:setLeftRight(true, true, 0, 0)
	f8_local2:setTopBottom(true, false, f8_local1, f8_local1 + CoD.textSize.Big)
	f8_local2:setFont(CoD.fonts.Big)
	f8_local2:setAlignment(LUI.Alignment.Left)
	f8_local2:setText(Engine.Localize("MENU_RESTART_LEVEL_Q"))
	f8_local0.title = f8_local2
	f8_local0:addElement(f8_local2)
	f8_local0.buttonList = CoD.ButtonList.new({
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = false,
		bottomAnchor = true,
		top = -CoD.ButtonPrompt.Height - CoD.CoD9Button.Height * 3 + 10,
		bottom = 0,
	})
	f8_local0:addElement(f8_local0.buttonList)
	local f8_local4 = CoD.RestartGamePopup.AddButton(f8_local0, Engine.Localize("MENU_YES"), "restartGamePopup_YesButtonPressed")
	local f8_local5 = CoD.RestartGamePopup.AddButton(f8_local0, Engine.Localize("MENU_NO"), "restartGamePopup_NoButtonPressed")
	f8_local5:processEvent({
		name = "gain_focus",
	})
	return f8_local0
end
