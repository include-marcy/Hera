-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

return function ()
	local athSignal = require(script.Parent.athSignal);

	describe("athSignal", function()
		local signal = athSignal.new();

		it("should be a signal", function()
			expect(signal.athClassName).to.equal("athSignal");
		end);

		it("should let anybody listen to it", function()
			signal:Connect(function()
				print("fired!");
			end);
		end);

		it("should be able to send out its signal", function()
			signal:Fire();
		end);

		it("should have some useful shorthands", function()
			signal:Once(function()
				print("once, before disconnecting itself!");
			end);
		end);
	end);
end