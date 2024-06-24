require("T6.CoDBase")
require("T6.BonusCardButton")
require("T6.LiveNotification")
require("T6.SwitchLobbies")
require("T6.MainMenu")
require("T6.NumbersBackground")
require("T6.Options")
require("T6.Menus.Barracks")
require("T6.Menus.ClanTag")
require("T6.Menus.ConfirmLeavePopup")
require("T6.Menus.PrivateLocalGameLobby")
require("T6.Menus.PublicGameLobby")
require("T6.Menus.PrivateOnlineGameLobby")
require("T6.Menus.SplitscreenGameLobby")
require("T6.Menus.TheaterLobby")
require("T6.PlayerMatchPartyLobby")
require("T6.GameLobby")
require("T6.matchmaking")

if CoD.isZombie == true then
	require("T6.Zombie.BaseZombie")
	require("T6.Zombie.GameGlobeZombie")
	require("T6.Zombie.GameMapZombie")
	require("T6.Zombie.GameMoonZombie")
	require("T6.Zombie.GameRockZombie")
	require("T6.Zombie.NoLeavePopupZombie")
	require("T6.Zombie.SelectDifficultyLevelPopupZombie")
	require("T6.Zombie.SelectStartLocZombie")
	require("T6.Zombie.SelectMapZombie")
else
	require("T6.Menus.CAC")
	require("T6.Menus.CACChooseClass")
	require("T6.Menus.CACCamoMenu")
	require("T6.Menus.CACEditClass")
	require("T6.Menus.CACGrenadesAndEquipment")
	require("T6.Menus.CACKnifeMenu")
	require("T6.Menus.CACPerks")
	require("T6.Menus.CACRemoveItem")
	require("T6.Menus.CACReticles")
	require("T6.Menus.CACRewardsPopup")
	require("T6.Menus.CACSelectClass")
	require("T6.Menus.CACWeapons")
	require("T6.Menus.ChangeGameModePopup")
	require("T6.Menus.ChangeMapPopup")
	require("T6.Menus.LeagueGameLobby")
	require("T6.Menus.LeaguePlayPartyLobby")
	require("T6.Menus.ConfirmPurchasePopup")
	require("T6.Menus.ConfirmPrestigeUnlock")
	require("T6.Menus.ConfirmWeaponPrestige")
	require("T6.Menus.RemoveReward")
	require("T6.CACAttachmentsButton")
	require("T6.CACGridSelectionMenu")
	require("T6.CACPerksButton")
	require("T6.CACWeaponButton")
	require("T6.ClassButton")
	require("T6.Menus.CACAttachmentsMenu")
	require("T6.Menus.CACGrenades")
	require("T6.Menus.CACUtility")
	require("T6.Menus.CheckClasses")
end
if (CoD.isWIIU or CoD.isPC) and CoD.isWIIU then
	require("T6.Drc.DrcBase")
	require("T6.Drc.DrcPopup")
	require("T6.Drc.DrcMakePrimaryPopup")
	require("T6.WiiUSystemServices")
end
local f0_local0 = function(f1_arg0, f1_arg1)
	profiler.stop()
	DebugPrint("Profiler stopped.")
end

local f0_local1 = function(f2_arg0, f2_arg1)
	if f2_arg1.key == 115 then
		if f2_arg0.safeAreaOverlay.toggled then
			f2_arg0.safeAreaOverlay.toggled = false
			f2_arg0.safeAreaOverlay:close()
		else
			f2_arg0.safeAreaOverlay.toggled = true
			f2_arg0:addElement(f2_arg0.safeAreaOverlay)
		end
	elseif f2_arg1.key == 116 then
		f2_arg0:addElement(LUI.UITimer.new(1000, "profiler_stop", true))
		DebugPrint("Profiler started.")
		profiler.start("test.prof")
	end
	f2_arg0:dispatchEventToChildren(f2_arg1)
end

local f0_local2 = function(f3_arg0, f3_arg1)
	local f3_local0 = 500
	if CoD.isZombie == true then
		f3_local0 = 1
	end
	Engine.PlaySound("cac_globe_draw")
	f3_arg0:beginAnimation("wireframe_in", f3_local0)
	f3_arg0:setShaderVector(0, 1, 0, 0, 0)
end

local f0_local3 = function(f4_arg0, f4_arg1)
	local f4_local0 = 1000
	if CoD.isZombie == true then
		f4_local0 = 1
	end
	f4_arg0:beginAnimation("map_in", f4_local0)
	f4_arg0:setShaderVector(0, 2, 2, 0, 0)
end

function ShowGlobe()
	if not CoD.globe then
		return
	elseif not CoD.globe.shown then
		CoD.globe.shown = true
		CoD.globe:beginAnimation("globe_ready", 1)
	end
end

function HideGlobe()
	if not CoD.globe then
		return
	elseif CoD.globe.shown then
		CoD.globe.shown = nil
		if CoD.isZombie == true then
			CoD.GameGlobeZombie.MoveToOrigin()
		else
			CoD.globe:setShaderVector(0, 0, 0, 0, 0)
		end
	end
end

CoD.InviteAccepted = function(f7_arg0, f7_arg1)
	Engine.Exec(f7_arg1.controller, "setclientbeingusedandprimary")
	Engine.ExecNow(f7_arg1.controller, "initiatedemonwareconnect")
	local f7_local0 = f7_arg0:openPopup("popup_connectingdw", f7_arg1.controller)
	f7_local0.inviteAccepted = true
	f7_local0.callingMenu = f7_arg0
end

local f0_local4 = function(f8_arg0, f8_arg1, f8_arg2, f8_arg3)
	local f8_local0 = f8_arg1 .. "_preload"
	f8_arg0[f8_local0] = LUI.UITimer.new(250, f8_local0, false)
	f8_arg0:addElement(f8_arg0[f8_local0])
	f8_arg0:registerEventHandler(f8_local0, function(element, event)
		local f9_local0 = f8_arg1 .. "_preload"
		local f9_local1 = f8_arg2 .. "_preload"
		if element[f9_local1] == nil then
			element[f9_local1] = LUI.UIStreamedImage.new()
			element[f9_local1]:setAlpha(0)
			element:addElement(element[f9_local1])
			element[f9_local1]:registerEventHandler("streamed_image_ready", function(element, event)
				if f8_arg3 ~= nil then
					f8_arg3(element, event)
				end
				f8_arg0[f8_local0]:close()
			end)
			element[f9_local0] = LUI.UIStreamedImage.new()
			element[f9_local0]:setAlpha(0)
			element:addElement(element[f9_local0])
		end
		element[f9_local1]:setImage(RegisterMaterial(f8_arg2))
		element[f9_local1]:setupUIStreamedImage(0)
		element[f9_local0]:setImage(RegisterMaterial(f8_arg1))
		element[f9_local0]:setupUIStreamedImage(0)
	end)
	f8_arg0:processEvent({
		name = f8_local0,
	})
end

CoD.InitCustomDvars = function()
	if UIExpression.DvarString(nil, "ui_gametype_obj") == "" then
		Engine.SetDvar("ui_gametype_obj", "")
	end

	if UIExpression.DvarString(nil, "ui_gametype_pro") == "" then
		Engine.SetDvar("ui_gametype_pro", 0)
	end

	if UIExpression.DvarString(nil, "ui_round_number") == "" then
		Engine.SetDvar("ui_round_number", 0)
	end

	if UIExpression.DvarString(nil, "additionalPrimaryWeaponName") == "" then
		Engine.SetDvar("additionalPrimaryWeaponName", "")
	end

	if UIExpression.DvarString(nil, "ui_hud_enemy_counter") == "" then
		Engine.Exec(nil, "seta ui_hud_enemy_counter 1")
	end

	if UIExpression.DvarString(nil, "ui_hud_timer") == "" then
		Engine.Exec(nil, "seta ui_hud_timer 1")
	end

	if UIExpression.DvarString(nil, "ui_hud_health_bar") == "" then
		Engine.Exec(nil, "seta ui_hud_health_bar 1")
	end

	if UIExpression.DvarString(nil, "ui_hud_zone_name") == "" then
		Engine.Exec(nil, "seta ui_hud_zone_name 1")
	end

	if UIExpression.DvarString(nil, "ui_hud_game_mode_name") == "" then
		Engine.Exec(nil, "seta ui_hud_game_mode_name 1")
	end

	if UIExpression.DvarString(nil, "ui_hud_containment") == "" then
		Engine.Exec(nil, "seta ui_hud_containment 1")
	end

	if UIExpression.DvarString(nil, "r_fog_settings") == "" then
		Engine.Exec(nil, "seta r_fog_settings 0")
	end
end

LUI.createMenu.main = function()
	CoD.InitCustomDvars()

	local f11_local0 = UIExpression.GetMaxControllerCount()
	for self = 0, f11_local0 - 1, 1 do
		Engine.LockInput(self, true)
		Engine.SetUIActive(self, true)
	end
	LUI.roots.UIRootFull:addElement(CoD.SetupSafeAreaOverlay())
	local self = LUI.UIElement.new({
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = true,
		top = 0,
		bottom = 0,
	})
	self.name = "Main"
	if CoD.useMouse == true then
		CoD.Mouse.RegisterMaterials()
	end
	if not CoD.isZombie then
		local f11_local2 = 1280
		local f11_local3 = 400
		local f11_local4 = LUI.UIImage.new()
		f11_local4:setLeftRight(false, false, -f11_local2, f11_local2)
		f11_local4:setTopBottom(false, false, f11_local3 - f11_local2, f11_local3 + f11_local2)
		f11_local4:setXRot(-80)
		f11_local4:setImage(RegisterMaterial("ui_holotable_grid"))
		self:addElement(f11_local4)
		local f11_local5 = LUI.UIImage.new()
		f11_local5:setLeftRight(false, false, -f11_local2, f11_local2)
		f11_local5:setTopBottom(false, false, f11_local3 - f11_local2, f11_local3 + f11_local2)
		f11_local5:setXRot(-80)
		f11_local5:setImage(RegisterMaterial("ui_holotable_grid3"))
		f11_local5:setRGB(0.5, 0.5, 0.5)
		self:addElement(f11_local5)
		local f11_local6 = -32
		local f11_local7 = LUI.UIImage.new()
		f11_local7:setLeftRight(false, false, -f11_local2, f11_local2)
		f11_local7:setTopBottom(false, false, f11_local3 - f11_local2 + f11_local6, f11_local3 + f11_local2 + f11_local6)
		f11_local7:setXRot(-80)
		f11_local7:setImage(RegisterMaterial("ui_holotable_grid2"))
		self:addElement(f11_local7)
	end
	local f11_local2 = nil
	if CoD.isZombie == true then
		f11_local2 = RegisterMaterial("lui_bkg_zm")
	else
		f11_local2 = RegisterMaterial("lui_bkg")
	end
	local f11_local3 = nil
	if CoD.isZombie == true then
		self:addElement(LUI.UIImage.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			top = 0,
			bottom = 0,
			alpha = 1,
			red = 0,
			green = 0,
			blue = 0,
		}))
		f11_local3 = LUI.UIStreamedImage.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			top = 0,
			bottom = 0,
			material = f11_local2,
		})
		f11_local3:setupUIStreamedImage(0)
		if not CoD.isPC then
			f0_local4(self, "menu_zm_nuked_map", "menu_zm_nuked_map_blur", function(f12_arg0, f12_arg1)
				CoD.GameMapZombie.BlurredImages.menu_zm_nuked_map_blur = true
			end)
			f0_local4(self, "menu_zm_highrise_map", "menu_zm_highrise_map_blur", function(f13_arg0, f13_arg1)
				CoD.GameMapZombie.BlurredImages.menu_zm_highrise_map_blur = true
			end)
			f0_local4(self, "menu_zm_prison_map", "menu_zm_prison_map_blur", function(f14_arg0, f14_arg1)
				CoD.GameMapZombie.BlurredImages.menu_zm_prison_map_blur = true
			end)
			f0_local4(self, "menu_zm_buried_map", "menu_zm_buried_map_blur", function(f15_arg0, f15_arg1)
				CoD.GameMapZombie.BlurredImages.menu_zm_buried_map_blur = true
			end)
		end
	else
		f11_local3 = LUI.UIImage.new({
			leftAnchor = true,
			rightAnchor = true,
			left = 0,
			right = 0,
			topAnchor = true,
			bottomAnchor = true,
			top = 0,
			bottom = 0,
			material = f11_local2,
		})
	end
	self:addElement(f11_local3)
	local f11_local4 = -810
	local f11_local5 = 460
	local f11_local6 = 720
	local f11_local7 = nil
	if CoD.isZombie == true then
		f11_local7 = RegisterMaterial("ui_globe_zm")
	else
		f11_local7 = RegisterMaterial("ui_globe")
	end
	local f11_local8 = LUI.UIElement.new()
	f11_local8:setLeftRight(false, false, f11_local4, f11_local4 + f11_local6)
	f11_local8:setTopBottom(false, false, f11_local5 - f11_local6, f11_local5)
	f11_local8:setImage(f11_local7)
	f11_local8:setAlpha(1)
	f11_local8:setShaderVector(0, 0, 0, 0, 0)
	f11_local8:setupGlobe()
	f11_local8:registerEventHandler("transition_complete_globe_ready", f0_local2)
	f11_local8:registerEventHandler("transition_complete_wireframe_in", f0_local3)
	CoD.globe = f11_local8
	local f11_local9, f11_local10 = nil
	if CoD.isZombie == true then
		f11_local9 = LUI.UIElement.new()
		self:addElement(f11_local9)
		f11_local10 = LUI.UIImage.new()
		self:addElement(f11_local10)
	end
	self:addElement(f11_local8)
	if CoD.isZombie == true then
		CoD.GameGlobeZombie.Init(f11_local8)
		CoD.GameMapZombie.Init(f11_local3, f11_local2)
		local f11_local11 = LUI.UIElement.new()
		self:addElement(f11_local11)
		local f11_local12 = LUI.UIElement.new()
		self:addElement(f11_local12)
		CoD.GameRockZombie.Init(f11_local12, f11_local9)
		local f11_local13 = LUI.UIImage.new()
		self:addElement(f11_local13)
		CoD.GameMoonZombie.Init(f11_local13, f11_local11, f11_local10)
		local f11_local14 = LUI.UIElement.new()
		self:addElement(f11_local14)
		CoD.Fog.Init(f11_local14)
	end
	if CoD.isMultiplayer then
		local f11_local11 = LUI.UIImage.new()
		f11_local11:setLeftRight(true, true, 0, 0)
		f11_local11:setTopBottom(true, true, 0, 0)
		f11_local11:setRGB(0, 0, 0)
		f11_local11:setAlpha(0.15)
		self:addElement(f11_local11)
	end
	self:addElement(LUI.createMenu.BlackMenu())
	self:registerEventHandler("keydown", f0_local1)
	self:registerEventHandler("profiler_stop", f0_local0)
	self:registerEventHandler("live_notification", CoD.LiveNotifications.NotifyMessage)
	Engine.PlayMenuMusic("mus_mp_frontend")
	Engine.Exec(nil, "checkforinvites")
	return self
end

LUI.createMenu.BlackMenu = function(f16_arg0)
	local f16_local0 = CoD.Menu.New("BlackMenu")
	local self = LUI.UIImage.new()
	self:setLeftRight(false, false, -640, 640)
	self:setTopBottom(false, false, -360, 360)
	self:setRGB(0, 0, 0)
	f16_local0:addElement(self)
	f16_local0:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	f16_local0:registerEventHandler("invite_accepted", CoD.inviteAccepted)
	return f16_local0
end

DisableGlobals()
Engine.StopEditingPresetClass()
