require("T6.CoDBase")
require("T6.HUD.OffhandIcons")
require("T6.HUD.AmmoCounter")
require("T6.HUD.DeadSpectate")
require("T6.HUD.GameMessages")
require("T6.HUD.GameTimer")
require("T6.HUD.GrenadeEffect")
require("T6.HUD.InGameMenus")
require("T6.HUD.Killcam")
require("T6.HUD.ManageSegments")
require("T6.HUD.Migration")
require("T6.HUD.ReaperHUD")
require("T6.HUD.ScoreBoard")
require("T6.HUD.ScoreFeed")
require("T6.HUD.TurretHUD")
require("T6.HUD.Spectate")
require("T6.HUD.WeaponLabel")
require("T6.HUD.Loading")
if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
	require("T6.HUD.DemoHighlightReel")
	require("T6.HUD.DemoHUD")
	require("T6.HUD.DemoInGame")
	require("T6.HUD.DemoPopup")
end
if CoD.isZombie == true then
	require("T6.Zombie.BaseZombie")
	require("T6.Zombie.Hud3DScoreBoardZombie")
	require("T6.Zombie.HudBuildablesZombie")
	require("T6.Zombie.HudCompetitiveScoreboardZombie")
	require("T6.Zombie.HudDPadAreaZombie")
	require("T6.Zombie.HudPerksZombie")
	require("T6.Zombie.HudPowerUpsZombie")
	require("T6.Zombie.HudRoundStatusZombie")
	require("T6.Zombie.HudTimerZombie")
	require("T6.Zombie.OtherAmmoCounters")
else
	require("T6.VcsMenu")
	require("T6.HUD.AirVehicleHUD")
	require("T6.HUD.AITank")
	require("T6.HUD.AmmoArea")
	require("T6.HUD.BombTimer")
	require("T6.HUD.ChopperGunnerHUD")
	require("T6.HUD.HUDDigit")
	require("T6.HUD.IngameVoipDock")
	require("T6.HUD.NamePlate")
	require("T6.HUD.PredatorHUD")
	require("T6.HUD.QRDrone")
	require("T6.HUD.RewardSelection")
	require("T6.HUD.ScoreArea")
	require("T6.HUD.ScoreBottomLeft")
	require("T6.HUD.ScorePopup")
	require("T6.HUD.NotificationPopups")
	require("T6.HUD.Compass")
	require("T6.HUD.gametypes.GametypeBase")
	require("T6.HUD.gametypes.ctf")
	require("T6.HUD.gametypes.dem")
	require("T6.HUD.gametypes.dom")
	require("T6.HUD.gametypes.hq")
	require("T6.HUD.gametypes.koth")
	require("T6.HUD.gametypes.oic")
	require("T6.HUD.gametypes.oneflag")
	require("T6.Menus.LiveStream")
end
if CoD.isWIIU or CoD.isPC then
	require("T6.LiveNotification")
end
if CoD.isWIIU then
	require("T6.WiiUSystemServices")
end
local HUD_OpenIngameMenu, HUD_SetupEventHandlers, HUD_KillcamUpdate, HUD_UpdateKillstreakHud, HUD_ForceKillKillstreakHud, HUD_SelectingLocationUpdate, HUD_GameEndedUpdate, HUD_ReloadShoutcasterHud, HUD_UpdateVehicleHud, HUD_FactionPopup, FactionPopupAddTextEvent, f0_local11, f0_local12 = nil

function HUD_IngameMenuClosed() end

LUI.createMenu.HUD = function(LocalClientIndex)
	local HUDWidget = CoD.Menu.NewFromState("HUD", {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = true,
		top = 0,
		bottom = 0,
	})
	if not LUI.roots.UIRootFull.safeAreaOverlay then
		LUI.roots.UIRootFull.safeAreaOverlay = CoD.SetupSafeAreaOverlay()
		LUI.roots.UIRootFull:addElement(LUI.roots.UIRootFull.safeAreaOverlay)
	end
	HUDWidget:setOwner(LocalClientIndex)
	HUDWidget.controller = LocalClientIndex
	HUD_SetupEventHandlers(HUDWidget)
	HUDWidget:registerEventHandler("debug_reload", HUD_DebugReload)
	HUDWidget:registerEventHandler("update_safe_area", HUD_UpdateSafeArea)
	if CoD.isWIIU then
		HUDWidget:registerEventHandler("occlusion_change", HUD_OcclusionChange)
	end
	if CoD.isPC then
		Engine.Exec(LocalClientIndex, "ui_keyboard_cancel")
		Engine.SetForceMouseRootFull(false)
	end
	Engine.PlayMenuMusic("")
	HUDWidget.loadingMenu = LUI.createMenu.Loading(LocalClientIndex)
	HUDWidget:addElement(HUDWidget.loadingMenu)
	return HUDWidget
end

function HUD_UpdateSafeArea(HUDWidget, ClientInstance)
	if HUDWidget.SpectateHUD ~= nil then
		HUDWidget.SpectateHUD:processEvent(ClientInstance)
	end
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

function HUD_OcclusionChange(HUDWidget, ClientInstance)
	CoD.Menu.OcclusionChange(HUDWidget, ClientInstance)
	Engine.EnableWiiURemotePointer(ClientInstance.controller, not ClientInstance.occluded)
end

HUD_SetupEventHandlers = function(HUDWidget)
	HUD_SetupEventHandlers_Common(HUDWidget)
	if CoD.isZombie == false then
		HUD_SetupEventHandlers_Multiplayer(HUDWidget)
	else
		HUD_SetupEventHandlers_Zombie(HUDWidget)
	end
end

function HUD_Hide(HUDWidget, ClientInstance)
	HUDWidget:setAlpha(0)
end

function HUD_Show(HUDWidget, ClientInstance)
	HUDWidget:setAlpha(1)
end

local WiiToggleFriends = function(HUDWidget, ClientInstance)
	if LUI.roots["UIRoot" .. ClientInstance.controller].ingameFriendsList then
		LUI.roots[rootName]:processEvent({
			name = "closeFriendsList",
			controller = ClientInstance.controller,
		})
		LUI.roots[rootName]:processEvent({
			name = "closeallpopups",
			controller = ClientInstance.controller,
		})
	else
		HUDWidget:openPopup("FriendsList", ClientInstance.controller)
	end
end

local PCInputSourceChanged = function(HUDWidget, ClientInstance)
	if HUDWidget.scoreBoard then
		HUDWidget.scoreBoard:processEvent(ClientInstance)
	end
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

function HUD_SetupEventHandlers_Common(HUDWidget)
	HUDWidget:registerEventHandler("destroy_hud", HUD_DestroyHUD)
	HUDWidget:registerEventHandler("first_snapshot", HUD_FirstSnapshot)
	HUDWidget:registerEventHandler("open_ingame_menu", HUD_OpenIngameMenu)
	HUDWidget:registerEventHandler("close_ingame_menu", HUD_CloseInGameMenu)
	HUDWidget:registerEventHandler("open_scoreboard_menu", HUD_OpenScoreBoard)
	HUDWidget:registerEventHandler("close_scoreboard_menu", HUD_CloseScoreBoard)
	HUDWidget:registerEventHandler("open_migration_menu", HUD_StartMigration)
	HUDWidget:registerEventHandler("spectate_hide_gamehud", HUD_Hide)
	HUDWidget:registerEventHandler("spectate_show_gamehud", HUD_Show)
	HUDWidget:registerEventHandler("fullscreen_viewport_start", HUD_FullscreenStart)
	HUDWidget:registerEventHandler("fullscreen_viewport_stop", HUD_FullscreenStop)
	if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
		HUDWidget:registerEventHandler("activate_demo_information_screen", CoD.DemoHUD.ActivateInformationScreen)
		HUDWidget:registerEventHandler("open_demo_ingame_menu", CoD.DemoInGame.Open)
		HUDWidget:registerEventHandler("open_dollycam_marker_options", CoD.DemoPopup.OpenDollyCamMarkerOptionsPopup)
		HUDWidget:registerEventHandler("open_demo_save_popup", CoD.DemoPopup.OpenSavePopup)
		HUDWidget:registerEventHandler("open_demo_manage_segments", CoD.ManageSegments.Open)
	end
	if CoD.isWIIU or CoD.isPC then
		HUDWidget:registerEventHandler("live_notification", CoD.LiveNotifications.NotifyMessage)
	end
	if CoD.isWIIU then
		HUDWidget:registerEventHandler("drc_toggle_friends", WiiToggleFriends)
	end
	if CoD.isPC then
		HUDWidget:registerEventHandler("input_source_changed", PCInputSourceChanged)
	end
end

function HUD_SetupEventHandlers_Multiplayer(HUDWidget)
	HUDWidget:registerEventHandler("hud_update_killstreak_hud", HUD_UpdateKillstreakHud)
	HUDWidget:registerEventHandler("hud_force_kill_killstreak_hud", HUD_ForceKillKillstreakHud)
	HUDWidget:registerEventHandler("hud_update_vehicle", HUD_UpdateVehicleHud)
	HUDWidget:registerEventHandler("faction_popup", HUD_FactionPopup)
	HUDWidget:registerEventHandler("hud_update_team_change", HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SPECTATING_CLIENT, HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_TEAM_SPECTATOR, HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_spectate", HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_GAME_ENDED, HUD_GameEndedUpdate)
	HUDWidget:registerEventHandler("hud_update_refresh", HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_KILLCAM, HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_FINAL_KILLCAM, HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_ROUND_END_KILLCAM, HUD_UpdateRefresh)
	HUDWidget:registerEventHandler("hud_update_bit_" .. CoD.BIT_SELECTING_LOCATION, HUD_SelectingLocationUpdate)
	HUDWidget:registerEventHandler("reload_shoutcaster_hud", HUD_ReloadShoutcasterHud)
	if CoD.isPC then
		HUDWidget:registerEventHandler("chooseclass_hotkey", HUD_Handle_ChooseClass_HotKey)
	end
end

function HUD_SetupEventHandlers_Zombie(HUDWidget)
	CoD.Zombie.IsSurvivalUsingCIAModel = false
	HUDWidget:registerEventHandler("hud_update_survival_team", HUD_UpdateSurvivalTeamZombie)
	HUDWidget:registerEventHandler("allow_round_animation", HUD_AllowRoundAnimation)
end

function HUD_AllowRoundAnimation(HUDWidget, ClientInstance)
	CoD.Zombie.AllowRoundAnimation = ClientInstance.allow
end

function HUD_UpdateSurvivalTeamZombie(HUDWidget, ClientInstance)
	CoD.Zombie.IsSurvivalUsingCIAModel = ClientInstance.data[1] == 1
end

function HUD_FirstSnapshot(HUDWidget, ClientInstance)
	HUDWidget:dispatchEventToChildren({
		name = "close_all_popups",
		controller = ClientInstance.controller,
	})
	HUDWidget:removeAllChildren()
	HUDWidget:setOwner(ClientInstance.controller)
	HUDWidget.controller = ClientInstance.controller
	HUD_FirstSnapshot_Common(HUDWidget, ClientInstance)
	if CoD.isZombie == false then
		HUD_FirstSnapshot_Multiplayer(HUDWidget, ClientInstance)
	else
		HUD_FirstSnapshot_Zombie(HUDWidget, ClientInstance)
	end
	Engine.ForceHUDRefresh(ClientInstance.controller)
end

function HUD_StartMigration(HUDWidget, ClientInstance)
	HUDWidget:removeAllChildren()
	HUDWidget:addElement(LUI.createMenu.migration_ingame(ClientInstance.controller, HUDWidget))
end

function HUD_FirstSnapshot_Common(HUDWidget, ClientInstance)
	local safeArea = CoD.Menu.NewSafeAreaFromState("hud_safearea", ClientInstance.controller)
	HUDWidget:addElement(safeArea)
	HUDWidget.safeArea = safeArea

	local f17_local1 = CoD.GrenadeEffect.new()
	f17_local1:setLeftRight(true, true, 0, 0)
	f17_local1:setTopBottom(true, true, 0, 0)
	HUDWidget:addElement(f17_local1)
	if CoD.isZombie == true then
		CoD.Zombie.SoloQuestMode = false
		local f17_local2 = Engine.PartyGetPlayerCount()
		if f17_local2 == 1 and (CoD.isOnlineGame() == false or Engine.GameModeIsMode(CoD.GAMEMODE_PRIVATE_MATCH) == false) then
			CoD.Zombie.SoloQuestMode = true
		end
		if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == true and f17_local2 > 2 then
			CoD.Zombie.LocalSplitscreenMultiplePlayers = true
		end
	end
	HUD_CloseScoreBoard(HUDWidget, ClientInstance)
	HUDWidget.scoreBoard = LUI.createMenu.Scoreboard(ClientInstance.controller)
	HUDWidget.scoreboardUpdateTimer = LUI.UITimer.new(1000, {
		name = "update_scoreboard",
		controller = ClientInstance.controller,
	}, false)
	HUDWidget:addElement(LUI.createMenu.DeadSpectate(ClientInstance.controller))
end

function HUD_FirstSnapshot_Multiplayer(HUDWidget, ClientInstance)
	if Engine.GetGametypeSetting("loadoutKillstreaksEnabled") == 1 then
		HUDWidget:addElement(LUI.createMenu.RewardSelection(ClientInstance.controller))
	end
	HUDWidget:addElement(LUI.createMenu.ScoreBottomLeft(ClientInstance.controller))
	HUDWidget:addElement(LUI.createMenu.AmmoArea(ClientInstance.controller))
	local f18_local0 = "gametype_" .. UIExpression.DvarString(nil, "g_gametype")
	local f18_local1 = LUI.createMenu[f18_local0]
	if f18_local1 ~= nil then
		HUDWidget:addElement(f18_local1(ClientInstance.controller))
	else
		HUDWidget:addElement(CoD.GametypeBase.new(f18_local0, ClientInstance.controller))
	end
	local f18_local2 = nil
	if CoD.isZombie == true then
		f18_local2 = CoD.ScorePopup.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			top = 0,
			bottom = 0,
		})
	else
		f18_local2 = CoD.ScorePopup.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			top = 0,
			bottom = 0,
		})
	end
	HUDWidget:addElement(f18_local2)
	HUDWidget:addElement(LUI.createMenu.NotificationPopups(ClientInstance.controller))
	CoD.Compass.AddMinimap(HUDWidget)
	local f18_local3 = 5
	HUDWidget.ingameTalker = CoD.IngameVoipDock.New()
	HUDWidget.ingameTalker:setLeftRight(false, true, f18_local3, f18_local3 + CoD.IngameVoipDock.IconWidth)
	HUDWidget.ingameTalker:setTopBottom(true, false, 0, CoD.IngameVoipDock.IconWidth)
	HUDWidget.miniMapContainer:addElement(HUDWidget.ingameTalker)
	if not Engine.IsSplitscreen() then
		CoD.GameMessages.AddObituaryWindow(HUDWidget, {
			leftAnchor = true,
			rightAnchor = false,
			left = 13,
			right = 277,
			topAnchor = false,
			bottomAnchor = true,
			top = -249,
			bottom = -149,
		})
	end
	CoD.GameMessages.BoldGameMessagesWindow(HUDWidget, {
		leftAnchor = false,
		rightAnchor = false,
		left = 0,
		right = 0,
		topAnchor = false,
		bottomAnchor = false,
		top = 50,
		bottom = 70,
	})
	if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
		CoD.LiveStream.AddInGameStatusWidget(HUDWidget, ClientInstance.controller, {
			leftAnchor = false,
			rightAnchor = true,
			left = -200,
			right = 0,
			topAnchor = true,
			bottomAnchor = false,
			top = 0,
			bottom = 150,
		})
		CoD.DemoHUD.AddHUDWidgets(HUDWidget, ClientInstance)
	end
end

function HUD_FirstSnapshot_Zombie(HUDWidget, ClientInstance)
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(true, true, 0, 0)
	Widget:setTopBottom(true, true, 0, 0)
	HUDWidget:addElement(Widget)
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC3Maps) then
		Widget:registerEventHandler("time_bomb_hud_toggle", HUD_ToggleZombieHudContainer)
	end
	Widget:addElement(LUI.createMenu.PerksArea(ClientInstance.controller))
	Widget:addElement(LUI.createMenu.PowerUpsArea(ClientInstance.controller))
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) then
		if CoD.Zombie.GAMETYPE_ZCLASSIC == Dvar.ui_gametype:get() then
			require("T6.Zombie.HudCraftablesZombie")
			Widget:addElement(LUI.createMenu.CraftablesArea(ClientInstance.controller))
		end
		require("T6.Zombie.HudAfterlifeDisplay")
		local f19_local1 = LUI.createMenu.AfterlifeArea(ClientInstance.controller)
		f19_local1:setUseGameTime(true)
		Widget:addElement(f19_local1)
	elseif CoD.Zombie.IsDLCMap(CoD.Zombie.DLC4Maps) then
		if CoD.Zombie.GAMETYPE_ZCLASSIC == Dvar.ui_gametype:get() then
			require("T6.Zombie.HudCraftablesTombZombie")
			Widget:addElement(LUI.createMenu.CraftablesTombArea(ClientInstance.controller))
			require("T6.HUD.gametypes.GametypeBase")
			require("T6.Zombie.TombCaptureZoneDisplay")
			Widget:addElement(LUI.createMenu.TombCaptureZoneDisplay(ClientInstance.controller))
			if not CoD.Zombie.LocalSplitscreenMultiplePlayers then
				require("T6.Zombie.HudChallengeMedals")
				Widget:addElement(LUI.createMenu.ChallengeMedalsArea(ClientInstance.controller))
			end
		end
	else
		Widget:addElement(LUI.createMenu.BuildablesArea(ClientInstance.controller))
	end
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC3Maps) then
		require("T6.Zombie.HudTimeBomb")
		Widget:addElement(LUI.createMenu.TimeBombArea(ClientInstance.controller))
	end
	local f19_local1 = LUI.createMenu.CompetitiveScoreboard(ClientInstance.controller)
	f19_local1:setUseGameTime(true)
	Widget:addElement(f19_local1)
	if CoD.Zombie.IsDLCMap(CoD.Zombie.DLC2Maps) or CoD.Zombie.IsDLCMap(CoD.Zombie.DLC3Maps) or CoD.Zombie.IsDLCMap(CoD.Zombie.DLC4Maps) then
		require("T6.Zombie.AmmoAreaZombie")
		local f19_local2 = LUI.createMenu.AmmoAreaZombie(ClientInstance.controller)
		f19_local2:setUseGameTime(true)
		Widget:addElement(f19_local2)
	else
		local f19_local2 = LUI.createMenu.DPadArea(ClientInstance.controller)
		f19_local2:setUseGameTime(true)
		Widget:addElement(f19_local2)
	end
	if CoD.Zombie.GAMETYPE_ZCLEANSED == Dvar.ui_gametype:get() then
		local f19_local2 = LUI.createMenu.TimerAreaZM(ClientInstance.controller)
		f19_local2:setUseGameTime(true)
		Widget:addElement(f19_local2)
	else
		local f19_local2 = LUI.createMenu.RoundStatus(ClientInstance.controller)
		f19_local2:setUseGameTime(true)
		Widget:addElement(f19_local2)
	end
	if CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER == UIExpression.DvarString(nil, "ui_zm_gamemodegroup") then
		Widget:addElement(CoD.Hud3DScoreBoardZombie.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			bottom = 0,
			top = 0,
			ui3DWindow = 0,
		}))
	end
	if not Engine.IsSplitscreen() then
		CoD.GameMessages.AddObituaryWindow(HUDWidget, {
			leftAnchor = true,
			rightAnchor = false,
			left = 13,
			right = 277,
			topAnchor = false,
			bottomAnchor = true,
			top = -320,
			bottom = -220,
		})
		CoD.GameMessages.BoldGameMessagesWindow(HUDWidget, {
			leftAnchor = false,
			rightAnchor = false,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = false,
			top = 50,
			bottom = 70,
		})
	end
	if Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
		CoD.DemoHUD.AddHUDWidgets(HUDWidget, ClientInstance)
	end

	require("T6.Zombie.HudReimagined")
	Widget:addElement(LUI.createMenu.ReimaginedArea(ClientInstance.controller))
end

function HUD_ToggleZombieHudContainer(HUDWidget, ClientInstance)
	if ClientInstance.newValue == 0 then
		HUDWidget:beginAnimation("fade_in", 500)
		HUDWidget:setAlpha(1)
	else
		HUDWidget:beginAnimation("fade_out", 500)
		HUDWidget:setAlpha(0)
	end
end

HUD_OpenIngameMenu = function(HUDWidget, ClientInstance)
	if HUDWidget.m_inputDisabled then
		return
	elseif ClientInstance.menuName == "class" and Engine.IsMigrating(ClientInstance.controller) == true then
		return
	elseif true == CoD.isZombie then
		if CoD.InGameMenu.m_unpauseDisabled == nil then
			CoD.InGameMenu.m_unpauseDisabled = {}
		end
		CoD.InGameMenu.m_unpauseDisabled[ClientInstance.controller + 1] = 0
		if ClientInstance.unpausable ~= nil and ClientInstance.unpausable == 0 then
			CoD.InGameMenu.m_unpauseDisabled[ClientInstance.controller + 1] = 1
		end
	end
	if ClientInstance.data ~= nil then
		ClientInstance.menuName = Engine.GetIString(ClientInstance.data[1], "CS_SCRIPT_MENUS")
	end
	if HUDWidget.SpectateHUD ~= nil and HUDWidget.SpectateHUD.m_controlsOpen then
		return
	end
	local f21_local0 = LUI.createMenu[ClientInstance.menuName]
	HUDWidget:dispatchEventToChildren(ClientInstance)
	if f21_local0 ~= nil then
		HUDWidget:openPopup(ClientInstance.menuName, ClientInstance.controller)
	end
	if HUDWidget.SpectateHUD ~= nil then
		HUDWidget.SpectateHUD:processEvent({
			name = "spectate_ingame_menu_opened",
		})
	end
end

function HUD_CloseInGameMenu(HUDWidget, ClientInstance)
	if CoD.isZombie == true then
		if CoD.InGameMenu.m_unpauseDisabled == nil then
			CoD.InGameMenu.m_unpauseDisabled = {}
		end
		CoD.InGameMenu.m_unpauseDisabled[ClientInstance.controller + 1] = 0
	end
	if HUDWidget.SpectateHUD ~= nil then
		HUDWidget.SpectateHUD:processEvent({
			name = "spectate_ingame_menu_closed",
		})
	end
	if CoD.isZombie == true then
		Engine.SetActiveMenu(ClientInstance.controller, CoD.UIMENU_NONE)
	end
end

function HUD_OpenScoreBoard(HUDWidget, ClientInstance)
	if CoD.isZombie == true and CoD.InGameMenu.m_unpauseDisabled ~= nil and CoD.InGameMenu.m_unpauseDisabled[ClientInstance.controller + 1] ~= nil and CoD.InGameMenu.m_unpauseDisabled[ClientInstance.controller + 1] > 0 then
		return
	elseif HUDWidget.scoreBoard and (HUDWidget.SpectateHUD == nil or not HUDWidget.SpectateHUD.m_controlsOpen) then
		HUDWidget:addElement(HUDWidget.scoreBoard)
		HUDWidget.scoreBoard:processEvent({
			name = "update_scoreboard",
			controller = ClientInstance.controller,
		})
		HUDWidget:addElement(HUDWidget.scoreboardUpdateTimer)
		if CoD.isZombie == true then
			if HUDWidget.scoreBoard.questItemDisplay then
				HUDWidget.scoreBoard.questItemDisplay:processEvent({
					name = "update_quest_item_display_scoreboard",
					controller = ClientInstance.controller,
				})
			end
			if HUDWidget.scoreBoard.persistentItemDisplay then
				HUDWidget.scoreBoard.persistentItemDisplay:processEvent({
					name = "update_persistent_item_display_scoreboard",
					controller = ClientInstance.controller,
				})
			end
			if HUDWidget.scoreBoard.craftableItemDisplay then
				HUDWidget.scoreBoard.craftableItemDisplay:processEvent({
					name = "update_craftable_item_display_scoreboard",
					controller = ClientInstance.controller,
				})
			end
			if HUDWidget.scoreBoard.captureZoneWheelDisplay then
				HUDWidget.scoreBoard.captureZoneWheelDisplay:processEvent({
					name = "update_capture_zone_wheel_display_scoreboard",
					controller = ClientInstance.controller,
				})
			end
		end
		if HUDWidget.SpectateHUD ~= nil then
			HUDWidget.SpectateHUD:processEvent({
				name = "spectate_scoreboard_opened",
			})
			if HUDWidget.SpectateHUD.m_selectedClientNum ~= nil then
				HUDWidget.scoreBoard:processEvent({
					name = "focus_client",
					controller = ClientInstance.controller,
					clientNum = HUDWidget.SpectateHUD.m_selectedClientNum,
				})
			end
		end
	end
end

function HUD_CloseScoreBoard(HUDWidget, ClientInstance)
	if HUDWidget.scoreBoard then
		HUDWidget.scoreBoard:close()
		HUDWidget.scoreboardUpdateTimer:close()
		HUDWidget.scoreboardUpdateTimer:reset()
		if HUDWidget.SpectateHUD ~= nil then
			HUDWidget.SpectateHUD:processEvent({
				name = "spectate_scoreboard_closed",
			})
		end
	end
end

function HUD_DebugReload(HUDWidget, ClientInstance)
	if HUDWidget.m_eventHandlers.debug_reload ~= HUD_DebugReload then
		HUDWidget:registerEventHandler("debug_reload", HUD_DebugReload)
		HUDWidget:processEvent({
			name = "debug_reload",
		})
		return
	else
		HUDWidget.chopperGunnerHUD = nil
		HUDWidget.predatorHUD = nil
		HUDWidget.reaperHUD = nil
		HUD_SetupEventHandlers(HUDWidget)
		HUD_FirstSnapshot(HUDWidget, {
			controller = HUDWidget.controller,
		})
		Engine.ForceHUDRefresh(HUDWidget.controller)
	end
end

function HUD_UpdateRefresh(HUDWidget, ClientInstance)
	HUD_KillcamUpdate(HUDWidget, ClientInstance)
	HUD_GameEndedUpdate(HUDWidget, ClientInstance)
end

function HUD_FullscreenStart(HUDWidget, ClientInstance)
	HUDWidget.scoreBoard:processEvent(ClientInstance)
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

function HUD_FullscreenStop(HUDWidget, ClientInstance)
	HUDWidget.scoreBoard:processEvent(ClientInstance)
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

function HUD_StartKillcamHud(HUDWidget, ClientInstance)
	if not HUDWidget.killcamHUD then
		HUDWidget.killcamHUD = LUI.createMenu.Killcam(ClientInstance.controller)
		HUDWidget:addElement(HUDWidget.killcamHUD)
		local f29_local0 = LUI.roots.UIRootDrc
		if f29_local0 then
			f29_local0:processEvent({
				name = "killcam_open",
				controller = ClientInstance.controller,
			})
		end
	end
end

function HUD_StopKillcamHud(HUDWidget, ClientInstance)
	if HUDWidget.killcamHUD then
		HUDWidget.killcamHUD:close()
		HUDWidget.killcamHUD = nil
		local f30_local0 = LUI.roots.UIRootDrc
		if f30_local0 then
			f30_local0:processEvent({
				name = "killcam_close",
				controller = ClientInstance.controller,
			})
		end
	end
end

HUD_KillcamUpdate = function(HUDWidget, ClientInstance)
	if UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_IN_KILLCAM) == 1 then
		if HUDWidget.killcamHUD then
			if HUDWidget.killcamHUD.isFinalKillcam ~= UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_FINAL_KILLCAM) then
				HUD_StopKillcamHud(HUDWidget, ClientInstance)
			elseif HUDWidget.killcamHUD.isRoundEndKillcam ~= UIExpression.IsVisibilityBitSet(ClientInstance.controller, CoD.BIT_ROUND_END_KILLCAM) then
				HUD_StopKillcamHud(HUDWidget, ClientInstance)
			end
		end
		HUD_StartKillcamHud(HUDWidget, ClientInstance)
	else
		HUD_StopKillcamHud(HUDWidget, ClientInstance)
	end
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

local f0_local18 = function(f32_arg0)
	local f32_local0
	if Engine.IsSplitscreen() ~= false or Engine.IsDemoShoutcaster() ~= true and (UIExpression.IsVisibilityBitSet(f32_arg0, CoD.BIT_SPECTATING_CLIENT) ~= 1 or UIExpression.IsVisibilityBitSet(f32_arg0, CoD.BIT_TEAM_SPECTATOR) ~= 1 or UIExpression.IsVisibilityBitSet(f32_arg0, CoD.BIT_GAME_ENDED) ~= 0 or UIExpression.IsVisibilityBitSet(f32_arg0, CoD.BIT_UI_ACTIVE) ~= 0) then
		f32_local0 = false
	else
		f32_local0 = true
	end
	return f32_local0
end

HUD_GameEndedUpdate = function(HUDWidget, ClientInstance)
	if f0_local18(ClientInstance.controller) then
		if HUDWidget.SpectateHUD == nil then
			local f33_local0 = CoD.SpectateHUD.new(ClientInstance)
			LUI.roots.UIRootFull:addElement(f33_local0)
			HUDWidget.SpectateHUD = f33_local0
			HUDWidget.SpectateHUD.m_gameHUD = HUDWidget
		end
		CoD.SpectateHUD.update(HUDWidget.SpectateHUD, ClientInstance)
	elseif HUDWidget.SpectateHUD ~= nil then
		HUDWidget.SpectateHUD:close()
		HUDWidget.SpectateHUD = nil
	end
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

HUD_ReloadShoutcasterHud = function(HUDWidget, ClientInstance)
	if HUDWidget.SpectateHUD ~= nil then
		HUDWidget.SpectateHUD:close()
		HUDWidget.SpectateHUD = nil
	end
	HUD_GameEndedUpdate(HUDWidget, ClientInstance)
end

local f0_local19 = function(f35_arg0)
	local f35_local0
	if UIExpression.IsVisibilityBitSet(f35_arg0, CoD.BIT_SELECTING_LOCATION) ~= 1 or UIExpression.IsVisibilityBitSet(f35_arg0, CoD.BIT_SPECTATING_CLIENT) ~= 0 or UIExpression.IsVisibilityBitSet(f35_arg0, CoD.BIT_IS_DEMO_PLAYING) ~= 0 or UIExpression.IsVisibilityBitSet(f35_arg0, CoD.BIT_SCOREBOARD_OPEN) ~= 0 then
		f35_local0 = false
	else
		f35_local0 = true
	end
	return f35_local0
end

HUD_SelectingLocationUpdate = function(HUDWidget, ClientInstance)
	if f0_local19(ClientInstance.controller) then
		if HUDWidget.locationSelectorMap == nil then
			if HUDWidget.selectorContainer == nil then
				HUDWidget.selectorContainer = CoD.SplitscreenScaler.new(nil, 1.3)
				HUDWidget.selectorContainer:setLeftRight(false, false, 0, 0)
				HUDWidget.selectorContainer:setTopBottom(false, false, 0, 0)
				HUDWidget.safeArea:addElement(HUDWidget.selectorContainer)
			end
			HUDWidget.locationSelectorMap = CoD.Compass.new({
				leftAnchor = false,
				rightAnchor = false,
				left = -275,
				right = 275,
				topAnchor = false,
				bottomAnchor = false,
				top = -275,
				bottom = 275,
			}, CoD.COMPASS_TYPE_FULL)
			HUDWidget.selectorContainer:addElement(HUDWidget.locationSelectorMap)
			Engine.BlurWorld(ClientInstance.controller, 2)
		end
	elseif HUDWidget.locationSelectorMap ~= nil then
		HUDWidget.selectorContainer:close()
		HUDWidget.selectorContainer = nil
		HUDWidget.locationSelectorMap:close()
		HUDWidget.locationSelectorMap = nil
		Engine.BlurWorld(ClientInstance.controller, 0)
	end
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

HUD_UpdateKillstreakHud = function(HUDWidget, ClientInstance)
	if ClientInstance.chopperGunner == true then
		if HUDWidget.chopperGunnerHUD == nil then
			local predatorHUD = CoD.ChopperGunnerHUD.new(ClientInstance.controller)
			HUDWidget:addElement(predatorHUD)
			HUDWidget.chopperGunnerHUD = predatorHUD
		end
	else
		HUDWidget.chopperGunnerHUD = nil
	end
	if ClientInstance.reaper == true then
		if HUDWidget.reaperHUD == nil then
			local predatorHUD = CoD.ReaperHUD.new(ClientInstance.controller)
			HUDWidget:addElement(predatorHUD)
			HUDWidget.reaperHUD = predatorHUD
		end
	else
		HUDWidget.reaperHUD = nil
	end
	if ClientInstance.predator == true then
		if HUDWidget.predatorHUD == nil then
			local predatorHUD = CoD.PredatorHUD.new(ClientInstance.controller)
			HUDWidget:addElement(predatorHUD)
			HUDWidget.predatorHUD = predatorHUD
		end
	else
		HUDWidget.predatorHUD = nil
	end
	HUDWidget:dispatchEventToChildren(ClientInstance)
end

HUD_ForceKillKillstreakHud = function(HUDWidget, ClientInstance)
	Engine.DisableSceneFilter(HUDWidget:getOwner(), 4)
end

HUD_UpdateVehicleHud = function(HUDWidget, ClientInstance)
	if HUDWidget.vehicleHUD then
		if HUDWidget.vehicleHUD.vehicleType == ClientInstance.vehicleType then
			return
		end
		HUDWidget.vehicleHUD:close()
		HUDWidget.vehicleHUD = nil
		Engine.DisableSceneFilter(HUDWidget:getOwner(), 4)
	end
	if not ClientInstance.vehicleType then
		return
	end
	local f39_local0 = LUI.createMenu[ClientInstance.vehicleType]
	if f39_local0 then
		HUDWidget.vehicleHUD = f39_local0(HUDWidget:getOwner())
		HUDWidget.vehicleHUD:setPriority(-10)
		HUDWidget.vehicleHUD.vehicleType = ClientInstance.vehicleType
		HUDWidget:addElement(HUDWidget.vehicleHUD)
	end
end

HUD_FactionPopup = function(HUDWidget, ClientInstance)
	local f40_local0 = UIExpression.Team(ClientInstance.controller, "name")
	local f40_local1, f40_local2, f40_local3, f40_local4, f40_local5 = nil
	if f40_local0 == "TEAM_ALLIES" then
		f40_local1 = RegisterMaterial(UIExpression.DvarString(nil, "g_TeamIcon_Allies"))
		f40_local2 = CoD.ScoreFeed.Color1
		f40_local3 = CoD.ScoreFeed.Color2
		f40_local4 = CoD.ScoreFeed.Color3
		f40_local5 = UIExpression.ToUpper(nil, Engine.Localize(Engine.GetIString(ClientInstance.data[1], "CS_LOCALIZED_STRINGS"), Dvar.g_TeamName_Allies:get()))
	elseif f40_local0 == "TEAM_AXIS" then
		f40_local1 = RegisterMaterial(UIExpression.DvarString(nil, "g_TeamIcon_Axis"))
		f40_local2 = CoD.ScoreFeed.ScoreStreakColor1
		f40_local3 = CoD.ScoreFeed.ScoreStreakColor2
		f40_local4 = CoD.ScoreFeed.ScoreStreakColor3
		f40_local5 = UIExpression.ToUpper(nil, Engine.Localize(Engine.GetIString(ClientInstance.data[1], "CS_LOCALIZED_STRINGS"), Dvar.g_TeamName_Axis:get()))
	else
		return
	end
	local f40_local6 = 128
	local f40_local7 = 0
	local Widget = LUI.UIElement.new({
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = true,
		top = 0,
		bottom = 0,
	})
	HUDWidget.safeArea:addElement(Widget)

	local darkSplash = LUI.UIImage.new()
	darkSplash:setLeftRight(false, false, -f40_local6 / 2, f40_local6 / 2)
	darkSplash:setTopBottom(true, false, f40_local7, f40_local7 + f40_local6)
	darkSplash:setImage(RegisterMaterial("ks_menu_background"))
	darkSplash:setAlpha(0.5)
	Widget:addElement(darkSplash)
	Widget.darkSplash = darkSplash

	local f40_local10 = CoD.textSize.Condensed
	Widget.text = CoD.AdditiveTextOverlay.newWithText(f40_local5, "Condensed", f40_local2, f40_local3, f40_local4, {
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = f40_local6,
		bottom = f40_local6 + f40_local10,
	})
	Widget.text.label:setRGB(CoD.offWhite.r, CoD.offWhite.g, CoD.offWhite.b)
	Widget.image = LUI.UIImage.new({
		leftAnchor = false,
		rightAnchor = false,
		left = -f40_local6 / 2,
		right = f40_local6 / 2,
		topAnchor = true,
		bottomAnchor = false,
		top = f40_local7,
		bottom = f40_local7 + f40_local6,
		material = f40_local1,
	})
	Widget:addElement(Widget.image)
	local f40_local11 = f40_local6 + f40_local10
	local f40_local12 = f40_local6
	Widget.imageGlow = CoD.AdditiveTextOverlay.new(f40_local6, f40_local6, f40_local2, f40_local3, f40_local4, {
		leftAnchor = false,
		rightAnchor = false,
		left = -f40_local6 / 2,
		right = f40_local6 / 2,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = f40_local6,
	})
	Widget:addElement(Widget.imageGlow)
	Widget:registerEventHandler("add_text", FactionPopupAddTextEvent)
	Widget:registerEventHandler("out", f0_local11)
	Widget:registerEventHandler("out2", f0_local12)
	Widget:addElement(LUI.UITimer.new(500, "add_text", true))
	Widget:addElement(LUI.UITimer.new(2000, "out", true))
end

FactionPopupAddTextEvent = function(HUDWidget, ClientInstance)
	HUDWidget:addElement(HUDWidget.text)
end

f0_local11 = function(HUDWidget, ClientInstance)
	HUDWidget.text:out()
	HUDWidget:addElement(LUI.UITimer.new(CoD.AdditiveTextOverlay.PulseOutTime, "out2", true))
	HUDWidget:addElement(LUI.UITimer.new(CoD.AdditiveTextOverlay.PulseOutTime * 2, "close", true))
end

f0_local12 = function(HUDWidget, ClientInstance)
	HUDWidget.imageGlow:out()
	HUDWidget.image:close()
	HUDWidget.darkSplash:close()
end

function HUD_IsFFA()
	local IsFFa = false
	if CoD.isZombie == true then
		local GamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
		if GamemodeGroup ~= CoD.Zombie.GAMETYPEGROUP_ZCLASSIC and GamemodeGroup ~= CoD.Zombie.GAMETYPEGROUP_ZSURVIVAL then
			IsFFa = true
		end
	elseif UIExpression.DvarString(nil, "ui_gametype") == "dm" or UIExpression.DvarString(nil, "ui_gametype") == "hcdm" or UIExpression.DvarString(nil, "ui_gametype") == "hack" then
		IsFFa = true
	end
	return IsFFa
end

function HUD_Handle_ChooseClass_HotKey(HUDWidget, ClientInstance)
	if UIExpression.Team(ClientInstance.controller, "name") ~= "TEAM_SPECTATOR" and CoD.IsWagerMode() == false and not (Engine.GetGametypeSetting("disableClassSelection") == 1) then
		HUD_OpenIngameMenu(HUDWidget, {
			menuName = "changeclass",
			controller = ClientInstance.controller,
		})
	end
end

DisableGlobals()
Engine.StopEditingPresetClass()
