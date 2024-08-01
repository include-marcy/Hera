-- This file is part of the Athena library and is licensed under GNU GENERAL PUBLIC LICENSE v3.0; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Class Declaration
local athStopwatch = {};
athStopwatch.__index = athStopwatch;

export type athStopwatch = typeof(setmetatable({} :: {
	name : string;
	_clicked : boolean;
	_startTime : number;
	_elapsedTime : number;
	_stopTime : number?;
	athClassName : "athStopwatch";
}, {} :: typeof(athStopwatch)));

--[=[
	@within athStopwatch

	Creates a new athStopwatch.

	@param athStopwatchCreateInfo;
	@return athStopwatch;
]=]
function athStopwatch.new(athStopwatchCreateInfo) : athStopwatch
	local stopwatch = setmetatable({
		athClassName = "athStopwatch";
	}, athStopwatch);

	stopwatch.name = athStopwatchCreateInfo.name;
	stopwatch._clicked = false;
	stopwatch._startTime = os.clock();
	stopwatch._elapsedTime = 0;

	return stopwatch;
end

--[=[
	@within athStopwatch

	Stops the timer of this athStopwatch.
]=]
function athStopwatch:athClick()
	local stopwatch : athStopwatch = self;

	if stopwatch._clicked then
		return;
	end

	stopwatch._clicked = true;
	stopwatch._stopTime = os.clock();
	stopwatch._elapsedTime = (stopwatch._stopTime - stopwatch._startTime);
end

--[=[
	@within athStopwatch

	Returns the length of time this stopwatch has been running for.

	@return elapsedTime : number;
]=]
function athStopwatch:athGetTime() : number
	local stopwatch : athStopwatch = self;

	return stopwatch._elapsedTime;
end

--[=[
	@within athStopwatch

	@retun stopwatchIsClicked : boolean;
]=]
function athStopwatch:athGetState() : boolean
	local stopwatch : athStopwatch = self;

	return stopwatch._clicked;
end

--[=[
	@within athStopwatch

	@return name : string;
]=]
function athStopwatch:athGetName() : string
	local stopwatch : athStopwatch = self;

	return stopwatch.name;
end

return athStopwatch;