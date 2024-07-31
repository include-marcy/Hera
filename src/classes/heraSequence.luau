-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);
local heraKeyframe = require(script.Parent.heraKeyframe);
local heraComputedKeyframeState = require(script.Parent.heraComputedKeyframeState);

-- Class Definition
local heraSequence = {};
heraSequence.__index = heraSequence;

-- Type Definition
export type heraSequence = typeof(setmetatable({} :: {
	heraClassName : "heraSequence";
	object : Instance;
	keyframes : {heraKeyframe.heraKeyframe};
	dirtyProperties : {string};
	computationStateProvider : {heraComputedKeyframeState.heraComputedKeyframeState};
}, {} :: typeof(heraSequence)))

--[=[
	@class heraSequence

	The heraSequence class is designed to be a supercession of the physical state of some
    Roblox Instance. It contains mutations of state through the dimensions of time, and can
    generate or contain heraKeyframes describing this mutation.

	@param heraSequenceCreateInfo;
	@return heraSequence;
]=]
function heraSequence.new(heraSequenceCreateInfo : heraTypes.heraSequenceCreateInfo) : heraSequence
	local class = setmetatable({}, heraSequence);
	class.heraClassName = "heraSequence";

	class.name = heraSequenceCreateInfo.name;
	class.object = heraSequenceCreateInfo.object;
	class.keyframes = {};
	class.dirtyProperties = {};
	class.computationStateProvider = {};

	return class;
end

--[=[
	@lib Hera
	@class heraSequence

	heraBuildKeyframes is designed to generate the required keyframes needed to accurately replay this sequence according to it's heraCurveBin description.
]=]
function heraSequence:heraBuildKeyframes()

end

--[=[
	@lib Hera
	@class heraSequence

	heraGetObject returns the object associated with this heraSequence.
]=]
function heraSequence:heraGetObject()
	local obj : heraSequence = self;

	return obj.object;
end

--[=[
	@lib Hera
	@class heraSequence

	heraSetObject sets the object this heraSequence is associated with.
]=]
function heraSequence:heraSetObject(object : Instance)
	local obj : heraSequence = self;

	obj.object = object;
end

--[=[
	@lib Hera
	@class heraSequence

	heraUpdate is designed to update this heraSequence to modify the computed
	state of the object associated with this heraSequence to be associated with the keyframes stored with updated time

	@param time : number
]=]
function heraSequence:heraUpdate(time : number)
	local obj : heraSequence = self;
	local dirtyProperties = obj.dirtyProperties;

	for _, dirtyProperty in dirtyProperties do
		obj:heraUpdateProperty(dirtyProperty, time);
	end
end

--[=[
	@lib Hera
	@class heraSequence

	heraGetKeyframesForTime returns a list of heraKeyframes stored in this heraSequence that have or are related to time t.

	@param property : string;
	@param time : number;
]=]
function heraSequence:heraUpdateProperty(property : string, time : number)
	local obj : heraSequence = self;

	-- Get the two keyframes which are bounding property at time
	local keyframeA, keyframeB = obj:heraGetBoundingKeyframesForTime(property, time);

	if not keyframeA or not keyframeB then
		return;
	end

	-- Get the computation object which lets us calculate the interpolated value of property at time t using the bounding keyframes
	local computedKeyframeState = obj:heraGetComputedKeyframeStateCached(property, keyframeA, keyframeB);
	local state = computedKeyframeState:heraComputeState(time);

	-- Update the object with the new interpolated value
	local object = obj:heraGetObject();

	object[property] = state;
end

--[=[
	@lib Hera
	@class heraSequence

	heraGetBoundingKeyframesForTime is designed to return the two keyframes that control a property for time T,
	when the keyframe needs interpolation

	@param property : string;
	@param time : number;
	@return keyframeA : heraKeyframe, keyframeB : heraKeyframe
]=]
function heraSequence:heraGetBoundingKeyframesForTime(property : string, time : number) : (heraKeyframe.heraKeyframe, heraKeyframe.heraKeyframe)
	local obj : heraSequence = self;
	local affectorKeyframes = obj:heraGetAffectorKeyframes(property);
	local keyframeA, keyframeB;

	local lowerBoundingKeyframeTime = 0;
	local upperBoundingKeyframeTime = math.huge;

	for _, propertyKeyframe : heraKeyframe.heraKeyframe in affectorKeyframes do
		local keyframeTime = propertyKeyframe:heraGetKeyframeTime();

		-- Any keyframe which has the highest time that is lower than the calculation time is the lower bounding keyframe
		if keyframeTime > lowerBoundingKeyframeTime and keyframeTime < time then
			lowerBoundingKeyframeTime = keyframeTime;
			keyframeA = propertyKeyframe;
		end

		-- Vice versa for upper bound
		if keyframeTime < upperBoundingKeyframeTime and keyframeTime > time then
			upperBoundingKeyframeTime = keyframeTime;
			keyframeB = propertyKeyframe;
		end
	end

	return keyframeA, keyframeB;
end

--[=[
	@lib Hera
	@class heraSequence

	heraGetComputedKeyframeStateCached is designed to return the cached object which relates to
	keyframeA and keyframe B for property s at time T
]=]
function heraSequence:heraGetComputedKeyframeStateCached(property : string, keyframeA : heraKeyframe.heraKeyframe, keyframeB : heraKeyframe.heraKeyframe) : heraComputedKeyframeState.heraComputedKeyframeState
	local obj : heraSequence = self;

	-- Retrieve a list of keyframes that are bound to keyframe A
	local computedKeyframeStateAList = obj.computationStateProvider[keyframeA];
	if not computedKeyframeStateAList then
		computedKeyframeStateAList = {};
		obj.computationStateProvider[keyframeA] = computedKeyframeStateAList;
	end

	-- Check if the computed keyframe state exists in list A for keyframe B
	local computedKeyframeState = computedKeyframeStateAList[keyframeB];
	if not computedKeyframeState then

		-- Create the keyframe state computer
		computedKeyframeState = heraComputedKeyframeState.new({
			object = obj:heraGetObject();
			property = property;
			keyframeA = keyframeA;
			keyframeB = keyframeB;
		});

		computedKeyframeStateAList[keyframeB] = computedKeyframeState;
	end

	return computedKeyframeState;
end

--[=[
	@lib Hera
	@class heraSequence

	heraGetKeyframes returns a list of all keyframes in this sequence

	@return keyframes : {heraKeyframe};
]=]
function heraSequence:heraGetKeyframes()
	local obj : heraSequence = self;

	return obj.keyframes;
end

--[=[
	@lib Hera
	@class heraSequence

	heraAddKeyframe adds a new keyframe for the lowest level representation of
	the property value across this sequences dimension of time.

	@param heraKeyframeCreateInfo;
	@return heraKeyframe;
]=]
function heraSequence:heraAddKeyframe(heraKeyframeCreateInfo : heraTypes.heraKeyframeCreateInfo) : heraKeyframe.heraKeyframe
	local obj : heraSequence = self;
	local keyframes = obj:heraGetKeyframes();
	local keyframe = heraKeyframe.new(heraKeyframeCreateInfo);

	table.insert(keyframes, keyframe);

	return keyframe;
end

--[=[
	@lib Hera
	@class heraSequence

	heraGetAffectorKeyframes is designed to return a list of keyframes that affect property S

	@param property : string;
	@return affectorKeyframes : {heraKeyframe};
]=]
function heraSequence:heraGetAffectorKeyframes(property : string) : {[number] : heraKeyframe.heraKeyframe}
	local obj : heraSequence = self;
	local keyframes = obj:heraGetKeyframes();
	local affectorKeyframes = {};

	for _, keyframe in keyframes do
		if keyframe.name == property then
			table.insert(affectorKeyframes, keyframe);
		end
	end

	return affectorKeyframes;
end

return heraSequence;