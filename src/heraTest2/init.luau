-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.lib.Types);

-- Class Definition
local heraTest2 = {};
heraTest2.__index = heraTest2;

-- Type Definition
export type heraTest2 = typeof(setmetatable({} :: {
	heraClassName : "heraTest2";
}, {} :: typeof(heraTest2)))

--[==[
	@class heraTest2

	The heraTest2 class is 

	@param heraTest2CreateInfo;
	@return heraTest2;
]==]
function heraTest2.new(heraTest2CreateInfo : heraTypes.heraTest2CreateInfo) : heraTest2
	local class = setmetatable({}, heraTest2);
	class.heraClassName = "heraTest2";
	class.name = heraTest2CreateInfo.name;

	return class;
end

--[==[
	@class heraTest2

]==]
function heraTest2:heraFoo()

end

return heraTest2;