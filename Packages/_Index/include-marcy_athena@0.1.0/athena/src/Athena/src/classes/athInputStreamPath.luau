-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

local athInputStreamPath = {};
athInputStreamPath.__index = athInputStreamPath;

export type athInputStreamPath = typeof(setmetatable({} :: {
    inputType : athTypes.athInformedInputType;
    inputToCapture : athTypes.athCapturableInputs;
    inputMobileButtonType : athTypes.athMobileButtonType?;
    transform : (athTypes.athInputStreamData) -> (athTypes.athInputStreamData)?;
    athClassName : "athInputStreamPath";
}, {} :: typeof(athInputStreamPath)));

function athInputStreamPath.new(athInputStreamPathCreateInfo : athTypes.athInputStreamPathCreateInfo) : athInputStreamPath
    local inputStreamPath = setmetatable({
        athClassName = "athInputStreamPath";
    }, athInputStreamPath);

    inputStreamPath.inputType = athInputStreamPathCreateInfo.inputType;
    inputStreamPath.inputToCapture = athInputStreamPathCreateInfo.inputToCapture;
    inputStreamPath.inputMobileButtonType = athInputStreamPathCreateInfo.inputMobileButtonType;
    inputStreamPath.transform = athInputStreamPathCreateInfo.transform;

    return inputStreamPath;
end

return athInputStreamPath;