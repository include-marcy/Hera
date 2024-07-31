-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

-- Class Definition
local athLibrary = {};
athLibrary.__index = athLibrary;

export type athLibrary = typeof(setmetatable({} :: {
    athClassName : "athLibrary";
    athClasses : Folder;
    athTypes : ModuleScript;
    athSingletons : {};
}, {} :: typeof(athLibrary)));

--[=[
    @class athLibrary

    Creates a new athLibrary object, a housing for a generic library object that can be built and ran by an athHost.

    Internal components of the library are exposed to this object natively by the athHost, and external clients are required to
    slot into the athHost and negotiate with it to access the internal components.

    :::INFO
    If you are the creator of a library or a maintainer of a library which builds with Athena, please read this documentation.
    If you are a developer of an experience which includes Athena built libraries, you can safely ignore this file.
    :::
]=]
function athLibrary.new(athLibraryCreateInfo : athTypes.athLibraryCreateInfo) : athLibrary
    local library = setmetatable({
        athClassName = "athLibrary";
    }, athLibrary);

    library.name = athLibraryCreateInfo.name;
    library.athClasses = {};
    library.athTypes = {};
    library.athSingletons = {};

    return library;
end

--[=[
    @class athLibrary

    Sets the internal registry of classes in this athLibrary object.
]=]
function athLibrary:athSetClasses(classes : Folder)
    local library : athLibrary = self;

    library.athClasses = classes;
end

--[=[
    @class athLibrary

    Returns the internal registry of classes in this athLibrary object.
]=]
function athLibrary:athGetClasses()
    local library : athLibrary = self;

    return library.athClasses;
end

--[=[
    @class athLibrary

    Sets the internal registry of types in this athLibrary object.
]=]
function athLibrary:athSetProjectTypes(types : ModuleScript)
    local library : athLibrary = self;

    library.athTypes = types;
end

--[=[
    @class athLibrary

    Returns the internal registry of types in this athLibrary object.
]=]
function athLibrary:athGetProjectTypes()
    local library : athLibrary = self;

    return library.athTypes;
end

--[=[
    @class athLibrary

    Makes the copy of a singleton of class in this athLibrary object stored under className.
]=]
function athLibrary:athCreateProjectSingleton(className : string, class : any, ...)
    local library : athLibrary = self;

    if library:athGetProjectSingleton(className) then
        return;
    end

    library.athSingletons[className] = class.new(...);

    return library.athSingletons[className];
end

--[=[
    @class athLibrary

    Returns the internal copy of a singleton of className in this athLibrary object
]=]
function athLibrary:athGetProjectSingleton(className : string)
    local library : athLibrary = self;
    return library.athSingletons[className];
end

return athLibrary;