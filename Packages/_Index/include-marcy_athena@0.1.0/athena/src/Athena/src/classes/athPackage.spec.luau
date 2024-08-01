-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

--!strict
--!native
--!optimize 2

-- Test athPackage
return function ()
	local athPackage = require(script.Parent.athPackage);
	local athTypes = require(script.Parent.Parent.lib.athTypes);

	describe("athPackage", function()
		local athPackageCreateInfo : athTypes.athPackageCreateInfo = {
			autoload = false;
			displayName = "Athena";
			packageIdentity = {
				packageCourier = "https://www.github.com/";
				packageShipper = "include-marcy";
				packageName = "Athena";
			};
		};
		local package : athPackage.athPackage = athPackage.new(athPackageCreateInfo);

		it("should be an athPackage", function()
			expect(athPackage.athClassName).to.equal("athPackage");
		end);

		it("should be able to download cloud package resources", function()
			package:athLoadPackageAsync();

			local cloudResource = package:athGetPackageInstance();
			print(package.displayName, "| PACKAGE DOWNLOADED | ", cloudResource);
		end);
	end);
end