-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies

-- Class Definition
local athTester = {};
athTester.__index = athTester;

export type athTester = typeof(setmetatable({} :: {
	athClassName : "athTester";
}, {} :: typeof(athTester)));

--[=[
	@within athTester

	Creates a new athTester, an object designed to help you run diagnostics and ensure unit testing can be easily performed
	on logical units of your libraries/plugins/frameworks.

	@return athTester
]=]
function athTester.new() : athTester
	local tester = setmetatable({
		athClassName = "athTester";
	}, athTester);

	return tester;
end

return athTester;