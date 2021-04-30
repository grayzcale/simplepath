![](https://img.shields.io/badge/Version-1.0-success?style=for-the-badge)

# SimplePath - Pathfinding Module

The SimplePath module gives you the ability to create a pathfinding script quickly with the shortest amount of code; pathfinding on this module is done using the methods from  [PathfindingService](https://developer.roblox.com/en-us/api-reference/class/PathfindingService).
<br>

>Get SimplePath from the [Roblox library](https://www.roblox.com/library/6744337775/SimplePath-Pathfinding-Module)

## API

#### Constructor:
|*`Path`* SimplePath.new(*`Model model`*, *`[Optional] Dictionary agentParamters`*)|
|:-|
|● *Creates a new Path* <br> ● *`model` must by a Model Instance with a PrimaryPart* <br> ● *Click [here][agentParametersLink] to find out more about `agentParameters` (may be required for custom humanoids)*|

### Path:

#### Properties:
|*`boolean`* Path.Visualize `Default: false`|
|:-|
|● *Set to true to visualize waypoints*|

|*`boolean`* Path.IgnoreObstacles `Default: true`|
|:-|
|● *Set to true to recalculate path when the path is blocked*|

#### Methods:
|*`boolean`* Path:Run(*`BasePart/Vector3 goal`*)|
|:-|
|● ***Returns false if pathfinding is not possible, make sure to handle it*** <br> ● *`goal` must by a BasePart or a Vector3 position*|

|*`void`* Path:Stop(*`String status`*)|
|:-|
|● *Stops moving the humanoid* <br> ● *Triggers the `Stopped` event with the given `status`*|
|Note: does not exist for non-humanoid models|

|*`void`* Path:Destroy()|
|:-|

#### Events:
|*`RBXScriptSignal`* Path.Reached(*`Model model`*)|
|:-|
|● *Fires when pathfinding is complete*|

|*`RBXScriptSignal`* Path.Blocked(*`Model model`*)|
|:-|
|● *Fires when there is an obstruction*|
|Note: does not exist for non-humanoid models|

|*`RBXScriptSignal`* Path.Stopped(*`String status`*)|
|:-|
|● *Fires when pathfinding stopped for any reason*|
|Note: does not exist for non-humanoid models|

|*`RBXScriptSignal`* Path.WaypointReached(*`Model model`*, *`Vector3 previousPosition`*, *`Vector3 nextPosition`*)|
|:-|
|● *Fires when the `model` reaches the next waypoint*|
|Note: Logic for non-humanoid models must be done using this event. See examples for more details|



[agentParametersLink]:https://developer.roblox.com/en-us/api-reference/function/PathfindingService/CreatePath
