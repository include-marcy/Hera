-- This file is part of the Athena library and is licensed under GNU GENERAL PUBLIC LICENSE v3.0; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athSignal = require(athena.classes.athSignal);
local athTrove = require(athena.packages.trove);

-- Class Declaration
local athExtension = {};
athExtension.__index = athExtension;

export type athExtension = typeof(setmetatable({} :: {
	athClassName : "athExtension";
	athExtensionName : string;
	athExtensionIcon : string;
	athExtensionLoaded : athSignal.athSignal;
	athExtensionClosed : athSignal.athSignal;
	athExtensionDock : DockWidgetPluginGui?;
	athExtensionGui : Frame;
	_loaded : boolean?;
	_closed : boolean?;
	trove : athTrove.athTrove;
	_boundCallbacks : {
		[number] : {
			callbackType : "ATH_EXT_CALLBACK_TYPE_LOADED" | ";ATH_EXT_CALLBACK_TYPE_CLOSED";
			callback : () -> ();
		};
	};
}, {} :: typeof(athExtension)));

--[=[
	@within athExtension

	Creates a new athExtension. athExtensions are a way to build portable, scalable Plugins for Roblox Studio.
	They are intended to simplify and abstract the process of building the internal workings of a plugin backend.
	They are also meant to be used to add new features to existing plugins, using the structure of an athExtension.

	@param athExtensionCreateInfo;
	@return athExtension;
]=]
function athExtension.new(athExtensionCreateInfo : athTypes.athExtensionCreateInfo) : athExtension
	local extension = setmetatable({
		athClassName = "athExtension";
		athExtensionLoaded = athSignal.new();
		athExtensionClosed = athSignal.new();
	}, athExtension);

	extension.athExtensionName = athExtensionCreateInfo.name;
	extension.athExtensionIcon = athExtensionCreateInfo.icon;
	extension.athExtensionDescription = athExtensionCreateInfo.description;
	extension.athExtensionGui = athExtensionCreateInfo.gui;

	extension._boundCallbacks = {};
	extension.trove = athTrove.new();

	extension.trove:Add(extension.athExtensionLoaded:Connect(function()
		if extension._loaded then
			return;
		end

		extension._loaded = true;

		for _, cb in extension._boundCallbacks do
			if cb.callbackType == "ATH_EXT_CALLBACK_TYPE_LOADED" then
				task.spawn(cb.callback);
			end
		end
	end));

	extension.trove:Add(extension.athExtensionLoaded:Connect(function()
		if extension._closed then
			return;
		end

		extension._closed = true;

		for _, cb in extension._boundCallbacks do
			if cb.callbackType == "ATH_EXT_CALLBACK_TYPE_CLOSED" then
				task.spawn(cb.callback);
			end
		end
	end));

	return extension;
end

--[=[
	@within athExtension

	Loads the athExtension, with the following actions being loaded:
	- Populates the toolbar with this extension's buttons.
	- Loads the code of this athExtension's main function.
	- Fires the loaded event
	- Allows it to be closed
]=]
function athExtension:athLoadExtension()
	local extension : athExtension = self;
	if extension._loaded then
		return;
	end

	if extension.athExtensionGui then
		extension:athMakeWindow();
	end

	extension.athExtensionToolbar = plugin:CreateToolbar(extension.athExtensionName);
	extension.athExtensionLoadButton = extension.athExtensionToolbar:CreateButton(extension.athExtensionName,
	extension.athExtensionDescription, extension.athExtensionIcon);

	extension.athExtensionLoaded:Fire();
end


--[=[
	@within athExtension

	Creates a new DockWidget for this plugin using the athExtensionGui as a base.

	@param athExtensionWindowCreateInfo;
	@return Frame;
]=]
function athExtension:athMakeWindow(_ : athTypes.athExtensionWindowCreateInfo) : Frame
	local extension : athExtension = self;
	local dockWidgetPluginGuiInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, true);
	extension.athExtensionDock = plugin:CreateDockWidgetPluginGui(extension.athExtensionName, dockWidgetPluginGuiInfo);

	local gui = extension.athExtensionGui:Clone();
	extension.athExtensionGui = gui;
	gui.Parent = extension.athExtensionDock;

	return gui;
end

function athExtension:athPlaySound(soundProperties) : Sound
	local extension : athExtension = self;
	local dock = extension.athExtensionDock;

	local sound = Instance.new("Sound");
	pcall(function()
		for pName, pValue in soundProperties do
			sound[pName] = pValue;
		end
	end);

	sound.Parent = dock;
	local c; c = sound.Ended:Connect(function()
		c:Disconnect();
		sound:Destroy();
		sound = nil;
	end);

	return sound;
end

function athExtension:athBindToExtensionLoaded(callback : () -> ())
	local extension : athExtension = self;

	if extension._loaded then
		return callback();
	end

	table.insert(extension._boundCallbacks, {
		callbackType = "ATH_EXT_CALLBACK_TYPE_LOADED";
		callback = callback;
	});
end

function athExtension:athBindToExtensionClosed(callback : () -> ())
	local extension : athExtension = self;

	if extension._closed then
		return callback();
	end

	table.insert(extension._boundCallbacks, {
		callbackType = "ATH_EXT_CALLBACK_TYPE_CLOSED";
		callback = callback;
	});
end

function athExtension:athCloseExtension()
	local extension : athExtension = self;
	if extension._closed then
		return;
	end

	extension.athExtensionClosed:Fire();

	extension.trove:Destroy();
	extension.trove = nil;
	table.clear(extension);
	setmetatable(extension, nil);
	extension = nil;
end

return athExtension;