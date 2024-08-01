-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

local athUtils = {};

--[=[
	@public
	@athUtils

	Returns 
]=]
function athUtils.athIsA(Class, athClassName)
	return typeof(Class) == "table" and (Class.athClassName or "athUnlabeledClass") == athClassName;
end

return athUtils;