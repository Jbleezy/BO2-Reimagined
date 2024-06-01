require("T6.MainLobby")
require("T6.Menus.MOTD")
if CoD.isWIIU then
	require("T6.Menus.InvalidAccountPopup")
	require("T6.WiiUControllerSettings")
end
if CoD.isZombie == false then
	require("T6.Menus.EliteRegistrationPopup")
	require("T6.Menus.EliteWelcomePopup")
	require("T6.Menus.EliteMarketingOptInPopup")
	require("T6.Menus.DLCPopup")
	require("T6.Menus.VotingPopup")
	require("T6.Menus.SPReminderPopup")
	require("T6.Menus.DSPPromotionPopup")
end
CoD.MainMenu = {}
CoD.MainMenu.SystemLinkLastUsedButton = 0
CoD.MainMenu.ShowStoreButtonEvent = function(MainMenuWidget, ClientInstance)
	if CoD.MainMenu.ShowStoreButton(ClientInstance.controller) == true and MainMenuWidget.ingameStoreButton == nil then
		CoD.MainMenu.AddStoreButton(MainMenuWidget)
	end
end
CoD.MainMenu.AddStoreButton = function(MainMenuWidget)
	MainMenuWidget.ingameStoreButton = MainMenuWidget.buttonList:addButton(Engine.Localize("MENU_INGAMESTORE"), nil, 5)
	MainMenuWidget.ingameStoreButton:setActionEventName("open_store")
end

CoD.MainMenu.ShowStoreButton = function(LocalClientIndex)
	if not CoD.isPC and not CoD.isWIIU and UIExpression.IsFFOTDFetched(LocalClientIndex) == 1 and Dvar.ui_inGameStoreVisible:get() == true and (CoD.isPS3 ~= true or CoD.isZombie ~= true) then
		return true
	else
		return false
	end
end

CoD.MainMenu.InitCustomDvars = function(LocalClientIndex)
	if UIExpression.DvarString(nil, "r_fog_settings") == "" then
		Engine.Exec(LocalClientIndex, "seta r_fog_settings 1")
	end
end

LUI.createMenu.MainMenu = function(LocalClientIndex)
	CoD.MainMenu.InitCustomDvars(LocalClientIndex)

	local MainMenuWidget = CoD.Menu.New("MainMenu")
	MainMenuWidget.anyControllerAllowed = true
	MainMenuWidget:registerEventHandler("open_main_lobby_requested", CoD.MainMenu.OpenMainLobbyRequested)
	MainMenuWidget:registerEventHandler("open_system_link_flyout", CoD.MainMenu.OpenSystemLinkFlyout)
	MainMenuWidget:registerEventHandler("open_system_link_lobby", CoD.MainMenu.OpenSystemLinkLobby)
	MainMenuWidget:registerEventHandler("open_server_browser", CoD.MainMenu.OpenServerBrowser)
	MainMenuWidget:registerEventHandler("open_local_match_lobby", CoD.MainMenu.OpenLocalMatchLobby)
	if CoD.isWIIU then
		MainMenuWidget:registerEventHandler("open_controls_menu", CoD.MainMenu.OpenControlsMenu)
	end
	MainMenuWidget:registerEventHandler("open_options_menu", CoD.MainMenu.OpenOptionsMenu)
	MainMenuWidget:registerEventHandler("start_zombies", CoD.MainMenu.StartZombies)
	MainMenuWidget:registerEventHandler("start_mp", CoD.MainMenu.StartMP)
	MainMenuWidget:registerEventHandler("start_sp", CoD.MainMenu.StartSP)
	MainMenuWidget:registerEventHandler("button_prompt_back", CoD.MainMenu.Back)
	MainMenuWidget:registerEventHandler("first_signed_in", CoD.MainMenu.SignedIntoLive)
	MainMenuWidget:registerEventHandler("last_signed_out", CoD.MainMenu.SignedOut)
	MainMenuWidget:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	MainMenuWidget:registerEventHandler("reopen_serverbrowser", CoD.MainMenu.ReopenServerBrowser)
	MainMenuWidget:registerEventHandler("invite_accepted", CoD.inviteAccepted)
	MainMenuWidget:registerEventHandler("button_prompt_friends", CoD.MainMenu.ButtonPromptFriendsMenu)
	MainMenuWidget:registerEventHandler("open_store", CoD.MainLobby.OpenStore)
	MainMenuWidget:registerEventHandler("showstorebutton", CoD.MainMenu.ShowStoreButtonEvent)
	if CoD.isPS3 then
		MainMenuWidget:registerEventHandler("corrupt_install", CoD.MainMenu.CorruptInstall)
	end
	if CoD.isPC then
		MainMenuWidget:registerEventHandler("open_quit_popup", CoD.MainMenu.OpenQuitPopup)
		MainMenuWidget:registerEventHandler("open_sp_switch_popup", CoD.MainMenu.OpenConfirmSwitchToSP)
		MainMenuWidget:registerEventHandler("open_mp_switch_popup", CoD.MainMenu.OpenConfirmSwitchToMP)
		MainMenuWidget:registerEventHandler("open_zm_switch_popup", CoD.MainMenu.OpenConfirmSwitchToZM)
	end
	if CoD.isZombie == false then
		MainMenuWidget:registerEventHandler("elite_registration_ended", CoD.MainMenu.elite_registration_ended)
		MainMenuWidget:registerEventHandler("elite_registration_email_popup_requested", CoD.EliteRegistrationEmailPopup.EliteRegistrationEmailPopupRequested)
		MainMenuWidget:registerEventHandler("AutoFillPopup_Closed", CoD.EliteRegistrationEmailPopup.AutoFillPopup_Closed)
		MainMenuWidget:registerEventHandler("motd_popup_closed", CoD.MainMenu.Popup_Closed)
		MainMenuWidget:registerEventHandler("dlcpopup_closed", CoD.MainMenu.Popup_Closed)
		MainMenuWidget:registerEventHandler("voting_popup_closed", CoD.MainMenu.Popup_Closed)
		MainMenuWidget:registerEventHandler("spreminder_popup_closed", CoD.MainMenu.Popup_Closed)
		MainMenuWidget:registerEventHandler("dsppromotion_popup_closed", CoD.MainMenu.Popup_Closed)
	end
	MainMenuWidget:addSelectButton()
	if not CoD.isPC then
		MainMenuWidget:addBackButton(Engine.Localize("MENU_MAIN_MENU"))
	end
	if UIExpression.AnySignedInToLive(LocalClientIndex) == 1 then
		MainMenuWidget:addFriendsButton()
	end
	if CoD.isZombie == false then
		local MainMenuBackgroundMP = LUI.UIImage.new()
		MainMenuBackgroundMP:setLeftRight(false, false, -640, 640)
		MainMenuBackgroundMP:setTopBottom(false, false, -360, 360)
		MainMenuBackgroundMP:setImage(RegisterMaterial("menu_mp_soldiers"))
		MainMenuBackgroundMP:setPriority(-1)
		MainMenuWidget:addElement(MainMenuBackgroundMP)
		local MainMenuBackgroundMP = LUI.UIImage.new()
		MainMenuBackgroundMP:setLeftRight(false, false, -640, 640)
		MainMenuBackgroundMP:setTopBottom(false, false, 180, 360)
		MainMenuBackgroundMP:setImage(RegisterMaterial("ui_smoke"))
		MainMenuBackgroundMP:setAlpha(0.1)
		MainMenuWidget:addElement(MainMenuBackgroundMP)
	end
	if CoD.isZombie then
		local f4_local1 = 192
		local f4_local2 = f4_local1 * 2
		local f4_local3 = 230
		local MainMenuBackgroundZM = LUI.UIImage.new()
		MainMenuBackgroundZM:setLeftRight(true, false, 0, f4_local2)
		MainMenuBackgroundZM:setTopBottom(true, false, f4_local3 - f4_local1 / 2, f4_local3 + f4_local1 / 2)
		MainMenuBackgroundZM:setImage(RegisterMaterial("menu_zm_title_screen"))
		MainMenuWidget:addElement(MainMenuBackgroundZM)
		CoD.GameGlobeZombie.gameGlobe.currentMenu = MainMenuWidget
	else
		local f4_local1 = 48
		local f4_local2 = f4_local1 * 8
		local f4_local3 = 210
		local f4_local4 = LUI.UIImage.new()
		f4_local4:setLeftRight(true, false, 0, f4_local2)
		f4_local4:setTopBottom(true, false, f4_local3, f4_local3 + f4_local1)
		f4_local4:setImage(RegisterMaterial("menu_mp_title_screen"))
		MainMenuWidget:addElement(f4_local4)
		local Language = Dvar.loc_language:get()
		if Language == CoD.LANGUAGE_ENGLISH or Language == CoD.LANGUAGE_BRITISH then
			local f4_local6 = 24
			local f4_local7 = f4_local6 * 16
			local f4_local8 = f4_local3 + f4_local1 + 2
			local f4_local9 = LUI.UIImage.new()
			f4_local9:setLeftRight(true, false, 0, f4_local7)
			f4_local9:setTopBottom(true, false, f4_local8, f4_local8 + f4_local6)
			f4_local9:setImage(RegisterMaterial("menu_mp_title_screen_mp"))
			MainMenuWidget:addElement(f4_local9)
		end
	end
	local f4_local1 = 8
	if CoD.isWIIU then
		f4_local1 = f4_local1 + 1
	end
	local HorizontalOffset = 6
	local f4_local3 = CoD.CoD9Button.Height * f4_local1
	local f4_local5 = -f4_local3 - CoD.ButtonPrompt.Height
	MainMenuWidget.buttonList = CoD.ButtonList.new({
		leftAnchor = true,
		rightAnchor = false,
		left = HorizontalOffset,
		right = HorizontalOffset + CoD.ButtonList.DefaultWidth,
		topAnchor = false,
		bottomAnchor = true,
		top = f4_local5,
		bottom = -CoD.ButtonPrompt.Height,
		alpha = 1,
	})
	MainMenuWidget.buttonList:setPriority(10)
	MainMenuWidget.buttonList:registerAnimationState("disabled", {
		alpha = 0.5,
	})
	MainMenuWidget:addElement(MainMenuWidget.buttonList)
	MainMenuWidget.mainLobbyButton = MainMenuWidget.buttonList:addButton(Engine.Localize("PLATFORM_XBOXLIVE_INSTR"), nil, 1)
	MainMenuWidget.mainLobbyButton:setActionEventName("open_main_lobby_requested")
	local ShowServerBrowser
	if not CoD.isPC or Dvar.developer:get() > 0 then
		ShowServerBrowser = not Engine.IsBetaBuild()
	else
		ShowServerBrowser = false
	end
	local HorizontalOffset2 = 120
	if ShowServerBrowser then
		local SystemLinkTitle = Engine.Localize("PLATFORM_SYSTEM_LINK_CAPS")
		local f4_local10_1, f4_local10_2, SystemLinkTitleTextWidth, f4_local10_4 = GetTextDimensions(SystemLinkTitle, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
		MainMenuWidget.systemLinkButton = MainMenuWidget.buttonList:addButton(SystemLinkTitle, nil, 2)
		MainMenuWidget.systemLinkButton:setActionEventName("open_system_link_flyout")
		HorizontalOffset2 = SystemLinkTitleTextWidth + 15
	end
	if not CoD.isPC and not Engine.IsBetaBuild() then
		if CoD.isWIIU then
			MainMenuWidget.localButton = MainMenuWidget.buttonList:addButton(Engine.Localize(CoD.MPZM("MENU_LOCAL_CAPS", "PLATFORM_UI_LOCAL_CAPS")), nil, 3)
		else
			MainMenuWidget.localButton = MainMenuWidget.buttonList:addButton(Engine.Localize(CoD.MPZM("MENU_LOCAL_CAPS", "ZMUI_LOCAL_CAPS")), nil, 3)
		end
		MainMenuWidget.localButton:setActionEventName("open_local_match_lobby")
	end
	if CoD.isWIIU then
		MainMenuWidget.controlsButton = MainMenuWidget.buttonList:addButton(Engine.Localize("MENU_CONTROLLER_SETTINGS_CAPS"), nil, 4)
		MainMenuWidget.controlsButton:setActionEventName("open_controls_menu")
	end
	MainMenuWidget.optionsButton = MainMenuWidget.buttonList:addButton(Engine.Localize("MENU_OPTIONS_CAPS"), nil, 4)
	MainMenuWidget.optionsButton:setActionEventName("open_options_menu")
	if CoD.MainMenu.ShowStoreButton(LocalClientIndex) == true and MainMenuWidget.ingameStoreButton == nil then
		CoD.MainMenu.AddStoreButton(MainMenuWidget)
	end
	if CoD.isPC then
		MainMenuWidget.buttonList:addSpacer(CoD.CoD9Button.Height / 2, 5)
		MainMenuWidget.spButton = MainMenuWidget.buttonList:addButton(Engine.Localize("MENU_SINGLEPLAYER_CAPS"), nil, 6)
		MainMenuWidget.spButton:setActionEventName("open_sp_switch_popup")
		if CoD.isZombie then
			MainMenuWidget.mpButton = MainMenuWidget.buttonList:addButton(Engine.Localize("MENU_MULTIPLAYER_CAPS"), nil, 7)
			MainMenuWidget.mpButton:setActionEventName("open_mp_switch_popup")
		else
			MainMenuWidget.zombieButton = MainMenuWidget.buttonList:addButton(Engine.Localize("MENU_ZOMBIE_CAPS"), nil, 7)
			MainMenuWidget.zombieButton:setActionEventName("open_zm_switch_popup")
		end
		MainMenuWidget.buttonList:addSpacer(CoD.CoD9Button.Height / 2, 8)
		MainMenuWidget.quitButton = MainMenuWidget.buttonList:addButton(Engine.Localize("MENU_QUIT_CAPS"), nil, 9)
		MainMenuWidget.quitButton:setActionEventName("open_quit_popup")
		MainMenuWidget:addLeftButtonPrompt(CoD.ButtonPrompt.new("secondary", "", MainMenuWidget, "open_quit_popup", true))
		MainMenuWidget.buttonList:setLeftRight(true, false, HorizontalOffset, HorizontalOffset + 120)
	end
	if ShowServerBrowser then
		local VerticalOffset = f4_local5 + CoD.CoD9Button.Height + 2
		local f4_local10 = CoD.CoD9Button.Height * 2 + 2
		local MenuCreateGame = Engine.Localize("MENU_CREATE_GAME_CAPS")
		local f4_local12_1, f4_local12_2, CreateGameTextWidth, f4_local12_4 = GetTextDimensions(MenuCreateGame, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
		local MenuJoinGame = Engine.Localize("MENU_JOIN_GAME_CAPS")
		local f4_local14_1, f4_local14_2, JoinGameTextWidth, f4_local14_4 = GetTextDimensions(MenuJoinGame, CoD.CoD9Button.Font, CoD.CoD9Button.TextHeight)
		local HorizontalOffset3 = CreateGameTextWidth
		if HorizontalOffset3 < JoinGameTextWidth then
			HorizontalOffset3 = JoinGameTextWidth
		end
		MainMenuWidget.systemLinkFlyoutContainer = LUI.UIElement.new({
			leftAnchor = true,
			rightAnchor = false,
			left = HorizontalOffset + HorizontalOffset2,
			right = HorizontalOffset + HorizontalOffset2 + HorizontalOffset3 + 12,
			topAnchor = false,
			bottomAnchor = true,
			top = VerticalOffset,
			bottom = VerticalOffset + f4_local10,
			alpha = 0,
		})
		MainMenuWidget.systemLinkFlyoutContainer:registerAnimationState("show", {
			alpha = 1,
		})
		MainMenuWidget:addElement(MainMenuWidget.systemLinkFlyoutContainer)
		MainMenuWidget.systemLinkFlyoutContainer:addElement(LUI.UIImage.new({
			leftAnchor = true,
			rightAnchor = false,
			left = -HorizontalOffset2 - 4,
			right = 0,
			topAnchor = true,
			bottomAnchor = false,
			top = 0,
			bottom = CoD.CoD9Button.Height,
			red = 0,
			green = 0,
			blue = 0,
			alpha = 0.8,
		}))
		MainMenuWidget.systemLinkFlyoutContainer:addElement(LUI.UIImage.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			top = 0,
			bottom = 0,
			red = 0,
			green = 0,
			blue = 0,
			alpha = 0.8,
		}))
		MainMenuWidget.systemLinkFlyoutContainer.buttonList = CoD.ButtonList.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 4,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			top = 0,
			bottom = 0,
		})
		CoD.ButtonList.DisableInput(MainMenuWidget.systemLinkFlyoutContainer.buttonList)
		MainMenuWidget.systemLinkFlyoutContainer:addElement(MainMenuWidget.systemLinkFlyoutContainer.buttonList)
		MainMenuWidget.systemLinkFlyoutContainer.buttonList.hintText:close()
		MainMenuWidget.systemLinkFlyoutContainer.buttonList.hintText = nil
		if CoD.useMouse then
			MainMenuWidget.systemLinkFlyoutContainer.buttonList:setHandleMouseButton(true)
			MainMenuWidget.systemLinkFlyoutContainer.buttonList:registerEventHandler("leftmouseup_outside", CoD.MainMenu.FlyoutBack)
		end
		MainMenuWidget.systemLinkFlyoutContainer.openSystemLinkButton = MainMenuWidget.systemLinkFlyoutContainer.buttonList:addButton(MenuCreateGame, nil, 1)
		MainMenuWidget.systemLinkFlyoutContainer.openSystemLinkButton:setActionEventName("open_system_link_lobby")
		MainMenuWidget.systemLinkFlyoutContainer.openServerBrowserButton = MainMenuWidget.systemLinkFlyoutContainer.buttonList:addButton(MenuJoinGame, nil, 1)
		MainMenuWidget.systemLinkFlyoutContainer.openServerBrowserButton:setActionEventName("open_server_browser")
	end
	if not MainMenuWidget.buttonList:restoreState() then
		MainMenuWidget.buttonList:processEvent({
			name = "gain_focus",
		})
	elseif ShowServerBrowser and MainMenuWidget.systemLinkButton:isInFocus() then
		local ClientInstance = {
			controller = LocalClientIndex,
		}
		if Engine.CheckNetConnection() == true and CoD.MainMenu.OfflinePlayAvailable(MainMenuWidget, ClientInstance, true) == 1 then
			CoD.MainMenu.OpenSystemLinkFlyout(MainMenuWidget, ClientInstance)
			if CoD.MainMenu.SystemLinkLastUsedButton == 1 then
				MainMenuWidget.systemLinkFlyoutContainer.openSystemLinkButton:processEvent({
					name = "lose_focus",
				})
				MainMenuWidget.systemLinkFlyoutContainer.openServerBrowserButton:processEvent({
					name = "gain_focus",
				})
			end
		end
	end
	HideGlobe()
	if CoD.isWIIU then
		Engine.ExecNow(0, "setclientbeingused")
	end
	if CoD.isPS3 then
		Engine.ExecNow(LocalClientIndex, "onetimeinstallcorruptioncheck")
	end
	return MainMenuWidget
end

CoD.MainMenu.CorruptInstall = function(MainMenuWidget, ClientInstance)
	local ErrorPopup = MainMenuWidget:openPopup("Error", ClientInstance.controller)
	ErrorPopup.anyControllerAllowed = true
	ErrorPopup:setMessage(Engine.Localize("MENU_PS3_INSTALL_INCOMPLETE"))
end

CoD.MainMenu.OpenPopup_EliteRegistration = function(MainMenuWidget, ClientInstance)
	if Engine.IsCustomElementScrollLanguageOverrideActive() then
		local EliteRegistrationScrollingTOSPopup = MainMenuWidget:openPopup("EliteRegistrationScrollingTOS", ClientInstance.controller)
	else
		local EliteRegistrationPopup = MainMenuWidget:openPopup("EliteRegistrationPopup", ClientInstance.controller)
	end
end

CoD.MainMenu.OpenPopup_EliteWelcome = function(MainMenuWidget, ClientInstance)
	if Engine.IsPlayerEliteFounder(ClientInstance.controller) then
		local EliteWelcomePopup = MainMenuWidget:openPopup("EliteWelcomeFounderPopup", ClientInstance.controller)
	else
		local EliteWelcomePopup = MainMenuWidget:openPopup("EliteWelcomePopup", ClientInstance.controller)
	end
end

CoD.MainMenu.elite_registration_ended = function(MainMenuWidget, ClientInstance)
	CoD.MainMenu.OpenMainLobby(MainMenuWidget, ClientInstance)
end

CoD.MainMenu.Popup_Closed = function(MainMenuWidget, ClientInstance)
	CoD.MainMenu.OpenMainLobbyRequested(MainMenuWidget, ClientInstance)
end

CoD.MainMenu.IsGuestRestricted = function(MainMenuWidget, ClientInstance)
	if not (not CoD.isPS3 or ClientInstance.controller == 0) or CoD.isXBOX and UIExpression.IsGuest(ClientInstance.controller) == 1 then
		local PopupGuestRestricted = MainMenuWidget:openPopup("popup_guest_contentrestricted", ClientInstance.controller)
		PopupGuestRestricted.anyControllerAllowed = true
		return true
	else
		return false
	end
end

CoD.MainMenu.ShowDLC0Popup = function(LocalClientIndex)
	if CoD.isXBOX == true and Engine.IsContentAvailableByPakName("dlc0") == false and UIExpression.DvarBool(nil, "ui_isDLCPopupEnabled") == 1 and CoD.perController[LocalClientIndex].IsDLCPopupViewed == nil then
		return true
	else
		return false
	end
end

CoD.MainMenu.AnyDLCMissing = function()
	local TotalDLCReleased = Dvar.ui_totalDLCReleased:get()
	for Index = 1, TotalDLCReleased, 1 do
		if not Engine.IsContentAvailableByPakName("dlc" .. Index) then
			return true
		end
	end
	return false
end

CoD.MainMenu.ShowSPReminderPopup = function(LocalClientIndex)
	if CoD.isPC then
		return false
	elseif Engine.ShouldShowSPReminder(LocalClientIndex) == true and Engine.OwnSeasonPass(LocalClientIndex) == true and CoD.MainMenu.AnyDLCMissing() == true then
		return true
	else
		return false
	end
end

CoD.MainMenu.ShowDSPPromotionPopup = function(LocalClientIndex)
	if Engine.ShouldShowDSPPromotion(LocalClientIndex) == true and Engine.OwnSeasonPass(LocalClientIndex) == false and Engine.OwnDLC1Only(LocalClientIndex) == true then
		return true
	else
		return false
	end
end

CoD.MainMenu.OpenMainLobbyRequested = function(MainMenuWidget, ClientInstance)
	if CoD.isZombie then
		if Engine.IsFeatureBanned(CoD.FEATURE_BAN_LIVE_ZOMBIE) then
			Engine.ExecNow(ClientInstance.controller, "banCheck " .. CoD.FEATURE_BAN_LIVE_ZOMBIE)
			return
		end
	elseif Engine.IsFeatureBanned(CoD.FEATURE_BAN_LIVE_MP) then
		Engine.ExecNow(ClientInstance.controller, "banCheck " .. CoD.FEATURE_BAN_LIVE_MP)
		return
	end
	if CoD.MainMenu.IsGuestRestricted(MainMenuWidget, ClientInstance) == true then
		return
	elseif Engine.CheckNetConnection() == false then
		local PopupNetConnection = MainMenuWidget:openPopup("popup_net_connection", ClientInstance.controller)
		PopupNetConnection.callingMenu = MainMenuWidget
		return
	elseif CoD.isZombie == false then
		if CoD.MainLobby.OnlinePlayAvailable(MainMenuWidget, ClientInstance) == 1 then
			Engine.Exec(ClientInstance.controller, "setclientbeingusedandprimary")
			if CoD.MainMenu.ShowDLC0Popup(ClientInstance.controller) == true then
				local f15_local0 = Engine.GetDLC0PublisherOfferId(ClientInstance.controller)
				if f15_local0 ~= nil then
					CoD.perController[ClientInstance.controller].ContentPublisherOfferID = f15_local0
					CoD.perController[ClientInstance.controller].ContentType = "0"
					local DLCPopup = MainMenuWidget:openPopup("DLCPopup", ClientInstance.controller)
					DLCPopup.callingMenu = MainMenuWidget
				end
			elseif Engine.ShouldShowMOTD(ClientInstance.controller) ~= nil and Engine.ShouldShowMOTD(ClientInstance.controller) == true then
				local MOTDPopup = MainMenuWidget:openPopup("MOTD", ClientInstance.controller)
				MOTDPopup.callingMenu = MainMenuWidget
			elseif CoD.MainMenu.ShowSPReminderPopup(ClientInstance.controller) then
				local SeasonPassReminder = MainMenuWidget:openPopup("SPReminderPopup", ClientInstance.controller)
				SeasonPassReminder.callingMenu = MainMenuWidget
			elseif CoD.MainMenu.ShowDSPPromotionPopup(ClientInstance.controller) then
				local DeluxeSeasonPassReminder = MainMenuWidget:openPopup("DSPPromotionPopup", ClientInstance.controller)
				DeluxeSeasonPassReminder.callingMenu = MainMenuWidget
			elseif Engine.ShouldShowVoting(ClientInstance.controller) == true then
				local VotingPopup = MainMenuWidget:openPopup("VotingPopup", ClientInstance.controller)
				VotingPopup.callingMenu = MainMenuWidget
			elseif Engine.ERegPopup_ShouldShow(ClientInstance.controller) == 1 then
				CoD.MainMenu.OpenPopup_EliteRegistration(MainMenuWidget, ClientInstance)
			elseif Engine.EWelcomePopup_ShouldShow(ClientInstance.controller) == 1 then
				CoD.MainMenu.OpenPopup_EliteWelcome(MainMenuWidget, ClientInstance)
			elseif Engine.EMarketingOptInPopup_ShouldShow(ClientInstance.controller) == true then
				MainMenuWidget:openPopup("EliteMarketingOptInPopup", ClientInstance.controller)
			elseif CoD.isPS3 and Engine.IsChatRestricted(ClientInstance.controller) then
				local PopupChatRestricted = MainMenuWidget:openPopup("popup_chatrestricted", ClientInstance.controller)
				PopupChatRestricted.callingMenu = MainMenuWidget
			else
				CoD.perController[ClientInstance.controller].IsDLCPopupViewed = nil
				CoD.MainMenu.OpenMainLobby(MainMenuWidget, ClientInstance)
			end
		end
	elseif CoD.MainLobby.OnlinePlayAvailable(MainMenuWidget, ClientInstance) == 1 then
		Engine.Exec(ClientInstance.controller, "setclientbeingusedandprimary")
		if Engine.ShouldShowMOTD(ClientInstance.controller) then
			local MOTDPopup = MainMenuWidget:openPopup("MOTD", ClientInstance.controller)
			MOTDPopup.callingMenu = MainMenuWidget
		elseif CoD.isPS3 and Engine.IsChatRestricted(ClientInstance.controller) then
			local PopupChatRestricted = MainMenuWidget:openPopup("popup_chatrestricted", ClientInstance.controller)
			PopupChatRestricted.callingMenu = MainMenuWidget
		else
			CoD.MainMenu.OpenMainLobby(MainMenuWidget, ClientInstance)
		end
	end
end

CoD.MainMenu.OpenMainLobby = function(MainMenuWidget, ClientInstance)
	if CoD.MainLobby.OnlinePlayAvailable(MainMenuWidget, ClientInstance) == 1 then
		if CoD.isZombie then
			if Engine.IsFeatureBanned(CoD.FEATURE_BAN_LIVE_ZOMBIE) then
				Engine.ExecNow(ClientInstance.controller, "banCheck " .. CoD.FEATURE_BAN_LIVE_ZOMBIE)
				return
			end
		elseif Engine.IsFeatureBanned(CoD.FEATURE_BAN_LIVE_MP) then
			Engine.ExecNow(ClientInstance.controller, "banCheck " .. CoD.FEATURE_BAN_LIVE_MP)
			return
		end
		MainMenuWidget.buttonList:saveState()
		Engine.SessionModeSetOnlineGame(true)
		Engine.Exec(ClientInstance.controller, "xstartprivateparty")
		Engine.Exec(ClientInstance.controller, "party_statechanged")
		CoD.MainMenu.InitializeLocalPlayers(ClientInstance.controller)
		local MainLobbyMenu = MainMenuWidget:openMenu("MainLobby", ClientInstance.controller)
		Engine.Exec(ClientInstance.controller, "session_rejoinsession " .. CoD.SESSION_REJOIN_CHECK_FOR_SESSION)
		if CoD.isZombie then
			CoD.GameGlobeZombie.gameGlobe.currentMenu = MainLobbyMenu
		end
		MainMenuWidget:close()
	end
end

CoD.MainMenu.OpenControlsMenu = function(MainMenuWidget, ClientInstance)
	if CoD.MainMenu.OfflinePlayAvailable(MainMenuWidget, ClientInstance) == 0 then
		return
	else
		CoD.MainMenu.InitializeLocalPlayers(ClientInstance.controller)
		MainMenuWidget:openPopup("WiiUControllerSettings", ClientInstance.controller, true)
		Engine.PlaySound("cac_screen_fade")
	end
end

CoD.MainMenu.OpenOptionsMenu = function(MainMenuWidget, ClientInstance)
	if CoD.MainMenu.OfflinePlayAvailable(MainMenuWidget, ClientInstance) == 0 then
		return
	else
		CoD.MainMenu.InitializeLocalPlayers(ClientInstance.controller)
		MainMenuWidget:openPopup("OptionsMenu", ClientInstance.controller)
		Engine.PlaySound("cac_screen_fade")
	end
end

CoD.MainMenu.OpenLocalMatchLobby = function(MainMenuWidget, ClientInstance)
	if CoD.MainMenu.IsGuestRestricted(MainMenuWidget, ClientInstance) == true then
		return
	elseif CoD.MainMenu.OfflinePlayAvailable(MainMenuWidget, ClientInstance) == 0 then
		return
	end
	MainMenuWidget.buttonList:saveState()
	CoD.MainMenu.InitializeLocalPlayers(ClientInstance.controller)
	CoD.SwitchToLocalLobby(ClientInstance.controller)
	if CoD.isZombie == true then
		MainMenuWidget:openMenu("SelectMapZM", ClientInstance.controller)
		ShowGlobe()
	else
		MainMenuWidget:openMenu("SplitscreenGameLobby", ClientInstance.controller)
	end
	MainMenuWidget:close()
end

CoD.MainMenu.OfflinePlayAvailable = function(MainMenuWidget, ClientInstance, f20_arg2)
	if UIExpression.IsSignedIn(ClientInstance.controller) == 0 then
		if f20_arg2 ~= nil and f20_arg2 == true then
			return 0
		elseif CoD.isPS3 then
			if UIExpression.IsPrimaryLocalClient(ClientInstance.controller) == 1 then
				Engine.Exec(ClientInstance.controller, "xsigninlive")
			else
				Engine.Exec(ClientInstance.controller, "signclientin")
			end
		else
			Engine.Exec(ClientInstance.controller, "xsignin")
			if CoD.isPC then
				return 1
			end
		end
		return 0
	else
		return 1
	end
end

CoD.MainMenu.StartZombies = function(MainMenuWidget, ClientInstance)
	Engine.Exec(ClientInstance.controller, "startZombies")
end

CoD.MainMenu.StartMP = function(MainMenuWidget, ClientInstance)
	Engine.Exec(ClientInstance.controller, "startMultiplayer")
end

CoD.MainMenu.StartSP = function(MainMenuWidget, ClientInstance)
	Engine.Exec(ClientInstance.controller, "startSingleplayer")
end

CoD.MainMenu.OpenQuitPopup = function(MainMenuWidget, ClientInstance)
	MainMenuWidget:openPopup("QuitPopup", ClientInstance.controller)
end

CoD.MainMenu.OpenConfirmSwitchToSP = function(MainMenuWidget, ClientInstance)
	MainMenuWidget:openPopup("SwitchToSPPopup", ClientInstance.controller)
end

CoD.MainMenu.OpenConfirmSwitchToMP = function(MainMenuWidget, ClientInstance)
	MainMenuWidget:openPopup("SwitchToMPPopup", ClientInstance.controller)
end

CoD.MainMenu.OpenConfirmSwitchToZM = function(MainMenuWidget, ClientInstance)
	MainMenuWidget:openPopup("SwitchToZMPopup", ClientInstance.controller)
end

CoD.MainMenu.OpenSystemLinkFlyout = function(MainMenuWidget, ClientInstance)
	if CoD.MainMenu.IsGuestRestricted(MainMenuWidget, ClientInstance) == true then
		return
	elseif Engine.CheckNetConnection() == false then
		local PopupNetConnection = MainMenuWidget:openPopup("popup_net_connection", ClientInstance.controller)
		PopupNetConnection.callingMenu = MainMenuWidget
		return
	elseif CoD.MainMenu.OfflinePlayAvailable(MainMenuWidget, ClientInstance) == 0 then
		return
	end
	MainMenuWidget.systemLinkFlyoutContainer:animateToState("show")
	CoD.ButtonList.DisableInput(MainMenuWidget.buttonList)
	MainMenuWidget.buttonList:animateToState("disabled")
	CoD.ButtonList.EnableInput(MainMenuWidget.systemLinkFlyoutContainer.buttonList)
	MainMenuWidget.systemLinkFlyoutContainer.openSystemLinkButton:processEvent({
		name = "gain_focus",
	})
	if MainMenuWidget.backButton ~= nil then
		MainMenuWidget.backButton:close()
	end
	MainMenuWidget:addBackButton()
	MainMenuWidget:registerEventHandler("button_prompt_back", CoD.MainMenu.CloseSystemLinkFlyout)
end

CoD.MainMenu.CloseSystemLinkFlyout = function(MainMenuWidget, f29_arg1)
	MainMenuWidget.systemLinkFlyoutContainer:animateToState("default")
	CoD.ButtonList.EnableInput(MainMenuWidget.buttonList)
	MainMenuWidget.buttonList:animateToState("default")
	MainMenuWidget.systemLinkFlyoutContainer.openSystemLinkButton:processEvent({
		name = "lose_focus",
	})
	MainMenuWidget.systemLinkFlyoutContainer.openServerBrowserButton:processEvent({
		name = "lose_focus",
	})
	CoD.ButtonList.DisableInput(MainMenuWidget.systemLinkFlyoutContainer.buttonList)
	if MainMenuWidget.backButton ~= nil then
		MainMenuWidget.backButton:close()
	end
	Engine.PlaySound("cac_cmn_backout")
	MainMenuWidget:addBackButton(Engine.Localize("MENU_MAIN_MENU"))
	MainMenuWidget:registerEventHandler("button_prompt_back", CoD.MainMenu.Back)
end

CoD.MainMenu.FlyoutBack = function(FlyoutButtonList, ClientInstance)
	if FlyoutButtonList.m_backReady then
		FlyoutButtonList:dispatchEventToParent({
			name = "button_prompt_back",
			controller = ClientInstance.controller,
		})
		FlyoutButtonList.m_backReady = nil
	else
		FlyoutButtonList.m_backReady = true
	end
end

CoD.MainMenu.OpenSystemLinkLobby = function(MainMenuWidget, ClientInstance)
	if CoD.MainMenu.IsGuestRestricted(MainMenuWidget, ClientInstance) == true then
		return
	elseif Engine.CheckNetConnection() == false then
		local PopupNetConnection = MainMenuWidget:openPopup("popup_net_connection", ClientInstance.controller)
		PopupNetConnection.callingMenu = MainMenuWidget
		return
	elseif CoD.MainMenu.OfflinePlayAvailable(MainMenuWidget, ClientInstance) == 0 then
		return
	end
	MainMenuWidget.buttonList:saveState()
	CoD.MainMenu.SystemLinkLastUsedButton = 0
	CoD.MainMenu.InitializeLocalPlayers(ClientInstance.controller)
	CoD.SwitchToSystemLinkLobby(ClientInstance.controller)
	if CoD.isZombie == true then
		MainMenuWidget:openMenu("SelectMapZM", ClientInstance.controller)
		ShowGlobe()
	else
		MainMenuWidget:openMenu("PrivateLocalGameLobby", ClientInstance.controller)
	end
	MainMenuWidget:close()
end

CoD.MainMenu.OpenServerBrowser = function(MainMenuWidget, ClientInstance)
	if CoD.MainMenu.IsGuestRestricted(MainMenuWidget, ClientInstance) == true then
		return
	else
		Engine.Exec(ClientInstance.controller, "loadcommonff")
		if Engine.CheckNetConnection() == false then
			local PopupNetConnection = MainMenuWidget:openPopup("popup_net_connection", ClientInstance.controller)
			PopupNetConnection.callingMenu = MainMenuWidget
			return
		elseif CoD.MainMenu.OfflinePlayAvailable(MainMenuWidget, ClientInstance) == 0 then
			return
		else
			MainMenuWidget.buttonList:saveState()
			CoD.MainMenu.SystemLinkLastUsedButton = 1
			CoD.MainMenu.InitializeLocalPlayers(ClientInstance.controller)
			Engine.ServerListUpdateFilter(ClientInstance.controller)
			MainMenuWidget:openPopup("ServerBrowser", ClientInstance.controller)
		end
	end
end

CoD.MainMenu.ReopenServerBrowser = function(MainMenuWidget, ClientInstance)
	CoD.resetGameModes()
	if MainMenuWidget.systemLinkButton:isInFocus() then
		return
	else
		MainMenuWidget.buttonList:processEvent({
			name = "lose_focus",
		})
		MainMenuWidget.systemLinkButton:processEvent({
			name = "gain_focus",
		})
		CoD.MainMenu.OpenSystemLinkFlyout(MainMenuWidget, ClientInstance)
		MainMenuWidget.systemLinkFlyoutContainer.openSystemLinkButton:processEvent({
			name = "lose_focus",
		})
		MainMenuWidget.systemLinkFlyoutContainer.openServerBrowserButton:processEvent({
			name = "gain_focus",
		})
		CoD.MainMenu.OpenServerBrowser(MainMenuWidget, ClientInstance)
	end
end

CoD.MainMenu.Leave = function(f34_arg0, ClientInstance)
	Dvar.ui_changed_exe:set(1)
	Engine.Exec(ClientInstance.controller, "wait;wait;wait")
	Engine.Exec(ClientInstance.controller, "startSingleplayer")
end

CoD.MainMenu.Back = function(MainMenuWidget, ClientInstance)
	local MainMenuQuit = {
		params = {},
		titleText = Engine.Localize("MENU_MAIN_MENU_CAPS"),
	}
	if not CoD.isZombie then
		table.insert(MainMenuQuit.params, {
			leaveHandler = CoD.MainMenu.StartSP,
			leaveEvent = "start_sp",
			leaveText = Engine.Localize("MENU_CAMPAIGN"),
		})
		table.insert(MainMenuQuit.params, {
			leaveHandler = CoD.MainMenu.StartZombies,
			leaveEvent = "start_zombies",
			leaveText = Engine.Localize("MENU_ZOMBIE"),
		})
	else
		table.insert(MainMenuQuit.params, {
			leaveHandler = CoD.MainMenu.StartSP,
			leaveEvent = "start_sp",
			leaveText = Engine.Localize("MENU_CAMPAIGN"),
		})
		table.insert(MainMenuQuit.params, {
			leaveHandler = CoD.MainMenu.StartMP,
			leaveEvent = "start_mp",
			leaveText = Engine.Localize("MENU_MULTIPLAYER"),
		})
	end
	local LeavePopup = MainMenuWidget:openPopup("ConfirmLeave", ClientInstance.controller, MainMenuQuit)
	LeavePopup.anyControllerAllowed = true
end

CoD.MainMenu.ButtonPromptFriendsMenu = function(MainMenuWidget, ClientInstance)
	if UIExpression.IsGuest(ClientInstance.controller) == 1 then
		local FriendsMenuPopup = MainMenuWidget:openPopup("popup_guest_contentrestricted", ClientInstance.controller)
		FriendsMenuPopup.anyControllerAllowed = true
		FriendsMenuPopup:setOwner(ClientInstance.controller)
		return
	elseif UIExpression.IsSignedInToLive(ClientInstance.controller) == 0 then
		local FriendsMenuPopup = MainMenuWidget:openPopup("Error", ClientInstance.controller)
		FriendsMenuPopup:setMessage(Engine.Localize("XBOXLIVE_FRIENDS_UNAVAILABLE"))
		FriendsMenuPopup.anyControllerAllowed = true
		return
	elseif UIExpression.IsContentRatingAllowed(ClientInstance.controller) == 0 or UIExpression.IsAnyControllerMPRestricted() == 1 or not Engine.HasMPPrivileges(ClientInstance.controller) then
		local FriendsMenuPopup = MainMenuWidget:openPopup("Error", ClientInstance.controller)
		FriendsMenuPopup:setMessage(Engine.Localize("XBOXLIVE_MPNOTALLOWED"))
		FriendsMenuPopup.anyControllerAllowed = true
		return
	elseif UIExpression.AreStatsFetched(ClientInstance.controller) == 0 then
		return
	elseif not CoD.isPS3 or UIExpression.IsSubUser(ClientInstance.controller) ~= 1 then
		local FriendsMenuPopup = MainMenuWidget:openPopup("FriendsList", ClientInstance.controller)
		CoD.MainMenu.InitializeLocalPlayers(ClientInstance.controller)
		FriendsMenuPopup:setOwner(ClientInstance.controller)
	end
end

CoD.MainMenu.SignedIntoLive = function(MainMenuWidget, f37_arg1)
	if MainMenuWidget.friendsButton == nil then
		MainMenuWidget:addFriendsButton()
	end
end

CoD.MainMenu.SignedOut = function(MainMenuWidget, f38_arg1)
	if MainMenuWidget.friendsButton ~= nil then
		MainMenuWidget.friendsButton:close()
		MainMenuWidget.friendsButton = nil
	end
end

CoD.MainMenu.InitializeLocalPlayers = function(LocalClientIndex)
	Engine.ExecNow(LocalClientIndex, "disableallclients")
	Engine.ExecNow(LocalClientIndex, "setclientbeingusedandprimary")
end

LUI.createMenu.VCS = function(f40_arg0)
	local f40_local0 = CoD.Menu.New("VCS")
	f40_local0.anyControllerAllowed = true
	f40_local0:addElement(LUI.UIImage.new({
		left = 0,
		top = 0,
		right = 1080,
		bottom = 600,
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = false,
		bottomAnchor = false,
		red = 1,
		green = 1,
		blue = 1,
		alpha = 1,
		material = RegisterMaterial("vcs_0"),
	}))
	return f40_local0
end
