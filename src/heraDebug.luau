--- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.lib.Types);

-- Class Definition
local heraDebug = {};
heraDebug.__index = heraDebug;

-- Type Definition
export type heraDebug = typeof(setmetatable({} :: {
	heraClassName : "heraDebug";
}, {} :: typeof(heraDebug)))

--[==[
	@class heraDebug

	The heraDebug class is 

	@param heraDebugCreateInfo;
	@return heraDebug;
]==]
function heraDebug.new(heraDebugCreateInfo : heraTypes.heraDebugCreateInfo) : heraDebug
	local class = setmetatable({}, heraDebug);
	class.heraClassName = "heraDebug";
	class.name = heraDebugCreateInfo.name;

	return class;
end

--[==[
	@class heraDebug

]==]
function heraDebug:heraFoo()

end

return heraDebug;