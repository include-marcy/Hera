-- This file is part of the Athena library and is licensed under GNU GENERAL PUBLIC LICENSE v3.0; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services
local TestService = game:WaitForChild("TestService");
local HttpService = game:GetService("HttpService");

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);

-- Class Definition
local athUserStore = {};
athUserStore.__index = athUserStore;

export type athUserStore = typeof(setmetatable({} :: {
	name : string;
	userDataFolder : Folder;
	athClassName : "athUserStore";
}, {} :: typeof(athUserStore)));

-- Constants
local REFERENDUM_FOLDER_NAME = "athUsersReferendum";

--[=[
	@within athUserStore
	@private
	@const
	@static

	Returns the users referendum, a global folder that stores data and instances for developers in
	Roblox Studio

	@return usersReferendum : Folder;
]=]
local function GET_REFERENDUM_USERS() : Folder
	local usersReferendum = TestService:FindFirstChild(REFERENDUM_FOLDER_NAME);

	if not usersReferendum then
		usersReferendum = Instance.new("Folder");
		usersReferendum.Name = REFERENDUM_FOLDER_NAME;
		usersReferendum.Parent = TestService;
	end

	return usersReferendum;
end

--[=[
	@within athUserStore
	@private
	@const
	@static

	Returns a folder inside the users referendum, a global access folder for storing instances and data inside
	Roblox Studio.

	@param user : string;
	@return userDataFolder : Folder;
]=]
local function GET_USER_DATA_FOLDER(user : string) : Folder
	local usersReferendum = GET_REFERENDUM_USERS();

	local userDataFolder = usersReferendum:FindFirstChild(user);

	if not userDataFolder then
		userDataFolder = Instance.new("Folder");
		userDataFolder.Name = user;
		userDataFolder.Parent = usersReferendum;
	end

	return userDataFolder;
end

--[=[
	@within athUserStore
	Creates a new athUserStore, which are similar functionally to DataStores without any API request limits.
	They are designed to be used in Studio only, typically for library and plugin development.

	@param athUserStoreCreateInfo;
	@return athUserStore
]=]
function athUserStore.new(athUserStoreCreateInfo : athTypes.athUserStoreCreateInfo) : athUserStore
	local userStore = setmetatable({
		athClassName = "athUserStore";
	}, athUserStore);

	userStore.name = athUserStoreCreateInfo.name;
	userStore.userDataFolder = GET_USER_DATA_FOLDER(userStore.name);

	return userStore;
end

--[=[
	@within athUserStore
	Loads a key value;

	@param key;
	@return any
]=]
function athUserStore:athLoadAsync(key : string) : any
	local userStore : athUserStore = self;
	local dataValue : StringValue? = userStore.userDataFolder:FindFirstChild(key);

	if dataValue then
		local isTable : BoolValue? = dataValue:FindFirstChild("athIsTableFlag");
		local value = dataValue.Value;

		if isTable and isTable.Value then
			value = HttpService:JSONDecode(value);
		end

		return value;
	end
end

--[=[
	@within athUserStore
	Sets a key value.
	A key value can be of mostly any type. If it is a table, ensure it can be ran through and encoded in JSON.

	@param key;
	@param value;
]=]
function athUserStore:athSetAsync(key : string, value : any)
	local userStore : athUserStore = self;
	local dataValue : StringValue? = userStore.userDataFolder:FindFirstChild(key);

	if not dataValue then
		local instanceToUse = "StringValue";
		local addTableFlag = false;

		if typeof(value) == "table" then
			addTableFlag = true;
			value = HttpService:JSONEncode(value);
		elseif typeof(value) == "number" then
			instanceToUse = "NumberValue";
		elseif typeof(value) == "CFrame" then
			instanceToUse = "CFrameValue";
		elseif typeof(value) == "Vector3" then
			instanceToUse = "Vector3Value";
		elseif typeof(value) == "Instance" then
			instanceToUse = "ObjectValue";
		end

		dataValue = Instance.new(instanceToUse);
		dataValue.Name = key;
		dataValue.Parent = userStore.userDataFolder;

		if addTableFlag then
			local tableFlag = Instance.new("BoolValue");
			tableFlag.Value = true;
			tableFlag.Name = "athIsTableFlag";
			tableFlag.Parent = dataValue;
		end
	else
		dataValue.Value = value;
	end
end

--[=[
	@within athUserStore
	Returns the possible associated instance with a given instance reference identifier for this user store.

	@param key;
	@return any
]=]
function athUserStore:athGetPersistentInstanceAsync(instanceReferenceIdentifier : string) : Instance?
	local userStore : athUserStore = self;
	local persistentInstance = userStore.userDataFolder:FindFirstChild(instanceReferenceIdentifier);

	return persistentInstance;
end

--[=[
	@within athUserStore
	Sets the associated instance with the given instance reference identifier for this user store.

	@param key;
	@return any
]=]
function athUserStore:athSetPersistentInstanceAsync(instanceReferenceIdentifier : string, instance : Instance)
	local userStore : athUserStore = self;

	instance.Name = instanceReferenceIdentifier;
	instance.Parent = userStore.userDataFolder;
end

return athUserStore;