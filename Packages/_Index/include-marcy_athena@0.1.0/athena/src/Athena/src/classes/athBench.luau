-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Roblox Services
local HttpService = game:GetService("HttpService");

-- Athena Dependencies
local athena = script.Parent.Parent;
local athToken = require(athena.classes.athToken);
local athStopwatch = require(athena.classes.athStopwatch);
local athAuthor = require(athena.classes.athAuthor);

-- Class Declaration
local athBench = {};
athBench.__index = athBench;

export type athBench = typeof(setmetatable({} :: {
    _frequencyHookStates : {[string] : number};
    _authors : {[string] : athAuthor.athAuthor};
    athClassName : "athBench";
}, {} :: typeof(athBench)));

--[=[
    @class athBench

    Creates a new athBench object. An athBench is used to gain insight into the performance of a certain region of
    an experience. Usually, you should create 1 athBench for use within your library.

    @return athBench
]=]
function athBench.new() : athBench
    local bench = setmetatable({
        athClassName = "athBench";
    }, athBench);

    bench._frequencyHookStates = {};
    bench._authors = {};
    bench._debugDump = {
        profile = {};
        tokens = {};
        biography = {};
    };

    return bench;
end

--[=[
    @class athBench

    Rates the given payload in kb/s against the rate n in seconds.
    The rate refers to how many times this payload is sent per second. For example,
    if you sent table T every 40 seconds across the remote network layer, it would have a rate
    of 40, and an athNetworkUsage of (size(T) * R) KB/s

    @param payload : any;
    @param rate : number;
    @return score : number;
]=]
function athBench:athNetworkUsage(payload : any, rate : number) : number
    -- return the data in kb/s
    local encoded = HttpService:JSONEncode(payload);

    return (#encoded) * rate;
end

--[=[
    @class athBench

    Registers and returns a hook for the given callback with name.
    Every time the hook is called, it will increment a counter.
    This allows you to track the frequency of a callback.

    @param name : string;
    @param callback : function;
    @return freqHook : function;
]=]
function athBench:athMakeFrequencyHook(name : string, callback : () -> ()) : () -> ()
    local bench : athBench = self;
    local num = bench._frequencyHookStates[name] or 0;

    return function(...)
        num += 1;
        bench._frequencyHookStates[name] = num;
        callback(...);
    end
end

--[=[
    @class athBench

    Returns the frequency associated with the given name of a frequency hook.
    This tells you how many times (the frequency) a callback has been called in this athBench environment.

    @param name : string;
    @return frequency : number;
]=]
function athBench:athGetFrequency(name : string) : number
    local bench : athBench = self;
    local num = bench._frequencyHookStates[name] or 0;

    return num
end

--[=[
    @class athBench

    Creates a new athToken object, which are immutable data objects that signal global state which can allow your library
    to reason about the experience in different ways.

    @param name : string;
    @param value : any;
    @return athToken
]=]
function athBench:athMakeToken(name : string, value : any) : athToken.athToken
    local bench : athBench = self;

    local token = athToken.new({
        name = name;
        value = value;
    })

    bench._debugDump.tokens[name] = token;

    return token;
end

--[=[
    @class athBench

    Reads the stored athToken object and returns its value, if any exists.

    @param name : string;
    @return tokenValue : any;
]=]
function athBench:athReadToken(name : string) : any
    local bench : athBench = self;

    local token : athToken.athToken? = bench._debugDump.tokens[name];
    if not token then
        return nil;
    end

    return token:athReadValue();
end

--[=[
    @class athBench

    Creates a new athStopwatch, a performance clocking device which allows you to easily track the time between lines of code.
    Stopwatch performance information is stored in the athBench, allowing you to perform multiple tests on the same
    "name", and then easily process all that information in the debug dump of the athBench.

    @param name : string;
    @return athStopwatch;
]=]
function athBench:athMakeStopwatch(name : string) : athStopwatch.athStopwatch
    local bench : athBench = self;
    local stopwatch = athStopwatch.new({
        name = name;
    });

    bench._debugDump.profile[name] = stopwatch;

    return stopwatch;
end

function athBench:athAverageProfile(name : string) : number
   local bench : athBench = self;

   local stopwatch = bench._debugDump.profile[name];
   if not stopwatch then
       return 0;
   end

   
end

--[=[
    @class athBench

    Creates and stores a new athAuthor, allowing you to denote information in the experience biography.
    For more info, check out `athAuthor.luau`

    @param name : string;
    @return athAuthor;
]=]
function athBench:athMakeAuthor(name : string) : athAuthor.athAuthor
    local bench : athBench = self;
    local author = athAuthor.new({
        name = name;
    });

    bench._authors[name] = author;

    return author;
end

return athBench;