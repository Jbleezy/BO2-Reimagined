if CoD == nil then
	CoD = {}
end
CoD.MapInfoImage = {}
CoD.MapInfoImage.AspectRatio = 1.6
CoD.MapInfoImage.AnimDuration = 250
CoD.MapInfoImage.MapImageHeight = 136
CoD.MapInfoImage.MapImageWidth = 294
CoD.MapInfoImage.MapImageBottom = -57
CoD.MapInfoImage.MapImageLeft = 6
CoD.MapInfoImage.SpinnerImageYPadding = -25
CoD.MapInfoImage.SpinnerImageXPadding = -8
CoD.MapInfoImage.SpinnerImageDimension = 32
CoD.MapInfoImage.new = function (f1_arg0)
	local Widget = LUI.UIElement.new(f1_arg0)
	Widget:registerEventHandler("gamelobby_update", CoD.MapInfoImage.RefreshEvent)
	Widget:registerEventHandler("game_options_update", CoD.MapInfoImage.RefreshEvent)
	Widget:registerEventHandler("update_livestream_camera", CoD.MapInfoImage.UpdateLiveStreamCamera)
	Widget.id = "MapInfoImage"
	Widget.mapTextSize = CoD.textSize.Condensed
	Widget.gametypeTextSize = CoD.textSize.Default
	Widget.loadingTextSize = CoD.textSize.Default
	Widget.unselectedFilmTextSize = CoD.textSize.Default
	local f1_local1 = CoD.MapInfoImage.MapImageLeft
	local f1_local2 = CoD.MapInfoImage.MapImageBottom
	Widget.mapImage = LUI.UIImage.new({
		leftAnchor = true,
		rightAnchor = false,
		left = f1_local1,
		right = f1_local1 + CoD.MapInfoImage.MapImageWidth,
		topAnchor = false,
		bottomAnchor = true,
		top = f1_local2 - CoD.MapInfoImage.MapImageHeight,
		bottom = f1_local2,
		alpha = 0
	})
	Widget:addElement(Widget.mapImage)
	local f1_local3 = 46
	local f1_local4 = LUI.UIImage.new()
	f1_local4:setLeftRight(true, false, f1_local1, f1_local1 + CoD.MapInfoImage.MapImageWidth)
	f1_local4:setTopBottom(false, true, CoD.MPZM(f1_local2, f1_local2 - CoD.MapInfoImage.MapImageHeight), f1_local2 + f1_local3)
	f1_local4:setImage(RegisterMaterial(CoD.MPZM("menu_mp_map_frame", "menu_zm_map_frame")))
	Widget:addElement(f1_local4)
	Widget.unselectedFilmImageBackground = LUI.UIImage.new({
		leftAnchor = true,
		rightAnchor = false,
		left = f1_local1,
		right = f1_local1 + CoD.MapInfoImage.MapImageWidth,
		topAnchor = false,
		bottomAnchor = true,
		top = f1_local2 - CoD.MapInfoImage.MapImageHeight,
		bottom = f1_local2,
		material = RegisterMaterial("white"),
		red = 0,
		green = 0,
		blue = 0
	})
	Widget.unselectedFilmImageBackground:setAlpha(0)
	Widget:addElement(Widget.unselectedFilmImageBackground)
	Widget.unselectedFilmImage = LUI.UIImage.new({
		leftAnchor = true,
		rightAnchor = false,
		left = f1_local1 + 70,
		right = f1_local1 + CoD.MapInfoImage.MapImageWidth - 70,
		topAnchor = false,
		bottomAnchor = true,
		top = f1_local2 - CoD.MapInfoImage.MapImageHeight,
		bottom = f1_local2,
		material = RegisterMaterial("menu_mp_lobby_icon_film"),
		red = 1,
		green = 1,
		blue = 1
	})
	Widget.unselectedFilmImage:setAlpha(0)
	Widget:addElement(Widget.unselectedFilmImage)
	local f1_local5 = CoD.MPZM(-10, -20)
	local f1_local6 = CoD.MPZM(-2, -14)
	Widget.gameTypeText = LUI.UIText.new({
		leftAnchor = true,
		rightAnchor = false,
		left = f1_local1 + CoD.MapInfoImage.MapImageWidth - 1000,
		right = f1_local1 + CoD.MapInfoImage.MapImageWidth + f1_local5,
		topAnchor = false,
		bottomAnchor = true,
		top = f1_local2 + f1_local3 + f1_local6 - CoD.textSize.ExtraSmall,
		bottom = f1_local2 + f1_local3 + f1_local6,
		alignment = LUI.Alignment.Right,
		font = CoD.fonts.ExtraSmall,
		red = CoD.offWhite.r,
		green = CoD.offWhite.g,
		blue = CoD.offWhite.b
	})
	Widget:addElement(Widget.gameTypeText)
	Widget.mapNameText = LUI.UIText.new({
		leftAnchor = true,
		rightAnchor = false,
		left = f1_local1 + CoD.MapInfoImage.MapImageWidth - 1000,
		right = f1_local1 + CoD.MapInfoImage.MapImageWidth + f1_local5,
		topAnchor = false,
		bottomAnchor = true,
		top = f1_local2 + f1_local3 + f1_local6 - 17 - CoD.textSize.Default,
		bottom = f1_local2 + f1_local3 + f1_local6 - 17,
		alignment = LUI.Alignment.Right,
		font = CoD.fonts.Default,
		red = CoD.offWhite.r,
		green = CoD.offWhite.g,
		blue = CoD.offWhite.b
	})
	Widget:addElement(Widget.mapNameText)
	local f1_local7 = UIExpression.ToUpper(nil, Engine.Localize("EXE_LOADING"))
	local f1_local8_1, f1_local8_2, f1_local8_3, f1_local8_4 = GetTextDimensions(f1_local7, CoD.fonts.Default, Widget.loadingTextSize)
	local f1_local9 = f1_local8_3
	Widget.loadingText = LUI.UIText.new()
	Widget.loadingText:setLeftRight(false, false, -f1_local9 / 2 + CoD.MapInfoImage.SpinnerImageXPadding, f1_local9 / 2 + CoD.MapInfoImage.SpinnerImageXPadding)
	Widget.loadingText:setTopBottom(false, false, CoD.MapInfoImage.SpinnerImageDimension + CoD.MapInfoImage.SpinnerImageYPadding, CoD.MapInfoImage.SpinnerImageDimension + CoD.MapInfoImage.SpinnerImageYPadding + Widget.loadingTextSize)
	Widget.loadingText:setRGB(CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b)
	Widget.loadingText:setAlpha(0)
	Widget.loadingText:setText(f1_local7)
	Widget:addElement(Widget.loadingText)
	Widget.unselectedFilmText = LUI.UIText.new({
		leftAnchor = true,
		rightAnchor = false,
		left = f1_local1 + 30,
		right = f1_local1 + CoD.MapInfoImage.MapImageWidth - 30,
		topAnchor = true,
		bottomAnchor = false,
		top = CoD.MapInfoImage.MapImageHeight / 2 - Widget.unselectedFilmTextSize / 2,
		bottom = CoD.MapInfoImage.MapImageHeight / 2 + Widget.unselectedFilmTextSize / 2,
		font = CoD.fonts.Default,
		alignment = LUI.Alignment.Center
	})
	Widget.unselectedFilmText:setAlpha(0)
	Widget:addElement(Widget.unselectedFilmText)
	local f1_local10 = f1_local2 + f1_local3 + f1_local6 - 45
	Widget.modifedCustomGameElement = LUI.UIElement.new()
	Widget.modifedCustomGameElement:setLeftRight(true, false, f1_local1 + 2, f1_local1 + CoD.MapInfoImage.MapImageWidth - 2)
	Widget.modifedCustomGameElement:setTopBottom(false, true, f1_local10 - 32, f1_local10)
	Widget:addElement(Widget.modifedCustomGameElement)
	local f1_local11 = LUI.UIImage.new()
	f1_local11:setLeftRight(true, true, 0, 0)
	f1_local11:setTopBottom(true, true, 0, 0)
	f1_local11:setRGB(0, 0, 0)
	f1_local11:setAlpha(0.5)
	Widget.modifedCustomGameElement:addElement(f1_local11)
	local f1_local12 = LUI.UIImage.new()
	f1_local12:setLeftRight(true, false, 0, 32)
	f1_local12:setTopBottom(true, false, 0, 32)
	f1_local12:setRGB(CoD.yellowGlow.r, CoD.yellowGlow.g, CoD.yellowGlow.b)
	f1_local12:setImage(RegisterMaterial("menu_mp_star_rating"))
	Widget.modifedCustomGameElement:addElement(f1_local12)
	local f1_local13 = LUI.UIText.new()
	f1_local13:setLeftRight(true, true, 0, -10)
	f1_local13:setTopBottom(true, false, 0, CoD.textSize.Default)
	f1_local13:setAlignment(LUI.Alignment.Right)
	Widget.modifedCustomGameElement.text = f1_local13
	Widget.modifedCustomGameElement:addElement(f1_local13)
	Widget.modifedCustomGameElement:setAlpha(0)
	Widget.livestreamCam = LUI.UIImage.new({
		leftAnchor = true,
		rightAnchor = false,
		left = f1_local1,
		right = f1_local1 + CoD.MapInfoImage.MapImageWidth,
		topAnchor = false,
		bottomAnchor = true,
		top = f1_local2 - CoD.MapInfoImage.MapImageHeight,
		bottom = f1_local2,
		material = RegisterMaterial("livestream_cam"),
		red = 1,
		green = 1,
		blue = 1,
		alpha = 0
	})
	Widget:addElement(Widget.livestreamCam)
	CoD.MapInfoImage.UpdateLiveStreamCamera(Widget)
	Widget.update = CoD.MapInfoImage.Update
	if CoD.isZombie == true then
		Widget.update = CoD.MapInfoImage.ZombieUpdate
	end
	Widget.show = CoD.MapInfoImage.Show
	Widget.hide = CoD.MapInfoImage.Hide
	Widget.setModifiedCustomGame = CoD.MapInfoImage.SetModifedCustomGame
	return Widget
end

CoD.MapInfoImage.Update = function (f2_arg0, f2_arg1, f2_arg2)
	if f2_arg1 ~= nil then
		f2_arg0.mapImage:registerAnimationState("change_map", {
			material = RegisterMaterial("menu_" .. f2_arg1 .. "_map_select_final"),
			alpha = 1
		})
		f2_arg0.mapImage:animateToState("change_map")
		f2_arg0.mapNameText:setText(UIExpression.ToUpper(nil, Engine.Localize(UIExpression.TableLookup(nil, UIExpression.GetCurrentMapTableName(), 0, f2_arg1, 3))))
	end
	if f2_arg2 ~= nil then
		f2_arg0.gameTypeText:setText(Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 0, 1, f2_arg2, 2)))
		if CoD.isSinglePlayer == true then
			f2_arg0.gameTypeText:setText(Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, f2_arg2, 3)))
		end
	end
	CoD.MapInfoImage.UpdateLiveStreamCamera(f2_arg0, nil)
	CoD.MapInfoImage.DLCWarningUpdate(f2_arg0)
end

CoD.MapInfoImage.UpdateLiveStreamCamera = function (f3_arg0, f3_arg1)
	if Engine.IsLivestreamEnabled() and Engine.WebM_camera_IsAvailable() and Engine.WebM_camera_IsEnabled() then
		f3_arg0.livestreamCam:setAlpha(1)
	else
		f3_arg0.livestreamCam:setAlpha(0)
	end
end

CoD.MapInfoImage.UpdateEvent = function (f4_arg0, f4_arg1)
	f4_arg0:update(f4_arg1.map, f4_arg1.gametype)
end

CoD.MapInfoImage.RefreshEvent = function (f5_arg0, f5_arg1)
	f5_arg0:update(Dvar.ui_mapname:get(), Dvar.ui_gametype:get())
end

CoD.MapInfoImage.ZombieUpdate = function (f6_arg0, f6_arg1, f6_arg2)
	if Engine.GameModeIsMode(CoD.GAMEMODE_THEATER) == true and UIExpression.DvarString(f6_arg0.controller, "ui_demoname") == "" then
		return
	end
	f6_arg1 = CoD.Zombie.GetUIMapName()
	local f6_local0 = UIExpression.DvarString(nil, "ui_zm_mapstartlocation")
	local f6_local1 = UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 0, 1, f6_arg2, 9)
	local f6_local2 = Engine.PartyGetHostUIState()
	if (f6_local0 == "" or f6_local2 == CoD.PARTYHOST_STATE_SELECTING_GAMETYPE or f6_local2 == CoD.PARTYHOST_STATE_SELECTING_MAP) and UIExpression.GameHost(f6_arg0.controller) ~= 1 then
		f6_arg0.mapImage:registerAnimationState("change_map", {
			alpha = 0
		})
		f6_arg0.mapImage:animateToState("change_map", 100)
		f6_arg0.mapNameText:setText("")
		f6_arg0.gameTypeText:setText("")
		return
	elseif f6_arg1 ~= nil and f6_local1 ~= nil and f6_local0 ~= nil then
		if f6_local0 == "" then
			f6_local0 = CoD.Zombie.START_LOCATION_TRANSIT
		end
		local materialName = GetMapMaterialName(f6_arg1, f6_local1, f6_local0)
		f6_arg0.mapImage:registerAnimationState("change_map", {
			material = RegisterMaterial(materialName),
			alpha = 1
		})
		f6_arg0.mapImage:animateToState("change_map", 100)
		f6_arg0.mapNameText:setText(UIExpression.ToUpper(nil, Engine.Localize(UIExpression.TableLookup(nil, UIExpression.GetCurrentMapTableName(), 0, f6_arg1, 3))))
	end
	local f6_local3 = nil
	if CoD.isZombie and f6_local0 and f6_arg2 ~= CoD.Zombie.GAMETYPE_ZCLASSIC then
		f6_local3 = Engine.Localize(UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 5, 3, f6_local0, 4))
	end
	local f6_local4 = nil
	if f6_arg2 then
		if f6_arg2 == CoD.Zombie.GAMETYPE_ZGRIEF then
			f6_local4 = GetGriefModeDisplayName()
		else
			f6_local4 = CoD.GetZombieGameTypeDescription(f6_arg2, f6_arg1)
		end
	end
	if f6_local4 then
		if f6_local3 then
			f6_arg0.gameTypeText:setText(f6_local3 .. " / " .. f6_local4)
		else
			f6_arg0.gameTypeText:setText(f6_local4)
		end
	elseif f6_local3 then
		f6_arg0.gameTypeText:setText(f6_local3)
	end
	CoD.MapInfoImage.DLCWarningUpdate(f6_arg0)
end

function GetMapMaterialName(map, gamemode, location)
	if map == "zm_transit" and gamemode ~= "zclassic" then
		gamemode = "zsurvival"
	end

	if location == "diner" then
		gamemode = "zencounter"
	end

	if location == "power" or location == "tunnel" or location == "cornfield" then
		gamemode = "zsurvival"
		location = "transit"
	end

	if location == "nuked" then
		gamemode = "zsurvival"
	end

	if location == "cellblock" or location == "docks" then
		gamemode = "zencounter"
		location = "cellblock"
	end

	if location == "street" or location == "maze" then
		gamemode = "zencounter"
		location = "street"
	end

	return "menu_" .. map .. "_" .. gamemode .. "_" .. location
end

function GetGriefModeDisplayName()
	return Engine.Localize("ZMUI_" .. UIExpression.DvarString(nil, "ui_gametype_obj") .. "_CAPS")
end

CoD.MapInfoImage.SetModifedCustomGame = function (f7_arg0, f7_arg1)
	if f7_arg1 == true then
		f7_arg0.modifedCustomGameElement.text:setText(Dvar.fshCustomGameName:get())
		f7_arg0.modifedCustomGameElement:setAlpha(1)
	else
		f7_arg0.modifedCustomGameElement:setAlpha(0)
	end
end

CoD.MapInfoImage.TheaterUpdate = function (f8_arg0, f8_arg1, f8_arg2, f8_arg3, f8_arg4, f8_arg5)
	if UIExpression.DvarString(f8_arg0.controller, "ui_demoname") == "" then
		f8_arg0.unselectedFilmImageBackground:setAlpha(0.2)
		f8_arg0.unselectedFilmImage:setAlpha(0.2)
		if f8_arg1 == true then
			f8_arg0.unselectedFilmText:setText(Engine.Localize("MENU_THEATER_LOAD_HINT"))
		else
			f8_arg0.unselectedFilmText:setText(UIExpression.GetTheaterFilmNotSelectedMessage())
		end
		f8_arg0.unselectedFilmText:setAlpha(1)
		f8_arg0.mapImage:setAlpha(0)
		f8_arg0.mapNameText:setAlpha(0)
		f8_arg0.gameTypeText:setAlpha(0)
		f8_arg0.loadingText:setAlpha(0)
	else
		f8_arg0.unselectedFilmImageBackground:setAlpha(0)
		f8_arg0.unselectedFilmImage:setAlpha(0)
		f8_arg0.unselectedFilmText:setAlpha(0)
		f8_arg0.mapImage:setAlpha(1)
		f8_arg0.mapNameText:setAlpha(1)
		f8_arg0.gameTypeText:setAlpha(1)
		if f8_arg5 ~= nil and not f8_arg5 then
			f8_arg0.unselectedFilmImage:setLeftRight(false, false, -CoD.MapInfoImage.SpinnerImageDimension + CoD.MapInfoImage.SpinnerImageXPadding, CoD.MapInfoImage.SpinnerImageDimension + CoD.MapInfoImage.SpinnerImageXPadding)
			f8_arg0.unselectedFilmImage:setTopBottom(false, false, -CoD.MapInfoImage.SpinnerImageDimension + CoD.MapInfoImage.SpinnerImageYPadding, CoD.MapInfoImage.SpinnerImageDimension + CoD.MapInfoImage.SpinnerImageYPadding)
			f8_arg0.unselectedFilmImage:setImage(RegisterMaterial("lui_loader"))
			f8_arg0.unselectedFilmImage:setShaderVector(0, 0, 0, 0, 0)
			f8_arg0.unselectedFilmImage:setAlpha(1)
			f8_arg0.loadingText:setAlpha(1)
		else
			f8_arg0.unselectedFilmImage:setAlpha(0)
			f8_arg0.loadingText:setAlpha(0)
		end
		f8_arg0:update(f8_arg2, f8_arg3)
	end
	CoD.MapInfoImage.DLCWarningUpdate(f8_arg0)
end

CoD.MapInfoImage.Show = function (f9_arg0, f9_arg1)
	f9_arg0:registerAnimationState("show", {
		alphaMultiplier = 1
	})
	local f9_local0 = CoD.MapInfoImage.AnimDuration
	if f9_arg1 then
		f9_local0 = f9_arg1
	end
	f9_arg0:animateToState("show", f9_local0)
end

CoD.MapInfoImage.Hide = function (f10_arg0, f10_arg1)
	f10_arg0:registerAnimationState("hide", {
		alphaMultiplier = 0
	})
	local f10_local0 = CoD.MapInfoImage.AnimDuration
	if f10_arg1 then
		f10_local0 = f10_arg1
	end
	f10_arg0:animateToState("hide", f10_local0)
end

CoD.MapInfoImage.ShowLeagueInfo = function (f11_arg0, f11_arg1)
	if f11_arg1 then
		f11_arg0.gameTypeText:setText(UIExpression.ToUpper(nil, f11_arg1.description))
		f11_arg0.mapNameText:setText(UIExpression.ToUpper(nil, CoD.Menu.GetOnlinePlayerCountText(Engine.GetPlaylistID())))
		f11_arg0.mapImage:setImage(f11_arg1.icon)
		f11_arg0.mapImage:setAlpha(1)
	end
	CoD.MapInfoImage.UpdateLiveStreamCamera(f11_arg0, nil)
end

CoD.MapInfoImage.DLCWarningUpdate = function (f12_arg0)
	if f12_arg0.dlcWarningContainer ~= nil then
		local f12_local0 = Engine.DoesPartyHaveDLCForMap(Dvar.ui_mapname:get())
		local f12_local1 = ""
		if Engine.GameModeIsMode(CoD.GAMEMODE_THEATER) == true then
			if UIExpression.DvarString(f12_arg0.controller, "ui_demoname") == "" then
				f12_arg0.dlcWarningContainer:setAlpha(0)
			elseif f12_local0 == false and Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
				f12_arg0.dlcWarningContainer:setAlpha(1)
				f12_local1 = Engine.Localize("MPUI_DLC_WARNING_PARTY_MISSING_MAP_PACK_THEATER")
			else
				f12_arg0.dlcWarningContainer:setAlpha(0)
			end
		elseif f12_local0 == false and Engine.GameModeIsMode(CoD.GAMEMODE_LOCAL_SPLITSCREEN) == false then
			f12_arg0.dlcWarningContainer:setAlpha(1)
			f12_local1 = Engine.Localize("MPUI_DLC_WARNING_PARTY_MISSING_MAP_PACK")
		else
			f12_arg0.dlcWarningContainer:setAlpha(0)
		end
		f12_arg0.dlcWarningContainer.warningLabel:setText(f12_local1)
	end
end