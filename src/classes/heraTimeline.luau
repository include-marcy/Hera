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
}, {} :: typeof(heraTimeline)))

--[==[
	@class heraTimeline

	The heraTimeline class is designed to represent the dimension of time in the Hera Virtual API.

	@param heraTimelineCreateInfo;
	@return heraTimeline;
]==]
function heraTimeline.new(heraTimelineCreateInfo : heraTypes.heraTimelineCreateInfo) : heraTimeline
	local class = setmetatable({}, heraTimeline);
	class.heraClassName = "heraTimeline";
	class.name = heraTimelineCreateInfo.name;

	return class;
end

--[==[
	@class heraTimeline

]==]
function heraTimeline:heraFoo()

end

return heraTimeline;