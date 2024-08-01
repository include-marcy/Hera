-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
--[=[
	@class heraTimeline

	The heraTimeline class is designed to represent the dimension of time in the Hera Virtual API.
]=]
local heraTimeline = {};
heraTimeline.__index = heraTimeline;

-- Type Definition
export type heraTimeline = typeof(setmetatable({} :: {
	heraClassName : "heraTimeline";
	name : string;
	time : number;
}, {} :: typeof(heraTimeline)))

--[=[
	@within heraTimeline

	The heraTimeline class is designed to represent the dimension of time in the Hera Virtual API.

	@param heraTimelineCreateInfo heraTypes.heraTimelineCreateInfo
	@return timeline
]=]
function heraTimeline.new(heraTimelineCreateInfo : heraTypes.heraTimelineCreateInfo) : heraTimeline
	local class = setmetatable({}, heraTimeline);
	class.heraClassName = "heraTimeline";
	class.name = heraTimelineCreateInfo.name;
	class.time = os.clock();

	return class;
end

--[=[
	@within heraTimeline

	heraUpdate will update the current time of this heraTimeline
]=]
function heraTimeline:heraUpdate()
	local obj : heraTimeline = self;

	obj:heraSetTime(os.clock());
end

--[=[
	@within heraTimeline

	heraGetTime is designed to return the current time of the heraTimeline

	@return time number
]=]
function heraTimeline:heraGetTime() : number
	local obj : heraTimeline = self;

	return obj.time;
end

--[=[
	@within heraTimeline

	heraSetTime is designed to set the current time of the heraTimeline

	@param newTime number
]=]
function heraTimeline:heraSetTime(newTime : number)
	local obj : heraTimeline = self;

	obj.time = newTime;
end

return heraTimeline;