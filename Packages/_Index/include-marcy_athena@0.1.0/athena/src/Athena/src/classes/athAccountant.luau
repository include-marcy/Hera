-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

-- Class Definition
local athAccountant = {};
athAccountant.__index = athAccountant;

export type athAccountant = typeof(setmetatable({} :: {
	athClassName : "athAccountant";
	name : string;
}, {} :: typeof(athAccountant)));

--[=[
	@within athAccountant

	Creates a new athAccountant. An accountant object is used to reason about performance statistics inside
	your experience.

	@param athAccountantCreateInfo;
	@return athAccountant;
]=]
function athAccountant.new(athAccountantCreateInfo : athTypes.athAccountantCreateInfo) : athAccountant
	local accountant = setmetatable({
		athClassName = "athAccountant";
	}, athAccountant);

	accountant.name = athAccountantCreateInfo.name;

	return accountant;
end

function athAccountant:athFoo()

end

return athAccountant;