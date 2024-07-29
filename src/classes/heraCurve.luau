-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
local heraCurve = {};
heraCurve.__index = heraCurve;

-- Type Definition
export type heraCurve = typeof(setmetatable({} :: {
	heraClassName : "heraCurve";
}, {} :: typeof(heraCurve)))

--[==[
	@class heraCurve

	The heraCurve class is a logical container for a series of CurveHandle objects, representing the state of some object which mutates through the dimension of time.

	@param heraCurveCreateInfo;
	@return heraCurve;
]==]
function heraCurve.new(heraCurveCreateInfo : heraTypes.heraCurveCreateInfo) : heraCurve
	local class = setmetatable({}, heraCurve);
	class.heraClassName = "heraCurve";
	class.name = heraCurveCreateInfo.name;

	return class;
end

--[==[
	@class heraCurve

]==]
function heraCurve:heraFoo()

end

return heraCurve;