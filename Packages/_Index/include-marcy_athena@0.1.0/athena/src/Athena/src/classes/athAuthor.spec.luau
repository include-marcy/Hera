-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

return function ()
	local ath = script.Parent.Parent;
	local athAuthor = require(ath.classes.athAuthor);
	local athTypes = require(ath.lib.athTypes);

	describe("athAuthor", function()
		local athAuthorCreateInfo : athTypes.athAuthorCreateInfo = {
			name = "debug";
			mode = "ATH_LOG_MODE_LOUD";
		};
		local author = athAuthor.new(athAuthorCreateInfo);

		it("should be an athAuthor", function()
			expect(athAuthor.athClassName).to.equal("athAuthor");
		end);

		it("should be able to write information", function()
			author:athLog("Hello from TestEZ.");
		end);

		it("should accept custom log layering information", function()
			author:athAddLogLayer({
				transform = function(message) : string
					local timeDateString = os.date("%c");
					return `{timeDateString} :: {message}`;
				end;
			});

			local loggedMessage = author:athLog("Hello from TestEZ.");
			expect(loggedMessage).to.never.equal("Hello from TestEZ."); -- because our log layer transformed it.
		end);
	end);
end