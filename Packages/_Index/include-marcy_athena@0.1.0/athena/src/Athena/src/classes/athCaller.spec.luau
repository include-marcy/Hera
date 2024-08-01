-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

return function ()
	local ath = script.Parent.Parent;
	local athCallerClass = require(ath.classes.athCaller);

	describe("athCaller", function()
		local athCaller = athCallerClass.new();

		it("should be a an athCaller", function()
			expect(athCaller.athClassName).to.equal("athCaller");
		end);

		local super = {};

		function super:_superDoInternal()

		end

		it("should allow callbacks to be safely called", function()
			expect(function()
				athCaller:athCall(super._superDoInternal, super);
			end).never.to.throw();
		end);
	end);
end