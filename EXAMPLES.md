## Humanoid Example

<br>

Change part color after pathfinding ends:
```lua
local Path = SimplePath.new(workspace.Dummy)

Path:Run(workspace.Goal)
Path.Reached:Wait()
workspace.Goal.BrickColor = BrickColor.new("Bright green")

Path:Destroy()
```

<br>

Spam `Path:Run()`:
```lua
local Path = SimplePath.new(workspace.Dummy)
while true do
	Path:Run(workspace.Goal)
	wait()
end
```

<br>

## Non-Humanoid Example

<br>

Change part color after pathfinding ends:
```lua
local Path = SimplePath.new(workspace.PartModel)

Path.Reached:Connect(function(model)
	workspace.Goal.BrickColor = BrickColor.new("Bright green")
end)

Path.WaypointReached:Connect(function(model, previousPosition, nextPosition)
	model:MoveTo(nextPosition)
	wait(0.5)
	Path:Run()
end)

Path:Run(workspace.Goal)
```

<br>

Spam `Path:Run()`:
```lua
local Path = SimplePath.new(workspace.PartModel)

Path.WaypointReached:Connect(function(model, previousPosition, nextPosition)
	model:MoveTo(nextPosition)
end)

while true do
	Path:Run(workspace.Goal)
	wait()
end
```
