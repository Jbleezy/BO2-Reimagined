require("T6.HardwareProfileLeftRightSelector")
require("T6.HardwareProfileLeftRightSlider")
require("T6.KeyBindSelector")
require("T6.CategoryCarousel")
require("T6.Menus.OptionsControls")
require("T6.Menus.OptionsSettings")
require("T6.Menus.SafeAreaMenu")
require("T6.Menus.SystemInfoMenu")
require("T6.AudioSettingsOptions")
require("T6.BrightnessOptions")
require("T6.ButtonLayoutOptions")
require("T6.StickLayoutOptions")
CoD.Options = {}
CoD.Options.ButtonListWidth = 500
CoD.Options.Width = 540
CoD.Options.AdjustSFX = "cac_safearea"

CoD.Options.Back = function(OptionsMenuWidget, ClientInstance)
	CoD.Options.UpdateWindowPosition()
	Engine.Exec(ClientInstance.controller, "updategamerprofile")
	Engine.SaveHardwareProfile()
	Engine.ApplyHardwareProfileSettings()
	if CoD.isSinglePlayer == true then
		Engine.SendMenuResponse(ClientInstance.controller, "luisystem", "modal_stop")
	end
	OptionsMenuWidget:goBack(ClientInstance.controller)
end

CoD.Options.CloseMenu = function(OptionsMenuWidget, ClientInstance)
	CoD.Options.UpdateWindowPosition()
	Engine.Exec(ClientInstance.controller, "updategamerprofile")
	Engine.SaveHardwareProfile()
	Engine.ApplyHardwareProfileSettings()
	OptionsMenuWidget:close()
end

CoD.Options.Close = function(OptionsMenuWidget)
	Engine.Exec(OptionsMenuWidget:getOwner(), "updategamerprofile")
	CoD.Menu.close(OptionsMenuWidget)
end

CoD.Options.ApplyChanges = function(f4_arg0, ClientInstance)
	CoD.Options.SetDvarChanges(f4_arg0)
	Engine.Exec(ClientInstance.controller, "vid_restart")
end

CoD.Options.OpenControls = function(OptionsMenuWidget, ClientInstance)
	if OptionsMenuWidget:getParent() then
		OptionsMenuWidget:saveState()
		OptionsMenuWidget:openMenu("OptionsControlsMenu", ClientInstance.controller)
		OptionsMenuWidget:close()
	end
end

CoD.Options.OpenSettings = function(OptionsMenuWidget, ClientInstance)
	if OptionsMenuWidget:getParent() then
		OptionsMenuWidget:saveState()
		OptionsMenuWidget:openMenu("OptionsSettingsMenu", ClientInstance.controller)
		OptionsMenuWidget:close()
	end
end

CoD.Options.OpenSystemInfo = function(OptionsMenuWidget, ClientInstance)
	OptionsMenuWidget:saveState()
	OptionsMenuWidget:openMenu("SystemInfo", ClientInstance.controller)
	Engine.PlaySound("cac_grid_nav")
	OptionsMenuWidget:close()
end

CoD.Options.IsCommonLoaded = function(f8_arg0, f8_arg1)
	if Engine.IsCommonLoaded() then
		f8_arg0.timer:close()
		f8_arg0.spinner:close()
		f8_arg0.message:close()
		CoD.Options.AddOptionCategories(f8_arg0)
	end
end

CoD.Options.SupportsSubtitles = function()
	local Language = Dvar.loc_language:get()
	if Language == CoD.LANGUAGE_ENGLISH or Language == CoD.LANGUAGE_BRITISH or Language == CoD.LANGUAGE_POLISH or Language == CoD.LANGUAGE_JAPANESE or Language == CoD.LANGUAGE_FULLJAPANESE then
		return true
	else
		return false
	end
end

CoD.Options.SupportsMatureContent = function()
	if Dvar.loc_language:get() == CoD.LANGUAGE_ENGLISH then
		return true
	else
		return false
	end
end

CoD.Options.Button_EnumProfile_SelectionChanged = function(AudioSettingsChoice)
	Engine.SetProfileVar(AudioSettingsChoice.parentSelectorButton.m_currentController, AudioSettingsChoice.parentSelectorButton.m_profileVarName, AudioSettingsChoice.value)
	AudioSettingsChoice.parentSelectorButton.hintText = AudioSettingsChoice.extraParams.associatedHintText
	local f11_local0 = AudioSettingsChoice.parentSelectorButton:getParent()
	if f11_local0 ~= nil and f11_local0.hintText ~= nil then
		f11_local0.hintText:updateText(AudioSettingsChoice.parentSelectorButton.hintText)
	end
end

CoD.Options.Button_AddChoices = function(Button)
	if Button.strings == nil or #Button.strings == 0 then
		return
	end
	for Index = 1, #Button.strings, 1 do
		Button:addChoice(Button.strings[Index], Button.values[Index])
	end
end

CoD.Options.Button_AddChoices_EnabledOrDisabled = function(Button)
	Button.strings = {
		Engine.Localize("MENU_DISABLED_CAPS"),
		Engine.Localize("MENU_ENABLED_CAPS"),
	}
	Button.values = {
		0,
		1,
	}
	CoD.Options.Button_AddChoices(Button)
end

CoD.Options.Button_AddChoices_OnOrOff = function(Button)
	Button.strings = {
		Engine.Localize("MENU_OFF_CAPS"),
		Engine.Localize("MENU_ON_CAPS"),
	}
	Button.values = {
		0,
		1,
	}
	CoD.Options.Button_AddChoices(Button)
end

CoD.Options.Button_AddChoices_YesOrNo = function(Button)
	Button.strings = {
		Engine.Localize("MENU_NO_CAPS"),
		Engine.Localize("MENU_YES_CAPS"),
	}
	Button.values = {
		0,
		1,
	}
	CoD.Options.Button_AddChoices(Button)
end

CoD.Options.AddHardwareProfileLeftRightSelector = function(ButtonList, f16_arg1, f16_arg2, f16_arg3, f16_arg4, f16_arg5)
	local f16_local0 = CoD.HardwareProfileLeftRightSelector.new(f16_arg1, f16_arg2, f16_arg4, {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = CoD.CoD9Button.Height,
	})
	f16_local0.hintText = f16_arg3
	f16_local0:setPriority(f16_arg5)
	CoD.ButtonList.AssociateHintTextListenerToButton(f16_local0)
	ButtonList.m_selectors[f16_arg2] = f16_local0
	ButtonList:addElement(f16_local0)
	return f16_local0
end

CoD.Options.AddHardwareProfileLeftRightSlider = function(ButtonList, f17_arg1, f17_arg2, f17_arg3, f17_arg4, f17_arg5, f17_arg6, f17_arg7)
	local f17_local0 = CoD.HardwareProfileLeftRightSlider.new(f17_arg1, f17_arg2, f17_arg3, f17_arg4, f17_arg6, {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = CoD.CoD9Button.Height,
	})
	f17_local0.hintText = f17_arg5
	f17_local0:setPriority(f17_arg7)
	CoD.ButtonList.AssociateHintTextListenerToButton(f17_local0)
	ButtonList.m_selectors[f17_arg2] = f17_local0
	ButtonList:addElement(f17_local0)
	return f17_local0
end

CoD.Options.AddLeftRightSelector = function(ButtonList, f18_arg1, f18_arg2, f18_arg3, f18_arg4, f18_arg5)
	local f18_local0 = CoD.LeftRightSelector.new(f18_arg1, f18_arg2, f18_arg4, {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = CoD.CoD9Button.Height,
	})
	f18_local0.hintText = f18_arg3
	f18_local0:setPriority(f18_arg5)
	CoD.ButtonList.AssociateHintTextListenerToButton(f18_local0)
	ButtonList:addElement(f18_local0)
	return f18_local0
end

CoD.Options.AddVoiceMeter = function(f19_arg0, f19_arg1, f19_arg2, f19_arg3)
	local f19_local0 = CoD.OptionElement.new(f19_arg1, nil, {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = CoD.CoD9Button.Height,
	})
	f19_local0.id = "VoiceMeter"
	f19_local0.hintText = f19_arg2
	CoD.ButtonList.AssociateHintTextListenerToButton(f19_local0)
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(true, false, 0, 300)
	Widget:setTopBottom(true, true, 0, 0)
	Widget:setupVoiceMeter(20)
	f19_local0.horizontalList:addElement(Widget)
	f19_arg0:addElement(f19_local0)
end

CoD.Options.AddApplyPrompt = function(GenericWidget)
	if GenericWidget.applyPrompt == nil then
		GenericWidget.applyPrompt = CoD.ButtonPrompt.new("alt1", Engine.Localize("MENU_APPLY_CAPS"), GenericWidget, "open_apply_popup", false, false, false, false, "F")
	end
	GenericWidget:addRightButtonPrompt(GenericWidget.applyPrompt)
end

CoD.Options.AddResetPrompt = function(GenericWidget)
	if GenericWidget.resetPrompt == nil then
		GenericWidget.resetPrompt = CoD.ButtonPrompt.new("alt2", Engine.Localize("MENU_RESET_TO_DEFAULT"), GenericWidget, "open_default_popup", false, false, false, false, "R")
	end
	GenericWidget:addRightButtonPrompt(GenericWidget.resetPrompt)
end

CoD.Options.RegisterSocialEventHandlers = function(AdvancedTabContainer)
	AdvancedTabContainer:registerEventHandler("check_for_youtube_account", CoD.Options.CheckForYouTubeAccount)
	AdvancedTabContainer:registerEventHandler("youtube_connect_complete", CoD.Options.YouTubeConnectComplete)
	AdvancedTabContainer:registerEventHandler("check_for_twitter_account", CoD.Options.CheckForTwitterAccount)
	AdvancedTabContainer:registerEventHandler("twitter_connect_complete", CoD.Options.TwitterConnectComplete)
	AdvancedTabContainer:registerEventHandler("check_for_twitch_account", CoD.Options.CheckForTwitchAccount)
	AdvancedTabContainer:registerEventHandler("twitch_connect_complete", CoD.Options.TwitchConnectComplete)
end

CoD.Options.AddYouTubeButton = function(AdvancedTabContainer, LocalClientIndex)
	AdvancedTabContainer.youtubeAccountButton = AdvancedTabContainer.buttonList:addButton(Engine.Localize("MENU_LINK_TO_YOUTUBE_CAPS"), Engine.Localize("MENU_LINK_YOUTUBE_DESC"))
	CoD.Options.UpdateYouTubeButtonText(AdvancedTabContainer.youtubeAccountButton, LocalClientIndex)
	if Engine.IsPlayerUnderage(LocalClientIndex) then
		AdvancedTabContainer.youtubeAccountButton:disable()
		AdvancedTabContainer.youtubeAccountButton.hintText = Engine.Localize("MENU_GENERIC_UNDERAGE_MESSAGE")
	else
		AdvancedTabContainer.youtubeAccountButton:setActionEventName("youtube_connect")
	end
end

CoD.Options.UpdateYouTubeButtonText = function(YoutubeButton, LocalClientIndex)
	if not Engine.IsYouTubeAccountRegistered(LocalClientIndex) then
		YoutubeButton:setLabel(Engine.Localize("MENU_LINK_TO_YOUTUBE_CAPS"))
	else
		YoutubeButton:setLabel(Engine.Localize("MENU_UNLINK_FROM_YOUTUBE_CAPS"))
	end
	if CoD.isZombie and YoutubeButton.brackets then
		YoutubeButton.brackets:setAlpha(0)
	end
end

CoD.Options.CheckForYouTubeAccount = function(AdvancedTabContainer, ClientInstance)
	if not Engine.IsYouTubeAccountChecked(ClientInstance.controller) then
		return
	else
		CoD.Options.AddYouTubeButton(AdvancedTabContainer, ClientInstance.controller)
		AdvancedTabContainer.youtubeCheckTimer:close()
		AdvancedTabContainer.youtubeCheckTimer = nil
	end
end

CoD.Options.OpenYouTubeConnect = function(f26_arg0, ClientInstance)
	if not Engine.IsYouTubeAccountChecked(controller) or not Engine.IsYouTubeAccountRegistered(controller) then
		f26_arg0:openPopup("YouTube_Connect", ClientInstance.controller)
	else
		f26_arg0:openPopup("YouTube_UnRegister", ClientInstance.controller)
	end
end

CoD.Options.YouTubeConnectComplete = function(AdvancedTabContainer, ClientInstance)
	CoD.Options.UpdateYouTubeButtonText(AdvancedTabContainer.youtubeAccountButton, ClientInstance.controller)
end

CoD.Options.AddTwitterButton = function(AdvancedTabContainer, LocalClientIndex)
	AdvancedTabContainer.twitterAccountButton = AdvancedTabContainer.buttonList:addButton(Engine.Localize("MENU_LINK_TO_TWITTER_CAPS"), Engine.Localize("MENU_LINK_TWITTER_DESC"))
	CoD.Options.UpdateTwitterButtonText(AdvancedTabContainer.twitterAccountButton, LocalClientIndex)
	if Engine.IsPlayerUnderage(LocalClientIndex) then
		AdvancedTabContainer.twitterAccountButton:disable()
		AdvancedTabContainer.twitterAccountButton.hintText = Engine.Localize("MENU_GENERIC_UNDERAGE_MESSAGE")
	else
		AdvancedTabContainer.twitterAccountButton:setActionEventName("twitter_connect")
	end
end

CoD.Options.UpdateTwitterButtonText = function(TwitterButton, LocalClientIndex)
	if not Engine.IsTwitterAccountRegistered(LocalClientIndex) then
		TwitterButton.label:setText(Engine.Localize("MENU_LINK_TO_TWITTER_CAPS"))
	else
		TwitterButton.label:setText(Engine.Localize("MENU_UNLINK_FROM_TWITTER_CAPS"))
	end
end

CoD.Options.CheckForTwitterAccount = function(AdvancedTabContainer, ClientInstance)
	if not Engine.IsTwitterAccountChecked(ClientInstance.controller) then
		return
	else
		CoD.Options.AddTwitterButton(AdvancedTabContainer, ClientInstance.controller)
		AdvancedTabContainer.twitterCheckTimer:close()
		AdvancedTabContainer.twitterCheckTimer = nil
	end
end

CoD.Options.OpenTwitterConnect = function(f31_arg0, ClientInstance)
	if not Engine.IsTwitterAccountChecked(ClientInstance.controller) or not Engine.IsTwitterAccountRegistered(ClientInstance.controller) then
		f31_arg0:openPopup("Twitter_Connect", ClientInstance.controller)
	else
		f31_arg0:openPopup("Twitter_UnRegister", ClientInstance.controller)
	end
end

CoD.Options.TwitterConnectComplete = function(AdvancedTabContainer, ClientInstance)
	CoD.Options.UpdateTwitterButtonText(AdvancedTabContainer.twitterAccountButton, ClientInstance.controller)
end

CoD.Options.AddTwitchButton = function(AdvancedTabContainer, LocalClientIndex)
	AdvancedTabContainer.twitchAccountButton = AdvancedTabContainer.buttonList:addButton(Engine.Localize("MENU_LINK_TO_TWITCH_CAPS"), Engine.Localize("MENU_LINK_TWITCH_DESC"))
	CoD.Options.UpdateTwitchButtonText(AdvancedTabContainer.twitchAccountButton, LocalClientIndex)
	if Engine.IsPlayerUnderage(LocalClientIndex) then
		AdvancedTabContainer.twitchAccountButton:disable()
		AdvancedTabContainer.twitchAccountButton.hintText = Engine.Localize("MENU_GENERIC_UNDERAGE_MESSAGE")
	else
		AdvancedTabContainer.twitchAccountButton:setActionEventName("twitch_connect")
	end
end

CoD.Options.UpdateTwitchButtonText = function(TwitchButton, LocalClientIndex)
	if not Engine.IsTwitchAccountRegistered(LocalClientIndex) then
		TwitchButton.label:setText(Engine.Localize("MENU_LINK_TO_TWITCH_CAPS"))
	else
		TwitchButton.label:setText(Engine.Localize("MENU_UNLINK_FROM_TWITCH_CAPS"))
	end
end

CoD.Options.CheckForTwitchAccount = function(AdvancedTabContainer, ClientInstance)
	if not Engine.IsTwitchAccountChecked(ClientInstance.controller) then
		return
	else
		CoD.Options.AddTwitchButton(AdvancedTabContainer, ClientInstance.controller)
		AdvancedTabContainer.twitchCheckTimer:close()
		AdvancedTabContainer.twitchCheckTimer = nil
	end
end

CoD.Options.OpenTwitchConnect = function(AdvancedTabContainer, ClientInstance)
	if not Engine.IsTwitchAccountRegistered(ClientInstance.controller) then
		AdvancedTabContainer:openPopup("Twitch_Connect", ClientInstance.controller)
	else
		AdvancedTabContainer:openPopup("Twitch_UnRegister", ClientInstance.controller)
	end
end

CoD.Options.TwitchConnectComplete = function(AdvancedTabContainer, ClientInstance)
	CoD.Options.UpdateTwitchButtonText(AdvancedTabContainer.twitchAccountButton, ClientInstance.controller)
end

CoD.Options.UpdateWindowPosition = function()
	Engine.SetHardwareProfileValue("vid_xpos", Dvar.vid_xpos:get())
	Engine.SetHardwareProfileValue("vid_ypos", Dvar.vid_ypos:get())
	Engine.SetHardwareProfileValue("sd_xa2_device_guid", UIExpression.DvarString(nil, "sd_xa2_device_guid"))
end

--Probably unused
CoD.Options.BumperControlOverride = function(f39_arg0, f39_arg1)
	if LUI.UIElement.handleGamepadButton(f39_arg0, f39_arg1) == true then
		return true
	end
	local f39_local0 = nil
	if f39_arg1.down == true then
		if f39_arg1.button == "shoulderr" then
			f39_local0 = 1
		elseif f39_arg1.button == "shoulderl" then
			f39_local0 = -1
		end
	end
	if f39_local0 ~= nil and f39_arg0.m_currentItem ~= nil then
		f39_arg0:scrollToItem(f39_arg0.m_currentItem + f39_local0, f39_arg0.m_scrollTime)
	end
end

CoD.Options.SetupTabManager = function(GenericWidget, HorizontalOffset)
	local VerticalOffset = CoD.Menu.TitleHeight + CoD.MFTabManager.TabHeight + 15
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(true, true, 0, 0)
	Widget:setTopBottom(true, true, VerticalOffset, -CoD.ButtonPrompt.Height)
	GenericWidget:addElement(Widget)
	local TabManagerVerticalOffset = CoD.Menu.TitleHeight + 15
	local GenericTabManager = CoD.MFTabManager.new(Widget, nil, nil, CoD.BOIIOrange)
	if HorizontalOffset then
		GenericTabManager:setLeftRight(false, false, -HorizontalOffset / 2, HorizontalOffset / 2)
	else
		GenericTabManager:setLeftRight(true, true, 0, 0)
	end
	GenericTabManager:setTopBottom(true, false, TabManagerVerticalOffset, TabManagerVerticalOffset + CoD.MFTabManager.TabHeight)
	GenericTabManager:setTabAlignment(LUI.Alignment.Center)
	GenericTabManager:setTabSpacing(20)
	GenericWidget.tabManager = GenericTabManager
	GenericWidget:addElement(GenericTabManager)
	return GenericTabManager
end

CoD.Options.CreateButtonList = function()
	local VerticalOffset = 20
	local GenericButtonList = CoD.ButtonList.new()
	if CoD.isSinglePlayer then
		GenericButtonList:setLeftRight(false, false, -CoD.Options.ButtonListWidth / 2, CoD.Options.ButtonListWidth / 2)
		GenericButtonList:setTopBottom(true, true, VerticalOffset, 0)
	else
		GenericButtonList:setLeftRight(true, false, 0, CoD.Options.ButtonListWidth)
		GenericButtonList:setTopBottom(true, true, VerticalOffset, 0)
		GenericButtonList.hintText:setLeftRight(true, false, 0, 800)
	end
	GenericButtonList.addHardwareProfileLeftRightSelector = CoD.Options.AddHardwareProfileLeftRightSelector
	GenericButtonList.addHardwareProfileLeftRightSlider = CoD.Options.AddHardwareProfileLeftRightSlider
	GenericButtonList.addLeftRightSelector = CoD.Options.AddLeftRightSelector
	GenericButtonList.addVoiceMeter = CoD.Options.AddVoiceMeter
	GenericButtonList.m_selectors = {}
	return GenericButtonList
end

CoD.Options.AddOptionCategories = function(OptionsMenuWidget)
	if UIExpression.IsInGame() == 0 then
		OptionsMenuWidget.systemInfoButton = CoD.ButtonPrompt.new("select", Engine.Localize("MENU_SYSTEM_INFO_CAPS"), OptionsMenuWidget, "open_system_info", nil, nil, nil, nil, "S")
		OptionsMenuWidget:addRightButtonPrompt(OptionsMenuWidget.systemInfoButton)
	end
	local OpenSettingsButton, OpenControlsButton = nil
	local OptionsMenuButtonList = CoD.ButtonList.new()
	if UIExpression.IsInGame() == 0 then
		local OptionsMenuButtonListSpacing = 30
		local HorizontalOffset = 300
		local VerticalOffset = 2 * (50 + OptionsMenuButtonListSpacing) - OptionsMenuButtonListSpacing
		OptionsMenuButtonList:setLeftRight(false, false, -HorizontalOffset / 2, HorizontalOffset / 2)
		OptionsMenuButtonList:setTopBottom(false, false, -VerticalOffset / 2, VerticalOffset / 2 + 100)
		OptionsMenuButtonList:setSpacing(OptionsMenuButtonListSpacing)
		OpenSettingsButton = OptionsMenuButtonList:addNavButton(Engine.Localize("MENU_SETTINGS_CAPS"), "open_settings")
		OpenControlsButton = OptionsMenuButtonList:addNavButton(Engine.Localize("MENU_CONTROLS_CAPS"), "open_controls")
		if not CoD.isSinglePlayer then
			OpenSettingsButton.brackets:close()
			OpenSettingsButton.m_skipAnimation = true
			OpenControlsButton.brackets:close()
			OpenControlsButton.m_skipAnimation = true
		end
	else
		if CoD.isSinglePlayer then
			OptionsMenuButtonList:setLeftRight(false, false, -CoD.ObjectiveInfoMenu.ElementWidth - CoD.ObjectiveInfoMenu.ElementSpacing / 2, -CoD.ObjectiveInfoMenu.ElementSpacing / 2)
			OptionsMenuButtonList:setTopBottom(true, true, CoD.ObjectiveInfoMenu.Pause_ButtonsTopAnchor, 0)
		else
			OptionsMenuButtonList:setLeftRight(true, false, 0, CoD.ButtonList.DefaultWidth)
			OptionsMenuButtonList:setTopBottom(true, true, CoD.Menu.TitleHeight, 0)
		end
		if not CoD.isMultiplayer then
			OptionsMenuButtonList:setButtonBackingAnimationState({
				leftAnchor = true,
				rightAnchor = true,
				left = -5,
				right = 0,
				topAnchor = true,
				bottomAnchor = true,
				top = 0,
				bottom = 0,
				material = RegisterMaterial("menu_mp_small_row"),
			})
		end
		OpenSettingsButton = OptionsMenuButtonList:addButton(Engine.Localize("MENU_SETTINGS_CAPS"))
		OpenSettingsButton:setActionEventName("open_settings")
		OpenControlsButton = OptionsMenuButtonList:addButton(Engine.Localize("MENU_CONTROLS_CAPS"))
		OpenControlsButton:setActionEventName("open_controls")
	end
	OptionsMenuWidget:addElement(OptionsMenuButtonList)
	if not OptionsMenuWidget:restoreState() then
		OpenSettingsButton:processEvent({
			name = "gain_focus",
		})
	end
	if CoD.isSinglePlayer == true and Engine.IsMenuLevel() == true then
		OptionsMenuWidget:setPreviousMenu("CampaignMenu")
	end
	Engine.SyncHardwareProfileWithDvars()
end

LUI.createMenu.OptionsMenu = function(LocalClientIndex)
	local OptionsMenuWidget = nil
	if UIExpression.IsInGame() == 1 then
		OptionsMenuWidget = CoD.InGameMenu.New("OptionsMenu", LocalClientIndex, Engine.Localize("MENU_OPTIONS_CAPS"))
		if CoD.isSinglePlayer == true then
			OptionsMenuWidget:setPreviousMenu("ObjectiveInfoMenu")
		elseif UIExpression.IsDemoPlaying(LocalClientIndex) ~= 0 then
			OptionsMenuWidget:setPreviousMenu("Demo_InGame")
		else
			OptionsMenuWidget:setPreviousMenu("class")
		end
	else
		OptionsMenuWidget = CoD.Menu.New("OptionsMenu")
		OptionsMenuWidget.anyControllerAllowed = true
		OptionsMenuWidget:addTitle(Engine.Localize("MENU_OPTIONS_CAPS"), LUI.Alignment.Center)
		if CoD.isSinglePlayer == false then
			OptionsMenuWidget:addLargePopupBackground()
		end
	end
	if CoD.isSinglePlayer == true then
		Engine.SendMenuResponse(LocalClientIndex, "luisystem", "modal_start")
	end
	OptionsMenuWidget:registerEventHandler("button_prompt_back", CoD.Options.Back)
	OptionsMenuWidget:registerEventHandler("apply_changes", CoD.Options.ApplyChanges)
	OptionsMenuWidget:registerEventHandler("open_controls", CoD.Options.OpenControls)
	OptionsMenuWidget:registerEventHandler("open_settings", CoD.Options.OpenSettings)
	OptionsMenuWidget:registerEventHandler("open_system_info", CoD.Options.OpenSystemInfo)
	OptionsMenuWidget:registerEventHandler("is_common_loaded", CoD.Options.IsCommonLoaded)
	OptionsMenuWidget:addSelectButton()
	OptionsMenuWidget:addBackButton()
	CoD.Options.AddOptionCategories(OptionsMenuWidget)
	return OptionsMenuWidget
end

CoD.OptionsSettings.TabChanged = function(OptionsSettingsWidget, SettingsTab)
	OptionsSettingsWidget.buttonList = OptionsSettingsWidget.tabManager.buttonList
	local NextFocusableTab = OptionsSettingsWidget.buttonList:getFirstChild()
	while not NextFocusableTab.m_focusable do
		NextFocusableTab = NextFocusableTab:getNextSibling()
	end
	if NextFocusableTab ~= nil then
		NextFocusableTab:processEvent({
			name = "gain_focus",
		})
	end
	CoD.OptionsSettings.CurrentTabIndex = SettingsTab.tabIndex

	if OptionsSettingsWidget.tabManager ~= nil and OptionsSettingsWidget.tabManager.currentTabHeader ~= nil and OptionsSettingsWidget.tabManager.currentTabHeader.tabBg ~= nil then
		OptionsSettingsWidget.tabManager.currentTabHeader.tabBg:setAlpha(0)
	end
end

CoD.OptionsSettings.CreateModTab = function(ModTab, LocalClientIndex)
	local ModTabContainer = LUI.UIContainer.new()
	local InGame = UIExpression.IsInGame() == 1
	local ModTabButtonList = CoD.Options.CreateButtonList()
	ModTab.buttonList = ModTabButtonList
	ModTabContainer.buttonList = ModTabButtonList
	ModTabContainer:addElement(ModTabButtonList)

	local EnemyCounterSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_ENEMY_COUNTER_CAPS"), "ui_hud_enemy_counter")
	EnemyCounterSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	EnemyCounterSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	local TimerSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_TIMER_CAPS"), "ui_hud_timer")
	TimerSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	TimerSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	local HealthBarSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_HEALTH_BAR_CAPS"), "ui_hud_health_bar")
	HealthBarSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	HealthBarSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	local ZoneNameSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_ZONE_NAME_CAPS"), "ui_hud_zone_name")
	ZoneNameSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	ZoneNameSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	ModTabButtonList:addSpacer(CoD.CoD9Button.Height / 2)

	local GameModeNameSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_GAME_MODE_NAME_CAPS"), "ui_hud_game_mode_name")
	GameModeNameSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	GameModeNameSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	local GameModeScoreSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_GAME_MODE_SCORE_CAPS"), "ui_hud_game_mode_score")
	GameModeScoreSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	GameModeScoreSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	GameModeScoreSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_MINIMAL_CAPS"), 2, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	local GameModeInfoSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_GAME_MODE_INFO_CAPS"), "ui_hud_game_mode_info")
	GameModeInfoSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	GameModeInfoSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	ModTabButtonList:addSpacer(CoD.CoD9Button.Height / 2)

	local HeadIconSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_HEAD_ICONS_CAPS"), "ui_hud_head_icons")
	HeadIconSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	HeadIconSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	local ActionSlotAreaSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_ACTION_SLOT_AREA_CAPS"), "ui_hud_action_slot_area")
	ActionSlotAreaSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_AUTOMATIC_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChangedUpdateActionSlots)
	ActionSlotAreaSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DPAD_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChangedUpdateActionSlots)
	ActionSlotAreaSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_KEY_PROMPT_CAPS"), 2, nil, CoD.OptionsSettings.Button_ApplyDvarChangedUpdateActionSlots)

	ModTabButtonList:addSpacer(CoD.CoD9Button.Height / 2)

	local FogSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_FOG_CAPS"), "r_fog_settings")
	FogSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChangedSendMenuResponse)
	FogSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChangedSendMenuResponse)

	local DofSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("PLATFORM_DEPTH_OF_FIELD_CAPS"), "r_dof_enable_settings")
	DofSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChangedSendMenuResponse)
	DofSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChangedSendMenuResponse)

	ModTabButtonList:addSpacer(CoD.CoD9Button.Height / 2)

	local CharacterDialogSelector = ModTabButtonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize("MENU_CHARACTER_DIALOG_CAPS"), "character_dialog")
	CharacterDialogSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_DISABLED_CAPS"), 0, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)
	CharacterDialogSelector:addChoice(LocalClientIndex, Engine.Localize("MENU_ENABLED_CAPS"), 1, nil, CoD.OptionsSettings.Button_ApplyDvarChanged)

	return ModTabContainer
end

LUI.createMenu.OptionsSettingsMenu = function(LocalClientIndex)
	local OptionsSettingsWidget = nil
	local InGame = UIExpression.IsInGame() == 1
	if InGame then
		OptionsSettingsWidget = CoD.InGameMenu.New("OptionsSettingsMenu", LocalClientIndex, Engine.Localize("MENU_SETTINGS_CAPS"))
	else
		OptionsSettingsWidget = CoD.Menu.New("OptionsSettingsMenu")
		OptionsSettingsWidget:addTitle(Engine.Localize("MENU_SETTINGS_CAPS"), LUI.Alignment.Center)
		OptionsSettingsWidget:addLargePopupBackground()
	end
	OptionsSettingsWidget.addApplyPrompt = CoD.Options.AddApplyPrompt
	OptionsSettingsWidget.addResetPrompt = CoD.Options.AddResetPrompt
	OptionsSettingsWidget:setPreviousMenu("OptionsMenu")
	OptionsSettingsWidget:setOwner(LocalClientIndex)
	OptionsSettingsWidget:registerEventHandler("add_apply_prompt", CoD.Options.AddApplyPrompt)
	OptionsSettingsWidget:registerEventHandler("button_prompt_back", CoD.OptionsSettings.Back)
	OptionsSettingsWidget:registerEventHandler("tab_changed", CoD.OptionsSettings.TabChanged)
	OptionsSettingsWidget:registerEventHandler("selector_changed", CoD.OptionsSettings.SelectorChanged)
	OptionsSettingsWidget:registerEventHandler("resolution_changed", CoD.OptionsSettings.ResolutionChanged)
	OptionsSettingsWidget:registerEventHandler("apply_changes", CoD.OptionsSettings.ApplyChanges)
	OptionsSettingsWidget:registerEventHandler("restore_default_settings", CoD.OptionsSettings.RestoreDefaultSettings)
	OptionsSettingsWidget:registerEventHandler("open_brightness", CoD.OptionsSettings.OpenBrightness)
	OptionsSettingsWidget:registerEventHandler("open_mature_content", CoD.OptionsSettings.OpenMatureContent)
	OptionsSettingsWidget:registerEventHandler("open_speaker_setup", CoD.AudioSettings.OpenSpeakerSetup)
	OptionsSettingsWidget:registerEventHandler("open_apply_popup", CoD.OptionsSettings.OpenApplyPopup)
	OptionsSettingsWidget:registerEventHandler("open_default_popup", CoD.OptionsSettings.OpenDefaultPopup)
	OptionsSettingsWidget:registerEventHandler("open_safe_area", CoD.OptionsSettings.OpenSafeArea)
	OptionsSettingsWidget:addSelectButton()
	OptionsSettingsWidget:addBackButton()
	if not InGame then
		OptionsSettingsWidget:addResetPrompt()
	end
	if CoD.OptionsSettings.NeedVidRestart or CoD.OptionsSettings.NeedPicmip or CoD.OptionsSettings.NeedSndRestart then
		OptionsSettingsWidget:addApplyPrompt()
	end
	if not CoD.OptionsSettings.DoNotSyncProfile then
		Engine.SyncHardwareProfileWithDvars()
	end
	CoD.OptionsSettings.DoNotSyncProfile = nil
	local SettingsTabs = CoD.Options.SetupTabManager(OptionsSettingsWidget, 700)
	SettingsTabs:addTab(LocalClientIndex, "MENU_GRAPHICS_CAPS", CoD.OptionsSettings.CreateGraphicsTab)
	SettingsTabs:addTab(LocalClientIndex, "MENU_ADVANCED_CAPS", CoD.OptionsSettings.CreateAdvancedTab)
	SettingsTabs:addTab(LocalClientIndex, "MENU_SOUND_CAPS", CoD.OptionsSettings.CreateSoundTab)
	SettingsTabs:addTab(LocalClientIndex, "MENU_VOICECHAT_CAPS", CoD.OptionsSettings.CreateVoiceChatTab)
	SettingsTabs:addTab(LocalClientIndex, "MENU_GAME_CAPS", CoD.OptionsSettings.CreateGameTab)
	SettingsTabs:addTab(LocalClientIndex, "MENU_MOD_CAPS", CoD.OptionsSettings.CreateModTab)
	if CoD.OptionsSettings.CurrentTabIndex then
		SettingsTabs:loadTab(LocalClientIndex, CoD.OptionsSettings.CurrentTabIndex)
	else
		SettingsTabs:refreshTab(LocalClientIndex)
	end
	return OptionsSettingsWidget
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
