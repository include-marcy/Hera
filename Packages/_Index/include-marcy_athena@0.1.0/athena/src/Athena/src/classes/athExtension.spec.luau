-- This file is part of the Athena library and is licensed under GNU GENERAL PUBLIC LICENSE v3.0; see LICENSE.md for details

return function ()
	local ath = script.Parent.Parent;
	local athExtension = require(ath.classes.athExtension);
	local athTypes = require(ath.lib.athTypes);

	describe("athExtension", function()
		local extensionCreateInfo : athTypes.athExtensionCreateInfo = {
			name = "debugExtension";
			icon = "rbxassetid://1";
			description = "a debug extension";
		};
		--// If we supplied a gui argument to the create info we would also have a gui pop up
		--// Which has presupplied events that close this extension.
		local extension = athExtension.new(extensionCreateInfo);

		it("should be an extension", function()
			expect(extension.athClassName).to.equal("athExtension");
		end);

		it("should be able to load at the request of the extension creator", function()
			extension:athLoadExtension();
		end);

		it("should be able to close at the request of the extension creator", function()
			--// The extension can also close for various other reasons automatically at any time.
			extension:athCloseExtension();
		end);

		it("should have exposed lifetime events", function()
			extension:athBindToExtensionLoaded(function()
				print("extension loaded!");
			end);
			extension:athBindToExtensionClosed(function()
				print("extension closed!");
			end);
		end);

		it("should be able to play sounds", function()
			extension:athPlaySound({
				SoundId = "rbxassetid://1";
				Volume = 1;
			})
		end);
	end);
end