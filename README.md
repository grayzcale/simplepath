![](https://img.shields.io/badge/Version-1.0-success?style=for-the-badge)

# SimplePath - Pathfinding Module

The SimplePath module gives you the ability to create a pathfinding script quickly in the shortest amount of code; pathfinding is done using [PathfindingService](https://developer.roblox.com/en-us/api-reference/class/PathfindingService) provided by Roblox.
<br>

<details>
<summary>Get SimplePath</summary>
<br>
  
```lua
local SimplePath = require(6744337775)
```
or get it from the [Roblox library](https://www.roblox.com/library/6744337775/SimplePath-Pathfinding-Module)
</details>

## API

#### Constructor:
|*`Path`* SimplePath.new(*`Model model`*, *`[Optional] Dictionary agentParamters`*)|
|:-|
|● *Creates a new Path* <br> ● *`model` must by a Model Instance* <br> ● *Click [here][agentParametersLink] to find out more about `agentParameters`*|

### Path:

#### Methods:
|*`boolean`* Path:Run(*`BasePart/Vector3 goal`*)|
|:-|
|● ***Returns false if pathfinding is not possible*** <br> ● *`goal` must by a BasePart or Vector3*|
|Note: Only for Humanoid models|


[agentParametersLink]:https://developer.roblox.com/en-us/api-reference/function/PathfindingService/CreatePath
