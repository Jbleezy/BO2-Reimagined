CoD.Zombie = {}
CoD.Zombie.PlayerColors = {}
CoD.Zombie.TeamPlayerCount = 8
CoD.Zombie.PlayerColors[1] = {}
CoD.Zombie.PlayerColors[1].r = 1
CoD.Zombie.PlayerColors[1].g = 1
CoD.Zombie.PlayerColors[1].b = 1
CoD.Zombie.PlayerColors[1].a = 1
CoD.Zombie.PlayerColors[2] = {}
CoD.Zombie.PlayerColors[2].r = 0.49
CoD.Zombie.PlayerColors[2].g = 0.81
CoD.Zombie.PlayerColors[2].b = 0.93
CoD.Zombie.PlayerColors[2].a = 1
CoD.Zombie.PlayerColors[3] = {}
CoD.Zombie.PlayerColors[3].r = 0.96
CoD.Zombie.PlayerColors[3].g = 0.79
CoD.Zombie.PlayerColors[3].b = 0.31
CoD.Zombie.PlayerColors[3].a = 1
CoD.Zombie.PlayerColors[4] = {}
CoD.Zombie.PlayerColors[4].r = 0.51
CoD.Zombie.PlayerColors[4].g = 0.93
CoD.Zombie.PlayerColors[4].b = 0.53
CoD.Zombie.PlayerColors[4].a = 1
CoD.Zombie.GAMETYPE_ZCLASSIC = "zclassic"
CoD.Zombie.GAMETYPE_ZSTANDARD = "zstandard"
CoD.Zombie.GAMETYPE_ZGRIEF = "zgrief"
CoD.Zombie.GAMETYPE_ZRACE = "zrace"
CoD.Zombie.GAMETYPE_ZCONTAINMENT = "zcontainment"
CoD.Zombie.GAMETYPE_ZMEAT = "zmeat"
CoD.Zombie.GAMETYPE_ZSR = "zsr"
CoD.Zombie.GAMETYPE_ZTURNED = "zturned"
CoD.Zombie.GAMETYPE_ZCLEANSED = "zcleansed"
CoD.Zombie.GameTypes = {}
CoD.Zombie.GameTypes[1] = CoD.Zombie.GAMETYPE_ZCLASSIC
CoD.Zombie.GameTypes[2] = CoD.Zombie.GAMETYPE_ZSTANDARD
CoD.Zombie.GameTypes[3] = CoD.Zombie.GAMETYPE_ZGRIEF
CoD.Zombie.GameTypes[4] = CoD.Zombie.GAMETYPE_ZCLEANSED
CoD.Zombie.GameTypes[5] = CoD.Zombie.GAMETYPE_ZMEAT
CoD.Zombie.GAMETYPEGROUP_ZCLASSIC = "zclassic"
CoD.Zombie.GAMETYPEGROUP_ZSURVIVAL = "zsurvival"
CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER = "zencounter"
CoD.Zombie.GameTypeGroups = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLASSIC] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLASSIC].maxPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLASSIC].minPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLASSIC].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLASSIC].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSTANDARD] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSTANDARD].maxPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSTANDARD].minPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSTANDARD].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSTANDARD].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZGRIEF] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZGRIEF].maxPlayers = 8
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZGRIEF].minPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZGRIEF].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZGRIEF].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZGRIEF].maxTeamPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZGRIEF].minTeamPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZRACE] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZRACE].maxPlayers = 8
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZRACE].minPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZRACE].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZRACE].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZRACE].maxTeamPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZRACE].minTeamPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCONTAINMENT] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCONTAINMENT].maxPlayers = 8
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCONTAINMENT].minPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCONTAINMENT].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCONTAINMENT].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCONTAINMENT].maxTeamPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCONTAINMENT].minTeamPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZMEAT] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZMEAT].maxPlayers = 8
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZMEAT].minPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZMEAT].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZMEAT].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZMEAT].maxTeamPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZMEAT].minTeamPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSR] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSR].maxPlayers = 8
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSR].minPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSR].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSR].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSR].maxTeamPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZSR].minTeamPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZTURNED] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZTURNED].maxPlayers = 8
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZTURNED].minPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZTURNED].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZTURNED].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZTURNED].maxTeamPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZTURNED].minTeamPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLEANSED] = {}
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLEANSED].maxPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLEANSED].minPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLEANSED].maxLocalPlayers = 2
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLEANSED].maxLocalSplitScreenPlayers = 4
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLEANSED].maxTeamPlayers = 1
CoD.Zombie.GameTypeGroups[CoD.Zombie.GAMETYPE_ZCLEANSED].minTeamPlayers = 1
CoD.Zombie.START_LOCATION_TRANSIT = "transit"
CoD.Zombie.START_LOCATION_FARM = "farm"
CoD.Zombie.START_LOCATION_TOWN = "town"
CoD.Zombie.START_LOCATION_DINER = "diner"
CoD.Zombie.START_LOCATION_TUNNEL = "tunnel"
CoD.Zombie.MAP_ZM_TRANSIT = "zm_transit"
CoD.Zombie.MAP_ZM_NUKED = "zm_nuked"
CoD.Zombie.MAP_ZM_HIGHRISE = "zm_highrise"
CoD.Zombie.MAP_ZM_TRANSIT_DR = "zm_transit_dr"
CoD.Zombie.MAP_ZM_TRANSIT_TM = "zm_transit_tm"
CoD.Zombie.MAP_ZM_PRISON = "zm_prison"
CoD.Zombie.MAP_ZM_BURIED = "zm_buried"
CoD.Zombie.MAP_ZM_TOMB = "zm_tomb"
CoD.Zombie.Maps = {}
CoD.Zombie.Maps[1] = CoD.Zombie.MAP_ZM_TRANSIT
CoD.Zombie.Maps[2] = CoD.Zombie.MAP_ZM_NUKED
CoD.Zombie.Maps[3] = CoD.Zombie.MAP_ZM_HIGHRISE
CoD.Zombie.Maps[4] = CoD.Zombie.MAP_ZM_PRISON
CoD.Zombie.Maps[5] = CoD.Zombie.MAP_ZM_BURIED
CoD.Zombie.Maps[6] = CoD.Zombie.MAP_ZM_TOMB
CoD.Zombie.DLC0Maps = {}
CoD.Zombie.DLC0Maps[1] = CoD.Zombie.MAP_ZM_NUKED
CoD.Zombie.DLC1Maps = {}
CoD.Zombie.DLC1Maps[1] = CoD.Zombie.MAP_ZM_HIGHRISE
CoD.Zombie.DLC2Maps = {}
CoD.Zombie.DLC2Maps[1] = CoD.Zombie.MAP_ZM_PRISON
CoD.Zombie.DLC3Maps = {}
CoD.Zombie.DLC3Maps[1] = CoD.Zombie.MAP_ZM_BURIED
CoD.Zombie.DLC4Maps = {}
CoD.Zombie.DLC4Maps[1] = CoD.Zombie.MAP_ZM_TOMB
CoD.Zombie.AllDLCMaps = {}
CoD.Zombie.AllDLCMaps[1] = CoD.Zombie.MAP_ZM_NUKED
CoD.Zombie.AllDLCMaps[2] = CoD.Zombie.MAP_ZM_HIGHRISE
CoD.Zombie.AllDLCMaps[3] = CoD.Zombie.MAP_ZM_PRISON
CoD.Zombie.AllDLCMaps[4] = CoD.Zombie.MAP_ZM_BURIED
CoD.Zombie.AllDLCMaps[5] = CoD.Zombie.MAP_ZM_TOMB
CoD.Zombie.SideQuestMaps = {}
CoD.Zombie.SideQuestMaps[1] = CoD.Zombie.MAP_ZM_TRANSIT
CoD.Zombie.SideQuestMaps[2] = CoD.Zombie.MAP_ZM_HIGHRISE
CoD.Zombie.SideQuestMaps[3] = CoD.Zombie.MAP_ZM_BURIED
CoD.Zombie.CharacterNameDisplayMaps = {}
CoD.Zombie.CharacterNameDisplayMaps[1] = CoD.Zombie.MAP_ZM_PRISON
CoD.Zombie.CharacterNameDisplayMaps[2] = CoD.Zombie.MAP_ZM_BURIED
CoD.Zombie.CharacterNameDisplayMaps[3] = CoD.Zombie.MAP_ZM_TOMB
CoD.Zombie.PlayListCurrentSuperCategoryIndex = nil
CoD.Zombie.IsSurvivalUsingCIAModel = nil
CoD.Zombie.miniGameDisabled = true
CoD.Zombie.AllowRoundAnimation = 1
CoD.Zombie.GameOptions = {}
CoD.Zombie.GameOptions[1] = {}
CoD.Zombie.GameOptions[1].id = "zmDifficulty"
CoD.Zombie.GameOptions[1].name = "ZMUI_DIFFICULTY_CAPS"
CoD.Zombie.GameOptions[1].hintText = "ZMUI_DIFFICULTY_DESC"
CoD.Zombie.GameOptions[1].labels = {}
CoD.Zombie.GameOptions[1].labels[1] = "ZMUI_DIFFICULTY_EASY_CAPS"
CoD.Zombie.GameOptions[1].labels[2] = "ZMUI_DIFFICULTY_NORMAL_CAPS"
CoD.Zombie.GameOptions[1].values = {}
CoD.Zombie.GameOptions[1].values[1] = 0
CoD.Zombie.GameOptions[1].values[2] = 1
CoD.Zombie.GameOptions[1].gameTypes = {}
CoD.Zombie.GameOptions[1].gameTypes[1] = CoD.Zombie.GAMETYPE_ZCLASSIC
CoD.Zombie.GameOptions[1].gameTypes[2] = CoD.Zombie.GAMETYPE_ZSTANDARD
CoD.Zombie.GameOptions[1].gameTypes[3] = CoD.Zombie.GAMETYPE_ZGRIEF
CoD.Zombie.GameOptions[2] = {}
CoD.Zombie.GameOptions[2].id = "startRound"
CoD.Zombie.GameOptions[2].name = "ZMUI_STARTING_ROUND_CAPS"
CoD.Zombie.GameOptions[2].hintText = "ZMUI_STARTING_ROUND_DESC"
CoD.Zombie.GameOptions[2].labels = {}
CoD.Zombie.GameOptions[2].labels[1] = "1"
CoD.Zombie.GameOptions[2].labels[2] = "5"
CoD.Zombie.GameOptions[2].labels[3] = "10"
CoD.Zombie.GameOptions[2].labels[4] = "15"
CoD.Zombie.GameOptions[2].labels[5] = "20"
CoD.Zombie.GameOptions[2].values = {}
CoD.Zombie.GameOptions[2].values[1] = 1
CoD.Zombie.GameOptions[2].values[2] = 5
CoD.Zombie.GameOptions[2].values[3] = 10
CoD.Zombie.GameOptions[2].values[4] = 15
CoD.Zombie.GameOptions[2].values[5] = 20
CoD.Zombie.GameOptions[2].gameTypes = {}
CoD.Zombie.GameOptions[2].gameTypes[1] = CoD.Zombie.GAMETYPE_ZSTANDARD
CoD.Zombie.GameOptions[2].gameTypes[2] = CoD.Zombie.GAMETYPE_ZGRIEF
CoD.Zombie.GameOptions[3] = {}
CoD.Zombie.GameOptions[3].id = "magic"
CoD.Zombie.GameOptions[3].name = "ZMUI_MAGIC_CAPS"
CoD.Zombie.GameOptions[3].hintText = "ZMUI_MAGIC_DESC"
CoD.Zombie.GameOptions[3].labels = {}
CoD.Zombie.GameOptions[3].labels[1] = "MENU_ENABLED_CAPS"
CoD.Zombie.GameOptions[3].labels[2] = "MENU_DISABLED_CAPS"
CoD.Zombie.GameOptions[3].values = {}
CoD.Zombie.GameOptions[3].values[1] = 1
CoD.Zombie.GameOptions[3].values[2] = 0
CoD.Zombie.GameOptions[3].gameTypes = {}
CoD.Zombie.GameOptions[3].gameTypes[1] = CoD.Zombie.GAMETYPE_ZSTANDARD
CoD.Zombie.GameOptions[3].gameTypes[2] = CoD.Zombie.GAMETYPE_ZGRIEF
CoD.Zombie.GameOptions[4] = {}
CoD.Zombie.GameOptions[4].id = "headshotsonly"
CoD.Zombie.GameOptions[4].name = "ZMUI_HEADSHOTS_ONLY_CAPS"
CoD.Zombie.GameOptions[4].hintText = "ZMUI_HEADSHOTS_ONLY_DESC"
CoD.Zombie.GameOptions[4].labels = {}
CoD.Zombie.GameOptions[4].labels[1] = "MENU_DISABLED_CAPS"
CoD.Zombie.GameOptions[4].labels[2] = "MENU_ENABLED_CAPS"
CoD.Zombie.GameOptions[4].values = {}
CoD.Zombie.GameOptions[4].values[1] = 0
CoD.Zombie.GameOptions[4].values[2] = 1
CoD.Zombie.GameOptions[4].gameTypes = {}
CoD.Zombie.GameOptions[4].gameTypes[1] = CoD.Zombie.GAMETYPE_ZSTANDARD
CoD.Zombie.GameOptions[4].gameTypes[2] = CoD.Zombie.GAMETYPE_ZGRIEF
CoD.Zombie.GameOptions[5] = {}
CoD.Zombie.GameOptions[5].id = "allowdogs"
CoD.Zombie.GameOptions[5].name = "ZMUI_DOGS_CAPS"
CoD.Zombie.GameOptions[5].hintText = "ZMUI_DOGS_DESC"
CoD.Zombie.GameOptions[5].labels = {}
CoD.Zombie.GameOptions[5].labels[1] = 0
CoD.Zombie.GameOptions[5].labels[2] = 1
CoD.Zombie.GameOptions[5].gameTypes = {}
CoD.Zombie.GameOptions[5].gameTypes[1] = CoD.Zombie.GAMETYPE_ZSTANDARD
CoD.Zombie.GameOptions[5].maps = {}
CoD.Zombie.GameOptions[5].maps[1] = CoD.Zombie.MAP_ZM_TRANSIT
CoD.Zombie.GameOptions[6] = {}
CoD.Zombie.GameOptions[6].id = "cleansedLoadout"
CoD.Zombie.GameOptions[6].name = "ZMUI_CLEANSED_LOADOUT_CAPS"
CoD.Zombie.GameOptions[6].hintText = "ZMUI_CLEANSED_LOADOUT_DESC"
CoD.Zombie.GameOptions[6].labels = {}
CoD.Zombie.GameOptions[6].labels[1] = "ZMUI_CLEANSED_LOADOUT_SHOTGUN_CAPS"
CoD.Zombie.GameOptions[6].labels[2] = "ZMUI_CLEANSED_LOADOUT_GUN_GAME_CAPS"
CoD.Zombie.GameOptions[6].values = {}
CoD.Zombie.GameOptions[6].values[1] = 0
CoD.Zombie.GameOptions[6].values[2] = 1
CoD.Zombie.GameOptions[6].gameTypes = {}
CoD.Zombie.GameOptions[6].gameTypes[1] = CoD.Zombie.GAMETYPE_ZCLEANSED
CoD.Zombie.SingleTeamColor = {}
CoD.Zombie.SingleTeamColor.r = 0
CoD.Zombie.SingleTeamColor.g = 0.5
CoD.Zombie.SingleTeamColor.b = 1
CoD.Zombie.FullScreenSize = {}
CoD.Zombie.FullScreenSize.w = 1280
CoD.Zombie.FullScreenSize.h = 720
CoD.Zombie.FullScreenSize.sw = 960
CoD.Zombie.SplitscreenMultiplier = 1.2
CoD.Zombie.OpenMenuEventMenuNames = {}
CoD.Zombie.OpenMenuEventMenuNames.PublicGameLobby = 1
CoD.Zombie.OpenMenuEventMenuNames.PrivateOnlineGameLobby = 1
CoD.Zombie.OpenMenuEventMenuNames.MainLobby = 1
CoD.Zombie.OpenMenuSelfMenuNames = {}
CoD.Zombie.OpenMenuSelfMenuNames.PublicGameLobby = 1
CoD.Zombie.OpenMenuSelfMenuNames.PrivateOnlineGameLobby = 1
CoD.Zombie.PLAYLIST_CATEGORY_FILTER_SOLOMATCH = "solomatch"
CoD.Zombie.GetUIMapName = function()
	return CoD.Zombie.GetMapName(UIExpression.DvarString(nil, "ui_mapname"))
end

CoD.Zombie.GetMapName = function(MapName)
	if MapName == nil or MapName == "" or string.find(MapName, CoD.Zombie.MAP_ZM_TRANSIT) ~= nil then
		MapName = CoD.Zombie.MAP_ZM_TRANSIT
	end
	return MapName
end

CoD.Zombie.GetDefaultStartLocationForMap = function()
	local MapName = Dvar.ui_mapname:get()
	local DefaultLocation = CoD.Zombie.START_LOCATION_TRANSIT
	if MapName then
		DefaultLocation = UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 6, 2, MapName, 7, "YES", 3)
	end
	return DefaultLocation
end

CoD.Zombie.GetDefaultGameTypeForMap = function()
	local MapName = Dvar.ui_mapname:get()
	local DefaultGametype = CoD.Zombie.GAMETYPE_ZCLASSIC
	if MapName then
		DefaultGametype = UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 6, 2, MapName, 7, "YES", 4)
	end
	return DefaultGametype
end

CoD.Zombie.GetDefaultGameTypeGroupForMap = function()
	local MapName = Dvar.ui_mapname:get()
	local DefaultGametypeGroup = CoD.Zombie.GAMETYPEGROUP_ZCLASSIC
	local DefaultGametype = CoD.Zombie.GAMETYPE_ZCLASSIC
	if MapName then
		DefaultGametype = UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 6, 2, MapName, 7, "YES", 4)
		if DefaultGametype then
			DefaultGametypeGroup = UIExpression.TableLookup(nil, CoD.gametypesTable, 0, 0, 1, DefaultGametype, 9)
		end
	end
	return DefaultGametypeGroup
end

CoD.Zombie.IsDLCMap = function(DlcMapGroup)
	local MapName = Dvar.ui_mapname:get()
	if MapName then
		if not DlcMapGroup then
			DlcMapGroup = CoD.Zombie.AllDLCMaps
		end
		for MapIndex = 1, #DlcMapGroup, 1 do
			if MapName == DlcMapGroup[MapIndex] then
				return true
			end
		end
	end
	return false
end

CoD.Zombie.IsSideQuestMap = function(MapName)
	if not MapName then
		MapName = Dvar.ui_mapname:get()
	end
	if MapName then
		for MapIndex = 1, #CoD.Zombie.SideQuestMaps, 1 do
			if MapName == CoD.Zombie.SideQuestMaps[MapIndex] then
				return true
			end
		end
	end
	return false
end

CoD.Zombie.IsCharacterNameDisplayMap = function(MapName)
	if not MapName then
		MapName = Dvar.ui_mapname:get()
	end
	if MapName then
		for MapIndex = 1, #CoD.Zombie.CharacterNameDisplayMaps, 1 do
			if MapName == CoD.Zombie.CharacterNameDisplayMaps[MapIndex] then
				return true
			end
		end
	end
	return false
end

CoD.Zombie.ColorRichtofen = function(f9_arg0, f9_arg1)
	f9_arg0:beginAnimation("color_rich", f9_arg1)
	f9_arg0:setRGB(CoD.Zombie.SideQuestStoryLine[1].color.r, CoD.Zombie.SideQuestStoryLine[1].color.g, CoD.Zombie.SideQuestStoryLine[1].color.b)
end

CoD.Zombie.ColorMaxis = function(f10_arg0, f10_arg1)
	f10_arg0:beginAnimation("color_maxis", f10_arg1)
	f10_arg0:setRGB(CoD.Zombie.SideQuestStoryLine[2].color.r, CoD.Zombie.SideQuestStoryLine[2].color.g, CoD.Zombie.SideQuestStoryLine[2].color.b)
end

CoD.Zombie.SideQuestStoryLine = {}
CoD.Zombie.SideQuestStoryLine[1] = {
	name = "Richtofen",
	color = CoD.playerBlue,
	colorFunction = CoD.Zombie.ColorRichtofen,
}
CoD.Zombie.SideQuestStoryLine[2] = {
	name = "Maxis",
	color = CoD.BOIIOrange,
	colorFunction = CoD.Zombie.ColorMaxis,
}
CoD.CACUtility = {}
CoD.CACUtility.denySFX = "cac_cmn_deny"
CoD.CACUtility.carouselLRSFX = "cac_slide_nav_lr"
CoD.CACUtility.carouselUpSFX = "cac_slide_nav_up"
CoD.CACUtility.carouselDownSFX = "cac_slide_nav_down"
CoD.CACUtility.carouselEquipSFX = "cac_slide_equip_item"
CoD.PlaylistCategoryFilter = nil
