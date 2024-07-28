--- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.lib.Types);

-- Class Definition
local heraTry = {};
heraTry.__index = heraTry;

-- Type Definition
export type heraTry = typeof(setmetatable({} :: {
	heraClassName : "heraTry";
}, {} :: typeof(heraTry)))

--[==[
	@class heraTry

	The heraTry class is 

	@param heraTryCreateInfo;
	@return heraTry;
]==]
function heraTry.new(heraTryCreateInfo : heraTypes.heraTryCreateInfo) : heraTry
	local class = setmetatable({}, heraTry);
	class.heraClassName = "heraTry";
	class.name = heraTryCreateInfo.name;

	return class;
end

--[==[
	@class heraTry

]==]
function heraTry:heraFoo()

end

return heraTry;