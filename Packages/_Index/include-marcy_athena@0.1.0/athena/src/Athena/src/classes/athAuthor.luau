-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athTypes = require(script.Parent.Parent.lib.athTypes);

-- Class Declaration
local athAuthor = {};
athAuthor.__index = athAuthor;

export type athAuthor = typeof(setmetatable({} :: {
    name : string;
    athClassName : "athAuthor";
    mode : athTypes.athAuthorMode;
    _logLayers : {[number]: {
        transform : (string) -> (string);
    }};
    _biography : {[number]: string};
}, {} :: typeof(athAuthor)));

--[==[
    @class athAuthor

    Creates a new athAuthor instance. An athAuthor instance is used to write logs to the experience "biography".
    Experience Biographies are used to tell us more about the lifecycle of real JobIds so that we can gain insight
    into the runtime behavior of libraries and experience state.

    @param athAuthorCreateInfo;
    @return athAuthor
]==]
function athAuthor.new(athAuthorCreateInfo : athTypes.athAuthorCreateInfo) : athAuthor
    local author = setmetatable({
        athClassName = "athAuthor";
    }, athAuthor);

    author.name = athAuthorCreateInfo.name;
    author.mode = athAuthorCreateInfo.mode;

    author._logLayers = {};
    author._biography = {};

    return author;
end

--[==[
    @class athAuthor

    Allows you to register middleware that will transform logged messages on this author.
    Used to automate repetitive tasks or boilerplate text onto messages.

    @param athLogLayerCreateInfo;
]==]
function athAuthor:athAddLogLayer(athLogLayerCreateInfo)
    local author : athAuthor = self;

    table.insert(author._logLayers, athLogLayerCreateInfo);
end

--[==[
    @class athAuthor

    Logs the message to the experience biography.
    Automatically includes the author name, current time, and the message with any log transforms.

    @param message : string;
    @return transformedMessage : string;
]==]
function athAuthor:athLog(message : string) : string
    local author : athAuthor = self;

    for _, logLayer in author._logLayers do
        local transform = logLayer.transform;
        if transform then
            message = transform(message);
        end
    end

    table.insert(author._debugDump.biography, {
        author = author.name;
        message = message;
        timeStamp = os.time();
    });

    if author.mode == "ATH_LOG_MODE_LOUD" then
        warn(message);
    elseif author.mode == "ATH_LOG_MODE_QUIET" then
        print(message);
    elseif author.mode == "ATH_LOG_MODE_SILENT" then
        return;
    end

    return message;
end

return athAuthor;