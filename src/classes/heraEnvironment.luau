-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
--[=[
	@class heraEnvironment

	The heraEnvironment class is a logical container which acts as a virtual environment from which this application is rooted within.
]=]
local heraEnvironment = {};
heraEnvironment.__index = heraEnvironment;

-- Type Definition
export type heraEnvironment = typeof(setmetatable({} :: {
	heraClassName : "heraEnvironment";
}, {} :: typeof(heraEnvironment)))

--[=[
	@within heraEnvironment

	The heraEnvironment class is a logical container which acts as a virtual environment from which this application is rooted within.

	@param heraEnvironmentCreateInfo heraTypes.heraEnvironmentCreateInfo
	@return environment heraEnvironment
]=]
function heraEnvironment.new(heraEnvironmentCreateInfo : heraTypes.heraEnvironmentCreateInfo) : heraEnvironment
	local class = setmetatable({}, heraEnvironment);
	class.heraClassName = "heraEnvironment";
	class.name = heraEnvironmentCreateInfo.name;

	return class;
end

return heraEnvironment;