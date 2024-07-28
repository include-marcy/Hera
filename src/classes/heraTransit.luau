-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.Types);

-- Class Definition
local heraTransit = {};
heraTransit.__index = heraTransit;

-- Type Definition
export type heraTransit = typeof(setmetatable({} :: {
	heraClassName : "heraTransit";
}, {} :: typeof(heraTransit)))

--[==[
	@class heraTransit

	The heraTransit class is an epic class

	@param heraTransitCreateInfo;
	@return heraTransit;
]==]
function heraTransit.new(heraTransitCreateInfo : heraTypes.heraTransitCreateInfo) : heraTransit
	local class = setmetatable({}, heraTransit);
	class.heraClassName = "heraTransit";
	class.name = heraTransitCreateInfo.name;

	return class;
end

--[==[
	@class heraTransit

]==]
function heraTransit:heraFoo()

end

return heraTransit;