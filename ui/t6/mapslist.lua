require("T6.Lobby")
require("T6.Menus.PopupMenus")
require("T6.ListBox")

CoD.MapsList = {}
CoD.MapsList.GameModes = {
	"ZMUI_ZCLASSIC_GAMEMODE_CAPS",
	"ZMUI_ZSTANDARD_CAPS",
	"ZMUI_ZGRIEF_CAPS",
	"ZMUI_ZSNR_CAPS",
	"ZMUI_ZRACE_CAPS",
	"ZMUI_ZCONTAINMENT_CAPS",
	"ZMUI_ZMEAT_CAPS",
	-- "ZMUI_ZCLEANSED_CAPS", -- TODO: add
}
CoD.MapsList.Maps = {
	"ZMUI_ZCLASSIC_ZM_TRANSIT_CAPS",
	"ZMUI_ZCLASSIC_ZM_HIGHRISE_CAPS",
	"ZMUI_ZCLASSIC_ZM_BURIED_CAPS",
	"ZMUI_ZCLASSIC_ZM_PRISON_CAPS",
	"ZMUI_ZCLASSIC_ZM_TOMB_CAPS",
}
CoD.MapsList.Locations = {
	"ZMUI_NUKED_STARTLOC_CAPS",
	"ZMUI_TRANSIT_STARTLOC_CAPS",
	"ZMUI_DINER_CAPS",
	"ZMUI_FARM_CAPS",
	"ZMUI_POWER_CAPS",
	"ZMUI_TOWN_CAPS",
	"ZMUI_TUNNEL_CAPS",
	"ZMUI_CORNFIELD_CAPS",
	"ZMUI_SHOPPING_MALL_CAPS",
	"ZMUI_DRAGON_ROOFTOP_CAPS",
	"ZMUI_SWEATSHOP_CAPS",
	"ZMUI_STREET_LOC_CAPS",
	"ZMUI_MAZE_CAPS",
	"ZMUI_CELLBLOCK_CAPS",
	"ZMUI_DOCKS_CAPS",
	"ZMUI_TRENCHES_CAPS",
	"ZMUI_EXCAVATION_SITE_CAPS",
	"ZMUI_CHURCH_CAPS",
	-- "ZMUI_CRAZY_PLACE_CAPS", -- TODO: add
}

local function setGameModeDvars()
	local index = math.max(1, UIExpression.DvarInt(nil, "ui_gametype_index"))
	local gameMode = CoD.MapsList.GameModes[index]

	if gameMode == "ZMUI_ZCLASSIC_GAMEMODE_CAPS" then
		Engine.SetDvar("ui_zm_gamemodegroup", "zclassic")
		Engine.SetDvar("ui_gametype", "zclassic")
	elseif gameMode == "ZMUI_ZSTANDARD_CAPS" then
		Engine.SetDvar("ui_zm_gamemodegroup", "zsurvival")
		Engine.SetDvar("ui_gametype", "zstandard")
	elseif gameMode == "ZMUI_ZGRIEF_CAPS" then
		Engine.SetDvar("ui_zm_gamemodegroup", "zencounter")
		Engine.SetDvar("ui_gametype", "zgrief")
		Engine.SetDvar("ui_gametype_obj", "zgrief")
	elseif gameMode == "ZMUI_ZSNR_CAPS" then
		Engine.SetDvar("ui_zm_gamemodegroup", "zencounter")
		Engine.SetDvar("ui_gametype", "zgrief")
		Engine.SetDvar("ui_gametype_obj", "zsnr")
	elseif gameMode == "ZMUI_ZRACE_CAPS" then
		Engine.SetDvar("ui_zm_gamemodegroup", "zencounter")
		Engine.SetDvar("ui_gametype", "zgrief")
		Engine.SetDvar("ui_gametype_obj", "zrace")
	elseif gameMode == "ZMUI_ZCONTAINMENT_CAPS" then
		Engine.SetDvar("ui_zm_gamemodegroup", "zencounter")
		Engine.SetDvar("ui_gametype", "zgrief")
		Engine.SetDvar("ui_gametype_obj", "zcontainment")
	elseif gameMode == "ZMUI_ZMEAT_CAPS" then
		Engine.SetDvar("ui_zm_gamemodegroup", "zencounter")
		Engine.SetDvar("ui_gametype", "zgrief")
		Engine.SetDvar("ui_gametype_obj", "zmeat")
	elseif gameMode == "ZMUI_ZCLEANSED_CAPS" then
		-- TODO: set dvars when game mode is added
	end
end

local function setMapDvars()
	local index = math.max(1, UIExpression.DvarInt(nil, "ui_mapname_index"))
	local map = CoD.MapsList.Maps[index]

	if map == "ZMUI_ZCLASSIC_ZM_TRANSIT_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "transit")
	elseif map == "ZMUI_ZCLASSIC_ZM_HIGHRISE_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_highrise")
		Engine.SetDvar("ui_zm_mapstartlocation", "rooftop")
	elseif map == "ZMUI_ZCLASSIC_ZM_PRISON_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_prison")
		Engine.SetDvar("ui_zm_mapstartlocation", "prison")
	elseif map == "ZMUI_ZCLASSIC_ZM_BURIED_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_buried")
		Engine.SetDvar("ui_zm_mapstartlocation", "processing")
	elseif map == "ZMUI_ZCLASSIC_ZM_TOMB_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_tomb")
		Engine.SetDvar("ui_zm_mapstartlocation", "tomb")
	end
end

local function setLocationDvars()
	local index = math.max(1, UIExpression.DvarInt(nil, "ui_zm_mapstartlocation_index"))
	local location = CoD.MapsList.Locations[index]

	if location == "ZMUI_TRANSIT_STARTLOC_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "transit")
	elseif location == "ZMUI_DINER_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "diner")
	elseif location == "ZMUI_FARM_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "farm")
	elseif location == "ZMUI_POWER_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "power")
	elseif location == "ZMUI_TOWN_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "town")
	elseif location == "ZMUI_TUNNEL_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "tunnel")
	elseif location == "ZMUI_CORNFIELD_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_transit")
		Engine.SetDvar("ui_zm_mapstartlocation", "cornfield")
	elseif location == "ZMUI_NUKED_STARTLOC_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_nuked")
		Engine.SetDvar("ui_zm_mapstartlocation", "nuked")
	elseif location == "ZMUI_SHOPPING_MALL_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_highrise")
		Engine.SetDvar("ui_zm_mapstartlocation", "shopping_mall")
	elseif location == "ZMUI_DRAGON_ROOFTOP_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_highrise")
		Engine.SetDvar("ui_zm_mapstartlocation", "dragon_rooftop")
	elseif location == "ZMUI_SWEATSHOP_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_highrise")
		Engine.SetDvar("ui_zm_mapstartlocation", "sweatshop")
	elseif location == "ZMUI_CELLBLOCK_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_prison")
		Engine.SetDvar("ui_zm_mapstartlocation", "cellblock")
	elseif location == "ZMUI_DOCKS_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_prison")
		Engine.SetDvar("ui_zm_mapstartlocation", "docks")
	elseif location == "ZMUI_STREET_LOC_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_buried")
		Engine.SetDvar("ui_zm_mapstartlocation", "street")
	elseif location == "ZMUI_MAZE_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_buried")
		Engine.SetDvar("ui_zm_mapstartlocation", "maze")
	elseif location == "ZMUI_TRENCHES_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_tomb")
		Engine.SetDvar("ui_zm_mapstartlocation", "trenches")
	elseif location == "ZMUI_EXCAVATION_SITE_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_tomb")
		Engine.SetDvar("ui_zm_mapstartlocation", "excavation_site")
	elseif location == "ZMUI_CHURCH_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_tomb")
		Engine.SetDvar("ui_zm_mapstartlocation", "church")
	elseif location == "ZMUI_CRAZY_PLACE_CAPS" then
		Engine.SetDvar("ui_mapname", "zm_tomb")
		Engine.SetDvar("ui_zm_mapstartlocation", "crazy_place")
	end
end

local function gameModeListFocusChangedEventHandler(self, event)
	local focusedIndex = self.listBox:getFocussedIndex()
end

local function gameModeListSelectionClickedEventHandler(self, event)
	local focusedIndex = self.listBox:getFocussedIndex()

	CoD.MapsList.GameModeIndex = focusedIndex

	local gameMode = CoD.MapsList.GameModes[focusedIndex]

	if gameMode == "ZMUI_ZCLASSIC_GAMEMODE_CAPS" then
		self:openMenu("SelectMapListZM", self.controller)
	else
		self:openMenu("SelectLocationListZM", self.controller)
	end

	self:close()
end

local function gameModeListBackEventHandler(self, event)
	CoD.MapsList.GameModeIndex = nil
	CoD.Menu.ButtonPromptBack(self, event)
end

local function gameModeListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function gameModeListGetButtonData(controller, index, mutables, self)
	local gameMode = CoD.MapsList.GameModes[index]
	mutables.text:setText(Engine.Localize(gameMode))
end

function LUI.createMenu.SelectGameModeListZM(controller)
	local self = CoD.Menu.New("SelectGameModeListZM")
	self.controller = controller

	self:setPreviousMenu("PrivateOnlineGameLobby")

	self:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_GAMEMODE_CAPS"))

	local index = math.max(1, UIExpression.DvarInt(nil, "ui_gametype_index"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, gameModeListCreateButtonMutables, gameModeListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()

	if UIExpression.DvarBool(nil, "party_solo") == 1 then
		listBox:setTotalItems(2, index)
	else
		listBox:setTotalItems(#CoD.MapsList.GameModes, index)
	end

	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("button_prompt_back", gameModeListBackEventHandler)
	self:registerEventHandler("listbox_focus_changed", gameModeListFocusChangedEventHandler)
	self:registerEventHandler("click", gameModeListSelectionClickedEventHandler)

	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_GAMETYPE)
	CoD.PrivateGameLobby.FadeIn = true

	return self
end

local function mapListFocusChangedEventHandler(self, event)
	local focusedIndex = self.listBox:getFocussedIndex()
end

local function mapListSelectionClickedEventHandler(self, event)
	local focusedIndex = self.listBox:getFocussedIndex()

	if CoD.MapsList.GameModeIndex ~= nil then
		Engine.SetDvar("ui_gametype_index", CoD.MapsList.GameModeIndex)
		CoD.MapsList.GameModeIndex = nil
	end

	Engine.SetDvar("ui_mapname_index", focusedIndex)

	setGameModeDvars()
	setMapDvars()

	self:openMenu("PrivateOnlineGameLobby", self.controller)

	self:close()
end

local function mapListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function mapListGetButtonData(controller, index, mutables, self)
	local map = CoD.MapsList.Maps[index]
	mutables.text:setText(Engine.Localize(map))
end

function LUI.createMenu.SelectMapListZM(controller)
	local self = CoD.Menu.New("SelectMapListZM")
	self.controller = controller

	self:setPreviousMenu("SelectGameModeListZM")
	self:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_MAPS_CAPS"))

	local index = math.max(1, UIExpression.DvarInt(nil, "ui_mapname_index"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, mapListCreateButtonMutables, mapListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()
	listBox:setTotalItems(#CoD.MapsList.Maps, index)
	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("listbox_focus_changed", mapListFocusChangedEventHandler)
	self:registerEventHandler("click", mapListSelectionClickedEventHandler)

	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_MAP)
	CoD.PrivateGameLobby.FadeIn = true

	return self
end

local function locationListFocusChangedEventHandler(self, event)
	local focusedIndex = self.listBox:getFocussedIndex()
end

local function locationListSelectionClickedEventHandler(self, event)
	local focusedIndex = self.listBox:getFocussedIndex()

	if CoD.MapsList.GameModeIndex ~= nil then
		Engine.SetDvar("ui_gametype_index", CoD.MapsList.GameModeIndex)
		CoD.MapsList.GameModeIndex = nil
	end

	Engine.SetDvar("ui_zm_mapstartlocation_index", focusedIndex)

	setGameModeDvars()
	setLocationDvars()

	self:openMenu("PrivateOnlineGameLobby", self.controller)

	self:close()
end

local function locationListCreateButtonMutables(controller, mutables)
	local text = LUI.UIText.new()
	text:setLeftRight(true, false, 2, 2)
	text:setTopBottom(true, true, 0, 0)
	text:setRGB(1, 1, 1)
	text:setAlpha(1)
	mutables:addElement(text)
	mutables.text = text
end

local function locationListGetButtonData(controller, index, mutables, self)
	local location = CoD.MapsList.Locations[index]
	mutables.text:setText(Engine.Localize(location))
end

function LUI.createMenu.SelectLocationListZM(controller)
	local self = CoD.Menu.New("SelectLocationListZM")
	self.controller = controller

	self:setPreviousMenu("SelectGameModeListZM")
	self:registerEventHandler("open_menu", CoD.Lobby.OpenMenu)
	self:addSelectButton()
	self:addBackButton()

	self:addTitle(Engine.Localize("MPUI_MAPS_CAPS"))

	local index = math.max(1, UIExpression.DvarInt(nil, "ui_zm_mapstartlocation_index"))

	local listBox = CoD.ListBox.new(nil, controller, 15, CoD.CoD9Button.Height, 250, locationListCreateButtonMutables, locationListGetButtonData, 5, 0)
	listBox:setLeftRight(true, false, 0, 250)
	listBox:setTopBottom(true, false, 75, 75 + 530)
	listBox:addScrollBar()
	listBox:setTotalItems(#CoD.MapsList.Locations, index)
	self:addElement(listBox)
	self.listBox = listBox

	self:registerEventHandler("listbox_focus_changed", locationListFocusChangedEventHandler)
	self:registerEventHandler("click", locationListSelectionClickedEventHandler)

	Engine.PartyHostSetUIState(CoD.PARTYHOST_STATE_SELECTING_MAP)
	CoD.PrivateGameLobby.FadeIn = true

	return self
end
