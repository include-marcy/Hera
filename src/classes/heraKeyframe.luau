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
	name : string;
	value : any;
	handleType : heraTypes.heraHandleType;
	time : number;
}, {} :: typeof(heraKeyframe)))

--[=[
	@class heraKeyframe

	The heraKeyframe class is designed to act as a virtual state object at some time T for object N contained
	within a heraSequence

	@param heraKeyframeCreateInfo;
	@return heraKeyframe;
]=]
function heraKeyframe.new(heraKeyframeCreateInfo : heraTypes.heraKeyframeCreateInfo) : heraKeyframe
	local class = setmetatable({}, heraKeyframe);
	class.heraClassName = "heraKeyframe";

	class.name = heraKeyframeCreateInfo.name;
	class.value = heraKeyframeCreateInfo.value;
	class.handleType = heraKeyframeCreateInfo.handleType;
	class.time = heraKeyframeCreateInfo.time;

	return class;
end

--[=[
	@lib Hera
	@class heraKeyframe

	heraGetKeyframeValue returns the value of this keyframe.

	@return value : heraInterpolationValidationType
]=]
function heraKeyframe:heraGetKeyframeValue() : heraTypes.heraInterpolationValidationType?
	local obj : heraKeyframe = self;

	return obj.value;
end

--[=[
	@lib Hera
	@class heraKeyframe

	heraGetKeyframeHandleType is designed to return the handle type of this keyframe.

	@return handleType : heraHandleType;
]=]
function heraKeyframe:heraGetKeyframeHandleType() : heraTypes.heraHandleType
	local obj : heraKeyframe = self;

	return obj.handleType;
end

--[=[
	@lib Hera
	@class heraKeyframe

	heraGetKeyframeTime returns the time this keyframe is affecting

	@return time : number;
]=]
function heraKeyframe:heraGetKeyframeTime() : number
	local obj : heraKeyframe = self;

	return obj.time;
end

return heraKeyframe;