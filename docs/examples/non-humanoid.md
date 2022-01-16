# Non-Humanoid Examples

Handling pathfinding for non-humanoid models can get tricky to handle. Consider converting your non-humanoid model to a humanoid if possible.

## Example 1

<video width=100% height=100% controls>
    <source style="object-fit: cover;" src="https://00xima.github.io/RBLX-SimplePath/assets/non_humanoid_example_1.mp4" types="video/mp4">
</video>

```lua linenums="1"
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local SimplePath = require(ServerStorage.SimplePath)

local Model = workspace.Model
local Goal = workspace.Goal
local Path = SimplePath.new(Model)

local function tween(part, destination)
	local tweenBase = TweenService:Create(part, TweenInfo.new(0.07), {Position = destination + Vector3.new(0, 0.5, 0)})
	tweenBase:Play()
	tweenBase.Completed:Wait()
end

Path.Visualize = true

--Tween model to final waypoint when reached
Path.Reached:Connect(function(model, finalWaypoint)
	tween(model.PrimaryPart, finalWaypoint.Position)
end)

--Call Path:Run() at the end of the event to indicate the end of movement for the current waypoint
Path.WaypointReached:Connect(function(model, lastWaypoint, nextWaypoint)
	tween(model.PrimaryPart, nextWaypoint.Position)
	Path:Run()
end)

Path:Run(Goal)
```

## Example 2

<video width=100% height=100% controls>
    <source style="object-fit: cover;" src="https://00xima.github.io/RBLX-SimplePath/assets/non_humanoid_example_2.mp4" types="video/mp4">
</video>

```lua linenums="1"
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local SimplePath = require(ServerStorage.SimplePath)

local Model = workspace.Model
local Goal = workspace.Goal
local Path = SimplePath.new(Model)

local function tween(part, destination)
	local tweenBase = TweenService:Create(part, TweenInfo.new(0.07), {Position = destination + Vector3.new(0, 0.5, 0)})
	tweenBase:Play()
	tweenBase.Completed:Wait()
end

Path.Visualize = true

--If the path is blocked
Path.Blocked:Connect(function()
	Path:Run(Goal)
end)

--In case of an error
Path.Error:Connect(function()
	Path:Run(Goal)
end)

Path.Reached:Connect(function(model, finalWaypoint)
	tween(model.PrimaryPart, finalWaypoint.Position)
	Path:Run(Goal)
end)

Path.WaypointReached:Connect(function(model, lastWaypoint, nextWaypoint)
	tween(model.PrimaryPart, nextWaypoint.Position)
	Path:Run(Goal)
end)

Path:Run(Goal)
```

## Example 3

<video width=100% height=100% controls>
    <source style="object-fit: cover;" src="https://00xima.github.io/RBLX-SimplePath/assets/non_humanoid_example_3.mp4" types="video/mp4">
</video>


```lua linenums="1"
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local SimplePath = require(ServerStorage.SimplePath)

local Model = workspace.Model
local Goal = workspace.Goal
local Path = SimplePath.new(Model)

Path.Visualize = true

Path.Reached:Connect(function(model, finalWaypoint)
	model.PrimaryPart.Position = finalWaypoint.Position + Vector3.new(0, 0.5, 1)
end)

Path.WaypointReached:Connect(function(model, lastWaypoint, nextWaypoint)
	model.PrimaryPart.Position = nextWaypoint.Position + Vector3.new(0, 0.5, 1)
end)

while true do
	Path:Run(Goal)
	task.wait()
end
```