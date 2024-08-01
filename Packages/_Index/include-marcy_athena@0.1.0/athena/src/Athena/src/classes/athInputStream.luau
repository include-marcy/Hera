-- This file is part of the Athena library and is licensed under GNU GENERAL PUBLIC LICENSE v3.0; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services
local UserInputService = game:GetService("UserInputService");

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athSignal = require(athena.classes.athSignal);
local athTrove = require(athena.packages.trove);

local athInputStreamPath = require(athena.classes.athInputStreamPath);
local athMobileButton = require(athena.classes.athMobileButton);

-- Class Definition
local athInputStream = {};
athInputStream.__index = athInputStream;

export type athInputStream = typeof(setmetatable({} :: {
	athInputBeganSignal : athSignal.athSignal;
	athInputEndedSignal : athSignal.athSignal;
	athMovementSignal : athSignal.athSignal;
	athInformedInputTypeChanged : athSignal.athSignal;
	athInputChannels : {};
	athTrove : athTrove.athTrove;
	athClassName : "athInputStream";
}, {} :: typeof(athInputStream)));

--[=[
	@within athInputStream

	Creates a new athInputStream, a cross-platform input streaming object that facilitates libraries demand for
	a unified input detection method across all ©Roblox platforms.

]=]
function athInputStream.new() : athInputStream
	local inputStream = setmetatable({
		athClassName = "athInputStream";
	}, athInputStream);

	inputStream.athInputBeganSignal = athSignal.new();
	inputStream.athInputEndedSignal = athSignal.new();
	inputStream.athMovementSignal = athSignal.new();
	inputStream.athInformedInputTypeChanged = athSignal.new();

	inputStream.athInputChannels = {};
	inputStream.athTrove = athTrove.new();

	return inputStream;
end

--[=[
	@within athInputStream

	Returns a new athSignal which is fired whenever any input begins

	@return athSignal;
]=]
function athInputStream:athGetInputBeganSignal() : athSignal.athSignal
	local inputStream : athInputStream = self;

	return inputStream.athInputBeganSignal;
end

--[=[
	@within athInputStream

	Returns a new athSignal which is fired whenever any input ends

	@return athSignal;
]=]
function athInputStream:athGetInputEndedSignal() : athSignal.athSignal
	local inputStream : athInputStream = self;

	return inputStream.athInputEndedSignal;
end

--[=[
	@within athInputStream

	Returns a signal which, when fired, outputs a unit vector describing the desired movement direction of the client.
	For use in core script replacements where implementations should be platform blind.

	Supports:
	Input stream from customizable keyboard inputs (WASD and arrow keys by default)
	Input stream from mobile joystick implementation
	Input stream from gamepad
	Input stream from VR

	@return athSignal;
]=]
function athInputStream:athGetMovementSignal() : athSignal.athSignal
	return self.athMovementSignal :: athSignal.athSignal;
end

--[=[
	@within athInputStream

	Sets up this athInputStream to begin outputting input signals.
]=]
function athInputStream:athInit()
	local inputStream : athInputStream = self;
	local athInputTrove : athTrove.athTrove = inputStream.athTrove;
	local recordedInputType = inputStream:athGetInformedInputMethod();

	athInputTrove:Connect(UserInputService.InputBegan, function(inputObject : InputObject, eventConsumedByGame : boolean)
		if eventConsumedByGame then
			return;
		end

		local informedInputType = inputStream:athGetInformedInputMethod();
		if informedInputType ~= recordedInputType then
			inputStream.athInformedInputTypeChanged:Fire(recordedInputType, informedInputType);
			recordedInputType = informedInputType;
		end

		inputStream.athInputBeganSignal:Fire(inputObject);
	end);

	athInputTrove:Connect(UserInputService.InputEnded, function(inputObject : InputObject, eventConsumedByGame : boolean)
		if eventConsumedByGame then
			return;
		end

		inputStream.athInputEndedSignal:Fire(inputObject);
	end);

	local MovementDirection = Vector3.zero;
	local MovementEnums = {
		["W"] = Vector3.new(0, 0, -1);
		["A"] = Vector3.new(-1, 0, 0);
		["S"] = Vector3.new(0, 0, 1);
		["D"] = Vector3.new(1, 0, 0);
	}

	--// Keyboard inputs:
	local inputStreamPathW = athInputStreamPath.new({
		inputType = "ATH_KEYBOARD";
		inputToCapture = "W";
	});
	local inputStreamPathA = athInputStreamPath.new({
		inputType = "ATH_KEYBOARD";
		inputToCapture = "A";
	});
	local inputStreamPathS = athInputStreamPath.new({
		inputType = "ATH_KEYBOARD";
		inputToCapture = "S";
	});
	local inputStreamPathD = athInputStreamPath.new({
		inputType = "ATH_KEYBOARD";
		inputToCapture = "D";
	});

	local inputStreamPathMobileJoystick = athInputStreamPath.new({
		inputType = "ATH_MOBILE";
		inputMobileButtonType = "ATH_BUTTON_JOYSTICK";
		transform = function(inputStreamData, mobileButton : athMobileButton.athMobileButton)
			local Direction = mobileButton:athGetJoystickDirection();
			inputStreamData.MovementChange = Vector3.new(Direction.X, 0, Direction.Y);
			return inputStreamData;
		end;
	});

	inputStream:athMakeDedicatedInputChannel("athMovement_Forward", {
		inputStreamPathW;
		inputStreamPathA;
		inputStreamPathS;
		inputStreamPathD;
		inputStreamPathMobileJoystick;
	}, 1, function(inputStreamData)
		-- handle non keyboard callback cases
		-- lifting the joystick and moving it constantly sets this movement direction
		-- gyrating the joystick on a gamepad navigates the unit of this movement direction
		-- releasing any type of joystick sets the movement direction to 0
		if inputStreamData.MovementChange then
			MovementDirection = inputStreamData.MovementChange;
			return;
		end

		-- handle keystrokes
		local Change = MovementEnums[inputStreamData.InputString]
		if inputStreamData.Began then
			MovementDirection += Change
		else
			MovementDirection -= Change
		end

		inputStream.athMovementSignal:Fire(MovementDirection);
	end);
end

--[=[
	@within athInputStream

	Gets the currently active input method. Has various constraints that determines which
	input method is "active", for instance:
	- Sometimes, touch screen laptops are detected as mobile devices. This detects keyboards and uses them when available.

	@return athInformedInputType;
]=]
function athInputStream:athGetInformedInputMethod() : athTypes.athInformedInputType
	local keyboardEnabled = UserInputService.KeyboardEnabled;
	local touchEnabled = UserInputService.TouchEnabled;
	local gamepadEnabled = UserInputService.GamepadEnabled;
	local vrEnabled = UserInputService.VREnabled;

	if keyboardEnabled then
		return "ATH_KEYBOARD";
	elseif touchEnabled then
		return "ATH_TOUCH_SCREEN";
	elseif gamepadEnabled then
		return "ATH_GAMEPAD";
	elseif vrEnabled then
		return "ATH_VR";
	end
end

--[=[
	@within athInputStream

	Gets the linked dedicated input channel associated with the desired input.

	@param inputChannel : string;
	@return athDedicatedInputChannel;
]=]
function athInputStream:athGetDedicatedInputChannel(inputChannel : string)
	local inputStream : athInputStream = self;

	return inputStream.athInputChannels[inputChannel];
end

function athInputStream:athMakeDedicatedInputChannel(inputChannel : string, inputPaths : {athInputStreamPath.athInputStreamPath}, streamPriority : number, onInputReceived)
	local inputStream : athInputStream = self;

	if inputStream:athGetDedicatedInputChannel(inputChannel) then
		return;
	end

	local athInputTrove : athTrove.athTrove = inputStream.athTrove;
	local athInputChannelTrove = athInputTrove:Extend();
	local athInputChannelInformedInputType = inputStream:athGetInformedInputMethod();

	athInputChannelTrove:Connect(inputStream.athInformedInputTypeChanged, function(_, newInformedInputType : athTypes.athInformedInputType)
		if newInformedInputType ~= athInputChannelInformedInputType then
			athInputChannelInformedInputType = newInformedInputType;
		end
	end);

	local dedicatedInputChannel = {
		athInputChannelTrove = athInputChannelTrove;
		streamPriority = streamPriority;
	};

	inputStream.athInputChannels[inputChannel] = dedicatedInputChannel;

	local function getInputString(inputObject : InputObject)
		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			return inputObject.KeyCode.Name;
		else
			return inputObject.UserInputType.Name;
		end
	end

	local function EmitChannelCallback(inputObject : InputObject, began, transform)
		local inputString = getInputString(inputObject);
		local inputStreamData = {
			InputString = inputString;
			Began = began;
		};

		if transform then
			inputStreamData = transform(inputStreamData);
		end

		onInputReceived(inputStreamData);

		return inputStreamData;
	end

	for _, inputStreamPath in inputPaths do
		athInputChannelTrove:Connect(inputStream.athInputBeganSignal, function(inputObject : InputObject)
			if inputObject.UserInputType == Enum.UserInputType.Keyboard then
				if inputObject.KeyCode.Name == inputStreamPath.inputToCapture then
					EmitChannelCallback(inputObject, true, inputStreamPath.transform);
				end
			end
		end);

		athInputChannelTrove:Connect(inputStream.athInputEndedSignal, function(inputObject : InputObject)
			if inputObject.UserInputType == Enum.UserInputType.Keyboard then
				if inputObject.KeyCode.Name == inputStreamPath.inputToCapture then
					EmitChannelCallback(inputObject, false, inputStreamPath.transform);
				end
			end
		end);
	end

	return dedicatedInputChannel;
end

function athInputStream:athDestroyDedicatedInputChannel(inputChannel : string)
	local inputStream : athInputStream = self;
	local dedicatedInputChannel = inputStream:athGetDedicatedInputChannel(inputChannel);
	if not dedicatedInputChannel then
		return;
	end

	local athInputChannelTrove = dedicatedInputChannel.athInputChannelTrove;
	if athInputChannelTrove then
		athInputChannelTrove:Destroy();
		athInputChannelTrove = nil;
	end

	inputStream.athInputChannels[inputChannel] = nil;
	dedicatedInputChannel = nil;
end

function athInputStream:athConfigureChannelForMobile(inputChannel : string, channelConfiguration)
	local inputStream : athInputStream = self;
	local dedicatedInputChannel = inputStream:athGetDedicatedInputChannel(inputChannel);
	if not dedicatedInputChannel then
		return;
	end

	return inputStream:athMakeMobileButton(dedicatedInputChannel, channelConfiguration.athMobileButtonCreateInfo);
end

function athInputStream:athMakeMobileButton(_, athMobileButtonCreateInfo : athTypes.athMobileButtonCreateInfo)
	local mobileButton = athMobileButton.new(athMobileButtonCreateInfo);

	return mobileButton;
end

function athInputStream:athOrganizeMobileButtons()

end

function athInputStream:athCreateMobileOrganizationLayer(_ : string, _ : (athMobileButton.athMobileButton) -> (number))

end

return athInputStream;