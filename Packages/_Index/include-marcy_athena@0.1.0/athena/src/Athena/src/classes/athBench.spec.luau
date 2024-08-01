-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

return function ()
	local ath = script.Parent.Parent;
	local athBenchClass = require(ath.classes.athBench);
	local athTypes = require(ath.lib.athTypes);

	describe("athBench", function()
		local athBench = athBenchClass.new();

		it("should be an athBench", function()
			expect(athBench.athClassName).to.equal("athBench");
		end);

		it("should return the average network usage of the provided payload with the provided avg. time per request", function()
			local payload = {
				foo = buffer.create(16);
			};
			local athNetworkUsageResult = athBench:athNetworkUsage(payload, 5);
			expect(athNetworkUsageResult).to.be.ok();
		end);

		it("should create an object that can be used to signal the frequency of the provided function", function()
			local callback = function()
				print(5 + 5);
			end;
			local athFrequencyHook = athBench:athMakeFrequencyHook("name", callback);
			expect(athFrequencyHook).to.be.a("function");

			athFrequencyHook();
		end);

		it("should be able to tell us how frequently a function is called", function()
			local count = athBench:athGetFrequency("name");

			expect(count).to.be.a("number");
			expect(count).never.to.equal(nil);
		end);

		it("should allow libraries to build tokens to signal to Athena immutable information about the library", function()
			athBench:athMakeToken("production", false);
			athBench:athMakeToken("doExampleFFlag", true);

			expect(athBench:athGetToken("production")).to.equal(false);
			expect(athBench:athGetToken("doExampleFFlag")).to.equal(true);

			expect(function()
				athBench:athGetToken("production"):athSetValue(true);
			end).to.throw("attempt to mutate a token!");
		end);

		it("should allow libraries to profile and log events", function()
			local athEventStopwatch = athBench:athMakeStopwatch("data");
			--.. do some work...
			task.wait(5);
			--.. maybe do some more...
			athEventStopwatch:athClick();

			expect(athEventStopwatch:athGetTime()).to.be.a("number");
			expect(athEventStopwatch:athGetTime()).to.be.near(5);
			expect(athEventStopwatch:athGetName()).to.equal("data");
			expect(athEventStopwatch:athGetState()).to.equal(true);
		end);

		it("should allow libraries to author entries to a game biography", function()
			local athAuthor = athBench:athMakeAuthor("heimdall");

			athAuthor:athLog("intialized Heimdall framework successfully!");
		end);

		it("should be capable of outputting debug information about a library at large", function()
			local athDebugDump = athBench:athGetDebugDump();

			expect(athDebugDump.errors).never.to.equal(nil);
			expect(athDebugDump.profiling).never.to.equal(nil);
			expect(athDebugDump.tokens).to.be.a(typeof({
				athTypes.athToken;
			}));
			expect(athDebugDump.biography).never.to.equal(nil);
		end);

		it("should be capable of authoring an error dump", function()
			local athDebugDump = athBench:athGetDebugDump();

			expect(#athDebugDump.errors >= 0).to.equal(true);

			if #athDebugDump.errors > 0 then
				expect(athDebugDump.errors[1]).to.be.a("string");
			end
		end);

		it("should be capable of authoring a profile dump", function()
			local athDebugDump = athBench:athGetDebugDump();

			expect(#athDebugDump.profile >= 0).to.equal(true);

			if #athDebugDump.profile > 0 then
				local profilinginfo = athDebugDump.profile[1];
				expect(profilinginfo).to.be.a("table");

				expect(profilinginfo.name).to.be.a("string");
				expect(profilinginfo.type).to.be.a("string");
				expect(profilinginfo.performanceRating).to.be.a("number");
				expect(profilinginfo.worklog).to.be.a("table");
			end
		end);

		it("should be capable of authoring the tokens present in the game", function()
			local athDebugDump = athBench:athGetDebugDump();

			expect(#athDebugDump.tokens >= 0).to.equal(true);

			if #athDebugDump.tokens > 0 then
				local token = athDebugDump.tokens[1];

				expect(typeof(token) == athTypes.athToken).to.equal(true);
			end
		end);

		it("should be able to provide an authored biography of the game with its metadata", function()
			local athDebugDump = athBench:athGetDebugDump();

			expect(#athDebugDump.biography >= 0).to.equal(true);

			if #athDebugDump.biography > 0 then
				local log = athDebugDump.biography[1];

				expect(log.entry).to.be.a("string");
				expect(log.timestamp).to.be.a("string");
				expect(log.author).to.be.a("string");
			end
		end);

		it("should be able to hide away when in production mode", function()
			local production = athBench:athReadToken("production");

			function athBench:athFoo()
				print("I'm going to be benchmarked when outside of production mode!");
			end

			if production then
				athBench:athFoo();
			else
				local athFrequencyHook = athBench:athMakeFrequencyHook(athBench.athFoo, athBench);
				athFrequencyHook();
			end
		end);
	end);
end