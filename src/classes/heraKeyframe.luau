-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
local heraKeyframe = {};
heraKeyframe.__index = heraKeyframe;

-- Type Definition
export type heraKeyframe = typeof(setmetatable({} :: {
	heraClassName : "heraKeyframe";
}, {} :: typeof(heraKeyframe)))

--[==[
	@class heraKeyframe

	The heraKeyframe class is designed to act as a virtual state object at some time T for object N contained within a heraSequence

	@param heraKeyframeCreateInfo;
	@return heraKeyframe;
]==]
function heraKeyframe.new(heraKeyframeCreateInfo : heraTypes.heraKeyframeCreateInfo) : heraKeyframe
	local class = setmetatable({}, heraKeyframe);
	class.heraClassName = "heraKeyframe";
	class.name = heraKeyframeCreateInfo.name;

	return class;
end

--[==[
	@class heraKeyframe

]==]
function heraKeyframe:heraFoo()

end

return heraKeyframe;