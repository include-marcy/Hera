-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

-- Class Definition
local athEnumerator = {};
athEnumerator.__index = athEnumerator;

export type athEnumerator = typeof(setmetatable({} :: {
	athClassName : "athEnumerator";
	name : string;
}, {} :: typeof(athEnumerator)));

function athEnumerator.new(athEnumeratorCreateInfo : athTypes.athEnumeratorCreateInfo) : athEnumerator
	local enumerator = setmetatable({
		athClassName = "athEnumerator";
	}, athEnumerator);

	enumerator.name = athEnumeratorCreateInfo.name;

	return enumerator;
end

function athEnumerator:athFoo()

end

return athEnumerator;