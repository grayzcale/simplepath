## Configuration

The settings below can be accessed directly from the SimplePath modulescript.

<br>

### TIME_VARIANCE
> `Settings.TIME_VARIANCE: number` [default: 0.07]

Represents the minimum time in seconds elapsed between Path.Run calls. The default setting is roughly 14 computations per second. This is necessary to allow the agent the freedom for movement (give the agent some time to reach the next waypoint before computing a new path).

<br>

### COMPARISON_CHECKS
> `Settings.COMPARISON_CHECKS: number` [default: 1]

During pathfinding, in the case where the agent is stationary at the same position for 1 + COMPARISON_CHECKS consecutive Path.Run calls, the agent attempts to avoid the obstruction by jumping. This is necessary in order to prevent the agent from being at rest for infinity (unless otherwise moved by an external object).

<hr>

## ErrorTypes

```lua linenums="1" title="Example"

Path.Error:Connect(function(errorType)
	if errorType == SimplePath.ErrorType.ComputeError then
		--code (1)
	end
end)
```

1. This code block will run whenever there's a ComputeError.

!!! Info
	Use ErrorTypes to determine the type of error received from the Path.Error event. For additional debug options, see [Path.LastError](#lasterror).

<br>

### LimitReached
> `ErrorType.LimitReached: ErrorType and string`

The elapsed time between Path.Run calls is less than Settings.TIME_VARIANCE. For stability purposes, this error is invoked after `Path:Run()` yields for Settings.TIME_VARIANCE.

It is recommended to avoid depending on this ErrorType.

<br>

### TargetUnreachable
> `ErrorType.TargetUnreachable: ErrorType and string`

Target is unreachable.

<br>

### ComputeError
> `ErrorType.ComputeError: ErrorType and string`

Path computation failed.

<hr>

## StatusTypes

Read the [Path.Status](#status) property to get the current Path status.

<br>

### Idle
> `StatusType.Idle: StatusType and string`

Path is in idle state.

<br>

### Active
> `StatusType.Active: StatusType and string`

Path is in active state.

<hr>

## Static Methods

<br>

### GetNearestCharacter

> `<model or nil> SimplePath.GetNearestCharacter(fromPosition: Vector3)` 

Returns a `model` of the nearest character from the provided `Vector3` position or `nil` if no character is found.

<hr>

## Path

<br>

#### Constructor

> `<Path> SimplePath.new(agent: model, agentParameters: Dictionary or nil)`

Creates a new Path object using the `agent` and optional `agentParameters`.
	
!!! Note
	`SimplePath.new()` is a constructor that creates a new Path and it should only be created once per agent. You can call `Path:Run()` on the same Path object multiple times without having to create a new Path every time you need to do pathfinding.

!!! Info
	Use agent parameters for custom characters to compute the best path. Find out more about agent parameters and how to use them at [Roblox Developer Hub](https://developer.roblox.com/en-us/api-reference/function/PathfindingService/CreatePath).

	Refine the path computation further by using pathfinding modifiers. To use this feature with SimplePath, Simply include modifier data in `agentParameters` normally. Find out more about pathfinding modifiers at [Roblox Developer Hub](https://developer.roblox.com/en-us/api-reference/class/PathfindingService).

<hr>

### Properties

<br>

#### Visualize
>`Path.Visualize: boolean` [default: false]

Set this property to `true` before the first `Path:Run()` to visualize waypoints.

<br>

#### Status
>`Path.Status: SimplePath.StatusType` [readonly]

Returns the current [StatusType](#statustypes) of Path.

!!! Note
	This will return `SimplePath.StatusType.Idle` always for non-humanoids since pathfinding for a non-humanoid is meant to be handled manually.

<br>

#### LastError
>`Path.LastError: SimplePath.ErrorType` [readonly]

Returns the last [ErrorType](#errortypes).

<hr>

### Methods

<br>

#### Run
>`<boolean> Path:Run(target: Vector3 or BasePart)`

This method returns `true` if the computation was successful. If it returns `false`, the [Path.Error](#error) event is fired with a ComputeError. This method automatically yields if the elapsed time between consecutive calls is less than Settings.TIME_VARIANCE.

<br>

#### Stop
>`<void> Path:Stop()`

Stops the navigation of the current Path if Path.Status is in an active state and fires the [Path.Stopped](#stopped) event.

!!! Note
	This method cannot be used for non-humanoids since pathfinding is meant to be handled manually.

<br>

#### Destroy
>`<void> Path:Destroy()`

Destroy Path.
<hr>

### Events

<br>

#### Reached
>`<RBXScriptSignal> Path.Reached(agent: model, finalWaypoint: PathWaypoint)`

This event is fired after the `agent` reaches its target and returns the final `PathWaypoint`.

!!! Info
	Find out more about `PathWaypoint` at [Roblox Developer Hub](https://developer.roblox.com/en-us/api-reference/datatype/PathWaypoint).

<br>

#### WaypointReached
>`<RBXScriptSignal> Path.WaypointReached(agent: model, next: PathWaypoint)`

This event is fired every time the next `PathWaypoint` is reached.

!!! Note
	Make use of this event when pathfinding for non-humanoids.

<br>

#### Blocked
>`<RBXScriptSignal> Path.Blocked(agent: model, blocked: PathWaypoint)`

`blocked` is a `PathWaypoint` such that: `currentWaypoint.Index <= blocked.Index <= currentWaypoint.Index + 1`.

<br>

#### Error
>`<RBXScriptSignal> Path.Error(error: ErrorType)`

Fires when an error from any of the [ErrorTypes](#errortypes) occurs.

<br>

#### Stopped
>`<RBXScriptSignal> Path.Stopped(agent: model)`

Fires after `Path:Stop()` is called.

!!! Note
	Just like the Path.Stop method, this event should only be used for humanoids.