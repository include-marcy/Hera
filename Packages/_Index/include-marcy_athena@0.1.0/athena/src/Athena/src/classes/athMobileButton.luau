-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athTrove = require(athena.packages.trove);

-- Class Definition
local athMobileButton = {};
athMobileButton.__index = athMobileButton;

export type athMobileButton = typeof(setmetatable({} :: {
	organizationLayer : Frame;
	buttonType : athTypes.athMobileButtonType;
	displayText : string;
	displayIcon : string?;
	displayFont : Enum.Font?;
	color : Color3?;
	iconColor : Color3?;
	textColor : Color3?;
	rich : boolean;
	systemSize : number?;
	active : boolean;
	buttonInstance : Frame?;
	buttonInstanceType : athTypes.athMobileButtonType;
	athClassName : "athMobileButton";
}, {} :: typeof(athMobileButton)));

local function GET_RAW_SCALE_FOR_SYSTEM_SIZE_MOBILE(systemSize : number) : UDim2

end

--[=[
	@within athMobileButton

	Creates a new Luau representation of the Athena mobile button implementation.
	Read more about the Athena mobile button implementation in the README.md file.

	@return athMobileButton
]=]
function athMobileButton.new(athMobileButtonCreateInfo : athTypes.athMobileButtonCreateInfo) : athMobileButton
	local mobileButton = setmetatable({
		athClassName = "athMobileButton";
	}, athMobileButton);

	mobileButton.organizationLayer = athMobileButtonCreateInfo.organizationLayer;
	mobileButton.buttonType = athTypes.athMobileButtonCreateInfo.buttonType or "ATH_BUTTON_NORMAL";

	mobileButton.displayText = athMobileButtonCreateInfo.displayText;
	mobileButton.displayIcon = athMobileButtonCreateInfo.displayIcon;
	mobileButton.displayTextFont = athMobileButtonCreateInfo.displayFont or Enum.Font.BuilderSans;

	mobileButton.color = athMobileButtonCreateInfo.color or Color3.fromRGB(42, 41, 42);
	mobileButton.iconColor = athMobileButtonCreateInfo.iconColor or Color3.fromRGB(255, 255, 255);
	mobileButton.textColor = athMobileButtonCreateInfo.textColor or Color3.fromRGB(255, 255, 255);

	mobileButton.rich = athMobileButtonCreateInfo.rich or false;
	mobileButton.active = athMobileButtonCreateInfo.active or true;
	mobileButton.systemSize = athMobileButtonCreateInfo.systemSize or 1;

	mobileButton:athDrawButton();

	return mobileButton;
end

--[=[
	@within athMobileButton

	Creates the button instance, rendering it to the screen immediately
]=]
function athMobileButton:athDrawButton() : Frame
	local mobileButton : athMobileButton = self;
	if mobileButton.buttonType == "ATH_BUTTON_NORMAL" then
		return mobileButton:athDrawNormalButton();
	elseif mobileButton.buttonType == "ATH_BUTTON_JOYSTICK" then
		return mobileButton:athDrawJoystickButton();
	end

	mobileButton:athUpdateStyle();
end

--[=[
	@within athMobileButton

	Internal function to create a static button with no extra behavior.
]=]
function athMobileButton:athDrawNormalButton() : Frame
	local mobileButton : athMobileButton = self;

	--// Only 1 instance of button should exist in the athMobileButton at a time.
	if mobileButton.buttonInstance then
		if mobileButton.buttonInstanceType == "ATH_BUTTON_NORMAL" then
			return mobileButton.buttonInstance;
		elseif mobileButton.buttonInstanceType == "ATH_BUTTON_JOYSTICK" then
			mobileButton:athEraseButton();
		end
	end

	--// Create the *actual* button as a frame.
	local athButtonParent = Instance.new("Frame");

	--// Using systemSize param allows us to let developers express the ideal size and allow Athena to implement making sure that
	--// goes right on any and all displays.
	local athButtonSize = GET_RAW_SCALE_FOR_SYSTEM_SIZE_MOBILE(mobileButton.systemSize);
	athButtonParent.Size = athButtonSize;
	athButtonParent.BackgroundColor3 = mobileButton.color;
	athButtonParent.BackgroundTransparency = 0.45;

	--// The organization layer will determine the AbsolutePosition of the athButtonParent.
	athButtonParent.Parent = mobileButton.organizationLayer;

	--// Create the actual button itself, which will also be used to broadcast events to the athMobileButton.
	local athButton = Instance.new("TextButton");
	athButton.BackgroundTransparency = 1;
	athButton.Text = mobileButton.displayText;
	athButton.FontFace = mobileButton.displayFont;
	athButton.TextColor3 = mobileButton.textColor;
	athButton.RichText = mobileButton.rich;
	athButton.Size = UDim2.fromScale(1, 1);
	athButton.Position = UDim2.fromScale(0.5, 0.5);
	athButton.AnchorPoint = Vector2.new(0.5, 0.5);
	athButton.Parent = athButtonParent;

	--// Handle the event broadcasts now.
	local athButtonTrove = athTrove.instanceTrove(athButtonParent);
	athButtonTrove:Connect(athButton.MouseButton1Click, mobileButton.athButtonClicked);
	athButtonTrove:Connect(athButton.MouseButton1Down, mobileButton.athButtonDown);
	athButtonTrove:Connect(athButton.MouseButton1Up, mobileButton.athButtonUp);
	athButtonTrove:Connect(athButton.MouseEnter, mobileButton.athButtonMouseEnter);
	athButtonTrove:Connect(athButton.MouseLeave, mobileButton.athButtonMouseLeave);

	--// Style the button further.
	local StyleCorner = Instance.new("UICorner");
	StyleCorner.CornerRadius = UDim.new(1, 0);
	StyleCorner.Parent = athButtonParent;

	--// Register the button instance into the athMobileButton.
	mobileButton.buttonInstance = athButtonParent;
	mobileButton.buttonInstanceType = "ATH_BUTTON_NORMAL";

	return athButtonParent;
end

--[=[
	@within athMobileButton

	Internal function to create a joystick button, aka one which has two components:
		1. The handle. The handle is used to shift the joystick in any coordinate direction.
		2. The root. The root is used to hold the handle and describe the output of the joystick as a vector.

]=]
function athMobileButton:athDrawJoystickButton() : Frame
	local mobileButton : athMobileButton = self;

	if mobileButton.buttonInstance then
		if mobileButton.buttonInstanceType == "ATH_BUTTON_JOYSTICK" then
			return mobileButton.buttonInstance;
		elseif mobileButton.buttonInstanceType == "ATH_BUTTON_NORMAL" then
			mobileButton:athEraseButton();
		end
	end

	local athJoystickButtonParent = Instance.new("Frame");

	local athButtonSize = GET_RAW_SCALE_FOR_SYSTEM_SIZE_MOBILE(mobileButton.systemSize);
	athJoystickButtonParent.Name = "athJoystickButtonParent";
	athJoystickButtonParent.Size = athButtonSize;
	athJoystickButtonParent.BackgroundColor3 = mobileButton.color;
	athJoystickButtonParent.BackgroundTransparency = 0.45;
	athJoystickButtonParent.Parent = mobileButton.organizationLayer;

	local athJoystickButton = Instance.new("TextButton");
	athJoystickButton.Name = "athJoystickButton";
	athJoystickButton.BackgroundTransparency = 1;
	athJoystickButton.Text = mobileButton.displayText;
	athJoystickButton.FontFace = mobileButton.displayFont;
	athJoystickButton.TextColor3 = mobileButton.textColor;
	athJoystickButton.RichText = mobileButton.rich;
	athJoystickButton.Size = UDim2.fromScale(1, 1);
	athJoystickButton.Position = UDim2.fromScale(0.5, 0.5);
	athJoystickButton.AnchorPoint = Vector2.new(0.5, 0.5);
	athJoystickButton.Parent = athJoystickButtonParent;

	local athButtonTrove = athTrove.instanceTrove(athJoystickButtonParent);
	athButtonTrove:Connect(athJoystickButton.MouseButton1Click, mobileButton.athButtonClicked);
	athButtonTrove:Connect(athJoystickButton.MouseButton1Down, mobileButton.athButtonDown);
	athButtonTrove:Connect(athJoystickButton.MouseButton1Up, mobileButton.athButtonUp);
	athButtonTrove:Connect(athJoystickButton.MouseEnter, mobileButton.athButtonMouseEnter);
	athButtonTrove:Connect(athJoystickButton.MouseLeave, mobileButton.athButtonMouseLeave);

	local StyleCorner = Instance.new("UICorner");
	StyleCorner.CornerRadius = UDim.new(1, 0);
	StyleCorner.Parent = athJoystickButtonParent;

	local athJoystickInputRegion = Instance.new("TextButton");
	athJoystickInputRegion.Name = "athJoystickInputRegion";
	athJoystickInputRegion.Size = UDim2.fromScale(1.5, 1.5);
	athJoystickInputRegion.BackgroundTransparency = 1;
	athJoystickInputRegion.Parent = athJoystickButtonParent;

	mobileButton.buttonInstance = athJoystickButtonParent;
	mobileButton.buttonInstanceType = "ATH_BUTTON_JOYSTICK";

	return athJoystickButtonParent;
end

--[=[
	@within athMobileButton

	Destroys the button instance, removing it from the data model.
]=]
function athMobileButton:athEraseButton()
	local mobileButton : athMobileButton = self;

	local buttonInstance = mobileButton.buttonInstance;

	if not buttonInstance then
		return;
	end

	buttonInstance:Destroy();
	buttonInstance = nil;
	mobileButton.buttonInstance = nil;
	mobileButton.buttonInstanceType = nil;
end

--[=[
	@within athMobileButton

	Signals the button as deactivated, suppressing input while it is.
]=]
function athMobileButton:athDeactivateButton()
	local mobileButton : athMobileButton = self;
	if mobileButton.active == false then
		return;
	end

	mobileButton.active = false;
	mobileButton:athUpdateStyle();
end

--[=[
	@within athMobileButton

	Signals the button as active, allowing input to stream from this button.
]=]
function athMobileButton:athActivateButton()
	local mobileButton : athMobileButton = self;
	if mobileButton.active == true then
		return;
	end

	mobileButton.active = true;
	mobileButton:athUpdateStyle();
end

--[=[
	@within athMobileButton

	Callback that executes when the athMobileButton's buttonInstance textButton object is directly inputted.
]=]
function athMobileButton:athButtonClicked()
	local mobileButton : athMobileButton = self;
	if not mobileButton.active then
		return;
	end


end

--[=[
	@within athMobileButton

	Callback that executes when the user begins holding the handle of the joystick.
]=]
function athMobileButton:athJoystickDown(touchPosition : UDim2)
	local button : athMobileButton = self;

	button.joystickDown = true;
end

--[=[
	@within athMobileButton

	Callback that executes when the user releases the handle of the joystick.
]=]
function athMobileButton:athJoystickUp(touchPosition : UDim2)
	local button : athMobileButton = self;

	button.joystickDown = true;
end

--[=[
	@within athMobileButton

	Callback that executes whenever the vector of the joystick handle changes.
]=]
function athMobileButton:athJoystickMoved(unit : Vector2)

end

function athMobileButton:athIsJoystickDown() : boolean
	local button : athMobileButton = self;

	return button.joystickDown;
end

function athMobileButton:athGetJoystickDirection() : Vector2
	local button : athMobileButton = self;
	local buttonInstance = button.buttonInstance;

	local rawOrigin = buttonInstance.AbsolutePosition;
	local rawOrigin2 = buttonInstance.athJoystickButton.AbsolutePosition;

	local direction : Vector2 = (rawOrigin - rawOrigin2);
	local normalizedDirection = direction.Unit;

	return normalizedDirection;
end

--[=[
	@within athMobileButton

	Callback that executes whenever the athMobileButton's buttonInstance textButton has begun to be pressed.
]=]
function athMobileButton:athButtonDown()

end

--[=[
	@within athMobileButton

	Callback that executes whenever the athMobileButton's buttonInstance textButton has stopped being pressed.
]=]
function athMobileButton:athButtonUp()

end

--[=[
	@within athMobileButton

	Callback that executes whenever the athMobileButton's buttonInstance textButton has been hovered over by a mouse or finger
]=]
function athMobileButton:athButtonMouseEnter()

end

--[=[
	@within athMobileButton

	Callback that executes whenever a mouse or finger has left the athMobileButton's buttonInstance textButton
]=]
function athMobileButton:athButtonMouseLeave()

end

--[=[
	@within athMobileButton

	Configures the style of the button according to the given parameters
]=]
function athMobileButton:athUpdateStyle()
	local mobileButton : athMobileButton = self;
	local buttonInstance = mobileButton.buttonInstance;

	if not buttonInstance then
		return;
	end

	if mobileButton.active then
		
	elseif not mobileButton.active then

	end
end

--[=[
	@within athMobileButton

	Creates a radial progress indicator on this button, returning a "pie chart" sweeping animation object
]=]
function athMobileButton:athRadialProgressAction()

end

--[=[
	@within athMobileButton

	Creates a horizontal progress indicator on this button, returning a "flat" sweeping animation object
]=]
function athMobileButton:athHorizontalProgressAction()

end

--[=[
	@within athMobileButton

	Creates a circular progress indicator on this button, returning a "circle" that grows and shrinks by the returned animation object.
]=]
function athMobileButton:athCircularProgressAction()

end

--[=[
	@within athMobileButton

	Hides the button, suppressing input and total visibility. Does not remove it from the data model.
]=]
function athMobileButton:athHideButton()

end

--[=[
	@within athMobileButton

	Returns the button from the hidden state.

	:::info
	All other states that were modified or added to the button before and during its hidden state still apply 
	Such as the disabled state).
	:::
]=]
function athMobileButton:athShowButton()

end

--[=[
	@within athMobileButton

	Reallocates the position flag of this button, reordering it accordingly in the organization layer.
]=]
function athMobileButton:athRepositionButton(priority : number)

end

--[=[
	@within athMobileButton

	Resizes the button dynamically.
]=]
function athMobileButton:athResizeButton(systemSize : number)

end

return athMobileButton;