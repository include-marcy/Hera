-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
--[=[
	@class heraCurveHandle

	The heraCurveHandle class is a minimalist object representing a point that describes computed state interpolation goals for arbitrary objects.
]=]
local heraCurveHandle = {};
heraCurveHandle.__index = heraCurveHandle;

-- Type Definition
export type heraCurveHandle = typeof(setmetatable({} :: {
	heraClassName : "heraCurveHandle";
}, {} :: typeof(heraCurveHandle)))

--[=[
	@within heraCurveHandle

	The heraCurveHandle class is a minimalist object representing a point that describes computed state interpolation goals for arbitrary objects.

	@param heraCurveHandleCreateInfo heraTypes.heraCurveHandleCreateInfo
	@return curveHandle heraCurveHandle
]=]
function heraCurveHandle.new(heraCurveHandleCreateInfo : heraTypes.heraCurveHandleCreateInfo) : heraCurveHandle
	local class = setmetatable({}, heraCurveHandle);
	class.heraClassName = "heraCurveHandle";
	class.name = heraCurveHandleCreateInfo.name;

	return class;
end

return heraCurveHandle;