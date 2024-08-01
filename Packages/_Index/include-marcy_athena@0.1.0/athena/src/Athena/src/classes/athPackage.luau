-- This file is part of the Athena library and is licensed under GNU GENERAL PUBLIC LICENSE v3.0; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- ROBLOX Services
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- Athena Dependencies
local athena = script.Parent.Parent;
local athTypes = require(athena.lib.athTypes);
local athUserStore = require(athena.classes.athUserStore);

local athPackagesUserStore = athUserStore.new({
	name = "athenaPackages";
})

-- Class Definition
local athPackage = {};
athPackage.__index = athPackage;

-- Constants
local SHIP_BLOCK = ";";

--[=[
	@private
	@const
	@static

	Unpacks a package identity into its constituent member variables, which describe:
		The site it shipped from
		The user of the site shipping the package
		The package to ship, from the user
]=]
local function GET_SHIPPING_DETAILS(packageIdentity)
	local details = string.split(packageIdentity, SHIP_BLOCK);

	return table.unpack(details);
end

--[=[
	@private
	@const
	@static

	Creates a string which can be stored as a package identity.
]=]
local function MAKE_SHIPPING_DETAILS(packageCourier : string, packageShipper : string, packageName : string) : string
	return `{packageCourier}{SHIP_BLOCK}{packageShipper}{SHIP_BLOCK}{packageName}`;
end

--[=[
	@private
	@const
	@static

	Recursively populates the given "currentFolder" argument with the HTTP GET data from GitHub API with the specified
	gitUser and gitRepoName.
]=]
local function MAKE_DESCRIPTION_FROM_GITHUB(gitUser, gitRepoName, currentFolder)
	local request = `https://api.github.com/repos/{gitUser}/{gitRepoName}/contents`;

	local function download(link)
		local httpPageSource = HttpService:GetAsync(link);
		local httpPage = HttpService:JSONDecode(httpPageSource);

		for _, httpObject in httpPage do
			if httpObject.type == "dir" then
				local newFolder = Instance.new("Folder")
				newFolder.Name = httpObject.name;
				newFolder.Parent = currentFolder;
				local oldFolder = currentFolder;
				currentFolder = newFolder;

				download(httpObject.url);

				currentFolder = oldFolder;
			elseif httpObject.type == "file" then
				local name = httpObject.name;
				local filedata = string.split(name, ".");

				if #filedata < 2 then
					continue
				end

				local filetype = filedata[#filedata];

				if filetype ~= "lua" and filetype ~= "luau" then
					continue;
				end

				local filename = "";
				for i = 1, #filedata - 1 do
					local str = filedata[i];
					filename ..= str;
				end

				local download_url = httpObject.download_url;
				local source = HttpService:GetAsync(download_url);

				local scriptFile = Instance.new("ModuleScript");
				scriptFile.Name = filename;
				scriptFile.Source = source;

				if filename == "init" and (filetype == "lua" or filetype == "luau") then
					scriptFile.Parent = currentFolder.Parent;
					scriptFile.Name = currentFolder.Name;

					for _, v in currentFolder:GetChildren() do
						v.Parent = scriptFile;
					end
					currentFolder:Destroy();
					currentFolder = scriptFile;
				else
					scriptFile.Parent = currentFolder;
				end
			end
		end
	end

	download(request);
end

export type athPackage = typeof(setmetatable({} :: {
	displayName : string?;
	dump : Instance;
	identity : string?;
	athClassName : "athPackage";
}, {} :: typeof(athPackage)));

--[=[
	@within athPackage
	Creates a virtual Package, an identity pointing to some resource in the cloud which needs to be maintained.
	Usually, these are stored on something like GitHub.

	@param athPackageCreateInfo;
	@return athPackage
]=]
function athPackage.new(athPackageCreateInfo : athTypes.athPackageCreateInfo) : athPackage
	local package = setmetatable({
		athClassName = "athPackage";
	}, athPackage);

	local id = athPackageCreateInfo.packageIdentity;
	local autoload = athPackageCreateInfo.autoload;
	local dumpLocation = athPackageCreateInfo.dumpLocation;
	local displayName = athPackageCreateInfo.displayName;

	if displayName then
		package.displayName = displayName;
	end

	if id then
		if not displayName then
			package.displayName = id.packageName;
		end

		package:athSetPackageIdentity(id.packageCourier, id.packageShipper, id.packageName);

		if autoload then
			package:athLoadPackageAsync();
		end
	end

	if dumpLocation then
		package.dump = dumpLocation;
	else
		package.dump = ReplicatedStorage;
	end

	return package;
end

--[=[
	@within athPackage

	Sets the package's identity, an HTTP url describing the resource this package is linked to.
]=]
function athPackage:athSetPackageIdentity(packageCourier, packageShipper, packageName)
	local package : athPackage = self;
	local packageIdentity = MAKE_SHIPPING_DETAILS(packageCourier, packageShipper, packageName);

	package.identity = packageIdentity;
end

--[=[
	@within athPackage
	@yields

	Loads the current package identity into the data model.
]=]
function athPackage:athLoadPackageAsync()
	local package : athPackage = self;

	if package:athGetPackageInstance() then
		package:athUpdatePackageInstance();
	else
		package:athBuildPackageInstance();
	end
end

--[=[
	@within athPackage

	Returns the existing package associated with this package identity, if one is found.
]=]
function athPackage:athGetPackageInstance() : Instance?
	local package : athPackage = self;
	local packageIdentity = package.identity;

	if not packageIdentity then
		return;
	end

	return athPackagesUserStore:athGetPersistentInstanceAsync(packageIdentity);
end

--[=[
	@within athPackage

	Returns the existing package associated with this package identity, if one is found.
]=]
function athPackage:athBuildPackageInstance()
	local package : athPackage = self;
	local packageIdentity = package.identity;
	local packageDump = package.dump;
	local packageDisplayName = package.displayName;

	local packageInstance = Instance.new("Folder");
	if packageDisplayName then
		packageInstance.Name = packageDisplayName;
	else
		packageInstance.Name = packageIdentity;
	end

	athPackagesUserStore:athSetPersistentInstanceAsync(packageIdentity, packageInstance);

	package:athUpdatePackageInstance();

	packageInstance.Parent = packageDump;
end

--[=[
	@within athPackage

	Updates the existing package associated with this package identity.
]=]
function athPackage:athUpdatePackageInstance()
	local package : athPackage = self;
	local packageIdentity = package.identity;

	if not packageIdentity then
		return;
	end

	local packageInstance = athPackagesUserStore:athGetPersistentInstanceAsync(packageIdentity);

	local packageCourier, packageShipper, packageName = GET_SHIPPING_DETAILS(packageIdentity);
	if not packageCourier or not packageShipper or not packageName then
		return;
	end

	if packageCourier == "https://www.github.com/" then
		MAKE_DESCRIPTION_FROM_GITHUB(packageShipper, packageName, packageInstance);
	end
end

return athPackage;