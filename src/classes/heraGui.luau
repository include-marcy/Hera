-- This file is a part of the Hera library. Hera is licensed under the terms of the MIT License. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);
local Roact = require(script.Parent.Parent.heraPackages.roact);

-- Class Definition
local heraGui = {};
heraGui.__index = heraGui;

-- Type Definition
export type heraGui = typeof(setmetatable({} :: {
	heraClassName : "heraGui";
    name : string;
    widget : DockWidgetPluginGui?;
}, {} :: typeof(heraGui)))

--[==[
	@lib Hera
	@class heraGui

	The heraGui class is the Hera Virtual API representation of the Roact Hera Transit Designer Plugin GUI (Graphical User Interface).

	@param heraGuiCreateInfo;
	@return heraGui;
]==]
function heraGui.new(heraGuiCreateInfo : heraTypes.heraGuiCreateInfo) : heraGui
	local class = setmetatable({}, heraGui);
	class.heraClassName = "heraGui";
	class.name = heraGuiCreateInfo.name;

	return class;
end

--[==[
	@lib Hera
	@class heraGui

	heraGenerateMainHandle is designed to create the main plugin GUI handle that is the root of the plugin's GUI representation in screen space.
]==]
function heraGui:heraGenerateMainHandle()
	local obj : heraGui = self;
    local mainHandleComponent = obj:heraGetMainHandleComponent();
    Roact.createElement(mainHandleComponent);
end

--[==[
	@lib Hera
	@class heraGui

	heraGetMainHandleComponent is designed to return the Roact component that sources the MainHandle root node for the Hera Transit Designer Plugin GUI
]==]
function heraGui:heraGetMainHandleComponent() : Roact.Component
	return function(props)
        return Roact.createElement("Frame", {
            Parent = props.Parent;
        });
    end
end

--[==[
	@lib Hera
	@class heraGui

	heraMakePluginRoot creates a DockWidgetPluginGui which this Hera Virtual API GUI rests within during its lifetime.
]==]
function heraGui:heraMakePluginRoot()
	local obj : heraGui = self;
    local thisWidgetGuiCreateInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left);
    local thisWidgetGui = plugin:CreateDockWidgetPluginGui(obj.name);

    obj.widget = thisWidgetGui;
end

return heraGui;