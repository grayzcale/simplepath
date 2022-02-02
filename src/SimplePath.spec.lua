return function()

	local SimplePath = require(game:GetService("ReplicatedStorage").SimplePath)
	local Dummy = workspace.Dummy
	local Goal = workspace.Goal
	local Path

	describe("constructor", function()

		it("creates a new Path with provided character", function()
			expect(SimplePath.new(Dummy)).to.be.ok()
		end)

		it("errors when model is not passed in", function()
			expect(function()
				SimplePath.new()
			end).to.throw()
		end)

		it("errors when PrimaryPart is not set", function()
			expect(function()
				local c = Dummy:Clone()
				c.PrimaryPart = nil
				SimplePath.new(c)
			end).to.throw()
		end)

		it("overrides default settings", function()
			local config = SimplePath.new(Dummy, nil, {
				TIME_VARIANCE = 2;
				COMPARISON_CHECKS = 2;
				JUMP_WHEN_STUCK = false;
			})._settings
			local defaults = {
				TIME_VARIANCE = 0.07;
				COMPARISON_CHECKS = 1;
				JUMP_WHEN_STUCK = true;
			}
			expect(function()
				for i, v in pairs(config) do
					if defaults[i] == v then
						error("Does not override default settings")
					end
				end
			end).never.to.throw()
		end)

	end)

	describe("Path:Run()", function()

		beforeAll(function()
			Path = SimplePath.new(Dummy)
		end)

		it("errors if no valid Vector3 or BasePart is given", function()
			expect(function()
				Path:Run()
			end).to.throw()
		end)

		it("should change Path.Status to StatusType.Active", function()
			expect(Path.Status == SimplePath.StatusType.Active).to.be.ok()
		end)

		it("should return true", function()
			expect(Path:Run(Goal)).to.be.ok()
		end)

	end)
	
	
	describe("Path:Stop()", function()
		beforeAll(function()
			Path:Stop()
		end)
		it("should change Path.Status to StatusType.Idle", function()
			expect(Path.Status == SimplePath.StatusType.Idle).to.be.ok()
		end)
	end)
	
	describe("test", function()
		it("should not produce any ErrorType", function()
			expect(Path.LastError).never.to.be.ok()
		end)
	end)
	
	describe("Path:Destroy()", function()
		beforeAll(function()
			Path:Destroy()
		end)

		it("should destroy Path", function()
			expect(function()
				for k, _ in pairs(Path) do
					error(("Path.%s exists!"):format(k))
				end
			end).never.to.throw()
			expect(getmetatable(Path)).never.to.be.ok()
		end)
	end)

end