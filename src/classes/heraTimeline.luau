-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
local heraTimeline = {};
heraTimeline.__index = heraTimeline;

-- Type Definition
export type heraTimeline = typeof(setmetatable({} :: {
	heraClassName : "heraTimeline";
	name : string;
	time : number;
}, {} :: typeof(heraTimeline)))

--[=[
	@class heraTimeline

	The heraTimeline class is designed to represent the dimension of time in the Hera Virtual API.

	@param heraTimelineCreateInfo;
	@return heraTimeline;
]=]
function heraTimeline.new(heraTimelineCreateInfo : heraTypes.heraTimelineCreateInfo) : heraTimeline
	local class = setmetatable({}, heraTimeline);
	class.heraClassName = "heraTimeline";
	class.name = heraTimelineCreateInfo.name;
	class.time = os.clock();

	return class;
end

--[=[
	@lib Hera
	@class heraTimeline

	heraUpdate will update the current time of this heraTimeline
]=]
function heraTimeline:heraUpdate()
	local obj : heraTimeline = self;

	obj:heraSetTime(os.clock());
end

--[=[
	@lib Hera
	@class heraTimeline

	heraGetTime is designed to return the current time of the heraTimeline
]=]
function heraTimeline:heraGetTime() : number
	local obj : heraTimeline = self;

	return obj.time;
end

--[=[
	@lib Hera
	@class heraTimeline

	heraSetTime is designed to set the current time of the heraTimeline
]=]
function heraTimeline:heraSetTime(newTime : number)
	local obj : heraTimeline = self;

	obj.time = newTime;
end

return heraTimeline;