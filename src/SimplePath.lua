--[[
-------------------------------------------------------------------

Created by: @V3N0M_Z
Reference: https://v3n0m-z.github.io/RBLX-SimplePath/
License: MIT

---------------------------------------------------------------------
]]

local DEFAULT_SETTINGS = {

	TIME_VARIANCE = 0.07;

	COMPARISON_CHECKS = 1;

	JUMP_WHEN_STUCK = true;
}

---------------------------------------------------------------------

local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local function output(func, msg)
	func(((func == error and "SimplePath Error: ") or "SimplePath: ")..msg)
end
local Path = {
	StatusType = {
		Idle = "Idle";
		Active = "Active";
	};
	ErrorType = {
		LimitReached = "LimitReached";
		TargetUnreachable = "TargetUnreachable";
		ComputationError = "ComputationError";
		AgentStuck = "AgentStuck";
	};
}
Path.__index = function(table, index)
	if index == "Stopped" and not table._humanoid then
		output(error, "Attempt to use Path.Stopped on a non-humanoid.")
	end
	return (table._events[index] and table._events[index].Event)
		or (index == "LastError" and table._lastError)
		or (index == "Status" and table._status)
		or Path[index]
end

--Used to visualize waypoints
local visualWaypoint = Instance.new("Part")
visualWaypoint.Size = Vector3.new(0.3, 0.3, 0.3)
visualWaypoint.Anchored = true
visualWaypoint.CanCollide = false
visualWaypoint.Material = Enum.Material.Neon
visualWaypoint.Shape = Enum.PartType.Ball

--[[ PRIVATE FUNCTIONS ]]--
local function declareError(self, errorType)
	self._lastError = errorType
	self._events.Error:Fire(errorType)
end

--Create visual waypoints
local function createVisualWaypoints(waypoints)
	local visualWaypoints = {}
	for _, waypoint in ipairs(waypoints) do
		local visualWaypointClone = visualWaypoint:Clone()
		visualWaypointClone.Position = waypoint.Position
		visualWaypointClone.Parent = workspace
		visualWaypointClone.Color =
			(waypoint == waypoints[#waypoints] and Color3.fromRGB(0, 255, 0))
			or (waypoint.Action == Enum.PathWaypointAction.Jump and Color3.fromRGB(255, 0, 0))
			or Color3.fromRGB(255, 139, 0)
		table.insert(visualWaypoints, visualWaypointClone)
	end
	return visualWaypoints
end

--Destroy visual waypoints
local function destroyVisualWaypoints(waypoints)
	if waypoints then
		for _, waypoint in ipairs(waypoints) do
			waypoint:Destroy()
		end
	end
	return
end

--Get initial waypoint for non-humanoid
local function getNonHumanoidWaypoint(self)
	--Account for multiple waypoints that are sometimes in the same place
	for i = 2, #self._waypoints do
		if (self._waypoints[i].Position - self._waypoints[i - 1].Position).Magnitude > 0.1 then
			return i
		end
	end
	return 2
end

--Make NPC jump
local function setJumpState(self)
	pcall(function()
		if self._humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and self._humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
			self._humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end

--Primary move function
local function move(self)
	if self._waypoints[self._currentWaypoint].Action == Enum.PathWaypointAction.Jump then
		setJumpState(self)
	end
	self._humanoid:MoveTo(self._waypoints[self._currentWaypoint].Position)
end

--Disconnect MoveToFinished connection when pathfinding ends
local function disconnectMoveConnection(self)
	self._moveConnection:Disconnect()
	self._moveConnection = nil
end

--Fire the WaypointReached event
local function invokeWaypointReached(self)
	local lastWaypoint = self._waypoints[self._currentWaypoint - 1]
	local nextWaypoint = self._waypoints[self._currentWaypoint]
	self._events.WaypointReached:Fire(self._agent, lastWaypoint, nextWaypoint)
end

local function moveToFinished(self, reached)
	
	--Stop execution if Path is destroyed
	if not getmetatable(self) then return end

	--Handle case for non-humanoids
	if not self._humanoid then
		if reached and self._currentWaypoint + 1 <= #self._waypoints then
			invokeWaypointReached(self)
			self._currentWaypoint += 1
		elseif reached then
			self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
			self._target = nil
			self._events.Reached:Fire(self._agent, self._waypoints[self._currentWaypoint])
		else
			self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
			self._target = nil
			declareError(self, self.ErrorType.TargetUnreachable)
		end
		return
	end

	if reached and self._currentWaypoint + 1 <= #self._waypoints  then --Waypoint reached
		if self._currentWaypoint + 1 < #self._waypoints then
			invokeWaypointReached(self)
		end
		self._currentWaypoint += 1
		move(self)
	elseif reached then --Target reached, pathfinding ends
		disconnectMoveConnection(self)
		self._status = Path.StatusType.Idle
		self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
		self._events.Reached:Fire(self._agent, self._waypoints[self._currentWaypoint])
	else --Target unreachable
		disconnectMoveConnection(self)
		self._status = Path.StatusType.Idle
		self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
		declareError(self, self.ErrorType.TargetUnreachable)
	end
end

--Refer to Settings.COMPARISON_CHECKS
local function comparePosition(self)
	if self._currentWaypoint == #self._waypoints then return end
	self._position._count = ((self._agent.PrimaryPart.Position - self._position._last).Magnitude <= 0.07 and (self._position._count + 1)) or 0
	self._position._last = self._agent.PrimaryPart.Position
	if self._position._count >= self._settings.COMPARISON_CHECKS then
		if self._settings.JUMP_WHEN_STUCK then
			setJumpState(self)
		end
		declareError(self, self.ErrorType.AgentStuck)
	end
end

--[[ STATIC METHODS ]]--
function Path.GetNearestCharacter(fromPosition)
	local character, dist = nil, math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character and (player.Character.PrimaryPart.Position - fromPosition).Magnitude < dist then
			character, dist = player.Character, (player.Character.PrimaryPart.Position - fromPosition).Magnitude
		end
	end
	return character
end

--[[ CONSTRUCTOR ]]--
function Path.new(agent, agentParameters, override)
	if not (agent and agent:IsA("Model") and agent.PrimaryPart) then
		output(error, "Pathfinding agent must be a valid Model Instance with a set PrimaryPart.")
	end

	local self = setmetatable({
		_settings = override or DEFAULT_SETTINGS;
		_events = {
			Reached = Instance.new("BindableEvent");
			WaypointReached = Instance.new("BindableEvent");
			Blocked = Instance.new("BindableEvent");
			Error = Instance.new("BindableEvent");
			Stopped = Instance.new("BindableEvent");
		};
		_agent = agent;
		_humanoid = agent:FindFirstChildOfClass("Humanoid");
		_path = PathfindingService:CreatePath(agentParameters);
		_status = "Idle";
		_t = 0;
		_position = {
			_last = Vector3.new();
			_count = 0;
		};
	}, Path)

	--Configure settings
	for setting, value in pairs(DEFAULT_SETTINGS) do
		self._settings[setting] = self._settings[setting] == nil and value or self._settings[setting]
	end

	--Path blocked connection
	self._path.Blocked:Connect(function(...)
		if (self._currentWaypoint <= ... and self._currentWaypoint + 1 >= ...) and self._humanoid then
			setJumpState(self)
			self._events.Blocked:Fire(self._agent, self._waypoints[...])
		end
	end)

	return self
end


--[[ NON-STATIC METHODS ]]--
function Path:Destroy()
	for _, event in ipairs(self._events) do
		event:Destroy()
	end
	self._events = nil
	if rawget(self, "_visualWaypoints") then
		self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
	end
	self._path:Destroy()
	setmetatable(self, nil)
	for k, _ in pairs(self) do
		self[k] = nil
	end
end

function Path:Stop()
	if not self._humanoid then
		output(error, "Attempt to call Path:Stop() on a non-humanoid.")
		return
	end
	if self._status == Path.StatusType.Idle then
		output(function(m)
			warn(debug.traceback(m))
		end, "Attempt to run Path:Stop() in idle state")
		return
	end
	disconnectMoveConnection(self)
	self._status = Path.StatusType.Idle
	self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
	self._events.Stopped:Fire(self._model)
end

function Path:Run(target)

	--Non-humanoid handle case
	if not target and not self._humanoid and self._target then
		moveToFinished(self, true)
		return
	end

	--Parameter check
	if not (target and (typeof(target) == "Vector3" or target:IsA("BasePart"))) then
		output(error, "Pathfinding target must be a valid Vector3 or BasePart.")
	end

	--Refer to Settings.TIME_VARIANCE
	if os.clock() - self._t <= self._settings.TIME_VARIANCE and self._humanoid then
		task.wait(os.clock() - self._t)
		declareError(self, self.ErrorType.LimitReached)
		return false
	elseif self._humanoid then
		self._t = os.clock()
	end

	--Compute path
	local pathComputed, _ = pcall(function()
		self._path:ComputeAsync(self._agent.PrimaryPart.Position, (typeof(target) == "Vector3" and target) or target.Position)
	end)

	--Make sure path computation is successful
	if not pathComputed
		or self._path.Status == Enum.PathStatus.NoPath
		or #self._path:GetWaypoints() < 2
		or (self._humanoid and self._humanoid:GetState() == Enum.HumanoidStateType.Freefall) then
		self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
		task.wait()
		declareError(self, self.ErrorType.ComputationError)
		return false
	end

	--Set status to active; pathfinding starts
	self._status = (self._humanoid and Path.StatusType.Active) or Path.StatusType.Idle
	self._target = target

	--Set network owner to server to prevent "hops"
	pcall(function()
		self._agent.PrimaryPart:SetNetworkOwner(nil)
	end)

	--Initialize waypoints
	self._waypoints = self._path:GetWaypoints()
	self._currentWaypoint = 2

	--Refer to Settings.COMPARISON_CHECKS
	if self._humanoid then
		comparePosition(self)
	end

	--Visualize waypoints
	destroyVisualWaypoints(self._visualWaypoints)
	self._visualWaypoints = (self.Visualize and createVisualWaypoints(self._waypoints))

	--Create a new move connection if it doesn't exist already
	self._moveConnection = self._humanoid and (self._moveConnection or self._humanoid.MoveToFinished:Connect(function(...)
		moveToFinished(self, ...)
	end))

	--Begin pathfinding
	if self._humanoid then
		self._humanoid:MoveTo(self._waypoints[self._currentWaypoint].Position)
	elseif #self._waypoints == 2 then
		self._target = nil
		self._visualWaypoints = destroyVisualWaypoints(self._visualWaypoints)
		self._events.Reached:Fire(self._agent, self._waypoints[2])
	else
		self._currentWaypoint = getNonHumanoidWaypoint(self)
		moveToFinished(self, true)
	end
	return true
end

return Path