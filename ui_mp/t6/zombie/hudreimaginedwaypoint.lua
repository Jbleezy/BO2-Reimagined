CoD.ReimaginedWaypoint = {}
CoD.GameModeObjectiveWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.GameModeObjectiveWaypoint.FLAG_HIDE = 0
CoD.GameModeObjectiveWaypoint.FLAG_SHOW = 1
CoD.PlayerObjectiveWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerEnemyWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerCloneWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerReviveWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerDownWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerAliveWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerWaypoint.FLAG_DEAD = 0
CoD.PlayerWaypoint.FLAG_ALIVE = 1
CoD.PlayerWaypoint.FLAG_DOWN = 2
CoD.PlayerWaypoint.FLAG_OBJECTIVE = 3
CoD.TombstoneWaypoint = InheritFrom(CoD.ObjectiveWaypoint)
CoD.PlayerHeadIcon = InheritFrom(CoD.ObjectiveWaypoint)

LUI.createMenu.GameModeObjectiveWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("GameModeObjectiveWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_GAME_MODE_1 = CoD.GameModeObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_GAME_MODE_2 = CoD.GameModeObjectiveWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.GameModeObjectiveWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerObjectiveWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerObjectiveWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerObjectiveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerObjectiveWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.GameModeObjectiveWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.GameModeObjectiveWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerCloneWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerCloneWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_1 = CoD.PlayerCloneWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_2 = CoD.PlayerCloneWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_3 = CoD.PlayerCloneWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_4 = CoD.PlayerCloneWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_5 = CoD.PlayerCloneWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_6 = CoD.PlayerCloneWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_7 = CoD.PlayerCloneWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_CLONE_8 = CoD.PlayerCloneWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_SHOWOBJICONS, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerCloneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerCloneWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerReviveWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerReviveWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerReviveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerReviveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerReviveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerReviveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerReviveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerReviveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerReviveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerReviveWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_SHOWOBJICONS, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerDownWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerDownWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerDownWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerDownWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_SHOWOBJICONS, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerEnemyWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerEnemyWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerEnemyWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerEnemyWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerEnemyWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerEnemyWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerEnemyWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerEnemyWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerEnemyWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerEnemyWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_SHOWOBJICONS, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerWaypoint.UpdateVisibility)

	return safeArea
end

LUI.createMenu.PlayerAliveWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerAliveWaypointArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerAliveWaypoint
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerAliveWaypoint

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_SHOWOBJICONS, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerWaypoint.UpdateVisibility)

	return safeArea
end

CoD.GameModeObjectiveWaypoint.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.PlayerCloneWaypoint.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_SHOWOBJICONS) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.PlayerWaypoint.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_SHOWOBJICONS) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.GameModeObjectiveWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.GameModeObjectiveWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -12, 12)
	waypoint.arrowImage:setTopBottom(false, false, 21, 45)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updateProgress = CoD.NullFunction
	waypoint.updatePlayerUsing = CoD.GameModeObjectiveWaypoint.updatePlayerUsing
	waypoint.snapToHeight = -250
	waypoint.x = 0
	waypoint.y = 0
	waypoint.z = 0

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)

	if objectiveName == "OBJ_GAME_MODE_1" then
		waypoint:setPriority(100)
	end

	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("transition_complete_snap_out", CoD.ReimaginedWaypoint.TransitionCompleteSnapOut)

	return waypoint
end

CoD.GameModeObjectiveWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local gametype = UIExpression.DvarString(nil, "ui_gametype")

	if objectiveFlags == CoD.GameModeObjectiveWaypoint.FLAG_SHOW then
		local objectiveIcon = ""
		local objectiveArrow = "waypoint_circle_arrow"

		if gametype == "zcontainment" then
			local objectiveName = Engine.GetObjectiveName(controller, index)
			local objectiveTeam = Engine.GetObjectiveTeam(Menu, index)
			local clientTeam = Engine.GetTeamID(controller, clientNum)

			if objectiveTeam == CoD.TEAM_FREE then
				objectiveIcon = "white_waypoint_target"

				if objectiveName == "OBJ_GAME_MODE_1" then
					Menu.mainImage:setAlpha(1)
					Menu.arrowImage:setAlpha(1)
					Menu.mainImage:setRGB(1, 1, 1)
					Menu.arrowImage:setRGB(1, 1, 1)
				elseif objectiveName == "OBJ_GAME_MODE_2" then
					Menu.mainImage:setAlpha(0.5)
					Menu.arrowImage:setAlpha(0.5)
					Menu.mainImage:setRGB(0.5, 0.5, 0.5)
					Menu.arrowImage:setRGB(0.5, 0.5, 0.5)
				end
			elseif objectiveTeam == CoD.TEAM_THREE then
				objectiveIcon = "white_waypoint_contested"
				Menu.mainImage:setRGB(1, 1, 0)
				Menu.arrowImage:setRGB(1, 1, 0)
			elseif objectiveTeam == clientTeam then
				objectiveIcon = "white_waypoint_defend"
				Menu.mainImage:setRGB(0, 1, 0)
				Menu.arrowImage:setRGB(0, 1, 0)
			else
				objectiveIcon = "white_waypoint_capture"
				Menu.mainImage:setRGB(1, 0, 0)
				Menu.arrowImage:setRGB(1, 0, 0)
			end

			Menu.zOffset = 40
		elseif gametype == "zmeat" then
			objectiveIcon = "white_waypoint_grab"
			Menu.mainImage:setRGB(1, 1, 1)
			Menu.arrowImage:setRGB(1, 1, 1)
			Menu.zOffset = 20
		end

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setImage(RegisterMaterial(objectiveIcon))
		Menu.arrowImage:setImage(RegisterMaterial(objectiveArrow))
	else
		Menu.alphaController:setAlpha(0)
	end

	Menu.super.update(Menu, ClientInstance)
end

CoD.GameModeObjectiveWaypoint.updatePlayerUsing = function(Menu, LocalClientIndex, IsPlayerTeamUsing, IsAnyOtherTeamUsing)
	local index = Menu.index
	local clientNum = Engine.GetClientNum(LocalClientIndex)
	local objectiveIsPlayerUsing = Engine.ObjectiveIsPlayerUsing(LocalClientIndex, index, clientNum)
	local x, y, z = Engine.GetObjectivePosition(Menu, index)
	local newObjPos = false

	if Menu.x ~= x or Menu.y ~= y or Menu.z ~= z then
		Menu.x, Menu.y, Menu.z = x, y, z
		newObjPos = true
	end

	if objectiveIsPlayerUsing then
		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			if not newObjPos then
				Menu:beginAnimation("snap_in", Menu.snapToTime, true, true)
			end
		end

		Menu:setEntityContainerStopUpdating(true)
		Menu:setLeftRight(false, false, -Menu.largeIconWidth / 2, Menu.largeIconWidth / 2)
		Menu:setTopBottom(false, false, -Menu.largeIconHeight - Menu.snapToHeight, -Menu.snapToHeight)
		Menu.edgePointerContainer:setAlpha(0)
	else
		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			if not newObjPos then
				Menu:beginAnimation("snap_out", Menu.snapToTime, true, true)
			end
		end

		Menu:setEntityContainerStopUpdating(false)
		Menu:setLeftRight(false, false, -Menu.iconWidth / 2, Menu.iconWidth / 2)
		Menu:setTopBottom(false, true, -Menu.iconHeight, 0)
		Menu.edgePointerContainer:setAlpha(1)
	end

	Menu.playerUsing = objectiveIsPlayerUsing
end

CoD.PlayerObjectiveWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerObjectiveWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -12, 12)
	waypoint.arrowImage:setTopBottom(false, false, 21, 45)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updatePlayerUsing = CoD.NullFunction

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("entity_container_update_offset", CoD.ReimaginedWaypoint.updateOffset)

	return waypoint
end

CoD.PlayerObjectiveWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)
	local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_OBJECTIVE then
		local objectiveIcon = ""
		local objectiveArrow = "waypoint_circle_arrow"

		if clientTeam == objectiveEntityTeam then
			objectiveIcon = "white_waypoint_escort"
			Menu.mainImage:setRGB(0, 1, 0)
			Menu.arrowImage:setRGB(0, 1, 0)
		else
			objectiveIcon = "white_waypoint_kill"
			Menu.mainImage:setRGB(1, 0, 0)
			Menu.arrowImage:setRGB(1, 0, 0)
		end

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setImage(RegisterMaterial(objectiveIcon))
		Menu.arrowImage:setImage(RegisterMaterial(objectiveArrow))
	else
		Menu.alphaController:setAlpha(0)
	end

	Menu:processEvent({ name = "entity_container_update_offset" })

	Menu.super.update(Menu, ClientInstance)
end

CoD.PlayerCloneWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerCloneWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updatePlayerUsing = CoD.PlayerCloneWaypoint.updatePlayerUsing
	waypoint.snapToHeight = 80

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("player_corpse_id", waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("transition_complete_snap_out", CoD.ReimaginedWaypoint.TransitionCompleteSnapOut)

	return waypoint
end

CoD.PlayerCloneWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local mapName = CoD.Zombie.GetUIMapName()
	local cloneReviveIcon = ""
	local cloneReviveArrow = ""

	if mapName == CoD.Zombie.MAP_ZM_PRISON then
		local inAfterlife = UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 1

		if inAfterlife then
			local playerIndex = index - 8
			local clientNum = Engine.GetClientNum(controller)
			local playerObjectiveEntity = Engine.GetObjectiveEntity(Menu, playerIndex)

			if clientNum == playerObjectiveEntity then
				Menu.alphaController:setAlpha(1)
			else
				Menu.alphaController:setAlpha(0)
			end
		else
			Menu.alphaController:setAlpha(1)
		end

		cloneReviveIcon = "waypoint_revive_afterlife"
		cloneReviveArrow = "waypoint_afterlife_blue_arrow"

		Menu.mainImage:setLeftRight(false, false, -24, 24)
		Menu.mainImage:setTopBottom(false, false, -27, -3)
		Menu.arrowImage:setLeftRight(false, false, -10, 10)
		Menu.arrowImage:setTopBottom(false, false, 26, 40)
		Menu.arrowImage:setRGB(1, 1, 1)
		Menu.zOffset = 40
	else
		cloneReviveIcon = "specialty_chugabud_zombies"
		cloneReviveArrow = "waypoint_revive_arrow"

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setLeftRight(false, false, -18, 18)
		Menu.mainImage:setTopBottom(false, false, -33, 3)
		Menu.arrowImage:setLeftRight(false, false, -12, 12)
		Menu.arrowImage:setTopBottom(false, false, 21, 45)
		Menu.arrowImage:setRGB(0.25, 0.25, 1)
		Menu.zOffset = 30
	end

	Menu.mainImage:setImage(RegisterMaterial(cloneReviveIcon))
	Menu.arrowImage:setImage(RegisterMaterial(cloneReviveArrow))

	Menu.super.update(Menu, ClientInstance)
end

CoD.PlayerCloneWaypoint.updatePlayerUsing = function(Menu, LocalClientIndex, IsPlayerTeamUsing, IsAnyOtherTeamUsing)
	local index = Menu.index
	local playerIndex = index - 8
	local clientNum = Engine.GetClientNum(LocalClientIndex)
	local playerObjectiveEntity = Engine.GetObjectiveEntity(Menu, playerIndex)
	local objectiveIsPlayerUsing = Engine.ObjectiveIsPlayerUsing(LocalClientIndex, index, clientNum)
	local isAnyTeamUsing = IsPlayerTeamUsing or IsAnyOtherTeamUsing

	if isAnyTeamUsing then
		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_in", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(true)
		Menu:setLeftRight(false, false, -Menu.largeIconWidth / 2, Menu.largeIconWidth / 2)
		Menu:setTopBottom(false, false, -Menu.largeIconHeight - Menu.snapToHeight, -Menu.snapToHeight)
		Menu.edgePointerContainer:setAlpha(0)
	else
		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_out", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(false)
		Menu:setLeftRight(false, false, -Menu.iconWidth / 2, Menu.iconWidth / 2)
		Menu:setTopBottom(false, true, -Menu.iconHeight, 0)
		Menu.edgePointerContainer:setAlpha(1)
	end

	Menu.playerUsing = objectiveIsPlayerUsing
end

CoD.PlayerReviveWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerReviveWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -12, 12)
	waypoint.arrowImage:setTopBottom(false, false, 21, 45)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updatePlayerUsing = CoD.PlayerReviveWaypoint.updatePlayerUsing
	waypoint.snapToHeight = 80

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("transition_complete_snap_out", CoD.ReimaginedWaypoint.TransitionCompleteSnapOut)

	return waypoint
end

CoD.PlayerReviveWaypoint.update = function(Menu, ClientInstance)
	CoD.PlayerWaypoint.updateDownAndRevive(Menu, ClientInstance, false)
end

CoD.PlayerReviveWaypoint.updatePlayerUsing = function(Menu, LocalClientIndex, IsPlayerTeamUsing, IsAnyOtherTeamUsing)
	local index = Menu.index
	local clientNum = Engine.GetClientNum(LocalClientIndex)
	local objectiveIsPlayerUsing = Engine.ObjectiveIsPlayerUsing(LocalClientIndex, index, clientNum)
	local isAnyTeamUsing = IsPlayerTeamUsing or IsAnyOtherTeamUsing

	if isAnyTeamUsing then
		if Menu.showWaypoint then
			Menu.alphaController:setAlpha(1)
		end

		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_in", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(true)
		Menu:setLeftRight(false, false, -Menu.largeIconWidth / 2, Menu.largeIconWidth / 2)
		Menu:setTopBottom(false, false, -Menu.largeIconHeight - Menu.snapToHeight, -Menu.snapToHeight)
		Menu.edgePointerContainer:setAlpha(0)
	else
		Menu.alphaController:setAlpha(0)

		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_out", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(false)
		Menu:setLeftRight(false, false, -Menu.iconWidth / 2, Menu.iconWidth / 2)
		Menu:setTopBottom(false, true, -Menu.iconHeight, 0)
		Menu.edgePointerContainer:setAlpha(1)
	end

	Menu.playerUsing = objectiveIsPlayerUsing
end

CoD.PlayerDownWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerDownWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -12, 12)
	waypoint.arrowImage:setTopBottom(false, false, 21, 45)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updatePlayerUsing = CoD.PlayerDownWaypoint.updatePlayerUsing
	waypoint.snapToHeight = 80

	local colorState = { red = 1, green = 0, blue = 0 }
	waypoint.mainImage:registerAnimationState("color", colorState)
	waypoint.arrowImage:registerAnimationState("color", colorState)

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("transition_complete_snap_out", CoD.ReimaginedWaypoint.TransitionCompleteSnapOut)

	return waypoint
end

CoD.PlayerDownWaypoint.update = function(Menu, ClientInstance)
	CoD.PlayerWaypoint.updateDownAndRevive(Menu, ClientInstance, true)
end

CoD.PlayerDownWaypoint.updatePlayerUsing = function(Menu, LocalClientIndex, IsPlayerTeamUsing, IsAnyOtherTeamUsing)
	local index = Menu.index
	local clientNum = Engine.GetClientNum(LocalClientIndex)
	local objectiveIsPlayerUsing = Engine.ObjectiveIsPlayerUsing(LocalClientIndex, index, clientNum)
	local isAnyTeamUsing = IsPlayerTeamUsing or IsAnyOtherTeamUsing

	if isAnyTeamUsing then
		Menu.alphaController:setAlpha(0)

		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_in", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(true)
		Menu:setLeftRight(false, false, -Menu.largeIconWidth / 2, Menu.largeIconWidth / 2)
		Menu:setTopBottom(false, false, -Menu.largeIconHeight - Menu.snapToHeight, -Menu.snapToHeight)
		Menu.edgePointerContainer:setAlpha(0)
	else
		if Menu.showWaypoint then
			Menu.alphaController:setAlpha(1)
		end

		if Menu.playerUsing == objectiveIsPlayerUsing then
			return
		end

		if Menu.playerUsing ~= nil then
			Menu:beginAnimation("snap_out", Menu.snapToTime, true, true)
		end

		Menu:setEntityContainerStopUpdating(false)
		Menu:setLeftRight(false, false, -Menu.iconWidth / 2, Menu.iconWidth / 2)
		Menu:setTopBottom(false, true, -Menu.iconHeight, 0)
		Menu.edgePointerContainer:setAlpha(1)
	end

	Menu.playerUsing = objectiveIsPlayerUsing
end

CoD.PlayerWaypoint.updateDownAndRevive = function(Menu, ClientInstance, IsDownWaypoint)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)
	local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_DOWN and (clientTeam == objectiveEntityTeam or gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER) then
		local reviveIcon = "waypoint_revive"
		local reviveArrow = "waypoint_revive_arrow"

		if gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
			local faction = Engine.GetFactionForTeam(objectiveEntityTeam)

			if faction == "cdc" or faction == "cia" then
				reviveIcon = "waypoint_revive_" .. faction .. "_zm"
			else
				reviveIcon = "waypoint_revive_" .. faction
			end
		end

		if IsDownWaypoint then
			if clientNum == objectiveEntity then
				Engine.SetDvar("ui_hud_showobjicons", 0)
			end

			if not Menu.showWaypoint then
				local player_lastStandBleedoutTime = UIExpression.DvarInt(nil, "player_lastStandBleedoutTime") * 1000
				Menu.mainImage:setRGB(1, 0.7, 0)
				Menu.arrowImage:setRGB(1, 0.7, 0)
				Menu.mainImage:animateToState("color", player_lastStandBleedoutTime)
				Menu.arrowImage:animateToState("color", player_lastStandBleedoutTime)
			end
		end

		Menu.mainImage:setImage(RegisterMaterial(reviveIcon))
		Menu.arrowImage:setImage(RegisterMaterial(reviveArrow))
		Menu.zOffset = 30
		Menu.showWaypoint = true
	else
		if IsDownWaypoint then
			if clientNum == objectiveEntity then
				Engine.SetDvar("ui_hud_showobjicons", 1)
			end
		end

		Menu.alphaController:setAlpha(0)
		Menu.showWaypoint = nil
	end

	Menu.super.update(Menu, ClientInstance)
end

CoD.PlayerEnemyWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerEnemyWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.mainImage:setLeftRight(false, false, -24, 24)
	waypoint.mainImage:setTopBottom(false, false, -39, 9)
	waypoint.arrowImage:setLeftRight(false, false, -12, 12)
	waypoint.arrowImage:setTopBottom(false, false, 21, 45)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.updatePlayerUsing = CoD.NullFunction

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("entity_container_update_offset", CoD.ReimaginedWaypoint.updateOffset)

	return waypoint
end

CoD.PlayerEnemyWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)
	local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_ALIVE and clientTeam ~= objectiveEntityTeam and gamemodeGroup ~= CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
		local killIcon = "waypoint_kill_red"
		local killArrow = "waypoint_revive_arrow"

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setRGB(1, 0, 0)
		Menu.arrowImage:setRGB(1, 0, 0)
		Menu.mainImage:setImage(RegisterMaterial(killIcon))
		Menu.arrowImage:setImage(RegisterMaterial(killArrow))
	else
		Menu.alphaController:setAlpha(0)
	end

	Menu:processEvent({ name = "entity_container_update_offset" })

	Menu.super.update(Menu, ClientInstance)
end

CoD.PlayerAliveWaypoint.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerAliveWaypoint)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.mainImage:setAlpha(0)
	waypoint.arrowImage:setLeftRight(false, false, -18, 18)
	waypoint.arrowImage:setTopBottom(false, false, 24, 42)
	waypoint.edgePointerContainer:setTopBottom(true, true, -15, -15)
	waypoint.edgePointerContainer:setupEdgePointer(90)
	waypoint.updatePlayerUsing = CoD.NullFunction
	waypoint.boundsClampedCount = 0
	waypoint.boundsTotalCount = 0

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("entity_container_update_offset", CoD.ReimaginedWaypoint.updateOffset)
	waypoint:registerEventHandler("entity_container_clamped", CoD.NullFunction)
	waypoint:registerEventHandler("entity_container_unclamped", CoD.NullFunction)

	local bounds1 = LUI.UIElement.new()
	bounds1:setClass(CoD.PlayerAliveWaypoint)
	bounds1:setupEntityContainer(-1)
	bounds1:setEntityContainerClamp(true)
	waypoint:addElement(bounds1)
	waypoint.bounds1 = bounds1
	waypoint.boundsTotalCount = waypoint.boundsTotalCount + 1
	bounds1.waypoint = waypoint
	bounds1:registerEventHandler("entity_container_clamped", waypoint.BoundsClamped)
	bounds1:registerEventHandler("entity_container_unclamped", waypoint.BoundsUnclamped)

	local bounds2 = LUI.UIElement.new()
	bounds2:setClass(CoD.PlayerAliveWaypoint)
	bounds2:setupEntityContainer(-1)
	bounds2:setEntityContainerClamp(true)
	waypoint:addElement(bounds2)
	waypoint.bounds2 = bounds2
	waypoint.boundsTotalCount = waypoint.boundsTotalCount + 1
	bounds2.waypoint = waypoint
	bounds2:registerEventHandler("entity_container_clamped", waypoint.BoundsClamped)
	bounds2:registerEventHandler("entity_container_unclamped", waypoint.BoundsUnclamped)

	local bounds3 = LUI.UIElement.new()
	bounds3:setClass(CoD.PlayerAliveWaypoint)
	bounds3:setupEntityContainer(-1)
	bounds3:setEntityContainerClamp(true)
	waypoint:addElement(bounds3)
	waypoint.bounds3 = bounds3
	waypoint.boundsTotalCount = waypoint.boundsTotalCount + 1
	bounds3.waypoint = waypoint
	bounds3:registerEventHandler("entity_container_clamped", waypoint.BoundsClamped)
	bounds3:registerEventHandler("entity_container_unclamped", waypoint.BoundsUnclamped)

	return waypoint
end

CoD.PlayerAliveWaypoint.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local x, y, z = Engine.GetObjectivePosition(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_ALIVE and clientTeam == objectiveEntityTeam and Menu.boundsClampedCount == Menu.boundsTotalCount then
		local aliveArrow = "hud_offscreenobjectivepointer"

		Menu.alphaController:setAlpha(1)
		Menu.arrowImage:setImage(RegisterMaterial(aliveArrow))
	else
		Menu.alphaController:setAlpha(0)
	end

	Menu:processEvent({ name = "entity_container_update_offset" })

	Menu.bounds1:setupEntityContainer(objectiveEntity, 0, 0, 0)
	Menu.bounds2:setupEntityContainer(objectiveEntity, 0, 0, z / 2)
	Menu.bounds3:setupEntityContainer(objectiveEntity, 0, 0, z)

	Menu.super.update(Menu, ClientInstance)
end

CoD.PlayerAliveWaypoint.BoundsClamped = function(Menu, ClientInstance)
	Menu.waypoint.boundsClampedCount = Menu.waypoint.boundsClampedCount + 1

	CoD.PlayerAliveWaypoint.update(Menu.waypoint, ClientInstance)
end

CoD.PlayerAliveWaypoint.BoundsUnclamped = function(Menu, ClientInstance)
	Menu.waypoint.boundsClampedCount = Menu.waypoint.boundsClampedCount - 1

	CoD.PlayerAliveWaypoint.update(Menu.waypoint, ClientInstance)
end

LUI.createMenu.TombstoneWaypointArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("TombstoneWaypointArea", LocalClientIndex)

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.TombstoneWaypoint.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.TombstoneWaypoint.UpdateVisibility)

	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.TombstoneWaypoint)
	waypoint:setEntityContainerClamp(false)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.alphaController:setAlpha(0)
	waypoint.arrowImage:setAlpha(0)
	waypoint.mainImage:setLeftRight(false, false, -18, 18)
	waypoint.mainImage:setTopBottom(false, false, -18, 18)
	safeArea:addElement(waypoint)

	waypoint:registerEventHandler("objective_update_tombstone_powerup", waypoint.update)

	return safeArea
end

CoD.TombstoneWaypoint.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.TombstoneWaypoint.update = function(Menu, ClientInstance)
	if ClientInstance.data ~= nil then
		local objectiveEntity = ClientInstance.data[1]
		local powerupIcon = "specialty_tombstone_zombies"

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setImage(RegisterMaterial(powerupIcon))
		Menu.zOffset = 40

		Menu:setupEntityContainer(objectiveEntity, 0, 0, Menu.zOffset)
	else
		Menu.alphaController:setAlpha(0)
	end
end

LUI.createMenu.PlayerHeadIconArea = function(LocalClientIndex)
	local safeArea = CoD.GametypeBase.new("PlayerHeadIconArea", LocalClientIndex)

	safeArea.objectiveTypes.OBJ_PLAYER_1 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_2 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_3 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_4 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_5 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_6 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_7 = CoD.PlayerHeadIcon
	safeArea.objectiveTypes.OBJ_PLAYER_8 = CoD.PlayerHeadIcon

	safeArea:registerEventHandler("hud_update_refresh", CoD.GametypeBase.Refresh)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_HUD_VISIBLE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_PLAYER_IN_AFTERLIFE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_VEHICLE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_GUIDED_MISSILE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_AMMO_COUNTER_HIDE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_UI_ACTIVE, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_SCOREBOARD_OPEN, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_PLAYER_DEAD, CoD.PlayerHeadIcon.UpdateVisibility)
	safeArea:registerEventHandler("hud_update_bit_" .. CoD.BIT_IS_SCOPED, CoD.PlayerHeadIcon.UpdateVisibility)

	return safeArea
end

CoD.PlayerHeadIcon.UpdateVisibility = function(Menu, ClientInstance)
	local controller = ClientInstance.controller
	if UIExpression.DvarBool(nil, "ui_hud_head_icons") == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_HUD_VISIBLE) == 1 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_PLAYER_IN_AFTERLIFE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_CAMERA_MODE_MOVIECAM) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_DEMO_ALL_GAME_HUD_HIDDEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_VEHICLE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_GUIDED_MISSILE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IN_REMOTE_KILLSTREAK_STATIC) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_AMMO_COUNTER_HIDE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_UI_ACTIVE) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_SCOREBOARD_OPEN) == 0 and UIExpression.IsVisibilityBitSet(controller, CoD.BIT_IS_SCOPED) == 0 and (not CoD.IsShoutcaster(controller) or CoD.ExeProfileVarBool(controller, "shoutcaster_scorestreaks") and Engine.IsSpectatingActiveClient(controller)) and CoD.FSM_VISIBILITY(controller) == 0 then
		if Menu.visible ~= true then
			Menu:setAlpha(1)
			Menu.m_inputDisabled = nil
			Menu.visible = true
		end
	elseif Menu.visible == true then
		Menu:setAlpha(0)
		Menu.m_inputDisabled = true
		Menu.visible = nil
	end
	Menu:dispatchEventToChildren(ClientInstance)
end

CoD.PlayerHeadIcon.new = function(Menu, ObjectiveIndex)
	local waypoint = CoD.ObjectiveWaypoint.new(Menu, ObjectiveIndex, 0)
	waypoint:setClass(CoD.PlayerHeadIcon)
	waypoint:setEntityContainerClamp(false)
	waypoint:setLeftRight(false, false, -waypoint.iconWidth / 2, waypoint.iconWidth / 2)
	waypoint:setTopBottom(false, true, -waypoint.iconHeight, 0)
	waypoint.arrowImage:setAlpha(0)
	waypoint.mainImage:setLeftRight(false, false, -18, 18)
	waypoint.mainImage:setTopBottom(false, false, -18, 18)
	waypoint.updatePlayerUsing = CoD.NullFunction

	local objectiveName = Engine.GetObjectiveName(Menu, ObjectiveIndex)
	waypoint:registerEventHandler("objective_update_" .. objectiveName, waypoint.update)
	waypoint:registerEventHandler("hud_update_team_change", waypoint.update)
	waypoint:registerEventHandler("hud_update_other_player_team_change", waypoint.update)
	waypoint:registerEventHandler("entity_container_update_offset", CoD.ReimaginedWaypoint.updateOffset)

	return waypoint
end

CoD.PlayerHeadIcon.update = function(Menu, ClientInstance)
	local index = Menu.index
	local controller = ClientInstance.controller
	local clientNum = Engine.GetClientNum(controller)
	local objectiveFlags = Engine.GetObjectiveGamemodeFlags(Menu, index)
	local objectiveEntity = Engine.GetObjectiveEntity(Menu, index)
	local clientTeam = Engine.GetTeamID(controller, clientNum)
	local objectiveEntityTeam = Engine.GetTeamID(controller, objectiveEntity)

	if objectiveFlags == CoD.PlayerWaypoint.FLAG_ALIVE and clientTeam == objectiveEntityTeam then
		local gamemodeGroup = UIExpression.DvarString(nil, "ui_zm_gamemodegroup")
		local mapName = CoD.Zombie.GetUIMapName()
		local factionIcon = "faction_" .. Engine.GetFactionForTeam(objectiveEntityTeam)

		if gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZCLASSIC then
			if mapName == CoD.Zombie.MAP_ZM_TOMB then
				factionIcon = "faction_tomb"
			elseif mapName == CoD.Zombie.MAP_ZM_BURIED then
				factionIcon = "faction_buried"
			elseif mapName == CoD.Zombie.MAP_ZM_PRISON then
				factionIcon = "faction_prison"
			elseif mapName == CoD.Zombie.MAP_ZM_HIGHRISE then
				factionIcon = "faction_highrise"
			else
				factionIcon = "faction_tranzit"
			end
		elseif gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZSURVIVAL then
			if CoD.Zombie.IsSurvivalUsingCIAModel == true then
				if mapName == CoD.Zombie.MAP_ZM_PRISON or mapName == CoD.Zombie.MAP_ZM_TOMB then
					factionIcon = "faction_inmates"
				else
					factionIcon = "faction_cia"
				end
			end
		elseif gamemodeGroup == CoD.Zombie.GAMETYPEGROUP_ZENCOUNTER then
			if Dvar.ui_gametype:get() == CoD.Zombie.GAMETYPE_ZCLEANSED and objectiveEntityTeam == CoD.TEAM_AXIS then
				factionIcon = "faction_zombie"
			end
		end

		Menu.alphaController:setAlpha(1)
		Menu.mainImage:setImage(RegisterMaterial(factionIcon))
	else
		Menu.alphaController:setAlpha(0)
	end

	Menu:processEvent({ name = "entity_container_update_offset" })

	Menu.super.update(Menu, ClientInstance)
end

CoD.ReimaginedWaypoint.updateOffset = function(Menu, ClientInstance)
	local index = Menu.index
	local x, y, z = Engine.GetObjectivePosition(Menu, index)
	Menu.zOffsetNew = z

	if Menu.zOffset == 0 then
		Menu.zOffset = z
	end

	if Menu.zOffset ~= Menu.zOffsetNew then
		local moveScale = UIExpression.DvarInt(nil, "com_maxfps") / 120

		if moveScale == 0 then
			moveScale = 1
		end

		local moveAmount = 1 / moveScale

		if Menu.zOffset > Menu.zOffsetNew then
			Menu.zOffset = math.max(Menu.zOffset - moveAmount, Menu.zOffsetNew)
		else
			Menu.zOffset = math.min(Menu.zOffset + moveAmount, Menu.zOffsetNew)
		end
	end

	if Menu.timer ~= nil then
		Menu.super.update(Menu, ClientInstance)
	end

	if Menu.zOffset == Menu.zOffsetNew then
		if Menu.timer ~= nil then
			Menu.timer:close()
			Menu.timer = nil
		end

		return
	end

	if Menu.timer == nil then
		Menu.timer = LUI.UITimer.new(1, "entity_container_update_offset", false)
		Menu:addElement(Menu.timer)
	end
end

CoD.ReimaginedWaypoint.TransitionCompleteSnapOut = function(Menu, Event)
	if not Event.interrupted then
		Menu:setAlpha(0)
	end
end
