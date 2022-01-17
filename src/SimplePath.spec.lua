return function()
	
	local SimplePath = require(game:GetService("ReplicatedStorage").SimplePath)
	local Dummy = workspace.Dummy
	local Goal = workspace.Goal
	local Path = SimplePath.new(Dummy)
	
	-- selene: allow(unused_variable)
	local reached, errored, stopped
	local waypointsReached = 0
	
	Path.Reached:Connect(function()
		reached = true
	end)
	
	Path.Error:Connect(function()
		errored = true
	end)
	
	Path.WaypointReached:Connect(function()
		waypointsReached += 1
	end)
	
	Path.Stopped:Connect(function()
		stopped = true
	end)
	
	local function reset()
		Dummy.PrimaryPart.CFrame = CFrame.new(0, 3, 0)
	end
	
	local function getCount(t)
		local c = 0
		for _, _ in pairs(t) do
			c += 1
		end
		return c
	end
	
	describe("Path:Run()", function()

		local t
		
		beforeAll(function()
			t = os.time()
		end)
		
		afterAll(function()
			reset()
		end)
		
		it("should start pathfinding without errors", function()
			expect(Path:Run(Goal)).to.be.ok()
		end)
		
		it("should change state to active when pathfinding", function()
			Path:Run(Goal)
			expect(Path.Status).to.equal(SimplePath.StatusType.Active)
		end)
		
		it("should fire Path.Reached after reaching goal", function()
			repeat
				task.wait()
			until reached or os.difftime(os.time(), t) > 4
			print("Position: ", t, Dummy.PrimaryPart.Position)
			expect(reached).to.be.ok()
		end)
		
		-- it("should reach all the waypoints to goal", function()
		-- 	print("Total Waypoints: ", waypointsReached)
		-- 	expect(waypointsReached).to.equal(7)
		-- end)
		
	end)
	
	describe("Path:Stop()", function()
		
		local midPos
		
		beforeAll(function()
			Path:Run(Goal)
			task.wait(1)
			Path:Stop()
			task.wait(1)
			midPos = Dummy.PrimaryPart.Position
			task.wait(1)
		end)
		
		it("should stop pathfinding", function()
			expect(midPos).to.equal(Dummy.PrimaryPart.Position)
		end)
		
		it("should fire Path.Stopped", function()
			expect(stopped).to.be.ok()
		end)
		
		it("should change state back to idle", function()
			expect(Path.Status).to.equal(SimplePath.StatusType.Idle)
		end)
		
	end)
	
	describe("Path:Destroy()", function()
		
		it("should destroy Path", function()
			Path:Destroy()
			expect(getCount(Path)).to.equal(0)
		end)
		
	end)
	
end