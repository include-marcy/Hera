-- This file is part of the Athena library and is licensed under MIT License; see LICENSE.md for details

return function ()
    local athToken = require(script.Parent.athToken);
    local athTypes = require(script.Parent.Parent.lib.athTypes);

    describe("athToken", function()
        local athTokenCreateInfo : athTypes.athTokenCreateInfo = {
            name = "buildMode";
            value = "debug";
        };
        local token = athToken.new(athTokenCreateInfo);

        it("should be an athToken", function()
            expect(athToken.athClassName).to.equal("athToken");
        end);

        it("should be immutable", function()
            expect(function()
                token.value = "production";
            end).to.throw("ath error: attempt to mutate athToken");
        end);

        it("should be readable", function()
            expect(token.value).to.equal("debug");
        end);

        it("should belong to an athLibrary object", function()
            
        end);
    end)
end