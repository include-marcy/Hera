-- This file is part of the Athena library and is licensed under GNU GENERAL PUBLIC LICENSE v3.0; see LICENSE.md for details

local athClasses = script.src.classes;
local athHost = require(athClasses.athHost);
local host : athHost.athHost = athHost.new();

local Athena = {
	athHost = host;
};

return Athena;