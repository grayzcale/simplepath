local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

local SimplePath = {
	Status = {
		PathNotFound = "PathNotFound";
		PathCompleted = "PathCompleted";
		PathChanged = "PathChanged";
		PathTimeout = "PathTimeout";
	};
}
SimplePath.__index = function(tab, index)
	return (tab._signals[index] and tab._signals[index].Event) or SimplePath[index]
end

local function Move(self)
	if self._active then
		if self._humanoid then
			self._humanoid:MoveTo(self._waypoints[self._waypoint].Position)
		end
	end
	return true
end

local function WaypointReached(self, reached)
	if reached and self._waypoint < #self._waypoints then
		self._waypoint += 1
		Move(self)
	else
		self._signals.Reached:Fire()
		self:Stop(self.Status.PathCompleted)
	end
end

local function CleanWaypoints(self, newWaypoints, finalPosition)
	local cleanedWaypoints = {}
	for _, waypoint in ipairs(newWaypoints) do
		local angle = math.deg(math.acos((finalPosition - self._model.PrimaryPart.Position).Unit:Dot((waypoint.Position - self._model.PrimaryPart.Position).Unit)))
		if angle < 150 then
			table.insert(cleanedWaypoints, #cleanedWaypoints + 1, waypoint)
		end
	end
	return cleanedWaypoints
end

function SimplePath.new(model, agentParameters)
	
	assert((model:IsA("Model") and true) or false, "Model must be a valid 'Model' Instance")
	assert(model:IsA("Model") and model.PrimaryPart, "Model must have a PrimaryPart")
	
	local self = setmetatable({
		_signals = {
			Reached = Instance.new("BindableEvent");
			Blocked = Instance.new("BindableEvent");
			WaypointReached = Instance.new("BindableEvent");
			Stopped = Instance.new("BindableEvent");
		};
		_model = model;
		_path = PathfindingService:CreatePath(agentParameters);
		_humanoid = model:FindFirstChildOfClass("Humanoid");
	}, SimplePath)
	
	if self._humanoid then
		self._connections = {self._humanoid.MoveToFinished:Connect(function(reached)
			self._signals.WaypointReached:Fire(reached)
			self._elapsed = tick()
			return (self._active and WaypointReached(self, reached)) or nil
		end);
		}
	end
	
	return self
end

function SimplePath:Stop(status)
	self._signals.Stopped:Fire(status)
	self._active = false
	self._elapsed = false
end

function SimplePath:Run(goal)
	
	assert(((goal:IsA("BasePart") or typeof(goal) == "Vector3") and true) or false, "Goal must be a valid BasePart or a Vector3 position")
	
	local initialPosition = self._model.PrimaryPart.Position
	local finalPosition = (goal:IsA("BasePart") and goal.Position) or goal
	self._final = finalPosition
	local success, msg = pcall(function()
		self._path:ComputeAsync(initialPosition, finalPosition)
	end)
	if not success or self._path.Status == Enum.PathStatus.NoPath or not self._path:GetWaypoints() or #self._path:GetWaypoints() == 0 then
		self:Stop(self.Status.PathNotFound)
		return false
	end
	
	self._waypoints = (self._active and CleanWaypoints(self, self._path:GetWaypoints(), finalPosition)) or self._path:GetWaypoints()
	self._waypoint = 1
	if not self._active then
		self._active = true
		
		coroutine.wrap(function()
			while self._active do
				if self._elapsed and tick() - self._elapsed > 1 then
					self:Stop(self.Status.PathTimeout)
					self._humanoid.Jump = true
					self:Run(goal)
					break
				end
				RunService.Stepped:Wait()
			end
		end)()
		
		return Move(self)
	end
	
end

return SimplePath