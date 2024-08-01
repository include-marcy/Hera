-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
--[=[
	@class heraPort

	The heraPort class is designed to act as a port between the Roblox environment and the Hera Virtual API.
]=]
local heraPort = {};
heraPort.__index = heraPort;

-- Type Definition
export type heraPort = typeof(setmetatable({} :: {
	heraClassName : "heraPort";
}, {} :: typeof(heraPort)))

--[=[
	@within heraPort

	The heraPort class is designed to act as a port between the Roblox environment and the Hera Virtual API.

	@param heraPortCreateInfo heraTypes.heraPortCreateInfo
	@return heraPort
]=]
function heraPort.new(heraPortCreateInfo : heraTypes.heraPortCreateInfo) : heraPort
	local class = setmetatable({}, heraPort);
	class.heraClassName = "heraPort";
	class.name = heraPortCreateInfo.name;

	return class;
end

return heraPort;