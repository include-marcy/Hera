-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU General Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);
local heraKeyframe = require(script.Parent.heraKeyframe);

-- Class Definition
local heraComputedKeyframeState = {};
heraComputedKeyframeState.__index = heraComputedKeyframeState;

-- Type Definition
export type heraComputedKeyframeState = typeof(setmetatable({} :: {
	heraClassName : "heraComputedKeyframeState";
    keyframeA : heraKeyframe.heraKeyframe;
    keyframeB : heraKeyframe.heraKeyframe;
    object : Instance;
    property : string;
}, {} :: typeof(heraComputedKeyframeState)))

-- Constant Declaration
local CONST_LERP = function(t, a, b)
	return a + (b - a) * t;
end

local CONST_QUAD_BEZIER = function(t, p0, p1, p2)
	local l1 = CONST_LERP(t, p0, p1);
	local l2 = CONST_LERP(t, p1, p2);
	local quad = CONST_LERP(t, l1, l2);
	return quad;
end

--[==[
	@lib Hera
	@class heraComputedKeyframeState

	The heraComputedKeyframeState class is a logical cascading representation of the
    interpolated computed state of some value for some object.
    It consists of two heraKeyframes and returns the state of the given property for the given object at the given time.

	@param heraComputedKeyframeStateCreateInfo;
	@return heraComputedKeyframeState;
]==]
function heraComputedKeyframeState.new(heraComputedKeyframeStateCreateInfo : heraTypes.heraComputedKeyframeStateCreateInfo) : heraComputedKeyframeState
	local class = setmetatable({}, heraComputedKeyframeState);
	class.heraClassName = "heraComputedKeyframeState";

    class.keyframeA = heraComputedKeyframeStateCreateInfo.keyframeA;
    class.keyframeB = heraComputedKeyframeStateCreateInfo.keyframeB;
    class.object = heraComputedKeyframeStateCreateInfo.object;
    class.property = heraComputedKeyframeStateCreateInfo.state;

	return class;
end

--[==[
	@lib Hera
	@class heraComputedKeyframeState

	heraComputeState is designed to return the property value interpolated for property S between keyframeA and keyframeB at time T

    @param time : number;
    @return interpolatedValue : heraInterpolationValidationType;
]==]
function heraComputedKeyframeState:heraComputeState(time : number) : heraTypes.heraInterpolationValidationType
	local obj : heraComputedKeyframeState = self;
    local keyframeA = obj.keyframeA;
    local keyframeB = obj.keyframeB;

    local keyframeAValue = keyframeA:heraGetKeyframeValue();
    local keyframeBValue = keyframeB:heraGetKeyframeValue();

    local handleType : heraTypes.heraHandleType = keyframeA:heraGetKeyframeHandleType();

    return obj:heraInterpolate(keyframeAValue, keyframeBValue, handleType, time);
end

--[==[
	@lib Hera
	@class heraComputedKeyframeState

	heraInterpolate is designed to return an interpolated value of a state between keyframe A and keyframe B.

    @param A : heraInterpolationValidationType;
    @param B : heraInterpolationValidationType;
    @param handleType : heraHandleType;
    @param time : number;
    @return interpolatedValue : heraInterpolationValidationType;
]==]
function heraComputedKeyframeState:heraInterpolate(A : heraTypes.heraInterpolationValidationType, B : heraTypes.heraInterpolationValidationType, handleType : heraTypes.heraHandleType, time : number) : heraTypes.heraInterpolationValidationType
    if handleType == "HERA_HANDLE_TYPE_LINEAR" then
        return CONST_LERP(time, A, B);
    elseif handleType == "HERA_HANDLE_TYPE_BEZIER" then
        return CONST_QUAD_BEZIER(time, 0.5, A, B);
    end
end

return heraComputedKeyframeState;