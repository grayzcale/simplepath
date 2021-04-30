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



[agentParametersLink]:https://developer.roblox.com/en-us/api-reference/function/PathfindingService/CreatePath
