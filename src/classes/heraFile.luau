-- This file is a part of the Hera library. Hera is licensed under the terms of the GNU Public License v3.0. For more information, see LICENSE.md

--!strict
--!native
--!optimize 2

-- Library Dependencies
local heraTypes = require(script.Parent.Parent.lib.heraTypes);

-- Class Definition
--[=[
	@class heraFile

	The heraFile class is designed to create a bridge between the .hera file type and the Hera Virtual API
]=]
local heraFile = {};
heraFile.__index = heraFile;

-- Type Definition
export type heraFile = typeof(setmetatable({} :: {
	heraClassName : "heraFile";
}, {} :: typeof(heraFile)))

--[=[
	@within heraFile

	The heraFile class is designed to create a bridge between the .hera file type and the Hera Virtual API

	@param heraFileCreateInfo heraTypes.heraFileCreateInfo
	@return file heraFile
]=]
function heraFile.new(heraFileCreateInfo : heraTypes.heraFileCreateInfo) : heraFile
	local class = setmetatable({}, heraFile);
	class.heraClassName = "heraFile";
	class.name = heraFileCreateInfo.name;

	return class;
end

return heraFile;