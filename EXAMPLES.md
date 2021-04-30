## Humanoid Example

<br>

Change part color after pathfinding ends:
```lua
local Path = SimplePath.new(model) --Create new Path

Path:Run(goal) --Move the humanoid
Path.Reached:Wait() --Wait until Rig reaches the final position
goal.BrickColor = BrickColor.new("Bright green") --Change part color

Path:Destroy() --Destroy Path object after use
```

<br>

Spam `Path:Run()` as the goal position changes:
```lua
local model = workspace:WaitForChild("Dummy") --Get humanoid model
local goal = workspace:WaitForChild("Goal") --Get goal part
local path = SimplePath.new(model) --Create new Path

goal:GetPropertyChangedSignal("Position"):Connect(function()
	path:Run(goal)  --Move the humanoid as the goal position changes
end)
```

<br>

## Non-Humanoid Example

<br>

Change part color after pathfinding ends:
```lua

Path.Reached:Connect(function()
	Goal.BrickColor = BrickColor.new("Bright green") --Change color of goal part when pathfinding ends
end)

--define movement logic using the WaypointReached event
Path.WaypointReached:Connect(function(model, previousPosition, nextPosition)
	model:SetPrimaryPartCFrame(CFrame.new(nextPosition, previousPosition + (nextPosition - previousPosition).Unit * 4)) --Move model to next position facing nextPosition
	wait(0.1) --Some type of wait is required to prevent exhaustion
	path:Run() --Let the Path know movement is done
end)

path:Run(goal) --Move to the goal only once initially
```
