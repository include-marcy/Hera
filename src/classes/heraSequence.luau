-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
local heraSequence = {};
heraSequence.__index = heraSequence;

-- Type Definition
export type heraSequence = typeof(setmetatable({} :: {
	heraClassName : "heraSequence";
}, {} :: typeof(heraSequence)))

--[==[
	@class heraSequence

	The heraSequence class is designed to be a supercession of the physical state of some
    Roblox Instance. It contains mutations of state through the dimensions of time, and can
    generate or contain heraKeyframes describing this mutation.

	@param heraSequenceCreateInfo;
	@return heraSequence;
]==]
function heraSequence.new(heraSequenceCreateInfo : heraTypes.heraSequenceCreateInfo) : heraSequence
	local class = setmetatable({}, heraSequence);
	class.heraClassName = "heraSequence";
	class.name = heraSequenceCreateInfo.name;

	return class;
end

--[==[
	@class heraSequence

]==]
function heraSequence:heraFoo()

end

return heraSequence;