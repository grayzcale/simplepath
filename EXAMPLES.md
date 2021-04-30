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

