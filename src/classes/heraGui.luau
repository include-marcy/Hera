-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU GENERAL PUBLIC LICENSE v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Roblox Services
local ContentProvider = game:GetService("ContentProvider");

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);
local Roact = require(script.Parent.Parent.heraPackages.roact);

-- Constants Declaration
local PRELOAD_ASYNC_LIST_RAW = {
	Sound = {
		"rbxassetid://1";
		"rbxassetid://2";
	};
	Decal = {
		"rbxassetid://3";
		"rbxassetid://4";
	};
};

-- Class Definition
--[=[
	@class heraGui

	The heraGui class is the Hera Virtual API representation of the Roact Hera Transit Designer Plugin GUI (Graphical User Interface).
]=]
local heraGui = {};
heraGui.__index = heraGui;

-- Type Definition
export type heraGui = typeof(setmetatable({} :: {
	heraClassName : "heraGui";
	name : string;
	widget : DockWidgetPluginGui?;
}, {} :: typeof(heraGui)))

--[=[
	@within heraGui

	The heraGui class is the Hera Virtual API representation of the Roact Hera Transit Designer Plugin GUI (Graphical User Interface).

	@param heraGuiCreateInfo heraTypes.heraGuiCreateInfo
	@return gui heraGui
]=]
function heraGui.new(heraGuiCreateInfo : heraTypes.heraGuiCreateInfo) : heraGui
	local class = setmetatable({}, heraGui);
	class.heraClassName = "heraGui";
	class.name = heraGuiCreateInfo.name;

	return class;
end

--[=[
	@within heraGui

	heraMakePluginRoot creates a DockWidgetPluginGui which this Hera Virtual API GUI rests within during its lifetime.
]=]
function heraGui:heraMakePluginRoot()
	local obj : heraGui = self;
	local thisWidgetGuiCreateInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left);
	local thisWidgetGui = plugin:CreateDockWidgetPluginGui(obj.name, thisWidgetGuiCreateInfo);

	obj.widget = thisWidgetGui;

	local loadingHandle = obj:heraGenerateLoadHandle();

	local mainHandle = obj:heraGenerateMainHandle();
	mainHandle.Parent = obj.widget;

	obj:heraLoadPluginAssetsAsync();
end

--[=[
	@within heraGui

	heraGenerateMainHandle is designed to create the main plugin GUI handle that is the root of the plugin's GUI representation in screen space.
]=]
function heraGui:heraGenerateMainHandle() : Frame
	local obj : heraGui = self;
	local mainHandleComponent = obj:heraGetMainHandleComponent();
	return Roact.createElement(mainHandleComponent);
end

--[=[
	@within heraGui

	heraGetMainHandleComponent is designed to return the Roact component that sources the MainHandle
	root node for the Hera Transit Designer Plugin GUI

	@return mainHandle Roact.Component
]=]
function heraGui:heraGetMainHandleComponent() : Roact.Component
	return function(props)
		return Roact.createElement("Frame", {
			Parent = props.Parent;
		});
	end
end

--[=[
	@within heraGui

	heraLoadPluginAssetsAsync is designed to load all necessary graphical and audio components of the Hera GUI (Graphical User Interface)
]=]
function heraGui:heraLoadPluginAssetsAsync()
	local obj : heraGui = self;

	local heraAssetBin = {};
	for assetType, assetList in PRELOAD_ASYNC_LIST_RAW do
		for heraAssetName, content in assetList do
			local inst = Instance.new(assetType);
			if assetType == "Sound" then
				inst.SoundId = content
			end
			if assetType == "Decal" then
				inst.Decal = content;
			end
			table.insert(heraAssetBin, inst);
		end
	end

	ContentProvider:PreloadAsync(heraAssetBin, function(assetId, assetFetchStatus)
		print("PreloadAsync() resolved asset ID:", assetId)
		print("PreloadAsync() final AssetFetchStatus:", assetFetchStatus)
	end);

	for i, v in heraAssetBin do
		v:Destroy();
		v.Parent = nil;
		v = nil;
	end

	table.clear(heraAssetBin);
	heraAssetBin = nil;
end

--[=[
	@within heraGui

	heraGenerateLoadHandle is designed to load a developer's loading menu for a plugin widget before displaying the main handle.
]=]
function heraGui:heraGenerateLoadHandle() : Frame
	local obj : heraGui = self;

	local loadHandleComponent = obj:heraGetLoadHandleComponent();
	return Roact.createElement(loadHandleComponent);
end

--[=[
	@within heraGui

	heraGetLoadHandleComponent is designed to return the Roact component that serves as a loading screen for the plugin during startup.
]=]
function heraGui:heraGetLoadHandleComponent() : Roact.Component
	return function(props)
		return Roact.createElement("Frame", {
			Parent = props.Parent;
		});
	end
end

return heraGui;