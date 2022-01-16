This tutorial shows you how you can set up SimplePath and teaches you a basic implementation of the module.

## Installation

Get the module from the [Roblox library](https://www.roblox.com/library/6744337775/SimplePath-Pathfinding-Module).

!!! Note
	For the purposes of the tutorial, the script assumes the module is in `game.ServerStorage`.

After you insert the module to your place, add a new script to `game.ServerScriptService` and paste the folowing code to start using the module:

```lua
--Import the module so you can start using it
local ServerStorage = game:GetService("ServerStorage")
local SimplePath = require(ServerStorage.SimplePath)
```


The next part of the code defines all of the different variables that will be used in the script:


```lua
--Define npc
local Dummy = workspace.Dummy

--Define a part called "Goal"
local Goal = workspace.Goal

--Create a new Path using the Dummy
local Path = SimplePath.new(Dummy)
```

!!! Note
	`SimplePath.new()` is a constructor that creates a new Path and it should only be created once per agent. You can call `Path:Run()` on the same Path object multiple times without having to create a new Path every time you need to do pathfinding.

<hr>

## Method 1: Using Events

The following part of the tutorial shows you how you can make a pathfinding script using only events. 

To make the Dummy move towards the goal, you only need one line of code:
```lua
Path:Run(Goal)
```

Even though this single line of code seems sufficient, there are a few important things to keep in mind. Firstly, if some object comes in-between the path of the Dummy, the Dummy will just stop pathfinding before reaching the goal because `Path:Run()` is not called a second time to compute the path again. To fix this, you can use the `Path.Blocked` event and call `Path:Run()` whenever something blocks the path:

```lua
--Dummy knows to compute path again if something blocks the path
Path.Blocked:Connect(function()
    Path:Run(Goal)
end)
```

The next thing to keep in mind is the position of the goal part. In the case where the goal part is constantly moving, how can you alter the current path of Dummy to make sure that it reaches the exact position of the goal part? You can do this by adding in 2 more events. 

The `Path.WaypointReached` event will compute a new Path everytime the Dummy reaches the next waypoint and accounts for a new position of the goal part if it changed.

```lua
--If the position of Goal changes at the next waypoint, compute path again
Path.WaypointReached:Connect(function()
    Path:Run(Goal)
end)
```

The second event is `Path.Error`. You can compute a new path every time the target becomes unreachable or the path to the goal is not traversable. For example, if the part is floating in the sky, the Dummy would not be able to reach it and `Path.Error` fires.

```lua
--Dummmy knows to compute path again if an error occurs
Path.Error:Connect(function(errorType)
    Path:Run(Goal)
end)
```

Your code should look something like this after adding everything in:

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

<video width=100% height=100% controls>
    <source style="object-fit: cover;" src="/docs/assets/humanoid_example_1.mp4" types="video/mp4">
</video>

!!! Info
	Set `Path.Visualize` to `true` before the very first `Path:Run()` call to see the waypoints.

As you can see, the Dummy stops pathfinding after reaching the goal. If you want the Dummy to always follow the goal part even after reaching it, you can simply use the `Path.Reached` event:


```lua
--Compute a new path every time the Dummy reaches the goal part
Path.Reached:Connect(function()
    Path:Run(Goal)
end)
```

<hr>

## Method 2: Using Loops

In the following tutorial, you will learn how to use SimplePath using loops instead of events. Using SimplePath in a loop is way simpler than using events. You only need 3 lines of code:

```lua
while true do
    Path:Run(Goal)
end
```

`Path:Run()` does not require a wait because it automatically yields if the maximum time elapsed between consecutive calls are less than `Settings.TIME_VARIANCE`.

If you are using loops, your final code should look something like this:

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

<hr>

## Choosing a method

SimplePath gives you the freedom to code in any method you prefer. You are not limited to the two methods mentioned in this tutorial as they are simply meant to be examples. You can even combine both methods and implement them together at once. It all depends on how you decide to structure your code based on the performance, compatibility, etc. and personal preference.