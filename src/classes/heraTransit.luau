-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);
local heraSequence = require(script.Parent.heraSequence);

-- Class Definition
local heraTransit = {};
heraTransit.__index = heraTransit;

-- Type Definition
export type heraTransit = typeof(setmetatable({} :: {
	heraClassName : "heraTransit";
	name : string;
	_hsq : {[Instance] : {heraSequence.heraSequence}};
}, {} :: typeof(heraTransit)))

--[=[
	@class heraTransit

	The heraTransit class is designed to be a data type object which can be used to transfer
	information across API boundaries according to the rules and conventions of the Hera
	Virtual API.

	@param heraTransitCreateInfo;
	@return heraTransit;
]=]
function heraTransit.new(heraTransitCreateInfo : heraTypes.heraTransitCreateInfo) : heraTransit
	local class = setmetatable({}, heraTransit);
	class.heraClassName = "heraTransit";
	class.name = heraTransitCreateInfo.name;
	class._hsq = {};

	return class;
end

--[=[
	@lib Hera
	@class heraTransit

	Returns whether the given Instance is associated with a sequence cache
]=]
function heraTransit:heraIsObjectSequenced(object : Instance) : boolean
	local obj : heraTransit = self;
	local heraSequences = obj:heraGetHeraSequenceCache();

	return table.find(heraSequences, object) ~= nil;
end

--[=[
	@lib Hera
	@class heraTransit

	heraMakeObjectSequenced is designed to create a cache of sequences for the given instance.
]=]
function heraTransit:heraMakeObjectSequenced(object : Instance) : {heraSequence.heraSequence}
	local obj : heraTransit = self;
	local heraSequences = obj:heraGetHeraSequenceCache();

	heraSequences[object] = {};

	return heraSequences[object];
end

--[=[
	@lib Hera
	@class heraTransit

	heraGetHeraSequenceCache is designed to return a cache of instance->sequences
]=]
function heraTransit:heraGetHeraSequenceCache() : {[Instance] : {heraSequence.heraSequence}}
	local obj : heraTransit = self;

	return obj._hsq;
end

--[=[
	@lib Hera
	@class heraTransit

	heraGetObjectSequences returns the cache of the given objects sequences
]=]
function heraTransit:heraGetObjectSequences()
	local obj : heraTransit = self;

end

return heraTransit;