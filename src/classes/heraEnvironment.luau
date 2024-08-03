-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);
local heraConfig = require(script.Parent.Parent.lib.heraConfig);
local heraSequence = require(script.Parent.heraSequence);
local heraTimeline = require(script.Parent.heraTimeline);
local heraGui = require(script.Parent.heraGui);
local heraCurveBin = require(script.Parent.heraCurveBin);
local heraCurve = require(script.Parent.heraCurve);

-- Class Definition
--[=[
	@class heraEnvironment

	The heraEnvironment class is a logical container which acts as a virtual environment from which this application is rooted within.
]=]
local heraEnvironment = {};
heraEnvironment.__index = heraEnvironment;

-- Type Definition
export type heraEnvironment = typeof(setmetatable({} :: {
	heraClassName : "heraEnvironment";
	name : string;
	heraSequences : {heraSequence.heraSequence};
	heraTimeline : heraTimeline.heraTimeline;
	heraGui : heraGui.heraGui;
	heraCurveBin : heraCurveBin.heraCurveBin;
}, {} :: typeof(heraEnvironment)))

--[=[
	@within heraEnvironment

	The heraEnvironment class is a logical container which acts as a virtual environment from which this application is rooted within.

	@param heraEnvironmentCreateInfo heraTypes.heraEnvironmentCreateInfo
	@return environment heraEnvironment
]=]
function heraEnvironment.new(heraEnvironmentCreateInfo : heraTypes.heraEnvironmentCreateInfo) : heraEnvironment
	local class = setmetatable({}, heraEnvironment);
	class.heraClassName = "heraEnvironment";
	class.name = heraEnvironmentCreateInfo.name;

	return class;
end

--[=[
	@within heraEnvironment

	heraInit is designed to initialize the heraEnvironment and Hera Virtual API.
]=]
function heraEnvironment:heraInit()
	local obj : heraEnvironment = self;

	do -- Create the main gui
		local gui = heraGui.new();
		gui:heraMakePluginRoot();

		obj.heraGui = gui;
	end

	do -- Create the main timeline
		local timeline = heraTimeline.new();

		obj.heraTimeline = timeline;
	end

	do -- Create the main sequence bin
		obj.heraSequences = {};
	end

	do -- Create the curve bin
		local curveBin = heraCurveBin.new();

		obj.heraCurveBin = curveBin;
	end
end

return heraEnvironment;