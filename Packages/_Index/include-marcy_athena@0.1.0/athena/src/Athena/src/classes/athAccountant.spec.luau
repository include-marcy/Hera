-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

return function ()
    local athAccountantClass = require(script.Parent.athAccountant);
    local athBenchClass = require(script.Parent.athBench);
    local athTypes = require(script.Parent.Parent.lib.athTypes);

    describe("athAccountant", function()
        local athAccountant = athAccountantClass.new();
        local athBench = athBenchClass.new();

        it("should be an athAccountant", function()
            expect(athAccountant.athClassName).to.equal("athAccountant");
        end);

        it("should accurately approximate the performance cost of individual files in the experience", function()
            local accountantTest = {};

            function accountantTest:athFoo()

            end

            local athPerformanceRatingDiagnosticInfo : athTypes.athPerformanceRatingDiagnosticInfo = {
                patient = accountantTest;
                diagnose = {
                    "athFoo";
                };
                athBench = athBench;
            };

            local athPerformanceRating = athAccountant:athRatePerformance(athPerformanceRatingDiagnosticInfo);

            expect(athPerformanceRating).to.be.a("table");
            expect(athPerformanceRating.performance).to.be.a("number"); -- percentage
            expect(athPerformanceRating.performance <= 100).to.equal(true);
            expect(athPerformanceRating.performance > 0).to.equal(true);
        end);

        it("should be able to award a performance approval for a variety of levels", function()
            local performanceA = 25;
            local performanceB = 100;

            local athPerformanceMedalA : athTypes.athPerformanceMedal = athAccountant:athGetMedal(performanceA);
            local athPerformanceMedalB : athTypes.athPerformanceMedal = athAccountant:athGetMedal(performanceB);

            print(athPerformanceMedalA);
            print(athPerformanceMedalB);
        end);

        it("should output the highest offenders of performance cost in the experience", function()
            
        end);

        it("should collaborate with the athBench to obtain the performance diagnostic", function()
        
        end);
    end);
end