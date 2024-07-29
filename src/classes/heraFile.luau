-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
local heraFile = {};
heraFile.__index = heraFile;

-- Type Definition
export type heraFile = typeof(setmetatable({} :: {
	heraClassName : "heraFile";
}, {} :: typeof(heraFile)))

--[==[
	@class heraFile

	The heraFile class is designed to create a bridge between the .hera file type and the Hera Virtual API

	@param heraFileCreateInfo;
	@return heraFile;
]==]
function heraFile.new(heraFileCreateInfo : heraTypes.heraFileCreateInfo) : heraFile
	local class = setmetatable({}, heraFile);
	class.heraClassName = "heraFile";
	class.name = heraFileCreateInfo.name;

	return class;
end

--[==[
	@class heraFile

]==]
function heraFile:heraFoo()

end

return heraFile;