-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
local heraCurveBin = {};
heraCurveBin.__index = heraCurveBin;

-- Type Definition
export type heraCurveBin = typeof(setmetatable({} :: {
	heraClassName : "heraCurveBin";
}, {} :: typeof(heraCurveBin)))

--[==[
	@class heraCurveBin

	The heraCurveBin class is a holder object which can store and mass operate on heraCurve objects.

	@param heraCurveBinCreateInfo;
	@return heraCurveBin;
]==]
function heraCurveBin.new(heraCurveBinCreateInfo : heraTypes.heraCurveBinCreateInfo) : heraCurveBin
	local class = setmetatable({}, heraCurveBin);
	class.heraClassName = "heraCurveBin";
	class.name = heraCurveBinCreateInfo.name;

	return class;
end

--[==[
	@class heraCurveBin

]==]
function heraCurveBin:heraFoo()

end

return heraCurveBin;