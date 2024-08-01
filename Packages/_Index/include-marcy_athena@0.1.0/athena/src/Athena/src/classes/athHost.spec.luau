-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

return function ()
	local athHostClass = require(script.Parent.athHost);

	describe("athHost", function ()
		--@example.sln.luau
		local athHost = athHostClass.new();
		local exampleProject;

		it("should be an athHost", function()
			expect(athHost.athClassName).to.equal("athHost");
		end);

		it ("should host a project for a library developer", function ()
			exampleProject = athHost:athHostProject();
		end);

		it ("should expose configuration of a project to the library developer", function ()
			local projectSettings = {
				buildMode = "debug";
			};

			exampleProject:athSetProjectSettings(projectSettings);
		end);

		it ("should allow quick solution deployment for a client", function ()
			local solution = {}; -- stored in solution file like example.sln.luau

			exampleProject = athHost:athRun(solution);
		end);

		it ("should allow decomposition of a project for a client", function ()
			athHost:athDecomposeProject(exampleProject);
		end);

		it ("should facilitate access to the project and its components", function ()
			local fooTypes = exampleProject.types();
			local fooClasses = exampleProject.classes();
			local fooSingleton = exampleProject.singleton("foo");
			local fooTokens = exampleProject.tokens();

			expect(fooTypes).to.be.a("table");
			expect(fooClasses).to.be.a("table");
			expect(fooSingleton).to.be.a("table");
			expect(fooTokens).to.be.a("table");
		end);

		it ("should provide complete overview of the project and the performance of individual components", function ()
			local fooBench = exampleProject.bench();
			local fooAccountant = exampleProject.accountant();

			expect(fooBench).to.be.a("table");
			expect(fooAccountant).to.be.a("table");
		end);

		it ("should allow for build modes", function()
			local fooBuildMode = exampleProject.buildMode();

			expect(fooBuildMode).to.be.a("string");
			expect(fooBuildMode).to.equal("debug");
		end);
	end);
end