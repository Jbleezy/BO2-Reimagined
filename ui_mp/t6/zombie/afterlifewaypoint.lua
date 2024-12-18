CoD.AfterlifeWaypoint = {}
CoD.AfterlifeWaypoint.IconAlpha = 0.5
CoD.AfterlifeWaypoint.IconRatio = 2
CoD.AfterlifeWaypoint.IconWidth = 40
CoD.AfterlifeWaypoint.IconHeight = CoD.AfterlifeWaypoint.IconWidth / CoD.AfterlifeWaypoint.IconRatio
CoD.AfterlifeWaypoint.ArrowWidth = 20
CoD.AfterlifeWaypoint.ArrowHeight = CoD.AfterlifeWaypoint.ArrowWidth / CoD.AfterlifeWaypoint.IconRatio
CoD.AfterlifeWaypoint.PointerDistance = 30
CoD.AfterlifeWaypoint.TopBottomOffset = CoD.AfterlifeWaypoint.ArrowHeight / 2 + CoD.AfterlifeWaypoint.PointerDistance / 2
CoD.AfterlifeWaypoint.PULSE_DURATION = 3000
CoD.AfterlifeWaypoint.ICON_STATE_CLEAR = 0
CoD.AfterlifeWaypoint.ReviveMaterialName = "waypoint_revive_afterlife"
CoD.AfterlifeWaypoint.ArrowMaterialName = "waypoint_afterlife_blue_arrow"
CoD.AfterlifeWaypoint.RegisterMaterials = function()
	if not CoD.AfterlifeWaypoint.ReviveIconMaterial then
		CoD.AfterlifeWaypoint.ReviveIconMaterial = RegisterMaterial(CoD.AfterlifeWaypoint.ReviveMaterialName)
	end
	if not CoD.AfterlifeWaypoint.ArrowMaterial then
		CoD.AfterlifeWaypoint.ArrowMaterial = RegisterMaterial(CoD.AfterlifeWaypoint.ArrowMaterialName)
	end
end

CoD.AfterlifeWaypoint.new = function(f2_arg0)
	local Widget = LUI.UIElement.new()
	Widget:setLeftRight(false, false, -CoD.AfterlifeWaypoint.IconWidth / 2, CoD.AfterlifeWaypoint.IconWidth / 2)
	Widget:setTopBottom(false, false, -CoD.AfterlifeWaypoint.IconHeight - CoD.AfterlifeWaypoint.TopBottomOffset, -CoD.AfterlifeWaypoint.TopBottomOffset)
	Widget:setupEntityContainer(f2_arg0, 0, 0, 40)
	Widget:setEntityContainerScale(false)
	Widget:setEntityContainerClamp(true)
	Widget:setEntityContainerFadeWhenTargeted(true)

	local alphaController = LUI.UIElement.new()
	alphaController:setLeftRight(true, true, 0, 0)
	alphaController:setTopBottom(true, true, 0, 0)
	Widget:addElement(alphaController)
	Widget.alphaController = alphaController

	local mainImage = LUI.UIImage.new()
	mainImage:setLeftRight(true, true, 0, 0)
	mainImage:setTopBottom(true, true, 0, 0)
	mainImage:setImage(CoD.AfterlifeWaypoint.ReviveIconMaterial)
	alphaController:addElement(mainImage)
	Widget.mainImage = mainImage

	local edgePointerContainer = LUI.UIElement.new()
	edgePointerContainer:setLeftRight(true, true, 0, 0)
	edgePointerContainer:setTopBottom(true, true, -CoD.AfterlifeWaypoint.PointerDistance / 2, CoD.AfterlifeWaypoint.PointerDistance / 2)
	alphaController:addElement(edgePointerContainer)
	Widget.edgePointerContainer = edgePointerContainer

	local arrowImage = LUI.UIImage.new()
	arrowImage:setLeftRight(false, false, -CoD.AfterlifeWaypoint.ArrowWidth / 2, CoD.AfterlifeWaypoint.ArrowWidth / 2)
	arrowImage:setTopBottom(false, true, -CoD.AfterlifeWaypoint.ArrowHeight / 2, CoD.AfterlifeWaypoint.ArrowHeight / 2)
	arrowImage:setImage(CoD.AfterlifeWaypoint.ArrowMaterial)
	edgePointerContainer:addElement(arrowImage)
	Widget.arrowImage = arrowImage

	Widget:registerEventHandler("entity_container_clamped", CoD.AfterlifeWaypoint.Clamped)
	Widget:registerEventHandler("entity_container_unclamped", CoD.AfterlifeWaypoint.Unclamped)
	return Widget
end

CoD.AfterlifeWaypoint.Clamped = function(f3_arg0, f3_arg1)
	if f3_arg0.edgePointerContainer then
		f3_arg0.edgePointerContainer:setupEdgePointer(90)
	end
end

CoD.AfterlifeWaypoint.Unclamped = function(f4_arg0, f4_arg1)
	if f4_arg0.edgePointerContainer then
		f4_arg0.edgePointerContainer:setupUIElement()
		f4_arg0.edgePointerContainer:setZRot(0)
	end
end
