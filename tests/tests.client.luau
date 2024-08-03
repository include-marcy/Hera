local hera = game.ReplicatedStorage.Hera;
local heraTypes = require(hera.lib.heraTypes);
local heraEnvironment = require(hera.classes.heraEnvironment);

local heraGuiCreateInfo : heraTypes.heraGuiCreateInfo = {
    name = "main";
};

local heraEnvironmentCreateInfo : heraTypes.heraEnvironmentCreateInfo = {
    name = "main";
    guiCreateInfo = heraGuiCreateInfo;
};
local mainEnvironment = heraEnvironment.new(heraEnvironmentCreateInfo);

mainEnvironment:heraInit();