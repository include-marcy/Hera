local hera = game.ReplicatedStorage.Hera;
local heraTypes = require(hera.lib.heraTypes);
local heraEnvironment = require(hera.classes.heraEnvironment);

local heraEnvironmentCreateInfo : heraTypes.heraEnvironmentCreateInfo = {
    name = "main";
};
local mainEnvironment = heraEnvironment.new(heraEnvironmentCreateInfo);

mainEnvironment:heraInit();