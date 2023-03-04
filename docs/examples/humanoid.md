# Humanoid Examples

The following examples is explained in detail [here](../guides/getting-started.md).

<br>

## Using Events

<video width=100% height=100% controls>
    <source style="object-fit: cover;" src="https://wicked-wlzard.github.io/simplepath/assets/humanoid_example_1.mp4" types="video/mp4">
</video>

```lua linenums="1"
--Import the module so you can start using it
local ServerStorage = game:GetService("ServerStorage")
local SimplePath = require(ServerStorage.SimplePath)

--Define npc
local Dummy = workspace.Dummy

-- Define a part called "Goal"
local Goal = workspace.Goal

--Create a new Path using the Dummy
local Path = SimplePath.new(Dummy)

--Helps to visualize the path
Path.Visualize = true

--Compute a new path every time the Dummy reaches the goal part
Path.Reached:Connect(function()
    Path:Run(Goal)
end)

--Dummy knows to compute path again if something blocks the path
Path.Blocked:Connect(function()
    Path:Run(Goal)
end)

--If the position of Goal changes at the next waypoint, compute path again
Path.WaypointReached:Connect(function()
    Path:Run(Goal)
end)

--Dummmy knows to compute path again if an error occurs
Path.Error:Connect(function(errorType)
    Path:Run(Goal)
end)

Path:Run(Goal)
```

<hr>

## Using Loops

```lua linenums="1"
--Import the module so you can start using it
local ServerStorage = game:GetService("ServerStorage")
local SimplePath = require(ServerStorage.SimplePath)

--Define npc
local Dummy = workspace.Dummy

-- Define a part called "Goal"
local Goal = workspace.Goal

--Create a new Path using the Dummy
local Path = SimplePath.new(Dummy)

--Helps to visualize the path
Path.Visualize = true

while true do
    Path:Run(Goal)
end
```
